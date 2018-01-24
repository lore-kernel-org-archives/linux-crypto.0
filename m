From: Anand Moon <linux.amoon@gmail.com>
Subject: Odroid HC1 cryptsetup:encrypt sata driver
Date: Wed, 24 Jan 2018 18:34:10 +0530
Message-ID: <CANAwSgQ3WE9XmjmzHxJstDz52fj_SFvmBKnMjY3MVjhxJuoFmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f174.google.com ([74.125.82.174]:34066 "EHLO
        mail-ot0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933498AbeAXNEb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 08:04:31 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kamil Konieczny,

I am looking in setup of encrypted sata hard-disk on Odroid XU4/HC1 device.
using following encryption method.

aes-cbc-essiv:sha256 128
aes-cbc-essiv:sha256 256

Here is my defconfig I am using. https://pastebin.com/gF5T2stp

Following crypt benchmark we use to test : https://pastebin.com/WiexsJA2

When I am trying to format the the hard drive I am getting kernel panic.
I have tired different option like below.

*Please guide me in how to fix this bug*

# cryptsetup luksFormat /dev/sda1 --cipher aes-cbc-essiv:sha256
# cryptsetup --cipher aes-cbc-essiv --hash sha256 --use-urandom
--key-file=/dev/urandom --master-key-file=/dev/urandom
--keyfile-size=256 --key-size=256 luksFormat /dev/sda1

------------------------[kernel panic]-----------------
root@odroid:~# cryptsetup luksFormat /dev/sda1 --cipher aes-cbc-essiv:sha256

WARNING!
========
This will overwrite data on /dev/sda1 irrevocably.

Are you sure? (Type uppercase yes): YES
Enter passphrase:
Verify passphrase:

[ 2078.670930] Unable to handle kernel NULL pointer dereference at
virtual address 00000010
[ 2078.677550] pgd = b0cb4e51
[ 2078.680220] [00000010] *pgd=00000000
[ 2078.683779] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[ 2078.689148] Modules linked in: algif_skcipher af_alg sd_mod sg
evdev uas usb_storage scsi_mod gpio_keys fbtft(C) spidev spi_s3c64xx
ipv6
[ 2078.701377] CPU: 1 PID: 15 Comm: ksoftirqd/1 Tainted: G         C
    4.15.0-rc9-xu4krck #1
[ 2078.709861] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2078.715932] PC is at memcpy+0x80/0x330
[ 2078.719652] LR is at s5p_tasklet_cb+0x19c/0x328
[ 2078.724155] pc : [<c086a040>]    lr : [<c06f48b0>]    psr: 00070093
[ 2078.730396] sp : ee917ebc  ip : 00000010  fp : ee8cbe30
[ 2078.735594] r10: 00000007  r9 : 00000000  r8 : 60070013
[ 2078.740794] r7 : e7812fc4  r6 : ee23a268  r5 : 00000020  r4 : ee23a210
[ 2078.747294] r3 : e7812fc0  r2 : fffffff0  r1 : 00000010  r0 : f1a6b230
[ 2078.753794] Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment none
[ 2078.760986] Control: 10c5387d  Table: 6d6b006a  DAC: 00000051
[ 2078.766705] Process ksoftirqd/1 (pid: 15, stack limit = 0x2572141a)
[ 2078.772944] Stack: (0xee917ebc to 0xee918000)
[ 2078.777276] 7ea0:
             00000020
[ 2078.785426] 7ec0: ee23a268 e7812fc4 60070013 f1a6b230 ee23a210
c06f48b0 ee23a23c ee23a240
[ 2078.793578] 7ee0: 00000000 c0c7d29c 00000000 00000100 00000007
c012ad88 c0d03098 00000006
[ 2078.801723] 7f00: ee916000 c0d93948 00000040 c010159c 00000000
c09030a8 ee917f64 ee917f10
[ 2078.809866] 7f20: c0d03080 c0dab3c0 0000000a 0006c904 c0d03d00
04208040 ee8afa40 ffffe000
[ 2078.818012] 7f40: ee8afa40 c0d0c718 ffffe000 00000000 00000000
ee8afb1c ee8cbe30 c012a550
[ 2078.826157] 7f60: ee916000 c0146eac ee8afb00 ee8afac0 00000000
ee916000 ee8afa40 c0146d5c
[ 2078.834303] 7f80: ee8afb1c c0142ff4 00000000 ee8afac0 c0142ed0
00000000 00000000 00000000
[ 2078.842448] 7fa0: 00000000 00000000 00000000 c01088e8 00000000
00000000 00000000 00000000
[ 2078.850593] 7fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[ 2078.858739] 7fe0: 00000000 00000000 00000000 00000000 00000013
00000000 00400000 00080008
[ 2078.866894] [<c086a040>] (memcpy) from [<c06f48b0>]
(s5p_tasklet_cb+0x19c/0x328)
[ 2078.874255] [<c06f48b0>] (s5p_tasklet_cb) from [<c012ad88>]
(tasklet_action+0x58/0xe4)
[ 2078.882140] [<c012ad88>] (tasklet_action) from [<c010159c>]
(__do_softirq+0x114/0x3b0)
[ 2078.890023] [<c010159c>] (__do_softirq) from [<c012a550>]
(run_ksoftirqd+0x3c/0x64)
[ 2078.897650] [<c012a550>] (run_ksoftirqd) from [<c0146eac>]
(smpboot_thread_fn+0x150/0x268)
[ 2078.905884] [<c0146eac>] (smpboot_thread_fn) from [<c0142ff4>]
(kthread+0x124/0x154)
[ 2078.913596] [<c0142ff4>] (kthread) from [<c01088e8>]
(ret_from_fork+0x14/0x2c)
[ 2078.920784] Code: e320f000 e4913004 e4914004 e4915004 (e4916004)
[ 2078.926846] ---[ end trace 025fbaef2835f80b ]---
[ 2078.931435] Kernel panic - not syncing: Fatal exception in interrupt
[ 2078.937781] CPU2: stopping
[ 2078.940450] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D  C
 4.15.0-rc9-xu4krck #1
[ 2078.948684] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2078.954757] [<c0110c28>] (unwind_backtrace) from [<c010ced0>]
(show_stack+0x10/0x14)
[ 2078.962467] [<c010ced0>] (show_stack) from [<c086bac8>]
(dump_stack+0x84/0x98)
[ 2078.969659] [<c086bac8>] (dump_stack) from [<c010fbb4>]
(handle_IPI+0x334/0x3a8)
[ 2078.977022] [<c010fbb4>] (handle_IPI) from [<c0101484>]
(gic_handle_irq+0x98/0x9c)
[ 2078.984561] [<c0101484>] (gic_handle_irq) from [<c010da4c>]
(__irq_svc+0x6c/0xa8)
[ 2078.992010] Exception stack(0xee8fdf68 to 0xee8fdfb0)
[ 2078.997035] df60:                   00000001 00000000 00000000
c011be00 ee8fc000 c0d04d6c
[ 2079.005185] df80: c0d04dbc 00000004 c0c84870 00000000 00000000
ee8fdfc0 2e117000 ee8fdfb8
[ 2079.013328] dfa0: c0109358 c010935c 600e0013 ffffffff
[ 2079.018354] [<c010da4c>] (__irq_svc) from [<c010935c>]
(arch_cpu_idle+0x38/0x3c)
[ 2079.025725] [<c010935c>] (arch_cpu_idle) from [<c01659b8>]
(do_idle+0x184/0x218)
[ 2079.033089] [<c01659b8>] (do_idle) from [<c0165cf4>]
(cpu_startup_entry+0x18/0x1c)
[ 2079.040627] [<c0165cf4>] (cpu_startup_entry) from [<401018cc>] (0x401018cc)
[ 2079.047554] CPU3: stopping
[ 2079.050240] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D  C
 4.15.0-rc9-xu4krck #1
[ 2079.058474] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2079.064543] [<c0110c28>] (unwind_backtrace) from [<c010ced0>]
(show_stack+0x10/0x14)
[ 2079.072256] [<c010ced0>] (show_stack) from [<c086bac8>]
(dump_stack+0x84/0x98)
[ 2079.079448] [<c086bac8>] (dump_stack) from [<c010fbb4>]
(handle_IPI+0x334/0x3a8)
[ 2079.086813] [<c010fbb4>] (handle_IPI) from [<c0101484>]
(gic_handle_irq+0x98/0x9c)
[ 2079.094352] [<c0101484>] (gic_handle_irq) from [<c010da4c>]
(__irq_svc+0x6c/0xa8)
[ 2079.101801] Exception stack(0xee8fff68 to 0xee8fffb0)
[ 2079.106825] ff60:                   00000001 00000000 00000000
c011be00 ee8fe000 c0d04d6c
[ 2079.114976] ff80: c0d04dbc 00000008 c0c84870 00000000 00000000
ee8fffc0 2e128000 ee8fffb8
[ 2079.123120] ffa0: c0109358 c010935c 60000013 ffffffff
[ 2079.128144] [<c010da4c>] (__irq_svc) from [<c010935c>]
(arch_cpu_idle+0x38/0x3c)
[ 2079.135513] [<c010935c>] (arch_cpu_idle) from [<c01659b8>]
(do_idle+0x184/0x218)
[ 2079.142878] [<c01659b8>] (do_idle) from [<c0165cf4>]
(cpu_startup_entry+0x18/0x1c)
[ 2079.150417] [<c0165cf4>] (cpu_startup_entry) from [<401018cc>] (0x401018cc)
[ 2079.157344] CPU4: stopping
[ 2079.160031] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G      D  C
 4.15.0-rc9-xu4krck #1
[ 2079.168258] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2079.174331] [<c0110c28>] (unwind_backtrace) from [<c010ced0>]
(show_stack+0x10/0x14)
[ 2079.182041] [<c010ced0>] (show_stack) from [<c086bac8>]
(dump_stack+0x84/0x98)
[ 2079.189232] [<c086bac8>] (dump_stack) from [<c010fbb4>]
(handle_IPI+0x334/0x3a8)
[ 2079.196597] [<c010fbb4>] (handle_IPI) from [<c0101484>]
(gic_handle_irq+0x98/0x9c)
[ 2079.204136] [<c0101484>] (gic_handle_irq) from [<c010da4c>]
(__irq_svc+0x6c/0xa8)
[ 2079.211585] Exception stack(0xee901f68 to 0xee901fb0)
[ 2079.216611] 1f60:                   00000001 00000000 00000000
c011be00 ee900000 c0d04d6c
[ 2079.224759] 1f80: c0d04dbc 00000010 c0c84870 00000000 00000000
ee901fc0 2e139000 ee901fb8
[ 2079.232903] 1fa0: c0109358 c010935c 600e0013 ffffffff
[ 2079.237930] [<c010da4c>] (__irq_svc) from [<c010935c>]
(arch_cpu_idle+0x38/0x3c)
[ 2079.245298] [<c010935c>] (arch_cpu_idle) from [<c01659b8>]
(do_idle+0x184/0x218)
[ 2079.252662] [<c01659b8>] (do_idle) from [<c0165cf4>]
(cpu_startup_entry+0x18/0x1c)
[ 2079.260200] [<c0165cf4>] (cpu_startup_entry) from [<401018cc>] (0x401018cc)
[ 2079.267132] CPU0: stopping
[ 2079.269832] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D  C
 4.15.0-rc9-xu4krck #1
[ 2079.278055] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2079.284124] [<c0110c28>] (unwind_backtrace) from [<c010ced0>]
(show_stack+0x10/0x14)
[ 2079.291837] [<c010ced0>] (show_stack) from [<c086bac8>]
(dump_stack+0x84/0x98)
[ 2079.299029] [<c086bac8>] (dump_stack) from [<c010fbb4>]
(handle_IPI+0x334/0x3a8)
[ 2079.306395] [<c010fbb4>] (handle_IPI) from [<c0101484>]
(gic_handle_irq+0x98/0x9c)
[ 2079.313933] [<c0101484>] (gic_handle_irq) from [<c010da4c>]
(__irq_svc+0x6c/0xa8)
[ 2079.321382] Exception stack(0xc0d01f30 to 0xc0d01f78)
[ 2079.326406] 1f20:                                     00000001
00000000 00000000 c011be00
[ 2079.334557] 1f40: c0d00000 c0d04d6c c0d04dbc 00000001 c0c84870
00000000 00000000 c0d01f88
[ 2079.342702] 1f60: 2e0f5000 c0d01f80 c0109358 c010935c 600f0013 ffffffff
[ 2079.349287] [<c010da4c>] (__irq_svc) from [<c010935c>]
(arch_cpu_idle+0x38/0x3c)
[ 2079.356655] [<c010935c>] (arch_cpu_idle) from [<c01659b8>]
(do_idle+0x184/0x218)
[ 2079.364020] [<c01659b8>] (do_idle) from [<c0165cf4>]
(cpu_startup_entry+0x18/0x1c)
[ 2079.371564] [<c0165cf4>] (cpu_startup_entry) from [<c0c00cf8>]
(start_kernel+0x40c/0x418)
[ 2079.379700] CPU5: stopping
[ 2079.382383] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G      D  C
 4.15.0-rc9-xu4krck #1
[ 2079.390613] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2079.396681] [<c0110c28>] (unwind_backtrace) from [<c010ced0>]
(show_stack+0x10/0x14)
[ 2079.404394] [<c010ced0>] (show_stack) from [<c086bac8>]
(dump_stack+0x84/0x98)
[ 2079.411586] [<c086bac8>] (dump_stack) from [<c010fbb4>]
(handle_IPI+0x334/0x3a8)
[ 2079.418950] [<c010fbb4>] (handle_IPI) from [<c0101484>]
(gic_handle_irq+0x98/0x9c)
[ 2079.426489] [<c0101484>] (gic_handle_irq) from [<c010da4c>]
(__irq_svc+0x6c/0xa8)
[ 2079.433940] Exception stack(0xee903f68 to 0xee903fb0)
[ 2079.438966] 3f60:                   00000001 00000000 00000000
c011be00 ee902000 c0d04d6c
[ 2079.447113] 3f80: c0d04dbc 00000020 c0c84870 00000000 00000000
ee903fc0 2e14a000 ee903fb8
[ 2079.455257] 3fa0: c0109358 c010935c 60070013 ffffffff
[ 2079.460284] [<c010da4c>] (__irq_svc) from [<c010935c>]
(arch_cpu_idle+0x38/0x3c)
[ 2079.467651] [<c010935c>] (arch_cpu_idle) from [<c01659b8>]
(do_idle+0x184/0x218)
[ 2079.475016] [<c01659b8>] (do_idle) from [<c0165cf4>]
(cpu_startup_entry+0x18/0x1c)
[ 2079.482554] [<c0165cf4>] (cpu_startup_entry) from [<401018cc>] (0x401018cc)
[ 2079.489485] CPU6: stopping
[ 2079.492172] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G      D  C
 4.15.0-rc9-xu4krck #1
[ 2079.500404] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2079.506472] [<c0110c28>] (unwind_backtrace) from [<c010ced0>]
(show_stack+0x10/0x14)
[ 2079.514184] [<c010ced0>] (show_stack) from [<c086bac8>]
(dump_stack+0x84/0x98)
[ 2079.521377] [<c086bac8>] (dump_stack) from [<c010fbb4>]
(handle_IPI+0x334/0x3a8)
[ 2079.528742] [<c010fbb4>] (handle_IPI) from [<c0101484>]
(gic_handle_irq+0x98/0x9c)
[ 2079.536280] [<c0101484>] (gic_handle_irq) from [<c010da4c>]
(__irq_svc+0x6c/0xa8)
[ 2079.543730] Exception stack(0xee905f68 to 0xee905fb0)
[ 2079.548757] 5f60:                   00000001 00000000 00000000
c011be00 ee904000 c0d04d6c
[ 2079.556904] 5f80: c0d04dbc 00000040 c0c84870 00000000 00000000
ee905fc0 2e15b000 ee905fb8
[ 2079.565048] 5fa0: c0109358 c010935c 600e0013 ffffffff
[ 2079.570075] [<c010da4c>] (__irq_svc) from [<c010935c>]
(arch_cpu_idle+0x38/0x3c)
[ 2079.577442] [<c010935c>] (arch_cpu_idle) from [<c01659b8>]
(do_idle+0x184/0x218)
[ 2079.584807] [<c01659b8>] (do_idle) from [<c0165cf4>]
(cpu_startup_entry+0x18/0x1c)
[ 2079.592345] [<c0165cf4>] (cpu_startup_entry) from [<401018cc>] (0x401018cc)
[ 2079.599276] CPU7: stopping
[ 2079.601962] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G      D  C
 4.15.0-rc9-xu4krck #1
[ 2079.610194] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2079.616263] [<c0110c28>] (unwind_backtrace) from [<c010ced0>]
(show_stack+0x10/0x14)
[ 2079.623975] [<c010ced0>] (show_stack) from [<c086bac8>]
(dump_stack+0x84/0x98)
[ 2079.631167] [<c086bac8>] (dump_stack) from [<c010fbb4>]
(handle_IPI+0x334/0x3a8)
[ 2079.638532] [<c010fbb4>] (handle_IPI) from [<c0101484>]
(gic_handle_irq+0x98/0x9c)
[ 2079.646071] [<c0101484>] (gic_handle_irq) from [<c010da4c>]
(__irq_svc+0x6c/0xa8)
[ 2079.653521] Exception stack(0xee907f68 to 0xee907fb0)
[ 2079.658547] 7f60:                   00000001 00000000 00000000
c011be00 ee906000 c0d04d6c
[ 2079.666695] 7f80: c0d04dbc 00000080 c0c84870 00000000 00000000
ee907fc0 2e16c000 ee907fb8
[ 2079.674839] 7fa0: c0109358 c010935c 600d0013 ffffffff
[ 2079.679865] [<c010da4c>] (__irq_svc) from [<c010935c>]
(arch_cpu_idle+0x38/0x3c)
[ 2079.687233] [<c010935c>] (arch_cpu_idle) from [<c01659b8>]
(do_idle+0x184/0x218)
[ 2079.694598] [<c01659b8>] (do_idle) from [<c0165cf4>]
(cpu_startup_entry+0x18/0x1c)
[ 2079.702136] [<c0165cf4>] (cpu_startup_entry) from [<401018cc>] (0x401018cc)
[ 2079.709079] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

Best Regards
-Anand
