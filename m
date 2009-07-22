From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: ahash - Use GFP_KERNEL on allocation if the
	request can sleep
Date: Wed, 22 Jul 2009 11:51:23 +0200
Message-ID: <20090722095123.GL20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:41847 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZGVJss (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 05:48:48 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ahash_op_unaligned() and ahash_def_finup() allocate memory atomically,
regardless whether the request can sleep or not. This patch changes
this to use GFP_KERNEL if the request can sleep.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ahash.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 28a33d0..33a4ff4 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -223,7 +223,7 @@ static int ahash_op_unaligned(struct ahash_request *req,
 
 	priv = kmalloc(sizeof(*priv) + ahash_align_buffer_size(ds, alignmask),
 		       (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_ATOMIC : GFP_ATOMIC);
+		       GFP_KERNEL : GFP_ATOMIC);
 	if (!priv)
 		return -ENOMEM;
 
@@ -333,7 +333,7 @@ static int ahash_def_finup(struct ahash_request *req)
 
 	priv = kmalloc(sizeof(*priv) + ahash_align_buffer_size(ds, alignmask),
 		       (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_ATOMIC : GFP_ATOMIC);
+		       GFP_KERNEL : GFP_ATOMIC);
 	if (!priv)
 		return -ENOMEM;
 
-- 
1.5.4.2

