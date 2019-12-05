Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDD1C43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE9F1224F8
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:53:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Zr9IAIg0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbfLEJx4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:53:56 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:1122 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729314AbfLEJxy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:53:54 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: nAraF8Z1WJnLPSx/pW5Jf+syvA05dKgfPX8hNNy8rwni+B2oVlY8H1lVrtHoHE7Lwc7ye6doVW
 hCjpAN6k+eLycYeX5KlBCkJiGbh+dsypXVrm10D8hUeZYtnh5Thz1f5R/efqTsgvUg1qV7KgWq
 GAObcB6lzqbx8Fh02pM1th1RK6blUcR3Gmg8feHaa+4qJ0QuTjthEMvplB23Nejg1AkRjc6K/N
 Z9je2did8cQH44r1Ms1p1Dpa6qA9iNerMxoKGBa73O1Y1oElfVZ+clHDjIp3bEsZ174bFFIfx4
 ZP0=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="56727487"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:53:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:53:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Dec 2019 02:53:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ys+NhBOJZTcaO+wKQzKxWp79OIGuZz9232uuHPK5Cb9ze9VCMrjoO2fjmyZSzS3/3el2Nylgr2g0z/Fb+6RI3jT2Z6FMv0ODZb0qExuv8RWv3kgMQKwz8/jtNGjtbZH+AkSi81uT1DQVfjosukkfFFOfDRx/8CqCbquVoJz6pTe+xmcHE8MmmxcgFdDDKzi3fAW4mTlFCKhKwMKWNkZ0PnTGocYXEK3BVbATM3a4s3dc2fxuNr2+2AvoBtLO1SVPajsfZXsmMmogpt7dVQAVzzY6GTlx718UhahDfyJ8z+SQ/uYQvNX3XvSnddkInuXv/YHSV2Dd4IYe/rV8tpgKsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cr4SYo9OxlgO2sVpVu17o/n2cbERIBgvQtBwUP2ML98=;
 b=c5wOkIzXdq19+GOMQGa+/Ag/q6Mih6FnEeOKVmVhKyM4G+rsDR++473ucKbVG4mH9o2VDURwFNNTgaaIOFonDhChuczWwWbgIdpWz8g4bOqiwyWNeOsaSmDO9+DXnQe6W1/UP6BjtgelolsN/Jdi0UskyR6pH06litFkOt+Dq7hbiQwYusEKdLmkyfTTg8a2ffrtwiRoiet53M0pzhbxudsLQkYzY5uiCFSX1reOpSw/U+I/vyf7GUs/XeiK5vuoPIn4/NuXTQNmIvyx3QmFeU7FzHRJGe098Vo6ZoyFwnnHPrscrGoIKSVHLH7kthm3DZFFY07ShHxLZ3pucNPTIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cr4SYo9OxlgO2sVpVu17o/n2cbERIBgvQtBwUP2ML98=;
 b=Zr9IAIg0QlfkHm+dNY5zUyv1ULlcHL/tWYkUnYabXTXfaWOjxyihOt+BQUY0a2hTObg3tJTkQoo6/fhw/jZpyfwoBp1EMmJ1f5Et6bSo8dzsKJC+qbM+8IBv0Qo3rjrFS4S/KWGhi29mmgQI9XsNxE6uUeWVc3gscUxlsWg9k3Y=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3677.namprd11.prod.outlook.com (20.178.253.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 09:53:52 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:53:52 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 05/16] crypto: atmel-{aes,sha,tdes} - Drop superfluous error
 message in probe()
Thread-Topic: [PATCH 05/16] crypto: atmel-{aes,sha,tdes} - Drop superfluous
 error message in probe()
Thread-Index: AQHVq1HmlpXgnPH4V0KtO9/Hzu9rWg==
Date:   Thu, 5 Dec 2019 09:53:51 +0000
Message-ID: <20191205095326.5094-6-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: dc2e9a7f-f10e-4706-0002-08d779690887
x-ms-traffictypediagnostic: MN2PR11MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3677318FA4953D5E87982E3EF05C0@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:281;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(2616005)(66556008)(305945005)(66476007)(66446008)(102836004)(64756008)(11346002)(5660300002)(52116002)(76176011)(99286004)(36756003)(66946007)(2906002)(54906003)(26005)(6916009)(6506007)(1076003)(8676002)(6486002)(15650500001)(4326008)(50226002)(1730700003)(8936002)(14454004)(81156014)(186003)(86362001)(81166006)(5640700003)(478600001)(6512007)(71200400001)(25786009)(316002)(71190400001)(107886003)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3677;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w2WENlLinklQ6R9IfvN8aoA1Z6iHRKZEywiVcC97W9J2KydnBB1Bewq0HS9UMFvP6vBV9skwLgZ7r28cCnm2lm/o0MreWV5Q0vU6bw4Z95jW4qFq5rAe35Z49+dsdvHiF86P0A2R8AlY8RL2OX+eZRvMKlRGjDd4b9teKsiNfcj7/DkT6ZgPW3G2f0xEVkLK/WiDUDS1R+oZMcD28KsJlrC7lNtTl4FTvp8gy024Zktx5HWpKKIS+rMXFDDi00Q7qXU6cn9dNU8llIazyE7wyBwHFixdGosIBNywo7QezxoaKORugNcBEWGh2INrxWXanmXmYKpFhoZPEG+pZOqYpAf0xdj6vUOgigierDAgHm9D1FLRgp7kM3i6c3kvSxUs1MXEMIqYdMZ3bItYCkvnHxD45b7p3y6t18B0yMIKlE3XoetbPQDkOy+75daHmb5VAqLJjHiD+U2CCE9y+zua7w8OXH7yBaaJX86eXYZB7DTYzvntQlKtfDRz//ZQXYCw
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2e9a7f-f10e-4706-0002-08d779690887
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:53:51.9125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U8jXK9J5EHSwmyq9nmYPO9Shu50YV9K+KpLcdg2tAXkwN3RfuigD3WDXeQdV3jNTh+A+cMBzkTEHKnIDBhNj5IouGf3l6YupGzu8936UXm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

In case the probe fails, the device/driver core takes care of printing
the driver name, device name and error code. Drop superfluous error message
at probe.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 21 ++++++---------------
 drivers/crypto/atmel-sha.c  |  8 ++------
 drivers/crypto/atmel-tdes.c |  8 ++------
 3 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 91092504bc96..1cb5564e73f4 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2620,22 +2620,16 @@ static int atmel_aes_probe(struct platform_device *=
pdev)
 	pdata =3D pdev->dev.platform_data;
 	if (!pdata) {
 		pdata =3D atmel_aes_of_init(pdev);
-		if (IS_ERR(pdata)) {
-			err =3D PTR_ERR(pdata);
-			goto aes_dd_err;
-		}
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
 	}
=20
-	if (!pdata->dma_slave) {
-		err =3D -ENXIO;
-		goto aes_dd_err;
-	}
+	if (!pdata->dma_slave)
+		return -ENXIO;
=20
 	aes_dd =3D devm_kzalloc(&pdev->dev, sizeof(*aes_dd), GFP_KERNEL);
-	if (aes_dd =3D=3D NULL) {
-		err =3D -ENOMEM;
-		goto aes_dd_err;
-	}
+	if (!aes_dd)
+		return -ENOMEM;
=20
 	aes_dd->dev =3D dev;
=20
@@ -2741,9 +2735,6 @@ static int atmel_aes_probe(struct platform_device *pd=
ev)
 res_err:
 	tasklet_kill(&aes_dd->done_task);
 	tasklet_kill(&aes_dd->queue_task);
-aes_dd_err:
-	if (err !=3D -EPROBE_DEFER)
-		dev_err(dev, "initialization failed.\n");
=20
 	return err;
 }
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index bf53b8aa8bfc..e85fa48e3d10 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2756,10 +2756,8 @@ static int atmel_sha_probe(struct platform_device *p=
dev)
 	int err;
=20
 	sha_dd =3D devm_kzalloc(&pdev->dev, sizeof(*sha_dd), GFP_KERNEL);
-	if (sha_dd =3D=3D NULL) {
-		err =3D -ENOMEM;
-		goto sha_dd_err;
-	}
+	if (!sha_dd)
+		return -ENOMEM;
=20
 	sha_dd->dev =3D dev;
=20
@@ -2871,8 +2869,6 @@ static int atmel_sha_probe(struct platform_device *pd=
ev)
 res_err:
 	tasklet_kill(&sha_dd->queue_task);
 	tasklet_kill(&sha_dd->done_task);
-sha_dd_err:
-	dev_err(dev, "initialization failed.\n");
=20
 	return err;
 }
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index c47ceb593fa4..9baae2065474 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1258,10 +1258,8 @@ static int atmel_tdes_probe(struct platform_device *=
pdev)
 	int err;
=20
 	tdes_dd =3D devm_kmalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
-	if (tdes_dd =3D=3D NULL) {
-		err =3D -ENOMEM;
-		goto tdes_dd_err;
-	}
+	if (!tdes_dd)
+		return -ENOMEM;
=20
 	tdes_dd->dev =3D dev;
=20
@@ -1373,8 +1371,6 @@ static int atmel_tdes_probe(struct platform_device *p=
dev)
 res_err:
 	tasklet_kill(&tdes_dd->done_task);
 	tasklet_kill(&tdes_dd->queue_task);
-tdes_dd_err:
-	dev_err(dev, "initialization failed.\n");
=20
 	return err;
 }
--=20
2.14.5

