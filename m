Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E373C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Mar 2022 22:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiCPWjc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Mar 2022 18:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiCPWja (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Mar 2022 18:39:30 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC64B140A2
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 15:38:14 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nUcHT-0008Ij-E3; Thu, 17 Mar 2022 09:38:12 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 17 Mar 2022 10:38:10 +1200
Date:   Thu, 17 Mar 2022 10:38:10 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Simo Sorce <ssorce@redhat.com>, Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel@pengutronix.de, Guenter Roeck <linux@roeck-us.net>,
        Vladis Dronov <vdronov@redhat.com>
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <YjJm0sCDZLWhJQxV@gondor.apana.org.au>
References: <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
 <20211106034725.GA18680@gondor.apana.org.au>
 <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
 <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
 <YcvCglFcJEA87KNN@gondor.apana.org.au>
 <20211229110523.rsbzlkpjzwmqyvfs@pengutronix.de>
 <YjE5Ed5e1jjFFVn3@gondor.apana.org.au>
 <20220316163719.ud2s36e5zwmtmzef@pengutronix.de>
 <20220316214417.khho2qno76bby3qm@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220316214417.khho2qno76bby3qm@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 16, 2022 at 10:44:17PM +0100, Uwe Kleine-König wrote:
>
> Digging a bit deeper the problem is that simd_skcipher_create_compat()
> fails for aes_algs[1] in arch/arm/crypto/aes-neonbs-glue.c with -ENOENT
> and then aes_exit -> simd_skcipher_free -> crypto_unregister_skcipher ->
> crypto_unregister_alg stumbles over refcount_read(&alg->cra_refcnt)
> being 2. Is this enough to understand the actual problem?

That itself isn't enough as I already had reports on this.  The
question is why it's returning ENOENT.  The good news is that with
your kconfig I can reproduce the crash so I should be able to
figure out the root cause.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
