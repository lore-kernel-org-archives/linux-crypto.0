Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665EBEEA8
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 04:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785903566; cv=none; b=oK4p5DARNy5dEiF7NZO4dcg4MPqEJYxgMD/5cM1+IHpMdQooyOW8vvhEd5kg4ZcX8VZneou/uTDncY+Ug+JRuVW3CCzNFc511zZCCcf6THDQvR7iFY03NFbU5sfuuMLvvPN259xP/qB2RctSM6lTrJqhKuLCgxYnC+9McwUPH2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785903566; c=relaxed/simple;
	bh=acdSyytHjwZTJFehevO0SuRxzkFkKqkqGATugYLlyjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KqKvFZiwUQLMDJ5+S0swjDqviKVPYh5jPQZbzkuaUs9lDjBm6ujmCEIfJFBd6pCEmvTYkt6BSkZzE/86rUq6h6i6LAdavb9VuLQwKcRR/emB7gQtlGfmVp12Ocnqfmo9/oi9ExQ361OEEuSd31dnsteSqxyfHY/MSbb9e3kgG2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=J2BwAufe; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="J2BwAufe"
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 176023FBAF
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 04:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1785903553;
	bh=IotapiTX6AHa/b6BpPv3QCPlwle1thAL9RRjZLrSjGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=J2BwAufejxcLuqLbAhei0bWSxAaRh3gGyRyDIm9j6zYHLmfJhr/awy+bpEM/LkxV+
	 dd6w7t1tGKYIHD0LmDaEEo1wfAeS56/kaWdGu6lsUVOU5JktdzqW5T0Ja6kLEwCSH+
	 lhwutgYW/J01NSTOHh02ZE+BObDfgb+0KQ03/8HriYd1QF2+G4H0G10SAmeRXAD+zZ
	 Cx+U7TYCpe5vwSa3JP8faym99szjRXPgpeUln+8WDhImovQRBwg11LQRIa76FvXRlv
	 EpFAZ2EsqSifzjTIKpbkskzgPdmHF23pxbWHDg78n+SkRxNiBWsRxSNyaNiLPA7eKl
	 DiVzM9RY0LCXYs2gph+tfYNkSbveE1rvG6xuThKRQPmBjfMuxEjegcLt00cainCWFU
	 H3P3K69YfCdpDNCamMfrvsmBbZUF2uvE4f0ZXEc6svQC9EoQDRuGP/kdvEeOLImlye
	 RPyEdzhrpFXS3eE3be5TenfuCzETaXl8laOajI3qmqSnhqsbHmMWdCZg0fipF1cfNK
	 /mtRLMqE1K51tP9YaE35QdiLV2+nsAWZdRpup+ciLsLo/SoYz9Zk6TDeNr4cIpOl1j
	 bszNIIwMHIhtfaBiQ4ngwtCSS4pmvgMkL86pkQZogiOkWM7uOY/eFa17SQjxkSGZky
	 +O/hh478AYlJLbOlhxWTFMwQ=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cee1ec30f2so7263555ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Aug 2026 21:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785903551; x=1786508351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IotapiTX6AHa/b6BpPv3QCPlwle1thAL9RRjZLrSjGM=;
        b=BdslJQ6m3cE7kqBVs5PO2fZV17A74INk12hZbRU+iDEO+XRW+lR7ozVsofBk2ZhBTm
         24TfhjEDoUnYQWE8KIR9SNvN9MY54u5WwBaa0SuycHqY2bjDtHMVp0qtNJYOvJegYEm3
         wAWHUsnC5trwYq17x0KAMgWjPgHXHqrGTRBynPJ4+SwiCdpyOBpUAhUDxEFjg7R+lYKz
         luB7JgHKt38o6wRJdRXvJ7WAWNbgf4jrzX13X27dL3h7RNVGBT/HA4L2pfwbnB9sb6wQ
         u4yq3hx+M5QRy20ue2t792vH05rVGSq9px/0GMAdcWTphAmvm9EeS4UDx9xOHuHLKyXv
         A1dA==
X-Gm-Message-State: AOJu0YzC4p7rm8arvFfUPa7LgQZWpKsDHgq9uGkdFo7pDiLXtr4UQoe2
	fYuiwWvd4VsXo0tyVpXZIu/B0gIrXDUCd3Czbg6Egpwgm7EwrZXUHVnMp43EC1Pxfyd2xYY0poh
	yuCvXHJ2HfLONMPmMWA304sy2fTpTVeFSdqV7YA2hqNMvIXZl/CIhKUygyb3ts9dbAI4bby6bSQ
	Ek40K1PA==
X-Gm-Gg: AR+sD10RQ5XZ1PnHbekUiQpo0Douc3thx34VsBBcU30kGb6qJ4d3MRS6rkNIqjMYX4M
	7EkfqBU8Mk3jhO2m4cR2dqDOlB7dNR2/VL8zQsz14hUgoHy7dx26zQXhbI3C8qXrwJvBJJluVPi
	gT5UY8FEJGuDvYV81nagf8DSeJdD7PpT1FLq/gYZlNIUGe8u6PaxHt2+VGLKanuE0GTtphvfCzs
	Ux7Ywyi3NYYZbKj9Ev+yTurbEwSJb/dF3QhQLMsaLv1HKvQSZl2/J7isocinRXtQzHN2WQzAwVP
	Xm8jxzRQrsz+PVH2jAP0mlvF7NurW/cbSxFz1ii+bJI8mQey/adcbnqyUkRx3W9RQaZYz1LMamo
	P1WHlWVnYRPI=
X-Received: by 2002:a17:903:1a6f:b0:2ce:d957:59c4 with SMTP id d9443c01a7336-2d0ca7afcb6mr33854465ad.6.1785903551086;
        Tue, 04 Aug 2026 21:19:11 -0700 (PDT)
X-Received: by 2002:a17:903:1a6f:b0:2ce:d957:59c4 with SMTP id d9443c01a7336-2d0ca7afcb6mr33854155ad.6.1785903550657;
        Tue, 04 Aug 2026 21:19:10 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31586402e53sm15842163eec.11.2026.08.04.21.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 21:19:10 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	changwei.zou@canonical.com
Subject: [PATCH] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Wed,  5 Aug 2026 14:19:02 +1000
Message-ID: <20260805041902.1575170-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CAAM RSA driver directly DMA-maps the destination buffer supplied by
the caller via req->dst without checking whether it meets the cacheline
alignment requirements of DMA-incoherent hardware such as i.MX8.

On CPUs with non-coherent DMA caches, if the destination buffer shares a
cacheline with other data (i.e. it is not cacheline-aligned), cache
writeback/invalidation during DMA can corrupt adjacent memory or cause
stale data to be read back. This manifests as intermittent -EKEYREJECTED
errors when loading signed kernel modules.

When any segment of req->dst is not cacheline-aligned, allocate a
single contiguous aligned bounce buffer covering the full dst_len,
redirect the operation to it, and scatter-copy the result back to the
original destination once the hardware has completed the operation.

The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
can be triggered when loading signed kernel modules:

    for i in $(seq 1 100); do
        sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
        && sudo rmmod xfs || echo "FAILED on attempt $i"
    done

Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
Assisted-by: OpenCode:claude-sonnet-4.6
---
 drivers/crypto/caam/caampkc.c | 66 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/caam/caampkc.h |  6 ++++
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index cb001aa1de66..70300182f2ad 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -59,6 +59,37 @@ static void rsa_io_unmap(struct device *dev, struct rsa_edesc *edesc,
 				 DMA_TO_DEVICE);
 }
 
+static int do_rsa_bounce_buf(struct akcipher_request *req)
+{
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
+	int nents, err = 0;
+
+	if (!req_ctx->bounce_buf)
+		return 0;
+
+	/* Copy from aligned bounce buffer back to the original destination */
+	nents = sg_nents_for_len(req_ctx->orig_dst, req->dst_len);
+	if (nents < 0)
+		err = nents;
+	else if (sg_copy_from_buffer(req_ctx->orig_dst, nents,
+				     req_ctx->bounce_buf, req->dst_len) != req->dst_len)
+		err = -EFAULT;
+
+	kfree(req_ctx->bounce_buf);
+	req_ctx->bounce_buf = NULL;
+	req->dst = req_ctx->orig_dst;
+
+	return err;
+}
+
+static inline void rsa_bounce_buf_done(struct akcipher_request *req, int *err)
+{
+	int cperr = do_rsa_bounce_buf(req);
+
+	if (!*err)
+		*err = cperr;
+}
+
 static void rsa_pub_unmap(struct device *dev, struct rsa_edesc *edesc,
 			  struct akcipher_request *req)
 {
@@ -138,6 +169,7 @@ static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 	rsa_pub_unmap(dev, edesc, req);
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ecode);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -181,6 +213,7 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ecode);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -291,11 +324,32 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 				     req_ctx->fixup_src_len);
 	dst_nents = sg_nents_for_len(req->dst, req->dst_len);
 
+	req_ctx->bounce_buf = NULL;
+	req_ctx->orig_dst = req->dst;
+	if (req->dst_len > 0) {
+		struct scatterlist *sg;
+		int i;
+
+		for_each_sg(req->dst, sg, dst_nents, i) {
+			if (!IS_ALIGNED((unsigned long)sg_virt(sg),
+					dma_get_cache_alignment())) {
+				req_ctx->bounce_buf = kmalloc(req->dst_len, flags);
+				if (!req_ctx->bounce_buf)
+					return ERR_PTR(-ENOMEM);
+				sg_init_one(&req_ctx->dst, req_ctx->bounce_buf,
+					    req->dst_len);
+				req->dst = &req_ctx->dst;
+				dst_nents = 1;
+				break;
+			}
+		}
+	}
+
 	mapped_src_nents = dma_map_sg(dev, req_ctx->fixup_src, src_nents,
 				      DMA_TO_DEVICE);
 	if (unlikely(!mapped_src_nents)) {
 		dev_err(dev, "unable to map source\n");
-		return ERR_PTR(-ENOMEM);
+		goto bounce_fail;
 	}
 	mapped_dst_nents = dma_map_sg(dev, req->dst, dst_nents,
 				      DMA_FROM_DEVICE);
@@ -368,6 +422,10 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	dma_unmap_sg(dev, req->dst, dst_nents, DMA_FROM_DEVICE);
 src_fail:
 	dma_unmap_sg(dev, req_ctx->fixup_src, src_nents, DMA_TO_DEVICE);
+bounce_fail:
+	kfree(req_ctx->bounce_buf);
+	req_ctx->bounce_buf = NULL;
+	req->dst = req_ctx->orig_dst;
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -394,6 +452,7 @@ static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
 		rsa_pub_unmap(jrdev, req_ctx->edesc, req);
 		rsa_io_unmap(jrdev, req_ctx->edesc, req);
 		kfree(req_ctx->edesc);
+		rsa_bounce_buf_done(req, &ret);
 	} else {
 		ret = 0;
 	}
@@ -706,6 +765,7 @@ static int akcipher_enqueue_req(struct device *jrdev,
 		}
 		rsa_io_unmap(jrdev, edesc, req);
 		kfree(edesc);
+		rsa_bounce_buf_done(req, &ret);
 	}
 
 	return ret;
@@ -747,6 +807,7 @@ static int caam_rsa_enc(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -776,6 +837,7 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -805,6 +867,7 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -834,6 +897,7 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
index 96d03704c9be..efad91d6058f 100644
--- a/drivers/crypto/caam/caampkc.h
+++ b/drivers/crypto/caam/caampkc.h
@@ -103,6 +103,9 @@ struct caam_rsa_ctx {
  * @src           : input scatterlist (stripped of leading zeros)
  * @fixup_src     : input scatterlist (that might be stripped of leading zeros)
  * @fixup_src_len : length of the fixup_src input scatterlist
+ * @dst           : destination scatterlist backed by bounce buffer (if needed)
+ * @bounce_buf    : DMA-aligned bounce buffer for destination (or NULL)
+ * @orig_dst      : original destination scatterlist (before bounce substitution)
  * @edesc         : s/w-extended rsa descriptor
  * @akcipher_op_done : callback used when operation is done
  */
@@ -110,6 +113,9 @@ struct caam_rsa_req_ctx {
 	struct scatterlist src[2];
 	struct scatterlist *fixup_src;
 	unsigned int fixup_src_len;
+	struct scatterlist dst;
+	u8 *bounce_buf;
+	struct scatterlist *orig_dst;
 	struct rsa_edesc *edesc;
 	void (*akcipher_op_done)(struct device *jrdev, u32 *desc, u32 err,
 				 void *context);
-- 
2.43.0

