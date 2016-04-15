From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [RFC PATCH] KEYS: Provide keyctls to do public key operations
Date: Fri, 15 Apr 2016 15:07:34 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1604151411220.7434@gregoryb-fedora.amr.corp.intel.com>
References: <18908.1460671231@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: pjones@redhat.com, tadeusz.struk@intel.com, marcel@holtmann.org,
	dwmw2@infradead.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18908.1460671231@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On Thu, 14 Apr 2016, David Howells wrote:

> The interface for the active ops is a bit clunky as the syscall interface
> doesn't provide sufficient argument space to pass everything I need to
> specify.  Some basic integer arguments are specified in a struct and more
> complex options through a string of key=val pairs - just so I don't have to
> deal with the compat code for dealing with a struct containing pointers
> (but I can change to that if it's preferable).

It sounds like the struct would still have pointers to strings that would 
need parsing, so I'm not sure it's that much overhead to handle the short 
strings of key=val pairs. But I'll agree that it feels clunky.

> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index fd76b5fc3b3a..3a38b177df89 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -57,6 +57,40 @@ static void public_key_destroy(void *payload0, void *payload3)
> 	public_key_signature_free(payload3);
> }
>
> +/*
> + * Query information about a key.
> + */
> +static int software_key_query(const struct key *key,
> +			      struct kernel_pkey_query *info)
> +{
> +	struct crypto_akcipher *tfm;
> +	struct public_key *pkey = key->payload.data[asym_crypto];
> +	int ret, len;
> +
> +	tfm = crypto_alloc_akcipher(pkey->pkey_algo, 0, 0);
> +	if (IS_ERR(tfm))
> +		return PTR_ERR(tfm);
> +
> +	ret = crypto_akcipher_set_pub_key(tfm, pkey->key, pkey->keylen);
> +	if (ret < 0)
> +		goto error_free_tfm;
> +
> +	len = crypto_akcipher_maxsize(tfm) * 8;

An extra multiply here.

> +	info->key_size = len * 8;
> +	info->max_data_size = len;
> +	info->max_sig_size = len;
> +	info->max_enc_size = len;
> +	info->max_dec_size = len;
> +	info->supported_ops = KEYCTL_SUPPORTS_VERIFY;

Did you intend to include encrypt/decrypt/sign here?


> diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
> index 86eddd6241f3..d9e865ddee8a 100644
> --- a/include/uapi/linux/keyctl.h
> +++ b/include/uapi/linux/keyctl.h
> @@ -60,6 +60,11 @@
> #define KEYCTL_INVALIDATE		21	/* invalidate a key */
> #define KEYCTL_GET_PERSISTENT		22	/* get a user's persistent keyring */
> #define KEYCTL_DH_COMPUTE		23	/* Compute Diffie-Hellman values */
> +#define KEYCTL_PKEY_QUERY		24	/* Query public key parameters */
> +#define KEYCTL_PKEY_ENCRYPT		25	/* Encrypt a blob using a public key */
> +#define KEYCTL_PKEY_DECRYPT		26	/* Decrypt a blob using a public key */
> +#define KEYCTL_PKEY_SIGN		27	/* Create a public key signature */
> +#define KEYCTL_PKEY_VERIFY		28	/* Verify a public key signature */
>
> /* keyctl structures */
> struct keyctl_dh_params {
> @@ -68,4 +73,26 @@ struct keyctl_dh_params {
> 	__s32 base;
> };
>
> +struct keyctl_pkey_query {
> +	__u32		supported_ops;	/* Which ops are supported */
> +#define KEYCTL_SUPPORTS_ENCRYPT		0x01
> +#define KEYCTL_SUPPORTS_DECRYPT		0x02
> +#define KEYCTL_SUPPORTS_SIGN		0x04
> +#define KEYCTL_SUPPORTS_VERIFY		0x05

0x08 for KEYCTL_SUPPORTS_VERIFY?


> diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
> new file mode 100644
> index 000000000000..c903e7469beb
> --- /dev/null
> +++ b/security/keys/keyctl_pkey.c
> @@ -0,0 +1,324 @@
> +/* Public-key operation keyctls
> + *
> + * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/key.h>
> +#include <linux/keyctl.h>
> +#include <linux/parser.h>
> +#include <crypto/public_key.h>
> +#include <keys/asymmetric-type.h>
> +#include <keys/user-type.h>
> +#include <asm/uaccess.h>
> +#include "internal.h"
> +
> +/*
> + * Query information about an asymmetric key.
> + */
> +long keyctl_pkey_query(key_serial_t id,  struct keyctl_pkey_query __user *_res)
> +{
> +	struct kernel_pkey_query res;
> +	struct key *key;
> +	key_ref_t key_ref;
> +	long ret;
> +
> +	key_ref = lookup_user_key(id, 0, KEY_NEED_READ);
> +	if (IS_ERR(key_ref))
> +		return PTR_ERR(key_ref);
> +
> +	key = key_ref_to_ptr(key_ref);
> +
> +	ret = query_asymmetric_key(key, &res);
> +	if (ret < 0)
> +		goto error_key;
> +
> +	ret = -EFAULT;
> +	if (copy_to_user(_res, &res, sizeof(res)) == 0 &&
> +	    clear_user(_res->__spare, sizeof(_res->__spare)) == 0)
> +		ret = 0;
> +
> +error_key:
> +	key_put(key);
> +	return ret;
> +}
> +
> +static void keyctl_pkey_params_free(struct kernel_pkey_params *params)
> +{
> +	kfree(params->info);
> +	key_put(params->key);
> +	key_put(params->password);
> +}
> +
> +enum {
> +	Opt_err = -1,
> +	Opt_enc,		/* "enc=<endoding>" eg. "enc=oaep" */

endoding->encoding


> +	Opt_hash,		/* "hash=<digest-name>" eg. "hash=sha1" */
> +};
