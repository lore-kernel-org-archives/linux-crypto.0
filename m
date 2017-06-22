From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 6/6] ima: Support module-style appended signatures
 for appraisal
Date: Wed, 21 Jun 2017 21:33:57 -0400
Message-ID: <1498095237.5328.44.camel@linux.vnet.ibm.com>
References: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com>
         <1496886555-10082-7-git-send-email-bauerman@linux.vnet.ibm.com>
         <1497443972.4287.38.camel@linux.vnet.ibm.com>
         <8760fpck0x.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
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
To: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8760fpck0x.fsf@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2017-06-21 at 14:45 -0300, Thiago Jung Bauermann wrote:
> Hello Mimi,
> 
> Thanks for your review, and for queuing the other patches in this series.
> 
> Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> > On Wed, 2017-06-07 at 22:49 -0300, Thiago Jung Bauermann wrote:
> >> This patch introduces the modsig keyword to the IMA policy syntax to
> >> specify that a given hook should expect the file to have the IMA signature
> >> appended to it.
> >
> > Thank you, Thiago. Appended signatures seem to be working proper now
> > with multiple keys on the IMA keyring.
> 
> Great news!
> 
> > The length of this patch description is a good indication that this
> > patch needs to be broken up for easier review. A few
> > comments/suggestions inline below.
> 
> Ok, I will try to break it up, and also patch 5 as you suggested.
> 
> >> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
> >> index 06554c448dce..9190c9058f4f 100644
> >> --- a/security/integrity/digsig.c
> >> +++ b/security/integrity/digsig.c
> >> @@ -48,11 +48,10 @@ static bool init_keyring __initdata;
> >>  #define restrict_link_to_ima restrict_link_by_builtin_trusted
> >>  #endif
> >> 
> >> -int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
> >> -			    const char *digest, int digestlen)
> >> +struct key *integrity_keyring_from_id(const unsigned int id)
> >>  {
> >> -	if (id >= INTEGRITY_KEYRING_MAX || siglen < 2)
> >> -		return -EINVAL;
> >> +	if (id >= INTEGRITY_KEYRING_MAX)
> >> +		return ERR_PTR(-EINVAL);
> >> 
> >
> > When splitting up this patch, the addition of this new function could
> > be a separate patch. The patch description would explain the need for
> > a new function.
> 
> Ok, will do for v3.
> 
> >> @@ -229,10 +234,14 @@ int ima_appraise_measurement(enum ima_hooks func,
> >>  		goto out;
> >>  	}
> >> 
> >> -	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
> >> -	if ((status != INTEGRITY_PASS) && (status != INTEGRITY_UNKNOWN)) {
> >> -		if ((status == INTEGRITY_NOLABEL)
> >> -		    || (status == INTEGRITY_NOXATTRS))
> >> +	/* Appended signatures aren't protected by EVM. */
> >> +	status = evm_verifyxattr(dentry, XATTR_NAME_IMA,
> >> +				 xattr_value->type == IMA_MODSIG ?
> >> +				 NULL : xattr_value, rc, iint);
> >> +	if (status != INTEGRITY_PASS && status != INTEGRITY_UNKNOWN &&
> >> +	    !(xattr_value->type == IMA_MODSIG &&
> >> +	      (status == INTEGRITY_NOLABEL || status == INTEGRITY_NOXATTRS))) {
> >
> > This was messy to begin with, and now it is even more messy. For
> > appended signatures, we're only interested in INTEGRITY_FAIL. Maybe
> > leave the existing "if" clause alone and define a new "if" clause.
> 
> Ok, is this what you had in mind?
> 
> @@ -229,8 +237,14 @@ int ima_appraise_measurement(enum ima_hooks func,
>  		goto out;
>  	}
> 
> -	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
> -	if ((status != INTEGRITY_PASS) && (status != INTEGRITY_UNKNOWN)) {
> +	/* Appended signatures aren't protected by EVM. */
> +	status = evm_verifyxattr(dentry, XATTR_NAME_IMA,
> +				 xattr_value->type == IMA_MODSIG ?
> +				 NULL : xattr_value, rc, iint);

Yes, maybe add a comment here indicating only verifying other security
xattrs, if they exist.

> +	if (xattr_value->type == IMA_MODSIG && status == INTEGRITY_FAIL) {
> +		cause = "invalid-HMAC";
> +		goto out;
> +	} else if (status != INTEGRITY_PASS && status != INTEGRITY_UNKNOWN) {
>  		if ((status == INTEGRITY_NOLABEL)
>  		    || (status == INTEGRITY_NOXATTRS))
>  			cause = "missing-HMAC";

> 
> >> @@ -267,11 +276,18 @@ int ima_appraise_measurement(enum ima_hooks func,
> >>  		status = INTEGRITY_PASS;
> >>  		break;
> >>  	case EVM_IMA_XATTR_DIGSIG:
> >> +	case IMA_MODSIG:
> >>  		iint->flags |= IMA_DIGSIG;
> >> -		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> >> -					     (const char *)xattr_value, rc,
> >> -					     iint->ima_hash->digest,
> >> -					     iint->ima_hash->length);
> >> +
> >> +		if (xattr_value->type == EVM_IMA_XATTR_DIGSIG)
> >> +			rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> >> +						     (const char *)xattr_value,
> >> +						     rc, iint->ima_hash->digest,
> >> +						     iint->ima_hash->length);
> >> +		else
> >> +			rc = ima_modsig_verify(INTEGRITY_KEYRING_IMA,
> >> +					       xattr_value);
> >> +
> >
> > Perhaps allowing IMA_MODSIG to flow into EVM_IMA_XATTR_DIGSIG on
> > failure, would help restore process_measurements() to the way it was.
> > Further explanation below.
> 
> It's not possible to simply flow into EVM_IMA_XATTR_DIGSIG on failure
> because after calling ima_read_xattr we need to run again all the logic
> before the switch statement. Instead, I'm currently testing the
> following change for v3, what do you think?

I don't think we can assume that the same algorithm will be used for
signing the kernel image. Different entities would be signing the
kernel image with different requirements.

Suppose for example a stock distro image comes signed using one
algorithm (appended signature), but the same kernel image is locally
signed using a different algorithm (xattr).  Signature verification is
dependent on either the distro or local public key being loaded onto
the IMA keyring.

> More about this code further below.
> 
> @@ -266,6 +280,44 @@ int ima_appraise_measurement(enum ima_hooks func,
>  		}
>  		status = INTEGRITY_PASS;
>  		break;
> +	case IMA_MODSIG:
> +		rc = ima_modsig_verify(INTEGRITY_KEYRING_IMA, xattr_value);
> +		if (!rc) {
> +			iint->flags |= IMA_DIGSIG;
> +			status = INTEGRITY_PASS;
> +			break;
> +		}
> +
> +		/*
> +		 * The appended signature failed verification. Let's try
> +		 * reading a signature from the extended attribute instead.
> +		 */
> +
> +		ima_free_xattr_data(xattr_value);
> +		xattr_value = NULL;
> +
> +		/* read 'security.ima' */
> +		xattr_len = ima_read_xattr(file_dentry(file), &xattr_value);
> +		algo = iint->ima_hash->algo;
> +
> +		if (!xattr_value || xattr_value->type == IMA_MODSIG ||
> +		    ima_get_hash_algo(xattr_value, xattr_len) != algo) {
> +			iint->flags |= IMA_DIGSIG;
> +
> +			if (rc == -EOPNOTSUPP)
> +				status = INTEGRITY_UNKNOWN;
> +			else {
> +				cause = "invalid-signature";
> +				status = INTEGRITY_FAIL;
> +			}
> +
> +			break;
> +		}
> +
> +		pr_debug("Trying the xattr signature\n");
> +
> +		return ima_appraise_measurement(func, iint, file, filename,
> +						xattr_value, xattr_len, opened);
>  	case EVM_IMA_XATTR_DIGSIG:
>  		iint->flags |= IMA_DIGSIG;
>  		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> 
> >> @@ -406,7 +424,8 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
> >>  		if (!xattr_value_len || (xvalue->type >= IMA_XATTR_LAST))
> >>  			return -EINVAL;
> >>  		ima_reset_appraise_flags(d_backing_inode(dentry),
> >> -			 (xvalue->type == EVM_IMA_XATTR_DIGSIG) ? 1 : 0);
> >> +					 xvalue->type == EVM_IMA_XATTR_DIGSIG ||
> >> +					 xvalue->type == IMA_MODSIG);
> >
> > Probably easier to read if we set a variable, before calling
> > ima_reset_appraise_flags.
> 
> Ok, will do in v3.
> 
> >> @@ -226,30 +282,23 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
> >>  		goto out_digsig;
> >>  	}
> >> 
> >> -	template_desc = ima_template_desc_current();
> >> -	if ((action & IMA_APPRAISE_SUBMASK) ||
> >> -		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
> >> -		/* read 'security.ima' */
> >> -		xattr_len = ima_read_xattr(file_dentry(file), &xattr_value);
> >> -
> >> -	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
> >> -
> >> -	rc = ima_collect_measurement(iint, file, buf, size, hash_algo);
> >> -	if (rc != 0) {
> >> -		if (file->f_flags & O_DIRECT)
> >> -			rc = (iint->flags & IMA_PERMIT_DIRECTIO) ? 0 : -EACCES;
> >> -		goto out_digsig;
> >> -	}
> >> -
> >
> > There are four stages: collect measurement, store measurement,
> > appraise measurement and audit measurement. "Collect" needs to be
> > done if any one of the other stages is needed.
> >
> >>  	if (!pathbuf)	/* ima_rdwr_violation possibly pre-fetched */
> >>  		pathname = ima_d_path(&file->f_path, &pathbuf, filename);
> >> 
> >> +	if (iint->flags & IMA_MODSIG_ALLOWED)
> >> +		rc = measure_and_appraise(file, buf, size, func, opened, action,
> >> +					  iint, &xattr_value, &xattr_len,
> >> +					  pathname, true);
> >> +	if (!xattr_len)
> >> +		rc = measure_and_appraise(file, buf, size, func, opened, action,
> >> +					  iint, &xattr_value, &xattr_len,
> >> +					  pathname, false);
> >
> > I would rather see "collect" extended to support an appended signature
> > rather than trying to combine "collect" and "appraise" together.
> 
> I'm not sure I understand what you mean by "extend collect to support an
> appended signature", but the fundamental problem is that we don't know
> whether we need to fallback to the xattr sig until the appraise step
> because that's when we verify the signature, and by then the collect and
> store steps were already completed and would need to be done again if
> the hash algorithm in the xattr sig is different.

The "appraise" stage could be moved before the "store" stage, like you
have.  (This should be a separate patch explaining the need for moving
it.)  Based on an argument to ima_collect_measurement() have it
"collect" either the appended signature or the xattr.  Maybe something
like this:

loop [ appended signature, xattr ] {  <== list based on policy flags
     collect_measurement()
     if failure
        continue
     appraise_measurement()
     if success
        break
}

store_measurement()

Mimi


> If we don't want to change the order of these steps what I suggest (and
> what the code I pasted above for ima_appraise_measurement does) is to
> only allow falling back to the xattr sig if the appended sig and the
> xattr sig use the same hash algorithm.
> 
> In that case, collect and store don't need to be redone nor the store
> step need to be moved after appraise. This is the only change that would
> be needed in process_measurement:

> @@ -227,10 +230,16 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
>  	}
> 
>  	template_desc = ima_template_desc_current();
> -	if ((action & IMA_APPRAISE_SUBMASK) ||
> -		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
> -		/* read 'security.ima' */
> -		xattr_len = ima_read_xattr(file_dentry(file), &xattr_value);
> +	if (action & IMA_APPRAISE_SUBMASK ||
> +	    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0) {
> +		if (iint->flags & IMA_MODSIG_ALLOWED)
> +			ima_read_modsig(buf, &size, &xattr_value, &xattr_len);
> +
> +		if (!xattr_len)
> +			/* read 'security.ima' */
> +			xattr_len = ima_read_xattr(file_dentry(file),
> +						   &xattr_value);
> +	}
> 
>  	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
> 
> @@ -257,7 +266,7 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
>  	if ((mask & MAY_WRITE) && (iint->flags & IMA_DIGSIG) &&
>  	     !(iint->flags & IMA_NEW_FILE))
>  		rc = -EACCES;
> -	kfree(xattr_value);
> +	ima_free_xattr_data(xattr_value);
>  out_free:
>  	if (pathbuf)
>  		__putname(pathbuf);
> 
> >
> >> +	if (rc)
> >> +		goto out_digsig;
> >> +
> >>  	if (action & IMA_MEASURE)
> >>  		ima_store_measurement(iint, file, pathname,
> >>  				      xattr_value, xattr_len, pcr);
> >> -	if (action & IMA_APPRAISE_SUBMASK)
> >> -		rc = ima_appraise_measurement(func, iint, file, pathname,
> >> -					      xattr_value, xattr_len, opened);
> >
> > Moving appraisal before storing the measurement, should be a separate
> > patch with a clear explanation as to why it is needed.
> 
> Ok, will do in v3 if you don't like the restriction of both the modsig
> and xattr sig having to use the same hash algorithm.
> 
