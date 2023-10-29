Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA53EC4167D
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Oct 2023 20:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjJ2Usu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 16:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjJ2Usn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 16:48:43 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919D1C2
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 13:48:41 -0700 (PDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 310B73F68B
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 20:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1698612517;
        bh=SH87ZmKIdF7eMR0VODUq6DUDb+J0CZk1+c70eMvKp34=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=a4yP+dDLtTWpzjKncI0+02tYIy+9ovORaYZC7yn/dZiHSJI8pyewFc0b3SWN86oAA
         WfJK+kIrI7ePw8MbriTv2wlU5ZjyLhW0Jju3q7/4iwhVDfhUcwAkWrgJ/B/UFJc4NZ
         f7IL8pKQ0+2QxG7kwCXvS5UfxFIml4IV9KhTwTDbxppP7Nh+9MwzY249eCXfPf9dqP
         L3TLsHO/rRGdZ4yZ6sOKLiAteGDqGYwZ+trbrf0cO/htD3uKDoK08MU5XoTqtY3bNA
         CCMPZdt5wBNupdghX2pw1Bvi9D105hV7wPVECjgFTGmo+WUIAKSareyTYbRuq7S6HR
         t6CQxo4tDVl0Q==
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4094158c899so3862565e9.3
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 13:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698612515; x=1699217315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SH87ZmKIdF7eMR0VODUq6DUDb+J0CZk1+c70eMvKp34=;
        b=cPnXYMDZzefliN2IhSeGC3fz3+yPf4ZR0Xjgj9hv2GTWjfS45A8879htXuYoqYnLv2
         TwhEfFQB49Uotudwb7o8O6RJqszbELYY+e4mYZ3Rw10M7Dzzyo+PRhMWdc1KPj6dlvYn
         bn+ZVfwjsDSIQr2CPSKSbjd+KuKWTdOq+8Ymn3QFZLrirdHONJ4Kb2Y1TbkXFEsNiASJ
         tKmCPy4/2QrC9S4zktEKgq6w+o+Loba58PzmpZ91xnODh1KZ7v3ZKxC6DJft44aQOOQE
         6PBqjt4BqnMthdlbz8Z5C82bK+wIhQNAbSqasPr7SUwRrXPGmdLx1zDCLx4oewXPaR27
         x9uQ==
X-Gm-Message-State: AOJu0YwI3hV4Er/4caNoiJr+U9zzPhxgFhkmUs1VLbK77LJwMwm9Qbj5
        tApm222aKtpl4zs/6VIkOLGG6/VwD8YWNA/zEuDROY0mS+TYerW5eUeH7kvm44yQ35TQsRYVrXm
        mNCkD+8tmUBbCf8dzayYbbspPiwHOrTeOAWJYWbkn8NZMYGebWNGgxEk=
X-Received: by 2002:a05:600c:3ca4:b0:405:36d7:4582 with SMTP id bg36-20020a05600c3ca400b0040536d74582mr7000439wmb.15.1698612515194;
        Sun, 29 Oct 2023 13:48:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfcuRiTfAb8KkgDcD2BMJfMf4n/bD7ExxxWqJOp/7yNscMqbqqpJFGbwljPWHs0QD5H36qbw==
X-Received: by 2002:a05:600c:3ca4:b0:405:36d7:4582 with SMTP id bg36-20020a05600c3ca400b0040536d74582mr7000424wmb.15.1698612514721;
        Sun, 29 Oct 2023 13:48:34 -0700 (PDT)
Received: from localhost ([2001:67c:1560:8007::aac:c15c])
        by smtp.gmail.com with ESMTPSA id o13-20020a05600c510d00b003fe15ac0934sm4346423wms.1.2023.10.29.13.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Oct 2023 13:48:34 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>
Cc:     simo@redhat.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] crypto: drbg - update FIPS CTR self-checks to aes256
Date:   Sun, 29 Oct 2023 22:48:21 +0200
Message-Id: <20231029204823.663930-2-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231029204823.663930-1-dimitri.ledkov@canonical.com>
References: <20231029204823.663930-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When originally drbg was introduced FIPS self-checks for all types but
CTR were using the most preferred parameters for each type of
DRBG. Update CTR self-check to use aes256.

Fixes: 541af946fe ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---
 crypto/drbg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 2cce18dcfc..b120e2866b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1478,8 +1478,8 @@ static int drbg_generate(struct drbg_state *drbg,
 			err = alg_test("drbg_pr_hmac_sha256",
 				       "drbg_pr_hmac_sha256", 0, 0);
 		else if (drbg->core->flags & DRBG_CTR)
-			err = alg_test("drbg_pr_ctr_aes128",
-				       "drbg_pr_ctr_aes128", 0, 0);
+			err = alg_test("drbg_pr_ctr_aes256",
+				       "drbg_pr_ctr_aes256", 0, 0);
 		else
 			err = alg_test("drbg_pr_sha256",
 				       "drbg_pr_sha256", 0, 0);
@@ -2017,7 +2017,7 @@ static inline int __init drbg_healthcheck_sanity(void)
 		return 0;
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
-	drbg_convert_tfm_core("drbg_nopr_ctr_aes128", &coreref, &pr);
+	drbg_convert_tfm_core("drbg_nopr_ctr_aes256", &coreref, &pr);
 #endif
 #ifdef CONFIG_CRYPTO_DRBG_HASH
 	drbg_convert_tfm_core("drbg_nopr_sha256", &coreref, &pr);
-- 
2.34.1

