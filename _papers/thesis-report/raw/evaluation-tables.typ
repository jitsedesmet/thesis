/*
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
*/

#let insert-data-complete = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [insert data complete by creation date: SGV], [22], [44582068.340000115], [±1.73%],
  [insert data complete by creation date: RAW], [35], [27899513.780000415], [±2.07%],
  [insert data complete all in one file: SGV], [6], [149415739.04000136], [±2.98%],
  [insert data complete all in one file: RAW], [7], [134361192.54999822], [±8.66%],
  [insert data complete own file: SGV], [10], [91851395.35000053], [±2.56%],
  [insert data complete own file: RAW], [13], [76672217.40999986], [±3.07%],
  [insert data complete by creation location: SGV], [23], [43005366.399997436], [±2.20%],
  [insert data complete by creation location: RAW], [35], [28003949.459998112], [±2.53%],
)

#let delete-data-complete = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [delete data complete by creation date: SGV], [5], [177951642.12999925], [±0.53%],
  [delete data complete by creation date: RAW], [14], [67166339.21999979], [±0.55%],
  [delete data complete all in one file: SGV], [3], [298814885.4500032], [±0.94%],
  [delete data complete all in one file: RAW], [8], [119370476.16999887], [±2.83%],
  [delete data complete own file: SGV], [5], [176949144.21000051], [±0.33%],
  [delete data complete own file: RAW], [14], [66844005.420002505], [±0.59%],
  [delete data complete by creation location: SGV], [5], [178498626.96999976], [±0.30%],
  [delete data complete by creation location: RAW], [15], [65565496.53999682], [±0.76%],
)

#let insert-where-tag = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [insert where tag by creation date: SGV], [7], [130209519.73000309], [±0.33%],
  [insert where tag by creation date: RAW], [15], [64915564.9899994], [±1.29%],
  [insert where tag all in one file: SGV], [4], [226277836.13999897], [±2.64%],
  [insert where tag all in one file: RAW], [8], [122255749.08000185], [±2.96%],
  [insert where tag own file: SGV], [7], [129497887.78000394], [±0.75%],
  [insert where tag own file: RAW], [15], [65628874.43000043], [±1.45%],
  [insert where tag by creation location: SGV], [7], [130342417.51999244], [±0.36%],
  [insert where tag by creation location: RAW], [15], [64542496.22000149], [±1.33%],
)

#let insert-data-id = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [insert data id by creation date: SGV], [12], [80325290.78000924], [±0.66%],
  [insert data id by creation date: RAW], [15], [63787431.610004276], [±0.58%],
  [insert data id all in one file: SGV], [5], [184135528.4899927], [±0.71%],
  [insert data id all in one file: RAW], [8], [122780884.01999092], [±2.99%],
  [insert data id own file: SGV], [12], [79745654.40000734], [±0.62%],
  [insert data id own file: RAW], [15], [63785574.410007104], [±0.58%],
  [insert data id by creation location: SGV], [12], [80393959.2699986], [±0.86%],
  [insert data id by creation location: RAW], [15], [63705068.34000349], [±0.66%],
)

#let insert-data-tag = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [insert data tag by creation date: SGV], [5], [178149073.97000468], [±0.70%],
  [insert data tag by creation date: RAW], [15], [63309807.81999533], [±0.45%],
  [insert data tag all in one file: SGV], [3], [289314253.0599935], [±0.77%],
  [insert data tag all in one file: RAW], [8], [123444536.70999967], [±3.48%],
  [insert data tag own file: SGV], [5], [178175593.0599908], [±0.28%],
  [insert data tag own file: RAW], [15], [63045682.489996545], [±0.41%],
  [insert data tag by creation location: SGV], [5], [178955959.07001406], [±0.54%],
  [insert data tag by creation location: RAW], [15], [63363918.37999457], [±0.51%],
)

#let delete-insert-id = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [delete insert id by creation date: SGV], [6], [158251067.13999993], [±0.67%],
  [delete insert id by creation date: RAW], [35], [28025100.910000037], [±1.89%],
  [delete insert id all in one file: SGV], [2], [356617078.5399992], [±2.62%],
  [delete insert id all in one file: RAW], [5], [186824229.88999984], [±10.48%],
  [delete insert id own file: SGV], [5], [199237149.5699999], [±0.42%],
  [delete insert id own file: RAW], [35], [27882776.099978946], [±0.89%],
  [delete insert id by creation location: SGV], [6], [157357139.7299855], [±0.70%],
  [delete insert id by creation location: RAW], [35], [28254209.500013385], [±1.36%],
)

#let delete-where-complete = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [delete where complete by creation date: SGV], [7], [132988158.56000409], [±0.46%],
  [delete where complete by creation date: RAW], [15], [65584642.47000869], [±0.40%],
  [delete where complete all in one file: SGV], [4], [213726655.93998972], [±1.36%],
  [delete where complete all in one file: RAW], [8], [121148118.67999378], [±2.93%],
  [delete where complete own file: SGV], [7], [130769232.5300118], [±0.43%],
  [delete where complete own file: RAW], [14], [69931699.37000842], [±3.13%],
  [delete where complete by creation location: SGV], [7], [130786473.60000758], [±0.62%],
  [delete where complete by creation location: RAW], [15], [66160665.18999869], [±1.28%],
)

#let delete-where-tags = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [delete where tags by creation date: SGV], [7], [128534614.84000319], [±0.59%],
  [delete where tags by creation date: RAW], [15], [64838515.5300051], [±1.26%],
  [delete where tags all in one file: SGV], [4], [217007521.23001266], [±1.88%],
  [delete where tags all in one file: RAW], [8], [115368001.48000708], [±2.43%],
  [delete where tags own file: SGV], [7], [130018987.34001443], [±0.49%],
  [delete where tags own file: RAW], [15], [64744311.01999711], [±1.37%],
  [delete where tags by creation location: SGV], [7], [130569365.74000867], [±0.94%],
  [delete where tags by creation location: RAW], [15], [64453229.869995266], [±1.25%],
)

#let delete-data-id = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [Delete data id by creation date: SGV], [12], [80141498.44999892], [±0.80%],
  [Delete data id by creation date: RAW], [15], [63500094.67000374], [±0.43%],
  [Delete data id all in one file: SGV], [5], [185053673.15999466], [±0.73%],
  [Delete data id all in one file: RAW], [8], [121587804.55], [±2.94%],
  [Delete data id own file: SGV], [12], [79697409.76997884], [±0.60%],
  [Delete data id own file: RAW], [15], [63715705.30998986], [±0.92%],
  [Delete data id by creation location: SGV], [12], [79515830.70000866], [±0.51%],
  [Delete data id by creation location: RAW], [15], [63687341.049988754], [±0.77%],
)

#let delete-data-tag = table(
  columns: (auto, auto, auto, auto),
  table.header(
    [*Task*], [*ops/sec*], [*Average Time (ms)*], [*Margin*],
  ),
  [delete data tag by creation date: SGV], [5], [174155254.35998338], [±0.71%],
  [delete data tag by creation date: RAW], [15], [63248866.6999829], [±0.48%],
  [delete data tag all in one file: SGV], [3], [292456437.1000091], [±1.42%],
  [delete data tag all in one file: RAW], [8], [120948758.07001255], [±3.02%],
  [delete data tag own file: SGV], [5], [176555335.81997967], [±0.61%],
  [delete data tag own file: RAW], [15], [63792069.96001536], [±0.83%],
  [delete data tag by creation location: SGV], [5], [175975652.34998706], [±0.31%],
  [delete data tag by creation location: RAW], [15], [63362320.820009336], [±0.43%],
)