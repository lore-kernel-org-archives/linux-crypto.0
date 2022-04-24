Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36100C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Apr 2022 10:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239197AbiDXKtQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Apr 2022 06:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239133AbiDXKtE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Apr 2022 06:49:04 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F3D25E83
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 03:45:59 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n8so20861928plh.1
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 03:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bhiM3AjN7OQUvaBDZQVzT5dsdkup6eI4sw9Fv5sP5tE=;
        b=voSfwnuz4TazDsGKnkLUa3eLXrQvuZd0CeBraJuFrBeSJjuo6ZZnyyZ6IVf0DMCxDd
         2jO3l101hWUMVw6fE6Q1scUwdoY55AfZrU59fgoeCmBV8NoDnheH2xHW9oOuLNYc32kS
         /Myz9unOyMQgMJYiLy50IfLa0wWwZPsTpzo+uY0oEcuxNFo+Xee80to77j8yDZ+BPT4y
         djGTubGoqSCw75gGJq5Xax5kSqm3psqt0E8BbnH2vId9AoT513Tt6AWKyFwJ+/iitQWt
         z87pqXiqtAqnUt/3mHP9bu0yoOsQRF02y/h4nYScuC/sgGnvBrK48Z2KddBDQnrw0ALc
         uUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bhiM3AjN7OQUvaBDZQVzT5dsdkup6eI4sw9Fv5sP5tE=;
        b=yTkOkd8NopYANeDbLy7QIq0HA67W7DmuBMwMqisapiOmTtYdm3zP7DcvrMTgrG5V1D
         y4jUsD+b26gx/yq31WrqRrEqlR+KrCt3981BzFzideZ1M+QUL3P8XZ8STNks3W9epdIw
         zXMnXmrQLvUoRikzeKPEsXvJyrw/21wpKMKlcV3tdERFiF6cCTPkZHCfP1BJUu4Uvopb
         tZOqdk4TFPK8IXUyPc4D03Z+OJ2vuLNLoHB59YmzU1TiyJuvA1sEtu8OHivFzwhq97xh
         yb1/Qcrw/xfRR6zm78P4m6fAVQeO6vx5IvH7NrJvDtFjHmdHbWz+xgHk0MxXXJVeqoq4
         LHyA==
X-Gm-Message-State: AOAM530YUpu4KQ0oMERIZNMoO/4AzqrMDpohMxc+8UzV5TQq5QRtJ9Vu
        Z5BgaBOgn2kQqEAulizl7t96jg==
X-Google-Smtp-Source: ABdhPJxsLxoBTSXLJ8lKEHWxix35/c4WKDc8Lc+R21OTU1ppRMOI/MHE4yD26NyDYhl3/dU3YYeX9Q==
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id d22-20020a170902729600b0014b4bc60e81mr12832804pll.132.1650797158606;
        Sun, 24 Apr 2022 03:45:58 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id y2-20020a056a00190200b004fa865d1fd3sm8287295pfi.86.2022.04.24.03.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 03:45:58 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com
Cc:     herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net, zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v4 5/5] virtio-crypto: enable retry for virtio-crypto-dev
Date:   Sun, 24 Apr 2022 18:41:40 +0800
Message-Id: <20220424104140.44841-6-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220424104140.44841-1-pizhenwei@bytedance.com>
References: <20220424104140.44841-1-pizhenwei@bytedance.com>
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

