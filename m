From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH] crypto: sha1-powerpc: little-endian support
Date: Fri, 23 Sep 2016 16:31:56 -0300
Message-ID: <1474659116-4689-1-git-send-email-marcelo.cerri@canonical.com>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        George Wilson <gcwilson@us.ibm.com>,
        Claudio Carvalho <cclaudio@br.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@br.ibm.com>,
        joy.latten@canonical.com,
        Marcelo Cerri <marcelo.cerri@canonical.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:35241 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758001AbcIWTcy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2016 15:32:54 -0400
Received: by mail-qk0-f171.google.com with SMTP id t7so115464282qkh.2
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2016 12:32:54 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver does not handle endianness properly when loading the input
data.

Signed-off-by: Marcelo Cerri <marcelo.cerri@canonical.com>
---
 arch/powerpc/crypto/sha1-powerpc-asm.S | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/crypto/sha1-powerpc-asm.S b/arch/powerpc/crypto/sha1-powerpc-asm.S
index 125e165..82ddc9b 100644
--- a/arch/powerpc/crypto/sha1-powerpc-asm.S
+++ b/arch/powerpc/crypto/sha1-powerpc-asm.S
@@ -7,6 +7,15 @@
 #include <asm/ppc_asm.h>
 #include <asm/asm-offsets.h>
 
+#ifdef __BIG_ENDIAN__
+#define LWZ(rt, d, ra)	\
+	lwz	rt,d(ra)
+#else
+#define LWZ(rt, d, ra)	\
+	li	rt,d;	\
+	lwbrx	rt,rt,ra
+#endif
+
 /*
  * We roll the registers for T, A, B, C, D, E around on each
  * iteration; T on iteration t is A on iteration t+1, and so on.
@@ -23,7 +32,7 @@
 #define W(t)	(((t)%16)+16)
 
 #define LOADW(t)				\
-	lwz	W(t),(t)*4(r4)
+	LWZ(W(t),(t)*4,r4)
 
 #define STEPD0_LOAD(t)				\
 	andc	r0,RD(t),RB(t);		\
@@ -33,7 +42,7 @@
 	add	r0,RE(t),r15;			\
 	add	RT(t),RT(t),r6;		\
 	add	r14,r0,W(t);			\
-	lwz	W((t)+4),((t)+4)*4(r4);	\
+	LWZ(W((t)+4),((t)+4)*4,r4);	\
 	rotlwi	RB(t),RB(t),30;			\
 	add	RT(t),RT(t),r14
 
-- 
2.7.4
