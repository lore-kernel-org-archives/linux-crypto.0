Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD2FC43461
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 060502073B
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="GhdtQvuV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbgIDLfH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730131AbgIDLX7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 07:23:59 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D65C06123C
        for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2020 04:10:31 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id s13so5682991wmh.4
        for <linux-crypto@vger.kernel.org>; Fri, 04 Sep 2020 04:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RREMgoQ10AgEzpG5x2JxpJp9Y6xrNHTkcUblYPCMXMg=;
        b=GhdtQvuVPlMNi/4HuZ1Le/lrCrgZO5SzT0y0hUW5n2rpoWmV5qQ5lePPG9kMfnaHIE
         l95/VlEinbmuLJ8+JXTh2qoyemzjonhQ15so0IncFRJINpHUemb5SUZUnfYfdFl43Gjd
         JibwurqGMqVKb1JPUTFGo/1PXonh8XLYU/w5wgGFcbC/x98cudybdby8TOOsXyTwBVyE
         v0ZA8hv5iVX3N1HVu4UvyRVs15xyL4AlW9SlXFQ6EcER0Dmc8T8L0D6Ltk1Oqlkr/Fne
         MLno4tKSXVSj/hJECJ60lSBPGB/27OQnV70V8oCkTs4LxTklkJ52RHrLstg5fROSIAn2
         jbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RREMgoQ10AgEzpG5x2JxpJp9Y6xrNHTkcUblYPCMXMg=;
        b=OggV6aA2PBFHPWCLtQpCphXMsPwLUZgf6Yoy4zc55zqz/l/G6wt6S9dKQFYURNPx65
         G5uuyJCwU+Q1jakQScSDul3z2FoH30AMM0kJXFLjexz8erkzoYh0C8otpG56Wx54wWQM
         zy5LpfsGEjDb+YaYHHa1OFhFX77r5dqAgSEdj5MXnh6LLAaB728LZtz2ucySndEe5HEs
         F1/RtEw3Q345w7eUkfbMq+NFbLYsYrRyl8ctRFKtKI6uMJ8JyMy5l7j56gzyX2yFCk/E
         w3h/1uZPXyZ9tR0QiSeehXV2jl1LK5QSGpc2zE4+hQCKCTWrJ1NObzR5tDpF72Y4UXXV
         UZAQ==
X-Gm-Message-State: AOAM532IfUAjQt4LLMfiJpblllpGROyFtCJZFRft8MdS7vVbBJy9YMjG
        QqPCP3WpcplWxyfX0Dc/RO+qZg==
X-Google-Smtp-Source: ABdhPJzAXlVz9b1PNm6h5crfm4OA+i6aZW/VhhCZtvESCxw4H8J+XYMKpa0jH7ftMnVGyUCjsuTOGg==
X-Received: by 2002:a1c:2c06:: with SMTP id s6mr7241821wms.110.1599217829903;
        Fri, 04 Sep 2020 04:10:29 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id m3sm10622743wmb.26.2020.09.04.04.10.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2020 04:10:28 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 17/18] crypto: sun8i-ss: fix comparison of integer expressions of different signedness
Date:   Fri,  4 Sep 2020 11:10:02 +0000
Message-Id: <1599217803-29755-18-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
References: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes the warning:
warning: comparison of integer expressions of different signedness: 'int' and 'long unsigned int' [-Wsign-compare]

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 739874596c72..c9cfe20b383d 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -414,7 +414,7 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 static int sun8i_ss_dbgfs_read(struct seq_file *seq, void *v)
 {
 	struct sun8i_ss_dev *ss = seq->private;
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < MAXFLOW; i++)
 		seq_printf(seq, "Channel %d: nreq %lu\n", i, ss->flows[i].stat_req);
@@ -571,7 +571,8 @@ static void sun8i_ss_pm_exit(struct sun8i_ss_dev *ss)
 
 static int sun8i_ss_register_algs(struct sun8i_ss_dev *ss)
 {
-	int ss_method, err, id, i;
+	int ss_method, err, id;
+	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(ss_algs); i++) {
 		ss_algs[i].ss = ss;
@@ -642,7 +643,7 @@ static int sun8i_ss_register_algs(struct sun8i_ss_dev *ss)
 
 static void sun8i_ss_unregister_algs(struct sun8i_ss_dev *ss)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(ss_algs); i++) {
 		if (!ss_algs[i].ss)
-- 
2.26.2

