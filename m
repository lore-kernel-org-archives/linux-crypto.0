Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCECC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Apr 2022 10:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388504AbiDUKrO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 06:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388513AbiDUKrM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 06:47:12 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D242CE33
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 03:44:13 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n18so4472263plg.5
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 03:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Soqf3DM2EhHRALM+l3+OvMMOLUa3IL3/z83R4lQAUME=;
        b=MFcgCbgJJ5SK6J0X7stUHJhXJ0mBu8nHN96Z4tvfqDrjvLucvnYZgOGT0QjT597Uby
         X1P1qxXXARFF8wit/aAxMKwfDXO0rZDn3F4cbxwmxkKokfzYB1z7LhuoaTYegIMgyLqv
         ly0HoDdhUXeNpgQ1mwtvXwvP/8FrtIQEvkfMEezAoF7dwPoFpG+VMQ6TQ//imHHxOyBL
         WBSWvxXIsH8lO/KABabvTqewYOam48h/9Eli0b7/wsbHJREAKCSreIl3TDjrsRmS7fZQ
         qwNH4ZZ/D49sflTZ4fn2bPHMvETRXj/qB6rZXBbEbHddeeXH8ZwfU3nfojguPxeKrs06
         SBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Soqf3DM2EhHRALM+l3+OvMMOLUa3IL3/z83R4lQAUME=;
        b=ZfUOSmxsmio27TJEDJn+63mAROyxACix+0eYLu27Ltkxi2tIm+wOgk98YA5W/Cph0j
         5ARi2vmfH9mTaYbpK/seWQn11lPEnUFIKABSbUpKzI+Aay32mjh9nfwO+qN05EZCRheg
         CqqhBRMaIxy3w3HK9kMciZOhRHeVqu9BuyO0gvPseZMHdX1un6eMOyizOpySoZofosEK
         u1DB5TYq12tQPEIM5AlPQa+1qJr0qenDrsIgwKN+g822Sdjrr+xDhpxBkcMlmUtdSdp9
         /dCNbkoPMH7yGm1bLSKmqborfkC767mu0Ak10bC1FYKovU5KVOAP5Wx0DJgptxHcOZDB
         H7OQ==
X-Gm-Message-State: AOAM533mrjsGs5x3Gz6EtyWJUOb+ANSex9Qlk/XcAUO5s8gZXvQAR9YP
        kpKtsuQ93gcwkAHxO0ID6r+pDg==
X-Google-Smtp-Source: ABdhPJwERO7VeCmPyZBwxIsQHqWASpqeFP8RVtxBICGxK+ZjXbAoVUBaCflO3+ba3KBsGrekR9xcJg==
X-Received: by 2002:a17:902:bb92:b0:153:4eae:c77e with SMTP id m18-20020a170902bb9200b001534eaec77emr24831615pls.93.1650537852862;
        Thu, 21 Apr 2022 03:44:12 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.69])
        by smtp.gmail.com with ESMTPSA id w7-20020aa79547000000b0050ad0e82e6dsm3772485pfq.215.2022.04.21.03.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 03:44:12 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net, zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v3 3/5] virtio-crypto: move helpers into virtio_crypto_common.c
Date:   Thu, 21 Apr 2022 18:40:14 +0800
Message-Id: <20220421104016.453458-4-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220421104016.453458-1-pizhenwei@bytedance.com>
References: <20220421104016.453458-1-pizhenwei@bytedance.com>
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

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>
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
index 25b4f22e8605..4d33ed5593d4 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -152,4 +152,6 @@ int virtio_crypto_ctrl_vq_request(struct virtio_crypto *vcrypto, struct scatterl
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

