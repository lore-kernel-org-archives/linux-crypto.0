Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F56C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Oct 2022 18:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiJMSqa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Oct 2022 14:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiJMSqP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2022 14:46:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6234190E6A
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 11:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665686476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aO9uwyAWNrITIE0HcaM8sZnAKHxlA4eUnkHhusC4UKE=;
        b=HUAZBmVZdC5JKhxZJiN2OvTGJyteki3L6JkJ0BZ6KKo/i+Jnvp1EApRGP+SMMY4szhMMJb
        quwQzWDK7nnbLQ1Z+3hHi4F0yApuLJJW59Dd4w23yRwtke4AUYC3K99S5FZsTiY36PZ71r
        kDYhzkm6lCCiRg6HvYqkZf8QS8KF4+Q=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-151-C_euQGe4MK6awbdrlhA1RA-1; Thu, 13 Oct 2022 14:41:15 -0400
X-MC-Unique: C_euQGe4MK6awbdrlhA1RA-1
Received: by mail-oi1-f199.google.com with SMTP id a14-20020a05680802ce00b00354516db947so1099986oid.10
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 11:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aO9uwyAWNrITIE0HcaM8sZnAKHxlA4eUnkHhusC4UKE=;
        b=2kMvjCnwqFgnWP4xTxZxZNAF8js6eOOYBtjSTZ9uITpMYiGqGIbCp7u1MkRG6o6Kxm
         eTVNgLvMVhqKvtCyDuUSXWQ00GRw3+aPr4BoXfdiCW2SIr86TPIUcg/vU5BXKDEcyBO7
         /VKqipladJKsJpPCWdssIY05pfJ59cbTDlear5xaxAjKqiG2J7v8OdDvf2BUpgh3Ujkr
         R3j0rtPT5uZuhZFu4RCL9SCOhhBqN7OQYf8XBbGuDckevIBL+u7svEuHwMndkUN80hRk
         mDIEbJbGX+2J+EvD1ndXzhBmDZQ3+uCXR8TCpyJKcefnbm4smdO7KALD6Z8ZtKeTW5JW
         BGpw==
X-Gm-Message-State: ACrzQf3gYb7XzM7CHUUhuHE9ryY7DC/CikBiJeDqPPPjK3jrFrKgCiaj
        BWstmi2q7y6ODzz4f5WuAGrlCceeavxqk2pXn4hAXEhxnSEHzmLfOrHSeisO9Yi+v75fwuVdNd9
        FgIiTQWpoVuRyccJQx8x6eKe2
X-Received: by 2002:a05:6870:596:b0:12d:91cd:cf36 with SMTP id m22-20020a056870059600b0012d91cdcf36mr6446059oap.84.1665686474649;
        Thu, 13 Oct 2022 11:41:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM52k3vKtIVGL+BfBIsY/ib9UZWiX3f2GV5v2CeLaUkMNUjAO0cLO7Cc3TLwdOlxaDtAQIvz/Q==
X-Received: by 2002:a05:6870:596:b0:12d:91cd:cf36 with SMTP id m22-20020a056870059600b0012d91cdcf36mr6446050oap.84.1665686474448;
        Thu, 13 Oct 2022 11:41:14 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a801:9473:d360:c737:7c9c:d52b])
        by smtp.gmail.com with ESMTPSA id v13-20020a05683024ad00b006618ad77a63sm244521ots.74.2022.10.13.11.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 11:41:14 -0700 (PDT)
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
Subject: [PATCH v2 4/4] crypto/pcrypt: Do not use isolated CPUs for callback
Date:   Thu, 13 Oct 2022 15:40:29 -0300
Message-Id: <20221013184028.129486-5-leobras@redhat.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013184028.129486-1-leobras@redhat.com>
References: <20221013184028.129486-1-leobras@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently pcrypt_aead_init_tfm() will pick callback cpus (ctx->cb_cpu)
from any online cpus. Later padata_reorder() will queue_work_on() the
chosen cb_cpu.

This is undesired if the chosen cb_cpu is listed as isolated (i.e. using
isolcpus=... or nohz_full=... kernel parameters), since the work queued
will interfere with the workload on the isolated cpu.

Make sure isolated cpus are not used for pcrypt.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 crypto/pcrypt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 9d10b846ccf73..0162629a03957 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/cpu.h>
 #include <crypto/pcrypt.h>
+#include <linux/sched/isolation.h>
 
 static struct padata_instance *pencrypt;
 static struct padata_instance *pdecrypt;
@@ -175,13 +176,15 @@ static int pcrypt_aead_init_tfm(struct crypto_aead *tfm)
 	struct pcrypt_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_aead *cipher;
+	const cpumask_t *hk_wq = housekeeping_cpumask(HK_TYPE_WQ);
 
 	cpu_index = (unsigned int)atomic_inc_return(&ictx->tfm_count) %
-		    cpumask_weight(cpu_online_mask);
+		    cpumask_weight_and(hk_wq, cpu_online_mask);
 
-	ctx->cb_cpu = cpumask_first(cpu_online_mask);
+	ctx->cb_cpu = cpumask_first_and(hk_wq, cpu_online_mask);
 	for (cpu = 0; cpu < cpu_index; cpu++)
-		ctx->cb_cpu = cpumask_next(ctx->cb_cpu, cpu_online_mask);
+		ctx->cb_cpu = cpumask_next_and(ctx->cb_cpu, hk_wq,
+					       cpu_online_mask);
 
 	cipher = crypto_spawn_aead(&ictx->spawn);
 
-- 
2.38.0

