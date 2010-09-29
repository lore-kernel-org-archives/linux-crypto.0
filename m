From: Roberto Sassu <roberto.sassu@polito.it>
Subject: Re: [RFC][PATCH 4/4] keys: add new key-type encrypted
Date: Wed, 29 Sep 2010 14:40:54 +0200
Message-ID: <201009291440.59445.roberto.sassu@polito.it>
References: <1285698993-16927-1-git-send-email-zohar@linux.vnet.ibm.com> <201009291200.47199.roberto.sassu@polito.it> <1285761456.4350.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2451418.pUCyeE4yDk";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1285761456.4350.11.camel@localhost.localdomain>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--nextPart2451418.pUCyeE4yDk
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday, September 29, 2010 01:57:36 pm Mimi Zohar wrote:
> On Wed, 2010-09-29 at 12:00 +0200, Roberto Sassu wrote:
> > When a new encrypted key is created through the keyctl utility, the mas=
ter
> > key specified is not searched in the keyring and the operation is perfo=
rmed even=20
> > if it is missing.
>=20
> Yes, and why is this a problem?  After creating a new key, the first
> thing done should be to save it.  At that point, you'd find out the
> master-key doesn't exist, requiring you to either load it or change the
> master-key name using 'keyctl update'.
>=20

I think the master key verification is important at least for one reason:
i suppose to have one encrypted key which depends on a trusted key unsealed
during the boot process.  If the former key is present in the keyring, this=
 does not mean
that the platform is in a good status (condition required for the unsealing=
),  since an attacker
can generate another encryption key with the same name that may be used by =
users to
encrypt their personal data.
The create check is probably wrong, what i mean is that key generation is a=
n administrative
task and trusted and encrypted keys should be usable only after decryption =
with the key=20
they depend to.


> Mimi
>=20
> > The following patch moves the master key request in the encrypted_init(=
) function,=20
> > in order to deny a new key creation if the former is not present.
> >=20
> >=20
> > Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> > ---
> >  security/keys/encrypted_defined.c |   23 +++++++++++++----------
> >  1 files changed, 13 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypte=
d_defined.c
> > index 6b26db6..48e627e 100644
> > --- a/security/keys/encrypted_defined.c
> > +++ b/security/keys/encrypted_defined.c
> > @@ -491,12 +491,10 @@ static struct encrypted_key_payload *encrypted_ke=
y_alloc(struct key *key,
> >  }
> > =20
> >  static int encrypted_key_decrypt(struct encrypted_key_payload *epayloa=
d,
> > -				 char *hex_encoded_iv, char *hex_encoded_data)
> > +				 char *hex_encoded_iv, char *hex_encoded_data,
> > +				 void *master_key, unsigned int master_keylen)
> >  {
> >  	char derived_key[hash_size];
> > -	struct key *mkey;
> > -	void *master_key;
> > -	unsigned int master_keylen;
> >  	size_t encrypted_datalen;
> >  	char *hmac;
> >  	int ret;
> > @@ -508,10 +506,6 @@ static int encrypted_key_decrypt(struct encrypted_=
key_payload *epayload,
> >  	hmac =3D epayload->master_desc + epayload->datablob_len;
> >  	hex2bin(hmac, hex_encoded_data + (encrypted_datalen * 2), hash_size);
> > =20
> > -	mkey =3D request_master_key(epayload, &master_key, &master_keylen);
> > -	if (IS_ERR(mkey))
> > -		return PTR_ERR(mkey);
> > -
> >  	ret =3D datablob_hmac_verify(epayload, master_key, master_keylen);
> >  	if (ret) {
> >  		pr_err("encrypted_key: bad hmac (%d)\n", ret);
> > @@ -527,7 +521,6 @@ static int encrypted_key_decrypt(struct encrypted_k=
ey_payload *epayload,
> >  	if (ret)
> >  		pr_err("encrypted_key: failed to decrypt key (%d)\n", ret);
> >  out:
> > -	key_put(mkey);
> >  	return ret;
> >  }
> > =20
> > @@ -555,8 +548,16 @@ static int encrypted_init(struct encrypted_key_pay=
load *epayload,
> >  			  char *hex_encoded_iv, char *hex_encoded_data)
> >  {
> >  	int ret =3D 0;
> > +	struct key *mkey;
> > +	void *master_key;
> > +	unsigned int master_keylen;
> > =20
> >  	__ekey_init(epayload, master_desc, datalen);
> > +
> > +	mkey =3D request_master_key(epayload, &master_key, &master_keylen);
> > +	if (IS_ERR(mkey))
> > +		return PTR_ERR(mkey);
> > +=09
> >  	if (!hex_encoded_data) {
> >  		get_random_bytes(epayload->iv, ivsize);
> > =20
> > @@ -564,7 +565,9 @@ static int encrypted_init(struct encrypted_key_payl=
oad *epayload,
> >  				 epayload->decrypted_datalen);
> >  	} else
> >  		ret =3D encrypted_key_decrypt(epayload, hex_encoded_iv,
> > -					    hex_encoded_data);
> > +					    hex_encoded_data, master_key, master_keylen);
> > +
> > +	key_put(mkey);
> >  	return ret;
> >  }
> > =20
> > > Defines a new kernel key-type called 'encrypted'. Encrypted keys are
> > > kernel generated random numbers, which are encrypted/decrypted with
> > > a 'trusted' symmetric key. Encrypted keys are created/encrypted/decry=
pted
> > > in the kernel.  Userspace only ever sees/stores encrypted blobs.
> > >=20
> > > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > > Signed-off-by: David Safford <safford@watson.ibm.com>
> > > ---
> > >  include/keys/encrypted-type.h     |   30 ++
> > >  security/Kconfig                  |   17 +
> > >  security/keys/Makefile            |    1 +
> > >  security/keys/encrypted_defined.c |  781 +++++++++++++++++++++++++++=
++++++++++
> > >  security/keys/encrypted_defined.h |   52 +++
> > >  5 files changed, 881 insertions(+), 0 deletions(-)
> > >  create mode 100644 include/keys/encrypted-type.h
> > >  create mode 100644 security/keys/encrypted_defined.c
> > >  create mode 100644 security/keys/encrypted_defined.h
> > >=20
> > > diff --git a/include/keys/encrypted-type.h b/include/keys/encrypted-t=
ype.h
> > > new file mode 100644
> > > index 0000000..e2312e0
> > > --- /dev/null
> > > +++ b/include/keys/encrypted-type.h
> > > @@ -0,0 +1,30 @@
> > > +/* encrypted-type.h: encrypted-defined key type
> > > + *
> > > + * Copyright (C) 2010 IBM Corporation
> > > + * Author: Mimi Zohar <zohar@us.ibm.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or mod=
ify
> > > + * it under the terms of the GNU General Public License as published=
 by
> > > + * the Free Software Foundation, version 2 of the License.
> > > + */
> > > +
> > > +#ifndef _KEYS_ENCRYPTED_TYPE_H
> > > +#define _KEYS_ENCRYPTED_TYPE_H
> > > +
> > > +#include <linux/key.h>
> > > +#include <linux/rcupdate.h>
> > > +
> > > +struct encrypted_key_payload {
> > > +	struct rcu_head rcu;	/* RCU destructor */
> > > +	char *master_desc;	/* datablob: master key name */
> > > +	char *datalen;		/* datablob: decrypted key length */
> > > +	void *iv;		/* datablob: iv */
> > > +	void *encrypted_data;	/* datablob: encrypted key */
> > > +	unsigned short datablob_len;	/* length of datablob */
> > > +	unsigned short decrypted_datalen;	/* decrypted data length */
> > > +	char decrypted_data[0];	/* decrypted data +  datablob + hmac */
> > > +};
> > > +
> > > +extern struct key_type key_type_encrypted;
> > > +
> > > +#endif /* _KEYS_ENCRYPTED_TYPE_H */
> > > diff --git a/security/Kconfig b/security/Kconfig
> > > index f9681e5..b03187d 100644
> > > --- a/security/Kconfig
> > > +++ b/security/Kconfig
> > > @@ -37,6 +37,23 @@ config TRUSTED_KEYS
> > > =20
> > >  	  If you are unsure as to whether this is required, answer N.
> > > =20
> > > +config ENCRYPTED_KEYS
> > > +	tristate "ENCRYPTED KEYS"
> > > +	depends on KEYS && TRUSTED_KEYS
> > > +	select LIBCRC32C
> > > +	select CONFIG_CRYPTO_AES
> > > +	select CRYPTO_HMAC
> > > +	select CRYPTO_SHA256
> > > +	select BLOCK_CBC
> > > +	help
> > > +	  This option provides support for create/encrypting/decrypting keys
> > > +	  in the kernel.  Encrypted keys are kernel generated random number=
s,
> > > +	  which are encrypted/decrypted with a 'master' symmetric key. The
> > > +	  'master' key can be either a trusted-key or user-key type.
> > > +	  Userspace only ever sees/stores encrypted blobs.
> > > +
> > > +	  If you are unsure as to whether this is required, answer N.
> > > +
> > >  config KEYS_DEBUG_PROC_KEYS
> > >  	bool "Enable the /proc/keys file by which keys may be viewed"
> > >  	depends on KEYS
> > > diff --git a/security/keys/Makefile b/security/keys/Makefile
> > > index fcb1070..6c94105 100644
> > > --- a/security/keys/Makefile
> > > +++ b/security/keys/Makefile
> > > @@ -14,6 +14,7 @@ obj-y :=3D \
> > >  	user_defined.o
> > > =20
> > >  obj-$(CONFIG_TRUSTED_KEYS) +=3D trusted_defined.o
> > > +obj-$(CONFIG_ENCRYPTED_KEYS) +=3D encrypted_defined.o
> > >  obj-$(CONFIG_KEYS_COMPAT) +=3D compat.o
> > >  obj-$(CONFIG_PROC_FS) +=3D proc.o
> > >  obj-$(CONFIG_SYSCTL) +=3D sysctl.o
> > > diff --git a/security/keys/encrypted_defined.c b/security/keys/encryp=
ted_defined.c
> > > new file mode 100644
> > > index 0000000..6b26db6
> > > --- /dev/null
> > > +++ b/security/keys/encrypted_defined.c
> > > @@ -0,0 +1,781 @@
> > > +/*
> > > + * Copyright (C) 2010 IBM Corporation
> > > + *
> > > + * Author:
> > > + * Mimi Zohar <zohar@us.ibm.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or mod=
ify
> > > + * it under the terms of the GNU General Public License as published=
 by
> > > + * the Free Software Foundation, version 2 of the License.
> > > + *
> > > + * File: encrypted_defined.c
> > > + *
> > > + * Defines a new kernel key-type called 'encrypted'. Encrypted keys
> > > + * are kernel generated random numbers, which are encrypted/decrypted
> > > + * using a 'master' key. The 'master' key can either be a trusted-ke=
y or
> > > + * user-key type. Encrypted keys are created/encrypted/decrypted in =
the
> > > + * kernel. Userspace ever only sees/stores encrypted blobs.
> > > + *
> > > + * keyctl add "encrypted" "name" "NEW master-key-name keylen" ring
> > > + * keyctl add "encrypted" "name" "LOAD master-key-name keylen hex_bl=
ob" ring
> > > + * keyctl update keyid "UPDATE master-key-name"
> > > + */
> > > +
> > > +#include <linux/uaccess.h>
> > > +#include <linux/module.h>
> > > +#include <linux/init.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/parser.h>
> > > +#include <linux/string.h>
> > > +#include <keys/user-type.h>
> > > +#include <keys/trusted-type.h>
> > > +#include <keys/encrypted-type.h>
> > > +#include <linux/key-type.h>
> > > +#include <linux/random.h>
> > > +#include <linux/rcupdate.h>
> > > +#include <linux/scatterlist.h>
> > > +#include <linux/crypto.h>
> > > +#include <crypto/sha.h>
> > > +#include <crypto/aes.h>
> > > +
> > > +#include "encrypted_defined.h"
> > > +
> > > +static char hash_alg[] =3D "sha256";
> > > +static char hmac_alg[] =3D "hmac(sha256)";
> > > +static int hash_size =3D SHA256_DIGEST_SIZE;
> > > +static char blkcipher_alg[] =3D "cbc(aes)";
> > > +static int ivsize;
> > > +static int blksize;
> > > +
> > > +static int aes_get_sizes(int *ivsize, int *blksize)
> > > +{
> > > +	struct crypto_blkcipher *tfm;
> > > +
> > > +	tfm =3D crypto_alloc_blkcipher(blkcipher_alg, 0, CRYPTO_ALG_ASYNC);
> > > +	if (IS_ERR(tfm)) {
> > > +		pr_err("encrypted_key: failed to alloc_cipher (%ld)\n",
> > > +		       PTR_ERR(tfm));
> > > +		return PTR_ERR(tfm);
> > > +	}
> > > +	*ivsize =3D crypto_blkcipher_ivsize(tfm);
> > > +	*blksize =3D crypto_blkcipher_blocksize(tfm);
> > > +	crypto_free_blkcipher(tfm);
> > > +	return 0;
> > > +}
> > > +
> > > +enum {
> > > +	Opt_err =3D -1, Opt_new =3D 1, Opt_load, Opt_NEW, Opt_LOAD
> > > +};
> > > +
> > > +static match_table_t key_tokens =3D {
> > > +	{Opt_new, "new"},
> > > +	{Opt_NEW, "NEW"},
> > > +	{Opt_load, "load"},
> > > +	{Opt_LOAD, "LOAD"},
> > > +	{Opt_err, NULL}
> > > +};
> > > +
> > > +/*
> > > + * datablob_parse - parse the keyctl data
> > > + *
> > > + * datablob format:
> > > + * NEW <master-key name> <decrypted data length>
> > > + * LOAD <master-key name> <decrypted data length> <encrypted iv + da=
ta>
> > > + *
> > > + * Tokenizes a copy of the keyctl data, returning a pointer to each =
token,
> > > + * which is null terminated.
> > > + *
> > > + * On success returns 0, otherwise -EINVAL.
> > > + */
> > > +static int datablob_parse(char *datablob, char **master_desc,
> > > +			  char **decrypted_datalen, char **hex_encoded_iv,
> > > +			  char **hex_encoded_data)
> > > +{
> > > +	substring_t args[MAX_OPT_ARGS];
> > > +	int ret =3D -EINVAL;
> > > +	int key_cmd;
> > > +	char *p;
> > > +
> > > +	p =3D strsep(&datablob, " \t");
> > > +	if (!p)
> > > +		return ret;
> > > +	key_cmd =3D match_token(p, key_tokens, args);
> > > +
> > > +	*master_desc =3D strsep(&datablob, " \t");
> > > +	if (!*master_desc)
> > > +		goto out;
> > > +	*decrypted_datalen =3D strsep(&datablob, " \t");
> > > +	if (!*decrypted_datalen)
> > > +		goto out;
> > > +
> > > +	switch (key_cmd) {
> > > +	case Opt_new:
> > > +	case Opt_NEW:
> > > +		ret =3D 0;
> > > +		break;
> > > +	case Opt_load:
> > > +	case Opt_LOAD:
> > > +		*hex_encoded_iv =3D strsep(&datablob, " \t");
> > > +		if (!*hex_encoded_iv)
> > > +			break;
> > > +		*hex_encoded_data =3D *hex_encoded_iv + (2 * ivsize) + 2;
> > > +		ret =3D 0;
> > > +		break;
> > > +	case Opt_err:
> > > +		break;
> > > +	}
> > > +out:
> > > +	return ret;
> > > +}
> > > +
> > > +/* datablob_format - format as an ascii string, before copying to us=
erspace */
> > > +static int datablob_format(char __user *buffer,
> > > +			   struct encrypted_key_payload *epayload,
> > > +			   int asciiblob_len)
> > > +{
> > > +	char *ascii_buf, *bufp;
> > > +	char *iv =3D (char *)epayload->iv;
> > > +	int ret =3D 0;
> > > +	int len;
> > > +	int i;
> > > +
> > > +	ascii_buf =3D kzalloc(asciiblob_len + 1, GFP_KERNEL);
> > > +	if (!ascii_buf)
> > > +		return -ENOMEM;
> > > +
> > > +	len =3D sprintf(ascii_buf, "%s %s ", epayload->master_desc,
> > > +		      epayload->datalen);
> > > +
> > > +	/* convert the hex encoded iv, encrypted-data and HMAC to ascii */
> > > +	bufp =3D &ascii_buf[len];
> > > +	for (i =3D 0; i < (asciiblob_len - len) / 2; i++)
> > > +		bufp =3D pack_hex_byte(bufp, iv[i]);
> > > +
> > > +	if (copy_to_user(buffer, ascii_buf, asciiblob_len) !=3D 0)
> > > +		ret =3D -EFAULT;
> > > +	kfree(ascii_buf);
> > > +	return ret;
> > > +}
> > > +
> > > +/*
> > > + * request_trusted_key - request the trusted key
> > > + *
> > > + * Trusted keys are sealed to PCRs and other metadata. Although user=
space
> > > + * manages both trusted/encrypted key-types, like the encrypted key =
type
> > > + * data, trusted key type data is not visible decrypted from userspa=
ce.
> > > + */
> > > +static struct key *request_trusted_key(char *trusted_desc, void **ma=
ster_key,
> > > +				       unsigned int *master_keylen)
> > > +{
> > > +	struct trusted_key_payload *tpayload;
> > > +	struct key *tkey;
> > > +
> > > +	tkey =3D request_key(&key_type_trusted, trusted_desc, NULL);
> > > +	if (IS_ERR(tkey))
> > > +		goto error;
> > > +
> > > +	tpayload =3D tkey->payload.data;
> > > +	*master_key =3D tpayload->key;
> > > +	*master_keylen =3D tpayload->key_len;
> > > +error:
> > > +	return tkey;
> > > +}
> > > +
> > > +/*
> > > + * request_user_key - request the user key
> > > + *
> > > + * Use a user provided key to encrypt/decrypt an encrypted-key.
> > > + */
> > > +static struct key *request_user_key(char *master_desc, void **master=
_key,
> > > +				    unsigned int *master_keylen)
> > > +{
> > > +	struct user_key_payload *upayload;
> > > +	struct key *ukey;
> > > +
> > > +	ukey =3D request_key(&key_type_user, master_desc, NULL);
> > > +	if (IS_ERR(ukey))
> > > +		goto error;
> > > +
> > > +	upayload =3D ukey->payload.data;
> > > +	*master_key =3D upayload->data;
> > > +	*master_keylen =3D (unsigned int)upayload->datalen;
> > > +error:
> > > +	return ukey;
> > > +}
> > > +
> > > +static int init_desc(struct hash_desc *desc, char *alg)
> > > +{
> > > +	int ret;
> > > +
> > > +	desc->tfm =3D crypto_alloc_hash(alg, 0, CRYPTO_ALG_ASYNC);
> > > +	if (IS_ERR(desc->tfm)) {
> > > +		pr_info("encrypted_key: failed to load %s transform: %ld\n",
> > > +			alg, PTR_ERR(desc->tfm));
> > > +		ret =3D PTR_ERR(desc->tfm);
> > > +		return ret;
> > > +	}
> > > +	desc->flags =3D 0;
> > > +	ret =3D crypto_hash_init(desc);
> > > +	if (ret)
> > > +		crypto_free_hash(desc->tfm);
> > > +	return ret;
> > > +}
> > > +
> > > +static int calc_hmac(char *digest, char *key, int keylen,
> > > +		     char *buf, size_t buflen)
> > > +{
> > > +	struct hash_desc desc;
> > > +	struct scatterlist sg[1];
> > > +	int ret;
> > > +
> > > +	ret =3D init_desc(&desc, hmac_alg);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	crypto_hash_setkey(desc.tfm, key, keylen);
> > > +	ret =3D crypto_hash_init(&desc);
> > > +	if (ret)
> > > +		goto out;
> > > +
> > > +	sg_init_one(sg, buf, buflen);
> > > +	ret =3D crypto_hash_update(&desc, sg, buflen);
> > > +	if (!ret)
> > > +		ret =3D crypto_hash_final(&desc, digest);
> > > +out:
> > > +	crypto_free_hash(desc.tfm);
> > > +	return ret;
> > > +}
> > > +
> > > +static int calc_hash(char *digest, void *buf, int buflen)
> > > +{
> > > +	struct hash_desc desc;
> > > +	struct scatterlist sg[1];
> > > +	int ret;
> > > +
> > > +	ret =3D init_desc(&desc, hash_alg);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	sg_init_one(sg, buf, buflen);
> > > +	ret =3D crypto_hash_update(&desc, sg, buflen);
> > > +	if (!ret)
> > > +		ret =3D crypto_hash_final(&desc, digest);
> > > +	crypto_free_hash(desc.tfm);
> > > +	return ret;
> > > +}
> > > +
> > > +enum derived_key_type { ENC_KEY, AUTH_KEY };
> > > +
> > > +/* Derive authentication/encryption key from trusted key */
> > > +static int get_derived_key(char *derived_key, enum derived_key_type =
key_type,
> > > +			   void *master_key, unsigned int master_keylen)
> > > +{
> > > +	char derived_buf[hash_size + 10];
> > > +	int ret;
> > > +
> > > +	memset(derived_buf, 0, sizeof derived_buf);
> > > +	if (key_type)
> > > +		strcpy(derived_buf, "AUTH_KEY");
> > > +	else
> > > +		strcpy(derived_buf, "ENC_KEY");
> > > +
> > > +	memcpy(derived_buf + strlen(derived_buf) + 1, master_key,
> > > +	       master_keylen);
> > > +	ret =3D calc_hash(derived_key, derived_buf, sizeof derived_buf);
> > > +	return ret;
> > > +}
> > > +
> > > +static int init_blkcipher_desc(struct blkcipher_desc *desc, const vo=
id *key,
> > > +			       unsigned int key_len, void *iv, int ivsize)
> > > +{
> > > +	int ret;
> > > +
> > > +	desc->tfm =3D crypto_alloc_blkcipher(blkcipher_alg, 0, CRYPTO_ALG_A=
SYNC);
> > > +	if (IS_ERR(desc->tfm)) {
> > > +		pr_err("encrypted_key: failed to load %s transform (%ld)\n",
> > > +		       blkcipher_alg, PTR_ERR(desc->tfm));
> > > +		return PTR_ERR(desc->tfm);
> > > +	}
> > > +	desc->flags =3D 0;
> > > +
> > > +	ret =3D crypto_blkcipher_setkey(desc->tfm, key, key_len);
> > > +	if (ret) {
> > > +		pr_err("encrypted_key: failed to setkey (%d)\n", ret);
> > > +		crypto_free_blkcipher(desc->tfm);
> > > +		return ret;
> > > +	}
> > > +	crypto_blkcipher_set_iv(desc->tfm, iv, ivsize);
> > > +	return 0;
> > > +}
> > > +
> > > +static struct key *request_master_key(struct encrypted_key_payload *=
epayload,
> > > +				      void **master_key,
> > > +				      unsigned int *master_keylen)
> > > +{
> > > +	struct key *mkey;
> > > +
> > > +	mkey =3D request_trusted_key(epayload->master_desc,
> > > +				   master_key, master_keylen);
> > > +	if (IS_ERR(mkey)) {
> > > +		mkey =3D request_user_key(epayload->master_desc,
> > > +					master_key, master_keylen);
> > > +		if (IS_ERR(mkey)) {
> > > +			pr_info("encrypted_key: trusted/user key %s not found",
> > > +				epayload->master_desc);
> > > +			return mkey;
> > > +		}
> > > +	}
> > > +	dump_master_key(*master_key, *master_keylen);
> > > +	return mkey;
> > > +}
> > > +
> > > +/* Before returning data to userspace, encrypt decrypted data. */
> > > +static int derived_key_encrypt(struct encrypted_key_payload *epayloa=
d,
> > > +			       void *derived_key, unsigned int derived_keylen)
> > > +{
> > > +	struct scatterlist sg_in[2];
> > > +	struct scatterlist sg_out[1];
> > > +	struct blkcipher_desc desc;
> > > +	unsigned int encrypted_datalen;
> > > +	unsigned int padlen;
> > > +	char pad[16];
> > > +	int ret;
> > > +
> > > +	encrypted_datalen =3D roundup(epayload->decrypted_datalen, blksize);
> > > +	padlen =3D encrypted_datalen - epayload->decrypted_datalen;
> > > +
> > > +	ret =3D init_blkcipher_desc(&desc, derived_key, derived_keylen,
> > > +				  epayload->iv, ivsize);
> > > +	if (ret)
> > > +		goto out;
> > > +	dump_decrypted_data(epayload);
> > > +
> > > +	memset(pad, 0, sizeof pad);
> > > +	sg_init_table(sg_in, 2);
> > > +	sg_set_buf(&sg_in[0], epayload->decrypted_data,
> > > +		   epayload->decrypted_datalen);
> > > +	sg_set_buf(&sg_in[1], pad, padlen);
> > > +
> > > +	sg_init_table(sg_out, 1);
> > > +	sg_set_buf(sg_out, epayload->encrypted_data, encrypted_datalen);
> > > +
> > > +	ret =3D crypto_blkcipher_encrypt(&desc, sg_out, sg_in, encrypted_da=
talen);
> > > +	crypto_free_blkcipher(desc.tfm);
> > > +	if (ret)
> > > +		pr_err("encrypted_key: failed to encrypt (%d)\n", ret);
> > > +	else
> > > +		dump_encrypted_data(epayload, encrypted_datalen);
> > > +out:
> > > +	return ret;
> > > +}
> > > +
> > > +static int datablob_hmac_append(struct encrypted_key_payload *epaylo=
ad,
> > > +				void *master_key, unsigned int master_keylen)
> > > +{
> > > +	char derived_key[hash_size];
> > > +	char *digest;
> > > +	int ret;
> > > +
> > > +	memset(derived_key, 0, sizeof derived_key);
> > > +	ret =3D get_derived_key(derived_key, AUTH_KEY, master_key, master_k=
eylen);
> > > +	if (ret)
> > > +		goto out;
> > > +
> > > +	digest =3D epayload->master_desc + epayload->datablob_len;
> > > +	ret =3D calc_hmac(digest, derived_key, sizeof derived_key,
> > > +			epayload->master_desc, epayload->datablob_len);
> > > +	if (!ret)
> > > +		dump_hmac(NULL, digest, hash_size);
> > > +out:
> > > +	return ret;
> > > +}
> > > +
> > > +/* verify HMAC before decrypting encrypted key */
> > > +static int datablob_hmac_verify(struct encrypted_key_payload *epaylo=
ad,
> > > +				void *master_key, unsigned int master_keylen)
> > > +{
> > > +	char derived_key[hash_size];
> > > +	char digest[hash_size];
> > > +	int ret;
> > > +
> > > +	memset(derived_key, 0, sizeof derived_key);
> > > +	ret =3D get_derived_key(derived_key, AUTH_KEY, master_key, master_k=
eylen);
> > > +	if (ret)
> > > +		goto out;
> > > +
> > > +	memset(digest, 0, sizeof digest);
> > > +	ret =3D calc_hmac(digest, derived_key, sizeof derived_key,
> > > +			epayload->master_desc, epayload->datablob_len);
> > > +	if (ret)
> > > +		goto out;
> > > +	ret =3D memcmp(digest, epayload->master_desc + epayload->datablob_l=
en,
> > > +		     sizeof digest);
> > > +	if (ret) {
> > > +		dump_hmac("datablob",
> > > +			  epayload->master_desc + epayload->datablob_len,
> > > +			  hash_size);
> > > +		dump_hmac("calc", digest, hash_size);
> > > +	}
> > > +out:
> > > +	return ret;
> > > +}
> > > +
> > > +static int derived_key_decrypt(struct encrypted_key_payload *epayloa=
d,
> > > +			       void *derived_key, unsigned int derived_keylen)
> > > +{
> > > +	struct scatterlist sg_in[1];
> > > +	struct scatterlist sg_out[2];
> > > +	struct blkcipher_desc desc;
> > > +	unsigned int encrypted_datalen;
> > > +	char pad[16];
> > > +	int ret;
> > > +
> > > +	encrypted_datalen =3D roundup(epayload->decrypted_datalen, blksize);
> > > +	ret =3D init_blkcipher_desc(&desc, derived_key, derived_keylen,
> > > +				  epayload->iv, ivsize);
> > > +	if (ret)
> > > +		goto out;
> > > +	dump_encrypted_data(epayload, encrypted_datalen);
> > > +
> > > +	memset(pad, 0, sizeof pad);
> > > +	sg_init_table(sg_in, 1);
> > > +	sg_init_table(sg_out, 2);
> > > +	sg_set_buf(sg_in, epayload->encrypted_data, encrypted_datalen);
> > > +	sg_set_buf(&sg_out[0], epayload->decrypted_data,
> > > +		   (unsigned int)epayload->decrypted_datalen);
> > > +	sg_set_buf(&sg_out[1], pad, sizeof pad);
> > > +
> > > +	ret =3D crypto_blkcipher_decrypt(&desc, sg_out, sg_in, encrypted_da=
talen);
> > > +	crypto_free_blkcipher(desc.tfm);
> > > +	if (ret)
> > > +		goto out;
> > > +	dump_decrypted_data(epayload);
> > > +out:
> > > +	return ret;
> > > +}
> > > +
> > > +/* Allocate memory for decrypted key and datablob. */
> > > +static struct encrypted_key_payload *encrypted_key_alloc(struct key =
*key,
> > > +							 const char *master_desc,
> > > +							 char *datalen)
> > > +{
> > > +	struct encrypted_key_payload *epayload =3D NULL;
> > > +	unsigned short datablob_len;
> > > +	unsigned short decrypted_datalen;
> > > +	size_t encrypted_datalen;
> > > +	long dlen;
> > > +	int ret;
> > > +
> > > +	ret =3D strict_strtol(datalen, 10, &dlen);
> > > +	if (ret < 0 || dlen < 20 || dlen > hash_size)
> > > +		return ERR_PTR(-EINVAL);
> > > +
> > > +	decrypted_datalen =3D (unsigned short)dlen;
> > > +	encrypted_datalen =3D roundup(decrypted_datalen, blksize);
> > > +
> > > +	datablob_len =3D strlen(master_desc) + 1 + strlen(datalen) + 1
> > > +	    + ivsize + 1 + encrypted_datalen;
> > > +
> > > +	ret =3D key_payload_reserve(key, decrypted_datalen + datablob_len);
> > > +	if (ret < 0)
> > > +		return ERR_PTR(ret);
> > > +
> > > +	epayload =3D kzalloc(sizeof(*epayload) + decrypted_datalen +
> > > +			   datablob_len + hash_size + 1, GFP_KERNEL);
> > > +	if (!epayload)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	epayload->decrypted_datalen =3D decrypted_datalen;
> > > +	epayload->datablob_len =3D datablob_len;
> > > +	return epayload;
> > > +}
> > > +
> > > +static int encrypted_key_decrypt(struct encrypted_key_payload *epayl=
oad,
> > > +				 char *hex_encoded_iv, char *hex_encoded_data)
> > > +{
> > > +	char derived_key[hash_size];
> > > +	struct key *mkey;
> > > +	void *master_key;
> > > +	unsigned int master_keylen;
> > > +	size_t encrypted_datalen;
> > > +	char *hmac;
> > > +	int ret;
> > > +
> > > +	encrypted_datalen =3D roundup(epayload->decrypted_datalen, blksize);
> > > +	hex2bin(epayload->iv, hex_encoded_iv, ivsize);
> > > +	hex2bin(epayload->encrypted_data, hex_encoded_data, encrypted_datal=
en);
> > > +
> > > +	hmac =3D epayload->master_desc + epayload->datablob_len;
> > > +	hex2bin(hmac, hex_encoded_data + (encrypted_datalen * 2), hash_size=
);
> > > +
> > > +	mkey =3D request_master_key(epayload, &master_key, &master_keylen);
> > > +	if (IS_ERR(mkey))
> > > +		return PTR_ERR(mkey);
> > > +
> > > +	ret =3D datablob_hmac_verify(epayload, master_key, master_keylen);
> > > +	if (ret) {
> > > +		pr_err("encrypted_key: bad hmac (%d)\n", ret);
> > > +		goto out;
> > > +	}
> > > +
> > > +	memset(derived_key, 0, sizeof derived_key);
> > > +	ret =3D get_derived_key(derived_key, ENC_KEY, master_key, master_ke=
ylen);
> > > +	if (ret)
> > > +		goto out;
> > > +
> > > +	ret =3D derived_key_decrypt(epayload, derived_key, sizeof derived_k=
ey);
> > > +	if (ret)
> > > +		pr_err("encrypted_key: failed to decrypt key (%d)\n", ret);
> > > +out:
> > > +	key_put(mkey);
> > > +	return ret;
> > > +}
> > > +
> > > +static void __ekey_init(struct encrypted_key_payload *epayload,
> > > +			char *master_desc, char *datalen)
> > > +{
> > > +	epayload->master_desc =3D epayload->decrypted_data
> > > +	    + epayload->decrypted_datalen;
> > > +	epayload->datalen =3D epayload->master_desc + strlen(master_desc) +=
 1;
> > > +	epayload->iv =3D epayload->datalen + strlen(datalen) + 1;
> > > +	epayload->encrypted_data =3D epayload->iv + ivsize + 1;
> > > +
> > > +	memcpy(epayload->master_desc, master_desc, strlen(master_desc));
> > > +	memcpy(epayload->datalen, datalen, strlen(datalen));
> > > +}
> > > +
> > > +/*
> > > + * encrypted_init - initialize an encrypted key
> > > + *
> > > + * For a new key, use a random number for both the iv and data
> > > + * itself.  For an old key, decrypt the hex encoded data.
> > > + */
> > > +static int encrypted_init(struct encrypted_key_payload *epayload,
> > > +			  char *master_desc, char *datalen,
> > > +			  char *hex_encoded_iv, char *hex_encoded_data)
> > > +{
> > > +	int ret =3D 0;
> > > +
> > > +	__ekey_init(epayload, master_desc, datalen);
> > > +	if (!hex_encoded_data) {
> > > +		get_random_bytes(epayload->iv, ivsize);
> > > +
> > > +		get_random_bytes(epayload->decrypted_data,
> > > +				 epayload->decrypted_datalen);
> > > +	} else
> > > +		ret =3D encrypted_key_decrypt(epayload, hex_encoded_iv,
> > > +					    hex_encoded_data);
> > > +	return ret;
> > > +}
> > > +
> > > +/*
> > > + * encrypted_instantiate - instantiate an encrypted key
> > > + *
> > > + * Decrypt an existing encrypted datablob or create a new encrypted =
key
> > > + * based on a kernel random number.
> > > + *
> > > + * On success, return 0. Otherwise return errno.
> > > + */
> > > +static int encrypted_instantiate(struct key *key, const void *data,
> > > +				 size_t datalen)
> > > +{
> > > +	struct encrypted_key_payload *epayload =3D NULL;
> > > +	char *datablob =3D NULL;
> > > +	char *master_desc =3D NULL;
> > > +	char *decrypted_datalen =3D NULL;
> > > +	char *hex_encoded_iv =3D NULL;
> > > +	char *hex_encoded_data =3D NULL;
> > > +	int ret;
> > > +
> > > +	if (datalen <=3D 0 || datalen > 32767 || !data)
> > > +		return -EINVAL;
> > > +
> > > +	datablob =3D kzalloc(datalen + 1, GFP_KERNEL);
> > > +	if (!datablob)
> > > +		return -ENOMEM;
> > > +
> > > +	memcpy(datablob, data, datalen);
> > > +	ret =3D datablob_parse(datablob, &master_desc, &decrypted_datalen,
> > > +			     &hex_encoded_iv, &hex_encoded_data);
> > > +	if (ret < 0)
> > > +		goto out;
> > > +
> > > +	epayload =3D encrypted_key_alloc(key, master_desc, decrypted_datale=
n);
> > > +	if (IS_ERR(epayload)) {
> > > +		ret =3D PTR_ERR(epayload);
> > > +		goto out;
> > > +	}
> > > +	ret =3D encrypted_init(epayload, master_desc, decrypted_datalen,
> > > +			     hex_encoded_iv, hex_encoded_data);
> > > +	rcu_assign_pointer(key->payload.data, epayload);
> > > +out:
> > > +	kfree(datablob);
> > > +	return ret > 0 ? -EINVAL : ret;
> > > +}
> > > +
> > > +static void encrypted_rcu_free(struct rcu_head *rcu)
> > > +{
> > > +	struct encrypted_key_payload *epayload;
> > > +
> > > +	epayload =3D container_of(rcu, struct encrypted_key_payload, rcu);
> > > +	memset(epayload->decrypted_data, 0, epayload->decrypted_datalen);
> > > +	kfree(epayload);
> > > +}
> > > +
> > > +/*
> > > + * encrypted_update - update the master key description
> > > + *
> > > + * Change the master key description for an existing encrypted key.
> > > + * The next read will return an encrypted datablob using the new
> > > + * master key description.
> > > + *
> > > + * On success, return 0. Otherwise return errno.
> > > + */
> > > +static int encrypted_update(struct key *key, const void *data, size_=
t datalen)
> > > +{
> > > +	struct encrypted_key_payload *epayload =3D key->payload.data;
> > > +	struct encrypted_key_payload *new_epayload;
> > > +	char *buf;
> > > +	char *new_master_desc =3D NULL;
> > > +	int ret =3D 0;
> > > +
> > > +	if (datalen <=3D 0 || datalen > 32767 || !data)
> > > +		return -EINVAL;
> > > +
> > > +	buf =3D kzalloc(datalen + 1, GFP_KERNEL);
> > > +	if (!buf)
> > > +		return -ENOMEM;
> > > +
> > > +	memcpy(buf, data, datalen);
> > > +	new_master_desc =3D strsep(&buf, " \t");
> > > +	if (!*new_master_desc) {
> > > +		ret =3D -EINVAL;
> > > +		goto out;
> > > +	}
> > > +
> > > +	new_epayload =3D encrypted_key_alloc(key, new_master_desc,
> > > +					   epayload->datalen);
> > > +	if (IS_ERR(new_epayload)) {
> > > +		ret =3D PTR_ERR(new_epayload);
> > > +		goto out;
> > > +	}
> > > +
> > > +	__ekey_init(new_epayload, new_master_desc, epayload->datalen);
> > > +
> > > +	memcpy(new_epayload->iv, epayload->iv, ivsize);
> > > +	memcpy(new_epayload->decrypted_data, epayload->decrypted_data,
> > > +	       epayload->decrypted_datalen);
> > > +
> > > +	rcu_assign_pointer(key->payload.data, new_epayload);
> > > +	call_rcu(&epayload->rcu, encrypted_rcu_free);
> > > +out:
> > > +	kfree(buf);
> > > +	return ret;
> > > +}
> > > +
> > > +/*
> > > + * encrypted_read - format and copy the encrypted data to userspace
> > > + *
> > > + * The resulting datablob format is:
> > > + * <master-key name> <decrypted data length> <encrypted iv> <encrypt=
ed data>
> > > + *
> > > + * On success, return to userspace the encrypted key datablob size.
> > > + */
> > > +static long encrypted_read(const struct key *key, char __user * buff=
er,
> > > +			   size_t buflen)
> > > +{
> > > +	struct encrypted_key_payload *epayload;
> > > +	struct key *mkey;
> > > +	void *master_key;
> > > +	unsigned int master_keylen;
> > > +	char derived_key[hash_size];
> > > +	int asciiblob_len;
> > > +	int ret;
> > > +
> > > +	epayload =3D rcu_dereference_protected(key->payload.data,
> > > +				  rwsem_is_locked(&((struct key *)key)->sem));
> > > +
> > > +	/* returns the hex encoded iv, encrypted-data, and hmac as ascii */
> > > +	asciiblob_len =3D epayload->datablob_len + ivsize + 1
> > > +	    + roundup(epayload->decrypted_datalen, blksize)
> > > +	    + (hash_size * 2);
> > > +
> > > +	if (!buffer || buflen <=3D 0)
> > > +		return asciiblob_len;
> > > +
> > > +	mkey =3D request_master_key(epayload, &master_key, &master_keylen);
> > > +	if (IS_ERR(mkey))
> > > +		return PTR_ERR(mkey);
> > > +
> > > +	memset(derived_key, 0, sizeof derived_key);
> > > +	ret =3D get_derived_key(derived_key, ENC_KEY, master_key, master_ke=
ylen);
> > > +	if (ret)
> > > +		goto out;
> > > +
> > > +	ret =3D derived_key_encrypt(epayload, derived_key, sizeof derived_k=
ey);
> > > +	if (ret)
> > > +		goto out;
> > > +
> > > +	ret =3D datablob_hmac_append(epayload, master_key, master_keylen);
> > > +	if (ret)
> > > +		goto out;
> > > +
> > > +	ret =3D datablob_format(buffer, epayload, asciiblob_len);
> > > +	if (ret < 0)
> > > +		goto out;
> > > +
> > > +	key_put(mkey);
> > > +	return asciiblob_len;
> > > +out:
> > > +	key_put(mkey);
> > > +	return ret > 0 ? -EINVAL : ret;
> > > +}
> > > +
> > > +/*
> > > + * encrypted_destroy - before freeing the key, clear the decrypted d=
ata
> > > + *
> > > + * Before freeing the key, clear the memory containing the descrypted
> > > + * key data.
> > > + */
> > > +static void encrypted_destroy(struct key *key)
> > > +{
> > > +	struct encrypted_key_payload *epayload =3D key->payload.data;
> > > +
> > > +	if (!epayload)
> > > +		return;
> > > +
> > > +	memset(epayload->decrypted_data, 0, epayload->decrypted_datalen);
> > > +	kfree(key->payload.data);
> > > +}
> > > +
> > > +struct key_type key_type_encrypted =3D {
> > > +	.name =3D "encrypted",
> > > +	.instantiate =3D encrypted_instantiate,
> > > +	.update =3D encrypted_update,
> > > +	.match =3D user_match,
> > > +	.destroy =3D encrypted_destroy,
> > > +	.describe =3D user_describe,
> > > +	.read =3D encrypted_read,
> > > +};
> > > +EXPORT_SYMBOL_GPL(key_type_encrypted);
> > > +
> > > +static int __init init_encrypted(void)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret =3D register_key_type(&key_type_encrypted);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +	ret =3D aes_get_sizes(&ivsize, &blksize);
> > > +	return ret;
> > > +}
> > > +
> > > +static void __exit cleanup_encrypted(void)
> > > +{
> > > +	unregister_key_type(&key_type_encrypted);
> > > +}
> > > +
> > > +module_init(init_encrypted);
> > > +module_exit(cleanup_encrypted);
> > > +
> > > +MODULE_LICENSE("GPL");
> > > diff --git a/security/keys/encrypted_defined.h b/security/keys/encryp=
ted_defined.h
> > > new file mode 100644
> > > index 0000000..4e0b6e5
> > > --- /dev/null
> > > +++ b/security/keys/encrypted_defined.h
> > > @@ -0,0 +1,52 @@
> > > +#ifndef __ENCRYPTED_KEY_H
> > > +#define __ENCRYPTED_KEY_H
> > > +
> > > +#define ENCRYPTED_DEBUG 0
> > > +
> > > +#if ENCRYPTED_DEBUG
> > > +static inline void dump_master_key(void *master_key, unsigned int ma=
ster_keylen)
> > > +{
> > > +	print_hex_dump(KERN_ERR, "master key: ", DUMP_PREFIX_NONE, 32, 1,
> > > +		       master_key, (size_t) master_keylen, 0);
> > > +}
> > > +
> > > +static inline void dump_decrypted_data(struct encrypted_key_payload =
*epayload)
> > > +{
> > > +	print_hex_dump(KERN_ERR, "decrypted data: ", DUMP_PREFIX_NONE, 32, =
1,
> > > +		       epayload->decrypted_data,
> > > +		       epayload->decrypted_datalen, 0);
> > > +}
> > > +
> > > +static inline void dump_encrypted_data(struct encrypted_key_payload =
*epayload,
> > > +				       unsigned int encrypted_datalen)
> > > +{
> > > +	print_hex_dump(KERN_ERR, "encrypted data: ", DUMP_PREFIX_NONE, 32, =
1,
> > > +		       epayload->encrypted_data, (size_t) encrypted_datalen, 0);
> > > +}
> > > +
> > > +static inline void dump_hmac(char *str, void *digest, unsigned int h=
mac_size)
> > > +{
> > > +	if (str)
> > > +		pr_info("encrypted_key: %s", str);
> > > +	print_hex_dump(KERN_ERR, "hmac: ", DUMP_PREFIX_NONE, 32, 1, digest,
> > > +		       (size_t) hmac_size, 0);
> > > +}
> > > +#else
> > > +static inline void dump_master_key(void *master_key, unsigned int ma=
ster_keylen)
> > > +{
> > > +}
> > > +
> > > +static inline void dump_decrypted_data(struct encrypted_key_payload =
*epayload)
> > > +{
> > > +}
> > > +
> > > +static inline void dump_encrypted_data(struct encrypted_key_payload =
*epayload,
> > > +				       unsigned int encrypted_datalen)
> > > +{
> > > +}
> > > +
> > > +static inline void dump_hmac(char *str, void *digest, int hmac_size)
> > > +{
> > > +}
> > > +#endif
> > > +#endif
> > >=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-=
module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--nextPart2451418.pUCyeE4yDk
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIQCTCCBLMw
ggOboAMCAQICARQwDQYJKoZIhvcNAQEFBQAwQTEQMA4GA1UEChMHRXVyb1BLSTEtMCsGA1UEAxMk
RXVyb1BLSSBSb290IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA2MTAyNDEzMzEzM1oXDTEw
MTIzMTEyNTk1OVowUTELMAkGA1UEBhMCSVQxEDAOBgNVBAoTB0V1cm9QS0kxMDAuBgNVBAMTJ0V1
cm9QS0kgSXRhbGlhbiBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAPbJ3y5bE0iL2iFW59R4KGHS3iTc22mq2GlDaOZLE3Xz1wTvB/yBl5e4ntMZ
eEeWTW9JInNRTtfC3mcLk0gnEdK1rQZbe4lQwBVHdkG8LvRQDWHIkZNuccoUpQXMv+JbZjI6m7rH
fU2CN/YCvFY9QL08xXsfDxvX2Ee4S7EwJiSEEJSiy+R00uTfvfn27d8a6LCqYLzlInRlz4C2CUbk
+U2UAwjYEPTP2ziqFxztysbxC3fjqH8e6P5wIPXOS5cSYnVaEyp21VXhAOamVJEGlQCdVoTHs+pP
BYqCBuNhBfienUPaEDHHUUYHZ2nS4eNzd9XOu+5hFi1/8hVZxN4sbdECAwEAAaOCAaQwggGgMEwG
CWCGSAGG+EIBDQQ/Fj1Jc3N1ZWQgdW5kZXIgcG9saWN5OgogaHR0cDovL3d3dy5ldXJvcGtpLm9y
Zy9jYS9yb290L2Nwcy8xLjEvMGUGCCsGAQUFBwEBBFkwVzAoBggrBgEFBQcwAYYcaHR0cDovL29j
c3AuZXVyb3BraS5vcmc6ODAyNjArBggrBgEFBQcwAoYfaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9j
YS9yb290LzA7BgNVHR8ENDAyMDCgLqAshipodHRwOi8vd3d3LmV1cm9wa2kub3JnL2NhL3Jvb3Qv
Y3JsL2NybC5kZXIwDAYDVR0TBAUwAwEB/zBOBgNVHSAERzBFMEMGCisGAQQBqQcBAQEwNTAzBggr
BgEFBQcCARYnaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9yb290L2Nwcy8xLjEvMA4GA1UdDwEB
/wQEAwIB9jAdBgNVHQ4EFgQUjl4HtzG0Gbu5BJU0rMX9016KQsAwHwYDVR0jBBgwFoAUjNyLsaVK
kOdOiHMYPJ3VXn7kss0wDQYJKoZIhvcNAQEFBQADggEBAFjlAWMiL7uhEAVcrPeMXsbQU+bQNbP1
TBqyBoMCMJ4RakM7/67AsmqpKGIYwhjVkSNHhscRl5BuSiyviHOLbWUJ9tAAKt6hzMDr1J4OvWSH
Sn8y9fSlyQU8+fQE8FHxXT3Aa7aLYVqsqr0ppmxRDL/9b/mdUVcMXiKFAdopFzhXIigfZFh6MW/o
7/GEiDMGsovCiwKJ5ZL46zGRDaS+O0aRYQv2PHZaWrC8i0OPwghlTeB2DfUBzm0urPijBATdjzP8
yO3YGymFZOIG08Roe4bwzrANGzX5luBk3lNmtXTPHoUtRLn3ADa+IUGwK6VYWHYJe1+uUHRNziQu
/Zsb858wggU/MIIEJ6ADAgECAgIJzzANBgkqhkiG9w0BAQUFADBRMQswCQYDVQQGEwJJVDEQMA4G
A1UEChMHRXVyb1BLSTEwMC4GA1UEAxMnRXVyb1BLSSBJdGFsaWFuIENlcnRpZmljYXRpb24gQXV0
aG9yaXR5MB4XDTA2MTEwNjE3MTU1OVoXDTEwMTIzMTEyNTk1OVowZTELMAkGA1UEBhMCSVQxHjAc
BgNVBAoTFVBvbGl0ZWNuaWNvIGRpIFRvcmlubzE2MDQGA1UEAxMtUG9saXRlY25pY28gZGkgVG9y
aW5vIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEA/s1vopfmSp2eqKG/jW4H5YyfrZc/jWEnctMMm7TlVT+ryxJ2ifYV/7VyuYVIGdnCBnmJiav6
uhePqpHyuejEZ+IdCchk04BSBbgzkSbWakw2ekv1SKm8WfvhxHbiSo/t//LQEANMJ+XeeqGl1TRR
8gdMC6erWFGdl5FcuOpMoaqW6DszVGlOAf7Uo/DExZ0/9cw77GTRoDTA3vi1QJEYGaAAvI2/flaU
8gn4QoktjowchDXBylVsyqs+ux3v7m3H0cgC3q62t2om2badk40F9XH1w2WPLQB6rSl+TPDxkl2k
kR4goQprXR0b0OujS5ADq5Ds2w7YPj5h4J6ebsbIUQIDAQABo4ICCzCCAgcwdQYJYIZIAYb4QgEN
BGgWZklzc3VlZCB1bmRlciBwb2xpY2llczoKIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2Evcm9v
dC9jcHMvMS4xLwogaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLzBcBggrBgEF
BQcBAQRQME4wKAYIKwYBBQUHMAGGHGh0dHA6Ly9vY3NwLmV1cm9wa2kub3JnOjgwMjYwIgYIKwYB
BQUHMAKGFmh0dHA6Ly93d3cuZXVyb3BraS5vcmcwPAYDVR0fBDUwMzAxoC+gLYYraHR0cDovL3d3
dy5ldXJvcGtpLm9yZy9jYS9pdDIvY3JsMDMvY3JsLmRlcjAPBgNVHRMBAf8EBTADAQH/MIGTBgNV
HSAEgYswgYgwQwYKKwYBBAGpBwEBATA1MDMGCCsGAQUFBwIBFidodHRwOi8vd3d3LmV1cm9wa2ku
b3JnL2NhL3Jvb3QvY3BzLzEuMS8wQQYKKwYBBAGpBwIBATAzMDEGCCsGAQUFBwIBFiVodHRwOi8v
d3d3LmV1cm9wa2kub3JnL2NhL2l0L2Nwcy8xLjEvMAsGA1UdDwQEAwIB9jAdBgNVHQ4EFgQUCf0l
GW/jaHyCazVzvCgAviw8OjgwHwYDVR0jBBgwFoAUjl4HtzG0Gbu5BJU0rMX9016KQsAwDQYJKoZI
hvcNAQEFBQADggEBANfGdD6B98NUwBOVYIiuo+SNfw8Afjr2oFHLYEHYhKdBED1WBckhK610v2zJ
ctramnrqdd+xfyzmkyNm48OtkiVetYzXbgYeyMGxhO8HrJ1Ztf1yEN0lL8HgdK3lmJeLYNYH/cwZ
5SlKwvTR/VENHLYlWsgWk47ut7W8+Zd/ESwzNdJUCBUMoQnGZ3giyhAXKAgIOckwL0g8KmnceY7J
Y4L1G++1OuOoUcgg2jRPxcVmHVEe/cM0WHfUcigDXSBTIxAiDwlQ7ni97yX1RqBV/6IVdRDYKyjg
YkdYcwU9ZuOKUP4Pl5KKCegLOHRoo5kX6V1o7b2IZGBFoVmkag4m4kkwggYLMIIE86ADAgECAgID
wTANBgkqhkiG9w0BAQUFADBlMQswCQYDVQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkg
VG9yaW5vMTYwNAYDVQQDEy1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRo
b3JpdHkwHhcNMDgxMjA1MTYwMDAwWhcNMTAxMjMwMTIwMDAwWjB5MQswCQYDVQQGEwJJVDEeMBwG
A1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTEwLwYDVQQLEyhEaXBhcnRpbWVudG8gZGkgQXV0
b21hdGljYSBlIEluZm9ybWF0aWNhMRcwFQYDVQQDEw5Sb2JlcnRvICBTYXNzdTCCASIwDQYJKoZI
hvcNAQEBBQADggEPADCCAQoCggEBAOS/leMNzG5v7FG73ythWtNPOdq8MEFpzg7mjy4M7UsS9+sc
b7QE8TOX365q/+mBwxZ7qW+OhNKfgv14A3y/quju5P7mjTmTNvKWDpsUBjC+tCs+WpWsgIPc2xxW
PrR7br04U/SYYNsxynh1TtO2gsQrHIj9S/wNiNRP8GGPCAiuYRlaL2CeSVn4JEKcT0zOeLIIqfDp
3Ad3YeBhj+cR3TrmO9TyGTPCAb1oyq9wuA1Tx044rqSQNbp0e0RvOrwAIpD/2mNPP3ReTeB53aSg
q0pCHoH1s2AcY/jWJ1joYFC9hh/2DqZRvMNIsM7Uce5Iiz2sgl1I61IUD4658HYzCmMCAwEAAaOC
Aq8wggKrMIGVBglghkgBhvhCAQ0EgYcWgYRJc3N1ZWQgdW5kZXIgcG9saWNpZXM6CiBodHRwOi8v
d3d3LmV1cm9wa2kub3JnL2NhL3Jvb3QvY3BzLzEuMS8KIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcv
Y2EvaXQvY3BzLzEuMS8KIGh0dHA6Ly9jYS5wb2xpdG8uaXQvY3BzLzIuMS8wEQYJYIZIAYb4QgEB
BAQDAgCwMGMGCCsGAQUFBwEBBFcwVTAoBggrBgEFBQcwAYYcaHR0cDovL29jc3AuZXVyb3BraS5v
cmc6ODAyNjApBggrBgEFBQcwAoYdaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC8wMgYDVR0f
BCswKTAnoCWgI4YhaHR0cDovL2NhLnBvbGl0by5pdC9jcmwwMy9jcmwuZGVyMAwGA1UdEwEB/wQC
MAAwOgYDVR0RBDMwMYEXcm9iZXJ0by5zYXNzdUBwb2xpdG8uaXSgFgYKKwYBBAGVYgIBAaAIFgYw
MjEzMDUwgc0GA1UdIASBxTCBwjBDBgorBgEEAakHAQEBMDUwMwYIKwYBBQUHAgEWJ2h0dHA6Ly93
d3cuZXVyb3BraS5vcmcvY2Evcm9vdC9jcHMvMS4xLzBBBgorBgEEAakHAgEBMDMwMQYIKwYBBQUH
AgEWJWh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2EvaXQvY3BzLzEuMS8wOAYKKwYBBAGVYgECATAq
MCgGCCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjEvMAsGA1UdDwQEAwIE8DAd
BgNVHQ4EFgQUP+37DpRL6r5BNjgsgFjI8MHvGTcwHwYDVR0jBBgwFoAUCf0lGW/jaHyCazVzvCgA
viw8OjgwDQYJKoZIhvcNAQEFBQADggEBADRj0OWMglzLXTPuKND9gMTHd1iRPzRNI1TiYFN/WIyu
a3mNev65wKn35VxbbMV6k7zuxxdC7o+iYRLepVOnpw90Af/SiJRc9QI4rk8tzSr5xII7vI0fPvcl
rjSMymXCvwKrbYwrKe0FhBnSZ8AoewXoHDQ8f64heLIU8mLWuwo1+brq0pJUH5Q+69WAGD03ln+l
Fhk2KqvVv8yAD21PydrS7Uk2ZLE7l7/+BTQBY8ZjpNRZ44C6+o7lou2zN6lkWtVHBwUNVdfu3wkS
TdtCm/yxR8XUlFyZkLHfhY19VW4luxb7KZ4GiPKDERdQwBb0kja4eqSOBkAPWZ9Y8zpv4bAxggIc
MIICGAIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBkaSBUb3Jpbm8x
NjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQIC
A8EwCQYFKw4DAhoFAKCBhzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0xMDA5MjkxMjQwNTVaMCMGCSqGSIb3DQEJBDEWBBQML2WDvnmtykzJPndtyW0THcLTXDAoBgkq
hkiG9w0BCQ8xGzAZMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQEFAASCAQBy
YqS6+zFxOIf5BRx9cIQc4HVXpyYHWK8RLB7WPI6MC+npsTEnLdk9ImLCl91fgWaNZkGsyPPSwi9/
5VzIPT4xn/QtDAo+kqmC0+ALWhkJ2EdFn4zZRmt/GMqpLO1ir0YLrj7Xrd7vOi0y6VfwGPNJj6CQ
YBW6hUWmiQgvvKiBnW2YQdSzHdMhy7+kylDNd9j4YwboV8wF//nuL3TubNXs5YpSbt3U/VMBbJ2j
x8OpjLuPEGo4C3EhcxsE4ClqhZ9NNpHj+9ZEhg43fZI4SQSQ+m+qoqPYcXmG0n4rO0HIhvvOe/4w
YuWQPt7k+VY5c1gaW7k/vG4dGP7OtnmxvVqEAAAAAAAA

--nextPart2451418.pUCyeE4yDk--
