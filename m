Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13471C7618E
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Apr 2023 08:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbjDZIpd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Apr 2023 04:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239752AbjDZIpc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Apr 2023 04:45:32 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8E52684
        for <linux-crypto@vger.kernel.org>; Wed, 26 Apr 2023 01:45:25 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1praly-002Vld-Vg; Wed, 26 Apr 2023 16:45:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Apr 2023 16:45:12 +0800
Date:   Wed, 26 Apr 2023 16:45:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: jitter - change module_init(jent_mod_init)
 to subsys_initcall(jent_mod_init)
Message-ID: <ZEjkmOPvk7Iz213G@gondor.apana.org.au>
References: <20230425125709.39470-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425125709.39470-1-cuigaosheng1@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 25, 2023 at 08:57:09PM +0800, Gaosheng Cui wrote:
> The ecdh-nist-p256 algorithm will depend on jitterentropy_rng,
> and when they are built into kernel, the order of registration
> should be done such that the underlying algorithms are ready
> before the ones on top are registered.
> 
> Now ecdh is initialized with subsys_initcall but jitterentropy_rng
> is initialized with module_init.
> 
> This patch will change module_init(jent_mod_init) to
> subsys_initcall(jent_mod_init), so jitterentropy_rng will be
> registered before ecdh-nist-p256 when they are built into kernel.
> 
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  crypto/jitterentropy-kcapi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> index b9edfaa51b27..563c1ea8c8fe 100644
> --- a/crypto/jitterentropy-kcapi.c
> +++ b/crypto/jitterentropy-kcapi.c
> @@ -205,7 +205,7 @@ static void __exit jent_mod_exit(void)
>  	crypto_unregister_rng(&jent_alg);
>  }
>  
> -module_init(jent_mod_init);
> +subsys_initcall(jent_mod_init);

This is unnecessary because we now postpone the testing of all
algorithms until their first use.  So unless something in the
kernel makes use of this before/during module_init, then we don't
need to move jent.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
