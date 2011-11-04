From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2.2 6/7] integrity: digital signature verification
 using multiple keyrings
Date: Fri, 04 Nov 2011 07:29:46 -0400
Message-ID: <1320406187.2010.11.camel@falcor>
References: <cover.1319025009.git.dmitry.kasatkin@intel.com>
	 <f094bd1603dcf682b8ab5fb41af7c5635cb04d23.1319025009.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, herbert@gondor.apana.org.au
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:36406 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1KDLbN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Nov 2011 07:31:13 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Fri, 4 Nov 2011 05:31:06 -0600
In-Reply-To: <f094bd1603dcf682b8ab5fb41af7c5635cb04d23.1319025009.git.dmitry.kasatkin@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2011-10-19 at 14:51 +0300, Dmitry Kasatkin wrote:
> Define separate keyrings for each of the different use cases - evm, ima,
> and modules. Using different keyrings improves search performance, and also
> allows "locking" specific keyring to prevent adding new keys.
> This is useful for evm and module keyrings, when keys are usually only
> added from initramfs.
> 
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

Thanks Dmitry!  Other than the couple of trailing whitespaces, the
patches look good.  I think adding the word 'public', above, to 'adding
new keys' clarifies that the keyrings are only used for the digital
signatures.

Acked-by: Mimi Zohar <zohar@us.ibm.com>

> ---
>  security/integrity/Kconfig     |   14 +++++++++++
>  security/integrity/Makefile    |    1 +
>  security/integrity/digsig.c    |   48 ++++++++++++++++++++++++++++++++++++++++
>  security/integrity/integrity.h |   20 ++++++++++++++++
>  4 files changed, 83 insertions(+), 0 deletions(-)
>  create mode 100644 security/integrity/digsig.c
> 
> diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
> index 4bf00ac..d87fa2a 100644
> --- a/security/integrity/Kconfig
> +++ b/security/integrity/Kconfig
> @@ -3,5 +3,19 @@ config INTEGRITY
>  	def_bool y
>  	depends on IMA || EVM
> 
> +config INTEGRITY_DIGSIG
> +	boolean "Digital signature verification using multiple keyrings"
> +	depends on INTEGRITY
> +	default n
> +	select DIGSIG
> +	help
> +	  This option enables digital signature verification support
> +	  using multiple keyrings. It defines separate keyrings for each
> +	  of the different use cases - evm, ima, and modules.
> +	  Different keyrings improves search performance, but also allow
> +	  to "lock" certain keyring to prevent adding new keys.
> +	  This is useful for evm and module keyrings, when keys are
> +	  usually only added from initramfs.
> +
>  source security/integrity/ima/Kconfig
>  source security/integrity/evm/Kconfig
> diff --git a/security/integrity/Makefile b/security/integrity/Makefile
> index 0ae44ae..bece056 100644
> --- a/security/integrity/Makefile
> +++ b/security/integrity/Makefile
> @@ -3,6 +3,7 @@
>  #
> 
>  obj-$(CONFIG_INTEGRITY) += integrity.o
> +obj-$(CONFIG_INTEGRITY_DIGSIG) += digsig.o
> 
>  integrity-y := iint.o
> 
> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
> new file mode 100644
> index 0000000..b5d1e01
> --- /dev/null
> +++ b/security/integrity/digsig.c
> @@ -0,0 +1,48 @@
> +/*
> + * Copyright (C) 2011 Intel Corporation
> + *
> + * Author:
> + * Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, version 2 of the License.
> + *
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/err.h>
> +#include <linux/rbtree.h>
> +#include <linux/key-type.h>
> +#include <linux/digsig.h>
> +
> +#include "integrity.h"
> +
> +static struct key *keyring[INTEGRITY_KEYRING_MAX];
> +
> +static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
> +	"_evm",
> +	"_module",
> +	"_ima",
> +};
> +
> +int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
> +					const char *digest, int digestlen)
> +{
> +	if (id >= INTEGRITY_KEYRING_MAX)
> +		return -EINVAL;
> +
> +	if (!keyring[id]) {
> +		keyring[id] =
> +			request_key(&key_type_keyring, keyring_name[id], NULL);
> +		if (IS_ERR(keyring[id])) {
> +			pr_err("no %s keyring: %ld\n", keyring_name[id],
> +							PTR_ERR(keyring[id]));
> +			keyring[id] = NULL;
> +			return PTR_ERR(keyring[id]);
> +		}
> +	}
> +
> +	return digsig_verify(keyring[id], sig, siglen, digest, digestlen);
> +}
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index e898094..9fc723b 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -51,5 +51,25 @@ struct integrity_iint_cache {
>  struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
>  struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
> 
> +#define INTEGRITY_KEYRING_EVM		0
> +#define INTEGRITY_KEYRING_MODULE	1
> +#define INTEGRITY_KEYRING_IMA		2
> +#define INTEGRITY_KEYRING_MAX		3
> +
> +#ifdef CONFIG_INTEGRITY_DIGSIG
> +
> +int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
> +					const char *digest, int digestlen);
> +
> +#else
> +
> +static inline int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
> +					const char *digest, int digestlen)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +#endif /* CONFIG_INTEGRITY_DIGSIG */
> +
>  /* set during initialization */
>  extern int iint_initialized;
