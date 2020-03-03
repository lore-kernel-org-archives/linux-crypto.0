Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F52AC3F2C6
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 21:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D533020842
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 21:31:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UTGtCeaV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732546AbgCCVbM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 16:31:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52354 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732505AbgCCVbM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 16:31:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023LS4SG092617;
        Tue, 3 Mar 2020 21:30:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=yp0/8z5zvQXZIVH4pA65SFCLeNa4/KuEvMX5IX0JbsQ=;
 b=UTGtCeaVWNJitx5qI5IaBY1vXZpQKmAFz1r1sU7m9wjoRGJv3tEdSU2PXc+y78ZxTIxq
 LiM4K0JoULxAL2y3ordRvn4E/mlTFW92NafQSciRwCWh09R2t6jg9zoxiyIpPwmH62p1
 tnns2MVYkro7J/HMsKxiXj1DmR7MTagygsIRUO7dWfXjpdRC5zqlJT9XNQwqxhKyyxMu
 BYfid/DIT3L2ryAVg4nyv2QSawiBpYyHn1XF8hFUbwCHO0SgOYCPfd8klK+KQzsQlVEy
 6ptkLsfsgsZXUFx8LWKaDLzRLPbqZC+3vLndepnLYl2vpdtDp0tCZSAjjtTYsvERT2hI GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yffwqt3eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 21:30:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023LSchb010272;
        Tue, 3 Mar 2020 21:30:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2yg1p5g557-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 21:30:55 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 023LUsaQ020178;
        Tue, 3 Mar 2020 21:30:54 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 13:30:53 -0800
Date:   Tue, 3 Mar 2020 16:31:11 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Will Deacon <will@kernel.org>, tj@kernel.org,
        jiangshanlai@gmail.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20200303213111.op2vtxfmwtn7i6db@ca-dmjordan1.us.oracle.com>
References: <20200217204803.GA13479@Red>
 <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
 <20200220090350.GA19858@Red>
 <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
 <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
 <20200301175351.GA11684@Red>
 <20200302172510.fspofleipqjcdxak@ca-dmjordan1.us.oracle.com>
 <20200303074819.GB9935@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303074819.GB9935@Red>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=772 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=821 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1011 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030136
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 03, 2020 at 08:48:19AM +0100, Corentin Labbe wrote:
> The patch fix the issue. Thanks!

Thanks for trying it!

> So you could add:
> Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Tested-on: sun50i-h6-pine-h64
> Tested-on: imx8mn-ddr4-evk
> Tested-on: sun50i-a64-bananapi-m64

I definitely will if the patch turns out to be the right fix.

thanks,
Daniel
