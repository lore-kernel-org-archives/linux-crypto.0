Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7419EC47082
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 11:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 562CC611AB
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 11:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhE2LFZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 May 2021 07:05:25 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2536 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhE2LFI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 May 2021 07:05:08 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fsdrc52VhzYrY7;
        Sat, 29 May 2021 19:00:48 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 19:03:26 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 19:03:25 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Christoph Hellwig <hch@lst.de>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Eric Biederman <ebiederm@xmission.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        "Steffen Klassert" <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        kgdb-bugreport <kgdb-bugreport@lists.sourceforge.net>,
        kexec <kexec@lists.infradead.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 1/4] kprobes: Fix spelling mistakes
Date:   Sat, 29 May 2021 19:03:02 +0800
Message-ID: <20210529110305.9446-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210529110305.9446-1-thunder.leizhen@huawei.com>
References: <20210529110305.9446-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix some spelling mistakes in comments:
decrese ==> decrease
immmediately ==> immediately

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/linux/freelist.h | 2 +-
 kernel/kprobes.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/freelist.h b/include/linux/freelist.h
index fc1842b96469..1811c1f3f8cb 100644
--- a/include/linux/freelist.h
+++ b/include/linux/freelist.h
@@ -39,7 +39,7 @@ static inline void __freelist_add(struct freelist_node *node, struct freelist_he
 	 * and a refcount increment of a node in try_get, then back up to
 	 * something non-zero, then the refcount increment is done by the other
 	 * thread) -- so if the CAS to add the node to the actual list fails,
-	 * decrese the refcount and leave the add operation to the next thread
+	 * decrease the refcount and leave the add operation to the next thread
 	 * who puts the refcount back to zero (which could be us, hence the
 	 * loop).
 	 */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 8c0a6fdef771..d4156082d5a5 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -641,7 +641,7 @@ void wait_for_kprobe_optimizer(void)
 	while (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list)) {
 		mutex_unlock(&kprobe_mutex);
 
-		/* this will also make optimizing_work execute immmediately */
+		/* this will also make optimizing_work execute immediately */
 		flush_delayed_work(&optimizing_work);
 		/* @optimizing_work might not have been queued yet, relax */
 		cpu_relax();
-- 
2.25.1


