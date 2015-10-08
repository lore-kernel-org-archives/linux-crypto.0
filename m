From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH V3] crypto/nx842: Add CRC and validation support
Date: Thu, 08 Oct 2015 13:45:51 -0700
Message-ID: <1444337151.10131.10.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	hbabu@us.ibm.com
To: herbert@gondor.apana.org.au, davem@davemloft.net, ddstreet@ieee.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:57743 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbbJHUqE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2015 16:46:04 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
	Thu, 8 Oct 2015 14:46:03 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This patch adds CRC generation and validation support for nx-842.
Add CRC flag so that nx842 coprocessor includes CRC during compression
and validates during decompression.

Also changes in 842 SW compression to append CRC value at the end
of template and checks during decompression.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
Changes in V2: 
 Added CRC and validation support in 842 SW compression/ decompression
Changes in v3:
 Whitespace format changes

 drivers/crypto/nx/nx-842-powernv.c |    4 ++--
 drivers/crypto/nx/nx-842-pseries.c |    8 ++++++--
 lib/842/842.h                      |    2 ++
 lib/842/842_compress.c             |   13 +++++++++++++
 lib/842/842_decompress.c           |   17 +++++++++++++++++
 5 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 3750e13..9ef51fa 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -491,7 +491,7 @@ static int nx842_powernv_compress(const unsigned char *in, unsigned int inlen,
 				  void *wmem)
 {
 	return nx842_powernv_function(in, inlen, out, outlenp,
-				      wmem, CCW_FC_842_COMP_NOCRC);
+				      wmem, CCW_FC_842_COMP_CRC);
 }
 
 /**
@@ -519,7 +519,7 @@ static int nx842_powernv_decompress(const unsigned char *in, unsigned int inlen,
 				    void *wmem)
 {
 	return nx842_powernv_function(in, inlen, out, outlenp,
-				      wmem, CCW_FC_842_DECOMP_NOCRC);
+				      wmem, CCW_FC_842_DECOMP_CRC);
 }
 
 static int __init nx842_powernv_probe(struct device_node *dn)
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index f4cbde0..cddc6d8 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -234,6 +234,10 @@ static int nx842_validate_result(struct device *dev,
 		dev_dbg(dev, "%s: Out of space in output buffer\n",
 					__func__);
 		return -ENOSPC;
+	case 65: /* Calculated CRC doesn't match the passed value */
+		dev_dbg(dev, "%s: CRC mismatch for decompression\n",
+					__func__);
+		return -EINVAL;
 	case 66: /* Input data contains an illegal template field */
 	case 67: /* Template indicates data past the end of the input stream */
 		dev_dbg(dev, "%s: Bad data for decompression (code:%d)\n",
@@ -324,7 +328,7 @@ static int nx842_pseries_compress(const unsigned char *in, unsigned int inlen,
 	slout.entries = (struct nx842_slentry *)workmem->slout;
 
 	/* Init operation */
-	op.flags = NX842_OP_COMPRESS;
+	op.flags = NX842_OP_COMPRESS_CRC;
 	csbcpb = &workmem->csbcpb;
 	memset(csbcpb, 0, sizeof(*csbcpb));
 	op.csbcpb = nx842_get_pa(csbcpb);
@@ -457,7 +461,7 @@ static int nx842_pseries_decompress(const unsigned char *in, unsigned int inlen,
 	slout.entries = (struct nx842_slentry *)workmem->slout;
 
 	/* Init operation */
-	op.flags = NX842_OP_DECOMPRESS;
+	op.flags = NX842_OP_DECOMPRESS_CRC;
 	csbcpb = &workmem->csbcpb;
 	memset(csbcpb, 0, sizeof(*csbcpb));
 	op.csbcpb = nx842_get_pa(csbcpb);
diff --git a/lib/842/842.h b/lib/842/842.h
index 7c20003..e0a122b 100644
--- a/lib/842/842.h
+++ b/lib/842/842.h
@@ -76,6 +76,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/bitops.h>
+#include <linux/crc32.h>
 #include <asm/unaligned.h>
 
 #include <linux/sw842.h>
@@ -98,6 +99,7 @@
 #define I2_BITS		(8)
 #define I4_BITS		(9)
 #define I8_BITS		(8)
+#define CRC_BITS	(32)
 
 #define REPEAT_BITS_MAX		(0x3f)
 #define SHORT_DATA_BITS_MAX	(0x7)
diff --git a/lib/842/842_compress.c b/lib/842/842_compress.c
index 7ce6894..4051339 100644
--- a/lib/842/842_compress.c
+++ b/lib/842/842_compress.c
@@ -490,6 +490,7 @@ int sw842_compress(const u8 *in, unsigned int ilen,
 	int ret;
 	u64 last, next, pad, total;
 	u8 repeat_count = 0;
+	u32 crc;
 
 	BUILD_BUG_ON(sizeof(*p) > SW842_MEM_COMPRESS);
 
@@ -580,6 +581,18 @@ skip_comp:
 	if (ret)
 		return ret;
 
+	/*
+	 * crc(0:31) is appended to target data starting with the next
+	 * bit after End of stream template.
+	 * nx842 calculates CRC for data in big-endian format. So doing
+	 * same here so that sw842 decompression can be used for both
+	 * compressed data.
+	 */
+	crc = crc32_be(0, in, ilen);
+	ret = add_bits(p, crc, CRC_BITS);
+	if (ret)
+		return ret;
+
 	if (p->bit) {
 		p->out++;
 		p->olen--;
diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index 5446ff0..8881dad 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -285,6 +285,7 @@ int sw842_decompress(const u8 *in, unsigned int ilen,
 	struct sw842_param p;
 	int ret;
 	u64 op, rep, tmp, bytes, total;
+	u64 crc;
 
 	p.in = (u8 *)in;
 	p.bit = 0;
@@ -375,6 +376,22 @@ int sw842_decompress(const u8 *in, unsigned int ilen,
 		}
 	} while (op != OP_END);
 
+	/*
+	 * crc(0:31) is saved in compressed data starting with the
+	 * next bit after End of stream template.
+	 */
+	ret = next_bits(&p, &crc, CRC_BITS);
+	if (ret)
+		return ret;
+
+	/*
+	 * Validate CRC saved in compressed data.
+	 */
+	if (crc != (u64)crc32_be(0, out, total - p.olen)) {
+		pr_debug("CRC mismatch for decompression\n");
+		return -EINVAL;
+	}
+
 	if (unlikely((total - p.olen) > UINT_MAX))
 		return -ENOSPC;
 
-- 
1.7.0.4
