Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B2DC31E48
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 11:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3C75208C2
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 11:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408508AbfFLLH7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 07:07:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2408402AbfFLLH7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 07:07:59 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CB2b3M020873
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 07:07:57 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2x1kpf2s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 07:07:57 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Wed, 12 Jun 2019 12:07:55 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 12:07:53 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CB7ps952166910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 11:07:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6753B42041;
        Wed, 12 Jun 2019 11:07:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1CA54203F;
        Wed, 12 Jun 2019 11:07:50 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.145.62.239])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 11:07:50 +0000 (GMT)
Subject: Re: [PATCH v2 1/4] s390/pkey: Use -ENODEV instead of -EOPNOTSUPP
To:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20190612102248.18903-1-david@redhat.com>
 <20190612102248.18903-2-david@redhat.com>
 <7f313d87-f9ea-e291-49e2-8da29cf41680@linux.ibm.com>
 <53936c66-ca09-98a7-4c3c-eae8c6024887@redhat.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Wed, 12 Jun 2019 13:07:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <53936c66-ca09-98a7-4c3c-eae8c6024887@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19061211-0012-0000-0000-000003287567
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061211-0013-0000-0000-000021617CC3
Message-Id: <dcdf0d42-3a39-53aa-188a-82895c86cc34@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120077
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12.06.19 12:41, David Hildenbrand wrote:
> On 12.06.19 12:39, Harald Freudenberger wrote:
>> On 12.06.19 12:22, David Hildenbrand wrote:
>>> systemd-modules-load.service automatically tries to load the pkey module
>>> on systems that have MSA.
>>>
>>> Pkey also requires the MSA3 facility and a bunch of subfunctions.
>>> Failing with -EOPNOTSUPP makes "systemd-modules-load.service" fail on
>>> any system that does not have all needed subfunctions. For example,
>>> when running under QEMU TCG (but also on systems where protected keys
>>> are disabled via the HMC).
>>>
>>> Let's use -ENODEV, so systemd-modules-load.service properly ignores
>>> failing to load the pkey module because of missing HW functionality.
>>>
>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>  drivers/s390/crypto/pkey_api.c | 6 +++---
>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
>>> index 45eb0c14b880..ddfcefb47284 100644
>>> --- a/drivers/s390/crypto/pkey_api.c
>>> +++ b/drivers/s390/crypto/pkey_api.c
>>> @@ -1695,15 +1695,15 @@ static int __init pkey_init(void)
>>>  	 * are able to work with protected keys.
>>>  	 */
>>>  	if (!cpacf_query(CPACF_PCKMO, &pckmo_functions))
>>> -		return -EOPNOTSUPP;
>>> +		return -ENODEV;
>>>  
>>>  	/* check for kmc instructions available */
>>>  	if (!cpacf_query(CPACF_KMC, &kmc_functions))
>>> -		return -EOPNOTSUPP;
>>> +		return -ENODEV;
>>>  	if (!cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_128) ||
>>>  	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_192) ||
>>>  	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_256))
>>> -		return -EOPNOTSUPP;
>>> +		return -ENODEV;
>>>  
>>>  	pkey_debug_init();
>>>  
>> You missed one match in this file. Function pkey_clr2protkey()
>> also does a cpacf_test_func() and may return -EOPNOTSUPP.
>> I checked the call chain, it's save to change the returncode there also.
> That's unrelated to module loading (if I am not wrong), shall we still
> include this change here?
>
> Thanks!
That would be nice.
However, I agree it is not related to module loading.
>
>> If done, Thanks and add my
>> reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
>>
>

