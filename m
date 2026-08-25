Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783963DCD86
	for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2026 22:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787695585; cv=none; b=ex7dUGcyAYS5+iK2XpblyEEx+bxQTO5oZ0ipchArK3xWnBnAhY6zHyDMfb5Qey+lnXT0pJiu9JFRwBWy9J0/6ALtZPZNPQtExy1c9GYsRBLuf9dDYcZVDrsJPjTljF/j6iEaqykil7tnenVd5s+UlK6CTrUIouuue3iDHKwOmq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787695585; c=relaxed/simple;
	bh=0i2T135nstI1Jyb/4jvL3GgYI93oGF3oLzgBiHMSwOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YP8Kd/dX7gG481XkNYPl6UwFy+1kIryfCCLXLLzrYFVqXAOwy+jRiLqlbNQx/OVUtYMW4PEc5l/5KnjhzrV6vycmJ3w/uY8HgZBDje6YTHpAOCH8GTlI+RQfxr7I9lV3zij6unyAv2d2HZIhnIjxxWBdG1ExlojZLvJMHtjuYYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ds1Xz3ad; arc=none smtp.client-ip=91.218.175.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ds1Xz3ad"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0i2T135nstI1Jyb/4jvL3GgYI93oGF3oLzgBiHMSwOI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787695581; v=1; x=1788300381;
 b=Ds1Xz3adEhpHRTmATHDhgyQpwT8gXy4g9I7+BCYZvEP7TR6cWOvgHjaEWQRLpRdEujC3D/eg
 qKwrGC7zorRbS7khkRgO2XystVtVrur28i8Q0/wREnd3P1emStKwi7It0BLmSiQ18HkI4SDSNAF
 es4bZPDllq61wFcQMdpyO88A=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from localhost (2a03:2880:10ff:11::)
	by mta10.migadu.com with ESMTPS id 5f226bf144225a4c;
	Tue, 25 Aug 2026 22:06:21 +0000
X-Mizu-Trace-ID: 5f226bf144225a4c
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
Subject: [PATCH 1/2] crypto: zstd - Avoid redundant cstream initialization
Date: Tue, 25 Aug 2026 15:06:01 -0700
Message-ID: <20260825220616.3842633-2-usama.arif@linux.dev>
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

zstd_compress() initializes the shared workspace as a CStream before
entering the walk loop. If the first source and destination fragments
each span the whole request it then hands off to zstd_compress_one(),
which initializes that same ctx->wksp as a CCtx, discarding the CStream
setup without having compressed a byte. zswap always takes this one-shot
path when storing, so every page it stores paid for both.

Neither is cheap: zstd_init_cstream() redoes the cwksp layout, zeroes the
ZSTD_CCtx, probes for BMI2 through ZSTD_cpuid(), then resets the session
and parameters and replays ten validated ZSTD_CCtx_setParameter() calls.

Defer the CStream initialization to the first walk iteration that needs
it, guarded by a flag because that iteration can be reached more than
once. The first inner iteration either takes the one-shot path and
returns or initializes the CStream, so the trailing zstd_end_stream()
cannot pick up the stale context left in ctx->cctx by an earlier request.
Unlike the old call site the new one runs with the walk's fragments
mapped, so it has to release them before failing.

For a 4 KB crypto_acomp benchmark for compression, twelve runs of nine
30K operation rounds, on the bare-metal host the median per-round mean
request time fell from 52,283 ns to 51,038 ns (2.4%). In the one-vCPU
KVM guest it fell from 16,675 ns to 15,050 ns (9.8%).
The larger improvement in guest is because of the pair of CPUID
instructions in ZSTD_cpuid() that the removed initialization runs.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 crypto/zstd.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index 556f5d2bdd5fb..d64472f3e11e5 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -96,6 +96,7 @@ static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
 
 static int zstd_compress(struct acomp_req *req)
 {
+	bool stream_initialized = false;
 	struct crypto_acomp_stream *s;
 	unsigned int pos, scur, dcur;
 	unsigned int total_out = 0;
@@ -115,12 +116,6 @@ static int zstd_compress(struct acomp_req *req)
 	if (ret)
 		goto out;
 
-	ctx->cctx = zstd_init_cstream(&ctx->params, 0, ctx->wksp, ctx->wksp_size);
-	if (!ctx->cctx) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	do {
 		dcur = acomp_walk_next_dst(&walk);
 		if (!dcur) {
@@ -142,6 +137,19 @@ static int zstd_compress(struct acomp_req *req)
 				goto out;
 			}
 
+			if (!stream_initialized) {
+				ctx->cctx = zstd_init_cstream(&ctx->params, 0,
+							      ctx->wksp, ctx->wksp_size);
+				if (!ctx->cctx) {
+					/* Release in the reverse of the map order. */
+					acomp_walk_done_src(&walk, 0);
+					acomp_walk_done_dst(&walk, 0);
+					ret = -EINVAL;
+					goto out;
+				}
+				stream_initialized = true;
+			}
+
 			if (scur) {
 				inbuf.pos = 0;
 				inbuf.src = walk.src.virt.addr;
-- 
2.53.0-Meta

