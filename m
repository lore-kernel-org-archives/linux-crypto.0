Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CF6C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 19:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E531722B48
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 19:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="0bWiTGIV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfLLTgp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 14:36:45 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44072 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730761AbfLLTgo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 14:36:44 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so4001364wrm.11
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 11:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=26CQo4we7KtCfvTKv993lhoi2F1fM7dxkL37tJToeiU=;
        b=0bWiTGIV4TBC4HQqKJut7ledSmNzlbafeuunBgzcIJHkJax0jtZ0jMLzGHUvMlvUuL
         wBaw5vXg3akzsq37fDpW0Q77N7e5aXa/S06o7cgYA7NgLr0o69KowlOxqiuu19P8M24q
         /Bg6rqy7WTOzij1WpJmt3SfL44lA5iGWSoYTl66uT3vqQrhKxRcmNhCen02yyDuy5XyE
         Rk3rRk22Fpc5+Xowl9Ui0okoHiTUhTzE0iEYZvYdCHBVlXEumzAdIY+w4iT13p2AFJGP
         /Zi5u3XtQbysQFaHFQQYTaPgLmcFyDyiTa8KzJsxJc2zxI3dBjQlIcRzYDX5UHHITBRQ
         mIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=26CQo4we7KtCfvTKv993lhoi2F1fM7dxkL37tJToeiU=;
        b=T0+HVmjGFKVn3gs2YxyHhAlId9sQajU6tn0kl59pF3HjoArwfGMF1hq/gr6thQLiaA
         PxBX/ADoUG1HbX3FqpIdq+Cak79zyGy7RiaLFPh9uotA3mzr2GROtwvi1IjVyKigWnwa
         a8FpwZGDSxu7ipq6DFVsvTmkelK1lTNWXXFaQETJwFgLbNLhgfoaH19FFOyDRAHidESi
         cZEXaFQuCCscIORbH0twh5P9VngvJ2S1a9+7IhipywSUeMCqXTdixoi4NZgRpsZIwzPq
         MZYnj/6y2HnhZ8xiT7LCEQRh82MdxUdX9UO7XKzTGjucIlLaCEikGFFymkJxnDfjwIm4
         i8kQ==
X-Gm-Message-State: APjAAAXifMJC0yNjnOxngeA+yi22qG4LWJNvXbarD4qfaQtY+UJW9AeW
        +QZX2gYvATG4DH74TxIKdDAQzw==
X-Google-Smtp-Source: APXvYqwQhaWhC3pY0IFwMztpCBjDmmW+hlZfOXqucMqAQkOxn9NE6sIr+fEMQaQAqzfUrg84KXG7Dw==
X-Received: by 2002:a5d:6441:: with SMTP id d1mr8161069wrw.93.1576179402329;
        Thu, 12 Dec 2019 11:36:42 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id k19sm6820349wmi.42.2019.12.12.11.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 11:36:41 -0800 (PST)
Date:   Thu, 12 Dec 2019 20:36:39 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Brendan Higgins <brendanhiggins@google.com>
Cc:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidgow@google.com, linux-crypto@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH v1 5/7] crypto: amlogic: add unspecified HAS_IOMEM
 dependency
Message-ID: <20191212193639.GA25451@Red>
References: <20191211192742.95699-1-brendanhiggins@google.com>
 <20191211192742.95699-6-brendanhiggins@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211192742.95699-6-brendanhiggins@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 11, 2019 at 11:27:40AM -0800, Brendan Higgins wrote:
> Currently CONFIG_CRYPTO_DEV_AMLOGIC_GXL=y implicitly depends on
> CONFIG_HAS_IOMEM=y; consequently, on architectures without IOMEM we get
> the following build error:
> 
> ld: drivers/crypto/amlogic/amlogic-gxl-core.o: in function `meson_crypto_probe':
> drivers/crypto/amlogic/amlogic-gxl-core.c:240: undefined reference to `devm_platform_ioremap_resource'
> 
> Fix the build error by adding the unspecified dependency.
> 
> Reported-by: Brendan Higgins <brendanhiggins@google.com>
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> ---
>  drivers/crypto/amlogic/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/amlogic/Kconfig b/drivers/crypto/amlogic/Kconfig
> index b90850d18965f..cf95476026708 100644
> --- a/drivers/crypto/amlogic/Kconfig
> +++ b/drivers/crypto/amlogic/Kconfig
> @@ -1,5 +1,6 @@
>  config CRYPTO_DEV_AMLOGIC_GXL
>  	tristate "Support for amlogic cryptographic offloader"
> +	depends on HAS_IOMEM
>  	default y if ARCH_MESON
>  	select CRYPTO_SKCIPHER
>  	select CRYPTO_ENGINE

Acked-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
