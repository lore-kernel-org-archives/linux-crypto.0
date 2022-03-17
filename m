Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AADCC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 22:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiCQWQx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 18:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiCQWQx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 18:16:53 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7753AF3282
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 15:15:35 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nUyP1-00079d-9J; Fri, 18 Mar 2022 09:15:28 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Mar 2022 10:15:26 +1200
Date:   Fri, 18 Mar 2022 10:15:26 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel@pengutronix.de, Guenter Roeck <linux@roeck-us.net>,
        Vladis Dronov <vdronov@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: arm/aes-neonbs-cbc - Select generic cbc and aes
Message-ID: <YjOy/rrYekCuqsaB@gondor.apana.org.au>
References: <20211026163319.GA2785420@roeck-us.net>
 <20211106034725.GA18680@gondor.apana.org.au>
 <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
 <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
 <YcvCglFcJEA87KNN@gondor.apana.org.au>
 <20211229110523.rsbzlkpjzwmqyvfs@pengutronix.de>
 <YjE5Ed5e1jjFFVn3@gondor.apana.org.au>
 <20220316163719.ud2s36e5zwmtmzef@pengutronix.de>
 <YjJq0RLIHvN7YWaT@gondor.apana.org.au>
 <c725d68e69dd7caf3ff6e78d11e41e2c4c3a05cc.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c725d68e69dd7caf3ff6e78d11e41e2c4c3a05cc.camel@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 17, 2022 at 10:16:16AM +0100, Philipp Zabel wrote:
>
> What commit adad556efcdd caused was allowing the error path in
> late_initcall(aes_init) to be hit before
> late_initcall(crypto_algapi_init) would start the tests.

OK I know what's going on now.  Yes the registration had always
failed but it was silent so nobody noticed.

What adad556efcdd did different was to create larvals pointing
to the algorithms which will hang around until all tests complete
and that is what triggers the crash during unregister (that bug
during unregister has always existed too, it's just that it
was pretty much impossible to trigger as usually there aren't
any third parties allocating tfms during the init call).

I'll continue to work on the unregister crash.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
