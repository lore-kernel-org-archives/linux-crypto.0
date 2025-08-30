Received: from outbound.mr.icloud.com (p-west2-cluster5-host5-snip4-1.eps.apple.com [57.103.71.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E532741CD
	for <linux-crypto@vger.kernel.org>; Sat, 30 Aug 2025 03:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.71.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756524541; cv=none; b=oVBVpFONkJo4WXQFaMBioP+k5sbQecSwAgNTKgnG6x6KOpxX8T5JbBDQShK84JRuxTv1riv6thlDqXFjHByCYu72Px7ZT7YlGOMwLHW/GpGOboyIoBK8tdpGafRAek7QHCohxOfMH+Cao35TlvMaShgzESM2HrgI6fZ4yjatuJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756524541; c=relaxed/simple;
	bh=Kv8ytpJJ2MlubAQx9O7o5Oh6t5cUs6yXV1nK9y4WAMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bO/MdICTTwwUsAKnsA/SrYrp93M/++GVRsj2uqCxiTzBFSkwLbtn+YBsXLGWH5qHVY1oC0Oi7/gU6Pf3IypV/BTuha8mOcJrGbCJihajjTGhf20Ts8Aa/SmiXZWjRc7iEpczd+2kroeej0FY1ykBjqgt1e7P4HYte4jUhSi0PnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=cm4fzOks; arc=none smtp.client-ip=57.103.71.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="cm4fzOks"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-0 (Postfix) with ESMTPS id A71011800142;
	Sat, 30 Aug 2025 03:28:55 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1; bh=K3l72D9OEFk6r0bJCcEkDxxtbu8Qo3PZyVykPgZWxzo=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=cm4fzOksbICYuPwzOoau1hcj3utB6noovTrDg0QjXQR3Xpo/v5aZoCRRL2zJEZ8369tSVaG4LYxxRnU2lbiTuglXfc/iOPL1Oz4FYpVnoysK9fm/xm0EZLsZR99yV63hD/Bx/l4/3l7H4KXdSbHzZMGlpqWufOMEhMHXuTOZg0ZJuYakk+aHb3N6onl0kun4wiMuqcqA5d5BHleXcJVdUsmEv7mX2mIlajgRlMFks+usDHQYiuY6bu+si8ghdNpt8Kq0uLTkNzsaRZup7R65iXFHuthBHUT8thSUO6mGGWT55YazomZocxTAMNNogxnSp91jTF6Sd99/FJSjjS1SHw==
mail-alias-created-date: 1632196724000
Received: from hitch.danm.net (mr-asmtp-me-k8s.p00.prod.me.com [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-0 (Postfix) with ESMTPSA id 6C8AF1800697;
	Sat, 30 Aug 2025 03:28:54 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: linux-crypto@vger.kernel.org
Cc: dan@danm.net,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	regressions@lists.linux.dev
Subject: [PATCH 1/1] crypto: acomp: Use shared struct for context alloc and free ops
Date: Fri, 29 Aug 2025 21:28:39 -0600
Message-ID: <20250830032839.11005-2-dan@danm.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250830032839.11005-1-dan@danm.net>
References: <20250830032839.11005-1-dan@danm.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX2b1M8qUNyz24
 j0iddFHbW/BH9Uc8pJIX4ZJdLS3PSapvTENl5GjGW944AcFU7xof9rTTVrukOGaap45iTMJBsot
 GQYJL0h+SsuamJFLW8kAGeimqCJCCqgw4z/N8PL+DNhpXqU/6d6Q/gCA3rZGPsf41fgx146TBvA
 hszNtDV0CckTP+uWeKJDbcEqLBfhT76lxV2+zsppmP54A8AfBF5J9ubub2WQFNWvYIEIpQFxuHe
 rZay8zfZEZMVqWNLv9IEJTcWV5RvAXMZzKn+Amhp07BCzNNL6JrjKDFPuRdE810GTU1OhxDiU=
X-Proofpoint-GUID: YQXePvSDcBGobr6tX7QZb4sQNaXpBU-V
X-Proofpoint-ORIG-GUID: YQXePvSDcBGobr6tX7QZb4sQNaXpBU-V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-30_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 clxscore=1030 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2508300032
X-JNJ: AAAAAAABmTpYvWmuAogj5MhAhIV/c1QqHgJ3YxmmZHlwYOOWrRC8+Fg0MUOVp+TlTrQV9LOmDZc3ItduxqKA6b3k3gg8KqQ43Qx9wI/0ly/puTmNjnN41rEHEF/BuKj0umVmPS9DUW2m1GCmpiTclVOABIAGb3fx10GgdUk2Z8RRfXY+WhlAqX4GTJmpVvgSs2I2PEjw9IqBNtGgFmOXAuLQQmBgDG2OpleP8n9Se/kMN9k+TOfFj0z9Y55Dwl6m5Pf0GYZE4qUKsEwurcGBJGwksDdHba1Bk+cJL43sw6rzhYY5edhXZhOdOe5jK/mY3LmYe9WTjHc5JsGzgwDhOE5vdvQUr8ecsa9feFUYSBnIltZXxElRjrbfg/ws3To++H5zog/hxySKGuRo/UiLbV25iqDHgdgRx/LGhnatLxV3HARa2a/3vK5VKyUqoecHhRFtI4YRtod8R7wmU3v+yZHMootldYMQvENIpqdUIvggBZJmA2mAelFeD0B3Yelw9OEs6VCIeXnoAsB/Y6AC5uymM82oUIe4iRfcL3sMXJRkADG3iidzi6b8n/QWy+Y3D1b7O6ZkG3ki1SniWWxsIEnSrknBGCS+1Q==

In commit 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation
code into acomp"), the crypto_acomp_streams struct was made to rely on
having the alloc_ctx and free_ctx operations defined in the same order
as the scomp_alg struct. But in that same commit, the alloc_ctx and
free_ctx members of scomp_alg may be randomized by structure layout
randomization, since they are contained in a pure ops structure
(containing only function pointers). If the pointers within scomp_alg
are randomized, but those in crypto_acomp_streams are not, then
the order may no longer match. This fixes the problem by defining a
shared structure that both crypto_acomp_streams and scomp_alg share:
acomp_ctx_ops. This new pure ops structure may now be randomized,
while still allowing both crypto_acomp_streams and scomp_alg to have
matching layout.

Signed-off-by: Dan Moulding <dan@danm.net>
Fixes: 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation code into acomp")
---
 crypto/acompress.c                  |  6 +++---
 crypto/lz4.c                        |  6 ++++--
 include/crypto/internal/acompress.h | 10 +++++++---
 include/crypto/internal/scompress.h |  5 +----
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e3..ff910035ee42 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -375,7 +375,7 @@ static void acomp_stream_workfn(struct work_struct *work)
 		if (ps->ctx)
 			continue;
 
-		ctx = s->alloc_ctx();
+		ctx = s->ctx_ops.alloc_ctx();
 		if (IS_ERR(ctx))
 			break;
 
@@ -398,7 +398,7 @@ void crypto_acomp_free_streams(struct crypto_acomp_streams *s)
 		return;
 
 	cancel_work_sync(&s->stream_work);
-	free_ctx = s->free_ctx;
+	free_ctx = s->ctx_ops.free_ctx;
 
 	for_each_possible_cpu(i) {
 		struct crypto_acomp_stream *ps = per_cpu_ptr(streams, i);
@@ -427,7 +427,7 @@ int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s)
 	if (!streams)
 		return -ENOMEM;
 
-	ctx = s->alloc_ctx();
+	ctx = s->ctx_ops.alloc_ctx();
 	if (IS_ERR(ctx)) {
 		free_percpu(streams);
 		return PTR_ERR(ctx);
diff --git a/crypto/lz4.c b/crypto/lz4.c
index 7a984ae5ae52..c16c0d936708 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -68,8 +68,10 @@ static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lz4_alloc_ctx,
-	.free_ctx		= lz4_free_ctx,
+	.ctx_ops                = {
+		.alloc_ctx	= lz4_alloc_ctx,
+		.free_ctx       = lz4_free_ctx,
+	},
 	.compress		= lz4_scompress,
 	.decompress		= lz4_sdecompress,
 	.base			= {
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 2d97440028ff..c84a17ac26ca 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -55,15 +55,19 @@ struct acomp_alg {
 	};
 };
 
+struct acomp_ctx_ops {
+	void *(*alloc_ctx)(void);
+	void (*free_ctx)(void *);
+};
+
 struct crypto_acomp_stream {
 	spinlock_t lock;
 	void *ctx;
 };
 
 struct crypto_acomp_streams {
-	/* These must come first because of struct scomp_alg. */
-	void *(*alloc_ctx)(void);
-	void (*free_ctx)(void *);
+	/* This must come first because of struct scomp_alg. */
+	struct acomp_ctx_ops ctx_ops;
 
 	struct crypto_acomp_stream __percpu *streams;
 	struct work_struct stream_work;
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 533d6c16a491..1d807a15aef2 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -35,10 +35,7 @@ struct scomp_alg {
 			  void *ctx);
 
 	union {
-		struct {
-			void *(*alloc_ctx)(void);
-			void (*free_ctx)(void *ctx);
-		};
+		struct acomp_ctx_ops ctx_ops;
 		struct crypto_acomp_streams streams;
 	};
 
-- 
2.49.1

