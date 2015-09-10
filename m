From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 3/4] crypto: [sha] glue code for Intel SHA extensions
 optimized SHA1 & SHA256
Date: Thu, 10 Sep 2015 15:27:20 -0700
Message-ID: <1441924040.4322.3.camel@schen9-desk2.jf.intel.com>
References: <cover.1441929717.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Sean Gulley <sean.m.gulley@intel.com>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1441929717.git.tim.c.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


This patch adds the glue code to detect and utilize the Intel SHA
extensions optimized SHA1 and SHA256 update transforms when available.

This code has been tested on Broxton for functionality.

Originally-by: Chandramouli Narayanan <mouli_7982@yahoo.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha1_ssse3_glue.c   | 12 +++++++++++-
 arch/x86/crypto/sha256_ssse3_glue.c | 38 ++++++++++++++++++++++---------------
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 7c48e8b..98be8cc 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -44,6 +44,10 @@ asmlinkage void sha1_transform_avx(u32 *digest, const char *data,
 asmlinkage void sha1_transform_avx2(u32 *digest, const char *data,
 				    unsigned int rounds);
 #endif
+#ifdef CONFIG_AS_SHA1_NI
+asmlinkage void sha1_ni_transform(u32 *digest, const char *data,
+				   unsigned int rounds);
+#endif
 
 static void (*sha1_transform_asm)(u32 *, const char *, unsigned int);
 
@@ -166,12 +170,18 @@ static int __init sha1_ssse3_mod_init(void)
 #endif
 	}
 #endif
+#ifdef CONFIG_AS_SHA1_NI
+	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
+		sha1_transform_asm = sha1_ni_transform;
+		algo_name = "SHA-NI";
+	}
+#endif
 
 	if (sha1_transform_asm) {
 		pr_info("Using %s optimized SHA-1 implementation\n", algo_name);
 		return crypto_register_shash(&alg);
 	}
-	pr_info("Neither AVX nor AVX2 nor SSSE3 is available/usable.\n");
+	pr_info("Neither AVX nor AVX2 nor SSSE3/SHA-NI is available/usable.\n");
 
 	return -ENODEV;
 }
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index f8097fc..9c7b22c 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -50,6 +50,10 @@ asmlinkage void sha256_transform_avx(u32 *digest, const char *data,
 asmlinkage void sha256_transform_rorx(u32 *digest, const char *data,
 				      u64 rounds);
 #endif
+#ifdef CONFIG_AS_SHA256_NI
+asmlinkage void sha256_ni_transform(u32 *digest, const char *data,
+				   u64 rounds); /*unsigned int rounds);*/
+#endif
 
 static void (*sha256_transform_asm)(u32 *, const char *, u64);
 
@@ -142,36 +146,40 @@ static bool __init avx_usable(void)
 
 static int __init sha256_ssse3_mod_init(void)
 {
+	char *algo;
+
 	/* test for SSSE3 first */
-	if (cpu_has_ssse3)
+	if (cpu_has_ssse3) {
 		sha256_transform_asm = sha256_transform_ssse3;
+		algo = "SSSE3";
+	}
 
 #ifdef CONFIG_AS_AVX
 	/* allow AVX to override SSSE3, it's a little faster */
 	if (avx_usable()) {
+		sha256_transform_asm = sha256_transform_avx;
+		algo = "AVX";
 #ifdef CONFIG_AS_AVX2
-		if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_BMI2))
+		if (boot_cpu_has(X86_FEATURE_AVX2) &&
+		    boot_cpu_has(X86_FEATURE_BMI2)) {
 			sha256_transform_asm = sha256_transform_rorx;
-		else
+			algo = "AVX2";
+		}
+#endif
+	}
 #endif
-			sha256_transform_asm = sha256_transform_avx;
+#ifdef CONFIG_AS_SHA256_NI
+	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
+		sha256_transform_asm = sha256_ni_transform;
+		algo = "SHA-256-NI";
 	}
 #endif
 
 	if (sha256_transform_asm) {
-#ifdef CONFIG_AS_AVX
-		if (sha256_transform_asm == sha256_transform_avx)
-			pr_info("Using AVX optimized SHA-256 implementation\n");
-#ifdef CONFIG_AS_AVX2
-		else if (sha256_transform_asm == sha256_transform_rorx)
-			pr_info("Using AVX2 optimized SHA-256 implementation\n");
-#endif
-		else
-#endif
-			pr_info("Using SSSE3 optimized SHA-256 implementation\n");
+		pr_info("Using %s optimized SHA-256 implementation\n", algo);
 		return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 	}
-	pr_info("Neither AVX nor SSSE3 is available/usable.\n");
+	pr_info("Neither AVX nor SSSE3/SHA-NI is available/usable.\n");
 
 	return -ENODEV;
 }
-- 
2.4.2
