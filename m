Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8366827E7F9;
	Wed, 27 Aug 2025 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307699; cv=none; b=jbV6zAPDoUveHjrShXKecFi+I0SoVIeFlZUCwO0mEfs3ltWoAolLEdxXQQN2szDuxzJfisiuoXYsNLneWt750Ba+GCYRq+IDuX/G5yjZh6NU3Lf2BRBNzXpky1PKgk7JhM/JPG0W3coA5RncENbj7UIuCVZsPMPCm384NMLryvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307699; c=relaxed/simple;
	bh=NFRhzN4wSBfaVwKEFKFe99szQNdk4fuv7Txe2nbhvtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nx5f0ELwFbdULK1QRUVmi3mL6O8HTViJ66/hObeDD7vWsiboJxM1TbSDEsTy0I8qNsWYUZp/37lj4CGTMNcYGGqM10ho8AYOJH/i/6sj9ij08+h6mWHOa1qpPsgK8Z1gqG4wCihF7SeCkpqhyjECHGyofm3ZJzbR9mZyjB8clJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sQRVjO43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQRVjO43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19953C4CEF9;
	Wed, 27 Aug 2025 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756307699;
	bh=NFRhzN4wSBfaVwKEFKFe99szQNdk4fuv7Txe2nbhvtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQRVjO43EHxUlBVbNtQiqiymZScScOs2BakOrDe6zxv9CAukxhhGwL5UrzXyai7J4
	 eeRtxBTdguK+xrbqVLm5YkL9pMSnRselFMCPyjETrvVmuZB7colKipPtz5zNevMymN
	 G50RF3C6C78aVSnYk8SpOZwr+OWs7NmdFvuKF+NHGtvJ3b/MxUKhFRM9AXlXnxa9Tk
	 oN340/40uCL5zzxLs5j8iXgfIchEPlf94CUFJvFDQ3zq3c/QGYSZGjCnERdRKmxsr+
	 D++1E1ePxwWTtNvYkorsFEzNrKccjoOeH1Ikc/rgzDzqtPynCSm+j43ln9i4dS1oaa
	 QyqJr1BnSW9pg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 07/12] lib/crypto: x86/blake2s: Reduce size of BLAKE2S_SIGMA2
Date: Wed, 27 Aug 2025 08:11:26 -0700
Message-ID: <20250827151131.27733-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827151131.27733-1-ebiggers@kernel.org>
References: <20250827151131.27733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Save 480 bytes of .rodata by replacing the .long constants with .bytes,
and using the vpmovzxbd instruction to expand them.

Also update the code to do the loads before incrementing %rax rather
than after.  This avoids the need for the first load to use an offset.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/blake2s-core.S | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/lib/crypto/x86/blake2s-core.S b/lib/crypto/x86/blake2s-core.S
index ac1c845445a4d..ef8e9f427aab3 100644
--- a/lib/crypto/x86/blake2s-core.S
+++ b/lib/crypto/x86/blake2s-core.S
@@ -27,23 +27,23 @@ SIGMA:
 .byte  2,  6,  0,  8, 12, 10, 11,  3,  1,  4,  7, 15,  9, 13,  5, 14
 .byte 12,  1, 14,  4,  5, 15, 13, 10,  8,  0,  6,  9, 11,  7,  3,  2
 .byte 13,  7, 12,  3, 11, 14,  1,  9,  2,  5, 15,  8, 10,  0,  4,  6
 .byte  6, 14, 11,  0, 15,  9,  3,  8, 10, 12, 13,  1,  5,  2,  7,  4
 .byte 10,  8,  7,  1,  2,  4,  6,  5, 13, 15,  9,  3,  0, 11, 14, 12
-.section .rodata.cst64.BLAKE2S_SIGMA2, "aM", @progbits, 640
+.section .rodata.cst64.BLAKE2S_SIGMA2, "aM", @progbits, 160
 .align 64
 SIGMA2:
-.long  0,  2,  4,  6,  1,  3,  5,  7, 14,  8, 10, 12, 15,  9, 11, 13
-.long  8,  2, 13, 15, 10,  9, 12,  3,  6,  4,  0, 14,  5, 11,  1,  7
-.long 11, 13,  8,  6,  5, 10, 14,  3,  2,  4, 12, 15,  1,  0,  7,  9
-.long 11, 10,  7,  0,  8, 15,  1, 13,  3,  6,  2, 12,  4, 14,  9,  5
-.long  4, 10,  9, 14, 15,  0, 11,  8,  1,  7,  3, 13,  2,  5,  6, 12
-.long  2, 11,  4, 15, 14,  3, 10,  8, 13,  6,  5,  7,  0, 12,  1,  9
-.long  4,  8, 15,  9, 14, 11, 13,  5,  3,  2,  1, 12,  6, 10,  7,  0
-.long  6, 13,  0, 14, 12,  2,  1, 11, 15,  4,  5,  8,  7,  9,  3, 10
-.long 15,  5,  4, 13, 10,  7,  3, 11, 12,  2,  0,  6,  9,  8,  1, 14
-.long  8,  7, 14, 11, 13, 15,  0, 12, 10,  4,  5,  6,  3,  2,  1,  9
+.byte  0,  2,  4,  6,  1,  3,  5,  7, 14,  8, 10, 12, 15,  9, 11, 13
+.byte  8,  2, 13, 15, 10,  9, 12,  3,  6,  4,  0, 14,  5, 11,  1,  7
+.byte 11, 13,  8,  6,  5, 10, 14,  3,  2,  4, 12, 15,  1,  0,  7,  9
+.byte 11, 10,  7,  0,  8, 15,  1, 13,  3,  6,  2, 12,  4, 14,  9,  5
+.byte  4, 10,  9, 14, 15,  0, 11,  8,  1,  7,  3, 13,  2,  5,  6, 12
+.byte  2, 11,  4, 15, 14,  3, 10,  8, 13,  6,  5,  7,  0, 12,  1,  9
+.byte  4,  8, 15,  9, 14, 11, 13,  5,  3,  2,  1, 12,  6, 10,  7,  0
+.byte  6, 13,  0, 14, 12,  2,  1, 11, 15,  4,  5,  8,  7,  9,  3, 10
+.byte 15,  5,  4, 13, 10,  7,  3, 11, 12,  2,  0,  6,  9,  8,  1, 14
+.byte  8,  7, 14, 11, 13, 15,  0, 12, 10,  4,  5,  6,  3,  2,  1,  9
 
 .text
 SYM_FUNC_START(blake2s_compress_ssse3)
 	testq		%rdx,%rdx
 	je		.Lendofloop
@@ -191,13 +191,13 @@ SYM_FUNC_START(blake2s_compress_avx512)
 	vmovdqu		0x20(%rsi),%ymm7
 	addq		$0x40,%rsi
 	leaq		SIGMA2(%rip),%rax
 	movb		$0xa,%cl
 .Lblake2s_compress_avx512_roundloop:
-	addq		$0x40,%rax
-	vmovdqa		-0x40(%rax),%ymm8
-	vmovdqa		-0x20(%rax),%ymm9
+	vpmovzxbd	(%rax),%ymm8
+	vpmovzxbd	0x8(%rax),%ymm9
+	addq		$0x10,%rax
 	vpermi2d	%ymm7,%ymm6,%ymm8
 	vpermi2d	%ymm7,%ymm6,%ymm9
 	vmovdqa		%ymm8,%ymm6
 	vmovdqa		%ymm9,%ymm7
 	vpaddd		%xmm8,%xmm0,%xmm0
-- 
2.50.1

