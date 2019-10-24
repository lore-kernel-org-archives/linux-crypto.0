Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDB0CA9EBC
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82C6A2166E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:23:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S2eThVk8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502549AbfJXNX7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 09:23:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36612 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502548AbfJXNX6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 09:23:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id w18so25541016wrt.3
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 06:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TNWJxh1AFEyP6kvtb+pRqQQilO6T6qX/8rJmhhrHLY0=;
        b=S2eThVk83dKO5Bwg3yDm/gzVGNto7qsth4WMLLOmiYJINz7Qibs5lDhZH4pMHelfff
         UI55mx/5I/os0vKVwqaNYzvodYmhm3q7elBYzBwxmPBD/GiwrKVqX7DFhWZBhSZqTfDb
         KjuRWogf+5wecIavxAAFgv75+yn7OshRyOO5VWsaZJg6YRdu/S6wV2oaeWIGvn7xkyT2
         GYlxYl4QmaiC54ujOPw1nrH935qPBMI4BffDjb+GHywDtacfw4evwSNKQ7ue/25jsr1U
         TWuU7+hKvJpl0M+XfxDx5PBJ128PVg0jtARNCF0ugFpEeUzQLDYVTl90UMFXe0QRcLoa
         i6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TNWJxh1AFEyP6kvtb+pRqQQilO6T6qX/8rJmhhrHLY0=;
        b=iOIzO0Yy8nS4SqKMHoCUpFTSvsH0+LcueTJ+9Oip7bmrcJPMcAYEM3tronKhJD9Q8y
         /23PdLs71prA5U04ij7CBiyHObVr+TsE1BguBnos19Sdvji31NkAFUIB4YhV6mS3klUp
         l1+4sQXmH9DUNKXAd7kmG8xytSz/Kb6ltajRvhQuvVsN8JUiFOBUH9CxqDH7CpIIsqg2
         M9rgRi+TroltzUXDvwCka9prsenAEfJpFJRKNoFXjvtuDuznQUnPSDZSeZdAbvACtrgg
         nDAaGsVdPLkM0LDsw4Xg6drmCiNat3Xv9T8X5IfA8EQdM7zWqLECJ2BiU2VkDstvcfN3
         sJzQ==
X-Gm-Message-State: APjAAAVaENivq1ZGs+FXpg0mfulqOW8EuPmNJWLQRztPOAvFMuLyQIqG
        +n6Z8/kYGi6mEuZpL2MVTJsnFnPOA/7ypGQQ
X-Google-Smtp-Source: APXvYqyc+CLRulk3KGzezXZq5tnbXiDOqAyJFEZa5vrUyaKiixpSFHdiZydqrTrm/pESPS4zfHYTfQ==
X-Received: by 2002:adf:e886:: with SMTP id d6mr4021372wrm.188.1571923435313;
        Thu, 24 Oct 2019 06:23:55 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id e3sm2346310wme.36.2019.10.24.06.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:23:54 -0700 (PDT)
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
Subject: [PATCH v2 01/27] crypto: virtio - implement missing support for output IVs
Date:   Thu, 24 Oct 2019 15:23:19 +0200
Message-Id: <20191024132345.5236-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
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

