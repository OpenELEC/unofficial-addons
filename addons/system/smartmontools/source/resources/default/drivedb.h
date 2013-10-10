/*
 * drivedb.h - smartmontools drive database file
 *
 * Home page of code is: http://smartmontools.sourceforge.net
 *
 * Copyright (C) 2003-11 Philip Williams, Bruce Allen
 * Copyright (C) 2008-13 Christian Franke <smartmontools-support@lists.sourceforge.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * You should have received a copy of the GNU General Public License
 * (for example COPYING); If not, see <http://www.gnu.org/licenses/>.
 *
 */

/*
 * Structure used to store drive database entries:
 *
 * struct drive_settings {
 *   const char * modelfamily;
 *   const char * modelregexp;
 *   const char * firmwareregexp;
 *   const char * warningmsg;
 *   const char * presets;
 * };
 *
 * The elements are used in the following ways:
 *
 *  modelfamily     Informal string about the model family/series of a
 *                  device. Set to "" if no info (apart from device id)
 *                  known.  The entry is ignored if this string starts with
 *                  a dollar sign.  Must not start with "USB:", see below.
 *  modelregexp     POSIX extended regular expression to match the model of
 *                  a device.  This should never be "".
 *  firmwareregexp  POSIX extended regular expression to match a devices's
 *                  firmware.  This is optional and should be "" if it is not
 *                  to be used.  If it is nonempty then it will be used to
 *                  narrow the set of devices matched by modelregexp.
 *  warningmsg      A message that may be displayed for matching drives.  For
 *                  example, to inform the user that they may need to apply a
 *                  firmware patch.
 *  presets         String with vendor-specific attribute ('-v') and firmware
 *                  bug fix ('-F') options.  Same syntax as in smartctl command
 *                  line.  The user's own settings override these.
 *
 * The regular expressions for drive model and firmware must match the full
 * string.  The effect of "^FULLSTRING$" is identical to "FULLSTRING".
 * The form ".*SUBSTRING.*" can be used if substring match is desired.
 *
 * The table will be searched from the start to end or until the first match,
 * so the order in the table is important for distinct entries that could match
 * the same drive.
 *
 *
 * Format for USB ID entries:
 *
 *  modelfamily     String with format "USB: DEVICE; BRIDGE" where
 *                  DEVICE is the name of the device and BRIDGE is
 *                  the name of the USB bridge.  Both may be empty
 *                  if no info known.
 *  modelregexp     POSIX extended regular expression to match the USB
 *                  vendor:product ID in hex notation ("0x1234:0xabcd").
 *                  This should never be "".
 *  firmwareregexp  POSIX extended regular expression to match the USB
 *                  bcdDevice info.  Only compared during search if other
 *                  entries with same USB vendor:product ID exist.
 *  warningmsg      Not used yet.
 *  presets         String with one device type ('-d') option.
 *
 */

/*
const drive_settings builtin_knowndrives[] = {
 */
  { "$Id: drivedb.h 3840 2013-07-25 21:29:08Z chrfranke $",
    "-", "-",
    "This is a dummy entry to hold the SVN-Id of drivedb.h",
    ""
  /* Default settings:
    "-v 1,raw48,Raw_Read_Error_Rate "
    "-v 2,raw48,Throughput_Performance "
    "-v 3,raw16(avg16),Spin_Up_Time "
    "-v 4,raw48,Start_Stop_Count "
    "-v 5,raw16(raw16),Reallocated_Sector_Ct "
    "-v 6,raw48,Read_Channel_Margin "             // HDD only
    "-v 7,raw48,Seek_Error_Rate "                 // HDD only
    "-v 8,raw48,Seek_Time_Performance "           // HDD only
    "-v 9,raw24(raw8),Power_On_Hours "
    "-v 10,raw48,Spin_Retry_Count "               // HDD only
    "-v 11,raw48,Calibration_Retry_Count "        // HDD only
    "-v 12,raw48,Power_Cycle_Count "
    "-v 13,raw48,Read_Soft_Error_Rate "
    //  14-174 Unknown_Attribute
    "-v 175,raw48,Program_Fail_Count_Chip "       // SSD only
    "-v 176,raw48,Erase_Fail_Count_Chip "         // SSD only
    "-v 177,raw48,Wear_Leveling_Count "           // SSD only
    "-v 178,raw48,Used_Rsvd_Blk_Cnt_Chip "        // SSD only
    "-v 179,raw48,Used_Rsvd_Blk_Cnt_Tot "         // SSD only
    "-v 180,raw48,Unused_Rsvd_Blk_Cnt_Tot "       // SSD only
    "-v 181,raw48,Program_Fail_Cnt_Total "
    "-v 182,raw48,Erase_Fail_Count_Total "        // SSD only
    "-v 183,raw48,Runtime_Bad_Block "
    "-v 184,raw48,End-to-End_Error "
    //  185-186 Unknown_Attribute
    "-v 187,raw48,Reported_Uncorrect "
    "-v 188,raw48,Command_Timeout "
    "-v 189,raw48,High_Fly_Writes "               // HDD only
    "-v 190,tempminmax,Airflow_Temperature_Cel "
    "-v 191,raw48,G-Sense_Error_Rate "            // HDD only
    "-v 192,raw48,Power-Off_Retract_Count "
    "-v 193,raw48,Load_Cycle_Count "              // HDD only
    "-v 194,tempminmax,Temperature_Celsius "
    "-v 195,raw48,Hardware_ECC_Recovered "
    "-v 196,raw16(raw16),Reallocated_Event_Count "
    "-v 197,raw48,Current_Pending_Sector "
    "-v 198,raw48,Offline_Uncorrectable "
    "-v 199,raw48,UDMA_CRC_Error_Count "
    "-v 200,raw48,Multi_Zone_Error_Rate "         // HDD only
    "-v 201,raw48,Soft_Read_Error_Rate "          // HDD only
    "-v 202,raw48,Data_Address_Mark_Errs "        // HDD only
    "-v 203,raw48,Run_Out_Cancel "
    "-v 204,raw48,Soft_ECC_Correction "
    "-v 205,raw48,Thermal_Asperity_Rate "
    "-v 206,raw48,Flying_Height "                 // HDD only
    "-v 207,raw48,Spin_High_Current "             // HDD only
    "-v 208,raw48,Spin_Buzz "                     // HDD only
    "-v 209,raw48,Offline_Seek_Performnce "       // HDD only
    //  210-219 Unknown_Attribute
    "-v 220,raw48,Disk_Shift "                    // HDD only
    "-v 221,raw48,G-Sense_Error_Rate "            // HDD only
    "-v 222,raw48,Loaded_Hours "                  // HDD only
    "-v 223,raw48,Load_Retry_Count "              // HDD only
    "-v 224,raw48,Load_Friction "                 // HDD only
    "-v 225,raw48,Load_Cycle_Count "              // HDD only
    "-v 226,raw48,Load-in_Time "                  // HDD only
    "-v 227,raw48,Torq-amp_Count "                // HDD only
    "-v 228,raw48,Power-off_Retract_Count "
    //  229 Unknown_Attribute
    "-v 230,raw48,Head_Amplitude "                // HDD only
    "-v 231,raw48,Temperature_Celsius "
    "-v 232,raw48,Available_Reservd_Space "
    "-v 233,raw48,Media_Wearout_Indicator "       // SSD only
    //  234-239 Unknown_Attribute
    "-v 240,raw48,Head_Flying_Hours "             // HDD only
    "-v 241,raw48,Total_LBAs_Written "
    "-v 242,raw48,Total_LBAs_Read "
    //  243-249 Unknown_Attribute
    "-v 250,raw48,Read_Error_Retry_Rate "
    //  251-253 Unknown_Attribute
    "-v 254,raw48,Free_Fall_Sensor "              // HDD only
  */
  },
  { "Apple SSD SM128", // Samsung?
    "APPLE SSD SM128",
    "", "", ""
  },
  { "Apacer SDM4",
    "2GB SATA Flash Drive", // tested with APSDM002G15AN-CT/SFI2101D
    "SFI2101D", "",
    "-v 160,raw48,Initial_Bad_Block_Count "
    "-v 161,raw48,Bad_Block_Count "
    "-v 162,raw48,Spare_Block_Count "
    "-v 163,raw48,Max_Erase_Count "
    "-v 164,raw48,Min_Erase_Count " // could be wrong
    "-v 165,raw48,Average_Erase_Count " // could be wrong
  },
  { "Asus-Phison SSD",
    "ASUS-PHISON SSD",
    "", "", ""
  },
  { "Crucial/Micron RealSSD C300/M500", // Marvell 88SS91xx
    "C300-CTFDDA[AC](064|128|256)MAG|" // Marvell 88SS9174 BJP2, tested with C300-CTFDDAC128MAG/0002,
      // C300-CTFDDAC064MAG/0006
    "Crucial_CT(120|240|480)M500SSD3", // Marvell 88SS9187 BLD2, tested with Crucial_CT120M500SSD3/MU02
    "", "",
  //"-v 1,raw48,Raw_Read_Error_Rate "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 170,raw48,Grown_Failing_Block_Ct "
    "-v 171,raw48,Program_Fail_Count "
    "-v 172,raw48,Erase_Fail_Count "
    "-v 173,raw48,Wear_Leveling_Count "
    "-v 174,raw48,Unexpect_Power_Loss_Ct "
    "-v 181,raw16,Non4k_Aligned_Access "
    "-v 183,raw48,SATA_Iface_Downshift "
  //"-v 184,raw48,End-to-End_Error "
  //"-v 187,raw48,Reported_Uncorrect "
  //"-v 188,raw48,Command_Timeout "
    "-v 189,raw48,Factory_Bad_Block_Ct "
  //"-v 194,tempminmax,Temperature_Celsius "
  //"-v 195,raw48,Hardware_ECC_Recovered "
  //"-v 196,raw16(raw16),Reallocated_Event_Count "
  //"-v 197,raw48,Current_Pending_Sector "
  //"-v 198,raw48,Offline_Uncorrectable "
  //"-v 199,raw48,UDMA_CRC_Error_Count "
    "-v 202,raw48,Perc_Rated_Life_Used "
    "-v 206,raw48,Write_Error_Rate"
  },
  { "Crucial/Micron RealSSD m4/C400/P400", // Marvell 9176, fixed firmware
    "C400-MTFDDA[ACK](064|128|256|512)MAM|"
    "M4-CT(064|128|256|512)M4SSD[23]|" // tested with M4-CT512M4SSD2/0309
    "MTFDDAK(064|128|256|512|050|100|200|400)MA[RN]-1[JKS]1AA.*", // tested with
                                             // MTFDDAK256MAR-1K1AA/MA52
    "030[9-Z]|03[1-Z].|0[4-Z]..|[1-Z]....*", // >= "0309"
    "",
  //"-v 1,raw48,Raw_Read_Error_Rate "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 170,raw48,Grown_Failing_Block_Ct "
    "-v 171,raw48,Program_Fail_Count "
    "-v 172,raw48,Erase_Fail_Count "
    "-v 173,raw48,Wear_Leveling_Count "
    "-v 174,raw48,Unexpect_Power_Loss_Ct "
    "-v 181,raw16,Non4k_Aligned_Access "
    "-v 183,raw48,SATA_Iface_Downshift "
  //"-v 184,raw48,End-to-End_Error "
  //"-v 187,raw48,Reported_Uncorrect "
  //"-v 188,raw48,Command_Timeout "
    "-v 189,raw48,Factory_Bad_Block_Ct "
  //"-v 194,tempminmax,Temperature_Celsius "
  //"-v 195,raw48,Hardware_ECC_Recovered "
  //"-v 196,raw16(raw16),Reallocated_Event_Count "
  //"-v 197,raw48,Current_Pending_Sector "
  //"-v 198,raw48,Offline_Uncorrectable "
  //"-v 199,raw48,UDMA_CRC_Error_Count "
    "-v 202,raw48,Perc_Rated_Life_Used "
    "-v 206,raw48,Write_Error_Rate"
  },
  { "Crucial/Micron RealSSD m4/C400", // Marvell 9176, buggy or unknown firmware
    "C400-MTFDDA[ACK](064|128|256|512)MAM|" // tested with C400-MTFDDAC256MAM/0002
    "M4-CT(064|128|256|512)M4SSD[23]", // tested with M4-CT064M4SSD2/0002,
      // M4-CT064M4SSD2/0009, M4-CT256M4SSD3/000F
    "",
    "This drive may hang after 5184 hours of power-on time:\n"
    "http://www.tomshardware.com/news/Crucial-m4-Firmware-BSOD,14544.html\n"
    "See the following web pages for firmware updates:\n"
    "http://www.crucial.com/support/firmware.aspx\n"
    "http://www.micron.com/products/solid-state-storage/client-ssd#software",
    "-v 170,raw48,Grown_Failing_Block_Ct "
    "-v 171,raw48,Program_Fail_Count "
    "-v 172,raw48,Erase_Fail_Count "
    "-v 173,raw48,Wear_Leveling_Count "
    "-v 174,raw48,Unexpect_Power_Loss_Ct "
    "-v 181,raw16,Non4k_Aligned_Access "
    "-v 183,raw48,SATA_Iface_Downshift "
    "-v 189,raw48,Factory_Bad_Block_Ct "
    "-v 202,raw48,Perc_Rated_Life_Used "
    "-v 206,raw48,Write_Error_Rate"
  },
  { "SandForce Driven SSDs",
    "SandForce 1st Ed\\.|" // Demo Drive, tested with firmware 320A13F0
    "ADATA SSD S(396|510|599) .?..GB|" // tested with ADATA SSD S510 60GB/320ABBF0,
      // ADATA SSD S599 256GB/3.1.0, 64GB/3.4.6
    "ADATA SP900|" // Premier Pro, SF-2281, tested with ADATA SP900/5.0.6
    "Corsair CSSD-F(40|60|80|115|120|160|240)GBP?2.*|" // Corsair Force, tested with
      // Corsair CSSD-F40GB2/1.1, Corsair CSSD-F115GB2-A/2.1a
    "Corsair Force (3 SSD|GS|GT)|" // SF-2281, tested with
      // Corsair Force 3 SSD/1.3.2, GT/1.3.3, GS/5.03
    "FM-25S2S-(60|120|240)GBP2|" // G.SKILL Phoenix Pro, SF-1200, tested with
      // FM-25S2S-240GBP2/4.2
    "FTM(06|12|24|48)CT25H|" // Supertalent TeraDrive CT, tested with
      // FTM24CT25H/STTMP2P1
    "KINGSTON SH10[03]S3(90|120|240|480)G|" // HyperX (3K), SF-2281, tested with
      // SH100S3240G/320ABBF0, SH103S3120G/505ABBF0
    "KINGSTON SKC300S37A(60|120|240|480)G|" // SF-2281, tested with SKC300S37A120G/KC4ABBF0
    "KINGSTON SVP200S3(7A)?(60|90|120|240|480)G|" // V+ 200, SF-2281, tested with
      // SVP200S37A480G/502ABBF0, SVP200S390G/332ABBF0
    "KINGSTON SMS200S3(30|60|120)G|" // mSATA, SF-2241, tested with SMS200S3120G/KC3ABBF0
    "KINGSTON SMS450S3(32|64|128)G|" // mSATA, SF-2281, tested with SMS450S3128G/503ABBF0
    "KINGSTON (SV300|SKC100|SE100)S3.*G|" // other SF-2281
    "MKNSSDCR(45|60|90|120|180|240|480)GB(-DX)?|" // Mushkin Chronos (deluxe), SF-2281,
      // tested with MKNSSDCR120GB
    "Mushkin MKNSSDCL(40|60|80|90|115|120|180|240|480)GB-DX2?|" // Mushkin Callisto deluxe,
      // SF-1200/1222, Mushkin MKNSSDCL60GB-DX/361A13F0
    "OCZ[ -](AGILITY2([ -]EX)?|COLOSSUS2|ONYX2|VERTEX(2|-LE))( [123]\\..*)?|" // SF-1200,
      // tested with OCZ-VERTEX2/1.11, OCZ-VERTEX2 3.5/1.11
    "OCZ-NOCTI|" // mSATA, SF-2100, tested with OCZ-NOCTI/2.15
    "OCZ-REVODRIVE3?( X2)?|" // PCIe, SF-1200/2281, tested with
      // OCZ-REVODRIVE( X2)?/1.20, OCZ-REVODRIVE3 X2/2.11
    "OCZ[ -](VELO|VERTEX2[ -](EX|PRO))( [123]\\..*)?|" // SF-1500, tested with
      // OCZ VERTEX2-PRO/1.10 (Bogus thresholds for attribute 232 and 235)
    "D2[CR]STK251...-....|" // OCZ Deneva 2 C/R, SF-22xx/25xx,
      // tested with D2CSTK251M11-0240/2.08, D2CSTK251A10-0240/2.15
    "OCZ-(AGILITY3|SOLID3|VERTEX3( MI)?)|"  // SF-2200, tested with OCZ-VERTEX3/2.02,
      // OCZ-AGILITY3/2.11, OCZ-SOLID3/2.15, OCZ-VERTEX3 MI/2.15
    "OCZ Z-DRIVE R4 [CR]M8[48]|" // PCIe, SF-2282/2582, tested with OCZ Z-DRIVE R4 CM84/2.13
      // (Bogus attributes under Linux)
    "TALOS2|" // OCZ Talos 2 C/R, SAS (works with -d sat), 2*SF-2282, tested with TALOS2/3.20E
    "(APOC|DENC|DENEVA|FTNC|GFGC|MANG|MMOC|NIMC|TMSC).*|" // other OCZ SF-1200,
      // tested with DENCSTE251M11-0120/1.33, DENEVA PCI-E/1.33
    "(DENR|DRSAK|EC188|NIMR|PSIR|TRSAK).*|" // other OCZ SF-1500
    "OWC Mercury Electra [36]G SSD|" // tested with
      // OWC Mercury Electra 6G SSD/502ABBF0
    "OWC Mercury Extreme Pro (RE )?SSD|" // tested with
      // OWC Mercury Extreme Pro SSD/360A13F0
    "OWC Mercury EXTREME Pro 6G SSD|" // tested with
      // OWC Mercury EXTREME Pro 6G SSD/507ABBF0
    "Patriot Pyro|" // tested with Patriot Pyro/332ABBF0
    "SanDisk SDSSDX(60|120|240|480)GG25|" // SanDisk Extreme, SF-2281, tested with
      // SDSSDX240GG25/R201
    "SuperSSpeed S301 [0-9]*GB|" // SF-2281, tested with SuperSSpeed S301 128GB/503
    "(TX32|TX31C1|VN0.?..GCNMK).*|" // Smart Storage Systems XceedSTOR
    "(TX22D1|TX21B1).*|" // Smart Storage Systems XceedIOPS2
    "TX52D1.*|" // Smart Storage Systems Xcel-200
    "TS(64|128|256|512)GSSD320|" // Transcend SSD320, SF-2281, tested with TS128GSSD320
    "UGB(88P|99S)GC...H[BF].", // Unigen, tested with
      // UGB88PGC100HF2/MP Rev2, UGB99SGC100HB3/RC Rev3
    "", "",
    "-v 1,raw24/raw32,Raw_Read_Error_Rate "
    "-v 5,raw48,Retired_Block_Count "
    "-v 9,msec24hour32,Power_On_Hours_and_Msec "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 13,raw24/raw32,Soft_Read_Error_Rate "
    "-v 100,raw48,Gigabytes_Erased "
    "-v 170,raw48,Reserve_Block_Count "
    "-v 171,raw48,Program_Fail_Count "
    "-v 172,raw48,Erase_Fail_Count "
    "-v 174,raw48,Unexpect_Power_Loss_Ct "
    "-v 177,raw48,Wear_Range_Delta "
    "-v 181,raw48,Program_Fail_Count "
    "-v 182,raw48,Erase_Fail_Count "
    "-v 184,raw48,IO_Error_Detect_Code_Ct "
  //"-v 187,raw48,Reported_Uncorrect "
    "-v 189,tempminmax,Airflow_Temperature_Cel "
  //"-v 194,tempminmax,Temperature_Celsius "
    "-v 195,raw24/raw32,ECC_Uncorr_Error_Count "
  //"-v 196,raw16(raw16),Reallocated_Event_Count "
    "-v 198,raw24/raw32:210zr54,Uncorrectable_Sector_Ct " // KINGSTON SE100S3100G/510ABBF0
    "-v 199,raw48,SATA_CRC_Error_Count "
    "-v 201,raw24/raw32,Unc_Soft_Read_Err_Rate "
    "-v 204,raw24/raw32,Soft_ECC_Correct_Rate "
    "-v 230,raw48,Life_Curve_Status "
    "-v 231,raw48,SSD_Life_Left "
  //"-v 232,raw48,Available_Reservd_Space "
    "-v 233,raw48,SandForce_Internal "
    "-v 234,raw48,SandForce_Internal "
    "-v 235,raw48,SuperCap_Health "
    "-v 241,raw48,Lifetime_Writes_GiB "
    "-v 242,raw48,Lifetime_Reads_GiB"
  },
  { "Indilinx Barefoot based SSDs",
    "Corsair CSSD-V(32|60|64|128|256)GB2|" // Corsair Nova, tested with Corsair CSSD-V32GB2/2.2
    "CRUCIAL_CT(64|128|256)M225|" // tested with CRUCIAL_CT64M225/1571
    "G.SKILL FALCON (64|128|256)GB SSD|" // tested with G.SKILL FALCON 128GB SSD/2030
    "OCZ[ -](AGILITY|ONYX|VERTEX( 1199|-TURBO)?)|" // tested with
      // OCZ-ONYX/1.6, OCZ-VERTEX 1199/00.P97, OCZ-VERTEX/1.30, OCZ VERTEX-TURBO/1.5
    "Patriot[ -]Torqx.*|"
    "RENICE Z2|" // tested with RENICE Z2/2030
    "STT_FT[MD](28|32|56|64)GX25H|" // Super Talent Ultradrive GX, tested with STT_FTM64GX25H/1916
    "TS(18|25)M(64|128)MLC(16|32|64|128|256|512)GSSD|" // ASAX Leopard Hunt II, tested with TS25M64MLC64GSSD/0.1
    "FM-25S2I-(64|128)GBFII|" // G.Skill FALCON II, tested with FM-25S2I-64GBFII
    "TS(60|120)GSSD25D-M", // Transcend Ultra SSD (SATA II), see also Ticket #80
    "", "",
    "-v 1,raw64 " // Raw_Read_Error_Rate
    "-v 9,raw64 " // Power_On_Hours
    "-v 12,raw64 " // Power_Cycle_Count
    "-v 184,raw64,Initial_Bad_Block_Count "
    "-v 195,raw64,Program_Failure_Blk_Ct "
    "-v 196,raw64,Erase_Failure_Blk_Ct "
    "-v 197,raw64,Read_Failure_Blk_Ct "
    "-v 198,raw64,Read_Sectors_Tot_Ct "
    "-v 199,raw64,Write_Sectors_Tot_Ct "
    "-v 200,raw64,Read_Commands_Tot_Ct "
    "-v 201,raw64,Write_Commands_Tot_Ct "
    "-v 202,raw64,Error_Bits_Flash_Tot_Ct "
    "-v 203,raw64,Corr_Read_Errors_Tot_Ct "
    "-v 204,raw64,Bad_Block_Full_Flag "
    "-v 205,raw64,Max_PE_Count_Spec "
    "-v 206,raw64,Min_Erase_Count "
    "-v 207,raw64,Max_Erase_Count "
    "-v 208,raw64,Average_Erase_Count "
    "-v 209,raw64,Remaining_Lifetime_Perc "
    "-v 210,raw64,Indilinx_Internal "
    "-v 211,raw64,SATA_Error_Ct_CRC "
    "-v 212,raw64,SATA_Error_Ct_Handshake "
    "-v 213,raw64,Indilinx_Internal"
  },
  { "Indilinx Barefoot_2/Everest/Martini based SSDs",
    "OCZ VERTEX[ -]PLUS|" // tested with OCZ VERTEX-PLUS/3.55, OCZ VERTEX PLUS/3.55
    "OCZ-VERTEX PLUS R2|" // Barefoot 2, tested with OCZ-VERTEX PLUS R2/1.2
    "OCZ-PETROL|" // Everest 1, tested with OCZ-PETROL/3.12
    "OCZ-AGILITY4|" // Everest 2, tested with OCZ-AGILITY4/1.5.2
    "OCZ-VERTEX4", // Everest 2, tested with OCZ-VERTEX4/1.5
    "", "", ""
  //"-v 1,raw48,Raw_Read_Error_Rate "
  //"-v 3,raw16(avg16),Spin_Up_Time "
  //"-v 4,raw48,Start_Stop_Count "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 232,raw48,Lifetime_Writes " // LBA?
  //"-v 233,raw48,Media_Wearout_Indicator"
  },
  { "Indilinx Barefoot 3 based SSDs",
    "OCZ-VECTOR", // tested with OCZ-VECTOR/1.03
    "", "", ""
    "-v 5,raw48,Runtime_Bad_Block "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 171,raw48,Avail_OP_Block_Count "
    "-v 174,raw48,Pwr_Cycle_Ct_Unplanned "
    "-v 187,raw48,Total_Unc_NAND_Reads "
    "-v 195,raw48,Total_Prog_Failures "
    "-v 196,raw48,Total_Erase_Failures "
    "-v 197,raw48,Total_Unc_Read_Failures "
    "-v 198,raw48,Host_Reads_GiB "
    "-v 199,raw48,Host_Writes_GiB "
    "-v 208,raw48,Average_Erase_Count "
    "-v 210,raw48,SATA_CRC_Error_Count "
    "-v 233,raw48,Remaining_Lifetime_Perc "
    "-v 249,raw48,Total_NAND_Prog_Ct_GiB"
  },
  { "InnoDisk InnoLite SATADOM D150QV-L SSDs", // tested with InnoLite SATADOM D150QV-L/120319
    "InnoLite SATADOM D150QV-L",
    "", "",
  //"-v 1,raw48,Raw_Read_Error_Rate "
  //"-v 2,raw48,Throughput_Performance "
  //"-v 3,raw16(avg16),Spin_Up_Time "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 7,raw48,Seek_Error_Rate " // from InnoDisk iSMART Linux tool, useless for SSD
  //"-v 8,raw48,Seek_Time_Performance "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 10,raw48,Spin_Retry_Count "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 168,raw48,SATA_PHY_Error_Count "
    "-v 170,raw48,Bad_Block_Count "
    "-v 173,raw48,Erase_Count "
    "-v 175,raw48,Bad_Cluster_Table_Count "
    "-v 192,raw48,Unexpect_Power_Loss_Ct "
  //"-v 194,tempminmax,Temperature_Celsius "
  //"-v 197,raw48,Current_Pending_Sector "
    "-v 229,hex48,Flash_ID "
    "-v 235,raw48,Later_Bad_Block "
    "-v 236,raw48,Unstable_Power_Count "
    "-v 240,raw48,Write_Head"
  },
  { "Intel X25-E SSDs",
    "SSDSA2SH(032|064)G1.* INTEL",  // G1 = first generation
    "", "",
  //"-v 3,raw16(avg16),Spin_Up_Time "
  //"-v 4,raw48,Start_Stop_Count "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 192,raw48,Unsafe_Shutdown_Count "
    "-v 225,raw48,Host_Writes_32MiB "
    "-v 226,raw48,Intel_Internal "
    "-v 227,raw48,Intel_Internal "
    "-v 228,raw48,Intel_Internal "
  //"-v 232,raw48,Available_Reservd_Space "
  //"-v 233,raw48,Media_Wearout_Indicator"
  },
  { "Intel X18-M/X25-M G1 SSDs",
    "INTEL SSDSA[12]MH(080|160)G1.*",  // G1 = first generation, 50nm
    "", "",
  //"-v 3,raw16(avg16),Spin_Up_Time "
  //"-v 4,raw48,Start_Stop_Count "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 192,raw48,Unsafe_Shutdown_Count "
    "-v 225,raw48,Host_Writes_32MiB "
    "-v 226,raw48,Intel_Internal "
    "-v 227,raw48,Intel_Internal "
    "-v 228,raw48,Intel_Internal "
  //"-v 232,raw48,Available_Reservd_Space "
  //"-v 233,raw48,Media_Wearout_Indicator"
  },
  { "Intel X18-M/X25-M/X25-V G2 SSDs", // fixed firmware
      // tested with INTEL SSDSA2M(080|160)G2GC/2CV102J8 (X25-M)
    "INTEL SSDSA[12]M(040|080|120|160)G2.*",  // G2 = second generation, 34nm
    "2CV102(J[89A-Z]|[K-Z].)", // >= "2CV102J8"
    "",
  //"-v 3,raw16(avg16),Spin_Up_Time "
  //"-v 4,raw48,Start_Stop_Count "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
  //"-v 184,raw48,End-to-End_Error " // G2 only
    "-v 192,raw48,Unsafe_Shutdown_Count "
    "-v 225,raw48,Host_Writes_32MiB "
    "-v 226,raw48,Workld_Media_Wear_Indic " // Timed Workload Media Wear Indicator (percent*1024)
    "-v 227,raw48,Workld_Host_Reads_Perc "  // Timed Workload Host Reads Percentage
    "-v 228,raw48,Workload_Minutes " // 226,227,228 can be reset by 'smartctl -t vendor,0x40'
  //"-v 232,raw48,Available_Reservd_Space "
  //"-v 233,raw48,Media_Wearout_Indicator"
  },
  { "Intel X18-M/X25-M/X25-V G2 SSDs", // buggy or unknown firmware
      // tested with INTEL SSDSA2M040G2GC/2CV102HD (X25-V)
    "INTEL SSDSA[12]M(040|080|120|160)G2.*",
    "",
    "This drive may require a firmware update to\n"
    "fix possible drive hangs when reading SMART self-test log:\n"
    "http://downloadcenter.intel.com/Detail_Desc.aspx?DwnldID=18363",
    "-v 192,raw48,Unsafe_Shutdown_Count "
    "-v 225,raw48,Host_Writes_32MiB "
    "-v 226,raw48,Workld_Media_Wear_Indic "
    "-v 227,raw48,Workld_Host_Reads_Perc "
    "-v 228,raw48,Workload_Minutes"
  },
  { "Intel 313 Series SSDs", // tested with INTEL SSDSA2VP020G3/9CV10379
    "INTEL SSDSA2VP(020|024)G3",
    "", "",
  //"-v 3,raw16(avg16),Spin_Up_Time "
  //"-v 4,raw48,Start_Stop_Count "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 170,raw48,Reserve_Block_Count "
    "-v 171,raw48,Program_Fail_Count "
    "-v 172,raw48,Erase_Fail_Count "
    "-v 183,raw48,SATA_Downshift_Count "
  //"-v 184,raw48,End-to-End_Error "
  //"-v 187,raw48,Reported_Uncorrect "
    "-v 192,raw48,Unsafe_Shutdown_Count "
    "-v 225,raw48,Host_Writes_32MiB "
    "-v 226,raw48,Workld_Media_Wear_Indic " // Timed Workload Media Wear Indicator (percent*1024)
    "-v 227,raw48,Workld_Host_Reads_Perc "  // Timed Workload Host Reads Percentage
    "-v 228,raw48,Workload_Minutes " // 226,227,228 can be reset by 'smartctl -t vendor,0x40'
  //"-v 232,raw48,Available_Reservd_Space "
  //"-v 233,raw48,Media_Wearout_Indicator "
    "-v 241,raw48,Host_Writes_32MiB "
    "-v 242,raw48,Host_Reads_32MiB"
  },
  { "Intel 320 Series SSDs", // tested with INTEL SSDSA2CT040G3/4PC10362,
      // INTEL SSDSA2CW160G3/4PC10362, INTEL SSDSA2BT040G3/4PC10362, INTEL SSDSA2BW120G3A/4PC10362
    "INTEL SSDSA[12][BC][WT](040|080|120|160|300|600)G3A?",
    "", "",
    "-F nologdir "
  //"-v 3,raw16(avg16),Spin_Up_Time "
  //"-v 4,raw48,Start_Stop_Count "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 170,raw48,Reserve_Block_Count "
    "-v 171,raw48,Program_Fail_Count "
    "-v 172,raw48,Erase_Fail_Count "
  //"-v 184,raw48,End-to-End_Error "
  //"-v 187,raw48,Reported_Uncorrect "
    "-v 192,raw48,Unsafe_Shutdown_Count "
    "-v 225,raw48,Host_Writes_32MiB "
    "-v 226,raw48,Workld_Media_Wear_Indic " // Timed Workload Media Wear Indicator (percent*1024)
    "-v 227,raw48,Workld_Host_Reads_Perc "  // Timed Workload Host Reads Percentage
    "-v 228,raw48,Workload_Minutes " // 226,227,228 can be reset by 'smartctl -t vendor,0x40'
  //"-v 232,raw48,Available_Reservd_Space "
  //"-v 233,raw48,Media_Wearout_Indicator "
    "-v 241,raw48,Host_Writes_32MiB "
    "-v 242,raw48,Host_Reads_32MiB"
  },
  { "Intel 710 Series SSDs", // tested with INTEL SSDSA2BZ[12]00G3/6PB10362
    "INTEL SSDSA2BZ(100|200|300)G3",
    "", "",
    "-F nologdir "
  //"-v 3,raw16(avg16),Spin_Up_Time "
  //"-v 4,raw48,Start_Stop_Count "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 170,raw48,Reserve_Block_Count "
    "-v 171,raw48,Program_Fail_Count "
    "-v 172,raw48,Erase_Fail_Count "
    "-v 174,raw48,Unexpect_Power_Loss_Ct " // Missing in 710 specification from September 2011
    "-v 183,raw48,SATA_Downshift_Count "
  //"-v 184,raw48,End-to-End_Error "
  //"-v 187,raw48,Reported_Uncorrect "
  //"-v 190,tempminmax,Airflow_Temperature_Cel "
    "-v 192,raw48,Unsafe_Shutdown_Count "
    "-v 225,raw48,Host_Writes_32MiB "
    "-v 226,raw48,Workld_Media_Wear_Indic " // Timed Workload Media Wear Indicator (percent*1024)
    "-v 227,raw48,Workld_Host_Reads_Perc "  // Timed Workload Host Reads Percentage
    "-v 228,raw48,Workload_Minutes " // 226,227,228 can be reset by 'smartctl -t vendor,0x40'
  //"-v 232,raw48,Available_Reservd_Space "
  //"-v 233,raw48,Media_Wearout_Indicator "
    "-v 241,raw48,Host_Writes_32MiB "
    "-v 242,raw48,Host_Reads_32MiB"
  },
  { "Intel 510 Series SSDs",
    "INTEL SSDSC2MH(120|250)A2",
    "", "",
  //"-v 3,raw16(avg16),Spin_Up_Time "
  //"-v 4,raw48,Start_Stop_Count "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 192,raw48,Unsafe_Shutdown_Count "
    "-v 225,raw48,Host_Writes_32MiB "
  //"-v 232,raw48,Available_Reservd_Space "
  //"-v 233,raw48,Media_Wearout_Indicator"
  },
  { "Intel 520 Series SSDs", // tested with INTEL SSDSC2CW120A3/400i, SSDSC2BW480A3F/400i
    "INTEL SSDSC2[BC]W(060|120|180|240|480)A3F?",
    "", "",
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
    "-v 9,msec24hour32,Power_On_Hours_and_Msec "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 170,raw48,Available_Reservd_Space "
    "-v 171,raw48,Program_Fail_Count "
    "-v 172,raw48,Erase_Fail_Count "
    "-v 174,raw48,Unexpect_Power_Loss_Ct "
  //"-v 184,raw48,End-to-End_Error "
    "-v 187,raw48,Uncorrectable_Error_Cnt "
  //"-v 192,raw48,Power-Off_Retract_Count "
    "-v 225,raw48,Host_Writes_32MiB "
    "-v 226,raw48,Workld_Media_Wear_Indic "
    "-v 227,raw48,Workld_Host_Reads_Perc "
    "-v 228,raw48,Workload_Minutes "
  //"-v 232,raw48,Available_Reservd_Space "
  //"-v 233,raw48,Media_Wearout_Indicator "
    "-v 241,raw48,Host_Writes_32MiB "
    "-v 242,raw48,Host_Reads_32MiB "
    "-v 249,raw48,NAND_Writes_1GiB"
  },
  { "Intel 330/335 Series SSDs", // tested with INTEL SSDSC2CT180A3/300i, SSDSC2CT240A3/300i,
      // INTEL SSDSC2CT240A4/335t
    "INTEL SSDSC2CT(060|120|180|240)A[34]", // A4 = 335 Series
    "", "",
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
    "-v 9,msec24hour32,Power_On_Hours_and_Msec "
  //"-v 12,raw48,Power_Cycle_Count "
  //"-v 181,raw48,Program_Fail_Cnt_Total " // ] Missing in 330 specification from April 2012
  //"-v 182,raw48,Erase_Fail_Count_Total " // ]
  //"-v 192,raw48,Power-Off_Retract_Count "
    "-v 225,raw48,Host_Writes_32MiB "
  //"-v 232,raw48,Available_Reservd_Space "
  //"-v 233,raw48,Media_Wearout_Indicator "
    "-v 241,raw48,Host_Writes_32MiB "
    "-v 242,raw48,Host_Reads_32MiB "
    "-v 249,raw48,NAND_Writes_1GiB"
  },
  { "Intel DC S3700 Series SSDs", // tested with INTEL SSDSC2BA200G3/5DV10250
    "INTEL SSDSC(1N|2B)A(100|200|400|800)G3",
    "", "",
  //"-v 3,raw16(avg16),Spin_Up_Time "
  //"-v 4,raw48,Start_Stop_Count "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 170,raw48,Available_Reservd_Space "
    "-v 171,raw48,Program_Fail_Count "
    "-v 172,raw48,Erase_Fail_Count "
    "-v 174,raw48,Unsafe_Shutdown_Count "
    "-v 175,raw48,Power_Loss_Cap_Test "
    "-v 183,raw48,SATA_Downshift_Count "
  //"-v 184,raw48,End-to-End_Error "
  //"-v 187,raw48,Reported_Uncorrect "
    "-v 190,tempminmax,Temperature_Case "
    "-v 192,raw48,Unsafe_Shutdown_Count "
    "-v 194,tempminmax,Temperature_Internal "
  //"-v 197,raw48,Current_Pending_Sector "
    "-v 199,raw48,CRC_Error_Count "
    "-v 225,raw48,Host_Writes_32MiB "
    "-v 226,raw48,Workld_Media_Wear_Indic " // Timed Workload Media Wear Indicator (percent*1024)
    "-v 227,raw48,Workld_Host_Reads_Perc "  // Timed Workload Host Reads Percentage
    "-v 228,raw48,Workload_Minutes " // 226,227,228 can be reset by 'smartctl -t vendor,0x40'
  //"-v 232,raw48,Available_Reservd_Space "
  //"-v 233,raw48,Media_Wearout_Indicator "
    "-v 234,raw48,Thermal_Throttle "
    "-v 241,raw48,Host_Writes_32MiB "
    "-v 242,raw48,Host_Reads_32MiB"
  },
  { "Kingston branded X25-V SSDs", // fixed firmware
    "KINGSTON SSDNow 40GB",
    "2CV102(J[89A-Z]|[K-Z].)", // >= "2CV102J8"
    "",
    "-v 192,raw48,Unsafe_Shutdown_Count "
    "-v 225,raw48,Host_Writes_32MiB "
    "-v 226,raw48,Workld_Media_Wear_Indic "
    "-v 227,raw48,Workld_Host_Reads_Perc "
    "-v 228,raw48,Workload_Minutes"
  },
  { "Kingston branded X25-V SSDs", // buggy or unknown firmware
    "KINGSTON SSDNow 40GB",
    "",
    "This drive may require a firmware update to\n"
    "fix possible drive hangs when reading SMART self-test log.\n"
    "To update Kingston branded drives, a modified Intel update\n"
    "tool must be used. Search for \"kingston 40gb firmware\".",
    "-v 192,raw48,Unsafe_Shutdown_Count "
    "-v 225,raw48,Host_Writes_32MiB "
    "-v 226,raw48,Workld_Media_Wear_Indic "
    "-v 227,raw48,Workld_Host_Reads_Perc "
    "-v 228,raw48,Workload_Minutes"
  },
  { "JMicron based SSDs", // JMicron JMF60x
    "Kingston SSDNow V Series [0-9]*GB|" // tested with Kingston SSDNow V Series 64GB/B090522a
    "TS(2|4|8|16|32|64|128|192)GSSD25S?-(M|S)", // Transcend IDE and SATA, tested with TS32GSSD25-M/V090331
    "[BV].*", // other Transcend SSD versions will be catched by subsequent entry
    "",
  //"-v 9,raw24(raw8),Power_On_Hours " // raw value always 0?
  //"-v 12,raw48,Power_Cycle_Count "
  //"-v 194,tempminmax,Temperature_Celsius " // raw value always 0?
    "-v 229,hex64:w012345r,Halt_System/Flash_ID " // Halt, Flash[7]
    "-v 232,hex64:w012345r,Firmware_Version_Info " // "YYMMDD", #Channels, #Banks
    "-v 233,hex48:w01234,ECC_Fail_Record " // Fail number, Row[3], Channel, Bank
    "-v 234,raw24/raw24:w01234,Avg/Max_Erase_Count "
    "-v 235,raw24/raw24:w01z23,Good/Sys_Block_Count"
  },
  { "JMicron based SSDs", // JMicron JMF61x
    "ADATA S596 Turbo|"  // tested with ADATA S596 Turbo 256GB SATA SSD (JMicron JMF616)
    "APPLE SSD TS.*|"  // Toshiba?, tested with APPLE SSD TS064C/CJAA0201
    "KINGSTON SNV425S2(64|128)GB|"  // SSDNow V Series (2. Generation, JMF618),
                                    // tested with KINGSTON SNV425S264GB/C091126a
    "KINGSTON SSDNOW 30GB|" // tested with KINGSTON SSDNOW 30GB/AJXA0202
    "KINGSTON SS100S2(8|16)G|"  // SSDNow S100 Series, tested with KINGSTON SS100S28G/D100309a
    "KINGSTON SVP?100S2B?(64|96|128|256|512)G|"  // SSDNow V100/V+100 Series,
      // tested with KINGSTON SVP100S296G/CJR10202, KINGSTON SV100S2256G/D110225a
    "KINGSTON SV200S3(64|128|256)G|" // SSDNow V200 Series, tested with KINGSTON SV200S3128G/E120506a
    "TOSHIBA THNS128GG4BBAA|"  // Toshiba / Super Talent UltraDrive DX,
                               // tested with Toshiba 128GB 2.5" SSD (built in MacBooks)
    "TOSHIBA THNSNC128GMLJ|" // tested with THNSNC128GMLJ/CJTA0202 (built in Toshiba Protege/Dynabook)
    "TS(8|16|32|64|128|192|256|512)GSSD25S?-(MD?|S)", // Transcend IDE and SATA (JMF612), tested with
      // TS256GSSD25S-M/101028, TS32GSSD25-M/20101227
    "", "",
  //"-v 1,raw48,Raw_Read_Error_Rate "
  //"-v 2,raw48,Throughput_Performance "
    "-v 3,raw48,Unknown_Attribute "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
    "-v 7,raw48,Unknown_Attribute "
    "-v 8,raw48,Unknown_Attribute "
  //"-v 9,raw24(raw8),Power_On_Hours "
    "-v 10,raw48,Unknown_Attribute "
  //"-v 12,raw48,Power_Cycle_Count "
  //"-v 167,raw48,Unknown_Attribute "
    "-v 168,raw48,SATA_Phy_Error_Count "
  //"-v 169,raw48,Unknown_Attribute "
    "-v 170,raw16,Bad_Block_Count "
    "-v 173,raw16,Erase_Count "
    "-v 175,raw48,Bad_Cluster_Table_Count "
    "-v 192,raw48,Unexpect_Power_Loss_Ct "
  //"-v 194,tempminmax,Temperature_Celsius "
  //"-v 197,raw48,Current_Pending_Sector "
    "-v 240,raw48,Unknown_Attribute"
  },
  { "Plextor M3 (Pro) Series SSDs", // Marvell 9174, tested with PLEXTOR PX-128M3/1.01,
      // PLEXTOR PX-128M3P/1.04, PLEXTOR PX-256M3/1.05
      // (1.04/5 Firmware self-test log lifetime unit is bogus, possibly 1/256 hours)
    "PLEXTOR PX-(64|128|256|512)M3P?",
    "", "",
  //"-v 1,raw48,Raw_Read_Error_Rate "
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
  //"-v 177,raw48,Wear_Leveling_Count "
  //"-v 178,raw48,Used_Rsvd_Blk_Cnt_Chip "
  //"-v 181,raw48,Program_Fail_Cnt_Total "
  //"-v 182,raw48,Erase_Fail_Count_Total "
  //"-v 187,raw48,Reported_Uncorrect "
  //"-v 192,raw48,Power-Off_Retract_Count "
  //"-v 196,raw16(raw16),Reallocated_Event_Count "
  //"-v 198,raw48,Offline_Uncorrectable "
  //"-v 199,raw48,UDMA_CRC_Error_Count "
  //"-v 232,raw48,Available_Reservd_Space "
    ""
  },
  { "Samsung based SSDs",
    "SAMSUNG SSD PM800 .*GB|"  // SAMSUNG PM800 SSDs, tested with SAMSUNG SSD PM800 TH 64GB/VBM25D1Q
    "SAMSUNG SSD PM810 .*GB|"  // SAMSUNG PM810 (470 series) SSDs, tested with SAMSUNG SSD PM810 2.5" 128GB/AXM06D1Q
    "SAMSUNG 470 Series SSD|"  // tested with SAMSUNG 470 Series SSD 64GB/AXM09B1Q
    "SAMSUNG SSD 830 Series|"  // tested with SAMSUNG SSD 830 Series 64GB/CXM03B1Q
    "Samsung SSD 840 (PRO )?Series|" // tested with Samsung SSD 840 PRO Series 128GB/DXM04B0Q,
      // Samsung SSD 840 Series/DXT06B0Q
    "SAMSUNG MZ7WD((120|240)HAFV|480HAGM|960HAGP)-00003", // SM843T Series, tested with
      // SAMSUNG MZ7WD120HAFV-00003/DXM85W3Q
    "", "",
  //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
  //"-v 175,raw48,Program_Fail_Count_Chip "
  //"-v 176,raw48,Erase_Fail_Count_Chip "
  //"-v 177,raw48,Wear_Leveling_Count "
  //"-v 178,raw48,Used_Rsvd_Blk_Cnt_Chip "
  //"-v 179,raw48,Used_Rsvd_Blk_Cnt_Tot "
  //"-v 180,raw48,Unused_Rsvd_Blk_Cnt_Tot "
  //"-v 181,raw48,Program_Fail_Cnt_Total "
  //"-v 182,raw48,Erase_Fail_Count_Total "
  //"-v 183,raw48,Runtime_Bad_Block "
  //"-v 184,raw48,End-to-End_Error " // SM843T Series
    "-v 187,raw48,Uncorrectable_Error_Cnt "
  //"-v 190,tempminmax,Airflow_Temperature_Cel "  // seems to be some sort of temperature value for 470 Series?
  //"-v 194,tempminmax,Temperature_Celsius "
    "-v 195,raw48,ECC_Error_Rate "
  //"-v 198,raw48,Offline_Uncorrectable "
    "-v 199,raw48,CRC_Error_Count "
    "-v 201,raw48,Supercap_Status "
    "-v 202,raw48,Exception_Mode_Status "
    "-v 235,raw48,POR_Recovery_Count " // 830/840 Series
  //"-v 241,raw48,Total_LBAs_Written"
  },
  { "Smart Storage Systems Xcel-10 SSDs",  // based on http://www.smartm.com/files/salesLiterature/storage/xcel10.pdf
    "SMART A25FD-(32|64|128)GI32N", // tested with SMART A25FD-128GI32N/B9F23D4K
    "",
    "", // attributes info from http://www.adtron.com/pdf/SMART_Attributes_Xcel-10_810800014_RevB.pdf
    "-v 1,raw48,Not_Supported "
    "-v 2,raw48,Not_Supported "
  //"-v 9,raw24(raw8),Power_On_Hours "
  //"-v 12,raw48,Power_Cycle_Count "
    "-v 191,raw48,Not_Supported "
  //"-v 192,raw48,Power-Off_Retract_Count "
    "-v 197,raw48,ECC_Error_Count "
  //"-v 198,raw48,Offline_Uncorrectable "
  //"-v 199,raw48,UDMA_CRC_Error_Count "
    "-v 251,raw48,Min_Spares_Remain_Perc " // percentage of the total number of spare blocks available
    "-v 252,raw48,Added_Bad_Flash_Blk_Ct " // number of bad flash blocks
    "-v 254,raw48,Total_Erase_Blocks_Ct" // number of times the drive has erased any erase block
  },
  { "Smart Storage Systems XceedSecure2 SSDs",
    "(SMART|Adtron) ([AIS]25FBS|S35FCS).*",
    "", "",
    "-v 9,sec2hour,Power_On_Hours "
    "-v 194,hex64,Proprietary_194"
  },
  { "Smart Storage Systems XceedUltraX/Adtron A25FBX SSDs",
    "(SMART|Adtron) (A|I)25FBX.*",
    "", "",
    "-v 9,hex64,Proprietary_9 "
    "-v 194,hex48,Proprietary_194"
  },
  { "Smart Storage Systems Adtron A25FB 2xN SSDs",
    "(SMART|Adtron) A25FB.*2.N",
    "", "",
    "-v 110,hex64,Proprietary_HWC "
    "-v 111,hex64,Proprietary_MP "
    "-v 112,hex64,Proprietary_RtR "
    "-v 113,hex64,Proprietary_RR "
    "-v 120,hex64,Proprietary_HFAll "
    "-v 121,hex64,Proprietary_HF1st "
    "-v 122,hex64,Proprietary_HF2nd "
    "-v 123,hex64,Proprietary_HF3rd "
    "-v 125,hex64,Proprietary_SFAll "
    "-v 126,hex64,Proprietary_SF1st "
    "-v 127,hex64,Proprietary_SF2nd "
    "-v 128,hex64,Proprietary_SF3rd "
    "-v 194,raw24/raw32:zvzzzw,Fractional_Temperature"
  },
  { "Smart Storage Systems Adtron A25FB 3xN SSDs",
    "(SMART|Adtron) A25FB-.*3.N",
    "", "",
    "-v 9,sec2hour,Power_On_Hours "
    "-v 113,hex48,Proprietary_RR "
    "-v 130,raw48:54321,Minimum_Spares_All_Zs"
  //"-v 194,tempminmax,Temperature_Celsius"
  },
  { "STEC Mach2 CompactFlash Cards", // tested with STEC M2P CF 1.0.0/K1385MS
    "STEC M2P CF 1.0.0",
    "", "",
    "-v 100,raw48,Erase_Program_Cycles "
    "-v 103,raw48,Remaining_Energy_Storg "
    "-v 170,raw48,Reserved_Block_Count "
    "-v 171,raw48,Program_Fail_Count "
    "-v 172,raw48,Erase_Fail_Count "
    "-v 173,raw48,Wear_Leveling_Count "
    "-v 174,raw48,Unexpect_Power_Loss_Ct "
    "-v 211,raw48,Unknown_Attribute " // ] Missing in specification
    "-v 212,raw48,Unknown_Attribute"  // ] from September 2012
  },
  { "Transcend CompactFlash Cards", // tested with TRANSCEND/20080820,
      // TS4GCF133/20100709, TS16GCF133/20100709, TS16GCF150/20110407
    "TRANSCEND|TS(4|8|16)GCF(133|150)",
    "", "",
    "-v 7,raw48,Unknown_Attribute "
    "-v 8,raw48,Unknown_Attribute"
  },
  { "Marvell SSD SD88SA024BA0 (SUN branded)",
    "MARVELL SD88SA024BA0 SUN24G 0902M0054V",
    "", "", ""
  },
  { "HP 1TB SATA disk GB1000EAFJL",
    "GB1000EAFJL",
    "", "", ""
  },
  { "HP 500GB SATA disk MM0500EANCR",
    "MM0500EANCR",
    "", "", ""
  },
  { "HP 250GB SATA disk VB0250EAVER",
    "VB0250EAVER",
    "", "", ""
  },
  { "IBM Deskstar 60GXP",  // ER60A46A firmware
    "(IBM-|Hitachi )?IC35L0[12346]0AVER07.*",
    "ER60A46A",
    "", ""
  },
  { "IBM Deskstar 60GXP",  // All other firmware
    "(IBM-|Hitachi )?IC35L0[12346]0AVER07.*",
    "",
    "IBM Deskstar 60GXP drives may need upgraded SMART firmware.\n"
    "Please see http://haque.net/dtla_update/",
    ""
  },
  { "IBM Deskstar 40GV & 75GXP (A5AA/A6AA firmware)",
    "(IBM-)?DTLA-30[57]0[123467][05].*",
    "T[WX][123468AG][OF]A[56]AA",
    "", ""
  },
  { "IBM Deskstar 40GV & 75GXP (all other firmware)",
    "(IBM-)?DTLA-30[57]0[123467][05].*",
    "",
    "IBM Deskstar 40GV and 75GXP drives may need upgraded SMART firmware.\n"
    "Please see http://haque.net/dtla_update/",
    ""
  },
  { "", // ExcelStor J240, J340, J360, J680, J880 and J8160
    "ExcelStor Technology J(24|34|36|68|88|816)0",
    "", "", ""
  },
  { "", // Fujitsu M1623TAU
    "FUJITSU M1623TAU",
    "",
    "",
    "-v 9,seconds"
  },
  { "Fujitsu MHG",
    "FUJITSU MHG2...ATU?.*",
    "",
    "",
    "-v 9,seconds"
  },
  { "Fujitsu MHH",
    "FUJITSU MHH2...ATU?.*",
    "",
    "",
    "-v 9,seconds"
  },
  { "Fujitsu MHJ",
    "FUJITSU MHJ2...ATU?.*",
    "",
    "",
    "-v 9,seconds"
  },
  { "Fujitsu MHK",
    "FUJITSU MHK2...ATU?.*",
    "",
    "",
    "-v 9,seconds"
  },
  { "",  // Fujitsu MHL2300AT
    "FUJITSU MHL2300AT",
    "",
    "This drive's firmware has a harmless Drive Identity Structure\n"
      "checksum error bug.",
    "-v 9,seconds"
  },
  { "",  // MHM2200AT, MHM2150AT, MHM2100AT, MHM2060AT
    "FUJITSU MHM2(20|15|10|06)0AT",
    "",
    "This drive's firmware has a harmless Drive Identity Structure\n"
      "checksum error bug.",
    "-v 9,seconds"
  },
  { "Fujitsu MHN",
    "FUJITSU MHN2...AT",
    "",
    "",
    "-v 9,seconds"
  },
  { "", // Fujitsu MHR2020AT
    "FUJITSU MHR2020AT",
    "",
    "",
    "-v 9,seconds"
  },
  { "", // Fujitsu MHR2040AT
    "FUJITSU MHR2040AT",
    "",    // Tested on 40BA
    "",
    "-v 9,seconds -v 192,emergencyretractcyclect "
    "-v 198,offlinescanuncsectorct -v 200,writeerrorcount"
  },
  { "Fujitsu MHS AT",
    "FUJITSU MHS20[6432]0AT(  .)?",
    "",
    "",
    "-v 9,seconds -v 192,emergencyretractcyclect "
    "-v 198,offlinescanuncsectorct -v 200,writeerrorcount "
    "-v 201,detectedtacount"
  },
  { "Fujitsu MHT", // tested with FUJITSU MHT2030AC/909B
    "FUJITSU MHT2...(AC|AH|AS|AT|BH)U?.*",
    "",
    "",
    "-v 9,seconds"
  },
  { "Fujitsu MHU",
    "FUJITSU MHU2...ATU?.*",
    "",
    "",
    "-v 9,seconds"
  },
  { "Fujitsu MHV",
    "FUJITSU MHV2...(AH|AS|AT|BH|BS|BT).*",
    "",
    "",
    "-v 9,seconds"
  },
  { "Fujitsu MPA..MPG",
    "FUJITSU MP[A-G]3...A[HTEV]U?.*",
    "",
    "",
    "-v 9,seconds"
  },
  { "Fujitsu MHY BH",
    "FUJITSU MHY2(04|06|08|10|12|16|20|25)0BH.*",
    "", "",
    "-v 240,raw48,Transfer_Error_Rate"
  },
  { "Fujitsu MHW AC", // tested with FUJITSU MHW2060AC/00900004
    "FUJITSU MHW20(40|60)AC",
    "", "", ""
  },
  { "Fujitsu MHW BH",
    "FUJITSU MHW2(04|06|08|10|12|16)0BH.*",
    "", "", ""
  },
  { "Fujitsu MHW BJ",
    "FUJITSU MHW2(08|12|16)0BJ.*",
    "", "", ""
  },
  { "Fujitsu MHZ BH",
    "FUJITSU MHZ2(04|08|12|16|20|25|32)0BH.*",
    "", "", ""
  },
  { "Fujitsu MHZ BJ",
    "FUJITSU MHZ2(08|12|16|20|25|32)0BJ.*",
    "",
    "",
    "-v 9,minutes"
  },
  { "Fujitsu MHZ BS",
    "FUJITSU MHZ2(12|25)0BS.*",
    "", "", ""
  },
  { "Fujitsu MHZ BK",
    "FUJITSU MHZ2(08|12|16|25)0BK.*",
    "", "", ""
  },
  { "Fujitsu MJA BH",
    "FUJITSU MJA2(08|12|16|25|32|40|50)0BH.*",
    "", "", ""
  },
  { "", // Samsung SV4012H (known firmware)
    "SAMSUNG SV4012H",
    "RM100-08",
    "",
    "-v 9,halfminutes -F samsung"
  },
  { "", // Samsung SV4012H (all other firmware)
    "SAMSUNG SV4012H",
    "",
    "May need -F samsung disabled; see manual for details.",
    "-v 9,halfminutes -F samsung"
  },
  { "", // Samsung SV0412H (known firmware)
    "SAMSUNG SV0412H",
    "SK100-01",
    "",
    "-v 9,halfminutes -v 194,10xCelsius -F samsung"
  },
  { "", // Samsung SV0412H (all other firmware)
    "SAMSUNG SV0412H",
    "",
    "May need -F samsung disabled; see manual for details.",
    "-v 9,halfminutes -v 194,10xCelsius -F samsung"
  },
  { "", // Samsung SV1204H (known firmware)
    "SAMSUNG SV1204H",
    "RK100-1[3-5]",
    "",
    "-v 9,halfminutes -v 194,10xCelsius -F samsung"
  },
  { "", // Samsung SV1204H (all other firmware)
    "SAMSUNG SV1204H",
    "",
    "May need -F samsung disabled; see manual for details.",
    "-v 9,halfminutes -v 194,10xCelsius -F samsung"
  },
  { "", // SAMSUNG SV0322A tested with FW JK200-35
    "SAMSUNG SV0322A",
    "", "", ""
  },
  { "SAMSUNG SpinPoint V80", // tested with SV1604N/TR100-23
    "SAMSUNG SV(0211|0401|0612|0802|1203|1604)N",
    "",
    "",
    "-v 9,halfminutes -F samsung2"
  },
  { "", // SAMSUNG SP40A2H with RR100-07 firmware
    "SAMSUNG SP40A2H",
    "RR100-07",
    "",
    "-v 9,halfminutes -F samsung"
  },
  { "", // SAMSUNG SP80A4H with RT100-06 firmware
    "SAMSUNG SP80A4H",
    "RT100-06",
    "",
    "-v 9,halfminutes -F samsung"
  },
  { "", // SAMSUNG SP8004H with QW100-61 firmware
    "SAMSUNG SP8004H",
    "QW100-61",
    "",
    "-v 9,halfminutes -F samsung"
  },
  { "SAMSUNG SpinPoint F1 DT", // tested with HD103UJ/1AA01113
    "SAMSUNG HD(083G|16[12]G|25[12]H|32[12]H|50[12]I|642J|75[23]L|10[23]U)J",
    "", "", ""
  },
  { "SAMSUNG SpinPoint F1 EG", // tested with HD103UI/1AA01113
    "SAMSUNG HD(252H|322H|502I|642J|753L|103U)I",
    "", "", ""
  },
  { "SAMSUNG SpinPoint F1 RE", // tested with HE103UJ/1AA01113
    "SAMSUNG HE(252H|322H|502I|642J|753L|103U)J",
    "", "", ""
  },
  { "SAMSUNG SpinPoint F2 EG", // tested with HD154UI/1AG01118
    "SAMSUNG HD(502H|10[23]S|15[34]U)I",
    "", "", ""
  },
  { "SAMSUNG SpinPoint F3", // tested with HD502HJ/1AJ100E4
    "SAMSUNG HD(502H|754J|103S)J",
    "", "", ""
  },
  { "Seagate Barracuda SpinPoint F3", // tested with ST1000DM005 HD103SJ/1AJ100E5
    "ST[0-9DM]* HD(502H|754J|103S)J",
    "", "", ""
  },
  { "SAMSUNG SpinPoint F3 EG", // tested with HD503HI/1AJ100E4, HD153WI/1AN10002
    "SAMSUNG HD(253G|(324|503)H|754J|105S|(153|203)W)I",
    "", "", ""
  },
  { "SAMSUNG SpinPoint F3 RE", // tested with HE103SJ/1AJ30001
    "SAMSUNG HE(502H|754J|103S)J",
    "", "", ""
  },
  { "SAMSUNG SpinPoint F4 EG (AF)",// tested with HD204UI/1AQ10001(buggy|fixed)
    "SAMSUNG HD(155|204)UI",
    "", // 1AQ10001
    "Using smartmontools or hdparm with this\n"
    "drive may result in data loss due to a firmware bug.\n"
    "****** THIS DRIVE MAY OR MAY NOT BE AFFECTED! ******\n"
    "Buggy and fixed firmware report same version number!\n"
    "See the following web pages for details:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/223571en\n"
    "http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBlocks",
    ""
  },
  { "SAMSUNG SpinPoint S250", // tested with HD200HJ/KF100-06
    "SAMSUNG HD(162|200|250)HJ",
    "", "", ""
  },
  { "SAMSUNG SpinPoint T133", // tested with HD300LJ/ZT100-12, HD400LJ/ZZ100-14, HD401LJ/ZZ100-15
    "SAMSUNG HD(250KD|(30[01]|320|40[01])L[DJ])",
    "", "", ""
  },
  { "SAMSUNG SpinPoint T166", // tested with HD501LJ/CR100-1[01]
    "SAMSUNG HD(080G|160H|32[01]K|403L|50[01]L)J",
    "", "",
    "-v 197,increasing" // at least HD501LJ/CR100-11
  },
  { "SAMSUNG SpinPoint P120", // VF100-37 firmware, tested with SP2514N/VF100-37
    "SAMSUNG SP(16[01]3|2[05][01]4)[CN]",
    "VF100-37",
    "",
    "-F samsung3"
  },
  { "SAMSUNG SpinPoint P120", // other firmware, tested with SP2504C/VT100-33
    "SAMSUNG SP(16[01]3|2[05][01]4)[CN]",
    "",
    "May need -F samsung3 enabled; see manual for details.",
    ""
  },
  { "SAMSUNG SpinPoint P80 SD", // tested with HD160JJ/ZM100-33
    "SAMSUNG HD(080H|120I|160J)J",
    "", "", ""
  },
  { "SAMSUNG SpinPoint P80", // BH100-35 firmware, tested with SP0842N/BH100-35
    "SAMSUNG SP(0451|08[0124]2|12[0145]3|16[0145]4)[CN]",
    "BH100-35",
    "",
    "-F samsung3"
  },
  { "SAMSUNG SpinPoint P80", // firmware *-35 or later
    "SAMSUNG SP(0451|08[0124]2|12[0145]3|16[0145]4)[CN]",
    ".*-3[5-9]",
    "May need -F samsung3 enabled; see manual for details.",
    ""
  },
  { "SAMSUNG SpinPoint P80", // firmware *-25...34, tested with
      // SP0401N/TJ100-30, SP1614C/SW100-25 and -34
    "SAMSUNG SP(04[05]1|08[0124]2|12[0145]3|16[0145]4)[CN]",
    ".*-(2[5-9]|3[0-4])",
    "",
    "-v 9,halfminutes -v 198,increasing"
  },
  { "SAMSUNG SpinPoint P80", // firmware *-23...24, tested with
    // SP0802N/TK100-23,
    // SP1213N/TL100-23,
    // SP1604N/TM100-23 and -24
    "SAMSUNG SP(0451|08[0124]2|12[0145]3|16[0145]4)[CN]",
    ".*-2[34]",
    "",
    "-v 9,halfminutes -F samsung2"
  },
  { "SAMSUNG SpinPoint P80", // unknown firmware
    "SAMSUNG SP(0451|08[0124]2|12[0145]3|16[0145]4)[CN]",
    "",
    "May need -F samsung2 or -F samsung3 enabled; see manual for details.",
    ""
  },
  { "SAMSUNG SpinPoint M40/60/80", // tested with HM120IC/AN100-16, HM160JI/AD100-16
    "SAMSUNG HM(0[468]0H|120I|1[026]0J)[CI]",
    "",
    "",
    "-v 9,halfminutes"
  },
  { "SAMSUNG SpinPoint M5", // tested with HM160HI/HH100-12
    "SAMSUNG HM(((061|080)G|(121|160)H|250J)I|160HC)",
    "", "", ""
  },
  { "SAMSUNG SpinPoint M6", // tested with HM320JI/2SS00_01 M6
    "SAMSUNG HM(251J|320[HJ]|[45]00L)I",
    "", "", ""
  },
  { "SAMSUNG SpinPoint M7", // tested with HM500JI/2AC101C4
    "SAMSUNG HM(250H|320I|[45]00J)I",
    "", "", ""
  },
  { "SAMSUNG SpinPoint M7E (AF)", // tested with HM321HI/2AJ10001, HM641JI/2AJ10001
    "SAMSUNG HM(161G|(251|321)H|501I|641J)I",
    "", "", ""
  },
  { "SAMSUNG SpinPoint M7U (USB)", // tested with HM252HX/2AC101C4
    "SAMSUNG HM(162H|252H|322I|502J)X",
    "", "", ""
  },
  { "SAMSUNG SpinPoint M8 (AF)", // tested with HN-M101MBB/2AR10001
    "SAMSUNG HN-M(250|320|500|640|750|101)MBB",
    "", "", ""
  },
  { "Seagate Momentus SpinPoint M8 (AF)", // tested with
      // ST750LM022 HN-M750MBB/2AR10001, ST320LM001 HN-M320MBB/2AR10002
    "ST(250|320|500|640|750|1000)LM0[012][124] HN-M[0-9]*MBB",
    "", "", ""
  },
  { "SAMSUNG SpinPoint M8U (USB)", // tested with HN-M500XBB/2AR10001
    "SAMSUNG HN-M(320|500|750|101)XBB",
    "", "", ""
  },
  { "Seagate Samsung SpinPoint M8U (USB)", // tested with ST1000LM025 HN-M101ABB/2AR10001
    "ST(250|320|500|640|750|1000)LM0[012][3459] HN-M[0-9]*ABB",
    "", "", ""
  },
  { "SAMSUNG SpinPoint MP5", // tested with HM250HJ/2AK10001
    "SAMSUNG HM(250H|320H|500J|640J)J",
    "", "", ""
  },
  { "SAMSUNG SpinPoint MT2", // tested with HM100UI/2AM10001
    "SAMSUNG HM100UI",
    "", "", ""
  },
  { "SAMSUNG HM100UX (S2 Portable)", // tested with HM100UX/2AM10001
    "SAMSUNG HM100UX",
    "", "", ""
  },
  { "SAMSUNG SpinPoint M", // tested with MP0402H/UC100-11
    "SAMSUNG MP0(302|402|603|804)H",
    "",
    "",
    "-v 9,halfminutes"
  },
  { "SAMSUNG SpinPoint N3U-3 (USB, 4KiB LLS)", // tested with HS25YJZ/3AU10-01
    "SAMSUNG HS(122H|2[05]YJ)Z",
    "", "", ""
  },
  { "Maxtor Fireball 541DX",
    "Maxtor 2B0(0[468]|1[05]|20)H1",
    "",
    "",
    "-v 9,minutes -v 194,unknown"
  },
  { "Maxtor Fireball 3",
    "Maxtor 2F0[234]0[JL]0",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 1280 ATA",  // no self-test log, ATA2-Fast
    "Maxtor 8(1280A2|2160A4|2560A4|3840A6|4000A6|5120A8)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 2160 Ultra ATA",
    "Maxtor 8(2160D2|3228D3|3240D3|4320D4|6480D6|8400D8|8455D8)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 2880 Ultra ATA",
    "Maxtor 9(0510D4|0576D4|0648D5|0720D5|0840D6|0845D6|0864D6|1008D7|1080D8|1152D8)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 3400 Ultra ATA",
    "Maxtor 9(1(360|350|202)D8|1190D7|10[12]0D6|0840D5|06[48]0D4|0510D3|1(350|202)E8|1010E6|0840E5|0640E4)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax D540X-4G",
    "Maxtor 4G(120J6|160J[68])",
    "",
    "",
    "-v 9,minutes -v 194,unknown"
  },
  { "Maxtor DiamondMax D540X-4K",
    "MAXTOR 4K(020H1|040H2|060H3|080H4)",
    "", "", ""
  },
  { "Maxtor DiamondMax Plus D740X",
    "MAXTOR 6L0(20[JL]1|40[JL]2|60[JL]3|80[JL]4)",
    "", "", ""
  },
  { "Maxtor DiamondMax Plus 5120 Ultra ATA 33",
    "Maxtor 9(0512D2|0680D3|0750D3|0913D4|1024D4|1360D6|1536D6|1792D7|2048D8)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax Plus 6800 Ultra ATA 66",
    "Maxtor 9(2732U8|2390U7|204[09]U6|1707U5|1366U4|1024U3|0845U3|0683U2)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax D540X-4D",
    "Maxtor 4D0(20H1|40H2|60H3|80H4)",
    "",
    "",
    "-v 9,minutes -v 194,unknown"
  },
  { "Maxtor DiamondMax 16",
    "Maxtor 4(R0[68]0[JL]0|R1[26]0L0|A160J0|R120L4)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 4320 Ultra ATA",
    "Maxtor (91728D8|91512D7|91303D6|91080D5|90845D4|90645D3|90648D[34]|90432D2)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 17 VL",
    "Maxtor 9(0431U1|0641U2|0871U2|1301U3|1741U4)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 20 VL",
    "Maxtor (94091U8|93071U6|92561U5|92041U4|91731U4|91531U3|91361U3|91021U2|90841U2|90651U2)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax VL 30",  // U: ATA66, H: ATA100
    "Maxtor (33073U4|32049U3|31536U2|30768U1|33073H4|32305H3|31536H2|30768H1)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 36",
    "Maxtor (93652U8|92739U6|91826U4|91369U3|90913U2|90845U2|90435U1)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 40 ATA 66",
    "Maxtor 9(0684U2|1024U2|1362U3|1536U3|2049U4|2562U5|3073U6|4098U8)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax Plus 40 (Ultra ATA 66 and Ultra ATA 100)",
    "Maxtor (54098[UH]8|53073[UH]6|52732[UH]6|52049[UH]4|51536[UH]3|51369[UH]3|51024[UH]2)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 40 VL Ultra ATA 100",
    "Maxtor 3(1024H1|1535H2|2049H2|3073H3|4098H4)( B)?",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax Plus 45 Ulta ATA 100",
    "Maxtor 5(4610H6|4098H6|3073H4|2049H3|1536H2|1369H2|1023H2)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 60 ATA 66",
    "Maxtor 9(1023U2|1536U2|2049U3|2305U3|3073U4|4610U6|6147U8)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 60 ATA 100",
    "Maxtor 9(1023H2|1536H2|2049H3|2305H3|3073H4|4098H6|4610H6|6147H8)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax Plus 60",
    "Maxtor 5T0(60H6|40H4|30H3|20H2|10H1)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 80",
    "Maxtor (98196H8|96147H6)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 536DX",
    "Maxtor 4W(100H6|080H6|060H4|040H3|030H2)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax Plus 8",
    "Maxtor 6(E0[234]|K04)0L0",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 10 (ATA/133 and SATA/150)",
    "Maxtor 6(B(30|25|20|16|12|10|08)0[MPRS]|L(080[MLP]|(100|120)[MP]|160[MP]|200[MPRS]|250[RS]|300[RS]))0",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 10 (SATA/300)",
    "Maxtor 6V(080E|160E|200E|250F|300F|320F)0",
    "", "", ""
  },
  { "Maxtor DiamondMax Plus 9",
    "Maxtor 6Y((060|080|120|160)L0|(060|080|120|160|200|250)P0|(060|080|120|160|200|250)M0)",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor DiamondMax 11",
    "Maxtor 6H[45]00[FR]0",
    "", "", ""
  },
  { "Maxtor DiamondMax 17",
    "Maxtor 6G(080L|160[PE])0",
    "", "", ""
  },
  { "Seagate Maxtor DiamondMax 20",
    "MAXTOR STM3(40|80|160)[28]1[12]0?AS?",
    "", "", ""
  },
  { "Seagate Maxtor DiamondMax 21", // tested with MAXTOR STM3250310AS/3.AAF
    "MAXTOR STM3(80[28]15|160215|250310|(250|320)820|320620|500630)AS?",
    "", "", ""
  },
  { "Seagate Maxtor DiamondMax 22", // fixed firmware
    "(MAXTOR )?STM3(500320|750330|1000340)AS?",
    "MX1A", // http://knowledge.seagate.com/articles/en_US/FAQ/207969en
    "", ""
  },
  { "Seagate Maxtor DiamondMax 22", // fixed firmware
    "(MAXTOR )?STM3(160813|320614|640323|1000334)AS?",
    "MX1B", // http://knowledge.seagate.com/articles/en_US/FAQ/207975en
    "", ""
  },
  { "Seagate Maxtor DiamondMax 22", // buggy firmware
    "(MAXTOR )?STM3(500320|750330|1000340)AS?",
    "MX15",
    "There are known problems with these drives,\n"
    "AND THIS FIRMWARE VERSION IS AFFECTED,\n"
    "see the following Seagate web pages:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207931en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207969en",
    ""
  },
  { "Seagate Maxtor DiamondMax 22", // unknown firmware
    "(MAXTOR )?STM3(160813|32061[34]|500320|640323|750330|10003(34|40))AS?",
    "",
    "There are known problems with these drives,\n"
    "see the following Seagate web pages:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207931en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207969en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207975en",
    ""
  },
  { "Seagate Maxtor DiamondMax 23", // new firmware
    "STM3((160|250)31|(320|500)41|(750|1000)52)8AS?",
    "CC3[D-Z]",
    "", ""
  },
  { "Seagate Maxtor DiamondMax 23", // unknown firmware
    "STM3((160|250)31|(320|500)41|(750|1000)52)8AS?",
    "",
    "A firmware update for this drive may be available,\n"
    "see the following Seagate web pages:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207931en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/213911en",
    ""
  },
  { "Maxtor MaXLine Plus II",
    "Maxtor 7Y250[PM]0",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor MaXLine II",
    "Maxtor [45]A(25|30|32)0[JN]0",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor MaXLine III (ATA/133 and SATA/150)",
    "Maxtor 7L(25|30)0[SR]0",
    "",
    "",
    "-v 9,minutes"
  },
  { "Maxtor MaXLine III (SATA/300)",
    "Maxtor 7V(25|30)0F0",
    "", "", ""
  },
  { "Maxtor MaXLine Pro 500",  // There is also a 7H500R0 model, but I
    "Maxtor 7H500F0",               // haven't added it because I suspect
    "",                               // it might need vendoropts_9_minutes
    "", ""                            // and nobody has submitted a report yet
  },
  { "", // HITACHI_DK14FA-20B
    "HITACHI_DK14FA-20B",
    "",
    "",
    "-v 9,minutes -v 193,loadunload"
  },
  { "HITACHI Travelstar DK23XX/DK23XXB",
    "HITACHI_DK23..-..B?",
    "",
    "",
    "-v 9,minutes -v 193,loadunload"
  },
  { "Hitachi Endurastar J4K20/N4K20 (formerly DK23FA-20J)",
    "(HITACHI_DK23FA-20J|HTA422020F9AT[JN]0)",
    "",
    "",
    "-v 9,minutes -v 193,loadunload"
  },
  { "Hitachi Endurastar J4K30/N4K30",
    "HE[JN]4230[23]0F9AT00",
    "",
    "",
    "-v 9,minutes -v 193,loadunload"
  },
  { "Hitachi Travelstar C4K60",  // 1.8" slim drive
    "HTC4260[23]0G5CE00|HTC4260[56]0G8CE00",
    "",
    "",
    "-v 9,minutes -v 193,loadunload"
  },
  { "IBM Travelstar 4GT",
    "IBM-DTCA-2(324|409)0",
    "", "", ""
  },
  { "IBM Travelstar 6GN",
    "IBM-DBCA-20(324|486|648)0",
    "", "", ""
  },
  { "IBM Travelstar 25GS, 18GT, and 12GN",
    "IBM-DARA-2(25|18|15|12|09|06)000",
    "", "", ""
  },
  { "IBM Travelstar 14GS",
    "IBM-DCYA-214000",
    "", "", ""
  },
  { "IBM Travelstar 4LP",
    "IBM-DTNA-2(180|216)0",
    "", "", ""
  },
  { "IBM Travelstar 48GH, 30GN, and 15GN",
    "(IBM-|Hitachi )?IC25(T048ATDA05|N0(30|20|15|12|10|07|06|05)ATDA04)-.",
    "", "", ""
  },
  { "IBM Travelstar 32GH, 30GT, and 20GN",
    "IBM-DJSA-2(32|30|20|10|05)",
    "", "", ""
  },
  { "IBM Travelstar 4GN",
    "IBM-DKLA-2(216|324|432)0",
    "", "", ""
  },
  { "IBM/Hitachi Travelstar 60GH and 40GN",
    "(IBM-|Hitachi )?IC25(T060ATC[SX]05|N0[4321]0ATC[SX]04)-.",
    "", "", ""
  },
  { "IBM/Hitachi Travelstar 40GNX",
    "(IBM-|Hitachi )?IC25N0[42]0ATC[SX]05-.",
    "", "", ""
  },
  { "Hitachi Travelstar 80GN",
    "(Hitachi )?IC25N0[23468]0ATMR04-.",
    "", "", ""
  },
  { "Hitachi Travelstar 4K40",
    "(Hitachi )?HTS4240[234]0M9AT00",
    "", "", ""
  },
  { "Hitachi Travelstar 4K120",
    "(Hitachi )?(HTS4212(60|80|10|12)H9AT00|HTS421260G9AT00)",
    "", "", ""
  },
  { "Hitachi Travelstar 5K80",
    "(Hitachi )?HTS5480[8642]0M9AT00",
    "", "", ""
  },
  { "Hitachi Travelstar 5K100",
    "(Hitachi )?HTS5410[1864]0G9(AT|SA)00",
    "", "", ""
  },
  { "Hitachi Travelstar E5K100",
    "(Hitachi )?HTE541040G9(AT|SA)00",
    "", "", ""
  },
  { "Hitachi Travelstar 5K120",
    "(Hitachi )?HTS5412(60|80|10|12)H9(AT|SA)00",
    "", "", ""
  },
  { "Hitachi Travelstar 5K160",
    "(Hitachi |HITACHI )?HTS5416([468]0|1[26])J9(AT|SA)00",
    "", "", ""
  },
  { "Hitachi Travelstar E5K160",
    "(Hitachi )?HTE5416(12|16|60|80)J9(AT|SA)00",
    "", "", ""
  },
  { "Hitachi Travelstar 5K250",
    "(Hitachi |HITACHI )?HTS5425(80|12|16|20|25)K9(A3|SA)00",
    "", "", ""
  },
  { "Hitachi Travelstar 5K320", // tested with HITACHI HTS543232L9SA00/FB4ZC4EC,
    // Hitachi HTS543212L9SA02/FBBAC52F
    "(Hitachi |HITACHI )?HT(S|E)5432(80|12|16|25|32)L9(A3(00)?|SA0[012])",
    "", "", ""
  },
  { "Hitachi Travelstar 5K500.B",
    "(Hitachi )?HT[ES]5450(12|16|25|32|40|50)B9A30[01]",
    "", "", ""
  },
  { "Hitachi/HGST Travelstar Z5K500", // tested with HGST HTS545050A7E380/GG2OAC90
    "HGST HT[ES]5450(25|32|50)A7E38[01]",
    "", "", ""
  },
  { "Hitachi/HGST Travelstar 5K750", // tested with Hitachi HTS547575A9E384/JE4OA60A,
       // APPLE HDD HTS547550A9E384/JE3AD70F
    "(Hitachi|APPLE HDD) HT[ES]5475(50|64|75)A9E38[14]",
    "", "", ""
  },
  { "Hitachi Travelstar 7K60",
    "(Hitachi )?HTS726060M9AT00",
    "", "", ""
  },
  { "Hitachi Travelstar E7K60",
    "(Hitachi )?HTE7260[46]0M9AT00",
    "", "", ""
  },
  { "Hitachi Travelstar 7K100",
    "(Hitachi )?HTS7210[168]0G9(AT|SA)00",
    "", "", ""
  },
  { "Hitachi Travelstar E7K100",
    "(Hitachi )?HTE7210[168]0G9(AT|SA)00",
    "", "", ""
  },
  { "Hitachi Travelstar 7K200", // tested with HITACHI HTS722016K9SA00/DCDZC75A
    "(Hitachi |HITACHI )?HTS7220(80|10|12|16|20)K9(A3|SA)00",
    "", "", ""
  },
  { "Hitachi Travelstar 7K320", // tested with
    // HTS723225L9A360/FCDOC30F, HTS723216L9A362/FC2OC39F
    "(Hitachi )?HT[ES]7232(80|12|16|25|32)L9(A300|A36[02]|SA61)",
    "", "", ""
  },
  { "Hitachi Travelstar Z7K320", // tested with HITACHI HTS723232A7A364/EC2ZB70B
    "(HITACHI )?HT[ES]7232(16|25|32)A7A36[145]",
    "", "", ""
  },
  { "Hitachi Travelstar 7K500",
    "(Hitachi )?HT[ES]7250(12|16|25|32|50)A9A36[2-5]",
    "", "", ""
  },
  { "Hitachi/HGST Travelstar Z7K500", // tested with HITACHI HTS725050A7E630/GH2ZB390,
      // HGST HTS725050A7E630/GH2OA420
    "(HITACHI|HGST) HT[ES]7250(25|32|50)A7E63[015]",
    "", "", ""
  },
  { "Hitachi/HGST Travelstar 7K750", // tested with Hitachi HTS727550A9E364/JF3OA0E0,
      // Hitachi HTS727575A9E364/JF4OA0D0
    "(Hitachi|HGST) HT[ES]7275(50|64|75)A9E36[14]",
    "", "", ""
  },
  { "HGST Travelstar 7K1000", // tested with HGST HTS721010A9E630/JB0OA3B0
    "HGST HTS721010A9E630",
    "", "", ""
  },
  { "IBM Deskstar 14GXP and 16GP",
    "IBM-DTTA-3(7101|7129|7144|5032|5043|5064|5084|5101|5129|5168)0",
    "", "", ""
  },
  { "IBM Deskstar 25GP and 22GXP",
    "IBM-DJNA-3(5(101|152|203|250)|7(091|135|180|220))0",
    "", "", ""
  },
  { "IBM Deskstar 37GP and 34GXP",
    "IBM-DPTA-3(5(375|300|225|150)|7(342|273|205|136))0",
    "", "", ""
  },
  { "IBM/Hitachi Deskstar 120GXP",
    "(IBM-)?IC35L((020|040|060|080|120)AVVA|0[24]0AVVN)07-[01]",
    "", "", ""
  },
  { "IBM/Hitachi Deskstar GXP-180",
    "(IBM-)?IC35L(030|060|090|120|180)AVV207-[01]",
    "", "", ""
  },
  { "Hitachi Deskstar 5K3000", // tested with HDS5C3030ALA630/MEAOA5C0,
       // Hitachi HDS5C3020BLE630/MZ4OAAB0 (OEM, Toshiba Canvio Desktop)
    "(Hitachi )?HDS5C30(15|20|30)(ALA|BLE)63[02].*",
    "", "", ""
  },
  { "Hitachi Deskstar 5K4000", // tested with HDS5C4040ALE630/MPAOA250
    "(Hitachi )?HDS5C40(30|40)ALE63[01].*",
    "", "", ""
  },
  { "Hitachi Deskstar 7K80",
    "(Hitachi )?HDS7280([48]0PLAT20|(40)?PLA320|80PLA380).*",
    "", "", ""
  },
  { "Hitachi Deskstar 7K160",
    "(Hitachi )?HDS7216(80|16)PLA[3T]80.*",
    "", "", ""
  },
  { "Hitachi Deskstar 7K250",
    "(Hitachi )?HDS7225((40|80|12|16)VLAT20|(12|16|25)VLAT80|(80|12|16|25)VLSA80)",
    "", "", ""
  },
  { "Hitachi Deskstar 7K250 (SUN branded)",
    "HITACHI HDS7225SBSUN250G.*",
    "", "", ""
  },
  { "Hitachi Deskstar T7K250",
    "(Hitachi )?HDT7225((25|20|16)DLA(T80|380))",
    "", "", ""
  },
  { "Hitachi Deskstar 7K400",
    "(Hitachi )?HDS724040KL(AT|SA)80",
    "", "", ""
  },
  { "Hitachi Deskstar 7K500",
    "(Hitachi )?HDS725050KLA(360|T80)",
    "", "", ""
  },
  { "Hitachi Deskstar P7K500",
    "(Hitachi )?HDP7250(16|25|32|40|50)GLA(36|38|T8)0",
    "", "", ""
  },
  { "Hitachi Deskstar T7K500",
    "(Hitachi )?HDT7250(25|32|40|50)VLA(360|380|T80)",
    "", "", ""
  },
  { "Hitachi Deskstar 7K1000",
    "(Hitachi )?HDS7210(50|75|10)KLA330",
    "", "", ""
  },
  { "Hitachi Deskstar 7K1000.B",
    "(Hitachi )?HDT7210((16|25)SLA380|(32|50|64|75|10)SLA360)",
    "", "", ""
  },
  { "Hitachi Deskstar 7K1000.C", // tested with Hitachi HDS721010CLA330/JP4OA3MA
    "(Hitachi )?HDS7210((16|25)CLA382|(32|50)CLA362|(64|75|10)CLA33[02])",
    "", "", ""
  },
  { "Hitachi Deskstar 7K1000.D", // tested with HDS721010DLE630/MS2OA5Q0
    "Hitachi HDS7210(25|32|50|75|10)DLE630",
    "", "", ""
  },
  { "Hitachi Deskstar E7K1000", // tested with HDE721010SLA330/ST6OA31B
    "Hitachi HDE7210(50|75|10)SLA330",
    "", "", ""
  },
  { "Hitachi Deskstar 7K2000",
    "Hitachi HDS722020ALA330",
    "", "", ""
  },
  { "Hitachi Deskstar 7K3000", // tested with HDS723030ALA640/MKAOA3B0
    "Hitachi HDS7230((15|20)BLA642|30ALA640)",
    "", "", ""
  },
  { "Hitachi/HGST Deskstar 7K4000", // tested with Hitachi HDS724040ALE640/MJAOA250
    "Hitachi HDS724040ALE640",
    "", "", ""
  },
  { "Hitachi Ultrastar A7K1000", // tested with
    // HUA721010KLA330      44X2459 42C0424IBM/GKAOAB4A
    "(Hitachi )?HUA7210(50|75|10)KLA330.*",
    "", "", ""
  },
  { "Hitachi Ultrastar A7K2000", // tested with
    // HUA722010CLA330      43W7629 42C0401IBM
    "(Hitachi )?HUA7220(50|10|20)[AC]LA33[01].*",
    "", "", ""
  },
  { "Hitachi Ultrastar 7K3000", // tested with HUA723030ALA640/MKAOA580
    "Hitachi HUA7230(20|30)ALA640",
    "", "", ""
  },
  { "Hitachi Ultrastar 7K4000", // tested with Hitachi HUS724040ALE640/MJAOA3B0
    "Hitachi HUS7240(20|30|40)ALE640",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD (10-20 GB)",
    "TOSHIBA MK(101[67]GAP|15[67]GAP|20(1[678]GAP|(18|23)GAS))",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD (30-60 GB)",
    "TOSHIBA MK((6034|4032)GSX|(6034|4032)GAX|(6026|4026|4019|3019)GAXB?|(6025|6021|4025|4021|4018|3025|3021|3018)GAS|(4036|3029)GACE?|(4018|3017)GAP)",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD (80 GB and above)",
    "TOSHIBA MK(80(25GAS|26GAX|32GAX|32GSX)|10(31GAS|32GAX)|12(33GAS|34G[AS]X)|2035GSS)",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD MK..37GSX", // tested with TOSHIBA MK1637GSX/DL032C
    "TOSHIBA MK(12|16)37GSX",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD MK..46GSX", // tested with TOSHIBA MK1246GSX/LB213M
    "TOSHIBA MK(80|12|16|25)46GSX",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD MK..50GACY", // tested with TOSHIBA MK8050GACY/TF105A
    "TOSHIBA MK8050GACY",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD MK..52GSX",
    "TOSHIBA MK(80|12|16|25|32)52GSX",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD MK..55GSX", // tested with TOSHIBA MK5055GSX/FG001A, MK3255GSXF/FH115B
    "TOSHIBA MK(12|16|25|32|40|50)55GSXF?",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD MK..56GSY", // tested with TOSHIBA MK2556GSYF/LJ001D
    "TOSHIBA MK(16|25|32|50)56GSYF?",
    "",
    "",
    "-v 9,minutes"
  },
  { "Toshiba 2.5\" HDD MK..59GSXP (AF)",
    "TOSHIBA MK(32|50|64|75)59GSXP?",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD MK..59GSM (AF)",
    "TOSHIBA MK(75|10)59GSM",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD MK..61GSY[N]", // tested with TOSHIBA MK5061GSY/MC102E, MK5061GSYN/MH000A
    "TOSHIBA MK(16|25|32|50|64)61GSYN?",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD MK..65GSX", // tested with TOSHIBA MK5065GSX/GJ003A, MK3265GSXN/GH012H,
      // MK5065GSXF/GP006B
    "TOSHIBA MK(16|25|32|50|64)65GSX[FN]?",
    "", "", ""
  },
  { "Toshiba 2.5\" HDD MK..76GSX", // tested with TOSHIBA MK3276GSX/GS002D
    "TOSHIBA MK(16|25|32|50|64)76GSX",
    "",
    "",
    "-v 9,minutes"
  },
  { "Toshiba 2.5\" HDD MQ01ABD...", // tested with TOSHIBA MQ01ABD100/AX001U
    "TOSHIBA MQ01ABD(025|032|050|064|075|100)",
    "", "", ""
  },
  { "Toshiba 3.5\" HDD MK.002TSKB", // tested with TOSHIBA MK1002TSKB/MT1A
    "TOSHIBA MK(10|20)02TSKB",
    "", "", ""
  },
  { "Toshiba 3.5\" HDD DT01ACA...", // tested with TOSHIBA DT01ACA100/MS2OA750,
      // TOSHIBA DT01ACA200/MX4OABB0, TOSHIBA DT01ACA300/MX6OABB0
    "TOSHIBA DT01ACA(025|032|050|075|100|150|200|300)",
    "", "", ""
  },
  { "Toshiba 1.8\" HDD",
    "TOSHIBA MK[23468]00[4-9]GA[HL]",
    "", "", ""
  },
  { "Toshiba 1.8\" HDD MK..29GSG",
    "TOSHIBA MK(12|16|25)29GSG",
    "", "", ""
  },
  { "", // TOSHIBA MK6022GAX
    "TOSHIBA MK6022GAX",
    "", "", ""
  },
  { "", // TOSHIBA MK6409MAV
    "TOSHIBA MK6409MAV",
    "", "", ""
  },
  { "Toshiba MKx019GAXB (SUN branded)",
    "TOS MK[34]019GAXB SUN[34]0G",
    "", "", ""
  },
  { "Seagate Momentus",
    "ST9(20|28|40|48)11A",
    "", "", ""
  },
  { "Seagate Momentus 42",
    "ST9(2014|3015|4019)A",
    "", "", ""
  },
  { "Seagate Momentus 4200.2", // tested with ST960812A/3.05
    "ST9(100822|808210|60812|50212|402113|30219)A",
    "", "", ""
  },
  { "Seagate Momentus 5400.2",
    "ST9(808211|6082[12]|408114|308110|120821|10082[34]|8823|6812|4813|3811)AS?",
    "", "", ""
  },
  { "Seagate Momentus 5400.3",
    "ST9(4081[45]|6081[35]|8081[15]|100828|120822|160821)AS?",
    "", "", ""
  },
  { "Seagate Momentus 5400.3 ED",
    "ST9(4081[45]|6081[35]|8081[15]|100828|120822|160821)AB",
    "", "", ""
  },
  { "Seagate Momentus 5400.4",
    "ST9(120817|(160|200|250)827)AS",
    "", "", ""
  },
  { "Seagate Momentus 5400.5",
    "ST9((80|120|160)310|(250|320)320)AS",
    "", "", ""
  },
  { "Seagate Momentus 5400.6",
    "ST9(80313|160(301|314)|(12|25)0315|250317|(320|500)325|500327|640320)ASG?",
    "", "", ""
  },
  { "Seagate Momentus 5400.7",
    "ST9(160316|(250|320)310|(500|640)320)AS",
    "", "", ""
  },
  { "Seagate Momentus 5400.7 (AF)", // tested with ST9640322AS/0001BSM2
      // (device reports 4KiB LPS with 1 sector offset)
    "ST9(320312|400321|640322|750423)AS",
    "", "", ""
  },
  { "Seagate Momentus 5400 PSD", // Hybrid drives
    "ST9(808212|(120|160)8220)AS",
    "", "", ""
  },
  { "Seagate Momentus 7200.1",
    "ST9(10021|80825|6023|4015)AS?",
    "", "", ""
  },
  { "Seagate Momentus 7200.2",
    "ST9(80813|100821|120823|160823|200420)ASG?",
    "", "", ""
  },
  { "Seagate Momentus 7200.3",
    "ST9((80|120|160)411|(250|320)421)ASG?",
    "", "", ""
  },
  { "Seagate Momentus 7200.4",
    "ST9(160412|250410|320423|500420)ASG?",
    "", "", ""
  },
  { "Seagate Momentus 7200 FDE.2",
    "ST9((160413|25041[12]|320426|50042[12])AS|(16041[489]|2504[16]4|32042[67]|500426)ASG)",
    "", "", ""
  },
  { "Seagate Momentus 7200.5", // tested with ST9750420AS/0001SDM5, ST9750420AS/0002SDM1
    "ST9(50042[34]|64042[012]|75042[02])ASG?",
    "", "", ""
  },
  { "Seagate Momentus XT", // fixed firmware
    "ST9(2505610|3205620|5005620)AS",
    "SD2[68]", // http://knowledge.seagate.com/articles/en_US/FAQ/215451en
    "", ""
  },
  { "Seagate Momentus XT", // buggy firmware, tested with ST92505610AS/SD24
    "ST9(2505610|3205620|5005620)AS",
    "SD2[45]",
    "These drives may corrupt large files,\n"
    "AND THIS FIRMWARE VERSION IS AFFECTED,\n"
    "see the following web pages for details:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/215451en\n"
    "http://forums.seagate.com/t5/Momentus-XT-Momentus-Momentus/Momentus-XT-corrupting-large-files-Linux/td-p/109008\n"
    "http://superuser.com/questions/313447/seagate-momentus-xt-corrupting-files-linux-and-mac",
    ""
  },
  { "Seagate Momentus XT", // unknown firmware
    "ST9(2505610|3205620|5005620)AS",
    "",
    "These drives may corrupt large files,\n"
    "see the following web pages for details:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/215451en\n"
    "http://forums.seagate.com/t5/Momentus-XT-Momentus-Momentus/Momentus-XT-corrupting-large-files-Linux/td-p/109008\n"
    "http://superuser.com/questions/313447/seagate-momentus-xt-corrupting-files-linux-and-mac",
    ""
  },
  { "Seagate Momentus XT (AF)", // tested with ST750LX003-1AC154/SM12
    "ST750LX003-.*",
    "", "", ""
  },
  { "Seagate Momentus Thin", // tested with ST320LT007-9ZV142/0004LVM1
    "ST(160|250|320)LT0(07|09|11|14)-.*",
    "", "", ""
  },
  { "Seagate Laptop SSHD", // tested with ST500LM000-1EJ162/SM11
    "ST(500|1000)LM0(00|14)-.*",
    "", "", ""
  },
  { "Seagate Medalist 1010, 1720, 1721, 2120, 3230 and 4340",  // ATA2, with -t permissive
    "ST3(1010|1720|1721|2120|3230|4340)A",
    "", "", ""
  },
  { "Seagate Medalist 2110, 3221, 4321, 6531, and 8641",
    "ST3(2110|3221|4321|6531|8641)A",
    "", "", ""
  },
  { "Seagate U4",
    "ST3(2112|4311|6421|8421)A",
    "", "", ""
  },
  { "Seagate U5",
    "ST3(40823|30621|20413|15311|10211)A",
    "", "", ""
  },
  { "Seagate U6",
    "ST3(8002|6002|4081|3061|2041)0A",
    "", "", ""
  },
  { "Seagate U7",
    "ST3(30012|40012|60012|80022|120020)A",
    "", "", ""
  },
  { "Seagate U8",
    "ST3(4313|6811|8410|4313|13021|17221)A",
    "", "", ""
  },
  { "Seagate U9", // tested with ST3160022ACE/9.51
    "ST3(80012|120025|160022)A(CE)?",
    "", "", ""
  },
  { "Seagate U10",
    "ST3(20423|15323|10212)A",
    "", "", ""
  },
  { "Seagate UX",
    "ST3(10014A(CE)?|20014A)",
    "", "", ""
  },
  { "Seagate Barracuda ATA",
    "ST3(2804|2724|2043|1362|1022|681)0A",
    "", "", ""
  },
  { "Seagate Barracuda ATA II",
    "ST3(3063|2042|1532|1021)0A",
    "", "", ""
  },
  { "Seagate Barracuda ATA III",
    "ST3(40824|30620|20414|15310|10215)A",
    "", "", ""
  },
  { "Seagate Barracuda ATA IV",
    "ST3(20011|30011|40016|60021|80021)A",
    "", "", ""
  },
  { "Seagate Barracuda ATA V",
    "ST3(12002(3A|4A|9A|3AS)|800(23A|15A|23AS)|60(015A|210A)|40017A)",
    "", "", ""
  },
  { "Seagate Barracuda 5400.1",
    "ST340015A",
    "", "", ""
  },
  { "Seagate Barracuda 7200.7 and 7200.7 Plus", // tested with "ST380819AS          39M3701 39M0171 IBM"/3.03
    "ST3(200021A|200822AS?|16002[13]AS?|12002[26]AS?|1[26]082[78]AS|8001[13]AS?|8081[79]AS|60014A|40111AS|40014AS?)( .* IBM)?",
    "", "", ""
  },
  { "Seagate Barracuda 7200.8",
    "ST3(400[68]32|300[68]31|250[68]23|200826)AS?",
    "", "", ""
  },
  { "Seagate Barracuda 7200.9",
    "ST3(402111?|80[28]110?|120[28]1[0134]|160[28]1[012]|200827|250[68]24|300[68]22|(320|400)[68]33|500[68](32|41))AS?.*",
    "", "", ""
  },
  { "Seagate Barracuda 7200.10",
    "ST3((80|160)[28]15|200820|250[34]10|(250|300|320|400)[68]20|360320|500[68]30|750[68]40)AS?",
    "", "", ""
  },
  { "Seagate Barracuda 7200.11", // unaffected firmware
    "ST3(160813|320[68]13|500[368]20|640[36]23|640[35]30|750[36]30|1000(333|[36]40)|1500341)AS?",
    "CC.?.?", // http://knowledge.seagate.com/articles/en_US/FAQ/207957en
    "", ""
  },
  { "Seagate Barracuda 7200.11", // fixed firmware
    "ST3(500[368]20|750[36]30|1000340)AS?",
    "SD1A", // http://knowledge.seagate.com/articles/en_US/FAQ/207951en
    "", ""
  },
  { "Seagate Barracuda 7200.11", // fixed firmware
    "ST3(160813|320[68]13|640[36]23|1000333|1500341)AS?",
    "SD[12]B", // http://knowledge.seagate.com/articles/en_US/FAQ/207957en
    "", ""
  },
  { "Seagate Barracuda 7200.11", // buggy or fixed firmware
    "ST3(500[368]20|640[35]30|750[36]30|1000340)AS?",
    "(AD14|SD1[5-9]|SD81)",
    "There are known problems with these drives,\n"
    "THIS DRIVE MAY OR MAY NOT BE AFFECTED,\n"
    "see the following web pages for details:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207931en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207951en\n"
    "http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=632758",
    ""
  },
  { "Seagate Barracuda 7200.11", // unknown firmware
    "ST3(160813|320[68]13|500[368]20|640[36]23|640[35]30|750[36]30|1000(333|[36]40)|1500341)AS?",
    "",
    "There are known problems with these drives,\n"
    "see the following Seagate web pages:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207931en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207951en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207957en",
    ""
  },
  { "Seagate Barracuda 7200.12", // new firmware
    "ST3(160318|250318|320418|50041[08]|750528|1000528)AS",
    "CC4[9A-Z]",
    "", ""
  },
  { "Seagate Barracuda 7200.12", // unknown firmware
    "ST3(160318|250318|320418|50041[08]|750528|1000528)AS",
    "",
    "A firmware update for this drive may be available,\n"
    "see the following Seagate web pages:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207931en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/213891en",
    ""
  },
  { "Seagate Barracuda 7200.12", // tested with ST3250312AS/JC45, ST31000524AS/JC45,
      // ST3500413AS/JC4B, ST3750525AS/JC4B
    "ST3(160318|25031[128]|320418|50041[038]|750(518|52[358])|100052[348])AS",
    "", "", ""
  },
  { "Seagate Barracuda XT", // tested with ST32000641AS/CC13,
      // ST4000DX000-1C5160/CC42
    "ST(3(2000641|3000651)AS|4000DX000-.*)",
    "", "", ""
  },
  { "Seagate Barracuda 7200.14 (AF)", // new firmware, tested with
      // ST3000DM001-9YN166/CC4H, ST3000DM001-9YN166/CC9E
    "ST(1000|1500|2000|2500|3000)DM00[1-3]-.*",
    "CC(4[H-Z]|[5-9A-Z]..*)", // >= "CC4H"
    "",
    "-v 188,raw16 -v 240,msec24hour32" // tested with ST3000DM001-9YN166/CC4H
  },
  { "Seagate Barracuda 7200.14 (AF)", // old firmware, tested with
      // ST1000DM003-9YN162/CC46
    "ST(1000|1500|2000|2500|3000)DM00[1-3]-.*",
    "CC4[679CG]",
    "A firmware update for this drive is available,\n"
    "see the following Seagate web pages:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207931en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/223651en",
    "-v 188,raw16 -v 240,msec24hour32"
  },
  { "Seagate Barracuda 7200.14 (AF)", // unknown firmware
    "ST(1000|1500|2000|2500|3000)DM00[1-3]-.*",
    "",
    "A firmware update for this drive may be available,\n"
    "see the following Seagate web pages:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207931en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/223651en",
    "-v 188,raw16 -v 240,msec24hour32"
  },
  { "Seagate Barracuda 7200.14 (AF)", // < 1TB, tested with ST250DM000-1BC141
    "ST(250|320|500|750)DM00[0-3]-.*",
    "", "",
    "-v 188,raw16 -v 240,msec24hour32"
  },
  { "Seagate Desktop HDD.15", // tested with ST4000DM000-1CD168/CC43
    "ST4000DM000-.*",
    "", "",
    "-v 188,raw16 -v 240,msec24hour32"
  },
  { "Seagate Barracuda LP", // new firmware
    "ST3(500412|1000520|1500541|2000542)AS",
    "CC3[5-9A-Z]",
    "",
    "" // -F xerrorlba ?
  },
  { "Seagate Barracuda LP", // unknown firmware
    "ST3(500412|1000520|1500541|2000542)AS",
    "",
    "A firmware update for this drive may be available,\n"
    "see the following Seagate web pages:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207931en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/213915en",
    "-F xerrorlba" // tested with ST31000520AS/CC32
  },
  { "Seagate Barracuda Green (AF)", // new firmware
    "ST((10|15|20)00DL00[123])-.*",
    "CC3[2-9A-Z]",
    "", ""
  },
  { "Seagate Barracuda Green (AF)", // unknown firmware
    "ST((10|15|20)00DL00[123])-.*",
    "",
    "A firmware update for this drive may be available,\n"
    "see the following Seagate web pages:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207931en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/218171en",
    ""
  },
  { "Seagate Barracuda ES",
    "ST3(250[68]2|32062|40062|50063|75064)0NS",
    "", "", ""
  },
  { "Seagate Barracuda ES.2", // fixed firmware
    "ST3(25031|50032|75033|100034)0NS",
    "SN[01]6|"         // http://knowledge.seagate.com/articles/en_US/FAQ/207963en
    "MA(0[^7]|[^0].)", // http://dellfirmware.seagate.com/dell_firmware/DellFirmwareRequest.jsp
    "",
    "-F xerrorlba" // tested with ST31000340NS/SN06
  },
  { "Seagate Barracuda ES.2", // buggy firmware (Dell)
    "ST3(25031|50032|75033|100034)0NS",
    "MA07",
    "There are known problems with these drives,\n"
    "AND THIS FIRMWARE VERSION IS AFFECTED,\n"
    "see the following Seagate web page:\n"
    "http://dellfirmware.seagate.com/dell_firmware/DellFirmwareRequest.jsp",
    ""
  },
  { "Seagate Barracuda ES.2", // unknown firmware
    "ST3(25031|50032|75033|100034)0NS",
    "",
    "There are known problems with these drives,\n"
    "see the following Seagate web pages:\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207931en\n"
    "http://knowledge.seagate.com/articles/en_US/FAQ/207963en",
    ""
  },
  { "Seagate Constellation (SATA)", // tested with ST9500530NS/SN03
    "ST9(160511|500530)NS",
    "", "", ""
  },
  { "Seagate Constellation ES (SATA)", // tested with ST31000524NS/SN11
    "ST3(50051|100052|200064)4NS",
    "", "", ""
  },
  { "Seagate Constellation ES (SATA 6Gb/s)", // tested with ST1000NM0011/SN02
    "ST(5|10|20)00NM0011",
    "", "", ""
  },
  { "Seagate Constellation ES.2 (SATA 6Gb/s)", // tested with ST32000645NS/0004, ST33000650NS
    "ST3(2000645|300065[012])NS",
    "", "", ""
  },
  { "Seagate Constellation ES.3", // tested with ST1000NM0033-9ZM173/0001, ST4000NM0033-9ZM170/SN03
    "ST[1234]000NM00[35]3-.*",
    "", "", ""
  },
  { "Seagate Pipeline HD 5900.1",
    "ST3(160310|320[34]10|500(321|422))CS",
    "", "", ""
  },
  { "Seagate Pipeline HD 5900.2", // tested with ST31000322CS/SC13
    "ST3(160316|250[34]12|320(311|413)|500(312|414)|1000(322|424))CS",
    "", "", ""
  },
  { "Seagate Medalist 17240, 13030, 10231, 8420, and 4310",
    "ST3(17240|13030|10231|8420|4310)A",
    "", "", ""
  },
  { "Seagate Medalist 17242, 13032, 10232, 8422, and 4312",
    "ST3(1724|1303|1023|842|431)2A",
    "", "", ""
  },
  { "Seagate NL35",
    "ST3(250623|250823|400632|400832|250824|250624|400633|400833|500641|500841)NS",
    "", "", ""
  },
  { "Seagate SV35.2",
    "ST3(160815|250820|320620|500630|750640)[AS]V",
    "", "", ""
  },
  { "Seagate SV35.5", // tested with ST31000525SV/CV12
    "ST3(250311|500410|1000525)SV",
    "", "", ""
  },
  { "Seagate SV35", // tested with ST2000VX000-9YW164/CV12
    "ST([123]000VX00[20]|31000526SV|3500411SV)(-.*)?",
    "", "", ""
  },
  { "Seagate DB35", // tested with ST3250823ACE/3.03
    "ST3(200826|250823|300831|400832)ACE",
    "", "", ""
  },
  { "Seagate DB35.2", // tested with ST3160212SCE/3.ACB
    "ST3(802110|120213|160212|200827|250824|300822|400833|500841)[AS]CE",
    "", "", ""
  },
  { "Seagate DB35.3",
    "ST3(750640SCE|((80|160)215|(250|320|400)820|500830|750840)[AS]CE)",
    "", "", ""
  },
  { "Seagate LD25.2", // tested with ST940210AS/3.ALC
    "ST9(40|80)210AS?",
    "", "", ""
  },
  { "Seagate ST1.2 CompactFlash", // tested with ST68022CF/3.01
    "ST6[468]022CF",
    "", "", ""
  },
  { "Western Digital Protege",
  /* Western Digital drives with this comment all appear to use Attribute 9 in
   * a  non-standard manner.  These entries may need to be updated when it
   * is understood exactly how Attribute 9 should be interpreted.
   * UPDATE: this is probably explained by the WD firmware bug described in the
   * smartmontools FAQ */
    "WDC WD([2468]00E|1[26]00A)B-.*",
    "", "", ""
  },
  { "Western Digital Caviar",
  /* Western Digital drives with this comment all appear to use Attribute 9 in
   * a  non-standard manner.  These entries may need to be updated when it
   * is understood exactly how Attribute 9 should be interpreted.
   * UPDATE: this is probably explained by the WD firmware bug described in the
   * smartmontools FAQ */
    "WDC WD(2|3|4|6|8|10|12|16|18|20|25)00BB-.*",
    "", "", ""
  },
  { "Western Digital Caviar WDxxxAB",
  /* Western Digital drives with this comment all appear to use Attribute 9 in
   * a  non-standard manner.  These entries may need to be updated when it
   * is understood exactly how Attribute 9 should be interpreted.
   * UPDATE: this is probably explained by the WD firmware bug described in the
   * smartmontools FAQ */
    "WDC WD(3|4|6|8|25)00AB-.*",
    "", "", ""
  },
  { "Western Digital Caviar WDxxxAA",
  /* Western Digital drives with this comment all appear to use Attribute 9 in
   * a  non-standard manner.  These entries may need to be updated when it
   * is understood exactly how Attribute 9 should be interpreted.
   * UPDATE: this is probably explained by the WD firmware bug described in the
   * smartmontools FAQ */
    "WDC WD...?AA(-.*)?",
    "", "", ""
  },
  { "Western Digital Caviar WDxxxBA",
  /* Western Digital drives with this comment all appear to use Attribute 9 in
   * a  non-standard manner.  These entries may need to be updated when it
   * is understood exactly how Attribute 9 should be interpreted.
   * UPDATE: this is probably explained by the WD firmware bug described in the
   * smartmontools FAQ */
    "WDC WD...BA",
    "", "", ""
  },
  { "Western Digital Caviar AC", // add only 5400rpm/7200rpm (ata33 and faster)
    "WDC AC((116|121|125|225|132|232)|([1-4][4-9][0-9])|([1-4][0-9][0-9][0-9]))00[A-Z]?.*",
    "", "", ""
  },
  { "Western Digital Caviar SE",
  /* Western Digital drives with this comment all appear to use Attribute 9 in
   * a  non-standard manner.  These entries may need to be updated when it
   * is understood exactly how Attribute 9 should be interpreted.
   * UPDATE: this is probably explained by the WD firmware bug described in the
   * smartmontools FAQ
   * UPDATE 2: this does not apply to more recent models, at least WD3200AAJB */
    "WDC WD(4|6|8|10|12|16|18|20|25|30|32|40|50)00(JB|PB)-.*",
    "", "", ""
  },
  { "Western Digital Caviar Blue EIDE",  // WD Caviar SE EIDE
    /* not completely accurate: at least also WD800JB, WD(4|8|20|25)00BB sold as Caviar Blue */
    "WDC WD(16|25|32|40|50)00AAJB-.*",
    "", "", ""
  },
  { "Western Digital Caviar Blue EIDE",  // WD Caviar SE16 EIDE
    "WDC WD(25|32|40|50)00AAKB-.*",
    "", "", ""
  },
  { "Western Digital RE EIDE",
    "WDC WD(12|16|25|32)00SB-.*",
    "", "", ""
  },
  { "Western Digital Caviar Serial ATA",
    "WDC WD(4|8|20|32)00BD-.*",
    "", "", ""
  },
  { "Western Digital Caviar SE Serial ATA", // tested with WDC WD3000JD-98KLB0/08.05J08
    "WDC WD(4|8|12|16|20|25|30|32|40)00(JD|KD|PD)-.*",
    "", "", ""
  },
  { "Western Digital Caviar SE Serial ATA",
    "WDC WD(8|12|16|20|25|30|32|40|50)00JS-.*",
    "", "", ""
  },
  { "Western Digital Caviar SE16 Serial ATA",
    "WDC WD(16|20|25|32|40|50|75)00KS-.*",
    "", "", ""
  },
  { "Western Digital Caviar Blue Serial ATA",  // WD Caviar SE Serial ATA
    /* not completely accurate: at least also WD800BD, (4|8)00JD sold as Caviar Blue */
    "WDC WD((8|12|16|25|32)00AABS|(8|12|16|25|32|40|50)00AAJS)-.*",
    "", "", ""
  },
  { "Western Digital Caviar Blue (SATA)",  // WD Caviar SE16 Serial ATA
      // tested with WD1602ABKS-18N8A0/DELL/02.03B04
    "WDC WD((16|20|25|32|40|50|64|75)00AAKS|1602ABKS|10EALS)-.*",
    "", "", ""
  },
  { "Western Digital Caviar Blue (SATA 6Gb/s)", // tested with WDC WD10EZEX-00RKKA0/80.00A80
    "WDC WD((25|32|50)00AAKX|7500AALX|10EALX|10EZEX)-.*",
    "", "", ""
  },
  { "Western Digital RE Serial ATA",
    "WDC WD(12|16|25|32)00(SD|YD|YS)-.*",
    "", "", ""
  },
  { "Western Digital RE2 Serial ATA",
    "WDC WD((40|50|75)00(YR|YS|AYYS)|(16|32|40|50)0[01]ABYS)-.*",
    "", "", ""
  },
  { "Western Digital RE2-GP",
    "WDC WD(5000AB|7500AY|1000FY)PS-.*",
    "", "", ""
  },
  { "Western Digital RE3 Serial ATA", // tested with WDC WD7502ABYS-02A6B0/03.00C06
    "WDC WD((25|32|50|75)02A|(75|10)02F)BYS-.*",
    "", "", ""
  },
  { "Western Digital RE4", // tested with WDC WD2003FYYS-18W0B0/01.01D02
    "WDC WD((((25|50)03A|1003F)BYX)|((15|20)03FYYS))-.*",
    "", "", ""
  },
  { "Western Digital RE4-GP", // tested with WDC WD2002FYPS-02W3B0/04.01G01
    "WDC WD2002FYPS-.*",
    "", "", ""
  },
  { "Western Digital RE4 (SATA 6Gb/s)", // tested with WDC WD2000FYYZ-01UL1B0/01.01K01
    "WDC WD(20|30|40)00FYYZ-.*",
    "", "", ""
  },
  { "Western Digital Caviar Green",
    "WDC WD((50|64|75)00AA(C|V)S|(50|64|75)00AADS|10EA(C|V)S|(10|15|20)EADS)-.*",
    "",
    "",
    "-F xerrorlba" // tested with WDC WD7500AADS-00M2B0/01.00A01
  },
  { "Western Digital Caviar Green (AF)",
    "WDC WD(((64|75|80)00AA|(10|15|20)EA|(25|30)EZ)R|20EAC)S-.*",
    "", "", ""
  },
  { "Western Digital Caviar Green (AF, SATA 6Gb/s)", // tested with
      // WDC WD10EZRX-00A8LB0/01.01A01, WDC WD20EZRX-00DC0B0/80.00A80,
      // WDC WD30EZRX-00MMMB0/80.00A80
    "WDC WD(7500AA|(10|15|20)EA|(10|20|25|30)EZ)RX-.*",
    "", "", ""
  },
  { "Western Digital Caviar Black",
    "WDC WD((500|640|750)1AAL|1001FA[EL]|2001FAS)S-.*",
    "", "", ""
  },
  { "Western Digital Caviar Black",  // SATA 6 Gb/s variants, tested with
      //  WDC WD4001FAEX-00MJRA0/01.01L01
    "WDC WD(5002AAL|(64|75)02AAE|((10|15|20)02|4001)FAE)X-.*",
    "", "", ""
  },
  { "Western Digital Caviar Black (AF)", // tested with WDC WD5003AZEX-00RKKA0/80.00A80
    "WDC WD(5003AZE)X-.*",
    "", "", ""
  },
  { "Western Digital AV ATA", // tested with WDC WD3200AVJB-63J5A0/01.03E01
    "WDC WD(8|16|25|32|50)00AV[BJ]B-.*",
    "", "", ""
  },
  { "Western Digital AV SATA",
    "WDC WD(16|25|32)00AVJS-.*",
    "", "", ""
  },
  { "Western Digital AV-GP",
    "WDC WD((16|25|32|50|64|75)00AV[CDV]S|(10|15|20)EV[CDV]S)-.*",
    "", "", ""
  },
  { "Western Digital AV-GP (AF)", // tested with WDC WD10EURS-630AB1/80.00A80, WDC WD10EUCX-63YZ1Y0/51.0AB52
    "WDC WD(7500AURS|10EU[CR]X|(10|15|20|25|30)EURS)-.*",
    "", "", ""
  },
  { "Western Digital AV-25",
    "WDC WD((16|25|32|50)00BUD|5000BUC)T-.*",
    "", "", ""
  },
  { "Western Digital Raptor",
    "WDC WD((360|740|800)GD|(360|740|800|1500)ADF[DS])-.*",
    "", "", ""
  },
  { "Western Digital Raptor X",
    "WDC WD1500AHFD-.*",
    "", "", ""
  },
  { "Western Digital VelociRaptor", // tested with WDC WD1500HLHX-01JJPV0/04.05G04
    "WDC WD(((800H|(1500|3000)[BH]|1600H|3000G)LFS)|((1500|3000|4500|6000)[BH]LHX))-.*",
    "", "", ""
  },
  { "Western Digital VelociRaptor (AF)", // tested with WDC WD1000DHTZ-04N21V0/04.06A00
    "WDC WD(2500H|5000H|1000D)HTZ-.*",
    "", "", ""
  },
  { "Western Digital Scorpio EIDE",
    "WDC WD(4|6|8|10|12|16)00(UE|VE)-.*",
    "", "", ""
  },
  { "Western Digital Scorpio Blue EIDE", // tested with WDC WD3200BEVE-00A0HT0/11.01A11
    "WDC WD(4|6|8|10|12|16|25|32)00BEVE-.*",
    "", "", ""
  },
  { "Western Digital Scorpio Serial ATA",
    "WDC WD(4|6|8|10|12|16|25)00BEAS-.*",
    "", "", ""
  },
  { "Western Digital Scorpio Blue Serial ATA",
    "WDC WD((4|6|8|10|12|16|25)00BEVS|(8|12|16|25|32|40|50|64)00BEVT|7500KEVT|10TEVT)-.*",
    "", "", ""
  },
  { "Western Digital Scorpio Blue Serial ATA (AF)", // tested with
      // WDC WD10JPVT-00A1YT0/01.01A01
    "WDC WD((16|25|32|50|64|75)00BPVT|10[JT]PVT)-.*",
    "", "", ""
  },
  { "Western Digital Scorpio Black", // tested with WDC WD5000BEKT-00KA9T0/01.01A01
    "WDC WD(8|12|16|25|32|50)00B[EJ]KT-.*",
    "", "", ""
  },
  { "Western Digital Scorpio Black (AF)",
    "WDC WD(50|75)00BPKT-.*",
    "", "", ""
  },
  { "Western Digital Red (AF)", // tested with WDC WD10EFRX-68JCSN0/01.01A01
    "WDC WD(10|20|30)EFRX-.*",
    "", "", ""
  },
  { "Western Digital My Passport (USB)", // tested with WDC WD5000BMVW-11AMCS0/01.01A01
    "WDC WD(25|32|40|50)00BMV[UVW]-.*",  // *W-* = USB 3.0
    "", "", ""
  },
  { "Western Digital My Passport (USB, AF)", // tested with
      // WDC WD5000KMVV-11TK7S1/01.01A01, WDC WD10TMVW-11ZSMS5/01.01A01,
      // WDC WD10JMVW-11S5XS1/01.01A01, WDC WD20NMVW-11W68S0/01.01A01
    "WDC WD(5000[LK]|7500K|10[JT]|20N)MV[VW]-.*", // *W-* = USB 3.0
    "", "", ""
  },
  { "Quantum Bigfoot", // tested with TS10.0A/A21.0G00, TS12.7A/A21.0F00
    "QUANTUM BIGFOOT TS(10\\.0|12\\.7)A",
    "", "", ""
  },
  { "Quantum Fireball lct15",
    "QUANTUM FIREBALLlct15 ([123]0|22)",
    "", "", ""
  },
  { "Quantum Fireball lct20",
    "QUANTUM FIREBALLlct20 [1234]0",
    "", "", ""
  },
  { "Quantum Fireball CX",
    "QUANTUM FIREBALL CX10.2A",
    "", "", ""
  },
  { "Quantum Fireball CR",
    "QUANTUM FIREBALL CR(4.3|6.4|8.4|13.0)A",
    "", "", ""
  },
  { "Quantum Fireball EX", // tested with QUANTUM FIREBALL EX10.2A/A0A.0D00
    "QUANTUM FIREBALL EX(3\\.2|6\\.4|10\\.2)A",
    "", "", ""
  },
  { "Quantum Fireball ST",
    "QUANTUM FIREBALL ST(3.2|4.3|4300)A",
    "", "", ""
  },
  { "Quantum Fireball SE",
    "QUANTUM FIREBALL SE4.3A",
    "", "", ""
  },
  { "Quantum Fireball Plus LM",
    "QUANTUM FIREBALLP LM(10.2|15|20.[45]|30)",
    "", "", ""
  },
  { "Quantum Fireball Plus AS",
    "QUANTUM FIREBALLP AS(10.2|20.5|30.0|40.0|60.0)",
    "", "", ""
  },
  { "Quantum Fireball Plus KX",
    "QUANTUM FIREBALLP KX27.3",
    "", "", ""
  },
  { "Quantum Fireball Plus KA",
    "QUANTUM FIREBALLP KA(9|10).1",
    "", "", ""
  },

  ////////////////////////////////////////////////////
  // USB ID entries
  ////////////////////////////////////////////////////

  // Hewlett-Packard
  { "USB: HP Desktop HD BD07; ", // 2TB
    "0x03f0:0xbd07",
    "",
    "",
    "-d sat"
  },
  // ALi
  { "USB: ; ALi M5621", // USB->PATA
    "0x0402:0x5621",
    "",
    "",
    "" // unsupported
  },
  // VIA
  { "USB: Connectland BE-USB2-35BP-LCM; VIA VT6204",
    "0x040d:0x6204",
    "",
    "",
    "" // unsupported
  },
  // Buffalo / Melco
  { "USB: Buffalo JustStore Portable HD-PVU2; ",
    "0x0411:0x0181",
    "",
    "",
    "-d sat"
  },
  { "USB: Buffalo MiniStation Stealth HD-PCTU2; ",
    "0x0411:0x01d9",
    "", // 0x0108
    "",
    "-d sat"
  },
  // LG Electronics
  { "USB: LG Mini HXD5; JMicron",
    "0x043e:0x70f1",
    "", // 0x0100
    "",
    "-d usbjmicron"
  },
  // Philips
  { "USB: Philips; ", // SDE3273FC/97 2.5" SATA HDD enclosure
    "0x0471:0x2021",
    "", // 0x0103
    "",
    "-d sat"
  },
  // Toshiba
  { "USB: Toshiba Canvio 500GB; SunPlus",
    "0x0480:0xa004",
    "",
    "",
    "-d usbsunplus"
  },
  { "USB: Toshiba Canvio Basics; ",
    "0x0480:0xa006",
    "", // 0x0001
    "",
    "-d sat"
  },
  { "USB: Toshiba Canvio 3.0 Portable Hard Drive; ", // 1TB
    "0x0480:0xa007",
    "", // 0x0001
    "",
    "-d sat"
  },
  { "USB: Toshiba Canvio Desktop; ", // 2TB
    "0x0480:0xd010",
    "",
    "",
    "-d sat"
  },
  // Cypress
  { "USB: ; Cypress CY7C68300A (AT2)",
    "0x04b4:0x6830",
    "0x0001",
    "",
    "" // unsupported
  },
  { "USB: ; Cypress CY7C68300B/C (AT2LP)",
    "0x04b4:0x6830",
    "0x0240",
    "",
    "-d usbcypress"
  },
  // Fujitsu
  { "USB: Fujitsu/Zalman ZM-VE300; ", // USB 3.0
    "0x04c5:0x2028",
    "", // 0x0001
    "",
    "-d sat"
  },
  // Fujitsu chip on DeLock 42475 
  { "USB: Fujitsu  SATA-to-USB3.0 bridge chip", // USB 3.0
    "0x04c5:0x201d",
    "", // 0x0001
    "",
    "-d sat"
  },
  // Myson Century
  { "USB: ; Myson Century CS8818",
    "0x04cf:0x8818",
    "", // 0xb007
    "",
    "" // unsupported
  },
  // Samsung
  { "USB: Samsung S2 Portable; JMicron",
    "0x04e8:0x1f0[568]",
    "",
    "",
    "-d usbjmicron"
  },
  { "USB: Samsung S1 Portable; JMicron",
    "0x04e8:0x2f03",
    "",
    "",
    "-d usbjmicron"
  },
  { "USB: Samsung Story Station; ",
    "0x04e8:0x5f0[56]",
    "",
    "",
    "-d sat"
  },
  { "USB: Samsung G2 Portable; JMicron",
    "0x04e8:0x6032",
    "",
    "",
    "-d usbjmicron"
  },
  { "USB: Samsung Story Station 3.0; ",
    "0x04e8:0x6052",
    "",
    "",
    "-d sat"
  },
  { "USB: Samsung Story Station 3.0; ",
    "0x04e8:0x6054",
    "",
    "",
    "-d sat"
  },
  { "USB: Samsung M2 Portable 3.0; ",
    "0x04e8:0x60c5",
    "",
    "",
    "-d sat"
  },
  { "USB: Samsung M3 Portable USB 3.0; ", // 1TB
    "0x04e8:0x61b6",
    "", // 0x0e00
    "",
    "-d sat"
  },
  // Sunplus
  { "USB: ; SunPlus",
    "0x04fc:0x0c05",
    "",
    "",
    "-d usbsunplus"
  },
  { "USB: ; SunPlus SPDIF215",
    "0x04fc:0x0c15",
    "", // 0xf615
    "",
    "-d usbsunplus"
  },
  { "USB: ; SunPlus SPDIF225", // USB+SATA->SATA
    "0x04fc:0x0c25",
    "", // 0x0103
    "",
    "-d usbsunplus"
  },
  // Iomega
  { "USB: Iomega Prestige Desktop USB 3.0; ",
    "0x059b:0x0070",
    "", // 0x0004
    "",
    "-d sat" // ATA output registers missing
  },
  { "USB: Iomega LPHD080-0; ",
    "0x059b:0x0272",
    "",
    "",
    "-d usbcypress"
  },
  { "USB: Iomega MDHD500-U; ",
    "0x059b:0x0275",
    "", // 0x0001
    "",
    "" // unsupported
  },
  { "USB: Iomega MDHD-UE; ",
    "0x059b:0x0277",
    "",
    "",
    "-d usbjmicron"
  },
  { "USB: Iomega LDHD-UP; Sunplus",
    "0x059b:0x0370",
    "",
    "",
    "-d usbsunplus"
  },
  { "USB: Iomega GDHDU2; JMicron",
    "0x059b:0x0475",
    "", // 0x0100
    "",
    "-d usbjmicron"
  },
  // LaCie
  { "USB: LaCie hard disk (FA Porsche design);",
    "0x059f:0x0651",
    "",
    "",
    "" // unsupported
  },
  { "USB: LaCie hard disk; JMicron",
    "0x059f:0x0951",
    "",
    "",
    "-d usbjmicron"
  },
  { "USB: LaCie hard disk (Neil Poulton design);",
    "0x059f:0x1018",
    "",
    "",
    "-d sat"
  },
  { "USB: LaCie Desktop Hard Drive; JMicron",
    "0x059f:0x1019",
    "",
    "",
    "-d usbjmicron"
  },
  { "USB: LaCie Rugged Hard Drive; JMicron",
    "0x059f:0x101d",
    "", // 0x0001
    "",
    "-d usbjmicron,x"
  },
  { "USB: LaCie Little Disk USB2; JMicron",
    "0x059f:0x1021",
    "",
    "",
    "-d usbjmicron"
  },
  { "USB: LaCie hard disk; ",
    "0x059f:0x1029",
    "", // 0x0100
    "",
    "-d sat"
  },
  { "USB: Lacie rikiki; JMicron",
    "0x059f:0x102a",
    "",
    "",
    "-d usbjmicron,x"
  },
  { "USB: LaCie rikiki USB 3.0; ",
    "0x059f:0x10(49|57)",
    "",
    "",
    "-d sat"
  },
  { "USB: LaCie minimus USB 3.0; ",
    "0x059f:0x104a",
    "",
    "",
    "-d sat"
  },
  { "USB: LaCie Rugged Mini USB 3.0; ",
    "0x059f:0x1051",
    "", // 0x0000
    "",
    "-d sat"
  },
  // In-System Design
  { "USB: ; In-System/Cypress ISD-300A1",
    "0x05ab:0x0060",
    "", // 0x1101
    "",
    "-d usbcypress"
  },
  // Genesys Logic
  { "USB: ; Genesys Logic GL881E",
    "0x05e3:0x0702",
    "",
    "",
    "" // unsupported
  },
  { "USB: ; Genesys Logic", // TODO: requires '-T permissive'
    "0x05e3:0x0718",
    "", // 0x0041
    "",
    "-d sat"
  },
  // Micron
  { "USB: Micron USB SSD; ",
    "0x0634:0x0655",
    "",
    "",
    "" // unsupported
  },
  // Prolific
  { "USB: ; Prolific PL2507", // USB->PATA
    "0x067b:0x2507",
    "",
    "",
    "-d usbjmicron,0" // Port number is required
  },
  { "USB: ; Prolific PL3507", // USB+IEE1394->PATA
    "0x067b:0x3507",
    "", // 0x0001
    "",
    "-d usbjmicron,p"
  },
  // Imation
  { "USB: Imation ; ", // Imation Odyssey external USB dock
    "0x0718:0x1000",
    "", // 0x5104
    "",
    "-d sat"
  },
  // Freecom
  { "USB: Freecom Mobile Drive XXS; JMicron",
    "0x07ab:0xfc88",
    "", // 0x0101
    "",
    "-d usbjmicron,x"
  },
  { "USB: Freecom Hard Drive XS; Sunplus",
    "0x07ab:0xfc8e",
    "", // 0x010f
    "",
    "-d usbsunplus"
  },
  { "USB: Freecom; ", // Intel labeled
    "0x07ab:0xfc8f",
    "", // 0x0000
    "",
    "-d sat"
  },
  { "USB: Freecom Classic HD 120GB; ",
    "0x07ab:0xfccd",
    "",
    "",
    "" // unsupported
  },
  { "USB: Freecom HD 500GB; JMicron",
    "0x07ab:0xfcda",
    "",
    "",
    "-d usbjmicron"
  },
  // Oxford Semiconductor, Ltd
  { "USB: ; Oxford",
    "0x0928:0x0000",
    "",
    "",
    "" // unsupported
  },
  { "USB: ; Oxford OXU921DS",
    "0x0928:0x0002",
    "",
    "",
    "" // unsupported
  },
  { "USB: ; Oxford", // Zalman ZM-VE200
    "0x0928:0x0010",
    "", // 0x0304
    "",
    "-d sat"
  },
  // Toshiba
  { "USB: Toshiba PX1270E-1G16; Sunplus",
    "0x0930:0x0b03",
    "",
    "",
    "-d usbsunplus"
  },
  { "USB: Toshiba PX1396E-3T01; Sunplus", // similar to Dura Micro 501
    "0x0930:0x0b09",
    "",
    "",
    "-d usbsunplus"
  },
  { "USB: Toshiba Stor.E Steel; Sunplus",
    "0x0930:0x0b11",
    "",
    "",
    "-d usbsunplus"
  },
  { "USB: Toshiba Stor.E; ",
    "0x0930:0x0b1[9ab]",
    "", // 0x0001
    "",
    "-d sat"
  },
  // Lumberg, Inc.
  { "USB: Toshiba Stor.E; Sunplus",
    "0x0939:0x0b16",
    "",
    "",
    "-d usbsunplus"
  },
  // Seagate
  { "USB: Seagate External Drive; Cypress",
    "0x0bc2:0x0503",
    "", // 0x0240
    "",
    "-d usbcypress"
  },
  { "USB: Seagate FreeAgent Go; ",
    "0x0bc2:0x2(000|100|101)",
    "",
    "",
    "-d sat"
  },
  { "USB: Seagate FreeAgent Go FW; ",
    "0x0bc2:0x2200",
    "",
    "",
    "-d sat"
  },
  { "USB: Seagate Expansion Portable; ",
    "0x0bc2:0x2300",
    "",
    "",
    "-d sat"
  },
  { "USB: Seagate FreeAgent Desktop; ",
    "0x0bc2:0x3000",
    "",
    "",
    "-d sat"
  },
  { "USB: Seagate FreeAgent Desk; ",
    "0x0bc2:0x3001",
    "",
    "",
    "-d sat"
  },
  { "USB: Seagate FreeAgent Desk; ", // 1TB
    "0x0bc2:0x3008",
    "",
    "",
    "-d sat,12"
  },
  { "USB: Seagate Expansion External; ", // 2TB, 3TB
    "0x0bc2:0x33(00|20|32)",
    "",
    "",
    "-d sat"
  },
  { "USB: Seagate FreeAgent GoFlex USB 2.0; ",
    "0x0bc2:0x5021",
    "",
    "",
    "-d sat"
  },
  { "USB: Seagate FreeAgent GoFlex USB 3.0; ",
    "0x0bc2:0x5031",
    "",
    "",
    "-d sat,12"
  },
  { "USB: Seagate FreeAgent; ",
    "0x0bc2:0x5040",
    "",
    "",
    "-d sat"
  },
  { "USB: Seagate FreeAgent GoFlex USB 3.0; ", // 2TB
    "0x0bc2:0x5071",
    "",
    "",
    "-d sat"
  },
  { "USB: Seagate FreeAgent GoFlex Desk USB 3.0; ", // 3TB
    "0x0bc2:0x50a1",
    "",
    "",
    "-d sat,12" // "-d sat" does not work (ticket #151)
  },
  { "USB: Seagate FreeAgent GoFlex Desk USB 3.0; ", // 4TB
    "0x0bc2:0x50a5",
    "", // 0x0100
    "",
    "-d sat"
  },
  { "USB: Seagate Backup Plus USB 3.0; ", // 1TB
    "0x0bc2:0xa013",
    "", // 0x0100
    "",
    "-d sat"
  },
  { "USB: Seagate Backup Plus Desktop USB 3.0; ", // 4TB, 3TB (8 LBA/1 PBA offset)
    "0x0bc2:0xa0a[14]",
    "",
    "",
    "-d sat"
  },
  // Dura Micro
  { "USB: Dura Micro; Cypress",
    "0x0c0b:0xb001",
    "", // 0x1110
    "",
    "-d usbcypress"
  },
  { "USB: Dura Micro 509; Sunplus",
    "0x0c0b:0xb159",
    "", // 0x0103
    "",
    "-d usbsunplus"
  },
  // Maxtor
  { "USB: Maxtor OneTouch 200GB; ",
    "0x0d49:0x7010",
    "",
    "",
    "" // unsupported
  },
  { "USB: Maxtor OneTouch; ",
    "0x0d49:0x7300",
    "", // 0x0121
    "",
    "-d sat"
  },
  { "USB: Maxtor OneTouch 4; ",
    "0x0d49:0x7310",
    "", // 0x0125
    "",
    "-d sat"
  },
  { "USB: Maxtor OneTouch 4 Mini; ",
    "0x0d49:0x7350",
    "", // 0x0125
    "",
    "-d sat"
  },
  { "USB: Maxtor BlackArmor Portable; ",
    "0x0d49:0x7550",
    "",
    "",
    "-d sat"
  },
  { "USB: Maxtor Basics Desktop; ",
    "0x0d49:0x7410",
    "", // 0x0122
    "",
    "-d sat"
  },
  { "USB: Maxtor Basics Portable; ",
    "0x0d49:0x7450",
    "", // 0x0122
    "",
    "-d sat"
  },
  // Oyen Digital
  { "USB: Oyen Digital MiniPro USB 3.0; ",
    "0x0dc4:0x020a",
    "",
    "",
    "-d sat"
  },
  // Cowon Systems, Inc.
  { "USB: Cowon iAudio X5; ",
    "0x0e21:0x0510",
    "",
    "",
    "-d usbcypress"
  },
  // iRiver
  { "USB: iRiver iHP-120/140 MP3 Player; Cypress",
    "0x1006:0x3002",
    "", // 0x0100
    "",
    "-d usbcypress"
  },
  // Western Digital
  { "USB: WD My Passport (IDE); Cypress",
    "0x1058:0x0701",
    "", // 0x0240
    "",
    "-d usbcypress"
  },
  { "USB: WD My Passport Portable; ",
    "0x1058:0x0702",
    "", // 0x0102
    "",
    "-d sat"
  },
  { "USB: WD My Passport Essential; ",
    "0x1058:0x0704",
    "", // 0x0175
    "",
    "-d sat"
  },
  { "USB: WD My Passport Elite; ",
    "0x1058:0x0705",
    "", // 0x0175
    "",
    "-d sat"
  },
  { "USB: WD My Passport 070A; ",
    "0x1058:0x070a",
    "", // 0x1028
    "",
    "-d sat"
  },
  { "USB: WD My Passport 0730; ",
    "0x1058:0x0730",
    "", // 0x1008
    "",
    "-d sat"
  },
  { "USB: WD My Passport Essential SE USB 3.0; ",
    "0x1058:0x074[02]",
    "",
    "",
    "-d sat"
  },
  { "USB: WD My Passport USB 3.0; ",
    "0x1058:0x07[4a]8",
    "",
    "",
    "-d sat"
  },
  { "USB: WD My Book ES; ",
    "0x1058:0x0906",
    "", // 0x0012
    "",
    "-d sat"
  },
  { "USB: WD My Book Essential; ",
    "0x1058:0x0910",
    "", // 0x0106
    "",
    "-d sat"
  },
  { "USB: WD Elements Desktop; ",
    "0x1058:0x1001",
    "", // 0x0104
    "",
    "-d sat"
  },
  { "USB: WD Elements Desktop WDE1UBK...; ",
    "0x1058:0x1003",
    "", // 0x0175
    "",
    "-d sat"
  },
  { "USB: WD Elements; ",
    "0x1058:0x10(10|a2)",
    "", // 0x0105
    "",
    "-d sat"
  },
  { "USB: WD Elements Desktop; ", // 2TB
    "0x1058:0x1021",
    "", // 0x2002
    "",
    "-d sat"
  },
  { "USB: WD Elements SE; ", // 1TB
    "0x1058:0x1023",
    "",
    "",
    "-d sat"
  },
  { "USB: WD Elements SE USB 3.0; ",
    "0x1058:0x1042",
    "",
    "",
    "-d sat"
  },
  { "USB: WD My Book Essential; ",
    "0x1058:0x1100",
    "", // 0x0165
    "",
    "-d sat"
  },
  { "USB: WD My Book Office Edition; ", // 1TB
    "0x1058:0x1101",
    "", // 0x0165
    "",
    "-d sat"
  },
  { "USB: WD My Book; ",
    "0x1058:0x1102",
    "", // 0x1028
    "",
    "-d sat"
  },
  { "USB: WD My Book Studio II; ", // 2x1TB
    "0x1058:0x1105",
    "",
    "",
    "-d sat"
  },
  { "USB: WD My Book Essential; ",
    "0x1058:0x1110",
    "", // 0x1030
    "",
    "-d sat"
  },
  { "USB: WD My Book Essential USB 3.0; ", // 3TB
    "0x1058:0x11[34]0",
    "", // 0x1012/0x1003
    "",
    "-d sat"
  },
  // Atech Flash Technology
  { "USB: ; Atech", // Enclosure from Kingston SSDNow notebook upgrade kit
    "0x11b0:0x6298",
    "", // 0x0108
    "",
    "-d sat"
  },
  // A-DATA
  { "USB: A-DATA SH93; Cypress",
    "0x125f:0xa93a",
    "", // 0x0150
    "",
    "-d usbcypress"
  },
  { "USB: A-DATA DashDrive; Cypress",
    "0x125f:0xa94a",
    "",
    "",
    "-d usbcypress"
  },
  // Initio
  { "USB: ; Initio 316000",
    "0x13fd:0x0540",
    "",
    "",
    "" // unsupported
  },
  { "USB: ; Initio", // Thermaltake BlacX
    "0x13fd:0x0840",
    "",
    "",
    "-d sat"
  },
  { "USB: ; Initio", // USB->SATA+PATA, Chieftec CEB-25I
    "0x13fd:0x1040",
    "", // 0x0106
    "",
    "" // unsupported
  },
  { "USB: ; Initio 6Y120L0", // CoolerMaster XCraft RX-3HU
    "0x13fd:0x1150",
    "",
    "",
    "" // unsupported
  },
  { "USB: ; Initio", // USB->SATA
    "0x13fd:0x1240",
    "", // 0x0104
    "",
    "-d sat"
  },
  { "USB: ; Initio", // USB+SATA->SATA
    "0x13fd:0x1340",
    "", // 0x0208
    "",
    "-d sat"
  },
  { "USB: Intenso Memory Station 2,5\"; Initio",
    "0x13fd:0x1840",
    "",
    "",
    "-d sat"
  },
  { "USB: ; Initio", // NexStar CX USB enclosure
    "0x13fd:0x1e40",
    "",
    "",
    "-d sat"
  },
  // Super Top
  { "USB: Super Top generic enclosure; Cypress",
    "0x14cd:0x6116",
    "", // 0x0160 also reported as unsupported
    "",
    "-d usbcypress"
  },
  // JMicron
  { "USB: ; JMicron USB 3.0",
    "0x152d:0x0539",
    "", // 0x0100
    "",
    "-d usbjmicron"
  },
  { "USB: ; JMicron ", // USB->SATA->4xSATA (port multiplier)
    "0x152d:0x0551",
    "", // 0x0100
    "",
    "-d usbjmicron,x"
  },
  { "USB: OCZ THROTTLE OCZESATATHR8G; JMicron JMF601",
    "0x152d:0x0602",
    "",
    "",
    "" // unsupported
  },
  { "USB: ; JMicron JM20329", // USB->SATA
    "0x152d:0x2329",
    "", // 0x0100
    "",
    "-d usbjmicron"
  },
  { "USB: ; JMicron JM20336", // USB+SATA->SATA, USB->2xSATA
    "0x152d:0x2336",
    "", // 0x0100
    "",
    "-d usbjmicron,x"
  },
  { "USB: Generic JMicron adapter; JMicron",
    "0x152d:0x2337",
    "",
    "",
    "-d usbjmicron"
  },
  { "USB: ; JMicron JM20337/8", // USB->SATA+PATA, USB+SATA->PATA
    "0x152d:0x2338",
    "", // 0x0100
    "",
    "-d usbjmicron"
  },
  { "USB: ; JMicron JM20339", // USB->SATA
    "0x152d:0x2339",
    "", // 0x0100
    "",
    "-d usbjmicron,x"
  },
  { "USB: ; JMicron", // USB+SATA->SATA
    "0x152d:0x2351",  // e.g. Verbatim Portable Hard Drive 500Gb
    "", // 0x0100
    "",
    "-d sat"
  },
  { "USB: ; JMicron", // USB->SATA
    "0x152d:0x2352",
    "", // 0x0100
    "",
    "-d usbjmicron,x"
  },
  { "USB: ; JMicron", // USB->SATA
    "0x152d:0x2509",
    "", // 0x0100
    "",
    "-d usbjmicron,x"
  },
  // ASMedia
  { "USB: ; ASMedia ASM1051",
    "0x174c:0x5106", // 0x174c:0x55aa after firmware update
    "",
    "",
    "-d sat"
  },
  { "USB: ; ASMedia USB 3.0", // MEDION HDDrive-n-GO, LaCie Rikiki USB 3.0,
      // Silicon Power Armor A80 (ticket #237)
      // reported as unsupported: BYTECC T-200U3, Kingwin USB 3.0 docking station
    "0x174c:0x55aa",
    "", // 0x0100
    "",
    "-d sat"
  },
  // LucidPort
  { "USB: ; LucidPORT USB300", // RaidSonic ICY BOX IB-110StU3-B, Sharkoon SATA QuickPort H3
    "0x1759:0x500[02]", // 0x5000: USB 2.0, 0x5002: USB 3.0
    "",
    "",
    "-d sat"
  },
  // Verbatim
  { "USB: Verbatim Portable Hard Drive; Sunplus",
    "0x18a5:0x0214",
    "", // 0x0112
    "",
    "-d usbsunplus"
  },
  { "USB: Verbatim FW/USB160; Oxford OXUF934SSA-LQAG", // USB+IEE1394->SATA
    "0x18a5:0x0215",
    "", // 0x0001
    "",
    "-d sat"
  },
  { "USB: Verbatim External Hard Drive 47519; Sunplus", // USB->SATA
    "0x18a5:0x0216",
    "",
    "",
    "-d usbsunplus"
  },
  { "USB: Verbatim Pocket Hard Drive; JMicron", // SAMSUNG SpinPoint N3U-3 (USB, 4KiB LLS)
    "0x18a5:0x0227",
    "",
    "",
    "-d usbjmicron" // "-d usbjmicron,x" does not work
  },
  { "USB: Verbatim External Hard Drive; JMicron", // 2TB
    "0x18a5:0x022a",
    "",
    "",
    "-d usbjmicron"
  },
  { "USB: Verbatim Store'n'Go; JMicron", // USB->SATA
    "0x18a5:0x022b",
    "", // 0x0100
    "",
    "-d usbjmicron"
  },
  // Silicon Image
  { "USB: Vantec NST-400MX-SR; Silicon Image 5744",
    "0x1a4a:0x1670",
    "",
    "",
    "" // unsupported
  },
  // SunplusIT
  { "USB: ; SunplusIT",
    "0x1bcf:0x0c31",
    "",
    "",
    "-d usbsunplus"
  },
  // Innostor
  { "USB: ; Innostor IS888", // Sharkoon SATA QuickDeck Pro USB 3.0
    "0x1f75:0x0888",
    "", // 0x0034
    "",
    "" // unsupported
  },
  // Power Quotient International
  { "USB: PQI H560; ",
    "0x3538:0x0902",
    "", // 0x0000
    "",
    "-d sat"
  },
  // Hitachi/SimpleTech
  { "USB: Hitachi Touro Desk; JMicron", // 3TB
    "0x4971:0x1011",
    "",
    "",
    "-d usbjmicron"
  },
  { "USB: Hitachi Touro Desk 3.0; ", // 2TB
    "0x4971:0x1015",
    "", // 0x0000
    "",
    "-d sat" // ATA output registers missing
  },
  { "USB: Hitachi/SimpleTech; JMicron", // 1TB
    "0x4971:0xce17",
    "",
    "",
    "-d usbjmicron,x"
  },
  // OnSpec
  { "USB: ; OnSpec", // USB->PATA
    "0x55aa:0x2b00",
    "", // 0x0100
    "",
    "" // unsupported
  },
  // 0x6795 (?)
  { "USB: Sharkoon 2-Bay RAID Box; ", // USB 3.0
    "0x6795:0x2756",
    "", // 0x0100
    "",
    "-d sat"
  },
/*
}; // builtin_knowndrives[]
 */
