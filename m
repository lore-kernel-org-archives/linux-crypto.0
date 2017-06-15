From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 12/13] crypto: inside-secure - increase the batch size
Date: Thu, 15 Jun 2017 09:56:28 +0200
Message-ID: <20170615075629.30907-13-antoine.tenart@free-electrons.com>
References: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53416 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbdFOIAH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:07 -0400
In-Reply-To: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Increase the batch size to the maximum number of requests a ring can
handle at a time (its size). This is possible now that the request
queues are per hw ring. This improves performances.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index abe0f59d1473..304c5838c11a 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -23,7 +23,7 @@
 #define EIP197_MAX_TOKENS			5
 #define EIP197_MAX_RINGS			4
 #define EIP197_FETCH_COUNT			1
-#define EIP197_MAX_BATCH_SZ			8
+#define EIP197_MAX_BATCH_SZ			EIP197_DEFAULT_RING_SIZE
 
 #define EIP197_GFP_FLAGS(base)	((base).flags & CRYPTO_TFM_REQ_MAY_SLEEP ? \
 				 GFP_KERNEL : GFP_ATOMIC)
-- 
2.9.4
