import pandas as pd

file_path = 'sst_stats.csv'  # Replace with your CSV file path

# Read the CSV into a DataFrame
df = pd.read_csv(file_path)

# req_latency
req_latency = (df[df['StatisticName'] == 'req_latency'])
req_latency_row = df[df['StatisticName'] == 'req_latency'].index[0]
sum_req_latency = df.loc[req_latency_row, 'Sum.u64']
count_req_latency = df.loc[req_latency_row, 'Count.u64']
avg_req_latency = round(sum_req_latency / count_req_latency, 2)
# print(avg_req_latency)

# cache
cache = (df[df['ComponentName'] == 'cache'])
cache_hit = (cache[cache['StatisticName'] == 'CacheHits'])['Sum.u64'].iloc[0]
cache_miss = (cache[cache['StatisticName'] == 'CacheMisses'])['Sum.u64'].iloc[0]
# print(cache_hit)
# print(cache_miss)
# print(cache_hit / (cache_hit + cache_miss))

# Max Requests per CPU Cycle
core = (df[df['ComponentName'] == 'core'])
requests = core[
    (core['StatisticName'] == 'read_reqs') |
    (core['StatisticName'] == 'write_reqs')
]
request_total = sum(requests['Count.u64'].tolist())
cycles = core[(core['StatisticName'] == 'cycles')]['Count.u64'].iloc[0]
# print(round(request_total / cycles,2))


memory = (df[df['ComponentName'] == 'memory'])

# Average Latency
latency = memory[memory['StatisticName'].str.contains(r'latency', regex=True)]
latency_sum = sum(latency['Sum.u64'].tolist())
latency_count = sum(latency['Count.u64'].tolist())
# print(round(latency_sum / latency_count, 2))

# Average Outstanding Requests
outstanding_requests = memory[memory['StatisticName'] == 'outstanding_requests']
outstanding_requests_sum = outstanding_requests['Sum.u64'].iloc[0]
outstanding_requests_count = outstanding_requests['Count.u64'].iloc[0]
print(round(outstanding_requests_sum / outstanding_requests_count, 2))


# print(df)