Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52509C4707F
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 08:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E7FD613AD
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 08:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhEYIya (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 04:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhEYIy3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 04:54:29 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD89C06138A
        for <linux-crypto@vger.kernel.org>; Tue, 25 May 2021 01:53:00 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id q3so14734454lfu.2
        for <linux-crypto@vger.kernel.org>; Tue, 25 May 2021 01:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lE/53svVZ/4NIbcXCQWhqxSYK4Lhm/Ppa/ygMHf6zWA=;
        b=hIpCYIQTApRRjc31g5ioWBFI9nySZL01C5MtWw+/o+bJBwNAxhfuctLhFlg4Sj47Wb
         /dx4aP7J6078ubUeEvLVv3LpwVkk4fO7qyqBiVOghndC8Agi5V+8IJI/9R5+eLIDbZUs
         0pGLBdf95Rzhl6Fa2F0FJ5dxNyOBhB22+VsM1wXtkzkzhATbtLxvIwUFcfU196P5NK1z
         Scke3BDR3zEziN4FmH8dOVqxEur85vBKjFGkG4+0TYpYzhgBGf3x9UFLIG4NkwQyYOns
         M2h8I+uSnZoXSWV+cTRjtGwEYib1CPuYyvB0L5KOdgg2Du6yNh53k3gmjxN2RuFmDxdu
         +58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lE/53svVZ/4NIbcXCQWhqxSYK4Lhm/Ppa/ygMHf6zWA=;
        b=eHYxb0VpG4AQE0azaeBbAgLNr2PVPWm8P+sh2Jukb5JBhc80PlWLAyMah4Ek8NMt2M
         t7j6/rrtMHWV1h2Xr4CYUeTNTiPagzB85ggXgqZrJshMG7qVbKOZyVM/+vp/xWToUm1i
         V/EVkghVM/DeDosIHm4iUvqfJo2IQTL2UXI5/9RCXUnQzQecEjXwZl7TG6B+drzsbKBo
         Vch4TJ++tHJ7QSLX7X/FxYg+QHDUy+IQYYGlt9VZvGorYHZk3mFOFRwRn5Z7A8iR17OH
         y2NVO9ap1ZteCqn+Mpx0MVFxyCZ8ibN38HaidU1Va8qf//P+9c719hfe392QyFYrX4n/
         z4zw==
X-Gm-Message-State: AOAM532/6IyrEgs+XtQnu9JqgSt+Ry+/XorSV5xf9EFVC3pa9j6BJaPM
        bK1jNeYXAYZjgP72k0tKjvHxp1ZKaQTA2A==
X-Google-Smtp-Source: ABdhPJzWXgM34v1xqWgN/DWmYCOw5wzxznQLT29N0+Q73ucJVbPECdvuhbBD/I4r3RKVpOXTuDylJw==
X-Received: by 2002:a05:6512:b17:: with SMTP id w23mr13056405lfu.133.1621932778373;
        Tue, 25 May 2021 01:52:58 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id p9sm1671075lfu.185.2021.05.25.01.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 01:52:57 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3 v4] crypto: ixp4xx: Add device tree support
Date:   Tue, 25 May 2021 10:50:56 +0200
Message-Id: <20210525085056.1114749-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This makes the IXP4xx driver probe from the device tree
and retrieve the NPE and two queue manager handled used
to process crypto from the device tree.

As the crypto engine is topologically a part of the NPE
hardware, we augment the NPE driver to spawn the
crypto engine as a child.

The platform data probe path is going away in due time,
for now it is an isolated else clause.

Cc: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- Revert back to the pattern in v1 to read the NPE phandle and
  the instance number as a cell in consequence with the
  reverted binding.
ChangeLog v2->v3:
- Get NPE instance number from the reg property.
ChangeLog v1->v2:
- Rebase on Corentin's patches in the cryptodev tree
- Drop unused ret variable (leftover from development)
- DTS patch can be found at:
  https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-nomadik.git/log/?h=ixp4xx-crypto-v5.13-rc1
---
 drivers/crypto/ixp4xx_crypto.c  | 107 +++++++++++++++++++++++---------
 drivers/soc/ixp4xx/ixp4xx-npe.c |   7 +++
 2 files changed, 86 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 76099d6cfff9..35fc5ee70491 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <linux/gfp.h>
 #include <linux/module.h>
+#include <linux/of.h>
 
 #include <crypto/ctr.h>
 #include <crypto/internal/des.h>
@@ -71,15 +72,11 @@
 #define MOD_AES256  (0x0a00 | KEYLEN_256)
 
 #define MAX_IVLEN   16
-#define NPE_ID      2  /* NPE C */
 #define NPE_QLEN    16
 /* Space for registering when the first
  * NPE_QLEN crypt_ctl are busy */
 #define NPE_QLEN_TOTAL 64
 
-#define SEND_QID    29
-#define RECV_QID    30
-
 #define CTL_FLAG_UNUSED		0x0000
 #define CTL_FLAG_USED		0x1000
 #define CTL_FLAG_PERFORM_ABLK	0x0001
@@ -221,6 +218,9 @@ static const struct ix_hash_algo hash_alg_sha1 = {
 };
 
 static struct npe *npe_c;
+
+static unsigned int send_qid;
+static unsigned int recv_qid;
 static struct dma_pool *buffer_pool;
 static struct dma_pool *ctx_pool;
 
@@ -437,8 +437,7 @@ static void crypto_done_action(unsigned long arg)
 	int i;
 
 	for (i = 0; i < 4; i++) {
-		dma_addr_t phys = qmgr_get_entry(RECV_QID);
-
+		dma_addr_t phys = qmgr_get_entry(recv_qid);
 		if (!phys)
 			return;
 		one_packet(phys);
@@ -448,10 +447,52 @@ static void crypto_done_action(unsigned long arg)
 
 static int init_ixp_crypto(struct device *dev)
 {
-	int ret = -ENODEV;
+	struct device_node *np = dev->of_node;
 	u32 msg[2] = { 0, 0 };
+	int ret = -ENODEV;
+	u32 npe_id;
+
+	dev_info(dev, "probing...\n");
+
+	/* Locate the NPE and queue manager to use from device tree */
+	if (IS_ENABLED(CONFIG_OF) && np) {
+		struct of_phandle_args queue_spec;
+		struct of_phandle_args npe_spec;
+
+		ret = of_parse_phandle_with_fixed_args(np, "intel,npe-handle",
+						       1, 0, &npe_spec);
+		if (ret) {
+			dev_err(dev, "no NPE engine specified\n");
+			return -ENODEV;
+		}
+		npe_id = npe_spec.args[0];
 
-	npe_c = npe_request(NPE_ID);
+		ret = of_parse_phandle_with_fixed_args(np, "queue-rx", 1, 0,
+						       &queue_spec);
+		if (ret) {
+			dev_err(dev, "no rx queue phandle\n");
+			return -ENODEV;
+		}
+		recv_qid = queue_spec.args[0];
+
+		ret = of_parse_phandle_with_fixed_args(np, "queue-txready", 1, 0,
+						       &queue_spec);
+		if (ret) {
+			dev_err(dev, "no txready queue phandle\n");
+			return -ENODEV;
+		}
+		send_qid = queue_spec.args[0];
+	} else {
+		/*
+		 * Hardcoded engine when using platform data, this goes away
+		 * when we switch to using DT only.
+		 */
+		npe_id = 2;
+		send_qid = 29;
+		recv_qid = 30;
+	}
+
+	npe_c = npe_request(npe_id);
 	if (!npe_c)
 		return ret;
 
@@ -497,20 +538,20 @@ static int init_ixp_crypto(struct device *dev)
 	if (!ctx_pool)
 		goto err;
 
-	ret = qmgr_request_queue(SEND_QID, NPE_QLEN_TOTAL, 0, 0,
+	ret = qmgr_request_queue(send_qid, NPE_QLEN_TOTAL, 0, 0,
 				 "ixp_crypto:out", NULL);
 	if (ret)
 		goto err;
-	ret = qmgr_request_queue(RECV_QID, NPE_QLEN, 0, 0,
+	ret = qmgr_request_queue(recv_qid, NPE_QLEN, 0, 0,
 				 "ixp_crypto:in", NULL);
 	if (ret) {
-		qmgr_release_queue(SEND_QID);
+		qmgr_release_queue(send_qid);
 		goto err;
 	}
-	qmgr_set_irq(RECV_QID, QUEUE_IRQ_SRC_NOT_EMPTY, irqhandler, NULL);
+	qmgr_set_irq(recv_qid, QUEUE_IRQ_SRC_NOT_EMPTY, irqhandler, NULL);
 	tasklet_init(&crypto_done_tasklet, crypto_done_action, 0);
 
-	qmgr_enable_irq(RECV_QID);
+	qmgr_enable_irq(recv_qid);
 	return 0;
 
 npe_error:
@@ -526,11 +567,11 @@ static int init_ixp_crypto(struct device *dev)
 
 static void release_ixp_crypto(struct device *dev)
 {
-	qmgr_disable_irq(RECV_QID);
+	qmgr_disable_irq(recv_qid);
 	tasklet_kill(&crypto_done_tasklet);
 
-	qmgr_release_queue(SEND_QID);
-	qmgr_release_queue(RECV_QID);
+	qmgr_release_queue(send_qid);
+	qmgr_release_queue(recv_qid);
 
 	dma_pool_destroy(ctx_pool);
 	dma_pool_destroy(buffer_pool);
@@ -682,8 +723,8 @@ static int register_chain_var(struct crypto_tfm *tfm, u8 xpad, u32 target,
 	buf->phys_addr = pad_phys;
 
 	atomic_inc(&ctx->configuring);
-	qmgr_put_entry(SEND_QID, crypt_virt2phys(crypt));
-	BUG_ON(qmgr_stat_overflow(SEND_QID));
+	qmgr_put_entry(send_qid, crypt_virt2phys(crypt));
+	BUG_ON(qmgr_stat_overflow(send_qid));
 	return 0;
 }
 
@@ -757,8 +798,8 @@ static int gen_rev_aes_key(struct crypto_tfm *tfm)
 	crypt->ctl_flags |= CTL_FLAG_GEN_REVAES;
 
 	atomic_inc(&ctx->configuring);
-	qmgr_put_entry(SEND_QID, crypt_virt2phys(crypt));
-	BUG_ON(qmgr_stat_overflow(SEND_QID));
+	qmgr_put_entry(send_qid, crypt_virt2phys(crypt));
+	BUG_ON(qmgr_stat_overflow(send_qid));
 	return 0;
 }
 
@@ -943,7 +984,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 	if (sg_nents(req->src) > 1 || sg_nents(req->dst) > 1)
 		return ixp4xx_cipher_fallback(req, encrypt);
 
-	if (qmgr_stat_full(SEND_QID))
+	if (qmgr_stat_full(send_qid))
 		return -EAGAIN;
 	if (atomic_read(&ctx->configuring))
 		return -EAGAIN;
@@ -993,8 +1034,8 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 	req_ctx->src = src_hook.next;
 	crypt->src_buf = src_hook.phys_next;
 	crypt->ctl_flags |= CTL_FLAG_PERFORM_ABLK;
-	qmgr_put_entry(SEND_QID, crypt_virt2phys(crypt));
-	BUG_ON(qmgr_stat_overflow(SEND_QID));
+	qmgr_put_entry(send_qid, crypt_virt2phys(crypt));
+	BUG_ON(qmgr_stat_overflow(send_qid));
 	return -EINPROGRESS;
 
 free_buf_src:
@@ -1057,7 +1098,7 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	enum dma_data_direction src_direction = DMA_BIDIRECTIONAL;
 	unsigned int lastlen;
 
-	if (qmgr_stat_full(SEND_QID))
+	if (qmgr_stat_full(send_qid))
 		return -EAGAIN;
 	if (atomic_read(&ctx->configuring))
 		return -EAGAIN;
@@ -1141,8 +1182,8 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	}
 
 	crypt->ctl_flags |= CTL_FLAG_PERFORM_AEAD;
-	qmgr_put_entry(SEND_QID, crypt_virt2phys(crypt));
-	BUG_ON(qmgr_stat_overflow(SEND_QID));
+	qmgr_put_entry(send_qid, crypt_virt2phys(crypt));
+	BUG_ON(qmgr_stat_overflow(send_qid));
 	return -EINPROGRESS;
 
 free_buf_dst:
@@ -1436,12 +1477,13 @@ static struct ixp_aead_alg ixp4xx_aeads[] = {
 
 static int ixp_crypto_probe(struct platform_device *_pdev)
 {
+	struct device *dev = &_pdev->dev;
 	int num = ARRAY_SIZE(ixp4xx_algos);
 	int i, err;
 
 	pdev = _pdev;
 
-	err = init_ixp_crypto(&pdev->dev);
+	err = init_ixp_crypto(dev);
 	if (err)
 		return err;
 
@@ -1533,11 +1575,20 @@ static int ixp_crypto_remove(struct platform_device *pdev)
 
 	return 0;
 }
+static const struct of_device_id ixp4xx_crypto_of_match[] = {
+	{
+		.compatible = "intel,ixp4xx-crypto",
+	},
+	{},
+};
 
 static struct platform_driver ixp_crypto_driver = {
 	.probe = ixp_crypto_probe,
 	.remove = ixp_crypto_remove,
-	.driver = { .name = "ixp4xx_crypto" },
+	.driver = {
+		.name = "ixp4xx_crypto",
+		.of_match_table = ixp4xx_crypto_of_match,
+	},
 };
 module_platform_driver(ixp_crypto_driver);
 
diff --git a/drivers/soc/ixp4xx/ixp4xx-npe.c b/drivers/soc/ixp4xx/ixp4xx-npe.c
index ec90b44fa0cd..3c158251a58b 100644
--- a/drivers/soc/ixp4xx/ixp4xx-npe.c
+++ b/drivers/soc/ixp4xx/ixp4xx-npe.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/soc/ixp4xx/npe.h>
 
@@ -679,6 +680,7 @@ static int ixp4xx_npe_probe(struct platform_device *pdev)
 {
 	int i, found = 0;
 	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
 	struct resource *res;
 
 	for (i = 0; i < NPE_COUNT; i++) {
@@ -711,6 +713,11 @@ static int ixp4xx_npe_probe(struct platform_device *pdev)
 
 	if (!found)
 		return -ENODEV;
+
+	/* Spawn crypto subdevice if using device tree */
+	if (IS_ENABLED(CONFIG_OF) && np)
+		devm_of_platform_populate(dev);
+
 	return 0;
 }
 
-- 
2.31.1

