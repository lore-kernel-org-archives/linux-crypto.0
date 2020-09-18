Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC630C43466
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 770E121741
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:23:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="b40vNqBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgIRHX4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgIRHXx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:23:53 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E03C06121F
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:44 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q9so4293697wmj.2
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=agXVF0ms/CfrT8LzQj5/+SUtzz/nXnxAuE96neqmqJI=;
        b=b40vNqBWrSpj193oHajdV8Ggm3g4WLkYG9C0NI/2MUbDs2BO0Wu27ZJI3IqdlTKwBJ
         FLcqi5gN1U8tM7pxfhc0E8snrwHBMNwSOAuhdwcDwdM801WMtbC4iobcC5ME+E0H3a+2
         UhIdwPldbJMt8RV6RGzobAiQoh/xUMwX4E5O8PJ3C90sleFrR5BQ2Fm0CbunvCkSIGqo
         NbErDwd1CS98w3sqUNeEaGp5FLxTlCl4HKRoOUXXnVhYDz3Dey/JKRRI56hUjsIVqGXd
         7ugITEdlv3QnYzUQpOY6QrKpXMgn3GswzNsEC+jXULzUglX60EwqfTzYrB21elM+7ERq
         dYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=agXVF0ms/CfrT8LzQj5/+SUtzz/nXnxAuE96neqmqJI=;
        b=XVSjHOpc7faPnJImZZTlam03IGO4JJ+FN+PWNGz/PHMc99CTkaJH1tsjUaDa1ETXwJ
         JQVFGQKE+vn8DJxOaK3FnsqVhc/7FhTHrxTS649LBaOwyor/ZCrB8BZB5n2QFGuc5vFS
         mbpAO+or+5i/rXJ6I0a8bdzuh1Rn41gKICSHwFFG6V70N3pbUuxvnaoNHMcuX1LGQ2hQ
         YW93R+68bbxxaFP6v5Rp6zuRU1dEoqBCMeSUg4NfardZK067bg/sfDMozuxU1EXLhrrV
         zhAL7ihMltJvvsR3dCDpifq8cZOYs9UVvOJ29RCB2FduOgIgf93okqua5EPO/DryEBQE
         +IJQ==
X-Gm-Message-State: AOAM531qA2aMcefFQKHlnGteUaIBVwr+w5Q0MVWf3PSJdXVS2UXqraLg
        QxjqQnqP6kBTa16XhWXD6NeUUg==
X-Google-Smtp-Source: ABdhPJxUZl2VZOaDadb4idrEKB8trbPyV1PnLZsaRVrTJWZh2s62nzGjodZAmf6BdZEZ9NXQyysgXw==
X-Received: by 2002:a1c:e904:: with SMTP id q4mr14880968wmc.151.1600413823006;
        Fri, 18 Sep 2020 00:23:43 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id z19sm3349546wmi.3.2020.09.18.00.23.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 00:23:42 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 16/17] crypto: sun8i-ce: fix comparison of integer expressions of different signedness
Date:   Fri, 18 Sep 2020 07:23:14 +0000
Message-Id: <1600413795-39256-17-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
References: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes the warning:
warning: comparison of integer expressions of different signedness: 'int' and 'long unsigned int' [-Wsign-compare]

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 116425e3d2b9..cf320898a4b1 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -566,7 +566,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 static int sun8i_ce_dbgfs_read(struct seq_file *seq, void *v)
 {
 	struct sun8i_ce_dev *ce = seq->private;
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < MAXFLOW; i++)
 		seq_printf(seq, "Channel %d: nreq %lu\n", i, ce->chanlist[i].stat_req);
@@ -778,7 +778,8 @@ static int sun8i_ce_get_clks(struct sun8i_ce_dev *ce)
 
 static int sun8i_ce_register_algs(struct sun8i_ce_dev *ce)
 {
-	int ce_method, err, id, i;
+	int ce_method, err, id;
+	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
 		ce_algs[i].ce = ce;
@@ -858,7 +859,7 @@ static int sun8i_ce_register_algs(struct sun8i_ce_dev *ce)
 
 static void sun8i_ce_unregister_algs(struct sun8i_ce_dev *ce)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
 		if (!ce_algs[i].ce)
-- 
2.26.2

