Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB02C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 08:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A97B02067D
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 08:53:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="hZxrTjgg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgGIIxf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 04:53:35 -0400
Received: from mail-eopbgr60122.outbound.protection.outlook.com ([40.107.6.122]:2215
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbgGIIxe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 04:53:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bH41cDegEfWO6NJsu6k8rQ9W3LNmqAGI+cj8+/v4aslEIQujUNNL/ZSwfy1hUT8pzBihRLKyVSqZ1HqbWn4j44kF/PAe9pqImLLv1rucFP/IWCDWXmGi+It9smBxalZ0IZX0R43yygJlNBHJOWD8OjaF0kr7ehvIOrMV87GKFdzzJ1Gf+MrdZxc3foPdL6pADTRhBNT2Rf4VDywUvpygZpFtFD/kMsefVzG5zmbfCXsgNkVXsIhz9HZAeWtqr2gar1XENPQeqtKGSHghr/DctCsamPD4ODLjvulEPMud9ulWO/EGx0mhXwBupPb2rivXDkHY8kPNcz7SKsuswDPAOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=htXIRt8xhBBqabG0PqE9ZQetA4rYev2Nte5zHmZ49MU=;
 b=YpROe/xcp3og0BfYepEVz1qF4YXGi3D6bmfQc8Zu0+0IKBe3m5YufKBf2jGJWFuy+XScJyJFufnP/UL/Ur1vR8ChqLFfuX5Ry6dCKsHolT/yyYfkBTDl/35Les0OQNpEdnpsGekxXPE1KktyvwJ1ZAMu5P4ILVtNG/LBbitRsifBCk+2xhC9BBJnCzBWPVSCKjq0d0pK0FAc4Atm7/cz8EMp3zgR4mSb+RakBLWmUfmEqgxNyOKHN35sSKwZyJl/0Zu/e8AH3T/fA/kFKOrmMKWrfrYGp02AIYyDXwnMkjm6kcjBX8q5pn4W6nk71b8Au2N69E6dHFgwu/PZWYI4Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=htXIRt8xhBBqabG0PqE9ZQetA4rYev2Nte5zHmZ49MU=;
 b=hZxrTjggZdkLGlaz+yf91pBPzBcHEgaBG86JtQyWqVuQfbxxtKhp8CQ8seLI6nChWS0w/8veoiTgeG1N97SQlqXXf6CGtIVvrNKzBmVuQnM71/7uB9RZPAJ2aHDm6qbFrrIRFG2VthZSVdGKYIxysBl71S29jjHQLjW//AKtHjU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM0PR05MB5923.eurprd05.prod.outlook.com
 (2603:10a6:208:12a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Thu, 9 Jul
 2020 08:53:31 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3153.032; Thu, 9 Jul 2020
 08:53:31 +0000
Date:   Thu, 9 Jul 2020 10:53:29 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     linux-crypto@vger.kernel.org
Cc:     boris.brezillon@free-electrons.com, arno@natisbad.org
Subject: [PATCH 1/1] marvell cesa irq balance
Message-ID: <20200709085329.z6rdmpi3i7yf7b6p@SvensMacBookAir.hq.voleatech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR2P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::11) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.hq.voleatech.com (37.24.174.42) by FR2P281CA0024.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Thu, 9 Jul 2020 08:53:30 +0000
X-Originating-IP: [37.24.174.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2b19309-0020-4b0b-c23c-08d823e58dfb
X-MS-TrafficTypeDiagnostic: AM0PR05MB5923:
X-Microsoft-Antispam-PRVS: <AM0PR05MB5923DC5FE25E1B55DB1A8C57EF640@AM0PR05MB5923.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNqac3aFngwiNW3aN35yfvrnzw65bpzk4okAsq9Nz/RW87435Z4dXl4nWhRGMFD/1AtuMg/D2tajJ7NKu3xhmm/92y2DtMZId8SwMfphLzhnlj0yPRATpT/HM1KqtembW+aJXv1MfRzKAvXxb4ZJu3eXZ4Tn7sukCpRKL4GYxMkBlpyov1pn1hoJFhlo0ka97hDmWhjwM20GIfVa2DP5DQhV1ZngU6WRvzIJ3p2gNA8TxkZiqgoDVeu6hVbWEt9qxACeOc1ZcDrElR7rzLifG2VcHlNfBaV4V53B3SOdjW5bawNu/WdMX6eYaY7rBkeBrm6yrDNfE13J+29cRjvB6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39830400003)(136003)(376002)(396003)(86362001)(16526019)(8936002)(9686003)(52116002)(83380400001)(7696005)(66556008)(66476007)(316002)(5660300002)(6506007)(66946007)(44832011)(1076003)(2906002)(8676002)(186003)(6916009)(508600001)(55016002)(956004)(26005)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 7mWYe+izTs+zY/9GD8+2hBa1rwvprUF2vLskDHp6tkCQAOqEmCl4Lx7oi3AL1wwIEW+a7mhLaIovLOxhRYLu0Ma7ZisIOO+RiGojw258y/2/LCuO1nGOvaJ0p/pW0Nf5CysXL4OWAkfLcd6nM/cmt7U9ecdfHI+GV+QeVE4dCvad2Xelo0xMMXTWS3RsqXrRFEbSSPZq8PDbfHAp6DuOubeYTZrcFjwwRv30iQiitpgklGtP7UD5H5fexl1yg0vUrWIwR9We+UbG/rRsnou7yP06OxPFlBZeUMqggimgEXOUOQYP18jcukNfAwhZFlGonBBAHwqD9PPpuFSn2gDyCV5ygYy2qQ0ZnnTUFzOj8nnuZWO534NynRpsGW5ued3eSNJUj2ZS5qVv6X8cL/g/XBc99v9vQatd2u/vbIKmzPP0oRfkCOBdHbvfx2oKFQlggpVvTqSL0GRwI7/yqfdgpYvIBbOs9USjrtug5ioNAJs=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b19309-0020-4b0b-c23c-08d823e58dfb
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 08:53:31.1004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gTVhrgwSNlLl8YJ6WGiDEB7J+kdTzJUENniadOMEO/Eprrfo6qzTnMu6TUwBfJplvrrm0I6eGq64qlL/xzSr5QpOUMcH1aykWqiY3fWTtl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5923
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
 drivers/crypto/marvell/cesa/cesa.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 8a5f0b0bdf77..bf1bda2e904a 100644
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
@@ -548,6 +548,10 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		if (ret)
 			goto err_cleanup;
 
+		// Set affinity
+		cpu = engine->id % num_online_cpus();
+		irq_set_affinity_hint(irq, get_cpu_mask(cpu));
+
 		crypto_init_queue(&engine->queue, CESA_CRYPTO_DEFAULT_MAX_QLEN);
 		atomic_set(&engine->load, 0);
 		INIT_LIST_HEAD(&engine->complete_queue);
-- 
2.20.1

