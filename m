Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793840181;
	b=hfHJxYTVmFyWO6ZKooMxgMOudlZZFqliHmwAQ3nLIpO80e3E9ifjDvFMULM2MkcSrr+t
	 cp1ezvHanWK0MB36Gmj6OfEQ+Nmrf1ZTjNNIMF94loUqq0DxLu2gBboYqV8WfBPCtFC7I
	 zkMg7m3pO5f1w2raI3qqDl5dVYBwAeQIG3D/+aoh/dXjYI7nO8cgYNbVbb/C/niMUFZrY
	 UHD+xs+wInJxREWoE3Av+08eFs7Mm3wwAunype7lsUPzLBe0zPbgIGXQ8U/Ur8vcIbv+G
	 Ez94rqzGtCy/DG/MnlOikmR6xpKTK/krgIHnbQnxkIZjKufN0La4/RBFQAbVdSPhNHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793840181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/UJOjkqaqO8MFJch1nfSqvPWF4/U5P/hg/MRikiB+Ro=;
	b=KTixFK+lOZOeLbON22o0s1CCLaAqwysEFXJRhrFnD28FJ+tlRj/XN3fCBle6jxIITh88
	 wfWbUP92rlcnKYdhBZ/Zw+uaUVtrKxKQ2pl5gcEXi/HGkVCAEOa9DaUx8PO+o5jXIeTjR
	 LWmD+1LUyqW9p3C/iUZ2X0z7NAVpP0kpxvvUxtsp4FcFL8RfrzlibdJjq8pJWLuMP1dKh
	 M24AxVr/qizyFkYzA8E4PWe0KlL6F7x5dF5pNbjowjQCDr1wWIcDMHsrOwQhgkHWcvsGt
	 qIARpAWYKnOnoyUHha4CqzG/vJVU0R4pd/3+o25FNzI/YAYyWbBsGsZHFZftTavXD/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IbNoiSOb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F35606D80A
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 00:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IbNoiSOb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770BA1F00A1C;
	Thu,  5 Nov 2026 00:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793840180;
	bh=/UJOjkqaqO8MFJch1nfSqvPWF4/U5P/hg/MRikiB+Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbNoiSObT284GNW71GfuttXSMG1s9XQmE6NK6Km9DxO6YiCZVZoVCxQLNiicLoUGI
	 ZHfsPdhSFFUDdNYjGXRZmXLTZbtWANsL28DNS5DXG2RephMna895TIdZiXl0GKgFv3
	 Mtmw8gquRPLsVJNE/a4wflsxnEMBj/BlE7lM/FEYx9loD4yPUVCe4lzn0vsf+vTABv
	 l/QvUYQ+p6r0oRxl4Qe77X0204eQOqNZJjsw5xRVzYXjMrTj8x9C0mfw/P24K6arfZ
	 phOFIz3M9Bp0JKwzBKiVrSlxIXUsh3bTbUnLPuc2I9Ws5yqEWE1VbH8DwgUU5WOqI9
	 xx+L0Pf1SRZ3Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] lib/crc: x86: Opt out of initializing MXCSR and 387 state
Date: Wed,  4 Nov 2026 16:55:21 -0800
Message-ID: <20261105005523.84925-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105005523.84925-1-ebiggers@kernel.org>
References: <20261105005523.84925-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CRC code using "kernel-mode FPU" is integer code that does not use
any MMX or x87 instructions.  To the extent that float-domain
instructions are used at all, they are only moves and shuffles, neither
of which raises SIMD floating-point exceptions or depends on MXCSR.

Therefore, there's no need to initialize MXCSR or the 387 FPU state.

Opt out of this initialization by using kernel_fpu_begin_mask(0) instead
of kernel_fpu_begin().  This eliminates an 'ldmxcsr' instruction in
every kernel-mode FPU section, reducing overhead, which matters most for
short input lengths.  On 32-bit kernels it also eliminates 'fninit'.

A precedent for this optimization can be found in
commit a58db7ad80e8 ("netfilter: nft_set_pipapo_avx2: Skip LDMXCSR, we
don't need a valid MXCSR state").

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crc/x86/crc-pclmul-template.h | 18 +++++++++---------
 lib/crc/x86/crc32.h               |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/crc/x86/crc-pclmul-template.h b/lib/crc/x86/crc-pclmul-template.h
index 893119bb7c07..124946f441a9 100644
--- a/lib/crc/x86/crc-pclmul-template.h
+++ b/lib/crc/x86/crc-pclmul-template.h
@@ -42,14 +42,14 @@ static inline bool have_avx512(void)
  * bytes, the CPU has PCLMULQDQ support, and the current context may use SIMD.
  *
  * 16 bytes is the minimum length supported by the [V]PCLMULQDQ functions.
- * There is overhead associated with kernel_fpu_begin() and kernel_fpu_end(),
- * varying by CPU and factors such as which parts of the "FPU" state userspace
- * has touched, which could result in a larger cutoff being better.  Indeed, a
- * larger cutoff is usually better for a *single* message.  However, the
- * overhead of the FPU section gets amortized if multiple FPU sections get
- * executed before returning to userspace, since the XSAVE and XRSTOR occur only
- * once.  Considering that and the fact that the [V]PCLMULQDQ code is lighter on
- * the dcache than the table-based code is, a 16-byte cutoff seems to work well.
+ * There is overhead associated with the kernel-mode "FPU" section, varying by
+ * CPU and factors such as which parts of the "FPU" state userspace has touched,
+ * which could result in a larger cutoff being better.  Indeed, a larger cutoff
+ * is usually better for a *single* message.  However, the overhead of the FPU
+ * section gets amortized if multiple FPU sections get executed before returning
+ * to userspace, since the XSAVE and XRSTOR occur only once.  Considering that
+ * and the fact that the [V]PCLMULQDQ code is lighter on the dcache than the
+ * table-based code is, a 16-byte cutoff seems to work well.
  */
 #define CRC_PCLMUL(crc, p, len, prefix, consts, have_pclmulqdq)		\
 do {									\
@@ -58,7 +58,7 @@ do {									\
 		const void *consts_ptr;					\
 									\
 		consts_ptr = (consts).fold_across_128_bits_consts;	\
-		kernel_fpu_begin();					\
+		kernel_fpu_begin_mask(0);				\
 		crc = static_call(prefix##_pclmul)((crc), (p), (len),	\
 						   consts_ptr);		\
 		kernel_fpu_end();					\
diff --git a/lib/crc/x86/crc32.h b/lib/crc/x86/crc32.h
index 19a5e3c6c73b..fb07ed449ae4 100644
--- a/lib/crc/x86/crc32.h
+++ b/lib/crc/x86/crc32.h
@@ -67,7 +67,7 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 		 * crc32c_x86_3way() and crc32_lsb_vpclmul_avx512().  The latter
 		 * is needed anyway for crc32_le(), so we just reuse it here.
 		 */
-		kernel_fpu_begin();
+		kernel_fpu_begin_mask(0);
 		if (static_branch_likely(&have_vpclmul_avx512))
 			crc = crc32_lsb_vpclmul_avx512(crc, p, len,
 				       crc32_lsb_0x82f63b78_consts.fold_across_128_bits_consts);
-- 
2.56.0

