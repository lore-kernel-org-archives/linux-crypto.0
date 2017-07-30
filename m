From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 7/7] ima: Support module-style appended signatures
 for appraisal
Date: Sun, 30 Jul 2017 10:29:48 -0400
Message-ID: <1501424988.9230.67.camel@linux.vnet.ibm.com>
References: <20170706221753.17380-1-bauerman@linux.vnet.ibm.com>
         <20170706221753.17380-8-bauerman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
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
        linux-security-module@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170706221753.17380-8-bauerman@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2017-07-06 at 19:17 -0300, Thiago Jung Bauermann wrote:
> This patch introduces the modsig keyword to the IMA policy syntax to
> specify that a given hook should expect the file to have the IMA signature
> appended to it. Here is how it can be used in a rule:
> 
> appraise func=KEXEC_KERNEL_CHECK appraise_type=modsig|imasig
> 
> With this rule, IMA will accept either an appended signature or a signature
> stored in the extended attribute. In that case, it will first check whether
> there is an appended signature, and if not it will read it from the
> extended attribute.
> 
> The format of the appended signature is the same used for signed kernel
> modules. This means that the file can be signed with the scripts/sign-file
> tool, with a command line such as this:
> 
> $ sign-file sha256 privkey_ima.pem x509_ima.der vmlinux
> 
> This code only works for files that are hashed from a memory buffer, not
> for files that are read from disk at the time of hash calculation. In other
> words, only hooks that use kernel_read_file can support appended
> signatures. This means that only FIRMWARE_CHECK, KEXEC_KERNEL_CHECK,
> KEXEC_INITRAMFS_CHECK and POLICY_CHECK can be supported.
> 
> This feature warrants a separate config option because enabling it brings
> in many other config options.
> 
> Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
> ---
>  security/integrity/ima/Kconfig            |  13 +++
>  security/integrity/ima/Makefile           |   1 +
>  security/integrity/ima/ima.h              |  60 ++++++++++--
>  security/integrity/ima/ima_appraise.c     | 102 ++++++++++++++++++---
>  security/integrity/ima/ima_main.c         |   7 +-
>  security/integrity/ima/ima_modsig.c       | 147 ++++++++++++++++++++++++++++++
>  security/integrity/ima/ima_policy.c       |  26 ++++--
>  security/integrity/ima/ima_template_lib.c |  14 ++-
>  security/integrity/integrity.h            |   4 +-
>  9 files changed, 343 insertions(+), 31 deletions(-)
> 
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index 35ef69312811..55f734a6124b 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -163,6 +163,19 @@ config IMA_APPRAISE_BOOTPARAM
>  	  This option enables the different "ima_appraise=" modes
>  	  (eg. fix, log) from the boot command line.
> 
> +config IMA_APPRAISE_MODSIG
> +	bool "Support module-style signatures for appraisal"
> +	depends on IMA_APPRAISE
> +	depends on INTEGRITY_ASYMMETRIC_KEYS
> +	select PKCS7_MESSAGE_PARSER
> +	select MODULE_SIG_FORMAT
> +	default n
> +	help
> +	   Adds support for signatures appended to files. The format of the
> +	   appended signature is the same used for signed kernel modules.
> +	   The modsig keyword can be used in the IMA policy to allow a hook
> +	   to accept such signatures.
> +
>  config IMA_TRUSTED_KEYRING
>  	bool "Require all keys on the .ima keyring be signed (deprecated)"
>  	depends on IMA_APPRAISE && SYSTEM_TRUSTED_KEYRING
> diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
> index 29f198bde02b..c72026acecc3 100644
> --- a/security/integrity/ima/Makefile
> +++ b/security/integrity/ima/Makefile
> @@ -8,5 +8,6 @@ obj-$(CONFIG_IMA) += ima.o
>  ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
>  	 ima_policy.o ima_template.o ima_template_lib.o
>  ima-$(CONFIG_IMA_APPRAISE) += ima_appraise.o
> +ima-$(CONFIG_IMA_APPRAISE_MODSIG) += ima_modsig.o
>  ima-$(CONFIG_HAVE_IMA_KEXEC) += ima_kexec.o
>  obj-$(CONFIG_IMA_BLACKLIST_KEYRING) += ima_mok.o
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index d52b487ad259..1e1e7c41ca19 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -190,6 +190,8 @@ enum ima_hooks {
>  	__ima_hooks(__ima_hook_enumify)
>  };
> 
> +extern const char *const func_tokens[];
> +
>  /* LIM API function definitions */
>  int ima_get_action(struct inode *inode, int mask,
>  		   enum ima_hooks func, int *pcr);
> @@ -236,9 +238,10 @@ int ima_policy_show(struct seq_file *m, void *v);
>  #ifdef CONFIG_IMA_APPRAISE
>  int ima_appraise_measurement(enum ima_hooks func,
>  			     struct integrity_iint_cache *iint,
> -			     struct file *file, const unsigned char *filename,
> -			     struct evm_ima_xattr_data *xattr_value,
> -			     int xattr_len, int opened);
> +			     struct file *file, const void *buf, loff_t size,
> +			     const unsigned char *filename,
> +			     struct evm_ima_xattr_data **xattr_value,
> +			     int *xattr_len, int opened);
>  int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func);
>  void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file);
>  enum integrity_status ima_get_cache_status(struct integrity_iint_cache *iint,
> @@ -248,13 +251,26 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
>  int ima_read_xattr(struct dentry *dentry,
>  		   struct evm_ima_xattr_data **xattr_value);
> 
> +#ifdef CONFIG_IMA_APPRAISE_MODSIG
> +bool ima_hook_supports_modsig(enum ima_hooks func);
> +int ima_read_modsig(const void *buf, loff_t buf_len,
> +		    struct evm_ima_xattr_data **xattr_value,
> +		    int *xattr_len);
> +int ima_modsig_serialize_data(struct evm_ima_xattr_data *hdr,
> +			      struct evm_ima_xattr_data **data, int *data_len);
> +int ima_modsig_verify(const unsigned int keyring_id,
> +		      struct evm_ima_xattr_data *hdr);
> +void ima_free_xattr_data(struct evm_ima_xattr_data *hdr);
> +#endif
> +
>  #else
>  static inline int ima_appraise_measurement(enum ima_hooks func,
>  					   struct integrity_iint_cache *iint,
> -					   struct file *file,
> +					   struct file *file, const void *buf,
> +					   loff_t size,
>  					   const unsigned char *filename,
> -					   struct evm_ima_xattr_data *xattr_value,
> -					   int xattr_len, int opened)
> +					   struct evm_ima_xattr_data **xattr_value,
> +					   int *xattr_len, int opened)
>  {
>  	return INTEGRITY_UNKNOWN;
>  }
> @@ -291,6 +307,38 @@ static inline int ima_read_xattr(struct dentry *dentry,
> 
>  #endif /* CONFIG_IMA_APPRAISE */
> 
> +#ifndef CONFIG_IMA_APPRAISE_MODSIG
> +static inline bool ima_hook_supports_modsig(enum ima_hooks func)
> +{
> +	return false;
> +}
> +
> +static inline int ima_read_modsig(const void *buf, loff_t buf_len,
> +				  struct evm_ima_xattr_data **xattr_value,
> +				  int *xattr_len)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static inline int ima_modsig_serialize_data(struct evm_ima_xattr_data *hdr,
> +					    struct evm_ima_xattr_data **data,
> +					    int *data_len)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static inline int ima_modsig_verify(const unsigned int keyring_id,
> +				    struct evm_ima_xattr_data *hdr)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static inline void ima_free_xattr_data(struct evm_ima_xattr_data *hdr)
> +{
> +	kfree(hdr);
> +}
> +#endif
> +
>  /* LSM based policy rules require audit */
>  #ifdef CONFIG_IMA_LSM_RULES
> 
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 87d2b601cf8e..b80aae429314 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -200,18 +200,40 @@ int ima_read_xattr(struct dentry *dentry,
>   */
>  int ima_appraise_measurement(enum ima_hooks func,
>  			     struct integrity_iint_cache *iint,
> -			     struct file *file, const unsigned char *filename,
> -			     struct evm_ima_xattr_data *xattr_value,
> -			     int xattr_len, int opened)
> +			     struct file *file, const void *buf, loff_t size,
> +			     const unsigned char *filename,
> +			     struct evm_ima_xattr_data **xattr_value_,
> +			     int *xattr_len_, int opened)
>  {
>  	static const char op[] = "appraise_data";
>  	char *cause = "unknown";
>  	struct dentry *dentry = file_dentry(file);
>  	struct inode *inode = d_backing_inode(dentry);
>  	enum integrity_status status = INTEGRITY_UNKNOWN;
> -	int rc = xattr_len, hash_start = 0;
> +	struct evm_ima_xattr_data *xattr_value = *xattr_value_;
> +	int xattr_len = *xattr_len_, rc = xattr_len, hash_start = 0;
> +	bool appraising_modsig = false;
> +	void *xattr_value_evm;
> +	size_t xattr_len_evm;
> +
> +	if (iint->flags & IMA_MODSIG_ALLOWED) {
> +		/*
> +		 * Not supposed to happen. Hooks that support modsig are
> +		 * whitelisted when parsing the policy using
> +		 * ima_hooks_supports_modsig.
> +		 */
> +		if (!buf || !size)
> +			WARN_ONCE(true, "%s doesn't support modsig\n",
> +				  func_tokens[func]);

ima _appraise_measurement() is getting kind of long.  Is there any
reason we can't move this comment and test to ima_read_modsig()?

> +		else if (!ima_read_modsig(buf, size,
> +					  &xattr_value, &xattr_len)) {
> +			appraising_modsig = true;
> +			rc = xattr_len;
> +		}
> +	}
> 
> -	if (!(inode->i_opflags & IOP_XATTR))
> +	/* If not appraising a modsig, we need an xattr. */
> +	if (!appraising_modsig && !(inode->i_opflags & IOP_XATTR))
>  		return INTEGRITY_UNKNOWN;
> 
>  	if (rc <= 0) {
> @@ -229,8 +251,24 @@ int ima_appraise_measurement(enum ima_hooks func,
>  		goto out;
>  	}
> 
> -	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
> -	if ((status != INTEGRITY_PASS) && (status != INTEGRITY_UNKNOWN)) {
> +	/*
> +	 * Appended signatures aren't protected by EVM but we still call
> +	 * evm_verifyxattr to check other security xattrs, if they exist.
> +	 */
> +	if (appraising_modsig) {
> +		xattr_value_evm = NULL;
> +		xattr_len_evm = 0;
> +	} else {
> +		xattr_value_evm = xattr_value;
> +		xattr_len_evm = xattr_len;
> +	}
> +
> +	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value_evm,
> +				 xattr_len_evm, iint);
> +	if (appraising_modsig && status == INTEGRITY_FAIL) {
> +		cause = "invalid-HMAC";
> +		goto out;

"modsig" is special, because having any security xattrs is not
required.  This test doesn't prevent status from being set to
"missing-HMAC".  This test is redundant with the original tests below.

> +	} else if (status != INTEGRITY_PASS && status != INTEGRITY_UNKNOWN) {
>  		if ((status == INTEGRITY_NOLABEL)
>  		    || (status == INTEGRITY_NOXATTRS))
>  			cause = "missing-HMAC";
> @@ -281,6 +319,43 @@ int ima_appraise_measurement(enum ima_hooks func,
>  			status = INTEGRITY_PASS;
>  		}

Calling evm_verifyxattr() with the IMA xattr value prevents EVM from
having to re-read the IMA xattr, but isn't necessary.  On modsig
signature verification failure, calling evm_verifyxattr() a second
time isn't necessary.

>  		break;
> +	case IMA_MODSIG:
> +		/*
> +		 * To avoid being tricked into recursion, we don't allow a
> +		 * modsig stored in the xattr.
> +		 */
> +		if (!appraising_modsig) {
> +			status = INTEGRITY_UNKNOWN;
> +			cause = "unknown-ima-data";
> +
> +			break;
> +		}
> +
> +		rc = ima_modsig_verify(INTEGRITY_KEYRING_IMA, xattr_value);
> +		if (!rc) {
> +			iint->flags |= IMA_DIGSIG;
> +			status = 
> +
> +			kfree(*xattr_value_);
> +			*xattr_value_ = xattr_value;
> +			*xattr_len_ = xattr_len;
> +
> +			break;
> +		}

When including the appended signature in the measurement list, the
corresponding file hash needs to be included in the measurement list,
which might be different than the previously calculated file hash
based on the hash algorithm as defined in the IMA xattr.

Including the file hash and signature in the measurement list allows
the attestation server, with just a public key, to verify the file
signature against the file hash.  No need for a white list.

ima_modsig_verify() must calculate the file hash in order to verify
the file signature.  This file hash value somehow needs to be returned
in order for it to be included in the measurement list.

> +		/*
> +		 * The appended signature failed verification. Let's try
> +		 * reading a signature from the extended attribute instead.
> +		 */
> +
> +		pr_debug("modsig didn't verify, trying the xattr signature\n");
> +
> +		ima_free_xattr_data(xattr_value);
> +		iint->flags &= ~IMA_MODSIG_ALLOWED;
> +
> +		return ima_appraise_measurement(func, iint, file, buf, size,
> +						filename, xattr_value_,
> +						xattr_len_, opened);

Most of the code before "switch" needs to be done only once.  Is
recursion necessary?  Or can we just retry the "switch" using the IMA
xattr, assuming there is an IMA xattr?

Mimi

>  	default:
>  		status = INTEGRITY_UNKNOWN;
>  		cause = "unknown-ima-data";
> @@ -291,13 +366,15 @@ int ima_appraise_measurement(enum ima_hooks func,
>  	if (status != INTEGRITY_PASS) {
>  		if ((ima_appraise & IMA_APPRAISE_FIX) &&
>  		    (!xattr_value ||
> -		     xattr_value->type != EVM_IMA_XATTR_DIGSIG)) {
> +		     (xattr_value->type != EVM_IMA_XATTR_DIGSIG &&
> +		      xattr_value->type != IMA_MODSIG))) {
>  			if (!ima_fix_xattr(dentry, iint))
>  				status = INTEGRITY_PASS;
>  		} else if ((inode->i_size == 0) &&
>  			   (iint->flags & IMA_NEW_FILE) &&
>  			   (xattr_value &&
> -			    xattr_value->type == EVM_IMA_XATTR_DIGSIG)) {
> +			    (xattr_value->type == EVM_IMA_XATTR_DIGSIG ||
> +			     xattr_value->type == IMA_MODSIG))) {
>  			status = INTEGRITY_PASS;
>  		}
>  		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
> @@ -398,6 +475,7 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
>  		       const void *xattr_value, size_t xattr_value_len)
>  {
>  	const struct evm_ima_xattr_data *xvalue = xattr_value;
> +	bool digsig;
>  	int result;
> 
>  	result = ima_protect_xattr(dentry, xattr_name, xattr_value,
> @@ -405,8 +483,10 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
>  	if (result == 1) {
>  		if (!xattr_value_len || (xvalue->type >= IMA_XATTR_LAST))
>  			return -EINVAL;
> -		ima_reset_appraise_flags(d_backing_inode(dentry),
> -			 (xvalue->type == EVM_IMA_XATTR_DIGSIG) ? 1 : 0);
> +
> +		digsig = xvalue->type == EVM_IMA_XATTR_DIGSIG ||
> +				xvalue->type == IMA_MODSIG;
> +		ima_reset_appraise_flags(d_backing_inode(dentry), digsig);
>  		result = 0;
>  	}
>  	return result;
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 0b4845e7248d..93fa257c71a7 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -245,8 +245,9 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
>  		pathname = ima_d_path(&file->f_path, &pathbuf, filename);
> 
>  	if (action & IMA_APPRAISE_SUBMASK)
> -		rc = ima_appraise_measurement(func, iint, file, pathname,
> -					      xattr_value, xattr_len, opened);
> +		rc = ima_appraise_measurement(func, iint, file, buf, size,
> +					      pathname, &xattr_value,
> +					      &xattr_len, opened);
>  	if (action & IMA_MEASURE)
>  		ima_store_measurement(iint, file, pathname,
>  				      xattr_value, xattr_len, pcr);
> @@ -257,7 +258,7 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
>  	if ((mask & MAY_WRITE) && (iint->flags & IMA_DIGSIG) &&
>  	     !(iint->flags & IMA_NEW_FILE))
>  		rc = -EACCES;
> -	kfree(xattr_value);
> +	ima_free_xattr_data(xattr_value);
>  out_free:
>  	if (pathbuf)
>  		__putname(pathbuf);
> diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
> new file mode 100644
> index 000000000000..a74f8aa36aa7
> --- /dev/null
> +++ b/security/integrity/ima/ima_modsig.c
> @@ -0,0 +1,147 @@
> +/*
> + * IMA support for appraising module-style appended signatures.
> + *
> + * Copyright (C) 2017  IBM Corporation
> + *
> + * Author:
> + * Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation (version 2 of the License).
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/module_signature.h>
> +#include <keys/asymmetric-type.h>
> +#include <crypto/pkcs7.h>
> +
> +#include "ima.h"
> +
> +struct modsig_hdr {
> +	uint8_t type;		/* Should be IMA_MODSIG. */
> +	const void *data;	/* Pointer to data covered by pkcs7_msg. */
> +	size_t data_len;
> +	struct pkcs7_message *pkcs7_msg;
> +	int raw_pkcs7_len;
> +
> +	/* This will be in the measurement list if required by the template. */
> +	struct evm_ima_xattr_data raw_pkcs7;
> +};
> +
> +/**
> + * ima_hook_supports_modsig - can the policy allow modsig for this hook?
> + *
> + * modsig is only supported by hooks using ima_post_read_file, because only they
> + * preload the contents of the file in a buffer. FILE_CHECK does that in some
> + * cases, but not when reached from vfs_open. POLICY_CHECK can support it, but
> + * it's not useful in practice because it's a text file so deny.
> + */
> +bool ima_hook_supports_modsig(enum ima_hooks func)
> +{
> +	switch (func) {
> +	case FIRMWARE_CHECK:
> +	case KEXEC_KERNEL_CHECK:
> +	case KEXEC_INITRAMFS_CHECK:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +int ima_read_modsig(const void *buf, loff_t buf_len,
> +		    struct evm_ima_xattr_data **xattr_value,
> +		    int *xattr_len)
> +{
> +	const size_t marker_len = sizeof(MODULE_SIG_STRING) - 1;
> +	const struct module_signature *sig;
> +	struct modsig_hdr *hdr;
> +	size_t sig_len;
> +	const void *p;
> +	int rc;
> +
> +	if (buf_len <= marker_len + sizeof(*sig))
> +		return -ENOENT;
> +
> +	p = buf + buf_len - marker_len;
> +	if (memcmp(p, MODULE_SIG_STRING, marker_len))
> +		return -ENOENT;
> +
> +	buf_len -= marker_len;
> +	sig = (const struct module_signature *) (p - sizeof(*sig));
> +
> +	rc = validate_module_sig(sig, buf_len);
> +	if (rc)
> +		return rc;
> +
> +	sig_len = be32_to_cpu(sig->sig_len);
> +	buf_len -= sig_len + sizeof(*sig);
> +
> +	hdr = kmalloc(sizeof(*hdr) + sig_len, GFP_KERNEL);
> +	if (!hdr)
> +		return -ENOMEM;
> +
> +	hdr->pkcs7_msg = pkcs7_parse_message(buf + buf_len, sig_len);
> +	if (IS_ERR(hdr->pkcs7_msg)) {
> +		rc = PTR_ERR(hdr->pkcs7_msg);
> +		kfree(hdr);
> +		return rc;
> +	}
> +
> +	memcpy(hdr->raw_pkcs7.data, buf + buf_len, sig_len);
> +	hdr->raw_pkcs7_len = sig_len + 1;
> +	hdr->raw_pkcs7.type = IMA_MODSIG;
> +
> +	hdr->type = IMA_MODSIG;
> +	hdr->data = buf;
> +	hdr->data_len = buf_len;
> +
> +	*xattr_value = (typeof(*xattr_value)) hdr;
> +	*xattr_len = sizeof(*hdr);
> +
> +	return 0;
> +}
> +
> +int ima_modsig_serialize_data(struct evm_ima_xattr_data *hdr,
> +			      struct evm_ima_xattr_data **data, int *data_len)
> +{
> +	struct modsig_hdr *modsig = (struct modsig_hdr *) hdr;
> +
> +	*data = &modsig->raw_pkcs7;
> +	*data_len = modsig->raw_pkcs7_len;
> +
> +	return 0;
> +}
> +
> +int ima_modsig_verify(const unsigned int keyring_id,
> +		      struct evm_ima_xattr_data *hdr)
> +{
> +	struct modsig_hdr *modsig = (struct modsig_hdr *) hdr;
> +	struct key *trusted_keys = integrity_keyring_from_id(keyring_id);
> +
> +	if (IS_ERR(trusted_keys))
> +		return -EINVAL;
> +
> +	return verify_pkcs7_message_sig(modsig->data, modsig->data_len,
> +					modsig->pkcs7_msg, trusted_keys,
> +					VERIFYING_MODULE_SIGNATURE, NULL, NULL);
> +}
> +
> +void ima_free_xattr_data(struct evm_ima_xattr_data *hdr)
> +{
> +	if (!hdr)
> +		return;
> +
> +	if (hdr->type == IMA_MODSIG) {
> +		struct modsig_hdr *modsig = (struct modsig_hdr *) hdr;
> +
> +		pkcs7_free_message(modsig->pkcs7_msg);
> +	}
> +
> +	kfree(hdr);
> +}
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index f4436626ccb7..4047ccabcbbf 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -853,8 +853,12 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  			}
> 
>  			ima_log_string(ab, "appraise_type", args[0].from);
> -			if ((strcmp(args[0].from, "imasig")) == 0)
> +			if (strcmp(args[0].from, "imasig") == 0)
>  				entry->flags |= IMA_DIGSIG_REQUIRED;
> +			else if (ima_hook_supports_modsig(entry->func) &&
> +				 strcmp(args[0].from, "modsig|imasig") == 0)
> +				entry->flags |= IMA_DIGSIG_REQUIRED
> +						| IMA_MODSIG_ALLOWED;
>  			else
>  				result = -EINVAL;
>  			break;
> @@ -960,6 +964,12 @@ void ima_delete_rules(void)
>  	}
>  }
> 
> +#define __ima_hook_stringify(str)	(#str),
> +
> +const char *const func_tokens[] = {
> +	__ima_hooks(__ima_hook_stringify)
> +};
> +
>  #ifdef	CONFIG_IMA_READ_POLICY
>  enum {
>  	mask_exec = 0, mask_write, mask_read, mask_append
> @@ -972,12 +982,6 @@ static const char *const mask_tokens[] = {
>  	"MAY_APPEND"
>  };
> 
> -#define __ima_hook_stringify(str)	(#str),
> -
> -static const char *const func_tokens[] = {
> -	__ima_hooks(__ima_hook_stringify)
> -};
> -
>  void *ima_policy_start(struct seq_file *m, loff_t *pos)
>  {
>  	loff_t l = *pos;
> @@ -1140,8 +1144,12 @@ int ima_policy_show(struct seq_file *m, void *v)
>  			}
>  		}
>  	}
> -	if (entry->flags & IMA_DIGSIG_REQUIRED)
> -		seq_puts(m, "appraise_type=imasig ");
> +	if (entry->flags & IMA_DIGSIG_REQUIRED) {
> +		if (entry->flags & IMA_MODSIG_ALLOWED)
> +			seq_puts(m, "appraise_type=modsig|imasig ");
> +		else
> +			seq_puts(m, "appraise_type=imasig ");
> +	}
>  	if (entry->flags & IMA_PERMIT_DIRECTIO)
>  		seq_puts(m, "permit_directio ");
>  	rcu_read_unlock();
> diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> index 28af43f63572..8c7fa52604a5 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -383,9 +383,21 @@ int ima_eventsig_init(struct ima_event_data *event_data,
>  	int xattr_len = event_data->xattr_len;
>  	int rc = 0;
> 
> -	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
> +	if (!xattr_value || (xattr_value->type != EVM_IMA_XATTR_DIGSIG &&
> +			     xattr_value->type != IMA_MODSIG))
>  		goto out;
> 
> +	/*
> +	 * The xattr_value for IMA_MODSIG is a runtime structure containing
> +	 * pointers. Get its raw data instead.
> +	 */
> +	if (xattr_value->type == IMA_MODSIG) {
> +		rc = ima_modsig_serialize_data(xattr_value, &xattr_value,
> +					       &xattr_len);
> +		if (rc)
> +			goto out;
> +	}
> +
>  	rc = ima_write_template_field_data(xattr_value, xattr_len, fmt,
>  					   field_data);
>  out:
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index ba5f13f94ed3..2c9393cf2860 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -28,11 +28,12 @@
> 
>  /* iint cache flags */
>  #define IMA_ACTION_FLAGS	0xff000000
> -#define IMA_ACTION_RULE_FLAGS	0x06000000
> +#define IMA_ACTION_RULE_FLAGS	0x16000000
>  #define IMA_DIGSIG		0x01000000
>  #define IMA_DIGSIG_REQUIRED	0x02000000
>  #define IMA_PERMIT_DIRECTIO	0x04000000
>  #define IMA_NEW_FILE		0x08000000
> +#define IMA_MODSIG_ALLOWED	0x10000000
> 
>  #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
>  				 IMA_APPRAISE_SUBMASK)
> @@ -58,6 +59,7 @@ enum evm_ima_xattr_type {
>  	EVM_XATTR_HMAC,
>  	EVM_IMA_XATTR_DIGSIG,
>  	IMA_XATTR_DIGEST_NG,
> +	IMA_MODSIG,
>  	IMA_XATTR_LAST
>  };
> 
