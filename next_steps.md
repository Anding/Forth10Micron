Forth10Micron next steps
===

1. Develop mount control words for model creation

2. Add VT100 output and diagnostics

3. Define GOTO etc. at ForthTelescopeMount.f level rather than higher up, as add VT100 diagnostics

4. Integrate JNOW <> J2000 conversions into mount control so that the FITS and GOTO commands all work in J2000 while the mount exchanges JNOW