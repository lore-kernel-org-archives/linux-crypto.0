From: Patrick McHardy <kaber@trash.net>
Subject: [RFC, TCRYPT]: Catch cipher destination memory corruption
Date: Wed, 07 May 2008 10:14:54 +0200
Message-ID: <482164FE.4020208@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000602050602090102020903"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55708 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbYEGIP2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 04:15:28 -0400
Received: from [192.168.0.100] (unknown [78.42.204.165])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTP id 7AC6E948B6
	for <linux-crypto@vger.kernel.org>; Wed,  7 May 2008 10:15:27 +0200 (MEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000602050602090102020903
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds checks to tcrypt to catch destination buffer
corruption for cipher tests across pages, which was useful
while fixing corruption caused by the HIFN driver.

It works by always clearing xbuf before the cipher operation
and counts how many bytes beyond the end of each buffer pointed
to by a scatterlist entry are non-zero.

The byte count is unreliable, if enough bytes are corrupted
it might reach the beginning of a new destination area and
include it in the count. I don't think this is important to
handle 100% correct since it usually shouldn't happen anyway,
but if this is considered a problem I would simply remove
the byte count entirely and only check the first byte.



--------------000602050602090102020903
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit b50b099a28f8e970cfe54b38bfc317e213a1faa7
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 08:32:05 2008 +0200

    [TCRYPT]: Catch cipher destination memory corruption
    
    Check whether the destination buffer is written to beyond the last
    byte contained in the scatterlist.
    
    Also change IDX1 of the cross-page access offsets to a multiple of 4.
    This triggers a corruption in the HIFN driver and doesn't seem to
    negatively impact other testcases.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6beabc5..1aa443d 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -46,7 +46,7 @@
 /*
  * Indexes into the xbuf to simulate cross-page access.
  */
-#define IDX1		37
+#define IDX1		32
 #define IDX2		32400
 #define IDX3		1
 #define IDX4		8193
@@ -218,7 +218,7 @@ out:
 static void test_aead(char *algo, int enc, struct aead_testvec *template,
 		      unsigned int tcount)
 {
-	unsigned int ret, i, j, k, temp;
+	unsigned int ret, i, j, k, n, temp;
 	char *q;
 	struct crypto_aead *tfm;
 	char *key;
@@ -360,7 +360,6 @@ next_one:
 	}
 
 	printk(KERN_INFO "\ntesting %s %s across pages (chunking)\n", algo, e);
-	memset(xbuf, 0, XBUFSIZE);
 	memset(axbuf, 0, XBUFSIZE);
 
 	for (i = 0, j = 0; i < tcount; i++) {
@@ -388,6 +387,7 @@ next_one:
 					goto out;
 			}
 
+			memset(xbuf, 0, XBUFSIZE);
 			sg_init_table(sg, template[i].np);
 			for (k = 0, temp = 0; k < template[i].np; k++) {
 				memcpy(&xbuf[IDX[k]],
@@ -459,6 +459,14 @@ next_one:
 					       0 : authsize)) ?
 				       "fail" : "pass");
 
+				for (n = 0; q[template[i].tap[k] + n]; n++)
+					;
+				if (n) {
+					printk("Result buffer corruption %u "
+					       "bytes:\n", n);
+					hexdump(&q[template[i].tap[k]], n);
+				}
+
 				temp += template[i].tap[k];
 				kunmap(sg_page(&sg[k]));
 			}
@@ -473,7 +481,7 @@ out:
 static void test_cipher(char *algo, int enc,
 			struct cipher_testvec *template, unsigned int tcount)
 {
-	unsigned int ret, i, j, k, temp;
+	unsigned int ret, i, j, k, n, temp;
 	char *q;
 	struct crypto_ablkcipher *tfm;
 	struct ablkcipher_request *req;
@@ -581,7 +589,6 @@ static void test_cipher(char *algo, int enc,
 	}
 
 	printk("\ntesting %s %s across pages (chunking)\n", algo, e);
-	memset(xbuf, 0, XBUFSIZE);
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
@@ -602,6 +609,7 @@ static void test_cipher(char *algo, int enc,
 			printk("test %u (%d bit key):\n",
 			j, template[i].klen * 8);
 
+			memset(xbuf, 0, XBUFSIZE);
 			crypto_ablkcipher_clear_flags(tfm, ~0);
 			if (template[i].wk)
 				crypto_ablkcipher_set_flags(
@@ -663,6 +671,14 @@ static void test_cipher(char *algo, int enc,
 					memcmp(q, template[i].result + temp,
 						template[i].tap[k]) ? "fail" :
 					"pass");
+
+				for (n = 0; q[template[i].tap[k] + n]; n++)
+					;
+				if (n) {
+					printk("Result buffer corruption %u "
+					       "bytes:\n", n);
+					hexdump(&q[template[i].tap[k]], n);
+				}
 				temp += template[i].tap[k];
 				kunmap(sg_page(&sg[k]));
 			}

--------------000602050602090102020903--
