Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD8F2F25E1
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764865708; cv=none; b=IouJlQj9eBt8RN8QxIXmA64FJ+zju8FYP1PmYq2Z8OimB1NLg+u+Bgu7BZqRJTognnXYZCNwj/ybcrP9A5rGx/nHhKLZdk5876J2fH6kOWOe1SL83bJ0Om9VLZjQCoLyxqdJfbGdbGtrU+s/majjX0dn+DtLTsQeVOt8wrYzi8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764865708; c=relaxed/simple;
	bh=j5XgDut8Jh1yOBUGeAP7WAC4k+EHrnpB2QuBKNomiHY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=btl+7vvJr9FWYih3P0UVmGH7QTcOlLW3f0b1uITGo1y5v+cRGHa0axX6LNYC0v7CZk7ALPZX4fs+bWHExCLgpdPoZShmzDTrModDvWWvoXd2l0acv3itYycSrAptIUDD8J0TrNfdkIGS8Rue4L1F/pflaOaIXSrpahbplssV0KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z0hGZn2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z0hGZn2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79365C4CEFB;
	Thu,  4 Dec 2025 16:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764865706;
	bh=j5XgDut8Jh1yOBUGeAP7WAC4k+EHrnpB2QuBKNomiHY=;
	h=From:To:Cc:Subject:Date:From;
	b=Z0hGZn2kNBdkc7f594EH++IfFxSu7b57KV/sMuVakNlZ5u/hrtZq6S48xIcPMPrwi
	 dvq+18F3QxhmHb22a4W3ZBBFjkrKqJX2D1ecpS30VXm+sESjvbG2Tvgz2QK9Hv+7vq
	 3iCXYnQZ5iRl96u67unbDTOQF5yDxwH4TQlsllrdHOIKZX3nUS1HKTKEDOmEf9F7P1
	 zHuBW624NkeCNaOstdSircbCW/fHWiDQ3o1bgv5rWMACYc+sZKubRawM+WclK+ZuGd
	 sDi5mU8FPRb8qa+VFBCE2h7QJYR321AuWvdgOIRr2CrxSICAYj288jYl7w0XD4rMXV
	 FAtfzwxN1mSGA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Justin Stitt <justinstitt@google.com>
Subject: [PATCH] arm64/simd: Avoid pointless clearing of FP/SIMD buffer
Date: Thu,  4 Dec 2025 17:28:15 +0100
Message-ID: <20251204162815.522879-2-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1891; i=ardb@kernel.org; h=from:subject; bh=j5XgDut8Jh1yOBUGeAP7WAC4k+EHrnpB2QuBKNomiHY=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIdNw2/zjsX9eZSTu27h3RtW9Nv2qtMtRK9qv5sQdtJrSX c1gdqa0o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEwkJIrhr/iv2P2PsoTz55dn LL7NUuJ39PYs2wrB63+mmHKbzJ7CsJzhD4+Sv8PXalnHKQc+z33iuZ6Z2/rVCfcFoWxy2ZH39hc vYQYA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

The buffer provided to kernel_neon_begin() is only used if the task is
scheduled out while the FP/SIMD is in use by the kernel, or when such a
section is interrupted by a softirq that also uses the FP/SIMD.

IOW, this happens rarely, and even if it happened often, there is still
no reason for this buffer to be cleared beforehand, which happens by
default when using a compiler that supports -ftrivial-auto-var-init.

So mark the buffer as __uninitialized. Given that this is a variable
attribute not a type attribute, this requires that the expression is
tweaked a bit.

Cc: Will Deacon <will@kernel.org>,
Cc: Catalin Marinas <catalin.marinas@arm.com>,
Cc: Kees Cook <keescook@chromium.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/simd.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

The issue here is that returning a pointer to an automatic variable as
it goes out of scope is slightly dodgy, especially in the context of
__attribute__((cleanup())), on which the scoped guard API relies
heavily. However, in this case it should be safe, given that this
expression is the input to the guarded variable type's constructor.

It is definitely not pretty, though, so hopefully here is a better way
to attach this.

diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
index 0941f6f58a14..825b7fe94003 100644
--- a/arch/arm64/include/asm/simd.h
+++ b/arch/arm64/include/asm/simd.h
@@ -48,6 +48,7 @@ DEFINE_LOCK_GUARD_1(ksimd,
 		    kernel_neon_begin(_T->lock),
 		    kernel_neon_end(_T->lock))
 
-#define scoped_ksimd()	scoped_guard(ksimd, &(struct user_fpsimd_state){})
+#define scoped_ksimd()	\
+	scoped_guard(ksimd, ({ struct user_fpsimd_state __uninitialized s; &s; }))
 
 #endif
-- 
2.47.3

