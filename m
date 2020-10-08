Return-Path: <SRS0=kcel=DP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091DDC433E7
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 17:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D37D22200
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 17:34:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IDSyVZeF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732133AbgJHRed (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Oct 2020 13:34:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51448 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731283AbgJHRed (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Oct 2020 13:34:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098HO0GE159283;
        Thu, 8 Oct 2020 17:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=hqpugaLb9HTKxQQq/bPTvS8Ku6M1O2DR/Zz5E5a2OrE=;
 b=IDSyVZeFimRjNtzW26YNpD4HILYBcy56chG4XUbFcK486V460W5qHvMW0+1HC/8+ID9W
 BYR50s+Pb3MTRXHcrcoZSzN2O9k4k7E7iWrD+UsJsr8IfZmu0BHpS8c2I7Bt+stS/wwk
 i/7wmeHHTNVHb1y9Vbst1zAiGwhF+VRHwhgFChPdumIiRnwthBPU+P+MsBP8bQuVlm65
 xmtuImhNNq+hSV0Sm3jsvLImnT2BKfpka5BkwlX0EwoOSnBtJoRM1yDYGt7B/8YE3maz
 Y6IlsJquYNt3UImdMl84aagTTrDB7KZQGS6Vz9dDog7hiPSVIQgbsl88uStq74J8FHuG 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34x4va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 17:34:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098HOvar116310;
        Thu, 8 Oct 2020 17:32:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3410k1f09q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 17:32:26 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098HWOg0005911;
        Thu, 8 Oct 2020 17:32:24 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 10:32:23 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH] module: statically initialize init section freeing data
Date:   Thu,  8 Oct 2020 13:32:20 -0400
Message-Id: <20201008173220.923671-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1011 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080128
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Corentin hit the following workqueue warning when running with
CRYPTO_MANAGER_EXTRA_TESTS:

  WARNING: CPU: 2 PID: 147 at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
  Modules linked in: ghash_generic
  CPU: 2 PID: 147 Comm: modprobe Not tainted
      5.6.0-rc1-next-20200214-00068-g166c9264f0b1-dirty #545
  Hardware name: Pine H64 model A (DT)
  pc : __queue_work+0x3b8/0x3d0
  Call trace:
   __queue_work+0x3b8/0x3d0
   queue_work_on+0x6c/0x90
   do_init_module+0x188/0x1f0
   load_module+0x1d00/0x22b0

I wasn't able to reproduce on x86 or rpi 3b+.

This is

  WARN_ON(!list_empty(&work->entry))

from __queue_work(), and it happens because the init_free_wq work item
isn't initialized in time for a crypto test that requests the gcm
module.  Some crypto tests were recently moved earlier in boot as
explained in commit c4741b230597 ("crypto: run initcalls for generic
implementations earlier"), which went into mainline less than two weeks
before the Fixes commit.

Avoid the warning by statically initializing init_free_wq and the
corresponding llist.

Link: https://lore.kernel.org/lkml/20200217204803.GA13479@Red/
Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: sun50i-h6-pine-h64
Tested-on: imx8mn-ddr4-evk
Tested-on: sun50i-a64-bananapi-m64
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/module.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1c5cff34d9f2..8486123ffd7a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -91,8 +91,9 @@ EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
 /* Work queue for freeing init sections in success case */
-static struct work_struct init_free_wq;
-static struct llist_head init_free_list;
+static void do_free_init(struct work_struct *w);
+static DECLARE_WORK(init_free_wq, do_free_init);
+static LLIST_HEAD(init_free_list);
 
 #ifdef CONFIG_MODULES_TREE_LOOKUP
 
@@ -3579,14 +3580,6 @@ static void do_free_init(struct work_struct *w)
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

base-commit: c85fb28b6f999db9928b841f63f1beeb3074eeca
-- 
2.28.0

