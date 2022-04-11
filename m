Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A9FC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Apr 2022 08:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiDKIoq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Apr 2022 04:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343932AbiDKIop (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Apr 2022 04:44:45 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223B03EAAE
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 01:42:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id i20so8779782wrb.13
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 01:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8C/eYgaWADBmXGolQTtkrHTLecaGjlBMq7BNuIlcZ8Q=;
        b=xeJcy/KGJE8E9dTJtbqIY8xwk3sT+9zWBdf3lwNQ3wiHwbo4fFi8C+BojzWUb7Nts5
         YPHs4k4QJ+0sAnvMgpBPi22mDZOONbSIFtlnjK/F59s/8G5mPCd2VtQv5dvyliQPsxYp
         KmY7lSTcYSkZjPO7nyfaPW2MGED205fey3U79yIsgipqxg9s588DuLwxZoS624dnuMgM
         MHMyVZLpuUay/uFgMoPsgbusEwXdLTEqSSHSIgL/tziKq/jixkyvnP9IpacQh9Y4GqEV
         Rm3sXKIwUpMR9FpWp1I6M9UhCnaMeQFSP4Q/dXQ3qck3BCxgik8RLUyCr26oF7Q4kt7N
         JBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8C/eYgaWADBmXGolQTtkrHTLecaGjlBMq7BNuIlcZ8Q=;
        b=q+VuZSHdygwPIuLEhunTxhn5U6Mh5YLQJbMLBkKEp1OC/wZRWPb4GacvpRC5Rf1ayh
         uvv4m8So9QFMt4KSKmT2m1msUzvlmxBf3107kIHJhCswD2rnZ4fg+L0Qzgv0Pew+alOn
         8gMla76Tqt9Cs4k//ZZyZ1CkppHFUwo54Kwl88WoUj14Utyzb+S9SaSYsLn6sGe3dplq
         1gV2mD2FmvJK3wjpvn232jC2kJujRQK6m8BtPlw9Kmsc5l3eHRe/yoTFB/0EdkMtLWr6
         cK9vTXnzDblKiNc/iQg+HiTHTWBT6FhzL6Vy14f565EGkZcchMP3Zq2tkJUA3s7F+mHD
         cfOA==
X-Gm-Message-State: AOAM531a/dp8bgh9gyBzP/hhsDXWhy2tevAmHAwf/T9Wqx1o7Iv80AUU
        vtzxQ+SBoLjrgy+IBxIuH8nkSQ==
X-Google-Smtp-Source: ABdhPJwj2GX5sxFvKfF2plvDXxPFsbnq+9QtCMe/UP3BTx6ywnM8X9ZtvNekIgx0mHUmfcedMxPk8Q==
X-Received: by 2002:a5d:5406:0:b0:205:a2c2:3530 with SMTP id g6-20020a5d5406000000b00205a2c23530mr23927622wrv.587.1649666549614;
        Mon, 11 Apr 2022 01:42:29 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id c4-20020a056000184400b00207a55f712asm3337327wri.37.2022.04.11.01.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 01:42:29 -0700 (PDT)
Date:   Mon, 11 Apr 2022 10:42:26 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     John Keeping <john@metanate.com>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v4 06/33] crypto: rockchip: add fallback for cipher
Message-ID: <YlPp8rkH7B742TZM@Red>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
 <20220401201804.2867154-7-clabbe@baylibre.com>
 <YkrV1z5GPVXc+d/X@donbot>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YkrV1z5GPVXc+d/X@donbot>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Mon, Apr 04, 2022 at 12:26:15PM +0100, John Keeping a écrit :
> On Fri, Apr 01, 2022 at 08:17:37PM +0000, Corentin Labbe wrote:
> > The hardware does not handle 0 size length request, let's add a
> > fallback.
> > Furthermore fallback will be used for all unaligned case the hardware
> > cannot handle.
> > 
> > Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> > diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
> > index bbd0bf52bf07..c6b601086c04 100644
> > --- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
> > +++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
> > @@ -13,6 +13,71 @@
> >  
> >  #define RK_CRYPTO_DEC			BIT(0)
> >  
> > +static int rk_cipher_need_fallback(struct skcipher_request *req)
> > +{
> > +	struct scatterlist *sgs, *sgd;
> > +	unsigned int todo, len;
> > +	unsigned int bs = crypto_skcipher_blocksize(tfm);
> > +
> > +	if (!req->cryptlen)
> > +		return true;
> > +
> > +	len = req->cryptlen;
> > +	sgs = req->src;
> > +	while (sgs) {
> > +		if (!IS_ALIGNED(sgs->offset, sizeof(u32))) {
> > +			return true;
> > +		}
> > +		todo = min(len, sgs->length);
> > +		if (todo % bs) {
> > +			return true;
> > +		}
> > +		len -= todo;
> > +		sgs = sg_next(sgs);
> > +	}
> > +	len = req->cryptlen;
> > +	sgd = req->dst;
> > +	while (sgd) {
> > +		if (!IS_ALIGNED(sgd->offset, sizeof(u32))) {
> > +			return true;
> > +		}
> > +		todo = min(len, sgd->length);
> > +		if (todo % bs) {
> > +			return true;
> > +		}
> > +		len -= todo;
> > +		sgd = sg_next(sgd);
> > +	}
> > +	sgs = req->src;
> > +	sgd = req->dst;
> > +	while (sgs && sgd) {
> > +		if (sgs->length != sgd->length)
> 
> This check still seems to be triggering the fallback when it is not
> needed.
> 
> I've done some testing with fscrypt and the series is working great, but
> the stats show the fallback triggering more than I'd expect.  With some
> extra logging here I see output like:
> 
> 	sgs->length=32 sgd->length=255 req->cryptlen=16
> 
> In this case sgs and sgd are both the first (and only) entries in the
> list.  Should this take account of req->cryptlen as well?
> 
> In fact, can't this whole function be folded into one loop over src and
> dst at the same time, since all the checks must be the same?  Something
> like this (untested):
> 
> 	while (sgs && sgd) {
> 		if (!IS_ALIGNED(sgs->offset, sizeof(u32)) ||
> 		    !IS_ALIGNED(sgd->offset, sizeof(u32)))
> 			return true;
> 
> 		todo = min(len, sgs->length);
> 		if (todo % bs)
> 			return true;
> 
> 		if (sgd->length < todo)
> 			return true;
> 
> 		len -= todo;
> 		sgs = sg_next(sgs);
> 		sgd = sg_next(sgd);
> 	}
> 
> 	if (len)
> 		return true;
> 

Thanks, for this hint, I will use it.

Regards
