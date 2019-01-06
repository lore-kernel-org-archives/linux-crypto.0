Return-Path: <SRS0=Z4qA=PO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbfAFUtY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 15:49:24 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: algapi - reject NULL crypto_spawn::inst
Date: Sun,  6 Jan 2019 12:46:06 -0800
Message-Id: <20190106204606.11412-2-ebiggers@kernel.org>
In-Reply-To: <20190106204606.11412-1-ebiggers@kernel.org>
References: <20190106204606.11412-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

It took me a while to notice the bug where the adiantum template left
crypto_spawn::inst == NULL, because this only caused problems in certain
cases where algorithms are dynamically loaded/unloaded.

More improvements are needed, but for now make crypto_init_spawn()
reject this case and WARN(), so this type of bug will be noticed
immediately in the future.

Note: I checked all callers and the adiantum template was the only place
that had this wrong.  So this WARN shouldn't trigger anymore.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index f3d766312bd96..713baabeb6438 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -608,6 +608,9 @@ int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 {
 	int err = -EAGAIN;
 
+	if (WARN_ON_ONCE(inst == NULL))
+		return -EINVAL;
+
 	spawn->inst = inst;
 	spawn->mask = mask;
 
-- 
2.20.1
