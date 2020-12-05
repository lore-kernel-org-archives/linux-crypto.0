Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE70BC4167B
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Dec 2020 19:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFBB72311C
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Dec 2020 19:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgLETtA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Dec 2020 14:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLETtA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Dec 2020 14:49:00 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D10FC0613D1;
        Sat,  5 Dec 2020 11:48:18 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607197695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5V64cHoDauQUIjehmXNdE3d+yc6rEovliqZd890tZyc=;
        b=2dZo+Tgpz46/CvuMRAaMBs6LBghauRtHEJYgcpKvgHaboX1eRha21sywPs90/boVHgePPW
        4BQ4o7Qf70lN6yBLyI0a2okxXCsi1LIIq4E8VeZIp3fLI/SVaERVtQpJzVF5xsZkSpezWG
        n9tbwfrwuJakp/IDyFWh4UIY5T+8p2K4znYOZGgg2g5bxFPaUSUN/69DeneBxLzMbi5I2y
        phdHLVyRJZEH8+KKgcMNBeMh37Jn33RIshbPbIanUhyyEmwf8tU1vrFbsRngNE00Hfc/u0
        dmGy0w1lKccZ+gk0KbHg/4WM1Ve0y1j1wWskzFuXOCXotUS8naIKBp1BcusgSg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607197695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5V64cHoDauQUIjehmXNdE3d+yc6rEovliqZd890tZyc=;
        b=yo8evh+GXBHbspAYbEKASwVyNqiH9vfFd2JG9cthkSOM+YN9oopdlp3N2ZhOvsUAXW4mFt
        KJ+wK35XaaclkPAw==
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: crypto: sun4i-ss: error with kmap
In-Reply-To: <20201205184334.GA8034@Red>
References: <20201201144529.GA6786@Red> <87v9dlfthf.fsf@nanos.tec.linutronix.de> <20201202195501.GA29296@Red> <877dpzexfr.fsf@nanos.tec.linutronix.de> <20201203173846.GA16207@Red> <87r1o6bh1u.fsf@nanos.tec.linutronix.de> <20201204132631.GA25321@Red> <874kl1bod0.fsf@nanos.tec.linutronix.de> <20201204192753.GA19782@Red> <87wnxx9tle.fsf@nanos.tec.linutronix.de> <20201205184334.GA8034@Red>
Date:   Sat, 05 Dec 2020 20:48:15 +0100
Message-ID: <87mtys8268.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Corentin,

On Sat, Dec 05 2020 at 19:43, Corentin Labbe wrote:
> On Fri, Dec 04, 2020 at 09:58:21PM +0100, Thomas Gleixner wrote:
>> Can you please replace the debug patch with the one below and try again?
>> That stops the trace right on the condition.
>
> Hello, the result could be found at http://kernel.montjoie.ovh/130739.log

Thanks for providing this. This is clearly showing where stuff goes
wrong. It starts here at 729.550001. I removed the uninteresting parts:

0d..2 147103293us : __kmap_local_page_prot <-sg_miter_next
0d..3 147103308us :__kmap_local_pfn_prot: kmap_local_pfn: 1 ffefd000

0d..3 147103311us : __kmap_local_page_prot <-sg_miter_next
0d..4 147103325us : __kmap_local_pfn_prot: kmap_local_pfn: 3 ffefb000

0d..3 147103429us : kunmap_local_indexed <-sg_miter_stop
0d..4 147103433us : kunmap_local_indexed: kunmap_local: 3 ffefd000

So this maps two pages and unmaps the first one. That's all called from
sun4i_ss_opti_poll() and the bug is clearly visible there:

	sg_miter_next(&mi);
	sg_miter_next(&mo);

release_ss:
	sg_miter_stop(&mi);
	sg_miter_stop(&mo);

Written by yourself :) Same issue in sun4i_ss_cipher_poll()

Fix below.

Julia, it might be worth to have a coccinelle check for that. It's the
only place which got it wrong, but this goes unnoticed when code is
e.g. only fully tested on 64bit or as in this case never tested with
full debugging enabled. The whole kmap_atomic and kmap_local (new in
next) family and all users like the sg_miter stuff are affected by this.

Thanks,

        tglx
---
Subject: crypto: sun4i-ss - Fix sg_miter_stop() ordering
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 05 Dec 2020 20:17:28 +0100

sun4i_ss_opti_poll() and sun4i_ss_cipher_poll() do:

        sg_miter_next(&mi);
        sg_miter_next(&mo);
	...
        sg_miter_stop(&mi);
        sg_miter_stop(&mo);

which is the wrong order because sg_miter_next() maps a page with
kmap_atomic() and sg_miter_stop() unmaps it. kmap_atomic() uses a stack
internaly which requires that the nested map is unmapped first. As this
uses the wrong order it triggers the warning in kunmap_local_indexed()
which checks the to be unmapped address and subsequently crashes.

This went unnoticed for 5 years because the ARM kmap_atomic()
implementation had the warning conditional on CONFIG_DEBUG_HIGHMEM which
was obviously never enabled when testing that driver.

Flip the order to cure it.

Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -109,8 +109,8 @@ static int noinline_for_stack sun4i_ss_o
 	}
 
 release_ss:
-	sg_miter_stop(&mi);
 	sg_miter_stop(&mo);
+	sg_miter_stop(&mi);
 	writel(0, ss->base + SS_CTL);
 	spin_unlock_irqrestore(&ss->slock, flags);
 	return err;
@@ -333,8 +333,8 @@ static int sun4i_ss_cipher_poll(struct s
 	}
 
 release_ss:
-	sg_miter_stop(&mi);
 	sg_miter_stop(&mo);
+	sg_miter_stop(&mi);
 	writel(0, ss->base + SS_CTL);
 	spin_unlock_irqrestore(&ss->slock, flags);
 


