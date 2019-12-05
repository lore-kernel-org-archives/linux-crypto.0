Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F3FEC43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 13:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B764F2464E
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 13:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="YKnB8Jrc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbfLENss (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 08:48:48 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:21304 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbfLENss (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 08:48:48 -0500
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
IronPort-SDR: /6EcsHnnW79FH/SBMaPtih1ujr0c9IMUMGwgl+MHe6VKOkBzQGVxAHiqw+QKoG31D+rHchXaOA
 VbhnX1GzVt6FkjV3uVPDhVswlGnnPpeLEv50oLkXW6PuwM/j051unxTIZxVjBMLelZb+ofI17e
 Jo7CD/M9PeahqdKxFdkjoBCErLWz5Chf+514J8jcncALIzz3S5WJ1SQ4tN2J9N07ymmVZXSBXz
 BaIU7pIYKjTCJCApMbzlH2+xmo6XXmMFQ+eBOLpAuUFFMamiESDGPtFjZ920j1i9SKO5r/BWbC
 Dk8=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="56749434"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 06:48:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 06:48:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Dec 2019 06:48:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U48xnuqtN4+BNFWtNkVzCesR/ukAfaVLNcZsdLIjAfIjc1h9Q6ymdM8ZEUvZJkhBNwqN20Yf+JbAInJBQWhGTyJ6DuAOgvthQYjlaZj6kVaK362Szw91zCnb3d2F139J9xYzLmlAN0Ypmvdok16tqC5df84mhSkaaV5xgcW8Ccu99U44tcAn7b1luR6S7ljzdHFfr5RzEJ4h1wN8Qj7UFkSY2Cz7praBrQZdG/N4KY1z2uzseMGG0jgjPt9N8GXj6cEaco7Ko7kgpL3wpABcFi5ZdkmCmvnk/2rHmnWotN3MU43XwZV8aeenhU8jUSMGKBFOd7WqGAGag5xxNFFPeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvUkra0vxKEvg6UzmZXdIJfMPc4bfT+mouB+B/Vsu5Q=;
 b=BfIJWgbboOgFMcH7lMJulTHJi0OndV8CD/cuvHgCDAjaH0iLMwnlbRUESDFRUkmpNj3t40uwqqpPpD4lHPemOup5/IEtKM6HT14bb6+NRGJd5PttMQh8nDRUe8ysAIxZZAA8VpImdV204wWEtKLfEPOiAR8pWdobM5tt67hqo5NEBSEmtvgITFf9CUNJFOk4e+BHQBgs/AuJr8ffI/NIVQKcI+blmFafI3UY80/UiZMa3BQ8NSbnUN8+0hBf+ACneiMEQR5lNcTPRpgfRGmBzKJ+pQBi6ToAcZbUNIz049gZq6Z9+B7+mNPq7oGS29faAY3H0fuU05VM27Xy18hGIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvUkra0vxKEvg6UzmZXdIJfMPc4bfT+mouB+B/Vsu5Q=;
 b=YKnB8JrcvcOD/4vWX6bhFiP8Vh7IICZ1xewnqo/bV228dSrpR81Ja39LgRbCASuHCOGY0ZxPHYLexHybpVwgbxHtUUUQ0jHJGBAasXWwO7NCd0P/ci5qo/JLFOvjZ0X7uMhxo/x/b8+gn06TH2+OXBR7M0yCHtQ+lKy7AKYqDcg=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3997.namprd11.prod.outlook.com (10.255.181.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 13:48:40 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2516.014; Thu, 5 Dec 2019
 13:48:40 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH v2 16/16] crypto: atmel-{aes,sha,tdes} - Group common alg type
 init in dedicated methods
Thread-Topic: [PATCH v2 16/16] crypto: atmel-{aes,sha,tdes} - Group common alg
 type init in dedicated methods
Thread-Index: AQHVq3Kz/CkLIKxG10a/cp5orQDsLg==
Date:   Thu, 5 Dec 2019 13:48:39 +0000
Message-ID: <20191205134824.9744-1-tudor.ambarus@microchip.com>
References: <20191205095326.5094-17-tudor.ambarus@microchip.com>
In-Reply-To: <20191205095326.5094-17-tudor.ambarus@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0036.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::49) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.14.5
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0642bbe-1a54-4150-7e1a-08d77989d593
x-ms-traffictypediagnostic: MN2PR11MB3997:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3997327DD416F0936A6F1C58F05C0@MN2PR11MB3997.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(396003)(346002)(136003)(199004)(189003)(8936002)(102836004)(2616005)(11346002)(107886003)(1730700003)(4326008)(25786009)(52116002)(6506007)(186003)(26005)(81156014)(6486002)(66476007)(66446008)(76176011)(66946007)(54906003)(64756008)(5640700003)(66556008)(86362001)(316002)(99286004)(478600001)(14444005)(6916009)(36756003)(305945005)(1076003)(2906002)(71200400001)(71190400001)(14454004)(6512007)(81166006)(5660300002)(50226002)(8676002)(30864003)(142933001)(559001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3997;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CJC1HtrkBmRjOOQvQK0Rmeds6W+6Q/TrRwCgiLUJEyjN+hj60rSREM+4A3ls+IOZNCP6Jijfcj2PKbtIa3MhDLf6gW7VAFKDRoE3JL06ZUfnaexBYMIeuHJQGQwLln+qhwpMUCbGXekd/XWo1yob0gMnnL1vF7lb4qEalQyvEOCvqbYzOJP55XqGx8tlFf6/PPiKGiBpPh4oezY59CQj0EG79obAPOCBIP27RyVh9QPXAvGmyJExTGz3YKJrlkQE+19t4pwR27zP/nWOPyurEPaRTX3/piN8gKEF8+llR+zxg211LdYrEi3PbbrHtcZR4RYQR/ePTmymdXk2Snhy0Kkn0zZJoYCirmAreKoVlsk4sMIihFD89RIRgR+lP0qjOOZwkrJfB+5a5z/3IKPHZe9gzj+OhMhXmMVF3b6W4nOwSexZoz7L/bJw3W3PjCnU9y7loTJ2d57EW+gNoWfA43hX3x2btANOlpkBl36Zv4MBFX08PwM/7hQ2japzdtaD
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d0642bbe-1a54-4150-7e1a-08d77989d593
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 13:48:39.9886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zOfoFSfbsUghRlekNMGMtg8M7komsS3OE5J32uYa3+51Tn6ONNLR4dopNz80FfMw70zKduArHjTEuR+jXB3Zy2ANhKuPBrFT6HJ5OugAYGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3997
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

Move common alg type init to dedicated methods.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
v2: more common alg init for atmel-sha

 drivers/crypto/atmel-aes.c  |  82 +++--------
 drivers/crypto/atmel-sha.c  | 324 ++++++++++++++--------------------------=
----
 drivers/crypto/atmel-tdes.c |  62 ++-------
 3 files changed, 129 insertions(+), 339 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 18802c977291..d96759357d03 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1289,12 +1289,8 @@ static struct skcipher_alg aes_algs[] =3D {
 {
 	.base.cra_name		=3D "ecb(aes)",
 	.base.cra_driver_name	=3D "atmel-ecb-aes",
-	.base.cra_priority	=3D ATMEL_AES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D AES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_aes_ctx),
-	.base.cra_alignmask	=3D 0xf,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_aes_init_tfm,
 	.min_keysize		=3D AES_MIN_KEY_SIZE,
@@ -1306,12 +1302,8 @@ static struct skcipher_alg aes_algs[] =3D {
 {
 	.base.cra_name		=3D "cbc(aes)",
 	.base.cra_driver_name	=3D "atmel-cbc-aes",
-	.base.cra_priority	=3D ATMEL_AES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D AES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_aes_ctx),
-	.base.cra_alignmask	=3D 0xf,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_aes_init_tfm,
 	.min_keysize		=3D AES_MIN_KEY_SIZE,
@@ -1324,12 +1316,8 @@ static struct skcipher_alg aes_algs[] =3D {
 {
 	.base.cra_name		=3D "ofb(aes)",
 	.base.cra_driver_name	=3D "atmel-ofb-aes",
-	.base.cra_priority	=3D ATMEL_AES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D AES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_aes_ctx),
-	.base.cra_alignmask	=3D 0xf,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_aes_init_tfm,
 	.min_keysize		=3D AES_MIN_KEY_SIZE,
@@ -1342,12 +1330,8 @@ static struct skcipher_alg aes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb(aes)",
 	.base.cra_driver_name	=3D "atmel-cfb-aes",
-	.base.cra_priority	=3D ATMEL_AES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D AES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_aes_ctx),
-	.base.cra_alignmask	=3D 0xf,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_aes_init_tfm,
 	.min_keysize		=3D AES_MIN_KEY_SIZE,
@@ -1360,12 +1344,8 @@ static struct skcipher_alg aes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb32(aes)",
 	.base.cra_driver_name	=3D "atmel-cfb32-aes",
-	.base.cra_priority	=3D ATMEL_AES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB32_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_aes_ctx),
-	.base.cra_alignmask	=3D 0xf,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_aes_init_tfm,
 	.min_keysize		=3D AES_MIN_KEY_SIZE,
@@ -1378,12 +1358,8 @@ static struct skcipher_alg aes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb16(aes)",
 	.base.cra_driver_name	=3D "atmel-cfb16-aes",
-	.base.cra_priority	=3D ATMEL_AES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB16_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_aes_ctx),
-	.base.cra_alignmask	=3D 0xf,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_aes_init_tfm,
 	.min_keysize		=3D AES_MIN_KEY_SIZE,
@@ -1396,12 +1372,8 @@ static struct skcipher_alg aes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb8(aes)",
 	.base.cra_driver_name	=3D "atmel-cfb8-aes",
-	.base.cra_priority	=3D ATMEL_AES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB8_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_aes_ctx),
-	.base.cra_alignmask	=3D 0xf,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_aes_init_tfm,
 	.min_keysize		=3D AES_MIN_KEY_SIZE,
@@ -1414,12 +1386,8 @@ static struct skcipher_alg aes_algs[] =3D {
 {
 	.base.cra_name		=3D "ctr(aes)",
 	.base.cra_driver_name	=3D "atmel-ctr-aes",
-	.base.cra_priority	=3D ATMEL_AES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D 1,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_aes_ctr_ctx),
-	.base.cra_alignmask	=3D 0xf,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_aes_ctr_init_tfm,
 	.min_keysize		=3D AES_MIN_KEY_SIZE,
@@ -1434,12 +1402,8 @@ static struct skcipher_alg aes_algs[] =3D {
 static struct skcipher_alg aes_cfb64_alg =3D {
 	.base.cra_name		=3D "cfb64(aes)",
 	.base.cra_driver_name	=3D "atmel-cfb64-aes",
-	.base.cra_priority	=3D ATMEL_AES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB64_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_aes_ctx),
-	.base.cra_alignmask	=3D 0xf,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_aes_init_tfm,
 	.min_keysize		=3D AES_MIN_KEY_SIZE,
@@ -1825,12 +1789,8 @@ static struct aead_alg aes_gcm_alg =3D {
 	.base =3D {
 		.cra_name		=3D "gcm(aes)",
 		.cra_driver_name	=3D "atmel-gcm-aes",
-		.cra_priority		=3D ATMEL_AES_PRIORITY,
-		.cra_flags		=3D CRYPTO_ALG_ASYNC,
 		.cra_blocksize		=3D 1,
 		.cra_ctxsize		=3D sizeof(struct atmel_aes_gcm_ctx),
-		.cra_alignmask		=3D 0xf,
-		.cra_module		=3D THIS_MODULE,
 	},
 };
=20
@@ -1947,12 +1907,8 @@ static int atmel_aes_xts_init_tfm(struct crypto_skci=
pher *tfm)
 static struct skcipher_alg aes_xts_alg =3D {
 	.base.cra_name		=3D "xts(aes)",
 	.base.cra_driver_name	=3D "atmel-xts-aes",
-	.base.cra_priority	=3D ATMEL_AES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D AES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_aes_xts_ctx),
-	.base.cra_alignmask	=3D 0xf,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.min_keysize		=3D 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		=3D 2 * AES_MAX_KEY_SIZE,
@@ -2252,12 +2208,8 @@ static struct aead_alg aes_authenc_algs[] =3D {
 	.base =3D {
 		.cra_name		=3D "authenc(hmac(sha1),cbc(aes))",
 		.cra_driver_name	=3D "atmel-authenc-hmac-sha1-cbc-aes",
-		.cra_priority		=3D ATMEL_AES_PRIORITY,
-		.cra_flags		=3D CRYPTO_ALG_ASYNC,
 		.cra_blocksize		=3D AES_BLOCK_SIZE,
 		.cra_ctxsize		=3D sizeof(struct atmel_aes_authenc_ctx),
-		.cra_alignmask		=3D 0xf,
-		.cra_module		=3D THIS_MODULE,
 	},
 },
 {
@@ -2272,12 +2224,8 @@ static struct aead_alg aes_authenc_algs[] =3D {
 	.base =3D {
 		.cra_name		=3D "authenc(hmac(sha224),cbc(aes))",
 		.cra_driver_name	=3D "atmel-authenc-hmac-sha224-cbc-aes",
-		.cra_priority		=3D ATMEL_AES_PRIORITY,
-		.cra_flags		=3D CRYPTO_ALG_ASYNC,
 		.cra_blocksize		=3D AES_BLOCK_SIZE,
 		.cra_ctxsize		=3D sizeof(struct atmel_aes_authenc_ctx),
-		.cra_alignmask		=3D 0xf,
-		.cra_module		=3D THIS_MODULE,
 	},
 },
 {
@@ -2292,12 +2240,8 @@ static struct aead_alg aes_authenc_algs[] =3D {
 	.base =3D {
 		.cra_name		=3D "authenc(hmac(sha256),cbc(aes))",
 		.cra_driver_name	=3D "atmel-authenc-hmac-sha256-cbc-aes",
-		.cra_priority		=3D ATMEL_AES_PRIORITY,
-		.cra_flags		=3D CRYPTO_ALG_ASYNC,
 		.cra_blocksize		=3D AES_BLOCK_SIZE,
 		.cra_ctxsize		=3D sizeof(struct atmel_aes_authenc_ctx),
-		.cra_alignmask		=3D 0xf,
-		.cra_module		=3D THIS_MODULE,
 	},
 },
 {
@@ -2312,12 +2256,8 @@ static struct aead_alg aes_authenc_algs[] =3D {
 	.base =3D {
 		.cra_name		=3D "authenc(hmac(sha384),cbc(aes))",
 		.cra_driver_name	=3D "atmel-authenc-hmac-sha384-cbc-aes",
-		.cra_priority		=3D ATMEL_AES_PRIORITY,
-		.cra_flags		=3D CRYPTO_ALG_ASYNC,
 		.cra_blocksize		=3D AES_BLOCK_SIZE,
 		.cra_ctxsize		=3D sizeof(struct atmel_aes_authenc_ctx),
-		.cra_alignmask		=3D 0xf,
-		.cra_module		=3D THIS_MODULE,
 	},
 },
 {
@@ -2332,12 +2272,8 @@ static struct aead_alg aes_authenc_algs[] =3D {
 	.base =3D {
 		.cra_name		=3D "authenc(hmac(sha512),cbc(aes))",
 		.cra_driver_name	=3D "atmel-authenc-hmac-sha512-cbc-aes",
-		.cra_priority		=3D ATMEL_AES_PRIORITY,
-		.cra_flags		=3D CRYPTO_ALG_ASYNC,
 		.cra_blocksize		=3D AES_BLOCK_SIZE,
 		.cra_ctxsize		=3D sizeof(struct atmel_aes_authenc_ctx),
-		.cra_alignmask		=3D 0xf,
-		.cra_module		=3D THIS_MODULE,
 	},
 },
 };
@@ -2469,29 +2405,45 @@ static void atmel_aes_unregister_algs(struct atmel_=
aes_dev *dd)
 		crypto_unregister_skcipher(&aes_algs[i]);
 }
=20
+static void atmel_aes_crypto_alg_init(struct crypto_alg *alg)
+{
+	alg->cra_flags =3D CRYPTO_ALG_ASYNC;
+	alg->cra_alignmask =3D 0xf;
+	alg->cra_priority =3D ATMEL_AES_PRIORITY;
+	alg->cra_module =3D THIS_MODULE;
+}
+
 static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 {
 	int err, i, j;
=20
 	for (i =3D 0; i < ARRAY_SIZE(aes_algs); i++) {
+		atmel_aes_crypto_alg_init(&aes_algs[i].base);
+
 		err =3D crypto_register_skcipher(&aes_algs[i]);
 		if (err)
 			goto err_aes_algs;
 	}
=20
 	if (dd->caps.has_cfb64) {
+		atmel_aes_crypto_alg_init(&aes_cfb64_alg.base);
+
 		err =3D crypto_register_skcipher(&aes_cfb64_alg);
 		if (err)
 			goto err_aes_cfb64_alg;
 	}
=20
 	if (dd->caps.has_gcm) {
+		atmel_aes_crypto_alg_init(&aes_gcm_alg.base);
+
 		err =3D crypto_register_aead(&aes_gcm_alg);
 		if (err)
 			goto err_aes_gcm_alg;
 	}
=20
 	if (dd->caps.has_xts) {
+		atmel_aes_crypto_alg_init(&aes_xts_alg.base);
+
 		err =3D crypto_register_skcipher(&aes_xts_alg);
 		if (err)
 			goto err_aes_xts_alg;
@@ -2500,6 +2452,8 @@ static int atmel_aes_register_algs(struct atmel_aes_d=
ev *dd)
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->caps.has_authenc) {
 		for (i =3D 0; i < ARRAY_SIZE(aes_authenc_algs); i++) {
+			atmel_aes_crypto_alg_init(&aes_authenc_algs[i].base);
+
 			err =3D crypto_register_aead(&aes_authenc_algs[i]);
 			if (err)
 				goto err_aes_authenc_alg;
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index a620a6a1cee3..0412c4f0d743 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1252,130 +1252,66 @@ static int atmel_sha_cra_init(struct crypto_tfm *t=
fm)
 	return 0;
 }
=20
+static void atmel_sha_alg_init(struct ahash_alg *alg)
+{
+	alg->halg.base.cra_priority =3D ATMEL_SHA_PRIORITY;
+	alg->halg.base.cra_flags =3D CRYPTO_ALG_ASYNC;
+	alg->halg.base.cra_ctxsize =3D sizeof(struct atmel_sha_ctx);
+	alg->halg.base.cra_module =3D THIS_MODULE;
+	alg->halg.base.cra_init =3D atmel_sha_cra_init;
+
+	alg->halg.statesize =3D sizeof(struct atmel_sha_reqctx);
+
+	alg->init =3D atmel_sha_init;
+	alg->update =3D atmel_sha_update;
+	alg->final =3D atmel_sha_final;
+	alg->finup =3D atmel_sha_finup;
+	alg->digest =3D atmel_sha_digest;
+	alg->export =3D atmel_sha_export;
+	alg->import =3D atmel_sha_import;
+}
+
 static struct ahash_alg sha_1_256_algs[] =3D {
 {
-	.init		=3D atmel_sha_init,
-	.update		=3D atmel_sha_update,
-	.final		=3D atmel_sha_final,
-	.finup		=3D atmel_sha_finup,
-	.digest		=3D atmel_sha_digest,
-	.export		=3D atmel_sha_export,
-	.import		=3D atmel_sha_import,
-	.halg =3D {
-		.digestsize	=3D SHA1_DIGEST_SIZE,
-		.statesize	=3D sizeof(struct atmel_sha_reqctx),
-		.base	=3D {
-			.cra_name		=3D "sha1",
-			.cra_driver_name	=3D "atmel-sha1",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
-			.cra_blocksize		=3D SHA1_BLOCK_SIZE,
-			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
-			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
-			.cra_init		=3D atmel_sha_cra_init,
-		}
-	}
+	.halg.base.cra_name		=3D "sha1",
+	.halg.base.cra_driver_name	=3D "atmel-sha1",
+	.halg.base.cra_blocksize	=3D SHA1_BLOCK_SIZE,
+
+	.halg.digestsize =3D SHA1_DIGEST_SIZE,
 },
 {
-	.init		=3D atmel_sha_init,
-	.update		=3D atmel_sha_update,
-	.final		=3D atmel_sha_final,
-	.finup		=3D atmel_sha_finup,
-	.digest		=3D atmel_sha_digest,
-	.export		=3D atmel_sha_export,
-	.import		=3D atmel_sha_import,
-	.halg =3D {
-		.digestsize	=3D SHA256_DIGEST_SIZE,
-		.statesize	=3D sizeof(struct atmel_sha_reqctx),
-		.base	=3D {
-			.cra_name		=3D "sha256",
-			.cra_driver_name	=3D "atmel-sha256",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
-			.cra_blocksize		=3D SHA256_BLOCK_SIZE,
-			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
-			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
-			.cra_init		=3D atmel_sha_cra_init,
-		}
-	}
+	.halg.base.cra_name		=3D "sha256",
+	.halg.base.cra_driver_name	=3D "atmel-sha256",
+	.halg.base.cra_blocksize	=3D SHA256_BLOCK_SIZE,
+
+	.halg.digestsize =3D SHA256_DIGEST_SIZE,
 },
 };
=20
 static struct ahash_alg sha_224_alg =3D {
-	.init		=3D atmel_sha_init,
-	.update		=3D atmel_sha_update,
-	.final		=3D atmel_sha_final,
-	.finup		=3D atmel_sha_finup,
-	.digest		=3D atmel_sha_digest,
-	.export		=3D atmel_sha_export,
-	.import		=3D atmel_sha_import,
-	.halg =3D {
-		.digestsize	=3D SHA224_DIGEST_SIZE,
-		.statesize	=3D sizeof(struct atmel_sha_reqctx),
-		.base	=3D {
-			.cra_name		=3D "sha224",
-			.cra_driver_name	=3D "atmel-sha224",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
-			.cra_blocksize		=3D SHA224_BLOCK_SIZE,
-			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
-			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
-			.cra_init		=3D atmel_sha_cra_init,
-		}
-	}
+	.halg.base.cra_name		=3D "sha224",
+	.halg.base.cra_driver_name	=3D "atmel-sha224",
+	.halg.base.cra_blocksize	=3D SHA224_BLOCK_SIZE,
+
+	.halg.digestsize =3D SHA224_DIGEST_SIZE,
 };
=20
 static struct ahash_alg sha_384_512_algs[] =3D {
 {
-	.init		=3D atmel_sha_init,
-	.update		=3D atmel_sha_update,
-	.final		=3D atmel_sha_final,
-	.finup		=3D atmel_sha_finup,
-	.digest		=3D atmel_sha_digest,
-	.export		=3D atmel_sha_export,
-	.import		=3D atmel_sha_import,
-	.halg =3D {
-		.digestsize	=3D SHA384_DIGEST_SIZE,
-		.statesize	=3D sizeof(struct atmel_sha_reqctx),
-		.base	=3D {
-			.cra_name		=3D "sha384",
-			.cra_driver_name	=3D "atmel-sha384",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
-			.cra_blocksize		=3D SHA384_BLOCK_SIZE,
-			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
-			.cra_alignmask		=3D 0x3,
-			.cra_module		=3D THIS_MODULE,
-			.cra_init		=3D atmel_sha_cra_init,
-		}
-	}
+	.halg.base.cra_name		=3D "sha384",
+	.halg.base.cra_driver_name	=3D "atmel-sha384",
+	.halg.base.cra_blocksize	=3D SHA384_BLOCK_SIZE,
+	.halg.base.cra_alignmask	=3D 0x3,
+
+	.halg.digestsize =3D SHA384_DIGEST_SIZE,
 },
 {
-	.init		=3D atmel_sha_init,
-	.update		=3D atmel_sha_update,
-	.final		=3D atmel_sha_final,
-	.finup		=3D atmel_sha_finup,
-	.digest		=3D atmel_sha_digest,
-	.export		=3D atmel_sha_export,
-	.import		=3D atmel_sha_import,
-	.halg =3D {
-		.digestsize	=3D SHA512_DIGEST_SIZE,
-		.statesize	=3D sizeof(struct atmel_sha_reqctx),
-		.base	=3D {
-			.cra_name		=3D "sha512",
-			.cra_driver_name	=3D "atmel-sha512",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
-			.cra_blocksize		=3D SHA512_BLOCK_SIZE,
-			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
-			.cra_alignmask		=3D 0x3,
-			.cra_module		=3D THIS_MODULE,
-			.cra_init		=3D atmel_sha_cra_init,
-		}
-	}
+	.halg.base.cra_name		=3D "sha512",
+	.halg.base.cra_driver_name	=3D "atmel-sha512",
+	.halg.base.cra_blocksize	=3D SHA512_BLOCK_SIZE,
+	.halg.base.cra_alignmask	=3D 0x3,
+
+	.halg.digestsize =3D SHA512_DIGEST_SIZE,
 },
 };
=20
@@ -2084,131 +2020,61 @@ static void atmel_sha_hmac_cra_exit(struct crypto_=
tfm *tfm)
 	atmel_sha_hmac_key_release(&hmac->hkey);
 }
=20
+static void atmel_sha_hmac_alg_init(struct ahash_alg *alg)
+{
+	alg->halg.base.cra_priority =3D ATMEL_SHA_PRIORITY;
+	alg->halg.base.cra_flags =3D CRYPTO_ALG_ASYNC;
+	alg->halg.base.cra_ctxsize =3D sizeof(struct atmel_sha_hmac_ctx);
+	alg->halg.base.cra_module =3D THIS_MODULE;
+	alg->halg.base.cra_init	=3D atmel_sha_hmac_cra_init;
+	alg->halg.base.cra_exit	=3D atmel_sha_hmac_cra_exit;
+
+	alg->halg.statesize =3D sizeof(struct atmel_sha_reqctx);
+
+	alg->init =3D atmel_sha_hmac_init;
+	alg->update =3D atmel_sha_update;
+	alg->final =3D atmel_sha_final;
+	alg->digest =3D atmel_sha_hmac_digest;
+	alg->setkey =3D atmel_sha_hmac_setkey;
+	alg->export =3D atmel_sha_export;
+	alg->import =3D atmel_sha_import;
+}
+
 static struct ahash_alg sha_hmac_algs[] =3D {
 {
-	.init		=3D atmel_sha_hmac_init,
-	.update		=3D atmel_sha_update,
-	.final		=3D atmel_sha_final,
-	.digest		=3D atmel_sha_hmac_digest,
-	.setkey		=3D atmel_sha_hmac_setkey,
-	.export		=3D atmel_sha_export,
-	.import		=3D atmel_sha_import,
-	.halg =3D {
-		.digestsize	=3D SHA1_DIGEST_SIZE,
-		.statesize	=3D sizeof(struct atmel_sha_reqctx),
-		.base	=3D {
-			.cra_name		=3D "hmac(sha1)",
-			.cra_driver_name	=3D "atmel-hmac-sha1",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
-			.cra_blocksize		=3D SHA1_BLOCK_SIZE,
-			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
-			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
-			.cra_init		=3D atmel_sha_hmac_cra_init,
-			.cra_exit		=3D atmel_sha_hmac_cra_exit,
-		}
-	}
+	.halg.base.cra_name		=3D "hmac(sha1)",
+	.halg.base.cra_driver_name	=3D "atmel-hmac-sha1",
+	.halg.base.cra_blocksize	=3D SHA1_BLOCK_SIZE,
+
+	.halg.digestsize =3D SHA1_DIGEST_SIZE,
 },
 {
-	.init		=3D atmel_sha_hmac_init,
-	.update		=3D atmel_sha_update,
-	.final		=3D atmel_sha_final,
-	.digest		=3D atmel_sha_hmac_digest,
-	.setkey		=3D atmel_sha_hmac_setkey,
-	.export		=3D atmel_sha_export,
-	.import		=3D atmel_sha_import,
-	.halg =3D {
-		.digestsize	=3D SHA224_DIGEST_SIZE,
-		.statesize	=3D sizeof(struct atmel_sha_reqctx),
-		.base	=3D {
-			.cra_name		=3D "hmac(sha224)",
-			.cra_driver_name	=3D "atmel-hmac-sha224",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
-			.cra_blocksize		=3D SHA224_BLOCK_SIZE,
-			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
-			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
-			.cra_init		=3D atmel_sha_hmac_cra_init,
-			.cra_exit		=3D atmel_sha_hmac_cra_exit,
-		}
-	}
+	.halg.base.cra_name		=3D "hmac(sha224)",
+	.halg.base.cra_driver_name	=3D "atmel-hmac-sha224",
+	.halg.base.cra_blocksize	=3D SHA224_BLOCK_SIZE,
+
+	.halg.digestsize =3D SHA224_DIGEST_SIZE,
 },
 {
-	.init		=3D atmel_sha_hmac_init,
-	.update		=3D atmel_sha_update,
-	.final		=3D atmel_sha_final,
-	.digest		=3D atmel_sha_hmac_digest,
-	.setkey		=3D atmel_sha_hmac_setkey,
-	.export		=3D atmel_sha_export,
-	.import		=3D atmel_sha_import,
-	.halg =3D {
-		.digestsize	=3D SHA256_DIGEST_SIZE,
-		.statesize	=3D sizeof(struct atmel_sha_reqctx),
-		.base	=3D {
-			.cra_name		=3D "hmac(sha256)",
-			.cra_driver_name	=3D "atmel-hmac-sha256",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
-			.cra_blocksize		=3D SHA256_BLOCK_SIZE,
-			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
-			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
-			.cra_init		=3D atmel_sha_hmac_cra_init,
-			.cra_exit		=3D atmel_sha_hmac_cra_exit,
-		}
-	}
+	.halg.base.cra_name		=3D "hmac(sha256)",
+	.halg.base.cra_driver_name	=3D "atmel-hmac-sha256",
+	.halg.base.cra_blocksize	=3D SHA256_BLOCK_SIZE,
+
+	.halg.digestsize =3D SHA256_DIGEST_SIZE,
 },
 {
-	.init		=3D atmel_sha_hmac_init,
-	.update		=3D atmel_sha_update,
-	.final		=3D atmel_sha_final,
-	.digest		=3D atmel_sha_hmac_digest,
-	.setkey		=3D atmel_sha_hmac_setkey,
-	.export		=3D atmel_sha_export,
-	.import		=3D atmel_sha_import,
-	.halg =3D {
-		.digestsize	=3D SHA384_DIGEST_SIZE,
-		.statesize	=3D sizeof(struct atmel_sha_reqctx),
-		.base	=3D {
-			.cra_name		=3D "hmac(sha384)",
-			.cra_driver_name	=3D "atmel-hmac-sha384",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
-			.cra_blocksize		=3D SHA384_BLOCK_SIZE,
-			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
-			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
-			.cra_init		=3D atmel_sha_hmac_cra_init,
-			.cra_exit		=3D atmel_sha_hmac_cra_exit,
-		}
-	}
+	.halg.base.cra_name		=3D "hmac(sha384)",
+	.halg.base.cra_driver_name	=3D "atmel-hmac-sha384",
+	.halg.base.cra_blocksize	=3D SHA384_BLOCK_SIZE,
+
+	.halg.digestsize =3D SHA384_DIGEST_SIZE,
 },
 {
-	.init		=3D atmel_sha_hmac_init,
-	.update		=3D atmel_sha_update,
-	.final		=3D atmel_sha_final,
-	.digest		=3D atmel_sha_hmac_digest,
-	.setkey		=3D atmel_sha_hmac_setkey,
-	.export		=3D atmel_sha_export,
-	.import		=3D atmel_sha_import,
-	.halg =3D {
-		.digestsize	=3D SHA512_DIGEST_SIZE,
-		.statesize	=3D sizeof(struct atmel_sha_reqctx),
-		.base	=3D {
-			.cra_name		=3D "hmac(sha512)",
-			.cra_driver_name	=3D "atmel-hmac-sha512",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
-			.cra_blocksize		=3D SHA512_BLOCK_SIZE,
-			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
-			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
-			.cra_init		=3D atmel_sha_hmac_cra_init,
-			.cra_exit		=3D atmel_sha_hmac_cra_exit,
-		}
-	}
+	.halg.base.cra_name		=3D "hmac(sha512)",
+	.halg.base.cra_driver_name	=3D "atmel-hmac-sha512",
+	.halg.base.cra_blocksize	=3D SHA512_BLOCK_SIZE,
+
+	.halg.digestsize =3D SHA512_DIGEST_SIZE,
 },
 };
=20
@@ -2561,12 +2427,16 @@ static int atmel_sha_register_algs(struct atmel_sha=
_dev *dd)
 	int err, i, j;
=20
 	for (i =3D 0; i < ARRAY_SIZE(sha_1_256_algs); i++) {
+		atmel_sha_alg_init(&sha_1_256_algs[i]);
+
 		err =3D crypto_register_ahash(&sha_1_256_algs[i]);
 		if (err)
 			goto err_sha_1_256_algs;
 	}
=20
 	if (dd->caps.has_sha224) {
+		atmel_sha_alg_init(&sha_224_alg);
+
 		err =3D crypto_register_ahash(&sha_224_alg);
 		if (err)
 			goto err_sha_224_algs;
@@ -2574,6 +2444,8 @@ static int atmel_sha_register_algs(struct atmel_sha_d=
ev *dd)
=20
 	if (dd->caps.has_sha_384_512) {
 		for (i =3D 0; i < ARRAY_SIZE(sha_384_512_algs); i++) {
+			atmel_sha_alg_init(&sha_384_512_algs[i]);
+
 			err =3D crypto_register_ahash(&sha_384_512_algs[i]);
 			if (err)
 				goto err_sha_384_512_algs;
@@ -2582,6 +2454,8 @@ static int atmel_sha_register_algs(struct atmel_sha_d=
ev *dd)
=20
 	if (dd->caps.has_hmac) {
 		for (i =3D 0; i < ARRAY_SIZE(sha_hmac_algs); i++) {
+			atmel_sha_hmac_alg_init(&sha_hmac_algs[i]);
+
 			err =3D crypto_register_ahash(&sha_hmac_algs[i]);
 			if (err)
 				goto err_sha_hmac_algs;
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index d10be95a6470..b4b758604f44 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -924,18 +924,23 @@ static int atmel_tdes_init_tfm(struct crypto_skcipher=
 *tfm)
 	return 0;
 }
=20
+static void atmel_tdes_skcipher_alg_init(struct skcipher_alg *alg)
+{
+	alg->base.cra_priority =3D ATMEL_TDES_PRIORITY;
+	alg->base.cra_flags =3D CRYPTO_ALG_ASYNC;
+	alg->base.cra_ctxsize =3D sizeof(struct atmel_tdes_ctx),
+	alg->base.cra_module =3D THIS_MODULE;
+
+	alg->init =3D atmel_tdes_init_tfm;
+}
+
 static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ecb(des)",
 	.base.cra_driver_name	=3D "atmel-ecb-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
-	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
-	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
 	.max_keysize		=3D DES_KEY_SIZE,
 	.setkey			=3D atmel_des_setkey,
@@ -945,14 +950,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cbc(des)",
 	.base.cra_driver_name	=3D "atmel-cbc-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
-	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
-	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
 	.max_keysize		=3D DES_KEY_SIZE,
 	.ivsize			=3D DES_BLOCK_SIZE,
@@ -963,14 +963,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb(des)",
 	.base.cra_driver_name	=3D "atmel-cfb-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
-	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
-	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
 	.max_keysize		=3D DES_KEY_SIZE,
 	.ivsize			=3D DES_BLOCK_SIZE,
@@ -981,14 +976,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb8(des)",
 	.base.cra_driver_name	=3D "atmel-cfb8-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB8_BLOCK_SIZE,
-	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0,
-	.base.cra_module	=3D THIS_MODULE,
=20
-	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
 	.max_keysize		=3D DES_KEY_SIZE,
 	.ivsize			=3D DES_BLOCK_SIZE,
@@ -999,14 +989,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb16(des)",
 	.base.cra_driver_name	=3D "atmel-cfb16-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB16_BLOCK_SIZE,
-	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x1,
-	.base.cra_module	=3D THIS_MODULE,
=20
-	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
 	.max_keysize		=3D DES_KEY_SIZE,
 	.ivsize			=3D DES_BLOCK_SIZE,
@@ -1017,14 +1002,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb32(des)",
 	.base.cra_driver_name	=3D "atmel-cfb32-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB32_BLOCK_SIZE,
-	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x3,
-	.base.cra_module	=3D THIS_MODULE,
=20
-	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
 	.max_keysize		=3D DES_KEY_SIZE,
 	.ivsize			=3D DES_BLOCK_SIZE,
@@ -1035,14 +1015,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ofb(des)",
 	.base.cra_driver_name	=3D "atmel-ofb-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
-	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
-	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
 	.max_keysize		=3D DES_KEY_SIZE,
 	.ivsize			=3D DES_BLOCK_SIZE,
@@ -1053,14 +1028,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ecb(des3_ede)",
 	.base.cra_driver_name	=3D "atmel-ecb-tdes",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
-	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
-	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES3_EDE_KEY_SIZE,
 	.max_keysize		=3D DES3_EDE_KEY_SIZE,
 	.setkey			=3D atmel_tdes_setkey,
@@ -1070,14 +1040,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cbc(des3_ede)",
 	.base.cra_driver_name	=3D "atmel-cbc-tdes",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
-	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
-	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES3_EDE_KEY_SIZE,
 	.max_keysize		=3D DES3_EDE_KEY_SIZE,
 	.setkey			=3D atmel_tdes_setkey,
@@ -1088,14 +1053,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ofb(des3_ede)",
 	.base.cra_driver_name	=3D "atmel-ofb-tdes",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
-	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
-	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES3_EDE_KEY_SIZE,
 	.max_keysize		=3D DES3_EDE_KEY_SIZE,
 	.setkey			=3D atmel_tdes_setkey,
@@ -1170,6 +1130,8 @@ static int atmel_tdes_register_algs(struct atmel_tdes=
_dev *dd)
 	int err, i, j;
=20
 	for (i =3D 0; i < ARRAY_SIZE(tdes_algs); i++) {
+		atmel_tdes_skcipher_alg_init(&tdes_algs[i]);
+
 		err =3D crypto_register_skcipher(&tdes_algs[i]);
 		if (err)
 			goto err_tdes_algs;
--=20
2.14.5

