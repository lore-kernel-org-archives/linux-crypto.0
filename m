Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A48C433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FA36208FE
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BXIYKiGp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgIJMZY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Sep 2020 08:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbgIJMWw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Sep 2020 08:22:52 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF40C061756;
        Thu, 10 Sep 2020 05:22:52 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g4so6481897wrs.5;
        Thu, 10 Sep 2020 05:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wbR7SoxQBCfjqgUzYEK//K0pUx9xypcrfOp3M+Xlkkk=;
        b=BXIYKiGpUbcAZdgcVJHCCYYoWh8ku3rlrGTa7HWb520OhpwcV3vIS7yTGRo2QDZJ+8
         3JG+b+MTgn+zh2YyfxY2fZU2Dbkn7WFzCDsBfFVUXpnFg/Ie0zObTKkbaxK+gUht53zG
         nEwOymmTyrKOmK0evHwpI0AY343wYXmPDCYeVdnRlLWhP1upH7SnOtj4mXPpNz4UVWWC
         8ffY6rhUxJe6Po/XgwnDuYAwbfocPRD3aOshRiCRIHum3UTIx164Koq3aV+hsBOhG0K1
         uYfRMeP2OqVXRurq9BLBRD3SgzYrW39TyQYUef3oSxM62i8YiL0sE/TmC2Qyn80zSsuc
         4nkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wbR7SoxQBCfjqgUzYEK//K0pUx9xypcrfOp3M+Xlkkk=;
        b=IGmqL4giYbnUajeqozQRGbu1qDx1Q2VbgBkcRnSoZDjA7s4jP7UybqMQP18+/HxgMD
         88zSsZ6n8y8Wd9U0fqGd9/G5MhNAEarR1ZCInit9ru99609ZYn7U1YVITxYX5a347l6P
         FjPiP/oWt3ZKJzQj713eI3JIScExMpiMY0d95kxc89989+0CT+j2eQ1fE1+wI9eQgBoI
         lp7xIrWQ692xu9jOQGkyaT0pyer7CoI8QTEiOIxuNOzxrfIjXHF5TGToeDb0B+FH33WL
         CkT+f3cvwE1Sfv8zMltK2prEd5o7Nt0bwttUn0B7iz7jdv1OsQEd7mzH/GvJRq5qczUt
         saig==
X-Gm-Message-State: AOAM530Wp3qqZaeb3Mf/Q4iF3IPBsyjVdeLRsekE7IFjdIjf00xLqlDz
        nmzkSoaxqKjQ1EIIbPj3pAE=
X-Google-Smtp-Source: ABdhPJwPP1GdSmxn2sYE5qC2/b5Xv7umjvz/zLM1phsyVYV+ypqibgli0wj4n4g10BZwpE3oafve3A==
X-Received: by 2002:adf:f042:: with SMTP id t2mr8335938wro.385.1599740570516;
        Thu, 10 Sep 2020 05:22:50 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id v3sm3428918wmh.6.2020.09.10.05.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 05:22:49 -0700 (PDT)
Date:   Thu, 10 Sep 2020 14:22:48 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: sun4i-ss - Fix sparse endianness markers
Message-ID: <20200910122248.GA22506@Red>
References: <202009061621.J89kO43Q%lkp@intel.com>
 <20200907062400.GA15841@gondor.apana.org.au>
 <20200907160029.GC11894@Red>
 <20200908050036.GA19817@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908050036.GA19817@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 08, 2020 at 03:00:36PM +1000, Herbert Xu wrote:
> On Mon, Sep 07, 2020 at 06:00:29PM +0200, Corentin Labbe wrote:
> >
> > The put_unaligned should be _le32.
> > 
> > This fix the modprobe tcrypt fail.
> 
> Thanks.  Yes the original code was correct.
> 
> ---8<---
> This patch also fixes the incorrect endianness markings in the
> sun4i-ss driver.  It should have no effect in the genereated code.
> 
> Instead of using cpu_to_Xe32 followed by a memcpy, this patch
> converts the final hash write to use put_unaligned_X instead.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
> index dc35edd90034..1dff48558f53 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
> @@ -9,6 +9,7 @@
>   * You could find the datasheet in Documentation/arm/sunxi.rst
>   */
>  #include "sun4i-ss.h"
> +#include <asm/unaligned.h>
>  #include <linux/scatterlist.h>
>  
>  /* This is a totally arbitrary value */
> @@ -196,7 +197,7 @@ static int sun4i_hash(struct ahash_request *areq)
>  	struct sg_mapping_iter mi;
>  	int in_r, err = 0;
>  	size_t copied = 0;
> -	__le32 wb = 0;
> +	u32 wb = 0;
>  
>  	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x wl=%u h0=%0x",
>  		__func__, crypto_tfm_alg_name(areq->base.tfm),
> @@ -408,7 +409,7 @@ static int sun4i_hash(struct ahash_request *areq)
>  
>  		nbw = op->len - 4 * nwait;
>  		if (nbw) {
> -			wb = cpu_to_le32(*(u32 *)(op->buf + nwait * 4));
> +			wb = le32_to_cpup((__le32 *)(op->buf + nwait * 4));
>  			wb &= GENMASK((nbw * 8) - 1, 0);
>  
>  			op->byte_count += nbw;
> @@ -417,7 +418,7 @@ static int sun4i_hash(struct ahash_request *areq)
>  
>  	/* write the remaining bytes of the nbw buffer */
>  	wb |= ((1 << 7) << (nbw * 8));
> -	bf[j++] = le32_to_cpu(wb);
> +	((__le32 *)bf)[j++] = cpu_to_le32(wb);
>  
>  	/*
>  	 * number of space to pad to obtain 64o minus 8(size) minus 4 (final 1)
> @@ -479,16 +480,16 @@ static int sun4i_hash(struct ahash_request *areq)
>  	/* Get the hash from the device */
>  	if (op->mode == SS_OP_SHA1) {
>  		for (i = 0; i < 5; i++) {
> +			v = readl(ss->base + SS_MD0 + i * 4);
>  			if (ss->variant->sha1_in_be)
> -				v = cpu_to_le32(readl(ss->base + SS_MD0 + i * 4));
> +				put_unaligned_le32(v, areq->result + i * 4);
>  			else
> -				v = cpu_to_be32(readl(ss->base + SS_MD0 + i * 4));
> -			memcpy(areq->result + i * 4, &v, 4);
> +				put_unaligned_be32(v, areq->result + i * 4);
>  		}
>  	} else {
>  		for (i = 0; i < 4; i++) {
> -			v = cpu_to_le32(readl(ss->base + SS_MD0 + i * 4));
> -			memcpy(areq->result + i * 4, &v, 4);
> +			v = readl(ss->base + SS_MD0 + i * 4);
> +			put_unaligned_le32(v, areq->result + i * 4);
>  		}
>  	}
>  

I get some md5 error on both A20+BE:
alg: ahash: md5 test failed (wrong result) on test vector \"random: psize=129 ksize=0\", cfg=\"random: inplace use_finup nosimd src_divs=[<reimport,nosimd>85.99%@+3999, 5.85%@+30, <reimport>0.96%@+25, <reimport,nosimd>5.9%@+2263, <flush,nosimd>2.11%@+1950] iv_offset=2 key_offset=43\"
and A33+BE:
[   84.469045] alg: ahash: md5 test failed (wrong result) on test vector \"random: psize=322 ksize=0\", cfg=\"random: inplace may_sleep use_finup src_divs=[<reimport>99.1%@+2668, <reimport>0.88%@alignmask+3630, 0.11%@+3403] iv_offset=33\"
+[   84.469074] need:35966fc8 b31ea266 2bf064e9 f20f40ad
+[   84.469084] have:e29e4491 f3b6effc fa366691 00e04bd9

Thoses errors are random. (1 boot out of 2)

The ahash-md5-sun4i-ss is set as "selftest: passed" and I didnt see any failling/absent test in /proc/crypto
So what is this md5 which fail ?

I am still investigating and will try on more platform.
