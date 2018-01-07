From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 22/27] staging: ccree: put pointer next to var name
Date: Sun,  7 Jan 2018 12:14:33 +0000
Message-ID: <1515327285-8948-23-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Put pointer next to var name as per coding style.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 78f25e5..dc3be29 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -166,7 +166,7 @@ static void enqueue_seq(struct cc_drvdata *drvdata, struct cc_hw_desc seq[],
 			unsigned int seq_len)
 {
 	int i, w;
-	void * __iomem reg = drvdata->cc_base + CC_REG(DSCRPTR_QUEUE_WORD0);
+	void __iomem *reg = drvdata->cc_base + CC_REG(DSCRPTR_QUEUE_WORD0);
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	/*
-- 
2.7.4
