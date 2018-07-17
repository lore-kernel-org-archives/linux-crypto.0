From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6/6] lib: Use existing define with polynomial
Date: Tue, 17 Jul 2018 18:05:41 +0200
Message-ID: <20180717160541.3843-7-krzk@kernel.org>
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

Do not define again the polynomial but use header with existing define.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 lib/decompress_bunzip2.c | 3 ++-
 lib/xz/xz_crc32.c        | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 0234361b24b8..7c4932eed748 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -51,6 +51,7 @@
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
+#include <linux/crc32poly.h>
 
 #ifndef INT_MAX
 #define INT_MAX 0x7fffffff
@@ -654,7 +655,7 @@ static int INIT start_bunzip(struct bunzip_data **bdp, void *inbuf, long len,
 	for (i = 0; i < 256; i++) {
 		c = i << 24;
 		for (j = 8; j; j--)
-			c = c&0x80000000 ? (c << 1)^0x04c11db7 : (c << 1);
+			c = c&0x80000000 ? (c << 1)^(CRC32_POLY_BE) : (c << 1);
 		bd->crc32Table[i] = c;
 	}
 
diff --git a/lib/xz/xz_crc32.c b/lib/xz/xz_crc32.c
index 34532d14fd4c..25a5d87e2e4c 100644
--- a/lib/xz/xz_crc32.c
+++ b/lib/xz/xz_crc32.c
@@ -15,6 +15,7 @@
  * but they are bigger and use more memory for the lookup table.
  */
 
+#include <linux/crc32poly.h>
 #include "xz_private.h"
 
 /*
@@ -29,7 +30,7 @@ STATIC_RW_DATA uint32_t xz_crc32_table[256];
 
 XZ_EXTERN void xz_crc32_init(void)
 {
-	const uint32_t poly = 0xEDB88320;
+	const uint32_t poly = CRC32_POLY_LE;
 
 	uint32_t i;
 	uint32_t j;
-- 
2.14.1
