Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A797DC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Oct 2022 18:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiJMSzc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Oct 2022 14:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbiJMSzJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2022 14:55:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA263911E
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 11:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665687129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8VBqJ4dzJjbnYynK7jkYTYjysfbRi2UUuxGT40j6Ev4=;
        b=AuWNxO4PnXHsFJWtebkFuicen9P3MwQlkPgSSGsAxzGCjQpvRj0g3rO9BccYv2eaKuA6y/
        wdIQBYw/XtGrjvGV6ymfC/WfTg0dIuJMFktaQfwgsGMquNWXXR0dCb4QSyZke3PcpzH5/G
        JTdckCKNO/SG5hLB3VzbTnZK0HQoBxk=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-6-JdztKqGoN6eGBqAqvsVUoA-1; Thu, 13 Oct 2022 14:40:56 -0400
X-MC-Unique: JdztKqGoN6eGBqAqvsVUoA-1
Received: by mail-oi1-f197.google.com with SMTP id o12-20020a056808124c00b00353f308fb4bso1103227oiv.22
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 11:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8VBqJ4dzJjbnYynK7jkYTYjysfbRi2UUuxGT40j6Ev4=;
        b=uJlezDXID0I5Jj5xjHeSk1LbsHEox9E0nGFE70RPzUVmKOrnTkgxY7bb7VtK0mLjFx
         s3/kBzokei976iRIvSpOScltwZ/CeYy2uxVl9lYo6wifBlYaZJCvOvoyGnwS3rKHFRto
         +YFf0I4q9InE6CzEgUVkRfvvpBs1GnI8taHR5MZQ26rFmQfkWqxOtjNZgi05huNz8E+v
         py5IKvcRejyQ7RmHQGHvUUTck/eL+iCnA7mCEgUdW3KPSsb4EiOtCSfiMBByGK3KUD0M
         KKBlcLxg5Kmkhyv6avz6ukVXwkDwUwJMsmj5W8gqCM+xuvVo75Cd8j2NW5w68gGi7wCA
         YR3A==
X-Gm-Message-State: ACrzQf2SkP6/lCoGbA8A8z+fSO9H1ZyQh9gewX8YRmuEBvTTWfrO4XlW
        ZBhBxBqgjnu3iDSl2w0yFU8KsgODVtkPFvfyptaRT+ru1GVQDdpXM6xUnMCKHAtVaTVJR7NEhJE
        IeWA9PpFmB93Unrq1n2quP5gw
X-Received: by 2002:a05:6830:3152:b0:661:ceb9:9272 with SMTP id c18-20020a056830315200b00661ceb99272mr667820ots.149.1665686455879;
        Thu, 13 Oct 2022 11:40:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4nJIAmq9Hq+46Kh8sn9us3gulZMoSvouw/Iy6ORtvgE9Z/MyjjjsC/KzgV7OOt2CYFqnSHDA==
X-Received: by 2002:a05:6830:3152:b0:661:ceb9:9272 with SMTP id c18-20020a056830315200b00661ceb99272mr667806ots.149.1665686455653;
        Thu, 13 Oct 2022 11:40:55 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a801:9473:d360:c737:7c9c:d52b])
        by smtp.gmail.com with ESMTPSA id v13-20020a05683024ad00b006618ad77a63sm244521ots.74.2022.10.13.11.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 11:40:55 -0700 (PDT)
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
Subject: [PATCH v2 1/4] sched/isolation: Fix style issues reported by checkpatch
Date:   Thu, 13 Oct 2022 15:40:26 -0300
Message-Id: <20221013184028.129486-2-leobras@redhat.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013184028.129486-1-leobras@redhat.com>
References: <20221013184028.129486-1-leobras@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

scripts/checkpatch.pl warns about:
- extern prototypes should be avoided in .h files
- Missing or malformed SPDX-License-Identifier tag in line 1

Fix those issues to avoid extra noise.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 include/linux/sched/isolation.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 8c15abd67aed9..762701f295d1c 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_SCHED_ISOLATION_H
 #define _LINUX_SCHED_ISOLATION_H
 
@@ -20,12 +21,12 @@ enum hk_type {
 
 #ifdef CONFIG_CPU_ISOLATION
 DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
-extern int housekeeping_any_cpu(enum hk_type type);
-extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
-extern bool housekeeping_enabled(enum hk_type type);
-extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
-extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
-extern void __init housekeeping_init(void);
+int housekeeping_any_cpu(enum hk_type type);
+const struct cpumask *housekeeping_cpumask(enum hk_type type);
+bool housekeeping_enabled(enum hk_type type);
+void housekeeping_affine(struct task_struct *t, enum hk_type type);
+bool housekeeping_test_cpu(int cpu, enum hk_type type);
+void __init housekeeping_init(void);
 
 #else
 
-- 
2.38.0

