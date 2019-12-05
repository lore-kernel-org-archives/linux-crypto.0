Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DE5C43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B51B24653
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:53:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="owZjnhFO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbfLEJx6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:53:58 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:11822 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbfLEJx5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:53:57 -0500
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
IronPort-SDR: baXAFboOjboB0oTABbArIdgnYCkvWbuLo4f9VJDo27RKGo+yOUPHW9FJ8ucQDES1Nm3t47NJPx
 3elztZRkwOJNM6Js4+zVvUyCZjRVBylG5FYF4CwMTOkOY69FaFo7Je6eAhYeeAlZCm7lkrMe/Q
 104WPmzNZGaiq7zJcH9fpedC512TcryX+7vf0acmO67g66msCiuU7jmGcWTSrcG5CKwznPM62C
 IfFVny2btjZzaiZXOsH5BqezHGkCx23UoGgmG/bvA6znknIKbk6pgKd9d+a1vFIYMcI4Mky+xP
 m4c=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="58828889"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:53:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:53:59 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 5 Dec 2019 02:53:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQhomzsYqsQ++lV7+C7jfSJOrZmoDuVejFrs0oVlN2ISHSs94WXNoZ15C4HtaJ1+RFbIM3wWwdIEYc3KyF0lR6qLb7knP29TjiUdejEcnJVS1eO1RNxkXeaz4zaXHGV5eUYh7NUz4cslMiIGb/6Q8LnUyhg7wmgg4+Aykd81IuQR3ihDJ+y5SEzj67qf2eAXf7THHDoOQH6T0yZ5YMEvv+/nuPwO5tsXbuO5cdyGI5IgNGEMUvCu5PnOPnaMg6x5HqIFAlPnEk2PEwpKZa1FAqoSoS28efzeIIBYs5S71Pcq9vqK4M5VI7/Ti/W7aZwMBC0sgQYGTyHxMHeJmU3+LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVRwHOldG0ynnXiqDs/bDd/P3uzW8vlGnnbfn/dGjIE=;
 b=V4CnYdEi8W5piShsTUBNYPGUw85rXbhZfIitp71Ks8p8vQt7tLcUYDBn2K5Hkr86sTj31Q2zRHpJ8e+xRqMj1I912fwk+1G8HZgiS9V3/aqMMSR/HhPgf4ua7H2yVFH1vfGAfuAuhCMkDy6JkruL1znT3I0pFxarnIZxoJVan0jrDqyvuMxaQrItJPx7q/HvXGpZjR5tsiRfvZgjtGQrmFq4xBKicBWN/5FDqoO6g6b8PGCUyaTsvYlBVQ5KXn1PMm7zG81iLJxClo/DfixmH5/6pcwKyavDFXJIgOS94XYuqbrfKoAoDVYg9SYUOcVNk6mcRuwVmeQ/skxfh5hdpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVRwHOldG0ynnXiqDs/bDd/P3uzW8vlGnnbfn/dGjIE=;
 b=owZjnhFOqIwzya8aTqcJkSAC7L+On05kFEF6bITA93/93e8ww1wmIKbZotiOoxFJu+/8GkjJf6DeQdobk7aIrOSrv1xVRMCHri6ccK8a+VW/hzrxbOoEYZMQxrs0ppBG83d5GF09XLDZFlPCw34FNpXbgWcuexbWS8rwKHw1tAU=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB4288.namprd11.prod.outlook.com (52.135.37.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Thu, 5 Dec 2019 09:53:55 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:53:55 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 07/16] crypto: atmel-tdes - Remove useless write in Control
 Register
Thread-Topic: [PATCH 07/16] crypto: atmel-tdes - Remove useless write in
 Control Register
Thread-Index: AQHVq1HoXxSWzAveyEy5pNcChjB39Q==
Date:   Thu, 5 Dec 2019 09:53:55 +0000
Message-ID: <20191205095326.5094-8-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: d1179bd3-748c-4038-088e-08d779690a74
x-ms-traffictypediagnostic: MN2PR11MB4288:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4288ADF5B7548D77A9647E64F05C0@MN2PR11MB4288.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:64;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(6506007)(1076003)(305945005)(4326008)(2616005)(86362001)(478600001)(11346002)(14444005)(102836004)(107886003)(2906002)(50226002)(5660300002)(66446008)(66946007)(66476007)(66556008)(14454004)(1730700003)(64756008)(76176011)(8936002)(4744005)(52116002)(81166006)(186003)(5640700003)(81156014)(36756003)(71200400001)(71190400001)(54906003)(6512007)(316002)(6486002)(25786009)(8676002)(26005)(6916009)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4288;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mchAHhvzKNjq7cXp4rPjktuS3poYEkxHaxntILwKDnRintEfPvXuugw+ZZ/Ju9taLb51u5eIiZW1tt5tNGIIGLPIMgT4BnyPXFptlZYuCVBdjWBLyc2TvqcwuNQjHCATNfhdOlnQZstj2PKpmvfyXUrM4Q7hrEGzz3S2WDja0U+IqUvzEgzNpJITEl17lL0G24Wd+BNSd1ylxRkD3WJ80T+qpqHSP3Ywjx5Yzpt8O2Z/sblTCuzge8XGCR1t0pePq0XRwdfXg40YSlwAQiIoEqKowN7JC/AWJzAJafxCQ4DeKppF/N9AQHR1mwCajcXmCw+OSNC1U+RE2h0xzWUfEu42iq7M8hW1/DcjvQtbFU2xckPhqsvPNAFnO8u5K4s3lkVhUNdgx1irQ3bboAHAK6byvWjYJsj2oPRuPeMAwF39+4MmWcUTuGBaAFMptRgE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d1179bd3-748c-4038-088e-08d779690a74
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:53:55.2406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8S5UBb4JSww/CI8ye3CquNsZCtHnLR4AitEmh/VjTLVUgUrG007+P0OkZLhWWORypSzb9iBg5oC85h3CJQSWSeGct39M+T9XQ3bnqTRSIec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4288
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

As claimed by the datasheet, writing 0 into the Control Register has no
effect. Remove this useless register access.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-tdes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 16527ef2a05b..0b9badbd232d 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -265,7 +265,7 @@ static void atmel_tdes_dma_callback(void *data)
 static int atmel_tdes_write_ctrl(struct atmel_tdes_dev *dd)
 {
 	int err;
-	u32 valcr =3D 0, valmr =3D TDES_MR_SMOD_PDC;
+	u32 valmr =3D TDES_MR_SMOD_PDC;
=20
 	err =3D atmel_tdes_hw_init(dd);
=20
@@ -307,7 +307,6 @@ static int atmel_tdes_write_ctrl(struct atmel_tdes_dev =
*dd)
 	if ((dd->flags & TDES_FLAGS_ENCRYPT) || (dd->flags & TDES_FLAGS_OFB))
 		valmr |=3D TDES_MR_CYPHER_ENC;
=20
-	atmel_tdes_write(dd, TDES_CR, valcr);
 	atmel_tdes_write(dd, TDES_MR, valmr);
=20
 	atmel_tdes_write_n(dd, TDES_KEY1W1R, dd->ctx->key,
--=20
2.14.5

