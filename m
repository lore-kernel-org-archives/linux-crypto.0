Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017D62CCC5;
	Mon,  3 Nov 2025 19:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762197091; cv=none; b=iUjzmnKMMwYpMOF6Y2lVtjmlo70cJl10yXUxsoTSKxktBuqls6pntm0pR2P+OMdiPtKLRG4tBT1wNMf/03/ZLDYfqruyP8UbzzLoE0lajTH9lh83jFEtw3bhMUkBB/BivaplKmb2R7bb+B85QUXKr8hAbkSvfJ3yZ+bDXKUvQ24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762197091; c=relaxed/simple;
	bh=elJCjcfvahvp6s3Rlkf81DsuW1yBFx0eE2HI5yG2OtE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=vD89Ntd65VlWFp2zro/07jn5aWQMnJp7deXYyLMdtO0xJlAGNijkbRoe8T+SY6Fp/xDNgEelka4G8IbqNM2CY00urJD+p4Z8V2ifkn5KT9eKVeirLcEDS1vtBALKzN9ZyyOVdSeFPLmIWUmwkGo0zvf+94UG1pPITeEe0+TjY7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nfhcuuso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nfhcuuso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CAAC4CEE7;
	Mon,  3 Nov 2025 19:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762197090;
	bh=elJCjcfvahvp6s3Rlkf81DsuW1yBFx0eE2HI5yG2OtE=;
	h=From:Date:Subject:To:Cc:From;
	b=nfhcuusoSXGMQWZ+AzDSZcG2aCi3FD2aDi8q4VL3ub0GavZKhlw1bGDuj08qcOUI3
	 iubyWeruzHsAQDnjZ/0pGxjoedR8c2OsaF8vnKr2WajGgvrP+Uu+xGH5NMC2fZ0JGt
	 5ksK/TT+/D91WxhlzD8+ki1pQbvxOvB/KYmP6ag7tDxZdf5wjTpaBwpe9dmw8/aLet
	 Yt+Bp0IYu60eZ+ZHDmEBfbP7l/KYGn81CBNBiPX92xt5r0j2FJzUAOApT6YyXJqCKQ
	 FGcbtuKphX42GSxrbfx7pihIBA8V4ylYZMRyK4wvNlAouk2ZkV7TLDS3T7BWl4rhm2
	 K9DME2FEZo3yQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 03 Nov 2025 12:11:24 -0700
Subject: [PATCH v2] lib/crypto: curve25519-hacl64: Fix older clang KASAN
 workaround for GCC
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251103-curve25519-hacl64-fix-kasan-workaround-v2-1-ab581cbd8035@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFv+CGkC/5WNSw6CMBRFt0I69hlaKR9H7sMwqO0rNJCWvErVE
 PZuZQcOz83NORuLSA4juxYbI0wuuuAziFPB9Kj8gOBMZiZKITkvBeiVEgopeQej0nNdgXVvmFR
 UHl6BJkVh9QYaac2j1WXXWsOybCHMvyN07zOPLj4DfY5u4r/170TiwKFGXTeX1nZNxW8Tksf5H
 Ghg/b7vX2Ybv2TdAAAA
X-Change-ID: 20251102-curve25519-hacl64-fix-kasan-workaround-75fdb8c098fd
To: Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1553; i=nathan@kernel.org;
 h=from:subject:message-id; bh=elJCjcfvahvp6s3Rlkf81DsuW1yBFx0eE2HI5yG2OtE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJkc/xIyspj72GVWtoUsOmXiscxF02z+3aWxxc9X7JwT7
 75rzqMDHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi/z8wMpwOP9XSOH1jVWfw
 pb35F7PiGOtPvfirYPp/O09t+u14hiZGhtkaT2+9krVu2D47wyr0i+jjb/OuqpVcWcn/VGiazy+
 n/bwA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with
clang-17 and older") inadvertently disabled KASAN in curve25519-hacl64.o
for GCC unconditionally because clang-min-version will always evaluate
to nothing for GCC. Add a check for CONFIG_CC_IS_CLANG to avoid applying
the workaround for GCC, which is only needed for clang-17 and older.

Cc: stable@vger.kernel.org
Fixes: 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v2:
- Check for CONFIG_CC_IS_CLANG explicitly instead of using
  CONFIG_CC_IS_GCC as "not clang" (Eric).
- Link to v1: https://patch.msgid.link/20251102-curve25519-hacl64-fix-kasan-workaround-v1-1-6ec6738f9741@kernel.org
---
 lib/crypto/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index bded351aeace..d2845b214585 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -90,7 +90,7 @@ else
 libcurve25519-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC) += curve25519-fiat32.o
 endif
 # clang versions prior to 18 may blow out the stack with KASAN
-ifeq ($(call clang-min-version, 180000),)
+ifeq ($(CONFIG_CC_IS_CLANG)_$(call clang-min-version, 180000),y_)
 KASAN_SANITIZE_curve25519-hacl64.o := n
 endif
 

---
base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
change-id: 20251102-curve25519-hacl64-fix-kasan-workaround-75fdb8c098fd

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

