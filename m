From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: tcrpyt - Remove unnecessary kmap/kunmap calls
Date: Thu, 3 Jul 2008 15:02:17 +0800
Message-ID: <20080703070217.GA27224@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55243 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755884AbYGCHCV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2008 03:02:21 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KEIpe-0007hk-0L
	for <linux-crypto@vger.kernel.org>; Thu, 03 Jul 2008 17:02:18 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KEIpd-00075N-00
	for <linux-crypto@vger.kernel.org>; Thu, 03 Jul 2008 15:02:17 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

I'll add this patch to cryptodev-2.6.

crypto: tcrpyt - Remove unnecessary kmap/kunmap calls

Noticed by Neil Horman: we are doing unnecessary kmap/kunmap calls
on kmalloced memory.  This patch removes them.  For the purposes of
testing SG construction, the underlying crypto code already does plenty
of kmap/kunmap calls anyway.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 73f6f4a..7a6c939 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -23,7 +23,6 @@
 #include <linux/scatterlist.h>
 #include <linux/string.h>
 #include <linux/crypto.h>
-#include <linux/highmem.h>
 #include <linux/moduleparam.h>
 #include <linux/jiffies.h>
 #include <linux/timex.h>
@@ -31,7 +30,7 @@
 #include "tcrypt.h"
 
 /*
- * Need to kmalloc() memory for testing kmap().
+ * Need to kmalloc() memory for testing.
  */
 #define TVMEMSIZE	16384
 #define XBUFSIZE	32768
@@ -376,13 +375,12 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 				goto next_one;
 			}
 
-			q = kmap(sg_page(&sg[0])) + sg[0].offset;
+			q = input;
 			hexdump(q, template[i].rlen);
 
 			printk(KERN_INFO "enc/dec: %s\n",
 			       memcmp(q, template[i].result,
 				      template[i].rlen) ? "fail" : "pass");
-			kunmap(sg_page(&sg[0]));
 next_one:
 			if (!template[i].key)
 				kfree(key);
@@ -482,7 +480,7 @@ next_one:
 
 			for (k = 0, temp = 0; k < template[i].np; k++) {
 				printk(KERN_INFO "page %u\n", k);
-				q = kmap(sg_page(&sg[k])) + sg[k].offset;
+				q = &axbuf[IDX[k]];
 				hexdump(q, template[i].tap[k]);
 				printk(KERN_INFO "%s\n",
 				       memcmp(q, template[i].result + temp,
@@ -500,7 +498,6 @@ next_one:
 				}
 
 				temp += template[i].tap[k];
-				kunmap(sg_page(&sg[k]));
 			}
 		}
 	}
@@ -609,13 +606,12 @@ static void test_cipher(char *algo, int enc,
 				goto out;
 			}
 
-			q = kmap(sg_page(&sg[0])) + sg[0].offset;
+			q = data;
 			hexdump(q, template[i].rlen);
 
 			printk("%s\n",
 			       memcmp(q, template[i].result,
 				      template[i].rlen) ? "fail" : "pass");
-			kunmap(sg_page(&sg[0]));
 		}
 		kfree(data);
 	}
@@ -697,7 +693,7 @@ static void test_cipher(char *algo, int enc,
 			temp = 0;
 			for (k = 0; k < template[i].np; k++) {
 				printk("page %u\n", k);
-				q = kmap(sg_page(&sg[k])) + sg[k].offset;
+				q = &xbuf[IDX[k]];
 				hexdump(q, template[i].tap[k]);
 				printk("%s\n",
 					memcmp(q, template[i].result + temp,
@@ -712,7 +708,6 @@ static void test_cipher(char *algo, int enc,
 					hexdump(&q[template[i].tap[k]], n);
 				}
 				temp += template[i].tap[k];
-				kunmap(sg_page(&sg[k]));
 			}
 		}
 	}
