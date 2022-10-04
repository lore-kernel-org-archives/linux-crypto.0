Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD32C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Oct 2022 06:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiJDG0J (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Oct 2022 02:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJDG0I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2022 02:26:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC7621263
        for <linux-crypto@vger.kernel.org>; Mon,  3 Oct 2022 23:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664864761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ATSwXcQokmwIH/YgclkGZO8BhI6NMe9jQwAsKeX4mSE=;
        b=Mt3fgTSWwj16MGPYw/yDOD5e1np2FQuRQfqK9mXJlFng2qz5oXrHRg/xrXYNibwBOpxnFe
        zat/wj+80rZgJJsPgjzYG6xJAUcTzMIamGc1pkccm1JqSIFXK3ncK359zBHTDDgjoAqX4M
        uuoI8U+LeoptYj+ZiC0wt3eX/5OL5Z8=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-197-t0-opXG2NHia_AFfBBa0MQ-1; Tue, 04 Oct 2022 02:26:00 -0400
X-MC-Unique: t0-opXG2NHia_AFfBBa0MQ-1
Received: by mail-vk1-f199.google.com with SMTP id z5-20020a056122148500b003a2e0028d97so2850502vkp.22
        for <linux-crypto@vger.kernel.org>; Mon, 03 Oct 2022 23:26:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ATSwXcQokmwIH/YgclkGZO8BhI6NMe9jQwAsKeX4mSE=;
        b=5zeZvLygbPmikRuZDgzsnotO9uC1QwJEbMnoJaj6ldqNPWAra5Y9+HgQ+ytK/0U5S+
         Ffgjqzdvfpi4/Ru1NWGrS+TJcfLadVT1ib8imN1w/4McXAo0J93h7Iy/CYzGaeWhxiiK
         8SXtD5EdV1VieReKEyCCR9HmoGfR4WahN1pyH+0Oguvf+vinMB/xMUEwPhcmOddTHYeS
         ZUeNa+2din69dd0buKCpeQgzf5tMCup7Ge9kZqjch5WEv36UqbX8TsB8eqjdZI2a1uji
         Qz3TLgHoAnKvsAJ35KkkJff2DSwDAtfAbkJlIk2dwn02Q0k5/tCd6T3zgi/WMzMHf7aC
         iRMQ==
X-Gm-Message-State: ACrzQf0tU4aVfrX44/lk5Maq1ArYOsHzSAKsEzdcI0peCxli5HJcjZQD
        qND8P/jXmJqtfpT8NCSDXucb3tCCNV/kuvyft9a30V3UaYFtsMHAi3U7+4WZaPQQtmEZIUSpdaE
        l4tf3uV1oQ5rzVho9nJU1rbUl
X-Received: by 2002:a1f:ac16:0:b0:3a3:258:3442 with SMTP id v22-20020a1fac16000000b003a302583442mr10220608vke.2.1664864759822;
        Mon, 03 Oct 2022 23:25:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4XbdLYaoQUUg8Mgb6U0GIeBHnweooSVWMg0hl/x+bHpaNodSp5SoFkdNa6MKUGg9K0/GQYpA==
X-Received: by 2002:a1f:ac16:0:b0:3a3:258:3442 with SMTP id v22-20020a1fac16000000b003a302583442mr10220605vke.2.1664864759648;
        Mon, 03 Oct 2022 23:25:59 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a801:6b4a:8652:f462:a76a:cc3a])
        by smtp.gmail.com with ESMTPSA id r196-20020a1fc1cd000000b003aa8c4ebfb8sm2521168vkf.50.2022.10.03.23.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 23:25:58 -0700 (PDT)
From:   Leonardo Bras <leobras@redhat.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, mtosatti@redhat.com
Cc:     Leonardo Bras <leobras@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/1] crypto/pcrypt: Do not use isolated CPUs for callback
Date:   Tue,  4 Oct 2022 03:25:37 -0300
Message-Id: <20221004062536.280712-1-leobras@redhat.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently pcrypt_aead_init_tfm() will pick callback cpus (ctx->cb_cpu)
from any online cpus. Later padata_reorder() will queue_work_on() the
chosen cb_cpu.

This is undesired if the chosen cb_cpu is listed as isolated (i.e. using
isolcpus=... kernel parameter), since the work queued will interfere with
the workload on the isolated cpu.

Make sure isolated cpus are not used for pcrypt.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 crypto/pcrypt.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 9d10b846ccf73..9017d08c91a8d 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/cpu.h>
 #include <crypto/pcrypt.h>
+#include <linux/sched/isolation.h>
 
 static struct padata_instance *pencrypt;
 static struct padata_instance *pdecrypt;
@@ -175,13 +176,16 @@ static int pcrypt_aead_init_tfm(struct crypto_aead *tfm)
 	struct pcrypt_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_aead *cipher;
+	struct cpumask non_isolated;
+
+	cpumask_and(&non_isolated, cpu_online_mask, housekeeping_cpumask(HK_TYPE_DOMAIN));
 
 	cpu_index = (unsigned int)atomic_inc_return(&ictx->tfm_count) %
-		    cpumask_weight(cpu_online_mask);
+		    cpumask_weight(&non_isolated);
 
-	ctx->cb_cpu = cpumask_first(cpu_online_mask);
+	ctx->cb_cpu = cpumask_first(&non_isolated);
 	for (cpu = 0; cpu < cpu_index; cpu++)
-		ctx->cb_cpu = cpumask_next(ctx->cb_cpu, cpu_online_mask);
+		ctx->cb_cpu = cpumask_next(ctx->cb_cpu, &non_isolated);
 
 	cipher = crypto_spawn_aead(&ictx->spawn);
 
-- 
2.37.3

