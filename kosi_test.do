clear all
cls

sysuse auto
kosi price | weight | | gear length , verbose
kosi price | weight || gear length , verbose
kosi price | | weight , verbose
kosi ||| , verbose
kosi | price , verbose
