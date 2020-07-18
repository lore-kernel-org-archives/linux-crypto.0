Return-Path: <SRS0=nnFP=A5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E2CC433E1
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Jul 2020 09:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E463020691
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Jul 2020 09:44:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="GG43Kw2y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgGRJo6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Jul 2020 05:44:58 -0400
Received: from mail-eopbgr80131.outbound.protection.outlook.com ([40.107.8.131]:3148
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbgGRJo5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Jul 2020 05:44:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bf0yYpiNSu0ULloJyKQqpBzod+b8gR/0WXpQkAGPUjcnnCScaCXSZi/cTsfbNicvzrAEcpkVH5rp1WZnFRVSyxRWLpIuybdK8BgG9jRicYpD4EAFQfVclVp2WIUVWteUdfdX0VtWr+OPpBgAZ0ftShyS21z9feYzxHUGRbIkAVyUpACtBoTpIvMgBhSbMysa/gIqowjIXFIOOAlI8+AXjRmR67IAbORyqbPQPms7NeHBiqjx9GW7zvnu8nMJeDowo5MTmKE5AmSptZi/RhGCnAThd/wo5B7S5LSzUKS+BD2u+EHP21JN8n7qiAF3HLa+MeyZl0pAE1ndyCtyMxXRUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8ZSw/xrM6ZCZZnYf9Edc/M8FdPff33cKpysnhkPFp0=;
 b=DARdxbQ+0anpZAzfYbllh5Ew3cO2+HMjxxgmnNZ35cKotYwroQsNMqGXeoKf5ui0ZnvMqCjC+T6djhs40ef+POMfusDq6qvtRR8nk3sTMyvKo+IWGWlUvI1W5gQdPtDGg4t7noPkO3tktWdBvETAtF5wQed6ULeMX7TcqI2TufieYM/L9IOLurpfqfxlsTcBRPbzUpWdC0rQF16AGoESUCUgk90UDyjBzN/mhJ9Lh4fNf7qXxmNz5/OnvjQgbJc72oJ/ldIMq3jCkyj9lZVyUjxGe9JE2EdVOoWei0cWeyf3/8lO57669sUOLYpkbj5AXdPn1MoxdoN3u/0CT3hIhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8ZSw/xrM6ZCZZnYf9Edc/M8FdPff33cKpysnhkPFp0=;
 b=GG43Kw2yOsDhAvPgDcS7qZSkVnEmncOQli/KAZ3JkDsJAoDvhLGZ/wX23eGDA67aJXtIXU4IoHTDzLVvPDirvDO5s3EaTzYqLg87FngV65Os6wFLYaz8IjnvFjtYnQubfVq6ujCTfWZkZ0IIUbBAUDhL6UL5bfZxNIyZyFdGeQA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR05MB3396.eurprd05.prod.outlook.com
 (2603:10a6:205:5::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Sat, 18 Jul
 2020 09:44:55 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3174.027; Sat, 18 Jul
 2020 09:44:55 +0000
Date:   Sat, 18 Jul 2020 11:44:53 +0200
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au
Subject: [PATCH 1/1 v2] marvell cesa irq balance
Message-ID: <20200718094453.72lpwi47jckhg4tv@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM3PR05CA0086.eurprd05.prod.outlook.com
 (2603:10a6:207:1::12) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (109.193.235.168) by AM3PR05CA0086.eurprd05.prod.outlook.com (2603:10a6:207:1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Sat, 18 Jul 2020 09:44:54 +0000
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 843d7d03-3fbc-46aa-e838-08d82aff39c7
X-MS-TrafficTypeDiagnostic: AM4PR05MB3396:
X-Microsoft-Antispam-PRVS: <AM4PR05MB339665DFEDD010F3F176693EEF7D0@AM4PR05MB3396.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:556;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qtn4gK3pjL1OM+j911lZwNcGKzdYmVQNIyrlQD5wkqhnxPHCRvcaVa95RTB92lX2EwtsFqIlsED0Ns27qCThgw+hPs3XLgCJQyDiXeGIjtNjuL3S6OPozl8av183JH+6eAuMd6QsrDYCwhW+S4Oh9zoRqsqqhxvpiXD10AaHj09HmYks27Fg6qhryDlBntpwhTpL/dUEDjZBgwJOWCSH5wbW+vnsY/OkdaYb41S1zXDY2Fax1+kBu1p798utp3LsYKlPiK+mbev2oGGTCv8skeYUv/4qVx1NNC4+g1j32MJJiHEurQY/aqySv1nwHhLTuxTJ21oftOFMxzIKHFlXsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(396003)(39830400003)(136003)(316002)(5660300002)(2906002)(6916009)(66556008)(508600001)(83380400001)(8676002)(66476007)(66946007)(8936002)(6506007)(1076003)(956004)(4326008)(7696005)(16526019)(26005)(86362001)(52116002)(186003)(55016002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: MdCyegufhrBKlQTUTN+pbv5QacmiYdt27I9vL6qCh8LgOM4VyVuhTD4e9i334jQ6Huzw9irHXwyzHWQ9KBYPQNJ8fEZD4+Rw9LzmsLi5DnzZGwjV/scjNpbj7HVS8RuA9rlUAuGeRpe/upGsMqF9rUgtaDkDx3eijeC/eHRyG1ERFtNf9TBL4flNENeg2atZf8QA5qiSgmK1faSK2fbJX4GQQFkF8J4Zquj0Ox7nuXVgDIkKuzIwyvXtnhIc8VCPOA75M+LewAIsLPKywZyUcp06CH9//NhFS9inJPHM+hKfZD450jE2mG3CNdAzr7Ely3rhro3OeF6Ux+bK3XCfC2s54x7crN1b9+uOpMEWnoCTcUbVHQR3rIEh9A/VVUlAUhXD9gevHQlHWW56JA1BLw37oIsthQ//zBf2y/Y93d/bfVzZq4g2J69TO18sPKhWyIreHGODfsAvXjXlZ9SHR7u0Sjpne0QJOKLZF1iqAQqxzEWGimonfVVNCzQAnkxe
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 843d7d03-3fbc-46aa-e838-08d82aff39c7
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2020 09:44:54.9673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npUvLxZU4E/k4dbfPn2DHxl782DwYz3QF75jkLWNU0QZa8rYAS2A+7gwdDHc8Btr/kZG3GpxmG8v+SlVUkSEH7s1dvfNdFDJZhsoYLfywTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3396
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Balance the irqs of the marvell cesa driver over all
available cpus.
Currently all interrupts are handled by the first CPU.

From my testing with IPSec AES 256 SHA256
on my clearfog base with 2 Cores I get a 2x speed increase:

Before the patch: 26.74 Kpps
With the patch: 56.11 Kpps

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
v2:
* use cpumask_local_spread and remove affinity on
  module remove

 drivers/crypto/marvell/cesa/cesa.c | 11 ++++++++++-
 drivers/crypto/marvell/cesa/cesa.h |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 8a5f0b0bdf77..c098587044a1 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -438,7 +438,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	struct mv_cesa_dev *cesa;
 	struct mv_cesa_engine *engines;
 	struct resource *res;
-	int irq, ret, i;
+	int irq, ret, i, cpu;
 	u32 sram_size;
 
 	if (cesa_dev) {
@@ -505,6 +505,8 @@ static int mv_cesa_probe(struct platform_device *pdev)
 			goto err_cleanup;
 		}
 
+		engine->irq = irq;
+
 		/*
 		 * Not all platforms can gate the CESA clocks: do not complain
 		 * if the clock does not exist.
@@ -548,6 +550,10 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		if (ret)
 			goto err_cleanup;
 
+		// Set affinity
+		cpu = cpumask_local_spread(engine->id, -1);
+		irq_set_affinity_hint(irq, get_cpu_mask(cpu));
+
 		crypto_init_queue(&engine->queue, CESA_CRYPTO_DEFAULT_MAX_QLEN);
 		atomic_set(&engine->load, 0);
 		INIT_LIST_HEAD(&engine->complete_queue);
@@ -570,6 +576,8 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		clk_disable_unprepare(cesa->engines[i].zclk);
 		clk_disable_unprepare(cesa->engines[i].clk);
 		mv_cesa_put_sram(pdev, i);
+		if (cesa->engines[i].irq > 0)
+			irq_set_affinity_hint(cesa->engines[i].irq, NULL);
 	}
 
 	return ret;
@@ -586,6 +594,7 @@ static int mv_cesa_remove(struct platform_device *pdev)
 		clk_disable_unprepare(cesa->engines[i].zclk);
 		clk_disable_unprepare(cesa->engines[i].clk);
 		mv_cesa_put_sram(pdev, i);
+		irq_set_affinity_hint(cesa->engines[i].irq, NULL);
 	}
 
 	return 0;
diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
index e8632d5f343f..0c9cbb681e49 100644
--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -457,6 +457,7 @@ struct mv_cesa_engine {
 	atomic_t load;
 	struct mv_cesa_tdma_chain chain;
 	struct list_head complete_queue;
+	int irq;
 };
 
 /**
-- 
2.20.1

