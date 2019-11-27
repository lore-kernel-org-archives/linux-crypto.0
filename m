Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7740C432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 23:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99D9E2051A
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 23:38:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OcBDwEjb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfK0Xi5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 18:38:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49640 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfK0Xi5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 18:38:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xARNTFt8040141;
        Wed, 27 Nov 2019 23:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3NwS4X9XFfYjuFrYcJ84uMMgzhEabxEQjLay4ia45Gs=;
 b=OcBDwEjb5J1CuR3rd9zy8FdDwUfobuM7Kj7s4cGr2CuuutpYhKm1a9R+mWMUlK1f62RR
 a54abz//WKc4jLpXo3Xl/XDAGCaCthgbhLSt6x5lSzDzedFky+KNZ8mXKOS1ZmTDELsi
 YA41aaFvXTsvsPzBwTej8489rF6Sxl4cQU9qn55VruWEFI75jI8DEsxmnMzx5BV3DSUI
 UcSTia89vCSlfk5ghaD1CoPFe3gXfvGS6oPAzjQWbi4fpQeNGa4+jmD8zsOKp6tY0yZw
 NOapC+of1mAm4uyw9s2yGqL/A3wSUsROotXOsEyVQA515TBrsoIpHX7nkcURTwGnw/BK Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wewdrg9p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 23:38:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xARNchf7156028;
        Wed, 27 Nov 2019 23:38:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2whx5rcghj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 23:38:47 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xARNcXrs027310;
        Wed, 27 Nov 2019 23:38:33 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 Nov 2019 15:38:32 -0800
Date:   Wed, 27 Nov 2019 18:38:40 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [v3 PATCH] crypto: pcrypt - Avoid deadlock by using per-instance
 padata queues
Message-ID: <20191127233840.2yggxrlinztiueor@ca-dmjordan1.us.oracle.com>
References: <20191119130556.dso2ni6qlks3lr23@gondor.apana.org.au>
 <20191119173732.GB819@sol.localdomain>
 <20191119185827.nerskpvddkcsih25@gondor.apana.org.au>
 <20191126053238.yxhtfbt5okcjycuy@ca-dmjordan1.us.oracle.com>
 <20191126075845.2v3woc3xqx2fxzqh@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126075845.2v3woc3xqx2fxzqh@gondor.apana.org.au>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9454 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=890
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9454 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=950 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270188
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 26, 2019 at 03:58:45PM +0800, Herbert Xu wrote:
> On Tue, Nov 26, 2019 at 12:32:38AM -0500, Daniel Jordan wrote:
> > 
> > I think it's possible for a task in padata_do_parallel() racing with another in
> > padata_replace() to use a pd after free.  The synchronize_rcu() comes after the
> > pd_old->refcnt's are dec'd.
> 
> Thanks.  I've fixed this as well as the CPU mask issue you identified
> earlier.

I spent some time reviewing and testing this today, and the changes to
padata.h/c look fine to me.

Daniel
