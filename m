Return-Path: <SRS0=oD/a=4Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEB6C3F2D2
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 15:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DF3F246AC
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 15:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EZcxPLjY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgB1Pd3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Feb 2020 10:33:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58446 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgB1Pd2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Feb 2020 10:33:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SFNbpO014854;
        Fri, 28 Feb 2020 15:33:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=UECnQ/oTwdSNKe5Xwj90yZ1hGNYLYSWaAjIgZTEoUHg=;
 b=EZcxPLjYQUuIr1PPWvoGLq8u79eUUlRU43u5TEmqxPhBi58LneZRsmGtX7jN2h7oOgTE
 J6PFnqBvcjuZWqJqgzFrWd7iPEhDmnuvRtQzWBym7/lSpBz64UPxkLreMt+krvxlk6FR
 FoxP+HtsaLrv9ibUQjJpQ8UgA+Cxz6+aNL15PRw1k/QmRrB+dGeCRUK7RMREF8f6AXBA
 z0BjLYFzNtvQW+i/D0/PJ7IHsDq0Wu8JhhdhwMLeuXhOh+rjacsQK+a+gadD6ffQnpK3
 2kl9efrg2X6O5AE/2STjo1Rrp0AhHytXh1aMF3+XDjmgae2gZ1XvC4RPQMbAx3pIFFBR Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ydcsnun8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 15:33:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SFWNsH144227;
        Fri, 28 Feb 2020 15:33:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ydcsepxuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 15:33:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SFXE50018142;
        Fri, 28 Feb 2020 15:33:15 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 07:33:14 -0800
Date:   Fri, 28 Feb 2020 10:33:31 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Will Deacon <will@kernel.org>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>, tj@kernel.org,
        jiangshanlai@gmail.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
References: <20200217204803.GA13479@Red>
 <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
 <20200220090350.GA19858@Red>
 <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228123311.GE3275@willie-the-truck>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=727 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=793 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280122
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 28, 2020 at 12:33:12PM +0000, Will Deacon wrote:
> On Fri, Feb 21, 2020 at 12:42:23PM -0500, Daniel Jordan wrote:
> > On Thu, Feb 20, 2020 at 10:03:50AM +0100, Corentin Labbe wrote:
> > > But I got the same with plain next (like yesterday 5.6.0-rc2-next-20200219 and tomorow 5.6.0-rc2-next-20200220) and master got the same issue.
> > 
> > Thanks.  I've been trying to reproduce this on an arm board but it's taking a
> > while to get it setup since I've never used it for kernel work.
> > 
> > Hoping to get it up soon, though someone with a working setup may be in a
> > better position to help with this.
> 
> Any joy with this? It sounded to me like the issue also happens on a
> mainline kernel. If this is the case, have you managed to bisect it?

I managed to get recent mainline (rawhide) booting days ago but wasn't able to
reproduce on a rpi 3b+.

My plan had been to try debug-by-email next, but then something exploded
internally and I haven't had time for it yet.  Still intending to help once the
explosion is contained, provided someone can't get to it sooner.

thanks,
Daniel
