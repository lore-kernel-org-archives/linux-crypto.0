Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CAAC4708F
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 11:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52F0C613CD
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 11:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhE2LFg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 May 2021 07:05:36 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2101 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhE2LFO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 May 2021 07:05:14 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FsdpW1r0YzWpxn;
        Sat, 29 May 2021 18:58:59 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 19:03:28 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 19:03:26 +0800
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
Subject: [PATCH v2 2/4] kgdb: Fix spelling mistakes
Date:   Sat, 29 May 2021 19:03:03 +0800
Message-ID: <20210529110305.9446-3-thunder.leizhen@huawei.com>
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
initalization ==> initialization
detatch ==> detach
represntation ==> representation
hexidecimal ==> hexadecimal
delimeter ==> delimiter
architecure ==> architecture

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/linux/kgdb.h           | 8 ++++----
 kernel/debug/debug_core.c      | 2 +-
 kernel/debug/kdb/kdb_main.c    | 8 ++++----
 kernel/debug/kdb/kdb_private.h | 2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 392a3670944c..258cdde8d356 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -105,9 +105,9 @@ extern int dbg_set_reg(int regno, void *mem, struct pt_regs *regs);
  */
 
 /**
- *	kgdb_arch_init - Perform any architecture specific initalization.
+ *	kgdb_arch_init - Perform any architecture specific initialization.
  *
- *	This function will handle the initalization of any architecture
+ *	This function will handle the initialization of any architecture
  *	specific callbacks.
  */
 extern int kgdb_arch_init(void);
@@ -229,9 +229,9 @@ extern int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt);
 extern int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt);
 
 /**
- *	kgdb_arch_late - Perform any architecture specific initalization.
+ *	kgdb_arch_late - Perform any architecture specific initialization.
  *
- *	This function will handle the late initalization of any
+ *	This function will handle the late initialization of any
  *	architecture specific callbacks.  This is an optional function for
  *	handling things like late initialization of hw breakpoints.  The
  *	default implementation does nothing.
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 4708aec492df..a1f26766eb90 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -1032,7 +1032,7 @@ dbg_notify_reboot(struct notifier_block *this, unsigned long code, void *x)
 	/*
 	 * Take the following action on reboot notify depending on value:
 	 *    1 == Enter debugger
-	 *    0 == [the default] detatch debug client
+	 *    0 == [the default] detach debug client
 	 *   -1 == Do nothing... and use this until the board resets
 	 */
 	switch (kgdbreboot) {
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 622410c45da1..d8ee5647b732 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -253,7 +253,7 @@ static char *kdballocenv(size_t bytes)
  * Parameters:
  *	match	A character string representing a numeric value
  * Outputs:
- *	*value  the unsigned long represntation of the env variable 'match'
+ *	*value  the unsigned long representation of the env variable 'match'
  * Returns:
  *	Zero on success, a kdb diagnostic on failure.
  */
@@ -356,7 +356,7 @@ static void kdb_printenv(void)
  * Parameters:
  *	arg	A character string representing a numeric value
  * Outputs:
- *	*value  the unsigned long represntation of arg.
+ *	*value  the unsigned long representation of arg.
  * Returns:
  *	Zero on success, a kdb diagnostic on failure.
  */
@@ -470,7 +470,7 @@ static int kdb_check_regs(void)
  *	symbol name, and offset to the caller.
  *
  *	The argument may consist of a numeric value (decimal or
- *	hexidecimal), a symbol name, a register name (preceded by the
+ *	hexadecimal), a symbol name, a register name (preceded by the
  *	percent sign), an environment variable with a numeric value
  *	(preceded by a dollar sign) or a simple arithmetic expression
  *	consisting of a symbol name, +/-, and a numeric constant value
@@ -894,7 +894,7 @@ static void parse_grep(const char *str)
  *	Limited to 20 tokens.
  *
  *	Real rudimentary tokenization. Basically only whitespace
- *	is considered a token delimeter (but special consideration
+ *	is considered a token delimiter (but special consideration
  *	is taken of the '=' sign as used by the 'set' command).
  *
  *	The algorithm used to tokenize the input string relies on
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index ccbed9089808..170c69aedebb 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -64,7 +64,7 @@
 
 /*
  * KDB_MAXBPT describes the total number of breakpoints
- * supported by this architecure.
+ * supported by this architecture.
  */
 #define KDB_MAXBPT	16
 
-- 
2.25.1


