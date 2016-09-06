From: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Subject: linux 3.10 crash with crypto hardware assist,
Date: Tue, 6 Sep 2016 19:13:41 +0000
Message-ID: <ca14d628437648feb3699836fd1188d8@NALASEXR01F.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "Bronstein, Dan" <dbronste@qti.qualcomm.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44059 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932321AbcIFTNs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 15:13:48 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Has anyone seen the following problem on Linux 3.10, or later Linux?
If it is fixed, can anyone point out where the fix is?
Thanks.
Chemin

We are running Android, based on Linux3.10.
With our crypto hardware accelerator, and driver, algorithm of "authenc(hma=
c(sha1),cbc(aes))" is running well.
With our hardware accelerator and algorithm of "rfc4309(ccm(aes))", it is r=
unning fine  too.

We start testing extended sequence number recently.=20
 ip xfrm state is set with flag esn and replay-window 256. =20

System crashes shortly, after the first couple of packet transmits.
We try to run the same test with flag esn and replay-window 256 with algori=
thm of "rfc4309(ccm(aes))", it still runs fine with hardware accelerator.

We go back to the same algorithm of "authenc(hmac(sha1),cbc(aes))" but with=
out hardware accelerator. This time, it runs fine.

The crypto hardware driver is agnostic to esn. Without esn, it is running f=
ine. So it is less likely driver is at fault.=20
When it crashes, the stack dump looks like the following

# ping 10.2.242.93 -I 192.168.2.10
PING 10.2.242.93 (10.2.242.93) from 192.168.2.10: 56 data byt  329.068077] =
Unable to handle kernel NULL pointer dereference at virtual address 0000000=
8

[  329.079579] pgd =3D c0004000
[  329.082277] [00000008] *pgd=3D00000000
[  329.085844] Internal error: Oops: 5 [#1] PREEMPT SMP THUMB2
[  329.091390] Modules linked in: ota_crypto ath_pktlog(PO) umac(O) ath_dev=
(PO) ath_dfs(PO) ath_rate_atheros(PO) ath_hal(PO) adf(PO) asf(PO) evbug
[  329.104228] CPU: 3 PID: 247 Comm: kworker/3:1H Tainted: P           O 3.=
10.84-perf-gbc40dee-35160-g0d54083 #1
[  329.114126] Workqueue: qcrypto_seq_response_wq seq_response
[  329.119678] task: c94fd080 ti: c97be000 task.ti: c97be000
[  329.125062] PC is at scatterwalk_map_and_copy+0x1e/0x98
[  329.130272] LR is at authenc_esn_geniv_ahash_done+0x29/0x3c
[  329.135824] pc : [<c02cd432>]    lr : [<c02df0fd>]    psr: 20000033
[  329.135824] sp : c97bfe98  ip : 00000000  fp : c0c189e4
[  329.147282] r10: c91585ac  r9 : c9158564  r8 : c0b163c8
[  329.152490] r7 : 00000000  r6 : 00000001  r5 : 00000000  r4 : 271ae748
[  329.158999] r3 : c0b6155c  r2 : 00000000  r1 : 00000000  r0 : 00000000
[  329.165510] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segme=
nt kernel
[  329.172977] Control: 50c5787d  Table: 1267c06a  DAC: 00000015
[  329.178706]
[  329.178706] PC: 0xc02cd3b2:
[  329.182958] d3b0  f3c243e2 3201020b 1b2c441d bf284294 42b44614 4634bf28 =
ff5ef7ff 46394605
[  329.191117] d3d0  0f00f1b8 4629d101 46224638 f02a4427 4628fadf fb62f645 =
5004f8d9 464842a6
[  329.199277] d3f0  f04f4641 eba60201 44250604 5004f8c9 e9ddd1cd e9dd3400 =
e9dd5602 b0067804
[  329.207436] d410  8200e8bd 4506e96d 8e04e9cd 38c8f246 08b1f2cc 6702e9cd =
f8d8b084 94034000
[  329.215596] d430  688cb33b 91012600 b17446b6 1935684f 970242aa 680cd310 =
d40807a4 b32c698c
[  329.223756] d450  462e3110 2c009101 f7ffd1f0 f8deff27 21004008 e7f5462e =
a9014417 461a1bbe
[  329.231915] d470  96029b0a ff86f7ff 990aa801 f7ff2200 9a03ff5d 3000f8d8 =
d10d429a e9ddb004
[  329.240075] d490  e9dd4500 b0046702 8100e8bd 462e6909 0103f021 e7d5688c =
ffacf661 f2474608
[  329.248236] d4b0  f2cc21d8 f72b0172 bf00b85b 4504e96d f24f460c f1040120 =
f2cc0228 e9cd0189
[  329.256397]
[  329.256397] LR: 0xc02df07d:
[  329.260650] f07c  e7cf0149 ebc96cb2 46500308 e9d46961 6ae56702 65a36992 =
6aa36561 64e76a21
[  329.268809] f09c  652264a6 e9c46665 68d31317 46014798 bf00e7b5 4e02e96d =
f5004604 f7ed708c
[  329.276968] f0bc  f504fa6b f7ed7080 4620fa67 4e00e9dd f6fdb002 bf00bea1 =
4504e96d e9cd460d
[  329.285127] f0dc  68c46e02 6923b082 b9496c1a 44222601 f8d26a1b 6ce100cc =
96006c22 f98cf7ee
[  329.293287] f0fc  462968a3 b0024620 4500e9dd 6e02e9dd 4718b004 3406e96d =
5602e9cd 4606460d
[  329.301448] f11c  7e04e9cd e9d26902 6eda4310 f1034404 34ac0140 69d74620 =
681b6121 b1284798
[  329.309608] f13c  3400e9dd 5602e9dd bd80b004 01acf106 f1066c72 eb010350 =
46200147 692361e3
[  329.317768] f15c  0707ea21 622761a2 f8d66972 60e610a4 60a1402a f8536162 =
47983c3c d1df2800
[  329.325927] f17c  46206cf1 62276c33 e9c46922 69733106 10a8f8d6 402b60e6 =
616360a1 3c3cf852
[  329.334086]
[  329.334086] SP: 0xc97bfe18:
[  329.338340] fe18  00000001 c0b2cf80 c1b9f4c0 c0b2cf80 60000013 271ae748 =
c02cd432 20000033
[  329.346500] fe38  ffffffff c97bfe84 c0b163c8 c9158564 c91585ac c06172f5 =
00000000 00000000
[  329.354658] fe58  00000000 c0b6155c 271ae748 00000000 00000001 00000000 =
c0b163c8 c9158564
[  329.362819] fe78  c91585ac c0c189e4 00000000 c97bfe98 c02df0fd c02cd432 =
20000033 ffffffff
[  329.370978] fe98  c9158564 00008b43 00000001 271ae748 cab26540 00000000 =
00000001 00000000
[  329.379139] feb8  c0c18950 c02df0fd 00000001 c02d087f c0c189fc 00000001 =
00000000 c03bc4c7
[  329.387299] fed8  c0c189ec c0c189e0 c1ba1540 c0c189ec c97b4e80 c0b6ada0 =
c1ba1540 c1ba6800
[  329.395458] fef8  00000001 c1ba1540 c97be008 c01458ab c97bff20 00000000 =
00000000 00000000
[  329.403619]
[  329.403619] FP: 0xc0c18964:
[  329.407871] 8964  01000000 01010001 00010001 00000000 00000000 00000002 =
00000007 00000008
[  329.416031] 8984  00530053 cbd5b000 cb6d6800 00000000 00000000 00000000 =
00000000 00000000
[  329.424191] 89a4  cb6ab300 cb6ab600 00000003 00000001 00000000 c0c189b8 =
c0c189b8 00000000
[  329.432350] 89c4  00000000 cb6ab600 c0c189cc c0c189cc c0c189cc 00000000 =
00000300 00000000
[  329.440510] 89e4  00000001 cb6c0f00 000000e0 c0c189f0 c0c189f0 c03bc449 =
00000001 00000001
[  329.448670] 8a04  00000003 cb6ab300 cb6ab500 00000000 00000000 00000000 =
00000001 00000007
[  329.456829] 8a24  0000000d 00000000 00000002 00000001 00000000 00000000 =
00000004 00000002
[  329.464989] 8a44  00000000 00000000 00000000 00000000 0000000e 00000001 =
cb9f8a18 00000000
[  329.473150]
[  329.473150] R3: 0xc0b614dc:
[  329.477403] 14dc  c0b61514 c0562ad1 c0562c2d 00000000 c0b6150c c0b6149c =
00000002 0000000b
[  329.485561] 14fc  c0b61514 c0562d39 00000000 00000000 c0b6149c c0b614ec =
00000000 00000003
[  329.493722] 151c  0010000b 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[  329.501881] 153c  00000000 c0b61180 c0b61fc8 c0563e95 c0563dad 00000000 =
00000000 00000000
[  329.510042] 155c  c0563d3d c0563541 c05656d9 00000000 c0563ec5 c0563bd9 =
c0563d1d 00000000
[  329.518201] 157c  c0564009 c0563f59 c05640ad c0563bf5 00000000 c0563b59 =
c0563b1d c0563779
[  329.526361] 159c  c05639e5 c0563a45 00000000 00000000 00000000 00000003 =
00000000 00000000
[  329.534521] 15bc  00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 cbc01780
[  329.542681]
[  329.542681] R8: 0xc0b16348:
[  329.546934] 6348  c41ad32f 0ec67274 cfcdd6f2 051177a9 5b749545 91a8341e =
6e7e1c4c a4a2bd17
[  329.555093] 6368  fac75ffb 301bfea0 f1105a26 3bccfb7d 65a91991 af75b8ca =
9b044835 51d8e96e
[  329.563253] 6388  0fbd0b82 c561aad9 046a0e5f ceb6af04 90d34de8 5a0fecb3 =
a5d9c4e1 6f0565ba
[  329.571413] 63a8  31608756 fbbc260d 3ab7828b f06b23d0 ae0ec13c 64d26067 =
00000000 00000001
[  329.579572] 63c8  271ae748 002fb0d7 00000009 c0113069 c0113031 00000022 =
ffffffff 00000000
[  329.587732] 63e8  00000000 00000000 00000000 0000000f 0000000f 0000000f =
0000000f 00000000
[  329.595892] 6408  cbc3b900 cbc3b9c0 cbc3ba80 cbc26300 cbc3bb40 00000001 =
00000000 0000263b
[  329.604051] 6428  000003e8 00000001 00000001 0000006e 00000020 00000001 =
00000000 0007a120
[  329.612211]
[  329.612211] R9: 0xc91584e4:
[  329.616464] 84e4  00000028 00000004 00000000 c0d72b02 00000400 00000004 =
00000000 c0d7e762
[  329.624624] 8504  0000002c 0000007c 1173b02c 00000002 00000000 00000000 =
00000000 c02df0d5
[  329.632784] 8524  c02dfb11 c02dfa91 f50339d1 cff361ff 12a93443 655f0e57 =
05cf5684 c0d7e762
[  329.640943] 8544  0000002c 0000007c 1173b02c 00000002 00000000 00000000 =
00000000 00000000
[  329.649103] 8564  00100100 00200200 c02d0869 c9158564 ca4a2040 00000000 =
00000004 c91584f0
[  329.657264] 8584  caf6b740 caf6b700 00000000 00000000 00000000 00000000 =
00000000 00000000
[  329.665423] 85a4  00100100 00200200 00000000 c9158564 00000000 cb6ab500 =
c91584f0 00000004
[  329.673582] 85c4  00200200 c02dfbb9 c9158480 ca4a2e00 00000000 00000070 =
c9158404 00000054
[  329.681743]
[  329.681743] R10: 0xc915852c:
[  329.686083] 852c  f50339d1 cff361ff 12a93443 655f0e57 05cf5684 c0d7e762 =
0000002c 0000007c
[  329.694242] 854c  1173b02c 00000002 00000000 00000000 00000000 00000000 =
00100100 00200200
[  329.702402] 856c  c02d0869 c9158564 ca4a2040 00000000 00000004 c91584f0 =
caf6b740 caf6b700
[  329.710561] 858c  00000000 00000000 00000000 00000000 00000000 00000000 =
00100100 00200200
[  329.718721] 85ac  00000000 c9158564 00000000 cb6ab500 c91584f0 00000004 =
00200200 c02dfbb9
[  329.726882] 85cc  c9158480 ca4a2e00 00000000 00000070 c9158404 00000054 =
00000000 c03bace3
[  329.735040] 85ec  00000000 00000000 0000007c 00000000 0a330000 799f27c1 =
1fc4c9ce b981ee60
[  329.743200] 860c  df442c11 81453d07 4ade9fdd 2be94b5c 8c2259c8 a6814796 =
8fde90c1 0e958c2f
[  329.751363] Process kworker/3:1H (pid: 247, stack limit =3D 0xc97be238)
[  329.757785] Stack: (0xc97bfe98 to 0xc97c0000)
[  329.762125] fe80:                                                       =
c9158564 00008b43
[  329.770286] fea0: 00000001 271ae748 cab26540 00000000 00000001 00000000 =
c0c18950 c02df0fd
[  329.778446] fec0: 00000001 c02d087f c0c189fc 00000001 00000000 c03bc4c7 =
c0c189ec c0c189e0
[  329.786607] fee0: c1ba1540 c0c189ec c97b4e80 c0b6ada0 c1ba1540 c1ba6800 =
00000001 c1ba1540
[  329.794765] ff00: c97be008 c01458ab c97bff20 00000000 00000000 00000000 =
00000001 c97b4e80
[  329.802926] ff20: c1ba1540 c97b4e98 c1ba1554 c97be000 c0b6a9ad c1ba1540 =
00000000 c0146313
[  329.811085] ff40: 00000000 cbcb5e84 cbcb5e84 c97bff84 c97b4e80 c0146231 =
00000000 00000000
[  329.819244] ff60: 00000000 c014a6f5 00000000 e7fddef0 c97b4e80 00000000 =
00000000 c97bff7c
[  329.827406] ff80: c97bff7c 00000000 00000000 c97bff8c c97bff8c 271ae748 =
00000000 cbcb5e84
[  329.835564] ffa0: c014a65d 00000000 00000000 c01059e1 00000000 00000000 =
00000000 00000000
[  329.843723] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[  329.851884] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000 =
e7fddef0 e7fddef0
[  329.860049] [<c02cd432>] (scatterwalk_map_and_copy+0x1e/0x98) from [<c02=
df0fd>] (authenc_esn_geniv_ahash_done+0x29/0x3c)
[  329.870897] [<c02df0fd>] (authenc_esn_geniv_ahash_done+0x29/0x3c) from [=
<c03bc4c7>] (seq_response+0x7f/0x174)
[  329.880795] [<c03bc4c7>] (seq_response+0x7f/0x174) from [<c01458ab>] (pr=
ocess_one_work+0xcf/0x324)
[  329.889736] [<c01458ab>] (process_one_work+0xcf/0x324) from [<c0146313>]=
 (worker_thread+0xe3/0x2d8)
[  329.898763] [<c0146313>] (worker_thread+0xe3/0x2d8) from [<c014a6f5>] (k=
thread+0x99/0x9c)
[  329.906924] [<c014a6f5>] (kthread+0x99/0x9c) from [<c01059e1>] (ret_from=
_fork+0x11/0x30)
[  329.914992] Code: f8d8 4000 9403 b33b (688c) 2600
[  329.919785] ---[ end trace b69ab7f7a6c9c9b9 ]---
[  329.924366] Kernel panic - not syncing: Fatal exception in interrupt
[  329.930717] CPU2: stopping
[  329.933414] CPU: 2 PID: 0 Comm: swapper/2 Tainted: P      D    O 3.10.84=
-perf-gbc40dee-35160-g0d54083 #1
[  329.942906] [<c010b7a1>] (unwind_backtrace+0x1/0xf8) from [<c0108dc5>] (=
show_stack+0xd/0x10)
[  329.951312] [<c0108dc5>] (show_stack+0xd/0x10) from [<c010ad19>] (handle=
_IPI+0x151/0x168)
[  329.959463] [<c010ad19>] (handle_IPI+0x151/0x168) from [<c0100425>] (gic=
_handle_irq+0x5d/0x60)
[  329.968064] [<c0100425>] (gic_handle_irq+0x5d/0x60) from [<c061735b>] (_=
_irq_svc+0x3b/0x80)
[  329.976373] Exception stack(0xcbc8bf78 to 0xcbc8bfc0)
[  329.981410] bf60:                                                       =
ffffffed 01088000
[  329.989577] bf80: 00000000 c045e5d9 c0b16458 cbc8a000 c0b17180 c0b6b250 =
cbc8a008 c0b0a400
[  329.997737] bfa0: cbc8a008 00000000 000000b2 cbc8bfc0 c0106535 c0106536 =
60070033 ffffffff
[  330.005914] [<c061735b>] (__irq_svc+0x3b/0x80) from [<c0106536>] (arch_c=
pu_idle+0x1e/0x28)
[  330.014160] [<c0106536>] (arch_cpu_idle+0x1e/0x28) from [<c016cb6f>] (cp=
u_startup_entry+0x14b/0x20c)
[  330.023267] [<c016cb6f>] (cpu_startup_entry+0x14b/0x20c) from [<0860f365=
>] (0x860f365)
[  330.031148] CPU0: stopping
[  330.033854] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D    O 3.10.84=
-perf-gbc40dee-35160-g0d54083 #1
[  330.043347] [<c010b7a1>] (unwind_backtrace+0x1/0xf8) from [<c0108dc5>] (=
show_stack+0xd/0x10)
[  330.051747] [<c0108dc5>] (show_stack+0xd/0x10) from [<c010ad19>] (handle=
_IPI+0x151/0x168)
[  330.059897] [<c010ad19>] (handle_IPI+0x151/0x168) from [<c0100425>] (gic=
_handle_irq+0x5d/0x60)
[  330.068499] [<c0100425>] (gic_handle_irq+0x5d/0x60) from [<c061735b>] (_=
_irq_svc+0x3b/0x80)
[  330.076806] Exception stack(0xc0b0ff18 to 0xc0b0ff60)
[  330.081843] ff00:                                                       =
ffffffed 0106e000
[  330.090011] ff20: 00000000 c045e5d9 c0b16458 c0b0e000 c0b17180 c0b6b250 =
c0b0e008 c0b0a400
[  330.098170] ff40: c0b0e008 00000000 000000b2 c0b0ff60 c0106535 c0106536 =
600f0033 ffffffff
[  330.106351] [<c061735b>] (__irq_svc+0x3b/0x80) from [<c0106536>] (arch_c=
pu_idle+0x1e/0x28)
[  330.114593] [<c0106536>] (arch_cpu_idle+0x1e/0x28) from [<c016cb6f>] (cp=
u_startup_entry+0x14b/0x20c)
[  330.123707] [<c016cb6f>] (cpu_startup_entry+0x14b/0x20c) from [<c060bf31=
>] (rest_init+0x95/0xa8)
[  330.132480] [<c060bf31>] (rest_init+0x95/0xa8) from [<c0a008a1>] (start_=
kernel+0x2bd/0x2d4)
[  330.140785] CPU1: stopping
[  330.143489] CPU: 1 PID: 0 Comm: swapper/1 Tainted: P      D    O 3.10.84=
-perf-gbc40dee-35160-g0d54083 #1
[  330.152982] [<c010b7a1>] (unwind_backtrace+0x1/0xf8) from [<c0108dc5>] (=
show_stack+0xd/0x10)
[  330.161382] [<c0108dc5>] (show_stack+0xd/0x10) from [<c010ad19>] (handle=
_IPI+0x151/0x168)
[  330.169534] [<c010ad19>] (handle_IPI+0x151/0x168) from [<c0100425>] (gic=
_handle_irq+0x5d/0x60)
[  330.178132] [<c0100425>] (gic_handle_irq+0x5d/0x60) from [<c061735b>] (_=
_irq_svc+0x3b/0x80)
[  330.186442] Exception stack(0xcbc89f78 to 0xcbc89fc0)
[  330.191480] 9f60:                                                       =
ffffffed 0107b000
[  330.199645] 9f80: 00000000 c045e5d9 c0b16458 cbc88000 c0b17180 c0b6b250 =
cbc88008 c0b0a400
[  330.207806] 9fa0: cbc88008 00000000 0382a800 cbc89fc0 c0106535 c0106536 =
60070033 ffffffff
[  330.215983] [<c061735b>] (__irq_svc+0x3b/0x80) from [<c0106536>] (arch_c=
pu_idle+0x1e/0x28)
[  330.224227] [<c0106536>] (arch_cpu_idle+0x1e/0x28) from [<c016cb6f>] (cp=
u_startup_entry+0x14b/0x20c)
[  330.233340] [<c016cb6f>] (cpu_startup_entry+0x14b/0x20c) from [<0860f365=
>] (0x860f365)
[  330.241396] Rebooting in 5 seconds..
[  335.246158] Going down for restart now
[  335.249660] Failed to disable secure wdog debug: -4
[  346.257332] Reboot failed -- System halted
