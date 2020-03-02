Return-Path: <SRS0=CDDf=4T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FFFC3F2CD
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 17:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 452722146E
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 17:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QD8LDPW4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCBR0E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Mar 2020 12:26:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41248 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgCBR0E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Mar 2020 12:26:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HNPGX098653;
        Mon, 2 Mar 2020 17:25:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ljzd0Xe5Fg4CocMgwn0S+I3dakdjPxi3oE8VRnoUYlA=;
 b=QD8LDPW4X4pP3Con9UBGU9spo1eN7BgyyLl2aaHLXXLnwzk0Qx4vdqZdf8ZMWkjjTeo4
 CMAQVzOkEBd0Y6TmMKsWVwsDp/sIBjRKPv/bGoEfSx16UpOs9oB8ciCwcVYfbrb4fuBu
 Nup7nbhTzspfk2D0qhMeC6RQ9NKfLsqajXyzsd8Kw31dERKjDye+JJCOepCaM5wwd9B0
 jwPGl0IHxIRzk4b4lTHcejqlVB+6RvmGiNeFiuMLmEuRL8nBvZoFfxpYT6XFwrBotfL3
 ZVrQ0Ah/pRiH61VjRTtuDnHv95rTjENPCWER6Qq/kWauhSD4Qkz4etN7scSEcfiQCoii Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yghn2w29v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Mar 2020 17:25:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HNEF1072297;
        Mon, 2 Mar 2020 17:25:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yg1rfy3qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Mar 2020 17:25:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 022HPnkq015255;
        Mon, 2 Mar 2020 17:25:49 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Mar 2020 09:25:46 -0800
Date:   Mon, 2 Mar 2020 12:25:10 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Will Deacon <will@kernel.org>, tj@kernel.org,
        jiangshanlai@gmail.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20200302172510.fspofleipqjcdxak@ca-dmjordan1.us.oracle.com>
References: <20200217204803.GA13479@Red>
 <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
 <20200220090350.GA19858@Red>
 <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
 <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
 <20200301175351.GA11684@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301175351.GA11684@Red>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9547 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9547 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020116
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 01, 2020 at 06:53:51PM +0100, Corentin Labbe wrote:
> I tried to bisect this problem, but the result is:
...
> # first bad commit: [81ff5d2cba4f86cd850b9ee4a530cd221ee45aa3] Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
> 
> The only interesting thing I see in this MR is: "Add fuzz testing to testmgr"
> 
> But this wont help.

Hm, that merge commit has only a couple lines of powerpc build change, so maybe
there's something nondeterministic going on.

Does this fix it?  I can't verify but figure it's worth trying the simplest
explanation first, which is that the work isn't initialized by the time it's
queued.

thanks,
daniel

---8<---

Subject: [PATCH] module: statically initialize init section freeing data

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/module.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 33569a01d6e1..db0cda206167 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -88,8 +88,9 @@ EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
 /* Work queue for freeing init sections in success case */
-static struct work_struct init_free_wq;
-static struct llist_head init_free_list;
+static void do_free_init(struct work_struct *w);
+static DECLARE_WORK(init_free_wq, do_free_init);
+static LLIST_HEAD(init_free_list);
 
 #ifdef CONFIG_MODULES_TREE_LOOKUP
 
@@ -3501,14 +3502,6 @@ static void do_free_init(struct work_struct *w)
 	}
 }
 
-static int __init modules_wq_init(void)
-{
-	INIT_WORK(&init_free_wq, do_free_init);
-	init_llist_head(&init_free_list);
-	return 0;
-}
-module_init(modules_wq_init);
-
 /*
  * This is where the real work happens.
  *
-- 
2.25.1

