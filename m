From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: Re: [cryptodev:master 79/79] (.text+0x330de0): multiple definition
 of `ecdh_shared_secret'
Date: Fri, 24 Jun 2016 07:06:49 +0100
Message-ID: <20160624060649.GA21165@localhost>
References: <201606240302.rtIGIxRf%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, salvatore.benedetto@intel.com
To: kbuild test robot <fengguang.wu@intel.com>,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:10411 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbcFXGGt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 02:06:49 -0400
Content-Disposition: inline
In-Reply-To: <201606240302.rtIGIxRf%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 24, 2016 at 03:47:04AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   3c4b23901a0c766879dff680cd6bdab47bcdbbd2
> commit: 3c4b23901a0c766879dff680cd6bdab47bcdbbd2 [79/79] crypto: ecdh - Add ECDH software support
> config: i386-allyesconfig (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
> reproduce:
>         git checkout 3c4b23901a0c766879dff680cd6bdab47bcdbbd2
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    net/built-in.o: In function `ecdh_shared_secret':
> >> (.text+0x330de0): multiple definition of `ecdh_shared_secret'
>    crypto/built-in.o:(.text+0xb1b0): first defined here
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

Hi Herbert,

can you squash the following patch?

Thanks,
Salvatore

---8<---
Rename ecdh_shared_secret

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 crypto/ecc.c  |  8 ++++----
 crypto/ecc.h  | 12 ++++++------
 crypto/ecdh.c |  8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 9aedec6..1ba2436 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -966,10 +966,10 @@ out:
 	return ret;
 }
 
-int ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
-		       const u8 *private_key, unsigned int private_key_len,
-		       const u8 *public_key, unsigned int public_key_len,
-		       u8 *secret, unsigned int secret_len)
+int ecdh_compute_ss(unsigned int curve_id, unsigned int ndigits,
+		    const u8 *private_key, unsigned int private_key_len,
+		    const u8 *public_key, unsigned int public_key_len,
+		    u8 *secret, unsigned int secret_len)
 {
 	int ret = 0;
 	struct ecc_point *product, *pk;
diff --git a/crypto/ecc.h b/crypto/ecc.h
index b5db4b9..a856175 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -60,7 +60,7 @@ int ecdh_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
 		      u8 *public_key, unsigned int public_key_len);
 
 /**
- * ecdh_shared_secret() - Compute a shared secret
+ * ecdh_compute_ss() - Compute a shared secret
  *
  * @curve_id:		id representing the curve to use
  * @private_key:	private key of part A
@@ -70,14 +70,14 @@ int ecdh_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
  * @secret:		buffer for storing the calculated shared secret
  * @secret_len:		length of the secret buffer
  *
- * Note: It is recommended that you hash the result of ecdh_shared_secret
+ * Note: It is recommended that you hash the result of ecdh_compute_ss
  * before using it for symmetric encryption or HMAC.
  *
  * Returns 0 if the shared secret was generated successfully, a negative value
  * if an error occurred.
  */
-int ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
-		       const u8 *private_key, unsigned int private_key_len,
-		       const u8 *public_key, unsigned int public_key_len,
-		       u8 *secret, unsigned int secret_len);
+int ecdh_compute_ss(unsigned int curve_id, unsigned int ndigits,
+		    const u8 *private_key, unsigned int private_key_len,
+		    const u8 *public_key, unsigned int public_key_len,
+		    u8 *secret, unsigned int secret_len);
 #endif
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index d3a9eec..7e12a34 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -79,10 +79,10 @@ static int ecdh_compute_value(struct kpp_request *req)
 		if (copied != 2 * nbytes)
 			return -EINVAL;
 
-		ret = ecdh_shared_secret(ctx->curve_id, ctx->ndigits,
-					 (const u8 *)ctx->private_key, nbytes,
-					 (const u8 *)ctx->public_key, 2 * nbytes,
-					 (u8 *)ctx->shared_secret, nbytes);
+		ret = ecdh_compute_ss(ctx->curve_id, ctx->ndigits,
+				      (const u8 *)ctx->private_key, nbytes,
+				      (const u8 *)ctx->public_key, 2 * nbytes,
+				      (u8 *)ctx->shared_secret, nbytes);
 
 		buf = ctx->shared_secret;
 	} else {
-- 
2.7.4
