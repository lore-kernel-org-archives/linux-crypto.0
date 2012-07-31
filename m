From: "cloudy.linux" <cloudy.linux@gmail.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Tue, 31 Jul 2012 20:12:02 +0800
Message-ID: <5017CB92.9010708@gmail.com>
References: <20120618201235.GA20755@schnuecks.de> <4FE1D09E.4040104@gmail.com> <20120620154131.GR9122@philter.vipri.net> <20120625134050.GB12294@philter.vipri.net> <4FE874BD.2020909@gmail.com> <4FE88C63.8010103@gmail.com> <20120625215928.GA3853@philter.vipri.net> <4FEEAC54.10503@gmail.com> <20120706153018.GB24676@philter.vipri.net> <4FF91CE7.7090205@gmail.com> <20120709125450.GB30493@philter.vipri.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54545 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab2GaMMT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Jul 2012 08:12:19 -0400
Received: by eeil10 with SMTP id l10so1601407eei.19
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jul 2012 05:12:18 -0700 (PDT)
In-Reply-To: <20120709125450.GB30493@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Phil

On 2012-7-9 20:54, Phil Sutter wrote:
> Hi,
>
> On Sun, Jul 08, 2012 at 01:38:47PM +0800, cloudy.linux wrote:
>> Newest result. Still couldn't boot up. This time the source was cloned
>> from your git repository.
>>
>> MV-DMA: window at bar0: target 0, attr 14, base 0, size 8000000
>> MV-DMA: window at bar1: target 5, attr 0, base f2200000, size 10000
>> MV-DMA: IDMA engine up and running, IRQ 23
>> MV-DMA: idma_print_and_clear_irq: address miss @0!
>> MV-DMA: tpg.reg + DMA_CTRL = 0x80001d04
>> MV-DMA: tpg.reg + DMA_BYTE_COUNT = 0x0
>> MV-DMA: tpg.reg + DMA_SRC_ADDR = 0x0
>> MV-DMA: tpg.reg + DMA_DST_ADDR = 0x0
>> MV-DMA: tpg.reg + DMA_NEXT_DESC = 0x79b1000
>> MV-DMA: tpg.reg + DMA_CURR_DESC = 0x0
>> MV-DMA: DMA descriptor list:
>> MV-DMA: entry 0 at 0xffdbb000: dma addr 0x79b1000, src 0x79b4000, dst
>> 0xf2200080, count 16, own 1, next 0x79b1010
>> MV-DMA: entry 1 at 0xffdbb010: dma addr 0x79b1010, src 0x799c28c, dst
>> 0xf2200000, count 80, own 1, next 0x79b1020
>> MV-DMA: entry 2 at 0xffdbb020: dma addr 0x79b1020, src 0x0, dst 0x0,
>> count 0, own 0, next 0x79b1030
>> MV-DMA: entry 3 at 0xffdbb030: dma addr 0x79b1030, src 0xf2200080, dst
>> 0x79b4000, count 16, own 1, next 0x0
>> MV-CESA:got an interrupt but no pending timer?
>
> Sucks. What's making me wonder here is, address decoding of address 0x0
> actually shouldn't fail, since window 0 includes this address.
>
> For now, I have pushed two new commits to my public git, adding more
> debugging output for decoding window logic and interrupt case as well as
> decoding window permission fix and changing from FETCH_ND to programming
> the first DMA descriptor's values manually.
>
> In the long term, I probably should try to get access to some
> appropriate hardware myself. This is rather a quiz game than actual bug
> tracking.
>
> Greetings, Phil
>
>
> Phil Sutter
> Software Engineer
>

Sorry for taking so long time to try the latest code. Just came back 
from a vacation and tried several days to get a tight sleep.

The latest console output:

MV-DMA: window at bar0: target 0, attr 14, base 0, size 8000000
MV-DMA: idma_set_deco_win: win(0): BAR 0x7ff0000, size 0x0, enable 
0xffff, prot 0xc031295c
MV-DMA: window at bar1: target 5, attr 0, base f2200000, size 10000
MV-DMA: idma_set_deco_win: win(1): BAR 0x0, size 0x0, enable 0xffff, 
prot 0xc031295c
MV-DMA: IDMA engine up and running, IRQ 23
MV-DMA: idma_print_and_clear_irq: cause 0x3, select 0x1, addr 0x79b4000
MV-DMA: idma_print_and_clear_irq: address miss @0!
MV-DMA: tpg.reg + DMA_CTRL = 0x80001d04
MV-DMA: tpg.reg + DMA_BYTE_COUNT = 0x80000010
MV-DMA: tpg.reg + DMA_SRC_ADDR = 0x79b4000
MV-DMA: tpg.reg + DMA_DST_ADDR = 0xf2200080
MV-DMA: tpg.reg + DMA_NEXT_DESC = 0x79b1010
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
CPU: 0    Not tainted  (3.5.0-rc2+ #4)
pc : [<c01df9d8>]    lr : [<c0015810>]    psr: 20000093
sp : c79b9e68  ip : c79b9db8  fp : c79b9e7c
r10: c02f2164  r9 : c0306322  r8 : 0000001c
r7 : 00000000  r6 : 00000000  r5 : c0312988  r4 : 00000002
r3 : c799c200  r2 : 0000de20  r1 : fdd90000  r0 : fdd90000
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: a005317f  Table: 00004000  DAC: 00000017
Process mv_crypto (pid: 276, stack limit = 0xc79b8270)
Stack: (0xc79b9e68 to 0xc79ba000)
9e60:                   c79afc40 0000001c c79b9eb4 c79b9e80 c0047694 
c01df950
9e80: c7824540 00000001 c79b9eac c02f2164 0000001c 00000000 c79b9f5c 
c79bbe18
9ea0: c02ecc18 c02ef0a0 c79b9ecc c79b9eb8 c0047844 c0047650 00022000 
c02f2164
9ec0: c79b9ee4 c79b9ed0 c0049b4c c0047824 c0049ac4 c02ff738 c79b9ef4 
c79b9ee8
9ee0: c0046fd0 c0049ad4 c79b9f14 c79b9ef8 c000985c c0046fb0 c01dc330 
c01dee08
9f00: a0000013 fdd20200 c79b9f24 c79b9f18 c0008170 c0009834 c79b9fbc 
c79b9f28
9f20: c0008c14 c0008170 0000009b 00000001 fdd90000 0000de00 c0312988 
c799c200
9f40: c7936cc0 c79ac780 c79bbe18 c02ecc18 c02ef0a0 c79b9fbc 00000010 
c79b9f70
9f60: c01dc330 c01dee08 a0000013 ffffffff 00000000 c79b9f80 c025d9fc 
c0035000
9f80: c78897a0 c7827de8 c79b8000 c02ecc18 00000013 c7827de8 c799c200 
c01de718
9fa0: 00000013 00000000 00000000 00000000 c79b9ff4 c79b9fc0 c002da78 
c01de728
9fc0: c7827de8 00000000 c799c200 00000000 c79b9fd0 c79b9fd0 00000000 
c7827de8
9fe0: c002d9e8 c0018354 00000000 c79b9ff8 c0018354 c002d9f8 01e6e7fe 
01e6e7ff
Backtrace:
Function entered at [<c01df940>] from [<c0047694>]
  r5:0000001c r4:c79afc40
Function entered at [<c0047640>] from [<c0047844>]
Function entered at [<c0047814>] from [<c0049b4c>]
  r4:c02f2164 r3:00022000
Function entered at [<c0049ac4>] from [<c0046fd0>]
  r4:c02ff738 r3:c0049ac4
Function entered at [<c0046fa0>] from [<c000985c>]
Function entered at [<c0009824>] from [<c0008170>]
  r6:fdd20200 r5:a0000013 r4:c01dee08 r3:c01dc330
Function entered at [<c0008160>] from [<c0008c14>]
Exception stack(0xc79b9f28 to 0xc79b9f70)
9f20:                   0000009b 00000001 fdd90000 0000de00 c0312988 
c799c200
9f40: c7936cc0 c79ac780 c79bbe18 c02ecc18 c02ef0a0 c79b9fbc 00000010 
c79b9f70
9f60: c01dc330 c01dee08 a0000013 ffffffff
Function entered at [<c01de718>] from [<c002da78>]
Function entered at [<c002d9e8>] from [<c0018354>]
  r6:c0018354 r5:c002d9e8 r4:c7827de8
Code: e89da830 e59f000c eb01ec39 eaffffe9 (e7f001f2)
MV-DMA: idma_print_and_clear_irq: cause 0x3, select 0x1, addr 0x0
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
MV-DMA: idma_print_and_clear_irq: cause 0x3, select 0x1, addr 0x0
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
MV-DMA: idma_print_and_clear_irq: cause 0x3, select 0x1, addr 0x0
MV-DMA: idma_print_and_clear_irq: address miss @0!
MV-DMA: tpg.reg + DMA_CTRL = 0x80001d04
MV-DMA: tpg.reg + DMA_BYTE_COUNT = 0x0
MV-DMA: tpg.reg + DMA_SRC_ADDR = 0x0
MV-DMA: tpg.reg + DMA_DST_ADDR = 0x0
MV-DMA: tpg.reg + DMA_NEXT_DESC = 0x0
MV-DMA: tpg.reg + DMA_CURR_DESC = 0x0
...

Best Regards
Cloudy
