Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0963414F98
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 03:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741232014; cv=none; b=Hy995vAcqPr5KdHBP6zlnO6CFf6a9d/O1ZtD8IqNQaabp/Mg59N92IuRIhyz+MYMIFuwa7wZTSTMCQwhNvENirRTlCsGy7L4fbHICKy1m0NMp0Umy/29F7KY0RBQJWljxSsgHTcPOolCyzu/f39yDMWYGMBNYxGrjsO3GPmU0sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741232014; c=relaxed/simple;
	bh=siYRwaLXdMe3e+G1uWUQdLsOjkRdw78md5+as2hWy0Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PP3gjh4U52IeKe2iOq5mKsJFj1qLguMNtI0tKaQSERM77PofVmI0+5bfBPBXjok8ugB/DYvy569Gc+b/GRa3pGlyW+de4cM+THm54ibUnOQFTg4UQZCgRSqdRfceRQPIntfaVbWpUxZ8fZGCBbzYIrMc3w3PSkQTLQ+IOXxI5y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrL35o53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrL35o53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6887AC4CED1
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 03:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741232013;
	bh=siYRwaLXdMe3e+G1uWUQdLsOjkRdw78md5+as2hWy0Y=;
	h=From:To:Subject:Date:From;
	b=CrL35o53F7u1CtL2ypqrM/xcvbSLn+rsgKtWOSVII2UKsZjpL8EPVwzTFKVvJ3eNC
	 6vLhWqgQUN3m6G+5KFYiVHfM9cO8ovFRzTwyLJ/vEDb7GG01ID9VwEpSfSpmjB+jN/
	 0tqbNzW7h6wClOW0Sd2tgWnvxBVloHjGGriFQcW3YurSAxUNSGpAMUBsnNsof9no2o
	 eQnctQyx1NImYZqdwyYaIaRTlt+dJvGVbzYu4nbm2z5axYbU1EGQZiXP2acoGCrok/
	 0PMKDe3my4wwIMJQGhZfdZc6hrrKUm38wlJFb8DAf3+deFo6zDaX6htXasKYrig0SP
	 KVUFxdpfy8uuw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: skcipher - fix mismatch between mapping and unmapping order
Date: Wed,  5 Mar 2025 19:33:05 -0800
Message-ID: <20250306033305.163767-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Local kunmaps have to be unmapped in the opposite order from which they
were mapped.  My recent change flipped the unmap order in the
SKCIPHER_WALK_DIFF case.  Adjust the mapping side to match.

This fixes a WARN_ON_ONCE that was triggered when running the
crypto-self tests on a 32-bit kernel with
CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP=y.

Fixes: 95dbd711b1d8 ("crypto: skcipher - use the new scatterwalk functions")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 53123d3685d5d..66d19c360dd8b 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -207,16 +207,16 @@ static int skcipher_next_fast(struct skcipher_walk *walk)
 	diff = offset_in_page(walk->in.offset) -
 	       offset_in_page(walk->out.offset);
 	diff |= (u8 *)(sg_page(walk->in.sg) + (walk->in.offset >> PAGE_SHIFT)) -
 		(u8 *)(sg_page(walk->out.sg) + (walk->out.offset >> PAGE_SHIFT));
 
-	skcipher_map_src(walk);
-	walk->dst.virt.addr = walk->src.virt.addr;
+	skcipher_map_dst(walk);
+	walk->src.virt.addr = walk->dst.virt.addr;
 
 	if (diff) {
 		walk->flags |= SKCIPHER_WALK_DIFF;
-		skcipher_map_dst(walk);
+		skcipher_map_src(walk);
 	}
 
 	return 0;
 }
 

base-commit: 17ec3e71ba797cdb62164fea9532c81b60f47167
-- 
2.48.1

