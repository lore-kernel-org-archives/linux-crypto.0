Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E30C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 19:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D89A2245D
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 19:24:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LO2dRHCy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfKSTYP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 14:24:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44236 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfKSTYP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 14:24:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJJJBoP072724;
        Tue, 19 Nov 2019 19:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=QxgcqLxoGjB8tiiHLUzk3bvI2hEG7GG+c6sd93JVxAE=;
 b=LO2dRHCyRmYOfZlnkSFpTudygOdKoIXFYUlzaOU+k/zAwyqxK9wZ0FqSjLQfvpa+2b4u
 VQc6RDJdqRZaJMX1Si5+Xs6oiVCw/JmUuVRDedNlVVlrZ6LOYxFYR73HTPTlqyVgLdGN
 o8x6kxeowdy1Cvxbh8sluYiMj9/fb6bSSZl26s1sRjXf4UBBDkqQNyxYpict6sjr32Fn
 Q2Gc+hE4vm6RGNEyPeUipHatR0onaYfKsUyy566GsWfU4vv6TU4Bs2jUgUMPfj8uAzyd
 p1AoUS3IITiP58zJ3HQMjL4YzfkuUpTuo8Byn4s2UCEXUOH2IuajUluzzkbHnRYHFXAx aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8hts5u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 19:24:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJJN8uh170689;
        Tue, 19 Nov 2019 19:24:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wbxm4s9c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 19:24:04 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAJJO3Qu019812;
        Tue, 19 Nov 2019 19:24:03 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 11:24:03 -0800
Date:   Tue, 19 Nov 2019 14:24:05 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Remove broken queue flushing
Message-ID: <20191119192405.imfi6q4u3g2zgstc@ca-dmjordan1.us.oracle.com>
References: <20191119051731.yev6dcsp2znjaagz@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119051731.yev6dcsp2znjaagz@gondor.apana.org.au>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190160
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 19, 2019 at 01:17:31PM +0800, Herbert Xu wrote:
> The function padata_flush_queues is fundamentally broken because
> it cannot force padata users to complete the request that is
> underway.  IOW padata has to passively wait for the completion
> of any outstanding work.
> 
> As it stands flushing is used in two places.  Its use in padata_stop
> is simply unnecessary because nothing depends on the queues to
> be flushed afterwards.
> 
> The other use in padata_replace is more substantial as we depend
> on it to free the old pd structure.  This patch instead uses the
> pd->refcnt to dynamically free the pd structure once all requests
> are complete.

__padata_free unconditionally frees pd, so a padata job might choke on it
later.  padata_do_parallel calls seem safe because they use RCU, but it seems
possible that a job could call padata_do_serial after the instance is gone.

Best idea I can think of now is to indicate the instance has been freed in the
pd before dropping the initial pd ref in __padata_free, and use that to bail
out early from places that touch the instance or its data (workqueues say).
Will think more on this.


(By the way, I was on leave longer than anticipated, so thanks for picking up
my slack on this patch.  I plan to repost my other padata fixes soon.)
