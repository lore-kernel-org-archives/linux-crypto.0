From: Jarod Wilson <jarod@redhat.com>
Subject: [RFC PATCH] crypto: add buffer overflow checks to testmgr
Date: Fri, 29 May 2009 11:32:54 -0400
Message-ID: <200905291132.55848.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Neil Horman <nhorman@tuxdriver.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54200 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758603AbZE2Pdt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2009 11:33:49 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

At present, its entirely possible to add a test vector to testmgr with
an input longer than a page in length w/o specifying a .np option, and
overflow the page of memory allocated to {a,}xbuf[0], silently
corrupting memory. I know, because I've accidentally done it. :)

While this doesn't currently happen in practice w/the existing code,
due to all !np vectors being less than a 4k page in length (and the
page allocation loop often returns contiguous pages anyway), explicit
checks or a way to remove the 4k limit would be a good idea.

A few ways to fix and/or work around this:

1) allocate some larger guaranteed contiguous buffers using
__get_free_pages() or kmalloc and use them in the !np case

2) catch the > PAGE_SIZE && !np case and then do things similar to how
they are done in the np case

3) catch the > PAGE_SIZE && !np case and simply exit with an error

Since there currently aren't any test vectors that are actually larger
than a page and not tagged np, option 1 seems like a waste of memory
and option 2 sounds like unnecessary complexity, so I'd offer up
option 3 as the most viable alternative right now.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 376ea88..9483a2b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -185,6 +185,13 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 
 		hash_buff = xbuf[0];
 
+		if (template[i].psize > PAGE_SIZE) {
+			printk(KERN_ERR "alg: hash: psize %u larger than "
+			       "contiguous buffer space\n", template[i].psize);
+			ret = -EOVERFLOW;
+			goto out;
+		}
+
 		memcpy(hash_buff, template[i].plaintext, template[i].psize);
 		sg_init_one(&sg[0], hash_buff, template[i].psize);
 
@@ -357,6 +364,16 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			input = xbuf[0];
 			assoc = axbuf[0];
 
+			if (template[i].ilen > PAGE_SIZE ||
+			    template[i].alen > PAGE_SIZE) {
+				printk(KERN_ERR "alg: aead: input larger than "
+				       "contiguous buffer space (ilen: %u, "
+				       "alen: %u)\n",
+				       template[i].ilen, template[i].alen);
+				ret = -EOVERFLOW;
+				goto out;
+			}
+
 			memcpy(input, template[i].input, template[i].ilen);
 			memcpy(assoc, template[i].assoc, template[i].alen);
 			if (template[i].iv)
@@ -651,6 +668,14 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 		j++;
 
 		data = xbuf[0];
+
+		if (template[i].ilen > PAGE_SIZE) {
+			printk(KERN_ERR "alg: cipher: ilen %u larger than "
+			       "contiguous buffer space\n", template[i].ilen);
+			ret = -EOVERFLOW;
+			goto out;
+		}
+
 		memcpy(data, template[i].input, template[i].ilen);
 
 		crypto_cipher_clear_flags(tfm, ~0);
@@ -742,6 +767,15 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			j++;
 
 			data = xbuf[0];
+
+			if (template[i].ilen > PAGE_SIZE) {
+				printk(KERN_ERR "alg: skcipher: ilen %u larger "
+				       "than contiguous buffer space\n",
+				       template[i].ilen);
+				ret = -EOVERFLOW;
+				goto out;
+			}
+
 			memcpy(data, template[i].input, template[i].ilen);
 
 			crypto_ablkcipher_clear_flags(tfm, ~0);

-- 
Jarod Wilson
jarod@redhat.com
