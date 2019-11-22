Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5E3C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 16:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD7E20714
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 16:28:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NVHv/2Eo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfKVQ2S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 11:28:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33638 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVQ2R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 11:28:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMGODnX029754;
        Fri, 22 Nov 2019 16:28:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=SnkAoFLe34M7NtOQkFzQOWouFU/OBziOwmj95OAqjng=;
 b=NVHv/2EoAgLwcaRi41l6habM5YyapMqPsRy1YiMlmML2KYCjqbmqwGiT3LjFoxFpyTzw
 pSC6bBDsHqqxTW/Y0sfu9R1CKX92oBqEZS77kgS8IaVW7ur8XCrUoSrvWbPKKhv7SqSN
 E653LR0kxSNJVD24rVhV3ywHZWRVJM8YSIUFY+0hDBU3AsIZriXSBLBza0b8Kxc2yDfk
 EqqPz24WRIaGWaLarsv1X1eVcHcTjtKfv4igC40+nlXEW9qoYshiSzhw1bxHwV8TKSol
 eHGc4D9shNx1BV8aHbrH+GAqsExu1FwARtMF2T08+pSU0dZ4eLXMoam9ThWjVavOUyBK kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8hubny4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 16:28:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMGJ5qA058800;
        Fri, 22 Nov 2019 16:28:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wegqrjcy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 16:28:06 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAMGS503028121;
        Fri, 22 Nov 2019 16:28:05 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 08:28:05 -0800
Date:   Fri, 22 Nov 2019 11:28:12 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [v2 PATCH] crypto: pcrypt - Avoid deadlock by using per-instance
 padata queues
Message-ID: <20191122162812.a4uzsnvr7crghtzo@ca-dmjordan1.us.oracle.com>
References: <20191119130556.dso2ni6qlks3lr23@gondor.apana.org.au>
 <20191119173732.GB819@sol.localdomain>
 <20191119185827.nerskpvddkcsih25@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119185827.nerskpvddkcsih25@gondor.apana.org.au>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220141
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 20, 2019 at 02:58:27AM +0800, Herbert Xu wrote:
>  static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
>  {
> -	struct parallel_data *pd = NULL;
> -
>  	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
> +		cpumask_clear_cpu(cpu, pinst->cpumask.pcpu);
> +		cpumask_clear_cpu(cpu, pinst->cpumask.cbcpu);
>  
>  		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
>  		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
>  			__padata_stop(pinst);
>  
> -		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
> -				     pinst->cpumask.cbcpu);
> -		if (!pd)
> -			return -ENOMEM;
> -
> -		padata_replace(pinst, pd);
> -
> -		cpumask_clear_cpu(cpu, pd->cpumask.cbcpu);
> -		cpumask_clear_cpu(cpu, pd->cpumask.pcpu);
> +		padata_replace(pinst);
>  	}

Clearing the offlined CPU from pinst's cpumasks means it won't be used if it
comes back online.

The CPU could be cleared from all pd's attached to the instance, but that
doesn't address another bug in this function that's fixed by this patch:

    https://lore.kernel.org/linux-crypto/20190828221425.22701-6-daniel.m.jordan@oracle.com/

Should I add it into the next version of the padata series I just posted?:

    https://lore.kernel.org/linux-crypto/20191120185412.302-1-daniel.m.jordan@oracle.com/

It would obviate the need for your patch to mess with cpumask_clear_cpu().  Or
is there something else you'd prefer?

Thanks,
Daniel
