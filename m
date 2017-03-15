From: Michael Davidson <md@google.com>
Subject: [PATCH] crypto, x86: aesni - fix token pasting for clang
Date: Wed, 15 Mar 2017 15:36:00 -0700
Message-ID: <20170315223600.131367-1-md@google.com>
Cc: Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Davidson <md@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

aes_ctrby8_avx-x86_64.S uses the C preprocessor for token pasting
of character sequences that are not valid preprocessor tokens.
While this is allowed when preprocessing assembler files it exposes
an incompatibilty between the clang and gcc preprocessors where
clang does not strip leading white space from macro parameters,
leading to the CONCAT(%xmm, i) macro expansion on line 96 resulting
in a token with a space character embedded in it.

While this could be resolved by deleting the offending space character,
the assembler is perfectly capable of doing the token pasting correctly
for itself so we can just get rid of the preprocessor macros.

Signed-off-by: Michael Davidson <md@google.com>
---
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index a916c4a61165..5f6a5af9c489 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -65,7 +65,6 @@
 #include <linux/linkage.h>
 #include <asm/inst.h>
 
-#define CONCAT(a,b)	a##b
 #define VMOVDQ		vmovdqu
 
 #define xdata0		%xmm0
@@ -92,8 +91,6 @@
 #define num_bytes	%r8
 
 #define tmp		%r10
-#define	DDQ(i)		CONCAT(ddq_add_,i)
-#define	XMM(i)		CONCAT(%xmm, i)
 #define	DDQ_DATA	0
 #define	XDATA		1
 #define KEY_128		1
@@ -131,12 +128,12 @@ ddq_add_8:
 /* generate a unique variable for ddq_add_x */
 
 .macro setddq n
-	var_ddq_add = DDQ(\n)
+	var_ddq_add = ddq_add_\n
 .endm
 
 /* generate a unique variable for xmm register */
 .macro setxdata n
-	var_xdata = XMM(\n)
+	var_xdata = %xmm\n
 .endm
 
 /* club the numeric 'id' to the symbol 'name' */
-- 
2.12.0.367.g23dc2f6d3c-goog
