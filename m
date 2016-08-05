From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH v2 7/7] crypto: img-hash - Fix set_reqsize call
Date: Fri, 5 Aug 2016 14:00:20 +0100
Message-ID: <1470402020-10774-8-git-send-email-will.thomas@imgtec.com>
References: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Will Thomas <will.thomas@imgtec.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:23440 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759709AbcHENIQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 09:08:16 -0400
In-Reply-To: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Properly allocate enough memory to respect the fallback.

Signed-off-by: Will Thomas <will.thomas@imgtec.com>
---
 drivers/crypto/img-hash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 60410d7..a2e77b8 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -686,6 +686,7 @@ static int img_hash_cra_init(struct crypto_tfm *tfm, const char *alg_name)
 	}
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct img_hash_request_ctx) +
+				 crypto_ahash_reqsize(ctx->fallback) +
 				 IMG_HASH_DMA_THRESHOLD);
 
 	return 0;
-- 
2.1.4
