From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re:[PATCH] ixp4xx_crypto panic with fragmented packets in scatterlist
Date: Wed, 25 Feb 2009 16:35:40 +0100
Message-ID: <49A5654C.1080002@hiramoto.org>
References: <49A2E421.5050806@hiramoto.org> <49A3F3FA.1000801@hiramoto.org> <20090225090735.GA6283@elara.bln.innominate.local> <49A5110B.2050803@hiramoto.org> <20090225115407.GB6283@elara.bln.innominate.local> <49A55744.3010702@hiramoto.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040106000100030600070404"
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
To: Christian Hohnstaedt <chohnstaedt@innominate.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:56931 "EHLO
	spunkymail-a20.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751891AbZBYPfy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 10:35:54 -0500
In-Reply-To: <49A55744.3010702@hiramoto.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040106000100030600070404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The attached patch fixes my issue, but am not sure if it is correct or
will  cause problems else where.

--------------040106000100030600070404
Content-Type: text/plain;
 name="sg_chain.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_chain.patch"

diff -Naurp linux-2.6.28.7.a/arch/arm/include/asm/scatterlist.h linux-2.6.28.7.b/arch/arm/include/asm/scatterlist.h
--- linux-2.6.28.7.a/arch/arm/include/asm/scatterlist.h	2009-02-20 23:41:27.000000000 +0100
+++ linux-2.6.28.7.b/arch/arm/include/asm/scatterlist.h	2009-02-25 16:19:59.000000000 +0100
@@ -24,4 +24,6 @@ struct scatterlist {
 #define sg_dma_address(sg)      ((sg)->dma_address)
 #define sg_dma_len(sg)          ((sg)->length)
 
+#define ARCH_HAS_SG_CHAIN
+
 #endif /* _ASMARM_SCATTERLIST_H */
diff -Naurp linux-2.6.28.7.a/crypto/eseqiv.c linux-2.6.28.7.b/crypto/eseqiv.c
--- linux-2.6.28.7.a/crypto/eseqiv.c	2009-02-20 23:41:27.000000000 +0100
+++ linux-2.6.28.7.b/crypto/eseqiv.c	2009-02-25 16:17:09.000000000 +0100
@@ -17,7 +17,6 @@
 
 #include <crypto/internal/skcipher.h>
 #include <crypto/rng.h>
-#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -67,11 +66,11 @@ static void eseqiv_chain(struct scatterl
 {
 	if (chain) {
 		head->length += sg->length;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 
 	if (sg)
-		scatterwalk_sg_chain(head, 2, sg);
+		sg_chain(head, 2, sg);
 	else
 		sg_mark_end(head);
 }

--------------040106000100030600070404--
