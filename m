From: Joe Perches <joe@perches.com>
Subject: [PATCH 17/21] crypto/async_tx/raid6test.c: use pr_<level> and add pr_fmt(fmt)
Date: Sun,  4 Oct 2009 17:53:44 -0700
Message-ID: <537d5c767044ad3040eb8464a4b75536387ed159.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Maciej Sosnowski <maciej.sosnowski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1745 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758339AbZJEAz5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:57 -0400
In-Reply-To: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Converted pr( to pr_info(
Removed #define pr pr_info("raid6test: "

Signed-off-by: Joe Perches <joe@perches.com>
---
 crypto/async_tx/raid6test.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index 3ec27c7..bcf762c 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -19,12 +19,12 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/async_tx.h>
 #include <linux/random.h>
 
-#undef pr
-#define pr(fmt, args...) pr_info("raid6test: " fmt, ##args)
-
 #define NDISKS 16 /* Including P and Q */
 
 static struct page *dataptrs[NDISKS];
@@ -121,12 +121,12 @@ static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, stru
 	async_tx_issue_pending(tx);
 
 	if (wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000)) == 0)
-		pr("%s: timeout! (faila: %d failb: %d disks: %d)\n",
-		   __func__, faila, failb, disks);
+		pr_info("%s: timeout! (faila: %d failb: %d disks: %d)\n",
+			__func__, faila, failb, disks);
 
 	if (result != 0)
-		pr("%s: validation failure! faila: %d failb: %d sum_check_flags: %x\n",
-		   __func__, faila, failb, result);
+		pr_info("%s: validation failure! faila: %d failb: %d sum_check_flags: %x\n",
+			__func__, faila, failb, result);
 }
 
 static int test_disks(int i, int j, int disks)
@@ -144,9 +144,9 @@ static int test_disks(int i, int j, int disks)
 	erra = memcmp(page_address(data[i]), page_address(recovi), PAGE_SIZE);
 	errb = memcmp(page_address(data[j]), page_address(recovj), PAGE_SIZE);
 
-	pr("%s(%d, %d): faila=%3d(%c)  failb=%3d(%c)  %s\n",
-	   __func__, i, j, i, disk_type(i, disks), j, disk_type(j, disks),
-	   (!erra && !errb) ? "OK" : !erra ? "ERRB" : !errb ? "ERRA" : "ERRAB");
+	pr_info("%s(%d, %d): faila=%3d(%c)  failb=%3d(%c)  %s\n",
+		__func__, i, j, i, disk_type(i, disks), j, disk_type(j, disks),
+		(!erra && !errb) ? "OK" : !erra ? "ERRB" : !errb ? "ERRA" : "ERRAB");
 
 	dataptrs[i] = data[i];
 	dataptrs[j] = data[j];
@@ -179,11 +179,11 @@ static int test(int disks, int *tests)
 	async_tx_issue_pending(tx);
 
 	if (wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000)) == 0) {
-		pr("error: initial gen_syndrome(%d) timed out\n", disks);
+		pr_info("error: initial gen_syndrome(%d) timed out\n", disks);
 		return 1;
 	}
 
-	pr("testing the %d-disk case...\n", disks);
+	pr_info("testing the %d-disk case...\n", disks);
 	for (i = 0; i < disks-1; i++)
 		for (j = i+1; j < disks; j++) {
 			(*tests)++;
@@ -216,9 +216,9 @@ static int raid6_test(void)
 		err += test(5, &tests);
 	err += test(NDISKS, &tests);
 
-	pr("\n");
-	pr("complete (%d tests, %d failure%s)\n",
-	   tests, err, err == 1 ? "" : "s");
+	pr_info("\n");
+	pr_info("complete (%d tests, %d failure%s)\n",
+		tests, err, err == 1 ? "" : "s");
 
 	for (i = 0; i < NDISKS+3; i++)
 		put_page(data[i]);
-- 
1.6.3.1.10.g659a0.dirty

