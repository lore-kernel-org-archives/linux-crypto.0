Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A2EC433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 04:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BA7E208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 04:38:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="ko1IRxSj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgGUEiD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 00:38:03 -0400
Received: from mail-eopbgr10116.outbound.protection.outlook.com ([40.107.1.116]:59270
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgGUEiD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 00:38:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yh33UtpqQ5QwXTDb0stmCacuOQ66ZpXGnwlKqBoORAoRFSh/P+in1adgxMZIWrFz8IAnLE/8Mpk9xM3xtcC7DXhEv+oJL6kKi6+zVNXIg+eEdd/Veih9kezBpoaZDi3VhskmXP6ixSM5MyMwyDe3FtRBNoa0NQtjNtokSLo7/3cRfF98OYAu3y6sdUmOUtiQRfEYuh/0XfxIJo1Ye3KLXWnnfaWgxwP5xlrGiph/ngB0WbjyX7sprm4jAxms/B2T4xD6LuIMCNUxfmhxmfS1ArLnf6Ubz/vsGM1zJUF986aIJCuHmBHnQwv3fWgte+CKkYJOHQHcRxpBkrjpZdqHPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llkz4TH8+xPy1eVbbZrT1tIhwScRdM6NaN78uAoG4Cs=;
 b=I5EsGRAo3Pv81mLuH2gKrwBWo4OmhWS6DiLjfkURueic4CCFsOvmAyu0TFeXZ4vkAL+0dxAYF95iayjEZ6qvR80kEhZfAOzArLUH+KTJuHPK+3t7cIroHIq53cQBOGeOA5RWAlc/gEpJS9WarVE2Y+mHTxC9zlKR8v1FDztAOivW0OUDvTkqBhbteZb8Ol6Un8Zz4FDNUnXzDTFFbSjGHECElIbGAAdlJPmHUKL6UAhy/9XmKk/g6lCypXC3Ghe/EzjrZ+dRGcHb6jxHF5P2QOjFXfqIztDKup7dd0+wk4hbq7gaEwfaJG22cx4oQW/4cElOPS2wJWV1B11+iN9kkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llkz4TH8+xPy1eVbbZrT1tIhwScRdM6NaN78uAoG4Cs=;
 b=ko1IRxSjAa/zlbP3qgO5BbwVjC82A2lBnoJbfD3bvGPpZ0CJNeuCZMDuXylO7iz0acmeHwCaijsAP5gX+tBbaftfidhmN20xfUKhdybIo6qjXX4jqWdcnqz1VFNQo7xOxMuF2CViinkv7/Lza98RGHx24zzlb4TEQnaC12eSUFQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR05MB3284.eurprd05.prod.outlook.com
 (2603:10a6:205:4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Tue, 21 Jul
 2020 04:38:00 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3195.026; Tue, 21 Jul
 2020 04:38:00 +0000
Date:   Tue, 21 Jul 2020 06:37:59 +0200
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, pvanleeuwen@rambus.com,
        antoine.tenart@bootlin.com, ardb@kernel.org
Subject: [PATCH 1/1 v3] inside-secure irq balance
Message-ID: <20200721043759.4tpgtxjohnhx3yuv@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM0PR03CA0086.eurprd03.prod.outlook.com
 (2603:10a6:208:69::27) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (109.193.235.168) by AM0PR03CA0086.eurprd03.prod.outlook.com (2603:10a6:208:69::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Tue, 21 Jul 2020 04:38:00 +0000
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a40ca86-1d74-4857-63a7-08d82d2fd91f
X-MS-TrafficTypeDiagnostic: AM4PR05MB3284:
X-Microsoft-Antispam-PRVS: <AM4PR05MB3284D638C7C7166E380C2A38EF780@AM4PR05MB3284.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:53;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+bFZuEv1h9apILOft7JSbd/LLBUwmu6AYPmULYwx4bvHkHnPwBinhE/p3d1AuJmkeTeQA3wQv5hrdO3fRkiyO+ophpMPRP1rAwa4ZBDlJKXmO5f7nnCVj0UGdWg1KZapq7KyPoKtCmEbHDCQp2/fEza5yHxinD6V+L/WWFayJq4hHmMOCG2FM067Q5AQM6n9CsdEw7rASf/UY2u3oqJ/J5QnpQxbFR7J0341/19gu33B95DGfVh4MNqZ8gYGqvkyAdSGkNTMPhhSlzlKvh2ryiu4AdCt0x9ouLxCFkIwwpS2n7odPqa/96W/YwrCqyyJABN7cSNSxXqgD0SvTjnaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39830400003)(366004)(396003)(346002)(376002)(136003)(66476007)(6506007)(66556008)(8676002)(2906002)(186003)(4326008)(508600001)(8936002)(16526019)(26005)(9686003)(52116002)(7696005)(66946007)(5660300002)(6916009)(1076003)(83380400001)(316002)(956004)(86362001)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ALwRvTeD8qNAzPpnGl/l5xhzP8Cydas1xr7uR3t5Rtr6idKOFcHIdQkQ0+U+b++/I2XsQaCiyWfS8VZq6ud8k5lnQd+jAhYmN5mt1lPPArSRaEjTH9vFQ7U8wsdQbtd3/SZoj7XbKKwvTCynyyPCtD57dwDtZS04mJH78cvxVhilrI1Z/braK8e3EbY10MNm5siilFPJXsi/IypU1qV1zGPwOOOyY2wDKa8MB6ELTYle+od7tzUc7CKSCWieUSuMSd+12KF/TK1jyTl07L8Dx630JfzHMTvKE4u2b3dV/xeTsYAKN7Deg5ycuOXTLXSjTTCXbofSimXu48PYPV9GM/KUgSQ1yd5gtT9UIZFdtbFgXG/Fo2D00jNcm53Vh53p4K6O3ZJWED9x3xKXVAZPseoF5VLYl5IzLHVLZwwbG2NHxmysfHBt0vWALq5wqJtbQFNkZP3tezXRqtITqWQXK+nh6SvDtEXvjfDbi/EMmaeaPmOCc2i0fHb04gCpKzYq
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a40ca86-1d74-4857-63a7-08d82d2fd91f
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 04:38:00.4420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ybOGEHdeoq7TWg8ZvYaYBuK+m5Uq/rIL+8EXOmKyP4ltaitgrXhPdT2yve31zAAK6Wn3hjvIjtHwEeEMgFiYJV1FgLeV3LmJKPSX1sweIls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3284
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Balance the irqs of the inside secure driver over all
available cpus.
Currently all interrupts are handled by the first CPU.

From my testing with IPSec AES-GCM 256
on my MCbin with 4 Cores I get a 50% speed increase:

Before the patch: 99.73 Kpps
With the patch: 151.25 Kpps

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
v3:
* use NUMA_NO_NODE constant

v2:
* use cpumask_local_spread and remove affinity on
  module remove

 drivers/crypto/inside-secure/safexcel.c | 13 +++++++++++--
 drivers/crypto/inside-secure/safexcel.h |  3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 2cb53fbae841..fb8e0d8732f8 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1135,11 +1135,12 @@ static irqreturn_t safexcel_irq_ring_thread(int irq, void *data)
 
 static int safexcel_request_ring_irq(void *pdev, int irqid,
 				     int is_pci_dev,
+				     int ring_id,
 				     irq_handler_t handler,
 				     irq_handler_t threaded_handler,
 				     struct safexcel_ring_irq_data *ring_irq_priv)
 {
-	int ret, irq;
+	int ret, irq, cpu;
 	struct device *dev;
 
 	if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
@@ -1177,6 +1178,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 		return ret;
 	}
 
+	/* Set affinity */
+	cpu = cpumask_local_spread(ring_id, NUMA_NO_NODE);
+	irq_set_affinity_hint(irq, get_cpu_mask(cpu));
+
 	return irq;
 }
 
@@ -1611,6 +1616,7 @@ static int safexcel_probe_generic(void *pdev,
 		irq = safexcel_request_ring_irq(pdev,
 						EIP197_IRQ_NUMBER(i, is_pci_dev),
 						is_pci_dev,
+						i,
 						safexcel_irq_ring,
 						safexcel_irq_ring_thread,
 						ring_irq);
@@ -1619,6 +1625,7 @@ static int safexcel_probe_generic(void *pdev,
 			return irq;
 		}
 
+		priv->ring[i].irq = irq;
 		priv->ring[i].work_data.priv = priv;
 		priv->ring[i].work_data.ring = i;
 		INIT_WORK(&priv->ring[i].work_data.work,
@@ -1756,8 +1763,10 @@ static int safexcel_remove(struct platform_device *pdev)
 	clk_disable_unprepare(priv->reg_clk);
 	clk_disable_unprepare(priv->clk);
 
-	for (i = 0; i < priv->config.rings; i++)
+	for (i = 0; i < priv->config.rings; i++) {
+		irq_set_affinity_hint(priv->ring[i].irq, NULL);
 		destroy_workqueue(priv->ring[i].workqueue);
+	}
 
 	return 0;
 }
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 94016c505abb..7c5fe382d272 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -707,6 +707,9 @@ struct safexcel_ring {
 	 */
 	struct crypto_async_request *req;
 	struct crypto_async_request *backlog;
+
+	/* irq of this ring */
+	int irq;
 };
 
 /* EIP integration context flags */
-- 
2.20.1

