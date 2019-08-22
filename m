Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B67C3A5A1
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 22:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAE2F21848
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 22:53:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NVV8kon+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405322AbfHVWxX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 18:53:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51958 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405321AbfHVWxX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 18:53:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MMiR8f137545;
        Thu, 22 Aug 2019 22:53:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vpVu2VZRtNah6ylpgnywGvA55NJhIJGRcvAqj+DChyw=;
 b=NVV8kon+IlvlvC423xl7cR5HmEvnrJ2TgEOHtaqMdQLZvfV+GH7bfnbEBMPaiW+H5Uux
 +S2tBikRm8BWXBAaM7V23EEhj99jNTUPxCMd0bR1iEvER+6kOTh6AZXljSrt0reFhYOe
 Fro4Xasfz/ZxMHev65VDkFcRQK3f/NQStfZIY2sx+lRgRXkqnwYTUyj13Pgx6JhaYhm2
 UTHZfJh2KM0ckKkQOt8D/4ibYMYGsrtIf1Cxd3iob4xFc5Mhj45TXCJoY6A/miwCavAF
 0q6EexfYl7cuERK24nvg6IXYXMOKl8e0JQyxWIdsgo6BRtGWL4838Sd2RejIXb2zx6SQ Gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uea7r9003-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 22:53:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MMhXOd043707;
        Thu, 22 Aug 2019 22:53:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uj1xyuhdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 22:53:09 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7MMr7p7026926;
        Thu, 22 Aug 2019 22:53:08 GMT
Received: from [192.168.1.219] (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 15:53:07 -0700
Subject: Re: [PATCH v2] padata: validate cpumask without removed CPU during
 offline
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190809192857.26585-2-daniel.m.jordan@oracle.com>
 <20190809210603.20900-1-daniel.m.jordan@oracle.com>
 <20190822035005.GA32551@gondor.apana.org.au>
 <6a15a323-7e61-79b5-d3db-3c8717f50196@oracle.com>
Message-ID: <b341a330-0e85-e386-1f74-89219c4f511f@oracle.com>
Date:   Thu, 22 Aug 2019 18:53:06 -0400
MIME-Version: 1.0
In-Reply-To: <6a15a323-7e61-79b5-d3db-3c8717f50196@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908220199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220199
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 8/22/19 6:10 PM, Daniel Jordan wrote:
> On 8/21/19 11:50 PM, Herbert Xu wrote:
>> On Fri, Aug 09, 2019 at 05:06:03PM -0400, Daniel Jordan wrote:
>>> diff --git a/kernel/padata.c b/kernel/padata.c
>>> index d056276a96ce..01460ea1d160 100644
>>> --- a/kernel/padata.c
>>> +++ b/kernel/padata.c
>>> @@ -702,10 +702,7 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
>>>       struct parallel_data *pd = NULL;
>>>       if (cpumask_test_cpu(cpu, cpu_online_mask)) {
>>> -
>>> -        if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
>>> -            !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
>>> -            __padata_stop(pinst);
>>> +        __padata_stop(pinst);
>>>           pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
>>>                        pinst->cpumask.cbcpu);
>>> @@ -716,6 +713,9 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
>>>           cpumask_clear_cpu(cpu, pd->cpumask.cbcpu);
>>>           cpumask_clear_cpu(cpu, pd->cpumask.pcpu);
>>> +        if (padata_validate_cpumask(pinst, pd->cpumask.pcpu) &&
>>> +            padata_validate_cpumask(pinst, pd->cpumask.cbcpu))
>>> +            __padata_start(pinst);
>>>       }
>>
>> I looked back at the original code and in fact the original
>> assumption is to call this after cpu_online_mask has been modified.
>>
>> So I suspect we need to change the state at which this is called
>> by CPU hotplug.
> 
> Yes the state idea is good, it's cleaner to have the CPU out of the online mask ahead of time.
> 
> I think we'll need two states.  We want a CPU being offlined to already be removed from the online cpumask so and'ing the user-supplied and online masks reflects conditions after the hotplug operation is finished.  For the same reason we want a CPU being onlined to already be in the online mask, and we can use the existing hotplug state for that, though we'd need a new padata-specific state for the offline case.

The new state would be something before CPUHP_BRINGUP_CPU so the cpu isn't in the online mask yet.

> 
>> IOW the commit that broke this is 30e92153b4e6.
> 
> I don't think 30e92153b4e6 is the one since the commit before that only allows __padata_remove_cpu to do its work if @cpu is in the online mask, so the call happens before cpu_online_mask has been modified.  Same story for the very first padata commit, so it seems like that should actually be Fixes.
> 
>> This would also allow us to get rid of the two cpumask_clear_cpu
>> calls on pd->cpumask which is just bogus as you should only ever
>> modify the pd->cpumask prior to the padata_repalce call (because
>> the readers are not serialised with respect to this).
> 
> Yeah, makes sense.
> 
> Daniel
