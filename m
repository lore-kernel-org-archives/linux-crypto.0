Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30950C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 13:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392480AbiEFNZc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 09:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392451AbiEFNZN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 09:25:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D566973F
        for <linux-crypto@vger.kernel.org>; Fri,  6 May 2022 06:21:18 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so10798363pjv.4
        for <linux-crypto@vger.kernel.org>; Fri, 06 May 2022 06:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=snAq8vOceBJQXNtHaQrKZKIzrWkN2Ytbsg/b/TMNKmk=;
        b=RcbJboymTfiVvIkRHCgMojUfl9bLvh+A2nG+XBtgmx0u4q3MuN7jucM7/yuVKMzlwh
         UnMU2h/tV8bvG7ApiCvCmir6sodCeLyONGmHHscGkU0RofG2yjBLERzmHarv3zKNdn3c
         W1qDNbeb8vuDdLXbyGwpLxh4as5TGCG+DtP5oGtMuiJwcz9+Ocnj6sZ9xOBb211wgbSW
         lsRhEZHd8CZ93wsB7gNlHbWHuwdNKtEIzUYtmdB/cxqBRweoDwfSlHs4aj/ZF7ZTmad+
         TDCC2YheRyFnYFVnvg1YVHCxdu5HESG/g1d4BiK1Ixu56OjuAOLXVlpoBk9MzY19DPQI
         qzKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=snAq8vOceBJQXNtHaQrKZKIzrWkN2Ytbsg/b/TMNKmk=;
        b=0dECydkt6sIh7H5eXTfVkUXHtYrH8wblMzSsjqjZ40Cwqz1tjPvH5T80UQDy3D6S1o
         NyUPXqlHiRqhLFQLoEXTr0I6TP7br2PUscp/FKfgdAtDwH0FWVdrSuXGyyon2xu3OnyP
         PWwPEdLYP6kQD6rFF64p16NTw3PU0GgokPRYdYhcJFcUX73ybWPi/SEDP1yXQVbtuunw
         H6PA2/X7G8Bt5ZFznX3bZEFz4NB7JGbGiOHksXL+e7wiedzCcN9sv1SDznQEytvaZwTw
         XR+yecjwqEDT5Q/50JYdOxlMwrcZqVGbbhhyvy2gXV5qcqIMhds/OdEyS9OLw7y9eSjq
         rBXg==
X-Gm-Message-State: AOAM530bDO3VSABVUBJ4oHvIg4gGouc8AF2i0c7Zy5JMnXyi7kuVG4jP
        Xm24t2gpMVeSSXq+GYDuOgYwgPM0FTOyJA==
X-Google-Smtp-Source: ABdhPJyFm1OdK877ATfQ8sTTUFDzZf6kwJX19vO8QKfl9vfzuJo5UneDBXKKQgQprvUGJ1o25mQvVQ==
X-Received: by 2002:a17:902:8605:b0:15d:10dc:1c6f with SMTP id f5-20020a170902860500b0015d10dc1c6fmr3781372plo.4.1651843277875;
        Fri, 06 May 2022 06:21:17 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id i22-20020a63e916000000b003c14af50643sm3256986pgh.91.2022.05.06.06.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 06:21:17 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        pizhenwei@bytedance.com, davem@davemloft.net
Subject: [PATCH v6 5/5] virtio-crypto: enable retry for virtio-crypto-dev
Date:   Fri,  6 May 2022 21:16:27 +0800
Message-Id: <20220506131627.180784-6-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506131627.180784-1-pizhenwei@bytedance.com>
References: <20220506131627.180784-1-pizhenwei@bytedance.com>
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
Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 drivers/crypto/virtio/virtio_crypto_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index 60490ffa3df1..1198bd306365 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -144,7 +144,8 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 		spin_lock_init(&vi->data_vq[i].lock);
 		vi->data_vq[i].vq = vqs[i];
 		/* Initialize crypto engine */
-		vi->data_vq[i].engine = crypto_engine_alloc_init(dev, 1);
+		vi->data_vq[i].engine = crypto_engine_alloc_init_and_set(dev, true, NULL, true,
+						virtqueue_get_vring_size(vqs[i]));
 		if (!vi->data_vq[i].engine) {
 			ret = -ENOMEM;
 			goto err_engine;
-- 
2.20.1

