Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46927C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Apr 2022 06:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343934AbiDOGsK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Apr 2022 02:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350718AbiDOGsI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Apr 2022 02:48:08 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC526B0A68
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 23:45:32 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s137so6664528pgs.5
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 23:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ouz4DgKg6HX7//LGRrUD97CctBPhdyzV/9EeFTiygxk=;
        b=gMCyNTTL33kI18vJdBqOu9Mcm2fImvGdxj+ka3vkQktHDiY/CK6mvTSSga/VonfgCK
         G2yDrY4zAQ73dGXaCnliYP1Sy/I4SgZ0iyzTWjhjjHSEigW4fxdNA2tP2Wf0uxbksfhX
         cBHCROmEIoL5iGVlxzgLAUEjeRiwP80HJL4kjIiu0Ul8xGUMQGmqpnFWq7dE7QrLdKSO
         69iqyiKk38F14+E73N4tvDHBGN2U4xpNoI5fXGuTfLl7tLH4+PRaN5ohLpVXe45yFSXv
         GER/mPzklCwMsqFB3YjPtmkoDrHVR4kVx5qMb1cFyLLTHiTjMubqehbQDnte90iuhh6h
         Bb1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ouz4DgKg6HX7//LGRrUD97CctBPhdyzV/9EeFTiygxk=;
        b=IT8l1V9Zl9CXBuiPEtMsfycwkzFcNKHwhu9zcptFYMicKUsvlrxUthLHHF5ZRxahzn
         DM6karueglMlcYitQAjECuW+qP0no8M/evvnemgFtFU3to37XHATkif2DDg9npjuqFP+
         ojIZkGgYUJ1udgcss8EIUn3OfLKf9qWNUXQVw3iAnLrrFbGSltxoTMb7kcMP07Iq/0aK
         +mt+3bnGQ0o1eS9QrsNorUBJ8NOsPx1gYS5xY+lmOFYGDrW8yEashwD5hkTBZZobQm6E
         FyJQ3Hs1ORLALZTf5Cd6+x/f3Z2PHVrkOviqOh5UyG5mOO2GnAoqHCubPk/Bc+UYycsC
         rHRg==
X-Gm-Message-State: AOAM530JISjZEk9g49lmaea6fNj+W8P84f9HKwFERODuDuUWEfRKDjr2
        ur7VTN5ilY749ofye1fKl4hlnA==
X-Google-Smtp-Source: ABdhPJwyfNEEO9oK4pBktYn2c0uxMeRu2wWbIGD1BpxdATL+9+KfkFN82SS1+bpSVF2rQMXvUC8AAw==
X-Received: by 2002:a63:6a88:0:b0:398:54fb:85ba with SMTP id f130-20020a636a88000000b0039854fb85bamr5311202pgc.88.1650005132521;
        Thu, 14 Apr 2022 23:45:32 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a00198800b004fab740dbe6sm1867385pfl.15.2022.04.14.23.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 23:45:32 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net
Subject: [PATCH 4/4] virtio-crypto: enable retry for virtio-crypto-dev
Date:   Fri, 15 Apr 2022 14:41:36 +0800
Message-Id: <20220415064136.304661-5-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415064136.304661-1-pizhenwei@bytedance.com>
References: <20220415064136.304661-1-pizhenwei@bytedance.com>
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

