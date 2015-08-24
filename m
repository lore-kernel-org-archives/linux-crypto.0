From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] doc: crypto: warning cleanup
Date: Mon, 24 Aug 2015 06:51:35 +0200
Message-ID: <5137031.WPPXXLuRMs@tauon.atsec.com>
References: <20150823135101.270c6630@xps.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150823135101.270c6630@xps.lwn.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Sonntag, 23. August 2015, 13:51:01 schrieb Jonathan Corbet:

Hi Jonathan,

>Fix up a missing field description and a misdirected doc inclusion to make
>a couple of warnings go away.
>
>Signed-off-by: Jonathan Corbet <corbet@lwn.net>
>---
> Documentation/DocBook/crypto-API.tmpl | 2 +-
> include/crypto/aead.h                 | 1 +
> 2 files changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/Documentation/DocBook/crypto-API.tmpl
>b/Documentation/DocBook/crypto-API.tmpl index 0992531ffefb..980bcc994913
>100644
>--- a/Documentation/DocBook/crypto-API.tmpl
>+++ b/Documentation/DocBook/crypto-API.tmpl
>@@ -1687,7 +1687,7 @@ read(opfd, out, outlen);
> !Pinclude/linux/crypto.h Block Cipher Algorithm Definitions
> !Finclude/linux/crypto.h crypto_alg
> !Finclude/linux/crypto.h ablkcipher_alg
>-!Finclude/linux/crypto.h aead_alg
>+!Finclude/crypto/aead.h aead_alg

This one is already in the cryptodev-2.6 kernel.

>From now on, I will always CC the linux-doc mailing list on patches pertaining 
the crypto documentation so that you can see the patches too.

> !Finclude/linux/crypto.h blkcipher_alg
> !Finclude/linux/crypto.h cipher_alg
> !Finclude/crypto/rng.h rng_alg
>diff --git a/include/crypto/aead.h b/include/crypto/aead.h
>index 7169ad04acc0..88c6cdf3a886 100644
>--- a/include/crypto/aead.h
>+++ b/include/crypto/aead.h
>@@ -120,6 +120,7 @@ struct aead_givcrypt_request {
>  * @exit: Deinitialize the cryptographic transformation object. This is a
>  *	  counterpart to @init, used to remove various changes set in
>  *	  @init.
>+ * @base: Common crypto API algorithm data structure

I am wondering: does this really fix the issue? I tried it and it failed (i.e. 
still produced errors by the parser) due to the exotic definition in of this 
variable in the C code.


>  *
>  * All fields except @ivsize is mandatory and must be filled.
>  */


Ciao
Stephan
