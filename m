Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADCEC64E7B
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 06:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09AA42087D
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 06:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e+AzRyBR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgLAGvP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 01:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgLAGvP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 01:51:15 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB732C0613CF;
        Mon, 30 Nov 2020 22:50:34 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id q22so205394pfk.12;
        Mon, 30 Nov 2020 22:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5TbZRDFuS6pZ0tUWXbMbLbpnoAnGVDMU7ST9hOrM+1w=;
        b=e+AzRyBR4DLj0yY3x0KPjvibjwmrpTiNoi6bJ+DdYAu5BLOJFpji490fQs/2baa3Og
         zvKeYgBvczsT14jpc+vT8b9kdm4U4GdwfVCuIEWHw3k/pRd3pVJEuQvXxAu1Ev21E9Dr
         9WxHziTFY1S9/w9Ct6N2kPaYIK7pQT5m6rtOa5TQ57l0f2MacMEz3zM7QEnsCP5sdpQN
         9v6U/WEEWZKumdRnRHO0GbW39xkTq4yK+QrAo8r3iownSOLyzak21fNRDiz9VG+ce1Ac
         aYmQ8os5cWiyFqFvuUgztBn661Aw7H6UwyZsFOlIsY2oA3CIKuV4M26OaONB1fc5Po3v
         ssEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5TbZRDFuS6pZ0tUWXbMbLbpnoAnGVDMU7ST9hOrM+1w=;
        b=B61kRVEjq5DQBX8ztv2SvLecFsSXwE5ual5M1MqOeDwJBEWK+Yq9netUVoTf5LXDQx
         9Mw8DXrQlD1XlVbYu7o0lWUD+4/XZPhVUFnKtau26AmmNTj+bA00C4tORFe4XAj8MJJl
         Vugeo9pl4/Z2Y7GoSmuFMm6NIYSJFCKlE2ig8uIVybI+7k4BAKiSik5emg5VzUby5RM+
         DpVoD08RX/Lsvc0u7DQ/UctxOP07yOUVDdsI0UabYo/Y9gMvA7qwjKOvH3xgzmSvI8tU
         wUivkGj2euqZb2q4gCAoHKCFCktAGpCzWH5v5RZTjxRd3NLMXeKdVWYq1wH6Zelw4HLU
         anNw==
X-Gm-Message-State: AOAM533esAJDXBRz+DfAqKsIneDt7kobrHVRWni/n+6bD7HqHJLNhzmO
        bTEFC8H/aHoPzrELrZIOHfv+TYpiFB0=
X-Google-Smtp-Source: ABdhPJxLXb0m/onpoQcyuCUIYX5W7JPNbhOhJrKliJRDzbDshn8gU+6egfzSiG5G1p6tIdZmUj6DCg==
X-Received: by 2002:a63:a503:: with SMTP id n3mr1075553pgf.416.1606805434370;
        Mon, 30 Nov 2020 22:50:34 -0800 (PST)
Received: from localhost.localdomain ([8.210.202.142])
        by smtp.gmail.com with ESMTPSA id l3sm1035966pju.44.2020.11.30.22.50.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Nov 2020 22:50:33 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     xuzaibo@huawei.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] crypto: hisilicon/trng replace atomic_add_return()
Date:   Tue,  1 Dec 2020 14:50:18 +0800
Message-Id: <1606805418-4739-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

a set of atomic_inc_return() looks more neater

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 drivers/crypto/hisilicon/trng/trng.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
index a5033cf..2971268 100644
--- a/drivers/crypto/hisilicon/trng/trng.c
+++ b/drivers/crypto/hisilicon/trng/trng.c
@@ -267,12 +267,12 @@ static int hisi_trng_probe(struct platform_device *pdev)
 	}
 
 	hisi_trng_add_to_list(trng);
-	if (atomic_add_return(1, &trng_active_devs) == 1) {
+	if (atomic_inc_return(&trng_active_devs) == 1) {
 		ret = crypto_register_rng(&hisi_trng_alg);
 		if (ret) {
 			dev_err(&pdev->dev,
 				"failed to register crypto(%d)\n", ret);
-			atomic_sub_return(1, &trng_active_devs);
+			atomic_dec_return(&trng_active_devs);
 			goto err_remove_from_list;
 		}
 	}
@@ -289,7 +289,7 @@ static int hisi_trng_probe(struct platform_device *pdev)
 	return ret;
 
 err_crypto_unregister:
-	if (atomic_sub_return(1, &trng_active_devs) == 0)
+	if (atomic_dec_return(&trng_active_devs) == 0)
 		crypto_unregister_rng(&hisi_trng_alg);
 
 err_remove_from_list:
@@ -305,7 +305,7 @@ static int hisi_trng_remove(struct platform_device *pdev)
 	while (hisi_trng_del_from_list(trng))
 		;
 
-	if (atomic_sub_return(1, &trng_active_devs) == 0)
+	if (atomic_dec_return(&trng_active_devs) == 0)
 		crypto_unregister_rng(&hisi_trng_alg);
 
 	return 0;
-- 
1.9.1

