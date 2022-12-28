Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAEFC4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Dec 2022 08:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiL1Iij (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Dec 2022 03:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiL1Iii (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2022 03:38:38 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB95BDF12
        for <linux-crypto@vger.kernel.org>; Wed, 28 Dec 2022 00:38:36 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pARxH-00BTFF-7R; Wed, 28 Dec 2022 16:38:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 28 Dec 2022 16:38:31 +0800
Date:   Wed, 28 Dec 2022 16:38:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: caam - Prevent fortify error
Message-ID: <Y6wAh5slG4JmPC7n@gondor.apana.org.au>
References: <20221222162513.4021928-1-u.kleine-koenig@pengutronix.de>
 <Y6VK4IJkHiawAbJz@gondor.apana.org.au>
 <20221223174719.4n6pmwio4zycj2qm@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221223174719.4n6pmwio4zycj2qm@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 23, 2022 at 06:47:19PM +0100, Uwe Kleine-König wrote:
>
> Using
> 
> 	if (data && len)
> 
> fixes it (that's the patch that b4 picks for the above message id :-\),
> 
> 	if (!IS_ENABLED(CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG) && len)
> 
> makes the problem go away, too. But I wonder if the latter is correct.

Thanks for confirming!

> Shouldn't the memcpy happen even with that debugging symbol enabled?

It's just a pecularity with gcc.  It only produces the warning
because of the extra complexities introduced by the debugging
code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
