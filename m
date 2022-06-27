Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD49C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jun 2022 01:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiF0BTT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Jun 2022 21:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiF0BTS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Jun 2022 21:19:18 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609C52AC7;
        Sun, 26 Jun 2022 18:19:16 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o5dP6-00BRbS-2p; Mon, 27 Jun 2022 11:19:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jun 2022 09:19:04 +0800
Date:   Mon, 27 Jun 2022 09:19:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simo Sorce <simo@redhat.com>
Subject: Re: [PATCH v2] crypto: fips - make proc files report fips module
 name and version
Message-ID: <YrkFiM+Y2G7a50z5@gondor.apana.org.au>
References: <20220620131618.952133-1-vdronov@redhat.com>
 <20220621150832.1710738-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621150832.1710738-1-vdronov@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 21, 2022 at 05:08:32PM +0200, Vladis Dronov wrote:
>
> diff --git a/include/linux/fips.h b/include/linux/fips.h
> index c6961e932fef..72d2e0e1d3ac 100644
> --- a/include/linux/fips.h
> +++ b/include/linux/fips.h
> @@ -2,10 +2,19 @@
>  #ifndef _FIPS_H
>  #define _FIPS_H
>  
> +#include <generated/utsrelease.h>
> +
>  #ifdef CONFIG_CRYPTO_FIPS
>  extern int fips_enabled;
>  extern struct atomic_notifier_head fips_fail_notif_chain;
>  
> +#define FIPS_MODULE_NAME CONFIG_CRYPTO_FIPS_NAME
> +#ifdef CONFIG_CRYPTO_FIPS_CUSTOM_VERSION
> +#define FIPS_MODULE_VERSION CONFIG_CRYPTO_FIPS_VERSION
> +#else
> +#define FIPS_MODULE_VERSION UTS_RELEASE
> +#endif

Why does this need to be in fips.h? If it's only used by one file
then it should be moved to the place where it's used.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
