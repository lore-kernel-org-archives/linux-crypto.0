Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFEEC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 17:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 419856120D
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 17:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345411AbhIPRKs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Sep 2021 13:10:48 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:59418
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350034AbhIPRIl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Sep 2021 13:08:41 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B63264026A
        for <linux-crypto@vger.kernel.org>; Thu, 16 Sep 2021 17:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631811925;
        bh=2in4Ee9Den/iF6lPr3kqJcbqH/e6c33reOi3jUtDPLA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=cs4Y6k44UsGKY91WC/2bdEmpFZWszWV+ItoSne5BQI0xVErDMu611oipjK+3rDUTP
         vDY/Lbj7zfEYKb9DZCbybjJCWFS14A9ph9jaslbskjnN+Pb8AT8rXgvu/Pe3KJDX5j
         aJ4tv6PFoUJTe71r3vuvtqi02IfF7DnN72LAe2WZx3XFaN94Emciima4NsT756opz4
         rF3zAuMw1aUuo2HQEz8yHOOvVbIcF0aimqhsBJ+95EZdlE8eCyWQLsNbrvR/TAf3sd
         cJJSBsg24oy0miIDmZiGK4bBvuMvt1ILLylDdzERF4Ojkw00hgQ37LudcB9x2BJSdU
         5k1Kf7xa0FURg==
Received: by mail-wr1-f71.google.com with SMTP id x7-20020a5d6507000000b0015dada209b1so2681241wru.15
        for <linux-crypto@vger.kernel.org>; Thu, 16 Sep 2021 10:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2in4Ee9Den/iF6lPr3kqJcbqH/e6c33reOi3jUtDPLA=;
        b=3kgNkzFJONKPqdDbOwFHGiRmdzkGooBEEHetEIk5Y9ZlprmoX+M+uuXVMzZXC2G149
         FYatQILZ/KNNi6fCcog6yaav4L0fKhOVDqbC16Z8Yj1Q5dytc48w+/WWEtLBb2NaZNYl
         FBzf3GQG89i7k7iwj35P052GU9MNQYX5Hxwh8urZCqlvSHj96Uw4sKdGtJ5cVdd+3Cbh
         OIwoSkVcBCTzxHqZb59zR6JOdpBVqwSre6E7GRg4zbUiGLmk3S8TGMfp3P51zqbCzLFs
         TKZ74M0tiMwRWURWU0iseVpTPvCoX3d36Wn22GYJdzKJKL9ClmIGpjRg3ZuTJMux5rge
         mhXA==
X-Gm-Message-State: AOAM533SJnvUeZFCFBghTIQiDvmTGd96OlEjDc32bZT4+rLQC8oEQxI2
        MPyxfujvkoERWjik8NMYh6Bv/SzdfPveM9TcKD2KloWgtUYl/A7UGD9UUaj2cOnpiOV+cSY2Yez
        uBMuYYyCor0RAyT53F9rgQJ27im9LpWmK26Kgn4W4vg==
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr7232423wrm.198.1631811925488;
        Thu, 16 Sep 2021 10:05:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweEXTvdgMrZFo+fiFdqAWkUZFpEa72JKe/21s+Rqw0H5pXNd34exqlivJU2zCzk9x4QzLSQg==
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr7232394wrm.198.1631811925284;
        Thu, 16 Sep 2021 10:05:25 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id f3sm3807850wmj.28.2021.09.16.10.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 10:05:24 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: marvell/cesa: drop unneeded MODULE_ALIAS
Date:   Thu, 16 Sep 2021 19:05:22 +0200
Message-Id: <20210916170523.138155-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The MODULE_DEVICE_TABLE already creates proper alias for platform
driver.  Having another MODULE_ALIAS causes the alias to be duplicated.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index f14aac532f53..5cd332880653 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -615,7 +615,6 @@ static struct platform_driver marvell_cesa = {
 };
 module_platform_driver(marvell_cesa);
 
-MODULE_ALIAS("platform:mv_crypto");
 MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com>");
 MODULE_AUTHOR("Arnaud Ebalard <arno@natisbad.org>");
 MODULE_DESCRIPTION("Support for Marvell's cryptographic engine");
-- 
2.30.2

