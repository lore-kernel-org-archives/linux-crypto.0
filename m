Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2147733A029
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 15:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818883; cv=none; b=tvXxTtQ7ijZBZ0unCg0O4t4kYuBthdtWdjWTu8CfJn730TeczJ7Nc5Gh8l2DflNUABTl9cAaSkxKU6ca8ut4QMsko2YAmit9GWZ6epQ45kg7nxdzvTHypv72BU+fw/TT8atvgfesLGoeldWarDGdI6/pWwjDfokLo51woCRJSVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818883; c=relaxed/simple;
	bh=qhc8y1t7l2U3SC+fCFgvoGHLPrbpQK1AUYxe4zLkDcA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AGX7ARF6ndbsYT+7JVKDZJHqVSDnyLVh1n5r48ApMqPkeOv3Bc3ynqEiLA2dokxNZudofspGZx3vkUn8VQPrqAqP0EDWwRMY6WP8U47wMFSDH7knGvLj8eDMhEMtQ/NwQZlPF78Y4BEXsQWKUko8xSLUgz2SMmtlW0sNRl9Bk2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=QVaZ/ITt; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="QVaZ/ITt"
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C784E3F9A4
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 15:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1784818877;
	bh=rmn4iCRgd2W2Q1p9YGZBP63yr2RQlfKU8yIifwUIXo8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=QVaZ/ITtT2vKBdsXssnfQ2y9lfFQMYoLL7gDgJbtvbbUGbHGG+1GrnYAR5GqOZniv
	 ZWmEqE6FpmNRpsaeSxZF2lCGJW1PJ/2KTNHbJQJGMAxoR7dFtU6YJ/2+h4SZmsZfT9
	 a4LuD7vOSVz0Mrwams/3IgAUm2ZJKLWuckuyUwWF6OPIjJErV+9KBO2eNpAkjsxRnV
	 JaawxXtUE+NmxncEUfatXsaKuG3dDaUwsyOMsdrms+JI4171iY3/a7H1+4ZuknQBrj
	 H0sIFbZncCisrQ6iujLK1sBtJ9YT8jRN7M2jNzc7RGRwdjPLSyabL6LpciMNHWK8VE
	 niDPBadUgll590YV+4gC/GivFkVQ1/eBlx7GN/kTQlIU4K1L/E/4jeHxKWRqHeDrxU
	 SUNYsVqE1we2y8GaEFL4zTXHxgN0IJLG9GilVXcU1xc8kxcTVmlWj4tjuD/l781EbW
	 acBAE6j0Katip2p3711f4pkW0jA98SIwhLEO2wYoXGAJ488l5oFj2nmNcuxM/1+FoC
	 3+DUs5i8lpHv894RU/hmzaajpb6Y6aMnIu4zq7nVrL6pb47PFv0YRQg7Td4Wrh7KUe
	 DCoI0OIVVK8alwtMMXn9K5IqnaA3KE7XAS1qx6gpe4+J5QGpiPqQJOkX60PdzNyP9+
	 +k2sc5phoLlxfcOO9C8rSTUw=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb5ea36f969so949626a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 08:01:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784818876; x=1785423676;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rmn4iCRgd2W2Q1p9YGZBP63yr2RQlfKU8yIifwUIXo8=;
        b=Q7tCB1F21ktEABQjRwhxuBoxjxK0OKXVwGTLEKBEe+h48gF0El+pImEKzvhKlPJTWs
         JalwkXQ1G4vikgJ18uo3nkIUb/hU9wZhZwnMFnfDngkmGJSolGI5U+U2on650S/wYZAt
         E/52KPqme5Frb+O1G3D0z1V/FMRIU9ReioRWyBSkJFXwEfcV36llkjHII5v/+5qrh5tL
         uqSUCf5EdoH51pgbeHqwvILCSv2X2wDbRjyj89Ogmna9WulOeuEjNyj+LS5V/i8FDRXp
         PNuPcW7UCtCHTrh6Rm8t3JLQZRpwTLOQUDGX7ypcFQ0KUePKqDqWOT4kp6ALNN+b5qKr
         hcqw==
X-Forwarded-Encrypted: i=1; AHgh+RrNEG+3VJV1B4Fx4pY/1UsQwHW2eCJ8f+S3RIP7UQJBsmuOFZsJrVJOGUCl+OYDZVS2CGnQ2bRsEoFuMjs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuIqnmIMglJSo67PuUQk0htPK4g1f+LhFpBzK9bGeMjdTTKR0m
	ROIiVp0zpijdIbjU6qWBxSrQ/MJeoEnCHtnizpWoGzTUHSqwrTDJ+C1BMdJJ7wGCB0JVD7iMPNK
	SELDQqeeEoFd/EduNKSwLF+Y7SDdg29JBmIPntypxXlnYSvyXFHH3y5xOJ/m4rPKI8WhmkYKtEx
	zvh35Zjw==
X-Gm-Gg: AR+sD139ic2ssKfJRzvSUdm2qZ21hIPTm89z3CNKH/n8vdUqS3wbv6Dg4vtX+0Ab+Z3
	NLMdtcHfPN25CaMQZtNpojSwJwkLQN0XZh57uWwUALTNBW0N2y7VVmq5kJKEr+XFCl21wNamtWb
	SHdJzyWseUJ3drQRiKpofTte3j6VIUV7Z7OZh0Fv3XfyhFHWAU36qPEpP4tuNYFReMaWEBx/tfF
	KBXpEBPS/9sSsRI9GyKqdEbjCe8rS924fX4sFRcruo1uLnUkilVz8vqsYQEXHj7n9ntHLkaclga
	JM5g97YNfHU0qRaA6d1Jqihtm0+DMcip+wMJRPY5r5JeIcTkRfPG9du755ENeQed9q/gF5HsgP7
	1Ujf0oGwe1+4=
X-Received: by 2002:a17:90b:184c:b0:38e:8021:2ea9 with SMTP id 98e67ed59e1d1-38ec652455cmr4000004a91.19.1784818875928;
        Thu, 23 Jul 2026 08:01:15 -0700 (PDT)
X-Received: by 2002:a17:90b:184c:b0:38e:8021:2ea9 with SMTP id 98e67ed59e1d1-38ec652455cmr3999946a91.19.1784818875309;
        Thu, 23 Jul 2026 08:01:15 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d12f267fdsm17077445c88.0.2026.07.23.08.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 08:01:14 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au,
	lukas@wunner.de,
	ignat@linux.win
Cc: changwei.zou@canonical.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: rsassa-pkcs1: fix in-place DMA aliasing in rsassa_pkcs1_verify()
Date: Fri, 24 Jul 2026 01:01:07 +1000
Message-ID: <20260723150107.33546-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rsassa_pkcs1_verify() passes the same scatterlist as both src and dst
to akcipher_request_set_crypt():

    sg_init_one(&sg, out_buf, slen);
    akcipher_request_set_crypt(child_req, &sg, &sg, slen, slen);

This causes the underlying hardware driver to DMA-map the same
physical buffer twice with incompatible directions (DMA_TO_DEVICE and
DMA_FROM_DEVICE), which is undefined behaviour on non-coherent
architectures and leads to intermittent cache-coherency failures.

    dma_map_sg(dev, fixup_src, src_nents, DMA_TO_DEVICE);
    dma_map_sg(dev, req->dst,  dst_nents, DMA_FROM_DEVICE);

On non-coherent ARM64 platforms (e.g. i.MX8 with CAAM), the
DMA_FROM_DEVICE mapping invalidates CPU cache lines covering the buffer
after the DMA_TO_DEVICE mapping has flushed them but before the hardware
reads the data. This produces a race that intermittently corrupts the
RSA input, causing the EMSA-PKCS1-v1_5 structure check or digest
comparison to fail with -EKEYREJECTED.

Fix by allocating separate input and output buffers so each DMA mapping
covers a distinct physical region, matching the approach used by the
predecessor pkcs1pad template.

The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
can be triggered when running the command below.

    for i in $(seq 1 100); do
        sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
        && sudo rmmod xfs || echo "FAILED on attempt $i"
    done

Fixes: 8552cb04e083 ("crypto: rsassa-pkcs1 - Copy source data for SG list")
Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
---
 crypto/rsassa-pkcs1.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 94fa5e9600e7..63bce31ac446 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -224,10 +224,10 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 	unsigned int child_reqsize = crypto_akcipher_reqsize(ctx->child);
 	struct akcipher_request *child_req __free(kfree_sensitive) = NULL;
 	struct crypto_wait cwait;
-	struct scatterlist sg;
+	struct scatterlist sg_src, sg_dst;
 	unsigned int dst_len;
 	unsigned int pos;
-	u8 *out_buf;
+	u8 *in_buf, *out_buf;
 	int err;
 
 	/* RFC 8017 sec 8.2.2 step 1 - length checking */
@@ -236,19 +236,30 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 	    rsassa_pkcs1_invalid_hash_len(dlen, hash_prefix))
 		return -EINVAL;
 
-	/* RFC 8017 sec 8.2.2 step 2 - RSA verification */
-	child_req = kmalloc(sizeof(*child_req) + child_reqsize + ctx->key_size,
-			    GFP_KERNEL);
+	/*
+	 * RFC 8017 sec 8.2.2 step 2 - RSA verification
+	 *
+	 * Allocate separate input and output buffers within the child_req
+	 * allocation.  Using the same buffer for both src and dst (in-place)
+	 * would cause it to be DMA-mapped twice with incompatible directions
+	 * (DMA_TO_DEVICE and DMA_FROM_DEVICE), which is undefined behaviour on
+	 * non-coherent architectures such as ARM64 with hardware accelerators
+	 * like CAAM, leading to intermittent cache-coherency failures.
+	 */
+	child_req = kmalloc(sizeof(*child_req) + child_reqsize +
+			    2 * ctx->key_size, GFP_KERNEL);
 	if (!child_req)
 		return -ENOMEM;
 
-	out_buf = (u8 *)(child_req + 1) + child_reqsize;
-	memcpy(out_buf, src, slen);
+	in_buf  = (u8 *)(child_req + 1) + child_reqsize;
+	out_buf = in_buf + ctx->key_size;
+	memcpy(in_buf, src, slen);
 
 	crypto_init_wait(&cwait);
-	sg_init_one(&sg, out_buf, slen);
+	sg_init_one(&sg_src, in_buf,  slen);
+	sg_init_one(&sg_dst, out_buf, slen);
 	akcipher_request_set_tfm(child_req, ctx->child);
-	akcipher_request_set_crypt(child_req, &sg, &sg, slen, slen);
+	akcipher_request_set_crypt(child_req, &sg_src, &sg_dst, slen, slen);
 	akcipher_request_set_callback(child_req, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      crypto_req_done, &cwait);
 
-- 
2.43.0

