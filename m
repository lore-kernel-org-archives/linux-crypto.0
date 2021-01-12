Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122BAC433E6
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF4CD22EBE
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbhALBua (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728824AbhALBu2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:50:28 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E2BC061795;
        Mon, 11 Jan 2021 17:49:48 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c12so402937pfo.10;
        Mon, 11 Jan 2021 17:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hdFxs07OBJ0o+UoENy6opg4NHXCcbJpiwkpmIdQiwws=;
        b=FJdiFANvMr6hPlso1S2evd+zFtXBWgkIeiOXs8YUuvIMeBb0M9j3JNjt6b/T5byEgN
         ygaJTbhQVH19uvceTlN4Yofbl3VjYiq9X6MQ3AEf+J4YQy6YRWN8xxZYc/kZ0s8LiQZ6
         UgYAhKso1lUl1n205tYzvNbDUHnoqdKFgjoSvYWVJjHZCF4UQ//9l8TzmLL5Ege34lvo
         BKXjr9JcVHQ9Z2MTw9DvFfBA2xol34OpzBZ5LuWnSjR1NSLa/AxzNTQ3oKsh+WWvv/lS
         cop6/a44/SDw06dT6B0SThOFN6JuMgeX9DpNzSjO+dB+dSqvDn6K2mIQC6EvASp3H5d5
         c9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hdFxs07OBJ0o+UoENy6opg4NHXCcbJpiwkpmIdQiwws=;
        b=dQ/X90la3pCFFr/O7bOSLnv9TtEEw9E+gbNNh6Ocnf+qvdZgP6yu89oowkJYDhm9cW
         rxWNz1CKRRetRtJQ1Xs3cj2Cm+vEZLke8XcQNDL5R3nnSAZswqZVPM7t9w9aZYTztMhM
         mY4v2FARL7gsReUfB+AnLIj2N9uJCRyBJ9UZP+PoJ6pZTul6nNiQCHBaYD1vbRsG/NWO
         kF4TmbqVsGrLgKXdPu8a51tSAxpG1os3gXmB7Vv/YzW1+E7n7xiUmEjQIEA605YyGFm4
         hh16uOZ25XWV7FlH7jQKPLHmGzJc9gUxV7ka+E00tepAFvs8MI8uVPLgkaMMskXck+sT
         iK0Q==
X-Gm-Message-State: AOAM530L9prnDnqY13ljsXxMZbQuQZvxxUtN54npMRqx0xf1ul7eXqem
        RGP/Fd9QiSPle0s0Esq+J7U=
X-Google-Smtp-Source: ABdhPJz2PBmKMYU/Dsu4VtrMyiTvF6rhR+M+Fm3V4NTKiKxfPTJd3CpJpe8t5OvauzLVcGA80CqhjQ==
X-Received: by 2002:aa7:9848:0:b029:19d:c24b:1179 with SMTP id n8-20020aa798480000b029019dc24b1179mr2450075pfq.29.1610416188197;
        Mon, 11 Jan 2021 17:49:48 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:49:47 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v3 17/19] crypto: s5p: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:48 +0530
Message-Id: <20210112014650.10887-18-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112014650.10887-1-allen.lkml@gmail.com>
References: <20210112014650.10887-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/s5p-sss.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 682c8a450a57..128512a365e1 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1445,9 +1445,9 @@ static int s5p_hash_handle_queue(struct s5p_aes_dev *dd,
  * s5p_hash_tasklet_cb() - hash tasklet
  * @data:	ptr to s5p_aes_dev
  */
-static void s5p_hash_tasklet_cb(unsigned long data)
+static void s5p_hash_tasklet_cb(struct tasklet_struct *t)
 {
-	struct s5p_aes_dev *dd = (struct s5p_aes_dev *)data;
+	struct s5p_aes_dev *dd = from_tasklet(dd, t, hash_tasklet);
 
 	if (!test_bit(HASH_FLAGS_BUSY, &dd->hash_flags)) {
 		s5p_hash_handle_queue(dd, NULL);
@@ -1975,9 +1975,9 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	s5p_aes_complete(req, err);
 }
 
-static void s5p_tasklet_cb(unsigned long data)
+static void s5p_tasklet_cb(struct tasklet_struct *t)
 {
-	struct s5p_aes_dev *dev = (struct s5p_aes_dev *)data;
+	struct s5p_aes_dev *dev = from_tasklet(dev, t, tasklet);
 	struct crypto_async_request *async_req, *backlog;
 	struct s5p_aes_reqctx *reqctx;
 	unsigned long flags;
@@ -2258,7 +2258,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pdata);
 	s5p_dev = pdata;
 
-	tasklet_init(&pdata->tasklet, s5p_tasklet_cb, (unsigned long)pdata);
+	tasklet_setup(&pdata->tasklet, s5p_tasklet_cb);
 	crypto_init_queue(&pdata->queue, CRYPTO_QUEUE_LEN);
 
 	for (i = 0; i < ARRAY_SIZE(algs); i++) {
@@ -2268,8 +2268,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->use_hash) {
-		tasklet_init(&pdata->hash_tasklet, s5p_hash_tasklet_cb,
-			     (unsigned long)pdata);
+		tasklet_setup(&pdata->hash_tasklet, s5p_hash_tasklet_cb);
 		crypto_init_queue(&pdata->hash_queue, SSS_HASH_QUEUE_LENGTH);
 
 		for (hash_i = 0; hash_i < ARRAY_SIZE(algs_sha1_md5_sha256);
-- 
2.25.1

