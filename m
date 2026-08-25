Received: from mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980D0443ABA
	for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2026 22:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787695588; cv=none; b=MCvkPp/GPUGANabQguNsdJLyVQ0ar7di8+hgx7vTfuOtqjBVxPIGO7EkD63aBhiDsDAa/VR/6S7PtloEE48w7CuaTn4UTg7n+3cxuPQBGjdCKWJY5rppkthpWuWZsdtpzfaGHAojvwpF/b5ySikchSIqwMnHMubSF9C/r8S7rZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787695588; c=relaxed/simple;
	bh=kfl8eHfriQk9KJ2Dns1uaqm0darKcxxQoENqeOcFaiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaNjFwAuyK9mPgx6OzZCiSk48lEIxJ8PMUMcHeO3DY+3uVAZ/H6MJPDqb78NUxvwrgNZ07msmxrzbEdPZDAhls1wpt6VZ2tZORXkpf/Y6xEak0kh7i7ue/AsfnNPcYRZ6AKKR99DE9nep3M0CZA+x0RoFgsPJ6PNGZBGUL2kvWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Iwku/njJ; arc=none smtp.client-ip=95.215.58.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Iwku/njJ"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kfl8eHfriQk9KJ2Dns1uaqm0darKcxxQoENqeOcFaiQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787695583; v=1; x=1788300383;
 b=Iwku/njJ9H51NuigwcsfzUNk95uJ9EXLEDwfvM1RAeSjVPTVoliCRXgwm/dVRGalYXgjhHx3
 ZxrhWclQDrfxIkhgkAueeozYRl6wlYWgrbHiq0Rhznquh2PY5FpvrYZ+trbKn6Rno2jxreKSRy1
 WsdipPS2b2w2RSut3d0kGeZQ=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from localhost (2a03:2880:10ff:8::)
	by mta11.migadu.com with ESMTPS id 20a3fe3baad05ad2;
	Tue, 25 Aug 2026 22:06:23 +0000
X-Mizu-Trace-ID: 20a3fe3baad05ad2
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: davem@davemloft.net,
	dsterba@suse.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	terrelln@fb.com
Cc: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 2/2] crypto: zstd - Avoid redundant dstream initialization
Date: Tue, 25 Aug 2026 15:06:02 -0700
Message-ID: <20260825220616.3842633-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825220616.3842633-1-usama.arif@linux.dev>
References: <20260825220616.3842633-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zstd_decompress() initializes the shared workspace as a DStream before
entering the walk loop. If the first source and destination fragments
each span the whole request it then hands off to zstd_decompress_one(),
which initializes that same ctx->wksp as a DCtx, discarding the DStream
setup without having decompressed a byte. The two are in fact the same
routine, as ZSTD_initStaticDStream() is a tail call to
ZSTD_initStaticDCtx() and zstd_init_dstream() discards its
max_window_size argument, so the work was done twice byte for byte.

zswap takes this path whenever the stored object lies within a single
zsmalloc page, which is the common case; an object straddling a page
boundary comes back from zs_obj_read_sg_begin() as a two-entry source
scatterlist and streams instead.

Defer the DStream initialization to the first walk iteration that reaches
the streaming path, guarded by a flag because that iteration can be
reached more than once. Within this function ctx->dctx is read only by
the zstd_decompress_stream() call immediately below, so no stale context
can be picked up. As in the previous patch the new call site runs with
the walk's fragments mapped and has to release them before failing.

For a 4 KB crypto_acomp benchmark for decompression, twelve runs of nine
30K operation rounds, on the bare-metal host the median per-round mean
request time fell from 2,317 ns to 1,998 ns (13.8%).
In the one-vCPU KVM guest it fell from 3,516 ns to 2,265 ns (35.6%).

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 crypto/zstd.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index d64472f3e11e5..76bdaca327330 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -215,6 +215,7 @@ static int zstd_decompress_one(struct acomp_req *req, struct zstd_ctx *ctx,
 
 static int zstd_decompress(struct acomp_req *req)
 {
+	bool stream_initialized = false;
 	struct crypto_acomp_stream *s;
 	unsigned int total_out = 0;
 	unsigned int scur, dcur;
@@ -232,12 +233,6 @@ static int zstd_decompress(struct acomp_req *req)
 	if (ret)
 		goto out;
 
-	ctx->dctx = zstd_init_dstream(ZSTD_MAX_SIZE, ctx->wksp, ctx->wksp_size);
-	if (!ctx->dctx) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	do {
 		scur = acomp_walk_next_src(&walk);
 		if (scur) {
@@ -263,6 +258,19 @@ static int zstd_decompress(struct acomp_req *req)
 				goto out;
 			}
 
+			if (!stream_initialized) {
+				ctx->dctx = zstd_init_dstream(ZSTD_MAX_SIZE, ctx->wksp,
+							      ctx->wksp_size);
+				if (!ctx->dctx) {
+					/* Release in the reverse of the map order. */
+					acomp_walk_done_dst(&walk, 0);
+					acomp_walk_done_src(&walk, 0);
+					ret = -EINVAL;
+					goto out;
+				}
+				stream_initialized = true;
+			}
+
 			outbuf.pos = 0;
 			outbuf.dst = (u8 *)walk.dst.virt.addr;
 			outbuf.size = dcur;
-- 
2.53.0-Meta

