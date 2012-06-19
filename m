From: "cloudy.linux" <cloudy.linux@gmail.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Tue, 19 Jun 2012 23:09:43 +0800
Message-ID: <4FE09637.2020802@gmail.com>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com> <1339806021-14271-1-git-send-email-gmbnomis@gmail.com> <20120618134718.GL9122@philter.vipri.net> <20120618201235.GA20755@schnuecks.de> <20120619115123.GN9122@philter.vipri.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Simon Baatz <gmbnomis@gmail.com>, linux-crypto@vger.kernel.org,
	andrew@lunn.ch
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2FSPKG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jun 2012 11:10:06 -0400
Received: by pbbrp8 with SMTP id rp8so9774942pbb.19
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jun 2012 08:10:06 -0700 (PDT)
In-Reply-To: <20120619115123.GN9122@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2012-6-19 19:51, Phil Sutter wrote:
> Hi Simon,
>
> On Mon, Jun 18, 2012 at 10:12:36PM +0200, Simon Baatz wrote:
>> On Mon, Jun 18, 2012 at 03:47:18PM +0200, Phil Sutter wrote:
>>> On Sat, Jun 16, 2012 at 02:20:19AM +0200, Simon Baatz wrote:
>>>> thanks for providing these patches; it's great to finally see DMA
>>>> support for CESA in the kernel. Additionally, the implementation seems
>>>> to be fine regarding cache incoherencies (at least my test in [*]
>>>> works).
>>>
>>> Thanks for testing and the fixes. Could you also specify the platform
>>> you are testing on?
>>
>> This is a Marvell Kirkwood MV88F6281-A1.
>
> OK, thanks. Just wanted to be sure it's not already the Orion test I'm
> hoping for. :)
>

OK, here comes the Orion test result - Linkstation Pro with 88F5182 A2. 
I didn't enable any debug option yet (I don't know what to be enabled in 
fact). Hope the mv_cesa and mv_dma related kernel messages below could 
be helpful though:

...

MV-DMA: IDMA engine up and running, IRQ 23
MV-DMA: idma_print_and_clear_irq: address miss @0!
MV-DMA: tpg.reg + DMA_CTRL = 0x80001d04
MV-DMA: tpg.reg + DMA_BYTE_COUNT = 0x80000010
MV-DMA: tpg.reg + DMA_SRC_ADDR = 0x79b4008
MV-DMA: tpg.reg + DMA_DST_ADDR = 0xf2200080
MV-DMA: tpg.reg + DMA_NEXT_DESC = 0x79b1010
MV-DMA: tpg.reg + DMA_CURR_DESC = 0x79b1000
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
alg: skcipher: Test 1 failed on encryption for mv-ecb-aes
00000000: 00 11 22 33 44 55 66 77 88 99 aa bb cc dd ee ff
...

MV-CESA:completion timer expired (CESA active), cleaning up.
MV-CESA:mv_completion_timer_callback: waiting for engine finishing
MV-CESA:mv_completion_timer_callback: waiting for engine finishing

Then the console was flooded by the "waiting for engine finshing" 
message and the boot can't finish.

I'll be happy to help to debug this. Just tell me how.
