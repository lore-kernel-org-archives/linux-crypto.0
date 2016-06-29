From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/28] crypto: skcipher - skcipher algorithm conversion part 1
Date: Wed, 29 Jun 2016 18:02:23 +0800
Message-ID: <20160629100223.GA26260@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60662 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbcF2KC1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:02:27 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This path series begins the task of converting blkcipher/ablkcipher
implementations over to the unified skcipher interface.  The first
step is to convert non-cipher users such as aead to use skcipher.
Then we proceed to convert the top-level skcipher algorithms such
as rfc3686 and cts.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
