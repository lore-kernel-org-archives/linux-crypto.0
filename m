Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D3EC43331
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8539206E9
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="KUVQPcny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgDCTut (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 15:50:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36337 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgDCTut (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 15:50:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id k1so507291wrm.3
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2020 12:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZwalgJuNdjnU0AH+11/7zFoA2oqP3wkRvVgbyS9b41k=;
        b=KUVQPcnyz2hl7SCVBDI+1XsXZwodz/A+BMq7RJInRs48OWppiuWfPyn3Z7e/O+9Ku+
         3HlPHApGLzvMJs+0KFmGHj/6DUC23P9I2sSJDWPkk+YFZ2Q+B78IgzzUYzFLpc+dgn8r
         PndzOOMEAbb8Kg0i01xjsBVBJ/NkY32OR8lgja1akb26BTK54snwotBHjQNvVC7GTLyh
         T8md9A3jE00qFWhh1cLuTU9IBjwacoK0WRSxwOOpWinkGE+CQypkkEAp7Zr+vFheElVz
         E7fXNgg+imGbrYqZWVqTnvq7MHOMaQ1+e19T7UUWL0wfWgjinehkX8CITwHPlCPscYeI
         iVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZwalgJuNdjnU0AH+11/7zFoA2oqP3wkRvVgbyS9b41k=;
        b=alhEly2LocHCMbTsryAh8T3tpAVY/1RWL8HlvRkhtJRmeOTV0eDwnMAq9T+MpFPK2m
         n+yT6xc6EyiOSDqgTOgnSwQA/UHL4PHvDCe64TtSGcA2Rjlje/RfT5FVlsIeTk0OAYR4
         VOK5MqqhgDM7lGHYJWPbm4gqzV4w1TxZAOsRja7nuC7ryFNKw51DDq5zlLNiWJyzPtnS
         +ecoWvhRpz7djBL3T7Bm+Kx0Jmz5Oqzr5Ld4nAJEPo0WKalQKrBu2JXem5fPIDUkNBxC
         pvVmZBvLTvMtI8qz5FJd5Wx3siI5a6bDWgsegVXT97BZWQ50Up3eSB/tAy4BckwmMzn1
         5wCw==
X-Gm-Message-State: AGi0PuZF99KD77Sa/sUPVpJ7sZg5uSD5nkrcmrLZozqt3dwQc6CJ7kcg
        qqV9Cys6cFsEZ/Jq4/WbzuDjHQ==
X-Google-Smtp-Source: APiQypJPD3CP1v4p+ZE6U2Aywvu5WeATMjzlv5PMn28lxY1pqFnQhQh7N1RgKP5cr5vCmeFo5f3YRw==
X-Received: by 2002:adf:9e08:: with SMTP id u8mr10686337wre.155.1585943448089;
        Fri, 03 Apr 2020 12:50:48 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id c17sm8102448wrp.28.2020.04.03.12.50.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 Apr 2020 12:50:47 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 1/7] crypto: rng - add missing __crypto_rng_cast to the rng header
Date:   Fri,  3 Apr 2020 19:50:32 +0000
Message-Id: <1585943438-862-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
References: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch add __crypto_rng_cast() to the rng header like other
__algo_cast functions.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 include/crypto/rng.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 8b4b844b4eef..0e140f132efe 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -198,4 +198,9 @@ static inline int crypto_rng_seedsize(struct crypto_rng *tfm)
 	return crypto_rng_alg(tfm)->seedsize;
 }
 
+static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_rng, base);
+}
+
 #endif
-- 
2.24.1

