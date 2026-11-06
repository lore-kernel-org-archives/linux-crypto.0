Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949860;
	b=OV7RfBkZdRnx+5Fb3NFojVSCixyVtgGC3+dfhxXUY8c0jDEQxGgC8xIunOrkS8Gl44m9
	 h1cF8BiWdoXNY6uiWnr5JpYfc/e3cwfcX2/pdIumSAOOtWfWtExA6Awmgvu+U0oiigJYJ
	 M7u35dM238iqIdlmjU7aJRu+2ow+TI1n97UKthRSI7PtbzmMN1gh7HIDA3RXb6V8aNBfP
	 AzMT02XMy3fjlGaUprdRoiQUi9cpjcYVzbNudc5L3+FEzp5/KX7pwAxKAOeWq5UGH0XET
	 Nj7arWRpPVhUaApVX+hXgSl/Zc9q/DDSf36SU9z4VmUyJdkSV86+sYTwwXEQJk+JbQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949860;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
	b=yf0wTOJobcBVt6OaBnwGJR9ZP5pz+yq8XBHr8LZJ2QU9BsOgzXUCzdyMN0mDPpCzTpc9
	 XjzQ0R80UGADNdsCI+WJhVLKviNGJ0CD0RJCanvhc6+F0PFhsbcCak5KcOlTheWfPbUI1
	 g4+bvKb4/gQV7mh+nRvEoLB0n8MWUTmvUBdQT1bEeXz5qg/LZzsYCtpf8Sv+3TG8900Hs
	 Tbpvz2zpKyPGpT/6+O3vJyneD92tWrcG2rv0iEF6xuTAJLoJOI5s+qqcBHum2wrsKN4Xg
	 CsTdaTwelB2FsoodYtwCS7/RosR/iI/TkLmhj4B8K7Ne3Jtnu7hXqThx2/zhPa1TR9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FZ0FPByG;
	arc=none smtp.remote-ip=74.125.82.44
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A15B606A331
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 07:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A15B606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FZ0FPByG
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1a2761c69fbso902134c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 23:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949859; x=1794554659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
        b=FZ0FPByGmDXRI8FmoXBff7bpj+H16OjqZ3ME8Cu1cKb86VVDIuvSq/1mBRd+n9vTWX
         ASIfbpnQt7mBbiDyUChz710f8XK9tClWAYL7nTRyr4I05Ft9fq1ImPB/kWlcbvKDGvy5
         2dzgp6cABNQOuABB1ZTE6CZX+7wlJJhQu9G1FIIiWMAVEAkmX0Waqy6sEQIjk0Lj8m5r
         mWZSfQF704JypuLg2aa0wP1MmSlFV1NEupYVV3l54eeshuaVMwIsZrFD7qAY3sNxkqEw
         rq9sldcSjbL0yuYzeftBpyXHZk4KEI31twdXD02HwU1Oxn7aGGMXjiXOx21IC1LWK7qh
         wT8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949859; x=1794554659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
        b=craYmHxx6NlMu/hRYzOkNwi6nLje7EK/bbUG5VOZIdgRm4Ntq4VRrc2nVa4B+tHy98
         m836bQyJYgwjWEuiD06AeIPrp7jytGSUA03VqgTdeeYFeESgnZTq+YcU0sKDFJ95FKiY
         +khX6hPYEH+yjKl/MlsBmqiea0ovg9PQXXISIE0TmYdVKzcc9YRaelLhTHzzlT7DaXnk
         T1S+ewV92r0jEBGDBG71SojZPcpo0R62+jfzCqSMRaOF0HQpEKVFNfGInEdTWkyYCX8V
         TnaUpMfVaeO6kf/mb+rA8cR6LeKhWRm4Ow6c5Mh69uDuUTPo18mTATW3i6fmOg4Gnwm2
         bRMw==
X-Forwarded-Encrypted: i=1; AKwUvBwYB2Lcf6uXgMuAwewc8bsaR3HpeFWgDSb9BH0hW7EkKy6B0x0peGU3tnBo93iIGwJxlqU4tNti1N8q4tM=@vger.kernel.org
X-Gm-Message-State: APuU4Z/SDh/JwhW/A/x4fToyHwwtSEc/yce1EkJQpkQqKQ13hOQgmvWq
	Vx8I4Nj+bkcxWUKPoaV3LZxYUNCWTleQuKFlwtf8Lii5WIRdLQL1BsR3
X-Gm-Gg: AYBFou1Yg5IayhhNyl5VKNVMdmpBoAGiXD58KsHnS/y5IBVYWCrQEaNA/kaoQgwenWD
	vU9oCm3TiPd8UCulPR/tSC0yONPTIKUab2229k4xhDCcWoWvbYxkxGCOakmMGM/NoSVe6DbjNE2
	PzPZENDHrA0HmipWrNAe3jaCxuRvLhyyI2QaW6VFE+1rbO7fnHrUoeNXo0cpg8dQVrmJRCmhZie
	ePE6WYXdovxm5JHQS/3hqdy9j/Vft5qjTSo6dGgEpa0x2MzTe4PatmJlVJPA7KuO/5IRdFB5qB4
	ZzNdJnhSvHoy4Hcvjshvo+PRrLuKO6Jvr4LFyG3x8buf8iLk4cjZU8rbEPxSqG+hRuC3bufJMgl
	ZxU+tyRJ50kVsJhM7FztM4u6qQdDQP8FLAKzfysOABHb8eZESuUT13R9Y97mPra9QOh4syhH3gV
	1qpj/WFvVmmr8bBU1EMYIgjBQG93O0DHhHqgPPJVhUOcssfddkcsxaIZ+jSHARIr7LS8/SzUf1M
	TJ7xIG1bEP1QYgMH3ttvcs0xJd+yJMt40T6ZP/MrrsgT7L6/EBQlGpzHqh/NrL5FQJRtVI6O5CI
	RQsyEDTR7Epoz3TVCAR8DptUYBAZxuXgCH4m0XncRw==
X-Received: by 2002:a05:701b:4301:b0:16b:fdbf:4a9c with SMTP id a92af1059eb24-1b25d32cfb3mr1771497c88.23.1793949859398;
        Thu, 05 Nov 2026 23:24:19 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:18 -0800 (PST)
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
Subject: [PATCH v3 1/8] crypto: acomp - Define a unit_size in struct acomp_req to enable batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
Date: Thu,  5 Nov 2026 23:24:05 -0800
Message-Id: <20261106072412.7909-2-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
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

