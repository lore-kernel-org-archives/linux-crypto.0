From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH 2/8] KEYS: Provide keyctls to drive the new key type ops
 for asymmetric keys [ver #2]
Date: Thu, 28 Jul 2016 16:21:34 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1607281535550.15062@mjmartin-mac01.local>
References: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk> <146668966955.2977.16073224235350760987.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Cc: dwmw2@infradead.org, tadeusz.struk@intel.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31544 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbcG1XVh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jul 2016 19:21:37 -0400
In-Reply-To: <146668966955.2977.16073224235350760987.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Thu, 23 Jun 2016, David Howells wrote:

> diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
> index 8ac2c5fbc8fc..93ebd25b1427 100644
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
> @@ -73,4 +78,24 @@ struct keyctl_dh_params {
> #define KEYCTL_SUPPORTS_SIGN		0x04
> #define KEYCTL_SUPPORTS_VERIFY		0x08
>
> +struct keyctl_pkey_query {
> +	__u32		supported_ops;	/* Which ops are supported */
> +	__u32		key_size;	/* Size of the key in bits */
> +	__u16		max_data_size;	/* Maximum size of raw data to sign in bytes */
> +	__u16		max_sig_size;	/* Maximum size of signature in bytes */
> +	__u16		max_enc_size;	/* Maximum size of encrypted blob in bytes */
> +	__u16		max_dec_size;	/* Maximum size of decrypted blob in bytes */
> +	__u32		__spare[10];
> +};

It would also be useful to return pkey_algo so userspace can see which 
algorithm is in use for the given public key. The public key algorithm is 
printed in /proc/keys, but is not returned by KEYCTL_PKEY_QUERY or 
KEYCTL_DESCRIBE.

Does it make sense to add the information from key->type->describe() to 
KEYCTL_PKEY_QUERY or KEYCTL_DESCRIBE? Or add something new like 
KEYCTL_DESCRIBE_TYPE?

--
Mat Martineau
Intel OTC
