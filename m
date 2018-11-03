Return-Path: <SRS0=a5OM=NO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbeKDHJx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Nov 2018 02:09:53 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin Labbe <clabbe@baylibre.com>,
        Stafford Horne <shorne@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] crypto: crypto_user reporting fixes and cleanups
Date: Sat,  3 Nov 2018 14:55:59 -0700
Message-Id: <20181103215603.16250-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series fixes all the information leaks in crypto_user reporting,
removes some redundant reporting functions, and makes some changes to
reduce the chance of similar information leaks in the future.  Patch 2
is based on a patch already sent by Corentin Labbe, but it was
incomplete so I fixed it.

Corentin Labbe (1):
  crypto: crypto_user_stat - Zeroize whole structure given to user space

Eric Biggers (3):
  crypto: crypto_user - fix leaking uninitialized memory to userspace
  crypto: crypto_user - remove redundant reporting functions
  crypto: crypto_user - clean up report structure copying

 crypto/ablkcipher.c       |  32 ++++------
 crypto/acompress.c        |  10 +---
 crypto/aead.c             |  14 ++---
 crypto/ahash.c            |  12 ++--
 crypto/akcipher.c         |  11 ++--
 crypto/blkcipher.c        |  16 ++---
 crypto/crypto_user_base.c |  95 +++++------------------------
 crypto/crypto_user_stat.c | 123 ++++++++++++++------------------------
 crypto/kpp.c              |  10 +---
 crypto/rng.c              |  12 ++--
 crypto/scompress.c        |  11 ++--
 crypto/shash.c            |  12 ++--
 crypto/skcipher.c         |  15 ++---
 13 files changed, 116 insertions(+), 257 deletions(-)

-- 
2.19.1
