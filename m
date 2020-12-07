Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E74C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 12:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C45B4233CF
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 12:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgLGMTF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgLGMTE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 07:19:04 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B7CC0613D0;
        Mon,  7 Dec 2020 04:18:24 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id h21so13479022wmb.2;
        Mon, 07 Dec 2020 04:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fdmojab8DFblo4R8a5uw7uYMmGLz7NhMCeyqh5NST7s=;
        b=Yc5NCuCEbvlagevx0EH2pgwYvkWhWM2nWsB7Q+iasKYh777Oq/PVX7VdkadnIQ7PdT
         /7pas0rjd6iRQPB/Ddi8sSH9xeG+48dUPr1r5S0KVTXwmxE+AWl3xl/768ZGDaRUCj82
         1OGpYSMO+5flqGXJwaO5pEDFAfR0sV2Z7zwQaLGxxvfX6oaGZ0hHgqIi77xJ00rVgZu5
         eI6Qdyl3O91dFS/5uVV/TAaxPnBBH43SBAO/IqBn5r+eTluUX4AexjRZuvH6neAVLgrv
         rX9S/dNYLrFcYZVKjIeBBiw/tsDd4nVj+UexsMeBpSXocsX2qz+laiZmvfTUg2CL4+sx
         WJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fdmojab8DFblo4R8a5uw7uYMmGLz7NhMCeyqh5NST7s=;
        b=ONjgybWmg/n0rzQuGdkyc5bf/fdpB8m62koQKS02gkkbymXzmbzR4qEOF6vOcxKrQX
         SBK2m7luZj4IyoFW81DEbXsBSzHXIgYvU/fDFtMLK8pKKf1fkHPtZwlglUAKYbq/3gso
         xd4h/ennTtspod4uybAdtaQLHj3hhKyiQtaSF6VkENPG0mGCtIHhX48xueP8jitiEQ9d
         WdxTYc+L3PDHjmibHEs0OAk5jZ7rioQSlRmo9dX/x8xCleQ6mndplK+qXr+/x3Fp9LTn
         cAZLN8y7XTVEkAnMBDQRLpOwA2IpJq9GL3UNtFFkWRwd/nDYgFQ5asAu7jI97AHPbOUz
         YmvA==
X-Gm-Message-State: AOAM533Z5Pu0j1mKaMeUtD6fz0eQSZ8x/EL1zG6QtNzMjyFYa0hqhABP
        MHvYo0KOBQMGbJMcxPyhVlg=
X-Google-Smtp-Source: ABdhPJxlHm7SSIDKU6I+RgB8hoP9YF4vYxLOnvHvN2+ZNcdm8wkwn+joJo10ncGTK49Ph7Fo4T7fcw==
X-Received: by 2002:a1c:c90b:: with SMTP id f11mr18087966wmb.47.1607343502868;
        Mon, 07 Dec 2020 04:18:22 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id d191sm13418346wmd.24.2020.12.07.04.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 04:18:22 -0800 (PST)
Date:   Mon, 7 Dec 2020 13:18:20 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: crypto: sun4i-ss: error with kmap
Message-ID: <20201207121820.GB8458@Red>
References: <20201203173846.GA16207@Red>
 <87r1o6bh1u.fsf@nanos.tec.linutronix.de>
 <20201204132631.GA25321@Red>
 <874kl1bod0.fsf@nanos.tec.linutronix.de>
 <20201204192753.GA19782@Red>
 <87wnxx9tle.fsf@nanos.tec.linutronix.de>
 <20201205184334.GA8034@Red>
 <87mtys8268.fsf@nanos.tec.linutronix.de>
 <20201206214053.GA8458@Red>
 <87ft4i79oq.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ft4i79oq.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 07, 2020 at 01:15:49AM +0100, Thomas Gleixner wrote:
> On Sun, Dec 06 2020 at 22:40, Corentin Labbe wrote:
> > On Sat, Dec 05, 2020 at 08:48:15PM +0100, Thomas Gleixner wrote:
> >> So this maps two pages and unmaps the first one. That's all called from
> >> sun4i_ss_opti_poll() and the bug is clearly visible there:
> >> 
> >> 	sg_miter_next(&mi);
> >> 	sg_miter_next(&mo);
> >> 
> >> release_ss:
> >> 	sg_miter_stop(&mi);
> >> 	sg_miter_stop(&mo);
> >> 
> >> Written by yourself :) Same issue in sun4i_ss_cipher_poll()
> >> 
> >> Fix below.
> >> 
> >
> > Unfortunatly, the crash still happen with the fix.
> > See http://kernel.montjoie.ovh/131321.log
> 
> And why are you not looking for the reason of this problem in your own
> code yourself? It's not a regression caused by my work.
> 
> Turn on CONFIG_DEBUG_HIGHMEM on 5.10-rcX or older kernels and you will
> get the very same crashes. My work just made these checks unconditional.
> 
> This was broken forever and it's not my problem that you did not enable
> mandatory debug options when developing this thing.
> 
> I gave you tons of hints by now how to debug this and what to look
> for. Obviously I overlooked something and here is the final hint:
> 
>  	sg_miter_next(&mi);
>  	sg_miter_next(&mo);
> 
>         do {
>            ....
>            if (cond1)
>                sg_miter_next(&mi);      <--- HINT
>            ....
>            if (cond2)
>                sg_miter_next(&mo);
>  
> release_ss:
>  	sg_miter_stop(&mi);
>  	sg_miter_stop(&mo);
> 
> So yes, I overlooked the obvious, but as I said above it's not something
> which my is failing due to my changes. It was broken forever, it just
> was not tested properly. Don't blame the messenger.
> 

Hello

I wasnt blaming you, I set you in TO: since you worked on kmap recently just in case of.
I tryed to debug myself, but since it worked before I was sure the problem was outside my code.

So if I understand correctly, basicly I cannot have two atomic kmap at the same time since it made unmapping them in the right order complex.

I am not sure to have well understood your hint, but could you give me what you think about the following patch which fix (at least) the crash.
Instead of holding SGmiter (and so two kmap), I use only one at a time.

Thanks for your help.

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 99a415e8a13c..4f25e76dc269 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -36,6 +36,8 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	unsigned long flags;
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct sun4i_ss_alg_template *algt;
+	unsigned long toi = 0, too = 0;
+	bool miter_err;
 
 	if (!areq->cryptlen)
 		return 0;
@@ -71,39 +73,51 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	}
 	writel(mode, ss->base + SS_CTL);
 
-	sg_miter_start(&mi, areq->src, sg_nents(areq->src),
-		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
-	sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
-		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
-	sg_miter_next(&mi);
-	sg_miter_next(&mo);
-	if (!mi.addr || !mo.addr) {
-		dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
-		err = -EINVAL;
-		goto release_ss;
-	}
 
 	ileft = areq->cryptlen / 4;
 	oleft = areq->cryptlen / 4;
 	oi = 0;
 	oo = 0;
 	do {
-		todo = min(rx_cnt, ileft);
-		todo = min_t(size_t, todo, (mi.length - oi) / 4);
-		if (todo) {
-			ileft -= todo;
-			writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
-			oi += todo * 4;
-		}
-		if (oi == mi.length) {
-			sg_miter_next(&mi);
-			oi = 0;
+		if (ileft) {
+			sg_miter_start(&mi, areq->src, sg_nents(areq->src),
+					SG_MITER_FROM_SG | SG_MITER_ATOMIC);
+			if (toi)
+				sg_miter_skip(&mi, toi);
+			miter_err = sg_miter_next(&mi);
+			if (!miter_err || !mi.addr) {
+				dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+				err = -EINVAL;
+				goto release_ss;
+			}
+			todo = min(rx_cnt, ileft);
+			todo = min_t(size_t, todo, (mi.length - oi) / 4);
+			if (todo) {
+				ileft -= todo;
+				writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
+				oi += todo * 4;
+			}
+			if (oi == mi.length) {
+				toi += mi.length;
+				oi = 0;
+			}
+			sg_miter_stop(&mi);
 		}
 
 		spaces = readl(ss->base + SS_FCSR);
 		rx_cnt = SS_RXFIFO_SPACES(spaces);
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
 
+		sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
+			       SG_MITER_TO_SG | SG_MITER_ATOMIC);
+		if (too)
+			sg_miter_skip(&mo, too);
+		miter_err = sg_miter_next(&mo);
+		if (!miter_err || !mo.addr) {
+			dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+			err = -EINVAL;
+			goto release_ss;
+		}
 		todo = min(tx_cnt, oleft);
 		todo = min_t(size_t, todo, (mo.length - oo) / 4);
 		if (todo) {
@@ -112,9 +126,10 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 			oo += todo * 4;
 		}
 		if (oo == mo.length) {
-			sg_miter_next(&mo);
 			oo = 0;
+			too += mo.length;
 		}
+		sg_miter_stop(&mo);
 	} while (oleft);
 
 	if (areq->iv) {
@@ -128,8 +143,6 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	}
 
 release_ss:
-	sg_miter_stop(&mo);
-	sg_miter_stop(&mi);
 	writel(0, ss->base + SS_CTL);
 	spin_unlock_irqrestore(&ss->slock, flags);
 	return err;
@@ -194,6 +207,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int obl = 0;	/* length of data in bufo */
 	unsigned long flags;
 	bool need_fallback = false;
+	unsigned long toi = 0, too = 0;
+	bool miter_err;
 
 	if (!areq->cryptlen)
 		return 0;
@@ -253,17 +268,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	}
 	writel(mode, ss->base + SS_CTL);
 
-	sg_miter_start(&mi, areq->src, sg_nents(areq->src),
-		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
-	sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
-		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
-	sg_miter_next(&mi);
-	sg_miter_next(&mo);
-	if (!mi.addr || !mo.addr) {
-		dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
-		err = -EINVAL;
-		goto release_ss;
-	}
 	ileft = areq->cryptlen;
 	oleft = areq->cryptlen;
 	oi = 0;
@@ -271,6 +275,16 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	while (oleft) {
 		if (ileft) {
+			sg_miter_start(&mi, areq->src, sg_nents(areq->src),
+				       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
+			if (toi)
+				sg_miter_skip(&mi, toi);
+			miter_err = sg_miter_next(&mi);
+			if (!miter_err || !mi.addr) {
+				dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+				err = -EINVAL;
+				goto release_ss;
+			}
 			/*
 			 * todo is the number of consecutive 4byte word that we
 			 * can read from current SG
@@ -303,31 +317,38 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				}
 			}
 			if (oi == mi.length) {
-				sg_miter_next(&mi);
+				toi += mi.length;
 				oi = 0;
 			}
+			sg_miter_stop(&mi);
 		}
 
 		spaces = readl(ss->base + SS_FCSR);
 		rx_cnt = SS_RXFIFO_SPACES(spaces);
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
-		dev_dbg(ss->dev,
-			"%x %u/%zu %u/%u cnt=%u %u/%zu %u/%u cnt=%u %u\n",
-			mode,
-			oi, mi.length, ileft, areq->cryptlen, rx_cnt,
-			oo, mo.length, oleft, areq->cryptlen, tx_cnt, ob);
 
 		if (!tx_cnt)
 			continue;
+		sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
+			       SG_MITER_TO_SG | SG_MITER_ATOMIC);
+		if (too)
+			sg_miter_skip(&mo, too);
+		miter_err = sg_miter_next(&mo);
+		if (!miter_err || !mo.addr) {
+			dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+			err = -EINVAL;
+			goto release_ss;
+		}
 		/* todo in 4bytes word */
 		todo = min(tx_cnt, oleft / 4);
 		todo = min_t(size_t, todo, (mo.length - oo) / 4);
+
 		if (todo) {
 			readsl(ss->base + SS_TXFIFO, mo.addr + oo, todo);
 			oleft -= todo * 4;
 			oo += todo * 4;
 			if (oo == mo.length) {
-				sg_miter_next(&mo);
+				too += mo.length;
 				oo = 0;
 			}
 		} else {
@@ -352,12 +373,14 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				obo += todo;
 				oo += todo;
 				if (oo == mo.length) {
+					too += mo.length;
 					sg_miter_next(&mo);
 					oo = 0;
 				}
 			} while (obo < obl);
 			/* bufo must be fully used here */
 		}
+		sg_miter_stop(&mo);
 	}
 	if (areq->iv) {
 		if (mode & SS_DECRYPTION) {
@@ -370,8 +393,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	}
 
 release_ss:
-	sg_miter_stop(&mo);
-	sg_miter_stop(&mi);
 	writel(0, ss->base + SS_CTL);
 	spin_unlock_irqrestore(&ss->slock, flags);
