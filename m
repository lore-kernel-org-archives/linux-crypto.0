Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B53C47254
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 00:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 721EE206EB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 00:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VNmjKBsk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEEAzD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 May 2020 20:55:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55038 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgEEAzC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 May 2020 20:55:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0450nBAw033812;
        Tue, 5 May 2020 00:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=b3hPsJgnAq/dGfbpEbMlQqeRtWLtkJ/rfPDyw2Kx044=;
 b=VNmjKBskPOyZS197EmCQoi9ZiqIP06MS+SawxA9c3nHNfIvLXhhdrxqFyezuH6cEMFWU
 mPBV25shFRDsnHQMLyib/s1z7f6rPTjH2thwc4QUn+mUf6axExVTuX/afF42wvquiZ0b
 dxp7tOuXFQFc0j5gYOtHOGvKUHpe/h+JLBjJVtJUqn0LTAVMG7nyP1saa/UUZHPJyemd
 DYOvxf+AdvztjhEMfYbcqOdKsy2me3SyAgD0S50D3BfwUJ6WABhXDe16/rvpTWwWkN5q
 wRdJZQ50aqgW/OmgkaqhXFSIBn9y8DNGKMdnJTFUY8Cp7L2ZLQAMs4ysE+QtFsdLARV7 Ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30s0tma05p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 00:54:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0450kWUb096333;
        Tue, 5 May 2020 00:54:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30sjjx9k42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 00:54:19 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0450sBVI006589;
        Tue, 5 May 2020 00:54:11 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 17:54:11 -0700
Date:   Mon, 4 May 2020 20:54:33 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-crypto@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] mm: move zone iterator outside of
 deferred_init_maxorder()
Message-ID: <20200505005432.bohmaa6zeffhdkgn@ca-dmjordan1.us.oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-6-daniel.m.jordan@oracle.com>
 <deadac9a-fbef-6c66-207c-83d251d2ef50@linux.intel.com>
 <20200501024539.tnjuybydwe3r4u2x@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uctro3+PWeJTi=O3Yc2qUF8Oy+HrypzCUzkaCt=XH0Lkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Uctro3+PWeJTi=O3Yc2qUF8Oy+HrypzCUzkaCt=XH0Lkg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050003
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 04, 2020 at 03:10:46PM -0700, Alexander Duyck wrote:
> So we cannot stop in the middle of a max order block. That shouldn't
> be possible as part of the issue is that the buddy allocator will
> attempt to access the buddy for the page which could cause issues if
> it tries to merge the page with one that is not initialized. So if
> your code supports that then it is definitely broken. That was one of
> the reasons for all of the variable weirdness in
> deferred_init_maxorder. I was going through and making certain that
> while we were initializing the range we were freeing the pages in
> MAX_ORDER aligned blocks and skipping over whatever reserved blocks
> were there. Basically it was handling the case where a single
> MAX_ORDER block could span multiple ranges.
> 
> On x86 this was all pretty straightforward and I don't believe we
> needed the code, but I seem to recall there were some other
> architectures that had more complex memory layouts at the time and
> that was one of the reasons why I had to be careful to wait until I
> had processed the full MAX_ORDER block before I could start freeing
> the pages, otherwise it would start triggering memory corruptions.

Yes, thanks, I missed the case where deferred_grow_zone could stop
mid-max-order-block.

Maybe it's better to leave deferred_init_maxorder alone and adapt the
multithreading to the existing implementation.  That'd mean dealing with the
pesky opaque index somehow, so deferred_init_mem_pfn_range_in_zone() could be
generalized to find it in the thread function based on the start/end range, or
it could be maintained as part of the range that padata passes to the thread
function.

Or, keep this patch but make sure deferred_grow_zone stops on a
max-order-aligned boundary.
