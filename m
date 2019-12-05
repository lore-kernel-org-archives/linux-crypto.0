Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DD7C43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F26324654
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:53:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="V1fC3O/I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfLEJxw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:53:52 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:44604 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfLEJxu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:53:50 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: TmwG57nGtPEW1qnWkA7UfgOV1HaSzCU9+TdmtqAxXB2Jo8t7r4Y0AvIvQ4Em/N7G/YZ71RIPYy
 0J3Ixn1Nh9zkcJQh7D3u2JNKd6/255a/jpxP0HiDXoK6EA9iiwQLb8/QMl6AmV5XtIa5uxwdsS
 JD5H+eko9GRu80CMvaJ/3b1ZAQdF5q+wU25G2Rsv5Qg+HwmJ7uazWPoonEG8y33CDfN9oeKfnI
 R0KDsXhWglBx8SRaHEphyJlHD0z9EDOt50Sq5tQftbkWh0a8sR6NOxNgvJUeMjO+IVPfVnyg0a
 Lys=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="59347306"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:53:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:53:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Dec 2019 02:53:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sxv0oKueKwz/qZXOSy9Vv1XImPxIJmnnYv5eNm7L8QsWszbKsEkheoWceY9295VUMB53iNm39C2hr/QvCpXO4VMMlQ+BMOMO+ZAQr1QmvW7HeAecq85/rPzDEHmD3q0WKaQX7J7CCjObV9rlrZf9W7u4SRI1gpugQO7Y30C7uAi/h9YfhvCilmcqfiG01YkMmqPszsQ9LZQmbSPu+uIZDbpt+gsh0I52JAQCL5nxXLYJ3smcD1hlnugjiGapSdTCEVeGWfpQkuprxKjLpuSOg7lOQ9JNL/lID9Kwetjm7MD4yxKREmSYpUIGUK8OZeDlAeIHLcOCUWKZCvVHd9Qs+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXA+XnseAC1Qe6w9lVKYyCqn8salS7FIgQksEUWoFsE=;
 b=lMI/GOd/oV9PmInYfynC40j9Hc4ay8wNx0AgLsO019NDlDBci6mIukPJnX2MBNGh05odAGoX4GuJD+WWrhFWBwgO0KmnRtWTZhXp7lovASfGtpNYYgx2yKWli+TKzZ2+CjKQyMLtVllIIhUqTUINF70zxWkfwXBawQVk3W8pNrCnbm49wdog4WkwEqxC7R7CUumzfOLruD4cWrzMZnkOv6QNqhGXmTijnzEMiovAP3BjNFuLv3+LmRwdynRcKEZS96lrdIWljYyzaYTUZ5/kZb/z1fFTPQ4p2VJWkzFiiTqGI4HKaGg1CZtJ8/c0xzYDwqgrCWx1iEe/AmGG6vZQ6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXA+XnseAC1Qe6w9lVKYyCqn8salS7FIgQksEUWoFsE=;
 b=V1fC3O/IxJ75raJJCrVlSaC6tbP+6yFNKCRHD16wsmcVjvG2C29A2dt57I3fi5J4oGkuS9nwovFclANYeUrcGNf2T7yhSgwqJj/HRRfxlTQXaSsvFZi/R8KSDeWJP9rBRpCOKTtfwUBf4edUZBELecxYLROP72JznUlxlqsjFNU=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3677.namprd11.prod.outlook.com (20.178.253.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 09:53:46 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:53:46 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 02/16] crypto: atmel-{sha,tdes} - Change algorithm priorities
Thread-Topic: [PATCH 02/16] crypto: atmel-{sha,tdes} - Change algorithm
 priorities
Thread-Index: AQHVq1HiMEgFlFkcD0GAuCy2Po73TQ==
Date:   Thu, 5 Dec 2019 09:53:46 +0000
Message-ID: <20191205095326.5094-3-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: 29f6a808-bdad-49a5-64c9-08d77969055b
x-ms-traffictypediagnostic: MN2PR11MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB36779B21B0B55F93CA9C0855F05C0@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(2616005)(66556008)(305945005)(66476007)(66446008)(102836004)(64756008)(11346002)(5660300002)(52116002)(76176011)(99286004)(36756003)(66946007)(2906002)(54906003)(26005)(6916009)(6506007)(1076003)(8676002)(6486002)(4326008)(50226002)(1730700003)(8936002)(14454004)(81156014)(186003)(86362001)(81166006)(5640700003)(478600001)(6512007)(71200400001)(25786009)(316002)(71190400001)(107886003)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3677;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B2/oUNv0fcSJxBH2+cR3B5tHBk38W54iV0N7Wijy9UwK8JP8lpwThH54LkuNS6HQ3l/BlJvhRNKtY99KNmefLQpHX75tAkNqClA4bMNL0BdYYx24Er2BAEclzS0EqqZx3MB+FdEpWKF9mpe+SM0JsrkCMLliGHWSv0kKblaKZ3ucRRSZmzmn2tn1Xdap96iWeaaT8va91qOD1T/W0QdIlwYjxngdAkC+Wr+Ly5JccP369+r++q8bgRedO1XEdAoZrur2AIiXgCF0u8ltK30Ak1LdskUwZgjYXnsoamAkIQjyW73k+CiiIMcjZHE3W5cQX6bBNlwRa+nH9gN8EVbSklMgQEBAL22XIkzS5OYtl+B++/AqWzK858NYFjm6MmPl3d6SVqwOBzWbUBN1mKDXFjV82VxqOIHSaf0KCJI4nLy+H9oEuTRUQt8fo3bk3BlJAEviflKEPSOLakDJaecoAkHbT2v0MuDTqBvM2b+ZPP3THr0uzA1frB5LqUg89WW4
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f6a808-bdad-49a5-64c9-08d77969055b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:53:46.7045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlej7/C20royESG81HyJ0r5ySoU2hvHKejITPxZGl0ViqejoU28+ICfBf8aylsPYd5abT9MCvkLo0uazaUfbywXkgSdqprAGl0BbYSvQVrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

Increase the algorithm priorities so the hardware acceleration is now
preferred to the software computation: the generic drivers use 100
as priority.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-sha.c  | 22 ++++++++++++----------
 drivers/crypto/atmel-tdes.c | 22 ++++++++++++----------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 8ea0e4bcde0d..3bbec58bf2cd 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -40,6 +40,8 @@
 #include "atmel-sha-regs.h"
 #include "atmel-authenc.h"
=20
+#define ATMEL_SHA_PRIORITY	300
+
 /* SHA flags */
 #define SHA_FLAGS_BUSY			BIT(0)
 #define	SHA_FLAGS_FINAL			BIT(1)
@@ -1263,7 +1265,7 @@ static struct ahash_alg sha_1_256_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "sha1",
 			.cra_driver_name	=3D "atmel-sha1",
-			.cra_priority		=3D 100,
+			.cra_priority		=3D ATMEL_SHA_PRIORITY,
 			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA1_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
@@ -1287,7 +1289,7 @@ static struct ahash_alg sha_1_256_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "sha256",
 			.cra_driver_name	=3D "atmel-sha256",
-			.cra_priority		=3D 100,
+			.cra_priority		=3D ATMEL_SHA_PRIORITY,
 			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA256_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
@@ -1313,7 +1315,7 @@ static struct ahash_alg sha_224_alg =3D {
 		.base	=3D {
 			.cra_name		=3D "sha224",
 			.cra_driver_name	=3D "atmel-sha224",
-			.cra_priority		=3D 100,
+			.cra_priority		=3D ATMEL_SHA_PRIORITY,
 			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA224_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
@@ -1339,7 +1341,7 @@ static struct ahash_alg sha_384_512_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "sha384",
 			.cra_driver_name	=3D "atmel-sha384",
-			.cra_priority		=3D 100,
+			.cra_priority		=3D ATMEL_SHA_PRIORITY,
 			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA384_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
@@ -1363,7 +1365,7 @@ static struct ahash_alg sha_384_512_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "sha512",
 			.cra_driver_name	=3D "atmel-sha512",
-			.cra_priority		=3D 100,
+			.cra_priority		=3D ATMEL_SHA_PRIORITY,
 			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA512_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
@@ -2099,7 +2101,7 @@ static struct ahash_alg sha_hmac_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "hmac(sha1)",
 			.cra_driver_name	=3D "atmel-hmac-sha1",
-			.cra_priority		=3D 100,
+			.cra_priority		=3D ATMEL_SHA_PRIORITY,
 			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA1_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
@@ -2124,7 +2126,7 @@ static struct ahash_alg sha_hmac_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "hmac(sha224)",
 			.cra_driver_name	=3D "atmel-hmac-sha224",
-			.cra_priority		=3D 100,
+			.cra_priority		=3D ATMEL_SHA_PRIORITY,
 			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA224_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
@@ -2149,7 +2151,7 @@ static struct ahash_alg sha_hmac_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "hmac(sha256)",
 			.cra_driver_name	=3D "atmel-hmac-sha256",
-			.cra_priority		=3D 100,
+			.cra_priority		=3D ATMEL_SHA_PRIORITY,
 			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA256_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
@@ -2174,7 +2176,7 @@ static struct ahash_alg sha_hmac_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "hmac(sha384)",
 			.cra_driver_name	=3D "atmel-hmac-sha384",
-			.cra_priority		=3D 100,
+			.cra_priority		=3D ATMEL_SHA_PRIORITY,
 			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA384_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
@@ -2199,7 +2201,7 @@ static struct ahash_alg sha_hmac_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "hmac(sha512)",
 			.cra_driver_name	=3D "atmel-hmac-sha512",
-			.cra_priority		=3D 100,
+			.cra_priority		=3D ATMEL_SHA_PRIORITY,
 			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA512_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 9b69e7a26639..a6b36abba3d1 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -40,6 +40,8 @@
 #include <linux/platform_data/crypto-atmel.h>
 #include "atmel-tdes-regs.h"
=20
+#define ATMEL_TDES_PRIORITY	300
+
 /* TDES flags  */
 #define TDES_FLAGS_MODE_MASK		0x00ff
 #define TDES_FLAGS_ENCRYPT	BIT(0)
@@ -929,7 +931,7 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ecb(des)",
 	.base.cra_driver_name	=3D "atmel-ecb-des",
-	.base.cra_priority	=3D 100,
+	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
 	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
@@ -946,7 +948,7 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cbc(des)",
 	.base.cra_driver_name	=3D "atmel-cbc-des",
-	.base.cra_priority	=3D 100,
+	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
 	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
@@ -964,7 +966,7 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb(des)",
 	.base.cra_driver_name	=3D "atmel-cfb-des",
-	.base.cra_priority	=3D 100,
+	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
 	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
@@ -982,7 +984,7 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb8(des)",
 	.base.cra_driver_name	=3D "atmel-cfb8-des",
-	.base.cra_priority	=3D 100,
+	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
 	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB8_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
@@ -1000,7 +1002,7 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb16(des)",
 	.base.cra_driver_name	=3D "atmel-cfb16-des",
-	.base.cra_priority	=3D 100,
+	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
 	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB16_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
@@ -1018,7 +1020,7 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb32(des)",
 	.base.cra_driver_name	=3D "atmel-cfb32-des",
-	.base.cra_priority	=3D 100,
+	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
 	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB32_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
@@ -1036,7 +1038,7 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ofb(des)",
 	.base.cra_driver_name	=3D "atmel-ofb-des",
-	.base.cra_priority	=3D 100,
+	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
 	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
@@ -1054,7 +1056,7 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ecb(des3_ede)",
 	.base.cra_driver_name	=3D "atmel-ecb-tdes",
-	.base.cra_priority	=3D 100,
+	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
 	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
@@ -1071,7 +1073,7 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cbc(des3_ede)",
 	.base.cra_driver_name	=3D "atmel-cbc-tdes",
-	.base.cra_priority	=3D 100,
+	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
 	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
@@ -1089,7 +1091,7 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ofb(des3_ede)",
 	.base.cra_driver_name	=3D "atmel-ofb-tdes",
-	.base.cra_priority	=3D 100,
+	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
 	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
--=20
2.14.5

