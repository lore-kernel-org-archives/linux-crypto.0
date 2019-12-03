Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45908C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 15:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 130F0206E4
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 15:59:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="abn0siPG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfLCP6x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 10:58:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58360 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfLCP6w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 10:58:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3FsCFB167734;
        Tue, 3 Dec 2019 15:58:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=vRbK+BHOHolKnG3spmB1q9qIIX/CoVm5hzmk62chmCA=;
 b=abn0siPGzuIrSp3j24etYksoSJjLBzqI/QaoMWxEbXW/i9w2LJgit2+1CVkrST3biZf/
 6fHVFCR2GRLslObThCgeutgqx0qzD60dTmdLLBr/V5zCVk6H+ZAm3tiAfa4lExC+IWR2
 dbMxe6PO70uTBQQXKD2jVEuN4ZIwKnpfUdLiXTtL4y+VrBpPNsqFcBz80M3uRtIHthN+
 aj7MfWKeEEzQHFoGEkbKqIBy9UKgn8ztw3bD6/RpPSHIWyFX5jYENUeh10x255NO0fit
 xvoryBmzh3aFz9vXeKVhu7otivowx9bUB9sDowuzgE0WUsKiVRkk6f2OBfuNspEoh7zV vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wkgcq8k4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 15:58:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3Fs8vj009867;
        Tue, 3 Dec 2019 15:58:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wn8k2tnrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 15:58:35 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB3FwXDB002024;
        Tue, 3 Dec 2019 15:58:33 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 07:58:32 -0800
Date:   Tue, 3 Dec 2019 10:58:41 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: RFD: multithreading in padata
Message-ID: <20191203155841.56egvxekxgf5xctw@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030121
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[resending in modified form since this didn't seem to reach the lists]

Hi,

padata has been undergoing some surgery lately[0] and now seems ready for
another enhancement: splitting up and multithreading CPU-intensive kernel work.

I'm planning to send an RFC for this, but I wanted to post some thoughts on the
design and a work-in-progress branch first to see if the direction looks ok.

Quoting from an earlier series[1], this is the problem I'm trying to solve:

  A single CPU can spend an excessive amount of time in the kernel operating
  on large amounts of data.  Often these situations arise during initialization-
  and destruction-related tasks, where the data involved scales with system
  size.  These long-running jobs can slow startup and shutdown of applications
  and the system itself while extra CPUs sit idle.
      
There are several paths where this problem exists, but here are three to start:

 - struct page initialization (at boot-time, during memory hotplug, and for
   persistent memory)
 - VFIO page pinning (kvm guest initialization)
 - fallocating a HugeTLB page (database initialization)

padata is a general mechanism for parallel work and so seems natural for this
functionality[2], but now it can only manage a series of small, ordered jobs.

The coming RFC will bring enhancements to split up a large job among a set of
helper threads according to the user's wishes, load balance the work between
them, set concurrency limits to control the overall number of helpers in the
system and per NUMA node, and run extra helper threads beyond the first at a
low priority level so as not to disturb other activity on the system for the
sake of an optimization.  (While extra helpers are run at low priority for most
of the job, their priority is raised one by one at job end to match the
caller's to avoid starvation on a busy system.)

The existing padata interfaces and features will remain, but serialization
becomes optional because these sorts of jobs don't need it.

The advantage to enhancing padata rather than having the multithreading stand
alone is that there would be one central place in the kernel to manage the
number of helper threads that run at any given time.  A machine's idle CPU
resources can be harnessed yet controlled (the low priority idea) to provide
the right amount of multithreading for the system.

Here's a work-in-progress branch with some of this already done in the last
five patches.

    git://oss.oracle.com/git/linux-dmjordan.git padata-mt-wip
    https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-wip

Thoughts?  Questions?

Thanks.

Daniel

[0] https://lore.kernel.org/linux-crypto/?q=s%3Apadata+d%3A20190101..
[1] https://lore.kernel.org/lkml/20181105165558.11698-1-daniel.m.jordan@oracle.com/
[2] https://lore.kernel.org/lkml/20181107103554.GL9781@hirez.programming.kicks-ass.net/
