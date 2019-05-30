Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E9DCC28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E916425982
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aV3a3Qtp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfE3Nxr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 09:53:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33480 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfE3Nxr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 09:53:47 -0400
Received: by mail-io1-f68.google.com with SMTP id u13so5138508iop.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2019 06:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o1cBK1xetXKqPQsIIl75xlp+mHn3/szubtAs7P5Ucrg=;
        b=aV3a3QtpMLNViDLENhBHXiInGoHjqzPYoqVjaHiako1F0ud6Zv8vgIPbnzMFJf6oRU
         Tu/eQUXbTUUrKaA3CfD0sYTQhYGA+YvZ7or472tod4QzEQVq1/uX0qCm0ixiKXRQ59JY
         +9yhmdudR0wefvU88p3HkWSGJpRXAUmBoRtwrpXN/eonDDUasHf3zt76jqNJIKNCWLef
         WzO5/mRt2LLTszN1YyFdnXoKlqkaM6AZ9DHPKz5xIm1Vzo1aVei2Q8ruz8r098ec1Nyb
         CiFJ9DYnI04MYcLr0XTiplqRxa3ypbYB7DeiKb/DFrbTROK1pRnhSmsUdPkt7NNraiLE
         Ku4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o1cBK1xetXKqPQsIIl75xlp+mHn3/szubtAs7P5Ucrg=;
        b=DchYx+AMfKCTetgfZr6/tQLAh4c67wyhQb1r5JX3siMREMUaRbEKBEOW8sQn9ufVPA
         s3OX1iwj7QeHMSF9bhSOwpAZYwmIDl3J8pZUIhIEuuqtWgIGGmNiqjLjZSzbaVWy7OQd
         oZcCRxzQgHJx+rXCJVTYp81wUXDBT+/38NA4GsjrK5EzHKgfyJIVe5M+YXOGlA/sMo71
         VoaOXaIpKofcKe8SEebncPDpA/ii6ZX/ZBQI5X/EG84wMxNNSim/S0XqbIqVQX+Sd6jn
         xctpURUziGUmlvPhYoLBP4WLplHK6A9v5IzsEOv+pYiXPHyoCNThIAunomSidzrOlKm5
         6wJw==
X-Gm-Message-State: APjAAAV8pNMyoxLYsPzpo52uocbGEbg50LlSn3IR1tBfpDOz2OZqm0dg
        BrOMBCCdYKB8y3sRwUYqCwEwTWUYPDwjWzV2nB/Hwxn27HnYww==
X-Google-Smtp-Source: APXvYqxaz4GV5Y25t4/1krn0WhJBfKXcPRD9UUG155gKE/opIPm5E72E9h3/aLPqygECtWX9Ke/4tfms6QNF36/k2gM=
X-Received: by 2002:a5d:968e:: with SMTP id m14mr2702733ion.49.1559224426119;
 Thu, 30 May 2019 06:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com> <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au> <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 30 May 2019 15:53:32 +0200
Message-ID: <CAKv+Gu-jTWQP0Zp=QpuzX41v8Eb5Bvd0O9ajwSnFkDO-ijBf_A@mail.gmail.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 30 May 2019 at 15:45, Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>
> On 5/30/2019 4:34 PM, Herbert Xu wrote:
> > On Thu, May 30, 2019 at 01:29:41PM +0000, Iuliana Prodan wrote:
> >>
> >> I've tried coping the IV before the extended descriptor allocation, but
> >> is not working and to make it work will need to make more changes in
> >> CAAM. We need the original iv, and if we move it before
> >> skcipher_edesc_alloc we lose it.
> >> The fix exclusively in CAAM drv, to copy iv before DMA map, is more complex.
> >
> > Why doesn't it work (apart from the fact that this only makes sense
> > for CBC and yet you're doing it for everything including CTR)?
> >
> > Cheers,
> >
>
> On the current structure of caamalg, to work, iv needs to be copied
> before memcpy(iv, req->iv, ivsize), from skcipher_edesc_alloc function.
> For this we need edesc, but this cannot be allocated before knowing how
> much memory we need. So, to make it work, we'll need to modify more in CAAM.
>

Would this work?

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index c0ece44f303b..2ef2f76a3cb8 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1832,22 +1832,25 @@ static int skcipher_decrypt(struct
skcipher_request *req)
        struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
        int ivsize = crypto_skcipher_ivsize(skcipher);
        struct device *jrdev = ctx->jrdev;
+       u8 out_iv[AES_BLOCK_SIZE];
        u32 *desc;
        int ret = 0;

-       /* allocate extended descriptor */
-       edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
-       if (IS_ERR(edesc))
-               return PTR_ERR(edesc);
-
        /*
         * The crypto API expects us to set the IV (req->iv) to the last
         * ciphertext block.
         */
        if (ivsize)
-               scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen -
+               scatterwalk_map_and_copy(out_iv, req->src, req->cryptlen -
                                         ivsize, ivsize, 0);

+       /* allocate extended descriptor */
+       edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
+       if (IS_ERR(edesc))
+               return PTR_ERR(edesc);
+
+       memcpy(req->iv, out_iv, ivsize);
+
        /* Create and submit job descriptor*/
        init_skcipher_job(req, edesc, false);
        desc = edesc->hw_desc;
