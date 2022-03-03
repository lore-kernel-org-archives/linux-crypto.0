Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40009C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 19:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiCCTzu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Mar 2022 14:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbiCCTzu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Mar 2022 14:55:50 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01ED18A794
        for <linux-crypto@vger.kernel.org>; Thu,  3 Mar 2022 11:55:03 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id j17so9545002wrc.0
        for <linux-crypto@vger.kernel.org>; Thu, 03 Mar 2022 11:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zsIbz0/b386hU/ZdkOSBubB6mU+6IwbbmnEE1Ycu+MY=;
        b=P2/lLp3fpnzXDyB/a8TOfUWFAEABVhPQyw4vrBIqcCPNSqVsh75hfUEo7ksNNW/Lcb
         ORQN/swrL9IYwChFBbsy08B20shjCFURo9fA0UgjDt75cIZKeskIDctWDweIMszbiF6m
         3+nmbWDgvuxmybGFmrYHRHpPTjZCB/qljmJZ3vd6zWuX2A0yZ1UHZY77KScrPe2Ub+16
         4cEBAP5AxkTO00SGIVZ8/zdzMBBN5llAfSpc1JftBSSCtowCDLpqBx1t2zciHAwnwV+W
         7sLq/+PwEBc8tt8f0vczCDQUcL29TKHITgigXYDaIVbTLoXTERVs1vX0tt/vf35T8kAu
         f+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zsIbz0/b386hU/ZdkOSBubB6mU+6IwbbmnEE1Ycu+MY=;
        b=xAs7GJK5WDYuGIRBOaoeqNZwLhqe3OiwzoB93RUE0/XOn11Xfx96YAC3DflA+kLae/
         BqEN+UWotjUW1NpsT+LVtoj8cyH/X2SV/iXkuuJOHVBcHzsOebFCN27//g5eRXPBoBnW
         3tHtsu0EAZFZBtRT92ua/OTJaBHnV67k6fo1GFRBq5AyGqrvLRixnioHpDynTHzgmCIZ
         MCFawqUslFpL4L8xsMgpbKC8sdpoezVxXiS7JR+VFgrZj+Fm2BvjzkbjWL/69JvVs/4C
         KE4jNs5Cadq7YmpujhOXAuTG9uLXIOqIDqsCiZw+VTbKzQFuSeXbRVsDYIPVxu5gWe0L
         sZrg==
X-Gm-Message-State: AOAM53172/BHhzVEoDErKe4xLHonzAROMZ+oSEOFLqVaIkZtHy+J3TQC
        lrOrosOfafZI8yk7HzilZZwxnw==
X-Google-Smtp-Source: ABdhPJwSAaV6ui1w2AUfj/WG1jEQ2FypYIkPGjDYhD/nRjjjEqPVDKL8xOYDM+Z1Oa9dFUUITZz1Yw==
X-Received: by 2002:a5d:5407:0:b0:1f0:1246:5a8c with SMTP id g7-20020a5d5407000000b001f012465a8cmr10294116wrv.193.1646337302326;
        Thu, 03 Mar 2022 11:55:02 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id x2-20020a7bc762000000b00380fd1ba4ebsm16466518wmk.9.2022.03.03.11.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 11:55:01 -0800 (PST)
Date:   Thu, 3 Mar 2022 20:54:58 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     John Keeping <john@metanate.com>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v2 06/18] crypto: rockchip: add fallback for cipher
Message-ID: <YiEdEoX79kDp8kUY@Red>
References: <20220302211113.4003816-1-clabbe@baylibre.com>
 <20220302211113.4003816-7-clabbe@baylibre.com>
 <YiDO8Tt9Lhx530Oz@donbot>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YiDO8Tt9Lhx530Oz@donbot>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Thu, Mar 03, 2022 at 02:21:37PM +0000, John Keeping a écrit :
> On Wed, Mar 02, 2022 at 09:11:01PM +0000, Corentin Labbe wrote:
> > The hardware does not handle 0 size length request, let's add a
> > fallback.
> > Furthermore fallback will be used for all unaligned case the hardware
> > cannot handle.
> > 
> > Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  drivers/crypto/rockchip/rk3288_crypto.h       |  2 +
> >  .../crypto/rockchip/rk3288_crypto_skcipher.c  | 97 ++++++++++++++++---
> >  2 files changed, 86 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
> > index c919d9a43a08..8b1e15d8ddc6 100644
> > --- a/drivers/crypto/rockchip/rk3288_crypto.h
> > +++ b/drivers/crypto/rockchip/rk3288_crypto.h
> > @@ -246,10 +246,12 @@ struct rk_cipher_ctx {
> >  	struct rk_crypto_info		*dev;
> >  	unsigned int			keylen;
> >  	u8				iv[AES_BLOCK_SIZE];
> > +	struct crypto_skcipher *fallback_tfm;
> >  };
> >  
> >  struct rk_cipher_rctx {
> >  	u32				mode;
> > +	struct skcipher_request fallback_req;   // keep at the end
> >  };
> >  
> >  enum alg_type {
> > diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
> > index bbd0bf52bf07..bf9d398cc54c 100644
> > --- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
> > +++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
> > @@ -13,6 +13,63 @@
> >  
> >  #define RK_CRYPTO_DEC			BIT(0)
> >  
> > +static int rk_cipher_need_fallback(struct skcipher_request *req)
> > +{
> > +	struct scatterlist *sgs, *sgd;
> > +
> > +	if (!req->cryptlen)
> > +		return true;
> > +
> > +	sgs = req->src;
> > +	while (sgs) {
> > +		if (!IS_ALIGNED(sgs->offset, sizeof(u32))) {
> > +			return true;
> > +		}
> > +		if (sgs->length % 16) {
> 
> Can this be relaxed to check for alignment to 4 rather than 16?  That's
> the requirement for programming the registers.

No we cannot, the hardware could operate only one SG at a time, and the cipher operation need to be complete, so the length should be a multiple of AES_BLOCK_SIZE.
The original driver already have this size check.
But for DES/3DES this check is bad and should be 8, so a fix is needed anyway.

> 
> But I think this check is wrong in general as it doesn't account for
> cryptlen; with fscrypt I'm seeing sgs->length == 255 but cryptlen == 16
> so the hardware can be used but at the moment the fallback path is
> triggered.

Yes, I need to check min(sg->length, cryptlen_remaining) instead.
I will fix that.

Thanks.
