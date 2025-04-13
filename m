Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4461946AA;
	Sun, 13 Apr 2025 04:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744520145; cv=none; b=lY3dP33zWyCmFsUDDL/BqHyCKiXM+jg7foTu//2rScFWUo3kqowJiuwlRbTAXkK2GMWtW+8OMINDISEF46NVG2ulJ5FkDtGsvh26UfAcu3SQpcWc0kPEvUgaCVbLU8LV4SeP/QhXsZCDAcTiO44+NyKbhLlttmd7ecloG0k2AF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744520145; c=relaxed/simple;
	bh=2gVkbo9MzVz9VvdMrst8TjWJgNjWQ5w/TelaNMUEtGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNaD/sNHm27WxwtnQpo1/qTpO0iaeK0pAZpe5oPIxFiHsqAImPpT6tUssaEeUBu/Nqj862bEGBCZRJvvOAPNTBAUyTY8lkrUm04uy6as5WyHQXZoqf6YEMGna+m7ftSRbOamlvc8T1QQff2rW3XdVR+0kasEOmT1lPEL2J0q52E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQ3TQJtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQ3TQJtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8414CC4CEEC;
	Sun, 13 Apr 2025 04:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744520144;
	bh=2gVkbo9MzVz9VvdMrst8TjWJgNjWQ5w/TelaNMUEtGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQ3TQJtkQRNwLXjjSV+ZirK4F2x5Ki3Bhv5FTKS0TwurPeEsyoDqm/+11jsc6KW/a
	 sS/UqHVfUu/IOzxUpNwkD1ovfmDwFhEzVnWxOWHFD05K5ZscmwjZU2oMjAfRLzRawn
	 30yLpt4R8qhT7ec13PW04vyT4DaMPls82NRUZ1euqmDGxs8CSb9p5bWhuXdCviGCUc
	 1zRw8fPcXC/Zdg2Lmqm7zA1a+dhQrtO9RiXimZ4QHwMHLCsaPR3Bnik+Zq35FnHVcq
	 lQ9gEU05caDHcf1lX0cxLWbGZOh7IM7YG2I8Vl/U07faajdBK8X4wf5HybE8IpkIAd
	 uhuSffzv6mTwg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH 9/9] crypto: poly1305 - remove rset and sset fields of poly1305_desc_ctx
Date: Sat, 12 Apr 2025 21:54:21 -0700
Message-ID: <20250413045421.55100-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250413045421.55100-1-ebiggers@kernel.org>
References: <20250413045421.55100-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

These fields are no longer needed, so remove them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/poly1305.h | 4 ----
 lib/crypto/poly1305.c     | 2 --
 2 files changed, 6 deletions(-)

diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index 91444965772a..6e21ec2d1dc2 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -41,14 +41,10 @@ struct poly1305_state {
 struct poly1305_desc_ctx {
 	/* partial buffer */
 	u8 buf[POLY1305_BLOCK_SIZE];
 	/* bytes used in partial buffer */
 	unsigned int buflen;
-	/* how many keys have been set in r[] */
-	unsigned short rset;
-	/* whether s[] has been set */
-	bool sset;
 	/* finalize key */
 	u32 s[4];
 	/* accumulator */
 	struct poly1305_state h;
 	/* key */
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index 6e80214ebad8..b633b043f0f6 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -20,12 +20,10 @@ void poly1305_init_generic(struct poly1305_desc_ctx *desc,
 	desc->s[1] = get_unaligned_le32(key + 20);
 	desc->s[2] = get_unaligned_le32(key + 24);
 	desc->s[3] = get_unaligned_le32(key + 28);
 	poly1305_core_init(&desc->h);
 	desc->buflen = 0;
-	desc->sset = true;
-	desc->rset = 2;
 }
 EXPORT_SYMBOL_GPL(poly1305_init_generic);
 
 void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
 			     unsigned int nbytes)
-- 
2.49.0

