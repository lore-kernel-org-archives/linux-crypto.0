From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH] crypto: x86/aegis,morus - Do not require OSXSAVE for SSE2
Date: Wed,  5 Sep 2018 09:26:41 +0200
Message-ID: <20180905072641.13677-1-omosnace@redhat.com>
Cc: linux-crypto@vger.kernel.org, Zdenek Kaspar <zkaspar82@gmail.com>,
        Ondrej Mosnacek <omosnace@redhat.com>, stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

It turns out OSXSAVE needs to be checked only for AVX, not for SSE.
Without this patch the affected modules refuse to load on CPUs with SSE2
but without AVX support.

Fixes: 877ccce7cbe8 ("crypto: x86/aegis,morus - Fix and simplify CPUID checks")
Cc: <stable@vger.kernel.org> # 4.18
Reported-by: Zdenek Kaspar <zkaspar82@gmail.com>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 arch/x86/crypto/aegis128-aesni-glue.c  | 1 -
 arch/x86/crypto/aegis128l-aesni-glue.c | 1 -
 arch/x86/crypto/aegis256-aesni-glue.c  | 1 -
 arch/x86/crypto/morus1280-sse2-glue.c  | 1 -
 arch/x86/crypto/morus640-sse2-glue.c   | 1 -
 5 files changed, 5 deletions(-)

NOTE: This patch doesn't apply to the current crypto-2.6 tree [1], since
it is based on v4.18-rc7, which doesn't contain the commit this patch is
fixing. It needs to merge in the v4.18 tag before this patch can be
applied.

Thanks,
Ondrej

[1] https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git/

diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index acd11b3bf639..2a356b948720 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -379,7 +379,6 @@ static int __init crypto_aegis128_aesni_module_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM2) ||
 	    !boot_cpu_has(X86_FEATURE_AES) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
 		return -ENODEV;
 
diff --git a/arch/x86/crypto/aegis128l-aesni-glue.c b/arch/x86/crypto/aegis128l-aesni-glue.c
index 2071c3d1ae07..dbe8bb980da1 100644
--- a/arch/x86/crypto/aegis128l-aesni-glue.c
+++ b/arch/x86/crypto/aegis128l-aesni-glue.c
@@ -379,7 +379,6 @@ static int __init crypto_aegis128l_aesni_module_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM2) ||
 	    !boot_cpu_has(X86_FEATURE_AES) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
 		return -ENODEV;
 
diff --git a/arch/x86/crypto/aegis256-aesni-glue.c b/arch/x86/crypto/aegis256-aesni-glue.c
index b5f2a8fd5a71..8bebda2de92f 100644
--- a/arch/x86/crypto/aegis256-aesni-glue.c
+++ b/arch/x86/crypto/aegis256-aesni-glue.c
@@ -379,7 +379,6 @@ static int __init crypto_aegis256_aesni_module_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM2) ||
 	    !boot_cpu_has(X86_FEATURE_AES) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
 		return -ENODEV;
 
diff --git a/arch/x86/crypto/morus1280-sse2-glue.c b/arch/x86/crypto/morus1280-sse2-glue.c
index 95cf857d2cbb..f40244eaf14d 100644
--- a/arch/x86/crypto/morus1280-sse2-glue.c
+++ b/arch/x86/crypto/morus1280-sse2-glue.c
@@ -40,7 +40,6 @@ MORUS1280_DECLARE_ALGS(sse2, "morus1280-sse2", 350);
 static int __init crypto_morus1280_sse2_module_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM2) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
 		return -ENODEV;
 
diff --git a/arch/x86/crypto/morus640-sse2-glue.c b/arch/x86/crypto/morus640-sse2-glue.c
index 615fb7bc9a32..9afaf8f8565a 100644
--- a/arch/x86/crypto/morus640-sse2-glue.c
+++ b/arch/x86/crypto/morus640-sse2-glue.c
@@ -40,7 +40,6 @@ MORUS640_DECLARE_ALGS(sse2, "morus640-sse2", 400);
 static int __init crypto_morus640_sse2_module_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM2) ||
-	    !boot_cpu_has(X86_FEATURE_OSXSAVE) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
 		return -ENODEV;
 
-- 
2.17.1
