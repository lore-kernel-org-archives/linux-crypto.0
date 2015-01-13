From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] crypto: module alias fixes
Date: Tue, 13 Jan 2015 22:32:54 +1100
Message-ID: <20150113113254.GB6677@gondor.apana.org.au>
References: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:37081 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbAMLdC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 06:33:02 -0500
Content-Disposition: inline
In-Reply-To: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 11, 2015 at 06:17:41PM +0100, Mathias Krause wrote:
> Hi Herbert,
> 
> this series is a follow up to commit 5d26a105b5a7 ("crypto: prefix
> module autoloading with "crypto-""). In patch 1 it adds the required
> MODULE_ALIAS_CRYPTO annotation where needed to bring back automatic
> crypto module loading. Namely, modules that have a file name matching
> the cipher they implement still need the MODULE_ALIAS_CRYPTO()
> annotation. Otherwise they won't get loaded.
> 
> Patches 2 to 6 fix bogus module descriptions or aliases with the
> exception of patch 4 which adds a missing crypto module alias.
> 
> At least patch 1 should go to crypto-2.6 to not regress the crypto API
> for v3.19 in regard to automatic module loading.

Patch 1 applied to crypto and the rest to cryptodev.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
