From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crash in ppc4xx-rng on canyonland
Date: Mon, 18 Apr 2016 17:59:39 +0800
Message-ID: <20160418095939.GA18915@gondor.apana.org.au>
References: <2508973.j7LtCUZRGZ@debian64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Christian Lamparter <chunkeey@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55291 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbcDRJ7t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Apr 2016 05:59:49 -0400
Content-Disposition: inline
In-Reply-To: <2508973.j7LtCUZRGZ@debian64>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> wrote:
> 
> I tried to move ppc4xx-rng into crypto4xx (see attachment - patch #1).
> The driver works as is. But I can't come up with a way to attach the
> crypto4xx driver to the ppc4xx-rng OF node cleanly. Basically,
> I'm looking for a way to have one driver (with one context) be 
> in charge of two different OF nodes (ppc4xx-rng and ppc4xx-crypto).
> Is there any solution to this? Because otherwise, I would add a

Is it possible to have an RNG unit without the crypto unit? If not
then your first patch should be OK, provided that you add some error
handling when the RNG probe fails.  For example, if the RNG probe
fails we should probably not call remove on it later.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
