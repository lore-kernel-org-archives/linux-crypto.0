From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/14] crypto: aead - Phase oute seqniv
Date: Thu, 9 Jul 2015 07:13:30 +0800
Message-ID: <20150708231330.GA28797@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40093 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbbGHXNd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:13:33 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series attempts to phase out the recently introduced seqniv
generator.  The reason is that the logic of seqniv should not be
implemented at the IV generator layer.  Having the IV skipping
logic in seqniv means that you cannot perform encryption without
doing IV generation.

In fact moving the IV skipping logic out of seqniv and into the
underlying rfcXXXX (e.g., rfc4106) template allows optimisations
to be made as the underlying code can often skip the IV in a more
efficient manner.

Unfortunately we've already begun the conversion process so this
series adds a new flag CRYPTO_ALG_AEAD_NEW to indicate whether
a given algorithm has been converted to the new interface where
IV skipping is done outside of the IV generator.  This flag can
be removed once the conversion is complete.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
