From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 12/17] crypto: inside-secure - increase the ring size
Date: Thu, 14 Dec 2017 15:26:54 +0100
Message-ID: <20171214142659.16987-13-antoine.tenart@free-electrons.com>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36799 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753163AbdLNOaI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:08 -0500
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Increase the ring size to handle more requests in parallel, while
keeping the batch size (for interrupt coalescing) to its previous value.
The ring size and batch size are now unlinked.

Suggested-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 531e3e9d8384..2a0ab6ce716a 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -19,11 +19,11 @@
 #define EIP197_HIA_VERSION_BE			0x35ca
 
 /* Static configuration */
-#define EIP197_DEFAULT_RING_SIZE		64
+#define EIP197_DEFAULT_RING_SIZE		400
 #define EIP197_MAX_TOKENS			5
 #define EIP197_MAX_RINGS			4
 #define EIP197_FETCH_COUNT			1
-#define EIP197_MAX_BATCH_SZ			EIP197_DEFAULT_RING_SIZE
+#define EIP197_MAX_BATCH_SZ			64
 
 #define EIP197_GFP_FLAGS(base)	((base).flags & CRYPTO_TFM_REQ_MAY_SLEEP ? \
 				 GFP_KERNEL : GFP_ATOMIC)
-- 
2.14.3
