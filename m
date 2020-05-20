Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB917C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 18:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A30D2206C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 18:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k7X5PZyD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgETS3g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 14:29:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57820 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETS3f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 14:29:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KIHIMa176596;
        Wed, 20 May 2020 18:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=nN6DbGwF8FnkPi4tkPEPNI6ezoScQhlz0u39zLEZexY=;
 b=k7X5PZyDCEvcOKbFcm1+WBoe31bPk0AUe7csxpHau/kt1u8OuI3cZ3719/Faaq8TGZDe
 a7DlcYbdJbxeAXv+mzP5oR94p6M909+YfUSpUySH0UtKxOOm970grYk/Dqu+hRijmcdX
 qlbOMrVnDDwByiWf2BHSOtfvj1Kk9SpIMioqoT2waKlPssRdWj/wN79mqRtHeqA1ZC2p
 vraFINUmezkjw/pddUoJ2e6o+mY48/Xl4nqxPTPhMSpqhNeLEdsTagu/EYgW87bWB0FG
 1inxzUGkTGXLHbsPHxHsGKpfxekYMdCxGoj6OFCf/f8yFUl/cfqcBi4Jx5KWVa7gGZfN FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127krcrqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 18:29:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KICTfd099424;
        Wed, 20 May 2020 18:27:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gm7hpgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 18:27:03 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KIQsn7016354;
        Wed, 20 May 2020 18:26:55 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 11:26:54 -0700
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
        Robert Elliott <elliott@hpe.com>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-crypto@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 1/7] padata: remove exit routine
Date:   Wed, 20 May 2020 14:26:39 -0400
Message-Id: <20200520182645.1658949-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520182645.1658949-1-daniel.m.jordan@oracle.com>
References: <20200520182645.1658949-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=2
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=2 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200148
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
index a6afa12fb75ee..835919c745266 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1072,10 +1072,4 @@ static __init int padata_driver_init(void)
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

