Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526A2C3A5A1
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 22:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB12233A2
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 22:13:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G8G+3jdf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390281AbfHVWNl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 18:13:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38584 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390161AbfHVWNl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 18:13:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MM46Db107969;
        Thu, 22 Aug 2019 22:13:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=YQfxUm4RiEvSqlcjX0k9QKDvOnMyqXQq+e0T49ZJ0/o=;
 b=G8G+3jdfo8lxnRB0Y0IEllzGd50Pman7d/LDg3V18TA+/oKZxcmBqG4pDBEJafKfLzrb
 /GKnaFIc0oflWVwhZ4OPScaMivjhyMjv0Q1L42EgbfD/0WMdA7iDis1k9p5Trh6Vbgyg
 fwN0pv9svTrHVYLzGx1Xa+9CIUeHNG1tTVnUu9V4ryQtjMzA8Woj3heafFmSuLG9udxy
 7yfNF2XrryIbaD4PWpv885fVe+YM3PYWuN/sLCMls0gBSYaLspiVlOKndyV7VO3AbSvh
 ULbUPzNd7lKNcZpOWYxkMCtY940iCFik5djkQNNT5+pwTfS7GOdwsUtJAFLt/R4ln0kv mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uea7r8uus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 22:13:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MM41UL194552;
        Thu, 22 Aug 2019 22:13:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2uh2q6hut4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 22:13:17 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7MMDGP6005900;
        Thu, 22 Aug 2019 22:13:16 GMT
Received: from [192.168.1.219] (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 15:13:16 -0700
Subject: Re: [PATCH 8/9] padata: unbind parallel jobs from specific CPUs
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
 <20190813005224.30779-9-daniel.m.jordan@oracle.com>
 <20190822041340.GA590@gondor.apana.org.au>
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
Message-ID: <dd31ec02-4a52-995d-801a-95bec39f4944@oracle.com>
Date:   Thu, 22 Aug 2019 18:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <20190822041340.GA590@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908220194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220194
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/22/19 12:13 AM, Herbert Xu wrote:
> On Mon, Aug 12, 2019 at 08:52:23PM -0400, Daniel Jordan wrote:
>>
>> @@ -191,22 +184,25 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
>>   		padata = list_entry(reorder->list.next,
>>   				    struct padata_priv, list);
>>   
>> -		list_del_init(&padata->list);
>> -		atomic_dec(&pd->reorder_objects);
>> +		/*
>> +		 * The check fails in the unlikely event that two or more
>> +		 * parallel jobs have hashed to the same CPU and one of the
>> +		 * later ones finishes first.
>> +		 */
>> +		if (padata->seq_nr == pd->processed) {
>> +			list_del_init(&padata->list);
>> +			atomic_dec(&pd->reorder_objects);
> 
> Now that you've changed the test for whether there is work to be
> done you also need to update the code at the end of padata_reorder
> that checks whether there is work to do.  Otherwise we can end up
> in a busy loop that just wastes CPU cycles.

So we can, thanks for catching that.
