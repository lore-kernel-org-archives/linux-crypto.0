Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BD2C25B4E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Jan 2023 10:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjATKdx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Jan 2023 05:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjATKdv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2023 05:33:51 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0718D93CA;
        Fri, 20 Jan 2023 02:33:42 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pIoi9-002BZU-5l; Fri, 20 Jan 2023 18:33:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Jan 2023 18:33:29 +0800
Date:   Fri, 20 Jan 2023 18:33:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon - remove redundant config PCI
 dependency for some CRYPTO_DEV_HISI configs
Message-ID: <Y8pt+eTq/wwFWjw3@gondor.apana.org.au>
References: <20230111120203.822-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111120203.822-1-lukas.bulwahn@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 11, 2023 at 01:02:03PM +0100, Lukas Bulwahn wrote:
> While reviewing dependencies in some Kconfig files, I noticed the redundant
> dependency "depends on PCI && PCI_MSI". The config PCI_MSI has always,
> since its introduction, been dependent on the config PCI. So, it is
> sufficient to just depend on PCI_MSI, and know that the dependency on PCI
> is implicitly implied.
> 
> Reduce the dependencies of configs CRYPTO_DEV_HISI_SEC2,
> CRYPTO_DEV_HISI_QM, CRYPTO_DEV_HISI_ZIP and CRYPTO_DEV_HISI_HPRE.
> 
> No functional change and effective change of Kconfig dependendencies.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>  drivers/crypto/hisilicon/Kconfig | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
