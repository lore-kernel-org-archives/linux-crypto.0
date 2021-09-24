Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842BCC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Sep 2021 09:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64A2760FC1
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Sep 2021 09:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbhIXJaY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:30:24 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:16381 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244968AbhIXJaX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Sep 2021 05:30:23 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HG6764MdSzRPnV;
        Fri, 24 Sep 2021 17:24:34 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 17:28:47 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 24 Sep
 2021 17:28:47 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 1/6] crypto: hisilicon/sec - add ping-pong buffer for ahash
Date:   Fri, 24 Sep 2021 17:27:11 +0800
Message-ID: <20210924092716.12848-2-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924092716.12848-1-yekai13@huawei.com>
References: <20210924092716.12848-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For stream mode operations, we don't send data into HW everytime.
We use the pingpong buffer to hold some small packets. The length
of ping-pong buffer is PAGE_SIZE. As well as one TFM supports maximum of
128 streams.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        | 10 +++
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 85 ++++++++++++++++++++++
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  2 +
 3 files changed, 97 insertions(+)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index d97cf02b1df7..281f38de64e9 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -154,6 +154,16 @@ struct sec_ctx {
 	struct sec_cipher_ctx c_ctx;
 	struct sec_auth_ctx a_ctx;
 	u8 type_supported;
+
+	/*
+	 * For stream mode operations, we don't send data into HW everytime.
+	 * now ahash uses this. To avoid multiple copy, use pingpong buffers.
+	 */
+	struct scatterlist pingpong_sg[SEC_MAX_STREAMS][PINGPONG_BUF_NUM];
+	u8 pingpong_idx[SEC_MAX_STREAMS];
+	u32 pp_data_len[SEC_MAX_STREAMS][PINGPONG_BUF_NUM];
+	struct idr stream_idr;
+	struct mutex stream_idr_lock;
 	struct device *dev;
 };
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 6a45bd23b363..afbe36549e83 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -77,6 +77,8 @@
 #define SEC_TOTAL_PBUF_SZ	(PAGE_SIZE * SEC_PBUF_PAGE_NUM +	\
 			SEC_PBUF_LEFT_SZ)
 
+#define SEC_SID_BUF_LEN		(PAGE_SIZE)
+#define SEC_MAX_AD_SG_NENT	8
 #define SEC_SQE_LEN_RATE	4
 #define SEC_SQE_CFLAG		2
 #define SEC_SQE_AEAD_FLAG	3
@@ -158,6 +160,89 @@ static void sec_free_req_id(struct sec_req *req)
 	mutex_unlock(&qp_ctx->req_lock);
 }
 
+static int sec_alloc_stream_id(struct sec_ctx *ctx)
+{
+	int s_id;
+
+	mutex_lock(&ctx->stream_idr_lock);
+
+	s_id = idr_alloc_cyclic(&ctx->stream_idr, NULL,
+				0, SEC_MAX_STREAMS, GFP_ATOMIC);
+
+	mutex_unlock(&ctx->stream_idr_lock);
+	if (unlikely(s_id < 0))
+		dev_err(ctx->dev, "alloc stream id fail!\n");
+
+	return s_id;
+}
+
+static void sec_free_stream_id(struct sec_ctx *ctx, int stream_id)
+{
+	if (unlikely(stream_id < 0 || stream_id >= SEC_MAX_STREAMS)) {
+		dev_err(ctx->dev, "free stream id invalid!\n");
+		return;
+	}
+
+	mutex_lock(&ctx->stream_idr_lock);
+	idr_remove(&ctx->stream_idr, stream_id);
+	mutex_unlock(&ctx->stream_idr_lock);
+}
+
+/* For stream mode, we pre-create buffer to hold some small packets */
+static int sec_stream_mode_init(struct sec_ctx *ctx)
+{
+	u32 buf_len = SEC_MAX_STREAMS * SEC_SID_BUF_LEN * PINGPONG_BUF_NUM;
+	u32 buf_step = SEC_SID_BUF_LEN * PINGPONG_BUF_NUM;
+	struct device *dev = ctx->dev;
+	unsigned int order, i, j;
+	unsigned long buf;
+	void *temp_buf;
+
+	mutex_init(&ctx->stream_idr_lock);
+	idr_init(&ctx->stream_idr);
+
+	order = get_order(buf_len);
+	if (order > MAX_ORDER) {
+		dev_err(dev, "too large order %u for pingpong buf!\n", order);
+		return -ENOMEM;
+	}
+
+	buf = __get_free_pages(GFP_KERNEL, order);
+	if (!buf) {
+		dev_err(dev, "fail to get pingpong pages!\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * stream 0: | ping buf | pong buf
+	 * stream 1: | ping buf | pong buf
+	 * stream xx: | ping buf | pong buf
+	 * scatterlist ping-pong buffer initiation
+	 */
+	for (j = 0; j < SEC_MAX_STREAMS; j++) {
+		for (i = 0; i < PINGPONG_BUF_NUM; i++) {
+			temp_buf = (void *)(uintptr_t)buf + SEC_SID_BUF_LEN * i;
+
+			sg_init_one(&ctx->pingpong_sg[j][i], temp_buf, SEC_SID_BUF_LEN);
+		}
+		buf = buf + buf_step;
+	}
+
+	return 0;
+}
+
+static void sec_stream_mode_uninit(struct sec_ctx *ctx)
+{
+	struct scatterlist *sgl = &ctx->pingpong_sg[0][0];
+	unsigned int order;
+
+	order = get_order(SEC_SID_BUF_LEN * SEC_MAX_STREAMS * PINGPONG_BUF_NUM);
+
+	free_pages((unsigned long)(uintptr_t)sg_virt(sgl), order);
+
+	idr_destroy(&ctx->stream_idr);
+}
+
 static u8 pre_parse_finished_bd(struct bd_status *status, void *resp)
 {
 	struct sec_sqe *bd = resp;
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index 9f71c358a6d3..6efe473660eb 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -8,6 +8,8 @@
 #define SEC_IV_SIZE		24
 #define SEC_MAX_KEY_SIZE	64
 #define SEC_COMM_SCENE		0
+#define SEC_MAX_STREAMS		128
+#define PINGPONG_BUF_NUM	2
 #define SEC_MIN_BLOCK_SZ	1
 
 enum sec_calg {
-- 
2.33.0

