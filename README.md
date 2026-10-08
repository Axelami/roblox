# Energy Simulator

En Roblox-prototyp: samla energi, sälj för mynt och uppgradera verktyg och ryggsäck. Servern hanterar ekonomin och begränsar insamling till fem klick per sekund. Progressionen återställs när spelaren lämnar servern; ingen DataStore eller monetisering är aktiverad.

## Bygg

```sh
cd /workspace/roblox
/workspace/tools/rojo build default.project.json -o build/EnergySimulator.rbxlx
```

Öppna `build/EnergySimulator.rbxlx` i Roblox Studio på Windows eller macOS och tryck Play. För löpande synkronisering: installera Rojo-pluginet i Studio och kör `/workspace/tools/rojo serve default.project.json`.

## Speltest i Studio

1. Klicka SAMLA ENERGI 25 gånger; energi ska stanna vid 25.
2. Gå till gula säljstationen och använd prompten: energi blir 0 och mynt blir 25.
3. Köp ett verktyg vid blå stationen: mynt blir 0, energi per klick blir 2.
4. Samla och sälj tills du har 50 mynt; köp ryggsäcken vid lila stationen. Kapaciteten blir 50.
5. Testa med två spelare: ekonomin ska vara separat. Testa också pekskärmens knappar i emulatorn.

Molnmiljön kan bygga placefilen men kan inte köra Roblox Studio. Publicera från Studio med File → Publish to Roblox efter speltest.
