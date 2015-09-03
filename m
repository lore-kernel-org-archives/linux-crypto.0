From: Andrey Ryabinin <aryabinin@odin.com>
Subject: [PATCH] x86/crypto/ghash-intel: specify context size for ghash async algorithm
Date: Thu, 3 Sep 2015 14:32:01 +0300
Message-ID: <1441279921-26838-2-git-send-email-aryabinin@odin.com>
References: <1441279921-26838-1-git-send-email-aryabinin@odin.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andrey Ryabinin <aryabinin@odin.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441279921-26838-1-git-send-email-aryabinin@odin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently context size (cra_ctxsize) doesn't specified for
ghash_async_alg. Which means it's zero. Thus crypto_create_tfm()
doesn't allocate needed space for ghash_async_ctx, so any
read/write to ctx (e.g. in ghash_async_init_tfm()) is not valid.

Signed-off-by: Andrey Ryabinin <aryabinin@odin.com>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 64d7cf1..440df0c 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -294,6 +294,7 @@ static struct ahash_alg ghash_async_alg = {
 			.cra_name		= "ghash",
 			.cra_driver_name	= "ghash-clmulni",
 			.cra_priority		= 400,
+			.cra_ctxsize		= sizeof(struct ghash_async_ctx),
 			.cra_flags		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
 			.cra_blocksize		= GHASH_BLOCK_SIZE,
 			.cra_type		= &crypto_ahash_type,
-- 
2.4.6
