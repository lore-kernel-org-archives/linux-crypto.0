Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12012C43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB2FA224F8
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Z9NRP718"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbfLEJyo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:54:44 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:44627 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729402AbfLEJyG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:54:06 -0500
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
IronPort-SDR: DgjmBG2l3vtdj+xs72GVL7OCfKVl95bvU5/p7Mn1mpanTCej+oMoH0mgN6x9ctoxdSfq3f/0OK
 geUJ80MRY21i86xcnaF2iFRiM9DOSUxhnwWe1eH5JMdjIp1mm39+PrUGgrkm9iM8ihBOPddloY
 IHuC4xIAC2ySeKNR1eUppyRQhm/23+4+fOSHGC5oyWbYaZTKOnkR3Kl6bwZpH9F6PVikJfDvf8
 bJY6pXCZiloNEjTK/S0XZGfS25sRCYym+7xd7tbHNZ6lYtTxblktREhH8E9zMxgBN7cZc4q8vi
 SsE=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="59347330"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:54:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:54:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Dec 2019 02:54:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iiZqPh0Mtnfn5K3IKItNl8wYhLPuJg/wNcuMQIPcISmEYoFRW2CgMs/8F47vDBhaRyXkfGBSxUyob2GovbYpJQ0Aj7kXnM3AcTaxMMqL2rbhL0rFWnFVFur2zhcdpBDiefn72ZE9iIrvfNae1BURO76XYOaKzSGKKdkLAv4VtlF9qHYBcLxIpNGnRZuHY5xQcrrKS7XLtEQLPTkAxs6G+oOk2krbCYmizy3XZpLjUjfFqAEHNnrV/g2LUyVr8Kr1ycRfD1XmDYXcz76TBLhzrqU0+GfHbq4ekdR8FJaRgRWwPrbl1s+oQMhaB6HTYJfrcDVAA+jf42OrlIhYzk/IVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yeLwb2XawRQuHknJR4sP/1YbNCjQLINB9ZRF9097Roo=;
 b=RhXCAwTIKpNFIku4+TGbE93ucoYBNg1HA8wEE0MxvbXrfoVqdKZdQ1jx5+cdbT5ExyTZVtySeYtc25n5ysDFyu9jVMOb0Sr/7pN6aKpHVg87XNKtRii33F7JVDHmcQxFKgB+GkBk8pqlRC+hCNrzhsFfMxcf07LnU2TAVSQQOMT4Qe5SyG9yPuZx55vSgIhvYwyEzhdMU+crfPdwt4GxMLFmjaD26Fm2yWF6IFRo3lCj7XGLzsL++g3Q1WWH8uFaN1grmPhW1KMlXlkBlWaJ32RLJfQj8NqF/iWQkfPBCowZVGk0LPoNohEbdyRyK8XzZFdn6OebUMey3Jaz5YQVCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yeLwb2XawRQuHknJR4sP/1YbNCjQLINB9ZRF9097Roo=;
 b=Z9NRP71896aU3GWqIH1R6zoQ6tFoivT+ptv3oV2uMMb/GBJ04VAD0bMCf7kq6GFerMHg81maS7TWEEcXb22zcHiZ46aa38hVN8xx7PThMhwHOse7UuOcdHPpr8KUYGdEjiTmW1TkIZph0cXNo6f6K5CGcbhbNRzBNgKITMsHd+8=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3677.namprd11.prod.outlook.com (20.178.253.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 09:54:03 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:54:03 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 12/16] crypto: atmel-aes - Fix saving of IV for CTR mode
Thread-Topic: [PATCH 12/16] crypto: atmel-aes - Fix saving of IV for CTR mode
Thread-Index: AQHVq1Hswvi5MUOxfE+TUslwNbNKZA==
Date:   Thu, 5 Dec 2019 09:54:03 +0000
Message-ID: <20191205095326.5094-13-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: fb6c0613-5faa-4099-fee8-08d779690f4d
x-ms-traffictypediagnostic: MN2PR11MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3677B53683A0B83C465F4CFFF05C0@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(2616005)(66556008)(305945005)(66476007)(66446008)(102836004)(64756008)(11346002)(5660300002)(52116002)(76176011)(99286004)(36756003)(66946007)(2906002)(54906003)(26005)(6916009)(6506007)(1076003)(8676002)(6486002)(4326008)(50226002)(1730700003)(8936002)(14454004)(81156014)(186003)(86362001)(81166006)(5640700003)(478600001)(6512007)(71200400001)(25786009)(316002)(71190400001)(14444005)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3677;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VAnEREDJbbtF9P1+QNNjjMsHKtPy5dK53zQlxbhwroFmeInPcEpWhNofzKyTNCZ60vRbSOxjLpIAL9Iq0yXW1IQPXCz2d+csTMd5fKKUePKLuKqZH7q/6WxfAYozDR3SpqIu7euxcGi39vQdZvB9ulJIa40p9f2dHb6N3w19ZdfEKuPk9v4faVArYuzvYGIkdeRhE1wNJUfN7AYICsyQ8IsLimpS1LOPdkUuV9AWaV87VSMBI6+FQZim/F5oQ+e8VXSWyoyxz+JgzT//mcmewZGMkOz87U2hn+4Aaiua9wHknGMjxZmq3kDKdDDb8gs6IWh/vhOON/t903vWc4nrWWNkAiHdNySad/VQS/3uYm+J1PW73Jks965xsD5BkmKGRMbLcagByYOsVoENwbT/KYbFZUXez+cHftbKQlHfylidYcMqJO0JeV+99hXYg32L
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fb6c0613-5faa-4099-fee8-08d779690f4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:54:03.3040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mvGCXLsTO1T6T6f8+pZ9053VaC2xV6x6hZy40hE4UHl7TxvY0DY1tFbKKwu4wn+7k5hYR/J9xTCNf7MmvIVnx039FFHxABKNBNZY2P8vbVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

The req->iv of the skcipher_request is expected to contain the
last used IV. Update the req->iv for CTR mode.

Fixes: bd3c7b5c2aba ("crypto: atmel - add Atmel AES driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c | 43 +++++++++++++++++++++++++++++++-----------=
-
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index cbfe6ccd2a0d..60f54580d646 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -121,6 +121,7 @@ struct atmel_aes_ctr_ctx {
 	size_t			offset;
 	struct scatterlist	src[2];
 	struct scatterlist	dst[2];
+	u16			blocks;
 };
=20
 struct atmel_aes_gcm_ctx {
@@ -513,6 +514,26 @@ static void atmel_aes_set_iv_as_last_ciphertext_block(=
struct atmel_aes_dev *dd)
 	}
 }
=20
+static inline struct atmel_aes_ctr_ctx *
+atmel_aes_ctr_ctx_cast(struct atmel_aes_base_ctx *ctx)
+{
+	return container_of(ctx, struct atmel_aes_ctr_ctx, base);
+}
+
+static void atmel_aes_ctr_update_req_iv(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_ctr_ctx *ctx =3D atmel_aes_ctr_ctx_cast(dd->ctx);
+	struct skcipher_request *req =3D skcipher_request_cast(dd->areq);
+	struct crypto_skcipher *skcipher =3D crypto_skcipher_reqtfm(req);
+	unsigned int ivsize =3D crypto_skcipher_ivsize(skcipher);
+	int i;
+
+	for (i =3D 0; i < ctx->blocks; i++)
+		crypto_inc((u8 *)ctx->iv, AES_BLOCK_SIZE);
+
+	memcpy(req->iv, ctx->iv, ivsize);
+}
+
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
 	struct skcipher_request *req =3D skcipher_request_cast(dd->areq);
@@ -527,8 +548,12 @@ static inline int atmel_aes_complete(struct atmel_aes_=
dev *dd, int err)
 	dd->flags &=3D ~AES_FLAGS_BUSY;
=20
 	if (!dd->ctx->is_aead &&
-	    (rctx->mode & AES_FLAGS_OPMODE_MASK) !=3D AES_FLAGS_ECB)
-		atmel_aes_set_iv_as_last_ciphertext_block(dd);
+	    (rctx->mode & AES_FLAGS_OPMODE_MASK) !=3D AES_FLAGS_ECB) {
+		if ((rctx->mode & AES_FLAGS_OPMODE_MASK) !=3D AES_FLAGS_CTR)
+			atmel_aes_set_iv_as_last_ciphertext_block(dd);
+		else
+			atmel_aes_ctr_update_req_iv(dd);
+	}
=20
 	if (dd->is_async)
 		dd->areq->complete(dd->areq, err);
@@ -1007,12 +1032,6 @@ static int atmel_aes_start(struct atmel_aes_dev *dd)
 				   atmel_aes_transfer_complete);
 }
=20
-static inline struct atmel_aes_ctr_ctx *
-atmel_aes_ctr_ctx_cast(struct atmel_aes_base_ctx *ctx)
-{
-	return container_of(ctx, struct atmel_aes_ctr_ctx, base);
-}
-
 static int atmel_aes_ctr_transfer(struct atmel_aes_dev *dd)
 {
 	struct atmel_aes_ctr_ctx *ctx =3D atmel_aes_ctr_ctx_cast(dd->ctx);
@@ -1020,7 +1039,7 @@ static int atmel_aes_ctr_transfer(struct atmel_aes_de=
v *dd)
 	struct scatterlist *src, *dst;
 	size_t datalen;
 	u32 ctr;
-	u16 blocks, start, end;
+	u16 start, end;
 	bool use_dma, fragmented =3D false;
=20
 	/* Check for transfer completion. */
@@ -1030,14 +1049,14 @@ static int atmel_aes_ctr_transfer(struct atmel_aes_=
dev *dd)
=20
 	/* Compute data length. */
 	datalen =3D req->cryptlen - ctx->offset;
-	blocks =3D DIV_ROUND_UP(datalen, AES_BLOCK_SIZE);
+	ctx->blocks =3D DIV_ROUND_UP(datalen, AES_BLOCK_SIZE);
 	ctr =3D be32_to_cpu(ctx->iv[3]);
=20
 	/* Check 16bit counter overflow. */
 	start =3D ctr & 0xffff;
-	end =3D start + blocks - 1;
+	end =3D start + ctx->blocks - 1;
=20
-	if (blocks >> 16 || end < start) {
+	if (ctx->blocks >> 16 || end < start) {
 		ctr |=3D 0xffff;
 		datalen =3D AES_BLOCK_SIZE * (0x10000 - start);
 		fragmented =3D true;
--=20
2.14.5

