From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 4/4] Documentation: crypto - add skcipher API documentation
Date: Tue, 16 Feb 2016 11:34:47 +0100
Message-ID: <1610789.guXSq8fhDn@positron.chronox.de>
References: <1550901.OUzcZboqul@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33890 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbcBPKfK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 05:35:10 -0500
In-Reply-To: <1550901.OUzcZboqul@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The crypto API received the skcipher API which is intended to replace
the ablkcipher and blkcipher API. This patch adds the skcipher API
documentation to the DocBook, updates the code sample (including
removing the blkcipher example) replaces the references to ablkcipher
and blkcipher with skcipher.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/DocBook/crypto-API.tmpl | 204 ++++++++++++----------------------
 1 file changed, 74 insertions(+), 130 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index 50efc5a..db82f19 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -348,10 +348,7 @@
       <para>type:
        <itemizedlist>
         <listitem>
-         <para>blkcipher for synchronous block ciphers</para>
-        </listitem>
-        <listitem>
-         <para>ablkcipher for asynchronous block ciphers</para>
+         <para>skcipher for symmetric key ciphers</para>
         </listitem>
         <listitem>
          <para>cipher for single block ciphers that may be used with
@@ -600,7 +597,7 @@ kernel crypto API                                |   IPSEC Layer
       v                   v
 +-----------+       +-----------+
 |           |       |           |
-| ablkcipher|       |   ahash   |
+|  skcipher |       |   ahash   |
 |   (ctr)   | ---+  |  (ghash)  |
 +-----------+    |  +-----------+
                  |
@@ -661,7 +658,7 @@ kernel crypto API                                |   IPSEC Layer
 
       <listitem>
        <para>
-        The GCM AEAD cipher type implementation now invokes the ABLKCIPHER API
+        The GCM AEAD cipher type implementation now invokes the SKCIPHER API
         with the instantiated CTR(AES) cipher handle.
        </para>
 
@@ -672,7 +669,7 @@ kernel crypto API                                |   IPSEC Layer
        </para>
 
        <para>
-        That means that the ABLKCIPHER implementation of CTR(AES) only
+        That means that the SKCIPHER implementation of CTR(AES) only
         implements the CTR block chaining mode. After performing the block
         chaining operation, the CIPHER implementation of AES is invoked.
        </para>
@@ -680,7 +677,7 @@ kernel crypto API                                |   IPSEC Layer
 
       <listitem>
        <para>
-        The ABLKCIPHER of CTR(AES) now invokes the CIPHER API with the AES
+        The SKCIPHER of CTR(AES) now invokes the CIPHER API with the AES
         cipher handle to encrypt one block.
        </para>
       </listitem>
@@ -709,7 +706,7 @@ kernel crypto API                                |   IPSEC Layer
      <para>
       For example, CBC(AES) is implemented with cbc.c, and aes-generic.c. The
       ASCII art picture above applies as well with the difference that only
-      step (4) is used and the ABLKCIPHER block chaining mode is CBC.
+      step (4) is used and the SKCIPHER block chaining mode is CBC.
      </para>
     </sect2>
 
@@ -907,15 +904,14 @@ kernel crypto API            |       Caller
     </sect2>
    </sect1>
 
-   <sect1><title>Multi-Block Ciphers [BLKCIPHER] [ABLKCIPHER]</title>
+   <sect1><title>Multi-Block Ciphers</title>
     <para>
      Example of transformations: cbc(aes), ecb(arc4), ...
     </para>
 
     <para>
      This section describes the multi-block cipher transformation
-     implementations for both synchronous [BLKCIPHER] and
-     asynchronous [ABLKCIPHER] case. The multi-block ciphers are
+     implementations. The multi-block ciphers are
      used for transformations which operate on scatterlists of
      data supplied to the transformation functions. They output
      the result into a scatterlist of data as well.
@@ -924,16 +920,15 @@ kernel crypto API            |       Caller
     <sect2><title>Registration Specifics</title>
 
      <para>
-      The registration of [BLKCIPHER] or [ABLKCIPHER] algorithms
+      The registration of multi-block cipher algorithms
       is one of the most standard procedures throughout the crypto API.
      </para>
 
      <para>
       Note, if a cipher implementation requires a proper alignment
       of data, the caller should use the functions of
-      crypto_blkcipher_alignmask() or crypto_ablkcipher_alignmask()
-      respectively to identify a memory alignment mask. The kernel
-      crypto API is able to process requests that are unaligned.
+      crypto_skcipher_alignmask() to identify a memory alignment mask.
+      The kernel crypto API is able to process requests that are unaligned.
       This implies, however, additional overhead as the kernel
       crypto API needs to perform the realignment of the data which
       may imply moving of data.
@@ -948,14 +943,13 @@ kernel crypto API            |       Caller
 
      <para>
       Please refer to the single block cipher description for schematics
-      of the block cipher usage. The usage patterns are exactly the same
-      for [ABLKCIPHER] and [BLKCIPHER] as they are for plain [CIPHER].
+      of the block cipher usage.
      </para>
     </sect2>
 
     <sect2><title>Specifics Of Asynchronous Multi-Block Cipher</title>
      <para>
-      There are a couple of specifics to the [ABLKCIPHER] interface.
+      There are a couple of specifics to the asynchronous interface.
      </para>
 
      <para>
@@ -1695,7 +1689,28 @@ read(opfd, out, outlen);
 !Finclude/linux/crypto.h cipher_alg
 !Finclude/crypto/rng.h rng_alg
    </sect1>
-   <sect1><title>Asynchronous Block Cipher API</title>
+   <sect1><title>Symmetric Key Cipher API</title>
+!Pinclude/crypto/skcipher.h Symmetric Key Cipher API
+!Finclude/crypto/skcipher.h crypto_alloc_skcipher
+!Finclude/crypto/skcipher.h crypto_free_skcipher
+!Finclude/crypto/skcipher.h crypto_has_skcipher
+!Finclude/crypto/skcipher.h crypto_skcipher_ivsize
+!Finclude/crypto/skcipher.h crypto_skcipher_blocksize
+!Finclude/crypto/skcipher.h crypto_skcipher_setkey
+!Finclude/crypto/skcipher.h crypto_skcipher_reqtfm
+!Finclude/crypto/skcipher.h crypto_skcipher_encrypt
+!Finclude/crypto/skcipher.h crypto_skcipher_decrypt
+   </sect1>
+   <sect1><title>Symmetric Key Cipher Request Handle</title>
+!Pinclude/crypto/skcipher.h Symmetric Key Cipher Request Handle
+!Finclude/crypto/skcipher.h crypto_skcipher_reqsize
+!Finclude/crypto/skcipher.h skcipher_request_set_tfm
+!Finclude/crypto/skcipher.h skcipher_request_alloc
+!Finclude/crypto/skcipher.h skcipher_request_free
+!Finclude/crypto/skcipher.h skcipher_request_set_callback
+!Finclude/crypto/skcipher.h skcipher_request_set_crypt
+   </sect1>
+   <sect1><title>Asynchronous Block Cipher API - Deprecated</title>
 !Pinclude/linux/crypto.h Asynchronous Block Cipher API
 !Finclude/linux/crypto.h crypto_alloc_ablkcipher
 !Finclude/linux/crypto.h crypto_free_ablkcipher
@@ -1707,7 +1722,7 @@ read(opfd, out, outlen);
 !Finclude/linux/crypto.h crypto_ablkcipher_encrypt
 !Finclude/linux/crypto.h crypto_ablkcipher_decrypt
    </sect1>
-   <sect1><title>Asynchronous Cipher Request Handle</title>
+   <sect1><title>Asynchronous Cipher Request Handle - Deprecated</title>
 !Pinclude/linux/crypto.h Asynchronous Cipher Request Handle
 !Finclude/linux/crypto.h crypto_ablkcipher_reqsize
 !Finclude/linux/crypto.h ablkcipher_request_set_tfm
@@ -1738,7 +1753,7 @@ read(opfd, out, outlen);
 !Finclude/crypto/aead.h aead_request_set_crypt
 !Finclude/crypto/aead.h aead_request_set_ad
    </sect1>
-   <sect1><title>Synchronous Block Cipher API</title>
+   <sect1><title>Synchronous Block Cipher API - Deprecated</title>
 !Pinclude/linux/crypto.h Synchronous Block Cipher API
 !Finclude/linux/crypto.h crypto_alloc_blkcipher
 !Finclude/linux/crypto.h crypto_free_blkcipher
@@ -1843,7 +1858,7 @@ read(opfd, out, outlen);
   </chapter>
 
   <chapter id="Code"><title>Code Examples</title>
-   <sect1><title>Code Example For Asynchronous Block Cipher Operation</title>
+   <sect1><title>Code Example For Symmetric Key Cipher Operation</title>
     <programlisting>
 
 struct tcrypt_result {
@@ -1852,15 +1867,15 @@ struct tcrypt_result {
 };
 
 /* tie all data structures together */
-struct ablkcipher_def {
+struct skcipher_def {
 	struct scatterlist sg;
-	struct crypto_ablkcipher *tfm;
-	struct ablkcipher_request *req;
+	struct crypto_skcipher *tfm;
+	struct skcipher_request *req;
 	struct tcrypt_result result;
 };
 
 /* Callback function */
-static void test_ablkcipher_cb(struct crypto_async_request *req, int error)
+static void test_skcipher_cb(struct crypto_async_request *req, int error)
 {
 	struct tcrypt_result *result = req-&gt;data;
 
@@ -1872,15 +1887,15 @@ static void test_ablkcipher_cb(struct crypto_async_request *req, int error)
 }
 
 /* Perform cipher operation */
-static unsigned int test_ablkcipher_encdec(struct ablkcipher_def *ablk,
-					   int enc)
+static unsigned int test_skcipher_encdec(struct skcipher_def *sk,
+					 int enc)
 {
 	int rc = 0;
 
 	if (enc)
-		rc = crypto_ablkcipher_encrypt(ablk-&gt;req);
+		rc = crypto_skcipher_encrypt(sk-&gt;req);
 	else
-		rc = crypto_ablkcipher_decrypt(ablk-&gt;req);
+		rc = crypto_skcipher_decrypt(sk-&gt;req);
 
 	switch (rc) {
 	case 0:
@@ -1888,52 +1903,52 @@ static unsigned int test_ablkcipher_encdec(struct ablkcipher_def *ablk,
 	case -EINPROGRESS:
 	case -EBUSY:
 		rc = wait_for_completion_interruptible(
-			&amp;ablk-&gt;result.completion);
-		if (!rc &amp;&amp; !ablk-&gt;result.err) {
-			reinit_completion(&amp;ablk-&gt;result.completion);
+			&amp;sk-&gt;result.completion);
+		if (!rc &amp;&amp; !sk-&gt;result.err) {
+			reinit_completion(&amp;sk-&gt;result.completion);
 			break;
 		}
 	default:
-		pr_info("ablkcipher encrypt returned with %d result %d\n",
-		       rc, ablk-&gt;result.err);
+		pr_info("skcipher encrypt returned with %d result %d\n",
+			rc, sk-&gt;result.err);
 		break;
 	}
-	init_completion(&amp;ablk-&gt;result.completion);
+	init_completion(&amp;sk-&gt;result.completion);
 
 	return rc;
 }
 
 /* Initialize and trigger cipher operation */
-static int test_ablkcipher(void)
+static int test_skcipher(void)
 {
-	struct ablkcipher_def ablk;
-	struct crypto_ablkcipher *ablkcipher = NULL;
-	struct ablkcipher_request *req = NULL;
+	struct skcipher_def sk;
+	struct crypto_skcipher *skcipher = NULL;
+	struct skcipher_request *req = NULL;
 	char *scratchpad = NULL;
 	char *ivdata = NULL;
 	unsigned char key[32];
 	int ret = -EFAULT;
 
-	ablkcipher = crypto_alloc_ablkcipher("cbc-aes-aesni", 0, 0);
-	if (IS_ERR(ablkcipher)) {
-		pr_info("could not allocate ablkcipher handle\n");
-		return PTR_ERR(ablkcipher);
+	skcipher = crypto_alloc_skcipher("cbc-aes-aesni", 0, 0);
+	if (IS_ERR(skcipher)) {
+		pr_info("could not allocate skcipher handle\n");
+		return PTR_ERR(skcipher);
 	}
 
-	req = ablkcipher_request_alloc(ablkcipher, GFP_KERNEL);
+	req = skcipher_request_alloc(skcipher, GFP_KERNEL);
 	if (IS_ERR(req)) {
 		pr_info("could not allocate request queue\n");
 		ret = PTR_ERR(req);
 		goto out;
 	}
 
-	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					test_ablkcipher_cb,
-					&amp;ablk.result);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      test_skcipher_cb,
+				      &amp;sk.result);
 
 	/* AES 256 with random key */
 	get_random_bytes(&amp;key, 32);
-	if (crypto_ablkcipher_setkey(ablkcipher, key, 32)) {
+	if (crypto_skcipher_setkey(skcipher, key, 32)) {
 		pr_info("key could not be set\n");
 		ret = -EAGAIN;
 		goto out;
@@ -1955,26 +1970,26 @@ static int test_ablkcipher(void)
 	}
 	get_random_bytes(scratchpad, 16);
 
-	ablk.tfm = ablkcipher;
-	ablk.req = req;
+	sk.tfm = skcipher;
+	sk.req = req;
 
 	/* We encrypt one block */
-	sg_init_one(&amp;ablk.sg, scratchpad, 16);
-	ablkcipher_request_set_crypt(req, &amp;ablk.sg, &amp;ablk.sg, 16, ivdata);
-	init_completion(&amp;ablk.result.completion);
+	sg_init_one(&amp;sk.sg, scratchpad, 16);
+	skcipher_request_set_crypt(req, &amp;sk.sg, &amp;sk.sg, 16, ivdata);
+	init_completion(&amp;sk.result.completion);
 
 	/* encrypt data */
-	ret = test_ablkcipher_encdec(&amp;ablk, 1);
+	ret = test_skcipher_encdec(&amp;sk, 1);
 	if (ret)
 		goto out;
 
 	pr_info("Encryption triggered successfully\n");
 
 out:
-	if (ablkcipher)
-		crypto_free_ablkcipher(ablkcipher);
+	if (skcipher)
+		crypto_free_skcipher(skcipher);
 	if (req)
-		ablkcipher_request_free(req);
+		skcipher_request_free(req);
 	if (ivdata)
 		kfree(ivdata);
 	if (scratchpad)
@@ -1984,77 +1999,6 @@ out:
     </programlisting>
    </sect1>
 
-   <sect1><title>Code Example For Synchronous Block Cipher Operation</title>
-    <programlisting>
-
-static int test_blkcipher(void)
-{
-	struct crypto_blkcipher *blkcipher = NULL;
-	char *cipher = "cbc(aes)";
-	// AES 128
-	charkey =
-"\x12\x34\x56\x78\x90\xab\xcd\xef\x12\x34\x56\x78\x90\xab\xcd\xef";
-	chariv =
-"\x12\x34\x56\x78\x90\xab\xcd\xef\x12\x34\x56\x78\x90\xab\xcd\xef";
-	unsigned int ivsize = 0;
-	char *scratchpad = NULL; // holds plaintext and ciphertext
-	struct scatterlist sg;
-	struct blkcipher_desc desc;
-	int ret = -EFAULT;
-
-	blkcipher = crypto_alloc_blkcipher(cipher, 0, 0);
-	if (IS_ERR(blkcipher)) {
-		printk("could not allocate blkcipher handle for %s\n", cipher);
-		return -PTR_ERR(blkcipher);
-	}
-
-	if (crypto_blkcipher_setkey(blkcipher, key, strlen(key))) {
-		printk("key could not be set\n");
-		ret = -EAGAIN;
-		goto out;
-	}
-
-	ivsize = crypto_blkcipher_ivsize(blkcipher);
-	if (ivsize) {
-		if (ivsize != strlen(iv))
-			printk("IV length differs from expected length\n");
-		crypto_blkcipher_set_iv(blkcipher, iv, ivsize);
-	}
-
-	scratchpad = kmalloc(crypto_blkcipher_blocksize(blkcipher), GFP_KERNEL);
-	if (!scratchpad) {
-		printk("could not allocate scratchpad for %s\n", cipher);
-		goto out;
-	}
-	/* get some random data that we want to encrypt */
-	get_random_bytes(scratchpad, crypto_blkcipher_blocksize(blkcipher));
-
-	desc.flags = 0;
-	desc.tfm = blkcipher;
-	sg_init_one(&amp;sg, scratchpad, crypto_blkcipher_blocksize(blkcipher));
-
-	/* encrypt data in place */
-	crypto_blkcipher_encrypt(&amp;desc, &amp;sg, &amp;sg,
-				 crypto_blkcipher_blocksize(blkcipher));
-
-	/* decrypt data in place
-	 * crypto_blkcipher_decrypt(&amp;desc, &amp;sg, &amp;sg,
-	 */			 crypto_blkcipher_blocksize(blkcipher));
-
-
-	printk("Cipher operation completed\n");
-	return 0;
-
-out:
-	if (blkcipher)
-		crypto_free_blkcipher(blkcipher);
-	if (scratchpad)
-		kzfree(scratchpad);
-	return ret;
-}
-    </programlisting>
-   </sect1>
-
    <sect1><title>Code Example For Use of Operational State Memory With SHASH</title>
     <programlisting>
 
-- 
2.5.0
