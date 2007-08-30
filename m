From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/8] [CRYPTO]: Add AEAD/authenc support
Date: Thu, 30 Aug 2007 16:39:00 +0800
Message-ID: <20070830083900.GA15936@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1365 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755916AbXH3IjR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 04:39:17 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

I'm about add these patches to cryptodev-2.6.

They create a new operation called crypto_aead which will
support AEAD (Authenticated Encryption with Associated Data)
algorithms.  Essentially they combine the functionality of
the current blkcipher and hash operations into one.

This will be used by IPsec, in particular, for algorithms
such as CCM.

Right now there is only one AEAD algorithm, authenc, which
simply combines an ablkcipher with a hash in the way that
is currently used by IPsec ESP.

With this we can replace the ablkcipher/hash code in ESP
with aead, which will then make it possible to support CCM.

The authenc code is currently untested because of the lack
of actual users.  This will be addressed when IPsec is
converted across.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
