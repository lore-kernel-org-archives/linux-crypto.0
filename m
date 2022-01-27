Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF35C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 04:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbiA0Ele (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 23:41:34 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60508 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbiA0Eld (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 23:41:33 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nCwbC-0007sh-UK; Thu, 27 Jan 2022 15:41:32 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Jan 2022 15:41:30 +1100
Date:   Thu, 27 Jan 2022 15:41:30 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de
Subject: Re: [PATCH] crypto: algapi - Remove test larvals to fix error paths
Message-ID: <YfIiem46QS3VUMI8@gondor.apana.org.au>
References: <20220126145322.646723-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126145322.646723-1-p.zabel@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 26, 2022 at 03:53:22PM +0100, Philipp Zabel wrote:
> If crypto_unregister_alg() is called with an algorithm that still has a
> pending test larval, the algorithm will have a reference count of 2 and
> crypto_unregister_alg() will trigger a BUG(). This can happen during
> cleanup if the error path is taken for a built-in algorithm, before
> crypto_algapi_init() was called.
> 
> Kill test larvals for untested algorithms during removal to fix the
> reference count.
> 
> Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  crypto/algapi.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)

Yes this is definitely a bug.

However, I think simply fixing this for test larvals is not enough.
After all, another thread could come through the middle and take
a reference to our newly minted algorithm before a subsequent
algorithm registration failure and thus would trigger exactly
the same crash.

So we need something a bit more general.  Previously we relied
on module reference counts to stop the unregistering of live
algorithms.  But that is clearly not of any use in this case.

It also fails for hardware devices than can be unplugged.

One solution would be to simply allow the unregistration to
continue and only free the data structures after all references
have gone away.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
