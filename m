Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2800C433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 13:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388427AbiEFNZO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 09:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392437AbiEFNZM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 09:25:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B1269722
        for <linux-crypto@vger.kernel.org>; Fri,  6 May 2022 06:21:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso10831671pjb.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 May 2022 06:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5edDtm3ClDj2Ih4shfC7v+UW75qeVSKJFNdIatinSe4=;
        b=Uk0uXOW5WRqRK2VTpgFyRJQIfmCllW+gzKZ2xs8e38Byyi/sOBdnh8zgRA2lcnrGCp
         MbpJ6070kITrxcF0rmmRClG32eCpQhdvZnLOw7NLyTPxN17z9kfcUDGoISZ+d6HUt5GC
         GVJC143IRGMeIeiMMdCszdGtCr5lKVFZAUq5kJjXPyWZJcE/9kdtn0fobMio59+w9sa2
         V/jA6HOPPwfzAulbD2NmBLMojuItt8BegWaY3H53J4ZqG4FkyZNtgmc4blc4AX3OYc9I
         JFHSNhwzkd2cerBOdCNcSJ/O1sx3tYQCe2VhoYJcoIR2cwtxRpscHgemetzFMfVdAioF
         n3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5edDtm3ClDj2Ih4shfC7v+UW75qeVSKJFNdIatinSe4=;
        b=oo0wlrOb98oMz1QRJ2Mf1GXLKtu7KEl/k4klGyvqThl8SAZcm5jyrMYOGp1XsrHSRc
         aYBGc2iAr7a3+Gl5Qf5YIOb2BN1wUJXVnYMZKP2TqwGCB4eL592XPI57FbcVo7LgEOhG
         U5X0peyu52TT6qC6yf7joTcX04Nlm+jV/N5XTxlOnK2GvUWiTgSsf/YLHuqTH0lACEdA
         gVTfpyHL1sYYjY4n/N2vlw+GXcDaFOMU1YuBe/CawNoC3cvCtH3Sh++qVmT4TaO06Cnt
         XD0Q/i7ivjRrdfUJXrjwcLPTAds+BJSlyuppQATa0w/UgywanK8xbtQXJIvWUWerplk7
         c4jQ==
X-Gm-Message-State: AOAM530qquGEYILvJEJec4dAI+OodUPHQvN7SvXJ646fU3q/MkmbDlQm
        P4XoRBxIs4OBXzHl/Dqik0P8CQ==
X-Google-Smtp-Source: ABdhPJwmOLNxQkSjP7G9cCAfAFBzJustpWCljWo7emBIKpuY9vdl/bdTDNTkpES1Me8znMuFza7RlQ==
X-Received: by 2002:a17:90b:1c04:b0:1dc:4dfd:5a43 with SMTP id oc4-20020a17090b1c0400b001dc4dfd5a43mr12535457pjb.160.1651843273430;
        Fri, 06 May 2022 06:21:13 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id i22-20020a63e916000000b003c14af50643sm3256986pgh.91.2022.05.06.06.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 06:21:12 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        pizhenwei@bytedance.com, davem@davemloft.net
Subject: [PATCH v6 4/5] virtio-crypto: adjust dst_len at ops callback
Date:   Fri,  6 May 2022 21:16:26 +0800
Message-Id: <20220506131627.180784-5-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506131627.180784-1-pizhenwei@bytedance.com>
References: <20220506131627.180784-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: lei he <helei.sig11@bytedance.com>

For some akcipher operations(eg, decryption of pkcs1pad(rsa)),
the length of returned result maybe less than akcipher_req->dst_len,
we need to recalculate the actual dst_len through the virt-queue
protocol.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index 382ccec9ab12..2a60d0525cde 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -90,9 +90,12 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
 	}
 
 	akcipher_req = vc_akcipher_req->akcipher_req;
-	if (vc_akcipher_req->opcode != VIRTIO_CRYPTO_AKCIPHER_VERIFY)
+	if (vc_akcipher_req->opcode != VIRTIO_CRYPTO_AKCIPHER_VERIFY) {
+		/* actuall length maybe less than dst buffer */
+		akcipher_req->dst_len = len - sizeof(vc_req->status);
 		sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
 				    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
+	}
 	virtio_crypto_akcipher_finalize_req(vc_akcipher_req, akcipher_req, error);
 }
 
-- 
2.20.1

