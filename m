Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4114718DA;
	Wed, 14 Oct 2026 20:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010355; cv=none; b=DV3IL6mMhGioXJo9uGITPswAlgGHracn7McjLt+wYQLk54CPMYUU/E9hU/V8nVOsKRs0a4A9CVr6wHcpYHcLBsG3bh9cBM6U/6hD43dzXAixVcdn7CqEhaGb/SOdfTWYQAUjwwfEMxwpvBn5XGSIdd8+ew65aw+BQx1NfEqSWl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010355; c=relaxed/simple;
	bh=UBvuNYZW41/APtR5ddoeb0UgGDD+zXYvUBuSkNWMIaI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s+vKlbvC+maUbIq2b83up2dnHYReO6wZMTd6GleBqOsJFQ0umq9NT5AzR/uqLKKvKhzZuu8HPZpmpWyiZjcB0cOEsg+8UYD6BRTYJu7Vm9w6FkbYfpA9ESgLR5JBQsPcncOmasjmIArkq2bxGfSgeefPc+7PEhcX3rccVkL5cFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2c3T2Fx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2c3T2Fx"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 732B6C2BCFC;
	Wed, 14 Oct 2026 20:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792010355;
	bh=UBvuNYZW41/APtR5ddoeb0UgGDD+zXYvUBuSkNWMIaI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=q2c3T2FxqkrsZUIE6rNPEf33TUEUgcVUBuCwXb9dd6QsiHsbMD0mSEKP8SWMmWbkf
	 d4mZJeJuG0JItVczEC9KqQRKIEiWB6Zxn6SVlmhBfPntTXkCfV+HGJgCvZUkaRGdly
	 ufHU1brKIyMfpurIpS822TX/iorgRkOqNISidZ+8pBLUHUMH36INMFFl/lpgIFmfrZ
	 XuRnTDapdGNuh/o5OKaTNLLlA4jUtL3MzrMZJK76JzsFtpy8wjaFg882S7EmGlXFaC
	 MAhyYxmNzC5SkoMvpCFDvZJcanccB9Yry6hfYTYvEPxOBY6814i8iAA5HqErXehdPR
	 4AAdAkxL4JdTw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52FEACC6B2E;
	Wed, 14 Oct 2026 20:39:15 +0000 (UTC)
From: Vladimir Kukharenko via B4 Relay <devnull+vladimir.genproof.com@kernel.org>
Date: Wed, 14 Oct 2026 20:34:22 +0000
Subject: [PATCH 2/2] lib/crypto: mips/chacha: Handle lengths of 2 GiB or
 more
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-libcrypto-chacha-32bit-2gib-v1-2-e0719ca0be89@genproof.com>
References: <20261014-libcrypto-chacha-32bit-2gib-v1-0-e0719ca0be89@genproof.com>
In-Reply-To: <20261014-libcrypto-chacha-32bit-2gib-v1-0-e0719ca0be89@genproof.com>
To: Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 Vladimir Kukharenko <vladimir@genproof.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792010354; l=2832;
 i=vladimir@genproof.com; s=20261012; h=from:subject:message-id;
 bh=TE9/gftYr+enx+PZyGbuYGXK7HjmheuriB0NIElpFUA=;
 b=WOkimjKS6q9y+tTvfw/GyU0mi88Yj7HdCBcTmTAQGDb1YctRcrBvsYwbJ1Jg3i7NiV+cIVR+a
 8pxikIGozpaAWK0ypu8z2t18ifIHtLu8A0hLRdsR/pNvbzEHMC7SEVg
X-Developer-Key: i=vladimir@genproof.com; a=ed25519;
 pk=EqOzBSKBgFn7ExzKj5f9T8u+1yTrGVlLBwf3fj/sdHM=
X-Endpoint-Received: by B4 Relay for vladimir@genproof.com/20261012 with
 auth_id=1169
X-Original-From: Vladimir Kukharenko <vladimir@genproof.com>
Reply-To: vladimir@genproof.com

From: Vladimir Kukharenko <vladimir@genproof.com>

The MIPS ChaCha assembly, which is chacha_crypt_arch() itself, tests
the remaining length with signed branches, so for 2 GiB + 64 bytes or
more it takes the final partial block path too early and processes less
than requested.  It is only used on 32-bit kernels, where size_t is 32
bits, so declaring the length as size_t does not avoid this.  No
in-tree caller passes such lengths.

The partial block code also keeps the remaining length as a negative
value, so instead of changing the assembly, rename it to
chacha_crypt_mips() and add a C chacha_crypt_arch() that passes it at
most 1 GiB per call.

Tested in QEMU user mode: with a length of 0xfffff045 the assembly
processed about 4 KiB and advanced the block counter by 64; with the
same 1 GiB loop in C, a 1.25 GiB + 4101 byte buffer matches a C
reference.  An LLM review of this code found the bug.

Assisted-by: LLM
Signed-off-by: Vladimir Kukharenko <vladimir@genproof.com>
---
 lib/crypto/mips/chacha-core.S |  8 ++++----
 lib/crypto/mips/chacha.h      | 20 +++++++++++++++++++-
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/lib/crypto/mips/chacha-core.S b/lib/crypto/mips/chacha-core.S
index 706aeb850fb0..1a2253d91af7 100644
--- a/lib/crypto/mips/chacha-core.S
+++ b/lib/crypto/mips/chacha-core.S
@@ -196,9 +196,9 @@ CONCAT3(.Lchacha_mips_xor_aligned_, PLUS_ONE(x), _b: ;) \
 .text
 .set	reorder
 .set	noat
-.globl	chacha_crypt_arch
-.ent	chacha_crypt_arch
-chacha_crypt_arch:
+.globl	chacha_crypt_mips
+.ent	chacha_crypt_mips
+chacha_crypt_mips:
 	.frame	$sp, STACK_SIZE, $ra
 
 	/* Load number of rounds */
@@ -414,7 +414,7 @@ chacha_crypt_arch:
 
 	/* Jump table */
 	FOR_EACH_WORD(JMPTBL_UNALIGNED)
-.end chacha_crypt_arch
+.end chacha_crypt_mips
 .set at
 
 /* Input arguments
diff --git a/lib/crypto/mips/chacha.h b/lib/crypto/mips/chacha.h
index 5a565d0a8c26..15b39c744c28 100644
--- a/lib/crypto/mips/chacha.h
+++ b/lib/crypto/mips/chacha.h
@@ -6,8 +6,26 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sizes.h>
 
-asmlinkage void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
+asmlinkage void chacha_crypt_mips(struct chacha_state *state, u8 *dst,
 				  const u8 *src, size_t bytes, int nrounds);
 asmlinkage void hchacha_block_arch(const struct chacha_state *state,
 				   u32 out[HCHACHA_OUT_WORDS], int nrounds);
+
+static void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
+			      const u8 *src, size_t bytes, int nrounds)
+{
+	/*
+	 * chacha_crypt_mips() compares the length as a signed value, so pass
+	 * it at most 1 GiB at a time.
+	 */
+	do {
+		size_t todo = min(bytes, SZ_1G);
+
+		chacha_crypt_mips(state, dst, src, todo, nrounds);
+		bytes -= todo;
+		src += todo;
+		dst += todo;
+	} while (bytes);
+}

-- 
2.43.0


