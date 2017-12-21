From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 1/3] crypto: Prevent to register duplicate
 cra_driver_name
Date: Thu, 21 Dec 2017 17:35:22 +1100
Message-ID: <20171221063522.GA18211@gondor.apana.org.au>
References: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
 <1513800567-12764-2-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, nhorman@tuxdriver.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:45410 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750768AbdLUGf6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Dec 2017 01:35:58 -0500
Content-Disposition: inline
In-Reply-To: <1513800567-12764-2-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 08:09:25PM +0000, Corentin Labbe wrote:
> Each crypto algorithm "cra_name" can have multiple implementation called
> "cra_driver_name".
> If two different implementation have the same cra_driver_name, nothing
> can easily differentiate them.
> Furthermore the mechanism for getting a crypto algorithm with its
> implementation name (crypto_alg_match() in crypto/crypto_user.c) will
> get only the first one found.
> 
> So this patch prevent the registration of two implementation with the
> same cra_driver_name.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

No this is intentional.  The idea is that you can hot-replace
an implementation by registering a new version of it while the
old one is still in use.  The new one will be used for all new
allocations.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
