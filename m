Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3087DC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Apr 2022 06:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350674AbiDOGrv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Apr 2022 02:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350668AbiDOGru (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Apr 2022 02:47:50 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C2F98F7D
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 23:45:23 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 22so243861pfu.1
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 23:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HIfkyA0kHsUAS/WiTZijAfUV1CeLSCyZNaoBawxM4dQ=;
        b=bRNhcDrRB4NS8pkIyJ0hmHz8NeqERb22Ss/1ljlGJ1GB7zLBKH9J4g7Q6f6Fy9tDKB
         GVozb8zX2giAR9+DvLMs7bmzTzrFTUwNoNkT+uOLZaiDlcMYge25ogOzrdkN+K3EAmP8
         sQLk25OzbV4bjfS9mTvknf0xWdLd2xCTXnQqG455z+v66utPUCXAhgywZzMjKfUesuVG
         bLYhYFJaj7IePr9CME3+lYjMKRcCFrQQvOFPvE59Pg3wuFK37O3mJzuHslF95TJKtdEe
         pyrWeNT8Nd9b77qtm/fRf6WPvlz2uhClm8PB+XiPfov6ea0fM1jcfTdpfGHs210PA1lV
         V9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HIfkyA0kHsUAS/WiTZijAfUV1CeLSCyZNaoBawxM4dQ=;
        b=XhuikYG9bEtyd8i06DQyT09ryxBCNMF1DI+rM+TJ/Xg4J/5TP5LuyTpDr+mc3wiKxW
         n3g0lw9qboVEmY79ym9Rbf5RILIeFrT56ocpj1ha+1DmM+BQ+FY/gOPq7DuRBwHDfO0U
         HhivCVXhsfvp1Tcy1uDRYB+w244w/B5x8TsYfYLQQu5RxuC6nTEUkDk+Dn7fKFfO5rYZ
         8kQN50FqaWC4bdFp9C+fDrf1HyMWtZvXZYJbIZgl1knLaxr8BAEmbU3hr2MfT6uMpV65
         h5X1d4Nm1B05Pk60EXjPd6KTqcTSzPzqzk8FFiE/dNcLbSK7+jHg/fSloSTDHOed79sC
         vWzQ==
X-Gm-Message-State: AOAM532U/RhbxfjGZoKmHqkchLw/qWt40af/kExfgj1Xb4yPRMp9PVGJ
        3cbqh+172jsuvOuBgZIKFNdZ7Q==
X-Google-Smtp-Source: ABdhPJxL1fEBgglkis/EMPLSlJi9UALXaNzImIYVN25Au5p37RRe+JGZt7QPDDzenL0BV+xqlxWkGA==
X-Received: by 2002:a05:6a00:1788:b0:508:70fe:4e62 with SMTP id s8-20020a056a00178800b0050870fe4e62mr4175773pfg.70.1650005123188;
        Thu, 14 Apr 2022 23:45:23 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a00198800b004fab740dbe6sm1867385pfl.15.2022.04.14.23.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 23:45:22 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net, zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH 2/4] virtio-crypto: move helpers into virtio_crypto_common.c
Date:   Fri, 15 Apr 2022 14:41:34 +0800
Message-Id: <20220415064136.304661-3-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415064136.304661-1-pizhenwei@bytedance.com>
References: <20220415064136.304661-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move virtcrypto_clear_request and virtcrypto_dataq_callback into
virtio_crypto_common.c to make code clear. Then the xx_core.c
supports:
  - probe/remove/irq affinity seting for a virtio device
  - basic virtio related operations

xx_common.c supports:
  - common helpers/functions for algos

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 drivers/crypto/virtio/virtio_crypto_common.c | 31 +++++++++++++++++++
 drivers/crypto/virtio/virtio_crypto_common.h |  2 ++
 drivers/crypto/virtio/virtio_crypto_core.c   | 32 --------------------
 3 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_common.c b/drivers/crypto/virtio/virtio_crypto_common.c
index 93df73c40dd3..4a23524896fe 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.c
+++ b/drivers/crypto/virtio/virtio_crypto_common.c
@@ -8,6 +8,14 @@
 
 #include "virtio_crypto_common.h"
 
+void virtcrypto_clear_request(struct virtio_crypto_request *vc_req)
+{
+	if (vc_req) {
+		kfree_sensitive(vc_req->req_data);
+		kfree(vc_req->sgs);
+	}
+}
+
 static void virtio_crypto_ctrlq_callback(struct virtio_crypto_ctrl_request *vc_ctrl_req)
 {
 	complete(&vc_ctrl_req->compl);
@@ -59,3 +67,26 @@ void virtcrypto_ctrlq_callback(struct virtqueue *vq)
 	} while (!virtqueue_enable_cb(vq));
 	spin_unlock_irqrestore(&vcrypto->ctrl_lock, flags);
 }
+
+void virtcrypto_dataq_callback(struct virtqueue *vq)
+{
+	struct virtio_crypto *vcrypto = vq->vdev->priv;
+	struct virtio_crypto_request *vc_req;
+	unsigned long flags;
+	unsigned int len;
+	unsigned int qid = vq->index;
+
+	spin_lock_irqsave(&vcrypto->data_vq[qid].lock, flags);
+	do {
+		virtqueue_disable_cb(vq);
+		while ((vc_req = virtqueue_get_buf(vq, &len)) != NULL) {
+			spin_unlock_irqrestore(
+				&vcrypto->data_vq[qid].lock, flags);
+			if (vc_req->alg_cb)
+				vc_req->alg_cb(vc_req, len);
+			spin_lock_irqsave(
+				&vcrypto->data_vq[qid].lock, flags);
+		}
+	} while (!virtqueue_enable_cb(vq));
+	spin_unlock_irqrestore(&vcrypto->data_vq[qid].lock, flags);
+}
diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index 125ad2300b83..a003935f91a9 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -148,4 +148,6 @@ int virtio_crypto_ctrl_vq_request(struct virtio_crypto *vcrypto, struct scatterl
 				  unsigned int out_sgs, unsigned int in_sgs,
 				  struct virtio_crypto_ctrl_request *vc_ctrl_req);
 
+void virtcrypto_dataq_callback(struct virtqueue *vq);
+
 #endif /* _VIRTIO_CRYPTO_COMMON_H */
diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index e668d4b1bc6a..d8edefcb966c 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -13,38 +13,6 @@
 #include "virtio_crypto_common.h"
 
 
-void
-virtcrypto_clear_request(struct virtio_crypto_request *vc_req)
-{
-	if (vc_req) {
-		kfree_sensitive(vc_req->req_data);
-		kfree(vc_req->sgs);
-	}
-}
-
-static void virtcrypto_dataq_callback(struct virtqueue *vq)
-{
-	struct virtio_crypto *vcrypto = vq->vdev->priv;
-	struct virtio_crypto_request *vc_req;
-	unsigned long flags;
-	unsigned int len;
-	unsigned int qid = vq->index;
-
-	spin_lock_irqsave(&vcrypto->data_vq[qid].lock, flags);
-	do {
-		virtqueue_disable_cb(vq);
-		while ((vc_req = virtqueue_get_buf(vq, &len)) != NULL) {
-			spin_unlock_irqrestore(
-				&vcrypto->data_vq[qid].lock, flags);
-			if (vc_req->alg_cb)
-				vc_req->alg_cb(vc_req, len);
-			spin_lock_irqsave(
-				&vcrypto->data_vq[qid].lock, flags);
-		}
-	} while (!virtqueue_enable_cb(vq));
-	spin_unlock_irqrestore(&vcrypto->data_vq[qid].lock, flags);
-}
-
 static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 {
 	vq_callback_t **callbacks;
-- 
2.20.1

