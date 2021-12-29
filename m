Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EDDC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Dec 2021 02:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbhL2CGB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Dec 2021 21:06:01 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58688 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238317AbhL2CGB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Dec 2021 21:06:01 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n2OLi-0006Bp-OM; Wed, 29 Dec 2021 13:05:55 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 29 Dec 2021 13:05:54 +1100
Date:   Wed, 29 Dec 2021 13:05:54 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>, kernel@pengutronix.de
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <YcvCglFcJEA87KNN@gondor.apana.org.au>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
 <20211106034725.GA18680@gondor.apana.org.au>
 <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
 <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 22, 2021 at 11:22:46AM +0100, Uwe Kleine-König wrote:
>
> I still experience a problem with the patch that got
> adad556efcdd42a1d9e060cbe5f6161cccf1fa28 in v5.16-rc1. I saw there are
> two commit fixing this one (
> 
> 	cad439fc040e crypto: api - Do not create test larvals if manager is disabled
> 	e42dff467ee6 crypto: api - Export crypto_boot_test_finished
> 
> ) but I still encounter the following on 2f47a9a4dfa3:

Perhaps you missed the last fix?

commit beaaaa37c664e9afdf2913aee19185d8e3793b50
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Nov 5 15:26:08 2021 +0800

    crypto: api - Fix boot-up crash when crypto manager is disabled

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
