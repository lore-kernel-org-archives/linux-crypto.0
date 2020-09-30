Return-Path: <SRS0=wif3=DH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E840C4727C
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Sep 2020 18:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9BD62076A
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Sep 2020 18:09:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VarIvOdW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgI3SJ2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Sep 2020 14:09:28 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45712 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgI3SJ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Sep 2020 14:09:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UI01dV050533;
        Wed, 30 Sep 2020 18:09:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=UEaRiYRBxUeUBHTLs10lcQvjesJtGuVb0ziBQ7IPbec=;
 b=VarIvOdWDEDO1H8/IlOUyZWRpyoJ8CieyKlwQ/sjnuOx1B9Yf78LOfRaU0dePDiKmWvp
 VgbV0kYlAsSLIJmD0RMzMLEvAAO4/GoRIeKGt6S9JY5VDeNB4Oun901CojDxE2l1r1sN
 MRHq5UdnbGazZs6J/EVhSbHbTXn0fqq1quQoWHBFhvvD+HT3vjuUi9BcxmB9XzIE3RDS
 jvDHXijWiqjDBDkEdaaBAtxlRCAku9LYyPKy/mnAtLRCuI7YqXPUVuGE+O+vkMzR4MI0
 kYOmWJX4rki+sbBWr4Ct1pUyk95olzCtu3w+dD40gnx+Wf4jdNvh4ty6chXJI++VSA+b gA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33su5b24b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 18:09:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UI4tNl093183;
        Wed, 30 Sep 2020 18:09:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33uv2frmdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 18:09:17 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08UI9Gc7025354;
        Wed, 30 Sep 2020 18:09:16 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 11:09:16 -0700
Date:   Wed, 30 Sep 2020 14:18:23 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Will Deacon <will@kernel.org>, tj@kernel.org,
        jiangshanlai@gmail.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20200930181823.vq3up3vcxau7nf3y@ca-dmjordan1.us.oracle.com>
References: <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
 <20200220090350.GA19858@Red>
 <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
 <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
 <20200301175351.GA11684@Red>
 <20200302172510.fspofleipqjcdxak@ca-dmjordan1.us.oracle.com>
 <20200303074819.GB9935@Red>
 <20200303213111.op2vtxfmwtn7i6db@ca-dmjordan1.us.oracle.com>
 <20200925181203.GA26463@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925181203.GA26463@Red>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1011 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300143
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 25, 2020 at 08:12:03PM +0200, Corentin Labbe wrote:
> On Tue, Mar 03, 2020 at 04:31:11PM -0500, Daniel Jordan wrote:
> > On Tue, Mar 03, 2020 at 08:48:19AM +0100, Corentin Labbe wrote:
> > > The patch fix the issue. Thanks!
> > 
> > Thanks for trying it!
> > 
> > > So you could add:
> > > Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > Tested-on: sun50i-h6-pine-h64
> > > Tested-on: imx8mn-ddr4-evk
> > > Tested-on: sun50i-a64-bananapi-m64
> > 
> > I definitely will if the patch turns out to be the right fix.
> > 
> > thanks,
> > Daniel
> 
> Hello
> 
> I forgot about this problem since the patch is in my branch since.
> But a co-worker hit this problem recently and without this patch my CI still have it.

Hi,

Sure, I'm happy to help get a fix merged, but let's nail down what the problem
is first.  It'd be useful to have the things requested here:

https://lore.kernel.org/linux-crypto/20200303213017.tanczhqd3nhpeeak@ca-dmjordan1.us.oracle.com/

thanks,
Daniel
