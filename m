From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 2/7] staging: ccree: register setkey for none hash macs
Date: Thu, 22 Jun 2017 10:07:48 +0300
Message-ID: <1498115276-1601-3-git-send-email-gilad@benyossef.com>
References: <1498115276-1601-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1498115276-1601-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Fix a bug where the transformation init code did
not register a setkey method for none hash based MACs.

Fixes commit 50cfbbb7e627 ("staging: ccree: add ahash support").

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 83 ++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index c39e3be..f52e1af 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1874,8 +1874,8 @@ static int ssi_ahash_setkey(struct crypto_ahash *ahash,
 struct ssi_hash_template {
 	char name[CRYPTO_MAX_ALG_NAME];
 	char driver_name[CRYPTO_MAX_ALG_NAME];
-	char hmac_name[CRYPTO_MAX_ALG_NAME];
-	char hmac_driver_name[CRYPTO_MAX_ALG_NAME];
+	char mac_name[CRYPTO_MAX_ALG_NAME];
+	char mac_driver_name[CRYPTO_MAX_ALG_NAME];
 	unsigned int blocksize;
 	bool synchronize;
 	struct ahash_alg template_ahash;
@@ -1894,8 +1894,8 @@ static struct ssi_hash_template driver_hash[] = {
 	{
 		.name = "sha1",
 		.driver_name = "sha1-dx",
-		.hmac_name = "hmac(sha1)",
-		.hmac_driver_name = "hmac-sha1-dx",
+		.mac_name = "hmac(sha1)",
+		.mac_driver_name = "hmac-sha1-dx",
 		.blocksize = SHA1_BLOCK_SIZE,
 		.synchronize = false,
 		.template_ahash = {
@@ -1919,8 +1919,8 @@ static struct ssi_hash_template driver_hash[] = {
 	{
 		.name = "sha256",
 		.driver_name = "sha256-dx",
-		.hmac_name = "hmac(sha256)",
-		.hmac_driver_name = "hmac-sha256-dx",
+		.mac_name = "hmac(sha256)",
+		.mac_driver_name = "hmac-sha256-dx",
 		.blocksize = SHA256_BLOCK_SIZE,
 		.template_ahash = {
 			.init = ssi_ahash_init,
@@ -1943,8 +1943,8 @@ static struct ssi_hash_template driver_hash[] = {
 	{
 		.name = "sha224",
 		.driver_name = "sha224-dx",
-		.hmac_name = "hmac(sha224)",
-		.hmac_driver_name = "hmac-sha224-dx",
+		.mac_name = "hmac(sha224)",
+		.mac_driver_name = "hmac-sha224-dx",
 		.blocksize = SHA224_BLOCK_SIZE,
 		.template_ahash = {
 			.init = ssi_ahash_init,
@@ -1968,8 +1968,8 @@ static struct ssi_hash_template driver_hash[] = {
 	{
 		.name = "sha384",
 		.driver_name = "sha384-dx",
-		.hmac_name = "hmac(sha384)",
-		.hmac_driver_name = "hmac-sha384-dx",
+		.mac_name = "hmac(sha384)",
+		.mac_driver_name = "hmac-sha384-dx",
 		.blocksize = SHA384_BLOCK_SIZE,
 		.template_ahash = {
 			.init = ssi_ahash_init,
@@ -1992,8 +1992,8 @@ static struct ssi_hash_template driver_hash[] = {
 	{
 		.name = "sha512",
 		.driver_name = "sha512-dx",
-		.hmac_name = "hmac(sha512)",
-		.hmac_driver_name = "hmac-sha512-dx",
+		.mac_name = "hmac(sha512)",
+		.mac_driver_name = "hmac-sha512-dx",
 		.blocksize = SHA512_BLOCK_SIZE,
 		.template_ahash = {
 			.init = ssi_ahash_init,
@@ -2017,8 +2017,8 @@ static struct ssi_hash_template driver_hash[] = {
 	{
 		.name = "md5",
 		.driver_name = "md5-dx",
-		.hmac_name = "hmac(md5)",
-		.hmac_driver_name = "hmac-md5-dx",
+		.mac_name = "hmac(md5)",
+		.mac_driver_name = "hmac-md5-dx",
 		.blocksize = MD5_HMAC_BLOCK_SIZE,
 		.template_ahash = {
 			.init = ssi_ahash_init,
@@ -2039,8 +2039,8 @@ static struct ssi_hash_template driver_hash[] = {
 		.inter_digestsize = MD5_DIGEST_SIZE,
 	},
 	{
-		.name = "xcbc(aes)",
-		.driver_name = "xcbc-aes-dx",
+		.mac_name = "xcbc(aes)",
+		.mac_driver_name = "xcbc-aes-dx",
 		.blocksize = AES_BLOCK_SIZE,
 		.template_ahash = {
 			.init = ssi_ahash_init,
@@ -2062,8 +2062,8 @@ static struct ssi_hash_template driver_hash[] = {
 	},
 #if SSI_CC_HAS_CMAC
 	{
-		.name = "cmac(aes)",
-		.driver_name = "cmac-aes-dx",
+		.mac_name = "cmac(aes)",
+		.mac_driver_name = "cmac-aes-dx",
 		.blocksize = AES_BLOCK_SIZE,
 		.template_ahash = {
 			.init = ssi_ahash_init,
@@ -2106,9 +2106,9 @@ ssi_hash_create_alg(struct ssi_hash_template *template, bool keyed)
 
 	if (keyed) {
 		snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s",
-			 template->hmac_name);
+			 template->mac_name);
 		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-			 template->hmac_driver_name);
+			 template->mac_driver_name);
 	} else {
 		halg->setkey = NULL;
 		snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s",
@@ -2297,32 +2297,33 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 	/* ahash registration */
 	for (alg = 0; alg < ARRAY_SIZE(driver_hash); alg++) {
 		struct ssi_hash_alg *t_alg;
+		int hw_mode = driver_hash[alg].hw_mode;
 
 		/* register hmac version */
+		t_alg = ssi_hash_create_alg(&driver_hash[alg], true);
+		if (IS_ERR(t_alg)) {
+			rc = PTR_ERR(t_alg);
+			SSI_LOG_ERR("%s alg allocation failed\n",
+				    driver_hash[alg].driver_name);
+			goto fail;
+		}
+		t_alg->drvdata = drvdata;
 
-		if ((((struct ssi_hash_template *)&driver_hash[alg])->hw_mode != DRV_CIPHER_XCBC_MAC) &&
-		    (((struct ssi_hash_template *)&driver_hash[alg])->hw_mode != DRV_CIPHER_CMAC)) {
-			t_alg = ssi_hash_create_alg(&driver_hash[alg], true);
-			if (IS_ERR(t_alg)) {
-				rc = PTR_ERR(t_alg);
-				SSI_LOG_ERR("%s alg allocation failed\n",
-					 driver_hash[alg].driver_name);
-				goto fail;
-			}
-			t_alg->drvdata = drvdata;
-
-			rc = crypto_register_ahash(&t_alg->ahash_alg);
-			if (unlikely(rc)) {
-				SSI_LOG_ERR("%s alg registration failed\n",
-					    driver_hash[alg].driver_name);
-				kfree(t_alg);
-				goto fail;
-			} else {
-				list_add_tail(&t_alg->entry,
-					      &hash_handle->hash_list);
-			}
+		rc = crypto_register_ahash(&t_alg->ahash_alg);
+		if (unlikely(rc)) {
+			SSI_LOG_ERR("%s alg registration failed\n",
+				    driver_hash[alg].driver_name);
+			kfree(t_alg);
+			goto fail;
+		} else {
+			list_add_tail(&t_alg->entry,
+				      &hash_handle->hash_list);
 		}
 
+		if ((hw_mode == DRV_CIPHER_XCBC_MAC) ||
+		    (hw_mode == DRV_CIPHER_CMAC))
+			continue;
+
 		/* register hash version */
 		t_alg = ssi_hash_create_alg(&driver_hash[alg], false);
 		if (IS_ERR(t_alg)) {
-- 
2.1.4
