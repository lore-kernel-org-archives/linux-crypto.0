Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4321C3A5A1
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 22:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DADD21744
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 22:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J+4MXTXA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390423AbfHVWKq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 18:10:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41426 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390232AbfHVWKq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 18:10:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MM3w4H119755;
        Thu, 22 Aug 2019 22:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kdQSfdcoBBmXRsKBaEBdADzGlfbRY2+yF9PElnHHdXI=;
 b=J+4MXTXA0z4xtlZc2SDM3R3MYJ/j6QQgsUneQ9g6E2ABUIXTkE8NuMMpM+mAaB8oohNL
 wRC9VES2lZJcoHx0B1b2lbR/F0n52rCBn24PcMc+7k/3bM7KaPWw6JoAhvmrFnknheY2
 9Kn2ao8+pkKUtOjQURt6Imk2yGjR8F6N8E52bB+0LO1arG63RLgHcvcXSHPKjX42tNnn
 tCvK08XH3TlqJXPu58P5EcSx2ybPg5gXnBmDxWXBPRZR6i3mFSBJwz83ID4siEEXXXeu
 afP971Ym9kXHwAVqNRHFQ8QLtK3efzBfV18FTjX8t1VtoJ8GBfUZgTw919EGiTf8EC5u Sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ue9hq0s2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 22:10:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MM3gcp099962;
        Thu, 22 Aug 2019 22:10:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uhuseyupd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 22:10:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7MMAVZB004472;
        Thu, 22 Aug 2019 22:10:32 GMT
Received: from [192.168.1.219] (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 15:10:31 -0700
Subject: Re: [PATCH v2] padata: validate cpumask without removed CPU during
 offline
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190809192857.26585-2-daniel.m.jordan@oracle.com>
 <20190809210603.20900-1-daniel.m.jordan@oracle.com>
 <20190822035005.GA32551@gondor.apana.org.au>
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
Message-ID: <6a15a323-7e61-79b5-d3db-3c8717f50196@oracle.com>
Date:   Thu, 22 Aug 2019 18:10:30 -0400
MIME-Version: 1.0
In-Reply-To: <20190822035005.GA32551@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908220194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220194
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/21/19 11:50 PM, Herbert Xu wrote:
> On Fri, Aug 09, 2019 at 05:06:03PM -0400, Daniel Jordan wrote:
>> diff --git a/kernel/padata.c b/kernel/padata.c
>> index d056276a96ce..01460ea1d160 100644
>> --- a/kernel/padata.c
>> +++ b/kernel/padata.c
>> @@ -702,10 +702,7 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
>>   	struct parallel_data *pd = NULL;
>>   
>>   	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
>> -
>> -		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
>> -		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
>> -			__padata_stop(pinst);
>> +		__padata_stop(pinst);
>>   
>>   		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
>>   				     pinst->cpumask.cbcpu);
>> @@ -716,6 +713,9 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
>>   
>>   		cpumask_clear_cpu(cpu, pd->cpumask.cbcpu);
>>   		cpumask_clear_cpu(cpu, pd->cpumask.pcpu);
>> +		if (padata_validate_cpumask(pinst, pd->cpumask.pcpu) &&
>> +		    padata_validate_cpumask(pinst, pd->cpumask.cbcpu))
>> +			__padata_start(pinst);
>>   	}
> 
> I looked back at the original code and in fact the original
> assumption is to call this after cpu_online_mask has been modified.
> 
> So I suspect we need to change the state at which this is called
> by CPU hotplug.

Yes the state idea is good, it's cleaner to have the CPU out of the online mask ahead of time.

I think we'll need two states.  We want a CPU being offlined to already be removed from the online cpumask so and'ing the user-supplied and online masks reflects conditions after the hotplug operation is finished.  For the same reason we want a CPU being onlined to already be in the online mask, and we can use the existing hotplug state for that, though we'd need a new padata-specific state for the offline case.

> IOW the commit that broke this is 30e92153b4e6.

I don't think 30e92153b4e6 is the one since the commit before that only allows __padata_remove_cpu to do its work if @cpu is in the online mask, so the call happens before cpu_online_mask has been modified.  Same story for the very first padata commit, so it seems like that should actually be Fixes.

> This would also allow us to get rid of the two cpumask_clear_cpu
> calls on pd->cpumask which is just bogus as you should only ever
> modify the pd->cpumask prior to the padata_repalce call (because
> the readers are not serialised with respect to this).

Yeah, makes sense.

Daniel
