From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/3] crypto: handle ccm dec test vectors expected to fail verification
Date: Wed, 15 Apr 2009 09:36:43 -0400
Message-ID: <200904150936.43919.jarod@redhat.com>
References: <200904091434.59639.jarod@redhat.com> <200904150835.38818.jarod@redhat.com> <200904150935.15947.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755852AbZDONhg@vger.kernel.org>
In-Reply-To: <200904150935.15947.jarod@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add infrastructure to tcrypt to support handling ccm decryption test
vectors that are expected to fail verification.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |   32 ++++++++++++++++++++++++++++++++
 crypto/testmgr.h |    1 +
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a8bdcb3..92f4df0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -373,6 +373,16 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
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
@@ -382,6 +392,10 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 					INIT_COMPLETION(result.completion);
 					break;
 				}
+			case -EBADMSG:
+				if (template[i].novrfy)
+					/* verification failure was expected */
+					goto next_aead_vector;
 				/* fall through */
 			default:
 				printk(KERN_ERR "alg: aead: %s failed on test "
@@ -398,6 +412,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 				goto out;
 			}
 		}
+next_aead_vector:
+		continue;
 	}
 
 	for (i = 0, j = 0; i < tcount; i++) {
@@ -491,6 +507,16 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
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
@@ -500,6 +526,10 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 					INIT_COMPLETION(result.completion);
 					break;
 				}
+			case -EBADMSG:
+				if (template[i].novrfy)
+					/* verification failure was expected */
+					goto next_aead_chunk_vector;
 				/* fall through */
 			default:
 				printk(KERN_ERR "alg: aead: %s failed on "
@@ -550,6 +580,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 				temp += template[i].tap[k];
 			}
 		}
+next_aead_chunk_vector:
+		continue;
 	}
 
 	ret = 0;
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
1.6.2.2


-- 
Jarod Wilson
jarod@redhat.com
