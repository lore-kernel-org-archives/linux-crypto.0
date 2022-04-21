Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86761C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Apr 2022 10:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388492AbiDUKrQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 06:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388522AbiDUKrN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 06:47:13 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B261B2D1E0
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 03:44:23 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t13so4303732pgn.8
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 03:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vgyphshva4+1MoZbiUZHYBed15/dj2PxkqwfRwCNPpE=;
        b=EfTBFRclrg2OJBpUoWZLcqlhoTqhRPEqclktYCgbN7WckD+ipu67xVjpp/KgX7S3df
         0IajjdCl6lQ4JqNYZ2giw2+aoayfss17DKxqHwh6fCOCKA+6vJXZux5rCgrI/FvsvgZW
         6maMRybm/GRxdmiP7SY1PPpQYHJ3wabRoo8f+BHWM0ec9Z8SSDXgW5f4txOhg+0YNp9e
         igR+AHPtL0BXLeX/E03XpjTxJnzt+JoQtKDa/lJErvLuZ7Mnh2Vs9vvIAggOKq9U4eSY
         xmdDLBRPP7BdgUm0SkYvRhfiNAkFaZkxy2rIWHF7ahWI1j//YJPqwXC44BuF6XA7i7kQ
         FeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vgyphshva4+1MoZbiUZHYBed15/dj2PxkqwfRwCNPpE=;
        b=0FOnfrZUiyLVe2cHz7lIiFIUjf34iQ7b/KqYgl8sMm+8nrxUK72U20qcdjj6jMzajn
         KBn5CAVjPvqurrB+heQIVDC8UOjDICLxv4SnabKdxhEvepjGA4dd8HIbdXR/TMusDQpG
         86NwXC6m33QjCV9naeTFHbhG/KHp97RLwM9O0nyq/gaU8PJCyCn3ipO2fZ4uC1wHmoTb
         str/7phzsAqkrjSoAXdESMdwcBlDUe0LD50/m+Mx0wrHjSrihorCn0b8hLikfx2ooIwP
         CXHxeC2fYnHxo3eX4472mfFg09aavlmz1SzEjEreuAlaLYgh0WDj74vsSpxGTTap447G
         hJPQ==
X-Gm-Message-State: AOAM532suE6tsKhdYRuX0lItQs4MymTkSRpSQHl+k4GFp4pItLvbym0P
        EpuUPPD8f9DhgpniHIWzGYonPw==
X-Google-Smtp-Source: ABdhPJyJLS3mZ53Vu2R9I+Mt2sPcqwMG8V444JCZXnqM/k/gHuRh+50aLFK0VyGbedV642Rj9fvPKg==
X-Received: by 2002:a65:6e9a:0:b0:382:1804:35c8 with SMTP id bm26-20020a656e9a000000b00382180435c8mr23664506pgb.584.1650537863265;
        Thu, 21 Apr 2022 03:44:23 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.69])
        by smtp.gmail.com with ESMTPSA id w7-20020aa79547000000b0050ad0e82e6dsm3772485pfq.215.2022.04.21.03.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 03:44:22 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net, zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v3 5/5] virtio-crypto: enable retry for virtio-crypto-dev
Date:   Thu, 21 Apr 2022 18:40:16 +0800
Message-Id: <20220421104016.453458-6-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220421104016.453458-1-pizhenwei@bytedance.com>
References: <20220421104016.453458-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: lei he <helei.sig11@bytedance.com>

Enable retry for virtio-crypto-dev, so that crypto-engine
can process cipher-requests parallelly.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 drivers/crypto/virtio/virtio_crypto_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index d8edefcb966c..5c0d68c9e894 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -62,7 +62,8 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 		spin_lock_init(&vi->data_vq[i].lock);
 		vi->data_vq[i].vq = vqs[i];
 		/* Initialize crypto engine */
-		vi->data_vq[i].engine = crypto_engine_alloc_init(dev, 1);
+		vi->data_vq[i].engine = crypto_engine_alloc_init_and_set(dev, true, NULL, 1,
+						virtqueue_get_vring_size(vqs[i]));
 		if (!vi->data_vq[i].engine) {
 			ret = -ENOMEM;
 			goto err_engine;
-- 
2.20.1

