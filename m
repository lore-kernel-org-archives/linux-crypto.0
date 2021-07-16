Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD509C07E95
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 07:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E20D613DF
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 07:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbhGPHlR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jul 2021 03:41:17 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51398 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232052AbhGPHlQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jul 2021 03:41:16 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1m4IQO-00051b-Lz; Fri, 16 Jul 2021 15:38:20 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1m4IQM-00021y-C1; Fri, 16 Jul 2021 15:38:18 +0800
Date:   Fri, 16 Jul 2021 15:38:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     iLifetruth <yixiaonn@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiang Liu <cyruscyliu@gmail.com>, yajin@vm-kernel.org
Subject: Re: crypto: prefix additional module autoloading with "crypto-"
Message-ID: <20210716073818.GA7773@gondor.apana.org.au>
References: <CABv53a8jyUXns9yu3xyd71_R+nNerU+Xj4i7a4rcZUH0bd52kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABv53a8jyUXns9yu3xyd71_R+nNerU+Xj4i7a4rcZUH0bd52kw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 08, 2021 at 12:33:47PM +0800, iLifetruth wrote:
>
> =========
> And the common fix pattern we found in each crypto-related module is as follows:
> 1. linux/drivers/crypto/padlock-aes.c
>        -MODULE_ALIAS("aes");
>        +MODULE_ALIAS_CRYPTO("aes");

This is already fixed in the current kernel.

> or in another module:
> 
> 2. linux/drivers/crypto/qat/qat_common/adf_ctl_drv.c
>       -MODULE_ALIAS("intel_qat");
>       +MODULE_ALIAS_CRYPTO("intel_qat");

This is not a bug.  The _CRYPTO suffix only applies to the ones
that are algorithm names.  intel_qat is not the name of an algorithm.

> ==========
> Even though commit 5d26a105b5a7 added those aliases for a large number
> of modules,  it is still missing some newly added crypto-related
> modules.
> For example:
> 1. for file linux/drivers/crypto/amcc/crypto4xx_trng.c in line 129,
> Module_ALIAS is used instead of MODULE_ALIAS_CRYPTO
>            MODULE_ALIAS("ppc4xx_rng");
>      In fact, ppc4xx-rng was integrated into crypto4xx on 2016-04-18
> by commit 5343e674f32fb8, which was committed about 2 years later than
> the security bug fixing patch(5d26a105b5a7) committed on 2014-11-24
> 
> More modules that may not have been fixed are as follows:
> 2. linux/crypto/crypto_user_base.c
>         MODULE_ALIAS("net-pf-16-proto-21");
> 3. linux/drivers/crypto/mxs-dcp.c
>         MODULE_ALIAS("platform:mxs-dcp");
> 4. linux/drivers/crypto/omap-sham.c
>         MODULE_ALIAS("platform:omap-sham");
> 5. linux/drivers/crypto/qcom-rng.c
>         MODULE_ALIAS("platform:" KBUILD_MODNAME);
> 6. linux/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
>         MODULE_ALIAS("platform:sun4i-ss");
> 7. linux/drivers/crypto/marvell/cesa/cesa.c
>         MODULE_ALIAS("platform:mv_crypto");
> 8. linux/drivers/crypto/qce/core.c
>         MODULE_ALIAS("platform:" KBUILD_MODNAME);

Nor are any of these algorithm names.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
