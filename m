Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A6BC2BD09
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 995BC24655
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="eqTD8tZ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbfLEJyP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:54:15 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:55114 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729456AbfLEJyO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:54:14 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: u/9sCziHZgaGjJ7pTSFsQb4Oo5wmAlpeDCDTtTAKpn+fdyy7YElT/NsKNBweS0oUUg+E/xz0fU
 7yFsc3+/LfYU/bsSoc1CJFIvpYyWxMf4oVJKVZUYfhMqNQIh+FTGC2DHbA/bOXVLmd72rSO8mZ
 fq0TThSisNbXscHb6HI9GFYSSDxQVVRpCAoS/hIMnqnSgxzJsbbJ/lBdAwNllfHoPCpNnVrBmb
 d7iP9w6+AwNQS78Nj43TORSRBaoJA+tZgxP2WdyPtWhXQHQMf5HCM18eE4pmhiRP7QCz8ri4i+
 vVg=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="57907214"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:54:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:54:14 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 5 Dec 2019 02:54:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3k7ckOmBk8vSVy52zmGtwnjA/NXrNW//VtVrMtHjYtlgJmaFQeuHOMd+xpqMQQPZIPLymx5KQvuiaQxN3iyUVoXQquYf+m3kWhSdV2H1+4K5ycHm32n5Hzxa381pOua5GBvWcx6d+RpZq1ZIZ8xv+6eMYh7csnukYDKDmBuMtSLYtOxeU+VqD4EQUXZfQ2/mFPSmeNzyqWsALJ0XK3Ezztp7sRe3027qFvUeVlUvLDQFdkzkBQVhdfOXt14wS/sZYel1azkC9ekLu8nAgbZ4pV7XYFNGAiqFW4n27sHmzjzuVwT9BAJCuAIV0Pxi4i0pBaHeIf0U0jQw8Mirw9lAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31S7h+yxA9Ut53hiDOgLJ4EBGdjNO7I5oNVRxf+NHNU=;
 b=V151UDtLBli7RX0mhqYuvP+1WFDO106KSM3MCKNIgwojENpBM76lZoR2Ah0UEzvyu7KgDcEp/+zWQexGonuab9tP9v+WSc1fbDrt2A9c2gBm2tHLaKioTbLALPJa1Y12hgnfaNyX4Gco94QHuW2oapi7cr22ytSAwLaIyJRy2B/6FUW44FdPLGbdNqNfKk5n72U9k/OgXhdC8IUlEoDErpVUG1aApwSXX9X1LM8qXd2U7XJ8npvgPuOhoVL0UdVoNvubW66OS9GUTtCy7DWEVFr+RZ4y0po0LZVWeRRh2CNEvJuVXftcD6A8/ziHw23dfXb/Ciqiqe2LFmdAtEURaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31S7h+yxA9Ut53hiDOgLJ4EBGdjNO7I5oNVRxf+NHNU=;
 b=eqTD8tZ/owL5oc7uwnozCrUMq6tBf9MBbbe0u173of4paD+eMwgwKHD6aUceGBAUwqjNEgfywPx7HPbUqWOQ0NevOpOW90lFAkAqyNmR/kdEcvEDH/9ldoEHTjwAzNJw0LFd3FcwCHzNSKgo16JuNQI3Rww7ZvvW7KrJflOUmR4=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB4288.namprd11.prod.outlook.com (52.135.37.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Thu, 5 Dec 2019 09:54:10 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:54:10 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 16/16] crypto: atmel-{aes,sha,tdes} - Group common alg type
 init in dedicated methods
Thread-Topic: [PATCH 16/16] crypto: atmel-{aes,sha,tdes} - Group common alg
 type init in dedicated methods
Thread-Index: AQHVq1HxV08z2q1qzUizBwqVxO+JTQ==
Date:   Thu, 5 Dec 2019 09:54:10 +0000
Message-ID: <20191205095326.5094-17-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: a3ae047b-b0c2-4fe1-233d-08d779691388
x-ms-traffictypediagnostic: MN2PR11MB4288:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB428855C7CB19E1FE150922B2F05C0@MN2PR11MB4288.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(6506007)(1076003)(305945005)(4326008)(2616005)(86362001)(478600001)(11346002)(102836004)(107886003)(2906002)(50226002)(5660300002)(66446008)(66946007)(66476007)(66556008)(14454004)(1730700003)(64756008)(76176011)(8936002)(52116002)(81166006)(186003)(5640700003)(81156014)(36756003)(71200400001)(71190400001)(54906003)(6512007)(316002)(6486002)(30864003)(25786009)(8676002)(26005)(6916009)(99286004)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4288;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3lxjIcR3YaVcgmf2KIN+EbJUCqsf0KnybRkphJskb24FOQ2PpPd9fjyPkydzeV5MQfDtCXI0Iz7vyaEXw+4YDQ2XMe6HIGKPSlHQNo/HzrcePc3wu8rJ2JVU14xaNTJqUa1xBxz3E+Qu9MVW3awF53PUFAOOkUWNA2hsoi+InbJYQUNe0LEM8+DrmT88uqpcqHncYyVUftsvR4PHhsZdNSlxLqWHe1yG3R5YHxnIn62PIob+MyZhpoN0AN+b9Lp1vE3FdfNwXKywTrYaXflQU1wLs8pME687/gCzn22TzuF00eqhY4dkzcP30nvYZmnE3sFJC2zn/CDA4fDJSzYJTUr1WURraCTBO+ZK/p+bGvnrJ02BI7JSm5DR2OwK+CzuuFXQBE3ES3IQAWRpmf9UyeDREH1ZtKDXvMksyYhZ/QuXzgYRfjnLSloMFJ1sTDr5y0C9xEGmzENIqSIFYtWMQ+1UXev7Vr21wyJ31VIXmB0T0ceACJBWCiwWWZH9uTnu
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ae047b-b0c2-4fe1-233d-08d779691388
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:54:10.4149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eXyCPXQ24UVe2QQT4uk2wlWfLBcHZnZ+eRZjK7ge0eT8K4h+a/y6XnHHCDzOqN56+K7LbzsYm0YjrXpIEncbVYEReOL428deydm3A/JsUSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4288
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

Move common alg type init to dedicated methods.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 82 ++++++++++-------------------------------=
----
 drivers/crypto/atmel-sha.c  | 45 +++++++++----------------
 drivers/crypto/atmel-tdes.c | 39 +++++----------------
 3 files changed, 42 insertions(+), 124 deletions(-)

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
index a620a6a1cee3..a91612c94755 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1267,12 +1267,9 @@ static struct ahash_alg sha_1_256_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "sha1",
 			.cra_driver_name	=3D "atmel-sha1",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA1_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
 			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
 			.cra_init		=3D atmel_sha_cra_init,
 		}
 	}
@@ -1291,12 +1288,9 @@ static struct ahash_alg sha_1_256_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "sha256",
 			.cra_driver_name	=3D "atmel-sha256",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA256_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
 			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
 			.cra_init		=3D atmel_sha_cra_init,
 		}
 	}
@@ -1317,12 +1311,9 @@ static struct ahash_alg sha_224_alg =3D {
 		.base	=3D {
 			.cra_name		=3D "sha224",
 			.cra_driver_name	=3D "atmel-sha224",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA224_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
 			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
 			.cra_init		=3D atmel_sha_cra_init,
 		}
 	}
@@ -1343,12 +1334,9 @@ static struct ahash_alg sha_384_512_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "sha384",
 			.cra_driver_name	=3D "atmel-sha384",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA384_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
 			.cra_alignmask		=3D 0x3,
-			.cra_module		=3D THIS_MODULE,
 			.cra_init		=3D atmel_sha_cra_init,
 		}
 	}
@@ -1367,12 +1355,9 @@ static struct ahash_alg sha_384_512_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "sha512",
 			.cra_driver_name	=3D "atmel-sha512",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA512_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
 			.cra_alignmask		=3D 0x3,
-			.cra_module		=3D THIS_MODULE,
 			.cra_init		=3D atmel_sha_cra_init,
 		}
 	}
@@ -2099,12 +2084,9 @@ static struct ahash_alg sha_hmac_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "hmac(sha1)",
 			.cra_driver_name	=3D "atmel-hmac-sha1",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA1_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
 			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
 			.cra_init		=3D atmel_sha_hmac_cra_init,
 			.cra_exit		=3D atmel_sha_hmac_cra_exit,
 		}
@@ -2124,12 +2106,9 @@ static struct ahash_alg sha_hmac_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "hmac(sha224)",
 			.cra_driver_name	=3D "atmel-hmac-sha224",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA224_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
 			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
 			.cra_init		=3D atmel_sha_hmac_cra_init,
 			.cra_exit		=3D atmel_sha_hmac_cra_exit,
 		}
@@ -2149,11 +2128,8 @@ static struct ahash_alg sha_hmac_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "hmac(sha256)",
 			.cra_driver_name	=3D "atmel-hmac-sha256",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA256_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
-			.cra_alignmask		=3D 0,
 			.cra_module		=3D THIS_MODULE,
 			.cra_init		=3D atmel_sha_hmac_cra_init,
 			.cra_exit		=3D atmel_sha_hmac_cra_exit,
@@ -2174,12 +2150,9 @@ static struct ahash_alg sha_hmac_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "hmac(sha384)",
 			.cra_driver_name	=3D "atmel-hmac-sha384",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA384_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
 			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
 			.cra_init		=3D atmel_sha_hmac_cra_init,
 			.cra_exit		=3D atmel_sha_hmac_cra_exit,
 		}
@@ -2199,12 +2172,9 @@ static struct ahash_alg sha_hmac_algs[] =3D {
 		.base	=3D {
 			.cra_name		=3D "hmac(sha512)",
 			.cra_driver_name	=3D "atmel-hmac-sha512",
-			.cra_priority		=3D ATMEL_SHA_PRIORITY,
-			.cra_flags		=3D CRYPTO_ALG_ASYNC,
 			.cra_blocksize		=3D SHA512_BLOCK_SIZE,
 			.cra_ctxsize		=3D sizeof(struct atmel_sha_hmac_ctx),
 			.cra_alignmask		=3D 0,
-			.cra_module		=3D THIS_MODULE,
 			.cra_init		=3D atmel_sha_hmac_cra_init,
 			.cra_exit		=3D atmel_sha_hmac_cra_exit,
 		}
@@ -2556,17 +2526,28 @@ static void atmel_sha_unregister_algs(struct atmel_=
sha_dev *dd)
 	}
 }
=20
+static void atmel_sha_ahash_alg_init(struct ahash_alg *alg)
+{
+	alg->halg.base.cra_flags =3D CRYPTO_ALG_ASYNC;
+	alg->halg.base.cra_priority =3D ATMEL_SHA_PRIORITY;
+	alg->halg.base.cra_module =3D THIS_MODULE;
+}
+
 static int atmel_sha_register_algs(struct atmel_sha_dev *dd)
 {
 	int err, i, j;
=20
 	for (i =3D 0; i < ARRAY_SIZE(sha_1_256_algs); i++) {
+		atmel_sha_ahash_alg_init(&sha_1_256_algs[i]);
+
 		err =3D crypto_register_ahash(&sha_1_256_algs[i]);
 		if (err)
 			goto err_sha_1_256_algs;
 	}
=20
 	if (dd->caps.has_sha224) {
+		atmel_sha_ahash_alg_init(&sha_224_alg);
+
 		err =3D crypto_register_ahash(&sha_224_alg);
 		if (err)
 			goto err_sha_224_algs;
@@ -2574,6 +2555,8 @@ static int atmel_sha_register_algs(struct atmel_sha_d=
ev *dd)
=20
 	if (dd->caps.has_sha_384_512) {
 		for (i =3D 0; i < ARRAY_SIZE(sha_384_512_algs); i++) {
+			atmel_sha_ahash_alg_init(&sha_384_512_algs[i]);
+
 			err =3D crypto_register_ahash(&sha_384_512_algs[i]);
 			if (err)
 				goto err_sha_384_512_algs;
@@ -2582,6 +2565,8 @@ static int atmel_sha_register_algs(struct atmel_sha_d=
ev *dd)
=20
 	if (dd->caps.has_hmac) {
 		for (i =3D 0; i < ARRAY_SIZE(sha_hmac_algs); i++) {
+			atmel_sha_ahash_alg_init(&sha_hmac_algs[i]);
+
 			err =3D crypto_register_ahash(&sha_hmac_algs[i]);
 			if (err)
 				goto err_sha_hmac_algs;
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index d10be95a6470..6bb9d48379a2 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -928,12 +928,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ecb(des)",
 	.base.cra_driver_name	=3D "atmel-ecb-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
@@ -945,12 +942,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cbc(des)",
 	.base.cra_driver_name	=3D "atmel-cbc-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
@@ -963,12 +957,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb(des)",
 	.base.cra_driver_name	=3D "atmel-cfb-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
@@ -981,12 +972,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb8(des)",
 	.base.cra_driver_name	=3D "atmel-cfb8-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB8_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
@@ -999,12 +987,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb16(des)",
 	.base.cra_driver_name	=3D "atmel-cfb16-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB16_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x1,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
@@ -1017,12 +1002,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cfb32(des)",
 	.base.cra_driver_name	=3D "atmel-cfb32-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D CFB32_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x3,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
@@ -1035,12 +1017,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ofb(des)",
 	.base.cra_driver_name	=3D "atmel-ofb-des",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES_KEY_SIZE,
@@ -1053,12 +1032,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ecb(des3_ede)",
 	.base.cra_driver_name	=3D "atmel-ecb-tdes",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES3_EDE_KEY_SIZE,
@@ -1070,12 +1046,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "cbc(des3_ede)",
 	.base.cra_driver_name	=3D "atmel-cbc-tdes",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES3_EDE_KEY_SIZE,
@@ -1088,12 +1061,9 @@ static struct skcipher_alg tdes_algs[] =3D {
 {
 	.base.cra_name		=3D "ofb(des3_ede)",
 	.base.cra_driver_name	=3D "atmel-ofb-tdes",
-	.base.cra_priority	=3D ATMEL_TDES_PRIORITY,
-	.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	=3D DES_BLOCK_SIZE,
 	.base.cra_ctxsize	=3D sizeof(struct atmel_tdes_ctx),
 	.base.cra_alignmask	=3D 0x7,
-	.base.cra_module	=3D THIS_MODULE,
=20
 	.init			=3D atmel_tdes_init_tfm,
 	.min_keysize		=3D DES3_EDE_KEY_SIZE,
@@ -1165,11 +1135,20 @@ static void atmel_tdes_unregister_algs(struct atmel=
_tdes_dev *dd)
 		crypto_unregister_skcipher(&tdes_algs[i]);
 }
=20
+static void atmel_tdes_skcipher_alg_init(struct skcipher_alg *alg)
+{
+	alg->base.cra_flags =3D CRYPTO_ALG_ASYNC;
+	alg->base.cra_priority =3D ATMEL_TDES_PRIORITY;
+	alg->base.cra_module =3D THIS_MODULE;
+}
+
 static int atmel_tdes_register_algs(struct atmel_tdes_dev *dd)
 {
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

