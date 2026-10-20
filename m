Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464890;
	b=KxGGVRcJ+NTcf6ETNa6B/BThswcXBz4lI6MlmQXLbSIlBscIBQ5lkraYQzTXuewPOxYL
	 Moda0SpaYnriD9QXDpW+XA6qjnQyqagogVZZUsIMhj/Ykm8tU7eeExEdBzmVzzM3W2uDr
	 pd+fNxQFwcQtIO9CX/hW5AFECT/Vvvj8ClFoYsLxX2+R1YZk/vhdvpVFt1W/RkvLk5N0F
	 luMELnwMLqX1ZjT5F1x6DDzOma5ny9z1mLlA+b40SY6PfZgRq+bSjE+1R4uxvUSMGDmQe
	 Grd4AxkhSWJs3NOJA1qHnPbV3LwFffsg65uVB8XMWAuw/6EEG6K5vTnTG8vDDze/MqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464890;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NrezdmsVgQvNo7LlU7HAZmepMUp1FaJ1YwSuM/yBTvE=;
	b=auIoRfpKO8dL8AWgarMTB80lbV0IfiPUbTN+4km50oapamVVQ6vYCm8YlrHJMeoQgzDH
	 Qxc9gbhuv3u0Ay1ZpFdbogAcUkQGxVVt2ju3ZIlo1MlC+v3m14Hy6kOgSZSPbwE4il12q
	 Wnm4nsx0upRyjfIkXWsNGn6DCIDv7jLT2Q3OD+Ao75Zchchq9rbQY14m8VxfTVn7jEAV5
	 6kX/dYKuQPcyb7XFRPvV36tQVJC0Pa/nifUceokajJ47VI15oT+HN6DBxRPJu5miCr5/1
	 PWpIvYSVY4vV5adRLtImn1Say+lGIW06z0aDyYYzTsVEV+VbwNUaM/7sBST+a3T0umg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=OU+B4ic4;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F786606A328
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 02:54:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F786606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=OU+B4ic4
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id EFDF13F5B7
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 02:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1792464888;
	bh=NrezdmsVgQvNo7LlU7HAZmepMUp1FaJ1YwSuM/yBTvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=OU+B4ic4EowGi3LxiYwP7pJwSrhP+pM0KFLaSdpZR8qQitypM24lnnNsMvRvc1LrE
	 an9qBNFGRwx/ZQt7e1ZQMsow70fNZLSqcLpNY8vWG/KlDb/x9XOxFrc4yyrS0ERtDq
	 HYMPVWMwdJl0sKJ6sWdWuznC8KSSk/3yYNfpTZPxWkLAyhrlddGuCk47Z5ToaDJcqO
	 bsUlyJLj5jEx+rRDVNgJ96vICsRutqozhnRLAAeSoT0KWg1CtJT3LNSxGx4ESS+fZf
	 yMdP0e5VWJ6e5ya33wxzmZvO2ICGURyNFpthehAmDSda4xdUNH1Us8kwFSWkAG8agr
	 HU1UJKAh0nnDThBYrASQuJyZzHCmLnIAs5TT8IBmM+UdFYTkdTnwtcMnRZ3N+8T5T3
	 kCz4QqrXY/sQf8m8K0OOEKGhYH8Me7+djmuZ5VGEpGEkGmy2UhXBZJ1Z+ONCeLhJVN
	 ezZDwoNEnGihBY+hrEuonq0otdDjtFkES130c7+pCUBXanIfXI7te1a/5+oXWQ8WHy
	 VNjQ+hwGW1G/LoMG0QlbZmFOzGO8I5EfkEiEt6NrvsHEJr/PNEXf7SZrS1tmzx7R0Y
	 eka5lwK0ppvYGLWnqzi+e+JswB7acLxQ9cjcBuWFA2bpmhTdUEHnjsy2rkjaPiSwza
	 8P81xemD0oeYl+8KOhkwATfI=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ab67ff8ec3so2141882a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 19:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792464886; x=1793069686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NrezdmsVgQvNo7LlU7HAZmepMUp1FaJ1YwSuM/yBTvE=;
        b=OuRx7NZL4b2wwaRVewqJ1kMALmwgI5ZgkJGRD48hluy3q5paGUt7KwKZyXQiWLssJi
         zRiX5Xin5fStUR2nZWpTYQZa94Xoh5mvoWKO24SLrXCCqfPezXUMPpDGQBoBE1eK2Ijv
         yXWqsZ6g/+r44jb8d1JIK5qCJWl6PJuujAfXVc7Z1McFAcrUEzp/XcUIWkYP5m1+IELP
         ZYXT1KQn9FhPHKDH+MqjpHaShNHm8ecTNjrgdKZg3s+8rF6j7zZ1uamizi5HMiheXJLA
         bT5iB92dukcvJ5MvuWSKiegFKLomsZdvGf3bkIv3OB0+XGbsh8IwRIm4OYnZbZi2oylo
         Y6eQ==
X-Forwarded-Encrypted: i=1; AKwUvBwfmhR9yJP+ml5VXxg8mRSBFl+sqp/b21KLYVEBppfGkvc/12UbY0/JrieQwKJ/L0bszSVKelHIVd/IIOI=@vger.kernel.org
X-Gm-Message-State: AFq9FYKwBTh8mut7CQkwiiTkN4m2mMUUtc+xgGuJGdcURMf8/3pNuMQL
	TbWW+SzLT0RaNoK3SH8W4YY5Se3CM7xt4l189Hy8SpSuuad/JnVNlIXQOkHhm/8RswnSGw3Baxe
	1FcsZf3a23HcHlveGrDccBjvFgve6YCW2oaiQZ7fRTsR7WmkfeCZKAPy8Dbr3320fUYH77kExD6
	leHwmvVelH/oVf0lvY
X-Gm-Gg: AYBFou3tR8Vplh2NAj6Pc7+4Erl6q179tSeaQZCLJcvT6pyixb9lELoiV8GxpG82Fs8
	GU4boJwLNCAaQ8mRiZzZYG+gW1+QGRaqfibpDWIhBAZy/n2yMk9xpReBQISyOggPB0nDBdtKj3J
	wYnowdwZFRMo1ZnucvnjvqkrflDhlZFxZBvhZjqUoYutd/lpwZf6czlKPZEYPlKijGhxmfY6cgE
	QaUFqvVUOurtHWA6HN65olql0EAyUBBcA9cyAKDtl2l/v6vxOT6k1C68SmU73tpTMkAihuhfw8g
	lSkjc7IOZ/PWZzYHW73GNkOVWy6M1AAoIvEyQos9jKvEniNRFEuGb8nsJhP07rkqOBA/5QKltRG
	PS14cvnz86Q==
X-Received: by 2002:a17:90b:28c8:b0:3aa:548f:eb77 with SMTP id 98e67ed59e1d1-3acef5f1ccdmr8643131a91.56.1792464886329;
        Mon, 19 Oct 2026 19:54:46 -0700 (PDT)
X-Received: by 2002:a17:90b:28c8:b0:3aa:548f:eb77 with SMTP id 98e67ed59e1d1-3acef5f1ccdmr8643117a91.56.1792464885926;
        Mon, 19 Oct 2026 19:54:45 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad5d5679d5sm1962994a91.7.2026.10.19.19.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 19:54:45 -0700 (PDT)
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
Subject: [PATCH v3 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Tue, 20 Oct 2026 13:54:26 +1100
Message-ID: <20261020025426.955531-3-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261020025426.955531-1-changwei.zou@canonical.com>
References: <20261020025426.955531-1-changwei.zou@canonical.com>
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
 drivers/crypto/caam/caampkc.c | 87 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/caam/caampkc.h |  6 +++
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 18a728849147..aa782978b1e6 100644
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
@@ -291,11 +343,34 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
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
@@ -368,6 +443,10 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	dma_unmap_sg(dev, req->dst, dst_nents, DMA_FROM_DEVICE);
 src_fail:
 	dma_unmap_sg(dev, req_ctx->fixup_src, src_nents, DMA_TO_DEVICE);
+bounce_fail:
+	kfree(req_ctx->bounce_buf);
+	req_ctx->bounce_buf = NULL;
+	req->dst = req_ctx->orig_dst;
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -409,6 +488,7 @@ static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
 		}
 		rsa_io_unmap(jrdev, req_ctx->edesc, req);
 		kfree(req_ctx->edesc);
+		rsa_bounce_buf_done(req, &ret);
 	} else {
 		ret = 0;
 	}
@@ -723,6 +803,7 @@ static int akcipher_enqueue_req(struct device *jrdev,
 		}
 		rsa_io_unmap(jrdev, edesc, req);
 		kfree(edesc);
+		rsa_bounce_buf_done(req, &ret);
 	}
 
 	return ret;
@@ -764,6 +845,7 @@ static int caam_rsa_enc(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -793,6 +875,7 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -822,6 +905,7 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
 	kfree(edesc);
+	rsa_bounce_buf_done(req, &ret);
 	return ret;
 }
 
@@ -851,6 +935,7 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
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

