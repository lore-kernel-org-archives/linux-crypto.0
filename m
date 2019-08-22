Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD2FC3A5A1
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 22:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A0C7233A2
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 22:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SUHtNmG0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393857AbfHVWNs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 18:13:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38694 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390161AbfHVWNs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 18:13:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MM43Q3107932;
        Thu, 22 Aug 2019 22:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QG6TIfrrSSoVNSZ0AIqkQgTHXGsAUxD1RWiyqZg0oj4=;
 b=SUHtNmG0wC6DDUoEiuqb44ozaGSOb9bIVfsG184DBF+AeaR4zd/otKy23VGNufM1qoXh
 2O6cVDGGLtzNoT/QUip7Ke+4JzWNl0iX7ls/Fjd/R4DFHcS8RM3FFXgjR/iu9TBH1yaV
 YMI+9HwU34X9UlWjC0TBOLKGJwXb/fqFhKwPakcJzGWUd8mWNvXqR4/4EMMyQuoNEUe9
 ry4Zt++eE11KngbqgqBLW5XCCcuGb0qkTs00o2SDy7LKVmXaEbqjKkhtf+PxHEBp6oGf
 56yJ3ptZcp71k5+HBmoImiD0EiUpAlwwVFn4jo5nW+vqxibMsCakJZRjzPJlEn6cWrOH 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uea7r8uvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 22:13:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MM3tSs129429;
        Thu, 22 Aug 2019 22:11:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2uh83qm57h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 22:11:40 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7MMBder028773;
        Thu, 22 Aug 2019 22:11:39 GMT
Received: from [192.168.1.219] (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 15:11:39 -0700
Subject: Re: [PATCH 3/2] padata: initialize usable masks to reflect offlined
 CPU
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190809210603.20900-1-daniel.m.jordan@oracle.com>
 <20190812210200.13653-1-daniel.m.jordan@oracle.com>
 <20190822035143.GB32551@gondor.apana.org.au>
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
Message-ID: <fc23525a-431f-b714-2384-f707ce50c428@oracle.com>
Date:   Thu, 22 Aug 2019 18:11:38 -0400
MIME-Version: 1.0
In-Reply-To: <20190822035143.GB32551@gondor.apana.org.au>
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

On 8/21/19 11:51 PM, Herbert Xu wrote:
> On Mon, Aug 12, 2019 at 05:02:00PM -0400, Daniel Jordan wrote:
>> __padata_remove_cpu clears the offlined CPU from the usable masks after
>> padata_alloc_pd has initialized pd->cpu, which means pd->cpu could be
>> initialized to this CPU, causing padata to wait indefinitely for the
>> next job in padata_get_next.
>>
>> Make the usable masks reflect the offline CPU when they're established
>> in padata_setup_cpumasks so pd->cpu is initialized properly.
>>
>> Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
>> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: Steffen Klassert <steffen.klassert@secunet.com>
>> Cc: linux-crypto@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>
>> Hi, one more edge case.  All combinations of CPUs among
>> parallel_cpumask, serial_cpumask, and CPU hotplug have now been tested
>> in a 4-CPU VM, and an 8-CPU VM has run with random combinations of these
>> settings for over an hour.
>>
>>   kernel/padata.c | 18 ++++++++++++++----
>>   1 file changed, 14 insertions(+), 4 deletions(-)
> 
> If we modify patch 2/2 by calling this after cpu_online_mask
> has been updated then this problem should go away because we
> can then remove the cpumask_clear_cpu calls.

Yep, agreed.
