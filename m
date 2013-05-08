From: Tobias Rauter <tobiasrauter@gmail.com>
Subject: [RFC] Freescale DCP crypto acceleration
Date: Wed,  8 May 2013 20:41:12 +0200
Message-ID: <1368038473-6979-1-git-send-email-tobias.rauter@gmail.com>
Cc: "Christoph G. Baumann" <cb@sgoc.de>
To: Tobias Rauter <tobias.rauter@smaxtec.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:47359 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3EHSlp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 May 2013 14:41:45 -0400
Received: by mail-ee0-f53.google.com with SMTP id d49so1129614eek.26
        for <linux-crypto@vger.kernel.org>; Wed, 08 May 2013 11:41:43 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

I am working on a driver for the data co processor of freescale's
imx28 (should also work on mx23 and mx5).  I noticed that Christoph
sent a patch for this device some days ago to the crypto mailing
list. As far as I see this is basically the Freescale-SDK driver with
some modifications for mainline. This was also my first
approach. Since this driver has some problems (duplicated code, mutex in
atomic context) I decided to get the reference manual and write the
driver from scratch. To prevent double work (in case Christoph or
someone else does the same thing), I want to share my work here now.

This is my first real kernel driver so it would be nice if someone
could take some time to find the noob-mistakes and send me feedback.

Things I'm working on:
- get rid of the global device
- at the moment the number of entries of the in/out scatterlist is
  limited to 20. I am working on a ringbuffer where the CPU fills the
  co-processors buffer while it iterates through the pages.
- overall performance
- ATM each scatterlist entry of the request has to be aligned to
  AES_BLOCK_SIZE.  Since I was not able to find a documentation, I
  want to ask if my idea is the right approach to solve this problem:
  use a ablkcipher walk ,iterate through this walk and do
  dma_map_single for each buffer instead of the whole scatterlist.

regards,
Tobias
