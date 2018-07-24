From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 11/18] dm crypt: Convert essiv from ahash to
	shash
Date: Tue, 24 Jul 2018 09:49:29 -0700
Message-ID: <20180724164936.37477-12-keescook@chromium.org>
References: <20180724164936.37477-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	linux-wireless@vger.kernel.org,
	Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>, dm-devel@redhat.com,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-afs@lists.infradead.org,
	Alasdair Kergon <agk@redhat.com>,
	Kees Cook <keescook@chromium.org>, devel@driverdev.osuosl.org,
	x86@kernel.org, qat-linux@intel.com, Ingo Molnar <mingo@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	drbd-dev@lists.linbit.com, Rabin Vincent <rabinv@axis.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
	linux-block@vger.kernel.org, Josh Poimboeuf
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180724164936.37477-1-keescook@chromium.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

In preparing to remove all stack VLA usage from the kernel[1], this
removes the discouraged use of AHASH_REQUEST_ON_STACK in favor of the
smaller SHASH_DESC_ON_STACK by converting from ahash-wrapped-shash to
direct shash. By removing a layer of indirection this both improves
performance and reduces stack usage. The stack allocation will be made
a fixed size in a later patch to the crypto subsystem.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-crypt.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b61b069c33af..c4c922990090 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -99,7 +99,7 @@ struct crypt_iv_operations {
 };
 
 struct iv_essiv_private {
-	struct crypto_ahash *hash_tfm;
+	struct crypto_shash *hash_tfm;
 	u8 *salt;
 };
 
@@ -327,25 +327,22 @@ static int crypt_iv_plain64be_gen(struct crypt_config *cc, u8 *iv,
 static int crypt_iv_essiv_init(struct crypt_config *cc)
 {
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	AHASH_REQUEST_ON_STACK(req, essiv->hash_tfm);
-	struct scatterlist sg;
+	SHASH_DESC_ON_STACK(desc, essiv->hash_tfm);
 	struct crypto_cipher *essiv_tfm;
 	int err;
 
-	sg_init_one(&sg, cc->key, cc->key_size);
-	ahash_request_set_tfm(req, essiv->hash_tfm);
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
-	ahash_request_set_crypt(req, &sg, essiv->salt, cc->key_size);
+	desc->tfm = essiv->hash_tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	err = crypto_ahash_digest(req);
-	ahash_request_zero(req);
+	err = crypto_shash_digest(desc, cc->key, cc->key_size, essiv->salt);
+	shash_desc_zero(desc);
 	if (err)
 		return err;
 
 	essiv_tfm = cc->iv_private;
 
 	err = crypto_cipher_setkey(essiv_tfm, essiv->salt,
-			    crypto_ahash_digestsize(essiv->hash_tfm));
+			    crypto_shash_digestsize(essiv->hash_tfm));
 	if (err)
 		return err;
 
@@ -356,7 +353,7 @@ static int crypt_iv_essiv_init(struct crypt_config *cc)
 static int crypt_iv_essiv_wipe(struct crypt_config *cc)
 {
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	unsigned salt_size = crypto_ahash_digestsize(essiv->hash_tfm);
+	unsigned salt_size = crypto_shash_digestsize(essiv->hash_tfm);
 	struct crypto_cipher *essiv_tfm;
 	int r, err = 0;
 
@@ -408,7 +405,7 @@ static void crypt_iv_essiv_dtr(struct crypt_config *cc)
 	struct crypto_cipher *essiv_tfm;
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 
-	crypto_free_ahash(essiv->hash_tfm);
+	crypto_free_shash(essiv->hash_tfm);
 	essiv->hash_tfm = NULL;
 
 	kzfree(essiv->salt);
@@ -426,7 +423,7 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 			      const char *opts)
 {
 	struct crypto_cipher *essiv_tfm = NULL;
-	struct crypto_ahash *hash_tfm = NULL;
+	struct crypto_shash *hash_tfm = NULL;
 	u8 *salt = NULL;
 	int err;
 
@@ -436,14 +433,14 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	}
 
 	/* Allocate hash algorithm */
-	hash_tfm = crypto_alloc_ahash(opts, 0, CRYPTO_ALG_ASYNC);
+	hash_tfm = crypto_alloc_shash(opts, 0, 0);
 	if (IS_ERR(hash_tfm)) {
 		ti->error = "Error initializing ESSIV hash";
 		err = PTR_ERR(hash_tfm);
 		goto bad;
 	}
 
-	salt = kzalloc(crypto_ahash_digestsize(hash_tfm), GFP_KERNEL);
+	salt = kzalloc(crypto_shash_digestsize(hash_tfm), GFP_KERNEL);
 	if (!salt) {
 		ti->error = "Error kmallocing salt storage in ESSIV";
 		err = -ENOMEM;
@@ -454,7 +451,7 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	cc->iv_gen_private.essiv.hash_tfm = hash_tfm;
 
 	essiv_tfm = alloc_essiv_cipher(cc, ti, salt,
-				       crypto_ahash_digestsize(hash_tfm));
+				       crypto_shash_digestsize(hash_tfm));
 	if (IS_ERR(essiv_tfm)) {
 		crypt_iv_essiv_dtr(cc);
 		return PTR_ERR(essiv_tfm);
@@ -465,7 +462,7 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 
 bad:
 	if (hash_tfm && !IS_ERR(hash_tfm))
-		crypto_free_ahash(hash_tfm);
+		crypto_free_shash(hash_tfm);
 	kfree(salt);
 	return err;
 }
-- 
2.17.1
