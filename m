From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] [crypto] aes-asm x86-i586 remove unused return code
Date: Sat, 19 Jan 2008 01:02:13 +0100
Message-ID: <1200700935-3844-4-git-send-email-sebastian@breakpoint.cc>
References: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@ml.breakpoint.cc,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38855 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbYASIdp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2008 03:33:45 -0500
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1JG996-0002dC-Hv
	for linux-crypto@vger.kernel.org; Sat, 19 Jan 2008 09:33:44 +0100
In-Reply-To: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The return parameter isn't used remove it.
Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/x86/crypto/aes-i586-asm_32.S |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/aes-i586-asm_32.S b/arch/x86/crypto/aes-i586-asm_32.S
index 1093bed..e41b147 100644
--- a/arch/x86/crypto/aes-i586-asm_32.S
+++ b/arch/x86/crypto/aes-i586-asm_32.S
@@ -289,7 +289,6 @@ aes_enc_blk:
 	pop     %ebx
 	mov     %r0,(%ebp)
 	pop     %ebp
-	mov     $1,%eax
 	ret
 
 // AES (Rijndael) Decryption Subroutine
@@ -365,6 +364,4 @@ aes_dec_blk:
 	pop     %ebx
 	mov     %r0,(%ebp)
 	pop     %ebp
-	mov     $1,%eax
 	ret
-
-- 
1.5.3.6
