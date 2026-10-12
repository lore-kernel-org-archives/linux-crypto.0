Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370DD4CA771;
	Mon, 12 Oct 2026 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791840685; cv=none; b=AObPv299hzkv/amMzKCx7Te0VInjkQSVef4U5vYTH3GEe5hBAwnnfChdQ3X1xyNys4ATL0gSxcSQaLq2cnWqrG5NELG1zjWAP/uYN3bvyYDbgouvuYM0/w2T/gv7ikHngvgxx4EgvNN5qmaTjmGThBOmaH7ah253dlDST6JEod0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791840685; c=relaxed/simple;
	bh=I7f6rDN7NdrQVCnnQyVijoCApsep/PLG4qtIDjWsGzA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sr3R67LNBIkfXnzn8rVp4JgRgXfLV9Gz7PCjAWMohlSInNer8Kds7M971DMsCHQFrVrdcqDg3Pa6e2tPX/wOyDhC7mAhWzR8bfs72W3Qrg3V0ZuIBQehkXR9O/3dI58nQLl4qR6dTubm1mW8XKjepX6v3IOat8EZEz57fbQNLjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0xPa4Rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0xPa4Rl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3821C2BCFD;
	Mon, 12 Oct 2026 21:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791840685;
	bh=I7f6rDN7NdrQVCnnQyVijoCApsep/PLG4qtIDjWsGzA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=e0xPa4RltyZWgPt3j0VFEHM7b9mH4LFPFiwYdgxvt6G7asAdr23qDlubOHXCanRG2
	 1Cnm+DVptXYgFxXzWNTtdQI6P181/NOCo14YX91XLYxuAg9JEj1ysI3K/DKi/1tEQc
	 EV/LvmgnIOp9qxgSZFd/c+hzO9Q3egwldF/SZZ/MISqGwYdwbVMIfkKfoEt+MyaURv
	 VZCJZAZyOcAi0skYMD1b4g1aUPM8hbNyJMzz/nw43utU6AAg0OK//cq6D6n6tYOMo+
	 UX8PnHdxxGZL5a75nr5XhyWyNw86k5/oslLmRFxo8qEIVP1yk6y3SBZJpy2oQCAdKp
	 JWa6Hjeva6ZLQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF65CC6B03;
	Mon, 12 Oct 2026 21:31:24 +0000 (UTC)
From: Vladimir Kukharenko via B4 Relay <devnull+vladimir.genproof.com@kernel.org>
Date: Mon, 12 Oct 2026 21:31:20 +0000
Subject: [PATCH 3/5] lib/crypto: arm64/poly1305: Fix 32-bit length treated
 as 64-bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-libcrypto-4gib-lengths-v1-3-ea566c129a2e@genproof.com>
References: <20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com>
In-Reply-To: <20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, 
 Vladimir Kukharenko <vladimir@genproof.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791840683; l=1781;
 i=vladimir@genproof.com; s=20261012; h=from:subject:message-id;
 bh=3X4KjNZCvYTpASxJw7cTyOKaRln3LqL4XSBvokwu7TM=;
 b=W2t+f5+yF8aKsOGkWzZBLm4nYHkonWwAO7SmhDYiVEI4JDEB/vmFQan2b6+ZguD/gEb1HKimy
 TOTzMpjGThnCdpj01JXCsli5BOroYcTU+x+DnbWYgOBTXABEvFUFWeG
X-Developer-Key: i=vladimir@genproof.com; a=ed25519;
 pk=EqOzBSKBgFn7ExzKj5f9T8u+1yTrGVlLBwf3fj/sdHM=
X-Endpoint-Received: by B4 Relay for vladimir@genproof.com/20261012 with
 auth_id=1169
X-Original-From: Vladimir Kukharenko <vladimir@genproof.com>
Reply-To: vladimir@genproof.com

From: Vladimir Kukharenko <vladimir@genproof.com>

The C code declares the length argument of poly1305_blocks_arm64() and
poly1305_blocks_neon() as u32, but the assembly, which comes from
OpenSSL/CRYPTOGAMS where the length is a size_t, reads it from the
64-bit register x2.  The arm64 ABI leaves the upper 32 bits of a 32-bit
argument unspecified, and gcc and clang don't zero-extend it.  In
practice the upper bits are zero in the current callers, so I don't
know of a failure.

Declare the length as size_t, as OpenSSL and the x86_64 code do, rather
than changing the imported assembly.  The assembly also reads hibit from
x3, but the callers always pass the constant 0 or 1.

This has been the case since commit f569ca164751 ("crypto:
arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation").

Assisted-by: LLM
Signed-off-by: Vladimir Kukharenko <vladimir@genproof.com>
---
 lib/crypto/arm64/poly1305.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/arm64/poly1305.h b/lib/crypto/arm64/poly1305.h
index 3d4bde857699..205a7b5fcf47 100644
--- a/lib/crypto/arm64/poly1305.h
+++ b/lib/crypto/arm64/poly1305.h
@@ -14,9 +14,9 @@
 asmlinkage void poly1305_block_init(struct poly1305_block_state *state,
 				    const u8 raw_key[POLY1305_BLOCK_SIZE]);
 asmlinkage void poly1305_blocks_arm64(struct poly1305_block_state *state,
-				      const u8 *src, u32 len, u32 hibit);
+				      const u8 *src, size_t len, u32 hibit);
 asmlinkage void poly1305_blocks_neon(struct poly1305_block_state *state,
-				     const u8 *src, u32 len, u32 hibit);
+				     const u8 *src, size_t len, u32 hibit);
 asmlinkage void poly1305_emit(const struct poly1305_state *state,
 			      u8 digest[POLY1305_DIGEST_SIZE],
 			      const u32 nonce[4]);

-- 
2.43.0


