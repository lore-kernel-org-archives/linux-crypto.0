Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533D7C2D0BF
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14E96224F8
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="r5GDvXb7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbfLEJx7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:53:59 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:11822 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729344AbfLEJx6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:53:58 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: DINsbWI6hwNMFT59pN1L42ywqJVuGdiULiicDLS1QV9/SwTZy6R/vF7UxGB8usviS1fCtgrBao
 nmvCvfOJivYhfjVj/NHf9HFWm0aNCwrUSLuOgLszK67bpU0iqD1FT5A4y04vFxsa/3f7+aMwEt
 s1fEuvtxGn9zz4FOhRKP+59Q44hQE5wtumwWlyMZNeJwCt9c6/4IyllXZAnpFeQbgeC263bbO9
 K3CTo2LrUaZfpMcbkHLZxsNHu1JiMqS25vG1Sa3/Nb5XW7kS2VZztoDR6jKIuBTENoB2pR6RjG
 VgI=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="58828890"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:53:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:53:59 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 5 Dec 2019 02:53:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpEvl4cX2fDNXMfWK7EV0NNZOeRhCnubqTBRksNNN9Rxnd9nMQ/qL/mr4LgykLnZGpxu+R2ToCFzoslud2nYHyk+8fUegoO7MIbGqAQ1QgbE4Tx313H7RvxCd4ZbUBbbidsLRlJ7QWQtacJqlT0+Qw0svF01efT0ksTEK28QeIeAKFHVmZlZ9Y8KK5wSUfdkPoCVlFCOM2DdSIKBkPl5zs2fMqYg8zm/4sQpYTx6KkNqL0hiqKB7PUEAQIn0a8C0UVZmNtLIK8EYV5hRVGr9KmNHsPvR56nkpVluYK00MgWUZZoJW6El6/amuFlhPdbrKCK0j57czJ6jBPmCl4H8dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOYRrHFvK4Fnxfw91jxATUd72f9U5vBFOZr930ZMXKc=;
 b=l+95gbydJzroMsiOZlC6uzRjBoFwlW53HkDle3Aitjw51RD9woCOD/bTlw0xefQxi2XZym2/KcNfrWdJ82m/4CK8EM4ae97o2/G9EKFXJ5SpHAP7ygOXjbHwl0nOX+6bT4Qj7qbmqfjzX4DgMVWbcFcOBykdmWQsNnKOAmMeFoeLRXJg59UY5R+1RvTKvscwTgfcBm7M6uX6h78bq2mGASUYzdU/nJWvPxWEeOT6Ul/ZQjw49CbuG2NQESh5b1t4yoN9ahEagnxeuYYQkWk35j/CpUvYXI7RoPwhaKDcjbO49sK0kByA7sTeTu2Q2pFyDa/bWi4o4IildryKgbt3gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOYRrHFvK4Fnxfw91jxATUd72f9U5vBFOZr930ZMXKc=;
 b=r5GDvXb7tBCxN3LkeKSYKMmCDTslo4V/AweddlvnVGUh2mvK85ljjQudcP62QWJDgjKlkF4k55M3i36vW9BmsJHGlUTvX6ZDjsB8YrxSdnCTYCEtmuUAl0mZP3CZwLR/SF+wHZ6nDUwHikdeqfB0Pbr2f9cz/gWOANsn5YDfX7I=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3677.namprd11.prod.outlook.com (20.178.253.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 09:53:53 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:53:53 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 06/16] crypto: atmel-{aes,sha,tdes} - Rename labels in probe()
Thread-Topic: [PATCH 06/16] crypto: atmel-{aes,sha,tdes} - Rename labels in
 probe()
Thread-Index: AQHVq1HnsuLmnGSJ10WhJdITuvt32g==
Date:   Thu, 5 Dec 2019 09:53:53 +0000
Message-ID: <20191205095326.5094-7-tudor.ambarus@microchip.com>
References: <20191205095326.5094-1-tudor.ambarus@microchip.com>
In-Reply-To: <20191205095326.5094-1-tudor.ambarus@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.14.5
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f63ed5c-3edd-494f-eed8-08d779690979
x-ms-traffictypediagnostic: MN2PR11MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB367777617B4F550E5F2DCD27F05C0@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:220;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(2616005)(66556008)(305945005)(66476007)(66446008)(102836004)(64756008)(11346002)(5660300002)(52116002)(76176011)(99286004)(36756003)(66946007)(2906002)(54906003)(26005)(6916009)(6506007)(1076003)(8676002)(6486002)(4326008)(50226002)(1730700003)(8936002)(14454004)(81156014)(186003)(86362001)(81166006)(5640700003)(478600001)(6512007)(71200400001)(25786009)(316002)(71190400001)(14444005)(107886003)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3677;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4tlqrL9+mDNHdtjphKWyYoMz4jKOSYzbwfmTnzIwYtTuv/Cb4ZxGPbuF+Menk/6+GC5VSzI+8m4IQj8oeSmiP1uJNFf943d17CXgauHnDNLWSnjBMz0xAqIQsU0JeuZVdHg8vj3GzXlFSwvFQQlMU+ThM0yqVjEDnu8IO3pjBvSHlNM7OWAX8NQLw7XmDVg5VXJKyMCvZZyBySPubdZYus4WmKZa0YG2ASqdJrqeWTg/XhNKpHhWzF14zMpQqOnYVtLeMHu7qXiM6cWVwXKshHE8OeUCkm3cdUpiYCRxy8G7AhhSNGlRNsjtfJDitszxc3R6r9htKon3iV99Bj5Zr1e+LHwj9ueOj0e5MJSi/1Xf5Fk5PnUsF40vbVGxSHhgBySsXQ7X4ByARpW6y2Me944ZwYw3EwJNKvjmazuDvtjfLNQ7J0sdcoNEayhu5/XDMVj++ORuEUmKz7+gtficQg5kTHhA/F6bqkrq511RTbZMt6FFDobMUxxmU+lybqnd
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f63ed5c-3edd-494f-eed8-08d779690979
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:53:53.5106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ugeHGve8XYE3/ShdoaLPduKsOodJ7doESEmv9jgPQV+V1j3Vohbyaz7uaG9kPoin2rfoxifH/T09c5LVIFLYaIBCKpJsxjQD5rtLqxKdByc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

Choose label names which say what the goto does and not from where
the goto was issued. This avoids adding superfluous labels like
"err_aes_buff".

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 27 +++++++++++++--------------
 drivers/crypto/atmel-sha.c  | 25 ++++++++++++-------------
 drivers/crypto/atmel-tdes.c | 26 ++++++++++++--------------
 3 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 1cb5564e73f4..0744859ec793 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2650,7 +2650,7 @@ static int atmel_aes_probe(struct platform_device *pd=
ev)
 	if (!aes_res) {
 		dev_err(dev, "no MEM resource info\n");
 		err =3D -ENODEV;
-		goto res_err;
+		goto err_tasklet_kill;
 	}
 	aes_dd->phys_base =3D aes_res->start;
=20
@@ -2658,14 +2658,14 @@ static int atmel_aes_probe(struct platform_device *=
pdev)
 	aes_dd->irq =3D platform_get_irq(pdev,  0);
 	if (aes_dd->irq < 0) {
 		err =3D aes_dd->irq;
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	err =3D devm_request_irq(&pdev->dev, aes_dd->irq, atmel_aes_irq,
 			       IRQF_SHARED, "atmel-aes", aes_dd);
 	if (err) {
 		dev_err(dev, "unable to request aes irq.\n");
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	/* Initializing the clock */
@@ -2673,40 +2673,40 @@ static int atmel_aes_probe(struct platform_device *=
pdev)
 	if (IS_ERR(aes_dd->iclk)) {
 		dev_err(dev, "clock initialization failed.\n");
 		err =3D PTR_ERR(aes_dd->iclk);
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	aes_dd->io_base =3D devm_ioremap_resource(&pdev->dev, aes_res);
 	if (IS_ERR(aes_dd->io_base)) {
 		dev_err(dev, "can't ioremap\n");
 		err =3D PTR_ERR(aes_dd->io_base);
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	err =3D clk_prepare(aes_dd->iclk);
 	if (err)
-		goto res_err;
+		goto err_tasklet_kill;
=20
 	err =3D atmel_aes_hw_version_init(aes_dd);
 	if (err)
-		goto iclk_unprepare;
+		goto err_iclk_unprepare;
=20
 	atmel_aes_get_cap(aes_dd);
=20
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (aes_dd->caps.has_authenc && !atmel_sha_authenc_is_ready()) {
 		err =3D -EPROBE_DEFER;
-		goto iclk_unprepare;
+		goto err_iclk_unprepare;
 	}
 #endif
=20
 	err =3D atmel_aes_buff_init(aes_dd);
 	if (err)
-		goto err_aes_buff;
+		goto err_iclk_unprepare;
=20
 	err =3D atmel_aes_dma_init(aes_dd, pdata);
 	if (err)
-		goto err_aes_dma;
+		goto err_buff_cleanup;
=20
 	spin_lock(&atmel_aes.lock);
 	list_add_tail(&aes_dd->list, &atmel_aes.dev_list);
@@ -2727,12 +2727,11 @@ static int atmel_aes_probe(struct platform_device *=
pdev)
 	list_del(&aes_dd->list);
 	spin_unlock(&atmel_aes.lock);
 	atmel_aes_dma_cleanup(aes_dd);
-err_aes_dma:
+err_buff_cleanup:
 	atmel_aes_buff_cleanup(aes_dd);
-err_aes_buff:
-iclk_unprepare:
+err_iclk_unprepare:
 	clk_unprepare(aes_dd->iclk);
-res_err:
+err_tasklet_kill:
 	tasklet_kill(&aes_dd->done_task);
 	tasklet_kill(&aes_dd->queue_task);
=20
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index e85fa48e3d10..8f63a1aebd9e 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2778,7 +2778,7 @@ static int atmel_sha_probe(struct platform_device *pd=
ev)
 	if (!sha_res) {
 		dev_err(dev, "no MEM resource info\n");
 		err =3D -ENODEV;
-		goto res_err;
+		goto err_tasklet_kill;
 	}
 	sha_dd->phys_base =3D sha_res->start;
=20
@@ -2786,14 +2786,14 @@ static int atmel_sha_probe(struct platform_device *=
pdev)
 	sha_dd->irq =3D platform_get_irq(pdev,  0);
 	if (sha_dd->irq < 0) {
 		err =3D sha_dd->irq;
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	err =3D devm_request_irq(&pdev->dev, sha_dd->irq, atmel_sha_irq,
 			       IRQF_SHARED, "atmel-sha", sha_dd);
 	if (err) {
 		dev_err(dev, "unable to request sha irq.\n");
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	/* Initializing the clock */
@@ -2801,23 +2801,23 @@ static int atmel_sha_probe(struct platform_device *=
pdev)
 	if (IS_ERR(sha_dd->iclk)) {
 		dev_err(dev, "clock initialization failed.\n");
 		err =3D PTR_ERR(sha_dd->iclk);
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	sha_dd->io_base =3D devm_ioremap_resource(&pdev->dev, sha_res);
 	if (IS_ERR(sha_dd->io_base)) {
 		dev_err(dev, "can't ioremap\n");
 		err =3D PTR_ERR(sha_dd->io_base);
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	err =3D clk_prepare(sha_dd->iclk);
 	if (err)
-		goto res_err;
+		goto err_tasklet_kill;
=20
 	err =3D atmel_sha_hw_version_init(sha_dd);
 	if (err)
-		goto iclk_unprepare;
+		goto err_iclk_unprepare;
=20
 	atmel_sha_get_cap(sha_dd);
=20
@@ -2828,16 +2828,16 @@ static int atmel_sha_probe(struct platform_device *=
pdev)
 			if (IS_ERR(pdata)) {
 				dev_err(&pdev->dev, "platform data not available\n");
 				err =3D PTR_ERR(pdata);
-				goto iclk_unprepare;
+				goto err_iclk_unprepare;
 			}
 		}
 		if (!pdata->dma_slave) {
 			err =3D -ENXIO;
-			goto iclk_unprepare;
+			goto err_iclk_unprepare;
 		}
 		err =3D atmel_sha_dma_init(sha_dd, pdata);
 		if (err)
-			goto err_sha_dma;
+			goto err_iclk_unprepare;
=20
 		dev_info(dev, "using %s for DMA transfers\n",
 				dma_chan_name(sha_dd->dma_lch_in.chan));
@@ -2863,10 +2863,9 @@ static int atmel_sha_probe(struct platform_device *p=
dev)
 	spin_unlock(&atmel_sha.lock);
 	if (sha_dd->caps.has_dma)
 		atmel_sha_dma_cleanup(sha_dd);
-err_sha_dma:
-iclk_unprepare:
+err_iclk_unprepare:
 	clk_unprepare(sha_dd->iclk);
-res_err:
+err_tasklet_kill:
 	tasklet_kill(&sha_dd->queue_task);
 	tasklet_kill(&sha_dd->done_task);
=20
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 9baae2065474..16527ef2a05b 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1280,7 +1280,7 @@ static int atmel_tdes_probe(struct platform_device *p=
dev)
 	if (!tdes_res) {
 		dev_err(dev, "no MEM resource info\n");
 		err =3D -ENODEV;
-		goto res_err;
+		goto err_tasklet_kill;
 	}
 	tdes_dd->phys_base =3D tdes_res->start;
=20
@@ -1288,14 +1288,14 @@ static int atmel_tdes_probe(struct platform_device =
*pdev)
 	tdes_dd->irq =3D platform_get_irq(pdev,  0);
 	if (tdes_dd->irq < 0) {
 		err =3D tdes_dd->irq;
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	err =3D devm_request_irq(&pdev->dev, tdes_dd->irq, atmel_tdes_irq,
 			       IRQF_SHARED, "atmel-tdes", tdes_dd);
 	if (err) {
 		dev_err(dev, "unable to request tdes irq.\n");
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	/* Initializing the clock */
@@ -1303,25 +1303,25 @@ static int atmel_tdes_probe(struct platform_device =
*pdev)
 	if (IS_ERR(tdes_dd->iclk)) {
 		dev_err(dev, "clock initialization failed.\n");
 		err =3D PTR_ERR(tdes_dd->iclk);
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	tdes_dd->io_base =3D devm_ioremap_resource(&pdev->dev, tdes_res);
 	if (IS_ERR(tdes_dd->io_base)) {
 		dev_err(dev, "can't ioremap\n");
 		err =3D PTR_ERR(tdes_dd->io_base);
-		goto res_err;
+		goto err_tasklet_kill;
 	}
=20
 	err =3D atmel_tdes_hw_version_init(tdes_dd);
 	if (err)
-		goto res_err;
+		goto err_tasklet_kill;
=20
 	atmel_tdes_get_cap(tdes_dd);
=20
 	err =3D atmel_tdes_buff_init(tdes_dd);
 	if (err)
-		goto err_tdes_buff;
+		goto err_tasklet_kill;
=20
 	if (tdes_dd->caps.has_dma) {
 		pdata =3D pdev->dev.platform_data;
@@ -1330,16 +1330,16 @@ static int atmel_tdes_probe(struct platform_device =
*pdev)
 			if (IS_ERR(pdata)) {
 				dev_err(&pdev->dev, "platform data not available\n");
 				err =3D PTR_ERR(pdata);
-				goto err_pdata;
+				goto err_buff_cleanup;
 			}
 		}
 		if (!pdata->dma_slave) {
 			err =3D -ENXIO;
-			goto err_pdata;
+			goto err_buff_cleanup;
 		}
 		err =3D atmel_tdes_dma_init(tdes_dd, pdata);
 		if (err)
-			goto err_tdes_dma;
+			goto err_buff_cleanup;
=20
 		dev_info(dev, "using %s, %s for DMA transfers\n",
 				dma_chan_name(tdes_dd->dma_lch_in.chan),
@@ -1364,11 +1364,9 @@ static int atmel_tdes_probe(struct platform_device *=
pdev)
 	spin_unlock(&atmel_tdes.lock);
 	if (tdes_dd->caps.has_dma)
 		atmel_tdes_dma_cleanup(tdes_dd);
-err_tdes_dma:
-err_pdata:
+err_buff_cleanup:
 	atmel_tdes_buff_cleanup(tdes_dd);
-err_tdes_buff:
-res_err:
+err_tasklet_kill:
 	tasklet_kill(&tdes_dd->done_task);
 	tasklet_kill(&tdes_dd->queue_task);
=20
--=20
2.14.5

