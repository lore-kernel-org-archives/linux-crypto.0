Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794438180;
	b=ENi42+2b+8B2mlwnjKdZtu50HBL1qtSGqEuvd5je/NX7zRMI7myojrmCJJX4KhJn8NOt
	 lH3cwoM9T+7TLrTEk0Dtf7IHSnfXlxeFXW84nlqYWF7CQ/hePbYf/7m62ruDCKvMiDdRa
	 cko5qiV6tssH4dr0Ty1OIcXdSzdbWYDLd0yq1rEVGURQIW1IQO29Yx7qvuOevgKKKpY6g
	 Z4a6Q4RzCApm7IkQfGD/T80gSDZSHy95NO+Kf3B/MohJ/oVoN6u3aLAlVtK6ZobEI1YY7
	 WJW7qcXgXfZUNRk3Zx2ATquiw8IYIEDn66zwxmyG5EfEkVaI68Vp2EzTXVVUPCl5lgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438180;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mrHQN4g6QL4gu1G1PTYTtlzVT5fDy2OJaX2TQQRIbaY=;
	b=4ZsXCzliodoxqXStw3T1dV2hV0FMaDNkwjooEUNzT4OcuWzQbLZs5Yyii7822C6V9Ccs
	 GCni97V0c/+YtSWyJ7kIQqXCf0c7a3p756LACs4TeU32DFkv/pWsrjhe3u/DeTYFHBPub
	 zqYAUCguiP+IBSK+5qBzxaEXmvLlLa+ZS7VvSqlCXj9G1Si06iEU/9DycxAUifxIq9m87
	 H+ZTh7YS7MdpN7o0XcJ55ocUb5Rq5H1C9+LtdoXTZLu6j7LD70U+iFN3xjuiyxt3EHNyJ
	 8JGS/NFy1rloBjUNh3aBaMN9ySyAiwV9v7FA/zvuyj+SbOSfDxao9WOl9nhTngMAoqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=HtUBwm8a;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9994360A3831
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 23:02:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9994360A3831
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=HtUBwm8a
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id CC36F40290
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 23:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794438177;
	bh=mrHQN4g6QL4gu1G1PTYTtlzVT5fDy2OJaX2TQQRIbaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=HtUBwm8a/UqjhJ2vn6r/MX8wjOpJlhBmQNcEXWsTkBCNUw2k1z4eDhBvwyyTYA66m
	 aaQ38wPaYI73LWivq2rkos5UAR2Ue0FoJhdpRWlIOf1cWG8IBYjfu9vCshURLK4+n1
	 utiDZBOMziBirafs4anAdr4h/wBioJorvJU1JQsRQfbiIL1drQXgLX/0GaIN5IdEgj
	 CALLMZHVrIlRvObE3jGh5omN3MTTw5uZBMlD1TXLw86gThFjjwjRWbs20FP5b7fdMy
	 IdBTNI3B9iYvV+BwQX9PEKv/zrsq7MDMUNENo7GEvyJrVkK1u03tSPwT2UUMegDu94
	 4iQHcQwfC3TOzVKBKaQPeCStwhdCAOWSVV1KDfWk8zzXRbgS+zgmLWZkpQHyXxowkk
	 sfZKatN1XQ7M4u6zPhiSbvwraoIxYFFZhUNKfdYHjF2YmpO3em8Ar1J5hWCIOnklXO
	 eZ4rG14/KnSHf2Pw4n288nSUJLIP0kMj5hJNDCmdCckTRm4uR2wpP02QSQmAzIYue0
	 YV1dWRTh+crWGEKtbuaEg3X3AY3X7qwmf4/gAw7zSNB/pCfbNS7ihzohXQWR4P3xKb
	 7/V5HVaugnp1VrxJuYmTl0Klw7Ruh3hUerRMVYoqznXXM/7RDcuBIUr8MqENP8Sq/E
	 yJirS/YBGjGKjm2U2RX5Crvw=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbb92868263so1859003a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 15:02:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794438176; x=1795042976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mrHQN4g6QL4gu1G1PTYTtlzVT5fDy2OJaX2TQQRIbaY=;
        b=DVKSXvOTiOBaOeMopUcQYN8s2Z+BRNXXreoA0Ppicw1fqX+xsG1m8OBZTFed8JeboJ
         uuHS9DseZ/AmfZ7rrx4bbQgd3phXycFsemT+F/K/vApvJ+sAkTL6nwwSMDbswwjH75JS
         UIpJ5G0ZNUZJXNZLRAj/16Hvp2YBniBiLfzm9jOnTRQRusTmdkhtlnSLhbbtyF/nweut
         N0YTp5AVfJ0HdyBu9AngeJu/FmVMwCz5tNKKxDmCBxEsnsZ583Yb/IzjfeZYF9gZzq8E
         Vw1KbQt/dvtb3F13ubtL1bfLhS9mtrL40/JOa/XtcprTLW4uZv+zTSy7nPN4/OdP5XqE
         mDKA==
X-Forwarded-Encrypted: i=1; AL+hErEnaypyId7gF7Fdajbf9/BhjZk7AGrxhK9A47GoMpqsXpDXdREE8b6fyAUSFIJolRMyhbthWk6wrOz/rws=@vger.kernel.org
X-Gm-Message-State: APuU4Z8v/BF1qwWMvPzCrlBFDFxl5dbJk+9ok/hhiF9M4gnJurOnfNuU
	C0KgkLeEOB/SwOnbqRdsCiS3BhPwPhVU9Qyfmn52D0fAHjRaLE0k0XipEdFdnmVy6b3Ew+JnbnE
	s4Bm14Sy09tGOq7Rsv1ZtLIhPGd1YSzBi2ekE5UI/cnRdvESYmxv4gUFqIcHuhSWf7dNA9cRbqI
	7n0ArEXw==
X-Gm-Gg: AYBFou0HfREDkdR7/V+wo4vbR1mXAruopbE79fqDlj+RDC53+BJQ46kERLOh+rTzP93
	4+9YicddSebun31f9LpmVeDhxmCa8ykliNLTDsl8ei0UcDYcEv1J/cH/O0vFb9iXwD7fAsX2Hgk
	Md6j5lmxsY2dTmR7v+fUZVOJi6yJ6/ooPDuuEB/QECIax0Wgyv+6duv3d6he9b6BXq0eJcB3Ax/
	vpS+Ixh6XYZKSUfnhfSLjXLLanNmBUOr1O85zEr6l78I65e1vnwZ2Obbj+sO6YWLa+FHW2pERwB
	kzftypdxiKYPQ1yQ3XCeg5cvRrRKq7hrt5DgGuRqJrnPILQHe5Em84gi9/+KgUtgDdcQXAo3/D7
	f1PtldbeETwv6I03pSSOMH2x5iYXPUEFGLDsLDv+Qv4kluO2hhKJvoT2EiJA=
X-Received: by 2002:a05:6a20:a103:b0:3e1:88d6:60e6 with SMTP id adf61e73a8af0-3f2fa49a5f2mr3854518637.10.1794438176202;
        Wed, 11 Nov 2026 15:02:56 -0800 (PST)
X-Received: by 2002:a05:6a20:a103:b0:3e1:88d6:60e6 with SMTP id adf61e73a8af0-3f2fa49a5f2mr3854488637.10.1794438175821;
        Wed, 11 Nov 2026 15:02:55 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab4fd5c6sm2531211b3a.46.2026.11.11.15.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 15:02:41 -0800 (PST)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au,
	sahil.malhotra@nxp.com
Cc: davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	jeffbarnes@linux.microsoft.com,
	stephane.debusne@cynove.com,
	iuliana.prodan@nxp.com,
	martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Martin Kepplinger-Novakovic <Martin.Kepplinger-Novakovic@ginzinger.com>
Subject: [PATCH v4 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Thu, 12 Nov 2026 10:02:21 +1100
Message-ID: <20261111230221.40297-3-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111230221.40297-1-changwei.zou@canonical.com>
References: <20261111230221.40297-1-changwei.zou@canonical.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
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
Tested-by: Stephane Debusne <stephane.debusne@cynove.com>
---
 drivers/crypto/caam/caampkc.c | 88 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/caam/caampkc.h |  6 +++
 2 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 18a728849147..2d06fa11e782 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -59,6 +59,50 @@ static void rsa_io_unmap(struct device *dev, struct rsa_edesc *edesc,
 				 DMA_TO_DEVICE);
 }
 
+static int do_rsa_bounce_buf(struct akcipher_request *req,
+			     struct caam_rsa_req_ctx *req_ctx, int req_err)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
+	struct caam_rsa_key *key = &ctx->key;
+	int nents, err = 0;
+
+	/*
+	 * Only copy back to the original destination on success, and only the
+	 * actual RSA output (key->n_sz bytes) rather than the full dst_len, so
+	 * the trailing capacity of the caller's buffer is left untouched.
+	 */
+	if (!req_err) {
+		nents = sg_nents_for_len(req_ctx->orig_dst, key->n_sz);
+		if (nents < 0)
+			err = nents;
+		else if (sg_copy_from_buffer(req_ctx->orig_dst, nents,
+					     req_ctx->bounce_buf,
+					     key->n_sz) != key->n_sz)
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
@@ -138,6 +182,7 @@ static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 	rsa_pub_unmap(dev, edesc, req);
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ecode);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -181,6 +226,7 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ecode);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -246,6 +292,12 @@ static int caam_rsa_count_leading_zeros(struct scatterlist *sgl,
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
@@ -291,11 +343,35 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
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
+				unsigned int bounce_len =
+					ALIGN(req->dst_len,
+					      dma_get_cache_alignment());
+
+				req_ctx->bounce_buf = kzalloc(bounce_len, flags);
+				if (!req_ctx->bounce_buf)
+					return ERR_PTR(-ENOMEM);
+				sg_init_one(&req_ctx->dst, req_ctx->bounce_buf,
+					    bounce_len);
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
@@ -368,6 +444,10 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	dma_unmap_sg(dev, req->dst, dst_nents, DMA_FROM_DEVICE);
 src_fail:
 	dma_unmap_sg(dev, req_ctx->fixup_src, src_nents, DMA_TO_DEVICE);
+bounce_fail:
+	kfree(req_ctx->bounce_buf);
+	req_ctx->bounce_buf = NULL;
+	req->dst = req_ctx->orig_dst;
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -409,6 +489,7 @@ static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
 		}
 		rsa_io_unmap(jrdev, req_ctx->edesc, req);
 		kfree(req_ctx->edesc);
+		rsa_bounce_buf_done(req, &ret);
 	} else {
 		ret = 0;
 	}
@@ -723,6 +804,7 @@ static int akcipher_enqueue_req(struct device *jrdev,
 		}
 		rsa_io_unmap(jrdev, edesc, req);
 		kfree(edesc);
+		rsa_bounce_buf_done(req, &ret);
 	}
 
 	return ret;
@@ -764,6 +846,7 @@ static int caam_rsa_enc(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -793,6 +876,7 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -822,6 +906,7 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -851,6 +936,7 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
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

