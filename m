From: Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH] libcrc32c: keep intermediate crc state in cpu order
Date: Thu, 08 Nov 2007 10:20:34 +0200
Message-ID: <4732C6D2.5000904@panasas.com>
References: <473186E9.5080300@panasas.com> <4731A5C5.3030109@panasas.com> <4731D387.5090901@panasas.com> <20071108001400O.tomof@acm.org> <4731DA0C.5090702@panasas.com> <4731FD41.1090704@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu,
	djiang@mvista.com, Herbert Xu <herbert@gondor.apana.org.au>
To: open-iscsi@googlegroups.com, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Clay Haapala <chaapala@cisco.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sa7.bezeqint.net ([192.115.104.21]:44560 "EHLO sa7.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbXKHIUn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Nov 2007 03:20:43 -0500
In-Reply-To: <4731FD41.1090704@panasas.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

crypto/crc32.c:chksum_final() is computing the digest as
*(__le32 *)out = ~cpu_to_le32(mctx->crc);
so the low-level crc32c_le routines should just keep
the crc in cpu order, otherwise it is getting swabbed
one too many times on big-endian machines.

Signed-off-by: Benny Halevy <bhalevy@fs1.bhalevy.com>
---
 lib/libcrc32c.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 802f11f..b5c3287 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -33,7 +33,6 @@
 #include <linux/crc32c.h>
 #include <linux/compiler.h>
 #include <linux/module.h>
-#include <asm/byteorder.h>
 
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
 MODULE_DESCRIPTION("CRC32c (Castagnoli) calculations");
@@ -161,15 +160,13 @@ static const u32 crc32c_table[256] = {
  */
 
 u32 __pure
-crc32c_le(u32 seed, unsigned char const *data, size_t length)
+crc32c_le(u32 crc, unsigned char const *data, size_t length)
 {
-	u32 crc = __cpu_to_le32(seed);
-	
 	while (length--)
 		crc =
 		    crc32c_table[(crc ^ *data++) & 0xFFL] ^ (crc >> 8);
 
-	return __le32_to_cpu(crc);
+	return crc;
 }
 
 #endif	/* CRC_LE_BITS == 8 */
-- 
1.5.3.3
