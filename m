Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4251D79B4
	for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2024 21:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734038955; cv=none; b=IIbAztC20Dh2EawNQDTKXKiWmMMdWQG9O85aE0Go1hP/LspJC0HIbA5bf7w1H0IJcnmc7cy72YlCYuVR/OVhHrYQQwuDMWOYM3qUINuWHqez2F+KdkV09/Y06npD8+Y6HQJt/3Kfv3G3OWxv6gmPQPC4bhatj4Bs3CMhQcBZsEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734038955; c=relaxed/simple;
	bh=FFfyPoD79Mg8fUB5soc2AZToAwkrs7/exNRNK6bG6ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6lV4xrROnxl9FxAsfjPso+bGmABakgOyPFiScbEsR4MTjrVayI2v489c/JuyFmbWLl3Q6VWTBofo7fipk3YSkS+7U7Eo73X3MXua0G8bD0YXqrtu3UDDh4ZMSzPQTIEV2S16K7hRP2JQTUJGqRJbSbwynq6JHtRzt6lKj3Ck8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbDuwCQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbDuwCQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AE9C4CED0;
	Thu, 12 Dec 2024 21:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734038955;
	bh=FFfyPoD79Mg8fUB5soc2AZToAwkrs7/exNRNK6bG6ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbDuwCQyGBodWU2+KS76E+TWZM/qRKosrR4MchQrVbarB29ZhxZ540Qhp0b2Z22OE
	 /5e2NYFd73nCV5iI4baaEhUEjmAuDAsjNWJCHDuQSVIRbCep3qg6PSXVT0z1q0VFwl
	 lbzI66I1QJSCYmhlod/CsKN2mboK7Fa/0ZA4oYd1tMTxVIbowhoK8Utnn5RhJ+LTBJ
	 0PnN6bXEd4T402E+zjSMoizlCMJnGCYTT/k8r1SRrlTpFmMwfNWNN5HeB7cip4EmGX
	 6Suf0bprPN64Lfip3l16TzGwydRD/ueKxNY4plQlXtIyiQ5DDUG3BjCqrKCfyNQ0ya
	 Kp3aFsA7y9GOg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH v2 3/8] crypto: x86/aes-xts - use .irp when useful
Date: Thu, 12 Dec 2024 13:28:40 -0800
Message-ID: <20241212212845.40333-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212212845.40333-1-ebiggers@kernel.org>
References: <20241212212845.40333-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Use .irp instead of repeating code.

No change in the generated code.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-xts-avx-x86_64.S | 74 ++++++----------------------
 1 file changed, 15 insertions(+), 59 deletions(-)

diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index 48f97b79f7a9..580e73396052 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -110,43 +110,17 @@
 
 .macro _define_aliases
 	// Define register aliases V0-V15, or V0-V31 if all 32 SIMD registers
 	// are available, that map to the xmm, ymm, or zmm registers according
 	// to the selected Vector Length (VL).
-	_define_Vi	0
-	_define_Vi	1
-	_define_Vi	2
-	_define_Vi	3
-	_define_Vi	4
-	_define_Vi	5
-	_define_Vi	6
-	_define_Vi	7
-	_define_Vi	8
-	_define_Vi	9
-	_define_Vi	10
-	_define_Vi	11
-	_define_Vi	12
-	_define_Vi	13
-	_define_Vi	14
-	_define_Vi	15
+.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	_define_Vi	\i
+.endr
 .if USE_AVX10
-	_define_Vi	16
-	_define_Vi	17
-	_define_Vi	18
-	_define_Vi	19
-	_define_Vi	20
-	_define_Vi	21
-	_define_Vi	22
-	_define_Vi	23
-	_define_Vi	24
-	_define_Vi	25
-	_define_Vi	26
-	_define_Vi	27
-	_define_Vi	28
-	_define_Vi	29
-	_define_Vi	30
-	_define_Vi	31
+.irp i, 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+	_define_Vi	\i
+.endr
 .endif
 
 	// V0-V3 hold the data blocks during the main loop, or temporary values
 	// otherwise.  V4-V5 hold temporary values.
 
@@ -543,19 +517,13 @@
 	_vaes_1x	\enc, 0, 2, \xmm_suffix, \data
 .Laes192\@:
 	_vaes_1x	\enc, 0, 3, \xmm_suffix, \data
 	_vaes_1x	\enc, 0, 4, \xmm_suffix, \data
 .Laes128\@:
-	_vaes_1x	\enc, 0, 5, \xmm_suffix, \data
-	_vaes_1x	\enc, 0, 6, \xmm_suffix, \data
-	_vaes_1x	\enc, 0, 7, \xmm_suffix, \data
-	_vaes_1x	\enc, 0, 8, \xmm_suffix, \data
-	_vaes_1x	\enc, 0, 9, \xmm_suffix, \data
-	_vaes_1x	\enc, 0, 10, \xmm_suffix, \data
-	_vaes_1x	\enc, 0, 11, \xmm_suffix, \data
-	_vaes_1x	\enc, 0, 12, \xmm_suffix, \data
-	_vaes_1x	\enc, 0, 13, \xmm_suffix, \data
+.irp i, 5,6,7,8,9,10,11,12,13
+	_vaes_1x	\enc, 0, \i, \xmm_suffix, \data
+.endr
 	_vaes_1x	\enc, 1, 14, \xmm_suffix, \data
 	_vpxor		\tweak, \data, \data
 .endm
 
 .macro	_aes_xts_crypt	enc
@@ -616,19 +584,13 @@
 	_vaes_4x	\enc, 0, 2
 .Laes192\@:
 	_vaes_4x	\enc, 0, 3
 	_vaes_4x	\enc, 0, 4
 .Laes128\@:
-	_vaes_4x	\enc, 0, 5
-	_vaes_4x	\enc, 0, 6
-	_vaes_4x	\enc, 0, 7
-	_vaes_4x	\enc, 0, 8
-	_vaes_4x	\enc, 0, 9
-	_vaes_4x	\enc, 0, 10
-	_vaes_4x	\enc, 0, 11
-	_vaes_4x	\enc, 0, 12
-	_vaes_4x	\enc, 0, 13
+.irp i, 5,6,7,8,9,10,11,12,13
+	_vaes_4x	\enc, 0, \i
+.endr
 	_vaes_4x	\enc, 1, 14
 
 	// XOR in the tweaks again.
 	_vpxor		TWEAK0, V0, V0
 	_vpxor		TWEAK1, V1, V1
@@ -777,19 +739,13 @@ SYM_TYPED_FUNC_START(aes_xts_encrypt_iv)
 	vaesenc		-5*16(%rdi), %xmm0, %xmm0
 .Lencrypt_iv_aes192:
 	vaesenc		-4*16(%rdi), %xmm0, %xmm0
 	vaesenc		-3*16(%rdi), %xmm0, %xmm0
 .Lencrypt_iv_aes128:
-	vaesenc		-2*16(%rdi), %xmm0, %xmm0
-	vaesenc		-1*16(%rdi), %xmm0, %xmm0
-	vaesenc		0*16(%rdi), %xmm0, %xmm0
-	vaesenc		1*16(%rdi), %xmm0, %xmm0
-	vaesenc		2*16(%rdi), %xmm0, %xmm0
-	vaesenc		3*16(%rdi), %xmm0, %xmm0
-	vaesenc		4*16(%rdi), %xmm0, %xmm0
-	vaesenc		5*16(%rdi), %xmm0, %xmm0
-	vaesenc		6*16(%rdi), %xmm0, %xmm0
+.irp i, -2,-1,0,1,2,3,4,5,6
+	vaesenc		\i*16(%rdi), %xmm0, %xmm0
+.endr
 	vaesenclast	7*16(%rdi), %xmm0, %xmm0
 	vmovdqu		%xmm0, (%rsi)
 	RET
 SYM_FUNC_END(aes_xts_encrypt_iv)
 
-- 
2.47.1

