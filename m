Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75F1CE7A8D
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Sep 2023 22:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbjIXWb1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Sep 2023 18:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjIXWbZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Sep 2023 18:31:25 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703CBEE;
        Sun, 24 Sep 2023 15:31:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-2773b10bd05so333557a91.0;
        Sun, 24 Sep 2023 15:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695594679; x=1696199479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X08/Fgz2Lymvqwv76PNkcekanOGwDL7/fXB8WXjIcSc=;
        b=A50WcCGrBEj4s52yKtRn3YoedPXKCwya++4s0JpBm4ZBd1jh7TWjMXo5mVlA/sKxyU
         48AVDRuE3TX+cbM0xXn6UHY55+tnoePilg/N8acQQtaKyWDyGYKMX2VAM/N4gjNB8xoJ
         XrQucBvqt6G3eUUiWaOFIbYFaIXCYaB+sbOWfN6kmjlEBygqn+g++eXVypE3bvijGX59
         pB43i6H85ir5FBKJYu0xALeTS689yYxlP8Cnc54jU0AkYQV/PzclvFlSMsCmB740g8dV
         Y0R7KfdR2MidU3gEXcSSjpbmMMk7WulDoVJ3xk7BYAFalW7086MxjxfxdWISbfqYsuIp
         orWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695594679; x=1696199479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X08/Fgz2Lymvqwv76PNkcekanOGwDL7/fXB8WXjIcSc=;
        b=WuzN6DpRWclhpC2dIEer6nNQQz7bAmrjfOvyQO5aV0qzKmIXcPKxczER20JfJTL1TM
         aXvHvPGkdaPMGgk5Et1jKpQU+ceJeVlLMGcKh4kZ1Mb5wT2Zgm94AdFt9Y9sSLmPw1+D
         gmOz9bNCN0qMrgiKxHJH9Gf9x/mfyzRKMCp7/nIVm+et9C6fTbts72aI3FJ4/yjRo+pq
         /4cy0jKTQ2W3YEuVt/E2yKU+KJQNzZw+NWnvulGEF7GhhwlH35aHgp0rdPTmPjwelNLJ
         Ceg+oBpvuutl2Yh0hSoKpAApHclBJzcd6EdQTMMD90SH55BdiLdFm3+y7+NxwFGQUCvf
         k/dQ==
X-Gm-Message-State: AOJu0YyBZYtvk02kW6easN24exeqru19EZHQRnq+l0RMaHKhv2IBokKy
        78i7a78dqA2R2YgIKSzvmwY=
X-Google-Smtp-Source: AGHT+IFoDZFKkRCqujOdwweFYdqk5NfCSOj3GYURQUN+/UZ+K3PO8HfR2Jcv/RIl4XJTb2nodsXC6A==
X-Received: by 2002:a17:90a:51a2:b0:269:34a6:d4ca with SMTP id u31-20020a17090a51a200b0026934a6d4camr4870679pjh.0.1695594678830;
        Sun, 24 Sep 2023 15:31:18 -0700 (PDT)
Received: from fabio-Precision-3551.. ([2804:14c:485:4b61:ce8e:216e:1d92:cabc])
        by smtp.gmail.com with ESMTPSA id 5-20020a17090a1a4500b00274e610dbdasm9315258pjl.8.2023.09.24.15.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Sep 2023 15:31:18 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@denx.de>
Subject: [PATCH 2/4] dt-bindings: crypto: fsl-imx-sahara: Remove leading space
Date:   Sun, 24 Sep 2023 19:31:02 -0300
Message-Id: <20230924223104.862169-2-festevam@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230924223104.862169-1-festevam@gmail.com>
References: <20230924223104.862169-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

Remove the leading space in the reg property as this is the standard.

Signed-off-by: Fabio Estevam <festevam@denx.de>
---
 Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
index c7da09c58eff..bad82491cd6a 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
+++ b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
@@ -32,6 +32,6 @@ examples:
   - |
     crypto@10025000 {
         compatible = "fsl,imx27-sahara";
-        reg = < 0x10025000 0x800>;
+        reg = <0x10025000 0x800>;
         interrupts = <75>;
     };
-- 
2.34.1

