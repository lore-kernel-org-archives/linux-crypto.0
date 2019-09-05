Return-Path: <SRS0=9BFZ=XA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07FBC43331
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 22:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8D80206DE
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 22:40:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p23Nw56N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390323AbfIEWk0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:40:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55660 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731458AbfIEWkZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 18:40:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MXakO060612;
        Thu, 5 Sep 2019 22:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=j4duDJkDTLknvUpbMVOSUtirQmIgH4PjV/EQIrfRAgQ=;
 b=p23Nw56N0c1kF9pYFKppS2aA5ftLjfUjoyYmfwhIykDLBzxcuDJWKu1ooZYmk6vZQC1E
 FNNH7kyJ33KlkHRvmHsfjSEPy0Shw19WlVGGhuunRvhPlHJ9qR0jAqWF3SH/88QwyXgo
 Fja/nvxlShfb2/Jv7lFLoxUpgcv5Afcmgwtn3tyM3F4FqCxmKUaozfsHl8A92DbbK7AZ
 5Hz2649uVsVEITfD5P/DdiejwkPhsZKYJo+4xXGDCwBmiNCT5XAyBhPIG+cJGOmrPgPm
 +QyJR/45vGn1dDa6ZpSEEXKoYL8tgIZajWWbgsw8/AMypcFtLxEYKKc0PQ2caxEwymHq wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uub5yr17v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 22:40:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MXM9Y154410;
        Thu, 5 Sep 2019 22:40:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uthq289s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 22:40:08 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85Me6Cm019154;
        Thu, 5 Sep 2019 22:40:06 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:40:06 -0700
Date:   Thu, 5 Sep 2019 18:40:04 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] padata: use unbound workqueues for parallel jobs
Message-ID: <20190905224004.jjavgjseaf4we3cm@ca-dmjordan1.us.oracle.com>
References: <20190829173038.21040-1-daniel.m.jordan@oracle.com>
 <20190905043548.GA27131@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905043548.GA27131@gondor.apana.org.au>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=882
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=946 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050210
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 05, 2019 at 02:35:48PM +1000, Herbert Xu wrote:
> On Thu, Aug 29, 2019 at 01:30:29PM -0400, Daniel Jordan wrote:
> > Hello,
> > 
> > Everything in the Testing section has been rerun after the suggestion
> > from Herbert last round.  Thanks again to Steffen for giving this a run.
> > 
> > Any comments welcome.
> > 
> > Daniel
> > 
> > v1[*]  -> v2:
> >  - Updated patch 8 to avoid queueing the reorder work if the next object
> >    by sequence number isn't ready yet (Herbert)
> >  - Added Steffen's ack to all but patch 8 since that one changed.
> 
> This doesn't apply against cryptodev.  Perhaps it depends on the
> flushing patch series? If that's the case please combine both into
> one series.

I had developed this on top of the flushing series, but this doesn't depend on
it, so I've rebased this onto today's cryptodev and will send it soon.
