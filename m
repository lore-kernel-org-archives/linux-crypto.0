From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 0/2] crypto: constify test vectors
Date: Fri, 24 Feb 2017 15:46:57 -0800
Message-ID: <20170224234659.89423-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34471 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbdBXXrb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2017 18:47:31 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

These two patches mark all the cryptographic test vectors as 'const'.
This has several potential advantages and moves a large amount of data
from .data to .rodata when the tests are enabled.  The second patch does
the real work; the first just prepares for it by updating a function to
take a const buffer argument.

Eric Biggers (2):
  crypto: kpp - constify buffer passed to crypto_kpp_set_secret()
  crypto: testmgr - constify all test vectors

 crypto/dh.c                                   |   3 +-
 crypto/ecdh.c                                 |   3 +-
 crypto/testmgr.c                              |  71 ++--
 crypto/testmgr.h                              | 512 +++++++++++++-------------
 drivers/crypto/qat/qat_common/qat_asym_algs.c |   2 +-
 include/crypto/kpp.h                          |   6 +-
 6 files changed, 305 insertions(+), 292 deletions(-)

-- 
2.11.0.483.g087da7b7c-goog
