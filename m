Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5EBC433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Apr 2022 10:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239131AbiDXKtC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Apr 2022 06:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbiDXKsq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Apr 2022 06:48:46 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDAB20BED
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 03:45:45 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q3so20846163plg.3
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 03:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UsAhpE+ugC3O5yltAsuOPgGj88elpiVZxkM4bSAZJVI=;
        b=CDPq45Eju4Udy1f/3D6Pgk+8kUjQzM6KhnVJojoEE5FKwex4nZ5L1UM9DRHQVoYGYF
         V7xtY5T+QZVO+YvYHKTxY2zcvwss27qoqS5V9nsCNnquT1esJgZnhFmiwonfvbYxoUZP
         V/SoodAVkcVl5VDO0OJ9yrrptHf4FhPQpvuJ8WPAmkStC768aCPo4vea48xuHq1BORd4
         c/5/juNv1kQi2bYn3wDOsGhWjbObWk62EvPI1ObTs/PdsMAKc2cr8sVzvMjQCtF8+3g0
         iCLheoLG9y/4CjdVFr1UEsGLT+o0+0kbXkMGo/eCSZkTBpQqSYX5nHj/XwsCdcpSJs3N
         qSYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UsAhpE+ugC3O5yltAsuOPgGj88elpiVZxkM4bSAZJVI=;
        b=NapKac+GhTPyISeq3XPZg7+q9Nohrp9UTqxPIoN/vgNbJ3wH+07d5PyUuDgG0uQuXd
         6gGM4YzuGdw3KYwiUY9qr/qqwZNWFOKfALbLNTWnMaK+Hw5ISXNZOp4MZLhSMcxMWzRB
         NUPYlTYEK55AwKMaGIt8Yho8KrjWolQqD++BZoAP3j3C275Vxs9K3HQhr+b0n/lScp3B
         cmF1Vrb3GdOV53J9KNOJNTIw33214zWW1c0S4MLhq5V54kkzIAC34WIRVfGI4GAP097f
         rPdG1m9IHRfSOegKae+fUzYAoyZcMkr+c0wFMkoDEi+SmFeBIRP9or/zDL7y2DpZoYw3
         7lVw==
X-Gm-Message-State: AOAM530pPhbFWB9gOFfcac57q5m+rXw92ZQnBH8UpGTJjxrqmm+sj58e
        VmJ/Hp1rVQ/UHLplaaZVTBx4Hw==
X-Google-Smtp-Source: ABdhPJy43fQlBPZDmMQtOyeaXbRgcCetLjUR1wmMWKTV8ELw8Mm1SFDDvLrIoITjZT4S9T1VAij4LQ==
X-Received: by 2002:a17:90a:a82:b0:1c9:ef95:486 with SMTP id 2-20020a17090a0a8200b001c9ef950486mr25677254pjw.93.1650797145068;
        Sun, 24 Apr 2022 03:45:45 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id y2-20020a056a00190200b004fa865d1fd3sm8287295pfi.86.2022.04.24.03.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 03:45:44 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com
Cc:     herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net, zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v4 2/5] virtio-crypto: use private buffer for control request
Date:   Sun, 24 Apr 2022 18:41:37 +0800
Message-Id: <20220424104140.44841-3-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220424104140.44841-1-pizhenwei@bytedance.com>
References: <20220424104140.44841-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Originally, all of the control requests share a single buffer(
ctrl & input & ctrl_status fields in struct virtio_crypto), this
allows queue depth 1 only, the performance of control queue gets
limited by this design.

In this patch, each request allocates request buffer dynamically, and
free buffer after request, so the scope protected by ctrl_lock also
get optimized here.
It's possible to optimize control queue depth in the next step.

A necessary comment is already in code, still describe it again:
/*
 * Note: there are padding fields in request, clear them to zero before
 * sending to host to avoid to divulge any information.
 * Ex, virtio_crypto_ctrl_request::ctrl::u::destroy_session::padding[48]
 */
So use kzalloc to allocate buffer of struct virtio_crypto_ctrl_request.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 .../virtio/virtio_crypto_akcipher_algs.c      | 41 +++++++++++----
 drivers/crypto/virtio/virtio_crypto_common.h  | 17 +++++--
 .../virtio/virtio_crypto_skcipher_algs.c      | 50 ++++++++++++-------
 3 files changed, 75 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index 20901a263fc8..509884e8b201 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -108,16 +108,22 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 	unsigned int num_out = 0, num_in = 0;
 	struct virtio_crypto_op_ctrl_req *ctrl;
 	struct virtio_crypto_session_input *input;
+	struct virtio_crypto_ctrl_request *vc_ctrl_req;
 
 	pkey = kmemdup(key, keylen, GFP_ATOMIC);
 	if (!pkey)
 		return -ENOMEM;
 
-	spin_lock(&vcrypto->ctrl_lock);
-	ctrl = &vcrypto->ctrl;
+	vc_ctrl_req = kzalloc(sizeof(*vc_ctrl_req), GFP_KERNEL);
+	if (!vc_ctrl_req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	ctrl = &vc_ctrl_req->ctrl;
 	memcpy(&ctrl->header, header, sizeof(ctrl->header));
 	memcpy(&ctrl->u, para, sizeof(ctrl->u));
-	input = &vcrypto->input;
+	input = &vc_ctrl_req->input;
 	input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
 
 	sg_init_one(&outhdr_sg, ctrl, sizeof(*ctrl));
@@ -129,14 +135,18 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 	sg_init_one(&inhdr_sg, input, sizeof(*input));
 	sgs[num_out + num_in++] = &inhdr_sg;
 
+	spin_lock(&vcrypto->ctrl_lock);
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out, num_in, vcrypto, GFP_ATOMIC);
-	if (err < 0)
+	if (err < 0) {
+		spin_unlock(&vcrypto->ctrl_lock);
 		goto out;
+	}
 
 	virtqueue_kick(vcrypto->ctrl_vq);
 	while (!virtqueue_get_buf(vcrypto->ctrl_vq, &inlen) &&
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
+	spin_unlock(&vcrypto->ctrl_lock);
 
 	if (le32_to_cpu(input->status) != VIRTIO_CRYPTO_OK) {
 		err = -EINVAL;
@@ -148,7 +158,7 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 	err = 0;
 
 out:
-	spin_unlock(&vcrypto->ctrl_lock);
+	kfree(vc_ctrl_req);
 	kfree_sensitive(pkey);
 
 	if (err < 0)
@@ -167,15 +177,22 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
 	int err;
 	struct virtio_crypto_op_ctrl_req *ctrl;
 	struct virtio_crypto_inhdr *ctrl_status;
+	struct virtio_crypto_ctrl_request *vc_ctrl_req;
 
-	spin_lock(&vcrypto->ctrl_lock);
 	if (!ctx->session_valid) {
 		err = 0;
 		goto out;
 	}
-	ctrl_status = &vcrypto->ctrl_status;
+
+	vc_ctrl_req = kzalloc(sizeof(*vc_ctrl_req), GFP_KERNEL);
+	if (!vc_ctrl_req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	ctrl_status = &vc_ctrl_req->ctrl_status;
 	ctrl_status->status = VIRTIO_CRYPTO_ERR;
-	ctrl = &vcrypto->ctrl;
+	ctrl = &vc_ctrl_req->ctrl;
 	ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_AKCIPHER_DESTROY_SESSION);
 	ctrl->header.queue_id = 0;
 
@@ -188,14 +205,18 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
 	sg_init_one(&inhdr_sg, &ctrl_status->status, sizeof(ctrl_status->status));
 	sgs[num_out + num_in++] = &inhdr_sg;
 
+	spin_lock(&vcrypto->ctrl_lock);
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out, num_in, vcrypto, GFP_ATOMIC);
-	if (err < 0)
+	if (err < 0) {
+		spin_unlock(&vcrypto->ctrl_lock);
 		goto out;
+	}
 
 	virtqueue_kick(vcrypto->ctrl_vq);
 	while (!virtqueue_get_buf(vcrypto->ctrl_vq, &inlen) &&
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
+	spin_unlock(&vcrypto->ctrl_lock);
 
 	if (ctrl_status->status != VIRTIO_CRYPTO_OK) {
 		err = -EINVAL;
@@ -206,7 +227,7 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
 	ctx->session_valid = false;
 
 out:
-	spin_unlock(&vcrypto->ctrl_lock);
+	kfree(vc_ctrl_req);
 	if (err < 0) {
 		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
 			ctrl_status->status, destroy_session->session_id);
diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index e693d4ee83a6..2422237ec4e6 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -13,6 +13,7 @@
 #include <crypto/aead.h>
 #include <crypto/aes.h>
 #include <crypto/engine.h>
+#include <uapi/linux/virtio_crypto.h>
 
 
 /* Internal representation of a data virtqueue */
@@ -65,11 +66,6 @@ struct virtio_crypto {
 	/* Maximum size of per request */
 	u64 max_size;
 
-	/* Control VQ buffers: protected by the ctrl_lock */
-	struct virtio_crypto_op_ctrl_req ctrl;
-	struct virtio_crypto_session_input input;
-	struct virtio_crypto_inhdr ctrl_status;
-
 	unsigned long status;
 	atomic_t ref_count;
 	struct list_head list;
@@ -85,6 +81,17 @@ struct virtio_crypto_sym_session_info {
 	__u64 session_id;
 };
 
+/*
+ * Note: there are padding fields in request, clear them to zero before
+ *       sending to host to avoid to divulge any information.
+ * Ex, virtio_crypto_ctrl_request::ctrl::u::destroy_session::padding[48]
+ */
+struct virtio_crypto_ctrl_request {
+	struct virtio_crypto_op_ctrl_req ctrl;
+	struct virtio_crypto_session_input input;
+	struct virtio_crypto_inhdr ctrl_status;
+};
+
 struct virtio_crypto_request;
 typedef void (*virtio_crypto_data_callback)
 		(struct virtio_crypto_request *vc_req, int len);
diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index e3c5bc8d6112..6aaf0869b211 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -126,6 +126,7 @@ static int virtio_crypto_alg_skcipher_init_session(
 	struct virtio_crypto_op_ctrl_req *ctrl;
 	struct virtio_crypto_session_input *input;
 	struct virtio_crypto_sym_create_session_req *sym_create_session;
+	struct virtio_crypto_ctrl_request *vc_ctrl_req;
 
 	/*
 	 * Avoid to do DMA from the stack, switch to using
@@ -136,15 +137,20 @@ static int virtio_crypto_alg_skcipher_init_session(
 	if (!cipher_key)
 		return -ENOMEM;
 
-	spin_lock(&vcrypto->ctrl_lock);
+	vc_ctrl_req = kzalloc(sizeof(*vc_ctrl_req), GFP_KERNEL);
+	if (!vc_ctrl_req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	/* Pad ctrl header */
-	ctrl = &vcrypto->ctrl;
+	ctrl = &vc_ctrl_req->ctrl;
 	ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_CIPHER_CREATE_SESSION);
 	ctrl->header.algo = cpu_to_le32(alg);
 	/* Set the default dataqueue id to 0 */
 	ctrl->header.queue_id = 0;
 
-	input = &vcrypto->input;
+	input = &vc_ctrl_req->input;
 	input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
 	/* Pad cipher's parameters */
 	sym_create_session = &ctrl->u.sym_create_session;
@@ -164,12 +170,12 @@ static int virtio_crypto_alg_skcipher_init_session(
 	sg_init_one(&inhdr, input, sizeof(*input));
 	sgs[num_out + num_in++] = &inhdr;
 
+	spin_lock(&vcrypto->ctrl_lock);
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out,
 				num_in, vcrypto, GFP_ATOMIC);
 	if (err < 0) {
 		spin_unlock(&vcrypto->ctrl_lock);
-		kfree_sensitive(cipher_key);
-		return err;
+		goto out;
 	}
 	virtqueue_kick(vcrypto->ctrl_vq);
 
@@ -180,13 +186,13 @@ static int virtio_crypto_alg_skcipher_init_session(
 	while (!virtqueue_get_buf(vcrypto->ctrl_vq, &tmp) &&
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
+	spin_unlock(&vcrypto->ctrl_lock);
 
 	if (le32_to_cpu(input->status) != VIRTIO_CRYPTO_OK) {
-		spin_unlock(&vcrypto->ctrl_lock);
 		pr_err("virtio_crypto: Create session failed status: %u\n",
 			le32_to_cpu(input->status));
-		kfree_sensitive(cipher_key);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	if (encrypt)
@@ -194,10 +200,11 @@ static int virtio_crypto_alg_skcipher_init_session(
 	else
 		ctx->dec_sess_info.session_id = le64_to_cpu(input->session_id);
 
-	spin_unlock(&vcrypto->ctrl_lock);
-
+	err = 0;
+out:
+	kfree(vc_ctrl_req);
 	kfree_sensitive(cipher_key);
-	return 0;
+	return err;
 }
 
 static int virtio_crypto_alg_skcipher_close_session(
@@ -212,12 +219,16 @@ static int virtio_crypto_alg_skcipher_close_session(
 	unsigned int num_out = 0, num_in = 0;
 	struct virtio_crypto_op_ctrl_req *ctrl;
 	struct virtio_crypto_inhdr *ctrl_status;
+	struct virtio_crypto_ctrl_request *vc_ctrl_req;
 
-	spin_lock(&vcrypto->ctrl_lock);
-	ctrl_status = &vcrypto->ctrl_status;
+	vc_ctrl_req = kzalloc(sizeof(*vc_ctrl_req), GFP_KERNEL);
+	if (!vc_ctrl_req)
+		return -ENOMEM;
+
+	ctrl_status = &vc_ctrl_req->ctrl_status;
 	ctrl_status->status = VIRTIO_CRYPTO_ERR;
 	/* Pad ctrl header */
-	ctrl = &vcrypto->ctrl;
+	ctrl = &vc_ctrl_req->ctrl;
 	ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_CIPHER_DESTROY_SESSION);
 	/* Set the default virtqueue id to 0 */
 	ctrl->header.queue_id = 0;
@@ -236,28 +247,31 @@ static int virtio_crypto_alg_skcipher_close_session(
 	sg_init_one(&status_sg, &ctrl_status->status, sizeof(ctrl_status->status));
 	sgs[num_out + num_in++] = &status_sg;
 
+	spin_lock(&vcrypto->ctrl_lock);
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out,
 			num_in, vcrypto, GFP_ATOMIC);
 	if (err < 0) {
 		spin_unlock(&vcrypto->ctrl_lock);
-		return err;
+		goto out;
 	}
 	virtqueue_kick(vcrypto->ctrl_vq);
 
 	while (!virtqueue_get_buf(vcrypto->ctrl_vq, &tmp) &&
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
+	spin_unlock(&vcrypto->ctrl_lock);
 
 	if (ctrl_status->status != VIRTIO_CRYPTO_OK) {
-		spin_unlock(&vcrypto->ctrl_lock);
 		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
 			ctrl_status->status, destroy_session->session_id);
 
 		return -EINVAL;
 	}
-	spin_unlock(&vcrypto->ctrl_lock);
 
-	return 0;
+	err = 0;
+out:
+	kfree(vc_ctrl_req);
+	return err;
 }
 
 static int virtio_crypto_alg_skcipher_init_sessions(
-- 
2.20.1

