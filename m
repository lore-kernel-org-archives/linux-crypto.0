From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/2] crypto: ccree: cleanup and hardware keys
Date: Mon, 26 Mar 2018 08:32:17 +0100
Message-ID: <1522049540-10042-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Small cleanup and add support for CryptoCell hardware keys.

Gilad Ben-Yossef (2):
  crypto: ccree: remove unused enums
  crypto: ccree: enable support for hardware keys

 crypto/testmgr.c                        |  43 ++++
 drivers/crypto/ccree/cc_cipher.c        | 348 ++++++++++++++++++++++++++++----
 drivers/crypto/ccree/cc_cipher.h        |  30 +--
 drivers/crypto/ccree/cc_hw_queue_defs.h |  28 +--
 4 files changed, 366 insertions(+), 83 deletions(-)

-- 
2.7.4
