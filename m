From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 1/6] lib/crc: Move polynomial definition to separate header
Date: Tue, 17 Jul 2018 18:05:36 +0200
Message-ID: <20180717160541.3843-2-krzk@kernel.org>
References: <20180717160541.3843-1-krzk@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kern
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717160541.3843-1-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Allow other drivers and parts of kernel to use the same define for
CRC32 polynomial, instead of duplicating it in many places.  This code
does not bring any functional changes, except moving existing code.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 include/linux/crc32poly.h | 20 ++++++++++++++++++++
 lib/crc32.c               |  1 +
 lib/crc32defs.h           | 14 --------------
 lib/gen_crc32table.c      |  1 +
 4 files changed, 22 insertions(+), 14 deletions(-)
 create mode 100644 include/linux/crc32poly.h

diff --git a/include/linux/crc32poly.h b/include/linux/crc32poly.h
new file mode 100644
index 000000000000..7ad5aa92d3c7
--- /dev/null
+++ b/include/linux/crc32poly.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CRC32_POLY_H
+#define _LINUX_CRC32_POLY_H
+
+/*
+ * There are multiple 16-bit CRC polynomials in common use, but this is
+ * *the* standard CRC-32 polynomial, first popularized by Ethernet.
+ * x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x^1+x^0
+ */
+#define CRCPOLY_LE 0xedb88320
+#define CRCPOLY_BE 0x04c11db7
+
+/*
+ * This is the CRC32c polynomial, as outlined by Castagnoli.
+ * x^32+x^28+x^27+x^26+x^25+x^23+x^22+x^20+x^19+x^18+x^14+x^13+x^11+x^10+x^9+
+ * x^8+x^6+x^0
+ */
+#define CRC32C_POLY_LE 0x82F63B78
+
+#endif /* _LINUX_CRC32_POLY_H */
diff --git a/lib/crc32.c b/lib/crc32.c
index 2ef20fe84b69..341c54cb4edf 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -27,6 +27,7 @@
 /* see: Documentation/crc32.txt for a description of algorithms */
 
 #include <linux/crc32.h>
+#include <linux/crc32poly.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/sched.h>
diff --git a/lib/crc32defs.h b/lib/crc32defs.h
index cb275a28a750..0c8fb5923e7e 100644
--- a/lib/crc32defs.h
+++ b/lib/crc32defs.h
@@ -1,18 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*
- * There are multiple 16-bit CRC polynomials in common use, but this is
- * *the* standard CRC-32 polynomial, first popularized by Ethernet.
- * x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x^1+x^0
- */
-#define CRCPOLY_LE 0xedb88320
-#define CRCPOLY_BE 0x04c11db7
-
-/*
- * This is the CRC32c polynomial, as outlined by Castagnoli.
- * x^32+x^28+x^27+x^26+x^25+x^23+x^22+x^20+x^19+x^18+x^14+x^13+x^11+x^10+x^9+
- * x^8+x^6+x^0
- */
-#define CRC32C_POLY_LE 0x82F63B78
 
 /* Try to choose an implementation variant via Kconfig */
 #ifdef CONFIG_CRC32_SLICEBY8
diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
index 8f26660ea10a..34c3bc826f45 100644
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
+#include "../include/linux/crc32poly.h"
 #include "../include/generated/autoconf.h"
 #include "crc32defs.h"
 #include <inttypes.h>
-- 
2.14.1
