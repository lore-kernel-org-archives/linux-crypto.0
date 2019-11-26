Return-Path: <SRS0=6oT7=ZS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8FDC432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 05:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA1E720637
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 05:32:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gT8QA1LE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfKZFcv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Nov 2019 00:32:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKZFcv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Nov 2019 00:32:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQ5THpq163100;
        Tue, 26 Nov 2019 05:32:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8zB3TsTytegvoCe09ZHtPxhgC3JiQuIcJm0pmU68R4Q=;
 b=gT8QA1LE74UdB2V1SxIShb6wQHb0dQaKBsLiVSL/HrjxPK7T09O80xUX3b7DaJLIFcqI
 MUDOlqN4+szwAEJ7eyfOoZ/dkeOUHc2qEmehFMSy+QThz4NLSP37DiHdXE5QZHKEnM78
 Op/uJP3Ni8bvg1hPSnaw2GGuDUoiT+zQCWJZMv5Vt9xnhjEJjsxo5iRD5B6U2kr+U4Wg
 okUcjSGQJymhQqdwDdMa6B9dE3xPElfZd/TU9getOzgXgwHGtn3XUVDd/SVKlSQrvESO
 OnREel2EYXa/jTyN4BEvtKo6iK1w5Uzo4Bm2GacNhjBbdaZ4S5z+F0cKiioKhJX5K4Ld hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wevqq49xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 05:32:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQ5T9NZ106090;
        Tue, 26 Nov 2019 05:32:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wgvfhujmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 05:32:33 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAQ5WVqE027572;
        Tue, 26 Nov 2019 05:32:31 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Nov 2019 21:32:30 -0800
Date:   Tue, 26 Nov 2019 00:32:38 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [v2 PATCH] crypto: pcrypt - Avoid deadlock by using per-instance
 padata queues
Message-ID: <20191126053238.yxhtfbt5okcjycuy@ca-dmjordan1.us.oracle.com>
References: <20191119130556.dso2ni6qlks3lr23@gondor.apana.org.au>
 <20191119173732.GB819@sol.localdomain>
 <20191119185827.nerskpvddkcsih25@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119185827.nerskpvddkcsih25@gondor.apana.org.au>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=860
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911260046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=926 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911260046
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 20, 2019 at 02:58:27AM +0800, Herbert Xu wrote:
>  /* Replace the internal control structure with a new one. */
> -static void padata_replace(struct padata_instance *pinst,
> -			   struct parallel_data *pd_new)
> +static int padata_replace_one(struct padata_shell *ps)
>  {
> -	struct parallel_data *pd_old = pinst->pd;
> +	struct parallel_data *pd_old = rcu_dereference_protected(ps->pd, 1);
> +	struct parallel_data *pd_new;
>  	int notification_mask = 0;
>  
> -	pinst->flags |= PADATA_RESET;
> -
> -	rcu_assign_pointer(pinst->pd, pd_new);
> +	pd_new = padata_alloc_pd(ps);
> +	if (!pd_new)
> +		return -ENOMEM;
>  
> -	synchronize_rcu();
> +	rcu_assign_pointer(ps->pd, pd_new);
>  
>  	if (!cpumask_equal(pd_old->cpumask.pcpu, pd_new->cpumask.pcpu))
>  		notification_mask |= PADATA_CPU_PARALLEL;
> @@ -510,10 +515,25 @@ static void padata_replace(struct padata_instance *pinst,
>  	if (atomic_dec_and_test(&pd_old->refcnt))
>  		padata_free_pd(pd_old);
>  
> +	return notification_mask;
> +}
> +
> +static void padata_replace(struct padata_instance *pinst)
> +{
> +	int notification_mask = 0;
> +	struct padata_shell *ps;
> +
> +	pinst->flags |= PADATA_RESET;
> +
> +	list_for_each_entry(ps, &pinst->pslist, list)
> +		notification_mask |= padata_replace_one(ps);
> +
> +	synchronize_rcu();
> +
>  	if (notification_mask)
>  		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
>  					     notification_mask,
> -					     &pd_new->cpumask);
> +					     &pinst->cpumask);
>  
>  	pinst->flags &= ~PADATA_RESET;
>  }

I think it's possible for a task in padata_do_parallel() racing with another in
padata_replace() to use a pd after free.  The synchronize_rcu() comes after the
pd_old->refcnt's are dec'd.

                                          padata_do_parallel()
                                            rcu_dereference_bh(ps->pd)
                                            // doesn't see PADATA_RESET set
padata_replace()
  pinst->flags |= PADATA_RESET
  padata_replace_one()
    rcu_assign_pointer(ps->pd, pd_new)
    atomic_dec_and_test(&pd_old->refcnt)
      padata_free_pd()
                                            atomic_inc(&pd->refcnt) // too late

If I'm not missing something, one way out is adding a list_head to
parallel_data for remembering the old pd's on a local list in padata_replace()
so that this function can loop over it and drop the refs after
synchronize_rcu().  A padata_do_parallel() call will have then had a chance to
take a ref on the pd it's using.


And, not this patch, but with the removal of flushing it seems there's no need
for PADATA_RESET, so it and its EBUSY error can go away.
