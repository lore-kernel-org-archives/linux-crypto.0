From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 10/24] staging: ccree: fix req mgr func def coding style
Date: Tue, 12 Dec 2017 14:52:56 +0000
Message-ID: <1513090395-7938-11-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix request manager functions definition indentation according to coding
style guide lines for better code readability

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 21 +++++++++------------
 drivers/staging/ccree/ssi_request_mgr.h |  9 ++++-----
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index dbdfd0c..91f5e2d 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -165,9 +165,8 @@ int cc_req_mgr_init(struct ssi_drvdata *drvdata)
 	return rc;
 }
 
-static void enqueue_seq(
-	void __iomem *cc_base,
-	struct cc_hw_desc seq[], unsigned int seq_len)
+static void enqueue_seq(void __iomem *cc_base, struct cc_hw_desc seq[],
+			unsigned int seq_len)
 {
 	int i, w;
 	void * __iomem reg = cc_base + CC_REG(DSCRPTR_QUEUE_WORD0);
@@ -202,10 +201,9 @@ static void request_mgr_complete(struct device *dev, void *dx_compl_h)
 	complete(this_compl);
 }
 
-static int cc_queues_status(
-		struct ssi_drvdata *drvdata,
-		struct cc_req_mgr_handle *req_mgr_h,
-		unsigned int total_seq_len)
+static int cc_queues_status(struct ssi_drvdata *drvdata,
+			    struct cc_req_mgr_handle *req_mgr_h,
+			    unsigned int total_seq_len)
 {
 	unsigned long poll_queue;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -259,9 +257,8 @@ static int cc_queues_status(
  *
  * \return int Returns -EINPROGRESS if "is_dout=true"; "0" if "is_dout=false"
  */
-int send_request(
-	struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
-	struct cc_hw_desc *desc, unsigned int len, bool is_dout)
+int send_request(struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
+		 struct cc_hw_desc *desc, unsigned int len, bool is_dout)
 {
 	void __iomem *cc_base = drvdata->cc_base;
 	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
@@ -413,8 +410,8 @@ int send_request(
  *
  * \return int Returns "0" upon success
  */
-int send_request_init(
-	struct ssi_drvdata *drvdata, struct cc_hw_desc *desc, unsigned int len)
+int send_request_init(struct ssi_drvdata *drvdata, struct cc_hw_desc *desc,
+		      unsigned int len)
 {
 	void __iomem *cc_base = drvdata->cc_base;
 	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
index d018f51..91e0d47 100644
--- a/drivers/staging/ccree/ssi_request_mgr.h
+++ b/drivers/staging/ccree/ssi_request_mgr.h
@@ -38,12 +38,11 @@ int cc_req_mgr_init(struct ssi_drvdata *drvdata);
  *
  * \return int Returns -EINPROGRESS if "is_dout=true"; "0" if "is_dout=false"
  */
-int send_request(
-	struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
-	struct cc_hw_desc *desc, unsigned int len, bool is_dout);
+int send_request(struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
+		 struct cc_hw_desc *desc, unsigned int len, bool is_dout);
 
-int send_request_init(
-	struct ssi_drvdata *drvdata, struct cc_hw_desc *desc, unsigned int len);
+int send_request_init(struct ssi_drvdata *drvdata, struct cc_hw_desc *desc,
+		      unsigned int len);
 
 void complete_request(struct ssi_drvdata *drvdata);
 
-- 
2.7.4
