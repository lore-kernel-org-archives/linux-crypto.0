Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E15C04A95
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Sep 2022 07:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiI2HeJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Sep 2022 03:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235304AbiI2HeE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Sep 2022 03:34:04 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10F0138F30
        for <linux-crypto@vger.kernel.org>; Thu, 29 Sep 2022 00:33:56 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v28so778562wrd.3
        for <linux-crypto@vger.kernel.org>; Thu, 29 Sep 2022 00:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:to:from:date:from:to:cc
         :subject:date;
        bh=LGdaK3qy/JDlMc+f4v0ZcsQhNJbfdJpMi5Ol3/wPCKk=;
        b=C7DW5l8OpKHmP6J6V6XnyMd4ELBO9nXmcVuh5O1Tuu/qJBKYpPWLDR1M36CCeg4kE2
         jIMR3bON6AWvtvM3IRfICLSGx5mlYuHx/J1UOXL9MlX9qz6d1R7H9lx8yPn4Aqxqb/Un
         ADycgQ1eJAkEd9cKoaSfQEqYPVMvNqCi7HVSN/efOIPDueo98/JjqZTSXcVHQ6BN9Rf7
         93OkTEt2AzzGXOsKy67rKmC5iZyQifgAQQWVnuH18mZlFiG/8Ru/Pq/uUrWwMqJqTtUO
         D6xd5InM5To3jRdClbT7qDwwTNEhTEgksZedemh4SG63you8vtotU5UhyiWZYZawaVsP
         1+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=LGdaK3qy/JDlMc+f4v0ZcsQhNJbfdJpMi5Ol3/wPCKk=;
        b=nlsm7Tp6VgejQXpTx/NA0aoYzaWcBSsj3ZZPVBLLpLZkFaybmnhPiBsBmS1EulXx4D
         bRVoPJ1g7DuTKpH6f2ryNPyQCWkJXeWEtulddkfG421t5PqTbOwknVytVP+oG9uOvLWX
         q49soB0yq30gjqP8hkSHVqPorQsjxKoPPCYQtl7oovUaR1x9auv9rFC8LcqXQfGPwiik
         esD4fyQ+MLPTr+J+43GJ5R2spUj7CzLFr17QSvBfsau2cv7GdfLE0SYfhDfpBbk6KWF8
         0QcRC10BHMpzqgQVcaMoY6YUECyQu1kHul1ypyQHESRMfU0VEDxplN5oaFZbIeVDT72o
         xxVQ==
X-Gm-Message-State: ACrzQf3yi5GVX2rsH5W8n89f+6jBd64wRQE9ZgNriq5UKO7gWPCmfUNj
        GIrLHmhOnwq1xl/Za3j8RV3lUg==
X-Google-Smtp-Source: AMsMyM5HRXn6gLFEWsR4ZbAKJk9UifyyzLeCViBeeY4ueRh0LWXfbwVjiHlK38vaupC9+JIMdHfUEA==
X-Received: by 2002:a05:6000:1d94:b0:22c:c4d1:3622 with SMTP id bk20-20020a0560001d9400b0022cc4d13622mr1095415wrb.63.1664436835053;
        Thu, 29 Sep 2022 00:33:55 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id x12-20020a05600c2d0c00b003b51369fbbbsm3856730wmf.4.2022.09.29.00.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:33:54 -0700 (PDT)
Date:   Thu, 29 Sep 2022 09:33:53 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     heiko@sntech.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH RFT 4/5] crypto: rockchip: support the new crypto IP for
 rk3568/rk3588
Message-ID: <YzVKYWknb6EGEgyr@Red>
References: <20220927080048.3151911-1-clabbe@baylibre.com>
 <20220927080048.3151911-5-clabbe@baylibre.com>
 <YzNtkiR/dD0aEZrv@aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YzNtkiR/dD0aEZrv@aurel32.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Sep 27, 2022 at 11:39:30PM +0200, Aurelien Jarno a écrit :
> On 2022-09-27 08:00, Corentin Labbe wrote:
> > Rockchip rk3568 and rk3588 have a common crypto offloader IP.
> > This driver adds support for it.
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  drivers/crypto/rockchip/Kconfig               |  28 +
> >  drivers/crypto/rockchip/Makefile              |   5 +
> >  drivers/crypto/rockchip/rk3588_crypto.c       | 646 ++++++++++++++++++
> >  drivers/crypto/rockchip/rk3588_crypto.h       | 221 ++++++
> >  drivers/crypto/rockchip/rk3588_crypto_ahash.c | 346 ++++++++++
> >  .../crypto/rockchip/rk3588_crypto_skcipher.c  | 340 +++++++++
> >  6 files changed, 1586 insertions(+)
> >  create mode 100644 drivers/crypto/rockchip/rk3588_crypto.c
> >  create mode 100644 drivers/crypto/rockchip/rk3588_crypto.h
> >  create mode 100644 drivers/crypto/rockchip/rk3588_crypto_ahash.c
> >  create mode 100644 drivers/crypto/rockchip/rk3588_crypto_skcipher.c
> > 
> > diff --git a/drivers/crypto/rockchip/Kconfig b/drivers/crypto/rockchip/Kconfig
> > index 1010d897d9ef..84ca1081fd0c 100644
> > --- a/drivers/crypto/rockchip/Kconfig
> > +++ b/drivers/crypto/rockchip/Kconfig
> > @@ -26,3 +26,31 @@ config CRYPTO_DEV_ROCKCHIP_DEBUG
> >  	  Say y to enable Rockchip crypto debug stats.
> >  	  This will create /sys/kernel/debug/rk3288_crypto/stats for displaying
> >  	  the number of requests per algorithm and other internal stats.
> > +
> > +config CRYPTO_DEV_ROCKCHIP2
> > +	tristate "Rockchip's cryptographic offloader V2"
> > +	depends on OF && ARCH_ROCKCHIP
> > +	depends on PM
> > +	select CRYPTO_ECB
> > +	select CRYPTO_CBC
> > +	select CRYPTO_AES
> > +	select CRYPTO_MD5
> > +	select CRYPTO_SHA1
> > +	select CRYPTO_SHA256
> > +	select CRYPTO_SM3
> 
> That should be CRYPTO_SM3_GENERIC

Thanks I will fix it.
