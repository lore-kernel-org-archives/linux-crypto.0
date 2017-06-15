From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 13/13] crypto: inside-secure - use the base_end pointer in ring rollback
Date: Thu, 15 Jun 2017 09:56:29 +0200
Message-ID: <20170615075629.30907-14-antoine.tenart@free-electrons.com>
References: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53413 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbdFOIAH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:07 -0400
In-Reply-To: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A base_end pointer is set and provided. Use it in the ring rollback
function to avoid using build-in defines.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_ring.c b/drivers/crypto/inside-secure/safexcel_ring.c
index fdbf05ae55fc..c9d2a8716b5b 100644
--- a/drivers/crypto/inside-secure/safexcel_ring.c
+++ b/drivers/crypto/inside-secure/safexcel_ring.c
@@ -84,7 +84,7 @@ void safexcel_ring_rollback_wptr(struct safexcel_crypto_priv *priv,
 		return;
 
 	if (ring->write == ring->base)
-		ring->write += (EIP197_DEFAULT_RING_SIZE - 1) * ring->offset;
+		ring->write = ring->base_end - ring->offset;
 	else
 		ring->write -= ring->offset;
 
-- 
2.9.4
