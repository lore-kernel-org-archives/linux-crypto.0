From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: CTR DRBG - prevent invalid SG mappings
Date: Sat, 26 Nov 2016 09:54:14 +0100
Message-ID: <2300597.UdE444b3Re@positron.chronox.de>
References: <1833318.YYJALW9cvC@positron.chronox.de> <3805767.QuT5G9UC4v@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:51000 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750845AbcKZUBd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Nov 2016 15:01:33 -0500
In-Reply-To: <3805767.QuT5G9UC4v@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

as discussed in another thread, SGs must not be used with stack memory 
pointers. This issue was the culprit to the error I see with the CTR DRBG. The 
attached patch fixes the issue.

---8<---

When using SGs, only heap memory (memory that is valid as per
virt_addr_valid) is allowed to be referenced. The CTR DRBG used to
reference the caller-provided memory directly in an SG. In case the
caller provided stack memory pointers, the SG mapping is not considered
to be valid. In some cases, this would even cause a paging fault.

The change adds a new scratch buffer that is used in case the
caller-provided buffer is deemed not suitable for use in an SG. The
crypto operation of the CTR DRBG produces its output with that scratch
buffer.

The scratch buffer is allocated during allocation time of the CTR DRBG
as its access is protected with the DRBG mutex.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 35 +++++++++++++++++++++++++++++++----
 include/crypto/drbg.h |  2 ++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 9a95b61..cbbd19f 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -262,6 +262,7 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 			      u8 *inbuf, u32 inbuflen,
 			      u8 *outbuf, u32 outlen);
 #define DRBG_CTR_NULL_LEN 128
+#define DRBG_OUTSCRATCHLEN DRBG_CTR_NULL_LEN
 
 /* BCC function for CTR DRBG as defined in 10.4.3 */
 static int drbg_ctr_bcc(struct drbg_state *drbg,
@@ -1644,6 +1645,9 @@ static int drbg_fini_sym_kernel(struct drbg_state *drbg)
 	kfree(drbg->ctr_null_value_buf);
 	drbg->ctr_null_value = NULL;
 
+	kfree(drbg->outscratchpadbuf);
+	drbg->outscratchpadbuf = NULL;
+
 	return 0;
 }
 
@@ -1708,6 +1712,15 @@ static int drbg_init_sym_kernel(struct drbg_state 
*drbg)
 	drbg->ctr_null_value = (u8 *)PTR_ALIGN(drbg->ctr_null_value_buf,
 					       alignmask + 1);
 
+	drbg->outscratchpadbuf = kmalloc(DRBG_OUTSCRATCHLEN + alignmask,
+					 GFP_KERNEL);
+	if (!drbg->outscratchpadbuf) {
+		drbg_fini_sym_kernel(drbg);
+		return -ENOMEM;
+	}
+	drbg->outscratchpad = (u8 *)PTR_ALIGN(drbg->outscratchpadbuf,
+					      alignmask + 1);
+
 	return alignmask;
 }
 
@@ -1737,15 +1750,22 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 			      u8 *outbuf, u32 outlen)
 {
 	struct scatterlist sg_in;
+	bool virt_addr_valid = virt_addr_valid(outbuf);
+	int ret = 0;
 
 	sg_init_one(&sg_in, inbuf, inlen);
 
 	while (outlen) {
 		u32 cryptlen = min_t(u32, inlen, outlen);
 		struct scatterlist sg_out;
-		int ret;
 
-		sg_init_one(&sg_out, outbuf, cryptlen);
+		/* If output buffer is not valid for SGL, use scratchpad */
+		if (virt_addr_valid)
+			sg_init_one(&sg_out, outbuf, cryptlen);
+		else {
+			cryptlen = min_t(u32, cryptlen, DRBG_OUTSCRATCHLEN);
+			sg_init_one(&sg_out, drbg->outscratchpad, cryptlen);
+		}
 		skcipher_request_set_crypt(drbg->ctr_req, &sg_in, &sg_out,
 					   cryptlen, drbg->V);
 		ret = crypto_skcipher_encrypt(drbg->ctr_req);
@@ -1761,15 +1781,22 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 				break;
 			}
 		default:
-			return ret;
+			goto out;
 		}
 		init_completion(&drbg->ctr_completion);
 
+		if (!virt_addr_valid)
+			memcpy(outbuf, drbg->outscratchpad, cryptlen);
+
 		outlen -= cryptlen;
 		outbuf += cryptlen;
 	}
+	ret = 0;
 
-	return 0;
+out:
+	if (!virt_addr_valid)
+		memzero_explicit(drbg->outscratchpad, DRBG_OUTSCRATCHLEN);
+	return ret;
 }
 #endif /* CONFIG_CRYPTO_DRBG_CTR */
 
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 61580b1..22f884c 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -124,6 +124,8 @@ struct drbg_state {
 	struct skcipher_request *ctr_req;	/* CTR mode request handle */
 	__u8 *ctr_null_value_buf;		/* CTR mode unaligned buffer */
 	__u8 *ctr_null_value;			/* CTR mode aligned zero buf */
+	__u8 *outscratchpadbuf;			/* CTR mode output scratchpad */
+        __u8 *outscratchpad;			/* CTR mode aligned outbuf */
 	struct completion ctr_completion;	/* CTR mode async handler */
 	int ctr_async_err;			/* CTR mode async error */
 
-- 
2.9.3
