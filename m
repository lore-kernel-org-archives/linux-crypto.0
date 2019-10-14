Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F7AC4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB1B1206A3
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RGejKaLh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfJNMTl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:19:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41588 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729776AbfJNMTk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 08:19:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id p4so3594764wrm.8
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 05:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TNWJxh1AFEyP6kvtb+pRqQQilO6T6qX/8rJmhhrHLY0=;
        b=RGejKaLhilxSPep1T8GKNwd/Q7C8PjNrda8JoEtErLf7kvnBTwZv6MAI6dLz7PtSfH
         Xc0ZbIH4yCgnqQF/QZ8kRKM1M9TlpkV7h9fuLbnZtRfjgp1zFtS7HhezB+ejfsfcd/ih
         Qc8kssabtPem2XldE14kn5hRxH1jWbl5rCbr//QNr6RXDHGwxoFk4uTvKhI/i4zKT21e
         n2tN07fsRM4ujN5KvVN44S8MhsHdWSXcqVRQ3qW8zlxl0l1E3Mh9ai+PDNQQQB8jnKob
         b4w1isX5e8XtW8yn9hwPDMsxD6N5vMOQDu84Ikr17EIgPRBXdz5Uz2hqvpUCq8YB2xBv
         NDfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TNWJxh1AFEyP6kvtb+pRqQQilO6T6qX/8rJmhhrHLY0=;
        b=H8muBDtzkpxlCxCR47v5FddHShJdmgF3YNSeJB1PtOFj4wTVIp9wzw/vvSw9Nk/Yu5
         vPQfp/ooVHRd9uJV2WV+YAdOm70KctBNu9YefagXLl9vx/OACkrVvZwOCKvfuek5ZtDt
         n1yhkqmZTT8K1OBp7fEvHAY1jq4UbDtewZrvUQBr1zP3ZK9xFSHL4Kwi7h1sCvE9iMIz
         LTEzDE3hnyJ9EpCyad71jt3rI0ThAVi/J7eanmRDmpV/a2CF98H2WqlmK2B5Jy/hvEBg
         +GpkEUACnt/J1P0LUtJ4OKS0XqFXCHF1E33yhEC5gLSa/pstUOsFAqH9nR5j0GRthL3f
         aB6A==
X-Gm-Message-State: APjAAAXwICN+A4NSZ4ygdcJwQ/DpmGPnLuFbfVBz0NOi97hnbHd0M9zw
        I1FPtXm+zPBZ9dGipgnXcb1C+iBPg0I0QQ==
X-Google-Smtp-Source: APXvYqzdHoaIj/OJ0cTfxhnuBYveQ6+FMY9yHkd5B79vGinI43FDRZSmVS9GILkDgWfdRJaVncgH/A==
X-Received: by 2002:adf:bd93:: with SMTP id l19mr25110646wrh.1.1571055578363;
        Mon, 14 Oct 2019 05:19:38 -0700 (PDT)
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net. [91.167.84.221])
        by smtp.gmail.com with ESMTPSA id i1sm20222470wmb.19.2019.10.14.05.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 05:19:37 -0700 (PDT)
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
Subject: [PATCH 01/25] crypto: virtio - implement missing support for output IVs
Date:   Mon, 14 Oct 2019 14:18:46 +0200
Message-Id: <20191014121910.7264-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to allow for CBC to be chained, which is something that the
CTS template relies upon, implementations of CBC need to pass the
IV to be used for subsequent invocations via the IV buffer. This was
not implemented yet for virtio-crypto so implement it now.

Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/virtio/virtio_crypto_algs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 42d19205166b..65ec10800137 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -437,6 +437,11 @@ __virtio_crypto_ablkcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 		goto free;
 	}
 	memcpy(iv, req->info, ivsize);
+	if (!vc_sym_req->encrypt)
+		scatterwalk_map_and_copy(req->info, req->src,
+					 req->nbytes - AES_BLOCK_SIZE,
+					 AES_BLOCK_SIZE, 0);
+
 	sg_init_one(&iv_sg, iv, ivsize);
 	sgs[num_out++] = &iv_sg;
 	vc_sym_req->iv = iv;
@@ -563,6 +568,10 @@ static void virtio_crypto_ablkcipher_finalize_req(
 	struct ablkcipher_request *req,
 	int err)
 {
+	if (vc_sym_req->encrypt)
+		scatterwalk_map_and_copy(req->info, req->dst,
+					 req->nbytes - AES_BLOCK_SIZE,
+					 AES_BLOCK_SIZE, 0);
 	crypto_finalize_ablkcipher_request(vc_sym_req->base.dataq->engine,
 					   req, err);
 	kzfree(vc_sym_req->iv);
-- 
2.20.1

