From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC PATCH] KEYS: add SP800-56A KDF support for DH
Date: Fri, 15 Jul 2016 18:38:19 +0200
Message-ID: <25767136.yGpxH6HqEs@tauon.atsec.com>
References: <4161793.TTVXSVQtZL@positron.chronox.de> <alpine.OSX.2.20.1607141654250.69287@istotlan-mobl1.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39232 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbcGOQi0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jul 2016 12:38:26 -0400
In-Reply-To: <alpine.OSX.2.20.1607141654250.69287@istotlan-mobl1.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 14. Juli 2016, 17:45:59 schrieb Mat Martineau:

Hi Mat,

> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> > include/uapi/linux/keyctl.h | 10 +++++
> > security/keys/Kconfig       |  1 +
> > security/keys/dh.c          | 98
> > ++++++++++++++++++++++++++++++++++++++++----- security/keys/internal.h   
> > |  5 ++-
> > security/keys/keyctl.c      |  2 +-
> > 5 files changed, 103 insertions(+), 13 deletions(-)
> 
> Be sure to update Documentation/security/keys.txt once the interface is
> settled on.

Thanks for the reminder
> 
> > diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
> > index 86eddd6..cc4ce7c 100644
> > --- a/include/uapi/linux/keyctl.h
> > +++ b/include/uapi/linux/keyctl.h
> > @@ -68,4 +68,14 @@ struct keyctl_dh_params {
> > 
> > 	__s32 base;
> > 
> > };
> > 
> > +struct keyctl_kdf_params {
> > +#define KEYCTL_KDF_MAX_OUTPUTLEN	1024	/* max length of KDF output */
> > +#define KEYCTL_KDF_MAX_STRING_LEN	64	/* maximum length of strings 
*/
> 
> I think these limits should be in the internal headers rather than uapi.

Ok
> 
> > +	char *kdfname;
> > +	__u32 kdfnamelen;
> 
> As noted in the userspace patch, if kdfname is a null-terminated string
> then kdfnamelen isn't needed.

Ok
> 
> > +	char *otherinfo;
> > +	__u32 otherinfolen;
> > +	__u32 flags;
> 
> Looks like flags aren't used anywhere. Do you have a use planned? You
> could add some spare capacity like the keyctl_pkey_* structs instead (see
> https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h
> =keys-next&id=dd7e2ea418b4f8851a4eb976b9431fbc03d2ebaf )

I am not sure what to do here: I see the profileration of new syscalls which 
just differ from existing syscalls by a new flags field because the initial 
implementation simply missed such thing.

I want to avoid something like this happening here.

I am open for any suggestions.
> 
> > +};
> > +
> > #endif /*  _LINUX_KEYCTL_H */
> > diff --git a/security/keys/Kconfig b/security/keys/Kconfig
> > index f826e87..56491fe 100644
> > --- a/security/keys/Kconfig
> > +++ b/security/keys/Kconfig
> > @@ -90,6 +90,7 @@ config KEY_DH_OPERATIONS
> > 
> >        bool "Diffie-Hellman operations on retained keys"
> >        depends on KEYS
> >        select MPILIB
> > 
> > +       select CRYPTO_KDF
> > 
> >        help
> > 	 
> > 	 This option provides support for calculating Diffie-Hellman
> > 	 public keys and shared secrets using values stored as keys
> > 
> > diff --git a/security/keys/dh.c b/security/keys/dh.c
> > index 531ed2e..4c93969 100644
> > --- a/security/keys/dh.c
> > +++ b/security/keys/dh.c
> > 
> > @@ -77,14 +77,74 @@ error:
> > 	return ret;
> > 
> > }
> > 
> > +static int keyctl_dh_compute_kdf(struct keyctl_kdf_params *kdfcopy,
> > +				 char __user *buffer, size_t buflen,
> > +				 uint8_t *kbuf, size_t resultlen)
> > +{
> 
> Minor point: this function name made me think it was a replacement for
> keyctl_dh_compute at first (like the userspace counterpart).

Well, initially I had it part of dh_compute, but then extracted it to make the 
code nicer and less distracting.

> 
> > +	char kdfname[CRYPTO_MAX_ALG_NAME] = { 0 };
> > +	struct crypto_rng *tfm;
> > +	uint8_t *outbuf = NULL;
> > +	int ret;
> > +
> > +	BUILD_BUG_ON(CRYPTO_MAX_ALG_NAME != KEYCTL_KDF_MAX_STRING_LEN);
> 
> If this is a requirement, why define KEYCTL_KDF_MAX_STRING_LEN? Use
> CRYPTO_MAX_ALG_NAME directly.

Ok, I was not sure if I am allowed to add a crypto API header to key header 
files.
> 
> > +	if (!kdfcopy->kdfnamelen)
> > +		return -EFAULT;
> > +	if (copy_from_user(&kdfname, kdfcopy->kdfname,
> > +			   kdfcopy->kdfnamelen) != 0)
> 
> strndup_user works nicely for strings.

yes.
> 
> > +		return -EFAULT;
> > +
> 
> It would be best to validate all of the userspace input before the DH
> computation is done.

Uh, that means I cannot have a separate dh_compute_kdf function. But, ok, no 
problem.
> 
> > +	/*
> > +	 * Concatenate otherinfo past DH shared secret -- the
> > +	 * input to the KDF is (DH shared secret || otherinfo)
> > +	 */
> > +	if (kdfcopy->otherinfo &&
> > +	    copy_from_user(kbuf + resultlen, kdfcopy->otherinfo,
> > +			   kdfcopy->otherinfolen)
> > +	    != 0)
> > +		return -EFAULT;
> > +
> > +	tfm = crypto_alloc_rng(kdfname, 0, 0);
> > +	if (IS_ERR(tfm))
> > +		return PTR_ERR(tfm);
> > +
> > +#if 0
> > +	/* we do not support HMAC currently */
> > +	ret = crypto_rng_reset(tfm, xx, xxlen);
> > +	if (ret) {
> > +		crypto_free_rng(tfm);
> > +		goto error5;
> > +	}
> > +#endif
> > +
> > +	outbuf = kmalloc(buflen, GFP_KERNEL);
> > +	if (!outbuf) {
> > +		ret = -ENOMEM;
> > +		goto err;
> > +	}
> > +
> > +	ret = crypto_rng_generate(tfm, kbuf, resultlen + kdfcopy-
>otherinfolen,
> > +				  outbuf, buflen);
> > +	if (ret)
> > +		goto err;
> > +
> > +	ret = buflen;
> > +	if (copy_to_user(buffer, outbuf, buflen) != 0)
> > +		ret = -EFAULT;
> > +
> > +err:
> > +	kzfree(outbuf);
> > +	crypto_free_rng(tfm);
> > +	return ret;
> > +}
> > long keyctl_dh_compute(struct keyctl_dh_params __user *params,
> > 
> > 		       char __user *buffer, size_t buflen,
> > 
> > -		       void __user *reserved)
> > +		       struct keyctl_kdf_params __user *kdf)
> > {
> > 
> > 	long ret;
> > 	MPI base, private, prime, result;
> > 	unsigned nbytes;
> > 	struct keyctl_dh_params pcopy;
> > 
> > +	struct keyctl_kdf_params kdfcopy;
> > 
> > 	uint8_t *kbuf;
> > 	ssize_t keylen;
> > 	size_t resultlen;
> > 
> > @@ -98,12 +158,24 @@ long keyctl_dh_compute(struct keyctl_dh_params __user
> > *params,> 
> > 		goto out;
> > 	
> > 	}
> > 
> > -	if (reserved) {
> > -		ret = -EINVAL;
> > -		goto out;
> > +	if (kdf) {
> > +		if (copy_from_user(&kdfcopy, kdf, sizeof(kdfcopy)) != 0) {
> > +			ret = -EFAULT;
> > +			goto out;
> > +		}
> > +		if (buflen > KEYCTL_KDF_MAX_OUTPUTLEN ||
> > +		    kdfcopy.otherinfolen > KEYCTL_KDF_MAX_STRING_LEN ||
> > +		    kdfcopy.kdfnamelen > KEYCTL_KDF_MAX_STRING_LEN) {
> > +			ret = -EMSGSIZE;
> > +			goto out;
> > +		}
> > 
> > 	}
> > 
> > -	keylen = mpi_from_key(pcopy.prime, buflen, &prime);
> > +	/*
> > +	 * If the caller requests postprocessing with a KDF, allow an
> > +	 * arbitrary output buffer size since the KDF ensures proper 
truncation.
> > +	 */
> > +	keylen = mpi_from_key(pcopy.prime, kdf ? SIZE_MAX : buflen, &prime);
> > 
> > 	if (keylen < 0 || !prime) {
> > 	
> > 		/* buflen == 0 may be used to query the required buffer size,
> > 		
> > 		 * which is the prime key length.
> > 
> > @@ -133,7 +205,8 @@ long keyctl_dh_compute(struct keyctl_dh_params __user
> > *params,> 
> > 		goto error3;
> > 	
> > 	}
> > 
> > -	kbuf = kmalloc(resultlen, GFP_KERNEL);
> > +	kbuf = kmalloc(kdf ? (resultlen + kdfcopy.otherinfolen) : resultlen,
> > +		       GFP_KERNEL);
> > 
> > 	if (!kbuf) {
> > 	
> > 		ret = -ENOMEM;
> > 		goto error4;
> > 
> > @@ -147,12 +220,17 @@ long keyctl_dh_compute(struct keyctl_dh_params
> > __user *params,> 
> > 	if (ret != 0)
> > 	
> > 		goto error5;
> > 
> > -	ret = nbytes;
> > -	if (copy_to_user(buffer, kbuf, nbytes) != 0)
> > -		ret = -EFAULT;
> > +	if (kdf) {
> > +		ret = keyctl_dh_compute_kdf(&kdfcopy, buffer, buflen,
> > +					    kbuf, resultlen);
> > +	} else {
> > +		ret = nbytes;
> > +		if (copy_to_user(buffer, kbuf, nbytes) != 0)
> > +			ret = -EFAULT;
> > +	}
> > 
> > error5:
> > -	kfree(kbuf);
> > +	kzfree(kbuf);
> 
> Thanks for adjusting this.

I hope it is ok to not have it in a separate patch.
> 
> > error4:
> > 	mpi_free(result);
> > 
> > error3:
> > diff --git a/security/keys/internal.h b/security/keys/internal.h
> > index a705a7d..35a8d11 100644
> > --- a/security/keys/internal.h
> > +++ b/security/keys/internal.h
> > @@ -259,12 +259,13 @@ static inline long keyctl_get_persistent(uid_t uid,
> > key_serial_t destring) #endif
> > 
> > #ifdef CONFIG_KEY_DH_OPERATIONS
> > +#include <crypto/rng.h>
> > extern long keyctl_dh_compute(struct keyctl_dh_params __user *, char
> > __user *, -			      size_t, void __user *);
> > +			      size_t, struct keyctl_kdf_params __user *);
> > #else
> > static inline long keyctl_dh_compute(struct keyctl_dh_params __user
> > *params,> 
> > 				     char __user *buffer, size_t buflen,
> > 
> > -				     void __user *reserved)
> > +				     struct keyctl_kdf_params __user *kdf)
> > {
> > 
> > 	return -EOPNOTSUPP;
> > 
> > }
> > diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> > index d580ad0..b106898 100644
> > --- a/security/keys/keyctl.c
> > +++ b/security/keys/keyctl.c
> > @@ -1689,7 +1689,7 @@ SYSCALL_DEFINE5(keyctl, int, option, unsigned long,
> > arg2, unsigned long, arg3,> 
> > 	case KEYCTL_DH_COMPUTE:
> > 		return keyctl_dh_compute((struct keyctl_dh_params __user *) 
arg2,
> > 		
> > 					 (char __user *) arg3, (size_t) arg4,
> > 
> > -					 (void __user *) arg5);
> > +					 (struct keyctl_kdf_params __user *) 
arg5);
> > 
> > 	default:
> > 		return -EOPNOTSUPP;
> 
> Regards,
> 
> --
> Mat Martineau
> Intel OTC


Ciao
Stephan
