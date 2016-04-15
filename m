From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [RFC PATCH] KEYS: Provide keyctls to do public key operations
Date: Fri, 15 Apr 2016 11:49:39 -0700
Message-ID: <571137C3.1050805@intel.com>
References: <18908.1460671231@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: David Howells <dhowells@redhat.com>, pjones@redhat.com,
	marcel@holtmann.org, dwmw2@infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18908.1460671231@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi David,
On 04/14/2016 03:00 PM, David Howells wrote:
> diff --git a/crypto/asymmetric_keys/signature.c b/crypto/asymmetric_keys/signature.c
> index 11b7ba170904..8ecbeda16b53 100644
> --- a/crypto/asymmetric_keys/signature.c
> +++ b/crypto/asymmetric_keys/signature.c

Since this file implements the enc/dec operations also
should it be renamed to crypto/asymmetric_keys/public_key_ops.c
or something similar? signature.c is a bit confusing now.

> +/**
> + * encrypt_blob - Encrypt data using an asymmetric key
> + * @params: Various parameters
> + * @data: Data blob to be encrypted, length params->data_len
> + * @enc: Encrypted data buffer, length params->enc_len
> + *
> + * Encrypt the specified data blob using the private key specified by
> + * params->key.  The encrypted data is wrapped in an encoding if
> + * params->encoding is specified (eg. "pkcs1").
> + *
> + * If the key needs to be unlocked, a password can be supplied in a logon key
> + * specified by params->password.
> + *
> + * Returns the length of the data placed in the encrypted data buffer or an
> + * error.
> + */
> +int encrypt_blob(struct kernel_pkey_params *params,
> +		 const void *data, void *enc)
> +{
> +	const struct asymmetric_key_subtype *subtype;
> +	struct key *key = params->key;
> +	int ret;
> +
> +	pr_devel("==>%s()\n", __func__);
> +
> +	if (key->type != &key_type_asymmetric)
> +		return -EINVAL;
> +	subtype = asymmetric_key_subtype(key);
> +	if (!subtype ||
> +	    !key->payload.data[0])
> +		return -EINVAL;
> +	if (!subtype->encrypt_blob)
> +		return -ENOTSUPP;
> +
> +	ret = subtype->encrypt_blob(params, data, enc);
> +
> +	pr_devel("<==%s() = %d\n", __func__, ret);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(encrypt_blob);
> +
> +/**
> + * decrypt_blob - Decrypt data using an asymmetric key
> + * @params: Various parameters
> + * @enc: Encrypted data to be decrypted, length params->enc_len
> + * @data: Decrypted data buffer, length params->data_len
> + *
> + * Decrypt the specified data blob using the private key specified by
> + * params->key.  The decrypted data is wrapped in an encoding if
> + * params->encoding is specified (eg. "pkcs1").
> + *
> + * If the private key needs to be unlocked, a password can be supplied in a
> + * logon key specified by params->password.
> + *
> + * Returns the length of the data placed in the decrypted data buffer or an
> + * error.
> + */
> +int decrypt_blob(struct kernel_pkey_params *params,
> +		 const void *enc, void *data)
> +{
> +	const struct asymmetric_key_subtype *subtype;
> +	struct key *key = params->key;
> +	int ret;
> +
> +	pr_devel("==>%s()\n", __func__);
> +
> +	if (key->type != &key_type_asymmetric)
> +		return -EINVAL;
> +	subtype = asymmetric_key_subtype(key);
> +	if (!subtype ||
> +	    !key->payload.data[0])
> +		return -EINVAL;
> +	if (!subtype->decrypt_blob)
> +		return -ENOTSUPP;
> +
> +	ret = subtype->decrypt_blob(params, enc, data);
> +
> +	pr_devel("<==%s() = %d\n", __func__, ret);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(decrypt_blob);
> +
> +/**
> + * create_signature - Sign some data using an asymmetric key
> + * @params: Various parameters
> + * @data: Data blob to be signed, length params->data_len
> + * @enc: Signature buffer, length params->enc_len
> + *
> + * Sign the specified data blob using the private key specified by params->key.
> + * The signature is wrapped in an encoding if params->encoding is specified
> + * (eg. "pkcs1").  If the encoding needs to know the digest type, this can be
> + * passed through params->hash_algo (eg. "sha1").
> + *
> + * If the private key needs to be unlocked, a password can be supplied in a
> + * logon key specified by params->password.
> + *
> + * Returns the length of the data placed in the signature buffer or an error.
> + */
> +int create_signature(struct kernel_pkey_params *params,
> +		     const void *data, void *enc)
> +{
> +	const struct asymmetric_key_subtype *subtype;
> +	struct key *key = params->key;
> +	int ret;
> +
> +	pr_devel("==>%s()\n", __func__);
> +
> +	if (key->type != &key_type_asymmetric)
> +		return -EINVAL;
> +	subtype = asymmetric_key_subtype(key);
> +	if (!subtype ||
> +	    !key->payload.data[0])
> +		return -EINVAL;
> +	if (!subtype->create_signature)
> +		return -ENOTSUPP;
> +
> +	ret = subtype->create_signature(params, data, enc);
> +
> +	pr_devel("<==%s() = %d\n", __func__, ret);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(create_signature);

This will work perfectly for the algif_akcipher. Thanks for providing this.
I'm going to rebase my patches on top of this and resend.
Should I use your keys-next as a base for the new version?
Thanks,
-- 
TS
