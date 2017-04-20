From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 4/5] KEYS: DH: ensure the KDF counter is properly aligned
Date: Wed, 19 Apr 2017 22:46:32 -0700
Message-ID: <20170420054633.14572-5-ebiggers3@gmail.com>
References: <20170420054633.14572-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33477 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938743AbdDTFsX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 01:48:23 -0400
In-Reply-To: <20170420054633.14572-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Accessing a 'u8[4]' through a '__be32 *' violates alignment rules.  Just
make the counter a __be32 instead.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 security/keys/dh.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index a3a8607107f5..e6b757c33289 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -130,14 +130,6 @@ static void kdf_dealloc(struct kdf_sdesc *sdesc)
 	kzfree(sdesc);
 }
 
-/* convert 32 bit integer into its string representation */
-static inline void crypto_kw_cpu_to_be32(u32 val, u8 *buf)
-{
-	__be32 *a = (__be32 *)buf;
-
-	*a = cpu_to_be32(val);
-}
-
 /*
  * Implementation of the KDF in counter mode according to SP800-108 section 5.1
  * as well as SP800-56A section 5.8.1 (Single-step KDF).
@@ -154,16 +146,14 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
 	unsigned int h = crypto_shash_digestsize(desc->tfm);
 	int err = 0;
 	u8 *dst_orig = dst;
-	u32 i = 1;
-	u8 iteration[sizeof(u32)];
+	__be32 counter = cpu_to_be32(1);
 
 	while (dlen) {
 		err = crypto_shash_init(desc);
 		if (err)
 			goto err;
 
-		crypto_kw_cpu_to_be32(i, iteration);
-		err = crypto_shash_update(desc, iteration, sizeof(u32));
+		err = crypto_shash_update(desc, (u8 *)&counter, sizeof(__be32));
 		if (err)
 			goto err;
 
@@ -189,7 +179,7 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
 
 			dlen -= h;
 			dst += h;
-			i++;
+			counter = cpu_to_be32(be32_to_cpu(counter) + 1);
 		}
 	}
 
-- 
2.12.2
