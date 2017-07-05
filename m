From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 6/6] ima: Support module-style appended signatures for appraisal
Date: Tue, 04 Jul 2017 23:22:55 -0300
Message-ID: <87fuebei68.fsf@linux.vnet.ibm.com>
References: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com> <1496886555-10082-7-git-send-email-bauerman@linux.vnet.ibm.com> <1497443972.4287.38.camel@linux.vnet.ibm.com> <8760fpck0x.fsf@linux.vnet.ibm.com> <1498095237.5328.44.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
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
        "AKASHI\, Takahiro" <takahiro.akashi@linaro.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1498095237.5328.44.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

> On Wed, 2017-06-21 at 14:45 -0300, Thiago Jung Bauermann wrote:
>> Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
>> > On Wed, 2017-06-07 at 22:49 -0300, Thiago Jung Bauermann wrote:
>> >> @@ -267,11 +276,18 @@ int ima_appraise_measurement(enum ima_hooks func,
>> >>  		status = INTEGRITY_PASS;
>> >>  		break;
>> >>  	case EVM_IMA_XATTR_DIGSIG:
>> >> +	case IMA_MODSIG:
>> >>  		iint->flags |= IMA_DIGSIG;
>> >> -		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
>> >> -					     (const char *)xattr_value, rc,
>> >> -					     iint->ima_hash->digest,
>> >> -					     iint->ima_hash->length);
>> >> +
>> >> +		if (xattr_value->type == EVM_IMA_XATTR_DIGSIG)
>> >> +			rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
>> >> +						     (const char *)xattr_value,
>> >> +						     rc, iint->ima_hash->digest,
>> >> +						     iint->ima_hash->length);
>> >> +		else
>> >> +			rc = ima_modsig_verify(INTEGRITY_KEYRING_IMA,
>> >> +					       xattr_value);
>> >> +
>> >
>> > Perhaps allowing IMA_MODSIG to flow into EVM_IMA_XATTR_DIGSIG on
>> > failure, would help restore process_measurements() to the way it was.
>> > Further explanation below.
>> 
>> It's not possible to simply flow into EVM_IMA_XATTR_DIGSIG on failure
>> because after calling ima_read_xattr we need to run again all the logic
>> before the switch statement. Instead, I'm currently testing the
>> following change for v3, what do you think?
>
> I don't think we can assume that the same algorithm will be used for
> signing the kernel image. Different entities would be signing the
> kernel image with different requirements.
>
> Suppose for example a stock distro image comes signed using one
> algorithm (appended signature), but the same kernel image is locally
> signed using a different algorithm (xattr). Signature verification is
> dependent on either the distro or local public key being loaded onto
> the IMA keyring.

This example is good, but it raises one question: should the xattr
signature cover the entire contents of the stock distro image (i.e.,
also cover the appended signature), or should it ignore the appended
signature and thus cover the same contents that the appended signature
covers?

If the former, then we can't reuse the iint->ima_hash that was collected
when trying to verify the appended signature because it doesn't cover
the appended signature itself and won't match the hash expected by the
xattr signature.

If the latter, then evmctl ima_sign needs to be modified to check
whether there's an appended signature in the given file and ignore it
when calculating the xattr signature.

Which is better?

>> >> @@ -226,30 +282,23 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
>> >>  		goto out_digsig;
>> >>  	}
>> >> 
>> >> -	template_desc = ima_template_desc_current();
>> >> -	if ((action & IMA_APPRAISE_SUBMASK) ||
>> >> -		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
>> >> -		/* read 'security.ima' */
>> >> -		xattr_len = ima_read_xattr(file_dentry(file), &xattr_value);
>> >> -
>> >> -	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
>> >> -
>> >> -	rc = ima_collect_measurement(iint, file, buf, size, hash_algo);
>> >> -	if (rc != 0) {
>> >> -		if (file->f_flags & O_DIRECT)
>> >> -			rc = (iint->flags & IMA_PERMIT_DIRECTIO) ? 0 : -EACCES;
>> >> -		goto out_digsig;
>> >> -	}
>> >> -
>> >
>> > There are four stages: collect measurement, store measurement,
>> > appraise measurement and audit measurement. "Collect" needs to be
>> > done if any one of the other stages is needed.
>> >
>> >>  	if (!pathbuf)	/* ima_rdwr_violation possibly pre-fetched */
>> >>  		pathname = ima_d_path(&file->f_path, &pathbuf, filename);
>> >> 
>> >> +	if (iint->flags & IMA_MODSIG_ALLOWED)
>> >> +		rc = measure_and_appraise(file, buf, size, func, opened, action,
>> >> +					  iint, &xattr_value, &xattr_len,
>> >> +					  pathname, true);
>> >> +	if (!xattr_len)
>> >> +		rc = measure_and_appraise(file, buf, size, func, opened, action,
>> >> +					  iint, &xattr_value, &xattr_len,
>> >> +					  pathname, false);
>> >
>> > I would rather see "collect" extended to support an appended signature
>> > rather than trying to combine "collect" and "appraise" together.
>> 
>> I'm not sure I understand what you mean by "extend collect to support an
>> appended signature", but the fundamental problem is that we don't know
>> whether we need to fallback to the xattr sig until the appraise step
>> because that's when we verify the signature, and by then the collect and
>> store steps were already completed and would need to be done again if
>> the hash algorithm in the xattr sig is different.
>
> The "appraise" stage could be moved before the "store" stage, like you
> have. (This should be a separate patch explaining the need for moving
> it.) Based on an argument to ima_collect_measurement() have it
> "collect" either the appended signature or the xattr. Maybe something
> like this:
>
> loop [ appended signature, xattr ] { <== list based on policy flags
>   collect_measurement()
>   if failure
>     continue
>   appraise_measurement()
>   if success
>     break
> }
>
> store_measurement()

Ok, the above is what v2 already does, so the only change I made was to
rename the function from measure_and_appraise to collect_and_appraise to
match the IMA jargon.

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
