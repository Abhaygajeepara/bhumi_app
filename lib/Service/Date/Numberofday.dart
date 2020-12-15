class NumberOfDay{

  int totalDays(int year,int month){
    int index = month - 1;
    List<int> monthLength = List(12);
    monthLength[0] = 31;
    year % 4 == 0? monthLength[1]=29:monthLength[1]= 28;
    monthLength[2] = 31;
    monthLength[4] = 31;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[9] = 31;
    monthLength[11] = 31;
    monthLength[3] = 30;
    monthLength[8] = 30;
    monthLength[5] = 30;
    monthLength[10] = 30;
    print(monthLength[index]);
    return monthLength[index];
  }

  
}