Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA064A5C2C
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 21:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791147742; cv=none; b=ivc24aTQrBKSILga5QSS18RmUP4Rl0JdbXQ9+1yIuGhMnJyW51Pze0eCRrqzlJaryagmDoQAbXcvEltedSMZQ7SvlcWWYh9PTCtNY5tcN8fEuG8bqvtPITVoOQz4l/CkIAn7fkWMZnSITMNNuvBkebVf7FZgL4JHfkaMP32OQ98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791147742; c=relaxed/simple;
	bh=kx5mV2YLybCvewSZ3/2h7UqXGepGGVLbUd4T5hC5ye8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0h2LHYy2o6ke1tGJMYatgxzNHxQ7cTXQ+TRZU+yFczpxw+GsE3wvFJuYhcJu7MtFBQ9mYLn/8vPHrVRzNJUkFqVt6E7SVSiHk3pZqIdyxmSZkwKamtQaHV9nQ+DVriWPh5ktsi1O7gtOTjX1j80UnkDJ3blchY4fpzlB+oVOXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=EHtpRdyE; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="EHtpRdyE"
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id ECBA63F29C
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 21:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791147738;
	bh=VohMkGY1mXCqwUR/SiwMVvUA/4iHrJCWHBBKDazHXjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=EHtpRdyE4vAhamFLRnGUyIcd3jvoTfvax0k0kiwTH5eTIsJuv6JNT4vOXrPGM2EJy
	 aIMjbf8Qen96HbNfNXbkgsJMOWCdbyFJ/kB3Adj7ho3pSp/owMCg4K8DyAQyoLhOx+
	 gH0Cg6gY/1WzjdqJyvHiw+s07fiv2I/H/KrTXW9CJ3cO7dtscvchYFotOCRePYPfDj
	 c08agfqBEwVBkx8uGgHpmWbvu5XiRvSVpeh9RoPsb0Gza+yf8zpknnjPGIf52jGfpj
	 yCt4z+H5A90xki6CrnWTWuAzETXRHH8mnhk0xSYRWqzG9DHPXVD/uVBnso0vhhRUeM
	 BcmLWHe/vOifArylnBMKaCN87qdsNv2vkRqy7LJJskqFOzcciJUlU4GP+P7eKTPyrP
	 q6Lu0lGCC91Ttf8Wob18rNdDDDRT+dD8NhXzM6hg3pepisEYdv565GctiD/FJVlixf
	 qAXJsuPbBPbVZ6cfqeSWGl39/6PQauwJWwBN4UOvIzgLPldPtvECkFAvVpJtcLNLpB
	 /6UNiPp0/iPwu4rNedInpmDrjD/MMHlY/h3q0ggca+k+mTx/h9o9oiNBUYux5HIxGr
	 xPfPE3M7UKgMIE6y6ipqUB5mQ+ki/TtAlHjehCcTb9D6geh+uKP1qejg+AHjcTe1Jk
	 wQXoBaFYkcOZGYndGCaGH5/0=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so1203526a91.1
        for <linux-crypto@vger.kernel.org>; Sun, 04 Oct 2026 14:02:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791147736; x=1791752536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VohMkGY1mXCqwUR/SiwMVvUA/4iHrJCWHBBKDazHXjY=;
        b=CKmJ0Tn9W83VN6cLpXBSqd4fo7yR0VE7KhrQFXopfOQPTo+D77uP5/5z5tsm9K+u80
         vAqEa/T3e9in2/KkfEIcPjaHxSybo8D9FgYGEoguKpP+nYidQCRmsWZ7pGhDK+CGI/lZ
         00BDcmvoW55LlfVnBVeFSaADPi6wF8xEM6oq46NaIXcwNDCDTNLlM4tjqNWx8PN6yv/7
         yJH5mWBFFb51UPqgtP3Yhq6HXSBHoi4COuoBvwRHcwpzvyKs125DxkqBy2d9F9firWJW
         MdGBDVJbz8vf/PB80cx2TRHq2Wrn4SzyqNi4+G0BMU+9PNj7uMvmdbt1x0o2F5NXbINE
         hItg==
X-Forwarded-Encrypted: i=1; AKwUvBxvxPDtwPA1n6vdE8MgmVhHhdXClj9tya/3MtkrUQ3HOL//X929gjsaBkgH/d0E1WD9wkI0RN90zvvBKOY=@vger.kernel.org
X-Gm-Message-State: AFq9FYJTIFy+iUklSIGDqsHyPaLyFcAol94qJmkYZR/Uxe10IurPsza0
	4/dk+frdvkydzka6ZIa9LIyABsmYBV6eEv8Ld4fD/gCNpLsxhybTMZxUHWZpIWYnueNNJSPS1o/
	xxob9u1KqGkkdsnggR+nXecgLJ9LxR4gRz2oMkaCSUOUD1QZOgnZuItVB6WDLKEcVXNG1FUhnhy
	p1yDf7Ow==
X-Gm-Gg: AYBFou3b4WnDNzlI1cJ6j/pGitlbayairN6p69ezmj0cPgw9ooTnkPCAOawjeVoGkcG
	1tGyu4aN+UCmORO7qD1PokW9KVJ5fN2qWrrxQ9HsYGUZfoBteGC1N0wqCaq+4PFfeLN4o4eIy1s
	jQ8jsKnf8ndB9eHJ9CK5ktjEEkVaxttOUkSpQ1JgRxteUBZByxim7fvLbtcPCtW8k73nJiDC7gz
	Zsx4EjlZS3WXt6qKVsZ30lxY7mqMU2RLPHG/iNsT2FNmO1n5HyHTCrn7Ldn0kZoQVRHxwAMz7c+
	CVhhc3vt+BxIWUDAW9igRT7VrVtC56n+pq5V3inWPJ21WXRy08B87uBwMQGVzxx1XFLQDoYW372
	NvW+Yp18M1A==
X-Received: by 2002:a17:90b:39c5:b0:3a4:7195:ecc9 with SMTP id 98e67ed59e1d1-3a78717da87mr5709797a91.20.1791147736216;
        Sun, 04 Oct 2026 14:02:16 -0700 (PDT)
X-Received: by 2002:a17:90b:39c5:b0:3a4:7195:ecc9 with SMTP id 98e67ed59e1d1-3a78717da87mr5709776a91.20.1791147735785;
        Sun, 04 Oct 2026 14:02:15 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e4664ebsm8313782a91.7.2026.10.04.14.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 14:02:15 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au,
	sahil.malhotra@nxp.com
Cc: davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	iuliana.prodan@nxp.com,
	martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Martin Kepplinger-Novakovic <Martin.Kepplinger-Novakovic@ginzinger.com>
Subject: [PATCH v2 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Mon,  5 Oct 2026 08:02:00 +1100
Message-ID: <20261004210200.290119-3-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261004210200.290119-1-changwei.zou@canonical.com>
References: <20261004210200.290119-1-changwei.zou@canonical.com>
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

Reported-by: Martin Kepplinger-Novakovic <Martin.Kepplinger-Novakovic@ginzinger.com>
Closes: https://lore.kernel.org/r/6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com
Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
Assisted-by: OpenCode:claude-sonnet-4.6
Tested-by: Martin Kepplinger-Novakovic <martin.kepplinger-novakovic@ginzinger.com>
---
 drivers/crypto/caam/caampkc.c | 80 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/caam/caampkc.h |  6 +++
 2 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 840271840cce..ec09c980a8e6 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -59,6 +59,43 @@ static void rsa_io_unmap(struct device *dev, struct rsa_edesc *edesc,
 				 DMA_TO_DEVICE);
 }
 
+static int do_rsa_bounce_buf(struct akcipher_request *req,
+			     struct caam_rsa_req_ctx *req_ctx, int req_err)
+{
+	int nents, err = 0;
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
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
+	int cperr;
+
+	if (!req_ctx->bounce_buf)
+		return;
+
+	cperr = do_rsa_bounce_buf(req, req_ctx, *err);
+
+	if (!*err)
+		*err = cperr;
+}
+
 static void rsa_pub_unmap(struct device *dev, struct rsa_edesc *edesc,
 			  struct akcipher_request *req)
 {
@@ -138,6 +175,7 @@ static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 	rsa_pub_unmap(dev, edesc, req);
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ecode);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -181,6 +219,7 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ecode);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -246,6 +285,12 @@ static int caam_rsa_count_leading_zeros(struct scatterlist *sgl,
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
@@ -291,11 +336,34 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
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
@@ -368,6 +436,10 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	dma_unmap_sg(dev, req->dst, dst_nents, DMA_FROM_DEVICE);
 src_fail:
 	dma_unmap_sg(dev, req_ctx->fixup_src, src_nents, DMA_TO_DEVICE);
+bounce_fail:
+	kfree(req_ctx->bounce_buf);
+	req_ctx->bounce_buf = NULL;
+	req->dst = req_ctx->orig_dst;
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -409,6 +481,7 @@ static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
 		}
 		rsa_io_unmap(jrdev, req_ctx->edesc, req);
 		kfree(req_ctx->edesc);
+		rsa_bounce_buf_done(req, &ret);
 	} else {
 		ret = 0;
 	}
@@ -723,6 +796,7 @@ static int akcipher_enqueue_req(struct device *jrdev,
 		}
 		rsa_io_unmap(jrdev, edesc, req);
 		kfree(edesc);
+		rsa_bounce_buf_done(req, &ret);
 	}
 
 	return ret;
@@ -764,6 +838,7 @@ static int caam_rsa_enc(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -793,6 +868,7 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -822,6 +898,7 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -851,6 +928,7 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
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

