From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH v3] KEYS: add SP800-56A KDF support for DH
Date: Tue, 9 Aug 2016 15:48:00 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1608091546100.24354@mjmartin-mac01.local>
References: <2239809.KsND40bFeW@positron.chronox.de> <2623005.lF82gu89UT@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33128 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461AbcHIWsC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 18:48:02 -0400
In-Reply-To: <2623005.lF82gu89UT@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Sat, 6 Aug 2016, Stephan Mueller wrote:

> diff --git a/security/keys/internal.h b/security/keys/internal.h
> index a705a7d..7659b52 100644
> --- a/security/keys/internal.h
> +++ b/security/keys/internal.h
> @@ -259,15 +259,32 @@ static inline long keyctl_get_persistent(uid_t uid, key_serial_t destring)
> #endif
>
> #ifdef CONFIG_KEY_DH_OPERATIONS
> +#include <crypto/rng.h>
> +#include <linux/compat.h>

These may belong at the top of the file, even if they are only used when 
CONFIG_KEY_DH_OPERATIONS is defined.

> extern long keyctl_dh_compute(struct keyctl_dh_params __user *, char __user *,
> -			      size_t, void __user *);
> +			      size_t, struct keyctl_kdf_params __user *);
> +extern long __keyctl_dh_compute(struct keyctl_dh_params __user *, char __user *,
> +				size_t, struct keyctl_kdf_params *);
> +extern long compat_keyctl_dh_compute(struct keyctl_dh_params __user *params,
> +				char __user *buffer, size_t buflen,
> +				struct compat_keyctl_kdf_params __user *kdf);
> +#define KEYCTL_KDF_MAX_OUTPUT_LEN	1024	/* max length of KDF output */
> +#define KEYCTL_KDF_MAX_OI_LEN		64	/* max length of otherinfo */
> #else
> static inline long keyctl_dh_compute(struct keyctl_dh_params __user *params,
> 				     char __user *buffer, size_t buflen,
> -				     void __user *reserved)
> +				     struct keyctl_kdf_params __user *kdf)
> {
> 	return -EOPNOTSUPP;
> }
> +
> +static inline long compat_keyctl_dh_compute(
> +				struct keyctl_dh_params __user *params,
> +				char __user *buffer, size_t buflen,
> +				struct keyctl_kdf_params __user *kdf)
> +{
> +	return -EOPNOTSUPP
> +}
> #endif
>
> /*
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
