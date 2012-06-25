From: "cloudy.linux" <cloudy.linux@gmail.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Tue, 26 Jun 2012 00:05:55 +0800
Message-ID: <4FE88C63.8010103@gmail.com>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com> <1339806021-14271-1-git-send-email-gmbnomis@gmail.com> <20120618134718.GL9122@philter.vipri.net> <20120618201235.GA20755@schnuecks.de> <4FE1D09E.4040104@gmail.com> <20120620154131.GR9122@philter.vipri.net> <20120625134050.GB12294@philter.vipri.net> <4FE874BD.2020909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64303 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab2FYQGK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jun 2012 12:06:10 -0400
Received: by eeit10 with SMTP id t10so1307123eei.19
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jun 2012 09:06:09 -0700 (PDT)
In-Reply-To: <4FE874BD.2020909@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2012-6-25 22:25, cloudy.linux wrote:
> On 2012-6-25 21:40, Phil Sutter wrote:
>> Hi,
>>
>> On Wed, Jun 20, 2012 at 05:41:31PM +0200, Phil Sutter wrote:
>>> PS: I am currently working at the address decoding problem, will get
>>> back to in a few days when I have something to test. So stay tuned!
>>
>> I have updated the cesa-dma branch at git://nwl.cc/~n0-1/linux.git with
>> code setting the decoding windows. I hope this fixes the issues on
>> orion. I decided not to publish the changes regarding the second DMA
>> channel for now, as this seems to be support for a second crypto session
>> (handled consecutively, so no real improvement) which is not supported
>> anyway.
>>
>> Greetings, Phil
>>
>>
>> Phil Sutter
>> Software Engineer
>>
>
> Thanks Phil. I'm cloning your git now but the speed is really slow. Last
> time I tried to do this but had to cancel after hours of downloading (at
> only about 20% progress). So the previous tests were actually done with
> 3.5-rc3 (I tried the up-to-date Linus' linux-git, but met compiling
> problem), of course with your patch and Simon's. Could you provide a
> diff based on your last round patch (diff to the not patched kernel
> should also be good, I think)?
>
> In the mean time, I'm still trying with a cloning speed of 5KiB/s ...
>
> Regards
> Cloudy

Hi Phil

This time the machine can't finish the boot again and the console was 
flooded by the message like below:

...

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
MV-CESA:got an interrupt but no pending timer?
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
MV-CESA:got an interrupt but no pending timer?
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

Also, I had to make some modifications to the 
arch/arm/mach-orion5x/common.c to let it compile successfully:
1 Add including of mv_dma.h
2 Add macro to define TARGET_SRAM as 9 (which is defined in addr-map.c, 
so I think the clean solution should be modify the addr-map.h? Anyway, 
as a quick solution the source finally got compiled)

Regards
Cloudy
