From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5/6] crypto: arm64/aes-blk - expose AES-CTR as synchronous
 cipher as well
Date: Mon,  2 Jan 2017 18:21:07 +0000
Message-ID: <1483381268-12987-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1483381268-12987-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1483381268-12987-1-git-send-email-ard.biesheuvel@linaro.org>
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

In addition to wrapping the AES-CTR cipher into the async SIMD wrapper,
which exposes it as an async skcipher that defers processing to process
context, expose our AES-CTR implementation directly as a synchronous cipher
as well, but with a lower priority.

This makes the AES-CTR transform usable in places where synchronous
transforms are required, such as the MAC802.11 encryption code, which
executes in sotfirq context, where SIMD processing is allowed on arm64.
Users of the async transform will keep the existing behavior.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c | 25 ++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 4e3f8adb1793..5164aaf82c6a 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -327,6 +327,23 @@ static struct skcipher_alg aes_algs[] = { {
 	.decrypt	= ctr_encrypt,
 }, {
 	.base = {
+		.cra_name		= "ctr(aes)",
+		.cra_driver_name	= "ctr-aes-" MODE,
+		.cra_priority		= PRIO - 1,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+		.cra_alignmask		= 7,
+		.cra_module		= THIS_MODULE,
+	},
+	.min_keysize	= AES_MIN_KEY_SIZE,
+	.max_keysize	= AES_MAX_KEY_SIZE,
+	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= AES_BLOCK_SIZE,
+	.setkey		= skcipher_aes_setkey,
+	.encrypt	= ctr_encrypt,
+	.decrypt	= ctr_encrypt,
+}, {
+	.base = {
 		.cra_name		= "__xts(aes)",
 		.cra_driver_name	= "__xts-aes-" MODE,
 		.cra_priority		= PRIO,
@@ -350,8 +367,9 @@ static void aes_exit(void)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(aes_simd_algs) && aes_simd_algs[i]; i++)
-		simd_skcipher_free(aes_simd_algs[i]);
+	for (i = 0; i < ARRAY_SIZE(aes_simd_algs); i++)
+		if (aes_simd_algs[i])
+			simd_skcipher_free(aes_simd_algs[i]);
 
 	crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 }
@@ -370,6 +388,9 @@ static int __init aes_init(void)
 		return err;
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
+		if (!(aes_algs[i].base.cra_flags & CRYPTO_ALG_INTERNAL))
+			continue;
+
 		algname = aes_algs[i].base.cra_name + 2;
 		drvname = aes_algs[i].base.cra_driver_name + 2;
 		basename = aes_algs[i].base.cra_driver_name;
-- 
2.7.4
