From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 01/16] crypto: authenc - Don't multiply priorities
Date: Thu, 11 Aug 2011 13:26:39 +0200
Message-ID: <20110811112639.GE16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:34402 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab1HKL0H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 07:26:07 -0400
Content-Disposition: inline
In-Reply-To: <20110811112603.GD16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Most crypto algorithms simply take the priority value of the underlying
algorithm and add some value to calculate the algorithms priority.
The only exeptions are the authenc algorithms. We change the authenc
algorithms to calculate their priority to the sum of the underlying
algorithms plus 100. With this we can keep the priority consistent if
one of the underlying algorithms changes the priority.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/authenc.c    |    4 ++--
 crypto/authencesn.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 5ef7ba6..59349e4 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -644,8 +644,8 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
 	inst->alg.cra_flags |= enc->cra_flags & CRYPTO_ALG_ASYNC;
-	inst->alg.cra_priority = enc->cra_priority *
-				 10 + auth_base->cra_priority;
+	inst->alg.cra_priority = enc->cra_priority +
+				 auth_base->cra_priority + 100;
 	inst->alg.cra_blocksize = enc->cra_blocksize;
 	inst->alg.cra_alignmask = auth_base->cra_alignmask | enc->cra_alignmask;
 	inst->alg.cra_type = &crypto_aead_type;
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 136b68b..de82829 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -767,8 +767,8 @@ static struct crypto_instance *crypto_authenc_esn_alloc(struct rtattr **tb)
 
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
 	inst->alg.cra_flags |= enc->cra_flags & CRYPTO_ALG_ASYNC;
-	inst->alg.cra_priority = enc->cra_priority *
-				 10 + auth_base->cra_priority;
+	inst->alg.cra_priority = enc->cra_priority +
+				 auth_base->cra_priority + 100;
 	inst->alg.cra_blocksize = enc->cra_blocksize;
 	inst->alg.cra_alignmask = auth_base->cra_alignmask | enc->cra_alignmask;
 	inst->alg.cra_type = &crypto_aead_type;
-- 
1.7.0.4
