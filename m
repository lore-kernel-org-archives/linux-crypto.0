Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FABC433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jul 2022 07:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbiGHHUc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jul 2022 03:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237298AbiGHHUb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jul 2022 03:20:31 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC041796BE;
        Fri,  8 Jul 2022 00:20:30 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o9iHW-00Fqwz-9l; Fri, 08 Jul 2022 17:20:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Jul 2022 15:20:06 +0800
Date:   Fri, 8 Jul 2022 15:20:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simo Sorce <simo@redhat.com>
Subject: Re: [PATCH v3] crypto: fips - make proc files report fips module
 name and version
Message-ID: <YsfappxjOaj99WEV@gondor.apana.org.au>
References: <20220620131618.952133-1-vdronov@redhat.com>
 <20220627195144.976741-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627195144.976741-1-vdronov@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 27, 2022 at 09:51:44PM +0200, Vladis Dronov wrote:
>
> diff --git a/crypto/fips.c b/crypto/fips.c
> index 7b1d8caee669..d820f83cb878 100644
> --- a/crypto/fips.c
> +++ b/crypto/fips.c
> @@ -30,13 +30,37 @@ static int fips_enable(char *str)
>  
>  __setup("fips=", fips_enable);
>  
> +#define FIPS_MODULE_NAME CONFIG_CRYPTO_FIPS_NAME
> +#ifdef CONFIG_CRYPTO_FIPS_CUSTOM_VERSION
> +#define FIPS_MODULE_VERSION CONFIG_CRYPTO_FIPS_VERSION
> +#else
> +#define FIPS_MODULE_VERSION UTS_RELEASE
> +#endif
> +
> +static char fips_name[] = FIPS_MODULE_NAME;
> +static char fips_version[] = FIPS_MODULE_VERSION;

This doesn't compile for me because you need to include
generated/utsrelease.h.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
