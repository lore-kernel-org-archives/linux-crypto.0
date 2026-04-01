Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C0C322A;
	Wed,  1 Apr 2026 00:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775002070; cv=none; b=lI2uWB8rJ1tZ/LBSj6JHu2gwANUMXRCXIwAp9KxnHCToz0DsIPBXSWRwU30utcq9pI6fBZAJGPkru/URJsLBRqJ2Ioj0Mfy5qU2U9YMwxZMZaLYtqwSlQAHk78lNBKT2M/TZMk1uQZzet7U3ZqeJDyq2ZnPohJkQD4lKEzcV2Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775002070; c=relaxed/simple;
	bh=IDxofDV1l6itbnGBXpDqaJyt+/X6blNaQzeWk25J7Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSOjU9RFHkjl/SYVHAEZ2JcQONC1589QQVQwVftgIulr+44OS3YxpRdA8dm5yxOTrtm7f6MLfNRiAKzDmcg2qkTW+AakYa9CECSEhDZ5D4RBniRLTo9U9my8Oqj8WHrna02DZSS4F2mMIVrc3dYgnnw9UvYQMUCUBfbh/MoUAF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLnFZ9ZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLnFZ9ZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D7EC2BCB4;
	Wed,  1 Apr 2026 00:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775002070;
	bh=IDxofDV1l6itbnGBXpDqaJyt+/X6blNaQzeWk25J7Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLnFZ9ZGjNSPQd/8I/31b5XsbGh4co6ArbnJCiY8mDm0jMZkPalDqjTX5wNAnkBNo
	 hjJnO+ANvexDSdzaAxZhxTYJT4F61XpgLpkvVPd++oiCnG57LPEr22T2+SeYSLVSel
	 +nxzysiwnMsFChEc1Ho0QgXp9yeVk/usNn8bz9/UWDc6YeZz/6eQ2Zsj8UPVCTyG9s
	 L+pFRYyUMQBPa8wRe89v3DROFp5Njl2tucohO6Y4LV9uzwAnal0dfP3mAtew+i9cn1
	 9VFc6z+HXIUkGapBP9Oq/Da6Eszzw0zImOdMXcqwYswJQtxXFqzM6ehAQcwbB4FP5V
	 yX1vWGuxuQibQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/9] lib/crypto: arm64/poly1305: Remove obsolete chunking logic
Date: Tue, 31 Mar 2026 17:05:43 -0700
Message-ID: <20260401000548.133151-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401000548.133151-1-ebiggers@kernel.org>
References: <20260401000548.133151-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit aefbab8e77eb ("arm64: fpsimd: Preserve/restore kernel mode
NEON at context switch"), kernel-mode NEON sections have been
preemptible on arm64.  And since commit 7dadeaa6e851 ("sched: Further
restrict the preemption modes"), voluntary preemption is no longer
supported on arm64 either.  Therefore, there's no longer any need to
limit the length of kernel-mode NEON sections on arm64.

Simplify the Poly1305 code accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm64/poly1305.h | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/lib/crypto/arm64/poly1305.h b/lib/crypto/arm64/poly1305.h
index b77669767cd6..3d4bde857699 100644
--- a/lib/crypto/arm64/poly1305.h
+++ b/lib/crypto/arm64/poly1305.h
@@ -25,21 +25,15 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
 static void poly1305_blocks(struct poly1305_block_state *state, const u8 *src,
 			    unsigned int len, u32 padbit)
 {
 	if (static_branch_likely(&have_neon) && likely(may_use_simd())) {
-		do {
-			unsigned int todo = min_t(unsigned int, len, SZ_4K);
-
-			scoped_ksimd()
-				poly1305_blocks_neon(state, src, todo, padbit);
-
-			len -= todo;
-			src += todo;
-		} while (len);
-	} else
+		scoped_ksimd()
+			poly1305_blocks_neon(state, src, len, padbit);
+	} else {
 		poly1305_blocks_arm64(state, src, len, padbit);
+	}
 }
 
 #define poly1305_mod_init_arch poly1305_mod_init_arch
 static void poly1305_mod_init_arch(void)
 {
-- 
2.53.0

