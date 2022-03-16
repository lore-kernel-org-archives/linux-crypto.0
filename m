Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB37C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Mar 2022 01:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243596AbiCPBMA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Mar 2022 21:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiCPBMA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Mar 2022 21:12:00 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A38D43EE2
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2022 18:10:46 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nUIBU-0004eO-Vg; Wed, 16 Mar 2022 12:10:42 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Mar 2022 13:10:41 +1200
Date:   Wed, 16 Mar 2022 13:10:41 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Simo Sorce <ssorce@redhat.com>, Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel@pengutronix.de, Guenter Roeck <linux@roeck-us.net>,
        Vladis Dronov <vdronov@redhat.com>
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <YjE5Ed5e1jjFFVn3@gondor.apana.org.au>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
 <20211106034725.GA18680@gondor.apana.org.au>
 <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
 <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
 <YcvCglFcJEA87KNN@gondor.apana.org.au>
 <20211229110523.rsbzlkpjzwmqyvfs@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211229110523.rsbzlkpjzwmqyvfs@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 29, 2021 at 12:05:23PM +0100, Uwe Kleine-König wrote:
> On Wed, Dec 29, 2021 at 01:05:54PM +1100, Herbert Xu wrote:
> > On Wed, Dec 22, 2021 at 11:22:46AM +0100, Uwe Kleine-König wrote:
> > >
> > > I still experience a problem with the patch that got
> > > adad556efcdd42a1d9e060cbe5f6161cccf1fa28 in v5.16-rc1. I saw there are
> > > two commit fixing this one (
> > > 
> > > 	cad439fc040e crypto: api - Do not create test larvals if manager is disabled
> > > 	e42dff467ee6 crypto: api - Export crypto_boot_test_finished
> > > 
> > > ) but I still encounter the following on 2f47a9a4dfa3:
> > 
> > Perhaps you missed the last fix?
> > 
> > commit beaaaa37c664e9afdf2913aee19185d8e3793b50
> > Author: Herbert Xu <herbert@gondor.apana.org.au>
> > Date:   Fri Nov 5 15:26:08 2021 +0800
> > 
> >     crypto: api - Fix boot-up crash when crypto manager is disabled
> 
> As 2f47a9a4dfa3 includes this commit, this is not the problem.

Using the config snippet in this email thread I was unable to
reproduce the failure under qemu.  Can you still reproduce this
with the latest upstream kernel? If yes please send me your complete
config file.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
