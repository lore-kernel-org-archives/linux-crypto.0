Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074A33C4B93
	for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 04:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787288187; cv=none; b=nwsy/4JwNOBWRlAHjH42wz5vtw76/yOUkjJofmZL8IRh8mJj3bimpMYxO4kBFGbkdTc4kIL1U5+0xbCc3sIlorPHuhhkl65VBKGktLZmKJENFccZwx2FRPuWURkTkD/10hjFXlA4zx9LlxkIsGpO7tZRbEV92uaJUC6ZO4APOPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787288187; c=relaxed/simple;
	bh=V7Z9H9oiwaKPz94p8f09aZT6Dm4cOFU/0XbPl/jd4zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNKM+4J2PmF90I/4YwAIm+mRFBX1mAti5V/0YAgaQMJnsSoBTHMQsILbvdrH0zul03z+Lx9P6mCnDBzEbb2K2I84o5YrCZVivPTmaEsXYD1UCi+kv7VtD4Gn3rZQY+udPA0rIwovrOQz/rglmVQG3zKYD2JGWNCwGPjMuVFy/q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=PWWgrY3q; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="PWWgrY3q"
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B0E6F3F0D2
	for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 04:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1787288174;
	bh=AI1sq5q1K9dh5wmYC3SNv2bg0usWJqlItyrFzBnnDRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=PWWgrY3q6NJpiVvoCTGoC+0dqnaxRx4VXws/fJbECuECmD4GaUMFpHUheXgzXJGg1
	 X+6mhga62YY1avgaYjakpT+310KGtpkT8QKPDBv4KVZy8bWRee1gn3tLXG4iYFXOr1
	 u7le3+WXyOTYZJuDH2G94xRVJHeAoUeOawuZnAgjb4NcJya8mhtmsZEtBYCaNLXZub
	 vdheKzhHTp32RUtQ15CE3SqETrLZCrO/pLcS0mH2ZKCy0/icQRbGZXguURRJFSOGts
	 yif2ys8UaT3X1q1rkdXXXnNAMXd6c0FHekMTZtSuSpLByGHNhyLwfXWhl3ldrFXwcI
	 5SfNYjR1aMRH555pz/1DoXZ7/CZ+5rX/SC+R6xbcjIfrqKQ+RkMDxwhA0YRaHzihIx
	 80q1b5MNmZxlPRhfRmHF20TCzwHbxweP99lU2ippFEsnKHW2sXkoEQT3Pb14FLCSCq
	 45rcYOpAyjc+/A0/ClcQ3uUr6AZezNZAQOPuhT6ryFNhggUcfPHq6DilTVUWD+PAvX
	 DYQAcakWuQqhSRufhnfEqVaMAFCD9pc48f86O1XmGEN6BDkp5gbGHFySznhjhThg5Y
	 56ydnftODs68Akcyd9vzmKs0QIk+NBIsXboaiP1HCi+PDMnV0Flapmy7xpB0kvYrdg
	 KLC+tbIFC+SQQzCRe+I8WVfE=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f5ac7354dso869426a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 21:56:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787288173; x=1787892973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AI1sq5q1K9dh5wmYC3SNv2bg0usWJqlItyrFzBnnDRg=;
        b=mOYfh+Q1kp6VtWsLM5uKjhF+uO4s69Ps5YYQqi5QMfMJIIj7rMZcZMgEEvrxU0QU7x
         OxsLTOmww6AFurgmwoZO0P3eCQwG4PuJGcCuR7yMTB5Ntan9+MrxDdK1wvuR9SiD2fzx
         HiBYLpP9v3GhJKbTR460lZAy1Zb12Kfsahiyr9qiDi2ncwpUhpMBDPJv5TJjZHS0YEe6
         wztXskg267T1kxD27nNhwXSeHJofXiAQdKJ6IFymKVIxCvhkFGT2xHJbZs40FAnR4Z/Q
         HdeKz705sgnrTgedxsi564KJ11p0UakqIHGnvJy9pIIYjfMHV0nv6lnBYXwm9OyrgsKe
         PGjw==
X-Gm-Message-State: AFuF++licBMQTw/RMDGiKHIlpyNH5F0rs9tvenOHrRxFVwczuMlbrRwm
	GIChhsKgq3ogwn1dmrO0dV3xr74617XsJUC9hVPsBPxkRpl1fDWubL5CW6h/MdgIE5E0WjXKlDq
	2cyH+M5ChtNl9pUTwTkbb91DIvzZTp4XnvTE25QeOq3QOpqfDIBdHfJtgu4sQSGwixLMk5TtfwA
	ezyM0C5A==
X-Gm-Gg: AR+sD10Syxq/pV3mw5Ps4mAzNjs1Jb1PFUkxIBeG2JxW3onrz0E+GVFD/m6vm9fJTzf
	prGVfuSLagqZkzRm3r800oCcHAgwMr8NX+MjAmACPdDBs9WPn5pSwWwFqiKCGKeF7Vw95El4z0R
	zy3ZlVoLTsjyV6Jgw6spMeYpqwPa46SkYaCRhEQOUCHAnR1OxFoSx5fJ7P/7+4pLr4JpxyZJbxz
	/jvLNekAlcJRQ9CN38GpjBIbnD/fxlpYLm9dpsjsLT0tQ4BFd4M2hWunW39nc5XOZGh/QT10dU/
	VKwbMBFtaQVeDTcGi9sIX71I8Rw53stcpodCBDQCROn3ViVxF5sPoLu9n4oRHWg/lVyQAqdB/Jp
	YKtyBcxjykdQ=
X-Received: by 2002:a17:90b:1a90:b0:37f:bfd6:8b40 with SMTP id 98e67ed59e1d1-395c33a0168mr5128280a91.5.1787288173144;
        Thu, 20 Aug 2026 21:56:13 -0700 (PDT)
X-Received: by 2002:a17:90b:1a90:b0:37f:bfd6:8b40 with SMTP id 98e67ed59e1d1-395c33a0168mr5128250a91.5.1787288172748;
        Thu, 20 Aug 2026 21:56:12 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c4553168sm1535224a91.1.2026.08.20.21.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 21:56:12 -0700 (PDT)
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
Subject: [PATCH 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Fri, 21 Aug 2026 14:55:55 +1000
Message-ID: <20260821045555.806471-3-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260821045555.806471-1-changwei.zou@canonical.com>
References: <20260821045555.806471-1-changwei.zou@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rsa-caam driver directly DMA-maps the destination buffer supplied by
the caller via req->dst without checking whether it meets the cacheline
alignment requirements of DMA-incoherent hardware such as i.MX8.

On CPUs with non-coherent DMA caches, if the destination buffer shares a
cacheline with other data (i.e. it is not cacheline-aligned), cache
writeback/invalidation during DMA can corrupt adjacent memory or cause
stale data to be read back. This manifests as intermittent -EKEYREJECTED
errors when loading signed kernel modules.

When any segment of req->dst is not cacheline-aligned in either its
start offset or length, allocate a single contiguous aligned bounce
buffer covering the full dst_len rounded up to a cacheline multiple,
redirect the operation to it, and copy the result back to the original
destination once the hardware has completed successfully.

Introduce a helper sg_is_dma_aligned() that checks both sg->offset and
sg->length for cacheline alignment. Checking sg->offset suffices for
the start address since physical pages are always page-aligned and
PAGE_SIZE is a multiple of dma_get_cache_alignment(). sg->length is
also checked to ensure the buffer end does not share a cacheline with
adjacent memory.

The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
can be triggered when loading signed kernel modules:

    for i in $(seq 1 100); do
        sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
        && sudo rmmod xfs || echo "FAILED on attempt $i"
    done

Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
Assisted-by: OpenCode:claude-sonnet-4.6
---
 drivers/crypto/caam/caampkc.c | 77 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/caam/caampkc.h |  6 +++
 2 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 840271840cce..11c6b07f5dad 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -59,6 +59,40 @@ static void rsa_io_unmap(struct device *dev, struct rsa_edesc *edesc,
 				 DMA_TO_DEVICE);
 }
 
+static int do_rsa_bounce_buf(struct akcipher_request *req, int req_err)
+{
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
+	int nents, err = 0;
+
+	if (!req_ctx->bounce_buf)
+		return 0;
+
+	/* Only copy back to the original destination on success */
+	if (!req_err) {
+		nents = sg_nents_for_len(req_ctx->orig_dst, req->dst_len);
+		if (nents < 0)
+			err = nents;
+		else if (sg_copy_from_buffer(req_ctx->orig_dst, nents,
+					     req_ctx->bounce_buf,
+					     req->dst_len) != req->dst_len)
+			err = -EFAULT;
+	}
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
+	int cperr = do_rsa_bounce_buf(req, *err);
+
+	if (!*err)
+		*err = cperr;
+}
+
 static void rsa_pub_unmap(struct device *dev, struct rsa_edesc *edesc,
 			  struct akcipher_request *req)
 {
@@ -138,6 +172,7 @@ static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 	rsa_pub_unmap(dev, edesc, req);
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ecode);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -181,6 +216,7 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ecode);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -246,6 +282,12 @@ static int caam_rsa_count_leading_zeros(struct scatterlist *sgl,
 	return tbytes - nbytes;
 }
 
+static inline bool sg_is_dma_aligned(struct scatterlist *sg)
+{
+	return IS_ALIGNED(sg->offset, dma_get_cache_alignment()) &&
+	       IS_ALIGNED(sg->length, dma_get_cache_alignment());
+}
+
 static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 					 size_t desclen)
 {
@@ -291,11 +333,34 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 				     req_ctx->fixup_src_len);
 	dst_nents = sg_nents_for_len(req->dst, req->dst_len);
 
+	req_ctx->bounce_buf = NULL;
+	req_ctx->orig_dst = req->dst;
+	if (req->dst_len > 0) {
+		struct scatterlist *sg;
+		int i;
+
+		for_each_sg(req->dst, sg, dst_nents, i) {
+			if (!sg_is_dma_aligned(sg)) {
+				req_ctx->bounce_buf =
+					kzalloc(ALIGN(req->dst_len,
+						      dma_get_cache_alignment()),
+						flags);
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
@@ -368,6 +433,10 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	dma_unmap_sg(dev, req->dst, dst_nents, DMA_FROM_DEVICE);
 src_fail:
 	dma_unmap_sg(dev, req_ctx->fixup_src, src_nents, DMA_TO_DEVICE);
+bounce_fail:
+	kfree(req_ctx->bounce_buf);
+	req_ctx->bounce_buf = NULL;
+	req->dst = req_ctx->orig_dst;
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -409,6 +478,7 @@ static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
 		}
 		rsa_io_unmap(jrdev, req_ctx->edesc, req);
 		kfree(req_ctx->edesc);
+		rsa_bounce_buf_done(req, &ret);
 	} else {
 		ret = 0;
 	}
@@ -723,6 +793,7 @@ static int akcipher_enqueue_req(struct device *jrdev,
 		}
 		rsa_io_unmap(jrdev, edesc, req);
 		kfree(edesc);
+		rsa_bounce_buf_done(req, &ret);
 	}
 
 	return ret;
@@ -764,6 +835,7 @@ static int caam_rsa_enc(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -793,6 +865,7 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -822,6 +895,7 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -851,6 +925,7 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
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

