Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B082FC43461
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 14:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64D1821532
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 14:56:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFT4wvP4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbgIGO4O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 10:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729890AbgIGOzG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 10:55:06 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641C8C061573;
        Mon,  7 Sep 2020 07:55:05 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x23so4704764wmi.3;
        Mon, 07 Sep 2020 07:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DA8mt+a8EH1CC0yZ7uKHeWsCnJnXRPDo9uEB8E8AISY=;
        b=jFT4wvP4T3fVEUAycW3J7ySI3oeMadWmVlEgPe16Etc1FgD6zPz11FETURPhEt3Ui+
         AblqeWlgy5lQMqY77I0ve+J8GDpmDAKJgMP6EWyZL53yTSzWzfU16GUW5b81jacyOwjv
         amURSBMkw6/UD0ViPggP2+fdmVc6GecyAd6SrZeugqgtjyej0onZiXuTL88DKEcXFR+U
         8a/27hfxsU1gr2lCU9JsTNPa6f4kiEnneaj1CiYHHn+kyxLMiOlLOTKJcDkzDud5CCaE
         ovDBb3msvBXQUcvy6N8puGw3bg3b29ufyAitgZmT80ip7Yj6GF29zZtEIUfd8ueasHlQ
         70YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DA8mt+a8EH1CC0yZ7uKHeWsCnJnXRPDo9uEB8E8AISY=;
        b=oWlsDgu1Bnr8Q0yy9tzREvKRdC8irbBJ+UtehwtHXNsoZM75iv21meAHVQ3CXwkOSE
         j9W9GUaO7KMcvUtwIoU1RWGdipJ161iqjgezoFTa4EgoF/kmumiYj8q5PX5D05pFgePC
         pvVra13VFxTR860sEktKK4gb/Xo+KnkJSDd8bt001oSWeDPRKzP+1XGeEXtdWXSya2H1
         9Ii6/qoHcBxgSUKoIkzWYKtyFmOougRRL3PcAoenyEccwry59LEWhXIKf0fvgiNPvMUp
         npw7GQPmyyOljzIlgtaU75BDirf9sHWc/QVlLkGsxgQdnN3AzuMrqEkv/6qiJigIX/Km
         iAvw==
X-Gm-Message-State: AOAM530bhP8Nt69U5LFlo5Gy/waODNAiWcpZ42MWbyIK2Q6MtUtfO1Hk
        IZAaROl+MRLOS3rKXbnyieC2hjaNMQo=
X-Google-Smtp-Source: ABdhPJxIvaKTAJnzoWVfazf4Iteh4NvH9jeyGHHLlpYv+NMm5ePWS4z5SNxtQRZ0aA/+HOhK6ZkXKw==
X-Received: by 2002:a7b:c387:: with SMTP id s7mr20872656wmj.171.1599490503785;
        Mon, 07 Sep 2020 07:55:03 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id g186sm8893629wmg.25.2020.09.07.07.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 07:55:02 -0700 (PDT)
Date:   Mon, 7 Sep 2020 16:55:01 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: sun4i-ss - Fix SHA1 hash on A33-variant with BE
 CPU
Message-ID: <20200907145501.GB11894@Red>
References: <202009061621.J89kO43Q%lkp@intel.com>
 <20200907062400.GA15841@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907062400.GA15841@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 07, 2020 at 04:24:00PM +1000, Herbert Xu wrote:
> On Sun, Sep 06, 2020 at 04:52:24PM +0800, kernel test robot wrote:
> >
> > >> drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:483:35: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [assigned] [usertype] v @@     got restricted __le32 [usertype] @@
> >    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:483:35: sparse:     expected unsigned int [assigned] [usertype] v
> >    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:483:35: sparse:     got restricted __le32 [usertype]
> >    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:485:35: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [assigned] [usertype] v @@     got restricted __be32 [usertype] @@
> >    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:485:35: sparse:     expected unsigned int [assigned] [usertype] v
> >    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:485:35: sparse:     got restricted __be32 [usertype]
> >    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:490:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [addressable] [assigned] [usertype] v @@     got restricted __le32 [usertype] @@
> >    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:490:27: sparse:     expected unsigned int [addressable] [assigned] [usertype] v
> >    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:490:27: sparse:     got restricted __le32 [usertype]
> 
> This appears to be a genuine bug, on big-endian CPUs at least.
> 
> ---8<---
> When the hash is written out on the A33 variant, it is incorrectly
> swabbed on big-endian CPUs, when it should simply be written out as
> is because it's already in the right format.  This was caught by
> sparse warnings.
> 
> Instead of using cpu_to_Xe32 followed by a memcpy, this patch
> converts the final hash write to use put_unaligned instead.  This
> simplifies the code and makes the A33 variant handling a lot clearer.
> 
> This patch also fixes the incorrect endianness marking on wb,
> although this should have no effect in the genereated code.
> 
> Fixes: 1e02e6fbdadb ("crypto: sun4i-ss - add the A33 variant of SS")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
> index dc35edd90034..84f7921de577 100644
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
> +				put_unaligned(v, areq->result + i * 4);
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

modprobe tcrypt on BE+next-20200828 fail with this patch on A33:
alg: ahash: sha1-sun4i-ss test failed (wrong result) on test vector 0, cfg=\"init+update+final aligned buffer\"

I will try to debug it.
