From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v11 06/13] crypto: aesni: add minimal build option for SGX LE
Date: Fri,  8 Jun 2018 19:09:41 +0200
Message-ID: <20180608171216.26521-7-jarkko.sakkinen@linux.intel.com>
References: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
Cc: dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
To: x86@kernel.org, platform-driver-x86@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Allow building a minimal subset of the low-level AESNI functions by
defining AESNI_INTEL_MINIMAL.  The SGX Launch Enclave will utilize
a small number of AESNI functions for creating CMACs when generating
tokens for userspace enclaves.

Reducing the size of the LE is high priority as EPC space is at a
premium and initializing/measuring EPC pages is extremely slow, and
defining only the minimal set of AESNI functions reduces the size of
the in-kernel LE by over 50%.  Because the LE is a (very) non-standard
build environment, using linker tricks e.g. --gc-sections to remove
the unused functions is not an option.

Eliminating the unused AESNI functions also eliminates all usage of
the retpoline macros, e.g. CALL_NOSPEC, which allows the LE linker
script to assert that the alternatives and retpoline sections don't
exist in the final binary.  Because the LE's code cannot be patched,
i.e. retpoline can't be enabled via alternatives, we want to assert
that we're not expecting a security feature that can't be enabled.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index e762ef417562..5a0a487466d5 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -45,6 +45,8 @@
 #define MOVADQ	movaps
 #define MOVUDQ	movups
 
+#ifndef AESNI_INTEL_MINIMAL
+
 #ifdef __x86_64__
 
 # constants in mergeable sections, linker can reorder and merge
@@ -133,6 +135,8 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 #define keysize 2*15*16(%arg1)
 #endif
 
+#endif /* AESNI_INTEL_MINIMAL */
+
 
 #define STATE1	%xmm0
 #define STATE2	%xmm4
@@ -506,6 +510,8 @@ _T_16_\@:
 _return_T_done_\@:
 .endm
 
+#ifndef AESNI_INTEL_MINIMAL
+
 #ifdef __x86_64__
 /* GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
 *
@@ -1760,6 +1766,7 @@ ENDPROC(aesni_gcm_finalize)
 
 #endif
 
+#endif /* AESNI_INTEL_MINIMAL */
 
 .align 4
 _key_expansion_128:
@@ -2031,6 +2038,8 @@ _aesni_enc1:
 	ret
 ENDPROC(_aesni_enc1)
 
+#ifndef AESNI_INTEL_MINIMAL
+
 /*
  * _aesni_enc4:	internal ABI
  * input:
@@ -2840,3 +2849,5 @@ ENTRY(aesni_xts_crypt8)
 ENDPROC(aesni_xts_crypt8)
 
 #endif
+
+#endif /* AESNI_INTEL_MINIMAL */
-- 
2.17.0
