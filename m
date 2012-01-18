From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH 16/21] KEYS: PGP-based public key signature verification
 [ver #3]
Date: Wed, 18 Jan 2012 13:36:20 +0200
Message-ID: <CALLzPKbQb26jAqkkduSQGDDtFuNiCDf5F-HVYB-RJjF4+KLLeQ@mail.gmail.com>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
	<20111202184548.21874.69507.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
	arjan.van.de.ven@intel.com, alan.cox@intel.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:57501 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756084Ab2ARLgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Jan 2012 06:36:21 -0500
In-Reply-To: <20111202184548.21874.69507.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 2, 2011 at 8:45 PM, David Howells <dhowells@redhat.com> wro=
te:
> Provide handlers for PGP-based public-key algorithm signature verific=
ation.
> This does most of the work involved in signature verification as most=
 of it is
> public-key algorithm agnostic. =C2=A0The public-key verification algo=
rithm itself
> is just the last little bit and is supplied the complete hash data to=
 process.
>
> This requires glue logic putting on top to make use of it - something=
 the next
> patch provides.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
> =C2=A0security/keys/Makefile =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=
=A03
> =C2=A0security/keys/pgp_parser.h =C2=A0 =C2=A0 | =C2=A0 =C2=A06 +
> =C2=A0security/keys/pgp_pubkey_sig.c | =C2=A0323 ++++++++++++++++++++=
++++++++++++++++++++
> =C2=A03 files changed, 331 insertions(+), 1 deletions(-)
> =C2=A0create mode 100644 security/keys/pgp_pubkey_sig.c
>
>
> diff --git a/security/keys/Makefile b/security/keys/Makefile
> index 242a087..fc1968e 100644
> --- a/security/keys/Makefile
> +++ b/security/keys/Makefile
> @@ -34,4 +34,5 @@ obj-$(CONFIG_CRYPTO_KEY_PGP_PARSER) +=3D pgp_parser=
=2Eo
> =C2=A0crypto_keys-y :=3D crypto_type.o crypto_verify.o
>
> =C2=A0pgp_parser-y :=3D \
> - =C2=A0 =C2=A0 =C2=A0 pgp_key_parser.o
> + =C2=A0 =C2=A0 =C2=A0 pgp_key_parser.o \
> + =C2=A0 =C2=A0 =C2=A0 pgp_pubkey_sig.o
> diff --git a/security/keys/pgp_parser.h b/security/keys/pgp_parser.h
> index 1cda231..a6192ce 100644
> --- a/security/keys/pgp_parser.h
> +++ b/security/keys/pgp_parser.h
> @@ -21,3 +21,9 @@
> =C2=A0*/
> =C2=A0extern const
> =C2=A0struct public_key_algorithm *pgp_public_key_algorithms[PGP_PUBK=
EY__LAST];
> +
> +/*
> + * pgp_pubkey_sig.c
> + */
> +extern struct crypto_key_verify_context *pgp_pkey_verify_sig_begin(
> + =C2=A0 =C2=A0 =C2=A0 struct key *crypto_key, const u8 *sigdata, siz=
e_t siglen);
> diff --git a/security/keys/pgp_pubkey_sig.c b/security/keys/pgp_pubke=
y_sig.c
> new file mode 100644
> index 0000000..b4b7cb0
> --- /dev/null
> +++ b/security/keys/pgp_pubkey_sig.c
> @@ -0,0 +1,323 @@
> +/* Handling for PGP public key signature data [RFC 4880]
> + *
> + * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#define pr_fmt(fmt) "PGPSIG: "fmt
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/pgp.h>
> +#include "public_key.h"
> +#include "pgp_parser.h"
> +
> +const struct {
> + =C2=A0 =C2=A0 =C2=A0 enum pkey_hash_algo algo : 8;
> +} pgp_pubkey_hash[PGP_HASH__LAST] =3D {
> + =C2=A0 =C2=A0 =C2=A0 [PGP_HASH_MD5].algo =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =3D PKEY_HASH_MD5,
> + =C2=A0 =C2=A0 =C2=A0 [PGP_HASH_SHA1].algo =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0=3D PKEY_HASH_SHA1,
> + =C2=A0 =C2=A0 =C2=A0 [PGP_HASH_RIPE_MD_160].algo =C2=A0 =C2=A0 =3D =
PKEY_HASH_RIPE_MD_160,
> + =C2=A0 =C2=A0 =C2=A0 [PGP_HASH_SHA256].algo =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0=3D PKEY_HASH_SHA256,
> + =C2=A0 =C2=A0 =C2=A0 [PGP_HASH_SHA384].algo =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0=3D PKEY_HASH_SHA384,
> + =C2=A0 =C2=A0 =C2=A0 [PGP_HASH_SHA512].algo =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0=3D PKEY_HASH_SHA512,
> + =C2=A0 =C2=A0 =C2=A0 [PGP_HASH_SHA224].algo =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0=3D PKEY_HASH_SHA224,
> +};
> +
> +static int pgp_pkey_verify_sig_add_data(struct crypto_key_verify_con=
text *ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const v=
oid *data, size_t datalen);
> +static int pgp_pkey_verify_sig_end(struct crypto_key_verify_context =
*ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const u8 *sig, size_t =
siglen);
> +static void pgp_pkey_verify_sig_cancel(struct crypto_key_verify_cont=
ext *ctx);
> +
> +struct pgp_pkey_sig_parse_context {
> + =C2=A0 =C2=A0 =C2=A0 struct pgp_parse_context pgp;
> + =C2=A0 =C2=A0 =C2=A0 struct pgp_sig_parameters params;
> +};
> +
> +static int pgp_pkey_parse_signature(struct pgp_parse_context *contex=
t,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 enum pgp_packet_tag t=
ype,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 headerlen,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const u8 *data,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t datalen)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct pgp_pkey_sig_parse_context *ctx =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 container_of(conte=
xt, struct pgp_pkey_sig_parse_context, pgp);
> +
> + =C2=A0 =C2=A0 =C2=A0 return pgp_parse_sig_params(&data, &datalen, &=
ctx->params);
> +}
> +
> +/*
> + * Begin the process of verifying a DSA signature.
> + *
> + * This involves allocating the hash into which first the data and t=
hen the
> + * metadata will be put, and parsing the signature to check that it =
matches the
> + * key.
> + */
> +struct crypto_key_verify_context *pgp_pkey_verify_sig_begin(
> + =C2=A0 =C2=A0 =C2=A0 struct key *crypto_key, const u8 *sigdata, siz=
e_t siglen)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct pgp_pkey_sig_parse_context p;
> + =C2=A0 =C2=A0 =C2=A0 struct public_key_signature *sig;
> + =C2=A0 =C2=A0 =C2=A0 struct crypto_shash *tfm;
> + =C2=A0 =C2=A0 =C2=A0 const struct public_key *key =3D crypto_key->p=
ayload.data;
> + =C2=A0 =C2=A0 =C2=A0 size_t digest_size, desc_size;
> + =C2=A0 =C2=A0 =C2=A0 int ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 kenter("{%d},,%zu", key_serial(crypto_key), si=
glen);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!key) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kleave(" =3D -ENOK=
EY [no public key]");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(-EN=
OKEY);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 p.pgp.types_of_interest =3D (1 << PGP_PKT_SIGN=
ATURE);
> + =C2=A0 =C2=A0 =C2=A0 p.pgp.process_packet =3D pgp_pkey_parse_signat=
ure;
> + =C2=A0 =C2=A0 =C2=A0 ret =3D pgp_parse_packets(sigdata, siglen, &p.=
pgp);
> + =C2=A0 =C2=A0 =C2=A0 if (ret < 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(ret=
);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (p.params.pubkey_algo >=3D PGP_PUBKEY__LAST=
 ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !pgp_public_key_algorithms[p.par=
ams.pubkey_algo]) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_debug("Unsuppor=
ted public key algorithm %u\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0p.params.pubkey_algo);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(-EN=
OKEY);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (pgp_public_key_algorithms[p.params.pubkey_=
algo] !=3D key->algo) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kleave(" =3D -ENOK=
EY [wrong pk algo]");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(-EN=
OKEY);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!(key->capabilities & PKEY_CAN_VERIFY)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kleave(" =3D -EKEY=
REJECTED [key can't verify]");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(-EK=
EYREJECTED);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (p.params.hash_algo >=3D PGP_HASH__LAST ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !pgp_hash_algorithms[p.params.ha=
sh_algo]) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kleave(" =3D -ENOP=
KG [hash]");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(-EN=
OPKG);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 pr_debug("Signature generated with %s hash\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pgp_hash_alg=
orithms[p.params.hash_algo]);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (memcmp(&p.params.issuer, key->key_id, 8) !=
=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kleave(" =3D -ENOK=
EY [wrong key ID]");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(-EN=
OKEY);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (p.params.signature_type !=3D PGP_SIG_BINAR=
Y_DOCUMENT_SIG &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p.params.signature_type !=3D PGP=
_SIG_STANDALONE_SIG) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* We don't want t=
o canonicalise */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kleave(" =3D -EOPN=
OTSUPP [canon]");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(-EO=
PNOTSUPP);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /* Allocate the hashing algorithm we're going =
to need and find out how
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* big the hash operational data will be.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 tfm =3D crypto_alloc_shash(pgp_hash_algorithms=
[p.params.hash_algo], 0, 0);
> + =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(tfm))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PTR_ERR(tfm=
) =3D=3D -ENOENT ?
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ERR_PTR(-ENOPKG) : ERR_CAST(tfm);
> +
> + =C2=A0 =C2=A0 =C2=A0 desc_size =3D crypto_shash_descsize(tfm);
> + =C2=A0 =C2=A0 =C2=A0 digest_size =3D crypto_shash_digestsize(tfm);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* We allocate the hash operational data stora=
ge on the end of our
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* context data.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 sig =3D kzalloc(sizeof(*sig) + desc_size + dig=
est_size, GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 if (!sig) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 crypto_free_shash(=
tfm);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(-EN=
OMEM);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 sig->base.key =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =3D crypto_key;
> + =C2=A0 =C2=A0 =C2=A0 sig->base.add_data =C2=A0 =C2=A0 =C2=A0=3D pgp=
_pkey_verify_sig_add_data;
> + =C2=A0 =C2=A0 =C2=A0 sig->base.end =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =3D pgp_pkey_verify_sig_end;
> + =C2=A0 =C2=A0 =C2=A0 sig->base.cancel =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
 pgp_pkey_verify_sig_cancel;
> + =C2=A0 =C2=A0 =C2=A0 sig->pkey_hash_algo =C2=A0 =C2=A0 =3D pgp_pubk=
ey_hash[p.params.hash_algo].algo;
> + =C2=A0 =C2=A0 =C2=A0 sig->digest =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =3D (u8 *)sig + sizeof(*sig) + desc_size;
> + =C2=A0 =C2=A0 =C2=A0 sig->digest_size =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
 digest_size;
> + =C2=A0 =C2=A0 =C2=A0 sig->hash.tfm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =3D tfm;
> + =C2=A0 =C2=A0 =C2=A0 sig->hash.flags =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=
 CRYPTO_TFM_REQ_MAY_SLEEP;
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D crypto_shash_init(&sig->hash);
> + =C2=A0 =C2=A0 =C2=A0 if (ret < 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 crypto_free_shash(=
sig->hash.tfm);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(sig);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(ret=
);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 key_get(sig->base.key);
> + =C2=A0 =C2=A0 =C2=A0 kleave(" =3D %p", sig);
> + =C2=A0 =C2=A0 =C2=A0 return &sig->base;
> +}
> +
> +/*
> + * Load data into the hash
> + */
> +static int pgp_pkey_verify_sig_add_data(struct crypto_key_verify_con=
text *ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const v=
oid *data, size_t datalen)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct public_key_signature *sig =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 container_of(ctx, =
struct public_key_signature, base);
> +
> + =C2=A0 =C2=A0 =C2=A0 return crypto_shash_update(&sig->hash, data, d=
atalen);
> +}

Hello,

Synchronous hash SHASH is used only for software hash implementation...
HW acceleration is not supported by this hash.
It is good for short data.
But when calculating a hash over long data as files can be,
async hash AHASH is a preferred choice as enables HW acceleration.

As in my response to
[PATCH 08/21] KEYS: Add signature verification facility [ver #3]
It would be nice to have API to pass pre-computed hash,
then client might tackle async peculiarities by itself...

- Dmitry

> +
> +struct pgp_pkey_sig_digest_context {
> + =C2=A0 =C2=A0 =C2=A0 struct pgp_parse_context pgp;
> + =C2=A0 =C2=A0 =C2=A0 const struct public_key *key;
> + =C2=A0 =C2=A0 =C2=A0 struct public_key_signature *sig;
> +};
> +
> +/*
> + * Extract required metadata from the signature packet and add what =
we need to
> + * to the hash.
> + */
> +static int pgp_pkey_digest_signature(struct pgp_parse_context *conte=
xt,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0enum pgp_packet=
_tag type,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 headerlen,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const u8 *data,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t datalen)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct pgp_pkey_sig_digest_context *ctx =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 container_of(conte=
xt, struct pgp_pkey_sig_digest_context, pgp);
> + =C2=A0 =C2=A0 =C2=A0 enum pgp_signature_version version;
> + =C2=A0 =C2=A0 =C2=A0 int i;
> +
> + =C2=A0 =C2=A0 =C2=A0 kenter(",%u,%u,,%zu", type, headerlen, datalen=
);
> +
> + =C2=A0 =C2=A0 =C2=A0 version =3D *data;
> + =C2=A0 =C2=A0 =C2=A0 if (version =3D=3D PGP_SIG_VERSION_3) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* We just include=
 an excerpt of the metadata from a V3
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* signature.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 crypto_shash_updat=
e(&ctx->sig->hash, data + 1, 5);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 data +=3D sizeof(s=
truct pgp_signature_v3_packet);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 datalen -=3D sizeo=
f(struct pgp_signature_v3_packet);
> + =C2=A0 =C2=A0 =C2=A0 } else if (version =3D=3D PGP_SIG_VERSION_4) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* We add the whol=
e metadata header and some of the hashed data
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* for a V4 s=
ignature, plus a trailer.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t hashedsz, u=
nhashedsz;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 trailer[6];
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hashedsz =3D 4 + 2=
 + (data[4] << 8) + data[5];
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 crypto_shash_updat=
e(&ctx->sig->hash, data, hashedsz);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 trailer[0] =3D ver=
sion;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 trailer[1] =3D 0xf=
fU;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 trailer[2] =3D has=
hedsz >> 24;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 trailer[3] =3D has=
hedsz >> 16;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 trailer[4] =3D has=
hedsz >> 8;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 trailer[5] =3D has=
hedsz;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 crypto_shash_updat=
e(&ctx->sig->hash, trailer, 6);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 data +=3D hashedsz=
;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 datalen -=3D hashe=
dsz;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unhashedsz =3D 2 +=
 (data[0] << 8) + data[1];
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 data +=3D unhashed=
sz;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 datalen -=3D unhas=
hedsz;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (datalen <=3D 2) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kleave(" =3D -EBAD=
MSG");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EBADMSG;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /* There's a quick check on the hash available=
=2E */
> + =C2=A0 =C2=A0 =C2=A0 ctx->sig->signed_hash_msw[0] =3D *data++;
> + =C2=A0 =C2=A0 =C2=A0 ctx->sig->signed_hash_msw[1] =3D *data++;
> + =C2=A0 =C2=A0 =C2=A0 datalen -=3D 2;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* And then the cryptographic data, which we'l=
l need for the
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* algorithm.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < ctx->key->algo->n_sig_mpi; i=
++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int remai=
ning =3D datalen;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (remaining =3D=3D=
 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 pr_debug("short %zu mpi %d\n", datalen, i);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return -EBADMSG;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctx->sig->mpi[i] =3D=
 mpi_read_from_buffer(data, &remaining);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ctx->sig->mpi=
[i])
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return -ENOMEM;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 data +=3D remainin=
g;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 datalen -=3D remai=
ning;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (datalen !=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kleave(" =3D -EBAD=
MSG [trailer %zu]", datalen);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EBADMSG;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 kleave(" =3D 0");
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +/*
> + * The data is now all loaded into the hash; load the metadata, fina=
lise the
> + * hash and perform the verification step.
> + */
> +static int pgp_pkey_verify_sig_end(struct crypto_key_verify_context =
*ctx,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const u8 *sigdata, siz=
e_t siglen)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct public_key_signature *sig =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 container_of(ctx, =
struct public_key_signature, base);
> + =C2=A0 =C2=A0 =C2=A0 const struct public_key *key =3D sig->base.key=
->payload.data;
> + =C2=A0 =C2=A0 =C2=A0 struct pgp_pkey_sig_digest_context p;
> + =C2=A0 =C2=A0 =C2=A0 int ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 kenter("");
> +
> + =C2=A0 =C2=A0 =C2=A0 /* Firstly we add metadata, starting with some=
 of the data from the
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* signature packet */
> + =C2=A0 =C2=A0 =C2=A0 p.pgp.types_of_interest =3D (1 << PGP_PKT_SIGN=
ATURE);
> + =C2=A0 =C2=A0 =C2=A0 p.pgp.process_packet =3D pgp_pkey_digest_signa=
ture;
> + =C2=A0 =C2=A0 =C2=A0 p.key =3D key;
> + =C2=A0 =C2=A0 =C2=A0 p.sig =3D sig;
> + =C2=A0 =C2=A0 =C2=A0 ret =3D pgp_parse_packets(sigdata, siglen, &p.=
pgp);
> + =C2=A0 =C2=A0 =C2=A0 if (ret < 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto error_free_ct=
x;
> +
> + =C2=A0 =C2=A0 =C2=A0 crypto_shash_final(&sig->hash, sig->digest);
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D key->algo->verify(key, sig);
> +
> +error_free_ctx:
> + =C2=A0 =C2=A0 =C2=A0 pgp_pkey_verify_sig_cancel(ctx);
> + =C2=A0 =C2=A0 =C2=A0 kleave(" =3D %d", ret);
> + =C2=A0 =C2=A0 =C2=A0 return ret;
> +}
> +
> +/*
> + * Cancel an in-progress data loading
> + */
> +static void pgp_pkey_verify_sig_cancel(struct crypto_key_verify_cont=
ext *ctx)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct public_key_signature *sig =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 container_of(ctx, =
struct public_key_signature, base);
> + =C2=A0 =C2=A0 =C2=A0 int i;
> +
> + =C2=A0 =C2=A0 =C2=A0 kenter("");
> +
> + =C2=A0 =C2=A0 =C2=A0 /* !!! Do we need to tell the crypto layer to =
cancel too? */
> + =C2=A0 =C2=A0 =C2=A0 crypto_free_shash(sig->hash.tfm);
> + =C2=A0 =C2=A0 =C2=A0 key_put(sig->base.key);
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < ARRAY_SIZE(sig->mpi); i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpi_free(sig->mpi[=
i]);
> + =C2=A0 =C2=A0 =C2=A0 kfree(sig);
> +
> + =C2=A0 =C2=A0 =C2=A0 kleave("");
> +}
>
