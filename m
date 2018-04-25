From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: arm64 - add support for SM4 encryption using
 special instructions
Date: Wed, 25 Apr 2018 14:20:46 +0200
Message-ID: <20180425122046.12695-3-ard.biesheuvel@linaro.org>
References: <20180425122046.12695-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: gilad@benyossef.com, herbert@gondor.apana.org.au,
 linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180425122046.12695-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Add support for the SM4 symmetric cipher implemented using the special
SM4 instructions introduced in ARM architecture revision 8.2.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig       |  6 ++
 arch/arm64/crypto/Makefile      |  3 +
 arch/arm64/crypto/sm4-ce-core.S | 36 ++++++++++
 arch/arm64/crypto/sm4-ce-glue.c | 73 ++++++++++++++++++++
 4 files changed, 118 insertions(+)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index cb5a243110c4..e3fdb0fd6f70 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -47,6 +47,12 @@ config CRYPTO_SM3_ARM64_CE
 	select CRYPTO_HASH
 	select CRYPTO_SM3
 
+config CRYPTO_SM4_ARM64_CE
+	tristate "SM4 symmetric cipher (ARMv8.2 Crypto Extensions)"
+	depends on KERNEL_MODE_NEON
+	select CRYPTO_ALGAPI
+	select CRYPTO_SM4
+
 config CRYPTO_GHASH_ARM64_CE
 	tristate "GHASH/AES-GCM using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index f35ac684b1c0..bcafd016618e 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -23,6 +23,9 @@ sha3-ce-y := sha3-ce-glue.o sha3-ce-core.o
 obj-$(CONFIG_CRYPTO_SM3_ARM64_CE) += sm3-ce.o
 sm3-ce-y := sm3-ce-glue.o sm3-ce-core.o
 
+obj-$(CONFIG_CRYPTO_SM4_ARM64_CE) += sm4-ce.o
+sm4-ce-y := sm4-ce-glue.o sm4-ce-core.o
+
 obj-$(CONFIG_CRYPTO_GHASH_ARM64_CE) += ghash-ce.o
 ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
 
diff --git a/arch/arm64/crypto/sm4-ce-core.S b/arch/arm64/crypto/sm4-ce-core.S
new file mode 100644
index 000000000000..af3bfbc3f4d4
--- /dev/null
+++ b/arch/arm64/crypto/sm4-ce-core.S
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+	.irp		b, 0, 1, 2, 3, 4, 5, 6, 7, 8
+	.set		.Lv\b\().4s, \b
+	.endr
+
+	.macro		sm4e, rd, rn
+	.inst		0xcec08400 | .L\rd | (.L\rn << 5)
+	.endm
+
+	/*
+	 * void sm4_ce_do_crypt(const u32 *rk, u32 *out, const u32 *in);
+	 */
+	.text
+ENTRY(sm4_ce_do_crypt)
+	ld1		{v8.4s}, [x2]
+	ld1		{v0.4s-v3.4s}, [x0], #64
+CPU_LE(	rev32		v8.16b, v8.16b		)
+	ld1		{v4.4s-v7.4s}, [x0]
+	sm4e		v8.4s, v0.4s
+	sm4e		v8.4s, v1.4s
+	sm4e		v8.4s, v2.4s
+	sm4e		v8.4s, v3.4s
+	sm4e		v8.4s, v4.4s
+	sm4e		v8.4s, v5.4s
+	sm4e		v8.4s, v6.4s
+	sm4e		v8.4s, v7.4s
+	rev64		v8.4s, v8.4s
+	ext		v8.16b, v8.16b, v8.16b, #8
+CPU_LE(	rev32		v8.16b, v8.16b		)
+	st1		{v8.4s}, [x1]
+	ret
+ENDPROC(sm4_ce_do_crypt)
diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
new file mode 100644
index 000000000000..b7fb5274b250
--- /dev/null
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <crypto/sm4.h>
+#include <linux/module.h>
+#include <linux/cpufeature.h>
+#include <linux/crypto.h>
+#include <linux/types.h>
+
+MODULE_ALIAS_CRYPTO("sm4");
+MODULE_ALIAS_CRYPTO("sm4-ce");
+MODULE_DESCRIPTION("SM4 symmetric cipher using ARMv8 Crypto Extensions");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+
+asmlinkage void sm4_ce_do_crypt(const u32 *rk, void *out, const void *in);
+
+static void sm4_ce_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (!may_use_simd()) {
+		crypto_sm4_encrypt(tfm, out, in);
+	} else {
+		kernel_neon_begin();
+		sm4_ce_do_crypt(ctx->rkey_enc, out, in);
+		kernel_neon_end();
+	}
+}
+
+static void sm4_ce_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (!may_use_simd()) {
+		crypto_sm4_decrypt(tfm, out, in);
+	} else {
+		kernel_neon_begin();
+		sm4_ce_do_crypt(ctx->rkey_dec, out, in);
+		kernel_neon_end();
+	}
+}
+
+static struct crypto_alg sm4_ce_alg = {
+	.cra_name			= "sm4",
+	.cra_driver_name		= "sm4-ce",
+	.cra_priority			= 200,
+	.cra_flags			= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize			= SM4_BLOCK_SIZE,
+	.cra_ctxsize			= sizeof(struct crypto_sm4_ctx),
+	.cra_module			= THIS_MODULE,
+	.cra_u.cipher = {
+		.cia_min_keysize	= SM4_KEY_SIZE,
+		.cia_max_keysize	= SM4_KEY_SIZE,
+		.cia_setkey		= crypto_sm4_set_key,
+		.cia_encrypt		= sm4_ce_encrypt,
+		.cia_decrypt		= sm4_ce_decrypt
+	}
+};
+
+static int __init sm4_ce_mod_init(void)
+{
+	return crypto_register_alg(&sm4_ce_alg);
+}
+
+static void __exit sm4_ce_mod_fini(void)
+{
+	crypto_unregister_alg(&sm4_ce_alg);
+}
+
+module_cpu_feature_match(SM3, sm4_ce_mod_init);
+module_exit(sm4_ce_mod_fini);
-- 
2.17.0
