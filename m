Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF4521D599;
	Tue, 17 Mar 2026 04:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773723077; cv=none; b=peXnpWD4/xlyK1YQgxr5Lo5nbezGglM/tUG692HW0/ZjrQCz58EXMD5HoA03fqzXKGlO1zMM3NLKUhBOCnQXHfr/c6OFzEr1wloyn29bADTex4KhPOn9VzulN3OH1kn8MohxiiQd3k1zNA5Q7oiYfh+8YIEXtijj3RqNs7kFLz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773723077; c=relaxed/simple;
	bh=6wmzA6YeKKYQRTyDXyQWVPMulEEjCgindg0VmxPV6V8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZmMnot8N7ontUsBjamdp7Dvq0i2Njs8HSBE8vdRYTgRfiFQXDJmMGe6GpHooJvX9iMRgqNZYYJ+b+r/kHkKsWV2PYBFksCHTcIuFPHunMwHVLkD8JueaOA8PmW9LFqLxdQK8HTMkvzyGEW8dg/FHqTv8EkvfTCjzMrd3Ax3RHbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTQl+5Nl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTQl+5Nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F59C2BC86;
	Tue, 17 Mar 2026 04:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773723076;
	bh=6wmzA6YeKKYQRTyDXyQWVPMulEEjCgindg0VmxPV6V8=;
	h=From:To:Cc:Subject:Date:From;
	b=kTQl+5NlPAyy2Q+qZwNe+TJAIgpLhmi4l3wxOMBcNsDMn6te04Uy4JEmZe6aDD+TP
	 oGsdhWv+KC2jz1VqcyKGoYgXoCSZLY3fiEdGc2sghbBcQTv+ewI/JNKCPpyl6VqkWB
	 nPWE6dVmKM1UWSUNFqjeivNNfbeF5eiRKOY/OOv+ecMZAwf3W++EJbod+7E3HLNokO
	 IUYVL/7/TqOeIra9rbjxYbOSOfpl80wbUFZOO0RvWxgU1zb1MdFKBRxSvxj+KLE0Uq
	 YE+WZ2aYDmGsPEybxOyhBgI7aR1fqWujTShlVm1DvZNpmUrDJU2cjYeXXV5+sgdmak
	 +zKRioypK1yIA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev@lists.ozlabs.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: powerpc: Add powerpc/aesp8-ppc.S to clean-files
Date: Mon, 16 Mar 2026 21:49:25 -0700
Message-ID: <20260317044925.104184-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the generated file powerpc/aesp8-ppc.S be removed by 'make clean'.

Fixes: 7cf2082e74ce ("lib/crypto: powerpc/aes: Migrate POWER8 optimized code into library")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 725eef05b758..dc7a56f7287d 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -53,10 +53,13 @@ endif # CONFIG_PPC
 libaes-$(CONFIG_RISCV) += riscv/aes-riscv64-zvkned.o
 libaes-$(CONFIG_SPARC) += sparc/aes_asm.o
 libaes-$(CONFIG_X86) += x86/aes-aesni.o
 endif # CONFIG_CRYPTO_LIB_AES_ARCH
 
+# clean-files must be defined unconditionally
+clean-files += powerpc/aesp8-ppc.S
+
 ################################################################################
 
 obj-$(CONFIG_CRYPTO_LIB_AESCFB)			+= libaescfb.o
 libaescfb-y					:= aescfb.o
 

base-commit: ebba09f198078b7a2565004104ef762d1148e7f0
-- 
2.53.0

