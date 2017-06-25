From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 2/6] staging: ccree: register setkey for none hash macs
Date: Sun, 25 Jun 2017 10:47:20 +0300
Message-ID: <1498376846-24136-3-git-send-email-gilad@benyossef.com>
References: <1498376846-24136-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1498376846-24136-1-git-send-email-gilad@benyossef.com>
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

The original ccree driver was registering a useless setkey
method even for non-MAC hash transformations. Somewhere
around v4.9 a check was added that failed hash operations
if a setkey method was registered but was not called,
so during the initial upstream port code was added to
only register the setkey method for MAC type hash transform.

Unfortunately, the ccree driver also registers non-hash based
MAC transforms and the code had a logic error that stopped
it registering a setkey callback even for those, thus rendering
them useless.

This commit fixes the logic mistake, thus correctly registering
a setkey method only for MAC transformations, leaving it out
for non-MAC ones, whether they are hash based on not.

Fixes: 50cfbbb7e627 ("staging: ccree: add ahash support").

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 83 ++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index ffe8e1a..bfe2bec 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1877,8 +1877,8 @@ static int ssi_ahash_setkey(struct crypto_ahash *ahash,
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
@@ -1897,8 +1897,8 @@ static struct ssi_hash_template driver_hash[] = {
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
@@ -1922,8 +1922,8 @@ static struct ssi_hash_template driver_hash[] = {
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
@@ -1946,8 +1946,8 @@ static struct ssi_hash_template driver_hash[] = {
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
@@ -1971,8 +1971,8 @@ static struct ssi_hash_template driver_hash[] = {
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
@@ -1995,8 +1995,8 @@ static struct ssi_hash_template driver_hash[] = {
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
@@ -2020,8 +2020,8 @@ static struct ssi_hash_template driver_hash[] = {
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
@@ -2042,8 +2042,8 @@ static struct ssi_hash_template driver_hash[] = {
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
@@ -2065,8 +2065,8 @@ static struct ssi_hash_template driver_hash[] = {
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
@@ -2109,9 +2109,9 @@ ssi_hash_create_alg(struct ssi_hash_template *template, bool keyed)
 
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
@@ -2300,32 +2300,33 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
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
