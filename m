Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35A6C4332F
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 19:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiEHTWB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 15:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbiEHTEW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 15:04:22 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470A3DFAF
        for <linux-crypto@vger.kernel.org>; Sun,  8 May 2022 12:00:23 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id q20so7290445wmq.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 May 2022 12:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nfRYAmvDSOfkn9xCnjz0sEuzUzffI51ibzudBubF+DM=;
        b=JbtmNvF8ZkRrmp0ZVDodTU7WGYDq/nJm5K36IhG0xquVIIW4xufQWZm7uzfcVk27MZ
         lirnIjLT4sWIjLTkJSy6Ba9N3kz4F4f8oTL7JiC85NXLlCCmFD1OJEg7C7Qi+VzC6SGU
         CL/ff6uZYMgNmZJ++ZtPmceDlgFhTBOUleq3ooznPJNWslMiiXR9u+6JUAIpeUrZQ6L6
         vqCaans+gc7FQxTlqKsCgfAFE16dnqOs7nP3AwPdbU1p7hEdCX9OXPT3jfixxHcwzcoZ
         ck4mAdzN127Vw/XTLuAwVAVz8qTWF4kulGqzP0DvMo/aqLZ3IPfyhWrTGrxgm8RTb0dc
         QwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nfRYAmvDSOfkn9xCnjz0sEuzUzffI51ibzudBubF+DM=;
        b=w8Laa8MUtm9iqR8mOOoaFkyenhJr8Aj/bYZE5HeboW2CwXHxWkzUkAWP9yElhBwGhg
         FiB+NIRjA5wtb8mov4ND+3v3qwTUFzQoqCgtU63uJd19zjf9PbVLlLo8vVtIodUULmbA
         tBt+1N6BUIQoXm8haHIfqGdU4I2yt6Xlb+DpU04unbHCXYNcz4Qd9MNj8giLQ3lrpR0m
         icWn75Dw/qsEwgPl5AdiYI13LWde45BFnuvnNRc+J6+hp6l4H7yy9SXZhf62DOef3xDE
         kTSEmOHGcZwzcZutc9fCmwSwk0qxVq3zOQ2kpubiddkMnTtwtgSyamPaP3xbdAW06npP
         Xprg==
X-Gm-Message-State: AOAM533B7tgm+DSzD217XVsbUWJG33lCpTzxq604T4/T2Kodlwqpt7SJ
        rwU2NYCm8e3AvTuZ84d8ZHkPOg==
X-Google-Smtp-Source: ABdhPJyyKOdVyYhTCQquA5X3hW0+KtTAcADNYPmxezkDmayc+tb1Atxs9r1zLvCxNR9rBZ2DltO3Sg==
X-Received: by 2002:a05:600c:3388:b0:393:ed53:4ee6 with SMTP id o8-20020a05600c338800b00393ed534ee6mr18991538wmp.1.1652036421657;
        Sun, 08 May 2022 12:00:21 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05600c3b9000b00394699f803dsm10552348wms.46.2022.05.08.12.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:00:21 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 16/33] crypto: rockchip: add myself as maintainer
Date:   Sun,  8 May 2022 18:59:40 +0000
Message-Id: <20220508185957.3629088-17-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Nobody is set as maintainer of rockchip crypto, I propose to do it as I
have already reworked lot of this code.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d4d4aa20fd08..d673e7ae3872 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17026,6 +17026,13 @@ F:	Documentation/ABI/*/sysfs-driver-hid-roccat*
 F:	drivers/hid/hid-roccat*
 F:	include/linux/hid-roccat*
 
+ROCKCHIP CRYPTO DRIVERS
+M:	Corentin Labbe <clabbe@baylibre.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
+F:	drivers/crypto/rockchip/
+
 ROCKCHIP I2S TDM DRIVER
 M:	Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
 L:	linux-rockchip@lists.infradead.org
-- 
2.35.1

