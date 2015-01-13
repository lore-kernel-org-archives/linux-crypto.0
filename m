From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: qat - Ensure ipad and opad are zeroed
Date: Wed, 14 Jan 2015 10:07:03 +1100
Message-ID: <20150113230703.GA12608@gondor.apana.org.au>
References: <20150113202753.32216.26250.stgit@tstruk-mobl1>
 <20150113212515.GA11562@gondor.apana.org.au>
 <54B59A86.10803@intel.com>
 <20150113224756.GA12432@gondor.apana.org.au>
 <54B5A25C.9070007@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36543 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbAMXHJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 18:07:09 -0500
Content-Disposition: inline
In-Reply-To: <54B5A25C.9070007@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 13, 2015 at 02:55:24PM -0800, Tadeusz Struk wrote:
> On 01/13/2015 02:47 PM, Herbert Xu wrote:
> > Why are you allocating this qat_auth_state anyway? Just do
> > ipad/opad[block_size] and be done with it.
> 
> You are right. I don't need qat_auth_state really. Let me send you v2 in
> 2 mins.

Don't worry, I fixed it for you.

-- >8 --
The patch ad511e260a27b8e35d273cc0ecfe5a8ff9543181 (crypto: qat -
Fix incorrect uses of memzero_explicit) broke hashing because the
code was in fact overwriting the qat_auth_state variable.

In fact there is no reason for the variable to exist anyway since
all we are using it for is to store ipad and opad.  So we could
simply create ipad and opad directly and avoid this whole mess.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index a0d95f3..e2c4b25 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -160,33 +160,30 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 				  const uint8_t *auth_key,
 				  unsigned int auth_keylen)
 {
-	struct qat_auth_state auth_state;
 	SHASH_DESC_ON_STACK(shash, ctx->hash_tfm);
 	struct sha1_state sha1;
 	struct sha256_state sha256;
 	struct sha512_state sha512;
 	int block_size = crypto_shash_blocksize(ctx->hash_tfm);
 	int digest_size = crypto_shash_digestsize(ctx->hash_tfm);
-	uint8_t *ipad = auth_state.data;
-	uint8_t *opad = ipad + block_size;
+	char ipad[block_size];
+	char opad[block_size];
 	__be32 *hash_state_out;
 	__be64 *hash512_state_out;
 	int i, offset;
 
-	memset(auth_state.data, 0, sizeof(auth_state.data));
+	memset(ipad, 0, block_size);
+	memset(opad, 0, block_size);
 	shash->tfm = ctx->hash_tfm;
 	shash->flags = 0x0;
 
 	if (auth_keylen > block_size) {
-		char buff[SHA512_BLOCK_SIZE];
 		int ret = crypto_shash_digest(shash, auth_key,
-					      auth_keylen, buff);
+					      auth_keylen, ipad);
 		if (ret)
 			return ret;
 
-		memcpy(ipad, buff, digest_size);
-		memcpy(opad, buff, digest_size);
-		memzero_explicit(buff, sizeof(buff));
+		memcpy(opad, ipad, digest_size);
 	} else {
 		memcpy(ipad, auth_key, auth_keylen);
 		memcpy(opad, auth_key, auth_keylen);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
