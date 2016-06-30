From: Anton Blanchard <anton@ozlabs.org>
Subject: [PATCH 1/2] powerpc: define FUNC_START/FUNC_END
Date: Fri,  1 Jul 2016 08:19:44 +1000
Message-ID: <1467325185-21091-1-git-send-email-anton@ozlabs.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:57733 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbcF3WU1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jun 2016 18:20:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Anton Blanchard <anton@samba.org>

gcc provides FUNC_START/FUNC_END macros to help with creating
assembly functions. Mirror these in the kernel so we can more easily
share code between userspace and the kernel. FUNC_END is just a
stub since we don't currently annotate the end of kernel functions.

It might make sense to do a wholesale search and replace, but for
now just create a couple of defines.

Signed-off-by: Anton Blanchard <anton@samba.org>
---
 arch/powerpc/include/asm/ppc_asm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index 7b591f9..7a924da 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -286,6 +286,9 @@ n:
 
 #endif
 
+#define FUNC_START(name)	_GLOBAL(name)
+#define FUNC_END(name)
+
 /* 
  * LOAD_REG_IMMEDIATE(rn, expr)
  *   Loads the value of the constant expression 'expr' into register 'rn'
-- 
2.7.4
