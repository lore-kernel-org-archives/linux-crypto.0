From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 17/18] ima: Implement support for module-style
 appended signatures
Date: Tue, 31 Oct 2017 09:31:35 -0400
Message-ID: <1509456695.3583.226.camel@linux.vnet.ibm.com>
References: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
         <20171018005331.2688-18-bauerman@linux.vnet.ibm.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751269AbdJaNbt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2017 09:31:49 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9VDVcgw139344
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2017 09:31:48 -0400
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dxt0vgmnr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2017 09:31:47 -0400
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Tue, 31 Oct 2017 13:31:44 -0000
In-Reply-To: <20171018005331.2688-18-bauerman@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2017-10-17 at 22:53 -0200, Thiago Jung Bauermann wrote:

Below are a few additional comments.

> @@ -200,18 +239,28 @@ int ima_read_xattr(struct dentry *dentry,
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
>  	const char *cause = "unknown";
>  	struct dentry *dentry = file_dentry(file);
>  	struct inode *inode = d_backing_inode(dentry);
>  	enum integrity_status status = INTEGRITY_UNKNOWN;
> -	int rc = xattr_len, hash_start = 0;
> +	struct evm_ima_xattr_data *xattr_value = *xattr_value_;
> +	int xattr_len = *xattr_len_, rc = xattr_len, hash_start = 0;
> +	bool appraising_modsig = false;
> +
> +	if (iint->flags & IMA_MODSIG_ALLOWED &&
> +	    !ima_read_modsig(func, buf, size, &xattr_value, &xattr_len)) {
> +		appraising_modsig = true;
> +		rc = xattr_len;
> +	}
> 
> -	if (!(inode->i_opflags & IOP_XATTR))
> +	/* If not appraising a modsig, we need an xattr. */
> +	if (!appraising_modsig && !(inode->i_opflags & IOP_XATTR))
>  		return INTEGRITY_UNKNOWN;
> 
>  	if (rc <= 0) {
> @@ -235,6 +284,9 @@ int ima_appraise_measurement(enum ima_hooks func,
>  	case INTEGRITY_UNKNOWN:
>  		break;
>  	case INTEGRITY_NOXATTRS:	/* No EVM protected xattrs. */
> +		/* It's fine not to have xattrs when using a modsig. */
> +		if (appraising_modsig)
> +			break;
>  	case INTEGRITY_NOLABEL:		/* No security.evm xattr. */
>  		cause = "missing-HMAC";
>  		goto out;
> @@ -242,6 +294,8 @@ int ima_appraise_measurement(enum ima_hooks func,
>  		cause = "invalid-HMAC";
>  		goto out;
>  	}
> +
> + retry:
>  	switch (xattr_value->type) {
>  	case IMA_XATTR_DIGEST_NG:
>  		/* first byte contains algorithm id */
> @@ -285,6 +339,61 @@ int ima_appraise_measurement(enum ima_hooks func,
>  			status = INTEGRITY_PASS;
>  		}
>  		break;
> +	case IMA_MODSIG:
> +		/*
> +		 * To avoid being tricked into an infinite loop, we don't allow
> +		 * a modsig stored in the xattr.
> +		 */
> +		if (!appraising_modsig) {
> +			status = INTEGRITY_UNKNOWN;
> +			cause = "unknown-ima-data";
> +			break;
> +		}
> +		rc = appraise_modsig(iint, xattr_value, xattr_len);
> +		if (!rc) {
> +			kfree(*xattr_value_);
> +			*xattr_value_ = xattr_value;
> +			*xattr_len_ = xattr_len;
> +
> +			status = INTEGRITY_PASS;
> +			break;
> +		}
> +
> +		ima_free_xattr_data(xattr_value);
> +
> +		/*
> +		 * The appended signature failed verification. If there's a
> +		 * signature in the extended attribute, let's fall back to it.
> +		 */
> +		if (inode->i_opflags & IOP_XATTR && *xattr_len_ != 0 &&
> +		    *xattr_len_ != -ENODATA) {

At this point, there was an appended signature verification failure.
 If there isn't an xattr, for whatever reason, shouldn't we be
returning "invalid_signature" and "INTEGRITY_FAIL".  If so, then the
above test could be simplified to check whether there is any data,
like this:

	if ((inode->i_opflags & IOP_XATTR) && (*xattr_len_ > 0)) {

> +			const char *modsig_cause = rc == -EOPNOTSUPP ?
> +				"unknown" : "invalid-signature";

This can then be cleaned up as well.

> +
> +			/* First, log that the modsig verification failed. */
> +			integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
> +					    filename, op, modsig_cause, rc, 0);

I'm not sure that we want to audit intermediary signature verification
failures.  Perhaps this audit message should be considered
"additional", meaning it is only emitted if the "integrity_audit" boot
command line option is enabled.  Change the last field to 1 to
indicate it is an "additional" audit message.

> +
> +			xattr_len = rc = *xattr_len_;
> +			xattr_value = *xattr_value_;
> +			appraising_modsig = false;
> +
> +			if (rc > 0)

This test becomes redundant.

> +				/* Process xattr contents. */
> +				goto retry;
> +
> +			/* Unexpected error reading xattr. */
> +			status = INTEGRITY_UNKNOWN;
> +		} else {
> +			if (rc == -EOPNOTSUPP)
> +				status = INTEGRITY_UNKNOWN;
> +			else {
> +				cause = "invalid-signature";
> +				status = INTEGRITY_FAIL;
> +			}
> +		}
> +		break;

I think the rest can be simplified to:
	cause = "invalid-signature";
	status = INTEGRITY_FAIL;

Mimi
