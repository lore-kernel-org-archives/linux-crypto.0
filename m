Return-Path: <SRS0=yTfj=C2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1749C43461
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 19:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F73E206B7
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 19:00:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="UDH2kSar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgIQTA2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 15:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgIQS7v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 14:59:51 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F490C061756
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:59:45 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s12so3171522wrw.11
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=/FQeEcWUlQDqfQ8wanTKIcTElJ0+/H0Q34PjAFqIS2E=;
        b=UDH2kSarbkBuYBTeWj3n0fqUdD9XU0XvPc+4NOngHaapEW0SOpuLQ8y2YcruoNZeEX
         svVWs1RwWe/w6VHGkXAOgYyz3Cix45a6NYx3vT6cF0+ufr8RGH7pgc/1fC9yA3KIbmZE
         MTt7xB/yrUVL+6MJpVcF2vyvi/2cOm2JzUH6JFmGAgB61p5NzL4KKCADVFcHVZh7q+UF
         ohOzgpHwsME46bLgBALQPJR3APlbQv4PT/DrXz2a7r+k3AZWUjujgKyUqrLxY2ve1zWl
         96ociw42g1nxXnxTmBpW5arpqMbDoUXiYheqCebLj3yquFlTwDkxwk7xLLnZtqD4h3cP
         N53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/FQeEcWUlQDqfQ8wanTKIcTElJ0+/H0Q34PjAFqIS2E=;
        b=iZ2RWn9u+OrWDymiyzpa9XWkr0cI6CTxvqeV59GmRHR7X2qNMpgz12OlutPpOdDKt/
         y2zGQS1YTfq4oWzWOlKDtwt8b1trN5dhIbzvdkH6GsAFGkq9l1JsSJ9papj0LsdnxYH4
         +UHaS5fP0XgJ22u/r3pcg87DebqfhEmKOA4bDf3DXuNwrVctLHZwWMvAiOTz8qnCkeA6
         lhxCxjsqOf9V7EPlsXrjGl3v1Ch2ucwWbev6M57rop/H1elLsFEVvQ9pduEPPG7n2Q6U
         G9fekzCs8TKdoHrSd3n58oQ9SeNAoSf4JxQiqFO2Q+xk+9RG62es9KipiBnhcKkkkXGG
         P2KA==
X-Gm-Message-State: AOAM530VwTywZZUfB+llcbNZhUy2lLvD5Q3A9wVO57ryOWI2GQobCsyU
        n//oaUv5vMs75vVvyha8c/Ih7g==
X-Google-Smtp-Source: ABdhPJzbVDEFcxbw/TjYhFdXwMyu3mguWYl6vvOW6/lfjbNAQgC808oX9KFWtD4HV3w00/BjD7ipww==
X-Received: by 2002:a5d:6283:: with SMTP id k3mr35007812wru.191.1600369184565;
        Thu, 17 Sep 2020 11:59:44 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id f23sm16639470wmc.3.2020.09.17.11.59.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 11:59:43 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: procfs: Removing some useless only space lines
Date:   Thu, 17 Sep 2020 18:59:36 +0000
Message-Id: <1600369176-28975-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some line got only spaces, remove them

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/proc.c b/crypto/proc.c
index 08d8c2bc7e62..12fccb9c5205 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -36,7 +36,7 @@ static void c_stop(struct seq_file *m, void *p)
 static int c_show(struct seq_file *m, void *p)
 {
 	struct crypto_alg *alg = list_entry(p, struct crypto_alg, cra_list);
-	
+
 	seq_printf(m, "name         : %s\n", alg->cra_name);
 	seq_printf(m, "driver       : %s\n", alg->cra_driver_name);
 	seq_printf(m, "module       : %s\n", module_name(alg->cra_module));
@@ -59,7 +59,7 @@ static int c_show(struct seq_file *m, void *p)
 		alg->cra_type->show(m, alg);
 		goto out;
 	}
-	
+
 	switch (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_CIPHER:
 		seq_printf(m, "type         : cipher\n");
-- 
2.26.2

