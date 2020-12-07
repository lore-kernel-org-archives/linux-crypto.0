Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0987C4361B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 862722333D
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgLGJBg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgLGJBg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:01:36 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154CBC0613D4
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:00:59 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w6so9178626pfu.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e0dUI8AGxbvnrFrBTmynHGYVP/vznJDLgVM97US7ciY=;
        b=UaiBWUBY/ZKe2kG0aaX1w/9KtIW5UarBuPjFPTkqSlZBc+xjUBnrR0jZUm03twXCuR
         7lTBxFz6jfW8q3xV4aMYPQGXy3YBSuQayYk12cjmHClk7cUXa0Ze0BnXHZ+sZBcioxaE
         LeKCxd0gsLOiXxLzMwAUx1mLP4iDWiatqCz72K+sF+fZE8UCLkEfLDjPviNJl0ju41/g
         nXJGDuJ6kqJuWsXBnq7HJEiVWDP3tuLGC6iSf9qviMkqjmqxUuj1JkUFs4T6I/hrNCAY
         65QoHTihCdVh+SRqc7nK8dN4s0wC3zoV3A4p3bVWup2Zh5aheH1ti8nH3metKhGcTAo/
         g5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e0dUI8AGxbvnrFrBTmynHGYVP/vznJDLgVM97US7ciY=;
        b=h0Fu+uzV4WnEMYd+1ToUuVmBTm1ZnGFn2YT76/aMAiweVIsePFTNykgv5wGItabal3
         Vus8bE3FCDdKiqxS7SSWcpiTtLxCJbrFSZ6mBNPrCf98cnPHC9SQ4JIlIJQghkogK7i2
         wz85wAGFF0jhhyzGTSMr/MlUXesJX3WqSB2b15MOuPSTuKgpfKFFYkiu9/eykH7RWjme
         /LnpRCW0s7d7EFxbdGH7vBPGHhumcv0PwPJXAAcd///tmY472U2WSecLFQASpjYPQIik
         hNBWWmHXz/u90GVmz/zC/+Fdvi0C80V4etHtjTz7sWPhOjSSvSNgZh35d5ZO/k26BQhM
         1iew==
X-Gm-Message-State: AOAM533ILTjiAw/5jbFWLXuUp/c2jeakytCIekK+C9RBZnfNzpRR+uYI
        Cf9k3ETPiwKzXgIPKxHNZ1s=
X-Google-Smtp-Source: ABdhPJwbBuTlrrbNOGzkydTVU9NzPOqM9J9hDvoDKxyLGK1h05gx6ZJbWzyzX71ySiIVcNuyXzEfFQ==
X-Received: by 2002:aa7:828c:0:b029:19e:3acf:98a with SMTP id s12-20020aa7828c0000b029019e3acf098amr265902pfm.54.1607331658698;
        Mon, 07 Dec 2020 01:00:58 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:00:58 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, matthias.bgg@gmail.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND 11/19] crypto: mediatek: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:23 +0530
Message-Id: <20201207085931.661267-12-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207085931.661267-1-allen.lkml@gmail.com>
References: <20201207085931.661267-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@microsoft.com>
---
 drivers/crypto/mediatek/mtk-aes.c | 14 ++++++--------
 drivers/crypto/mediatek/mtk-sha.c | 14 ++++++--------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 7323066724c3..fa49bb5b043b 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -1080,16 +1080,16 @@ static struct aead_alg aes_gcm_alg = {
 	},
 };
 
-static void mtk_aes_queue_task(unsigned long data)
+static void mtk_aes_queue_task(struct tasklet_struct *t)
 {
-	struct mtk_aes_rec *aes = (struct mtk_aes_rec *)data;
+	struct mtk_aes_rec *aes = from_tasklet(aes, t, queue_task);
 
 	mtk_aes_handle_queue(aes->cryp, aes->id, NULL);
 }
 
-static void mtk_aes_done_task(unsigned long data)
+static void mtk_aes_done_task(struct tasklet_struct *t)
 {
-	struct mtk_aes_rec *aes = (struct mtk_aes_rec *)data;
+	struct mtk_aes_rec *aes = from_tasklet(aes, t, done_task);
 	struct mtk_cryp *cryp = aes->cryp;
 
 	mtk_aes_unmap(cryp, aes);
@@ -1142,10 +1142,8 @@ static int mtk_aes_record_init(struct mtk_cryp *cryp)
 		spin_lock_init(&aes[i]->lock);
 		crypto_init_queue(&aes[i]->queue, AES_QUEUE_SIZE);
 
-		tasklet_init(&aes[i]->queue_task, mtk_aes_queue_task,
-			     (unsigned long)aes[i]);
-		tasklet_init(&aes[i]->done_task, mtk_aes_done_task,
-			     (unsigned long)aes[i]);
+		tasklet_setup(&aes[i]->queue_task, mtk_aes_queue_task);
+		tasklet_setup(&aes[i]->done_task, mtk_aes_done_task);
 	}
 
 	/* Link to ring0 and ring1 respectively */
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 3d5d7d68b03b..1f55f6143fb7 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -1163,16 +1163,16 @@ static struct ahash_alg algs_sha384_sha512[] = {
 },
 };
 
-static void mtk_sha_queue_task(unsigned long data)
+static void mtk_sha_queue_task(struct tasklet_struct *t)
 {
-	struct mtk_sha_rec *sha = (struct mtk_sha_rec *)data;
+	struct mtk_sha_rec *sha = from_tasklet(sha, t, queue_task);
 
 	mtk_sha_handle_queue(sha->cryp, sha->id - MTK_RING2, NULL);
 }
 
-static void mtk_sha_done_task(unsigned long data)
+static void mtk_sha_done_task(struct tasklet_struct *t)
 {
-	struct mtk_sha_rec *sha = (struct mtk_sha_rec *)data;
+	struct mtk_sha_rec *sha = from_tasklet(sha, t, done_task);
 	struct mtk_cryp *cryp = sha->cryp;
 
 	mtk_sha_unmap(cryp, sha);
@@ -1218,10 +1218,8 @@ static int mtk_sha_record_init(struct mtk_cryp *cryp)
 		spin_lock_init(&sha[i]->lock);
 		crypto_init_queue(&sha[i]->queue, SHA_QUEUE_SIZE);
 
-		tasklet_init(&sha[i]->queue_task, mtk_sha_queue_task,
-			     (unsigned long)sha[i]);
-		tasklet_init(&sha[i]->done_task, mtk_sha_done_task,
-			     (unsigned long)sha[i]);
+		tasklet_setup(&sha[i]->queue_task, mtk_sha_queue_task);
+		tasklet_setup(&sha[i]->done_task, mtk_sha_done_task);
 	}
 
 	/* Link to ring2 and ring3 respectively */
-- 
2.25.1

