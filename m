From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: [PATCH] crypto/pkcs7_verify: Fix unaligned access in pkcs7_verify()
Date: Tue, 13 Oct 2015 10:54:01 -0400
Message-ID: <20151013145401.GM20800@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	dhowells@redhat.com, marcel@holtmann.org, David.Woodhouse@intel.com
To: sowmini.varadhan@oracle.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On sparc, we see unaligned access messages on each modprobe[-r]:

Kernel unaligned access at TPC[6ad9b4] pkcs7_verify [..]
Kernel unaligned access at TPC[6a5484] crypto_shash_finup [..]
Kernel unaligned access at TPC[6a5390] crypto_shash_update [..]
Kernel unaligned access at TPC[10150308] sha1_sparc64_update [..]
Kernel unaligned access at TPC[101501ac] __sha1_sparc64_update [..]

These ware triggered by mod_verify_sig() invocations of pkcs_verify(), and
are are being caused by an unaligned desc at (sha1, digest_size is 0x14)
        desc = digest + digest_size;

To fix this, pkcs7_verify needs to make sure that desc is pointing
at an aligned value past the digest_size, and kzalloc appropriately,
taking alignment values into consideration.

Signed-off-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index d20c0b4..325575c 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -49,11 +49,12 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 	sinfo->sig.digest_size = digest_size = crypto_shash_digestsize(tfm);
 
 	ret = -ENOMEM;
-	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
+	digest = kzalloc(ALIGN(digest_size, __alignof__(*desc)) + desc_size,
+			 GFP_KERNEL);
 	if (!digest)
 		goto error_no_desc;
 
-	desc = digest + digest_size;
+	desc = PTR_ALIGN(digest + digest_size, __alignof__(*desc));
 	desc->tfm   = tfm;
 	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
-- 
1.7.1
