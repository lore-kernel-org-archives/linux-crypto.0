Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F34C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 03:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239388AbiCBDn1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Mar 2022 22:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239415AbiCBDnY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Mar 2022 22:43:24 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA874092B
        for <linux-crypto@vger.kernel.org>; Tue,  1 Mar 2022 19:42:38 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t14so537052pgr.3
        for <linux-crypto@vger.kernel.org>; Tue, 01 Mar 2022 19:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RJ7SOmE24IN5voTxxb2GBU71dQmksuFM00064oAmHe4=;
        b=U7ZqznmS1op+/KaI2hpBxG57ustImo02BzrQj6bgBtLI8dvn9ffPKtDqawnldGXy9E
         Kl3PxV0jFgg/djxjJEqT/Ur7W3AUNDaPJUvE2JVUFiw4/6KAj86VT4KXCxXLITt8l2jx
         2FsYXq1az2IeMkiiVAasVL/N72wMWKLtKpFIEQCgT0EvPFw5GAHBBlzGolPcEP6AMI4Z
         WvG8vGvL+iNA1Iw9QwJLpIvYpjrE7IqTwoDV7iIm+A7/3nvJ4GRAt+bK+CSLP7FxYEjL
         9UGsJBeIR/v1W3JogivT3jMSg7/JiN7kFOoFh8Bg9W76tRspJpWOa0Of7yTzWBhLJCP+
         zfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RJ7SOmE24IN5voTxxb2GBU71dQmksuFM00064oAmHe4=;
        b=5TbZJlSs6Y+vQzxW+aKR8I8K85XRnc1MNc1TScQZ6EbU/zLPpflgPlf2Q3Rsem4hU1
         c3lBERMhvH583eSAX5h+u925WVpftEO5A7RD/wEO4XDkGIj2YHh9HJtBGLfSggi3OjkT
         kNoXCu7rKhbZM+TqxLOLX8tpXsCe6fQB0pc4nHfr7H28TfpC94i8LBWVpRZ1eDheSAUn
         seLC1TXeVdaFM3lTwzoUHJ3vvn3Gy8L0ac21AReEx5l4Wg4rd1iYPKniQLCE5+rAkj3t
         IuD1ROuuUEyyuR962HfmN3qL5SqMk9yp/zPeV7zz6WCEiPT4oZU6sRmZZibSqfah3vZG
         97lw==
X-Gm-Message-State: AOAM5308Pt6crKskcZzg8aWVCkLNDO5dVhGTfGnlYshtde0RLC5qnMcJ
        wRtAEEBM6+sVPbe7VSpPmEKVIg==
X-Google-Smtp-Source: ABdhPJxEiW+ipwY11l3oml3I3IyQ/Fiktw3i7sAbvQ0T7S0UNpox+jSv/i+WgAhLOq6UadZzmRl5ZA==
X-Received: by 2002:a63:2786:0:b0:365:8a2d:327b with SMTP id n128-20020a632786000000b003658a2d327bmr24312602pgn.16.1646192558251;
        Tue, 01 Mar 2022 19:42:38 -0800 (PST)
Received: from always-x1.bytedance.net ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id gz13-20020a17090b0ecd00b001bc5defa657sm3358585pjb.11.2022.03.01.19.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 19:42:37 -0800 (PST)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, helei.sig11@bytedance.com,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v3 4/4] virtio-crypto: rename skcipher algs
Date:   Wed,  2 Mar 2022 11:39:17 +0800
Message-Id: <20220302033917.1295334-5-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302033917.1295334-1-pizhenwei@bytedance.com>
References: <20220302033917.1295334-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Suggested by Gonglei, rename virtio_crypto_algs.c to
virtio_crypto_skcipher_algs.c. Also minor changes for function name.
Thus the function of source files get clear: skcipher services in
virtio_crypto_skcipher_algs.c and akcipher services in
virtio_crypto_akcipher_algs.c.

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 drivers/crypto/virtio/Makefile                            | 2 +-
 drivers/crypto/virtio/virtio_crypto_common.h              | 4 ++--
 drivers/crypto/virtio/virtio_crypto_mgr.c                 | 8 ++++----
 ...virtio_crypto_algs.c => virtio_crypto_skcipher_algs.c} | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)
 rename drivers/crypto/virtio/{virtio_crypto_algs.c => virtio_crypto_skcipher_algs.c} (99%)

diff --git a/drivers/crypto/virtio/Makefile b/drivers/crypto/virtio/Makefile
index f2b839473d61..bfa6cbae342e 100644
--- a/drivers/crypto/virtio/Makefile
+++ b/drivers/crypto/virtio/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio_crypto.o
 virtio_crypto-objs := \
-	virtio_crypto_algs.o \
+	virtio_crypto_skcipher_algs.o \
 	virtio_crypto_akcipher_algs.o \
 	virtio_crypto_mgr.o \
 	virtio_crypto_core.o
diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index 214f9a6fcf84..e693d4ee83a6 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -130,8 +130,8 @@ static inline int virtio_crypto_get_current_node(void)
 	return node;
 }
 
-int virtio_crypto_algs_register(struct virtio_crypto *vcrypto);
-void virtio_crypto_algs_unregister(struct virtio_crypto *vcrypto);
+int virtio_crypto_skcipher_algs_register(struct virtio_crypto *vcrypto);
+void virtio_crypto_skcipher_algs_unregister(struct virtio_crypto *vcrypto);
 int virtio_crypto_akcipher_algs_register(struct virtio_crypto *vcrypto);
 void virtio_crypto_akcipher_algs_unregister(struct virtio_crypto *vcrypto);
 
diff --git a/drivers/crypto/virtio/virtio_crypto_mgr.c b/drivers/crypto/virtio/virtio_crypto_mgr.c
index 1cb92418b321..70e778aac0f2 100644
--- a/drivers/crypto/virtio/virtio_crypto_mgr.c
+++ b/drivers/crypto/virtio/virtio_crypto_mgr.c
@@ -237,14 +237,14 @@ struct virtio_crypto *virtcrypto_get_dev_node(int node, uint32_t service,
  */
 int virtcrypto_dev_start(struct virtio_crypto *vcrypto)
 {
-	if (virtio_crypto_algs_register(vcrypto)) {
-		pr_err("virtio_crypto: Failed to register crypto algs\n");
+	if (virtio_crypto_skcipher_algs_register(vcrypto)) {
+		pr_err("virtio_crypto: Failed to register crypto skcipher algs\n");
 		return -EFAULT;
 	}
 
 	if (virtio_crypto_akcipher_algs_register(vcrypto)) {
 		pr_err("virtio_crypto: Failed to register crypto akcipher algs\n");
-		virtio_crypto_algs_unregister(vcrypto);
+		virtio_crypto_skcipher_algs_unregister(vcrypto);
 		return -EFAULT;
 	}
 
@@ -263,7 +263,7 @@ int virtcrypto_dev_start(struct virtio_crypto *vcrypto)
  */
 void virtcrypto_dev_stop(struct virtio_crypto *vcrypto)
 {
-	virtio_crypto_algs_unregister(vcrypto);
+	virtio_crypto_skcipher_algs_unregister(vcrypto);
 	virtio_crypto_akcipher_algs_unregister(vcrypto);
 }
 
diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
similarity index 99%
rename from drivers/crypto/virtio/virtio_crypto_algs.c
rename to drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index 583c0b535d13..a618c46a52b8 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -613,7 +613,7 @@ static struct virtio_crypto_algo virtio_crypto_algs[] = { {
 	},
 } };
 
-int virtio_crypto_algs_register(struct virtio_crypto *vcrypto)
+int virtio_crypto_skcipher_algs_register(struct virtio_crypto *vcrypto)
 {
 	int ret = 0;
 	int i = 0;
@@ -644,7 +644,7 @@ int virtio_crypto_algs_register(struct virtio_crypto *vcrypto)
 	return ret;
 }
 
-void virtio_crypto_algs_unregister(struct virtio_crypto *vcrypto)
+void virtio_crypto_skcipher_algs_unregister(struct virtio_crypto *vcrypto)
 {
 	int i = 0;
 
-- 
2.20.1

