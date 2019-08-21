Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8C5C3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 04:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E551206DF
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 04:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AO1lwW7G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfHUEOd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 00:14:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54868 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfHUEOd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 00:14:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7L4DvZE120885;
        Wed, 21 Aug 2019 04:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=e3kgDvccVDLzNMMeR9/zH2eW+3aMX6c/MhJZaprZC3E=;
 b=AO1lwW7GB+SWC6UPk9BqflMxYl14SNqeX+eyW3uvmZUOzdDTu47HI0bDdNgfDT6NXNQP
 7aHQrgyy5FBkfD4ui/eDYnz/ywy0+Cksn3IyiwqxTbgH7wg/0DKIFk2iRvkvriey1wvM
 UFy33uW2amPTLoZVlGFWR5aGWJ6VSOR/sNsDmBDxIa/PyLcaTuCADvO0PUKK77nVOISc
 kDsElmn5RyYZeqYmS0sYT57vxMED0MoQ3DNRcFcRv2kfifLsJ/wYknivca4EbhZcFaqb
 2jTs7aD7WhJRYGo77E7TJjZRL6WSVTO3P4f2ZcgRNyBWZ37DSd/rwb4H3agPD5kex4ir 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uea7qtjje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 04:14:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7L4D9n0141955;
        Wed, 21 Aug 2019 04:14:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ug1ga34eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 04:14:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7L4EKYn029840;
        Wed, 21 Aug 2019 04:14:20 GMT
Received: from [192.168.1.218] (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 21:14:19 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH 1/2] padata: always acquire cpu_hotplug_lock before
 pinst->lock
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190809192857.26585-1-daniel.m.jordan@oracle.com>
 <20190815051518.GB24982@gondor.apana.org.au>
Message-ID: <f25cc77e-d467-c7a9-415c-eb9f46ac8493@oracle.com>
Date:   Wed, 21 Aug 2019 00:14:19 -0400
MIME-Version: 1.0
In-Reply-To: <20190815051518.GB24982@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908210044
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908210044
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[sorry for late reply, moved to new place in past week]

On 8/15/19 1:15 AM, Herbert Xu wrote:
> On Fri, Aug 09, 2019 at 03:28:56PM -0400, Daniel Jordan wrote:
>> padata doesn't take cpu_hotplug_lock and pinst->lock in a consistent
>> order.  Which should be first?  CPU hotplug calls into padata with
>> cpu_hotplug_lock already held, so it should have priority.
> 
> Yeah this is clearly a bug but I think we need tackle something
> else first.
>   
>> diff --git a/kernel/padata.c b/kernel/padata.c
>> index b60cc3dcee58..d056276a96ce 100644
>> --- a/kernel/padata.c
>> +++ b/kernel/padata.c
>> @@ -487,9 +487,7 @@ static void __padata_stop(struct padata_instance *pinst)
>>   
>>   	synchronize_rcu();
>>   
>> -	get_online_cpus();
>>   	padata_flush_queues(pinst->pd);
>> -	put_online_cpus();
>>   }
> 
> As I pointed earlier, the whole concept of flushing the queues is
> suspect.  So we should tackle that first and it may obviate the need
> to do get_online_cpus completely if the flush call disappears.
>
> My main worry is that you're adding an extra lock around synchronize_rcu
> and that is always something that should be done only after careful
> investigation.

Agreed, padata_stop may not need to do get_online_cpus() if we stop an instance in a way that plays well with async crypto.

I'll try fixing the flushing with Steffen's refcounting idea assuming he hasn't already started on that.  So we're on the same page, the problem is that if padata's ->parallel() punts to a cryptd thread, flushing the parallel work will return immediately without necessarily indicating the parallel job is finished, so flushing is pointless and padata_replace needs to wait till the instance's refcount drops to 0.  Did I get it right?

Daniel
