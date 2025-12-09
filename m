Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBC6347C7
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 05:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765259339; cv=none; b=NysUPas3DRSlvO1GUFgYvQA289JIHnbUnxJoKMcHhRXbTCQNFrNMV6gZTHpfraBAVkV8hNnzimOopnBzuUt4mRUk9641sF/MTJxOR5wmOFFyYwMALcXCNLfGhFBfwdfgspexliX4Gt/KKtEGdV9Dd+k+TG8sMYzlic0DQQbw7o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765259339; c=relaxed/simple;
	bh=EnPxXewT0JYL81DgO6QFNp08Dq76MYHJMEyIx30LmfE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rYBDEU0J3pH2XQiqyBNzm0I/xOGs37CRdXma0Ch95LuSmdl6h1ulvqyvoP9LpOqq2MzeIXusAxS9AU89+RljFZGXXSlvXyuBLZOJAYz4tMFrqgYzPy0YGN57hGUrGHh1p5Mn7m7rnus6c62DJPSIN8Rt7ixGeC6R1FqQDWgVHho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rG0hfk57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rG0hfk57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82864C4CEF5;
	Tue,  9 Dec 2025 05:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765259338;
	bh=EnPxXewT0JYL81DgO6QFNp08Dq76MYHJMEyIx30LmfE=;
	h=From:To:Cc:Subject:Date:From;
	b=rG0hfk57E0nf/ER61dqgCBdyU695Bufz0ivIecyIZBckFwTioW3qw49jFWUI47YFZ
	 mKH1l2Vu4NElb/D5JVzEjPAERMQdX2WVAZDOw0HKfvlxtBHe0zfcDIFKAtqizWNNh4
	 fpQqiJR+bDS9iDrDdk7N5jDYPSt+Uqcj2eyMpkJ40R9U+GLlt0G0XrrHw8S3pMyPFb
	 ZyvQI3aku2KeutoMHFe414NTI3yC7CsBOAz1KU8Ioa9LhNKfatjNm69InLJbEXINVW
	 g2+ya2mv1RTLcqsDnZW6j6H84Ki/o2nyMkMCCxXuKUlM7IDKR7iV24dv0xpD1x+fco
	 +tXwNOjSA7/4Q==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] arm64/simd: Avoid pointless clearing of FP/SIMD buffer
Date: Tue,  9 Dec 2025 06:48:49 +0100
Message-ID: <20251209054848.998878-2-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2051; i=ardb@kernel.org; h=from:subject; bh=EnPxXewT0JYL81DgO6QFNp08Dq76MYHJMEyIx30LmfE=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIdN8h/M0vcfvp115H//M+f+5X+Y77E+aX1joe8n29LWOh /kCd9P/d5SyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICb3MDwv6bhTLPa++1ZMm/5 ri2eyH5yw9e2e4Y+FetL69Uj7PwE1zL8M94cZPI4zEl1g/ZpjtO2X+u9/6658+rL5dIlNou3PVg QxgIA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

The buffer provided to kernel_neon_begin() is only used if the task is
scheduled out while the FP/SIMD is in use by the kernel, or when such a
section is interrupted by a softirq that also uses the FP/SIMD.

IOW, this happens rarely, and even if it happened often, there is still
no reason for this buffer to be cleared beforehand, which happens
unconditionally, due to the use of a compound literal expression.

So define that buffer variable explicitly, and mark it as
__uninitialized so that it will not get cleared, even when
-ftrivial-auto-var-init is in effect.

This requires some preprocessor gymnastics, due to the fact that the
variable must be defined throughout the entire guarded scope, and the
expression

  ({ struct user_fpsimd_state __uninitialized st; &st; })

is problematic in that regard, even though the compilers seem to
permit it. So instead, repeat for 'for ()' trick that is also used in
the implementation of the guarded scope helpers.

Cc: Will Deacon <will@kernel.org>,
Cc: Catalin Marinas <catalin.marinas@arm.com>,
Cc: Kees Cook <keescook@chromium.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/simd.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
index 0941f6f58a14..69ecbd69ca8c 100644
--- a/arch/arm64/include/asm/simd.h
+++ b/arch/arm64/include/asm/simd.h
@@ -48,6 +48,13 @@ DEFINE_LOCK_GUARD_1(ksimd,
 		    kernel_neon_begin(_T->lock),
 		    kernel_neon_end(_T->lock))
 
-#define scoped_ksimd()	scoped_guard(ksimd, &(struct user_fpsimd_state){})
+#define __scoped_ksimd(_label)					\
+	for (struct user_fpsimd_state __uninitialized __st;	\
+	     true; ({ goto _label; }))				\
+		if (0) {					\
+_label:			break;					\
+		} else scoped_guard(ksimd, &__st)
+
+#define scoped_ksimd()	__scoped_ksimd(__UNIQUE_ID(label))
 
 #endif

base-commit: 3f9f0252130e7dd60d41be0802bf58f6471c691d
-- 
2.47.3

