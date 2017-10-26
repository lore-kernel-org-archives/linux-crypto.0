From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 18/18] ima: Write modsig to the measurement list
Date: Thu, 26 Oct 2017 20:02:23 -0200
Message-ID: <87r2tpwosw.fsf@linux.vnet.ibm.com>
References: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com> <20171018005331.2688-19-bauerman@linux.vnet.ibm.com> <1509048454.5886.108.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
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
Return-path: <linux-security-module-owner@vger.kernel.org>
In-reply-to: <1509048454.5886.108.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Hello Mimi,

Thanks for your review.

Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

> On Tue, 2017-10-17 at 22:53 -0200, Thiago Jung Bauermann wrote:
>
>> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
>> index 6a2d960fbd92..0d3390de7432 100644
>> --- a/security/integrity/ima/ima_main.c
>> +++ b/security/integrity/ima/ima_main.c
>> @@ -246,7 +246,35 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
>>  		rc = ima_appraise_measurement(func, iint, file, buf, size,
>>  					      pathname, &xattr_value,
>>  					      &xattr_len, opened);
>> -	if (action & IMA_MEASURE)
>> +
>> +	/*
>> +	 * MODSIG has one corner case we need to deal with here:
>> +	 *
>> +	 * Suppose the policy has one measure rule for one hook and an appraise
>> +	 * rule for a different hook. Suppose also that the template requires
>> +	 * the signature to be stored in the measurement list.
>> +	 *
>> +	 * If a file containing a MODSIG is measured by the first hook before
>> +	 * being appraised by the second one, the corresponding entry in the
>> +	 * measurement list will not contain the MODSIG because we only fetch it
>> +	 * for IMA_APPRAISAL. We don't fetch it earlier because if the file has
>> +	 * both a DIGSIG and a MODSIG it's not possible to know which one will
>> +	 * be valid without actually doing the appraisal.
>> +	 *
>> +	 * Therefore, after appraisal of a MODSIG signature we need to store the
>> +	 * measurement again if the current template requires storing the
>> +	 * signature.
>
> Yes, all true, but this long comment doesn't belong here in the middle
> of process_measurement().
>
>> +	 * With the opposite ordering (the appraise rule triggering before the
>> +	 * measurement rule) there is the same problem but it's not possible to
>> +	 * do anything about it because at the time we are appraising the
>> +	 * signature it's impossible to know whether a measurement will ever
>> +	 * need to be stored for this file.
>> +	 */
>
> With the template format "ima-sig", the verified file signature needs
> to be included in the measurement list. Based on this file signature,
> the attestation server can validate the signature.
>
> In this case, where the appraisal comes first followed by the
> measurement, the appraised file signature is included in the
> measurement list. I don't see the problem here.

I think I forgot that during appraisal the modsig is copied into the
iint cache and that it will be used when the measure rule is trigerred.
I'll drop that last paragraph.

>
>> +	if ((action & IMA_MEASURE) || ((iint->flags & IMA_MEASURE) &&
>> +				       xattr_value &&
>> +				       xattr_value->type == IMA_MODSIG &&
>> +				       ima_current_template_has_sig()))
>
> Like the clean up you did elsewhere, this new set of tests should be
> made into a function. The comment could placed along with the new
> function.

Ok. I didn't create a function because these tests are only done here,
but I agree that it will make the code clearer, and be a better place
for the big comment as well. Will do in the next version.

-- 
Thiago Jung Bauermann
IBM Linux Technology Center

