Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726827AbeK3IGT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Nov 2018 03:06:19 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wATKwpkd060657
        for <linux-crypto@vger.kernel.org>; Thu, 29 Nov 2018 15:59:35 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2p2kd0upyj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 29 Nov 2018 15:59:35 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 29 Nov 2018 20:59:32 -0000
Subject: Re: [PATCH v8 04/14] integrity: Introduce struct evm_xattr
From: Mimi Zohar <zohar@linux.ibm.com>
To: Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
Date: Thu, 29 Nov 2018 15:59:12 -0500
In-Reply-To: <20181116200712.14154-5-bauerman@linux.ibm.com>
References: <20181116200712.14154-1-bauerman@linux.ibm.com>
         <20181116200712.14154-5-bauerman@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1543525152.3902.411.camel@linux.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2018-11-16 at 18:07 -0200, Thiago Jung Bauermann wrote:
> Even though struct evm_ima_xattr_data includes a fixed-size array to hold a
> SHA1 digest, most of the code ignores the array and uses the struct to mean
> "type indicator followed by data of unspecified size" and tracks the real
> size of what the struct represents in a separate length variable.
> 
> The only exception to that is the EVM code, which correctly uses the
> definition of struct evm_ima_xattr_data.
> 
> So make this explicit in the code by removing the length specification from
> the array in struct evm_ima_xattr_data. Also, change the name of the
> element from digest to data since in most places the array doesn't hold a
> digest.
> 
> A separate struct evm_xattr is introduced, with the original definition of
> evm_ima_xattr_data to be used in the places that actually expect that
> definition.

, specifically the EVM HMAC code.

> 
> Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>

Other than commenting the evm_xattr usage is limited to HMAC before
the structure definition, this looks good.

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

> ---
>  security/integrity/evm/evm_main.c     | 8 ++++----
>  security/integrity/ima/ima_appraise.c | 7 ++++---
>  security/integrity/integrity.h        | 5 +++++
>  3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 7f3f54d89a6e..a1b42d10efc7 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -169,7 +169,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
>  	/* check value type */
>  	switch (xattr_data->type) {
>  	case EVM_XATTR_HMAC:
> -		if (xattr_len != sizeof(struct evm_ima_xattr_data)) {
> +		if (xattr_len != sizeof(struct evm_xattr)) {
>  			evm_status = INTEGRITY_FAIL;
>  			goto out;
>  		}
> @@ -179,7 +179,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
>  				   xattr_value_len, &digest);
>  		if (rc)
>  			break;
> -		rc = crypto_memneq(xattr_data->digest, digest.digest,
> +		rc = crypto_memneq(xattr_data->data, digest.digest,
>  				   SHA1_DIGEST_SIZE);
>  		if (rc)
>  			rc = -EINVAL;
> @@ -523,7 +523,7 @@ int evm_inode_init_security(struct inode *inode,
>  				 const struct xattr *lsm_xattr,
>  				 struct xattr *evm_xattr)
>  {
> -	struct evm_ima_xattr_data *xattr_data;
> +	struct evm_xattr *xattr_data;
>  	int rc;
>  
>  	if (!evm_key_loaded() || !evm_protected_xattr(lsm_xattr->name))
> @@ -533,7 +533,7 @@ int evm_inode_init_security(struct inode *inode,
>  	if (!xattr_data)
>  		return -ENOMEM;
>  
> -	xattr_data->type = EVM_XATTR_HMAC;
> +	xattr_data->data.type = EVM_XATTR_HMAC;
>  	rc = evm_init_hmac(inode, lsm_xattr, xattr_data->digest);
>  	if (rc < 0)
>  		goto out;
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index deec1804a00a..8bcef90939f8 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -167,7 +167,8 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
>  		return sig->hash_algo;
>  		break;
>  	case IMA_XATTR_DIGEST_NG:
> -		ret = xattr_value->digest[0];
> +		/* first byte contains algorithm id */
> +		ret = xattr_value->data[0];
>  		if (ret < HASH_ALGO__LAST)
>  			return ret;
>  		break;
> @@ -175,7 +176,7 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
>  		/* this is for backward compatibility */
>  		if (xattr_len == 21) {
>  			unsigned int zero = 0;
> -			if (!memcmp(&xattr_value->digest[16], &zero, 4))
> +			if (!memcmp(&xattr_value->data[16], &zero, 4))
>  				return HASH_ALGO_MD5;
>  			else
>  				return HASH_ALGO_SHA1;
> @@ -274,7 +275,7 @@ int ima_appraise_measurement(enum ima_hooks func,
>  			/* xattr length may be longer. md5 hash in previous
>  			   version occupied 20 bytes in xattr, instead of 16
>  			 */
> -			rc = memcmp(&xattr_value->digest[hash_start],
> +			rc = memcmp(&xattr_value->data[hash_start],
>  				    iint->ima_hash->digest,
>  				    iint->ima_hash->length);
>  		else
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index e60473b13a8d..20ac02bf1b84 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -79,6 +79,11 @@ enum evm_ima_xattr_type {
>  
>  struct evm_ima_xattr_data {
>  	u8 type;
> +	u8 data[];
> +} __packed;
> +

Please add a comment here saying that evm_xattr is limited to HMAC.

> +struct evm_xattr {
> +	struct evm_ima_xattr_data data;
>  	u8 digest[SHA1_DIGEST_SIZE];
>  } __packed;
>  
