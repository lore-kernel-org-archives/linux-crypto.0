From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/4] crypto: caam - remove unused authkeylen from caam_ctx
Date: Sat, 14 May 2011 22:08:11 -0500
Message-ID: <20110514220811.8e5cbb28.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:15006
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591Ab1EODIS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 May 2011 23:08:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 4c69ba7..672abf3 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -83,7 +83,6 @@ struct caam_ctx {
 	u8 *key;
 	dma_addr_t key_phys;
 	unsigned int enckeylen;
-	unsigned int authkeylen;
 	unsigned int split_key_len;
 	unsigned int split_key_pad_len;
 	unsigned int authsize;
@@ -330,7 +329,6 @@ static int aead_authenc_setkey(struct crypto_aead *aead,
 #endif
 
 	ctx->enckeylen = enckeylen;
-	ctx->authkeylen = authkeylen;
 
 	ret = build_sh_desc_ipsec(ctx);
 	if (ret) {
-- 
1.7.5.1
