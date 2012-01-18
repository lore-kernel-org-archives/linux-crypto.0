From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH 08/21] KEYS: Add signature verification facility [ver #3]
Date: Wed, 18 Jan 2012 13:20:54 +0200
Message-ID: <CALLzPKZFShWGxxic8zMfTxoj6Q+t7-sC90wp5J790VRmg-O09g@mail.gmail.com>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
	<20111202184406.21874.65285.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
	arjan.van.de.ven@intel.com, alan.cox@intel.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:5132 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750969Ab2ARLU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Jan 2012 06:20:56 -0500
In-Reply-To: <20111202184406.21874.65285.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 2, 2011 at 8:44 PM, David Howells <dhowells@redhat.com> wro=
te:
> Add a facility whereby a key subtype may be asked to verify a signatu=
re against
> the data it is purported to have signed.
>
> This adds four routines:
>
> =C2=A0(1) struct crypto_key_verify_context *
> =C2=A0 =C2=A0 verify_sig_begin(struct key *keyring, const void *sig, =
size_t siglen);
>
> =C2=A0 =C2=A0 This sets up a verification context for the given signa=
ture using
> =C2=A0 =C2=A0 information in that signature to select a key from the =
specified keyring
> =C2=A0 =C2=A0 and to request a hash algorithm from the crypto layer.
>
> =C2=A0(2) int verify_sig_add_data(struct crypto_key_verify_context *c=
tx,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const void *data, size_t datalen);
>
> =C2=A0 =C2=A0 Incrementally supply data to be signed. =C2=A0May be ca=
lled multiple times.
>
Hello,

It would also nice to have an API to supply pre-computed data hash.
=46or example IMA uses the same functionality to compute the hash of th=
e
file content,
and then, based on security.ima type decided either verify it using jus=
t hash,
or use digital signature.
We could pass a hash as data. But may be we do not want to have extra
operation and compute hash over hash.

- Dmitry

> =C2=A0(3) int verify_sig_end(struct crypto_key_verify_context *ctx,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0const void *sig, size_t siglen);
>
> =C2=A0 =C2=A0 Complete the verification process and return the result=
=2E =C2=A0-EKEYREJECTED
> =C2=A0 =C2=A0 will indicate that the verification failed and 0 will i=
ndicate success.
> =C2=A0 =C2=A0 Other errors are also possible.
>
> =C2=A0(4) void verify_sig_cancel(struct crypto_key_verify_context *ct=
x);
>
> =C2=A0 =C2=A0 Cancel the verification process.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
> =C2=A0Documentation/security/keys-crypto.txt | =C2=A0101 ++++++++++++=
+++++++++++++++++
> =C2=A0include/keys/crypto-subtype.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
| =C2=A0 21 ++++++
> =C2=A0include/keys/crypto-type.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | =C2=A0 =C2=A09 +++
> =C2=A0security/keys/Makefile =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 | =C2=A0 =C2=A02 -
> =C2=A0security/keys/crypto_verify.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
| =C2=A0111 ++++++++++++++++++++++++++++++++
> =C2=A05 files changed, 243 insertions(+), 1 deletions(-)
> =C2=A0create mode 100644 security/keys/crypto_verify.c
>
>
> diff --git a/Documentation/security/keys-crypto.txt b/Documentation/s=
ecurity/keys-crypto.txt
> index 97dee80..a964717 100644
> --- a/Documentation/security/keys-crypto.txt
> +++ b/Documentation/security/keys-crypto.txt
> @@ -7,6 +7,7 @@ Contents:
> =C2=A0 - Overview.
> =C2=A0 - Key identification.
> =C2=A0 - Accessing crypto keys.
> + =C2=A0 =C2=A0- Signature verification.
> =C2=A0 - Implementing crypto parsers.
> =C2=A0 - Implementing crypto subtypes.
>
> @@ -89,6 +90,65 @@ This gives access to the key type:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct key_type key_type_crypto;
>
>
> +SIGNATURE VERIFICATION
> +----------------------
> +
> +The four operations that can perform cryptographic signature verific=
ation,
> +using one of a set of keys to provide the public key:
> +
> + (1) Begin verification procedure.
> +
> + =C2=A0 =C2=A0 =C2=A0 struct crypto_key_verify_context *
> + =C2=A0 =C2=A0 =C2=A0 verify_sig_begin(struct key *keyring, const vo=
id *sig, size_t siglen);
> +
> + =C2=A0 =C2=A0 This function sets up a verification context from the=
 information in the
> + =C2=A0 =C2=A0 signature and looks for a suitable key in the keyring=
=2E =C2=A0The signature blob
> + =C2=A0 =C2=A0 must be presented again at the end of the procedure. =
=C2=A0The keys will be
> + =C2=A0 =C2=A0 checked against parameters in the signature, and if t=
he matching one is
> + =C2=A0 =C2=A0 not found then -ENOKEY will be returned.
> +
> + =C2=A0 =C2=A0 The hashing algorithm, if such a thing applies, will =
be determined from
> + =C2=A0 =C2=A0 information in the signature and the appropriate cryp=
to module will be
> + =C2=A0 =C2=A0 used. =C2=A0-ENOPKG will be returned if the hash algo=
rithm is unavailable.
> +
> + =C2=A0 =C2=A0 The return value is an opaque pointer to be passed to=
 the other functions,
> + =C2=A0 =C2=A0 or a negative error code.
> +
> + (2) Indicate data to be verified.
> +
> + =C2=A0 =C2=A0 =C2=A0 int verify_sig_add_data(struct crypto_key_veri=
fy_context *ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const void *data, size_t datalen);
> +
> + =C2=A0 =C2=A0 This function is used to shovel data to the verificat=
ion procedure so that
> + =C2=A0 =C2=A0 it can load it into the hash, pass it to hardware or =
whatever is
> + =C2=A0 =C2=A0 appropriate for the algorithm being employed.
> +
> + =C2=A0 =C2=A0 The data is not canonicalised for the document type s=
pecified in the
> + =C2=A0 =C2=A0 signature. =C2=A0The caller must do that.
> +
> + =C2=A0 =C2=A0 It will return 0 if successful and a negative error c=
ode if not.
> +
> + (3) Complete the verification process.
> +
> + =C2=A0 =C2=A0 =C2=A0 int verify_sig_end(struct crypto_key_verify_co=
ntext *ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0const void *sig, size_t siglen);
> +
> + =C2=A0 =C2=A0 This function performs the actual signature verificat=
ion step and cleans
> + =C2=A0 =C2=A0 up the resources allocated at the beginning. =C2=A0Th=
e signature must be
> + =C2=A0 =C2=A0 presented again as some of the data therein may need =
to be added to the
> + =C2=A0 =C2=A0 internal hash.
> +
> + =C2=A0 =C2=A0 It will return -EKEYREJECTED if the signature didn't =
match, 0 if
> + =C2=A0 =C2=A0 successful and may return other errors as appropriate=
=2E
> +
> + (4) Cancel the verification process.
> +
> + =C2=A0 =C2=A0 =C2=A0 void verify_sig_cancel(struct crypto_key_verif=
y_context *ctx);
> +
> + =C2=A0 =C2=A0 This function cleans up the resources allocated at th=
e beginning. =C2=A0This is
> + =C2=A0 =C2=A0 not necessary if verify_sig_end() was called.
> +
> +
> =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> =C2=A0IMPLEMENTING CRYPTO PARSERS
> =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> @@ -96,6 +156,7 @@ IMPLEMENTING CRYPTO PARSERS
> =C2=A0The crypto key type keeps a list of registered data parsers. =C2=
=A0An example of
> =C2=A0such a parser is one that parses OpenPGP packet formatted data =
[RFC 4880].
>
> +
> =C2=A0During key instantiation each parser in the list is tried until=
 one doesn't
> =C2=A0return -EBADMSG.
>
> @@ -107,6 +168,8 @@ The parser definition structure looks like the fo=
llowing:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int (*instanti=
ate)(struct key *key,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const void *data, siz=
e_t datalen);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct crypto_key_=
verify_context *(*verify_sig_begin)(
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 struct key *keyring, const u8 *sig, size_t siglen);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0};
>
> =C2=A0The owner and name fields should be set to the owning module an=
d the name of
> @@ -135,6 +198,44 @@ but it is expected that at least one will be def=
ined.
> =C2=A0 =C2=A0 =C2=A0algorithm such as RSA and DSA this will likely be=
 a printable hex version
> =C2=A0 =C2=A0 =C2=A0of the key's fingerprint.
>
> + (2) verify_sig_begin().
> +
> + =C2=A0 =C2=A0 This is similar in concept to the instantiate() funct=
ion, except that it
> + =C2=A0 =C2=A0 is given a signature blob to parse rather than a key =
data blob.
> +
> + =C2=A0 =C2=A0 If the data format is not recognised, -EBADMSG should=
 be returned. =C2=A0If it
> + =C2=A0 =C2=A0 is recognised, but the signature verification process=
 cannot for some
> + =C2=A0 =C2=A0 reason be set up, some other negative error code shou=
ld be returned.
> + =C2=A0 =C2=A0 -ENOKEY should be used to indicate that no matching k=
ey is available and
> + =C2=A0 =C2=A0 -ENOPKG should be returned if the hash algorithm or t=
he verification
> + =C2=A0 =C2=A0 algorithm are unavailable.
> +
> + =C2=A0 =C2=A0 If successful, the parser should allocate a verificat=
ion context and embed
> + =C2=A0 =C2=A0 the following struct in it:
> +
> + =C2=A0 =C2=A0 =C2=A0 struct crypto_key_verify_context {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct key *key;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int (*add_data)(st=
ruct crypto_key_verify_context *ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const void *data, size_t datalen);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int (*end)(struct =
crypto_key_verify_context *ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0const u8 *sig, size_t siglen);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void (*cancel)(str=
uct crypto_key_verify_context *ctx);
> + =C2=A0 =C2=A0 =C2=A0 };
> +
> + =C2=A0 =C2=A0 and return a pointer to this to the caller, who will =
then pass it to the
> + =C2=A0 =C2=A0 verification operation wrappers described in the "Sig=
nature Verification"
> + =C2=A0 =C2=A0 section. =C2=A0The three operation pointers here corr=
espond exactly to those
> + =C2=A0 =C2=A0 wrappers and are all mandatory. =C2=A0container_of() =
should be used to retrieve
> + =C2=A0 =C2=A0 the actual context.
> +
> + =C2=A0 =C2=A0 Note that the crypto key type retains a reference on =
the parser module for
> + =C2=A0 =C2=A0 the lifetime of this context, though the operation po=
inters need not point
> + =C2=A0 =C2=A0 into this module.
> +
> + =C2=A0 =C2=A0 The parser should also record a pointer to the key se=
lected and take a
> + =C2=A0 =C2=A0 reference on that key with key_get().
> +
> +
> =C2=A0Functions are provided to register and unregister parsers:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int register_crypto_key_parser(struct cryp=
to_key_parser *parser);
> diff --git a/include/keys/crypto-subtype.h b/include/keys/crypto-subt=
ype.h
> index fa87555..f2b927a 100644
> --- a/include/keys/crypto-subtype.h
> +++ b/include/keys/crypto-subtype.h
> @@ -20,6 +20,20 @@
> =C2=A0extern struct key_type key_type_crypto;
>
> =C2=A0/*
> + * Context base for signature verification methods. =C2=A0Allocated =
by the subtype
> + * and presumably embedded in something appropriate.
> + */
> +struct crypto_key_verify_context {
> + =C2=A0 =C2=A0 =C2=A0 struct key *key;
> + =C2=A0 =C2=A0 =C2=A0 struct crypto_key_parser *parser;
> + =C2=A0 =C2=A0 =C2=A0 int (*add_data)(struct crypto_key_verify_conte=
xt *ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 const void *data, size_t datalen);
> + =C2=A0 =C2=A0 =C2=A0 int (*end)(struct crypto_key_verify_context *c=
tx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const=
 u8 *sig, size_t siglen);
> + =C2=A0 =C2=A0 =C2=A0 void (*cancel)(struct crypto_key_verify_contex=
t *ctx);
> +};
> +
> +/*
> =C2=A0* Keys of this type declare a subtype that indicates the handle=
rs and
> =C2=A0* capabilities.
> =C2=A0*/
> @@ -48,6 +62,13 @@ struct crypto_key_parser {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Return EBADMSG if not recognised.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int (*instantiate)(struct key *key, const =
void *data, size_t datalen);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* Attempt to recognise a signature blob and f=
ind a matching key.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Return EBADMSG if not recognised.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 struct crypto_key_verify_context *(*verify_sig=
_begin)(
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct key *keyrin=
g, const u8 *sig, size_t siglen);
> =C2=A0};
>
> =C2=A0extern int register_crypto_key_parser(struct crypto_key_parser =
*);
> diff --git a/include/keys/crypto-type.h b/include/keys/crypto-type.h
> index 47c00c7..6b93366 100644
> --- a/include/keys/crypto-type.h
> +++ b/include/keys/crypto-type.h
> @@ -18,6 +18,15 @@
>
> =C2=A0extern struct key_type key_type_crypto;
>
> +struct crypto_key_verify_context;
> +extern struct crypto_key_verify_context *verify_sig_begin(
> + =C2=A0 =C2=A0 =C2=A0 struct key *key, const void *sig, size_t sigle=
n);
> +extern int verify_sig_add_data(struct crypto_key_verify_context *ctx=
,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const void *data, size_t datalen);
> +extern int verify_sig_end(struct crypto_key_verify_context *ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 const void *sig, size_t siglen);
> +extern void verify_sig_cancel(struct crypto_key_verify_context *ctx)=
;
> +
> =C2=A0/*
> =C2=A0* The payload is at the discretion of the subtype.
> =C2=A0*/
> diff --git a/security/keys/Makefile b/security/keys/Makefile
> index 67fceaa..8462904 100644
> --- a/security/keys/Makefile
> +++ b/security/keys/Makefile
> @@ -26,4 +26,4 @@ obj-$(CONFIG_TRUSTED_KEYS) +=3D trusted.o
> =C2=A0obj-$(CONFIG_ENCRYPTED_KEYS) +=3D encrypted-keys/
> =C2=A0obj-$(CONFIG_CRYPTO_KEY_TYPE) +=3D crypto_keys.o
>
> -crypto_keys-y :=3D crypto_type.o
> +crypto_keys-y :=3D crypto_type.o crypto_verify.o
> diff --git a/security/keys/crypto_verify.c b/security/keys/crypto_ver=
ify.c
> new file mode 100644
> index 0000000..65f734c
> --- /dev/null
> +++ b/security/keys/crypto_verify.c
> @@ -0,0 +1,111 @@
> +/* Signature verification with a crypto key
> + *
> + * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + *
> + * See Documentation/security/keys-crypto.txt
> + */
> +
> +#include <keys/crypto-subtype.h>
> +#include <linux/module.h>
> +#include "crypto_keys.h"
> +
> +/**
> + * verify_sig_begin - Initiate the use of a crypto key to verify a s=
ignature
> + * @keyring: The public keys to verify against
> + * @sig: The signature data
> + * @siglen: The signature length
> + *
> + * Returns a context or an error.
> + */
> +struct crypto_key_verify_context *verify_sig_begin(
> + =C2=A0 =C2=A0 =C2=A0 struct key *keyring, const void *sig, size_t s=
iglen)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct crypto_key_verify_context *ret;
> + =C2=A0 =C2=A0 =C2=A0 struct crypto_key_parser *parser;
> +
> + =C2=A0 =C2=A0 =C2=A0 pr_devel("=3D=3D>%s()\n", __func__);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (siglen =3D=3D 0 || !sig)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(-EI=
NVAL);
> +
> + =C2=A0 =C2=A0 =C2=A0 down_read(&crypto_key_parsers_sem);
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D ERR_PTR(-EBADMSG);
> + =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(parser, &crypto_key_parser=
s, link) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (parser->verify=
_sig_begin) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (!try_module_get(parser->owner))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 pr_debug("Trying parser '%s'\n", parser->name);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ret =3D parser->verify_sig_begin(keyring, sig, siglen);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (IS_ERR(ret))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 module_put(parser->owner);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret->parser =3D parser;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (ret !=3D ERR_PTR(-EBADMSG)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_debug("Parser recognised the for=
mat"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"=
 (ret %ld)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0P=
TR_ERR(ret));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 up_read(&crypto_key_parsers_sem);
> + =C2=A0 =C2=A0 =C2=A0 pr_devel("<=3D=3D%s() =3D %p\n", __func__, ret=
);
> + =C2=A0 =C2=A0 =C2=A0 return ret;
> +}
> +EXPORT_SYMBOL_GPL(verify_sig_begin);
> +
> +/**
> + * verify_sig_add_data - Incrementally provide data to be verified
> + * @ctx: The context from verify_sig_begin()
> + * @data: Data
> + * @datalen: The amount of @data
> + *
> + * This may be called multiple times.
> + */
> +int verify_sig_add_data(struct crypto_key_verify_context *ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 const void *data, size_t datalen)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return ctx->add_data(ctx, data, datalen);
> +}
> +EXPORT_SYMBOL_GPL(verify_sig_add_data);
> +
> +/**
> + * verify_sig_end - Finalise signature verification and return resul=
t
> + * @ctx: The context from verify_sig_begin()
> + * @sig: The signature data
> + * @siglen: The signature length
> + */
> +int verify_sig_end(struct crypto_key_verify_context *ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const=
 void *sig, size_t siglen)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct crypto_key_parser *parser =3D ctx->pars=
er;
> + =C2=A0 =C2=A0 =C2=A0 int ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D ctx->end(ctx, sig, siglen);
> + =C2=A0 =C2=A0 =C2=A0 module_put(parser->owner);
> + =C2=A0 =C2=A0 =C2=A0 return ret;
> +}
> +EXPORT_SYMBOL_GPL(verify_sig_end);
> +
> +/**
> + * verify_sig_end - Cancel signature verification
> + * @ctx: The context from verify_sig_begin()
> + */
> +void verify_sig_cancel(struct crypto_key_verify_context *ctx)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct crypto_key_parser *parser =3D ctx->pars=
er;
> +
> + =C2=A0 =C2=A0 =C2=A0 ctx->cancel(ctx);
> + =C2=A0 =C2=A0 =C2=A0 module_put(parser->owner);
> +}
> +EXPORT_SYMBOL_GPL(verify_sig_cancel);
>
