Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A451C47257
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 20:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3561720836
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 20:12:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jpQ5KXL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgD3UMZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 16:12:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59106 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbgD3UMY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 16:12:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UK9LwW022271;
        Thu, 30 Apr 2020 20:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=BK9ctXRrIpRgGO6ZKhxMQ6dCR5vDweThxUdS7159PCM=;
 b=jpQ5KXL7fHt/Y5npAsmAs/QsQ+pjs4ePHIf/dZrXUuCAui+XQSMhvn8iHskTMt4CCVIh
 EtEY5b+bLXik8SQ6sbK1t1R6nEqRSOxjNt1WaB1s+idAtx7iWLLifU2FnX47a/ySMunb
 PZ/BeOZd5UjTZ3qHnOQsCpw9j8RpOF2u4f6ngFeyMbAQvjKBC/d6camCMcTNAzYjD2eV
 KU6Vk6TSix5hAu9wsw6xCb4hLXaEl3l+34NDB8pT00gp/lfTCURkqFaGIU6IfUoCJ42I
 RsGbY/W5gwxJuh28ppKkjDFRuMs3WlDL68KGmBLFshrcK1PcypS/wOQWIFMmjpiqaCWL Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30p01p45a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 20:11:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UK7PdW095893;
        Thu, 30 Apr 2020 20:11:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30qtjy23ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 20:11:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UKBZBd024024;
        Thu, 30 Apr 2020 20:11:35 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 13:11:35 -0700
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
Subject: [PATCH 2/7] padata: initialize earlier
Date:   Thu, 30 Apr 2020 16:11:20 -0400
Message-Id: <20200430201125.532129-3-daniel.m.jordan@oracle.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=2 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300150
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

padata will soon initialize the system's struct pages in parallel, so it
needs to be ready by page_alloc_init_late().

The error return from padata_driver_init() triggers an initcall warning,
so add a warning to padata_init() to avoid silent failure.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 include/linux/padata.h |  6 ++++++
 init/main.c            |  2 ++
 kernel/padata.c        | 17 ++++++++---------
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index a0d8b41850b25..476ecfa41f363 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -164,6 +164,12 @@ struct padata_instance {
 #define	PADATA_INVALID	4
 };
 
+#ifdef CONFIG_PADATA
+extern void __init padata_init(void);
+#else
+static inline void __init padata_init(void) {}
+#endif
+
 extern struct padata_instance *padata_alloc_possible(const char *name);
 extern void padata_free(struct padata_instance *pinst);
 extern struct padata_shell *padata_alloc_shell(struct padata_instance *pinst);
diff --git a/init/main.c b/init/main.c
index ee4947af823f3..5451a80e43016 100644
--- a/init/main.c
+++ b/init/main.c
@@ -94,6 +94,7 @@
 #include <linux/rodata_test.h>
 #include <linux/jump_label.h>
 #include <linux/mem_encrypt.h>
+#include <linux/padata.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -1438,6 +1439,7 @@ static noinline void __init kernel_init_freeable(void)
 	smp_init();
 	sched_init_smp();
 
+	padata_init();
 	page_alloc_init_late();
 	/* Initialize page ext after all struct pages are initialized. */
 	page_ext_init();
diff --git a/kernel/padata.c b/kernel/padata.c
index 36a8e98741bb3..b05cd30f8905b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/rcupdate.h>
-#include <linux/module.h>
 
 #define MAX_OBJ_NUM 1000
 
@@ -1049,26 +1048,26 @@ void padata_free_shell(struct padata_shell *ps)
 }
 EXPORT_SYMBOL(padata_free_shell);
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-static __init int padata_driver_init(void)
+void __init padata_init(void)
 {
+#ifdef CONFIG_HOTPLUG_CPU
 	int ret;
 
 	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "padata:online",
 				      padata_cpu_online, NULL);
 	if (ret < 0)
-		return ret;
+		goto err;
 	hp_online = ret;
 
 	ret = cpuhp_setup_state_multi(CPUHP_PADATA_DEAD, "padata:dead",
 				      NULL, padata_cpu_dead);
 	if (ret < 0) {
 		cpuhp_remove_multi_state(hp_online);
-		return ret;
+		goto err;
 	}
-	return 0;
-}
-module_init(padata_driver_init);
 
+	return;
+err:
+	pr_warn("padata: initialization failed\n");
 #endif
+}
-- 
2.26.2

