Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF85ECAAA3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 09:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245712AbiHZJMJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 05:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245551AbiHZJL6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 05:11:58 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC85D6BA7;
        Fri, 26 Aug 2022 02:11:56 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27Q9Bil5015593;
        Fri, 26 Aug 2022 04:11:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1661505104;
        bh=+46x+HLUlBkt4yUclJTZivGkoE1QCQMQ73VLUsdQx2A=;
        h=From:To:CC:Subject:Date;
        b=ZgWXmP4RyxPlK6xTtNVVOv+11sNpwNoPv84sQ4+qvDVvkA0NETeLKnpGW4JpUzxR4
         zq64RoFD0mczNjSTqpArSeJTLLJv1+qXngiIwOiSQdTV8e09voXfAPZHGD+RcT7M4C
         7k/3gHit2DwtCOmRT8DISPCgeeGGue/HNWflPDVk=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27Q9BiEI045059
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 26 Aug 2022 04:11:44 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Fri, 26
 Aug 2022 04:11:43 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Fri, 26 Aug 2022 04:11:43 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27Q9BhwG130182;
        Fri, 26 Aug 2022 04:11:43 -0500
From:   Jayesh Choudhary <j-choudhary@ti.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <j-keerthy@ti.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH] dt-bindings: crypto: ti,sa2ul: drop dma-coherent property
Date:   Fri, 26 Aug 2022 14:41:42 +0530
Message-ID: <20220826091142.262325-1-j-choudhary@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto driver itself is not dma-coherent. It is the dmaengine
that moves data and the buffers are to be mapped to the
dmaengine provider. So this property should be dropped.

Fixes: 2ce9a7299bf6 ('dt-bindings: crypto: Add TI SA2UL crypto accelerator documentation')
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
---

Resending the patch as it got ACK-ed but did not get MERGED.
(https://lore.kernel.org/all/2935fd8e-ceda-fec9-db47-65d3ec142e32@linaro.org/)
We get some warnings which are expected. I will post the dt-node
fixes once this patch gets merged.

 .../devicetree/bindings/crypto/ti,sa2ul.yaml        | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
index 02f47c2e7998..0c15fefb6671 100644
--- a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
+++ b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
@@ -35,8 +35,6 @@ properties:
       - const: rx1
       - const: rx2
 
-  dma-coherent: true
-
   "#address-cells":
     const: 2
 
@@ -72,16 +70,6 @@ required:
   - dmas
   - dma-names
 
-if:
-  properties:
-    compatible:
-      enum:
-        - ti,j721e-sa2ul
-        - ti,am654-sa2ul
-then:
-  required:
-    - dma-coherent
-
 additionalProperties: false
 
 examples:
@@ -95,5 +83,4 @@ examples:
         dmas = <&main_udmap 0xc000>, <&main_udmap 0x4000>,
                <&main_udmap 0x4001>;
         dma-names = "tx", "rx1", "rx2";
-        dma-coherent;
     };
-- 
2.25.1

