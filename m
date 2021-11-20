Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2007C43217
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhKTEw4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:52:56 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:26341 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbhKTEwz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:52:55 -0500
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hx1D52clkzbhvt;
        Sat, 20 Nov 2021 12:44:53 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 20 Nov 2021 12:49:50 +0800
Received: from huawei.com (10.69.192.56) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Sat, 20 Nov
 2021 12:49:50 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 4/4] crypto: hisilicon/qm - simplified the calculation of qos shaper parameters
Date:   Sat, 20 Nov 2021 12:47:39 +0800
Message-ID: <20211120044739.5667-5-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211120044739.5667-1-yekai13@huawei.com>
References: <20211120044739.5667-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some optimize for the calculation of qos shaper parameters.
and modify the comments.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 84 +++++++++++++++++++++++------------
 1 file changed, 55 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 88e638491e8f..81a94e05948e 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -501,10 +501,30 @@ static const char * const qp_s[] = {
 	"none", "init", "start", "stop", "close",
 };
 
-static const u32 typical_qos_val[QM_QOS_TYPICAL_NUM] = {100, 250, 500, 1000,
-						10000, 25000, 50000, 100000};
-static const u32 typical_qos_cbs_s[QM_QOS_TYPICAL_NUM] = {9, 10, 11, 12, 16,
-							 17, 18, 19};
+struct qm_typical_qos_table {
+	u32 start;
+	u32 end;
+	u32 val;
+};
+
+/* the qos step is 100 */
+static struct qm_typical_qos_table shaper_cir_s[] = {
+	{100, 100, 4},
+	{200, 200, 3},
+	{300, 500, 2},
+	{600, 1000, 1},
+	{1100, 100000, 0},
+};
+
+static struct qm_typical_qos_table shaper_cbs_s[] = {
+	{100, 200, 9},
+	{300, 500, 11},
+	{600, 1000, 12},
+	{1100, 10000, 16},
+	{10100, 25000, 17},
+	{25100, 50000, 18},
+	{50100, 100000, 19}
+};
 
 static bool qm_avail_state(struct hisi_qm *qm, enum qm_state new)
 {
@@ -988,12 +1008,14 @@ static void qm_init_prefetch(struct hisi_qm *qm)
 }
 
 /*
+ * acc_shaper_para_calc() Get the IR value by the qos formula, the return value
+ * is the expected qos calculated.
  * the formula:
  * IR = X Mbps if ir = 1 means IR = 100 Mbps, if ir = 10000 means = 10Gbps
  *
- *		        IR_b * (2 ^ IR_u) * 8
- * IR(Mbps) * 10 ^ -3 = -------------------------
- *		        Tick * (2 ^ IR_s)
+ *		IR_b * (2 ^ IR_u) * 8000
+ * IR(Mbps) = -------------------------
+ *		  Tick * (2 ^ IR_s)
  */
 static u32 acc_shaper_para_calc(u64 cir_b, u64 cir_u, u64 cir_s)
 {
@@ -1003,17 +1025,28 @@ static u32 acc_shaper_para_calc(u64 cir_b, u64 cir_u, u64 cir_s)
 
 static u32 acc_shaper_calc_cbs_s(u32 ir)
 {
+	int table_size = ARRAY_SIZE(shaper_cbs_s);
 	int i;
 
-	if (ir < typical_qos_val[0])
-		return QM_SHAPER_MIN_CBS_S;
+	for (i = 0; i < table_size; i++) {
+		if (ir >= shaper_cbs_s[i].start && ir <= shaper_cbs_s[i].end)
+			return shaper_cbs_s[i].val;
+	}
 
-	for (i = 1; i < QM_QOS_TYPICAL_NUM; i++) {
-		if (ir >= typical_qos_val[i - 1] && ir < typical_qos_val[i])
-			return typical_qos_cbs_s[i - 1];
+	return QM_SHAPER_MIN_CBS_S;
+}
+
+static u32 acc_shaper_calc_cir_s(u32 ir)
+{
+	int table_size = ARRAY_SIZE(shaper_cir_s);
+	int i;
+
+	for (i = 0; i < table_size; i++) {
+		if (ir >= shaper_cir_s[i].start && ir <= shaper_cir_s[i].end)
+			return shaper_cir_s[i].val;
 	}
 
-	return typical_qos_cbs_s[QM_QOS_TYPICAL_NUM - 1];
+	return 0;
 }
 
 static int qm_get_shaper_para(u32 ir, struct qm_shaper_factor *factor)
@@ -1022,25 +1055,18 @@ static int qm_get_shaper_para(u32 ir, struct qm_shaper_factor *factor)
 	u32 error_rate;
 
 	factor->cbs_s = acc_shaper_calc_cbs_s(ir);
+	cir_s = acc_shaper_calc_cir_s(ir);
 
 	for (cir_b = QM_QOS_MIN_CIR_B; cir_b <= QM_QOS_MAX_CIR_B; cir_b++) {
 		for (cir_u = 0; cir_u <= QM_QOS_MAX_CIR_U; cir_u++) {
-			for (cir_s = 0; cir_s <= QM_QOS_MAX_CIR_S; cir_s++) {
-				/** the formula is changed to:
-				 *	   IR_b * (2 ^ IR_u) * DIVISOR_CLK
-				 * IR(Mbps) = -------------------------
-				 *	       768 * (2 ^ IR_s)
-				 */
-				ir_calc = acc_shaper_para_calc(cir_b, cir_u,
-							       cir_s);
-				error_rate = QM_QOS_EXPAND_RATE * (u32)abs(ir_calc - ir) / ir;
-				if (error_rate <= QM_QOS_MIN_ERROR_RATE) {
-					factor->cir_b = cir_b;
-					factor->cir_u = cir_u;
-					factor->cir_s = cir_s;
-
-					return 0;
-				}
+			ir_calc = acc_shaper_para_calc(cir_b, cir_u, cir_s);
+
+			error_rate = QM_QOS_EXPAND_RATE * (u32)abs(ir_calc - ir) / ir;
+			if (error_rate <= QM_QOS_MIN_ERROR_RATE) {
+				factor->cir_b = cir_b;
+				factor->cir_u = cir_u;
+				factor->cir_s = cir_s;
+				return 0;
 			}
 		}
 	}
-- 
2.33.0

