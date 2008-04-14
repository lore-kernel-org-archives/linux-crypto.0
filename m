From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] add include/asm-avr32/xor.h
Date: Mon, 14 Apr 2008 17:16:32 +0300
Message-ID: <20080414141632.GA6695@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: hskinnemoen@atmel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41733 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760592AbYDNORh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Apr 2008 10:17:37 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes the following compile error with CONFIG_MD_RAID456
on avr32:

<--  snip  -->

...
  CC [M]  crypto/xor.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:23:21: error: asm/xor.h: No such file or directory
/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c: In function 'calibrate_xor_blocks':
/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:131: error: 'XOR_TRY_TEMPLATES' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:131: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:131: error: for each function it appears in.)
make[2]: *** [crypto/xor.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
601f75e99c076c16e2648f4860cac4fc6ce187ea diff --git a/include/asm-avr32/xor.h b/include/asm-avr32/xor.h
new file mode 100644
index 0000000..99c87aa
--- /dev/null
+++ b/include/asm-avr32/xor.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_XOR_H
+#define _ASM_XOR_H
+
+#include <asm-generic/xor.h>
+
+#endif

