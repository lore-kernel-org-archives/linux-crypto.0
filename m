Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54550CE7A81
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Sep 2023 11:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjIYLMy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Sep 2023 07:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbjIYLMx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2023 07:12:53 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6350C0;
        Mon, 25 Sep 2023 04:12:43 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-6927528c01dso965159b3a.0;
        Mon, 25 Sep 2023 04:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695640363; x=1696245163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uq4NPhSzxqypY2uN0jYUqe7Hvuv2Db/rhjFJPE8U29M=;
        b=M42mMMBdEpLrdIQIcrEmKxbcmoSY3gAKhpI8SCr8J0ludBbpM/bVDpMf70kr34T0Y9
         PeC5sPWuU5aLpf0uGt6qg8/9mpNcInFdb3aIm2QqXBW4fbqIAFI7d3kJQtdte1pNtAsP
         M+H0egXVO833PLrYNVM9iueKW2Vsyf2X/de61gCZ8XUEkZ8ftlwyn24wY30RpcnuuxHg
         Kp/igCPZAmGk4T1NR1Gg6Y37lxzdmQD46cSUg9RTlfffmJzIn9lV/hNF5FKkYFADdkX+
         xKHV430kKs83amyqKv4l6vkkTx6mgxvTsygGY2Mi+vQpYoo5mFuUtBok+WrhvHHjDpJP
         fKgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695640363; x=1696245163;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uq4NPhSzxqypY2uN0jYUqe7Hvuv2Db/rhjFJPE8U29M=;
        b=aMv2i+sS1k+zpkdEWNehaldpFA9vbcvz6Albaj5zJtGXA5tO/aavEyjBDRhRdYVUFG
         61bC5V3I4Bu4zjYuTd0UlbXfpFBRx+ict/Vxn9Iupf2p/4tdNWoSyz9jOMHYVid0u5LN
         bsnpPpRkB69hDO0JiyjbUiLnl4r2Foquos5Eq7xvGBqRuekpAt6LAAlCbWyJunfgvg4o
         eAUp9JGq/y342BqqKema7z/3Fx/kYGMip8pJXrXgsbabRGvp8qqY0B+9xNr9iOnhvluh
         a1xLxr098p/E3KQRE01vVsX9Yogk+yi65vEEtMMs9VW6w7thZnC7pMwlAP0J6ar/ZklY
         633A==
X-Gm-Message-State: AOJu0YwRTMXyARQAhFeck853JMOyGEXjpyBav5pYXKtF9fKB1srOXJD1
        kM4Uzhs1MOHjj/xC2HRIppw=
X-Google-Smtp-Source: AGHT+IEQXmRz8MMHegXa6LToyXN0/clS+jq/kPQf5mZ09Gu5T9cXw4V+pF7fqgUsi7HaZJQHV0bS0g==
X-Received: by 2002:a05:6a00:2f4d:b0:68f:c9f6:f366 with SMTP id ff13-20020a056a002f4d00b0068fc9f6f366mr7621167pfb.0.1695640363052;
        Mon, 25 Sep 2023 04:12:43 -0700 (PDT)
Received: from fabio-Precision-3551.. ([2804:14c:485:4b61:fbad:220b:bad3:838c])
        by smtp.gmail.com with ESMTPSA id 131-20020a630289000000b00528db73ed70sm7832772pgc.3.2023.09.25.04.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 04:12:42 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@denx.de>
Subject: [PATCH v2 1/3] dt-bindings: crypto: fsl-imx-sahara: Shorten the title
Date:   Mon, 25 Sep 2023 08:12:18 -0300
Message-Id: <20230925111220.924090-1-festevam@gmail.com>
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

While at it, also remove the extra space in the first reg entry.

Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Changes since v1:
- Squash the removal of leading space. (Krzysztof)

 Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
index d531f3af3ea4..bad82491cd6a 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
+++ b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/crypto/fsl-imx-sahara.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Freescale SAHARA Cryptographic Accelerator included in some i.MX chips
+title: Freescale SAHARA Cryptographic Accelerator
 
 maintainers:
   - Steffen Trumtrar <s.trumtrar@pengutronix.de>
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

