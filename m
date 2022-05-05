Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED645C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  5 May 2022 09:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353656AbiEEJdS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 May 2022 05:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353659AbiEEJc2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 May 2022 05:32:28 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768FB5004A
        for <linux-crypto@vger.kernel.org>; Thu,  5 May 2022 02:28:29 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p12so3234391pfn.0
        for <linux-crypto@vger.kernel.org>; Thu, 05 May 2022 02:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bhiM3AjN7OQUvaBDZQVzT5dsdkup6eI4sw9Fv5sP5tE=;
        b=7pLxwHXxcvVshGXn4uHVSVCm5smt0n8fUCsFCOFPzxzzbMx9xGwFC8KvsSw5ALEAQc
         YtSU16tQmkLgjSPzKZcLVcI5XY2JX4J8x+8n2BcStEZYz241qYt9POCYXssiCowaOCnD
         SmLvMlcKl5dnebFgxc4xwOxBqQrkvHBeuy5+jj97DytTTQWkKiwnyh3c2mgzF5/fpd0y
         cohIs8wSJ51+B9YoK748fTSvOCWCNBu1kkX9DYjIvItRZSfXb5CnAoy2CObgRC0aE0c0
         sqGBDL8LH/OF01q0pOa86ID9gEQECiLfKxnxDW4tw/9Ra+EJ54XueksS/HRBpCnq/uN5
         MqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bhiM3AjN7OQUvaBDZQVzT5dsdkup6eI4sw9Fv5sP5tE=;
        b=4MUIlcPq0gpb4fMoGGYmgTEKL3NvkU8NJxOwxrWWsR+2K6zR+2s76yV+Orwa87kgCs
         PPw99Z3SSPkVW5ltkyu+9h2JL5YxVILOV5IDA8aQbBGlMsn/V8VA4JljMC5h8WoRrOyd
         7xT91m0bn/+clNeBb/QEGyEigSUQWvmHQnxUh+ES2Vbvedqal7H8IXEqoB4+rp8cXtKY
         b7+hnaqSAC9Vpee6WBKma6G8HAA7d0nBQrM5WTx1z0BlHKFuYfGnKvtyJQYs1FbGTsxz
         6zwL13jisyux61+uVwXui8eLURVLJlFTpIellRrC9A/mYAJhDmIbeE3Ht1gtakbCKMxn
         s4WQ==
X-Gm-Message-State: AOAM530wNvd3YUqDiAugiO+JGgIHcf9PND1PDvpjjfb2CwSzzau5ztlf
        GWVXiIzUaHHZA/CLaKFo6Vc/Ow==
X-Google-Smtp-Source: ABdhPJxfhS9sNn9cwwCynTPr683iYd3vLNFKRz6cyWRcDnnmWCepvXGvvpQ/wv+sEubyXPwG47WkRw==
X-Received: by 2002:a63:310a:0:b0:3c5:f9ba:b010 with SMTP id x10-20020a63310a000000b003c5f9bab010mr4724700pgx.143.1651742909075;
        Thu, 05 May 2022 02:28:29 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id t68-20020a625f47000000b0050dc76281dcsm884224pfb.182.2022.05.05.02.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 02:28:28 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        pizhenwei@bytedance.com, davem@davemloft.net
Subject: [PATCH v5 5/5] virtio-crypto: enable retry for virtio-crypto-dev
Date:   Thu,  5 May 2022 17:24:08 +0800
Message-Id: <20220505092408.53692-6-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220505092408.53692-1-pizhenwei@bytedance.com>
References: <20220505092408.53692-1-pizhenwei@bytedance.com>
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
index 60490ffa3df1..f67e0d4c1b0c 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -144,7 +144,8 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
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

