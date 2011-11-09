From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: serpent-sse2 - clear CRYPTO_TFM_REQ_MAY_SLEEP in lrw
 and xts modes
Date: Wed, 09 Nov 2011 19:44:12 +0200
Message-ID: <20111109174412.2376.10503.stgit@localhost6.localdomain6>
References: <20111109142641.23131.40465.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:50519 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1KIRoO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Nov 2011 12:44:14 -0500
In-Reply-To: <20111109142641.23131.40465.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

LRW/XTS patches for serpent-sse2 forgot to add this. CRYPTO_TFM_REQ_MAY_SLEEP
should be cleared as sleeping between kernel_fpu_begin()/kernel_fpu_end() is
not allowed.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent_sse2_glue.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 8e214db..611c3c8 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -554,6 +554,7 @@ static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	};
 	int ret;
 
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 	ret = lrw_crypt(desc, dst, src, nbytes, &req);
 	serpent_fpu_end(crypt_ctx.fpu_enabled);
 
@@ -579,6 +580,7 @@ static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	};
 	int ret;
 
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 	ret = lrw_crypt(desc, dst, src, nbytes, &req);
 	serpent_fpu_end(crypt_ctx.fpu_enabled);
 
@@ -671,6 +673,7 @@ static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	};
 	int ret;
 
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 	ret = xts_crypt(desc, dst, src, nbytes, &req);
 	serpent_fpu_end(crypt_ctx.fpu_enabled);
 
@@ -697,6 +700,7 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	};
 	int ret;
 
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 	ret = xts_crypt(desc, dst, src, nbytes, &req);
 	serpent_fpu_end(crypt_ctx.fpu_enabled);
 
