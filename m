Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156714;
	b=F4V6kB7mM3rurzqi3mrL7c7CGAJ6WnkkJecDA/9151x4BpIhxrl3X7eupjqpD0jZ3VOG
	 u9IYIy2NsFvijyofJK51QrUptsfHOaomF+fbTdlzipN0pJ9EClYvx1W/7gbe+h/bvuTK7
	 eCmy2+RAqcWoYrF6rXaUSokk4iwDICMf20DJgmHbtxoQfoYTqpgawmZy4CUlC63u6d718
	 4nQm3Op75xs7p8N/xeRU5E35BGvRv9bJz8cfwLc8FBOGw34uun3x3q9kZluAt6dO/eEoF
	 3B98jNXj0u+/AKDzgnTxxm+sScQ4vMPAQNRo42p3Dz54sbPOlREsKvAgSzCdHfCxsBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156714;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
	b=wXIHL2zjOpOrGf29r7nM+Rg1HBKlxt286fXWg6bIST5JJnWi3wIn5AP6/URbA8zCJe6H
	 Qniv8MQR8hzQd0CPm+tYJl6ESi+uj7MjhkaIV3ToK+LhaQwUV9Rd43fR0ez5SpSK/ndxp
	 36cLGyVZneWUSlUukrMvUzh13/C5FLwgWTjWLJo58nHnAg5Yq6Ccfmk/E1FgcyfvRewIP
	 vjNmn7Mey/IAet1y4W9wpdPqEwcHcSHGv4zn9+FEugtkuFB4kQxkULCoC1BsDkgMan6tG
	 gPzxnNIXjPVVJhxFalURqT7D9jVTHCxy3fQGcgTwdei145zzikx0O+pMmbpqmJ+UKKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SKptKz+t;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B34606A331
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 03:05:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40B34606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SKptKz+t
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-170135e43c7so702670c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2026 20:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156712; x=1793761512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
        b=SKptKz+thfwzeL5VgN+FrCyCuv5Bp3y4tMY7sQ05aaOvheU6PBvH4IrCVNjOH0qUsG
         2gu6Z1LAkHAAB1Y8SkAbPZfsUU4G2vUcLSi+N5MZrdp/q2PTywsbSWBiTmf8JyzBo915
         Bl6lXVEtjc3AlkswP+lT2rgAvnp2H8g8MUsziK20M+4sOTjZowM5DqBDUoma1bAWbSai
         80aY46Oeew4+sVNKsaNzkpw4sGTO8cS4l00LtHT7+ehTI3d3wsnAwdrX6dY1MsGRetPm
         x3RPjdCVwXhFz8wcGliz662+4QfSyZkLEEDeaKM0/NyNivTl87g3evHPTV7XBgpf5/5M
         rzfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156712; x=1793761512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
        b=H/1XEbxk/dGfpi1OkBBdeN0j9bf9V68tZew8EWNGZG/nik7QIS9qnH/BSpKd+oPXBd
         NN49LURf3yMcJZhtiWhH6PUGZh6Ftf1BojKX+oZma8aPkZHgr9o08Jrt5gyN2SiuzIaD
         BRvRwFEawylVhXO+mEjOJY2eVDpr4IFxQathYv86BQXjMB5pcQoxxq0CRDH15zKBQSAj
         Uz2RRjQVQu7EUGN5dNFw8nevZLVwGU8m7eXbjYLyuFSpRhqG7bKeFQ15+QJlP+7lNNim
         YCGDfesNGH3I/9BHmzRL+XczLjkPBQ03D7llNEgdY9JSntOBSid1pEIs14YxgIg2Uqyu
         3JpA==
X-Forwarded-Encrypted: i=1; AKwUvBxC3r96lQH9Hv7fY5InhvpPxe0Bs2XQrHZzIeQ+C214ZMp1yEv4l3iGJB3Ig1AJkijO8OOzbSbHGqD5nr4=@vger.kernel.org
X-Gm-Message-State: AFq9FYITt9rEiKhHZkBwSrjhSU1xegT5kzZ05v34RsTTiR45j29TwfbQ
	LFMSxRj8gXGv6IuqIZBsO4hJwhcV7FJG2UePmcYmaolKLz7mjZ2Wo5lk
X-Gm-Gg: AYBFou1eZW/TLXWc7KM0GcUNvcP8dcaGllbClLZThBhTFar7A77+0i/L8I1v0dzX60R
	Ztjfpcx7mdTa8GCyoqkHutzUnahpOHXIC2oH1cHPIAitMHYm2bElw3fVsEMdM3Mk/wJVU25bgQ7
	kEe2h34GeHY3up/dWEQQ3Li6ma/XlzHT7POwTaoknMFFbuwiFAsArkUBx3Ea14o2yS320ZqNRaW
	MDwqbKBVDCUpzvDGC3kDNnmBWZRlMI+aBpHieU8a3DokpyprE0lZzlhfp7Fqkw/0SDitxeh24jl
	92dpCEjtjjbnfyKvshf1Hl+2s7QyjqJxfL+rYM2PJPk+svGkri968/9pwQORm0h++qqOeiVNMB9
	imgkTzLl4EYtE2vXdWjRHRIiaSxZix6hYHqWDqva0e3leaqTXBs/F8/gYqBsFfzeVEUZkXiZD/2
	7Dk1ljuBWKHz99/6zdxH3c+SUaFx0LvywSGcZvLCsh2lbNXaOyO9JdSfLqTPPKHuMK3Zy0KDlIY
	O1QPa0gnUGM3fxmwJEo1n7JDqw8BCuRtX/BJQ/YheWgwx2IShrWai72C3baWJInC2NcyRKQf693
	8k0JwPcixDmVgFvaAOFeuhyxtJnpFM4iSFRkANKdsg==
X-Received: by 2002:a05:7022:286:10b0:143:868a:20c1 with SMTP id a92af1059eb24-1a6cfa0e858mr1429965c88.46.1793156712194;
        Tue, 27 Oct 2026 20:05:12 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:11 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v2 1/8] crypto: acomp - Define a unit_size in struct acomp_req to enable batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
Date: Tue, 27 Oct 2026 20:04:56 -0700
Message-Id: <20261028030503.17923-2-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
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

We add a new @unit_size data member to struct acomp_req along with a
helper function acomp_request_set_unit_size() for kernel modules to set
the unit size to use while breaking down the request's src/dst
scatterlists.

An acomp_alg can implement batching by using the @req->unit_size to
break down the SG lists passed in via @req->dst and/or @req->src, to
submit individual @req->slen/@req->unit_size compress jobs or
@req->dlen/@req->unit_size decompress jobs, for batch compression and
batch decompression respectively.

In case of batch compression, the folio's pages for the batch can be
retrieved from the @req->src scatterlist by using a struct sg_page_iter
after determining the number of pages as @req->slen/@req->unit_size.

Please note that acomp_request_set_callback() sets the @req->unit_size
to 0.

In zswap_acomp_req_init(), after the call to
zswap_set_acomp_req_callback(), we set the unit size for zswap to
PAGE_SIZE.

      acomp_request_set_unit_size(areq->req, PAGE_SIZE);

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 include/crypto/acompress.h | 49 ++++++++++++++++++++++++++++++++++++++
 mm/zswap.c                 |  6 +++++
 2 files changed, 55 insertions(+)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 5d5358dfab73..6462fc46f4ec 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -79,6 +79,7 @@ struct acomp_req_chain {
  * @dvirt:	Destination virtual address
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
+ * @unit_size:	Unit size for the request for use in batching
  * @chain:	Private API code data, do not use
  * @__ctx:	Start of private context data
  */
@@ -94,6 +95,7 @@ struct acomp_req {
 	};
 	unsigned int slen;
 	unsigned int dlen;
+	unsigned int unit_size;
 
 	struct acomp_req_chain chain;
 
@@ -329,9 +331,56 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 {
 	flgs &= ~CRYPTO_ACOMP_REQ_PRIVATE;
 	flgs |= req->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
+	req->unit_size = 0;
 	crypto_request_set_callback(&req->base, flgs, cmpl, data);
 }
 
+/**
+ * acomp_request_set_unit_size() -- Sets the unit size for the request.
+ *
+ * This is a helper function that enables batching for zswap, IPComp, etc.
+ * It allows multiple independent compression (or decompression) operations to
+ * be submitted in a single request's SG lists, where each SG list ("segment")
+ * is processed independently. The unit size helps derive segments from a
+ * single request. crypto_acomp does not expect the segments to be related in
+ * any way.
+ *
+ * Example usage model:
+ *
+ * A module such as zswap that's configured to use a batching compressor, can
+ * accomplish batch compression of "nr_pages" with crypto_acomp by creating an
+ * output SG table for the batch, initialized to contain "nr_pages" SG
+ * lists. Each scatterlist is mapped to the nth destination buffer for the
+ * batch. Depending on whether the @req is used for batch compress/decompress,
+ * zswap must set the @req's source/destination length to be
+ * "nr_pages * @req->unit_size" respectively.
+ *
+ * An acomp_alg can implement batch compression by using the @req->unit_size
+ * to break down the SG lists passed in via @req->dst to submit individual
+ * "@req->slen/@req->unit_size" compress jobs to be processed as a batch.
+ *
+ * Similarly, zswap can implement batch decompression by passing an
+ * SG table with "nr_pages" SG lists via @req->src to process
+ * "@req->dlen/@req->unit_size" decompress jobs as a batch.
+ *
+ * This API must be called after acomp_request_set_callback(),
+ * which sets @req->unit_size to 0. This makes it easy for users of
+ * crypto_acomp to rely on a default of not opting in to batching.
+ * Users such as zswap opt in to batching by defining @req->unit_size
+ * to a non-zero value for use by acomp_algs supporting batching.
+ *
+ * @du would be PAGE_SIZE for zswap, it could be the MTU for IPsec.
+ *
+ * @req:	asynchronous compress/decompress request
+ * @du:		data unit size of the input/output buffer scatterlist.
+ */
+static inline void acomp_request_set_unit_size(struct acomp_req *req,
+					       unsigned int du)
+{
+	req->unit_size = du;
+}
+
+
 /**
  * acomp_request_set_params() -- Sets request parameters
  *
diff --git a/mm/zswap.c b/mm/zswap.c
index ad01c691a263..e1d57a7d9595 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -826,6 +826,12 @@ static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
 	crypto_init_wait(&areq->wait);
 	zswap_set_acomp_req_callback(areq->req, &areq->wait);
 
+	/*
+	 * This should be called after acomp_request_set_callback(),
+	 * which initializes req->unit_size to 0.
+	 */
+	acomp_request_set_unit_size(areq->req, PAGE_SIZE);
+
 	mutex_init(&areq->mutex);
 	return 0;
 }
-- 
2.39.5

