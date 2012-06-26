From: "cloudy.linux" <cloudy.linux@gmail.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Tue, 26 Jun 2012 19:24:49 +0800
Message-ID: <4FE99C01.2070107@gmail.com>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com> <1339806021-14271-1-git-send-email-gmbnomis@gmail.com> <20120618134718.GL9122@philter.vipri.net> <20120618201235.GA20755@schnuecks.de> <4FE1D09E.4040104@gmail.com> <20120620154131.GR9122@philter.vipri.net> <20120625134050.GB12294@philter.vipri.net> <4FE874BD.2020909@gmail.com> <4FE88C63.8010103@gmail.com> <20120625215928.GA3853@philter.vipri.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:32849 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab2FZLZG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jun 2012 07:25:06 -0400
Received: by eeit10 with SMTP id t10so1569830eei.19
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jun 2012 04:25:04 -0700 (PDT)
In-Reply-To: <20120625215928.GA3853@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2012-6-26 5:59, Phil Sutter wrote:
> Hi,
>
> On Tue, Jun 26, 2012 at 12:05:55AM +0800, cloudy.linux wrote:
>> This time the machine can't finish the boot again and the console was
>> flooded by the message like below:
>
> Oh well. I decided to drop that BUG_ON() again, since I saw it once
> being triggered while in interrupt context. But since the error is
> non-recovering anyway, I guess it may stay there as well.
>
>> Also, I had to make some modifications to the
>> arch/arm/mach-orion5x/common.c to let it compile successfully:
>> 1 Add including of mv_dma.h
>> 2 Add macro to define TARGET_SRAM as 9 (which is defined in addr-map.c,
>> so I think the clean solution should be modify the addr-map.h? Anyway,
>> as a quick solution the source finally got compiled)
>
> Hmm, yeah. Test-compiling for the platform one is writing code for is
> still a good idea. But it's even worse than that: according to the
> specs, for IDMA the SRAM target ID is 5, not 9 like it is for the CPU.
>
> Please apply the attached patch on top of the one I sent earlier,
> without your modifications (the necessary parts are contained in it).
> Also, I've added some log output to the decode window setter, so we see
> what's going on there.
>
> Anyway, thanks a lot for your help so far! I hope next try shows some
> progress at least.
>
> Greetings, Phil
>
>
> Phil Sutter
> Software Engineer
>

Kernel message after applying the latest patch:

MV-DMA: window at bar0: target 0, attr 14, base 0, size 8000000
MV-DMA: window at bar1: target 5, attr 0, base f2200000, size 10000
MV-DMA: IDMA engine up and running, IRQ 23
MV-DMA: idma_print_and_clear_irq: address miss @0!
MV-DMA: tpg.reg + DMA_CTRL = 0x80001d04
MV-DMA: tpg.reg + DMA_BYTE_COUNT = 0x0
MV-DMA: tpg.reg + DMA_SRC_ADDR = 0x0
MV-DMA: tpg.reg + DMA_DST_ADDR = 0x0
MV-DMA: tpg.reg + DMA_NEXT_DESC = 0x79b1000
MV-DMA: tpg.reg + DMA_CURR_DESC = 0x0
MV-DMA: DMA descriptor list:
MV-DMA: entry 0 at 0xffdbb000: dma addr 0x79b1000, src 0x79b4000, dst 
0xf2200080, count 16, own 1, next 0x79b1010
MV-DMA: entry 1 at 0xffdbb010: dma addr 0x79b1010, src 0x799c28c, dst 
0xf2200000, count 80, own 1, next 0x79b1020
MV-DMA: entry 2 at 0xffdbb020: dma addr 0x79b1020, src 0x0, dst 0x0, 
count 0, own 0, next 0x79b1030
MV-DMA: entry 3 at 0xffdbb030: dma addr 0x79b1030, src 0xf2200080, dst 
0x79b4000, count 16, own 1, next 0x0
MV-CESA:got an interrupt but no pending timer?
------------[ cut here ]------------
kernel BUG at drivers/crypto/mv_cesa.c:1126!
Internal error: Oops - BUG: 0 [#1] ARM
Modules linked in:
CPU: 0    Not tainted  (3.5.0-rc4+ #2)
pc : [<c01dfcd0>]    lr : [<c0015c20>]    psr: 20000093
sp : c79b9e58  ip : c79b9da8  fp : c79b9e6c
r10: c02f4184  r9 : c0308342  r8 : 0000001c
r7 : 00000000  r6 : 00000000  r5 : c03149a4  r4 : 00000002
r3 : c799c200  r2 : 0000de20  r1 : fdd90000  r0 : fdd90000
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: a005317f  Table: 00004000  DAC: 00000017
Process mv_crypto (pid: 276, stack limit = 0xc79b8270)
Stack: (0xc79b9e58 to 0xc79ba000)
9e40:                                                       c79afc40 
0000001c
9e60: c79b9ea4 c79b9e70 c0047aa8 c01dfc48 c788929c 4bfb2bc9 00000000 
c02f4184
9e80: 0000001c 00000000 c79b9f4c c79bbe18 c02eec18 c02f10a0 c79b9ebc 
c79b9ea8
9ea0: c0047c58 c0047a64 00022000 c02f4184 c79b9ed4 c79b9ec0 c0049f60 
c0047c38
9ec0: c0049ed8 c0301758 c79b9ee4 c79b9ed8 c00473e4 c0049ee8 c79b9f04 
c79b9ee8
9ee0: c000985c c00473c4 c01debf4 c025dfdc a0000013 fdd20200 c79b9f14 
c79b9f08
9f00: c0008170 c0009834 c79b9f6c c79b9f18 c0008c14 c0008170 00000000 
00000001
9f20: c79b9f60 c78897a0 c03149a4 c799c200 c7936cc0 c79ac780 c79bbe18 
c02eec18
9f40: c02f10a0 c79b9f6c c79b9f70 c79b9f60 c01debf4 c025dfdc a0000013 
ffffffff
9f60: c79b9fbc c79b9f70 c01debf4 c025dfd0 00000000 c79b9f80 c025dd54 
c0035418
9f80: c78897a0 c7827de8 c79b8000 c02eec18 00000013 c7827de8 c799c200 
c01dea10
9fa0: 00000013 00000000 00000000 00000000 c79b9ff4 c79b9fc0 c002de90 
c01dea20
9fc0: c7827de8 00000000 c799c200 00000000 c79b9fd0 c79b9fd0 00000000 
c7827de8
9fe0: c002de00 c001877c 00000000 c79b9ff8 c001877c c002de10 01e6e7fe 
01e6e7ff
Backtrace:
Function entered at [<c01dfc38>] from [<c0047aa8>]
  r5:0000001c r4:c79afc40
Function entered at [<c0047a54>] from [<c0047c58>]
Function entered at [<c0047c28>] from [<c0049f60>]
  r4:c02f4184 r3:00022000
Function entered at [<c0049ed8>] from [<c00473e4>]
  r4:c0301758 r3:c0049ed8
Function entered at [<c00473b4>] from [<c000985c>]
Function entered at [<c0009824>] from [<c0008170>]
  r6:fdd20200 r5:a0000013 r4:c025dfdc r3:c01debf4
Function entered at [<c0008160>] from [<c0008c14>]
Exception stack(0xc79b9f18 to 0xc79b9f60)
9f00:                                                       00000000 
00000001
9f20: c79b9f60 c78897a0 c03149a4 c799c200 c7936cc0 c79ac780 c79bbe18 
c02eec18
9f40: c02f10a0 c79b9f6c c79b9f70 c79b9f60 c01debf4 c025dfdc a0000013 
ffffffff
Function entered at [<c025dfc0>] from [<c01debf4>]
Function entered at [<c01dea10>] from [<c002de90>]
Function entered at [<c002de00>] from [<c001877c>]
  r6:c001877c r5:c002de00 r4:c7827de8
Code: e89da830 e59f000c eb01ec50 eaffffe9 (e7f001f2)
MV-DMA: idma_print_and_clear_irq: address miss @0!
MV-DMA: tpg.reg + DMA_CTRL = 0x80001d04
MV-DMA: tpg.reg + DMA_BYTE_COUNT = 0x0
MV-DMA: tpg.reg + DMA_SRC_ADDR = 0x0
MV-DMA: tpg.reg + DMA_DST_ADDR = 0x0
MV-DMA: tpg.reg + DMA_NEXT_DESC = 0x0
MV-DMA: tpg.reg + DMA_CURR_DESC = 0x0
MV-DMA: DMA descriptor list:
MV-DMA: entry 0 at 0xffdbb000: dma addr 0x79b1000, src 0x79b4000, dst 
0xf2200080, count 16, own 1, next 0x79b1010
MV-DMA: entry 1 at 0xffdbb010: dma addr 0x79b1010, src 0x799c28c, dst 
0xf2200000, count 80, own 1, next 0x79b1020
MV-DMA: entry 2 at 0xffdbb020: dma addr 0x79b1020, src 0x0, dst 0x0, 
count 0, own 0, next 0x79b1030
MV-DMA: entry 3 at 0xffdbb030: dma addr 0x79b1030, src 0xf2200080, dst 
0x79b4000, count 16, own 1, next 0x0
