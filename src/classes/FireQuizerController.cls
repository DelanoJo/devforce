public with sharing class FireQuizerController {
    
    public SelectOption[] possibleAnswers {get; set;}
    public SelectOption[] possibleQuizes {get; set;}
    public SelectOption[] possibleSubQuizes {get; set;}
    
    public String selectedQuiz {get;set;}
    public String selectedSubQuiz {get;set;}
    
    public SelectOption[] minStreets {get; set;}
    public SelectOption[] maxStreets {get; set;}
    
    public Decimal minStreet {get;set;}
    public Decimal maxStreet {get;set;}
    
    public String minStreetString {get;set;}
    public String maxStreetString {get;set;}
    
    public integer quizStage {get;set;}
    public integer totalQuestions {get;set;}
    public integer qIndex {get;set;}
    
    public wrapQ[] questionWrap {get;set;}
    
    public Decimal grade {get;set;}
    public integer missed {get;set;}
    public integer correct {get;set;}
    
    //set of integers grabbed from a list of question data
    public Set<Integer> questInts {get;set;}
    
    public Set<String> stringAnSet {get;set;}
    public Set<String> intAnSet {get;set;}
    
    public Question_Data__c[] questions {get;set;}
    
    public FireQuizerController(){
    }

    public void init() {
    
        this.questions = new Question_Data__c[]{};
        
        this.quizStage = 0;
        this.possibleQuizes = new SelectOption[]{};
        this.possibleSubQuizes = new SelectOption[]{};
        this.possibleAnswers = new SelectOption[]{};
        this.minStreets = new SelectOption[]{};
        this.maxStreets = new SelectOption[]{};
        
        this.questionWrap = new wrapQ[]{};
        
        this.possibleQuizes.add(new SelectOption('Station Quizes','Station Quizes'));
        this.possibleQuizes.add(new SelectOption('Broadway East','Broadway East Quizes'));
        this.possibleQuizes.add(new SelectOption('Broadway West','Broadway West Quizes'));
        this.possibleQuizes.add(new SelectOption('Downtown','Downtown Street Quizes'));
        this.possibleQuizes.add(new SelectOption('Ellsworth South','Ellsworth South Quizes'));
        this.possibleQuizes.add(new SelectOption('Building Quizes','Building Quizes'));
        
        this.questInts = new Set<Integer>();
        this.totalQuestions = 0;
        this.qIndex = 0;
        this.correct = 0;
        
        this.minStreet = 0;
        this.maxStreet = 0;
        
        this.minStreetString = '';
        this.maxStreetString = '';
    }
    
    public void incrementQIndex() {
        if (this.totalQuestions > this.qIndex + 1) {
            this.qIndex++;
        }
    }
    
    public void decrementQIndex() {
        if (this.qIndex >= 1) {
            this.qIndex--;
        }
    }
    
    public void back(){
        if(this.quizStage > 0){
            this.quizStage -= 1;
        }
    }
    
    public void next(){
        this.quizStage += 1;
    }
    
    public void reset(){
        this.quizStage =0;
    }
    
    public void goToStage1(){
        next();
        askForSubQuiz();
    }
    
    public void goToStage2(){
        next();
        generateQuiz();
    }
    
    public void goToStage3(){
        next();
        gradeQuiz();
    }
    
    public void gradeQuiz(){
        this.missed = 0;
        for(wrapQ wq : questionWrap){
            /*if(wq.answerString == null){
                this.missed +=1;
            }else{*/
                if((selectedQuiz == 'Broadway East' || selectedQuiz == 'Broadway West' || selectedQuiz == 'Downtown' || selectedQuiz == 'Ellsworth South') && selectedSubQuiz == 'byName'){
                    if(wq.answerString != null){
                        if(wq.answerString != wq.qd.Street_Name__c){
                            this.missed += 1;
                        }
                    }
                    wq.correctString = wq.qd.Street_Name__c;
                }
                if((selectedQuiz == 'Broadway East' || selectedQuiz == 'Broadway West' || selectedQuiz == 'Downtown' || selectedQuiz == 'Ellsworth South') && selectedSubQuiz == 'byNumber'){
                    if(wq.answerString != null){
                        if(integer.valueOf(wq.answerString) != wq.qd.Street_Number__c){
                            this.missed += 1;
                        }
                    }
                    wq.correctString = string.valueOf(wq.qd.Street_Number__c);
                }
                if((this.selectedQuiz == 'Station Quizes' || this.selectedQuiz == 'Building Quizes') && selectedSubQuiz == 'byLocation'){
                    if(wq.answerString != null){
                        if(wq.answerString != wq.qd.Location__c){
                            this.missed += 1;
                        }
                    }
                    wq.correctString = wq.qd.Location__c;
                }
                if(this.selectedQuiz == 'Station Quizes' && selectedSubQuiz == 'byName'){
                    if(wq.answerString != null){
                        if(integer.valueOf(wq.answerString) != wq.qd.Station__c){
                            this.missed += 1;
                        }
                    }
                    wq.correctString = string.valueOf(wq.qd.Station__c);
                }
                if(this.selectedQuiz == 'Station Quizes' && selectedSubQuiz == 'byDistrict'){
                    if(wq.answerString != null){
                        if(integer.valueOf(wq.answerString) != wq.qd.District__c){
                            this.missed += 1;
                        }
                    }
                    wq.correctString = string.valueOf(wq.qd.District__c);
                }
                if(this.selectedQuiz == 'Building Quizes'&& selectedSubQuiz == 'byName'){
                    if(wq.answerString != null){
                        if(wq.answerString != wq.qd.Building__c){
                            this.missed += 1;
                        }
                    }
                    wq.correctString = wq.qd.Building__c;
                }
            //}
            system.debug('$$$ Grade: ' + ((decimal.valueOf(this.totalQuestions) - this.missed)/decimal.valueOf(this.totalQuestions))*100);
        }
        this.correct = this.totalQuestions - this.missed;
        this.grade = ((decimal.valueOf(this.totalQuestions) - this.missed)/decimal.valueOf(this.totalQuestions)*100).setScale(2);
    }
    
    public void askForSubQuiz(){
        if(this.possibleSubQuizes.size() > 0){
            this.possibleSubQuizes.clear();
        }
        if(selectedQuiz == 'Building Quizes'){
            this.possibleSubQuizes.add(new SelectOption('byLocation', 'Quiz Me On the Buildings by Location'));
            this.possibleSubQuizes.add(new SelectOption('byName', 'Quiz Me On the Buildings by Name'));
        }
        if(selectedQuiz == 'Broadway East' || selectedQuiz == 'Broadway West' || selectedQuiz == 'Downtown' || selectedQuiz == 'Ellsworth South'){
            this.possibleSubQuizes.add(new SelectOption('byNumber', 'Quiz Me On the Streets by Number'));
            this.possibleSubQuizes.add(new SelectOption('byName', 'Quiz Me On the Streets by Name'));
                questions = [SELECT Id, Name, Type__c, Building__c, Direction__c, District__c, Location__c, Station__c, Street_Name__c, Street_Number__C
                            FROM Question_Data__c
                            WHERE Type__c = 'Street' AND
                            Direction__c =: selectedQuiz
                            ORDER By Street_Number__c];
                            
            for(Question_Data__c q : questions){
                this.maxStreets.add(new SelectOption(String.valueOf(q.Street_Number__c), String.valueOf(q.Street_Number__c)));
                this.minStreets.add(new SelectOption(String.valueOf(q.Street_Number__c), String.valueOf(q.Street_Number__c)));
            }
        }
        if(selectedQuiz == 'Station Quizes'){
            this.possibleSubQuizes.add(new SelectOption('byLocation', 'Quiz Me On the Stations by Location'));
            this.possibleSubQuizes.add(new SelectOption('byName', 'Quiz Me On the Stations by Number'));
            this.possibleSubQuizes.add(new SelectOption('byDistrict', 'Quiz Me On the Stations by District'));
        }
    }
    
    public void generateQuiz(){
        if(selectedQuiz == 'Broadway East' || selectedQuiz == 'Broadway West' || selectedQuiz == 'Downtown' || selectedQuiz == 'Ellsworth South'){
            this.minStreet = decimal.valueOf(this.minStreetString);
            this.maxStreet = decimal.valueOf(this.maxStreetString);
        }
        
        if(this.selectedQuiz == 'Station Quizes' && this.selectedSubQuiz == 'byName'){
            questions = [SELECT Id, Name, Type__c, Building__c, Direction__c, District__c, Location__c, Station__c, Street_Name__c, Street_Number__C
                        FROM Question_Data__c
                        WHERE Type__c = 'Station'
                        ORDER By Station__c];
        }
        if(this.selectedQuiz == 'Station Quizes' && this.selectedSubQuiz == 'byDistrict'){
            questions = [SELECT Id, Name, Type__c, Building__c, Direction__c, District__c, Location__c, Station__c, Street_Name__c, Street_Number__C
                        FROM Question_Data__c
                        WHERE Type__c = 'Station'
                        ORDER By District__c];
        }
        if(this.selectedQuiz == 'Station Quizes' && this.selectedSubQuiz == 'byLocation'){
            questions = [SELECT Id, Name, Type__c, Building__c, Direction__c, District__c, Location__c, Station__c, Street_Name__c, Street_Number__C
                        FROM Question_Data__c
                        WHERE Type__c = 'Station'
                        ORDER By Location__c];
        }
        if(this.selectedQuiz == 'Building Quizes'){
            questions = [SELECT Id, Name, Type__c, Building__c, Direction__c, District__c, Location__c, Station__c, Street_Name__c, Street_Number__C
                        FROM Question_Data__c
                        WHERE Type__c = 'Building'];
        }
        if(this.selectedQuiz == 'Broadway East'){
            questions = [SELECT Id, Name, Type__c, Building__c, Direction__c, District__c, Location__c, Station__c, Street_Name__c, Street_Number__C
                        FROM Question_Data__c
                        WHERE Type__c = 'Street' AND
                        Direction__c = 'Broadway East'
                        AND Street_Number__c >=: this.minStreet
                        AND Street_Number__c <=: this.maxStreet
                        ORDER By Street_Number__c];
        }
        if(this.selectedQuiz == 'Broadway West'){
            questions = [SELECT Id, Name, Type__c, Building__c, Direction__c, District__c, Location__c, Station__c, Street_Name__c, Street_Number__C
                        FROM Question_Data__c
                        WHERE Type__c = 'Street' AND
                        Direction__c = 'Broadway West'
                        AND Street_Number__c >=: this.minStreet
                        AND Street_Number__c <=: this.maxStreet
                        ORDER By Street_Number__c];
        }
        if(this.selectedQuiz == 'Downtown'){
            questions = [SELECT Id, Name, Type__c, Building__c, Direction__c, District__c, Location__c, Station__c, Street_Name__c, Street_Number__C
                        FROM Question_Data__c
                        WHERE Type__c = 'Street' AND
                        Direction__c = 'Downtown'
                        AND Street_Number__c >=: this.minStreet
                        AND Street_Number__c <=: this.maxStreet
                        ORDER By Street_Number__c];
        }
        if(this.selectedQuiz == 'Ellsworth South'){
            questions = [SELECT Id, Name, Type__c, Building__c, Direction__c, District__c, Location__c, Station__c, Street_Name__c, Street_Number__C
                        FROM Question_Data__c
                        WHERE Type__c = 'Street' AND
                        Direction__c = 'Ellsworth South'
                        AND Street_Number__c >=: this.minStreet
                        AND Street_Number__c <=: this.maxStreet
                        ORDER By Street_Number__c];
        }
        if(this.questions.size() > 0){
            for(Integer g = 0; g < this.questions.size(); g++){
                Question_Data__c q = new Question_Data__c();
                Integer i = getRandomInt(this.questions.size());
                Boolean isUsed = intUsed(i);
                if(isUsed == true){
                    while(isUsed == true){
                        i = getRandomInt(this.questions.size());
                        isUsed = intUsed(i);
                    }
                }
                q = this.questions[i];
                wrapQ wq = new wrapQ();
                wq.pAnswers = new SelectOption[]{};
                wq.answerString = '';
                wq.correctString = '';
                wq.correctInteger = -1;
                wq.qd = q;
                //String[] ans = new String[]{};
                for(Integer n = 0; n<4 ;n++){
                    Integer e = getRandomInt(this.questions.size());
                    wq.pAnswers.add(new SelectOption(pAnswergen(e),pAnswergen(e)));
                }
                Integer p = getRandomInt(4);
                wq.pAnswers[p] = new SelectOption(pAnswergen(i),pAnswergen(i));
                questionWrap.add(wq);
                questInts.add(i);
            }
            this.totalQuestions = questionWrap.size();
            generateAnswers();
        }
        
        system.debug('$$$ questionwrap: ' + questionWrap);
    }
    
    public String pAnswergen(Integer g){
        String s = '';
        if((selectedQuiz == 'Broadway East' || selectedQuiz == 'Broadway West' || selectedQuiz == 'Downtown' || selectedQuiz == 'Ellsworth South') && selectedSubQuiz == 'byName'){
            s=this.questions[g].Street_Name__c;
        }
        if((selectedQuiz == 'Broadway East' || selectedQuiz == 'Broadway West' || selectedQuiz == 'Downtown' || selectedQuiz == 'Ellsworth South') && selectedSubQuiz == 'byNumber'){
            s=string.valueOf(this.questions[g].Street_Number__c);
        }
        if((this.selectedQuiz == 'Station Quizes' || this.selectedQuiz == 'Building Quizes') && selectedSubQuiz == 'byLocation'){
            s=this.questions[g].Location__c;
        }
        if(this.selectedQuiz == 'Station Quizes' && selectedSubQuiz == 'byName'){
            s= string.valueOf(this.questions[g].Station__c);
        }
        if(this.selectedQuiz == 'Station Quizes' && selectedSubQuiz == 'byDistrict'){
            /*if(dist != this.questions[g].District__c){
                dist = this.questions[g].District__c;*/
                s= string.valueOf(this.questions[g].District__c);
            //}
        }
        if(this.selectedQuiz == 'Building Quizes'&& selectedSubQuiz == 'byName'){
            s=this.questions[g].Building__c;
        }
        
        return s;
    }
    
    public void generateAnswers(){
        questInts.clear();
        Decimal dist = 0;
        for(Integer g = 0; g < this.questions.size(); g++){
            Integer i = getRandomInt(this.questions.size());
            Boolean isUsed = intUsed(i);
            if(isUsed == true){
                while(isUsed == true){
                    i = getRandomInt(this.questions.size());
                    isUsed = intUsed(i);
                }
            }
            if((selectedQuiz == 'Broadway East' || selectedQuiz == 'Broadway West' || selectedQuiz == 'Downtown' || selectedQuiz == 'Ellsworth South') && selectedSubQuiz == 'byName'){
                possibleAnswers.add(new SelectOption(this.questions[g].Street_Name__c,this.questions[g].Street_Name__c));
            }
            if((selectedQuiz == 'Broadway East' || selectedQuiz == 'Broadway West' || selectedQuiz == 'Downtown' || selectedQuiz == 'Ellsworth South') && selectedSubQuiz == 'byNumber'){
                possibleAnswers.add(new SelectOption(string.valueOf(this.questions[g].Street_Number__c),string.valueOf(this.questions[g].Street_Number__c)));
            }
            if((this.selectedQuiz == 'Station Quizes' || this.selectedQuiz == 'Building Quizes') && selectedSubQuiz == 'byLocation'){
                possibleAnswers.add(new SelectOption(this.questions[g].Location__c,this.questions[g].Location__c));
            }
            if(this.selectedQuiz == 'Station Quizes' && selectedSubQuiz == 'byName'){
                possibleAnswers.add(new SelectOption(string.valueOf(this.questions[g].Station__c),string.valueOf(this.questions[g].Station__c)));
            }
            if(this.selectedQuiz == 'Station Quizes' && selectedSubQuiz == 'byDistrict'){
                if(dist != this.questions[g].District__c){
                    dist = this.questions[g].District__c;
                    possibleAnswers.add(new SelectOption(string.valueOf(this.questions[g].District__c),string.valueOf(this.questions[g].District__c)));
                }
            }
            if(this.selectedQuiz == 'Building Quizes'&& selectedSubQuiz == 'byName'){
                possibleAnswers.add(new SelectOption(this.questions[g].Building__c,this.questions[g].Building__c));
            }
            questInts.add(i);
        }
    }
    
    public Boolean intUsed(Integer i){
    
        Boolean isUsed;
        if(this.questInts.contains(i)){
            isUsed = true;
        }else{
            isUsed = false;
        }
        return isUsed;
    }

    public static Integer getRandomInt (Integer qsize)
    {
        Double random = math.random();
        decimal randomQ = random*qsize;
        Integer toGetRandom = integer.valueOf(math.rint(randomQ));
        if(toGetRandom == qSize){
            toGetRandom = toGetRandom - 1;
        }
        return toGetRandom;
    }
    
    class wrapQ{
        public Question_Data__c qd {get;set;}
        public String answerString {get;set;}
        public Integer answerInt {get;set;}
        
        public String correctString{get;set;}
        public Decimal correctInteger{get;set;}
        public SelectOption[] pAnswers {get; set;}
    }

}