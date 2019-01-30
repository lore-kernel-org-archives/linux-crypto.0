Return-Path: <SRS0=MZ7V=QG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2392C282D8
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 12:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE33F20882
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 12:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbfA3Mta (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 07:49:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:44152 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730992AbfA3MrY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 07:47:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0A9DBB0CD;
        Wed, 30 Jan 2019 12:47:22 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     mingo@redhat.com
Cc:     bp@alien8.de, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>, linux-crypto@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v7 09/28] x86/asm: annotate aliases
Date:   Wed, 30 Jan 2019 13:46:52 +0100
Message-Id: <20190130124711.12463-10-jslaby@suse.cz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130124711.12463-1-jslaby@suse.cz>
References: <20190130124711.12463-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

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
index 6c349e844581..19effbf9ce35 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -1761,8 +1761,7 @@ ENDPROC(aesni_gcm_finalize)
 #endif
 
 
-.align 4
-_key_expansion_128:
+SYM_FUNC_START_LOCAL_ALIAS(_key_expansion_128)
 SYM_FUNC_START_LOCAL(_key_expansion_256a)
 	pshufd $0b11111111, %xmm1, %xmm1
 	shufps $0b00010000, %xmm0, %xmm4
@@ -1773,8 +1772,8 @@ SYM_FUNC_START_LOCAL(_key_expansion_256a)
 	movaps %xmm0, (TKEYP)
 	add $0x10, TKEYP
 	ret
-ENDPROC(_key_expansion_128)
 SYM_FUNC_END(_key_expansion_256a)
+SYM_FUNC_END_ALIAS(_key_expansion_128)
 
 SYM_FUNC_START_LOCAL(_key_expansion_192a)
 	pshufd $0b01010101, %xmm1, %xmm1
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 3b24dc05251c..68fcd8f9a48b 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -27,7 +27,7 @@
  * Output:
  * rax original destination
  */
-ENTRY(__memcpy)
+SYM_FUNC_START_ALIAS(__memcpy)
 ENTRY(memcpy)
 	ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
 		      "jmp memcpy_erms", X86_FEATURE_ERMS
@@ -41,7 +41,7 @@ ENTRY(memcpy)
 	rep movsb
 	ret
 ENDPROC(memcpy)
-ENDPROC(__memcpy)
+SYM_FUNC_END_ALIAS(__memcpy)
 EXPORT_SYMBOL(memcpy)
 EXPORT_SYMBOL(__memcpy)
 
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index bbec69d8223b..50c1648311b3 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -26,7 +26,7 @@
  */
 .weak memmove
 
-ENTRY(memmove)
+SYM_FUNC_START_ALIAS(memmove)
 ENTRY(__memmove)
 
 	/* Handle more 32 bytes in loop */
@@ -208,6 +208,6 @@ ENTRY(__memmove)
 13:
 	retq
 ENDPROC(__memmove)
-ENDPROC(memmove)
+SYM_FUNC_END_ALIAS(memmove)
 EXPORT_SYMBOL(__memmove)
 EXPORT_SYMBOL(memmove)
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 9bc861c71e75..927ac44d34aa 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -19,7 +19,7 @@
  *
  * rax   original destination
  */
-ENTRY(memset)
+SYM_FUNC_START_ALIAS(memset)
 ENTRY(__memset)
 	/*
 	 * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended
@@ -43,8 +43,8 @@ ENTRY(__memset)
 	rep stosb
 	movq %r9,%rax
 	ret
-ENDPROC(memset)
 ENDPROC(__memset)
+SYM_FUNC_END_ALIAS(memset)
 EXPORT_SYMBOL(memset)
 EXPORT_SYMBOL(__memset)
 
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 1e9ef0ba30a5..30dcc311f566 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -168,13 +168,13 @@ ENDPROC(xen_sysenter_target)
 
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
2.20.1

