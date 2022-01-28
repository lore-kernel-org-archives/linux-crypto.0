Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AE4C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 05:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiA1FoL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 00:44:11 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60586 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbiA1FoI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 00:44:08 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nDK2z-0000F5-7a; Fri, 28 Jan 2022 16:43:46 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jan 2022 16:43:45 +1100
Date:   Fri, 28 Jan 2022 16:43:45 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shijith Thotton <sthotton@marvell.com>
Cc:     arno@natisbad.org, bbrezillon@kernel.org, sthotton@marvell.com,
        linux-crypto@vger.kernel.org, jerinj@marvell.com,
        sgoutham@marvell.com, schalla@marvell.com, davem@davemloft.net,
        chi.minghao@zte.com.cn, ovidiu.panait@windriver.com,
        schandran@marvell.com, lbartosik@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: octeontx2: fix NULL pointer dereference
Message-ID: <YfOCkY3RL0qqn5YU@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ef09bf0c4adf7bc33f01f60cb8ce96e8f77b58c.1642786900.git.sthotton@marvell.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Shijith Thotton <sthotton@marvell.com> wrote:
>
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
> index 2748a3327e39..620fa9b23e78 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
> @@ -1650,7 +1650,7 @@ static inline int cpt_register_algs(void)
> 
>        err = crypto_register_aeads(otx2_cpt_aeads,
>                                    ARRAY_SIZE(otx2_cpt_aeads));
> -       if (err) {
> +       if (err && !IS_ENABLED(CONFIG_DM_CRYPT)) {
>                crypto_unregister_skciphers(otx2_cpt_skciphers,
>                                            ARRAY_SIZE(otx2_cpt_skciphers));
>                return err;

A better fix would be to make the driver actually work with
dm-crypt.  What exactly is the issue?

Even if we have to keep the kludge, please move this into Kconfig
as a dependency and simply disable the whole driver.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
