Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD31FC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9FD5207DE
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="ZaXKB2Ee"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgHUNo2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 09:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbgHUNoB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 09:44:01 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196FCC061575
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 06:43:52 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t2so1675487wma.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 06:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=thgOsxp+Xq4BrFvbMKlBsMkOaotb5Mf5M65feuQsl1g=;
        b=ZaXKB2Ee5pnvOaTgPCoImaXNsyzLEyL/uH4YSjvQdVRqR/LP/b/8PbtH/p9K4OqW+a
         OEE2kcrRHdBjF+37oiKKK0M0nGhT9NQ03ouOKjEmoBcy2BZ9Ew211g4axDinefhqId/J
         74kVORgBW/bAFu0gdjWpR6VNhePUHT7tLankAGdLqExf70vJlInguFwq75pRtpxqdIul
         H+tZBFRiLeOGnt9L/bbXVRr158tG1vRJLH+/xoPUowCRg9DbNw5dh6d5d0yBROyGDxCl
         5P8FuRyMg8GQFxtZoKo6PYmlH/W/TXejuSQGtoGO31/XqksvAGm/CaBCyiKFMpamJI16
         L+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=thgOsxp+Xq4BrFvbMKlBsMkOaotb5Mf5M65feuQsl1g=;
        b=MYnwEHv/qvKYtaj2BDVDd//G3nlmHI/E1tiCFoa+rV147vOJes0M7CyfuECcj4RntQ
         MRr+/XrotytugDxdbH6l9Q7bKHnpAMAX0H4G1JmPHHaryIVkNw+Lh3JmOkK/AFaoECHq
         piix4hZcE3TzCOu8mk+iSFnff2YM8Out+iHRKHYLoczh0n1tTfBVcQNYAct3IiB+DoCT
         +F0dGmkgjODMw2+kOsYpPxSh5mDIugRD++gbojfEHeMQOU7bM459MkBPrMfnheH5DKhQ
         +VtLUjXySQ8Ra4Rkq6LsPfJsYbscMi2SeeuE+z2zN5CrHr/vODTREZUxQTv5L98DefyB
         NFSA==
X-Gm-Message-State: AOAM5324u8lNhnAKxdVFtT4v2F1oavbR6RCpWEbd+9obvBBLCz8H9ZbI
        qm8xUl49UztAGUz9uOmN/989GQ==
X-Google-Smtp-Source: ABdhPJy6RyED0f8sBL3O38VjQ0vstePlzROZmBceof4nYfVmuCSHrbvQw8vlHLwOfXjNDzBM8AKf/Q==
X-Received: by 2002:a1c:1904:: with SMTP id 4mr3255089wmz.119.1598017430786;
        Fri, 21 Aug 2020 06:43:50 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id 202sm5971179wmb.10.2020.08.21.06.43.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Aug 2020 06:43:50 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 07/18] crypto: sun8i-ce: handle endianness of t_common_ctl
Date:   Fri, 21 Aug 2020 13:43:24 +0000
Message-Id: <1598017415-39059-8-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598017415-39059-1-git-send-email-clabbe@baylibre.com>
References: <1598017415-39059-1-git-send-email-clabbe@baylibre.com>
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
index 138759dc8190..08ed1ca12baf 100644
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

