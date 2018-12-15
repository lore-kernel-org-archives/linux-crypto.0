Return-Path: <SRS0=nt8C=OY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727229AbeLOUmW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Dec 2018 15:42:22 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: skcipher - add might_sleep() to skcipher_walk_virt()
Date: Sat, 15 Dec 2018 12:41:53 -0800
Message-Id: <20181215204153.8016-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

skcipher_walk_virt() can still sleep even with atomic=true, since that
only affects the later calls to skcipher_walk_done().  But,
skcipher_walk_virt() only has to allocate memory for some input data
layouts, so incorrectly calling it with preemption disabled can go
undetected.  Use might_sleep() so that it's detected reliably.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 17be8d9c714eb..41b4f7f27f454 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -474,6 +474,8 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
 {
 	int err;
 
+	might_sleep_if(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+
 	walk->flags &= ~SKCIPHER_WALK_PHYS;
 
 	err = skcipher_walk_skcipher(walk, req);
-- 
2.19.2
