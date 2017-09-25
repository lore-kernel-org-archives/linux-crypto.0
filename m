From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 5/5] crypto: bcm: pr_err() strings should end with newlines
Date: Mon, 25 Sep 2017 16:06:16 +0530
Message-ID: <1506335776-1887-6-git-send-email-arvind.yadav.cs@gmail.com>
References: <1506335776-1887-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, arei.gonglei@huawei.com, harsh@chelsio.com,
        giovanni.cabiddu@intel.com, salvatore.benedetto@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506335776-1887-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

pr_err() messages should terminated with a new-line to avoid
other messages being concatenated onto the end.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/bcm/util.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index 430c557..d543c01 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -271,7 +271,7 @@ int do_shash(unsigned char *name, unsigned char *result,
 	hash = crypto_alloc_shash(name, 0, 0);
 	if (IS_ERR(hash)) {
 		rc = PTR_ERR(hash);
-		pr_err("%s: Crypto %s allocation error %d", __func__, name, rc);
+		pr_err("%s: Crypto %s allocation error %d\n", __func__, name, rc);
 		return rc;
 	}
 
@@ -279,7 +279,7 @@ int do_shash(unsigned char *name, unsigned char *result,
 	sdesc = kmalloc(size, GFP_KERNEL);
 	if (!sdesc) {
 		rc = -ENOMEM;
-		pr_err("%s: Memory allocation failure", __func__);
+		pr_err("%s: Memory allocation failure\n", __func__);
 		goto do_shash_err;
 	}
 	sdesc->shash.tfm = hash;
@@ -288,31 +288,31 @@ int do_shash(unsigned char *name, unsigned char *result,
 	if (key_len > 0) {
 		rc = crypto_shash_setkey(hash, key, key_len);
 		if (rc) {
-			pr_err("%s: Could not setkey %s shash", __func__, name);
+			pr_err("%s: Could not setkey %s shash\n", __func__, name);
 			goto do_shash_err;
 		}
 	}
 
 	rc = crypto_shash_init(&sdesc->shash);
 	if (rc) {
-		pr_err("%s: Could not init %s shash", __func__, name);
+		pr_err("%s: Could not init %s shash\n", __func__, name);
 		goto do_shash_err;
 	}
 	rc = crypto_shash_update(&sdesc->shash, data1, data1_len);
 	if (rc) {
-		pr_err("%s: Could not update1", __func__);
+		pr_err("%s: Could not update1\n", __func__);
 		goto do_shash_err;
 	}
 	if (data2 && data2_len) {
 		rc = crypto_shash_update(&sdesc->shash, data2, data2_len);
 		if (rc) {
-			pr_err("%s: Could not update2", __func__);
+			pr_err("%s: Could not update2\n", __func__);
 			goto do_shash_err;
 		}
 	}
 	rc = crypto_shash_final(&sdesc->shash, result);
 	if (rc)
-		pr_err("%s: Could not generate %s hash", __func__, name);
+		pr_err("%s: Could not generate %s hash\n", __func__, name);
 
 do_shash_err:
 	crypto_free_shash(hash);
-- 
1.9.1
