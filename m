Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4C9C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Apr 2022 06:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350691AbiDOGsJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Apr 2022 02:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343934AbiDOGsH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Apr 2022 02:48:07 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3945B0D0D
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 23:45:28 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ll10so6979546pjb.5
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 23:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eUPRo1W7HXTqRUmuszkjpWErgWaPyulrOyER93ew8mA=;
        b=2okK/vk4qQTljwBk1QYv8jssjKnLC1JWY6AXCN8hrTti/FJJ9mD+eNzxXeBbs+jshV
         AWEUMm0LmqJSBH/7058T7s6qFIKwViTM9mC5t3WNsTLJD21HO2MayRpqye5vrVeHx2Fk
         p1KyRNx72f3Lx/Q8nz+f2wJsYzFgsckeQXIMFOAZ+Pgb2CGZwskKTyUucasgjjisAtA7
         nxrk5PcUU0vN7wVsPu9vyZaarfvQO1dgcjhd5A3mxbr//0sV6vCZjwfbj/DzB7p7cbfN
         OH7l0ZGqqMf/TwdXfQKp8ots3JjEDr07bevn8Yh4I5I+nielXDSLVPOXLwupIMlP/RZ0
         9TQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eUPRo1W7HXTqRUmuszkjpWErgWaPyulrOyER93ew8mA=;
        b=AR8eLSyB06ypPGkDT7cfH0NQmGN4+6Q4KTvlJCC+husD+Fn4fZVwXtDOwIFSnLczxe
         IRlf0Sx2QUMt8w/fXKwfBRr8H30JhkF/q5kTXsqQl9F/+tzVJiuxwnWPpKriMWAJ6SCh
         J6gA7HAJCid6SuN8XzgUBWtsVSUSxEbrTnwZ8plrSMSMXOJHTlrBUMPCOlDYinFFPa/8
         S01t9QDbsI01cYJvFOCcrj+LyJSZWy0tqwF8+srZL1KBqMolj2/X4FZtwBegsP91Nhq7
         BJM+9zexNKuqIEBK36goZK1YbrvGJDutQIaveZgwQRTbA0GH59OuKF6Ck25GV1CjMoSF
         fsBQ==
X-Gm-Message-State: AOAM531C1//a3yzDr3DzZzZgbLN2m6KI13utWMYgtT93vZgsAI990biF
        RKvnftYE35ehEQ7m/TZP1r/VWA==
X-Google-Smtp-Source: ABdhPJxcShAeTRpf1TUgLEfubOBQZZ90/nwfksxqrBB43jrycMr1mv1lYJHhKntT+PHRDW956nfgSA==
X-Received: by 2002:a17:902:b10f:b0:156:612f:318d with SMTP id q15-20020a170902b10f00b00156612f318dmr50126545plr.143.1650005128147;
        Thu, 14 Apr 2022 23:45:28 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a00198800b004fab740dbe6sm1867385pfl.15.2022.04.14.23.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 23:45:27 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net, lei he <helei@bytedance.com>,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH 3/4] virtio-crypto: adjust dst_len at ops callback
Date:   Fri, 15 Apr 2022 14:41:35 +0800
Message-Id: <20220415064136.304661-4-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415064136.304661-1-pizhenwei@bytedance.com>
References: <20220415064136.304661-1-pizhenwei@bytedance.com>
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
index bf7c1aa4be37..7cd932c2d9ee 100644
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

