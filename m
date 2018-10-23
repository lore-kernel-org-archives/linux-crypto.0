Return-Path: <SRS0=BLQr=ND=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60816 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726885AbeJWPXl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Oct 2018 11:23:41 -0400
Message-ID: <1540278091.3347.9.camel@HansenPartnership.com>
Subject: Re: [PATCH v4 2/7] tpm2-sessions: Add full HMAC and encrypt/decrypt
 session handling
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-integrity <linux-integrity@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Date: Tue, 23 Oct 2018 08:01:31 +0100
In-Reply-To: <CAKv+Gu-gYLY1vmtgFC0MTkBfsAkPz658ELaGW78MbD=6ROrLFQ@mail.gmail.com>
References: <1540193596.3202.7.camel@HansenPartnership.com>
         <1540193787.3202.10.camel@HansenPartnership.com>
         <CAKv+Gu-gYLY1vmtgFC0MTkBfsAkPz658ELaGW78MbD=6ROrLFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2018-10-22 at 19:19 -0300, Ard Biesheuvel wrote:
[...]
> > +static void hmac_init(struct shash_desc *desc, u8 *key, int
> > keylen)
> > +{
> > +       u8 pad[SHA256_BLOCK_SIZE];
> > +       int i;
> > +
> > +       desc->tfm = sha256_hash;
> > +       desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> 
> I don't think this actually does anything in the shash API
> implementation, so you can drop this.

OK, I find crypto somewhat hard to follow.  There were bits I had to
understand, like when I wrote the CFB implementation or when I fixed
the ECDH scatterlist handling, but I've got to confess, in time
honoured tradition I simply copied this from EVM crypto without
actually digging into the code to understand why.

>  However, I take it this means that hmac_init() is never called in
> contexts where sleeping is not allowed? For the relevance of that,
> please see below.

Right, these routines are always called as an adjunct to a TPM
operation and TPM operations can sleep, so we must at least have kernel
thread context.

[...]
> > +       /* encrypt before HMAC */
> > +       if (auth->attrs & TPM2_SA_DECRYPT) {
> > +               struct scatterlist sg[1];
> > +               u16 len;
> > +               SKCIPHER_REQUEST_ON_STACK(req, auth->aes);
> > +
> > +               skcipher_request_set_tfm(req, auth->aes);
> > +               skcipher_request_set_callback(req,
> > CRYPTO_TFM_REQ_MAY_SLEEP,
> > +                                             NULL, NULL);
> > +
> 
> Your crypto_alloc_skcipher() call [further down] does not mask out
> CRYPTO_ALG_ASYNC, and so it permits asynchronous implementations to
> be selected. Your generic cfb template only permits synchronous
> implementations, since it wraps the cipher directly (which is always
> synchronous). However, we have support in the tree for some
> accelerators that implement cfb(aes), and those will return
> -EINPROGRESS when invoking crypto_skcipher_en/decrypt(req), which you
> are not set up to handle.
> 
> So the simple solution is to call 'crypto_alloc_skcipher("cfb(aes)",
> 0, CRYPTO_ALG_ASYNC)' below instead.
> 
> However, I would prefer it if we permit asynchronous skciphers here.
> The reason is that, on a given platform, the accelerator may be the
> only truly time invariant AES implementation that is available, and
> since we are dealing with the TPM, a bit of paranoia does not hurt.
> It also makes it easier to implement it as a [time invariant] SIMD
> based asynchronous skcipher, which are simpler than synchronous ones
> since they don't require a non-SIMD fallback path for calls from
> contexts where the SIMD unit may not be used.
> 
> I have already implemented cfb(aes) for arm64/NEON. I will post the
> patch after the merge window closes.
> 
> > +               /* need key and IV */
> > +               KDFa(auth->session_key, SHA256_DIGEST_SIZE
> > +                    + auth->passphraselen, "CFB", auth->our_nonce,
> > +                    auth->tpm_nonce, AES_KEYBYTES +
> > AES_BLOCK_SIZE,
> > +                    auth->scratch);
> > +               crypto_skcipher_setkey(auth->aes, auth->scratch,
> > AES_KEYBYTES);
> > +               len = tpm_get_inc_u16(&p);
> > +               sg_init_one(sg, p, len);
> > +               skcipher_request_set_crypt(req, sg, sg, len,
> > +                                          auth->scratch +
> > AES_KEYBYTES);
> > +               crypto_skcipher_encrypt(req);
> 
> So please consider replacing this with something like.
> 
> DECLARE_CRYPTO_WAIT(wait); [further up]
> skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
>                               crypto_req_done, &wait);
> crypto_wait_req(crypto_skcipher_encrypt(req), &wait);

Sure, I can do this ... the crypto skcipher handling was also cut and
paste, but I forget where from this time.  So what I think you're
asking for is below as the incremental diff?  I've tested this out and
it all works fine in my session testing environment (and on my real
laptop) ... although since I'm fully sync, I won't really have tested
the -EINPROGRESS do the wait case.

James

---

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 422c3ec64f8c..bbd3e8580954 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -165,7 +165,6 @@ static void hmac_init(struct shash_desc *desc, u8 *key, int keylen)
 	int i;
 
 	desc->tfm = sha256_hash;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	crypto_shash_init(desc);
 	for (i = 0; i < sizeof(pad); i++) {
 		if (i < keylen)
@@ -244,7 +243,6 @@ static void KDFe(u8 z[EC_PT_SZ], const char *str, u8 *pt_u, u8 *pt_v,
 	__be32 c = cpu_to_be32(1);
 
 	desc->tfm = sha256_hash;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	crypto_shash_init(desc);
 	/* counter (BE) */
@@ -445,7 +443,6 @@ void tpm_buf_fill_hmac_session(struct tpm_buf *buf, struct tpm2_auth *auth)
 	auth->ordinal = head->ordinal;
 
 	desc->tfm = sha256_hash;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	cc = be32_to_cpu(head->ordinal);
 
@@ -514,10 +511,11 @@ void tpm_buf_fill_hmac_session(struct tpm_buf *buf, struct tpm2_auth *auth)
 		struct scatterlist sg[1];
 		u16 len;
 		SKCIPHER_REQUEST_ON_STACK(req, auth->aes);
+		DECLARE_CRYPTO_WAIT(wait);
 
 		skcipher_request_set_tfm(req, auth->aes);
 		skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
-					      NULL, NULL);
+					      crypto_req_done, &wait);
 
 		/* need key and IV */
 		KDFa(auth->session_key, SHA256_DIGEST_SIZE
@@ -529,7 +527,7 @@ void tpm_buf_fill_hmac_session(struct tpm_buf *buf, struct tpm2_auth *auth)
 		sg_init_one(sg, p, len);
 		skcipher_request_set_crypt(req, sg, sg, len,
 					   auth->scratch + AES_KEYBYTES);
-		crypto_skcipher_encrypt(req);
+		crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
 		/* reset p to beginning of parameters for HMAC */
 		p -= 2;
 	}
@@ -755,7 +753,6 @@ int tpm_buf_check_hmac_response(struct tpm_buf *buf, struct tpm2_auth *auth,
 	 * with rphash
 	 */
 	desc->tfm = sha256_hash;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	crypto_shash_init(desc);
 	/* yes, I know this is now zero, but it's what the standard says */
 	crypto_shash_update(desc, (u8 *)&head->return_code,
@@ -786,10 +783,11 @@ int tpm_buf_check_hmac_response(struct tpm_buf *buf, struct tpm2_auth *auth,
 	if (auth->attrs & TPM2_SA_ENCRYPT) {
 		struct scatterlist sg[1];
 		SKCIPHER_REQUEST_ON_STACK(req, auth->aes);
+		DECLARE_CRYPTO_WAIT(wait);
 
 		skcipher_request_set_tfm(req, auth->aes);
 		skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
-					      NULL, NULL);
+					      crypto_req_done, &wait);
 
 		/* need key and IV */
 		KDFa(auth->session_key, SHA256_DIGEST_SIZE
@@ -801,7 +799,7 @@ int tpm_buf_check_hmac_response(struct tpm_buf *buf, struct tpm2_auth *auth,
 		sg_init_one(sg, p, len);
 		skcipher_request_set_crypt(req, sg, sg, len,
 					   auth->scratch + AES_KEYBYTES);
-		crypto_skcipher_decrypt(req);
+		crypto_wait_req(crypto_skcipher_decrypt(req), &wait);
 	}
 
  out:
@@ -965,7 +963,6 @@ static int parse_create_primary(struct tpm_chip *chip, u8 *data)
 	tmp = resp;
 	/* now we have the public area, compute the name of the object */
 	desc->tfm = sha256_hash;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	put_unaligned_be16(TPM2_ALG_SHA256, chip->tpmkeyname);
 	crypto_shash_init(desc);
 	crypto_shash_update(desc, resp, len);
