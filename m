From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 0/2] cleanup and hardware keys
Date: Mon, 23 Apr 2018 08:25:13 +0100
Message-ID: <1524468316-6606-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Small cleanup and add support for CryptoCell hardware keys.

Changes from v1:
- The cleanup patch is new, as Herbert took the previous one :-)
- Hardware key API uses the "paes" designator to indicate a protected key,
  same as s390, as per Herbert preference
- Avoid direct casting and reference of key material, as pointed out by
  Herbert

Gilad Ben-Yossef (2):
  crypto: ccree: enable support for hardware keys
  crypto: ccree: use proper printk format

 crypto/testmgr.c                 |  43 +++++
 drivers/crypto/ccree/cc_cipher.c | 350 ++++++++++++++++++++++++++++++++++-----
 drivers/crypto/ccree/cc_cipher.h |  30 +---
 drivers/crypto/ccree/cc_driver.c |   2 +-
 4 files changed, 362 insertions(+), 63 deletions(-)

-- 
2.7.4
