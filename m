Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF2A231856;
	Sun,  2 Nov 2025 23:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762127043; cv=none; b=h2ZxyzZklWDh7WywaAgMcT5hjsWwMXZSG67szrQ6sCgrTQNEKyCBpztWOflOLRLBwOHUBodJaTfkH4/wm7bvexPiGo/yYV3Gm0N/e0CDepG2e6mgZMEpl2GSrTzkH6kCzooadMbxTs+KRDUXHfFPHXeXSjtBvzjG/cYPtqd8eas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762127043; c=relaxed/simple;
	bh=Cjz2Ynime9JFgui5jMG92w+fxZmvkZNBICHD9qR75Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJF641c2kWfcJzBgmvUImBZsmE8ibtU7iEVlUfo+u4b2+Gf5mEd6YHNN32HtTMxEDDbSw0m7C1jCPyzBvvbvUwul7o8tRGrQ28f/jJ32iAJHGmz9XHkvlsbhl7+xTPgJKAHggoOIK4UxFXmRNA+AXkSARle/bBtZ1JBGCP24Nag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=omoKZCBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="omoKZCBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B59C19421;
	Sun,  2 Nov 2025 23:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762127043;
	bh=Cjz2Ynime9JFgui5jMG92w+fxZmvkZNBICHD9qR75Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omoKZCBD2ojlxQ6a0XUfYqhc3oa8RkS3oiDyfzTMmbQQQV0vtzYVRy+XSR8WsVYbJ
	 bw3LDMdiyjdnJv5Qwpsf0u2hjMLdLHONrYX/tn84w0S6FkX0cDk9BYU7O0q4JIsVgW
	 foptSmTPXnWv9HWo5esYDVmPc/BrF+pmq8D8glhDqvYl+Mfj08aRkDT23X5ESp3FVu
	 XfrctE4yMnss9L1bZRfL7lHiVbKgU9BLdpXxhGLZjKgHQsFCKUcFQkMjXR1ggZAAo+
	 KMWxyVQC92Xz24DxDeWepz3qFPFh8LdKyLpbdx0YVwfLcB6CGIN/hkW0qixZPGV7dT
	 BG0GDgb0wBInw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Samuel Neves <sneves@dei.uc.pt>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/6] lib/crypto: x86/blake2s: Drop check for nblocks == 0
Date: Sun,  2 Nov 2025 15:42:05 -0800
Message-ID: <20251102234209.62133-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251102234209.62133-1-ebiggers@kernel.org>
References: <20251102234209.62133-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since blake2s_compress() is always passed nblocks != 0, remove the
unnecessary check for nblocks == 0 from blake2s_compress_ssse3().

Note that this makes it consistent with blake2s_compress_avx512() in the
same file as well as the arm32 blake2s_compress().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/blake2s-core.S | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/lib/crypto/x86/blake2s-core.S b/lib/crypto/x86/blake2s-core.S
index 093e7814f387..aee13b97cc34 100644
--- a/lib/crypto/x86/blake2s-core.S
+++ b/lib/crypto/x86/blake2s-core.S
@@ -43,12 +43,10 @@ SIGMA2:
 .byte 15,  5,  4, 13, 10,  7,  3, 11, 12,  2,  0,  6,  9,  8,  1, 14
 .byte  8,  7, 14, 11, 13, 15,  0, 12, 10,  4,  5,  6,  3,  2,  1,  9
 
 .text
 SYM_FUNC_START(blake2s_compress_ssse3)
-	testq		%rdx,%rdx
-	je		.Lendofloop
 	movdqu		(%rdi),%xmm0
 	movdqu		0x10(%rdi),%xmm1
 	movdqa		ROT16(%rip),%xmm12
 	movdqa		ROR328(%rip),%xmm13
 	movdqu		0x20(%rdi),%xmm14
@@ -166,11 +164,10 @@ SYM_FUNC_START(blake2s_compress_ssse3)
 	decq		%rdx
 	jnz		.Lbeginofloop
 	movdqu		%xmm0,(%rdi)
 	movdqu		%xmm1,0x10(%rdi)
 	movdqu		%xmm14,0x20(%rdi)
-.Lendofloop:
 	RET
 SYM_FUNC_END(blake2s_compress_ssse3)
 
 SYM_FUNC_START(blake2s_compress_avx512)
 	vmovdqu		(%rdi),%xmm0
-- 
2.51.2

