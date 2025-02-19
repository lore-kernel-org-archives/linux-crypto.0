Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C9D215782;
	Wed, 19 Feb 2025 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989469; cv=none; b=Vs+4uiBObGIWCDHMNUJPtMuU+/W4PT4ogRVuSlAiLc10ucHd1ekdaLHSrI4kcU+hnTAzIFQ85ATeU/zTq4XYRST71WHeMEHNcP1u0v7XC0fI0C0xp5B6y49QGSTgrWZLTY+6R4Vii5FvMshtMhUQHIppDuCmszWCg7JIMKGSCsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989469; c=relaxed/simple;
	bh=VRdQ2k8FdPmnqmKHx3au+3j0XAULugqyn31iF/f7f3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSuuhoMK6PBFfCVKLzsDrcwZCBxg6/vIKs/UDn5aXnhTMx5oQgr5igK55+OdRcLfN+g55kBwBeBE9vT2f3mTSbD/7d8DU+V9c3LzdUv6G7U2AVflucwIFUjJtDyRg0Rt4TvzgLuX9ZjlKwFzIcNglvLmp8bDnbbgR3CkTkfe3l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OyExh26Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OyExh26Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15272C4CEDD;
	Wed, 19 Feb 2025 18:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989469;
	bh=VRdQ2k8FdPmnqmKHx3au+3j0XAULugqyn31iF/f7f3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyExh26ZqVNYSB/UUGR/UPV1JuE64mzG37cGURIG8Dh+wa3uIP7ZC2JrJmTZ/zTWK
	 vEwylh5guEPOIJ2O4+rUTVXy3AjroxP38ham1Cv3JaCHS2oRdgTKEqroXVKHBH08+G
	 Q0C1PLyKsxxioiT0kKFccE42a8LZUuDMTsgxgrq1YzDuaqavSdo6ro2F+vLogXaTeT
	 vQVCRG0Iqv8waLjpUOC2Z0i2QloX93Pdij4JZ37SvJk6710B9kEzlRgb96xZpQqkGc
	 3ZVollhWCrpMXt0qmvfGn3TT7Se64JyC0upWYkE/TvV1p8Z15DDw2m2mU7B+CoSjw2
	 YADpdk0PG47TQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 08/19] crypto: arm/ghash - use the new scatterwalk functions
Date: Wed, 19 Feb 2025 10:23:30 -0800
Message-ID: <20250219182341.43961-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219182341.43961-1-ebiggers@kernel.org>
References: <20250219182341.43961-1-ebiggers@kernel.org>
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
index 3af9970825340..9613ffed84f93 100644
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
2.48.1

