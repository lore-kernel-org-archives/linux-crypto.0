From: Denis Cheng <crquan@gmail.com>
Subject: [PATCH 1/2] crypto test: use print_hex_dump from <linux/kernel.h>
Date: Mon, 26 Nov 2007 15:13:02 +0800
Message-ID: <1196061182-6368-1-git-send-email-crquan@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:42445 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbXKZHLU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 02:11:20 -0500
Received: by rv-out-0910.google.com with SMTP id k20so442054rvb
        for <linux-crypto@vger.kernel.org>; Sun, 25 Nov 2007 23:11:19 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

these utilities implemented in lib/hexdump.c are more handy, please use this.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 crypto/tcrypt.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 24141fb..8766023 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -81,14 +81,6 @@ static char *check[] = {
 	"camellia", "seed", NULL
 };
 
-static void hexdump(unsigned char *buf, unsigned int len)
-{
-	while (len--)
-		printk("%02x", *buf++);
-
-	printk("\n");
-}
-
 static void tcrypt_complete(struct crypto_async_request *req, int err)
 {
 	struct tcrypt_result *res = req->data;
@@ -156,7 +148,8 @@ static void test_hash(char *algo, struct hash_testvec *template,
 			goto out;
 		}
 
-		hexdump(result, crypto_hash_digestsize(tfm));
+		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, result, crypto_hash_digestsize(tfm), 1);
+
 		printk("%s\n",
 		       memcmp(result, hash_tv[i].digest,
 			      crypto_hash_digestsize(tfm)) ?
@@ -203,7 +196,7 @@ static void test_hash(char *algo, struct hash_testvec *template,
 				goto out;
 			}
 
-			hexdump(result, crypto_hash_digestsize(tfm));
+			print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, result, crypto_hash_digestsize(tfm), 1);
 			printk("%s\n",
 			       memcmp(result, hash_tv[i].digest,
 				      crypto_hash_digestsize(tfm)) ?
@@ -319,7 +312,7 @@ static void test_cipher(char *algo, int enc,
 			}
 
 			q = kmap(sg_page(&sg[0])) + sg[0].offset;
-			hexdump(q, cipher_tv[i].rlen);
+			print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, q, cipher_tv[i].rlen, 1);
 
 			printk("%s\n",
 			       memcmp(q, cipher_tv[i].result,
@@ -393,7 +386,7 @@ static void test_cipher(char *algo, int enc,
 			for (k = 0; k < cipher_tv[i].np; k++) {
 				printk("page %u\n", k);
 				q = kmap(sg_page(&sg[k])) + sg[k].offset;
-				hexdump(q, cipher_tv[i].tap[k]);
+				print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, q, cipher_tv[i].tap[k], 1);
 				printk("%s\n",
 					memcmp(q, cipher_tv[i].result + temp,
 						cipher_tv[i].tap[k]) ? "fail" :
@@ -839,7 +832,7 @@ static void test_deflate(void)
 			printk("fail: ret=%d\n", ret);
 			continue;
 		}
-		hexdump(result, dlen);
+		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, result, dlen, 1);
 		printk("%s (ratio %d:%d)\n",
 		       memcmp(result, tv[i].output, dlen) ? "fail" : "pass",
 		       ilen, dlen);
@@ -870,7 +863,7 @@ static void test_deflate(void)
 			printk("fail: ret=%d\n", ret);
 			continue;
 		}
-		hexdump(result, dlen);
+		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, result, dlen, 1);
 		printk("%s (ratio %d:%d)\n",
 		       memcmp(result, tv[i].output, dlen) ? "fail" : "pass",
 		       ilen, dlen);
-- 
1.5.3.5
