Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82725C433E2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54A55206B7
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="bnr9W94c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgIDLX7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730043AbgIDLXp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 07:23:45 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FF8C061232
        for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2020 04:10:26 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o21so5725188wmc.0
        for <linux-crypto@vger.kernel.org>; Fri, 04 Sep 2020 04:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B84TBgeETkt4nO+wKVIpW+Ds3pJrpx/FZNcZ1KM26KI=;
        b=bnr9W94cIFYUYGbYZM/SjXBTXSmzTwYBy8DJNJXcmc8WG9lGAKRql5O2qS0xoi9z8k
         lEmn8M0IGhkeEqaCiExydHxJOGaqAxW/sskGh76OdYzjAdCqZQjde9d8mhLVm/VZOtdK
         R1Y1SntzmRorFlcJtkDUVIMB9h+TZKRSwiysjV3CZz0R5kw20lCPWnziudAOOlM8xfGu
         i/vnsJGr3U4cJrlpg3CPbstp5DecYYm7pNqZDK3PtkeZnOML6qFMlYihSzeo6/dREzDp
         etVmWRwa33R2N0Ujch1NRLKJpKP6KSp3pIQxDrgInzxPSD/QeP5uVVdYpQOq3wW100zv
         bq3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B84TBgeETkt4nO+wKVIpW+Ds3pJrpx/FZNcZ1KM26KI=;
        b=ZQr3ja+Cz7pn+eYpxSwASzrdpOSnF2MhOJl2/x74zJNrS2l5KLmkT21Z8y5bkXJE0A
         yGwFdHaJpmKanDHUeT1oCPesB7hlwoqhNH9u//eCinALeVEBRnmhtfVZV7fGpDjfCuky
         yq0l0n28Cnhh/E6ppyxfShJ619sifjUuTHS1F2nfqXde58NC0IcV4bS3kMHYAIDcclDg
         POkW+Wcpg1TKDi5wWtL9YjI/u8RwWrlRNNdZ5kidAsT8GACuyrQ5ytbggVTUTUeW99UY
         JVKJxWqR0445w0PlQFp8r7JKpharWcFXzCuYx3rlx85V6qDbUmWtPINOEGJj4rq4ZgeP
         CXMA==
X-Gm-Message-State: AOAM530B1N6VTTJ3atAXlq4VOuA41HDn31crGzGqC3F3cAHZ5umGmzoP
        n4dyT0rRhhANBE26YBAyBmivJYV6+WfrKA==
X-Google-Smtp-Source: ABdhPJwCcPr6IlHHWvbOcoNbdd4+uY/LZzQJ3ZXMxi3Gu7j9EL5gFmOLVKhDopwr3CZ8hLAlqlCWzA==
X-Received: by 2002:a1c:b60b:: with SMTP id g11mr7190349wmf.48.1599217825183;
        Fri, 04 Sep 2020 04:10:25 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id m3sm10622743wmb.26.2020.09.04.04.10.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2020 04:10:24 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 13/18] crypto: sun8i-ce: Add stat_bytes debugfs
Date:   Fri,  4 Sep 2020 11:09:58 +0000
Message-Id: <1599217803-29755-14-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
References: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a new stat_bytes counter in the sun8i-ce debugfs.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 6bbafdf9d40c..910b510d7bb2 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -276,6 +276,7 @@ struct sun8i_ce_hash_reqctx {
  * @alg:		one of sub struct must be used
  * @stat_req:		number of request done on this template
  * @stat_fb:		number of request which has fallbacked
+ * @stat_bytes:		total data size done by this template
  */
 struct sun8i_ce_alg_template {
 	u32 type;
@@ -289,6 +290,7 @@ struct sun8i_ce_alg_template {
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
 	unsigned long stat_fb;
+	unsigned long stat_bytes;
 #endif
 };
 
-- 
2.26.2

