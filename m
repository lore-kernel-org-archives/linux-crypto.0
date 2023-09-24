Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED00FCE7A8A
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Sep 2023 22:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjIXWbX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Sep 2023 18:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjIXWbW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Sep 2023 18:31:22 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8062EEE;
        Sun, 24 Sep 2023 15:31:16 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-27197b0b733so937261a91.1;
        Sun, 24 Sep 2023 15:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695594676; x=1696199476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OYPPEX4P1Ut3e7hG5n83kkTnAQomwDxAgC/ac8iNUyc=;
        b=fD/5U7LsbHAsForTjTZ0fiZJFiLYH08mlhCF68Q2qrKhgiOqphpW4Dwiau2/edNlFN
         oMATm3v8ChpA3DcxWD0rVo2iPzLh3TPwYBpfVfbSSEdqNInY5/H7R7YXZYcpP2/39hwa
         3W45I7n040xhIu5rEQOabWTsNBQPvV8Ki8inLXHebu1I3GFR0jynQgrmSyu9AOCE4y0r
         AXNA7AfazylHx/EQiOeTDq3aJ8dU+7h3kdksykvoUJOPaL7zcZxeCjfqI2XyBxESVbUN
         nLddlryQo/0zOt3+Gm2Ws7/sIqEW/VT57qy7X5Squwd8yLjMMUr1vY4GmCRtjXZECQ10
         x19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695594676; x=1696199476;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OYPPEX4P1Ut3e7hG5n83kkTnAQomwDxAgC/ac8iNUyc=;
        b=nq7xWTG32sHXu7OcUCIkXo8vOnDdenJ6+yDIXcaG/bVT2msTV7WJahTEUTVqnqUBrf
         r2Q7GwXTy0nKk/4G1+aNu0mAKeBuBSlJKmkwgLldgAra62Jo9nOtlxwou5otQYkn81CP
         IXUaK5xXbS4mH2x+abRe4bzM7Z1H+k3EfgVE5u5ISTCnyduAuHMksvGaDwb9OnfrAJg1
         ORy9AtF27CXex0zM5Mas8oyY7YVPgSkj3LrwzKVw9qXyop9orqOHuc749tZKeuiM2izp
         YsS6xvz8cnf7/oWB6Vpo7nMwLzxflLkR8yoet4Wo7CsUE3JApA/DWyqcGIKWpDDvBw5g
         8Nyw==
X-Gm-Message-State: AOJu0YzCqhp3EVMOmUTgE6lwFJT5mBTnC/7KXk0rr0YR6qwCuyFRqgWb
        J43gHhAvTeqNUYFiuSOhXN0=
X-Google-Smtp-Source: AGHT+IGgsCuZrm/i5f3t1rD1dFRWX/AbZuA+dNxk5oi33oB/Npcz+CqkriL4sLiyS1uzG+KL+EPrEw==
X-Received: by 2002:a17:90a:bc9:b0:268:38a7:842e with SMTP id x9-20020a17090a0bc900b0026838a7842emr4643854pjd.2.1695594675871;
        Sun, 24 Sep 2023 15:31:15 -0700 (PDT)
Received: from fabio-Precision-3551.. ([2804:14c:485:4b61:ce8e:216e:1d92:cabc])
        by smtp.gmail.com with ESMTPSA id 5-20020a17090a1a4500b00274e610dbdasm9315258pjl.8.2023.09.24.15.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Sep 2023 15:31:15 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@denx.de>
Subject: [PATCH 1/4] dt-bindings: crypto: fsl-imx-sahara: Shorten the title
Date:   Sun, 24 Sep 2023 19:31:01 -0300
Message-Id: <20230924223104.862169-1-festevam@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

In the title, there is no need to mention "included in some i.MX chips"
as it is too vague.

Remove it to make it simpler. 

Signed-off-by: Fabio Estevam <festevam@denx.de>
---
 Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
index d531f3af3ea4..c7da09c58eff 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
+++ b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/crypto/fsl-imx-sahara.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Freescale SAHARA Cryptographic Accelerator included in some i.MX chips
+title: Freescale SAHARA Cryptographic Accelerator
 
 maintainers:
   - Steffen Trumtrar <s.trumtrar@pengutronix.de>
-- 
2.34.1

