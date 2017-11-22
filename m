From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 0/5] crypto: chacha20 - Alignment fixes
Date: Wed, 22 Nov 2017 11:51:34 -0800
Message-ID: <20171122195139.121269-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:42468 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbdKVTwD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 14:52:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

This series fixes potentially unaligned memory accesses when loading the
initial state, key, and IV for ChaCha20, and when outputting each
keystream block.

It also removes the cra_alignmask from the generic and x86 ChaCha20
implementations, once it is no longer needed.

Eric Biggers (5):
  crypto: chacha20 - Fix unaligned access when loading constants
  crypto: chacha20 - Use unaligned access macros when loading key and IV
  crypto: chacha20 - Remove cra_alignmask
  crypto: x86/chacha20 - Remove cra_alignmask
  crypto: chacha20 - Fix keystream alignment for chacha20_block()

 arch/x86/crypto/chacha20_glue.c |  1 -
 crypto/chacha20_generic.c       | 33 +++++++++++++--------------------
 drivers/char/random.c           | 24 ++++++++++++------------
 include/crypto/chacha20.h       |  3 ++-
 lib/chacha20.c                  |  2 +-
 5 files changed, 28 insertions(+), 35 deletions(-)

-- 
2.15.0.448.gf294e3d99a-goog
