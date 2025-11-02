Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E2513D2B2;
	Sun,  2 Nov 2025 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762127043; cv=none; b=MkCL7NE7AsdjaZ0fGLHvywRRuz9iOyRaE0SfkAduxg5codi4ifl6F1eq778Hf9faHB0f0GJ9f5zF7YoOl7GxLZB2CASAT2T/+Mm23eSgl97hZN3v2GU9oe7H5WCaevclHz3QyZZbTnRz4hODY01p11kTGs6hRxdJScKzKr/qG3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762127043; c=relaxed/simple;
	bh=Q6eKCfeKL6NL11OUN0m6F/u4RWoglkYFIdJAEJsYzs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOpLV6MnJoaOOsP/XxAvyhvmtEkXnNAblimWVGDkh/RPNdbf3oO5rtlx5t9+YyJk/YtJVDp710vO2mzoSGB1pBYxeRP8SUG3rKyfBtHh7fzBh2HTQhmLPlMK/3PDspv5MmMwWbHbXR3NWn7WvTFPSU3qC5wD4SOuY0KiiHoL6No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sssUsswx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sssUsswx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F10C116B1;
	Sun,  2 Nov 2025 23:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762127042;
	bh=Q6eKCfeKL6NL11OUN0m6F/u4RWoglkYFIdJAEJsYzs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sssUsswx0zWR9HcHB05wU8TvV1NffLyzQ7hJe8KqZVlH1mDsNgfkDwfxgtb6APU2W
	 lxMdx0umCsMdgE3FzoiShWlzF8EtCznTM8/oGAZn8a+wNckqP2++R5kgDbmNlAQZpx
	 44cjlojtfqTPglxopwHQoPpNAcJWIiNQcgB0XGEBo3NEIBNOUvrnUFwoLUCGW3GwIL
	 m4hFADHO7aW/oK0J+/WJGdMXH1fgMH00jpBL082HLPrfXgyO67F/rv3ikw6ZcE56mX
	 /dzUrvzlONIRU+JFXy/B4ljiqERpzEdW+69qa4BfF3anJpFQ1heYVmCd/hZk3IaTI+
	 ExxEapn1CMMjQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Samuel Neves <sneves@dei.uc.pt>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/6] lib/crypto: x86/blake2s: Fix 32-bit arg treated as 64-bit
Date: Sun,  2 Nov 2025 15:42:04 -0800
Message-ID: <20251102234209.62133-2-ebiggers@kernel.org>
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

In the C code, the 'inc' argument to the assembly functions
blake2s_compress_ssse3() and blake2s_compress_avx512() is declared with
type u32, matching blake2s_compress().  The assembly code then reads it
from the 64-bit %rcx.  However, the ABI doesn't guarantee zero-extension
to 64 bits, nor do gcc or clang guarantee it.  Therefore, fix these
functions to read this argument from the 32-bit %ecx.

In theory, this bug could have caused the wrong 'inc' value to be used,
causing incorrect BLAKE2s hashes.  In practice, probably not: I've fixed
essentially this same bug in many other assembly files too, but there's
never been a real report of it having caused a problem.  In x86_64, all
writes to 32-bit registers are zero-extended to 64 bits.  That results
in zero-extension in nearly all situations.  I've only been able to
demonstrate a lack of zero-extension with a somewhat contrived example
involving truncation, e.g. when the C code has a u64 variable holding
0x1234567800000040 and passes it as a u32 expecting it to be truncated
to 0x40 (64).  But that's not what the real code does, of course.

Fixes: ed0356eda153 ("crypto: blake2s - x86_64 SIMD implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/blake2s-core.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/x86/blake2s-core.S b/lib/crypto/x86/blake2s-core.S
index ef8e9f427aab..093e7814f387 100644
--- a/lib/crypto/x86/blake2s-core.S
+++ b/lib/crypto/x86/blake2s-core.S
@@ -50,11 +50,11 @@ SYM_FUNC_START(blake2s_compress_ssse3)
 	movdqu		(%rdi),%xmm0
 	movdqu		0x10(%rdi),%xmm1
 	movdqa		ROT16(%rip),%xmm12
 	movdqa		ROR328(%rip),%xmm13
 	movdqu		0x20(%rdi),%xmm14
-	movq		%rcx,%xmm15
+	movd		%ecx,%xmm15
 	leaq		SIGMA+0xa0(%rip),%r8
 	jmp		.Lbeginofloop
 	.align		32
 .Lbeginofloop:
 	movdqa		%xmm0,%xmm10
@@ -174,11 +174,11 @@ SYM_FUNC_END(blake2s_compress_ssse3)
 
 SYM_FUNC_START(blake2s_compress_avx512)
 	vmovdqu		(%rdi),%xmm0
 	vmovdqu		0x10(%rdi),%xmm1
 	vmovdqu		0x20(%rdi),%xmm4
-	vmovq		%rcx,%xmm5
+	vmovd		%ecx,%xmm5
 	vmovdqa		IV(%rip),%xmm14
 	vmovdqa		IV+16(%rip),%xmm15
 	jmp		.Lblake2s_compress_avx512_mainloop
 .align 32
 .Lblake2s_compress_avx512_mainloop:
-- 
2.51.2

