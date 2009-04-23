From: Jarod Wilson <jarod@wilsonet.com>
Subject: [PATCH 1/2] crypto: handle ccm dec test vectors expected to fail verification
Date: Thu, 23 Apr 2009 14:22:49 -0400
Message-ID: <200904231422.50153.jarod@wilsonet.com>
References: <200904091434.59639.jarod@redhat.com> <20090420062640.GB1135@gondor.apana.org.au> <49F0B09D.6040308@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>,
	Jarod Wilson <jarod@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:46993
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646AbZDWS3j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2009 14:29:39 -0400
In-Reply-To: <49F0B09D.6040308@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add infrastructure to tcrypt/testmgr to support handling ccm decryption
test vectors that are expected to fail verification.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |   28 ++++++++++++++++++++++++++++
 crypto/testmgr.h |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index bfee6e9..84f9640 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -363,6 +363,16 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
 			switch (ret) {
 			case 0:
+				if (template[i].novrfy) {
+					/* verification was supposed to fail */
+					printk(KERN_ERR "alg: aead: %s failed "
+					       "on test %d for %s: ret was 0, "
+					       "expected -EBADMSG\n",
+					       e, j, algo);
+					/* so really, we got a bad message */
+					ret = -EBADMSG;
+					goto out;
+				}
 				break;
 			case -EINPROGRESS:
 			case -EBUSY:
@@ -372,6 +382,10 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 					INIT_COMPLETION(result.completion);
 					break;
 				}
+			case -EBADMSG:
+				if (template[i].novrfy)
+					/* verification failure was expected */
+					continue;
 				/* fall through */
 			default:
 				printk(KERN_ERR "alg: aead: %s failed on test "
@@ -481,6 +495,16 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
 			switch (ret) {
 			case 0:
+				if (template[i].novrfy) {
+					/* verification was supposed to fail */
+					printk(KERN_ERR "alg: aead: %s failed "
+					       "on chunk test %d for %s: ret "
+					       "was 0, expected -EBADMSG\n",
+					       e, j, algo);
+					/* so really, we got a bad message */
+					ret = -EBADMSG;
+					goto out;
+				}
 				break;
 			case -EINPROGRESS:
 			case -EBUSY:
@@ -490,6 +514,10 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 					INIT_COMPLETION(result.completion);
 					break;
 				}
+			case -EBADMSG:
+				if (template[i].novrfy)
+					/* verification failure was expected */
+					continue;
 				/* fall through */
 			default:
 				printk(KERN_ERR "alg: aead: %s failed on "
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 526f00a..b77b61d 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -62,6 +62,7 @@ struct aead_testvec {
 	int np;
 	int anp;
 	unsigned char fail;
+	unsigned char novrfy;	/* ccm dec verification failure expected */
 	unsigned char wk; /* weak key flag */
 	unsigned char klen;
 	unsigned short ilen;

-- 
Jarod Wilson
jarod@wilsonet.com
