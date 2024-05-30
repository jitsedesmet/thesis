/*
Using same query
┌─────────┬──────────────────────────────────────────────┬─────────┬────────────────────┬──────────┬─────────┐
│ (index) │ Task Name                                    │ ops/sec │ Average Time (ns)  │ Margin   │ Samples │
├─────────┼──────────────────────────────────────────────┼─────────┼────────────────────┼──────────┼─────────┤
│ 0       │ 'delete insert id by creation date: SGV'     │ '7'     │ 139087340.65000007 │ '±0.92%' │ 100     │
│ 1       │ 'delete insert id by creation date: RAW'     │ '31'    │ 31506357.520000163 │ '±3.26%' │ 100     │
│ 2       │ 'delete insert id all in one file: SGV'      │ '2'     │ 337700179.4699989  │ '±1.60%' │ 100     │
│ 3       │ 'delete insert id all in one file: RAW'      │ '5'     │ 168110947.49000025 │ '±5.88%' │ 100     │
│ 4       │ 'delete insert id own file: SGV'             │ '5'     │ 180586969.8300003  │ '±0.45%' │ 100     │
│ 5       │ 'delete insert id own file: RAW'             │ '32'    │ 30525821.86000043  │ '±2.80%' │ 100     │
│ 6       │ 'delete insert id by creation location: SGV' │ '7'     │ 135774830.83999717 │ '±0.78%' │ 100     │
│ 7       │ 'delete insert id by creation location: RAW' │ '32'    │ 30422259.46000166  │ '±3.14%' │ 100     │
└─────────┴──────────────────────────────────────────────┴─────────┴────────────────────┴──────────┴─────────┘

Same behaviour
┌─────────┬──────────────────────────────────────────────┬─────────┬────────────────────┬──────────┬─────────┐
│ (index) │ Task Name                                    │ ops/sec │ Average Time (ns)  │ Margin   │ Samples │
├─────────┼──────────────────────────────────────────────┼─────────┼────────────────────┼──────────┼─────────┤
│ 0       │ 'delete insert id by creation date: SGV'     │ '7'     │ 141940530.71999988 │ '±1.28%' │ 100     │
│ 1       │ 'delete insert id by creation date: RAW'     │ '11'    │ 87113119.69999988  │ '±0.75%' │ 100     │
│ 2       │ 'delete insert id all in one file: SGV'      │ '2'     │ 343690220.7800002  │ '±1.70%' │ 100     │
│ 3       │ 'delete insert id all in one file: RAW'      │ '4'     │ 208930211.3800001  │ '±2.04%' │ 100     │
│ 4       │ 'delete insert id own file: SGV'             │ '5'     │ 177991908.57000008 │ '±0.58%' │ 100     │
│ 5       │ 'delete insert id own file: RAW'             │ '12'    │ 80729940.5800007   │ '±1.06%' │ 100     │
│ 6       │ 'delete insert id by creation location: SGV' │ '7'     │ 133052120.67000103 │ '±0.60%' │ 100     │
│ 7       │ 'delete insert id by creation location: RAW' │ '12'    │ 81066196.45000145  │ '±1.15%' │ 100     │
└─────────┴──────────────────────────────────────────────┴─────────┴────────────────────┴──────────┴─────────┘
*/

#let insert-data-complete = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [insert data complete by creation date: SGV], [22], [44582.068], [±1.73%],
  [insert data complete by creation date: RAW], [35], [27899.513], [±2.07%],
  [insert data complete all in one file: SGV], [6], [149415.739], [±2.98%],
  [insert data complete all in one file: RAW], [7], [134361.192], [±8.66%],
  [insert data complete own file: SGV], [10], [91851.395], [±2.56%],
  [insert data complete own file: RAW], [13], [76672.217], [±3.07%],
  [insert data complete by creation location: SGV], [23], [43005.366], [±2.20%],
  [insert data complete by creation location: RAW], [35], [28003.949], [±2.53%],
)

#let delete-data-complete = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [delete data complete by creation date: SGV], [5], [177951.642], [±0.53%],
  [delete data complete by creation date: RAW], [14], [67166.339], [±0.55%],
  [delete data complete all in one file: SGV], [3], [298814.885], [±0.94%],
  [delete data complete all in one file: RAW], [8], [119370.476], [±2.83%],
  [delete data complete own file: SGV], [5], [176949.144], [±0.33%],
  [delete data complete own file: RAW], [14], [66844.005], [±0.59%],
  [delete data complete by creation location: SGV], [5], [178498.626], [±0.30%],
  [delete data complete by creation location: RAW], [15], [65565.496], [±0.76%],
)

#let insert-where-tag = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [insert where tag by creation date: SGV], [7], [130209.519], [±0.33%],
  [insert where tag by creation date: RAW], [15], [64915.564], [±1.29%],
  [insert where tag all in one file: SGV], [4], [226277.836], [±2.64%],
  [insert where tag all in one file: RAW], [8], [122255.749], [±2.96%],
  [insert where tag own file: SGV], [7], [129497.887], [±0.75%],
  [insert where tag own file: RAW], [15], [65628.874], [±1.45%],
  [insert where tag by creation location: SGV], [7], [130342.417], [±0.36%],
  [insert where tag by creation location: RAW], [15], [64542.496], [±1.33%],
)

#let insert-data-id = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [insert data id by creation date: SGV], [12], [80325.290], [±0.66%],
  [insert data id by creation date: RAW], [15], [63787.431], [±0.58%],
  [insert data id all in one file: SGV], [5], [184135.528], [±0.71%],
  [insert data id all in one file: RAW], [8], [122780.884], [±2.99%],
  [insert data id own file: SGV], [12], [79745.654], [±0.62%],
  [insert data id own file: RAW], [15], [63785.574], [±0.58%],
  [insert data id by creation location: SGV], [12], [80393.959], [±0.86%],
  [insert data id by creation location: RAW], [15], [63705.068], [±0.66%],
)

#let insert-data-tag = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [insert data tag by creation date: SGV], [5], [178149.073], [±0.70%],
  [insert data tag by creation date: RAW], [15], [63309.807], [±0.45%],
  [insert data tag all in one file: SGV], [3], [289314.253], [±0.77%],
  [insert data tag all in one file: RAW], [8], [123444.536], [±3.48%],
  [insert data tag own file: SGV], [5], [178175.593], [±0.28%],
  [insert data tag own file: RAW], [15], [63045.682], [±0.41%],
  [insert data tag by creation location: SGV], [5], [178955.959], [±0.54%],
  [insert data tag by creation location: RAW], [15], [63363.918], [±0.51%],
)

#let delete-insert-id = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [delete insert id by creation date: SGV], [7], [141940.530], [±1.28%],
  [delete insert id by creation date: RAW], [11], [87113.119], [±0.75%],
  [delete insert id all in one file: SGV], [2], [343690.220], [±1.70%],
  [delete insert id all in one file: RAW], [4], [208930.211], [±2.04%],
  [delete insert id own file: SGV], [5], [177991.908], [±0.58%],
  [delete insert id own file: RAW], [12], [80729.940], [±1.06%],
  [delete insert id by creation location: SGV], [7], [133052.120], [±0.60%],
  [delete insert id by creation location: RAW], [12], [81066.196], [±1.15%],
)

#let delete-where-complete = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [delete where complete by creation date: SGV], [7], [132988.158], [±0.46%],
  [delete where complete by creation date: RAW], [15], [65584.642], [±0.40%],
  [delete where complete all in one file: SGV], [4], [213726.655], [±1.36%],
  [delete where complete all in one file: RAW], [8], [121148.118], [±2.93%],
  [delete where complete own file: SGV], [7], [130769.232], [±0.43%],
  [delete where complete own file: RAW], [14], [69931.699], [±3.13%],
  [delete where complete by creation location: SGV], [7], [130786.473], [±0.62%],
  [delete where complete by creation location: RAW], [15], [66160.665], [±1.28%],
)

#let delete-where-tags = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [delete where tags by creation date: SGV], [7], [128534.614], [±0.59%],
  [delete where tags by creation date: RAW], [15], [64838.515], [±1.26%],
  [delete where tags all in one file: SGV], [4], [217007.521], [±1.88%],
  [delete where tags all in one file: RAW], [8], [115368.001], [±2.43%],
  [delete where tags own file: SGV], [7], [130018.987], [±0.49%],
  [delete where tags own file: RAW], [15], [64744.311], [±1.37%],
  [delete where tags by creation location: SGV], [7], [130569.365], [±0.94%],
  [delete where tags by creation location: RAW], [15], [64453.229], [±1.25%],
)

#let delete-data-id = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [Delete data id by creation date: SGV], [12], [80141.498], [±0.80%],
  [Delete data id by creation date: RAW], [15], [63500.094], [±0.43%],
  [Delete data id all in one file: SGV], [5], [185053.673], [±0.73%],
  [Delete data id all in one file: RAW], [8], [121587.804], [±2.94%],
  [Delete data id own file: SGV], [12], [79697.409], [±0.60%],
  [Delete data id own file: RAW], [15], [63715.705], [±0.92%],
  [Delete data id by creation location: SGV], [12], [79515.830], [±0.51%],
  [Delete data id by creation location: RAW], [15], [63687.341], [±0.77%],
)

#let delete-data-tag = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [delete data tag by creation date: SGV], [5], [174155.254], [±0.71%],
  [delete data tag by creation date: RAW], [15], [63248.866], [±0.48%],
  [delete data tag all in one file: SGV], [3], [292456.437], [±1.42%],
  [delete data tag all in one file: RAW], [8], [120948.758], [±3.02%],
  [delete data tag own file: SGV], [5], [176555.335], [±0.61%],
  [delete data tag own file: RAW], [15], [63792.069], [±0.83%],
  [delete data tag by creation location: SGV], [5], [175975.652], [±0.31%],
  [delete data tag by creation location: RAW], [15], [63362.320], [±0.43%],
)