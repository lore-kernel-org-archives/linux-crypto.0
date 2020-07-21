Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E95C433FB
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD4562068F
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="kpS0ODIM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgGUTHZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 15:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730500AbgGUTG6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 15:06:58 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D215C0619DE
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:57 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 22so3871036wmg.1
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IClHRVpfuk7pyuQdBbEm+ADLfyWf25fRbOn1BdIIJx4=;
        b=kpS0ODIMjq+Rex/AWKOaWVHiTIYVRyqA1p81k5RhhxTrsSUm7oxY721P7m25ai52mn
         eGD8THFhFyBroaNH9gyg+kYiZ9oGqSKMVpbk53qlf6NwbxbOhFms34PilOy8uPXuUuel
         f9PB5MJXN+GBiDm4pvJxEmHJhFGprO45X0Q472aewv9nmxqZyCULD6DE/Z3Bd6abmVtg
         WstaO+kbfW3SBQiNKlHaRuy8vPEuwSbX8QUKa9+vTDc5hYcwXDbwcdv80x3kNCq2K83m
         R9WY6i/ZHcgXp2l3a84yuAKXcywUtpUG9V9MYieWweqaEbnv2H/5pHYn4hHd50oVXCOP
         1Vng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IClHRVpfuk7pyuQdBbEm+ADLfyWf25fRbOn1BdIIJx4=;
        b=cdzRMCXYdNcXcY8LC2FsoZ1rY+U5OEDgUn6UjGJI/PrBzycIXOgyhcYEV3kAbEt38v
         Lwgvjipf706e16rysbgRPGC41R4hus1LeOmx3tZuonjaL/Mtn2JQMHO+4SHFvhOO9yRf
         kDPq9bVeIEN7Q5m011y/OZdpRWl6yJbFbUI7N1xdKEpdHfwWXnUg4EqGO4sp+OWoyiyb
         yukNCsjY55VHwIO6hYym4lsdKO4HrXBoioYNK+UKLRQebQSmO0A+iofDdmPHqvcRvrp7
         MfRvaYROfKUoVFpvq7RboUPYA0zz9pttnwlfi3vyeSAo5Yzra2Zz2pExh4y2qGYCmZbX
         qlSg==
X-Gm-Message-State: AOAM530QiW8dsljFV+ewKePRwzzpxNIzelgQrzTkhxKhULyGlAFJU9JY
        /Zmuwj2gx5LZEAWxrx6iT0UVZw==
X-Google-Smtp-Source: ABdhPJxkKsBBqSYMLl2ItrQoeHhFa7/eJVIPmedqJIvSOSX/Y34StYaam6LPLJv4WsxLjn/RcUwp0g==
X-Received: by 2002:a1c:de07:: with SMTP id v7mr5348230wmg.56.1595358416326;
        Tue, 21 Jul 2020 12:06:56 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id s14sm25794848wrv.24.2020.07.21.12.06.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 12:06:55 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 16/17] crypto: sun8i-ce: fix comparison of integer expressions of different signedness
Date:   Tue, 21 Jul 2020 19:06:30 +0000
Message-Id: <1595358391-34525-17-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
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
index 3901e3401c6b..7b2a142c9b8d 100644
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

