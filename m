Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3985F285C8D;
	Mon,  3 Nov 2025 02:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762137322; cv=none; b=WNq/dMvCLmOcaibA1RaWnSEvocsn/7vQgPkmIhshtQUEMpbdnpHKoE2weOYcP+kzjEMJC57ZjEQMMrYNVJIe1i7O0V8FXg3HjOsNhIL1nJ9SlWLRW7XU23MkqcusJI8fSSDPEUF9t3Oo1XFMA3rK5c/7/ub30iqxcXPwR1MLZ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762137322; c=relaxed/simple;
	bh=HN74kdnoxGftT5uGY7CIrbimSmHE7k+Bss9Q2BwLzvs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=skTaRIOOugKVf9BRHmN+iYH7bmtLJJFPqtFkQlIBNuDQERxNVTaYS9YYYBpCg7RijHiQq+NGP+8ibWTdNHRe4YJtUIT/wA7Ak1wnPnBBBm5XWKfC89pjS7deZC4/krv4eojN22p0NNB3VgfsV1RKWnQ5Zae4jg4G1jN8UmX6PIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=giJExO9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="giJExO9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C066C4CEFB;
	Mon,  3 Nov 2025 02:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762137321;
	bh=HN74kdnoxGftT5uGY7CIrbimSmHE7k+Bss9Q2BwLzvs=;
	h=From:Date:Subject:To:Cc:From;
	b=giJExO9cukbKjVO0Y3qTRbFBvpXuyVgHqbgptvGgS4HFwJWKy22SQB5ZzEAOT04I/
	 BEi8/h2KwSt8sFBEnJXFRXPB4ybzbY5PpCat+C3jebZ+qNhNgdQrFNLb3dQTqeLZtE
	 5UXZuOCsC2ZJwDa/i2qm1E03gdwJqmvuGC8VwVpkQrh7dhHmjHspiwVf0u9c+m7RLF
	 oe+S5dGWwrBGfxVKhlMMMDkrRy1iSaK0tryzKJpVo3ryy/ly6WAg4vlRrX9FtjakQ3
	 vQy/KNN36kvUIaUsDkMu6ycc6dVc31SB3SzMaUoeO31uDg3fO2Ihlc+C1G3OuT5nXc
	 pxMbi9Dt8RHsg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Sun, 02 Nov 2025 21:35:03 -0500
Subject: [PATCH] lib/crypto: curve25519-hacl64: Fix older clang KASAN
 workaround for GCC
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251102-curve25519-hacl64-fix-kasan-workaround-v1-1-6ec6738f9741@kernel.org>
X-B4-Tracking: v=1; b=H4sIANYUCGkC/x2NQQqDMBAAvyJ77kISmlb7leJhTTZ1sSRlg1YQ/
 97Q48Awc0BlFa7w6A5Q3qRKyQ3spYMwU34xSmwMzjhvrXEYVt3YeW8HnCm8b1dMsuNClTJ+iy6
 kZc0R7z7FqQ9m6FOEFvsoN+8/eo7n+QPdYBYaeAAAAA==
X-Change-ID: 20251102-curve25519-hacl64-fix-kasan-workaround-75fdb8c098fd
To: Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1470; i=nathan@kernel.org;
 h=from:subject:message-id; bh=HN74kdnoxGftT5uGY7CIrbimSmHE7k+Bss9Q2BwLzvs=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJkcIs+7q6Z4zrzSsbXzraym5/Nmj+dy0RoRxRvKTDa8P
 TxzzZRHHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi6+sZ/kflK0xpue/U6ndX
 UER3Qcyml/dk52n3Zv05edUxue3W1okM/90j9phrdyyZtGi/1g5D63IN86WPuy9GaHzsuzN1S2X
 Cc1YA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with
clang-17 and older") inadvertently disabled KASAN in curve25519-hacl64.o
for GCC unconditionally because clang-min-version will always evaluate
to nothing for GCC. Add a check for CONFIG_CC_IS_GCC to avoid the
workaround, which is only needed for clang-17 and older.

Additionally, invert the 'ifeq (...,)' into 'ifneq (...,y)', as it is a
little easier to read and understand the intention ("if not GCC or at
least clang-18, disable KASAN").

Cc: stable@vger.kernel.org
Fixes: 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 lib/crypto/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index bded351aeace..372b7a12b371 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -90,7 +90,7 @@ else
 libcurve25519-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC) += curve25519-fiat32.o
 endif
 # clang versions prior to 18 may blow out the stack with KASAN
-ifeq ($(call clang-min-version, 180000),)
+ifneq ($(CONFIG_CC_IS_GCC)$(call clang-min-version, 180000),y)
 KASAN_SANITIZE_curve25519-hacl64.o := n
 endif
 

---
base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
change-id: 20251102-curve25519-hacl64-fix-kasan-workaround-75fdb8c098fd

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

