From: "cloudy.linux" <cloudy.linux@gmail.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Sun, 08 Jul 2012 13:38:47 +0800
Message-ID: <4FF91CE7.7090205@gmail.com>
References: <1339806021-14271-1-git-send-email-gmbnomis@gmail.com> <20120618134718.GL9122@philter.vipri.net> <20120618201235.GA20755@schnuecks.de> <4FE1D09E.4040104@gmail.com> <20120620154131.GR9122@philter.vipri.net> <20120625134050.GB12294@philter.vipri.net> <4FE874BD.2020909@gmail.com> <4FE88C63.8010103@gmail.com> <20120625215928.GA3853@philter.vipri.net> <4FEEAC54.10503@gmail.com> <20120706153018.GB24676@philter.vipri.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49047 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2GHFjH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Jul 2012 01:39:07 -0400
Received: by pbbrp8 with SMTP id rp8so17251089pbb.19
        for <linux-crypto@vger.kernel.org>; Sat, 07 Jul 2012 22:39:06 -0700 (PDT)
In-Reply-To: <20120706153018.GB24676@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2012-7-6 23:30, Phil Sutter wrote:
> Hi Cloudy,
>
> On Sat, Jun 30, 2012 at 03:35:48PM +0800, cloudy.linux wrote:
>> Although I had no idea about what's wrong, I looked in the functional
>> errata (again), And I found what's attached (The doc I got from Internet
>> was a protected PDF, that's why I had to use screen capture).
>> Is this relevant? Or maybe you have already addressed this in the code
>> (I can just read some simple C code)?
>
> To me, doesn't read like a real problem, just a guideline for doing
> things. From the output you sent me in your previous mail, I'd rather
> suspect fetching the first descriptor to be faulty: the next descriptor
> pointer contains the first descriptor's DMA address, all other fields
> are zero (this is the situation when triggering the engine, as on
> kirkwood all I have to do is fill the first descriptor's address in and
> TDMA does the rest) and IDMA triggers an address miss interrupt at
> address 0x0. So probably IDMA starts up and tries to look up decoding
> windows for he up the still zero source and destination addresses.
>
> According to the specs, when using the next descriptor field for
> fetching the first descriptor one also has to set the FETCH_ND field in
> DMA_CTRL register, also for TDMA. Though, on my hardware the only
> working configuration is the implemented one, i.e. without FETCH_ND
> being set.
>
> I have implemented a separate approach just for IDMA, which instead of
> just writing the first descriptor's address to NEXT_DESC does:
> 1. clear CTRL_ENABLE bit
> 2. fill NEXT_DESC
> 3. set CTRL_ENABLE along with FETCH_ND
> hopefully this is the way to go on Orion. Since Marvell's BSP doesn't
> implement *DMA attached to CESA, I have nowhere to look this up. Getting
> it right for TDMA was just a matter of trial and error.
>
> My public git got a few updates, including the code described above.
> Would be great if you could give it a try.
>
> Greetings, Phil
>
>
>
> Phil Sutter
> Software Engineer
>

Hi

Newest result. Still couldn't boot up. This time the source was cloned 
from your git repository.

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
CPU: 0    Not tainted  (3.5.0-rc2+ #3)
pc : [<c01df8e0>]    lr : [<c0015810>]    psr: 20000093
sp : c79b9e58  ip : c79b9da8  fp : c79b9e6c
r10: c02f2164  r9 : c0306322  r8 : 0000001c
r7 : 00000000  r6 : 00000000  r5 : c0312988  r4 : 00000002
r3 : c799c200  r2 : 0000de20  r1 : fdd90000  r0 : fdd90000
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: a005317f  Table: 00004000  DAC: 00000017
Process mv_crypto (pid: 276, stack limit = 0xc79b8270)
Stack: (0xc79b9e58 to 0xc79ba000)
9e40:                                                       c79afc40 
0000001c
9e60: c79b9ea4 c79b9e70 c0047694 c01df858 c788929c 4bf287d9 00000000 
c02f2164
9e80: 0000001c 00000000 c79b9f4c c79bbe18 c02ecc18 c02ef0a0 c79b9ebc 
c79b9ea8
9ea0: c0047844 c0047650 00022000 c02f2164 c79b9ed4 c79b9ec0 c0049b4c 
c0047824
9ec0: c0049ac4 c02ff738 c79b9ee4 c79b9ed8 c0046fd0 c0049ad4 c79b9f04 
c79b9ee8
9ee0: c000985c c0046fb0 c01de804 c025db80 a0000013 fdd20200 c79b9f14 
c79b9f08
9f00: c0008170 c0009834 c79b9f6c c79b9f18 c0008c14 c0008170 00000000 
00000001
9f20: c79b9f60 0000de00 c0312988 c799c200 c7936cc0 c79ac780 c79bbe18 
c02ecc18
9f40: c02ef0a0 c79b9f6c c79b9f70 c79b9f60 c01de804 c025db80 a0000013 
ffffffff
9f60: c79b9fbc c79b9f70 c01de804 c025db80 00000000 c79b9f80 c025d904 
c0035000
9f80: c78897a0 c7827de8 c79b8000 c02ecc18 00000013 c7827de8 c799c200 
c01de620
9fa0: 00000013 00000000 00000000 00000000 c79b9ff4 c79b9fc0 c002da78 
c01de630
9fc0: c7827de8 00000000 c799c200 00000000 c79b9fd0 c79b9fd0 00000000 
c7827de8
9fe0: c002d9e8 c0018354 00000000 c79b9ff8 c0018354 c002d9f8 01e6e7fe 
01e6e7ff
Backtrace:
Function entered at [<c01df848>] from [<c0047694>]
  r5:0000001c r4:c79afc40
Function entered at [<c0047640>] from [<c0047844>]
Function entered at [<c0047814>] from [<c0049b4c>]
  r4:c02f2164 r3:00022000
Function entered at [<c0049ac4>] from [<c0046fd0>]
  r4:c02ff738 r3:c0049ac4
Function entered at [<c0046fa0>] from [<c000985c>]
Function entered at [<c0009824>] from [<c0008170>]
  r6:fdd20200 r5:a0000013 r4:c025db80 r3:c01de804
Function entered at [<c0008160>] from [<c0008c14>]
Exception stack(0xc79b9f18 to 0xc79b9f60)
9f00:                                                       00000000 
00000001
9f20: c79b9f60 0000de00 c0312988 c799c200 c7936cc0 c79ac780 c79bbe18 
c02ecc18
9f40: c02ef0a0 c79b9f6c c79b9f70 c79b9f60 c01de804 c025db80 a0000013 
ffffffff
Function entered at [<c025db70>] from [<c01de804>]
Function entered at [<c01de620>] from [<c002da78>]
Function entered at [<c002d9e8>] from [<c0018354>]
  r6:c0018354 r5:c002d9e8 r4:c7827de8
Code: e89da830 e59f000c eb01ec39 eaffffe9 (e7f001f2)
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

Regards
