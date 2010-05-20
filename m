From: Shikhar <shikhark@gmail.com>
Subject: Re: [PATCH] Possible bug in AUTHENC
Date: Thu, 20 May 2010 11:26:00 +0200
Message-ID: <AANLkTimSgYBqh0HxizUbCoywTZyUN9yPoCOsibQQNVRj@mail.gmail.com>
References: <AANLkTiltCjRr91OASbzzDplRp3zl5yaUnM0RKwzg3S_G@mail.gmail.com>
	<20100520051750.GB7443@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33725 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0ETJ0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 May 2010 05:26:21 -0400
Received: by wyg36 with SMTP id 36so1137217wyg.19
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2010 02:26:20 -0700 (PDT)
In-Reply-To: <20100520051750.GB7443@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: authenc - Fix "cryptlen" calculation.

This patch (applied against 2.6.34) fixes the calculation of the
length of the ABLKCIPHER decrypt request ("cryptlen") after an
asynchronous hash request has been completed in the AUTHENC interface.


Signed-off-by: Shikhar Khattar <shikhark@gmail.com>

diff -pu linux-2.6.34/crypto/authenc.c linux-2.6.34_mod/crypto/authenc.=
c

--- linux-2.6.34/crypto/authenc.c	2010-05-16 23:17:36.000000000 +0200
+++ linux-2.6.34_mod/crypto/authenc.c	2010-05-19 14:32:51.000000000 +02=
00
@@ -181,6 +181,7 @@ static void authenc_verify_ahash_update_
 	struct crypto_authenc_ctx *ctx =3D crypto_aead_ctx(authenc);
 	struct authenc_request_ctx *areq_ctx =3D aead_request_ctx(req);
 	struct ahash_request *ahreq =3D (void *)(areq_ctx->tail + ctx->reqoff=
);
+	unsigned int cryptlen =3D req->cryptlen;

 	if (err)
 		goto out;
@@ -196,6 +197,7 @@ static void authenc_verify_ahash_update_
 		goto out;

 	authsize =3D crypto_aead_authsize(authenc);
+	cryptlen -=3D authsize;
 	ihash =3D ahreq->result + authsize;
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
@@ -209,7 +211,7 @@ static void authenc_verify_ahash_update_
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
 					req->base.complete, req->base.data);
 	ablkcipher_request_set_crypt(abreq, req->src, req->dst,
-				     req->cryptlen, req->iv);
+				     cryptlen, req->iv);

 	err =3D crypto_ablkcipher_decrypt(abreq);

@@ -228,11 +230,13 @@ static void authenc_verify_ahash_done(st
 	struct crypto_authenc_ctx *ctx =3D crypto_aead_ctx(authenc);
 	struct authenc_request_ctx *areq_ctx =3D aead_request_ctx(req);
 	struct ahash_request *ahreq =3D (void *)(areq_ctx->tail + ctx->reqoff=
);
+	unsigned int cryptlen =3D req->cryptlen;

 	if (err)
 		goto out;

 	authsize =3D crypto_aead_authsize(authenc);
+	cryptlen -=3D authsize;
 	ihash =3D ahreq->result + authsize;
 	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
 				 authsize, 0);
@@ -246,7 +250,7 @@ static void authenc_verify_ahash_done(st
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
 					req->base.complete, req->base.data);
 	ablkcipher_request_set_crypt(abreq, req->src, req->dst,
-				     req->cryptlen, req->iv);
+				     cryptlen, req->iv);

 	err =3D crypto_ablkcipher_decrypt(abreq);


Thanks,
Shikhar


On Thu, May 20, 2010 at 7:17 AM, Herbert Xu <herbert@gondor.apana.org.a=
u> wrote:
> On Wed, May 19, 2010 at 03:24:24PM +0200, Shikhar wrote:
>> Hi,
>>
>> I am currently working on a driver for our crypto HW and the initial
>> aim was to offload IPSec (ESP for now) to HW. I did this by
>> registering the cipher and hash algorithms (both asynchronous)
>> separately (AES-CBC, HMAC-SHA1 only for now) and let the API handle
>> the request using the AUTHENC interface.
>>
>> The problem seems to be after the asynchronous hash request is
>> completed, the length of the ABLKCIPHER decrypt request is not
>> calculated correctly in "authenc_verify_ahash_update_done()" and
>> "authenc_verify_ahash_done()". The length should be subtracted by
>> "authsize" as done in "crypto_authenc_decrypt()".
>>
>> The following patch (applied against 2.6.34) should fix it. I hope I
>> didn't miss anything.
>
> Your patch looks good to me. =A0Could you please resubmit with
> a sign-off (see Documentation/SubmittingPatches)?
>
> Thanks!
> --
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>



--=20
There's no place like 127.0.0.1
