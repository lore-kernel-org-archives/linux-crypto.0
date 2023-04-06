Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A253C7618D
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Apr 2023 08:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbjDFIx2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Apr 2023 04:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDFIxW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Apr 2023 04:53:22 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C764F90;
        Thu,  6 Apr 2023 01:53:20 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pkLMc-00D23Q-6T; Thu, 06 Apr 2023 16:53:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Apr 2023 16:53:02 +0800
Date:   Thu, 6 Apr 2023 16:53:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Yang <mmyangfl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] crypto: hisilicon/trng - add support for HiSTB TRNG
Message-ID: <ZC6Ibor2aGR8D8fR@gondor.apana.org.au>
References: <20230401164448.1393336-1-mmyangfl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401164448.1393336-1-mmyangfl@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Apr 02, 2023 at 12:44:40AM +0800, David Yang wrote:
> HiSTB TRNG are found on some HiSilicon STB SoCs.
> 
> Signed-off-by: David Yang <mmyangfl@gmail.com>
> ---
> v2: fix typo
> v3: add option for post process depth, adjust timeout
> v4: do not case to __iomem, as requested
> v5: do not use rng->priv at all
>  drivers/crypto/hisilicon/Kconfig         |   7 +
>  drivers/crypto/hisilicon/Makefile        |   2 +-
>  drivers/crypto/hisilicon/trng/Makefile   |   3 +
>  drivers/crypto/hisilicon/trng/trng-stb.c | 176 +++++++++++++++++++++++
>  4 files changed, 187 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/hisilicon/trng/trng-stb.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
