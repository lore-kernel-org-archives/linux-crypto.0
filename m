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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79222C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C13364E9E
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhBHJtq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhBHJrH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:47:07 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8657CC061221;
        Mon,  8 Feb 2021 01:44:27 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id l18so8465681pji.3;
        Mon, 08 Feb 2021 01:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HNZLvmQAqbtAqMEvJP1wVGbLyEu2FmrY5NiRBOEZCk0=;
        b=E9UVi4abvaxsbLhlHYyDlxF8WRm6Eu0gMRiLrkvvtuXqnPnqW6bL/KOZ5PtwqvI7L0
         rr/mjZFilH2Hx/ngpK5+H81e3vqpySwZoJTo+05vSEiLs6urR/Pk7xeEkQq3955cfLQy
         PDniBGHgBVTpAvBzFgL6HTS1Z1XXrDbvdPMxB1lKgQ6a6LDsJOiauZP9MYqaavtk3SfN
         n2agapT/l7OsKweIbp61n2EXJS4S7anhuLKppP7bPX4HAQ7oHxxBu04I7PZ85idFkDjW
         oNUFRt9BJ72Nx85EdziKeK/dIrL9M8B5gXEnis4KZQdrUUH5mSjubnWGQ5Ljme7a7Z/p
         JMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HNZLvmQAqbtAqMEvJP1wVGbLyEu2FmrY5NiRBOEZCk0=;
        b=K3YsjEOdRg2mIIRc8DpTKGFpv6mKJqEl0k2qmGg4zm+DWpCpcK1StaBHrO0Hk0YC6K
         XFIvRro99+cyvWbJ5tlrf52ehhLAnABIQFWlq+XA6RvVXhDIL2fFWhmyKCBaAxEByKz0
         BYn62hqkVZ5ne+lp+7is+4jFJvUUHzfEyAM1B0Xonzt+10iIp/f+BitOiVLd3mEGoKyw
         u179OKIjXAqQfmvppM7sr8BKpYNFhEjmauqj6Shapl9KeOvQqOic6R2NQ3fll5LMXQaz
         iRk3uenyxrN6DexZSj0V/KDN1pY64mQquC3xI7Gx706qLJx9oRGEB5AzesY8bf5dUpg/
         svQw==
X-Gm-Message-State: AOAM533OvInGEF5z2S1VHXtmnPQbhs6cLpGwUSWcs/Jw/PStUsGebT3V
        0qQd2A8vs+vb8+DpEO9bgY0=
X-Google-Smtp-Source: ABdhPJwlG5OBJ0kvO2nRWf/monva/qL5NPmob87P7q3hiCtrCSN8PWpMlZ3xPHLxm8XYV9X9uwnvWA==
X-Received: by 2002:a17:902:ed95:b029:e2:d080:7e0e with SMTP id e21-20020a170902ed95b02900e2d0807e0emr6794449plj.85.1612777467166;
        Mon, 08 Feb 2021 01:44:27 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:44:26 -0800 (PST)
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
Subject: [PATCH v5 09/19] crypto: img-hash: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:28 +0530
Message-Id: <20210208094238.571015-10-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208094238.571015-1-allen.lkml@gmail.com>
References: <20210208094238.571015-1-allen.lkml@gmail.com>
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

