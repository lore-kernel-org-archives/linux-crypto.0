From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v2 07/10] x86: assembly, annotate aliases
Date: Mon, 20 Mar 2017 13:32:19 +0100
Message-ID: <20170320123222.15453-7-jslaby@suse.cz>
References: <9ea5e137-61f9-dccc-bb9d-ac3ff86e5867@suse.cz>
 <20170320123222.15453-1-jslaby@suse.cz>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        jpoimboe@redhat.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>, linux-crypto@vger.kernel.org,
        xen-devel@lists.xenproject.org
To: mingo@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754768AbdCTMcb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Mar 2017 08:32:31 -0400
In-Reply-To: <20170320123222.15453-1-jslaby@suse.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

_key_expansion_128 is an alias to _key_expansion_256a, __memcpy to
memcpy, xen_syscall32_target to xen_sysenter_target, and so on. Annotate
them all using the new SYM_FUNC_START_ALIAS, SYM_FUNC_START_LOCAL_ALIAS,
and SYM_FUNC_END_ALIAS. This will make the tools generating the
debuginfo happy.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <x86@kernel.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com> [xen parts]
Cc: <linux-crypto@vger.kernel.org>
Cc: <xen-devel@lists.xenproject.org>
---
 arch/x86/crypto/aesni-intel_asm.S | 5 ++---
 arch/x86/lib/memcpy_64.S          | 4 ++--
 arch/x86/lib/memmove_64.S         | 4 ++--
 arch/x86/lib/memset_64.S          | 4 ++--
 arch/x86/xen/xen-asm_64.S         | 4 ++--
 5 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 8913ea70323c..ea247bfed89d 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -1744,8 +1744,7 @@ ENDPROC(aesni_gcm_enc)
 #endif
 
 
-.align 4
-_key_expansion_128:
+SYM_FUNC_START_LOCAL_ALIAS(_key_expansion_128)
 SYM_FUNC_START_LOCAL(_key_expansion_256a)
 	pshufd $0b11111111, %xmm1, %xmm1
 	shufps $0b00010000, %xmm0, %xmm4
@@ -1756,8 +1755,8 @@ SYM_FUNC_START_LOCAL(_key_expansion_256a)
 	movaps %xmm0, (TKEYP)
 	add $0x10, TKEYP
 	ret
-ENDPROC(_key_expansion_128)
 ENDPROC(_key_expansion_256a)
+SYM_FUNC_END_ALIAS(_key_expansion_128)
 
 SYM_FUNC_START_LOCAL(_key_expansion_192a)
 	pshufd $0b01010101, %xmm1, %xmm1
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 779782f58324..2d6518b4dbd6 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -26,7 +26,7 @@
  * Output:
  * rax original destination
  */
-ENTRY(__memcpy)
+SYM_FUNC_START_ALIAS(__memcpy)
 ENTRY(memcpy)
 	ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
 		      "jmp memcpy_erms", X86_FEATURE_ERMS
@@ -40,7 +40,7 @@ ENTRY(memcpy)
 	rep movsb
 	ret
 ENDPROC(memcpy)
-ENDPROC(__memcpy)
+SYM_FUNC_END_ALIAS(__memcpy)
 EXPORT_SYMBOL(memcpy)
 EXPORT_SYMBOL(__memcpy)
 
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 15de86cd15b0..d22af97e5b27 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -25,7 +25,7 @@
  */
 .weak memmove
 
-ENTRY(memmove)
+SYM_FUNC_START_ALIAS(memmove)
 ENTRY(__memmove)
 
 	/* Handle more 32 bytes in loop */
@@ -207,6 +207,6 @@ ENTRY(__memmove)
 13:
 	retq
 ENDPROC(__memmove)
-ENDPROC(memmove)
+SYM_FUNC_END_ALIAS(memmove)
 EXPORT_SYMBOL(__memmove)
 EXPORT_SYMBOL(memmove)
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 55b95db30a61..0d3a1d341e60 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -18,7 +18,7 @@
  *
  * rax   original destination
  */
-ENTRY(memset)
+SYM_FUNC_START_ALIAS(memset)
 ENTRY(__memset)
 	/*
 	 * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended
@@ -42,8 +42,8 @@ ENTRY(__memset)
 	rep stosb
 	movq %r9,%rax
 	ret
-ENDPROC(memset)
 ENDPROC(__memset)
+SYM_FUNC_END_ALIAS(memset)
 EXPORT_SYMBOL(memset)
 EXPORT_SYMBOL(__memset)
 
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 2a968c087269..b3bf662a4f6a 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -117,13 +117,13 @@ ENDPROC(xen_sysenter_target)
 
 #else /* !CONFIG_IA32_EMULATION */
 
-ENTRY(xen_syscall32_target)
+SYM_FUNC_START_ALIAS(xen_syscall32_target)
 ENTRY(xen_sysenter_target)
 	lea 16(%rsp), %rsp	/* strip %rcx, %r11 */
 	mov $-ENOSYS, %rax
 	pushq $0
 	jmp hypercall_iret
-ENDPROC(xen_syscall32_target)
 ENDPROC(xen_sysenter_target)
+SYM_FUNC_END_ALIAS(xen_syscall32_target)
 
 #endif	/* CONFIG_IA32_EMULATION */
-- 
2.12.0
