Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706B9C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbiKRJKo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241776AbiKRJKj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:10:39 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E52B86A5C
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:10:38 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ovxOG-00FYNl-Em; Fri, 18 Nov 2022 17:10:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Nov 2022 17:10:28 +0800
Date:   Fri, 18 Nov 2022 17:10:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     gilad@benyossef.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree - Remove debugfs when
 platform_driver_register failed
Message-ID: <Y3dMBPpwjyJIMwOU@gondor.apana.org.au>
References: <20221108082912.1818219-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108082912.1818219-1-cuigaosheng1@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 08, 2022 at 04:29:12PM +0800, Gaosheng Cui wrote:
> When platform_driver_register failed, we need to remove debugfs,
> which will caused a resource leak, fix it.
> 
> Failed logs as follows:
> [   32.606488] debugfs: Directory 'ccree' with parent '/' already present!
> 
> Fixes: 4c3f97276e15 ("crypto: ccree - introduce CryptoCell driver")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  drivers/crypto/ccree/cc_driver.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
