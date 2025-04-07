Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7881A230996
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020188; cv=none; b=pzNpjRX6ezFQECFSYIqrJxa6qq1nMk6X9tfa6CX/xCsK1FiLuFmi8zfizUudiTSCVm8zCeuEpP1AV/P/LZVX8Ri6FmgLLaBBzWZkSVf3nKzJViJZj5pqB6gatkgI5nu2ldcNFEpIFqCIvbuJ/Vc+8dqL4qIWNMv1u2xne5kxye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020188; c=relaxed/simple;
	bh=pf9eosETxgTLmxl2cLGHXPnJnLdb4XVsMMY+TJhVUdo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=SitCzkR49LDYVx6+jD1YVBI5xvS0vTSp6m1uFquHZNNY4/5duIvzfa7fTbulBRdtPwAHqqavg9dbSdpiEH9S64ifinUwk2IgxRtUJEQALS62eKNEGjXQ36edEdQ8LHe5vO+e0aZIJdfCDs62EXZkEerouaSqWBDV9/zm8zT6lCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HB2LLti7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HB2LLti7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=iVbg3InwgPsUdiqSEdT5qyK2RoZdUYzHNxc8ehG58I8=; b=HB2LLti7xrnqJoJNNO3Egc4IEj
	HHww9xIuE4KRg83TTGb4+ypOB3BktcvsR45RUjOPUe+OIuzFIDsNZGmiLyW4sKgT3djUBSZMPFAq+
	KvyOWoRX1/w+20ghylstRwRZBbdDqwYPkDMn5zRPIpqH//tKzYE5yja2a4wSu18x5ytksDXGKRNSE
	yH2fiM/L3PaU+/2pRYdVvmWSquroFx7OzWJT6KhyNGwC09DLcOnPEjAp993bLV0YoJ0MwogKcHp99
	WuMJ2RonvSpbwOMYVRe7PuxfV9dKuwZogZPKWEYk8EM2jwka8D6dtKBt8WvqmDGSjVqXm2HPEw0Fe
	bWJ70TVw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jJm-00DTIF-2L;
	Mon, 07 Apr 2025 18:03:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:03:02 +0800
Date: Mon, 07 Apr 2025 18:03:02 +0800
Message-Id: <d6befca46855e7c4a7a47b58f23e39ecfee7f13d.1744019630.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744019630.git.herbert@gondor.apana.org.au>
References: <cover.1744019630.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/7] ubifs: Use ACOMP_REQUEST_CLONE
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Switch to the new acomp API where stacks requests are used by
default and a dynamic request is only allocted when necessary.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 fs/ubifs/compress.c | 251 ++++++++++++++++++++------------------------
 1 file changed, 116 insertions(+), 135 deletions(-)

diff --git a/fs/ubifs/compress.c b/fs/ubifs/compress.c
index ea6f06adcd43..059a02691edd 100644
--- a/fs/ubifs/compress.c
+++ b/fs/ubifs/compress.c
@@ -19,6 +19,11 @@
 #include <linux/highmem.h>
 #include "ubifs.h"
 
+union ubifs_in_ptr {
+	const void *buf;
+	struct folio *folio;
+};
+
 /* Fake description object for the "none" compressor */
 static struct ubifs_compressor none_compr = {
 	.compr_type = UBIFS_COMPR_NONE,
@@ -68,28 +73,61 @@ static struct ubifs_compressor zstd_compr = {
 /* All UBIFS compressors */
 struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];
 
-static int ubifs_compress_req(const struct ubifs_info *c,
-			      struct acomp_req *req,
-			      void *out_buf, int *out_len,
-			      const char *compr_name)
+static void ubifs_compress_common(int *compr_type, union ubifs_in_ptr in_ptr,
+				  size_t in_offset, int in_len, bool in_folio,
+				  void *out_buf, int *out_len)
 {
-	struct crypto_wait wait;
-	int in_len = req->slen;
+	struct ubifs_compressor *compr = ubifs_compressors[*compr_type];
 	int dlen = *out_len;
 	int err;
 
+	if (*compr_type == UBIFS_COMPR_NONE)
+		goto no_compr;
+
+	/* If the input data is small, do not even try to compress it */
+	if (in_len < UBIFS_MIN_COMPR_LEN)
+		goto no_compr;
+
 	dlen = min(dlen, in_len - UBIFS_MIN_COMPRESS_DIFF);
 
-	crypto_init_wait(&wait);
-	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &wait);
-	acomp_request_set_dst_dma(req, out_buf, dlen);
-	err = crypto_acomp_compress(req);
-	err = crypto_wait_req(err, &wait);
-	*out_len = req->dlen;
-	acomp_request_free(req);
+	do {
+		ACOMP_REQUEST_ON_STACK(req, compr->cc);
+		DECLARE_CRYPTO_WAIT(wait);
 
-	return err;
+		acomp_request_set_callback(req, 0, NULL, NULL);
+		if (in_folio)
+			acomp_request_set_src_folio(req, in_ptr.folio,
+						    in_offset, in_len);
+		else
+			acomp_request_set_src_dma(req, in_ptr.buf, in_len);
+		acomp_request_set_dst_dma(req, out_buf, dlen);
+		err = crypto_acomp_compress(req);
+		dlen = req->dlen;
+		if (err != -EAGAIN)
+			break;
+
+		req = ACOMP_REQUEST_CLONE(req, GFP_NOFS | __GFP_NOWARN);
+		acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					   crypto_req_done, &wait);
+		err = crypto_acomp_compress(req);
+		err = crypto_wait_req(err, &wait);
+		dlen = req->dlen;
+		acomp_request_free(req);
+	} while (0);
+
+	*out_len = dlen;
+	if (err)
+		goto no_compr;
+
+	return;
+
+no_compr:
+	if (in_folio)
+		memcpy_from_folio(out_buf, in_ptr.folio, in_offset, in_len);
+	else
+		memcpy(out_buf, in_ptr.buf, in_len);
+	*out_len = in_len;
+	*compr_type = UBIFS_COMPR_NONE;
 }
 
 /**
@@ -114,32 +152,10 @@ static int ubifs_compress_req(const struct ubifs_info *c,
 void ubifs_compress(const struct ubifs_info *c, const void *in_buf,
 		    int in_len, void *out_buf, int *out_len, int *compr_type)
 {
-	int err;
-	struct ubifs_compressor *compr = ubifs_compressors[*compr_type];
+	union ubifs_in_ptr in_ptr = { .buf = in_buf };
 
-	if (*compr_type == UBIFS_COMPR_NONE)
-		goto no_compr;
-
-	/* If the input data is small, do not even try to compress it */
-	if (in_len < UBIFS_MIN_COMPR_LEN)
-		goto no_compr;
-
-	{
-		ACOMP_REQUEST_ALLOC(req, compr->cc, GFP_NOFS | __GFP_NOWARN);
-
-		acomp_request_set_src_dma(req, in_buf, in_len);
-		err = ubifs_compress_req(c, req, out_buf, out_len, compr->name);
-	}
-
-	if (err)
-		goto no_compr;
-
-	return;
-
-no_compr:
-	memcpy(out_buf, in_buf, in_len);
-	*out_len = in_len;
-	*compr_type = UBIFS_COMPR_NONE;
+	ubifs_compress_common(compr_type, in_ptr, 0, in_len, false,
+			      out_buf, out_len);
 }
 
 /**
@@ -166,55 +182,71 @@ void ubifs_compress_folio(const struct ubifs_info *c, struct folio *in_folio,
 			  size_t in_offset, int in_len, void *out_buf,
 			  int *out_len, int *compr_type)
 {
-	int err;
-	struct ubifs_compressor *compr = ubifs_compressors[*compr_type];
+	union ubifs_in_ptr in_ptr = { .folio = in_folio };
 
-	if (*compr_type == UBIFS_COMPR_NONE)
-		goto no_compr;
-
-	/* If the input data is small, do not even try to compress it */
-	if (in_len < UBIFS_MIN_COMPR_LEN)
-		goto no_compr;
-
-	{
-		ACOMP_REQUEST_ALLOC(req, compr->cc, GFP_NOFS | __GFP_NOWARN);
-
-		acomp_request_set_src_folio(req, in_folio, in_offset, in_len);
-		err = ubifs_compress_req(c, req, out_buf, out_len, compr->name);
-	}
-
-	if (err)
-		goto no_compr;
-
-	return;
-
-no_compr:
-	memcpy_from_folio(out_buf, in_folio, in_offset, in_len);
-	*out_len = in_len;
-	*compr_type = UBIFS_COMPR_NONE;
+	ubifs_compress_common(compr_type, in_ptr, in_offset, in_len, true,
+			      out_buf, out_len);
 }
 
-static int ubifs_decompress_req(const struct ubifs_info *c,
-				struct acomp_req *req,
-				const void *in_buf, int in_len, int *out_len,
-				const char *compr_name)
+static int ubifs_decompress_common(const struct ubifs_info *c,
+				   const void *in_buf, int in_len,
+				   void *out_ptr, size_t out_offset,
+				   int *out_len, bool out_folio,
+				   int compr_type)
 {
-	struct crypto_wait wait;
+	struct ubifs_compressor *compr;
+	int dlen = *out_len;
 	int err;
 
-	crypto_init_wait(&wait);
-	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &wait);
-	acomp_request_set_src_dma(req, in_buf, in_len);
-	err = crypto_acomp_decompress(req);
-	err = crypto_wait_req(err, &wait);
-	*out_len = req->dlen;
+	if (unlikely(compr_type < 0 || compr_type >= UBIFS_COMPR_TYPES_CNT)) {
+		ubifs_err(c, "invalid compression type %d", compr_type);
+		return -EINVAL;
+	}
 
+	compr = ubifs_compressors[compr_type];
+
+	if (unlikely(!compr->capi_name)) {
+		ubifs_err(c, "%s compression is not compiled in", compr->name);
+		return -EINVAL;
+	}
+
+	if (compr_type == UBIFS_COMPR_NONE) {
+		if (out_folio)
+			memcpy_to_folio(out_ptr, out_offset, in_buf, in_len);
+		else
+			memcpy(out_ptr, in_buf, in_len);
+		*out_len = in_len;
+		return 0;
+	}
+
+	do {
+		ACOMP_REQUEST_ON_STACK(req, compr->cc);
+		DECLARE_CRYPTO_WAIT(wait);
+
+		acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					   crypto_req_done, &wait);
+		acomp_request_set_src_dma(req, in_buf, in_len);
+		if (out_folio)
+			acomp_request_set_dst_folio(req, out_ptr, out_offset,
+						    dlen);
+		else
+			acomp_request_set_dst_dma(req, out_ptr, dlen);
+		err = crypto_acomp_decompress(req);
+		dlen = req->dlen;
+		if (err != -EAGAIN)
+			break;
+
+		req = ACOMP_REQUEST_CLONE(req, GFP_NOFS | __GFP_NOWARN);
+		err = crypto_acomp_decompress(req);
+		err = crypto_wait_req(err, &wait);
+		dlen = req->dlen;
+		acomp_request_free(req);
+	} while (0);
+
+	*out_len = dlen;
 	if (err)
 		ubifs_err(c, "cannot decompress %d bytes, compressor %s, error %d",
-			  in_len, compr_name, err);
-
-	acomp_request_free(req);
+			  in_len, compr->name, err);
 
 	return err;
 }
@@ -235,33 +267,8 @@ static int ubifs_decompress_req(const struct ubifs_info *c,
 int ubifs_decompress(const struct ubifs_info *c, const void *in_buf,
 		     int in_len, void *out_buf, int *out_len, int compr_type)
 {
-	struct ubifs_compressor *compr;
-
-	if (unlikely(compr_type < 0 || compr_type >= UBIFS_COMPR_TYPES_CNT)) {
-		ubifs_err(c, "invalid compression type %d", compr_type);
-		return -EINVAL;
-	}
-
-	compr = ubifs_compressors[compr_type];
-
-	if (unlikely(!compr->capi_name)) {
-		ubifs_err(c, "%s compression is not compiled in", compr->name);
-		return -EINVAL;
-	}
-
-	if (compr_type == UBIFS_COMPR_NONE) {
-		memcpy(out_buf, in_buf, in_len);
-		*out_len = in_len;
-		return 0;
-	}
-
-	{
-		ACOMP_REQUEST_ALLOC(req, compr->cc, GFP_NOFS | __GFP_NOWARN);
-
-		acomp_request_set_dst_dma(req, out_buf, *out_len);
-		return ubifs_decompress_req(c, req, in_buf, in_len, out_len,
-					    compr->name);
-	}
+	return ubifs_decompress_common(c, in_buf, in_len, out_buf, 0, out_len,
+				       false, compr_type);
 }
 
 /**
@@ -283,34 +290,8 @@ int ubifs_decompress_folio(const struct ubifs_info *c, const void *in_buf,
 			   int in_len, struct folio *out_folio,
 			   size_t out_offset, int *out_len, int compr_type)
 {
-	struct ubifs_compressor *compr;
-
-	if (unlikely(compr_type < 0 || compr_type >= UBIFS_COMPR_TYPES_CNT)) {
-		ubifs_err(c, "invalid compression type %d", compr_type);
-		return -EINVAL;
-	}
-
-	compr = ubifs_compressors[compr_type];
-
-	if (unlikely(!compr->capi_name)) {
-		ubifs_err(c, "%s compression is not compiled in", compr->name);
-		return -EINVAL;
-	}
-
-	if (compr_type == UBIFS_COMPR_NONE) {
-		memcpy_to_folio(out_folio, out_offset, in_buf, in_len);
-		*out_len = in_len;
-		return 0;
-	}
-
-	{
-		ACOMP_REQUEST_ALLOC(req, compr->cc, GFP_NOFS | __GFP_NOWARN);
-
-		acomp_request_set_dst_folio(req, out_folio, out_offset,
-					    *out_len);
-		return ubifs_decompress_req(c, req, in_buf, in_len, out_len,
-					    compr->name);
-	}
+	return ubifs_decompress_common(c, in_buf, in_len, out_folio,
+				       out_offset, out_len, true, compr_type);
 }
 
 /**
-- 
2.39.5

