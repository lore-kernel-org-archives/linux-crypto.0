Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56869C43459
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32D3A207DD
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="F6j3zpRF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbgGUTH7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 15:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730409AbgGUTGv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 15:06:51 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4AAC0619E2
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f2so22193879wrp.7
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yXxrOq7y/XEqSAypbjoNDxKbsFCR1eLBq/95DK2gDRg=;
        b=F6j3zpRFRwLd3voWeaAm0+Ovh+KLFZDnR4gK6rXggWeAhmbzSJNwyAkBLadtPTH2GZ
         w6zsuSPftgiwG1OTv37y0vTJx38A3NqqhF8kIkPYqdCK9KbT06moo3gWs04k8YPkYh5c
         5/s0iEt0gvPAaa3mQezBlbnbk2LLTr5Rt0yyWaQxGXf3fHzHPHvYpe+mFlIYCxZXHhg0
         i6hVaJ5s8J2nKPNbuWKNTSlpCDzui+/LxE5a2EfcA7SQag0A5oSN15Q5oU+6mxBFzYl3
         LFYgOEkTCgnjbFGcHzCtc7BoBx857VGbahZtena4JykDu8sCqA/4FVJDvfdH88gXUuqk
         oEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yXxrOq7y/XEqSAypbjoNDxKbsFCR1eLBq/95DK2gDRg=;
        b=qzADFOXR4dLceiVkgFcq5qchS+LCpU8xRyFio4dOZq32+nZi5Az5rwS7z7QMn+igfz
         Q1azTNzGZp2cXevpQRjm/JbUBNp2cguQnjBFnqIfCqF0u6vLfmbdeWfk1fKx1ixpgRe0
         MLSJZxo3ggNzPL4qLS+qzP3QiTIFXaHOJeSf4JG/CdkOeD49CxwSJYLL8Be2bnM3rrH3
         sUmqJXXoDkDEvnq+eJjllyy0im/sUE7LnmJY9d4hqHq3xVIVouHjFaoTc2Z6eKcLObHj
         NpXDFp5yVoniVzrNGwGHOOkpo6mA1+rEVr4Zh8n+C14FPn6q3hUuDPNopcHHydxSlx2P
         SvnQ==
X-Gm-Message-State: AOAM531P5AVlKBbBzid45MQPV7De08UdYstOtBl2o/4i9o8U4Yzn4BWK
        F3pm77ibJdVhxSL0m/8C3qEzoQ==
X-Google-Smtp-Source: ABdhPJzDZYwaYL1Q2tq5nD548uq+rJJ8ORknySyeXBGJa8uE43WEF8xXDiqBx6Tw7rHEI9T5RiSmVQ==
X-Received: by 2002:adf:f18c:: with SMTP id h12mr26735428wro.375.1595358408498;
        Tue, 21 Jul 2020 12:06:48 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id s14sm25794848wrv.24.2020.07.21.12.06.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 12:06:47 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 07/17] crypto: sun8i-ce: handle endianness of t_common_ctl
Date:   Tue, 21 Jul 2020 19:06:21 +0000
Message-Id: <1595358391-34525-8-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

t_common_ctl is LE32 so we need to convert its value before using it.
This value is only used on H6 (ignored on other SoCs) and not handling
the endianness cause failure on xRNG/hashes operations on H6 when running BE.

Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 0bf8f29c5ae8..0b47a51e1cfc 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -120,7 +120,10 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 	/* Be sure all data is written before enabling the task */
 	wmb();
 
-	v = 1 | (ce->chanlist[flow].tl->t_common_ctl & 0x7F) << 8;
+	/* Only H6 needs to write a part of t_common_ctl along with "1", but since it is ignored
+	 * on older SoCs, we have no reason to complicate things.
+	 */
+	v = 1 | ((le32_to_cpu(ce->chanlist[flow].tl->t_common_ctl) & 0x7F) << 8);
 	writel(v, ce->base + CE_TLR);
 	mutex_unlock(&ce->mlock);
 
-- 
2.26.2

