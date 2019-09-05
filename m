Return-Path: <SRS0=9BFZ=XA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3F0C43331
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 22:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00A2D20825
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 22:38:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gd36TohF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731969AbfIEWiZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:38:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfIEWiZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 18:38:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MYURF061084;
        Thu, 5 Sep 2019 22:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=SMr5Wa1/JRqleE5iB2SBJYc1hjMDbWANCCSO+yo7+7A=;
 b=gd36TohFcCgMahV+CDJYj5r05LKAiLCosdVUECyedsnKRj7lvI76xNyOFnwJ3pD3k1s/
 TZ3Y1N5bvPtBRXU+iOjyRutGjuBjT6iVUucSN9XiWWTHHA6KJEOFTdew7i4AP/pIo/My
 UiMQYzi3qDaEGZOZMMcTcWQG+1NaaIpjqmyy6NEhazHwdkr23lyjUcdZQ1z8Vc5k6MtG
 V/H5uDMp1ViiwRU4lm1omUg0rIfspI0K/iTuOmC9TzUMT/Np//KdX4SayiPsuj8W6Cj2
 fnxM2P9YkyqLCN6UpqLanR/pOiTghYtjmRiZPsVqCjLIw2kE+PqF9T1rWv5wgJYkiUhO hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uub5yr117-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 22:38:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MYHBO035022;
        Thu, 5 Sep 2019 22:38:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2utpmby59r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 22:38:05 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85Mc3iT012918;
        Thu, 5 Sep 2019 22:38:03 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:38:03 -0700
Date:   Thu, 5 Sep 2019 18:37:56 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] padata: make flushing work with async users
Message-ID: <20190905223756.wmmjkjvztlerjzee@ca-dmjordan1.us.oracle.com>
References: <20190828221425.22701-1-daniel.m.jordan@oracle.com>
 <20190828221425.22701-2-daniel.m.jordan@oracle.com>
 <20190905041734.GA25330@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905041734.GA25330@gondor.apana.org.au>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050210
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 05, 2019 at 02:17:35PM +1000, Herbert Xu wrote:
> On Wed, Aug 28, 2019 at 06:14:21PM -0400, Daniel Jordan wrote:
> >
> > @@ -453,24 +456,15 @@ static void padata_free_pd(struct parallel_data *pd)
> >  /* Flush all objects out of the padata queues. */
> >  static void padata_flush_queues(struct parallel_data *pd)
> >  {
> > -	int cpu;
> > -	struct padata_parallel_queue *pqueue;
> > -	struct padata_serial_queue *squeue;
> > -
> > -	for_each_cpu(cpu, pd->cpumask.pcpu) {
> > -		pqueue = per_cpu_ptr(pd->pqueue, cpu);
> > -		flush_work(&pqueue->work);
> > -	}
> > -
> > -	if (atomic_read(&pd->reorder_objects))
> > -		padata_reorder(pd);
> > +	if (!(pd->pinst->flags & PADATA_INIT))
> > +		return;
> >  
> > -	for_each_cpu(cpu, pd->cpumask.cbcpu) {
> > -		squeue = per_cpu_ptr(pd->squeue, cpu);
> > -		flush_work(&squeue->work);
> > -	}
> > +	if (atomic_dec_return(&pd->refcnt) == 0)
> > +		complete(&pd->flushing_done);
> >  
> > -	BUG_ON(atomic_read(&pd->refcnt) != 0);
> > +	wait_for_completion(&pd->flushing_done);
> > +	reinit_completion(&pd->flushing_done);
> > +	atomic_set(&pd->refcnt, 1);
> >  }
> 
> I don't think waiting is an option.  In a pathological case the
> hardware may not return at all.  We cannot and should not hold off
> CPU hotplug for an arbitrary amount of time when the event we are
> waiting for isn't even occuring on that CPU.

Ok, I hadn't considered hardware not returning.

> I don't think flushing is needed at all.  All we need to do is
> maintain consistency before and after the CPU hotplug event.

I could imagine not flushing would work for replacing a pd.  The old pd could
be freed by whatever drops the last reference and the new pd could be
installed, all without flushing.

In the case of freeing an instance, though, padata needs to wait for all the
jobs to complete so they don't use the instance's data after it's been freed.
Holding the CPU hotplug lock isn't necessary for this, though, so I think we're
ok to wait here.
