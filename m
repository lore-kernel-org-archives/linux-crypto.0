Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE79DC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  5 May 2022 09:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354399AbiEEJcy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 May 2022 05:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353472AbiEEJc2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 May 2022 05:32:28 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A588153B52
        for <linux-crypto@vger.kernel.org>; Thu,  5 May 2022 02:28:24 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x52so3191548pfu.11
        for <linux-crypto@vger.kernel.org>; Thu, 05 May 2022 02:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MWUmfRvGF2BB+VZsTwGLae04hlnLvJ88GBm4mvPdVfY=;
        b=H6GLIk6bwodWrBOYEDm4+3SJj4/BTDn+p3oSwWbxAEs9y8gq3fek8GOJlclMDdwUiv
         dHCe0nAEw4q60SaI6Vv69CYld5DHxwZSv1FTzqAUDuUvgWdtnsTq1bAWD7Rn/HJ9a65K
         MmWUiUEDQVYmZAMyzpzWK8VaqlxJ7HqHCyFFf5L8Plp4mUb5e3sOgAFADcTR/UxPEUvH
         rTgsGzYxMrdowQPHybdiBUZho2Kin9IpZLk7nE8sbllOLvFhPVlQ2SxocQd0wQ8HmulW
         61sQcCyCwlrSToHRrP8m9cP9k4vziMrARbTX2DIG1E39DPCD6eQ7KcerTR0hDdc7McPw
         w7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MWUmfRvGF2BB+VZsTwGLae04hlnLvJ88GBm4mvPdVfY=;
        b=gmr9x2ppma7yoR5NyV1AITrvuRnuN4cUUmFBw/S6Ca5igr+XxxpfakU1vw5G4OGHSc
         OH0JfbNIRzlyGq9pD5e/teqf/6MC9dyBeUxsCmw/7JOQE0VQQYsPHRwsz+O/TunAfWFz
         qgQP05nnL4BJBs7PCRWE5RNb5kqm+iH2Ei9hyDstieE3/R+SF9ElXMOcziKU5wdF3wzP
         TXGb5CQ7CMaMyrXbsC1hI796dwx7fN0x/EistU3wzHmZAHExevdsB5vjdrvMOsz5m3hA
         EUCpHdZM3Y2srEJ7SDo6Pz450/aOC+FZU6fRCVNguRousRVZaHhupSDZ/AUw8n0vIfP6
         p7ZA==
X-Gm-Message-State: AOAM530PPCpJchc97S/d60hKMRbdyHBHkunA+mhQxGAybRRp6pOEEhiz
        5nP1RMxWTnp+9VAhVZlTYLb7nw==
X-Google-Smtp-Source: ABdhPJy0arwU8vCS8L/uqGSWrM7EpznmQ61YconxXJuGXjqJbFk5NzLR7b0Un/RvHp3HP83OWpdBFw==
X-Received: by 2002:a05:6a00:22c6:b0:510:3c78:638d with SMTP id f6-20020a056a0022c600b005103c78638dmr7293480pfj.54.1651742904156;
        Thu, 05 May 2022 02:28:24 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id t68-20020a625f47000000b0050dc76281dcsm884224pfb.182.2022.05.05.02.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 02:28:23 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        pizhenwei@bytedance.com, davem@davemloft.net
Subject: [PATCH v5 4/5] virtio-crypto: adjust dst_len at ops callback
Date:   Thu,  5 May 2022 17:24:07 +0800
Message-Id: <20220505092408.53692-5-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220505092408.53692-1-pizhenwei@bytedance.com>
References: <20220505092408.53692-1-pizhenwei@bytedance.com>
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

