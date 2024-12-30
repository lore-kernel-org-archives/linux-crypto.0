Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C7A19DFAB;
	Mon, 30 Dec 2024 00:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517765; cv=none; b=W3hAq6ejlKajX2+7pPZxRbbiB9YeFKIlzo+lR+4+hpPOwzQUHZtai1myXd1VuUZbgSAomV/PrYtDPLeWl7F0mbqYND9gDedwMLZdnQMbBxFT9IGRh9hHy4juP2hfEP4Ang8oHrWzddvfrnPOx24Cp9XcL2w8WJ+0yextXGPiEPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517765; c=relaxed/simple;
	bh=flgH9kGUEUUdU5GGIoLcecbOKpZ/9P71he8YGiVnKlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvHrZ9bDUyAYh74MWEuC2k9pd/vJm2Rl+7CWsDEWmXVP9yUVpiplzV2DFh/cpEl8Gx7xf7410LeBtP2bs3fdFknnQh0Mbbl7g3HlbDdyNHLJXMvOXZiYKIXug7G7LVLQSoTZ2o6p92Jh6qSXYG+1mqSnYEG4qH7wa/XGxKBaAiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JtFliWsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JtFliWsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA647C4AF0F;
	Mon, 30 Dec 2024 00:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517765;
	bh=flgH9kGUEUUdU5GGIoLcecbOKpZ/9P71he8YGiVnKlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtFliWsz1MQWt1rERIsI2ACTKt7OkpSZV/Ws3CTI/hJqzB5D+kTwjNVynffI78p3L
	 mX2IDLsguSW5936FvY2DfgWFk8ehPLyx/UrUFmVm84FPMdFaRxLcqUgQzL0RvsW4YE
	 SLfK1NxZgtKxTVFLNOmrcnDk20B3fhaa8wEPh+svrQSRFfSZMFA16cuRzDvgORuNji
	 H1egmLKAUNtkE8V08WKXPqgzr8GNP0dNiqBN5ClYdolActcKsV0Oy7wUdwba+bvndg
	 QNahR/v56j+mt67qLDUHeFxjTsHhfKpCaZQijTVdy9m6nyc4Coi7PrDG1gBo5N1nAJ
	 oTtmS9pWaxRsA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 18/29] crypto: arm/ghash - use the new scatterwalk functions
Date: Sun, 29 Dec 2024 16:14:07 -0800
Message-ID: <20241230001418.74739-19-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230001418.74739-1-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Use scatterwalk_next() which consolidates scatterwalk_clamp() and
scatterwalk_map(), and use scatterwalk_done_src() which consolidates
scatterwalk_unmap(), scatterwalk_advance(), and scatterwalk_done().
Remove unnecessary code that seemed to be intended to advance to the
next sg entry, which is already handled by the scatterwalk functions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/ghash-ce-glue.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 3af997082534..9613ffed84f9 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -457,30 +457,23 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[], u32 len)
 	int buf_count = 0;
 
 	scatterwalk_start(&walk, req->src);
 
 	do {
-		u32 n = scatterwalk_clamp(&walk, len);
-		u8 *p;
+		unsigned int n;
+		const u8 *p;
 
-		if (!n) {
-			scatterwalk_start(&walk, sg_next(walk.sg));
-			n = scatterwalk_clamp(&walk, len);
-		}
-
-		p = scatterwalk_map(&walk);
+		p = scatterwalk_next(&walk, len, &n);
 		gcm_update_mac(dg, p, n, buf, &buf_count, ctx);
-		scatterwalk_unmap(p);
+		scatterwalk_done_src(&walk, p, n);
 
 		if (unlikely(len / SZ_4K > (len - n) / SZ_4K)) {
 			kernel_neon_end();
 			kernel_neon_begin();
 		}
 
 		len -= n;
-		scatterwalk_advance(&walk, n);
-		scatterwalk_done(&walk, 0, len);
 	} while (len);
 
 	if (buf_count) {
 		memset(&buf[buf_count], 0, GHASH_BLOCK_SIZE - buf_count);
 		pmull_ghash_update_p64(1, dg, buf, ctx->h, NULL);
-- 
2.47.1

