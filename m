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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80FAC433E6
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A938822E02
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbhALBtf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbhALBte (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:49:34 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88704C061786;
        Mon, 11 Jan 2021 17:48:54 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id my11so54432pjb.1;
        Mon, 11 Jan 2021 17:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gZKtlD6nuAorTKG2PqNJjMaym8CBQGfY80Jr0aK5tbM=;
        b=uzr/zKLeYZMdidkOpSJZb7/8jxDkz6BkwW+cadJzPmNoTkXAoVOC5WyrT6TCtQEsYK
         KiyxanAnVpYPpn65uLMiWZRCKPOLR301NedOSCSUD3TVAafnqVDs2aTORv9ShQfUbVoK
         2vl2nt1XzMuIY8cA0r2SF+i1JRKGuv02oEMdd93KgUrSgvNv+hlE9szZHUcyG671qvYw
         xbB29kWdaWgha21K19/3C+gxs8D/jj3QwrYMCUzuVxf42m/57hZG2lPvL2lDTHhvx0UH
         yuRSVpDUWv1eoNvIbQTkfIplVOK1+xQDNNUm07YbZtCsHYZqTbuSPghXbPQ8QXu8cpsm
         u45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gZKtlD6nuAorTKG2PqNJjMaym8CBQGfY80Jr0aK5tbM=;
        b=B7tDec825Wf3p5PoyWdU78l+nUiB6wLZ9fau9YReZPITjayOfFqX5lrqGYxGwcRYjg
         gWHxOynuQsslqA3GPw0BkEHxMnrlutPOWsc7x+uwmxHKmYahHwJq7H6E8xBZ1BQbPfcd
         uX4CIgbIoHjVcemezz8jEismKBQdxvcsQZrakGhjwGhEkKQ5rwN1CAnUW9uCahzUwrZA
         7hChTmGapoIa93u82QFE45n//2NE8Tf9XcikTCLaAZdN15GTp2w9PMdEvcxq/Gmd9ODA
         tOKAEQFBMUpTTWMDEG27+//dNnWVzjkqRcgkCfZGil5LXQMwTqlL+Rie4JtidjJaf06X
         wdOw==
X-Gm-Message-State: AOAM5309wHxq7coVqEQcG2NH5kauQAHVIYEZPecen4pcMIe7WhyAgQw9
        YsCFUeC03tazNy7TvLZ+Eyk=
X-Google-Smtp-Source: ABdhPJz4VMp0PXevYFN3QBu5Hi2o0Eo0R+Bd33MpKCTeqxJe4KDLVpBYm33t0ooJjb5a0kj36pCXHw==
X-Received: by 2002:a17:90a:1050:: with SMTP id y16mr1812397pjd.181.1610416134181;
        Mon, 11 Jan 2021 17:48:54 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:48:53 -0800 (PST)
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
Subject: [PATCH v3 11/19] crypto: mediatek: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:42 +0530
Message-Id: <20210112014650.10887-12-allen.lkml@gmail.com>
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
index f55aacdafbef..c241762aa23b 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -1164,16 +1164,16 @@ static struct ahash_alg algs_sha384_sha512[] = {
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
@@ -1219,10 +1219,8 @@ static int mtk_sha_record_init(struct mtk_cryp *cryp)
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

