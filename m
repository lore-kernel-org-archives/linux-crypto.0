From: Rik Snel <rsnel@cube.dyndns.org>
Subject: [PATCH 3/6] crypto: some common 128-bit block operations, nicely centralized
Date: Thu, 31 Aug 2006 14:39:33 +0200
Message-ID: <11570279791046-git-send-email-rsnel@cube.dyndns.org>
References: <11570279761772-git-send-email-rsnel@cube.dyndns.org>
Reply-To: Rik Snel <rsnel@cube.dyndns.org>
Cc: linux-crypto@vger.kernel.org, Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:58885 "EHLO
	smtp-vbr4.xs4all.nl") by vger.kernel.org with ESMTP id S932149AbWHaMkM
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Aug 2006 08:40:12 -0400
To: herbert@gondor.apana.org.au
In-Reply-To: <11570279761772-git-send-email-rsnel@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

128bit is a common blocksize in linux kernel cryptography, so it helps to
centralize some common operations. The data must be aligned at sizeof(int)
for decent performance.

The code, while mostly trivial, is based on a header file mode_hdr.h in
http://fp.gladman.plus.com/AES/modes.vc8.19-06-06.zip

The original copyright (and GPL statement) of the original author,
Dr Brian Gladman, is preserved.

Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>
---
 crypto/b128ops.h |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/crypto/b128ops.h b/crypto/b128ops.h
new file mode 100644
index 0000000..d32bfc2
--- /dev/null
+++ b/crypto/b128ops.h
@@ -0,0 +1,72 @@
+/* b128ops.h - common 128-bit block operations
+ * 
+ * Copyright (c) 2003, Dr Brian Gladman, Worcester, UK.
+ * Copyright (c) 2006, Rik Snel <rsnel@cube.dyndns.org>
+ *
+ * Based on Dr Brain Gladman's (GPL'd) work published at
+ * http://fp.gladman.plus.com/cryptography_technology/index.htm
+ * See the original copyright notice below.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+/*
+ ---------------------------------------------------------------------------
+ Copyright (c) 2003, Dr Brian Gladman, Worcester, UK.   All rights reserved.
+
+ LICENSE TERMS
+
+ The free distribution and use of this software in both source and binary
+ form is allowed (with or without changes) provided that:
+
+   1. distributions of this source code include the above copyright
+      notice, this list of conditions and the following disclaimer;
+
+   2. distributions in binary form include the above copyright
+      notice, this list of conditions and the following disclaimer
+      in the documentation and/or other associated materials;
+
+   3. the copyright holder's name is not used to endorse products
+      built using this software without specific written permission.
+
+ ALTERNATIVELY, provided that this notice is retained in full, this product
+ may be distributed under the terms of the GNU General Public License (GPL),
+ in which case the provisions of the GPL apply INSTEAD OF those given above.
+
+ DISCLAIMER
+
+ This software is provided 'as is' with no explicit or implied warranties
+ in respect of its properties, including, but not limited to, correctness
+ and/or fitness for purpose.
+ ---------------------------------------------------------------------------
+ Issue Date: 13/06/2006
+*/
+
+#ifndef _LINUX_B128OPS_H
+#define _LINUX_B128OPS_H
+
+#include <linux/byteorder/swab.h>
+
+/* watch out: for good performance p and q must be aligned to 32bit
+ * boundaries on a 32bit machine and to 64bit boundaries on a 64bit 
+ * machine. */
+inline void b128ops_mov(void *p, const void *q)
+{
+	((u64*)p)[0] = ((u64*)q)[0];
+	((u64*)p)[1] = ((u64*)q)[1];
+}
+
+inline void b128ops_xor(void *p, const void *q)
+{
+	((u64*)p)[0] ^= ((u64*)q)[0];
+	((u64*)p)[1] ^= ((u64*)q)[1];
+}
+
+inline void bswap64_block(void* d, const void* s, u32 n)
+{ 
+    while(n--) ((u64*)d)[n] = __swab64(((u64*)s)[n]);
+}
+
+#endif /* _LINUX_B128OPS_H */
-- 
1.4.1.1

