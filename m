Return-Path: <SRS0=GLFy=62=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21007C54E4A
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 14:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1EF720722
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 14:13:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="mFE+2NY4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgELONV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 May 2020 10:13:21 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37438 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728283AbgELONV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 May 2020 10:13:21 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CE7CJ8017098;
        Tue, 12 May 2020 16:11:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=vusmNKIE7/y2LAj08wjyAKfANz0EujBPUQM+EpHV0Cc=;
 b=mFE+2NY4rFSRzZvF5mlssD5BVySbXlvZcy6kiq73CE3/LEGYibjcPfdKRqXJWpP8UI+I
 0bZuNPkDNiv5mbFcNAemZeimOFV1fFDJDvLmzGTORCfR1fcwwnKDS93c69TXfp19KIEM
 99yActVsn+cQz9umENPvPhK1NNdti7oD/1HQNo34lCbEHLPqfCIjNVSY+k83VRLdUbOL
 TzNzxPPXT1tVCoRx+RZhTjw/2J5bsLXLQn3uFlWkd3WO+e1pSbaw9cauehJqu+zb2ce8
 a3GZrNCqGko8iq9gm8Ue7azEmsKELqNOunVIBL+2NwHLnL5ZfkIk+d1GLhvGpzmH02JG jw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 30wkdh0hx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 May 2020 16:11:59 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 4A97F100038;
        Tue, 12 May 2020 16:11:59 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag6node1.st.com [10.75.127.16])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 3E0C52BAE54;
        Tue, 12 May 2020 16:11:59 +0200 (CEST)
Received: from localhost (10.75.127.46) by SFHDAG6NODE1.st.com (10.75.127.16)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 May 2020 16:11:58
 +0200
From:   Nicolas Toromanoff <nicolas.toromanoff@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
CC:     Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] crypto: stm32/crc: protect from concurrent accesses
Date:   Tue, 12 May 2020 16:11:13 +0200
Message-ID: <20200512141113.18972-6-nicolas.toromanoff@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512141113.18972-1-nicolas.toromanoff@st.com>
References: <20200512141113.18972-1-nicolas.toromanoff@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.46]
X-ClientProxiedBy: SFHDAG4NODE2.st.com (10.75.127.11) To SFHDAG6NODE1.st.com
 (10.75.127.16)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_04:2020-05-11,2020-05-12 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Protect STM32 CRC device from concurrent accesses.

As we create a spinlocked section that increase with buffer size,
we provide a module parameter to release the pressure by splitting
critical section in chunks.

Size of each chunk is defined in burst_size module parameter.
By default burst_size=0, i.e. don't split incoming buffer.

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@st.com>
---
 drivers/crypto/stm32/stm32-crc32.c | 47 ++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 413415c216ef..3ba41148c2a4 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -35,11 +35,16 @@
 
 #define CRC_AUTOSUSPEND_DELAY	50
 
+static unsigned int burst_size;
+module_param(burst_size, uint, 0644);
+MODULE_PARM_DESC(burst_size, "Select burst byte size (0 unlimited)");
+
 struct stm32_crc {
 	struct list_head list;
 	struct device    *dev;
 	void __iomem     *regs;
 	struct clk       *clk;
+	spinlock_t       lock;
 };
 
 struct stm32_crc_list {
@@ -109,6 +114,7 @@ static int stm32_crc_init(struct shash_desc *desc)
 	struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
 	struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
 	struct stm32_crc *crc;
+	unsigned long flags;
 
 	crc = stm32_crc_get_next_crc();
 	if (!crc)
@@ -116,6 +122,8 @@ static int stm32_crc_init(struct shash_desc *desc)
 
 	pm_runtime_get_sync(crc->dev);
 
+	spin_lock_irqsave(&crc->lock, flags);
+
 	/* Reset, set key, poly and configure in bit reverse mode */
 	writel_relaxed(bitrev32(mctx->key), crc->regs + CRC_INIT);
 	writel_relaxed(bitrev32(mctx->poly), crc->regs + CRC_POL);
@@ -125,18 +133,21 @@ static int stm32_crc_init(struct shash_desc *desc)
 	/* Store partial result */
 	ctx->partial = readl_relaxed(crc->regs + CRC_DR);
 
+	spin_unlock_irqrestore(&crc->lock, flags);
+
 	pm_runtime_mark_last_busy(crc->dev);
 	pm_runtime_put_autosuspend(crc->dev);
 
 	return 0;
 }
 
-static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
-			    unsigned int length)
+static int burst_update(struct shash_desc *desc, const u8 *d8,
+			size_t length)
 {
 	struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
 	struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
 	struct stm32_crc *crc;
+	unsigned long flags;
 
 	crc = stm32_crc_get_next_crc();
 	if (!crc)
@@ -144,6 +155,8 @@ static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
 
 	pm_runtime_get_sync(crc->dev);
 
+	spin_lock_irqsave(&crc->lock, flags);
+
 	/*
 	 * Restore previously calculated CRC for this context as init value
 	 * Restore polynomial configuration
@@ -182,12 +195,40 @@ static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
 	/* Store partial result */
 	ctx->partial = readl_relaxed(crc->regs + CRC_DR);
 
+	spin_unlock_irqrestore(&crc->lock, flags);
+
 	pm_runtime_mark_last_busy(crc->dev);
 	pm_runtime_put_autosuspend(crc->dev);
 
 	return 0;
 }
 
+static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
+			    unsigned int length)
+{
+	const unsigned int burst_sz = burst_size;
+	unsigned int rem_sz;
+	const u8 *cur;
+	size_t size;
+	int ret;
+
+	if (!burst_sz)
+		return burst_update(desc, d8, length);
+
+	/* Digest first bytes not 32bit aligned at first pass in the loop */
+	size = min(length,
+		   burst_sz + (unsigned int)d8 - ALIGN_DOWN((unsigned int)d8,
+							    sizeof(u32)));
+	for (rem_sz = length, cur = d8; rem_sz;
+	     rem_sz -= size, cur += size, size = min(rem_sz, burst_sz)) {
+		ret = burst_update(desc, cur, size);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int stm32_crc_final(struct shash_desc *desc, u8 *out)
 {
 	struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
@@ -300,6 +341,8 @@ static int stm32_crc_probe(struct platform_device *pdev)
 	pm_runtime_irq_safe(dev);
 	pm_runtime_enable(dev);
 
+	spin_lock_init(&crc->lock);
+
 	platform_set_drvdata(pdev, crc);
 
 	spin_lock(&crc_list.lock);
-- 
2.17.1

