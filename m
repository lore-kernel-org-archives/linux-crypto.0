Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C27C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 15:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2600824CFC
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 15:05:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YeeHVzkH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfE3PFG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 11:05:06 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37710 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbfE3PFF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 11:05:05 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so5345852iok.4
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2019 08:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jvt0JcWpyPlkkNAtAO9YUzPTlBiKUJt7TcdxdDpdEuk=;
        b=YeeHVzkHGt0/TRrPUDvopCGyBPvlJT5jKL5fhU9erhoHrokOiEbeVGuVnHm+Ppnyaa
         kobKTc3vQXpOK2NOww38wGIYlJIev8bd2vIhC9expYN+5HdY3fqV5CeA3ZvrYkixAEZF
         x0NPoYFdcuLlPBfVYES7gcPd5QzHcmyzPPB2zXIx6cPo8mUGhC03s6VtLiu2iunOVvs6
         OJ2MZF0anx/ZNMCCD7cQvbKnfKrYMSWjm60QM96JF6Lt6p+qTTDmfz0DBFM3c3t6rkmf
         WsDYV52q7WKU/4fnQQMabGYWCYB/JUHj7W8Ek4qloibiPjKDYxwfW2ZAZ65tN/dvwtnZ
         zyyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jvt0JcWpyPlkkNAtAO9YUzPTlBiKUJt7TcdxdDpdEuk=;
        b=QeMgQv06v0vwVmAnHS9OFEXHUb31mFXYqJwTeu8bVD5VDxgtS3koxF4XDCw9/rDZuJ
         bJiLN32Hg46jdjk51U+ZbSYffAiSllf5Q71DLbKS+hSHzYzk+HMJHEe5ZnFknKpr6q/j
         GHpSpCylPscbZBed1pmR1ZUCQeRz2xs8A1YqrvLlWwtQV53FIHVhACPVRgBwoR/0aJmj
         huK/dBSUF9hTwvzytn5IORpe98riKaOpnU67y7WXs7EQDEHM4mSfTWFC5aEOtMBxVw0R
         MBrOD5oxuwn+eKDWaVLDXGyr6hN6oxPuESwKOwP/bGX+5v6zPsnm/Lfw8vOWuf+FUww2
         Bncw==
X-Gm-Message-State: APjAAAW9n3Cdb/CGneaa5ZRJWLvVl4Fcb+8jVgqKBE5zou4wOYFfwvIz
        tNgX/v/HYcFOPR19P5Fx/MuR07tIwdQaWSqW8JZr2g==
X-Google-Smtp-Source: APXvYqzARUXWGq6q8/hYIVYeT219CiA8uTD6iRPTxw6rj46PxQ9tfJpySmwAjxlwp+nKTX+Z1+8Oi64X31H+Yk76o9E=
X-Received: by 2002:a5d:9d83:: with SMTP id 3mr2768462ion.65.1559228704949;
 Thu, 30 May 2019 08:05:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190529202728.GA35103@gmail.com> <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au> <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <CAKv+Gu-jTWQP0Zp=QpuzX41v8Eb5Bvd0O9ajwSnFkDO-ijBf_A@mail.gmail.com>
 <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
 <20190530142734.qlhgzeal22zxfhk5@gondor.apana.org.au> <CAKv+Gu8jJQCZwiHFORUJUzRaAizWzBQ95EAgYe36sFrcvzb6vg@mail.gmail.com>
 <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com> <20190530143438.d62y3woaogyivqpm@gondor.apana.org.au>
In-Reply-To: <20190530143438.d62y3woaogyivqpm@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 30 May 2019 17:04:51 +0200
Message-ID: <CAKv+Gu87wkLkZZLfsJwc02yuKpDx7Sa=Nx+1YW8pPE4DoWXGRw@mail.gmail.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
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

On Thu, 30 May 2019 at 16:34, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, May 30, 2019 at 04:31:09PM +0200, Ard Biesheuvel wrote:
> >
> > This might work:
>
> Looks good to me.
>

Thanks Herbert,

But given your remark regarding CBC being the only algo that has this
requirement, I wonder if this might be sufficient as well.

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index c0ece44f303b..65b050e3742f 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1844,7 +1844,7 @@ static int skcipher_decrypt(struct skcipher_request *req)
         * The crypto API expects us to set the IV (req->iv) to the last
         * ciphertext block.
         */
-       if (ivsize)
+       if (ctx->cdata.algtype & OP_ALG_AAI_CBC)
                scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen -
                                         ivsize, ivsize, 0);


Iulia, Horia?
