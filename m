Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A229E364959
	for <linux-crypto@vger.kernel.org>; Thu, 23 Apr 2026 11:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776943225; cv=none; b=Mu4n5JP8BIN9tBCF/ESXOtSjU/oxWfDQQL4PhmnL6scNXfanUd0LFQxWF3LlDhJP/hcpYikMufCzCycaXXZxQ85jRoWkfnTWz7PjSn1d8Sdlk2b49y3/THCiP+4xtOYzqPomKwPQz3kMWWVoISu2gt14GyKxYGCGKTzQ5pgIg1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776943225; c=relaxed/simple;
	bh=+1XyvQRM0gBy3IMiyOE5RaAvDDzH4OZ8Vq8cH5BT8oE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uvE+c7tZ25VwkXh+q0aA3Irer5yhLfpf9TQdxEjfYcCFrzUxmr1lBDlv/LjRiBO6XCmURLoXXvez6d/79SaLTUVuHbEra5HOF7S8ynUmQZz3gJWrLQb0OiN9bm7SZ0JC3B5hZGB1rCnXjBSkdT962QfFWjcpRm4a8C5nhyXp1pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SxfgClJ+; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SxfgClJ+"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35da2d35eccso4566006a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 23 Apr 2026 04:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776943224; x=1777548024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RwuJIm7Dw5jp31ncEc1KOiDX7dt/dDt8uIoQj49sz9E=;
        b=SxfgClJ+nu4PknWA/9Eycduk3SeUPlDKY/JUdeB0h45Gf2FHMEW7v7TlV9oVjIZSr7
         AufSlZvVU61Ls1wOzAwZzghtifHBji7volmd99HL+7AUMl6l65fTahmrl9dp0uI9sl5q
         5nh74crUhWSHCvG6QqCIfxUSOSgYhabY6XKmcnrQuJ3Ml5J1AGSkO7KGSLqCVHSBlpj2
         LNMpS3m1qKs/bxDxZbTRGwJ8iXa2edVLQPKeA76+FKtfoCw9zMJmmb6r96R082N5CAZu
         yD3ZGZFSfEgG01NIkXCUWcN1/J5c5XqXIda+uw5zZom0mYbQZqOWjHKOIWkG7gqT/n3Q
         XAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776943224; x=1777548024;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwuJIm7Dw5jp31ncEc1KOiDX7dt/dDt8uIoQj49sz9E=;
        b=b9m1R83HjOPMBoj0dSiToY4hWmU8rpKyncIrZ3VB2SMoguKggNejnS/Ks8koWMbBR4
         plUwBL37jm7JzIinwd530qRdN+xEX345hYWMz0X+OFJI9JJqi5R4QnUKHJLvzcEwEplP
         bUfbGkxNC+Y/7es/xkYHzTuf1vRPrAI2iI4WeM2Uxhye9KPT8+rbvEziDwtdPINK6i4d
         QMpUv61wTekAyzEQNPj9jcHl4/AIXPq//EoiajnbzVQUzRyZ2hx+mGNXE5cUnRFWVUmq
         LT7muIuPiJT+gSdSaLv+6McCIhheMY8HP23pZn5fNt0oCQ4eIFpfsFE+T67csHFeZPxM
         GYZA==
X-Forwarded-Encrypted: i=1; AFNElJ96PnUipELBtmQVBXRxFCooPAiWg+yox8EAt2lc4yQO5K6oKnShLDbBsiqpfY2CBYP+Pbv04evfrX51QsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC6pOaxuJF8ntIdRAcxvuNRQ7tEM3nCzTLwnlqsjIIrmgQy1H8
	s7IF4dQlPl3s7IVnKirJ1htzvnBEWorE+Im76Y2Ro6/GM12STWnC8p8b
X-Gm-Gg: AeBDietMqZUn/9qqhajx7U6G6l4WZzHZXktZ3ypBbeRrGglubqn+8e/z++3Vekn7Mde
	QsvwjMFFR78BhujU5Z7RpNriy+4EIG0LqYeZYngbxN88fM58binjFDvGox55SVFH6+r66OxLvnQ
	joYFALb/C3GFDfROvVlZ2r3oLQdxNhNBR8hBjH9yl3stX5BUpmh+p5zpLobMxfQVINd4j1nFi90
	FCBwxLE9zR8n0SGwzfEbYwHE+c/ZfdN0DsHxWZi73xx1fBWiJ92iSiiwwACVUGn9wfPXxzfHVPN
	6MxHxkZ/hosRvdXz4PJD1qNeXOlC4M2dDsBpre2eExZpd+zfW4pJdeh50Q7RdHiORZi4OuU5vEn
	lohTMF4y2a1Kpoy8gEHoI+UjFllsqEOPOn7YRL6rpbWgD6qphnAQZXDgT7IjHkQS/62F9n2Um+O
	P+TR2gReVrTZjAMXhZ64YttKEYkwnjogVK91Mx72ggG3UresguPrRGldGNwTXN9k8=
X-Received: by 2002:a17:90b:2243:b0:35f:bf4b:c396 with SMTP id 98e67ed59e1d1-361403ca5femr25738150a91.1.1776943223737;
        Thu, 23 Apr 2026 04:20:23 -0700 (PDT)
Received: from LAPTOP-CUCB24GH.tail9a93e7.ts.net ([175.159.176.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36141973c57sm19456388a91.14.2026.04.23.04.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 04:20:23 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Corentin Labbe <clabbe@baylibre.com>,
	linux-crypto@vger.kernel.org
Cc: Linus Walleij <linusw@kernel.org>,
	Imre Kaloz <kaloz@openwrt.org>,
	"David S . Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Ruoyu Wang <ruoyuw560@gmail.com>
Subject: [PATCH v2] crypto: ixp4xx - fix buffer chain unwind on allocation failure
Date: Thu, 23 Apr 2026 19:19:56 +0800
Message-ID: <20260423111956.185761-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

chainup_buffers() builds a linked list of buffer descriptors for a
scatterlist. If dma_pool_alloc() fails while constructing the list, the
current code sets buf to NULL and later dereferences it unconditionally
at the end of the function:

  buf->next = NULL;
  buf->phys_next = 0;

This can lead to a null-pointer dereference on allocation failure.

If the failure happens after part of the descriptor chain has already
been allocated and DMA-mapped, the partially constructed chain also
needs to be released.

Fix this by terminating the partially constructed chain on allocation
failure and letting the callers unwind it via their existing cleanup
paths. Also fix ablk_perform() to preserve the hook pointers before
checking for failure, so partially built chains can be freed correctly.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
v2:
- Keep the unwind path in the callers, per Herbert Xu's feedback.
- Terminate the partial chain before returning NULL on allocation failure.
- Save the hook pointers in ablk_perform() before checking the return value.
- Thanks to Herbert Xu for the review.

 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 25 ++++++++++++---------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index fcc0cf4df..5b90cf0fb 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -884,8 +884,9 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
 		ptr = sg_virt(sg);
 		next_buf = dma_pool_alloc(buffer_pool, flags, &next_buf_phys);
 		if (!next_buf) {
-			buf = NULL;
-			break;
+			buf->next = NULL;
+			buf->phys_next = 0;
+			return NULL;
 		}
 		sg_dma_address(sg) = dma_map_single(dev, ptr, len, dir);
 		buf->next = next_buf;
@@ -983,7 +984,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 	unsigned int nbytes = req->cryptlen;
 	enum dma_data_direction src_direction = DMA_BIDIRECTIONAL;
 	struct ablk_ctx *req_ctx = skcipher_request_ctx(req);
-	struct buffer_desc src_hook;
+	struct buffer_desc *buf, src_hook;
 	struct device *dev = &pdev->dev;
 	unsigned int offset;
 	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
@@ -1025,22 +1026,24 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 		/* This was never tested by Intel
 		 * for more than one dst buffer, I think. */
 		req_ctx->dst = NULL;
-		if (!chainup_buffers(dev, req->dst, nbytes, &dst_hook,
-				     flags, DMA_FROM_DEVICE))
-			goto free_buf_dest;
-		src_direction = DMA_TO_DEVICE;
+		buf = chainup_buffers(dev, req->dst, nbytes, &dst_hook,
+				      flags, DMA_FROM_DEVICE);
 		req_ctx->dst = dst_hook.next;
 		crypt->dst_buf = dst_hook.phys_next;
+		if (!buf)
+			goto free_buf_dest;
+		src_direction = DMA_TO_DEVICE;
 	} else {
 		req_ctx->dst = NULL;
 	}
 	req_ctx->src = NULL;
-	if (!chainup_buffers(dev, req->src, nbytes, &src_hook, flags,
-			     src_direction))
-		goto free_buf_src;
-
+	buf = chainup_buffers(dev, req->src, nbytes, &src_hook, flags,
+			      src_direction);
 	req_ctx->src = src_hook.next;
 	crypt->src_buf = src_hook.phys_next;
+	if (!buf)
+		goto free_buf_src;
+
 	crypt->ctl_flags |= CTL_FLAG_PERFORM_ABLK;
 	qmgr_put_entry(send_qid, crypt_virt2phys(crypt));
 	BUG_ON(qmgr_stat_overflow(send_qid));
-- 
2.43.0
