Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795148359;
	b=R//w7z0r6bQR9+NGv/AI12BrUdnbfNJDECcukeqDJZ/HpUoSf+gKslskYOW0sKaxaL5z
	 pANxAo4bwsF3BFyh3jkgrqyWNShq8S9y49h4j/PNs9B894Nk0RuHfubWPRgfUvTvgfMds
	 G9yTghxW1UPpZUcQ6CAwyxiTVysDtsxuNd0RRWRSw+hjdDx+qYSRd6pOzCEewVKZ0bef/
	 MrmVE2aGwrNIiT0FenELX3r8+ASNw/Iw3kBC7MX0G6w7+hN6ZZALd3E/IDTBwWmpf5WNm
	 ZFqNquzphcTNcvhCFRrYa4bNsxNM+CDtHuzsdU+crn0KAQxyEn4siDtzdRgQcYUPkxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795148359;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LTz9wzGNtR/N3sgiwyDnjJ6OY+zHMig/3wvX7u6gSy0=;
	b=zgvtRp/pLSYUzjNSZ1fDGqiUj9jdaVdnsA6hlsiJ8fvzygZfy3o99Op+qC59688Qw1qM
	 9GXSOkBD2+r4sQxdhi36WLg31B9M9qVe7369z3y0c+0RJaxxW3qNZA28Y3GTQP7hENPSR
	 9yHECfxIGeGn7VjRoDL08b/VVncW+Au8HBzpMgQ4pW+Ra2z5rEbE7XKalA1VSb7w41czm
	 h5Z7JwGzygSRZh/9dYKPMlnVUdWnvB+sDZ4yW4fADG+v7H8MkMZRIjkrUSMOqycCAYkkt
	 6gPKRvcdU7UjSJhlKyGJRyE7PqteUOOGy6LXsI18z2QS03o1cwoQIHCFf8RXXum71hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ln46AGCl;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6919606A330
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 04:19:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6919606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ln46AGCl
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so610117c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2026 20:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148358; x=1795753158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LTz9wzGNtR/N3sgiwyDnjJ6OY+zHMig/3wvX7u6gSy0=;
        b=Ln46AGClFLV8Vd9W0JYawJrOhClajoi54GUVWtYUzgQ00VMdxqUf6yKOvEDcVvKx5G
         +UONIIj4RWGd9zyKIcivQE5r22y20EMW4Gk+ZUod+rthDsU1S99o9ESob3DmIaNB9Mr5
         +ORX7pS51gQJGv9yT6KDz/KbmYYzSmYa9Ds+XSAMHa5r8fiV6zNV7okF8h+1k45T08fL
         ZJSx1NmrZZnGdD40yfkPIN7PwmoebE3ok57mTNqhzzVw55wYh04q3IZHgUsBMjrfNaxl
         8+LiuLMMhyiN5VkUPBo46cNKQ9D1Lp8LJ9gMzTXREEinBXvXJp6PS8RDgvP9tHtFQ7Ym
         Hnqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148358; x=1795753158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LTz9wzGNtR/N3sgiwyDnjJ6OY+zHMig/3wvX7u6gSy0=;
        b=YmQeN4EIOYtpFtctNJxwRczastLmMt1z7COTGyEz8NirSPCQMigSFQFy3qMK+ooUT2
         O2GaCpZxVievS/b90ksPpAeCVZXgEJDxzhviTh3ssyeFPuulM+pcQzKek7QeB1mISUJB
         W/fiGmlIah7Y42yMGY7kkvscWdzOpVGGKCxQBpTaocdf2MwGn0NnJJLJpWOou0eidUHj
         6AhYs5Aj6qYQaHrGMAyoxZ5+4c2mQ/XzM2V8Jcx2qcjNdAR2C+RdoZ7WAIq6fbxXlbcF
         RHPwWONn2BR9OnQd8nPg1ZodAzQ6H6AC2RJMtbfwY3izzzjcjvnNDzwCeOi8IyxrZAZ5
         o4gQ==
X-Forwarded-Encrypted: i=1; AL+hErFSVKnOPTtaptbR8PSCWrIJajGdRCpECeoDwvRBz2ulnR6N9yoUL1LuTJ17jFOjCucJMsn6g3zvhMtTjjc=@vger.kernel.org
X-Gm-Message-State: APuU4Z/h0uRGL8twtcEuCcfoExpAxAqCgGiA+DNzvfkO9/hJYSgXKpYn
	F/sfJKrs8zqhDWEWjrIRpihBDw62+w9+siIyGvYwoPQYxr+Z+H7jZ0KE
X-Gm-Gg: AYBFou0noMWtFx0mLcGxqdXoYAq5m+a9e1dU63culau4wrT2NXK3BVvRb2AKFfZbo+p
	crZS8KjUrwzPsWSt+DfQYRvheOC7yQ4BmqWg8h58cS1gUBPM2vAeEEY2Zux92P3V9znNidimjt4
	VAJync/OU/5WmwFN6CQwH4BCjFVi2vdos/lMhYKWmmhHTcqT96NiQm2MmN9y9+RjEK/5+fSDiCW
	JgfmYnrOTPN7UYqT+bdLGG2tAtPx/JN9Nmpzn4PHM4WP0dVp+52QMr6ro2AAZRi7Ya/885C6Bi2
	noYxc+1z8Qdy8TvIvuO5skVVxphVHiOy37o05J1ZlVX6wsoegClfsbhQddOFLj7cxlNMuAvl5N/
	IvqkEwAB9GzZ5g5aX3ySUuLd1kzHQrjt5M0pWQtoBBlQxz+wUPZ8r7F83eGsOD90tpHDK867bUO
	ieEKA3fpdEsSMzSM3p9WWQFuVz/FuRJ/AQ4i8lm4U9izfrF5kIbD/bHxP50D3ScACBUBqdCZ4+M
	TPpQRJTwaE9fuZKCK0VUbNe20pYF+HyHpAtmP0FzojZWjr9y8Z/kbGk7G6236sBBg7KSrXK0hvR
	k82DXU2L7mq0FQT0p3Oh+hflGb/x0+cqZsnQm0vIYQ==
X-Received: by 2002:a05:701b:260b:b0:1a4:3169:cb with SMTP id a92af1059eb24-1b5568c581amr1912909c88.17.1795148357871;
        Thu, 19 Nov 2026 20:19:17 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:17 -0800 (PST)
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
Subject: [PATCH v4 1/8] crypto: acomp - Define a unit_size in struct acomp_req to enable batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
Date: Thu, 19 Nov 2026 20:18:59 -0800
Message-Id: <20261120041906.5785-2-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
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
index a2e0314db1cf..9a323862bd59 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -829,6 +829,12 @@ static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
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

