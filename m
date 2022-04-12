Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C4BC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Apr 2022 09:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353148AbiDLKCF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377925AbiDLHyl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Apr 2022 03:54:41 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8826D5047A;
        Tue, 12 Apr 2022 00:31:55 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 23C7VnrD012170;
        Tue, 12 Apr 2022 02:31:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649748709;
        bh=vSHKAce0PuZloOOm4qVWYzbOX8w6lDDgPlaHriTZ10M=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=JqDbimH7940kctnxRkiuOG++gKolPnJBGU4z23O+P94wp9ar6/UclfGFIFiUFE+ps
         B2Gu7thtSLJqbLZKMq/ziQE/GFBTt0XNyduZpVHR36MTBqw22imQOPZvIxMJIHr2Mx
         bcDdiq2H0iNDjGhKLtlzzG7/+WQFW49qNmDo5wXE=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 23C7VnVM057477
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Apr 2022 02:31:49 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 12
 Apr 2022 02:30:21 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 12 Apr 2022 02:30:20 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 23C7UKhI026798;
        Tue, 12 Apr 2022 02:30:20 -0500
From:   Jayesh Choudhary <j-choudhary@ti.com>
To:     <linux-crypto@vger.kernel.org>
CC:     <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <krzysztof.kozlowski+dt@linaro.org>, <j-choudhary@ti.com>,
        <robh+dt@kernel.org>
Subject: [PATCH 2/2] crypto: sa2ul: Add the new compatible for AM62
Date:   Tue, 12 Apr 2022 13:00:16 +0530
Message-ID: <20220412073016.6014-3-j-choudhary@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220412073016.6014-1-j-choudhary@ti.com>
References: <20220412073016.6014-1-j-choudhary@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the new compatible for am62x in of_match_table.

Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
---
 drivers/crypto/sa2ul.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 51b58e57153f..6957a125b447 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2379,6 +2379,7 @@ static const struct of_device_id of_match[] = {
 	{ .compatible = "ti,j721e-sa2ul", .data = &am654_match_data, },
 	{ .compatible = "ti,am654-sa2ul", .data = &am654_match_data, },
 	{ .compatible = "ti,am64-sa2ul", .data = &am64_match_data, },
+	{ .compatible = "ti,am62-sa3ul", .data = &am64_match_data, },
 	{},
 };
 MODULE_DEVICE_TABLE(of, of_match);
-- 
2.17.1

