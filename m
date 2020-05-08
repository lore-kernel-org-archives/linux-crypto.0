Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DA6C47255
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 22:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A47BC2184D
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 22:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m2PPTcmd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgEHWfT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 18:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728186AbgEHWfS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 18:35:18 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1048CC061A0C;
        Fri,  8 May 2020 15:35:18 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id a4so2660880lfh.12;
        Fri, 08 May 2020 15:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hTAcvwqa4Oo39yOPo/Eolf+rq4dk/6Vbm85MLMWrpZY=;
        b=m2PPTcmd05LvqnQ0AigwK/no6HSABidn7DGFCxPlPZMfu3m2KZVOU0bOUlYuGa4sYY
         EWLQZfB9pYfTO1O6q6NRBPbypC1kNRGpEOeC84enB/Rq/DSFoyN9kxFM9OYpTNDiZ9Aw
         LqqcW5Ab3ykdZyTVGKHQiZ2oxuAjg+DEEsALvhhKpvesUt1DydG0eAu8/M0w8FYwYiqR
         lhQl49ASRyIB/fEw8HDymvxahDO9Azjx08HCB/b2kdOJzAcLXTzaKDb8PfRlD2SwyUzc
         x0oShL4fPOGqaI3o9jFQDV4rmLwWSK4GYBMEySB0YyGyHBTFu1uZZBcA77eYHRZXvSy2
         bfQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hTAcvwqa4Oo39yOPo/Eolf+rq4dk/6Vbm85MLMWrpZY=;
        b=LEUYmdMPBNFVeO6IIb6bEqgKMDu3dHmt6cJ1cpEPZAS4jT5OjIxdN5J/7kTWq2nAy3
         CEwlpV6hK3UpioaZ8Y7zLpkGMuUJSjMXn8DlojHtnAkuwxVXMJ65a1XPWCOcEfRKhCGJ
         +Kbo7GVbh4oaO0eMuSLCGiYBMwRfMRQUJF2LR7owWKaxOgeHcXNWFaXAzuHoWG1ENWAd
         QjHXRlEyBulTv7GVibAQIDj3xnFnQWOvwjN7kv8neuB+738nktqV3wV5zbPtH0uNwjMy
         0PvpoMoUHnyaTJXBg3y9rOuQrbQ6zEVmysHARE4qc0Nf1fadh3twrgSrmoZH3zwv6eVS
         2/uA==
X-Gm-Message-State: AOAM533E5mRYvp1raXw9xhvBWJ/gajTO5/yaLM7EKe23eKEWEorzzK2V
        dwQv4LdD169T81z8EaTul/o++cXbmOY=
X-Google-Smtp-Source: ABdhPJx9SmZOxNS6j3ihEnMnr13homYKKTs59ipLWSyQycw4aGW+Ua0K5nzaagC5oZwG0l8tyEqxjA==
X-Received: by 2002:a19:5f4e:: with SMTP id a14mr3385842lfj.57.1588977316606;
        Fri, 08 May 2020 15:35:16 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-22.NA.cust.bahnhof.se. [158.174.22.22])
        by smtp.gmail.com with ESMTPSA id s11sm2316501lfo.86.2020.05.08.15.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 15:35:15 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH 3/4] crypto: hisilicon/zip - constify struct debugfs_reg32
Date:   Sat,  9 May 2020 00:35:01 +0200
Message-Id: <20200508223502.7258-4-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508223502.7258-1-rikard.falkeborn@gmail.com>
References: <20200508223502.7258-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

hzip_dfx_regs is never changed and can be made const.

This allows the compiler to put it in the text section instead of the
data section.

Before:
   text    data     bss     dec     hex filename
  15236    6160     480   21876    5574 drivers/crypto/hisilicon/zip/zip_main.o

After:
   text    data     bss     dec     hex filename
  15620    5776     480   21876    5574 drivers/crypto/hisilicon/zip/zip_main.o

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 37db11f96fab..6934a03d21e1 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -165,7 +165,7 @@ static const u64 core_offsets[] = {
 	[HZIP_DECOMP_CORE5] = 0x309000,
 };
 
-static struct debugfs_reg32 hzip_dfx_regs[] = {
+static const struct debugfs_reg32 hzip_dfx_regs[] = {
 	{"HZIP_GET_BD_NUM                ",  0x00ull},
 	{"HZIP_GET_RIGHT_BD              ",  0x04ull},
 	{"HZIP_GET_ERROR_BD              ",  0x08ull},
-- 
2.26.2

