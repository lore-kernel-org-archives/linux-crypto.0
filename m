From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: sha1 - Add test vector to test partial block processing
Date: Thu, 17 Feb 2011 14:25:57 +1100
Message-ID: <20110217032557.GA12955@gondor.apana.org.au>
References: <20110207092817.GA16881@gondor.apana.org.au> <1297082827.11137.15.camel@bender>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48262 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1BQD0E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Feb 2011 22:26:04 -0500
Content-Disposition: inline
In-Reply-To: <1297082827.11137.15.camel@bender>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

I'm going to add this patch to prevent such issues in future.

commit bd1f2996b44a1c8bde76a6fecd10f36b6eb948d7
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Feb 17 14:24:45 2011 +1100

    crypto: sha1 - Add test vector to test partial block processing
    
    In light of the recent discovery of the bug with partial block
    processing on s390, we need best test coverage for that.  This
    patch adds a test vector for SHA1 that should catch such problems.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 834af7f..aa6dac0 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -451,8 +451,9 @@ static struct hash_testvec rmd320_tv_template[] = {
 
 /*
  * SHA1 test vectors  from from FIPS PUB 180-1
+ * Long vector from CAVS 5.0
  */
-#define SHA1_TEST_VECTORS	2
+#define SHA1_TEST_VECTORS	3
 
 static struct hash_testvec sha1_tv_template[] = {
 	{
@@ -467,6 +468,33 @@ static struct hash_testvec sha1_tv_template[] = {
 			  "\x4a\xa1\xf9\x51\x29\xe5\xe5\x46\x70\xf1",
 		.np	= 2,
 		.tap	= { 28, 28 }
+	}, {
+		.plaintext = "\xec\x29\x56\x12\x44\xed\xe7\x06"
+			     "\xb6\xeb\x30\xa1\xc3\x71\xd7\x44"
+			     "\x50\xa1\x05\xc3\xf9\x73\x5f\x7f"
+			     "\xa9\xfe\x38\xcf\x67\xf3\x04\xa5"
+			     "\x73\x6a\x10\x6e\x92\xe1\x71\x39"
+			     "\xa6\x81\x3b\x1c\x81\xa4\xf3\xd3"
+			     "\xfb\x95\x46\xab\x42\x96\xfa\x9f"
+			     "\x72\x28\x26\xc0\x66\x86\x9e\xda"
+			     "\xcd\x73\xb2\x54\x80\x35\x18\x58"
+			     "\x13\xe2\x26\x34\xa9\xda\x44\x00"
+			     "\x0d\x95\xa2\x81\xff\x9f\x26\x4e"
+			     "\xcc\xe0\xa9\x31\x22\x21\x62\xd0"
+			     "\x21\xcc\xa2\x8d\xb5\xf3\xc2\xaa"
+			     "\x24\x94\x5a\xb1\xe3\x1c\xb4\x13"
+			     "\xae\x29\x81\x0f\xd7\x94\xca\xd5"
+			     "\xdf\xaf\x29\xec\x43\xcb\x38\xd1"
+			     "\x98\xfe\x4a\xe1\xda\x23\x59\x78"
+			     "\x02\x21\x40\x5b\xd6\x71\x2a\x53"
+			     "\x05\xda\x4b\x1b\x73\x7f\xce\x7c"
+			     "\xd2\x1c\x0e\xb7\x72\x8d\x08\x23"
+			     "\x5a\x90\x11",
+		.psize	= 163,
+		.digest	= "\x97\x01\x11\xc4\xe7\x7b\xcc\x88\xcc\x20"
+			  "\x45\x9c\x02\xb6\x9b\x4a\xa8\xf5\x82\x17",
+		.np	= 4,
+		.tap	= { 63, 64, 31, 5 }
 	}
 };

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
