Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C819CC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8286E22EBE
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733034AbhALBtT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732934AbhALBtP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:49:15 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5103EC0617A2;
        Mon, 11 Jan 2021 17:48:35 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id cq1so445292pjb.4;
        Mon, 11 Jan 2021 17:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HNZLvmQAqbtAqMEvJP1wVGbLyEu2FmrY5NiRBOEZCk0=;
        b=M09HSCfSir62u5HnSP1MK9qS9FctY1quDgEXeJ1A71Ze53Dg116DP6MdpR1zxD11jl
         +Bw5eJOL62Jjuirn2yWCya47Zb6KUjtJk5GxF83xiDb3CC5sfgkg7oK1PlAV1SZRs7Bz
         P8FZO1zLaduEVlUgMcmJsW2UDQROJwWx/mCudXiCUdlQr0pQ4AVsKK/a8O7zRpODR8aS
         CoGH4WXD/V4ODiXwsnWpLtlgUJOfgKG83EvQXAxdPoPDDhXIgvbxNCXMfx4bZBMKvOnj
         SDJ7OSR69edLIZs1x7Bkbu+WcgLkiP6VFtrMRU3E2YIpQ1VHSjTqZ8aEMy76qzG2SwB3
         VdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HNZLvmQAqbtAqMEvJP1wVGbLyEu2FmrY5NiRBOEZCk0=;
        b=sRD2AtfziF3Q8DLDZ3ReXZMSU+q0wrM4J4YUSuvSHe0OiDL09dh3ALd0tamTD98mA0
         +Df24dY2MrGILTrVbvbGfvVOSFHvsgjc4CMFwx9GODfjDp2uQguj3VONLz0CLOxBTSQ4
         9RWWKbGkMy8m6iTDdXa/aJ+X8YB5xS18KbibYDxfHxeYKzeOoYbXVYNbqP6Pu0us1etB
         W1hkSd1/nDElIogB1eZ7ni0Z33jxWacM8rRFBeqBx605yEmiEWhl8MIx91tRu4iFxkFy
         LRNyqy6roA9rUd+q41cc6vcXzHqA+qR/ELIzypXQA8/mRVAs2DqKIiyjyzBcLmu391hh
         CHVw==
X-Gm-Message-State: AOAM531nCD9pethHBiNfDEJv16HA4r4tJ2g+ynkaAxpdjc3kiMziwpa8
        v5sxdhrijkGad+9LqMJ76wc=
X-Google-Smtp-Source: ABdhPJzQu/E/mY43VnJ/eXIQn39xOyztWpVic9U9RwF0peXg7JfTQosDtN7/RR1ZlInQT+sjJ1cYDg==
X-Received: by 2002:a17:902:8ec1:b029:dc:8ae1:7a22 with SMTP id x1-20020a1709028ec1b02900dc8ae17a22mr2678535plo.6.1610416114971;
        Mon, 11 Jan 2021 17:48:34 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:48:34 -0800 (PST)
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
Subject: [PATCH v3 09/19] crypto: img-hash: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:40 +0530
Message-Id: <20210112014650.10887-10-allen.lkml@gmail.com>
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

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/img-hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index e813115d5432..72b65cdff856 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -355,9 +355,9 @@ static int img_hash_dma_init(struct img_hash_dev *hdev)
 	return 0;
 }
 
-static void img_hash_dma_task(unsigned long d)
+static void img_hash_dma_task(struct tasklet_struct *t)
 {
-	struct img_hash_dev *hdev = (struct img_hash_dev *)d;
+	struct img_hash_dev *hdev = from_tasklet(hdev, t, dma_task);
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
 	u8 *addr;
 	size_t nbytes, bleft, wsend, len, tbc;
@@ -887,9 +887,9 @@ static int img_unregister_algs(struct img_hash_dev *hdev)
 	return 0;
 }
 
-static void img_hash_done_task(unsigned long data)
+static void img_hash_done_task(struct tasklet_struct *t)
 {
-	struct img_hash_dev *hdev = (struct img_hash_dev *)data;
+	struct img_hash_dev *hdev = from_tasklet(hdev, t, done_task);
 	int err = 0;
 
 	if (hdev->err == -EINVAL) {
@@ -954,8 +954,8 @@ static int img_hash_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&hdev->list);
 
-	tasklet_init(&hdev->done_task, img_hash_done_task, (unsigned long)hdev);
-	tasklet_init(&hdev->dma_task, img_hash_dma_task, (unsigned long)hdev);
+	tasklet_setup(&hdev->done_task, img_hash_done_task);
+	tasklet_setup(&hdev->dma_task, img_hash_dma_task);
 
 	crypto_init_queue(&hdev->queue, IMG_HASH_QUEUE_LENGTH);
 
-- 
2.25.1

