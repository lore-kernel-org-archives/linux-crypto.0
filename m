Return-Path: <SRS0=oD/a=4Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB9DC3F2D1
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 10:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 248C52469F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 10:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="KTWA0Miy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgB1KXw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Feb 2020 05:23:52 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34930 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgB1KXw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Feb 2020 05:23:52 -0500
Received: by mail-wr1-f65.google.com with SMTP id r7so2356001wro.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2020 02:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9BWu8iueEzRzeq+ljMw3GO5DRJ7WpLyt4g4K03+Dz2U=;
        b=KTWA0MiyIymXK1ATe6uz1WTX+uZh1NFjhSn/HYL20oh5JOrl+xuw5wSOntPWjheDpX
         kGr7V+YNENnDtmAZmSBYWYXNd6tx9zjgzOSGVbzH1OIStw6HhgbolY1tuhAAUOwChI+x
         CxIpmiEZXhMn419GAw1JLw2n4CnMiqmhilpsrOvduDDzT8BGQT23vXZr8LVxi1VC08Vk
         np7JOcGNQwnxwRe2kxffJGMutUFJ51YmnTePtg30An5qzu0nhYBUgOVq3ceedls5Nqel
         g7uhLy9OzxwW75lYS5R7WwPDCgGDirl6nncK2xueTAhZUageI22Ms0ns5dvu+4RrP7gG
         34Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9BWu8iueEzRzeq+ljMw3GO5DRJ7WpLyt4g4K03+Dz2U=;
        b=Vjh9dVzw0/RGLatWvVLRS0PtDnadR+n7lSimYbI4wt5ce6musPEyKP0vKc/5l0RTOn
         GDbPiT38XUcNDUKfp+N9pA9lrryA7D6NkMm17En5d3kKWCmo2+jxRr9wFC840B9Wg5TB
         w6i1yUnsApAn3uV8+/1qa009cd883dCIlzfOkxRyIapTb5Eg8dFzLhoY3iZ+/IOLfkpo
         nJF5Hfn1CSiWCHjUaZ81JETUTN87nDHgF/BlnHfmxu09af3dETgrSMm72RgMxd3oFgiD
         hhe9SpRHkJ6Bh/CEX8wMzkGrUO0Gz6KUgn6JZHMvA4j18Zxh0slh/DBC4s5yF4J4k+QZ
         zOEw==
X-Gm-Message-State: APjAAAXvpqYHTopqsXjgWoxP56ooxzfBP9Vk9tubGnpipSKKre0ho1+L
        X0LO4LdKj+9geiikWPeMyllnLg==
X-Google-Smtp-Source: APXvYqxH9owCTU7Ao+s51LMXcNiAO5qGpIEiVwOzyQhqkpDRULgg/35xMMXIZiEqRYYQVhOhgVu2Nw==
X-Received: by 2002:a5d:5148:: with SMTP id u8mr4423764wrt.132.1582885429318;
        Fri, 28 Feb 2020 02:23:49 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id z14sm8597747wrg.76.2020.02.28.02.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 02:23:48 -0800 (PST)
Date:   Fri, 28 Feb 2020 11:23:46 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: drbg: DRBG_CTR should select CTR
Message-ID: <20200228102346.GA1662@Red>
References: <1582127495-5871-1-git-send-email-clabbe@baylibre.com>
 <1582127495-5871-2-git-send-email-clabbe@baylibre.com>
 <20200228003052.GA9060@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228003052.GA9060@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 28, 2020 at 11:30:52AM +1100, Herbert Xu wrote:
> On Wed, Feb 19, 2020 at 03:51:35PM +0000, Corentin Labbe wrote:
> > if CRYPTO_DRBG_CTR is builtin and CTR is module, allocating such algo
> > will fail.
> > DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
> > alg: drbg: Failed to reset rng
> > alg: drbg: Test 0 failed for drbg_pr_ctr_aes128
> > DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
> > alg: drbg: Failed to reset rng
> > alg: drbg: Test 0 failed for drbg_nopr_ctr_aes128
> > DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
> > alg: drbg: Failed to reset rng
> > alg: drbg: Test 0 failed for drbg_nopr_ctr_aes192
> > DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
> > alg: drbg: Failed to reset rng
> > ialg: drbg: Test 0 failed for drbg_nopr_ctr_aes256
> > 
> > Since setting DRBG_CTR=CTR lead to a recursive dependency, let's depends
> > on CTR=y
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  crypto/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index 6d27fc6a7bf5..eddeb43fc01c 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -1822,7 +1822,7 @@ config CRYPTO_DRBG_HASH
> >  config CRYPTO_DRBG_CTR
> >  	bool "Enable CTR DRBG"
> >  	select CRYPTO_AES
> > -	depends on CRYPTO_CTR
> > +	depends on CRYPTO_CTR=y
> 
> This should be turned into a select.
> 

it fail also if I select it:
crypto/Kconfig:1800:error: recursive dependency detected!
crypto/Kconfig:1800:	symbol CRYPTO_DRBG_MENU is selected by CRYPTO_RNG_DEFAULT
crypto/Kconfig:83:	symbol CRYPTO_RNG_DEFAULT is selected by CRYPTO_SEQIV
crypto/Kconfig:330:	symbol CRYPTO_SEQIV is selected by CRYPTO_CTR
crypto/Kconfig:370:	symbol CRYPTO_CTR is selected by CRYPTO_DRBG_CTR
crypto/Kconfig:1822:	symbol CRYPTO_DRBG_CTR depends on CRYPTO_DRBG_MENU

I forgot to say it in the commit message.
I will send a v2 with an updated commit message.

Regards
