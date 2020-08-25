Return-Path: <SRS0=bFPd=CD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD638C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 13:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5527206F0
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 13:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="L4eZVYFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgHYNb2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Aug 2020 09:31:28 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:38578 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgHYNb0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Aug 2020 09:31:26 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07PDVJPZ081654;
        Tue, 25 Aug 2020 08:31:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598362279;
        bh=LCD4vBAgvcIC3DKR49TzRBSosI+1bVx/jmA6X91qXXc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=L4eZVYFv+w7m0XhVqA1XpWkpHAN9FiKsFAaMszI206O3TrL39Yq1e2TTlOexTf65p
         /EXhZq66efxhbUHI2StuKt6WWEBIsHQ+/3jmZYoS5TAy1a9JOn/gwdURU+WuwKL5u4
         3IFMnhd+ikvEUOZ42wJjdlKc2N6Nj7As8XizE9cA=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07PDVJYI016370
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 08:31:19 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 25
 Aug 2020 08:31:19 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 25 Aug 2020 08:31:18 -0500
Received: from sokoban.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07PDVFrx046832;
        Tue, 25 Aug 2020 08:31:17 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     Rob Herring <robh@kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH 1/2] dt-bindings: crypto: sa2ul: fix a DT binding check warning
Date:   Tue, 25 Aug 2020 16:31:05 +0300
Message-ID: <20200825133106.21542-2-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200825133106.21542-1-t-kristo@ti.com>
References: <20200825133106.21542-1-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DT binding check produces a warning about bad cell size:

Documentation/devicetree/bindings/crypto/ti,sa2ul.example.dt.yaml: example-0: crypto@4e00000:reg:0: [0, 81788928, 0, 4608] is too long
	From schema: python3.6/site-packages/dtschema/schemas/reg.yaml

Fix this by reducing the address sizes for the example to 1 cell from
current 2.

Fixes: 2ce9a7299bf6 ("dt-bindings: crypto: Add TI SA2UL crypto accelerator documentation")
Reported-by: Rob Herring <robh@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
index 85ef69ffebed..1465c9ebaf93 100644
--- a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
+++ b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
@@ -67,7 +67,7 @@ examples:
 
     main_crypto: crypto@4e00000 {
         compatible = "ti,j721-sa2ul";
-        reg = <0x0 0x4e00000 0x0 0x1200>;
+        reg = <0x4e00000 0x1200>;
         power-domains = <&k3_pds 264 TI_SCI_PD_EXCLUSIVE>;
         dmas = <&main_udmap 0xc000>, <&main_udmap 0x4000>,
                <&main_udmap 0x4001>;
-- 
2.17.1

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
