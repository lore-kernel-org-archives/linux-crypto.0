From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH] crypto: tcrypt - set assoc in sg_init_aead()
Date: Tue, 14 Nov 2017 16:59:15 +0200
Message-ID: <20171114145915.13299-1-tudor.ambarus@microchip.com>
References: <75766914-fdc1-5fb9-a571-82f86bcbe928@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <robert.baronescu@nxp.com>,
        <horia.geanta@nxp.com>, Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:45670 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752360AbdKNO7Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Nov 2017 09:59:24 -0500
In-Reply-To: <75766914-fdc1-5fb9-a571-82f86bcbe928@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Results better code readability.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
Should be applied after:
    crypto: tcrypt - fix S/G table for test_aead_speed()

 crypto/tcrypt.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 3ced1ba..28b4882 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -185,7 +185,8 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
 }
 
 static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
-			unsigned int buflen)
+			 unsigned int buflen, const void *assoc,
+			 unsigned int aad_size)
 {
 	int np = (buflen + PAGE_SIZE - 1)/PAGE_SIZE;
 	int k, rem;
@@ -198,6 +199,9 @@ static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
 	}
 
 	sg_init_table(sg, np + 1);
+
+	sg_set_buf(&sg[0], assoc, aad_size);
+
 	if (rem)
 		np--;
 	for (k = 0; k < np; k++)
@@ -318,14 +322,12 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 				goto out;
 			}
 
-			sg_init_aead(sg, xbuf,
-				    *b_size + (enc ? 0 : authsize));
+			sg_init_aead(sg, xbuf, *b_size + (enc ? 0 : authsize),
+				     assoc, aad_size);
 
 			sg_init_aead(sgout, xoutbuf,
-				    *b_size + (enc ? authsize : 0));
-
-			sg_set_buf(&sg[0], assoc, aad_size);
-			sg_set_buf(&sgout[0], assoc, aad_size);
+				     *b_size + (enc ? authsize : 0), assoc,
+				     aad_size);
 
 			aead_request_set_crypt(req, sg, sgout,
 					       *b_size + (enc ? 0 : authsize),
-- 
2.9.4
