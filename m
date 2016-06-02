From: Marcus Meissner <meissner@suse.de>
Subject: authenc methods vs FIPS in light of unencrypted associated data
Date: Thu, 2 Jun 2016 18:01:04 +0200
Message-ID: <20160602160104.GK18490@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbcFBQBJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 12:01:09 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

In February I already tagged some authenc ciphers for FIPS compatibility.

I currently revisit this to get testmgr running all the tests in strict FIPS mode.

The authenc() class is troublesome.

There is a HASH + ENC part of this method, but you can also add associated data,
which is not encrypted. (using the ctx->null cipher in crypto/authenc.c)

But in FIPS mode the crypto_authenc_init_tfm does:

	null = crypto_get_default_null_skcipher();

which results in error, as the crypto_alloc_blkcipher("ecb(cipher_null)", 0, 0);
results in failure due to "ecb(cipher_null)" not FIPS compliant.

How to handle this?

I think GCM also does not encrypt, just hashes, the associated data, it just does
copy the content itself and does not use a virtual cipher.

Ciao, Marcus
