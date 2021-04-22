Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB93C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 06:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C42C6145A
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 06:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhDVG43 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Apr 2021 02:56:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48236 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhDVG43 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Apr 2021 02:56:29 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lZTFc-0002Bn-FW; Thu, 22 Apr 2021 16:55:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 Apr 2021 16:55:48 +1000
Date:   Thu, 22 Apr 2021 16:55:48 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Haren Myneni <haren@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, hbabu@us.ibm.com,
        haren@us.ibm.com
Subject: Re: [V3 PATCH 13/16] crypto/nx: Rename nx-842-pseries file name to
 nx-common-pseries
Message-ID: <20210422065548.GA5486@gondor.apana.org.au>
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
 <ead7ef3bc33dac05fbb8b2ef59d5d0110ba318be.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ead7ef3bc33dac05fbb8b2ef59d5d0110ba318be.camel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Apr 17, 2021 at 02:11:15PM -0700, Haren Myneni wrote:
> 
> Rename nx-842-pseries.c to nx-common-pseries.c to add code for new
> GZIP compression type. The actual functionality is not changed in
> this patch.
> 
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  drivers/crypto/nx/Makefile                                  | 2 +-
>  drivers/crypto/nx/{nx-842-pseries.c => nx-common-pseries.c} | 0
>  2 files changed, 1 insertion(+), 1 deletion(-)
>  rename drivers/crypto/nx/{nx-842-pseries.c => nx-common-pseries.c} (100%)
> 
> diff --git a/drivers/crypto/nx/Makefile b/drivers/crypto/nx/Makefile
> index bc89a20e5d9d..d00181a26dd6 100644
> --- a/drivers/crypto/nx/Makefile
> +++ b/drivers/crypto/nx/Makefile
> @@ -14,5 +14,5 @@ nx-crypto-objs := nx.o \
>  obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_PSERIES) += nx-compress-pseries.o nx-compress.o
>  obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_POWERNV) += nx-compress-powernv.o nx-compress.o
>  nx-compress-objs := nx-842.o
> -nx-compress-pseries-objs := nx-842-pseries.o
> +nx-compress-pseries-objs := nx-common-pseries.o
>  nx-compress-powernv-objs := nx-common-powernv.o
> diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
> similarity index 100%
> rename from drivers/crypto/nx/nx-842-pseries.c
> rename to drivers/crypto/nx/nx-common-pseries.c

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
