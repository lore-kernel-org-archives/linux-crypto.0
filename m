Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BF2C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 20:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EDA761027
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 20:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhDMUjD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 16:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhDMUjC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 16:39:02 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B13C061756
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 13:38:42 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id i81so18316734oif.6
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 13:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sOciReA7WbfMclN/SHnVrQLizTrxYQXx4oJ9xPZtlVM=;
        b=Sghs9ai+aAAqxFOGtL+gun8IX7DUGA+FJ6xTCZOLmoxq35iz7NhVEn/c+HMVRRHgaE
         e68Vs8t3Xfi8BTC+PGl0juP0I3VwMEbDtfWhlZ2lOEyuvfDdgHePEkMw6nkHZMoRmGzv
         GcGvKHZFBEzunM1pKnRWj2S8DPObiKsJy31HFg4pLL+jb7WV3KKHxTYZcPl70U3qgwvx
         hYXJ5gam3WJI3JeLmdgsVJjxt7o4pphAAHD+0+9U2SRMghi9+uFwxDVvKOiHLjmDMi9Z
         jtIFBBRWaMfQUz6n20A5iL/qGm8JcAxMzljgUEYhOciibLsgThENs2rJ7kHvy3fHyQgb
         cCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sOciReA7WbfMclN/SHnVrQLizTrxYQXx4oJ9xPZtlVM=;
        b=Ib+zIs3FSwRLxQJL34nHo378RqGkH9uuMiFJddECw2bhlZD5/RlfwJowoQmAvY4yv6
         9J66BlAx/5rntyn3C8TBxviX8VfSXUN0RdyV9kRbQZmZ36GBHhu0dQzKoxJD8BVyiiB7
         j+48c2qvKWmBy7i+c8vv4qtD1snaz4BspybHyqCt3Iv39fUiD70je+Fy5Y3mp8etm8r2
         INlVfUKHjtbODDduWLbEIjtEsqLqeS9+jf50Dmif0htAFM5dlBXIoSe0E5itjiV1RE8t
         IT0TWIPK+2I/2D/N2Fz+zD2cjCKH/Yb9qVMbzZzwWW51xA+03U+7rW8ZCjRwJ57W3oVz
         i68g==
X-Gm-Message-State: AOAM5306gfzhuqaX/jUaXOZHMkIINQfjYbfq8qcjKRJGHRBJM60SzJlz
        ND6QEl+/Bl/Qt4UYO3gL4MG+0Q==
X-Google-Smtp-Source: ABdhPJwHLZMHoZ+xdKwp4Mg/gL11qS+u0P4YNMz7b6FAXqhoK1OPeWn7XZFEY5GybFjGThyV8gZEsg==
X-Received: by 2002:a05:6808:bd6:: with SMTP id o22mr1349359oik.129.1618346321957;
        Tue, 13 Apr 2021 13:38:41 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id n13sm3586803otk.61.2021.04.13.13.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 13:38:41 -0700 (PDT)
Date:   Tue, 13 Apr 2021 15:38:39 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] crypto: qce: Add mode for rfc4309
Message-ID: <20210413203839.GR1538589@yoga>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-4-thara.gopinath@linaro.org>
 <20210405223247.GC904837@yoga>
 <39683997-42ad-bd91-0c31-a9e982e0ba61@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39683997-42ad-bd91-0c31-a9e982e0ba61@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue 13 Apr 14:30 CDT 2021, Thara Gopinath wrote:

> 
> 
> On 4/5/21 6:32 PM, Bjorn Andersson wrote:
> > On Thu 25 Feb 12:27 CST 2021, Thara Gopinath wrote:
> > 
> > > rf4309 is the specification that uses aes ccm algorithms with IPsec
> > > security packets. Add a submode to identify rfc4309 ccm(aes) algorithm
> > > in the crypto driver.
> > > 
> > > Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> > > ---
> > >   drivers/crypto/qce/common.h | 7 +++++--
> > >   1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
> > > index 3bc244bcca2d..3ffe719b79e4 100644
> > > --- a/drivers/crypto/qce/common.h
> > > +++ b/drivers/crypto/qce/common.h
> > > @@ -51,9 +51,11 @@
> > >   #define QCE_MODE_CCM			BIT(12)
> > >   #define QCE_MODE_MASK			GENMASK(12, 8)
> > > +#define QCE_MODE_CCM_RFC4309		BIT(13)
> > > +
> > >   /* cipher encryption/decryption operations */
> > > -#define QCE_ENCRYPT			BIT(13)
> > > -#define QCE_DECRYPT			BIT(14)
> > > +#define QCE_ENCRYPT			BIT(14)
> > > +#define QCE_DECRYPT			BIT(15)
> > 
> > Can't we move these further up, so that next time we want to add
> > something it doesn't require that we also move the ENC/DEC bits?
> 
> Yes I will change it to BIT(30) and BIT(31)
> 
> > 
> > >   #define IS_DES(flags)			(flags & QCE_ALG_DES)
> > >   #define IS_3DES(flags)			(flags & QCE_ALG_3DES)
> > > @@ -73,6 +75,7 @@
> > >   #define IS_CTR(mode)			(mode & QCE_MODE_CTR)
> > >   #define IS_XTS(mode)			(mode & QCE_MODE_XTS)
> > >   #define IS_CCM(mode)			(mode & QCE_MODE_CCM)
> > > +#define IS_CCM_RFC4309(mode)		((mode) & QCE_MODE_CCM_RFC4309)
> > 
> > While leaving room for the typical macro issues, none of the other
> > macros wrap the argument in parenthesis. Please follow the style of the
> > driver, and perhaps follow up with a cleanup patch that just wraps them
> > all in parenthesis?
> 
> This does throw up a checkpatch warning if I don't wrap "mode" in
> parenthesis. How about I keep this for now and I will follow up with a clean
> up for rest of the macros later ?
> 

I don't have a problem with this approach.

Regards,
Bjorn

> > 
> > Regards,
> > Bjorn
> > 
> > >   #define IS_ENCRYPT(dir)			(dir & QCE_ENCRYPT)
> > >   #define IS_DECRYPT(dir)			(dir & QCE_DECRYPT)
> > > -- 
> > > 2.25.1
> > > 
> 
> -- 
> Warm Regards
> Thara
