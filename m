Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44637C433ED
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28808613D6
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhEEU1p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 16:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbhEEU1d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 16:27:33 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862C6C061346
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 13:26:34 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s8so3208538wrw.10
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 13:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vYMZs827CCgGeByzUj4j7pW9fP2E9jrzGT2N7JqFOmo=;
        b=aH9B3BMda3KPWti9Uu3E+DFfMK8Ml+sFvIdbE9z2GmHM6CfWdLsV2svGgW8yptBhwT
         NkNziXFpqeB01HGlJys6F3mzCIRd9b9UtKIwO7vmBT3SzU698aHvvv4BlkiND3RFOTdo
         haa8tkrt414eUT+W7v6H7L0UNnKaFrFkbVdKHOYmNoRagzoBU4hUqfYeLpMuNPwx3gZ1
         H45lH23u26reF8EjyRwpuUfiTpPkRRXIQT+68QkpZn3BKX4IH1hvN0bbHf2esWIeC11U
         KiXQxDxAlD1DOz/s4qvvHja4r0Gh/OvGepk0xmDNX9xQrG0+QML9J4TiBJTcPrtz6JPs
         vWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vYMZs827CCgGeByzUj4j7pW9fP2E9jrzGT2N7JqFOmo=;
        b=cEMLbhdnsL5swlqfEtG8LSGbl2E7SPvp5123DnGd6DResTz2PqU0lv1gm1urUCKeUi
         tAiqxWyZeVu1bM9rMm48V8FULCwIg7wFpvJvAB4dfqeISnHjOSmWH4q44KGQzj6n68U1
         AMD5rfwtheC0+hsET75CsFpljhg9GXWL92AUU7ws2RKQCDK9kHRQ2NjvBwyiV3aI6ij+
         kMggGdX2RKzILNev/IrjVdv6y+Dgm+bfBrLzpeJs/IRLGpik6GIebK53MtMK1ePBFsHV
         SYyd1CZCrv7jm3WOQPHPF5FsUR2go28VQlDM+ncgCz9RgCwnsd7S8qS6V5EyIt4EiiIE
         qPnw==
X-Gm-Message-State: AOAM533fpFTnp0JAs/o2GwRvO6FMc7ZdOQaqkz/UVlIQArBzY8kqFz8g
        P0vN7BDAsoJPN7fVJONn4IMCUAbNsMmX2tWA
X-Google-Smtp-Source: ABdhPJz8cK9jkEScVMSlG14YK2z2FbESXG3ybOXPeTvttlkfdC9shPN0TKFfu9Enj8x69G+Jmbdi3A==
X-Received: by 2002:a5d:6302:: with SMTP id i2mr871368wru.237.1620246393285;
        Wed, 05 May 2021 13:26:33 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id a15sm497245wrr.53.2021.05.05.13.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:26:32 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     chohnstaedt@innominate.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 10/11] MAINTAINERS: add ixp4xx_crypto to the right arch list
Date:   Wed,  5 May 2021 20:26:17 +0000
Message-Id: <20210505202618.2663889-11-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210505202618.2663889-1-clabbe@baylibre.com>
References: <20210505202618.2663889-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

drivers/crypto/ixp4xx_crypto.c is missing in the IXP4XX arch file list.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c7ffe0028387..351617dd019e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1974,6 +1974,7 @@ F:	Documentation/devicetree/bindings/interrupt-controller/intel,ixp4xx-interrupt
 F:	Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml
 F:	arch/arm/mach-ixp4xx/
 F:	drivers/clocksource/timer-ixp4xx.c
+F:	drivers/crypto/ixp4xx_crypto.c
 F:	drivers/gpio/gpio-ixp4xx.c
 F:	drivers/irqchip/irq-ixp4xx.c
 F:	include/linux/irqchip/irq-ixp4xx.h
-- 
2.26.3

