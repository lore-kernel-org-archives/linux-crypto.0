From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/5] [CRYPTO] api: Add crypto_inc and crypto_xor
Date: Thu, 22 Nov 2007 16:37:44 +0800
Message-ID: <E1Iv7ZA-0001wB-00@gondolin.me.apana.org.au>
References: <20071122083656.GB7368@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4622 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751279AbXKVIsP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:48:15 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7j8-0008A8-Jp
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:02 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Add crypto_inc and crypto_xor

With the addition of more stream ciphers we need to curb the proliferation
of ad-hoc xor functions.  This patch creates a generic pair of functions,
crypto_inc and crypto_xor which does big-endian increment and exclusive or,
respectively.

For optimum performance, they both use u32 operations so alignment must be
as that of u32 even though the arguments are of type u8 *.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/algapi.h |    4 ++++
 2 files changed, 51 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 8383282..08eca6d 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -605,6 +605,53 @@ int crypto_tfm_in_queue(struct crypto_queue *queue, struct crypto_tfm *tfm)
 }
 EXPORT_SYMBOL_GPL(crypto_tfm_in_queue);
 
+static inline void crypto_inc_byte(u8 *a, unsigned int size)
+{
+	u8 *b = (a + size);
+	u8 c;
+
+	for (; size; size--) {
+		c = *--b + 1;
+		*b = c;
+		if (c)
+			break;
+	}
+}
+
+void crypto_inc(u8 *a, unsigned int size)
+{
+	__be32 *b = (__be32 *)(a + size);
+	u32 c;
+
+	for (; size >= 4; size -= 4) {
+		c = be32_to_cpu(*--b) + 1;
+		*b = cpu_to_be32(c);
+		if (c)
+			return;
+	}
+
+	crypto_inc_byte(a, size);
+}
+EXPORT_SYMBOL_GPL(crypto_inc);
+
+static inline void crypto_xor_byte(u8 *a, const u8 *b, unsigned int size)
+{
+	for (; size; size--)
+		*a++ ^= *b++;
+}
+
+void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
+{
+	u32 *a = (u32 *)dst;
+	u32 *b = (u32 *)src;
+
+	for (; size >= 4; size -= 4)
+		*a++ ^= *b++;
+
+	crypto_xor_byte((u8 *)a, (u8 *)b, size);
+}
+EXPORT_SYMBOL_GPL(crypto_xor);
+
 static int __init crypto_algapi_init(void)
 {
 	crypto_init_proc();
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 88619f9..2cdb227 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -124,6 +124,10 @@ int crypto_enqueue_request(struct crypto_queue *queue,
 struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue);
 int crypto_tfm_in_queue(struct crypto_queue *queue, struct crypto_tfm *tfm);
 
+/* These functions require the input/output to be aligned as u32. */
+void crypto_inc(u8 *a, unsigned int size);
+void crypto_xor(u8 *dst, const u8 *src, unsigned int size);
+
 int blkcipher_walk_done(struct blkcipher_desc *desc,
 			struct blkcipher_walk *walk, int err);
 int blkcipher_walk_virt(struct blkcipher_desc *desc,
