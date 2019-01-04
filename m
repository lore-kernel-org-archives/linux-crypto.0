Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbfADEUy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:54 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 00/16] crypto: skcipher template simplifications and conversions
Date: Thu,  3 Jan 2019 20:16:09 -0800
Message-Id: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This series adds a function skcipher_alloc_instance_simple() that
greatly simplifies creating an skcipher_instance that uses a single
underlying block cipher.  It then converts the cbc, cfb, ctr, ecb, kw,
ofb, and pcbc templates to use it.  In doing so, ctr, ecb, and kw are
also converted from the deprecated "blkcipher" API to the skcipher API.

While doing this, I also found some rather silly bugs in the cfb, ofb,
and pcbc templates...  So I've included the fixes for these first, in
patches 1-4.  Please consider taking these first 4 patches through
'crypto' rather than 'cryptodev'.  (But 5-16 are cleanups only, so no
rush on those.)

Finally, I also converted ecb(arc4) and ecb(cipher_null) to the skcipher
API, since following the template conversions these were the last
generic algorithms that were still using the "blkcipher" API.

The overall delta is almost 500 lines removed, due to removing a lot of
boilerplate that created algorithm instances.

Eric Biggers (16):
  crypto: cfb - add missing 'chunksize' property
  crypto: cfb - remove bogus memcpy() with src == dest
  crypto: ofb - fix handling partial blocks and make thread-safe
  crypto: pcbc - remove bogus memcpy()s with src == dest
  crypto: skcipher - add helper for simple block cipher modes
  crypto: cbc - convert to skcipher_alloc_instance_simple()
  crypto: cfb - convert to skcipher_alloc_instance_simple()
  crypto: ctr - convert to skcipher API
  crypto: ecb - convert to skcipher API
  crypto: keywrap - convert to skcipher API
  crypto: ofb - convert to skcipher_alloc_instance_simple()
  crypto: pcbc - remove ability to wrap internal ciphers
  crypto: pcbc - convert to skcipher_alloc_instance_simple()
  crypto: arc4 - convert to skcipher API
  crypto: null - convert ecb-cipher_null to skcipher API
  crypto: algapi - remove crypto_alloc_instance()

 crypto/algapi.c                    |  33 +----
 crypto/arc4.c                      |  82 ++++++------
 crypto/cbc.c                       | 131 ++-----------------
 crypto/cfb.c                       | 139 +++-----------------
 crypto/crypto_null.c               |  57 ++++----
 crypto/ctr.c                       | 160 ++++++-----------------
 crypto/ecb.c                       | 151 +++++----------------
 crypto/keywrap.c                   | 198 ++++++++++------------------
 crypto/ofb.c                       | 202 ++++++-----------------------
 crypto/pcbc.c                      | 143 +++-----------------
 crypto/skcipher.c                  | 131 +++++++++++++++++++
 crypto/testmgr.h                   |  53 +++++++-
 include/crypto/algapi.h            |   6 +-
 include/crypto/internal/hash.h     |   6 +-
 include/crypto/internal/skcipher.h |  15 +++
 15 files changed, 508 insertions(+), 999 deletions(-)

-- 
2.20.1
