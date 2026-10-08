Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1494D7D37
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 18:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484124; cv=none; b=tEJQzM9wFWqhvj0864+a/dJkP+vbwa9JGUoVZo2X6EEiZNIP5KU8krLJrWGX5008yWWStXuUOTr9o0oKL49APDOvk7oIvgjs0GHegRT8Q4ZlyFjSi2WknmSUKExICSDHMHd0e69MX2eY4RQpjkzL3HxvH+dCegRbVKh4qgSIH+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484124; c=relaxed/simple;
	bh=IWTcp+2eziHJnOl2KhgfP+D2FcrXHN82wx6V+Ldr0lI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YzKRGBfJNVU+ocaXoe/Iw5OtCF2CptoDX2Z4JhnEPtZUQI4ROItmOOJEQ1Og5GUgkNY/iljSOmyKXz0qWD8sSxUxOonXq0IKkx4ujpmbLjgH6eozNYWYfXICGwl0m0X8+D2yhFGqBRnsxtplW8cghzzNvSGg6GNI5LGQsJWdIhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fxk+uqBp; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fxk+uqBp"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-154e9d2d979so3450305c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 11:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484110; x=1792088910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KHEkYAP4Kvw/D7tGM2EVPaorXMSyBP1fknjXL4EHP88=;
        b=Fxk+uqBpcLqIfbSEMoQGoaFpZAEQVuC+u7uo0A4Yy2E4TGFZ2mR/quM286XG9HOFNe
         PkOx/dorFsBr6omKvEJsexMMhRmqhBYHwa1AdcYsVGFcRVCBmFnbG6aVjTz5kksNvg2p
         yYgJBpgrDZO/2vMTaAIuvXzXAawFjWmDcj5t7MvJeBPU8yfbHMiysmSINwR+PirgJ9tZ
         tUX6pFqvMgmU4Cnkf57HvdpzZq2i3gishz9V/Lue5f6e6FW0hliybpydJZmClPznr12T
         ogIN1jhYe3aZEaw2JfZHooAb3uSSfpLMkYAk7KA1raOB1Tm5EOlVIl8gqvIoV4cZd2yw
         VPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484110; x=1792088910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KHEkYAP4Kvw/D7tGM2EVPaorXMSyBP1fknjXL4EHP88=;
        b=UZPN/D7lR/DrSMFr5iXZmYhDscUAY7GthAPPdihUhVhUvbgESIBdgHxzzsT2CeJ0N3
         bc9knmiX5bzHS7h6d9jAbYuPwoxORaB8SUkZr59aYTPw0ytxyNPQfECMjmKPY5H2PTgv
         M9dWjp1EvArI1kC8RFISHswsjovABBudTbc8KARegUfNvLz1c1fL6sOdokko1kuqAiz/
         TG5RW/Az76wiQh/i2bj0MuwWq3wX3ZvLk5Be7ojO4ldKjfYDpYc4+Wh7G1DChCSHqjbh
         yTT1oLaueRqZstPm6AlwMXwP0Ef9cYJ8jZWrsAsc62UODnmpdxFiPPqVovI02gw1nVfr
         MNUQ==
X-Forwarded-Encrypted: i=1; AKwUvByR9SLJwOMPEaznZN0NNEbBjsScJT0aa+VKiTslGJMgx8BEy1f6npLAVKE2yR6W5EFFfqeT+NpWX7uIUeI=@vger.kernel.org
X-Gm-Message-State: AFuF++kCwf09OJjxvN7VoCrimZ16frBJkSlHvRl0L+LGlERBLVFDMxV2
	gaGEMxtn0j+cqi8bqAg2Cq5sUtj6Baq3NLks6O/aSl8kj5Wy8qDrgkgD
X-Gm-Gg: AYBFou1NcqCNb+VKr5uh+DaeXduoPnPpFbqZVmm01YrRLEfcm0frZJ6zgwrpGajm4fm
	lb2n81lFr2weDHvtsCH4ULPliaoAQjwYwMx8Y8vfihASELLmRQ7nCzwPhDKQIirR+jqzUpXtOh4
	bsH+blkF4OG34GXYIvWd7YeMhzpSH4E0mwbMax3SP2N8OEh3DLQwMkipsR00edMvrdcYPXtIlBp
	O48oHlvd1AjDCqHUe6eAEm46uXdI3GyTVM3AfbG0+QZt6i+j77VsTimMPwppIKVBWdeVL8Hnunv
	b+ZlzrrmT3J3PakNjRUhQU/qMVHVLYqgT4N2Ke4O/F7At3eP8IYZmeAM9mjySu8KtHn90ytprW4
	q6r+e+0OjWw25F87KurBQUZouZV0tRTU/1J1FdvndCQle6C/lScZScFns3B/dgNuVlZ4A4moOFN
	NB4FVZYk41JoeUO2PInmnSw4goDC+mGEv6kYmOjYCL90eV/6z+6H3lNK02pWKmgwvOZI67lWsPd
	VmK4/NnoiA=
X-Received: by 2002:a05:7022:5f04:b0:15c:20b8:7973 with SMTP id a92af1059eb24-165a3e83adfmr3350053c88.6.1791484110399;
        Thu, 08 Oct 2026 11:28:30 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:29 -0700 (PDT)
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
Subject: [PATCH v1 1/8] crypto: acomp - Define a unit_size in struct acomp_req to enable batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
Date: Thu,  8 Oct 2026 11:28:07 -0700
Message-Id: <20261008182814.27450-2-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
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

In zswap_cpu_comp_prepare(), after the call to
acomp_request_set_callback(), we set the unit size for zswap to
PAGE_SIZE.

      acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);

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
index ae19e301fced..ca513a9f89e3 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -845,6 +845,12 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
+	/*
+	 * This should be called after acomp_request_set_callback(),
+	 * which initializes req->unit_size to 0.
+	 */
+	acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);
+
 	mutex_init(&acomp_ctx->mutex);
 	return 0;
 
-- 
2.39.5

