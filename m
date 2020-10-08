Return-Path: <SRS0=kcel=DP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A359C433E7
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 17:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2292221F1
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 17:00:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KBNWIPuW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgJHRAn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Oct 2020 13:00:43 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39328 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgJHRAn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Oct 2020 13:00:43 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098GsS9O177249;
        Thu, 8 Oct 2020 17:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=1vH0OsjmL5a+LFZyquS1yehptSAp2NAApw9a5KtUAHY=;
 b=KBNWIPuWY25lE/DBE09mNhUj288XRuNkTPxXBo1/Dg8dpmXD+VTJqjisEZTThOlo+GC3
 rhyTMimTOx6Fj/3lz6g8tfl8gtxfMZBuQNCFlzMwU2dc+VM8/6F1sgxk7hDPePaPaopz
 hS2iE/CWVfMybkpmbeior7pGXoB6mUAm0uaWE4kCtbiGaxxWNpCX33f6DIMb3d32jrtP
 8QbvIvZ+RGQVSebrMcHDn88isnu5piG3L5g5pFsGBoomtnhawVJaEY1jkBPRU2LOrwmv
 HCnbnlR4Ld2g5smJl6VWQrmsbBinavqTE74OzwBlfecEnbRM1h/UOMJ9sxAdAyc3ULHb Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33xetb91h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 17:00:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098GtG8C185292;
        Thu, 8 Oct 2020 16:58:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 341xnby43p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 16:58:28 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098GwR1m027465;
        Thu, 8 Oct 2020 16:58:27 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 09:58:26 -0700
Date:   Thu, 8 Oct 2020 13:07:36 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>, mark.rutland@arm.com,
        jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, tj@kernel.org,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20201008170736.h3ajky2wgonbfred@ca-dmjordan1.us.oracle.com>
References: <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
 <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
 <20200301175351.GA11684@Red>
 <20200302172510.fspofleipqjcdxak@ca-dmjordan1.us.oracle.com>
 <e7c92da2-42c0-a97d-7427-6fdc769b41b9@arm.com>
 <20200303213017.tanczhqd3nhpeeak@ca-dmjordan1.us.oracle.com>
 <20201001175022.GA22444@Red>
 <20201005170910.vxwrdwnzlw3ahkb4@ca-dmjordan1.us.oracle.com>
 <20201007194117.GA4859@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007194117.GA4859@Red>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080126
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 07, 2020 at 09:41:17PM +0200, Corentin Labbe wrote:
> I have added CONFIG_FTRACE=y and your second patch.
> The boot log can be seen at http://kernel.montjoie.ovh/108789.log
> 
> But it seems the latest dump_stack addition flood a bit.

Heh, sorry for making it spew, there wasn't such a flood when I tried.  Your
output is sufficiently incriminating, so I'll go post the fix now.

> I have started to read ftrace documentation, but if you have a quick what to do in /sys/kernel/debug/tracing, it will be helpfull.

Sure, you can view the trace in /sys/kernel/debug/tracing/trace and
kernel-parameters.txt has the boot options documented.
