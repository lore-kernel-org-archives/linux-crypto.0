Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85091C433FC
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 622792068F
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="QAnVtcZk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbgGUTHZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 15:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730531AbgGUTG6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 15:06:58 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7FCC0619E3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:58 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f139so3917840wmf.5
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=laHnxcRjPmQy9VaO/clWypRhfggwpc5qovCSuzLReNY=;
        b=QAnVtcZkVkETeqRJ7UhjGVUFOq5LUWUoreoJPx0uYX+WcB0QhDa8EQgZpB/x43AnEp
         se8w81A+aiy28s59yFk5xO9n7rCwJkgCpF4WomL30kcBQyCFpax3jUUrLRtRHjLrGYRI
         cu6FrITYrJKCbOTavfcv3IeKswJcaEyOIykOl5NFgDpfI6oUp4QZBzzPFhCQmFLgqPZR
         WuSK/uKV7GAnnCrpJjN+UtfsxnZucm4BqKuhg45DV+Oa9AhUwaskpNfqsFRSSv00UZjN
         uUVY+0JgX7Ql+ovPkLNOHyObmVc4vac7V9OCi8fVVVneYJfUGa/8JFbLdKC62+Gcd59J
         PIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=laHnxcRjPmQy9VaO/clWypRhfggwpc5qovCSuzLReNY=;
        b=qYSUq7CUcieTCDDVwwz4e3HjzXjj5+rX55ynnBr9WbwtO3zFauoqd9/K6+eQcc4K/t
         djJzM0yO8R5m6Bk+Ylzfm1y1XgZ0aQvEHX01OrHgl2m1tizSdv92kpsKanI5Q7AV3mQ3
         JIWpQDTDI/6BcM+4TMCk6aI6SZga1zX+OvtqK88aViNbBeSFIfkJCih3TlB3NnawiLM/
         Fipf/CipgK7x11p8gE8+UnAS+43g9wJEqXjNxcEHt71Sfn/E3kOudP+UbvkShh9pdNLJ
         YUOK5ARFxyy31cU1X68ILvpk8xOhA3+bankmPvtPj68aiAmuhUNEnHBiNxkxuOFfBdkL
         aA9Q==
X-Gm-Message-State: AOAM530aQFe6GVwCGIc7tDoARjgmtttwcMcIjL7NtnUI5syjI9r49im7
        QTPl4aA452/sloSo3udpW5GDSQ==
X-Google-Smtp-Source: ABdhPJxQHbPR+lsd7erqeGgjthIiB3YfPMd4IJcJvoLnUjJ/UZENfZjgWdMlQKNMew+ohFr/pAs3BQ==
X-Received: by 2002:a1c:2e57:: with SMTP id u84mr5680617wmu.52.1595358417148;
        Tue, 21 Jul 2020 12:06:57 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id s14sm25794848wrv.24.2020.07.21.12.06.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 12:06:56 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 17/17] crypto: sun8i-ss: fix comparison of integer expressions of different signedness
Date:   Tue, 21 Jul 2020 19:06:31 +0000
Message-Id: <1595358391-34525-18-git-send-email-clabbe@baylibre.com>
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
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index de32107817b3..a17241483b8e 100644
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

