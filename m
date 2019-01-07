Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbfAGCtj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 21:49:39 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/3] crypto: set CRYPTO_TFM_NEED_KEY if ->setkey() fails
Date: Sun,  6 Jan 2019 18:47:41 -0800
Message-Id: <20190107024744.4952-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series makes the crypto API mark shash, ahash, skcipher, and aead
tfms as needing a key again if setting a key fails, since on failure
many algorithms can leave the tfm in an intermediate state that is
neither the old key nor the new key -- and use of such tfms for hashing,
encryption, or decryption will produce bogus results or crashes.

Eric Biggers (3):
  crypto: hash - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
  crypto: skcipher - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
  crypto: aead - set CRYPTO_TFM_NEED_KEY if ->setkey() fails

 crypto/aead.c     |  4 +++-
 crypto/ahash.c    | 28 +++++++++++++++++++---------
 crypto/shash.c    | 18 +++++++++++++-----
 crypto/skcipher.c | 27 ++++++++++++++++++---------
 4 files changed, 53 insertions(+), 24 deletions(-)

-- 
2.20.1
