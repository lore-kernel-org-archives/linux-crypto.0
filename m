From: Colin King <colin.king@canonical.com>
Subject: [PATCH] arm64/crypto: remove redundant update of data
Date: Sun, 24 Aug 2014 21:38:35 +0100
Message-ID: <1408912715-9719-1-git-send-email-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Originally found by cppcheck:

[arch/arm64/crypto/sha2-ce-glue.c:153]: (warning) Assignment of
  function parameter has no effect outside the function. Did you
  forget dereferencing it?

Updating data by blocks * SHA256_BLOCK_SIZE at the end of
ha2_finup is redundant code and can be removed.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/arm64/crypto/sha2-ce-glue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index c294e67..ae67e88 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -150,7 +150,6 @@ static void sha2_finup(struct shash_desc *desc, const u8 *data,
 	kernel_neon_begin_partial(28);
 	sha2_ce_transform(blocks, data, sctx->state, NULL, len);
 	kernel_neon_end();
-	data += blocks * SHA256_BLOCK_SIZE;
 }
 
 static int sha224_finup(struct shash_desc *desc, const u8 *data,
-- 
2.1.0
