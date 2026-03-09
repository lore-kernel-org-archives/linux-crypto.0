Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E71136656C
	for <linux-crypto@vger.kernel.org>; Mon,  9 Mar 2026 08:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773044497; cv=none; b=fEKaMHb9UbaaWyL38CdDbpyk8ogWTWIKERSRa16BWUBU9K0TzbafIadHwpyY9/cNLqumopCYg3upGVymNnhiwj2KdNPRrPjQaeeuVHmXy7J6gTJz57XEX5IYfSNHDtkOYkMk85UKx5HzFjtlwSskFjtSidjELAYBPRcA7fubbe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773044497; c=relaxed/simple;
	bh=ae8oC6M24RmGbgaPYEriiD8mhYaapi3fMrA0MRSkwkU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DiNjFnGQQ2sDy3fiTRokSGUS+JvVQwEVW2gKfmzNR/WXDAk+IPmNBvpg3VO8Yi7Guk4bpvmH6me/HE0mFs7bMWW6KZNUOKNTIEKMsgxSYJJy6waupNvVSKx2641iXNqy9ZToWMTaTBsKGcTXgGrorzMDnMjZy8SCRTO/lLLQi+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HlQPjY6X; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HlQPjY6X"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d7412cfb9eso840522a34.1
        for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2026 01:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773044495; x=1773649295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LYplohEROQ/aWKluUhy32Hw7e1z7Llc/p+3/sITdRrk=;
        b=HlQPjY6Xfhd0NjJbKzHiTYJcpRMvCEEt+LLsHF4Cwu19IuN+8rVoCUM6yakW9JHOrS
         xzg2o0JMTX9M63EME6ZdyyA7ghzTMl0HQN4SxQrAtJrl7hMwQOwDu+0dOhooNpaqF4Al
         BrVHBFCXYtMGU+Yuv6BRm07X7CoZtUeqTRIeAxCXppufM6eKIeWKD3D0lgKwGE1+L3t2
         V015sOwFM/hC46p6UculaN+MpmnNOZrxrwhRIPw8a3NaLXVbi44tdT+iqCOZ1HYb9iXi
         Y4xi3huoHE295uapYo6qgvKXjXxXABXYJPq6DJct3Ljx+M0493/5b8EZu//H12RTJXgz
         Lr6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773044495; x=1773649295;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LYplohEROQ/aWKluUhy32Hw7e1z7Llc/p+3/sITdRrk=;
        b=gHyAqZcHX58DD2jVijUC6bk0VgJcmh79eQsR0GIEOBCjM84om9nMl3z/N8DDmy3sJ+
         3aCbcjNPctsYW+puxPtjp6IgpfUdLDVk8AHxwUyNF+K1T2wBrv9A8qYAGgiq29IF4lVD
         /8c2p6FLbLzkFPy7FLROhojoHMNM+OcftioxEzAbzNALBPaDE3HqAl4U8p/1qX13FaIA
         KFo3Frt71Tm5WIdi4J4F5RyE22huBaGk2qUgA9JQUIE+Z/djfJ2jmUeItIpd4OCSUqX3
         NOxEOA+SPWmD+hWSYIC6trcUKEQxsImv0z3g+UVd/fCyp5v9/1IthwI0YfsLk3TXZE+b
         5gQQ==
X-Gm-Message-State: AOJu0YzZ5XEm7oYWSULDip1hHZdx6b8V7fsXGxNk9qsVqCMYnvgD79/4
	BbwW3q+0Tg2pzHD49aP2jYNxH5K8JoHY58RKpw/pZ1xI5BNwFwjzz3XO9KQf83UjRZg=
X-Gm-Gg: ATEYQzw3siigVCtsYmRubYh3bmmwz0GZBsZtS7TkZYTT6oCuw12Gr48urzjKk6J8mb/
	l+DWxaM5ODZAqLHttS5WQ0w8vGvQ/9lod8mspXTrq6mhty3LJbwWZS/ndjwTJJbSZE0zGO8FvwH
	FmrT51szcoomb0CWsS8gEHwPPiYuXYk+dMyNzV+FAb4LZocLzS11zphGtkjV6WEnflIrdjqrf5z
	vc9BIgvPUElhymT2Owbw77EFeQKYheu6HNltOgLGQ19iz9IyQFaNn0l6u+7qvP5UDJHudk/I/sR
	bZRQd+M+bRfh22isXj5l+PXJFJa5dMrDcUUkC9BAcQPRiEj0M1sOTEIOFTLrR2NXpfIOCRGtHyi
	xGNh5ORC3qxe7r+szGMdUg4wwkEUM+X/xBYxhAHteCEwfHkkG12lLp9+t8YwBOl5/Z4i/OnMggB
	XFGXenf4lAXeueXyxyDriFDaQpjszv8hVglwjSzEQtFzNgBcytRRBGjkl26LYQc+mLNh+gYmPAc
	KuCLiWC9e70C6oxqvTxjXuOw1aJBp4F/g69tFNfOSJFkBx9
X-Received: by 2002:a05:6830:d18:b0:7c7:2c3c:690e with SMTP id 46e09a7af769-7d72707f403mr5596943a34.35.1773044495036;
        Mon, 09 Mar 2026 01:21:35 -0700 (PDT)
Received: from localhost.localdomain (108-212-132-20.lightspeed.irvnca.sbcglobal.net. [108.212.132.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d74a4cdd70sm1709788a34.12.2026.03.09.01.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 01:21:34 -0700 (PDT)
From: Wesley Atwell <atwellwea@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	terrelln@fb.com,
	dsterba@suse.com,
	giovanni.cabiddu@intel.com,
	suman.kumar.chakraborty@intel.com
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wesley Atwell <atwellwea@gmail.com>
Subject: [PATCH] crypto: zstd - fix segmented acomp streaming paths
Date: Mon,  9 Mar 2026 02:20:51 -0600
Message-Id: <20260309082051.2087363-1-atwellwea@gmail.com>
X-Mailer: git-send-email 2.34.1
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
to be called until it returns 0.  With segmented destinations this can
leave buffered output behind and misaccount the walk progress.

The decompression path has the same destination accounting issue, and
it stops when the source walk is exhausted even if
zstd_decompress_stream() has not yet reported that the frame is fully
decoded and flushed.  That can report success too early for segmented
requests and incomplete frames.

Fix both streaming paths by advancing destination segments by actual
output bytes, refilling destination segments as needed, draining
zstd_end_stream() until completion, and continuing to flush buffered
decompression output after the source walk is exhausted.  Return
-EINVAL if decompression cannot finish once the input has been fully
consumed.

Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
Assisted-by: Codex:GPT-5
Signed-off-by: Wesley Atwell <atwellwea@gmail.com>
---
Local validation:
- built bzImage with CONFIG_CRYPTO_SELFTESTS=y and CONFIG_CRYPTO_SELFTESTS_FULL=y
- exercised segmented zstd acomp requests using temporary local testmgr scaffolding
- booted under virtme and verified zstd-generic selftest passed in /proc/crypto

 crypto/zstd.c | 228 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 156 insertions(+), 72 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index 556f5d2bdd5f..3e19da1fed22 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -94,18 +94,30 @@ static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
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
 	zstd_out_buffer outbuf;
 	struct acomp_walk walk;
 	zstd_in_buffer inbuf;
 	struct zstd_ctx *ctx;
-	size_t pending_bytes;
-	size_t num_bytes;
+	size_t remaining;
 	int ret;
 
 	s = crypto_acomp_lock_stream_bh(&zstd_streams);
@@ -115,66 +127,87 @@ static int zstd_compress(struct acomp_req *req)
 	if (ret)
 		goto out;
 
+	ret = zstd_acomp_next_dst(&walk, &outbuf);
+	if (ret)
+		goto out;
+
 	ctx->cctx = zstd_init_cstream(&ctx->params, 0, ctx->wksp, ctx->wksp_size);
 	if (!ctx->cctx) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	do {
-		dcur = acomp_walk_next_dst(&walk);
-		if (!dcur) {
-			ret = -ENOSPC;
+	for (;;) {
+		scur = acomp_walk_next_src(&walk);
+		if (outbuf.size == req->dlen && scur == req->slen) {
+			ret = zstd_compress_one(req, ctx, walk.src.virt.addr,
+						walk.dst.virt.addr, &total_out);
+			if (!ret) {
+				acomp_walk_done_src(&walk, scur);
+				acomp_walk_done_dst(&walk, total_out);
+			}
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
+			remaining = zstd_compress_stream(ctx->cctx, &outbuf, &inbuf);
+			if (zstd_is_error(remaining)) {
+				ret = -EIO;
 				goto out;
 			}
 
-			if (scur) {
-				inbuf.pos = 0;
-				inbuf.src = walk.src.virt.addr;
-				inbuf.size = scur;
-			} else {
-				data_available = false;
-				break;
-			}
+			if (outbuf.pos != outbuf.size)
+				continue;
 
-			num_bytes = zstd_compress_stream(ctx->cctx, &outbuf, &inbuf);
-			if (ZSTD_isError(num_bytes)) {
-				ret = -EIO;
+			total_out += outbuf.pos;
+			acomp_walk_done_dst(&walk, outbuf.pos);
+
+			ret = zstd_acomp_next_dst(&walk, &outbuf);
+			if (ret)
 				goto out;
+		} while (inbuf.pos != inbuf.size);
+
+		acomp_walk_done_src(&walk, inbuf.pos);
+	}
+
+	for (;;) {
+		remaining = zstd_end_stream(ctx->cctx, &outbuf);
+		if (zstd_is_error(remaining)) {
+			ret = -EIO;
+			goto out;
+		}
+
+		if (outbuf.pos == outbuf.size) {
+			total_out += outbuf.pos;
+			acomp_walk_done_dst(&walk, outbuf.pos);
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
 
-		total_out += outbuf.pos;
-		acomp_walk_done_dst(&walk, dcur);
-	} while (data_available);
+			continue;
+		}
 
-	pos = outbuf.pos;
-	num_bytes = zstd_end_stream(ctx->cctx, &outbuf);
-	if (ZSTD_isError(num_bytes))
-		ret = -EIO;
-	else
-		total_out += (outbuf.pos - pos);
+		if (!remaining)
+			break;
+	}
+
+	if (outbuf.pos) {
+		total_out += outbuf.pos;
+		acomp_walk_done_dst(&walk, outbuf.pos);
+	}
 
 out:
 	if (ret)
@@ -209,12 +242,12 @@ static int zstd_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp_stream *s;
 	unsigned int total_out = 0;
-	unsigned int scur, dcur;
+	unsigned int scur;
 	zstd_out_buffer outbuf;
 	struct acomp_walk walk;
 	zstd_in_buffer inbuf;
 	struct zstd_ctx *ctx;
-	size_t pending_bytes;
+	size_t remaining = 1;
 	int ret;
 
 	s = crypto_acomp_lock_stream_bh(&zstd_streams);
@@ -224,54 +257,105 @@ static int zstd_decompress(struct acomp_req *req)
 	if (ret)
 		goto out;
 
+	ret = zstd_acomp_next_dst(&walk, &outbuf);
+	if (ret)
+		goto out;
+
 	ctx->dctx = zstd_init_dstream(ZSTD_MAX_SIZE, ctx->wksp, ctx->wksp_size);
 	if (!ctx->dctx) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	do {
+	for (;;) {
 		scur = acomp_walk_next_src(&walk);
-		if (scur) {
-			inbuf.pos = 0;
-			inbuf.size = scur;
-			inbuf.src = walk.src.virt.addr;
-		} else {
-			break;
+		if (outbuf.size == req->dlen && scur == req->slen) {
+			ret = zstd_decompress_one(req, ctx, walk.src.virt.addr,
+						  walk.dst.virt.addr, &total_out);
+			if (!ret) {
+				acomp_walk_done_src(&walk, scur);
+				acomp_walk_done_dst(&walk, total_out);
+			}
+			goto out;
 		}
 
+		if (!scur)
+			break;
+
+		inbuf.pos = 0;
+		inbuf.size = scur;
+		inbuf.src = walk.src.virt.addr;
+
 		do {
-			dcur = acomp_walk_next_dst(&walk);
-			if (dcur == req->dlen && scur == req->slen) {
-				ret = zstd_decompress_one(req, ctx, walk.src.virt.addr,
-							  walk.dst.virt.addr, &total_out);
-				acomp_walk_done_dst(&walk, dcur);
-				acomp_walk_done_src(&walk, scur);
+			remaining = zstd_decompress_stream(ctx->dctx, &outbuf, &inbuf);
+			if (zstd_is_error(remaining)) {
+				ret = -EIO;
 				goto out;
 			}
 
-			if (!dcur) {
-				ret = -ENOSPC;
-				goto out;
+			if (outbuf.pos != outbuf.size)
+				continue;
+
+			total_out += outbuf.pos;
+			acomp_walk_done_dst(&walk, outbuf.pos);
+
+			if (!remaining) {
+				outbuf.pos = 0;
+				break;
 			}
 
-			outbuf.pos = 0;
-			outbuf.dst = (u8 *)walk.dst.virt.addr;
-			outbuf.size = dcur;
+			ret = zstd_acomp_next_dst(&walk, &outbuf);
+			if (ret)
+				goto out;
+		} while (inbuf.pos != scur);
 
-			pending_bytes = zstd_decompress_stream(ctx->dctx, &outbuf, &inbuf);
-			if (ZSTD_isError(pending_bytes)) {
-				ret = -EIO;
+		acomp_walk_done_src(&walk, inbuf.pos);
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
+			goto out;
+		}
+
+		if (outbuf.pos == pos) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (outbuf.pos != outbuf.size) {
+			if (remaining) {
+				ret = -EINVAL;
 				goto out;
 			}
+			break;
+		}
 
-			total_out += outbuf.pos;
+		total_out += outbuf.pos;
+		acomp_walk_done_dst(&walk, outbuf.pos);
 
-			acomp_walk_done_dst(&walk, outbuf.pos);
-		} while (inbuf.pos != scur);
+		if (!remaining) {
+			outbuf.pos = 0;
+			break;
+		}
 
-		acomp_walk_done_src(&walk, scur);
-	} while (ret == 0);
+		ret = zstd_acomp_next_dst(&walk, &outbuf);
+		if (ret)
+			goto out;
+	}
+
+	if (outbuf.pos) {
+		total_out += outbuf.pos;
+		acomp_walk_done_dst(&walk, outbuf.pos);
+	}
 
 out:
 	if (ret)

base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
-- 
2.34.1

