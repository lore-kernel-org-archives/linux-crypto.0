From: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Subject: [PATCH] crypto: twofish-avx - remove useless instruction
Date: Thu, 5 Jul 2012 20:43:58 +0200
Message-ID: <20120705184358.GE2091@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2GESoA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jul 2012 14:44:00 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The register %rdx is written, but never read till the end of the encryption
routine. Therefore let's delete the useless instruction.

Signed-off-by: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
---
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index fc31b89..35f4557 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -243,7 +243,6 @@ __twofish_enc_blk_8way:
 	popq %rbx;
 
 	leaq (4*4*4)(%rsi), %rax;
-	leaq (4*4*4)(%rax), %rdx;
 
 	testb %cl, %cl;
 	jnz __enc_xor8;
-- 
1.7.2.5
