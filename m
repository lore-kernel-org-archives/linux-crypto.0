From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 02/11] crypto: caam - Use GCM IV size constant
Date: Tue, 22 Aug 2017 10:08:09 +0200
Message-ID: <20170822080818.12486-3-clabbe.montjoie@gmail.com>
References: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
 linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de,
 mingo@redhat.com, hpa@zytor.com, x86@kernel.org, horia.geanta@nxp.com,
 dan.douglass@nxp.com, thomas.lendacky@amd.com, gary.hook@amd.com,
 harsh@chelsio.com, matthias.bgg@gmail.com, leosilva@linux.vnet.ibm.com,
 pfsmorigo@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
 mpe@ellerman.id.au
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
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

This patch replace GCM IV size value by their constant name.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/caam/caamalg.c | 10 +++++-----
 drivers/crypto/caam/compat.h  |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 54f3b375a453..baa8dd52472d 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -992,7 +992,7 @@ static void init_gcm_job(struct aead_request *req,
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	u32 *desc = edesc->hw_desc;
-	bool generic_gcm = (ivsize == 12);
+	bool generic_gcm = (ivsize == GCM_AES_IV_SIZE);
 	unsigned int last;
 
 	init_aead_job(req, edesc, all_contig, encrypt);
@@ -1004,7 +1004,7 @@ static void init_gcm_job(struct aead_request *req,
 
 	/* Read GCM IV */
 	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-			 FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | 12 | last);
+			 FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | GCM_AES_IV_SIZE | last);
 	/* Append Salt */
 	if (!generic_gcm)
 		append_data(desc, ctx->key + ctx->cdata.keylen, 4);
@@ -1953,7 +1953,7 @@ static struct caam_aead_alg driver_aeads[] = {
 			.setauthsize = rfc4106_setauthsize,
 			.encrypt = ipsec_gcm_encrypt,
 			.decrypt = ipsec_gcm_decrypt,
-			.ivsize = 8,
+			.ivsize = GCM_RFC4106_IV_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
 		.caam = {
@@ -1971,7 +1971,7 @@ static struct caam_aead_alg driver_aeads[] = {
 			.setauthsize = rfc4543_setauthsize,
 			.encrypt = ipsec_gcm_encrypt,
 			.decrypt = ipsec_gcm_decrypt,
-			.ivsize = 8,
+			.ivsize = GCM_RFC4543_IV_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
 		.caam = {
@@ -1990,7 +1990,7 @@ static struct caam_aead_alg driver_aeads[] = {
 			.setauthsize = gcm_setauthsize,
 			.encrypt = gcm_encrypt,
 			.decrypt = gcm_decrypt,
-			.ivsize = 12,
+			.ivsize = GCM_AES_IV_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
 		.caam = {
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index 7149cd2492e0..5b8d930f3dd8 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -31,6 +31,7 @@
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
 #include <crypto/des.h>
+#include <crypto/gcm.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
 #include <crypto/internal/aead.h>
-- 
2.13.0
