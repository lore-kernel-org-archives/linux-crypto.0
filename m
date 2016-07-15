From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [RFC PATCH] KEYS: add SP800-56A KDF support for DH
Date: Thu, 14 Jul 2016 17:45:59 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1607141654250.69287@istotlan-mobl1.amr.corp.intel.com>
References: <4161793.TTVXSVQtZL@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22019 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbcGOAqD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jul 2016 20:46:03 -0400
In-Reply-To: <4161793.TTVXSVQtZL@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 12 Jul 2016, Stephan Mueller wrote:

> Hi Mat, David,
>
> This patch is based on the cryptodev-2.6 tree with the patch
> 4693fc734d675c5518ea9bd4c9623db45bc37402 ("KEYS: Add placeholder
> for KDF usage with DH") from Linus' tree added on top.
>
> I am aware of the fact that the compat code is not present. This
> patch is intended for review to verify that the user space
> interface follows the general approach for the keys subsystem.
>
> The patch to add KDF to the kernel crypto API will be appended to
> this patch.
>
> The patch for the keyutils user space extension will also be added.
>
> Ciao
> Stephan
>
> ---8<---
>
> SP800-56A define the use of DH with key derivation function based on a
> counter. The input to the KDF is defined as (DH shared secret || other
> information). The value for the "other information" is to be provided by
> the caller.
>
> The KDF is provided by the kernel crypto API. The SP800-56A KDF is equal
> to the SP800-108 counter KDF. However, the caller is allowed to specify
> the KDF type that he wants to use to derive the key material allowing
> the use of the other KDFs provided with the kernel crypto API.
>
> As the KDF implements the proper truncation of the DH shared secret to
> the requested size, this patch fills the caller buffer up to its size.
>
> The patch is tested with a new test added to the keyutils user space
> code which uses a CAVS test vector testing the compliance with
> SP800-56A.
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
> include/uapi/linux/keyctl.h | 10 +++++
> security/keys/Kconfig       |  1 +
> security/keys/dh.c          | 98 ++++++++++++++++++++++++++++++++++++++++-----
> security/keys/internal.h    |  5 ++-
> security/keys/keyctl.c      |  2 +-
> 5 files changed, 103 insertions(+), 13 deletions(-)

Be sure to update Documentation/security/keys.txt once the interface is 
settled on.

>
> diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
> index 86eddd6..cc4ce7c 100644
> --- a/include/uapi/linux/keyctl.h
> +++ b/include/uapi/linux/keyctl.h
> @@ -68,4 +68,14 @@ struct keyctl_dh_params {
> 	__s32 base;
> };
>
> +struct keyctl_kdf_params {
> +#define KEYCTL_KDF_MAX_OUTPUTLEN	1024	/* max length of KDF output */
> +#define KEYCTL_KDF_MAX_STRING_LEN	64	/* maximum length of strings */

I think these limits should be in the internal headers rather than uapi.

> +	char *kdfname;
> +	__u32 kdfnamelen;

As noted in the userspace patch, if kdfname is a null-terminated string 
then kdfnamelen isn't needed.

> +	char *otherinfo;
> +	__u32 otherinfolen;
> +	__u32 flags;

Looks like flags aren't used anywhere. Do you have a use planned? You 
could add some spare capacity like the keyctl_pkey_* structs instead (see 
https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h=keys-next&id=dd7e2ea418b4f8851a4eb976b9431fbc03d2ebaf 
)

> +};
> +
> #endif /*  _LINUX_KEYCTL_H */
> diff --git a/security/keys/Kconfig b/security/keys/Kconfig
> index f826e87..56491fe 100644
> --- a/security/keys/Kconfig
> +++ b/security/keys/Kconfig
> @@ -90,6 +90,7 @@ config KEY_DH_OPERATIONS
>        bool "Diffie-Hellman operations on retained keys"
>        depends on KEYS
>        select MPILIB
> +       select CRYPTO_KDF
>        help
> 	 This option provides support for calculating Diffie-Hellman
> 	 public keys and shared secrets using values stored as keys
> diff --git a/security/keys/dh.c b/security/keys/dh.c
> index 531ed2e..4c93969 100644
> --- a/security/keys/dh.c
> +++ b/security/keys/dh.c
> @@ -77,14 +77,74 @@ error:
> 	return ret;
> }
>
> +static int keyctl_dh_compute_kdf(struct keyctl_kdf_params *kdfcopy,
> +				 char __user *buffer, size_t buflen,
> +				 uint8_t *kbuf, size_t resultlen)
> +{

Minor point: this function name made me think it was a replacement for 
keyctl_dh_compute at first (like the userspace counterpart).

> +	char kdfname[CRYPTO_MAX_ALG_NAME] = { 0 };
> +	struct crypto_rng *tfm;
> +	uint8_t *outbuf = NULL;
> +	int ret;
> +
> +	BUILD_BUG_ON(CRYPTO_MAX_ALG_NAME != KEYCTL_KDF_MAX_STRING_LEN);

If this is a requirement, why define KEYCTL_KDF_MAX_STRING_LEN? Use 
CRYPTO_MAX_ALG_NAME directly.

> +	if (!kdfcopy->kdfnamelen)
> +		return -EFAULT;
> +	if (copy_from_user(&kdfname, kdfcopy->kdfname,
> +			   kdfcopy->kdfnamelen) != 0)

strndup_user works nicely for strings.

> +		return -EFAULT;
> +

It would be best to validate all of the userspace input before the DH 
computation is done.

> +	/*
> +	 * Concatenate otherinfo past DH shared secret -- the
> +	 * input to the KDF is (DH shared secret || otherinfo)
> +	 */
> +	if (kdfcopy->otherinfo &&
> +	    copy_from_user(kbuf + resultlen, kdfcopy->otherinfo,
> +			   kdfcopy->otherinfolen)
> +	    != 0)
> +		return -EFAULT;
> +
> +	tfm = crypto_alloc_rng(kdfname, 0, 0);
> +	if (IS_ERR(tfm))
> +		return PTR_ERR(tfm);
> +
> +#if 0
> +	/* we do not support HMAC currently */
> +	ret = crypto_rng_reset(tfm, xx, xxlen);
> +	if (ret) {
> +		crypto_free_rng(tfm);
> +		goto error5;
> +	}
> +#endif
> +
> +	outbuf = kmalloc(buflen, GFP_KERNEL);
> +	if (!outbuf) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	ret = crypto_rng_generate(tfm, kbuf, resultlen + kdfcopy->otherinfolen,
> +				  outbuf, buflen);
> +	if (ret)
> +		goto err;
> +
> +	ret = buflen;
> +	if (copy_to_user(buffer, outbuf, buflen) != 0)
> +		ret = -EFAULT;
> +
> +err:
> +	kzfree(outbuf);
> +	crypto_free_rng(tfm);
> +	return ret;
> +}
> long keyctl_dh_compute(struct keyctl_dh_params __user *params,
> 		       char __user *buffer, size_t buflen,
> -		       void __user *reserved)
> +		       struct keyctl_kdf_params __user *kdf)
> {
> 	long ret;
> 	MPI base, private, prime, result;
> 	unsigned nbytes;
> 	struct keyctl_dh_params pcopy;
> +	struct keyctl_kdf_params kdfcopy;
> 	uint8_t *kbuf;
> 	ssize_t keylen;
> 	size_t resultlen;
> @@ -98,12 +158,24 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
> 		goto out;
> 	}
>
> -	if (reserved) {
> -		ret = -EINVAL;
> -		goto out;
> +	if (kdf) {
> +		if (copy_from_user(&kdfcopy, kdf, sizeof(kdfcopy)) != 0) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +		if (buflen > KEYCTL_KDF_MAX_OUTPUTLEN ||
> +		    kdfcopy.otherinfolen > KEYCTL_KDF_MAX_STRING_LEN ||
> +		    kdfcopy.kdfnamelen > KEYCTL_KDF_MAX_STRING_LEN) {
> +			ret = -EMSGSIZE;
> +			goto out;
> +		}
> 	}
>
> -	keylen = mpi_from_key(pcopy.prime, buflen, &prime);
> +	/*
> +	 * If the caller requests postprocessing with a KDF, allow an
> +	 * arbitrary output buffer size since the KDF ensures proper truncation.
> +	 */
> +	keylen = mpi_from_key(pcopy.prime, kdf ? SIZE_MAX : buflen, &prime);
> 	if (keylen < 0 || !prime) {
> 		/* buflen == 0 may be used to query the required buffer size,
> 		 * which is the prime key length.
> @@ -133,7 +205,8 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
> 		goto error3;
> 	}
>
> -	kbuf = kmalloc(resultlen, GFP_KERNEL);
> +	kbuf = kmalloc(kdf ? (resultlen + kdfcopy.otherinfolen) : resultlen,
> +		       GFP_KERNEL);
> 	if (!kbuf) {
> 		ret = -ENOMEM;
> 		goto error4;
> @@ -147,12 +220,17 @@ long keyctl_dh_compute(struct keyctl_dh_params __user *params,
> 	if (ret != 0)
> 		goto error5;
>
> -	ret = nbytes;
> -	if (copy_to_user(buffer, kbuf, nbytes) != 0)
> -		ret = -EFAULT;
> +	if (kdf) {
> +		ret = keyctl_dh_compute_kdf(&kdfcopy, buffer, buflen,
> +					    kbuf, resultlen);
> +	} else {
> +		ret = nbytes;
> +		if (copy_to_user(buffer, kbuf, nbytes) != 0)
> +			ret = -EFAULT;
> +	}
>
> error5:
> -	kfree(kbuf);
> +	kzfree(kbuf);

Thanks for adjusting this.

> error4:
> 	mpi_free(result);
> error3:
> diff --git a/security/keys/internal.h b/security/keys/internal.h
> index a705a7d..35a8d11 100644
> --- a/security/keys/internal.h
> +++ b/security/keys/internal.h
> @@ -259,12 +259,13 @@ static inline long keyctl_get_persistent(uid_t uid, key_serial_t destring)
> #endif
>
> #ifdef CONFIG_KEY_DH_OPERATIONS
> +#include <crypto/rng.h>
> extern long keyctl_dh_compute(struct keyctl_dh_params __user *, char __user *,
> -			      size_t, void __user *);
> +			      size_t, struct keyctl_kdf_params __user *);
> #else
> static inline long keyctl_dh_compute(struct keyctl_dh_params __user *params,
> 				     char __user *buffer, size_t buflen,
> -				     void __user *reserved)
> +				     struct keyctl_kdf_params __user *kdf)
> {
> 	return -EOPNOTSUPP;
> }
> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> index d580ad0..b106898 100644
> --- a/security/keys/keyctl.c
> +++ b/security/keys/keyctl.c
> @@ -1689,7 +1689,7 @@ SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
> 	case KEYCTL_DH_COMPUTE:
> 		return keyctl_dh_compute((struct keyctl_dh_params __user *) arg2,
> 					 (char __user *) arg3, (size_t) arg4,
> -					 (void __user *) arg5);
> +					 (struct keyctl_kdf_params __user *) arg5);
>
> 	default:
> 		return -EOPNOTSUPP;


Regards,

--
Mat Martineau
Intel OTC
