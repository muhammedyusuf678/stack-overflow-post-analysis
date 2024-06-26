# mcis-stack-overflow-post-analysis

## Dataset

Existing datasets on kaggle were limited interms of data metrics, so for this analysis the Public BigQuery Stack Overflow dump was directly queried and a new dataset created. The tags analyzed are "reactjs" and "angular" which are 2 of the most popular Javascript frontend web development technologies. The time period sampled is from '2021-01-01' to '2021-06-30'.

## Data Processing Approach

To minimize use of cloud computing resources, the bigquery sql statements query both analysis tags in each statement and generate 2 files labelled with "bigquery" (one for question posts and the other for answer posts). These files are preprocessed to produce separate dataframes for each tag with only selected metrics. These are exported for reference and labelled with "analysis_dataset"). The bigquery statements perform joins on the public dataset tables, filter posts and add new columns. The final statements executed on the GCP console are included in the repository.

## Setup

Install packages listed on requirements.txt. The dataset files were too large to push to github and are available at the following URL:
https://drive.google.com/file/d/16GmCDUXVhRtzGS6xXZ7onkSEDrqq91BS/view?usp=sharing
Ensure the dataset files are saved to the same directory as the script. Additionally only the "bigquery" files are consumed by the scripts whereas the "analysis_dataset" files are generated by it as an output.

## Script/Notebook Organization

The notebook is organized into sections.
In particular for the distribution analysis, the 1st metric analysis presents each step one-by-one however subsequent metric analyses call higher order functions.
For each metric analysis, the metric distribution for a particular tag is visualized, analyzed and tested separately first and observations noted before making a comparison

## Metrics

- Stack overflow score: Number of upvotes - number of downvotes. The metric is indicative of a posts quality, relevance, usefulness, importance, etc. as percieved and inputted by users.
- answer_count: Number of answers to a particular question post. Indicative of engagement and contribution volume pertaining to a question.
- comment_count: Number of comments on a question or answer post. Also indicative of engagement and contribution volume pertaining to posts in general (questions and answers).
- view_count: Number of views of a particular question (this data is unavailable for answer posts as they are always viewed in tandem with the question on the same page). A useful metric throughout the internet for tracking user engagement. Unbiased indicator of popularity of questions unlike score which requires user input and depends on user perceptions.
- time_to_accepted_answer: Generated metric, amount of time (in hours) between question creation and accepted answer creation. Only applies to questions whose original posters marked an answer as the accepted answer. Indicative of "activeness" of the community and volume of helpful contributors.

## Analyses Used

After some exploratory data analysis, histograms with kde plots (seaborn distplots) are generated to visualize data distribution for each metric and each tag individually before plotting the distributions together for comparison.

Outliers were observed to add significant noise to the data plots and were removed.
The Kolmogorov Smirnov Test is used to verify the normality (or lack thereof) of the observed data distributions.
The Mann-Whitney U Hypothesis test is used to verify the statistical significance of the difference between 2 distributions of the same metric (if any).

Additional Analysis:
In addition to metric distribution analysis, the correlations between the metric were also analyzed by computing and visualizing the pearsons correlation coefficient.

## Results of Analysis

The distribution analysis revealed some interesting insights on the behavior of contributors in both tag communities:
Score:

- Angular posts have a significantly higher density of having 0 score whereas react posts have higher densities of higher scores; more react posts have higher scores than angular posts.
- Majority of posts regardless of community had an overall score of 0 (not much traction)
- In particular, the density of answer posts for scores +1 and -1 have identical probability density for both tags

Answer_Count:

- Angular has a significantly higher density of questions with no answer. React has higher density of answer_counts of 1+ on questions; more react posts tend to have more answers than angular posts.
- Majority of posts regardless of community had just 1 answer

Comment_Count:

- For both tags, questions and answers alike have a larger range of comment_count (within outlier threshold) as compared to the answer_count metric
- The probability density of angular for having 0 comments on posts is significantly higher than react, whereas react is >= angular for 1 or higher comment_count
- The probability density of reactjs questions having 1 or 2 comments are nearly identical; there appears to be significantly more comment engagement in the react community as compared to angular
- Majority of posts regardless of community had no comments (not much traction)

View_count:

- For lower view_counts, angular questions have a higher density of questions however for higher ones (~>400 view_count), react's posts have a higher density; more of reacts posts have a higher view_count as compared to angulars posts.
- Majority of react questions have the lowest "bin" of view_count, the distribution is right-skewed
- Majority of angular questions have a "middle bin" of view_count, the distribution is also right-skewed but less so than react

Time_To_Accepted_Answer:

- For questions which have accepted answers for both tags, highest density and frequency count puts the time to accepted answer creation to be within 1 hour of posting the question
- For questions with accepted answers created within 1 hour, react is significantly more dense than angular however for all subsequent hours values angular is more dense; angular questions appear to take longer for the accepted answer to be created
- For majority of react questions (without outliers), the range of time values is from 0 to ~ 7.5 hours (~ 1 work shift)
- For majority of angular questions (without outliers), the range is from 0 to ~ 25 hours (~ 1 full day)

Correlation analysis:

- Overall stronger positive correlations are observed across all metrics in react over angular. Particularly, the score of a post of react has a stronger impact on its view_count than in angular.
- For both technologies, the strongest positive correlation is between (score, view_count) followed by (answer_count, view_count)

## Possible Future Work

- Configuring a service account on GCP so that dataset generation can happen via a script rather than using the GCP console
- Further testing data distributions against other hypothesized distributions and finding a best fit
- NLP techniques to analyze textual content of questions and answers (removing stop words for post text, text lemmatization, word frequency distributions and topic modelling)
- Additional metrics like: time_to_first_answer_creation, time_to_highest_score_answer_creation
