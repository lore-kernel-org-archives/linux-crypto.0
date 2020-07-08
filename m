Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E9D1C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 15:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13B5A206DF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 15:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="Fzi9EOSH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbgGHPIu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 11:08:50 -0400
Received: from mail-eopbgr70097.outbound.protection.outlook.com ([40.107.7.97]:65190
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729022AbgGHPIu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 11:08:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Li9Arny6eQC/FrhNyx1EO60SjvIlcqRp2eNoM1gXjN89xD2NHyP3KIN2cuXL7gTdI9k/WPQVSQxiUmzbFM4v3g7kR2fB+14MXjAGrhLqVmX3/gt8Y3kIJE2Y0ysE9mQn0Ey46AIQu0fiWeTxo7VL5KfLj0T4EYTSGaz0NaAkjygNSKRP+oY/sbd58d5GJLSYy5h8gRRa1Tm84mewQXDkVslswTCrwZwpXf881IGlVBYmSKuwpUGZe8JujsKUtRMv9iyNw1/j+IUwu8Qd5j1jga7TRSoYtsgJv4qXHBSWuML+qGONP+gHZOQ++ef53iYoFIXzhWM+Blm51wL2TPCP5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWgLZSjQdapMsSSxVGZGmJDwIrSVOrZOhH+TtsRQMeY=;
 b=cKXsMz1gxQ3XBgeM4bP/7VPbip9Zkxzfj0Ejfkh83JOgjZZqdgE/tF67fztBx/YoW+OepV3S7aI9sQq1i7mdOWrHJoLyvBUsxHA9lIE+H/MFPqs0vaIlTJ26jdN/mho4+WIVl3dCrLfTWpzGReRr7wYnpGxQbVT1P5WJyAFuipGi3nHK1WbRad1olcmtPLX5APQ/0yfg/hHds1Gj/7kOu/VOHoBndkBit2NUm5DuLpDtlW2fcAmjgkSR5+3T3BwQM7sEVYSXUE6rzNULgYT4+2oiT27D/xOiMCmGhXQWIDKRSY0B2c95pSwudq3xrgjkt5AWbI04H1oI8A6b8peWig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWgLZSjQdapMsSSxVGZGmJDwIrSVOrZOhH+TtsRQMeY=;
 b=Fzi9EOSHwn0yh9H2uuq9wH0uABcUHiaNfdae4gKilMwdziwrLbWHQ8Tl61siLgsJ8Fb8eoU2ugIVfK6f0i2Xh6k9tLp96htSsrk30oK/WpQP3vXnR4gikxrgRfn8LLJjpLH8SKZiVWowwSpvQj42yjpTGgYwcjP1J//QPBS5ANQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM0PR05MB4226.eurprd05.prod.outlook.com
 (2603:10a6:208:57::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Wed, 8 Jul
 2020 15:08:45 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3153.030; Wed, 8 Jul 2020
 15:08:45 +0000
Date:   Wed, 8 Jul 2020 17:08:44 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/1] inside-secure irq balance
Message-ID: <20200708150844.2626m3pgdo5oidzm@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM3PR07CA0054.eurprd07.prod.outlook.com
 (2603:10a6:207:4::12) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (109.193.235.168) by AM3PR07CA0054.eurprd07.prod.outlook.com (2603:10a6:207:4::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Wed, 8 Jul 2020 15:08:45 +0000
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40dbc8b6-f6f0-4550-a8e8-08d82350cf6b
X-MS-TrafficTypeDiagnostic: AM0PR05MB4226:
X-Microsoft-Antispam-PRVS: <AM0PR05MB42265A88AAA086242C301760EF670@AM0PR05MB4226.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:243;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ryrKxpMJIiWPOM4CH/uGf0dNz2zcoUedVHn6kLbtqltpEOYJFZGFXm89syGr77MXcSlI+LdBf+5SO8gvv2cylgm7V5TMgN81H/RsIiIwFYuCz+iWkOxgPF+4h452TB7fO+FXt+L9hkSnavZXgZJul41gd0R8Uphu4lP2q9aYX0tTqbosrwjjAEyKE+NZ8t0S271kGcVbtXcbym2J225B5pi2s24GwVxqxIqvkq7aw1UaUrvV3UZ68KMBeWknF3uSSP2DXUAF+VUoQh8meF5hpOEoXjLfqLTepDGSUnuRIwhQT49o9W1g9O280k+8bGf8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39830400003)(346002)(376002)(366004)(396003)(66946007)(1076003)(66476007)(66556008)(55016002)(9686003)(2906002)(83380400001)(5660300002)(8676002)(8936002)(44832011)(956004)(86362001)(16526019)(316002)(6916009)(508600001)(26005)(186003)(6506007)(52116002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KY0kDLfgqn88/oYSAwcOElLxnQ5CiyGNTwsss02n5khr9/3btqd5cnHW9OsgB232GIsKrtvKbx8NXpT5ishdk/3M+ROKe6L0hWOHCscM5rXmP5ZCzWd/PWKMQ7ZFWJxGh+j4K2KYEi30mdeCx0WANBemkuFb8MQpoexoHbsx6Xjftm4+5WHZ7EwUHohIm8vEdZsCcoYHShvd3daUHZmbaZmi8M6uujbKykWrZd+4Wk7o9ioAMMGsQgVxYZErcXwNVDhZ8Nq07ZPvEqTCqdYtt3ngDngftHUIPJYftaui9TPG1oySXYHmLPU4s5de6N3XLgZCQea48VBS1Ot31j7+PRXqzqZL9iU7cSxxdUwCT4fjw84XdmuKLROhbtGMn/dhbV02uFdWdLL3CjAdZfgPcoEHBV4taDzbtnO7L4bVB52EtaOl3iAu5vbs4l+6F0uSd17JHmkVhfnJrTPBVuBIZojp6hIznF+uxmuaIHo9+ejRB3Clszbl06MdyFlJNNV2
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 40dbc8b6-f6f0-4550-a8e8-08d82350cf6b
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 15:08:45.8909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ck4mS98MkuBuYOWkCpQruL8zyodAFwaLv7e6pDt1XRXLl8RetkNPNzc0Vo2dhvT5rm6Ao1dznnS4eMvZOYNPsla4wDYindqPQjJzHHaafxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4226
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
 drivers/crypto/inside-secure/safexcel.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 2cb53fbae841..f206084be08e 100644
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
 
+	// Set affinity
+	cpu = ring_id % num_online_cpus();
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
-- 
2.20.1

