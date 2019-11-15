Return-Path: <SRS0=SVjD=ZH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50A4C432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 13:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5DF420733
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 13:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="nxr2JUeA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfKONtR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Nov 2019 08:49:17 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:58818 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbfKONtN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Nov 2019 08:49:13 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 04bJj8IRNnf31troyi8ebK52ffkHMGydyZWeXMOHhJc9y2oZ3piU4ItGNrJ/iJeU9a0s5UQPyV
 neJGQM7dIweBr7aTDG1sztvxnl9eA67UzVPNW+J9LKXnbVsDyIni4XLhedrARe57ytfH2DIxcL
 wiJGQEVLVe7baHdigsBTT+iAaUHxReYJAm5u7PkVlAaOcCPV/ceh390po/ZFUpO1uoaXClddBb
 OfmoFuFxFUkmWcB6BzN+8mfKqiT0MzJic1XmmsFkrJ8GxiqOVgrKUX3z53jSUco0OauJhRfr+A
 KKk=
X-IronPort-AV: E=Sophos;i="5.68,308,1569308400"; 
   d="scan'208";a="54484155"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Nov 2019 06:49:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 15 Nov 2019 06:49:12 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 15 Nov 2019 06:49:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEdiAPrhmzUI/BKnf1zazvqoU+zRyzIEQkV3KgK5rZsZ00GnqzRt1vNzYpkf+bTVK4V9sbTJ1FbUSGOBF+A4Lwrk+96ESKneZXWcqpD05CW9e5L/8nl6HrdTUmliZScmASw1Osy9VM3f5Ke0++rUXrfEH1jJTxcOoFOSnWbm9KUG2aqKO/LCxgE9Gbk7nN/e+S2k34vksBGmr4WMz/GtmXE1zStlfWcglV5c64PoaHxakA/4ld1HDZlB7VXRNLE2e8P4USEn0T1Y+h9+J90ruKMzJLrZtdMIQlK8QOoIgOCdjB3AxbKNoGZVQ+xdVBoj1HGViWAONnbT2pBd7d4u6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9OLMi37Bk/JbYXtwh3g7xif/bxtaYLtOIGFzJSiYvA=;
 b=GLMBWW2Keo2eWGcywrdvGF6jDEDh4tL66Tq7IarfYK+oI9IeUMGoBtS/vJUQmAXwcEISXW1bDcMRZtE1+FArJGEbDLNsTIixOonHhCgyZ+tBCLjopH4A+jtuBawDvDdJkECtl6ojhErKx5ZUJmv7TasViy5pHGAC3fUYd4koD51M3PRa9aonqMcs9d0dIJYH1j3erRoEmtHH93Dqnh+Z7xal0lX7W2p81dyGktTicaYQw2XvXBYj94XaZ5HzIvZ/NqbPiiEY3LDmNL2cxyGWOFGAYnnsBwWUYDEL7Z+Z6AVgzrHAFn/eyPjynCpVaW6mNWu4MYwCK6LZDBjKtZuFuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9OLMi37Bk/JbYXtwh3g7xif/bxtaYLtOIGFzJSiYvA=;
 b=nxr2JUeAwGdcVu48oHZK/ucW8/wZVmgM0Bz6QW7NvtiT3mZQNA8jtM1vJ8A50481hY3TuHivUJaCJii82VfgiCjHaoyGjcovJRII9tbhv0De/WSmSmoYWfMDJM+62MUopHE5tZ8m4i6SHTRknsu5wpp1BABbiP8EhoZbKKuRSI8=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB4159.namprd11.prod.outlook.com (20.179.150.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Fri, 15 Nov 2019 13:49:09 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2451.027; Fri, 15 Nov 2019
 13:49:09 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 2/2] crypto: atmel-aes - Change data type for "lastc" buffer
Thread-Topic: [PATCH 2/2] crypto: atmel-aes - Change data type for "lastc"
 buffer
Thread-Index: AQHVm7t0zw6ysqDDnEebCGYj6j6T6A==
Date:   Fri, 15 Nov 2019 13:49:09 +0000
Message-ID: <20191115134854.30190-2-tudor.ambarus@microchip.com>
References: <20191115134854.30190-1-tudor.ambarus@microchip.com>
In-Reply-To: <20191115134854.30190-1-tudor.ambarus@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BE0P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::27) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.9.5
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c4c1684-9de8-4fe7-86bd-08d769d29697
x-ms-traffictypediagnostic: MN2PR11MB4159:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB41591725FE42FC856C53358CF0700@MN2PR11MB4159.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(39860400002)(396003)(376002)(199004)(189003)(14444005)(102836004)(66446008)(6916009)(14454004)(2351001)(26005)(50226002)(6116002)(36756003)(71200400001)(3846002)(52116002)(99286004)(25786009)(8936002)(5660300002)(71190400001)(6506007)(6436002)(386003)(8676002)(6486002)(107886003)(2501003)(11346002)(66476007)(66946007)(66556008)(4744005)(6512007)(478600001)(64756008)(5640700003)(76176011)(446003)(1730700003)(81156014)(81166006)(186003)(1076003)(7736002)(305945005)(316002)(2616005)(4326008)(54906003)(486006)(476003)(256004)(66066001)(2906002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4159;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9xp5wU2A+7radu9up5MoS63YQ+faqeERPZFe2A5iE/yAnzRNm+/yATSaHQeyB/FDPh8S/WqE6rIVVUxRFdIpYERJAiyv0y0hAY97OiT3u8y3aYhYSHoILTUHFyE3IS9Wqjyp1hbnKXwCw+P50HXSJq021IsTfv+J6CtVAmCs7wFNLOQVx7vHvzY31SSOQeigSfDJV+Lot8h+iFsTPYJPe0FotIYk11ne8kwrfEId9HlL37QDwiRiurN/uILmLuqimMRjFI7a0Y+EYgdkNz9nrqiSbSyCQDDoEBDdqbj32M1/27zu28iGS61bFdzRbD5DDr2Ey2VPkmhq653TmXkAmcvW37AFeOdIzgDLj3T6F73MgYR1f94S1Yijcgg7YNmB4dxS6VTZ1se78VgRpa3P3VPYrPpThHRcnrT8v0J7QTdojxrivtYYeF+c7hxTqfvX
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c4c1684-9de8-4fe7-86bd-08d769d29697
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 13:49:09.0303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +AyJot5sSHg63/aroi/4RPt8cmpxEjz+5HmILDSVwrFLS5b7meUsWxNTgGs+iB8ZCaF3gZSue3zTb1GLB+sMaPWXBL5xZIIe9RkXWflPP/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4159
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

In case of in-place decryption, the "lastc" buffer is used to copy
the last ciphertext block before the decryption of the message. It
is later used to update the req->iv of the skcipher_request.

"lastc" variable is not used to interact with the hardware, there
is no restriction to be of type "u32". Change the type of "lastc"
to "u8".

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 3c88c164c3dc..91092504bc96 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -155,7 +155,7 @@ struct atmel_aes_authenc_ctx {
=20
 struct atmel_aes_reqctx {
 	unsigned long		mode;
-	u32			lastc[AES_BLOCK_SIZE / sizeof(u32)];
+	u8			lastc[AES_BLOCK_SIZE];
 };
=20
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
--=20
2.9.5

