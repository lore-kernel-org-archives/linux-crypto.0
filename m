From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 12/18] MODSIGN: Export module signature definitions
Date: Thu, 26 Oct 2017 16:12:08 -0400
Message-ID: <1509048728.5886.112.camel@linux.vnet.ibm.com>
References: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
         <20171018005331.2688-13-bauerman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
To: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>,
        linux-integrity@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171018005331.2688-13-bauerman@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2017-10-17 at 22:53 -0200, Thiago Jung Bauermann wrote:
> IMA will use the module_signature format for append signatures, so export
> the relevant definitions and factor out the code which verifies that the
> appended signature trailer is valid.
> 
> Also, create a CONFIG_MODULE_SIG_FORMAT option so that IMA can select it
> and be able to use validate_module_signature without having to depend on
> CONFIG_MODULE_SIG.
> 
> Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>

Reviewed-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

One minor comment below...

> ---
>  include/linux/module.h           |  3 --
>  include/linux/module_signature.h | 47 +++++++++++++++++++++++++
>  init/Kconfig                     |  6 +++-
>  kernel/Makefile                  |  2 +-
>  kernel/module.c                  |  1 +
>  kernel/module_signing.c          | 74 +++++++++++++++++-----------------------
>  6 files changed, 85 insertions(+), 48 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index fe5aa3736707..108874af9838 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -23,9 +23,6 @@
>  #include <linux/percpu.h>
>  #include <asm/module.h>
> 
> -/* In stripped ARM and x86-64 modules, ~ is surprisingly rare. */
> -#define MODULE_SIG_STRING "~Module signature appended~\n"
> -
>  /* Not Yet Implemented */
>  #define MODULE_SUPPORTED_DEVICE(name)
> 
> diff --git a/include/linux/module_signature.h b/include/linux/module_signature.h
> new file mode 100644
> index 000000000000..e80728e5b86c
> --- /dev/null
> +++ b/include/linux/module_signature.h
> @@ -0,0 +1,47 @@
> +/* Module signature handling.
> + *
> + * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#ifndef _LINUX_MODULE_SIGNATURE_H
> +#define _LINUX_MODULE_SIGNATURE_H
> +
> +/* In stripped ARM and x86-64 modules, ~ is surprisingly rare. */
> +#define MODULE_SIG_STRING "~Module signature appended~\n"
> +
> +enum pkey_id_type {
> +	PKEY_ID_PGP,		/* OpenPGP generated key ID */
> +	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
> +	PKEY_ID_PKCS7,		/* Signature in PKCS#7 message */
> +};
> +
> +/*
> + * Module signature information block.
> + *
> + * The constituents of the signature section are, in order:
> + *
> + *	- Signer's name
> + *	- Key identifier
> + *	- Signature data
> + *	- Information block
> + */
> +struct module_signature {
> +	u8	algo;		/* Public-key crypto algorithm [0] */
> +	u8	hash;		/* Digest algorithm [0] */
> +	u8	id_type;	/* Key identifier type [PKEY_ID_PKCS7] */
> +	u8	signer_len;	/* Length of signer's name [0] */
> +	u8	key_id_len;	/* Length of key identifier [0] */
> +	u8	__pad[3];
> +	__be32	sig_len;	/* Length of signature data */
> +};
> +
> +int validate_module_sig(const struct module_signature *ms, size_t file_len);
> +int mod_verify_sig(const void *mod, unsigned long *_modlen);
> +
> +#endif /* _LINUX_MODULE_SIGNATURE_H */
> diff --git a/init/Kconfig b/init/Kconfig
> index 78cb2461012e..230e9f3aedaf 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1748,7 +1748,7 @@ config MODULE_SRCVERSION_ALL
>  config MODULE_SIG
>  	bool "Module signature verification"
>  	depends on MODULES
> -	select SYSTEM_DATA_VERIFICATION
> +	select MODULE_SIG_FORMAT
>  	help
>  	  Check modules for valid signatures upon load: the signature
>  	  is simply appended to the module. For more information see
> @@ -1763,6 +1763,10 @@ config MODULE_SIG
>  	  debuginfo strip done by some packagers (such as rpmbuild) and
>  	  inclusion into an initramfs that wants the module size reduced.
> 
> +config MODULE_SIG_FORMAT
> +	def_bool n
> +	select SYSTEM_DATA_VERIFICATION
> +
>  config MODULE_SIG_FORCE
>  	bool "Require modules to be validly signed"
>  	depends on MODULE_SIG
> diff --git a/kernel/Makefile b/kernel/Makefile
> index ed470aac53da..20fd6d76232e 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -57,7 +57,7 @@ obj-y += up.o
>  endif
>  obj-$(CONFIG_UID16) += uid16.o
>  obj-$(CONFIG_MODULES) += module.o
> -obj-$(CONFIG_MODULE_SIG) += module_signing.o
> +obj-$(CONFIG_MODULE_SIG_FORMAT) += module_signing.o
>  obj-$(CONFIG_KALLSYMS) += kallsyms.o
>  obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
>  obj-$(CONFIG_CRASH_CORE) += crash_core.o
> diff --git a/kernel/module.c b/kernel/module.c
> index de66ec825992..a259e9df570d 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -19,6 +19,7 @@
>  #include <linux/export.h>
>  #include <linux/extable.h>
>  #include <linux/moduleloader.h>
> +#include <linux/module_signature.h>
>  #include <linux/trace_events.h>
>  #include <linux/init.h>
>  #include <linux/kallsyms.h>
> diff --git a/kernel/module_signing.c b/kernel/module_signing.c
> index 937c844bee4a..204c60d4cc9f 100644
> --- a/kernel/module_signing.c
> +++ b/kernel/module_signing.c
> @@ -11,36 +11,38 @@
> 
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
> +#include <linux/module_signature.h>
>  #include <linux/string.h>
>  #include <linux/verification.h>
>  #include <crypto/public_key.h>
>  #include "module-internal.h"
> 
> -enum pkey_id_type {
> -	PKEY_ID_PGP,		/* OpenPGP generated key ID */
> -	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
> -	PKEY_ID_PKCS7,		/* Signature in PKCS#7 message */
> -};
> -
> -/*
> - * Module signature information block.
> - *
> - * The constituents of the signature section are, in order:
> +/**
> + * validate_module_sig - validate that the given signature is sane
>   *
> - *	- Signer's name
> - *	- Key identifier
> - *	- Signature data
> - *	- Information block
> + * @ms:		Signature to validate.
> + * @file_len:	Size of the file to which @ms is appended.
>   */
> -struct module_signature {
> -	u8	algo;		/* Public-key crypto algorithm [0] */
> -	u8	hash;		/* Digest algorithm [0] */
> -	u8	id_type;	/* Key identifier type [PKEY_ID_PKCS7] */
> -	u8	signer_len;	/* Length of signer's name [0] */
> -	u8	key_id_len;	/* Length of key identifier [0] */
> -	u8	__pad[3];
> -	__be32	sig_len;	/* Length of signature data */
> -};
> +int validate_module_sig(const struct module_signature *ms, size_t file_len)
> +{
> +	if (be32_to_cpu(ms->sig_len) >= file_len - sizeof(*ms))
> +		return -EBADMSG;
> +	else if (ms->id_type != PKEY_ID_PKCS7) {
> +		pr_err("Module is not signed with expected PKCS#7 message\n");
> +		return -ENOPKG;
> +	} else if (ms->algo != 0 ||
> +		   ms->hash != 0 ||
> +		   ms->signer_len != 0 ||
> +		   ms->key_id_len != 0 ||
> +		   ms->__pad[0] != 0 ||
> +		   ms->__pad[1] != 0 ||
> +		   ms->__pad[2] != 0) {
> +		pr_err("PKCS#7 signature info has unexpected non-zero params\n");
> +		return -EBADMSG;
> +	}
> +

When moving code from one place to another, it's easier to review when
there aren't code changes as well.  In this case, the original code
doesn't have "else clauses".  Here some of the if/then/else clauses
have braces others don't.  There shouldn't be a mixture.

Mimi

> +	return 0;
> +}
> 
>  /*
>   * Verify the signature on a module.
> @@ -49,6 +51,7 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
>  {
>  	struct module_signature ms;
>  	size_t modlen = *_modlen, sig_len;
> +	int ret;
> 
>  	pr_devel("==>%s(,%zu)\n", __func__, modlen);
> 
> @@ -56,30 +59,15 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
>  		return -EBADMSG;
> 
>  	memcpy(&ms, mod + (modlen - sizeof(ms)), sizeof(ms));
> -	modlen -= sizeof(ms);
> +
> +	ret = validate_module_sig(&ms, modlen);
> +	if (ret)
> +		return ret;
> 
>  	sig_len = be32_to_cpu(ms.sig_len);
> -	if (sig_len >= modlen)
> -		return -EBADMSG;
> -	modlen -= sig_len;
> +	modlen -= sig_len + sizeof(ms);
>  	*_modlen = modlen;
> 
> -	if (ms.id_type != PKEY_ID_PKCS7) {
> -		pr_err("Module is not signed with expected PKCS#7 message\n");
> -		return -ENOPKG;
> -	}
> -
> -	if (ms.algo != 0 ||
> -	    ms.hash != 0 ||
> -	    ms.signer_len != 0 ||
> -	    ms.key_id_len != 0 ||
> -	    ms.__pad[0] != 0 ||
> -	    ms.__pad[1] != 0 ||
> -	    ms.__pad[2] != 0) {
> -		pr_err("PKCS#7 signature info has unexpected non-zero params\n");
> -		return -EBADMSG;
> -	}
> -
>  	return verify_pkcs7_signature(mod, modlen, mod + modlen, sig_len,
>  				      NULL, VERIFYING_MODULE_SIGNATURE,
>  				      NULL, NULL);
> 

