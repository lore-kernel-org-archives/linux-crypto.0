Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A3EC433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 528CF216C8
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:58:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iuewzSFk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbfG3Q6E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 12:58:04 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38538 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbfG3Q6E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 12:58:04 -0400
Received: by mail-pg1-f196.google.com with SMTP id f5so21550885pgu.5
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2019 09:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yrlIIjQiKa7HcwYMn5WEh3zoQP+A3KUtlQo6rp+l/70=;
        b=iuewzSFkAJ/RaH8ev4JnCSNMqw8AdCVdKZPIDPPxMJN7aIlzlj7FaD1UkkKWa7ztc/
         0eBXDQbyOVRPBheNGkAL1XkeD+aQuj/vihJwuK30V4LJC06VEE5qpuQ3GG9ZxH0o5XKT
         N5AmTQ9QKx1M2mZdMRwWdITglvVKF6skoeQfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yrlIIjQiKa7HcwYMn5WEh3zoQP+A3KUtlQo6rp+l/70=;
        b=nGl2IDRJ5iUZuzjcJMH/SmY6lNDoT5xqBwSD3CG0bf+JZzYRsEoB8SzN5NMOZhldwK
         3UIdJgFqg31LaV+uDDc6Bkpe2dBj0b8Qx8qYdAeHia6MsCeX7eNxyxroBFeJMozHOo2p
         EAOJIuPuwKBny7hbiXY6VNjdd6n0nLrUKNiGlWvAew5Y8ybAL7Pq2PjAQBYp40adynmN
         tnLACMyWd48BqrLKJ9sl0kaezqpktSIpdzALevM8msZiLxxtrGztAntJWF2Tky0Nq5Fv
         jG8wvq4gyr+vSmJnAjvLBiCGK7dvDsT74hXxSbduE1XSFWn95IQ94Yky3LhqV4EuVg/0
         +Vmw==
X-Gm-Message-State: APjAAAXRlXDCjGN0YAImofWiUndCFvgLQr6qeZp1lTsepfF4oY7P6Eyq
        RMkNZtrlBp+RLV+aGmqVJxFq5A==
X-Google-Smtp-Source: APXvYqzgUU43LGPOfga52QV0fCYdmludaIg0NRd9KeW0cvvx6BYzyyL0pDTvJ1mSDs+nmFSKfQNygQ==
X-Received: by 2002:a17:90a:fa12:: with SMTP id cm18mr117751421pjb.137.1564505883503;
        Tue, 30 Jul 2019 09:58:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b26sm74248720pfo.129.2019.07.30.09.58.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Jul 2019 09:58:02 -0700 (PDT)
Date:   Tue, 30 Jul 2019 09:58:01 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ux500/crypt: Mark expected switch fall-throughs
Message-ID: <201907300958.55BF0AD@keescook>
References: <20190729223819.GA21985@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190729223819.GA21985@embeddedor>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 29, 2019 at 05:38:19PM -0500, Gustavo A. R. Silva wrote:
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warning (Building: arm):
> 
> drivers/crypto/ux500/cryp/cryp.c: In function ‘cryp_save_device_context’:
> drivers/crypto/ux500/cryp/cryp.c:316:16: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    ctx->key_4_r = readl_relaxed(&src_reg->key_4_r);
> drivers/crypto/ux500/cryp/cryp.c:318:2: note: here
>   case CRYP_KEY_SIZE_192:
>   ^~~~
> drivers/crypto/ux500/cryp/cryp.c:320:16: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    ctx->key_3_r = readl_relaxed(&src_reg->key_3_r);
> drivers/crypto/ux500/cryp/cryp.c:322:2: note: here
>   case CRYP_KEY_SIZE_128:
>   ^~~~
> drivers/crypto/ux500/cryp/cryp.c:324:16: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    ctx->key_2_r = readl_relaxed(&src_reg->key_2_r);
> drivers/crypto/ux500/cryp/cryp.c:326:2: note: here
>   default:
>   ^~~~~~~
> In file included from ./include/linux/io.h:13:0,
>                  from drivers/crypto/ux500/cryp/cryp_p.h:14,
>                  from drivers/crypto/ux500/cryp/cryp.c:15:
> drivers/crypto/ux500/cryp/cryp.c: In function ‘cryp_restore_device_context’:
> ./arch/arm/include/asm/io.h:92:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
>  #define __raw_writel __raw_writel
>                       ^
> ./arch/arm/include/asm/io.h:299:29: note: in expansion of macro ‘__raw_writel’
>  #define writel_relaxed(v,c) __raw_writel((__force u32) cpu_to_le32(v),c)
>                              ^~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:363:3: note: in expansion of macro ‘writel_relaxed’
>    writel_relaxed(ctx->key_4_r, &reg->key_4_r);
>    ^~~~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:365:2: note: here
>   case CRYP_KEY_SIZE_192:
>   ^~~~
> In file included from ./include/linux/io.h:13:0,
>                  from drivers/crypto/ux500/cryp/cryp_p.h:14,
>                  from drivers/crypto/ux500/cryp/cryp.c:15:
> ./arch/arm/include/asm/io.h:92:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
>  #define __raw_writel __raw_writel
>                       ^
> ./arch/arm/include/asm/io.h:299:29: note: in expansion of macro ‘__raw_writel’
>  #define writel_relaxed(v,c) __raw_writel((__force u32) cpu_to_le32(v),c)
>                              ^~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:367:3: note: in expansion of macro ‘writel_relaxed’
>    writel_relaxed(ctx->key_3_r, &reg->key_3_r);
>    ^~~~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:369:2: note: here
>   case CRYP_KEY_SIZE_128:
>   ^~~~
> In file included from ./include/linux/io.h:13:0,
>                  from drivers/crypto/ux500/cryp/cryp_p.h:14,
>                  from drivers/crypto/ux500/cryp/cryp.c:15:
> ./arch/arm/include/asm/io.h:92:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
>  #define __raw_writel __raw_writel
>                       ^
> ./arch/arm/include/asm/io.h:299:29: note: in expansion of macro ‘__raw_writel’
>  #define writel_relaxed(v,c) __raw_writel((__force u32) cpu_to_le32(v),c)
>                              ^~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:371:3: note: in expansion of macro ‘writel_relaxed’
>    writel_relaxed(ctx->key_2_r, &reg->key_2_r);
>    ^~~~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:373:2: note: here
>   default:
>   ^~~~~~~
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/crypto/ux500/cryp/cryp.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/crypto/ux500/cryp/cryp.c b/drivers/crypto/ux500/cryp/cryp.c
> index ece83a363e11..f22f6fa612b3 100644
> --- a/drivers/crypto/ux500/cryp/cryp.c
> +++ b/drivers/crypto/ux500/cryp/cryp.c
> @@ -314,14 +314,17 @@ void cryp_save_device_context(struct cryp_device_data *device_data,
>  	case CRYP_KEY_SIZE_256:
>  		ctx->key_4_l = readl_relaxed(&src_reg->key_4_l);
>  		ctx->key_4_r = readl_relaxed(&src_reg->key_4_r);
> +		/* Fall through */
>  
>  	case CRYP_KEY_SIZE_192:
>  		ctx->key_3_l = readl_relaxed(&src_reg->key_3_l);
>  		ctx->key_3_r = readl_relaxed(&src_reg->key_3_r);
> +		/* Fall through */
>  
>  	case CRYP_KEY_SIZE_128:
>  		ctx->key_2_l = readl_relaxed(&src_reg->key_2_l);
>  		ctx->key_2_r = readl_relaxed(&src_reg->key_2_r);
> +		/* Fall through */
>  
>  	default:
>  		ctx->key_1_l = readl_relaxed(&src_reg->key_1_l);
> @@ -361,14 +364,17 @@ void cryp_restore_device_context(struct cryp_device_data *device_data,
>  	case CRYP_KEY_SIZE_256:
>  		writel_relaxed(ctx->key_4_l, &reg->key_4_l);
>  		writel_relaxed(ctx->key_4_r, &reg->key_4_r);
> +		/* Fall through */
>  
>  	case CRYP_KEY_SIZE_192:
>  		writel_relaxed(ctx->key_3_l, &reg->key_3_l);
>  		writel_relaxed(ctx->key_3_r, &reg->key_3_r);
> +		/* Fall through */
>  
>  	case CRYP_KEY_SIZE_128:
>  		writel_relaxed(ctx->key_2_l, &reg->key_2_l);
>  		writel_relaxed(ctx->key_2_r, &reg->key_2_r);
> +		/* Fall through */
>  
>  	default:
>  		writel_relaxed(ctx->key_1_l, &reg->key_1_l);
> -- 
> 2.22.0
> 

-- 
Kees Cook
