From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 2/6] lib/crc: Use consistent naming for CRC-32 polynomials
Date: Tue, 17 Jul 2018 18:05:37 +0200
Message-ID: <20180717160541.3843-3-krzk@kernel.org>
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

Header was defining CRCPOLY_LE/BE and CRC32C_POLY_LE but in fact all of
them are CRC-32 polynomials so use consistent naming.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 include/linux/crc32poly.h |  4 ++--
 lib/crc32.c               | 10 +++++-----
 lib/gen_crc32table.c      |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/crc32poly.h b/include/linux/crc32poly.h
index 7ad5aa92d3c7..62c4b7790a28 100644
--- a/include/linux/crc32poly.h
+++ b/include/linux/crc32poly.h
@@ -7,8 +7,8 @@
  * *the* standard CRC-32 polynomial, first popularized by Ethernet.
  * x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x^1+x^0
  */
-#define CRCPOLY_LE 0xedb88320
-#define CRCPOLY_BE 0x04c11db7
+#define CRC32_POLY_LE 0xedb88320
+#define CRC32_POLY_BE 0x04c11db7
 
 /*
  * This is the CRC32c polynomial, as outlined by Castagnoli.
diff --git a/lib/crc32.c b/lib/crc32.c
index 341c54cb4edf..a6c9afafc8c8 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -185,7 +185,7 @@ static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
 #if CRC_LE_BITS == 1
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
-	return crc32_le_generic(crc, p, len, NULL, CRCPOLY_LE);
+	return crc32_le_generic(crc, p, len, NULL, CRC32_POLY_LE);
 }
 u32 __pure __crc32c_le(u32 crc, unsigned char const *p, size_t len)
 {
@@ -195,7 +195,7 @@ u32 __pure __crc32c_le(u32 crc, unsigned char const *p, size_t len)
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len,
-			(const u32 (*)[256])crc32table_le, CRCPOLY_LE);
+			(const u32 (*)[256])crc32table_le, CRC32_POLY_LE);
 }
 u32 __pure __crc32c_le(u32 crc, unsigned char const *p, size_t len)
 {
@@ -269,7 +269,7 @@ static u32 __attribute_const__ crc32_generic_shift(u32 crc, size_t len,
 
 u32 __attribute_const__ crc32_le_shift(u32 crc, size_t len)
 {
-	return crc32_generic_shift(crc, len, CRCPOLY_LE);
+	return crc32_generic_shift(crc, len, CRC32_POLY_LE);
 }
 
 u32 __attribute_const__ __crc32c_le_shift(u32 crc, size_t len)
@@ -331,13 +331,13 @@ static inline u32 __pure crc32_be_generic(u32 crc, unsigned char const *p,
 #if CRC_LE_BITS == 1
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
-	return crc32_be_generic(crc, p, len, NULL, CRCPOLY_BE);
+	return crc32_be_generic(crc, p, len, NULL, CRC32_POLY_BE);
 }
 #else
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_be_generic(crc, p, len,
-			(const u32 (*)[256])crc32table_be, CRCPOLY_BE);
+			(const u32 (*)[256])crc32table_be, CRC32_POLY_BE);
 }
 #endif
 EXPORT_SYMBOL(crc32_be);
diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
index 34c3bc826f45..f755b997b967 100644
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -58,7 +58,7 @@ static void crc32init_le_generic(const uint32_t polynomial,
 
 static void crc32init_le(void)
 {
-	crc32init_le_generic(CRCPOLY_LE, crc32table_le);
+	crc32init_le_generic(CRC32_POLY_LE, crc32table_le);
 }
 
 static void crc32cinit_le(void)
@@ -77,7 +77,7 @@ static void crc32init_be(void)
 	crc32table_be[0][0] = 0;
 
 	for (i = 1; i < BE_TABLE_SIZE; i <<= 1) {
-		crc = (crc << 1) ^ ((crc & 0x80000000) ? CRCPOLY_BE : 0);
+		crc = (crc << 1) ^ ((crc & 0x80000000) ? CRC32_POLY_BE : 0);
 		for (j = 0; j < i; j++)
 			crc32table_be[0][i + j] = crc ^ crc32table_be[0][j];
 	}
-- 
2.14.1
