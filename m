From: "Sebastian A. Siewior" <arm-kernel@ml.breakpoint.cc>
Subject: [RFC 0/2] first IDMA support for the Orion/CESA engine
Date: Fri, 14 Aug 2009 21:09:48 +0200
Message-ID: <1250276990-28006-1-git-send-email-arm-kernel@ml.breakpoint.cc>
Cc: linux-arm-kernel@lists.arm.linux.org.uk
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57741 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215AbZHNTKA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2009 15:10:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is the first shot of DMA support for CESA on Orion. Right now, the
IDMA engine is used as memcpy(), no descriptors are used yet. The DMA
support seems to work fine so far. However it seems not to improve the
performance that much I hoped in first place.
The second patch replaces the driver thread with an interrupt thread. I
hacked it very quick together, it compiled and dm-crypt didn't complain.
I hope that the latency between "interrupt" and "copy back" is as short
as possible and maybe the performance improves a little :) I want to
avoid to push everything into the raw interrupt handler.

The next step would be to implement correct DMA-descriptor support and
let IDMA trigger CESA. Since CESA's ch0 has to work with IDMA's ch0 I
don't think it makes much sense to go through the dmaengine framework.
That's why I moved it to the crypto folder. IDMA's ch2 and ch3 could be
exposed to the dmaengine framework if one likes but the XOR engine
provides the same functionality.

Does someone have any objections on the idma-cesa mix? I probably should
add some hooks for the dma engine in case Kirkwood's and Orion's HW is
different here.

I'm off the radar for the next weeks so I can't reply.

- [RFC 1/2] crypto/cesa: add idma for Orion5X support
  also in branch orion_dma at [0]

- [RFC 2/2] crypto/mv-cesa: use threaded interrupts
  also available in branch orion_threaded_irq at [0]

[0] git://git.breakpoint.cc/bigeasy/linux.git

Sebastian
