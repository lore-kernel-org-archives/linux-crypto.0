From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [2.6 patch] add include/asm-avr32/xor.h
Date: Mon, 14 Apr 2008 20:11:40 +0200
Message-ID: <20080414181140.GA813@Chamillionaire.breakpoint.cc>
References: <20080414141632.GA6695@cs181133002.pp.htv.fi>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: hskinnemoen@atmel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, shannon.nelson@intel.com,
	dan.j.williams@intel.com
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764935AbYDNSMV@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080414141632.GA6695@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Adrian Bunk | 2008-04-14 17:16:32 [+0300]:

>This patch fixes the following compile error with CONFIG_MD_RAID456
>on avr32:
>
><--  snip  -->
>
>...
>  CC [M]  crypto/xor.o
>/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:23:21: error: asm/xor.h: No such file or directory
>/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c: In function 'calibrate_xor_blocks':
>/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:131: error: 'XOR_TRY_TEMPLATES' undeclared (first use in this function)
>/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:131: error: (Each undeclared identifier is reported only once
>/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:131: error: for each function it appears in.)
>make[2]: *** [crypto/xor.o] Error 1
>
><--  snip  -->
>
>Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
>---
>601f75e99c076c16e2648f4860cac4fc6ce187ea diff --git a/include/asm-avr32/xor.h b/include/asm-avr32/xor.h
>new file mode 100644
>index 0000000..99c87aa
>--- /dev/null
>+++ b/include/asm-avr32/xor.h
>@@ -0,0 +1,6 @@
>+#ifndef _ASM_XOR_H
>+#define _ASM_XOR_H
>+
>+#include <asm-generic/xor.h>
>+
>+#endif

What about providing <linux/xor.h> which includes the right file from
asm/ or asm-generic/ depending on HAVE_.* ?

Sebastian
