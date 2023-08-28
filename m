Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112D8C83F18
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Aug 2023 10:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjH1KaQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Aug 2023 06:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjH1KaA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Aug 2023 06:30:00 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ED7B9;
        Mon, 28 Aug 2023 03:29:57 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-31c71898109so2593854f8f.2;
        Mon, 28 Aug 2023 03:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693218595; x=1693823395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0nfoZacKfC8O6Up1SVSmQB7bbrUKT3oInnw0Jj2eo5s=;
        b=Dg3wO/WdwRwUD/Rja5Y7xMQgeCbuzhyA+bklSKy5Oe2rAza3+Bi+cGLuDzK3Wj6ShE
         gT9h7Dy+zEFT//mmpIF/ijdJRSeVOhOd4HPjzcAhxKoLL8cyfZqe2XJLJ7N/kJ2vw03x
         GD1rd3jcuET0XOvKQwNbYMQd+G/5Rhn0lQU3YcImoBlshwTdBNBiky6epBMZr1Lz5uLv
         UfitxxJ4Pxo9iCD5DwiZ6W1Syo0CDMteNfI5PzBXFNN2Z7Fjs8qk3pj8PCQ1zoWE54EC
         PM6RXYnSCJhQUSKMI1whRMGlBcfVg+U3bGkIsNBqwQyyUbLVCfDlaWF3LhA6aoxgJ+rq
         w5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693218595; x=1693823395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0nfoZacKfC8O6Up1SVSmQB7bbrUKT3oInnw0Jj2eo5s=;
        b=NZyZWkyTZJAVi20kuITsnDzlSBGFR0E0vwWFTlzLWPA+rqaNXKv14yVoO4HSJZSRY7
         OkSEM3giwbv0G8H9B0DIchmD7CZBsxUNJukT0ZchMj3Bss6yZRAtB7uDE/2L+da2nSid
         UG2ovRfoeM/aft/3fb7Q9iDmP77qSGOmM8ZNgW6jJXisDQ0SWH7tUshNyYGLDdvm3vNJ
         8q1OV+NJAu++PAjr7F2LThdjflM5H7pqJ12MVKRWLL46uBZ97dR1/5qDfgRP8yTd+Llt
         w/vhmp1l89K0rTjRjw48GGgbRA9AxFslTL/irfXTj8bD2c17TrdDj/ODULIaPh+67HpR
         NZ5A==
X-Gm-Message-State: AOJu0YzGVUUQd6VDt4lH6hl2LOCJGnSAJfRRQNP+0DhQ651isUMHWA/L
        R++ueV3JXR045PXr7RJY7M+qb1zBhfc=
X-Google-Smtp-Source: AGHT+IHAEt5cTKjwh9q8g6xo+HcNSP4aT9W4TVgCnYK3PmD6ec0saGlePeb/k9ELi7HFo/z9wvgsjQ==
X-Received: by 2002:adf:fd04:0:b0:319:6e43:7f6a with SMTP id e4-20020adffd04000000b003196e437f6amr19619606wrr.30.1693218595553;
        Mon, 28 Aug 2023 03:29:55 -0700 (PDT)
Received: from localhost.localdomain ([92.85.190.61])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d6609000000b0030647449730sm10105354wru.74.2023.08.28.03.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 03:29:55 -0700 (PDT)
From:   Andrei Coardos <aboutphysycs@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, olivia@selenic.com, alex@shruggie.ro,
        Andrei Coardos <aboutphysycs@gmail.com>
Subject: [PATCH] char: hw_random: xiphera-trng: removed unnneded platform_set_drvdata()
Date:   Mon, 28 Aug 2023 13:29:43 +0300
Message-Id: <20230828102943.21097-1-aboutphysycs@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This function call was found to be unnecessary as there is no equivalent
platform_get_drvdata() call to access the private data of the driver. Also,
the private data is defined in this driver, so there is no risk of it being
accessed outside of this driver file.

Signed-off-by: Andrei Coardos <aboutphysycs@gmail.com>
---
 drivers/char/hw_random/xiphera-trng.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/hw_random/xiphera-trng.c b/drivers/char/hw_random/xiphera-trng.c
index 2a9fea72b2e0..1fa4b70246f0 100644
--- a/drivers/char/hw_random/xiphera-trng.c
+++ b/drivers/char/hw_random/xiphera-trng.c
@@ -122,8 +122,6 @@ static int xiphera_trng_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	platform_set_drvdata(pdev, trng);
-
 	return 0;
 }
 
-- 
2.34.1

