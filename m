From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [PATCH v5 0/4] gf128mul refactoring
Date: Sun,  2 Apr 2017 21:19:12 +0200
Message-ID: <20170402191916.9309-1-omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Jeffrey Walton <noloader@gmail.com>,
        Milan Broz <gmazyland@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33651 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751570AbdDBTUb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Apr 2017 15:20:31 -0400
Received: by mail-wr0-f193.google.com with SMTP id u18so28216114wrc.0
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2017 12:20:30 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset contains the following gf128mul-related changes:
  1. The gf128mul_x_* functions are moved to gf128mul.h for performance reasons.
  2. The gf128mul_x_ble function is fixed to use the correct block type.
  3. The le128_gf128mul_x_ble function from glue_helper.h is removed and its
     usages replaced with gf128mul_x_ble calls.
  4. The now obsolete dependency of CRYPTO_XTS on CRYPTO_GF128MUL is removed.

v4 -> v5: added the other three patches
v3 -> v4: a faster version of gf128mul_x_lle
v2 -> v3: constant-time implementation
v1 -> v2: move all _x_ functions to the header, not just gf128mul_x_ble

Ondrej Mosnacek (4):
  crypto: gf128mul - define gf128mul_x_* in gf128mul.h
  crypto: gf128mul - switch gf128mul_x_ble to le128
  crypto: glue_helper - remove the le128_gf128mul_x_ble function
  crypto: xts - drop gf128mul dependency

 arch/x86/crypto/camellia_glue.c           |  4 +--
 arch/x86/crypto/glue_helper.c             |  3 +-
 arch/x86/crypto/serpent_sse2_glue.c       |  4 +--
 arch/x86/crypto/twofish_glue_3way.c       |  4 +--
 arch/x86/include/asm/crypto/glue_helper.h | 10 ------
 crypto/Kconfig                            |  1 -
 crypto/gf128mul.c                         | 33 +------------------
 crypto/xts.c                              | 38 ++++++++++-----------
 include/crypto/gf128mul.h                 | 55 +++++++++++++++++++++++++++++--
 include/crypto/xts.h                      |  2 +-
 10 files changed, 82 insertions(+), 72 deletions(-)

-- 
2.9.3
