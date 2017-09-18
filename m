From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 06/12] x86/crypto: Fix RBP usage in sha1_avx2_x86_64_asm.S
Date: Mon, 18 Sep 2017 14:42:05 -0500
Message-ID: <baa31c30ff580cef019041e431f5cbcd0dc2d1c7.1505763153.git.jpoimboe@redhat.com>
References: <cover.1505763153.git.jpoimboe@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750921AbdIRTmo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Sep 2017 15:42:44 -0400
In-Reply-To: <cover.1505763153.git.jpoimboe@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Using RBP as a temporary register breaks frame pointer convention and
breaks stack traces when unwinding from an interrupt in the crypto code.

Use R11 instead of RBP.  Since R11 isn't a callee-saved register, it
doesn't need to be saved and restored on the stack.

Reported-by: Eric Biggers <ebiggers@google.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Eric Biggers <ebiggers@google.com>
Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/sha1_avx2_x86_64_asm.S | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
index 1eab79c9ac48..9f712a7dfd79 100644
--- a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
+++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
@@ -89,7 +89,7 @@
 #define	REG_RE	%rdx
 #define	REG_RTA	%r12
 #define	REG_RTB	%rbx
-#define	REG_T1	%ebp
+#define	REG_T1	%r11d
 #define	xmm_mov	vmovups
 #define	avx2_zeroupper	vzeroupper
 #define	RND_F1	1
@@ -637,7 +637,6 @@ _loop3:
 	ENTRY(\name)
 
 	push	%rbx
-	push	%rbp
 	push	%r12
 	push	%r13
 	push	%r14
@@ -673,7 +672,6 @@ _loop3:
 	pop	%r14
 	pop	%r13
 	pop	%r12
-	pop	%rbp
 	pop	%rbx
 
 	ret
-- 
2.13.5
