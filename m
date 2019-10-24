Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10090CA9EAF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D77F32084C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a9bSL+5/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502548AbfJXNYA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 09:24:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53490 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502541AbfJXNYA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 09:24:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id n7so2005778wmc.3
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 06:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n1CZfuSwOBWiTJLsXGGXKsTYggjtyZaieumQoTW6nsw=;
        b=a9bSL+5/vXArpFGMdZBpm2T2ibvGHxT0RE4psOfP7d5NBAT+S87j+/oqiBatWysEkL
         kn7q3XuaODmBXB+3LwnsntgHwm56Y1ztfBFP0yqKTcmfHlqkuDe8ovw1sA1hc5kd57JO
         u8Ak//10fgCr6Mm3FaEZuBQdKM3COSEvlFdzm8IC1x/y3m9Ihrv/yxQgxutnY/g5jcOt
         WHfH/KT8reM6VDTrsoDEvUnMxcTL43KH8aoYux8cYXKb0qOogFPlsZb/grPu9I3I2dRx
         R+15WXBQxw9Y9PECCW+oCJlXTjFa3ScZneGVhbiSeQ3h1CYsluF43MWS6chfD96dWXBc
         QQUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n1CZfuSwOBWiTJLsXGGXKsTYggjtyZaieumQoTW6nsw=;
        b=Pi7Lynn0OuIO1K0PePtpzz6MltyX5as/W3Me3Og5efUeDMtK51aIGtAm12R7WX2Z2x
         PJ1LS9svNbenMTVl+Ryf/B8N+RADuUHkj6bzBlSKh0rfokqCG925q4y3wNpB/b/VYtm1
         6I6ZC8fq5XxCvyGm5bkMUAQUzV0KEQ2RfN21fr3DcglEBms5FXdjk1Hs8SVBsYwAoEKt
         E8yiAWZBOGWWM03jQ9t4oSHuKkUwe6VWHmHq4q8vXiq77Dhs5HjQieihTZ/Nv9Dcqa5Z
         SCKyboQY/5xXd+htJnTnIJrJtIp9gVw8XPZ5GWUpwuUE4WTVMhi/c2zNfMZtcGvEfOQk
         JsUA==
X-Gm-Message-State: APjAAAW26rWUIjSeVkH2EPaFe7skz822SXk+JJKc9afCQSwcdjQmY+dn
        s3Bug57zb28kqSk/TKagjN1ONYXQ3TMeflM8
X-Google-Smtp-Source: APXvYqwHtc6EgZfQ0QDGwcZ2Q95eSng9l7ZYxmVHvCtz9rcd14RvSZ98geGqKgL1Tay0isfdqki/1A==
X-Received: by 2002:a1c:4489:: with SMTP id r131mr4687908wma.132.1571923436836;
        Thu, 24 Oct 2019 06:23:56 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id e3sm2346310wme.36.2019.10.24.06.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:23:55 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gonglei <arei.gonglei@huawei.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 02/27] crypto: virtio - deal with unsupported input sizes
Date:   Thu, 24 Oct 2019 15:23:20 +0200
Message-Id: <20191024132345.5236-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Return -EINVAL for input sizes that are not a multiple of the AES
block size, since they are not supported by our CBC chaining mode.

While at it, remove the pr_err() that reports unsupported key sizes
being used: we shouldn't spam the kernel log with that.

Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/virtio/virtio_crypto_algs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 65ec10800137..82b316b2f537 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -105,8 +105,6 @@ virtio_crypto_alg_validate_key(int key_len, uint32_t *alg)
 		*alg = VIRTIO_CRYPTO_CIPHER_AES_CBC;
 		break;
 	default:
-		pr_err("virtio_crypto: Unsupported key length: %d\n",
-			key_len);
 		return -EINVAL;
 	}
 	return 0;
@@ -489,6 +487,11 @@ static int virtio_crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 	/* Use the first data virtqueue as default */
 	struct data_queue *data_vq = &vcrypto->data_vq[0];
 
+	if (!req->nbytes)
+		return 0;
+	if (req->nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
 	vc_sym_req->ablkcipher_ctx = ctx;
@@ -509,6 +512,11 @@ static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 	/* Use the first data virtqueue as default */
 	struct data_queue *data_vq = &vcrypto->data_vq[0];
 
+	if (!req->nbytes)
+		return 0;
+	if (req->nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
 	vc_sym_req->ablkcipher_ctx = ctx;
-- 
2.20.1

