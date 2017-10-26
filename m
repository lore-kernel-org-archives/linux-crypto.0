From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 12/18] MODSIGN: Export module signature definitions
Date: Thu, 26 Oct 2017 20:47:29 -0200
Message-ID: <87po99wmpq.fsf@linux.vnet.ibm.com>
References: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com> <20171018005331.2688-13-bauerman@linux.vnet.ibm.com> <1509048728.5886.112.camel@linux.vnet.ibm.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60704 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751553AbdJZWrn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 18:47:43 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9QMlCbM045892
        for <linux-crypto@vger.kernel.org>; Thu, 26 Oct 2017 18:47:43 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dukyad8k8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 26 Oct 2017 18:47:42 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.vnet.ibm.com>;
        Thu, 26 Oct 2017 18:47:41 -0400
In-reply-to: <1509048728.5886.112.camel@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

> On Tue, 2017-10-17 at 22:53 -0200, Thiago Jung Bauermann wrote:
>> IMA will use the module_signature format for append signatures, so export
>> the relevant definitions and factor out the code which verifies that the
>> appended signature trailer is valid.
>> 
>> Also, create a CONFIG_MODULE_SIG_FORMAT option so that IMA can select it
>> and be able to use validate_module_signature without having to depend on
>> CONFIG_MODULE_SIG.
>> 
>> Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
>
> Reviewed-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
>
> One minor comment below...

Thanks!

>> diff --git a/kernel/module_signing.c b/kernel/module_signing.c
>> index 937c844bee4a..204c60d4cc9f 100644
>> --- a/kernel/module_signing.c
>> +++ b/kernel/module_signing.c
>> @@ -11,36 +11,38 @@
>> 
>>  #include <linux/kernel.h>
>>  #include <linux/errno.h>
>> +#include <linux/module_signature.h>
>>  #include <linux/string.h>
>>  #include <linux/verification.h>
>>  #include <crypto/public_key.h>
>>  #include "module-internal.h"
>> 
>> -enum pkey_id_type {
>> -	PKEY_ID_PGP,		/* OpenPGP generated key ID */
>> -	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
>> -	PKEY_ID_PKCS7,		/* Signature in PKCS#7 message */
>> -};
>> -
>> -/*
>> - * Module signature information block.
>> - *
>> - * The constituents of the signature section are, in order:
>> +/**
>> + * validate_module_sig - validate that the given signature is sane
>>   *
>> - *	- Signer's name
>> - *	- Key identifier
>> - *	- Signature data
>> - *	- Information block
>> + * @ms:		Signature to validate.
>> + * @file_len:	Size of the file to which @ms is appended.
>>   */
>> -struct module_signature {
>> -	u8	algo;		/* Public-key crypto algorithm [0] */
>> -	u8	hash;		/* Digest algorithm [0] */
>> -	u8	id_type;	/* Key identifier type [PKEY_ID_PKCS7] */
>> -	u8	signer_len;	/* Length of signer's name [0] */
>> -	u8	key_id_len;	/* Length of key identifier [0] */
>> -	u8	__pad[3];
>> -	__be32	sig_len;	/* Length of signature data */
>> -};
>> +int validate_module_sig(const struct module_signature *ms, size_t file_len)
>> +{
>> +	if (be32_to_cpu(ms->sig_len) >= file_len - sizeof(*ms))
>> +		return -EBADMSG;
>> +	else if (ms->id_type != PKEY_ID_PKCS7) {
>> +		pr_err("Module is not signed with expected PKCS#7 message\n");
>> +		return -ENOPKG;
>> +	} else if (ms->algo != 0 ||
>> +		   ms->hash != 0 ||
>> +		   ms->signer_len != 0 ||
>> +		   ms->key_id_len != 0 ||
>> +		   ms->__pad[0] != 0 ||
>> +		   ms->__pad[1] != 0 ||
>> +		   ms->__pad[2] != 0) {
>> +		pr_err("PKCS#7 signature info has unexpected non-zero params\n");
>> +		return -EBADMSG;
>> +	}
>> +
>
> When moving code from one place to another, it's easier to review when
> there aren't code changes as well. In this case, the original code
> doesn't have "else clauses".

Indeed. I changed the code back to using separate if clauses, making
only the changes that are required for the refactoring.

> Here some of the if/then/else clauses
> have braces others don't. There shouldn't be a mixture.

Does this still apply when the if clauses are separate as in the
original code? Should the first if still have braces?

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
