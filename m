From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: x86/sha512_ssse3 - fixup for asm function prototype change
Date: Fri, 24 Apr 2015 08:37:09 +0200
Message-ID: <1429857429-13323-1-git-send-email-ard.biesheuvel@linaro.org>
References: <CAArOQ2U-dSkbNba_dDiO6cgCXDZEQJ8iChBLxxPO=Hi_mn-2Ag@mail.gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	torvalds@linux-foundation.org, smueller@chronox.de,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	bobbypowers@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33157 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbbDXGhW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Apr 2015 02:37:22 -0400
Received: by wgin8 with SMTP id n8so40247760wgi.0
        for <linux-crypto@vger.kernel.org>; Thu, 23 Apr 2015 23:37:21 -0700 (PDT)
In-Reply-To: <CAArOQ2U-dSkbNba_dDiO6cgCXDZEQJ8iChBLxxPO=Hi_mn-2Ag@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch e68410ebf626 ("crypto: x86/sha512_ssse3 - move SHA-384/512
SSSE3 implementation to base layer") changed the prototypes of the
core asm SHA-512 implementations so that they are compatible with
the prototype used by the base layer.

However, in one instance, the register that was used for passing the
input buffer was reused as a scratch register later on in the code,
and since the input buffer param changed places with the digest param
-which needs to be written back before the function returns- this
resulted in the scratch register to be dereferenced in a memory write
operation, causing a GPF.

Fix this by changing the scratch register to use the same register as
the input buffer param again.

Fixes: e68410ebf626 ("crypto: x86/sha512_ssse3 - move SHA-384/512 SSSE3 implementation to base layer")
Reported-By: Bobby Powers <bobbypowers@gmail.com>
Tested-By: Bobby Powers <bobbypowers@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/sha512-avx2-asm.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index a4771dcd1fcf..1f20b35d8573 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -79,7 +79,7 @@ NUM_BLKS    = %rdx
 c           = %rcx
 d           = %r8
 e           = %rdx
-y3          = %rdi
+y3          = %rsi
 
 TBL   = %rbp
 
-- 
1.8.3.2
