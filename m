From: Denis Cheng <crquan@gmail.com>
Subject: [PATCH] [RESEND] crypto test: use print_hex_dump from <linux/kernel.h> instead
Date: Tue, 27 Nov 2007 01:28:15 +0800
Message-ID: <1196098095-8995-1-git-send-email-crquan@gmail.com>
References: <20071126143939.GB28022@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, dengxw@163.com,
	Randy Dunlap <randy.dunlap@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ro-out-1112.google.com ([72.14.202.178]:55193 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbXKZR2f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 12:28:35 -0500
Received: by ro-out-1112.google.com with SMTP id p4so1104830roc
        for <linux-crypto@vger.kernel.org>; Mon, 26 Nov 2007 09:28:34 -0800 (PST)
In-Reply-To: <20071126143939.GB28022@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

this patch is against cryptodev-2.6, and have passed scripts/checkpatch.pl

KERN_DEBUG is stripped out, this acts more like the original in tcrypto.c

and the last parameter "bool ascii" set to zero to disable ascii output,
this could keep it happy on Unicode terminals.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 crypto/tcrypt.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 24141fb..665aa87 100644
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
@@ -156,7 +148,9 @@ static void test_hash(char *algo, struct hash_testvec *template,
 			goto out;
 		}
 
-		hexdump(result, crypto_hash_digestsize(tfm));
+		print_hex_dump("", "", DUMP_PREFIX_OFFSET, 16, 1,
+				result, crypto_hash_digestsize(tfm), 0);
+
 		printk("%s\n",
 		       memcmp(result, hash_tv[i].digest,
 			      crypto_hash_digestsize(tfm)) ?
@@ -203,7 +197,9 @@ static void test_hash(char *algo, struct hash_testvec *template,
 				goto out;
 			}
 
-			hexdump(result, crypto_hash_digestsize(tfm));
+			print_hex_dump("", "", DUMP_PREFIX_OFFSET,
+					16, 1,
+					result, crypto_hash_digestsize(tfm), 0);
 			printk("%s\n",
 			       memcmp(result, hash_tv[i].digest,
 				      crypto_hash_digestsize(tfm)) ?
@@ -319,7 +315,9 @@ static void test_cipher(char *algo, int enc,
 			}
 
 			q = kmap(sg_page(&sg[0])) + sg[0].offset;
-			hexdump(q, cipher_tv[i].rlen);
+			print_hex_dump("", "", DUMP_PREFIX_OFFSET,
+					16, 1,
+					q, cipher_tv[i].rlen, 0);
 
 			printk("%s\n",
 			       memcmp(q, cipher_tv[i].result,
@@ -393,7 +391,9 @@ static void test_cipher(char *algo, int enc,
 			for (k = 0; k < cipher_tv[i].np; k++) {
 				printk("page %u\n", k);
 				q = kmap(sg_page(&sg[k])) + sg[k].offset;
-				hexdump(q, cipher_tv[i].tap[k]);
+				print_hex_dump("", "", DUMP_PREFIX_OFFSET,
+						16, 1,
+						q, cipher_tv[i].tap[k], 0);
 				printk("%s\n",
 					memcmp(q, cipher_tv[i].result + temp,
 						cipher_tv[i].tap[k]) ? "fail" :
@@ -839,7 +839,8 @@ static void test_deflate(void)
 			printk("fail: ret=%d\n", ret);
 			continue;
 		}
-		hexdump(result, dlen);
+		print_hex_dump("", "", DUMP_PREFIX_OFFSET, 16, 1,
+				result, dlen, 0);
 		printk("%s (ratio %d:%d)\n",
 		       memcmp(result, tv[i].output, dlen) ? "fail" : "pass",
 		       ilen, dlen);
@@ -870,7 +871,8 @@ static void test_deflate(void)
 			printk("fail: ret=%d\n", ret);
 			continue;
 		}
-		hexdump(result, dlen);
+		print_hex_dump("", "", DUMP_PREFIX_OFFSET, 16, 1,
+				result, dlen, 0);
 		printk("%s (ratio %d:%d)\n",
 		       memcmp(result, tv[i].output, dlen) ? "fail" : "pass",
 		       ilen, dlen);
-- 
1.5.3.4
