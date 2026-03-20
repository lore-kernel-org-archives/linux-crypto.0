Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F0E3A75A8
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 21:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774043493; cv=none; b=VQGzYiXM5YZkCV8fGBM5c7aOwG4l1I/KiahVPxj6ud+H4h7N4z54QMzcvGRJco4fD/Pa50CUxeo7jmbrjRrmWf7jnX0FL5SbLMG0ZU0R5rcve82Zn40WD3+M1/rmc4yWH8/8q6KVxjDycwOJH9SO+urfSBVyjiA/k46n0wo6qNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774043493; c=relaxed/simple;
	bh=M5uuJj6H5j5o7MY8GZQVZDKOwVD70YVutRRi674j9vc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p2oyP3quUizQ8BrAcMMmBsDw2id+iigOs1e+4bXgKrOYgGAk1wjXSAR63C/jsau2AKp4o6+QYD68zr5DwAAxoQke08S4Y0jLK/lXpLvtzRLqgW9Y7IlcTjVHMGqBhswBOKaHh+ZHn+ekvKjcZXZ5ewv/frOPAl7Mw0F9W9h67Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eWB/5e/+; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eWB/5e/+"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d7eb85fb81so1340137a34.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 14:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774043490; x=1774648290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IGXNy+HMPOOSjFyvvOU7ENU9RYAs70/3AGVGPc75sz8=;
        b=eWB/5e/+QfmQn2wqnPfrJKLNaJnO0BVsNc6WL/xqo4+Bhou/8ETrtxr5hEZ2vYy/E8
         Jk1kyQrwwhHQlJVJaZHpa23zBJAEHhFcaH3A5/JtIWSiLUw5VbKYO49eqCutqRiIcheJ
         lvYiLwZrsqB2LXQwHvtrqATr90WpBUaUzgjiYv0i6+yB0biFWcW9Yn2tmzqhKGKkg2b8
         7EqKWwk93H1p3HeWtiC2MAQd2IyXW7BN85h/uAQzBVpZ9AcOL6qHI+T2+6eimDE0a0Jm
         BL1Km/vDkFDWBNxfX3iWa1q+pZPDkZVq6UhcMweS1GWdt4iPakMhOb3s/93SBWbFpfsM
         9/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774043490; x=1774648290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGXNy+HMPOOSjFyvvOU7ENU9RYAs70/3AGVGPc75sz8=;
        b=JUUfF1TDec98xbeGl19J0C15hox2VuA5k6R25+Vq01GKZTGckuIg0hFg+iJXoUjN7b
         JsQ2hQvQZeK/QCU817d5didHFwcPC+OZ0AhKdT9ZddRUSF097OCK936zmcGasGqbZ3pW
         at7G8i+4+NP55RDEi3XAMXY2nRW7YmLBwo8y2ZOF8Lvoah8MtguCmlh0+sxm6IlS9NQ3
         jp0b8TqkzDcP8+RIlsjNGcmvEBjutHOECZ7pDc82XXcUhMP71DqGnZeM6QbRbhuj91OJ
         tzeyBied8pRxDWNb3VfobTg+0xwXgNUpPZsv8B1r6Gj0NnwJOJ76NfHP+5BnWLw65Wqv
         Wg5A==
X-Forwarded-Encrypted: i=1; AJvYcCXyXZqipJ+UIYYHiuWYIVfhvzk1g9w634OaOFAZxUi0UNUmziRytsuvsu97lpd2zLdgiNr1EmwTD6frfxo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7UWzJLV3HDyqY5L6HETCbfKUF9xcK0DhpduL8URTKhY5DHJ3p
	J2fVbRcoIw+BVDV9kVJ26L51FpnYewAYoapKfEC/Gb2TYPoQDCZPwe7f
X-Gm-Gg: ATEYQzwOBYFB1UewX/D8fQhOuE0gNkiIZcgDzaaZJBVXBKZZqw88kACKX90Z7u96aZZ
	G583WlbxhJns5e2SJDNKrvxx4h8Xcorv3ODTH7P/+A4zJ7fEkkh9/OdQdgUzhajZtMBdP0gbytD
	2yW0hFHniZdoZfNVUo/fPbxRLLfbFNUGFhwn5fljnoukqhT/alfpAs6CcEr+TKwdrQOApKCo6ho
	oZV9v4kEq9+Sm2hVhcMgr6/Cv/M/ihTasRVYAebpY7q6yATXa7q8hHa1MIiAKDNXZnD1DXaKVY4
	4w79h9bzI5ASqU3q1ZPvX+uB9yZNKkZ2uYvUSqxuP8fDal/9yb+nMANydOQs+XrQIc0n6FZGpBh
	KS6poYgogVohyz0/hd0AUxDEusbDX3wnWoNfbRJDBLRXF8h361dCLsjxHDGNdENYBZSgVm4GOhr
	CQcPyVtQcNqbD+K+x5ML7eIBKZ04g5RL37tJG/OAF/Shb+Pb843vLBGE4t6jUOk5qlEiHtu1y6u
	aziKOsgJ3b4pkqhWkW8/mTOEJbb4os/Qbpmp/m+RQ==
X-Received: by 2002:a05:6830:83a9:b0:7d7:c911:1829 with SMTP id 46e09a7af769-7d7eaf6c25amr3520951a34.16.1774043489663;
        Fri, 20 Mar 2026 14:51:29 -0700 (PDT)
Received: from Atwell-Laptop.. (108-212-132-20.lightspeed.irvnca.sbcglobal.net. [108.212.132.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7eadce96dsm3172347a34.18.2026.03.20.14.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 14:51:29 -0700 (PDT)
From: Wesley Atwell <atwellwea@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wesley Atwell <atwellwea@gmail.com>
Subject: [PATCH v2] crypto: zstd - fix segmented acomp streaming paths
Date: Fri, 20 Mar 2026 15:51:24 -0600
Message-ID: <20260320215124.389938-1-atwellwea@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The zstd acomp implementation does not correctly handle segmented
source and destination walks.

The compression path advances the destination walk by the full
segment length rather than the bytes actually produced, and it only
calls zstd_end_stream() once even though the streaming API requires it
to be called until it returns 0. With segmented destinations this can
leave buffered output behind and misaccount the walk progress.

The decompression path has the same destination accounting issue, and
it stops when the source walk is exhausted even if
zstd_decompress_stream() has not yet reported that the frame is fully
decoded and flushed. That can report success too early for segmented
requests and incomplete frames.

Fix both streaming paths by advancing destination segments by actual
output bytes, refilling destination segments as needed, draining
zstd_end_stream() until completion, and continuing to flush buffered
decompression output after the source walk is exhausted. Return
-EINVAL if decompression cannot finish once the input has been fully
consumed.

Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
Assisted-by: Codex:GPT-5
Signed-off-by: Wesley Atwell <atwellwea@gmail.com>
---
Changes in v2:
- always finalize acomp walk mappings in the direct one-shot paths
- add mapped src/dst cleanup on streaming error exits
- reacquire a destination segment in decompression before resuming after a
  full output-chunk completion

Local validation:
- built bzImage with CONFIG_CRYPTO_SELFTESTS=y and
  CONFIG_CRYPTO_SELFTESTS_FULL=y
- exercised segmented zstd acomp requests using temporary local testmgr
  scaffolding
- booted under virtme and verified zstd-generic selftest passed in
  /proc/crypto

diff --git a/crypto/zstd.c b/crypto/zstd.c
index 556f5d2bdd5f..3fb04acf6b7f 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -94,18 +94,32 @@ static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
 	return 0;
 }
 
+static int zstd_acomp_next_dst(struct acomp_walk *walk, zstd_out_buffer *outbuf)
+{
+	unsigned int dcur = acomp_walk_next_dst(walk);
+
+	if (!dcur)
+		return -ENOSPC;
+
+	outbuf->pos = 0;
+	outbuf->dst = walk->dst.virt.addr;
+	outbuf->size = dcur;
+
+	return 0;
+}
+
 static int zstd_compress(struct acomp_req *req)
 {
 	struct crypto_acomp_stream *s;
-	unsigned int pos, scur, dcur;
+	unsigned int scur;
 	unsigned int total_out = 0;
-	bool data_available = true;
+	bool src_mapped = false;
+	bool dst_mapped = false;
 	zstd_out_buffer outbuf;
 	struct acomp_walk walk;
 	zstd_in_buffer inbuf;
 	struct zstd_ctx *ctx;
-	size_t pending_bytes;
-	size_t num_bytes;
+	size_t remaining;
 	int ret;
 
 	s = crypto_acomp_lock_stream_bh(&zstd_streams);
@@ -121,60 +135,102 @@ static int zstd_compress(struct acomp_req *req)
 		goto out;
 	}
 
-	do {
-		dcur = acomp_walk_next_dst(&walk);
-		if (!dcur) {
-			ret = -ENOSPC;
+	ret = zstd_acomp_next_dst(&walk, &outbuf);
+	if (ret)
+		goto out;
+	dst_mapped = true;
+
+	for (;;) {
+		scur = acomp_walk_next_src(&walk);
+		src_mapped = scur;
+		if (outbuf.size == req->dlen && scur == req->slen) {
+			ret = zstd_compress_one(req, ctx, walk.src.virt.addr,
+						walk.dst.virt.addr, &total_out);
+			acomp_walk_done_src(&walk, scur);
+			src_mapped = false;
+			acomp_walk_done_dst(&walk, ret ? outbuf.size : total_out);
+			dst_mapped = false;
 			goto out;
 		}
 
-		outbuf.pos = 0;
-		outbuf.dst = (u8 *)walk.dst.virt.addr;
-		outbuf.size = dcur;
+		if (!scur)
+			break;
+
+		inbuf.pos = 0;
+		inbuf.src = walk.src.virt.addr;
+		inbuf.size = scur;
 
 		do {
-			scur = acomp_walk_next_src(&walk);
-			if (dcur == req->dlen && scur == req->slen) {
-				ret = zstd_compress_one(req, ctx, walk.src.virt.addr,
-							walk.dst.virt.addr, &total_out);
-				acomp_walk_done_src(&walk, scur);
-				acomp_walk_done_dst(&walk, dcur);
-				goto out;
+			remaining = zstd_compress_stream(ctx->cctx, &outbuf, &inbuf);
+			if (zstd_is_error(remaining)) {
+				ret = -EIO;
+				goto out_free_walk;
 			}
 
-			if (scur) {
-				inbuf.pos = 0;
-				inbuf.src = walk.src.virt.addr;
-				inbuf.size = scur;
-			} else {
-				data_available = false;
-				break;
+			if (outbuf.pos != outbuf.size) {
+				if (inbuf.pos == inbuf.size)
+					break;
+				continue;
 			}
 
-			num_bytes = zstd_compress_stream(ctx->cctx, &outbuf, &inbuf);
-			if (ZSTD_isError(num_bytes)) {
-				ret = -EIO;
-				goto out;
+			total_out += outbuf.pos;
+			acomp_walk_done_dst(&walk, outbuf.pos);
+			dst_mapped = false;
+
+			ret = zstd_acomp_next_dst(&walk, &outbuf);
+			if (ret)
+				goto out_free_walk;
+			dst_mapped = true;
+		} while (inbuf.pos != inbuf.size);
+
+		acomp_walk_done_src(&walk, inbuf.pos);
+		src_mapped = false;
+	}
+
+	for (;;) {
+		remaining = zstd_end_stream(ctx->cctx, &outbuf);
+		if (zstd_is_error(remaining)) {
+			ret = -EIO;
+			goto out_free_walk;
+		}
+
+		if (outbuf.pos == outbuf.size) {
+			total_out += outbuf.pos;
+			acomp_walk_done_dst(&walk, outbuf.pos);
+			dst_mapped = false;
+
+			if (!remaining) {
+				outbuf.pos = 0;
+				break;
 			}
 
-			pending_bytes = zstd_flush_stream(ctx->cctx, &outbuf);
-			if (ZSTD_isError(pending_bytes)) {
-				ret = -EIO;
+			ret = zstd_acomp_next_dst(&walk, &outbuf);
+			if (ret)
 				goto out;
-			}
-			acomp_walk_done_src(&walk, inbuf.pos);
-		} while (dcur != outbuf.pos);
+			dst_mapped = true;
+
+			continue;
+		}
+
+		if (!remaining)
+			break;
+	}
 
+	if (outbuf.pos) {
 		total_out += outbuf.pos;
-		acomp_walk_done_dst(&walk, dcur);
-	} while (data_available);
+		acomp_walk_done_dst(&walk, outbuf.pos);
+		dst_mapped = false;
+	}
 
-	pos = outbuf.pos;
-	num_bytes = zstd_end_stream(ctx->cctx, &outbuf);
-	if (ZSTD_isError(num_bytes))
-		ret = -EIO;
-	else
-		total_out += (outbuf.pos - pos);
+out_free_walk:
+	if (src_mapped)
+		acomp_walk_done_src(&walk, inbuf.pos);
+	if (dst_mapped)
+		/*
+		 * The streaming helpers can fail after dirtying part of the
+		 * current destination chunk while leaving outbuf.pos stale.
+		 */
+		acomp_walk_done_dst(&walk, ret ? outbuf.size : outbuf.pos);
 
 out:
 	if (ret)
@@ -209,12 +265,14 @@ static int zstd_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp_stream *s;
 	unsigned int total_out = 0;
-	unsigned int scur, dcur;
+	unsigned int scur;
+	bool src_mapped = false;
+	bool dst_mapped = false;
 	zstd_out_buffer outbuf;
 	struct acomp_walk walk;
 	zstd_in_buffer inbuf;
 	struct zstd_ctx *ctx;
-	size_t pending_bytes;
+	size_t remaining = 1;
 	int ret;
 
 	s = crypto_acomp_lock_stream_bh(&zstd_streams);
@@ -230,48 +288,128 @@ static int zstd_decompress(struct acomp_req *req)
 		goto out;
 	}
 
-	do {
+	ret = zstd_acomp_next_dst(&walk, &outbuf);
+	if (ret)
+		goto out;
+	dst_mapped = true;
+
+	for (;;) {
 		scur = acomp_walk_next_src(&walk);
-		if (scur) {
-			inbuf.pos = 0;
-			inbuf.size = scur;
-			inbuf.src = walk.src.virt.addr;
-		} else {
+		src_mapped = scur;
+		if (!scur)
 			break;
+
+		inbuf.pos = 0;
+		inbuf.size = scur;
+		inbuf.src = walk.src.virt.addr;
+
+		if (!dst_mapped) {
+			ret = zstd_acomp_next_dst(&walk, &outbuf);
+			if (ret)
+				goto out_free_walk;
+			dst_mapped = true;
+		}
+
+		if (outbuf.size == req->dlen && scur == req->slen) {
+			ret = zstd_decompress_one(req, ctx, walk.src.virt.addr,
+						  walk.dst.virt.addr, &total_out);
+			acomp_walk_done_src(&walk, scur);
+			src_mapped = false;
+			acomp_walk_done_dst(&walk, ret ? outbuf.size : total_out);
+			dst_mapped = false;
+			goto out;
 		}
 
 		do {
-			dcur = acomp_walk_next_dst(&walk);
-			if (dcur == req->dlen && scur == req->slen) {
-				ret = zstd_decompress_one(req, ctx, walk.src.virt.addr,
-							  walk.dst.virt.addr, &total_out);
-				acomp_walk_done_dst(&walk, dcur);
-				acomp_walk_done_src(&walk, scur);
-				goto out;
+			remaining = zstd_decompress_stream(ctx->dctx, &outbuf,
+							   &inbuf);
+			if (zstd_is_error(remaining)) {
+				ret = -EIO;
+				goto out_free_walk;
 			}
 
-			if (!dcur) {
-				ret = -ENOSPC;
-				goto out;
+			if (outbuf.pos != outbuf.size) {
+				if (inbuf.pos == inbuf.size)
+					break;
+				continue;
 			}
 
-			outbuf.pos = 0;
-			outbuf.dst = (u8 *)walk.dst.virt.addr;
-			outbuf.size = dcur;
+			total_out += outbuf.pos;
+			acomp_walk_done_dst(&walk, outbuf.pos);
+			dst_mapped = false;
 
-			pending_bytes = zstd_decompress_stream(ctx->dctx, &outbuf, &inbuf);
-			if (ZSTD_isError(pending_bytes)) {
-				ret = -EIO;
-				goto out;
+			if (!remaining) {
+				outbuf.pos = 0;
+				break;
 			}
 
-			total_out += outbuf.pos;
+			ret = zstd_acomp_next_dst(&walk, &outbuf);
+			if (ret)
+				goto out_free_walk;
+			dst_mapped = true;
+		} while (inbuf.pos != inbuf.size);
 
-			acomp_walk_done_dst(&walk, outbuf.pos);
-		} while (inbuf.pos != scur);
+		acomp_walk_done_src(&walk, inbuf.pos);
+		src_mapped = false;
+	}
+
+	inbuf.pos = 0;
+	inbuf.size = 0;
+	inbuf.src = NULL;
+
+	/* Drain any buffered output after the source walk is exhausted. */
+	while (remaining) {
+		size_t pos = outbuf.pos;
+
+		remaining = zstd_decompress_stream(ctx->dctx, &outbuf, &inbuf);
+		if (zstd_is_error(remaining)) {
+			ret = -EIO;
+			goto out_free_walk;
+		}
+
+		if (outbuf.pos == pos) {
+			ret = -EINVAL;
+			goto out_free_walk;
+		}
+
+		if (outbuf.pos != outbuf.size) {
+			if (remaining) {
+				ret = -EINVAL;
+				goto out_free_walk;
+			}
+			break;
+		}
+
+		total_out += outbuf.pos;
+		acomp_walk_done_dst(&walk, outbuf.pos);
+		dst_mapped = false;
+
+		if (!remaining) {
+			outbuf.pos = 0;
+			break;
+		}
+
+		ret = zstd_acomp_next_dst(&walk, &outbuf);
+		if (ret)
+			goto out;
+		dst_mapped = true;
+	}
+
+	if (outbuf.pos) {
+		total_out += outbuf.pos;
+		acomp_walk_done_dst(&walk, outbuf.pos);
+		dst_mapped = false;
+	}
 
-		acomp_walk_done_src(&walk, scur);
-	} while (ret == 0);
+out_free_walk:
+	if (src_mapped)
+		acomp_walk_done_src(&walk, inbuf.pos);
+	if (dst_mapped)
+		/*
+		 * The streaming helpers can fail after dirtying part of the
+		 * current destination chunk while leaving outbuf.pos stale.
+		 */
+		acomp_walk_done_dst(&walk, ret ? outbuf.size : outbuf.pos);
 
 out:
 	if (ret)
base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
-- 
2.34.1
