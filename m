From: levent demir <levent.demir@inria.fr>
Subject: [BUG] crypto: atmel-aes - erro when compiling with VERBOSE_DEBUG
 enable
Date: Tue, 13 Sep 2016 17:09:38 +0200
Message-ID: <1473779378.3556.20.camel@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:20058
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752971AbcIMPJm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 11:09:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello, 

if you enable VERBOSE_DEBUG and compile you will have the following
error : 

drivers/crypto/atmel-aes.c:323:5: error: too few arguments to function
'atmel_aes_reg_name'
     atmel_aes_reg_name(offset, tmp));
     ^
include/linux/device.h:1306:41: note: in definition of macro 'dev_vdbg'
   dev_printk(KERN_DEBUG, dev, format, ##arg); \
                                         ^
drivers/crypto/atmel-aes.c:205:20: note: declared here
 static const char *atmel_aes_reg_name(u32 offset, char *tmp, size_t sz)

Indeed, in atmel_aes_write function the call to atmel_aes_reg_name
contains only two arguments instead of 3 : 

atmel_aes_reg_name(offset, tmp));

To fix it, one has to only add the size of tmp as third argument : 

atmel_aes_reg_name(offset, tmp, sizeof(tmp)));



--- atmel-aes.c	2016-09-13 17:01:11.199014981 +0200
+++ atmel-aes-fixed.c	2016-09-13 17:01:54.056389455 +0200
@@ -317,7 +317,7 @@
 		char tmp[16];
 
 		dev_vdbg(dd->dev, "write 0x%08x into %s\n", value,
-			 atmel_aes_reg_name(offset, tmp));
+				atmel_aes_reg_name(offset, tmp, sizeof(tmp)));
 	}
 #endif /* VERBOSE_DEBUG */
