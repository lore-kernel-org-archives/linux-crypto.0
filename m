Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A207C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Oct 2022 18:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJMSuf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Oct 2022 14:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiJMSts (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2022 14:49:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5B053A71
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 11:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665686830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6JjDK3twE+pSMUDp2i+4iId8FgNp8eHanR+PXksbbJA=;
        b=XezV84IQwFdLgc3LcVMnln+jVowTxWUPXNQKJouJHLMux9RxmUAxnQPhSjPVSkXI1yWZhJ
        qPUJO0cn/aSIVI9Qw9dVUPHQ2v6k0k4yU078ZMP1JU3uC+kpFWy6gduhvr+Ff6QqybzSHU
        UVhYJH32iG9Mgl9KNtLVbKFemGebx6o=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-hHQvZLGiMwGiaNKl4ySeSw-1; Thu, 13 Oct 2022 14:41:03 -0400
X-MC-Unique: hHQvZLGiMwGiaNKl4ySeSw-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-13631a68551so1493168fac.22
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 11:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6JjDK3twE+pSMUDp2i+4iId8FgNp8eHanR+PXksbbJA=;
        b=vojy54uXQR8HgmKtu2ypO/SPE9L5OOSfszcC/n9f0pS5ZVcD00vy5WbsPb3UfKOp4e
         TeI+c+z6XkzStLVCsGXmxsFYDM1ntv4BaH4GdbhZzE1rlaOKLk4KtfvsHz3beDd+UUph
         pkP1iLy2VsFzjgP3SRXY3WqPqT7iJAM1/rop9blUdICXH+xiukvvdwDURFsDY8evGyI7
         2Ki1RK9RalE/9dVlp7uBtNgbHCVMzZImAEZnwIDLpW2vKrnwnNYL99vd5q/MynW5eCiy
         cM8ZklOONh+Zylng0p3Y7VSK6XeKWfQfqIhcdV/uY6Ka+wKGFJYO7pNb9qni4VxypTW1
         fWPA==
X-Gm-Message-State: ACrzQf00ftZP2uW57bAo8mJOkZaPxoJG1NWC8t0yxdHfEp5PIVQbO3Ej
        nSEXRzTC6vcUQQlXxrrgUPKYczGwrsZV+UPvZupKLx32hIxguzZ5SIIw7oaWyYJ2U9QiNt6TgMk
        FKMfLGjZQ/Rqfnm2TkoyHzSuO
X-Received: by 2002:a9d:2d81:0:b0:658:accf:2adf with SMTP id g1-20020a9d2d81000000b00658accf2adfmr688446otb.334.1665686462117;
        Thu, 13 Oct 2022 11:41:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7TiIyrwXPFplLjLvX4+bEb60ttonBBZ0lr/zrMURi69WbZIZ4juK0apaIljHzLOixeLkyFDw==
X-Received: by 2002:a9d:2d81:0:b0:658:accf:2adf with SMTP id g1-20020a9d2d81000000b00658accf2adfmr688432otb.334.1665686461891;
        Thu, 13 Oct 2022 11:41:01 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a801:9473:d360:c737:7c9c:d52b])
        by smtp.gmail.com with ESMTPSA id v13-20020a05683024ad00b006618ad77a63sm244521ots.74.2022.10.13.11.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 11:41:01 -0700 (PDT)
From:   Leonardo Bras <leobras@redhat.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/4] sched/isolation: Improve documentation
Date:   Thu, 13 Oct 2022 15:40:27 -0300
Message-Id: <20221013184028.129486-3-leobras@redhat.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013184028.129486-1-leobras@redhat.com>
References: <20221013184028.129486-1-leobras@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Improve documentation on housekeeping types and what to expect from
housekeeping functions.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 include/linux/sched/isolation.h | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 762701f295d1c..9333c28153a7a 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -7,18 +7,25 @@
 #include <linux/tick.h>
 
 enum hk_type {
-	HK_TYPE_TIMER,
-	HK_TYPE_RCU,
-	HK_TYPE_MISC,
-	HK_TYPE_SCHED,
-	HK_TYPE_TICK,
-	HK_TYPE_DOMAIN,
-	HK_TYPE_WQ,
-	HK_TYPE_MANAGED_IRQ,
-	HK_TYPE_KTHREAD,
+	HK_TYPE_TIMER,		/* Timer interrupt, watchdogs */
+	HK_TYPE_RCU,		/* RCU callbacks */
+	HK_TYPE_MISC,		/* Minor housekeeping categories */
+	HK_TYPE_SCHED,		/* Scheduling and idle load balancing */
+	HK_TYPE_TICK,		/* See isolcpus=nohz boot parameter */
+	HK_TYPE_DOMAIN,		/* See isolcpus=domain boot parameter*/
+	HK_TYPE_WQ,		/* Work Queues*/
+	HK_TYPE_MANAGED_IRQ,	/* See isolcpus=managed_irq boot parameter */
+	HK_TYPE_KTHREAD,	/* kernel threads */
 	HK_TYPE_MAX
 };
 
+/* Kernel parameters like nohz_full and isolcpus allow passing cpu numbers
+ * for disabling housekeeping types.
+ *
+ * The functions bellow work the opposite way, by referencing which cpus
+ * are able to perform the housekeeping type in parameter.
+ */
+
 #ifdef CONFIG_CPU_ISOLATION
 DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
 int housekeeping_any_cpu(enum hk_type type);
-- 
2.38.0

