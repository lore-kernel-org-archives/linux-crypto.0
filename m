From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Alg errors with Intel QAT Card
Date: Wed, 14 Jun 2017 08:12:38 -0400
Message-ID: <20170614121238.GA18388@hmswarspite.think-freely.org>
References: <CAMFBXfmo5GmJS5kF+Pf2AvPaLOE20cz-NHUS9X53Lb7RspAOHw@mail.gmail.com>
 <309B30E91F5E2846B79BD9AA9711D0312ECE8C01@IRSMSX102.ger.corp.intel.com>
 <20170613123031.GA18575@hmswarspite.think-freely.org>
 <CAMFBXfn=mUyxQQqVcrg=mjw9JT+gK1MSbLszG1vNu__B78H41w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Raj Ammanur <rammanur@arista.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34378 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750756AbdFNMMs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2017 08:12:48 -0400
Content-Disposition: inline
In-Reply-To: <CAMFBXfn=mUyxQQqVcrg=mjw9JT+gK1MSbLszG1vNu__B78H41w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 13, 2017 at 01:32:55PM -0700, Raj Ammanur wrote:
> Hi Neil & Salvatore,
> 
> thanks for the replies. The soft reboot hasn't helped. I am trying a previous
> kernel version that works with a similar card that we installed in
> another server
> and that works fine. Will keep you posted.
> 
> Neil: have you found fix/workaround for the firmware errors or you just using
> a soft reboot? by that, you just mean unload and load the kernel modules or
> a system reboot. I have tried both.
> 
its the latter that works around the issue.  I belive a QAT firmware update will
be forthcomming to fix the issue

Neil

> thanks
> --Raj
> 
> On Tue, Jun 13, 2017 at 5:30 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Mon, Jun 12, 2017 at 03:52:07PM +0000, Benedetto, Salvatore wrote:
> >> Hi Raj,
> >>
> >> I've compiled and tested kernel 4.12.0-rc4 and I can't reproduce your issue.
> >> Are you seeing any of this with a previous kernel version? If not, git bisect might
> >> help us finding the root-cause.
> >> Have you tried with another platform/hw?
> >>
> >> Regards,
> >> Salvatore
> >>
> > Try a soft reboot and see if the error clears up.  This looks a bit reminscient
> > of some firmware errors we've been chasing down
> > Neil
> >
> >> > -----Original Message-----
> >> > From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> >> > owner@vger.kernel.org] On Behalf Of Raj Ammanur
> >> > Sent: Friday, June 9, 2017 7:37 PM
> >> > To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
> >> > Subject: Alg errors with Intel QAT Card
> >> >
> >> > Hi
> >> >
> >> > I am seeing the below errors after  installing an Intel QAT card
> >> > and loading the upstreamed qat_dh895xcc and intel_qat modules.
> >> >
> >> > Have others seen similar errors and know if this is a known issue
> >> > and a fix exists or know whats going on ? This is with 4.12.0-rc4+
> >> > version of the kernel.
> >> >
> >> > Any help is sincerely appreciated.
> >> >
> >> > thanks
> >> > --Raj
> >> >
> >> >
> >> > [    3.639046] dh895xcc 0000:00:0b.0: qat_dev0 started 12 acceleration engines
> >> > [    4.168887] alg: skcipher-ddst: Test 5 failed (invalid result) on
> >> > encryption for qat_aes_cbc
> >> > [    4.217866] alg: skcipher-ddst: Chunk test 1 failed on encryption
> >> > at page 0 for qat_aes_ctr
> >> > [    4.282042] alg: skcipher: Test 4 failed (invalid result) on
> >> > encryption for qat_aes_xts
> >> > [    4.395210] alg: akcipher: test 1 failed for qat-rsa, err=-22
> >> > [root@dhcp-swlab-681 ~]# dmesg | grep -i alg
> >> > [    1.499336] alg: No test for pkcs1pad(rsa,sha256)
> >> > (pkcs1pad(rsa-generic,sha256))
> >> > [    2.562511] SELinux:  Class alg_socket not defined in policy.
> >> > [    4.168887] alg: skcipher-ddst: Test 5 failed (invalid result) on
> >> > encryption for qat_aes_cbc
> >> > [    4.217866] alg: skcipher-ddst: Chunk test 1 failed on encryption
> >> > at page 0 for qat_aes_ctr
> >> > [    4.282042] alg: skcipher: Test 4 failed (invalid result) on
> >> > encryption for qat_aes_xts
> >> > [    4.367682] alg: akcipher: encrypt test failed. Invalid output
> >> > [    4.395210] alg: akcipher: test 1 failed for qat-rsa, err=-22
> >> > [    4.431827] alg: dh: generate public key test failed. Invalid output
> >> > [    4.431829] alg: dh: test failed on vector 1, err=-22
> >> >
> >> >
> >> > 83:00.0 Co-processor: Intel Corporation DH895XCC Series QAT
> >> > Subsystem: Intel Corporation Device 0000
> >> > Physical Slot: 2
> >> > Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> >> > Stepping- SERR+ FastB2B- DisINTx+
> >> > Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> >> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> >> > Latency: 0, Cache Line Size: 32 bytes
> >> > Interrupt: pin A routed to IRQ 35
> >> > NUMA node: 1
> >> > Region 0: Memory at fb900000 (64-bit, prefetchable) [size=512K]
> >> > Region 2: Memory at fbd40000 (64-bit, non-prefetchable) [size=256K]
> >> > Region 4: Memory at fbd00000 (64-bit, non-prefetchable) [size=256K]
> >> > Capabilities: [b0] MSI: Enable- Count=1/1 Maskable+ 64bit+
> >> > Address: 0000000000000000  Data: 0000
> >> > Masking: 00000000  Pending: 00000000
> >> > Capabilities: [60] MSI-X: Enable+ Count=33 Masked-
> >> > Vector table: BAR=2 offset=0003b000
> >> > PBA: BAR=2 offset=0003b800
> >> > Capabilities: [6c] Power Management version 3
> >> > Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-
> >> > ,D3cold-)
> >> > Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> >> > Capabilities: [74] Express (v2) Endpoint, MSI 00
> >> > DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <128ns, L1 <1us
> >> > ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
> >> > DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
> >> > RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLReset-
> >> > MaxPayload 256 bytes, MaxReadReq 1024 bytes
> >> > DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
> >> > LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s, Exit Latency L0s
> >> > <512ns, L1 unlimited
> >> > ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
> >> > LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
> >> > ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> >> > LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk- DLActive-
> >> > BWMgmt- ABWMgmt-
> >> > DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR-, OBFF Not
> >> > Supported
> >> > AtomicOpsCap: 32bit- 64bit- 128bitCAS-
> >> > DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
> >> > Disabled
> >> > AtomicOpsCtl: ReqEn-
> >> > LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
> >> >  Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
> >> > ComplianceSOS-
> >> >  Compliance De-emphasis: -6dB
> >> > LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> >> > EqualizationPhase1-
> >> >  EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> >> > Capabilities: [100 v1] Advanced Error Reporting
> >> > UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> >> > MalfTLP- ECRC- UnsupReq- ACSViol-
> >> > UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> >> > MalfTLP- ECRC- UnsupReq- ACSViol-
> >> > UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
> >> > MalfTLP+ ECRC- UnsupReq- ACSViol-
> >> > CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
> >> > CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> >> > AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
> >> > Capabilities: [138 v1] Alternative Routing-ID Interpretation (ARI)
> >> > ARICap: MFVC- ACS-, Next Function: 0
> >> > ARICtl: MFVC- ACS-, Function Group: 0
> >> > Capabilities: [140 v1] Single Root I/O Virtualization (SR-IOV)
> >> > IOVCap: Migration-, Interrupt Message Number: 000
> >> > IOVCtl: Enable- Migration- Interrupt- MSE- ARIHierarchy+
> >> > IOVSta: Migration-
> >> > Initial VFs: 32, Total VFs: 32, Number of VFs: 0, Function Dependency Link: 00
> >> > VF offset: 8, stride: 1, Device ID: 0443
> >> > Supported Page Size: 00000553, System Page Size: 00000001
> >> > Region 0: Memory at 00000000fbd80000 (64-bit, non-prefetchable)
> >> > Region 2: Memory at 00000000fbda0000 (64-bit, non-prefetchable)
> >> > VF Migration: offset: 00000000, BIR: 0
> >> > Kernel driver in use: dh895xcc
> >> > Kernel modules: qat_dh895xcc
> >> >
> >> >
> >> > # lsmod | grep qat
> >> > qat_dh895xcc           16384  1
> >> > intel_qat             126976  13 qat_dh895xcc
> >> > dh_generic             16384  1 intel_qat
> >> > authenc                16384  1 intel_qat
> >> >
> >> > # modinfo qat_dh895xcc
> >> > filename:
> >> > /lib/modules/4.12.0-
> >> > rc4+/kernel/drivers/crypto/qat/qat_dh895xcc/qat_dh895xcc.ko
> >> > version:        0.6.0
> >> > description:    Intel(R) QuickAssist Technology
> >> > firmware:       qat_895xcc.bin
> >> > author:         Intel
> >> > license:        Dual BSD/GPL
> >> > srcversion:     37370A80B9807EC2308F493
> >> > alias:          pci:v00008086d00000435sv*sd*bc*sc*i*
> >> > depends:        intel_qat
> >> > intree:         Y
> >> > vermagic:       4.12.0-rc4+ SMP mod_unload
> >> > signat:         PKCS#7
> >> > signer:
> >> > sig_key:
> >> > sig_hashalgo:   md4
> 
