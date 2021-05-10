Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEDBC433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 21:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8557D61554
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 21:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhEJVij (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 17:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbhEJVii (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 17:38:38 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BC2C061574
        for <linux-crypto@vger.kernel.org>; Mon, 10 May 2021 14:37:33 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id y9so22615056ljn.6
        for <linux-crypto@vger.kernel.org>; Mon, 10 May 2021 14:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Vig3/UDb6d/s3uE2zPkqOtgiQdK59B99+ZtUFYrpu4=;
        b=o8XPJWal9K1NyQu6/2oTMjhfSKc1Jei07YTnAWhXpAKrx6S+H3ukz20D673uyk9qGG
         q4AbdvtTojROoi/qnyUP/bccINyqUw5lKVAGMLQMD54THfy3dBFMHg0whg0zad4ej0Wz
         aQ4H9sdQgCZv+eJ5fvLg6VYUZpf6EeMdP4v7oo6/GEzZSO6AVo1l7Pk25we5nb0D984q
         Iqd1DsZ7Cne2F2L1FtQ8VuVjSIMMJGiU6o0M4xBX/7WiGbNFMbddl8nYMqyVFZKz0w1O
         DthWBPSgQwO03uYrcbRBZQ++c086n+p+tGkniRrC9LxIt2c4Yrgq0IP3GC2PRnYdedLL
         C/wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Vig3/UDb6d/s3uE2zPkqOtgiQdK59B99+ZtUFYrpu4=;
        b=mNneHD2iPKDaby64QrKSAoVoxqpsayJvIYdLxRVpSQD2bcnXoChy8jEBD0GyALu027
         ScQVbtMaaoTrvnT4DJD1Cbw3YMQ9RacXCZhKe6E54oAuRn3FpXD604Z7yV750q8cNGKm
         9Rmjfap5ak4OWfYIqRYwlhQcD0cUEjhDyZ7Y1AYEPp9q+1dOxEQLspENxt6mnHmeL/S1
         lcPzGush8XX1Nn6YAzW75qlbBich4QYrnH8/B8A5DBMIoSZP58SMsFdYRg+dOgYjH6Ym
         7dsWNks8AtK880fjMOHNwjX9HUhDKnz/HjH9omwKs3TFlfgyVaITriYngb8ZOomKsxc3
         tv3Q==
X-Gm-Message-State: AOAM532jUGiZF68v80IvFkWEQbzfUb4IH+Vv9ZY1BbtBEZizXNlvzQvS
        xAtI9hbpmf5qT0C1K6l0v8XRaODgKibMgw==
X-Google-Smtp-Source: ABdhPJxhXyzaeEUGUUCEZTyDSWRuCrRHPkrd3nbY9BAIcAaqIZ+rdSn5XTEZcg9IGeRMACNi2lKd8g==
X-Received: by 2002:a2e:8557:: with SMTP id u23mr21584878ljj.221.1620682651582;
        Mon, 10 May 2021 14:37:31 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id q19sm1091660lff.16.2021.05.10.14.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 14:37:31 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3] crypto: ixp4xx: Add device tree support
Date:   Mon, 10 May 2021 23:36:34 +0200
Message-Id: <20210510213634.600866-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510213634.600866-1-linus.walleij@linaro.org>
References: <20210510213634.600866-1-linus.walleij@linaro.org>
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

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Herbert, David: I am looking for an ACK to take this
into the ARM SoC tree as follow-on to the refactoring into
a platform device.
---
 drivers/crypto/ixp4xx_crypto.c  | 105 ++++++++++++++++++++++++--------
 drivers/soc/ixp4xx/ixp4xx-npe.c |   8 +++
 2 files changed, 86 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 879b93927e2a..49d3454280b6 100644
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
@@ -216,6 +213,8 @@ static const struct ix_hash_algo hash_alg_sha1 = {
 };
 
 static struct npe *npe_c;
+static unsigned int send_qid;
+static unsigned int recv_qid;
 static struct dma_pool *buffer_pool = NULL;
 static struct dma_pool *ctx_pool = NULL;
 
@@ -417,7 +416,7 @@ static void crypto_done_action(unsigned long arg)
 	int i;
 
 	for(i=0; i<4; i++) {
-		dma_addr_t phys = qmgr_get_entry(RECV_QID);
+		dma_addr_t phys = qmgr_get_entry(recv_qid);
 		if (!phys)
 			return;
 		one_packet(phys);
@@ -427,10 +426,52 @@ static void crypto_done_action(unsigned long arg)
 
 static int init_ixp_crypto(struct device *dev)
 {
-	int ret = -ENODEV;
+	struct device_node *np = dev->of_node;
 	u32 msg[2] = { 0, 0 };
+	int ret = -ENODEV;
+	unsigned int npe_id;
+
+	dev_info(dev, "probing...\n");
+
+	/* Locate the NPE and queue manager to use from the phandle in the device tree */
+	if (IS_ENABLED(CONFIG_OF) && np) {
+		struct of_phandle_args queue_spec;
+		struct of_phandle_args npe_spec;
+
+		ret = of_parse_phandle_with_fixed_args(np, "intel,npe-handle", 1, 0,
+						       &npe_spec);
+		if (ret) {
+			dev_err(dev, "no NPE engine specified\n");
+			return -ENODEV;
+		}
+		npe_id = npe_spec.args[0];
+
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
 
-	npe_c = npe_request(NPE_ID);
+	npe_c = npe_request(npe_id);
 	if (!npe_c)
 		return ret;
 
@@ -479,20 +520,20 @@ static int init_ixp_crypto(struct device *dev)
 	if (!ctx_pool) {
 		goto err;
 	}
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
@@ -508,11 +549,11 @@ static int init_ixp_crypto(struct device *dev)
 
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
@@ -645,8 +686,8 @@ static int register_chain_var(struct crypto_tfm *tfm, u8 xpad, u32 target,
 	buf->phys_addr = pad_phys;
 
 	atomic_inc(&ctx->configuring);
-	qmgr_put_entry(SEND_QID, crypt_virt2phys(crypt));
-	BUG_ON(qmgr_stat_overflow(SEND_QID));
+	qmgr_put_entry(send_qid, crypt_virt2phys(crypt));
+	BUG_ON(qmgr_stat_overflow(send_qid));
 	return 0;
 }
 
@@ -720,8 +761,8 @@ static int gen_rev_aes_key(struct crypto_tfm *tfm)
 	crypt->ctl_flags |= CTL_FLAG_GEN_REVAES;
 
 	atomic_inc(&ctx->configuring);
-	qmgr_put_entry(SEND_QID, crypt_virt2phys(crypt));
-	BUG_ON(qmgr_stat_overflow(SEND_QID));
+	qmgr_put_entry(send_qid, crypt_virt2phys(crypt));
+	BUG_ON(qmgr_stat_overflow(send_qid));
 	return 0;
 }
 
@@ -872,7 +913,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
 				GFP_KERNEL : GFP_ATOMIC;
 
-	if (qmgr_stat_full(SEND_QID))
+	if (qmgr_stat_full(send_qid))
 		return -EAGAIN;
 	if (atomic_read(&ctx->configuring))
 		return -EAGAIN;
@@ -916,8 +957,8 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 	req_ctx->src = src_hook.next;
 	crypt->src_buf = src_hook.phys_next;
 	crypt->ctl_flags |= CTL_FLAG_PERFORM_ABLK;
-	qmgr_put_entry(SEND_QID, crypt_virt2phys(crypt));
-	BUG_ON(qmgr_stat_overflow(SEND_QID));
+	qmgr_put_entry(send_qid, crypt_virt2phys(crypt));
+	BUG_ON(qmgr_stat_overflow(send_qid));
 	return -EINPROGRESS;
 
 free_buf_src:
@@ -980,7 +1021,7 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	enum dma_data_direction src_direction = DMA_BIDIRECTIONAL;
 	unsigned int lastlen;
 
-	if (qmgr_stat_full(SEND_QID))
+	if (qmgr_stat_full(send_qid))
 		return -EAGAIN;
 	if (atomic_read(&ctx->configuring))
 		return -EAGAIN;
@@ -1064,8 +1105,8 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	}
 
 	crypt->ctl_flags |= CTL_FLAG_PERFORM_AEAD;
-	qmgr_put_entry(SEND_QID, crypt_virt2phys(crypt));
-	BUG_ON(qmgr_stat_overflow(SEND_QID));
+	qmgr_put_entry(send_qid, crypt_virt2phys(crypt));
+	BUG_ON(qmgr_stat_overflow(send_qid));
 	return -EINPROGRESS;
 
 free_buf_dst:
@@ -1359,12 +1400,13 @@ static struct ixp_aead_alg ixp4xx_aeads[] = {
 
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
 
@@ -1458,11 +1500,20 @@ static int ixp_crypto_remove(struct platform_device *pdev)
 
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
index ec90b44fa0cd..e9e56f926e2d 100644
--- a/drivers/soc/ixp4xx/ixp4xx-npe.c
+++ b/drivers/soc/ixp4xx/ixp4xx-npe.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/soc/ixp4xx/npe.h>
 
@@ -679,7 +680,9 @@ static int ixp4xx_npe_probe(struct platform_device *pdev)
 {
 	int i, found = 0;
 	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
 	struct resource *res;
+	int ret;
 
 	for (i = 0; i < NPE_COUNT; i++) {
 		struct npe *npe = &npe_tab[i];
@@ -711,6 +714,11 @@ static int ixp4xx_npe_probe(struct platform_device *pdev)
 
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
2.30.2

