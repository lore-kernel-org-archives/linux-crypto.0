From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH] drivers/crypto/nx: Add CRC and validation support for nx842
Date: Sat, 19 Sep 2015 17:02:42 -0700
Message-ID: <1442707362.6178.11.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	hbabu@us.ibm.com
To: herbert@gondor.apana.org.au, davem@davemloft.net, ddstreet@ieee.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:53224 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbbITADh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Sep 2015 20:03:37 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
	Sat, 19 Sep 2015 20:03:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, 

This patch allows nx842 coprocessor to add CRC for compression and
check the computed CRC value for uncompression. Please let me know 
if you have any comments.

Thanks
Haren

commit d0b34d2e3ed41e7ec2afdbd654f0dd7716e4d4c0
Author: Haren Myneni <haren@us.ibm.com>
Date:   Sat Sep 12 01:20:51 2015 -0700

    crypto/nx842: Add CRC and validation support
    
    This patch adds CRC generation and validation support for nx-842. 
    Add CRC flag so that nx842 coprocessor includes CRC during 
    compression and validates during uncompression. 
    
    Signed-off-by: Haren Myneni <haren@us.ibm.com>

diff --git a/drivers/crypto/nx/nx-842-powernv.c
b/drivers/crypto/nx/nx-842-powernv.c
index 3750e13..9ef51fa 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -491,7 +491,7 @@ static int nx842_powernv_compress(const unsigned
char *in, unsigned int inlen,
 				  void *wmem)
 {
 	return nx842_powernv_function(in, inlen, out, outlenp,
-				      wmem, CCW_FC_842_COMP_NOCRC);
+				      wmem, CCW_FC_842_COMP_CRC);
 }
 
 /**
@@ -519,7 +519,7 @@ static int nx842_powernv_decompress(const unsigned
char *in, unsigned int inlen,
 				    void *wmem)
 {
 	return nx842_powernv_function(in, inlen, out, outlenp,
-				      wmem, CCW_FC_842_DECOMP_NOCRC);
+				      wmem, CCW_FC_842_DECOMP_CRC);
 }
 
 static int __init nx842_powernv_probe(struct device_node *dn)
diff --git a/drivers/crypto/nx/nx-842-pseries.c
b/drivers/crypto/nx/nx-842-pseries.c
index f4cbde0..5532dab 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -234,6 +234,9 @@ static int nx842_validate_result(struct device *dev,
 		dev_dbg(dev, "%s: Out of space in output buffer\n",
 					__func__);
 		return -ENOSPC;
+	case 65: /* Calculated CRC doesn't match the passed value */
+		dev_dbg(dev, "%s: CRC mismatch for decompression\n", __func__);
+		return -EINVAL;
 	case 66: /* Input data contains an illegal template field */
 	case 67: /* Template indicates data past the end of the input stream
*/
 		dev_dbg(dev, "%s: Bad data for decompression (code:%d)\n",
@@ -324,7 +327,7 @@ static int nx842_pseries_compress(const unsigned
char *in, unsigned int inlen,
 	slout.entries = (struct nx842_slentry *)workmem->slout;
 
 	/* Init operation */
-	op.flags = NX842_OP_COMPRESS;
+	op.flags = NX842_OP_COMPRESS_CRC;
 	csbcpb = &workmem->csbcpb;
 	memset(csbcpb, 0, sizeof(*csbcpb));
 	op.csbcpb = nx842_get_pa(csbcpb);
@@ -457,7 +460,7 @@ static int nx842_pseries_decompress(const unsigned
char *in, unsigned int inlen,
 	slout.entries = (struct nx842_slentry *)workmem->slout;
 
 	/* Init operation */
-	op.flags = NX842_OP_DECOMPRESS;
+	op.flags = NX842_OP_DECOMPRESS_CRC;
 	csbcpb = &workmem->csbcpb;
 	memset(csbcpb, 0, sizeof(*csbcpb));
 	op.csbcpb = nx842_get_pa(csbcpb);
