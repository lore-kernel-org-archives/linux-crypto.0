Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA682264A3;
	Tue,  8 Jul 2025 19:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752003711; cv=none; b=TW1H67VC7vL+bcD/Uo0QpTC+6VYszf5Wz/cFstL3YTaX2dxnpZKXFAtX+V5hFiTDZwThxMtJGVxKSH3naKiBnuDG+D2vYuv0xaqNzfsOqR/xotin3jmii/B1RMWn2UpQpGVI1+9nFfRsrjTPiePeUODwv9joJOGErG1WUp2P8FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752003711; c=relaxed/simple;
	bh=/eyHeUuBtfo2FwFId2SbeAJqAbp9dDd6FKzb90cHbsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTDXj8tRQCCIGcYkNZdIGBwrqNxlU3k8FFcHMNigqe1yJl1N7zsbZFuFWuza3sFZ3gD5KsFice2aGM+k4kuVuIWL2j/q/x3dgh4GdAK8qxU9FqbpuLvDQMclyeqQerNn7yNSZ4jSK5QYxVRgt1rjtI9Jayxi9Jl3auogd/bICpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTgLjD/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTgLjD/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36D0C4CEED;
	Tue,  8 Jul 2025 19:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752003711;
	bh=/eyHeUuBtfo2FwFId2SbeAJqAbp9dDd6FKzb90cHbsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTgLjD/CRAj6wPjhdiRlKm5CmuAtMyQf4+yISJmYyzKQHtWERjwOKHM2aKYw63Bt/
	 SCfwKx1teyJxRAP4u4qAW2oc/4WhGfouHJ9D/SdDRlF5FGKFxhUtZoY3RXOtjuPXGR
	 Ms3eMIyQhal8dyfHeW4If1gsFVuy8PmFdsAMkDEFnFugxo+1tYhF+hvoC3t8CS6zST
	 pGKUL828mH1sQNAUdCgXct6qhx/AbMI1k49gnRL/MFgUUid5zZ2cQBzkQT3F6XPTrC
	 eZAQXil4mUHIKHpJtWiAiJlhC+SP5JdpsKKosj13/DOICsgLZQ/pAW5PewcburvY84
	 WzaqyN6XSxkBg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-rt-devel@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] crypto: x86/aegis - Fix sleeping when disallowed on PREEMPT_RT
Date: Tue,  8 Jul 2025 12:38:28 -0700
Message-ID: <20250708193829.656988-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708193829.656988-1-ebiggers@kernel.org>
References: <20250708193829.656988-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skcipher_walk_done() can call kfree(), which takes a spinlock, which
makes it incorrect to call while preemption is disabled on PREEMPT_RT.
Therefore, end the kernel-mode FPU section before calling
skcipher_walk_done(), and restart it afterwards.

Moreover, pass atomic=false to skcipher_walk_aead_encrypt() instead of
atomic=true.  The point of atomic=true was to make skcipher_walk_done()
safe to call while in a kernel-mode FPU section, but that does not
actually work.  So just use the usual atomic=false.

Fixes: 1d373d4e8e15 ("crypto: x86 - Add optimized AEGIS implementations")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aegis128-aesni-glue.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index f1b6d40154e35..3cb5c193038bb 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -117,11 +117,13 @@ crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
 		else
 			aegis128_aesni_dec(state, walk->src.virt.addr,
 					   walk->dst.virt.addr,
 					   round_down(walk->nbytes,
 						      AEGIS128_BLOCK_SIZE));
+		kernel_fpu_end();
 		skcipher_walk_done(walk, walk->nbytes % AEGIS128_BLOCK_SIZE);
+		kernel_fpu_begin();
 	}
 
 	if (walk->nbytes) {
 		if (enc)
 			aegis128_aesni_enc_tail(state, walk->src.virt.addr,
@@ -129,11 +131,13 @@ crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
 						walk->nbytes);
 		else
 			aegis128_aesni_dec_tail(state, walk->src.virt.addr,
 						walk->dst.virt.addr,
 						walk->nbytes);
+		kernel_fpu_end();
 		skcipher_walk_done(walk, 0);
+		kernel_fpu_begin();
 	}
 }
 
 static struct aegis_ctx *crypto_aegis128_aesni_ctx(struct crypto_aead *aead)
 {
@@ -174,13 +178,13 @@ crypto_aegis128_aesni_crypt(struct aead_request *req,
 	struct aegis_ctx *ctx = crypto_aegis128_aesni_ctx(tfm);
 	struct skcipher_walk walk;
 	struct aegis_state state;
 
 	if (enc)
-		skcipher_walk_aead_encrypt(&walk, req, true);
+		skcipher_walk_aead_encrypt(&walk, req, false);
 	else
-		skcipher_walk_aead_decrypt(&walk, req, true);
+		skcipher_walk_aead_decrypt(&walk, req, false);
 
 	kernel_fpu_begin();
 
 	aegis128_aesni_init(&state, &ctx->key, req->iv);
 	crypto_aegis128_aesni_process_ad(&state, req->src, req->assoclen);
-- 
2.50.0

