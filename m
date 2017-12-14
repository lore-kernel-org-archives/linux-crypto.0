From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 03/17] crypto: inside-secure - remove useless memset
Date: Thu, 14 Dec 2017 15:26:45 +0100
Message-ID: <20171214142659.16987-4-antoine.tenart@free-electrons.com>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36749 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752803AbdLNOaD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:03 -0500
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes an useless memset in the ahash_export function, as
the zeroed buffer will be entirely overridden the next line.

Suggested-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index d4afc070ff58..ac922b91b2d7 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -624,7 +624,6 @@ static int safexcel_ahash_export(struct ahash_request *areq, void *out)
 	export->processed = req->processed;
 
 	memcpy(export->state, req->state, req->state_sz);
-	memset(export->cache, 0, crypto_ahash_blocksize(ahash));
 	memcpy(export->cache, req->cache, crypto_ahash_blocksize(ahash));
 
 	return 0;
-- 
2.14.3
