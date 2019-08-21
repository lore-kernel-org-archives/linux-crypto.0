Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C631C3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 04:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2B622DD3
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 04:15:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OA8QEXLt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfHUEPq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 00:15:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfHUEPp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 00:15:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7L4E1Jk135181;
        Wed, 21 Aug 2019 04:15:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=s9qTOfA4d5BMcENzLGFCUjg8Btuu3dasH6vLkzDj+6M=;
 b=OA8QEXLt5yyXLtF09f5Wi8wrSSo5fLPm/h2eMnBBCyUzHRS5k5RTsDBj8D7zLPuKRKQI
 zrIjrOcceYtn3nH1RPMNsr44A5AcP8YFctSJdBgB9Z7i1oIIWHGhrtqC+neh2CGRHJHX
 U3oooCXHfxedTEQlbatlj5zqG3KtP4+699QVojGavN+0qRLkZVki1bUsshSfiOwtuR2W
 AHx+o3EI7BCTsLiJuSUt+ICy1Rl51q1TO1Ynzg7Tnofc6zFpUZ8blhELDF8eStzyUnG3
 22/Ztjf2LbnYZgT/YTlXDLgxNnslyGxq5osit0uqxmh+/g/VjCx+suKOVq+mlWVzp4PD Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ue9hpjjb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 04:15:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7L4Dqha143352;
        Wed, 21 Aug 2019 04:15:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ugj7peb84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 04:15:22 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7L4FKrh024184;
        Wed, 21 Aug 2019 04:15:20 GMT
Received: from [192.168.1.218] (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 21:15:19 -0700
Subject: Re: [PATCH 0/9] padata: use unbound workqueues for parallel jobs
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
 <20190820060726.GL2879@gauss3.secunet.de>
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
Message-ID: <dd6a7e57-d4ed-c27e-4450-8850762ef042@oracle.com>
Date:   Wed, 21 Aug 2019 00:15:18 -0400
MIME-Version: 1.0
In-Reply-To: <20190820060726.GL2879@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908210044
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908210044
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/20/19 2:07 AM, Steffen Klassert wrote:
> Looks good!
> 
> I did a test with IPsec pcrypt and it seems to work as expected.
> Crypto load gets distributed, no network packet reordering.
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks for testing this, Steffen!
