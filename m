Return-Path: <SRS0=BixN=4J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD07DC35659
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 17:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E6AF222C4
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 17:42:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CNH1qLAf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgBURm0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 12:42:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40138 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgBURm0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 12:42:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LHc0FZ028765;
        Fri, 21 Feb 2020 17:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LRYV1bqrtYHpCN4fb7HaSFnbKvEuCaHF8P1aMViUCL8=;
 b=CNH1qLAfUWcxTj/4TRpqWQJXUVpBF4X8aYaQszqoMSUpzvirzAqS37yWwb0iUTcoplQN
 b6wr/qg58nt+sO+jcVnxXWCvze1YjqbuDgbKMuKihn1FzkWkhDAXUm5hkIMSQu63F5IE
 oqjAyTJlwyxfWnUawzRNEpPD4Zghtg+CPOqQO1xggbMmLKMz27O0/bHLWkZuFJ7XPhMW
 ocvO9UmsAaVho1iY5Vfaw9ZcXV7lYHDrKm2sTqGmzmGJ4R/tSqkVcQreYfoSj/VvwWd/
 BpG68kzEUgCozO68PkFrBi2/2HuP2x/HWmRe61+tWnkzFobwZDmOMR5HIN6H2dE04neO Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2y8udksyud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 17:42:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LHfuMU089895;
        Fri, 21 Feb 2020 17:42:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2y8udp6kfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 17:42:12 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01LHg7Ie013190;
        Fri, 21 Feb 2020 17:42:07 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 09:42:06 -0800
Date:   Fri, 21 Feb 2020 12:42:23 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>, tj@kernel.org,
        jiangshanlai@gmail.com, will@kernel.org, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
References: <20200217204803.GA13479@Red>
 <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
 <20200220090350.GA19858@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220090350.GA19858@Red>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=634
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=693 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210133
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 20, 2020 at 10:03:50AM +0100, Corentin Labbe wrote:
> But I got the same with plain next (like yesterday 5.6.0-rc2-next-20200219 and tomorow 5.6.0-rc2-next-20200220) and master got the same issue.

Thanks.  I've been trying to reproduce this on an arm board but it's taking a
while to get it setup since I've never used it for kernel work.

Hoping to get it up soon, though someone with a working setup may be in a
better position to help with this.
