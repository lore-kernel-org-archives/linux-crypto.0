From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [crypto] fix writting into unallocated memory in setkey_aligned
Date: Thu, 2 Aug 2007 14:57:43 +0200
Message-ID: <20070802125743.GC24639@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49172 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755011AbXHBM5r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 08:57:47 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

setkey_unaligned() commited in ca7c39385ce1a7b44894a4b225a4608624e90730
overwrites unallocated memory in the following memset() because I used the
wrong buffer length.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -35,7 +35,7 @@ static int setkey_unaligned(struct crypt
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = cipher->setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, absize);
+	memset(alignbuffer, 0, keylen);
 	kfree(buffer);
 	return ret;
 }
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -352,7 +352,7 @@ static int setkey_unaligned(struct crypt
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = cipher->setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, absize);
+	memset(alignbuffer, 0, keylen);
 	kfree(buffer);
 	return ret;
 }
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -36,7 +36,7 @@ static int setkey_unaligned(struct crypt
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = cia->cia_setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, absize);
+	memset(alignbuffer, 0, keylen);
 	kfree(buffer);
 	return ret;
 
--- a/crypto/hash.c
+++ b/crypto/hash.c
@@ -40,7 +40,7 @@ static int hash_setkey_unaligned(struct 
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = alg->setkey(crt, alignbuffer, keylen);
-	memset(alignbuffer, 0, absize);
+	memset(alignbuffer, 0, keylen);
 	kfree(buffer);
 	return ret;
 }
