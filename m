From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/4] crypto: fixes and cleanups
Date: Thu, 28 Jun 2018 08:32:50 +0100
Message-ID: <1530171175-31960-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The patch set fixes ccree IV handling and finuo() operation (provided
by Hadar Gat) along a code cleanup.

Since our finup() method was obviously broken but was not detected
by testmgr, I've added finup() test to testmgr to catch it next
time it happened

Gilad Ben-Yossef (3):
  crypto: testmgr: add hash finup tests
  crypto: ccree: fix iv handling
  crypto: ccree: remove dead legacy code

Hadar Gat (1):
  crypto: ccree: fix finup

 crypto/testmgr.c                 |  55 +++++++++++++++---
 drivers/crypto/ccree/cc_cipher.c | 117 ++++++++++++++++++++++++++++-----------
 drivers/crypto/ccree/cc_hash.c   |  81 ++++++---------------------
 3 files changed, 146 insertions(+), 107 deletions(-)

-- 
2.7.4
