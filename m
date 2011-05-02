From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/2] crypto: caam - remove unused keylen from session
 context
Date: Mon, 2 May 2011 18:27:41 -0500
Message-ID: <20110502182741.799ff896.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Steve Cornelius <sec@pobox.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:7566 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1EBX1n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2011 19:27:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 97d6dcc..719ad06 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -82,7 +82,6 @@ struct caam_ctx {
 	u32 alg_op;
 	u8 *key;
 	dma_addr_t key_phys;
-	unsigned int keylen;
 	unsigned int enckeylen;
 	unsigned int authkeylen;
 	unsigned int split_key_len;
@@ -330,7 +329,6 @@ static int aead_authenc_setkey(struct crypto_aead *aead,
 		       ctx->split_key_pad_len + enckeylen, 1);
 #endif
 
-	ctx->keylen = keylen;
 	ctx->enckeylen = enckeylen;
 	ctx->authkeylen = authkeylen;
 
-- 
1.7.5
