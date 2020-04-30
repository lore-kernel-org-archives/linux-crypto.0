Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C14C47254
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 20:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9D61207DD
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 20:14:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VRTPDgb0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgD3UOR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 16:14:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42902 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727869AbgD3UOM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 16:14:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UKD04K087856;
        Thu, 30 Apr 2020 20:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=YSH968m2chokijP0CuyV65vxstwMSwaqbt+J6W/LPzI=;
 b=VRTPDgb0IFZuQzrky+2E54YeGLLLnR1f4e9GyhB9JqdAf7twWjttXYbbeyY4flRfQpC4
 u4q3RxVxuD+rX051J800fVwQ94csDIGGmC1wxQLHPeONDPRQzdaWyRTTSuhMIS8NFkzR
 pBCmDiTOP3+NTNuPd1jpXkN26darea6/KV2P5d9zJ5ZycXk0L5S5QHQe/AC8GQyJaiOC
 JvSXtWOsEGKrtc52JBg1qCI2XZozheAyfyuTexSs+45iJAK4Nwy11amhFs1oADwFV6o6
 1fj/Stn3srd4dk0qSWRHvffjTJf/hZCh6J4jJdwWk5rrhlZ75dBWLFNZkMxsyEdEENKS Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucgdkwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 20:13:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UK7RZQ096205;
        Thu, 30 Apr 2020 20:11:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30qtjy23km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 20:11:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UKBXrf002202;
        Thu, 30 Apr 2020 20:11:33 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 13:11:33 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
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
        linux-crypto@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 1/7] padata: remove exit routine
Date:   Thu, 30 Apr 2020 16:11:19 -0400
Message-Id: <20200430201125.532129-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=2 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300151
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

padata_driver_exit() is unnecessary because padata isn't built as a
module and doesn't exit.

padata's init routine will soon allocate memory, so getting rid of the
exit function now avoids pointless code to free it.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/padata.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 72777c10bb9cb..36a8e98741bb3 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1071,10 +1071,4 @@ static __init int padata_driver_init(void)
 }
 module_init(padata_driver_init);
 
-static __exit void padata_driver_exit(void)
-{
-	cpuhp_remove_multi_state(CPUHP_PADATA_DEAD);
-	cpuhp_remove_multi_state(hp_online);
-}
-module_exit(padata_driver_exit);
 #endif
-- 
2.26.2

