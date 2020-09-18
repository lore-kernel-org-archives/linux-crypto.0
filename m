Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79052C43464
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E88020C56
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:24:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="HkHU/RuO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgIRHXz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgIRHXx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:23:53 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CAFC061220
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s12so4504079wrw.11
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RREMgoQ10AgEzpG5x2JxpJp9Y6xrNHTkcUblYPCMXMg=;
        b=HkHU/RuOacOBTr1v8pD8gw93Dk2xa6hsEqa7Aoe3HIk27GD5wjUQWn2ZA8+ROdU8m/
         MS2gTneDwTjM3HCO1qogpjmczY5egH9fMNsIfUQx1FHdd09JuZ9LZgXzbKSM7bfoIrNP
         WRqOe16IK9Fw3sfbmR0jUCAtvPxZUrmNpzqN8+GiK4Q8hfGUACdAwPmsVOWbGCtbyI3n
         MJnTFiz5W/kJh0dbKd5n5kxMIfvcSDN1+7XHjg5uR7mJPTP1RXcSbcY8bf/o/7tLAj9u
         Cz27U2rGSi/5ovHw5xhNVYYgQ7Ghj1ffW6VHdiJ2Uj7o3gvpCbWTcPMEvyz4ckSbSuyf
         wG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RREMgoQ10AgEzpG5x2JxpJp9Y6xrNHTkcUblYPCMXMg=;
        b=CkhD7wkLZrHf9iiqa6nET45oy897CLFX0K0WCjDlQxOJHgri1Kz16yk3aS9BB5YeYw
         a9AmRr0+wPjypc2ZpheCS0UItwgRrulMWpH/94NTza9N0fSJ4AocOtK6Jj5o0i9dyK1h
         fANkRuz5BNNZ/mIOA031VySpb5Kq7TPV00f0qJRwFMiHuZ9LZhkPgMzZKlI19O7eBB30
         vuisVU52jvYK2TLnG2EbUAFn998QObzLif28YUQ3qtnEk1zi3ftllmbBlwGg9VS3sysg
         EOnO4kcMewnE701kD669WFJukxbOXNuBUSzhk/0Xk4qn4Ev9FX7qTu4+oHvz2LWbMtTl
         jJuQ==
X-Gm-Message-State: AOAM5337Vgl7UwnJu2bZ4oVcEipdkX3Ng1pFMreLDMF2syU/JLq28U4F
        ubllXR5t+dTJDWQ6t/HbIedgYA==
X-Google-Smtp-Source: ABdhPJzrtZkV7XKdpdogHscJqjSpplrsVfnghJi5052mVZFzVZtfCQHBIG2VdoJST/XZhQKA27wCxA==
X-Received: by 2002:adf:ed12:: with SMTP id a18mr38252772wro.178.1600413824201;
        Fri, 18 Sep 2020 00:23:44 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id z19sm3349546wmi.3.2020.09.18.00.23.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 00:23:43 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 17/17] crypto: sun8i-ss: fix comparison of integer expressions of different signedness
Date:   Fri, 18 Sep 2020 07:23:15 +0000
Message-Id: <1600413795-39256-18-git-send-email-clabbe@baylibre.com>
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

