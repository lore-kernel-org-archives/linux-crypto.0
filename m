From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH v2 01/10] Expose SHA256 generic routine to be callable
 externally.
Date: Tue, 26 Mar 2013 13:58:49 -0700
Message-ID: <1364331529.27102.11.camel@schen9-DESK>
References: <cover.1364303479.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Jim Kukunas <james.t.kukunas@linux.intel.com>,
	Kirk Yap <kirk.s.yap@intel.com>,
	David Cote <david.m.cote@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1364303479.git.tim.c.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Other SHA256 routine may need to use the generic routine when
FPU is not available.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/sha256_generic.c | 11 ++++++-----
 include/crypto/sha.h    |  2 ++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index c3ed4ec..5433667 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -246,7 +246,7 @@ static int sha256_init(struct shash_desc *desc)
 	return 0;
 }
 
-static int sha256_update(struct shash_desc *desc, const u8 *data,
+int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
@@ -277,6 +277,7 @@ static int sha256_update(struct shash_desc *desc, const u8 *data,
 
 	return 0;
 }
+EXPORT_SYMBOL(crypto_sha256_update);
 
 static int sha256_final(struct shash_desc *desc, u8 *out)
 {
@@ -293,10 +294,10 @@ static int sha256_final(struct shash_desc *desc, u8 *out)
 	/* Pad out to 56 mod 64. */
 	index = sctx->count & 0x3f;
 	pad_len = (index < 56) ? (56 - index) : ((64+56) - index);
-	sha256_update(desc, padding, pad_len);
+	crypto_sha256_update(desc, padding, pad_len);
 
 	/* Append length (before padding) */
-	sha256_update(desc, (const u8 *)&bits, sizeof(bits));
+	crypto_sha256_update(desc, (const u8 *)&bits, sizeof(bits));
 
 	/* Store state in digest */
 	for (i = 0; i < 8; i++)
@@ -339,7 +340,7 @@ static int sha256_import(struct shash_desc *desc, const void *in)
 static struct shash_alg sha256_algs[2] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_init,
-	.update		=	sha256_update,
+	.update		=	crypto_sha256_update,
 	.final		=	sha256_final,
 	.export		=	sha256_export,
 	.import		=	sha256_import,
@@ -355,7 +356,7 @@ static struct shash_alg sha256_algs[2] = { {
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
 	.init		=	sha224_init,
-	.update		=	sha256_update,
+	.update		=	crypto_sha256_update,
 	.final		=	sha224_final,
 	.descsize	=	sizeof(struct sha256_state),
 	.base		=	{
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index c6c9c1f..f46ff61 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -87,4 +87,6 @@ struct shash_desc;
 extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
 
+extern int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len);
 #endif
-- 
1.7.11.7
