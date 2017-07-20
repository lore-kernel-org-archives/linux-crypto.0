From: sunil.m@techveda.org
Subject: [PATCH] staging: ccree: Fix unnecessary NULL check before kfree'ing it
Date: Thu, 20 Jul 2017 19:07:07 +0530
Message-ID: <1500557827-29853-1-git-send-email-sunil.m@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 Suniel Mahesh <sunil.m@techveda.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: gregkh@linuxfoundation.org,
	gilad@benyossef.com
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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

From: Suniel Mahesh <sunil.m@techveda.org>

kfree(NULL) is safe and their is no need for a NULL check. Pointed out
by checkpatch.

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
---
Note:
- Patch was compile tested and built(ARCH=arm) on next-20170719.
  No build issues reported.
---
 drivers/staging/ccree/ssi_hash.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index fba0643..b080aed 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -296,20 +296,14 @@ static int ssi_hash_map_request(struct device *dev,
 fail1:
 	 kfree(state->digest_buff);
 fail_digest_result_buff:
-	 if (state->digest_result_buff) {
-		 kfree(state->digest_result_buff);
-	     state->digest_result_buff = NULL;
-	 }
+	kfree(state->digest_result_buff);
+	state->digest_result_buff = NULL;
 fail_buff1:
-	 if (state->buff1) {
-		 kfree(state->buff1);
-	     state->buff1 = NULL;
-	 }
+	kfree(state->buff1);
+	state->buff1 = NULL;
 fail_buff0:
-	 if (state->buff0) {
-		 kfree(state->buff0);
-	     state->buff0 = NULL;
-	 }
+	kfree(state->buff0);
+	state->buff0 = NULL;
 fail0:
 	return rc;
 }
@@ -2319,11 +2313,8 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 	return 0;
 
 fail:
-
-	if (drvdata->hash_handle) {
-		kfree(drvdata->hash_handle);
-		drvdata->hash_handle = NULL;
-	}
+	kfree(drvdata->hash_handle);
+	drvdata->hash_handle = NULL;
 	return rc;
 }
 
-- 
1.9.1
