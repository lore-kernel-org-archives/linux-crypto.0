From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 09/14] staging: ccree: remove custom type tdes_keys_t
Date: Tue, 27 Jun 2017 10:27:21 +0300
Message-ID: <1498548449-10803-10-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replace references to type tdes_keys_t with struct tdes_keys.
_
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index b4fc9a6..eb3e8e6 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -253,11 +253,11 @@ static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
 }
 
 
-typedef struct tdes_keys {
+struct tdes_keys {
 	u8	key1[DES_KEY_SIZE];
 	u8	key2[DES_KEY_SIZE];
 	u8	key3[DES_KEY_SIZE];
-} tdes_keys_t;
+};
 
 static const u8 zero_buff[] = {	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
 				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
@@ -268,7 +268,7 @@ static const u8 zero_buff[] = {	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
 static int ssi_fips_verify_3des_keys(const u8 *key, unsigned int keylen)
 {
 #ifdef CCREE_FIPS_SUPPORT
-	tdes_keys_t *tdes_key = (tdes_keys_t *)key;
+	struct tdes_keys *tdes_key = (struct tdes_keys *)key;
 
 	/* verify key1 != key2 and key3 != key2*/
 	if (unlikely((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2, sizeof(tdes_key->key1)) == 0) ||
-- 
2.1.4
