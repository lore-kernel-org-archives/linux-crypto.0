From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 1/5] KEYS: DH: forbid using digest_null as the KDF hash
Date: Wed, 19 Apr 2017 22:46:29 -0700
Message-ID: <20170420054633.14572-2-ebiggers3@gmail.com>
References: <20170420054633.14572-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33435 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763679AbdDTFsV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 01:48:21 -0400
In-Reply-To: <20170420054633.14572-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Requesting "digest_null" in the keyctl_kdf_params caused an infinite
loop in kdf_ctr() because the "null" hash has a digest size of 0.  Fix
it by rejecting hash algorithms with a digest size of 0.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 security/keys/dh.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index e603bd912e4c..8abc70ebe22d 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -89,6 +89,7 @@ static int kdf_alloc(struct kdf_sdesc **sdesc_ret, char *hashname)
 	struct crypto_shash *tfm;
 	struct kdf_sdesc *sdesc;
 	int size;
+	int err;
 
 	/* allocate synchronous hash */
 	tfm = crypto_alloc_shash(hashname, 0, 0);
@@ -97,16 +98,25 @@ static int kdf_alloc(struct kdf_sdesc **sdesc_ret, char *hashname)
 		return PTR_ERR(tfm);
 	}
 
+	err = -EINVAL;
+	if (crypto_shash_digestsize(tfm) == 0)
+		goto out_free_tfm;
+
+	err = -ENOMEM;
 	size = sizeof(struct shash_desc) + crypto_shash_descsize(tfm);
 	sdesc = kmalloc(size, GFP_KERNEL);
 	if (!sdesc)
-		return -ENOMEM;
+		goto out_free_tfm;
 	sdesc->shash.tfm = tfm;
 	sdesc->shash.flags = 0x0;
 
 	*sdesc_ret = sdesc;
 
 	return 0;
+
+out_free_tfm:
+	crypto_free_shash(tfm);
+	return err;
 }
 
 static void kdf_dealloc(struct kdf_sdesc *sdesc)
-- 
2.12.2
