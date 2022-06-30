Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED405C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 06:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbiF3Gn1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 02:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbiF3Gn0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 02:43:26 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DC7A44A
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2022 23:43:25 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o6ntY-00CwMQ-Pj; Thu, 30 Jun 2022 16:43:22 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jun 2022 14:43:21 +0800
Date:   Thu, 30 Jun 2022 14:43:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Liang He <windhl@126.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org, windhl@126.com
Subject: Re: [PATCH] crypto: Hold the reference returned by
 of_find_compatible_node
Message-ID: <Yr1GCZF/gWBm4zHp@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621073742.4081013-1-windhl@126.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Liang He <windhl@126.com> wrote:
> In nx842_pseries_init() and crypto4xx_probe(), we should hold the
> reference returned by of_find_compatible_node() and use it to call
> of_node_put to keep refcount balance.
> 
> Signed-off-by: Liang He <windhl@126.com>
> ---
> drivers/crypto/amcc/crypto4xx_core.c  | 13 ++++++++-----
> drivers/crypto/nx/nx-common-pseries.c |  5 ++++-
> 2 files changed, 12 insertions(+), 6 deletions(-)

Please split this into two patches.

> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> index 8278d98074e9..169b6a05e752 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -1378,6 +1378,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
>        struct resource res;
>        struct device *dev = &ofdev->dev;
>        struct crypto4xx_core_device *core_dev;
> +       struct device_node *np;
>        u32 pvr;
>        bool is_revb = true;
> 
> @@ -1385,20 +1386,20 @@ static int crypto4xx_probe(struct platform_device *ofdev)
>        if (rc)
>                return -ENODEV;
> 
> -       if (of_find_compatible_node(NULL, NULL, "amcc,ppc460ex-crypto")) {
> +       if ((np = of_find_compatible_node(NULL, NULL, "amcc,ppc460ex-crypto")) != NULL) {

This is getting awkwardly long.  Please change this to

	np = ...;
	if (np) {

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
