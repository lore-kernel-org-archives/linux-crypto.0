Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87314C433E2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CFF2208C7
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="obW31qxL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbgIDLhN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729969AbgIDLg6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 07:36:58 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0F7C061245
        for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2020 04:10:29 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e17so5716687wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 04 Sep 2020 04:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=agXVF0ms/CfrT8LzQj5/+SUtzz/nXnxAuE96neqmqJI=;
        b=obW31qxLoN9OWZSj19gPQwd7o4se0XnSLbfRoYBvDVsFoX10sLfJOIKX9+EVAheFpY
         +CsJz7XMeRft3mfBqCcS+QfxleHYsfYtrBkYvCZXVAPD73YoxN/68frT48xZoXiaZBsC
         Yp+PTCDEVtkr57JKapdh6bOR9Zm92eorU/Mor5owv8PWj+h3OjrgnAhrHw59735YeuY+
         L2Gc3FjQ73fP7WIjzIK6q0SlloEhQADpTJg25jE/ZqbEvE7i15FYp1NU+xtiCgcHTntr
         fw5lJGW9e/1uef2+HjK1eDmPYty4cJeoGGUD6IA/u2i5wke9t2AZLNCwvRvVQ2WyNM0j
         JC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=agXVF0ms/CfrT8LzQj5/+SUtzz/nXnxAuE96neqmqJI=;
        b=qDNL5tkL84j8tPmpwrx5vLtPtu7R2/YpwHCKlJbn50OVW1W1cBV2gXS3OIQna9kRia
         swhdtF/3i6OWCSl2UndGEr3LnA1faPWkXbM3EpSucYU02Cd59OefWcTO3GlGRdo+IMXd
         f049XelZqgA/YtFaZgIyTXSpRZcAtv9sGkU/5QYWMIygA2FuSI4TXBqu5jTlioAC0JS8
         Yworj6xLmDFiuSV9FaK9THXclfgRpKYRDL60mXeIQL7drCIjEfQ1+N3fA4+dmYfsx2Tk
         4Ap+YHAWzkFJws2A+nUvpY4e7lenMVbjA1dk3wORDVf19yc4UcA5IO8woxGHuw1FEyqB
         dvyQ==
X-Gm-Message-State: AOAM533bix3xr2zurbEUBP0PrmdDvxHpBkHMECUL9OfhDcai047jjydF
        6UQI7ruQWStDKGixm/RR0pUpLQ==
X-Google-Smtp-Source: ABdhPJyWFAoPovD5D/ikwYMEEU7ftuFRGS2vCfDVOayt1KIOtg4sPOpAYrFsB25tqCpU9RbGj92kHg==
X-Received: by 2002:a7b:c753:: with SMTP id w19mr6906296wmk.157.1599217828670;
        Fri, 04 Sep 2020 04:10:28 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id m3sm10622743wmb.26.2020.09.04.04.10.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2020 04:10:28 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 16/18] crypto: sun8i-ce: fix comparison of integer expressions of different signedness
Date:   Fri,  4 Sep 2020 11:10:01 +0000
Message-Id: <1599217803-29755-17-git-send-email-clabbe@baylibre.com>
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

