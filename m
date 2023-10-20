Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E347EC001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 05:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376298AbjJTF6J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376293AbjJTF6H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 01:58:07 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D147CA;
        Thu, 19 Oct 2023 22:58:06 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qtiWH-0097il-6w; Fri, 20 Oct 2023 13:58:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Oct 2023 13:58:06 +0800
Date:   Fri, 20 Oct 2023 13:58:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     =?iso-8859-1?Q?Andr=E9?= Apitzsch <git@apitzsch.eu>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        git@apitzsch.eu
Subject: Re: [PATCH] crypto: qcom-rng - Add missing dependency on hw_random
Message-ID: <ZTIW7oSsJr5Ce1Km@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231016-qcom_rng-v1-1-1a7d7856651e@apitzsch.eu>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

André Apitzsch <git@apitzsch.eu> wrote:
> This should fix the undefined reference:
> 
>> /usr/bin/aarch64-alpine-linux-musl-ld: Unexpected GOT/PLT entries detected!
>> /usr/bin/aarch64-alpine-linux-musl-ld: Unexpected run-time procedure linkages detected!
>> /usr/bin/aarch64-alpine-linux-musl-ld: drivers/crypto/qcom-rng.o: in function `qcom_rng_probe':
>> qcom-rng.c:(.text+0x130): undefined reference to `devm_hwrng_register'
> 
> Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
> Signed-off-by: André Apitzsch <git@apitzsch.eu>
> ---
> drivers/crypto/Kconfig | 1 +
> 1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
