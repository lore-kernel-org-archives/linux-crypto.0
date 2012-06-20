From: "cloudy.linux" <cloudy.linux@gmail.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Wed, 20 Jun 2012 09:16:40 +0800
Message-ID: <4FE12478.2030104@gmail.com>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com> <1339806021-14271-1-git-send-email-gmbnomis@gmail.com> <20120618134718.GL9122@philter.vipri.net> <20120618201235.GA20755@schnuecks.de> <20120619115123.GN9122@philter.vipri.net> <4FE09637.2020802@gmail.com> <20120619171304.GQ9122@philter.vipri.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Simon Baatz <gmbnomis@gmail.com>, linux-crypto@vger.kernel.org,
	andrew@lunn.ch
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59189 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2FTBQv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jun 2012 21:16:51 -0400
Received: by pbbrp8 with SMTP id rp8so10387571pbb.19
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jun 2012 18:16:51 -0700 (PDT)
In-Reply-To: <20120619171304.GQ9122@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CESA still didn't work as expected. But this time the machine 
managed to finish the boot.

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
MV-CESA:mv_completion_timer_callback: waiting for engine finishing (5)
MV-CESA:mv_completion_timer_callback: waiting for engine finishing (4)
MV-CESA:mv_completion_timer_callback: waiting for engine finishing (3)
MV-CESA:mv_completion_timer_callback: waiting for engine finishing (2)
MV-CESA:mv_completion_timer_callback: waiting for engine finishing (1)
alg: hash: Test 1 failed for mv-sha1
00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000010: 00 00 00 00
ata2: SATA link down (SStatus 0 SControl 300)
MV-CESA:completion timer expired (CESA active), cleaning up.
MV-CESA:mv_completion_timer_callback: waiting for engine finishing (5)
MV-CESA:mv_completion_timer_callback: waiting for engine finishing (4)
MV-CESA:mv_completion_timer_callback: waiting for engine finishing (3)
MV-CESA:mv_completion_timer_callback: waiting for engine finishing (2)
MV-CESA:mv_completion_timer_callback: waiting for engine finishing (1)
alg: hash: Test 1 failed for mv-hmac-sha1
00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000010: 00 00 00 00

...

Regards
Cloudy
