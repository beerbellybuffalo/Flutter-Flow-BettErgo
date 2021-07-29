// This page includes all the functions that draws information from relevant
// columns in Table 3 to Graph in today_widget.dart

// Different Graph:
//  1. Outer Ring
//      - Good Sitting Time / Total Sitting Time. Plot
//  2. Inner Ring
//      - Total Sitting Time / 24hrs
//        ( turns yellow if(Total Sitting Time > 7hrs)
//        ( turns red if(Total Sitting Time > 9hrs)
//  3. Total Sitting Time
//      - Add number of rows where pos != null = number of minutes
//  4. Good Sitting Time
//      - Add the 'G' values
//  5. Position Change Frequency
//      - iterate down the list and check the number of times the position is
//      changed. if (i != i+1 && i+1 != null ){add to counter}

//  6. Apple Graph
//      - identify 3 factors from each position
//          e.g. legs_down_ls = [2,4,5,6];
//        (24hrs/day * 4 readings/hr = 96 data)
//        create 3 lists for each factor and 1 for total time sitting in that hour
//         with 24 spaces for each hour
//      1 iterate through list,
//      2 for each hour and add to each list in the right hour,
//         i.e. 1400-1459, # of counts in Pos 1(Legs down, Back down, Center leaning)
//              add to ls[14]

//  7. Posture Timing in Mins
//  8. Top 3 Positions in Mins (Jo Wee's illustrations)
//  9. Comparison with Yesterday

// Global Variable to use:
//  bool isSitting = false; // if( visualisationdata.Position ) == null

