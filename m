Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF17C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 09:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiCQJRh convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 05:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiCQJRg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 05:17:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A38D1D207B
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 02:16:20 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nUmF0-0004uM-Ed; Thu, 17 Mar 2022 10:16:18 +0100
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nUmF0-001Dxr-Gp; Thu, 17 Mar 2022 10:16:17 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nUmEy-0003JB-Am; Thu, 17 Mar 2022 10:16:16 +0100
Message-ID: <c725d68e69dd7caf3ff6e78d11e41e2c4c3a05cc.camel@pengutronix.de>
Subject: Re: [PATCH] crypto: arm/aes-neonbs-cbc - Select generic cbc and aes
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Simo Sorce <ssorce@redhat.com>, Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel@pengutronix.de, Guenter Roeck <linux@roeck-us.net>,
        Vladis Dronov <vdronov@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Thu, 17 Mar 2022 10:16:16 +0100
In-Reply-To: <YjJq0RLIHvN7YWaT@gondor.apana.org.au>
References: <20210913071251.GA15235@gondor.apana.org.au>
         <20210917002619.GA6407@gondor.apana.org.au>
         <20211026163319.GA2785420@roeck-us.net>
         <20211106034725.GA18680@gondor.apana.org.au>
         <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
         <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
         <YcvCglFcJEA87KNN@gondor.apana.org.au>
         <20211229110523.rsbzlkpjzwmqyvfs@pengutronix.de>
         <YjE5Ed5e1jjFFVn3@gondor.apana.org.au>
         <20220316163719.ud2s36e5zwmtmzef@pengutronix.de>
         <YjJq0RLIHvN7YWaT@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Do, 2022-03-17 at 10:55 +1200, Herbert Xu wrote:
> On Wed, Mar 16, 2022 at 05:37:19PM +0100, Uwe Kleine-König wrote:
> > 
> > # CONFIG_CRYPTO_CBC is not set
> 
> This was the issue.  The failure occurs on registering __cbc_aes
> and the reason is that the neonbs cbc-aes requirs a fallback which
> isn't available due to CBC being disabled.
> 
> I have no idea why this started occurring only with the testmgr
> change though as this should have been fatal all along.

I think this always failed and nobody that actually had CRYPTO_AES or
CRYPTO_CBC disabled noticed that aes-neonbs-cbc did not register.

What commit adad556efcdd caused was allowing the error path in
late_initcall(aes_init) to be hit before
late_initcall(crypto_algapi_init) would start the tests.

regards
Philipp
