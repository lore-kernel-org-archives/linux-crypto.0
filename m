Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1F1C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 09:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiDRJHY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 05:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiDRJHW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 05:07:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3B813DE7
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 02:04:44 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id s14so11866995plk.8
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 02:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qGycGFvEc/grEUwBLjN4FrsuSMK10Ph1TJa/0rHLB00=;
        b=SyqgyxdXATvl1tqV7yph+r4Ov29FnV+LuEYRD3cNUQbaEnKLSOmMXI7R9KN2yxV6OR
         LjumbVKsA9Bzn676oEXHvjHFXu1CDjVvtFd6wJxz/NOtDrfukBxwmRP2wwHWScH+hGgh
         hbWTgSDqaLGqkLhNPNYBZNqiR2ZnSJ5R3Mft1zvXK05rWjuGXmJMH3srjGuX4D834G/E
         YrASL7u82Pj5BEv1wNW/7TMbIO+uC9JFCvPe6cwD0wYb9NXyFVAw20WUL8v7oQrlwg+y
         ZoF45RADFCEW+dDKIM+plRx6Bloo7DSGc6vK6v/Ckv2g3S++SN80sfYi5E0N+MDY4bSi
         SKsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qGycGFvEc/grEUwBLjN4FrsuSMK10Ph1TJa/0rHLB00=;
        b=1OGnb2LNyvUOozTtXIkNCHzwyYEzvzEQR8ZgVrMErWHLBJB2mFtTtgBK84MKQ+EkgH
         WECcoeU2UwO7cmRIeQuH4xN/51Vu+GWuEkjazZuJPSTK8MLykVjBlQMC7mGR9mXq8Zg6
         WWVVwr9lfVNZMrTYk85Z+dqqV/8dpXYPRzJDsjmpGvDvQBQPfjje4F6J/SCF5JIvjITh
         pZYSmlfzpzoB+5CiZM3TPl406kp23QZ2J2AnsslZkH0KV8GdXIILL1ZMqXmTRuDGYWCi
         nbcpYeM52d2l11NmeiTp9Uwr80uBEeVBTr2McoBeX0CDm7KyFSu/OTFUQsbyEod5JoAH
         GrSw==
X-Gm-Message-State: AOAM532BPUKqfbZTPrKgCDNU1JZ1ESp4YOthraxvJnClESniYDarjTon
        CXllhxDiOd31SslKmD0T4EFZKQ==
X-Google-Smtp-Source: ABdhPJzl0keGE9CDZ9JEYQSKw/oJDMmcnJw0PJyud+pyqmk6lmwwYeDI+kw+cMA+ac6eAWEccD+O7g==
X-Received: by 2002:a17:903:40ce:b0:158:8178:8563 with SMTP id t14-20020a17090340ce00b0015881788563mr9800299pld.167.1650272683819;
        Mon, 18 Apr 2022 02:04:43 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id m21-20020a17090a7f9500b001c97c6bcaf4sm16408071pjl.39.2022.04.18.02.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 02:04:43 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net, lei he <helei@bytedance.com>,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v2 3/4] virtio-crypto: adjust dst_len at ops callback
Date:   Mon, 18 Apr 2022 17:00:50 +0800
Message-Id: <20220418090051.372803-4-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220418090051.372803-1-pizhenwei@bytedance.com>
References: <20220418090051.372803-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: lei he <helei@bytedance.com>

For some akcipher operations(eg, decryption of pkcs1pad(rsa)),
the length of returned result maybe less than akcipher_req->dst_len,
we need to recalculate the actual dst_len through the virt-queue
protocol.

Signed-off-by: lei he <helei@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index 9561bc2df62b..82db86e088c2 100644
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

