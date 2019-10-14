Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E606BC4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF812206A3
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:19:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WQDpJP0A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbfJNMTn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:19:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46699 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729858AbfJNMTn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 08:19:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id o18so19423767wrv.13
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 05:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n1CZfuSwOBWiTJLsXGGXKsTYggjtyZaieumQoTW6nsw=;
        b=WQDpJP0AB2+YAQR1rinmfn2OHo20KqKocZkKU1P4qbhMNSqnEQxDm7ujDtekTGWoKg
         iAbuFNCd7tNmXbdKJX/sQIpUbX06YbYtmwjKKZ3WZ922rxEvoe509/iRhkeFegq2XU+c
         IWfX6G9vZULPAHKXRvwYvuAq+JWfw+Cg0qn5gTclmfQd7d2jOLvBLptWubPpSGrPuJtm
         MyKVwdi30mvGTTs/ZDV4HKJRklkhKJoE5lqO9h85PuH6siyR4oBfyBHLdVyvcJMpgWSj
         wk2N1Fq9cHSSberQMlsNRrCGweZ3ZGhJUzYCN5i5C50rx1IkrHVOp1M4Y8HDMpyanxtd
         Poww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n1CZfuSwOBWiTJLsXGGXKsTYggjtyZaieumQoTW6nsw=;
        b=nIVD00BkTMhZwgansST4YDkf9g7AMOoCgc2qDWlETJ9aMv6evpkZuT2B/Wbjl3FN1Q
         sx2p1L3zyt2M1M38VpveGZH0YPhjimAeatRTqRVI4kmbPksyulPa83TUz75YiZ9Z9dds
         LMOfSM7e+P8ygA9u7hGsIrKoilpkfP/ejL0iFvSXf1IFL7nNzSZFZ4DXfFon12eNsDUy
         C/ozLqndzgHDDijvSZWMgLrrMVKGAmejqnfZpvqLssjbtk74HqFsrhYW0xQuC65bnBw+
         jO/pa099C8PmHBedN4/DGTi/9e+bat8ReTkuN/Nr+3JvdlgTpOYoD15hKQK/Y+C05bst
         E7YQ==
X-Gm-Message-State: APjAAAW20BW2SVd5gouDHA94FNhOU79PPz5Xi7E/yW79aRvGGD7+OX0s
        UscKTXlr8W66uU/WEUlSNRVtpftXRGapog==
X-Google-Smtp-Source: APXvYqzoEtqODKLCo2JUzVBBzE0BRowy8qYR0MKr1lrYu5U8xeIZMidm7JD1uPc3S36eCeyM0gJb8Q==
X-Received: by 2002:adf:dbcf:: with SMTP id e15mr26156311wrj.134.1571055579522;
        Mon, 14 Oct 2019 05:19:39 -0700 (PDT)
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net. [91.167.84.221])
        by smtp.gmail.com with ESMTPSA id i1sm20222470wmb.19.2019.10.14.05.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 05:19:38 -0700 (PDT)
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
Subject: [PATCH 02/25] crypto: virtio - deal with unsupported input sizes
Date:   Mon, 14 Oct 2019 14:18:47 +0200
Message-Id: <20191014121910.7264-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
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

