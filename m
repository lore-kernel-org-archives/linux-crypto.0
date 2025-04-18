Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B9E262A6;
	Fri, 18 Apr 2025 04:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744948846; cv=none; b=UdbKwfMIhx4mdNaET2BKizJX3ic7GoW92F3+/EAaLSo7sfkPyDe+hIhNY3tSJ6Uv+HzA5Jl4ALAAbsHgaXs9rIWg4oVDfgu3GDsi3I59VnytFWUYNUxn4r2bSwCSpx98MA7Y6jeyBgunNz2XbiKbpKxhfhC4LMHVra+zg7t9isE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744948846; c=relaxed/simple;
	bh=zIJTN+v7hIwW8TsLc0qWWgZ4uUmcS1YX8FJEkkI0NHI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ahh9xkP6m0rJ+4dq9EQhwY5UZwGUY6E5Wd8+ZUkCJ+bGLhH00ibxbvYjCgDdk65HGsSCgQ8GFblIsfBtVTbJ2VMl2+pzgEHK1ReXWwvJzZXK3xbG/HeJd+0q+eNvO5Vl5OO/6cFdu8iubqEwRTdU4N8tMedmZ20zx41Z9HIHrT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FWW6LBrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FWW6LBrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF041C4CEE2;
	Fri, 18 Apr 2025 04:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744948846;
	bh=zIJTN+v7hIwW8TsLc0qWWgZ4uUmcS1YX8FJEkkI0NHI=;
	h=From:To:Cc:Subject:Date:From;
	b=FWW6LBrLnKSDv4Iq9C5PpevthoaZ/Y0CU67yVlhn1nSqz9tC1m6pQOYl5J9Han6JA
	 glHgHIVzCPun5ah9N0wwuJxk4bmnFR5/siwByT/RAUCvpXF6xI5GNJ8T+VtqVWn7mG
	 otPvPWVFCML2Oo5jtur84zRXmCN/O/6vW3OSdYNwP0HrvcdndRpUHf8lD5dUpxDH8r
	 1mEsSsQKydNu1wbRO6JULGLcX7GV28y0LyCoMIpZZVSAXliG9oCUxL0VF2+ZZm83im
	 KgoU0CuIfk/acm3TLWnNn7WPqYolM/WEiolPfvZO7sNXtbAeTq+K70XMJfCx+lsSAU
	 uOZ8kKNgzxw3Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: lib/poly1305 - restore ability to remove modules
Date: Thu, 17 Apr 2025 21:00:17 -0700
Message-ID: <20250418040017.65086-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Though the module_exit functions are now no-ops, they should still be
defined, since otherwise the modules become unremovable.

Fixes: 1f81c58279c7 ("crypto: arm/poly1305 - remove redundant shash algorithm")
Fixes: f4b1a73aec5c ("crypto: arm64/poly1305 - remove redundant shash algorithm")
Fixes: 378a337ab40f ("crypto: powerpc/poly1305 - implement library instead of shash")
Fixes: 21969da642a2 ("crypto: x86/poly1305 - remove redundant shash algorithm")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/poly1305-glue.c         | 5 +++++
 arch/arm64/crypto/poly1305-glue.c       | 5 +++++
 arch/powerpc/crypto/poly1305-p10-glue.c | 5 +++++
 arch/x86/crypto/poly1305_glue.c         | 5 +++++
 4 files changed, 20 insertions(+)

diff --git a/arch/arm/crypto/poly1305-glue.c b/arch/arm/crypto/poly1305-glue.c
index 6d6998b3ec7e3..42d0ebde1ae15 100644
--- a/arch/arm/crypto/poly1305-glue.c
+++ b/arch/arm/crypto/poly1305-glue.c
@@ -114,7 +114,12 @@ static int __init arm_poly1305_mod_init(void)
 		static_branch_enable(&have_neon);
 	return 0;
 }
 arch_initcall(arm_poly1305_mod_init);
 
+static void __exit arm_poly1305_mod_exit(void)
+{
+}
+module_exit(arm_poly1305_mod_exit);
+
 MODULE_DESCRIPTION("Accelerated Poly1305 transform for ARM");
 MODULE_LICENSE("GPL v2");
diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index cb152ceac14a1..906970dd53732 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -105,7 +105,12 @@ static int __init neon_poly1305_mod_init(void)
 		static_branch_enable(&have_neon);
 	return 0;
 }
 arch_initcall(neon_poly1305_mod_init);
 
+static void __exit neon_poly1305_mod_exit(void)
+{
+}
+module_exit(neon_poly1305_mod_exit);
+
 MODULE_DESCRIPTION("Poly1305 authenticator (ARM64 optimized)");
 MODULE_LICENSE("GPL v2");
diff --git a/arch/powerpc/crypto/poly1305-p10-glue.c b/arch/powerpc/crypto/poly1305-p10-glue.c
index 40d296d52c23e..00617f4c58e69 100644
--- a/arch/powerpc/crypto/poly1305-p10-glue.c
+++ b/arch/powerpc/crypto/poly1305-p10-glue.c
@@ -125,8 +125,13 @@ static int __init poly1305_p10_init(void)
 		static_branch_enable(&have_p10);
 	return 0;
 }
 arch_initcall(poly1305_p10_init);
 
+static void __exit poly1305_p10_exit(void)
+{
+}
+module_exit(poly1305_p10_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Danny Tsen <dtsen@linux.ibm.com>");
 MODULE_DESCRIPTION("Optimized Poly1305 for P10");
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index a0fc543a0d688..cff35ca5822a8 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -206,8 +206,13 @@ static int __init poly1305_simd_mod_init(void)
 		static_branch_enable(&poly1305_use_avx512);
 	return 0;
 }
 arch_initcall(poly1305_simd_mod_init);
 
+static void __exit poly1305_simd_mod_exit(void)
+{
+}
+module_exit(poly1305_simd_mod_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
 MODULE_DESCRIPTION("Poly1305 authenticator");

base-commit: da4cb617bc7d827946cbb368034940b379a1de90
-- 
2.49.0

