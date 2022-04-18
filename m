Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6385CC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 09:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbiDRJHk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 05:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237440AbiDRJH2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 05:07:28 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FCBF6D
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 02:04:48 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t184so4809730pgd.4
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 02:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ouz4DgKg6HX7//LGRrUD97CctBPhdyzV/9EeFTiygxk=;
        b=6TWHPFn0LN6u1Gtv/IJ/FZUtIkxZGYRSlYL1xUuSQwz6ytLfUxUHzEhiZogx/oPjrb
         5IOYrTilRPWoHpCRSg3pD9hxYZzJxQhgFu7oMUXgRdkrpSBD8H8p9b2MjNWFFbRV/0fk
         JqtHVC/Atk4oTpbgL809sb6GZ48czjib99D2vLy8PKSaX5Q4H53WLL5nFIul/nggKvzB
         QyCC5TIlf1UwqjmQzzFfYQICmDC+k+WILzeWkCdunjIwypfSFlv0ZFqUS9k7G5oLbxB2
         6oUiQeUOEd1aB+8ADGQyVZYhbF9eyXJK0CCrBZfsSUMAUUktSQsB/HwqoQFmhdVi8f4r
         H9mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ouz4DgKg6HX7//LGRrUD97CctBPhdyzV/9EeFTiygxk=;
        b=yUHu/qK9+jjbAXz2TjWMklb85d6uAilpiqDHLISnvMSSVuf2/NgLZzYrFu5Z9jSFKy
         xgzfZ5eeqw4Z/QHKrf/5HRwyReD115lLrwkAj0hZHWfGVCSEH7vvw9gAiqUvWj0sH75L
         pRILBpfgsGjw0QmXCdJnnz02U3k3R8/nzsiirUmol7YZqo6G9KWEE1VioesAVPvbIBQO
         WxCXqKTVubidm7JQiMscRcdd84DfqO1h0ezhFHpH2ncdq0bwFcepHH4wtNva4nvs/eQB
         /HnA/XUSORy89ObHhvEVm08u9JnjemJL2qp6+o8que4Grg+SSRE7TCnqbOOCuYnRAxr1
         KDXA==
X-Gm-Message-State: AOAM5331N0S4UARYUrGmuOvNwEyh1N8SWDIP5NPRBaNuHFBON2ATZa9D
        6qXzy1GRYo3B0yNr51MWGpJHDg==
X-Google-Smtp-Source: ABdhPJz7+O43bQjw3Qx8+8pHjS0RYIso9TqOCGaesGbw3hn8vk87HPcB2H/bsqdEGcpfWIhWqakxhg==
X-Received: by 2002:a63:34e:0:b0:39d:8d96:a947 with SMTP id 75-20020a63034e000000b0039d8d96a947mr9503958pgd.105.1650272688180;
        Mon, 18 Apr 2022 02:04:48 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id m21-20020a17090a7f9500b001c97c6bcaf4sm16408071pjl.39.2022.04.18.02.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 02:04:47 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net
Subject: [PATCH v2 4/4] virtio-crypto: enable retry for virtio-crypto-dev
Date:   Mon, 18 Apr 2022 17:00:51 +0800
Message-Id: <20220418090051.372803-5-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220418090051.372803-1-pizhenwei@bytedance.com>
References: <20220418090051.372803-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: lei he <helei.sig11@bytedance.com>

Enable retry for virtio-crypto-dev, so that crypto-engine
can process cipher-requests parallelly.

Signed-off-by: lei he <helei.sig11@bytedance.com>
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

