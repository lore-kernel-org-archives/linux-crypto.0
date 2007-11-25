From: Mikko Herranen <mikko.herranen@cs.helsinki.fi>
Subject: [PATCH 1/2] Add GCM/GMAC support to cryptoapi
Date: Sun, 25 Nov 2007 16:25:45 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0711251624530.3663@antarct>
References: <Pine.LNX.4.64.0711251601100.3663@antarct>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:64627 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbXKYO0W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Nov 2007 09:26:22 -0500
In-Reply-To: <Pine.LNX.4.64.0711251601100.3663@antarct>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add AEAD support to tcrypt, needed by GCM.

Signed-off-by: Mikko Herranen <mh1@iki.fi>
Reviewed-by: Mika Kukkonen <mika.kukkonen@nsn.com>
---
 crypto/tcrypt.c |  258 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 crypto/tcrypt.h |   22 +++++
 2 files changed, 271 insertions(+), 9 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index b8cb1d1..b343d81 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -6,12 +6,14 @@
  *
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
+ * Copyright (c) 2007 Nokia Siemens Networks
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
+ * 2007-11-13 Added AEAD support
  * 2007-11-06 Added SHA-224 and SHA-224-HMAC tests
  * 2006-12-07 Added SHA384 HMAC and SHA512 HMAC tests
  * 2004-08-09 Added cipher speed tests (Reyk Floeter <reyk@vantronix.net>)
@@ -72,6 +74,7 @@ static unsigned int sec;
 
 static int mode;
 static char *xbuf;
+static char *axbuf;
 static char *tvmem;
 
 static char *check[] = {
@@ -169,6 +172,7 @@ static void test_hash(char *algo, struct hash_testvec *template,
 
 	/* setup the dummy buffer first */
 	memset(xbuf, 0, XBUFSIZE);
+	memset(axbuf, 0, XBUFSIZE);
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
@@ -217,6 +221,233 @@ out:
 	crypto_free_hash(tfm);
 }
 
+static void test_aead(char *algo, int enc, struct aead_testvec *template,
+		      unsigned int tcount)
+{
+	unsigned int ret, i, j, k, temp;
+	unsigned int tsize;
+	char *q;
+	struct crypto_aead *tfm;
+	char *key;
+	struct aead_testvec *aead_tv;
+	struct aead_request *req;
+	struct scatterlist sg[8];
+	struct scatterlist asg[8];
+	const char *e;
+	struct tcrypt_result result;
+
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+	printk(KERN_INFO "\ntesting %s %s\n", algo, e);
+
+	tsize = sizeof(struct aead_testvec);
+	tsize *= tcount;
+
+	if (tsize > TVMEMSIZE) {
+		printk(KERN_INFO "template (%u) too big for tvmem (%u)\n",
+		       tsize, TVMEMSIZE);
+		return;
+	}
+
+	memcpy(tvmem, template, tsize);
+	aead_tv = (void *)tvmem;
+
+	init_completion(&result.completion);
+
+	tfm = crypto_alloc_aead(algo, 0, 0);
+
+	if (IS_ERR(tfm)) {
+		printk(KERN_INFO "failed to load transform for %s: %ld\n",
+		       algo, PTR_ERR(tfm));
+		return;
+	}
+
+	req = aead_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		printk(KERN_INFO "failed to allocate request for %s\n", algo);
+		goto out;
+	}
+
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  tcrypt_complete, &result);
+
+	for (i = 0, j = 0; i < tcount; i++) {
+		if (!aead_tv[i].np) {
+			printk(KERN_INFO "test %u (%d bit key):\n",
+			       ++j, aead_tv[i].klen * 8);
+
+			crypto_aead_clear_flags(tfm, ~0);
+			if (aead_tv[i].wk)
+				crypto_aead_set_flags(
+					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+			key = aead_tv[i].key;
+
+			ret = crypto_aead_setkey(tfm, key,
+						 aead_tv[i].klen);
+			if (ret) {
+				printk(KERN_INFO "setkey() failed flags=%x\n",
+				       crypto_aead_get_flags(tfm));
+
+				if (!aead_tv[i].fail)
+					goto out;
+			}
+
+			sg_init_one(&sg[0], aead_tv[i].input,
+				    aead_tv[i].ilen);
+
+			sg_init_one(&asg[0], aead_tv[i].assoc,
+				    aead_tv[i].alen);
+
+			aead_request_set_crypt(req, sg, sg,
+					       aead_tv[i].ilen,
+					       aead_tv[i].iv);
+
+			aead_request_set_assoc(req, asg, aead_tv[i].alen);
+
+			if (enc) {
+				ret = crypto_aead_encrypt(req);
+			} else {
+				memcpy(req->__ctx, aead_tv[i].tag,
+				       aead_tv[i].tlen);
+				ret = crypto_aead_decrypt(req);
+			}
+
+			switch (ret) {
+			case 0:
+				break;
+			case -EINPROGRESS:
+			case -EBUSY:
+				ret = wait_for_completion_interruptible(
+					&result.completion);
+				if (!ret && !(ret = result.err)) {
+					INIT_COMPLETION(result.completion);
+					break;
+				}
+				/* fall through */
+			default:
+				printk(KERN_INFO "%s () failed err=%d\n",
+				       e, -ret);
+				goto out;
+			}
+
+			q = kmap(sg_page(&sg[0])) + sg[0].offset;
+			hexdump(q, aead_tv[i].rlen);
+			printk(KERN_INFO "auth tag: ");
+			hexdump((unsigned char *)req->__ctx, aead_tv[i].tlen);
+
+			printk(KERN_INFO "enc/dec: %s\n",
+			       memcmp(q, aead_tv[i].result,
+				      aead_tv[i].rlen) ? "fail" : "pass");
+
+			printk(KERN_INFO "auth tag: %s\n",
+			       memcmp(req->__ctx, aead_tv[i].tag,
+				      aead_tv[i].tlen) ? "fail" : "pass");
+		}
+	}
+
+	printk(KERN_INFO "\ntesting %s %s across pages (chunking)\n", algo, e);
+	memset(xbuf, 0, XBUFSIZE);
+
+	for (i = 0, j = 0; i < tcount; i++) {
+		if (aead_tv[i].np) {
+			printk(KERN_INFO "test %u (%d bit key):\n",
+			       ++j, aead_tv[i].klen * 8);
+
+			crypto_aead_clear_flags(tfm, ~0);
+			if (aead_tv[i].wk)
+				crypto_aead_set_flags(
+					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+			key = aead_tv[i].key;
+
+			ret = crypto_aead_setkey(tfm, key, aead_tv[i].klen);
+			if (ret) {
+				printk(KERN_INFO "setkey() failed flags=%x\n",
+				       crypto_aead_get_flags(tfm));
+
+				if (!aead_tv[i].fail)
+					goto out;
+			}
+
+			sg_init_table(sg, aead_tv[i].np);
+			for (k = 0, temp = 0; k < aead_tv[i].np; k++) {
+				memcpy(&xbuf[IDX[k]],
+				       aead_tv[i].input + temp,
+				       aead_tv[i].tap[k]);
+				temp += aead_tv[i].tap[k];
+				sg_set_buf(&sg[k], &xbuf[IDX[k]],
+					   aead_tv[i].tap[k]);
+			}
+
+			sg_init_table(asg, aead_tv[i].anp);
+			for (k = 0, temp = 0; k < aead_tv[i].anp; k++) {
+				memcpy(&axbuf[IDX[k]],
+				       aead_tv[i].assoc + temp,
+				       aead_tv[i].atap[k]);
+				temp += aead_tv[i].atap[k];
+				sg_set_buf(&asg[k], &axbuf[IDX[k]],
+					   aead_tv[i].atap[k]);
+			}
+
+			aead_request_set_crypt(req, sg, sg,
+					       aead_tv[i].ilen,
+					       aead_tv[i].iv);
+
+			aead_request_set_assoc(req, asg, aead_tv[i].alen);
+
+			if (enc) {
+				ret = crypto_aead_encrypt(req);
+			} else {
+				memcpy(req->__ctx, aead_tv[i].tag,
+				       aead_tv[i].tlen);
+				ret = crypto_aead_decrypt(req);
+			}
+
+			switch (ret) {
+			case 0:
+				break;
+			case -EINPROGRESS:
+			case -EBUSY:
+				ret = wait_for_completion_interruptible(
+					&result.completion);
+				if (!ret && !(ret = result.err)) {
+					INIT_COMPLETION(result.completion);
+					break;
+				}
+				/* fall through */
+			default:
+				printk(KERN_INFO "%s () failed err=%d\n",
+				       e, -ret);
+				goto out;
+			}
+
+			for (k = 0, temp = 0; k < aead_tv[i].np; k++) {
+				printk(KERN_INFO "page %u\n", k);
+				q = kmap(sg_page(&sg[k])) + sg[k].offset;
+				hexdump(q, aead_tv[i].tap[k]);
+				printk(KERN_INFO "%s\n",
+				       memcmp(q, aead_tv[i].result + temp,
+					      aead_tv[i].tap[k]) ?
+				       "fail" : "pass");
+
+				temp += aead_tv[i].tap[k];
+			}
+			printk(KERN_INFO "auth tag: ");
+			hexdump((unsigned char *)req->__ctx, aead_tv[i].tlen);
+
+			printk(KERN_INFO "auth tag: %s\n",
+			       memcmp(req->__ctx, aead_tv[i].tag,
+				      aead_tv[i].tlen) ? "fail" : "pass");
+		}
+	}
+
+out:
+	crypto_free_aead(tfm);
+	aead_request_free(req);
+}
+
 static void test_cipher(char *algo, int enc,
 			struct cipher_testvec *template, unsigned int tcount)
 {
@@ -1497,20 +1728,21 @@ static void do_test(void)
 
 static int __init init(void)
 {
+	int err = -ENOMEM;
+
 	tvmem = kmalloc(TVMEMSIZE, GFP_KERNEL);
 	if (tvmem == NULL)
-		return -ENOMEM;
+		return err;
 
 	xbuf = kmalloc(XBUFSIZE, GFP_KERNEL);
-	if (xbuf == NULL) {
-		kfree(tvmem);
-		return -ENOMEM;
-	}
+	if (xbuf == NULL)
+		goto err_free_tv;
 
-	do_test();
+	axbuf = kmalloc(XBUFSIZE, GFP_KERNEL);
+	if (axbuf == NULL)
+		goto err_free_xbuf;
 
-	kfree(xbuf);
-	kfree(tvmem);
+	do_test();
 
 	/* We intentionaly return -EAGAIN to prevent keeping
 	 * the module. It does all its work from init()
@@ -1518,7 +1750,15 @@ static int __init init(void)
 	 * => we don't need it in the memory, do we?
 	 *                                        -- mludvig
 	 */
-	return -EAGAIN;
+	err = -EAGAIN;
+
+	kfree(axbuf);
+ err_free_xbuf:
+	kfree(xbuf);
+ err_free_tv:
+	kfree(tvmem);
+
+	return err;
 }
 
 /*
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 6ffc411..865196a 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -6,12 +6,14 @@
  *
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
+ * Copyright (c) 2007 Nokia Siemens Networks
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
+ * 2007-11-13 Added AEAD support
  * 2006-12-07 Added SHA384 HMAC and SHA512 HMAC tests
  * 2004-08-09 Cipher speed tests by Reyk Floeter <reyk@vantronix.net>
  * 2003-09-14 Changes by Kartikey Mahendra Bhatt
@@ -51,6 +53,26 @@ struct cipher_testvec {
 	unsigned short rlen;
 };
 
+struct aead_testvec {
+	char key[MAX_KEYLEN] __attribute__ ((__aligned__(4)));
+	char iv[MAX_IVLEN];
+	char input[512];
+	char assoc[512];
+	char result[512];
+	char tag[128];
+	unsigned char tap[MAX_TAP];
+	unsigned char atap[MAX_TAP];
+	int np;
+	int anp;
+	unsigned char fail;
+	unsigned char wk; /* weak key flag */
+	unsigned char klen;
+	unsigned short ilen;
+	unsigned short alen;
+	unsigned short rlen;
+	unsigned short tlen;
+};
+
 struct cipher_speed {
 	unsigned char klen;
 	unsigned int blen;
