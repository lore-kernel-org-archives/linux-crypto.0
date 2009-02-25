From: Frank Seidel <fseidel@suse.de>
Subject: [PATCH][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 14:48:19 +0100
Message-ID: <49A54C23.8090209@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
	Frank Seidel <fseidel@suse.de>, akpm@linux-foundation.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
	lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com
To: linux kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZBYNsY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 08:48:24 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Frank Seidel <frank@f-seidel.de>

Applying kernel janitors todos (printk calls need KERN_*
constants on linebeginnings, reduce stack footprint where
possible) to tcrypts test_hash_speed (where stacks
memory footprint was very high (on i386 1184 bytes to
292 now).

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 crypto/tcrypt.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -396,26 +396,34 @@ static void test_hash_speed(const char *
 	struct scatterlist sg[TVMEMSIZE];
 	struct crypto_hash *tfm;
 	struct hash_desc desc;
-	char output[1024];
+	char *output;
+	size_t output_size = 1024;
 	int i;
 	int ret;
 
-	printk("\ntesting speed of %s\n", algo);
+	printk(KERN_INFO "\ntesting speed of %s\n", algo);
+
+	output = kmalloc(output_size * sizeof(*output), GFP_KERNEL);
+	if (!output) {
+		printk(KERN_ERR "tcrypt: failed to allocate outputbuffer\n");
+		return;
+	}
 
 	tfm = crypto_alloc_hash(algo, 0, CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm)) {
-		printk("failed to load transform for %s: %ld\n", algo,
+		printk(KERN_ERR "failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
+		kfree(output);
 		return;
 	}
 
 	desc.tfm = tfm;
 	desc.flags = 0;
 
-	if (crypto_hash_digestsize(tfm) > sizeof(output)) {
-		printk("digestsize(%u) > outputbuffer(%zu)\n",
-		       crypto_hash_digestsize(tfm), sizeof(output));
+	if (crypto_hash_digestsize(tfm) > output_size) {
+		printk(KERN_ERR "digestsize(%u) > outputbuffer(%zu)\n",
+		       crypto_hash_digestsize(tfm), output_size);
 		goto out;
 	}
 
@@ -427,12 +435,14 @@ static void test_hash_speed(const char *
 
 	for (i = 0; speed[i].blen != 0; i++) {
 		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
-			printk("template (%u) too big for tvmem (%lu)\n",
+			printk(KERN_ERR
+			       "template (%u) too big for tvmem (%lu)\n",
 			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
 			goto out;
 		}
 
-		printk("test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
+		printk(KERN_INFO "test%3u "
+		       "(%5u byte blocks,%5u bytes per update,%4u updates): ",
 		       i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
 
 		if (sec)
@@ -443,13 +453,14 @@ static void test_hash_speed(const char *
 					       speed[i].plen, output);
 
 		if (ret) {
-			printk("hashing failed ret=%d\n", ret);
+			printk(KERN_ERR "hashing failed ret=%d\n", ret);
 			break;
 		}
 	}
 
 out:
 	crypto_free_hash(tfm);
+	kfree(output);
 }
 
 static void test_available(void)
