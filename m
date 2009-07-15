From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] cryptd: Fix uninitialized return value
Date: Wed, 15 Jul 2009 10:50:09 +0200
Message-ID: <20090715085009.GL20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:43446 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbZGOIra (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 04:47:30 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If cryptd_alloc_instance() fails, the return value is uninitialized.
This patch fixes this by setting the return value.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/cryptd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 5dabb7d..fbd26f9 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -303,6 +303,7 @@ static int cryptd_create_blkcipher(struct crypto_template *tmpl,
 		return PTR_ERR(alg);
 
 	inst = cryptd_alloc_instance(alg, 0, sizeof(*ctx));
+	err = PTR_ERR(inst);
 	if (IS_ERR(inst))
 		goto out_put_alg;
 
@@ -522,6 +523,7 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	alg = &salg->base;
 	inst = cryptd_alloc_instance(alg, ahash_instance_headroom(),
 				     sizeof(*ctx));
+	err = PTR_ERR(inst);
 	if (IS_ERR(inst))
 		goto out_put_alg;
 
-- 
1.5.4.2

