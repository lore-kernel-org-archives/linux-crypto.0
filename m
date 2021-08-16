Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FD5C432BE
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 12:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D5E163285
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 12:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhHPMz6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Aug 2021 08:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhHPMz6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Aug 2021 08:55:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8E626328A;
        Mon, 16 Aug 2021 12:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629118526;
        bh=y6ldsfrCTtxUqXgvB/kfPMN6tTYDjZWOZxwxQpHrYtA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iOQq81NGSayBnzQ4XdWllErmXHxAihi6OTHlQPt2LH3IqwO3JcqZehXWSMbs9N8kp
         8BC3QlSd6eY0oApVWLjTE3nMlbfiEfH+Z6Vpv6ph3CxQ77lcUNwe4fSEWJjc9ekzLB
         fhEu82fdauoIRYbSbz/O3S8I0e2DNS/tjfr7oFomguFMpMBbDza436Mke2U0Sf9lwH
         kLj7vGcO2hEY6F/Q9b5USQUdsiAq6und7QqZzcpG+Rbg7EMXgRclrfouVAvIkGBBwh
         iqh5GUtQJ35INapwl7BY4rQNq4NmOWoVuTGjOBVjy1GiJvrQypP28ogVdFL7YMsVvS
         dkIw8w6pwQerA==
Received: by mail-ot1-f41.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so3718832otf.6;
        Mon, 16 Aug 2021 05:55:26 -0700 (PDT)
X-Gm-Message-State: AOAM530z//FiYiGO0oyRrVLlWv+xFU2PZVUirue33ySSBzEJnrm54u7N
        ppzEM/G1+qCjX1bDK1xFuBynfQ3qo140yzltuBI=
X-Google-Smtp-Source: ABdhPJxxMd3mBbuMB6M/CvVY1X6k7ltHvdrpDJub2UxaA78qfpiO8zqM8iqbzU5xcidaKUALMnaiixcKIl4DhyZW/Ss=
X-Received: by 2002:a9d:5c2:: with SMTP id 60mr12177072otd.77.1629118526103;
 Mon, 16 Aug 2021 05:55:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210816124433.10411-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20210816124433.10411-1-lukas.bulwahn@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 16 Aug 2021 14:55:15 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFEGK_3RDXcO3kvCVQvOvoCLgRtQsR=pEbSaiY7erVJrQ@mail.gmail.com>
Message-ID: <CAMj1kXFEGK_3RDXcO3kvCVQvOvoCLgRtQsR=pEbSaiY7erVJrQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: remove rmd320 in Makefile
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 16 Aug 2021 at 14:44, Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
>
> Commit 93f64202926f ("crypto: rmd320 - remove RIPE-MD 320 hash algorithm")
> removes the Kconfig and code, but misses to adjust the Makefile.
>
> Hence, ./scripts/checkkconfigsymbols.py warns:
>
> CRYPTO_RMD320
> Referencing files: crypto/Makefile
>
> Remove the missing piece of this code removal.
>
> Fixes: 93f64202926f ("crypto: rmd320 - remove RIPE-MD 320 hash algorithm")
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  crypto/Makefile | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 10526d4559b8..c633f15a0481 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -74,7 +74,6 @@ obj-$(CONFIG_CRYPTO_NULL2) += crypto_null.o
>  obj-$(CONFIG_CRYPTO_MD4) += md4.o
>  obj-$(CONFIG_CRYPTO_MD5) += md5.o
>  obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
> -obj-$(CONFIG_CRYPTO_RMD320) += rmd320.o
>  obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
>  obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
>  obj-$(CONFIG_CRYPTO_SHA512) += sha512_generic.o
> --
> 2.26.2
>
