Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47323C2BD09
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02CFA224F8
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="hBYRSmua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfLEJyB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:54:01 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:11822 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729362AbfLEJx7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:53:59 -0500
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
IronPort-SDR: H9DBKcHPm/6UITtM+xTSNud3tqn877qOJJzq9SvvG9UlJWq/b5fQBm/pmMgSVX0Wd/1/WOqNfH
 KfJOTK4uzMBYfEfY2rmIUXWUmUf+28Kb5BngNru1AIxTUWkdMKY+GQTP2LLgDXvYZMzbKuv662
 elJsfqGTmuE6r8q0EHdc+BLsw+upflSU4rtn5ITXMUeOcN0HAm6Tp+25sT7Sj2BlscwMLIpN2l
 XJqUkuNZS9ni806jCgF096PuCWDLfdumcoWIAg27t5ljAEKvHIwP1l/Ys55Kq2q6GySvrlW0ST
 QNQ=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="58828896"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:53:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:54:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 5 Dec 2019 02:53:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRBfOM4R8o019KChFp2fX79LxD4Gah4tOwSyJXD59v8S1syXWI1kM9aWPUjZM/kzMkYR66HZylzSVQP1xJ0Xy50hzwAtXM/9Gb80vlXs1ZUptHiTk+sMM2E/jiRbgOoJcs9iuVyVYa8UqQc22on5v9VJREEgrLvx/H3GCXm+gZxnetKvsD/mGT6Xfj3uTbm79fsqwz+FBTQ1J5F/3uTSJTSBllZhN7y+YOJOCKB+Bsl+V2nK8fuMYaTwhpDFdjfGu1q0hxEDSbTFCwAapO619WzCqNV78prwaA9iGBMG5SXMfLkLheJLFyTVeGwpuYUS9uPgK2MtCoW5z5MFuulo3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2yI5B4TbJuXvq8eZV2Ob4tKcjcAD4x0kTko29XWxAM=;
 b=G6O3P0lemTiQ435lIjqaN7Zjuelm4SgMFHx8lstblC9of6XedkeMiTY6KUUGxG8aiTySRmKuVtALweODvOBYGjLcRTYBQjISH3L+oRfqqfIvlaXVbgQrEmZPl0/zI43NvHh0mP1tOwbAgoV9dTBeRbA84fEN/RQct3PMqEy05hJH0iQTd2ZktcTUZ6b2ZZ6+b5VkObmvfY7R8qeoWFnt/0juI3wmr3yNzYYoK8c/CDnAkkIyiRpVY8YwuZz5ceLk8joZ3qoHLiiaAWvwcz9qSL/YO+j1gfDMcjIjDkDNa60WFV0rD3UEo/zb7dIOys03IJpptECXTOhzpLVjp6rcIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2yI5B4TbJuXvq8eZV2Ob4tKcjcAD4x0kTko29XWxAM=;
 b=hBYRSmuaq1Wamsh5Hxg1AKjIy0Y/kZsOqkGDFXBHGbB/UaSDyko7/8o17zGLe6Wr2K9vnQH+ayfMgsjFE0iYEhY2dkjCne+El8Jg5h4aBqV6JXz/FRYdV1qRF2rrxIOudaeAlkQCNU1SzCchPssjr2WTLmZXgnpZWGMruvFiOKY=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3677.namprd11.prod.outlook.com (20.178.253.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 09:53:57 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:53:57 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 08/16] crypto: atmel-tdes - Map driver data flags to Mode
 Register
Thread-Topic: [PATCH 08/16] crypto: atmel-tdes - Map driver data flags to Mode
 Register
Thread-Index: AQHVq1Hp7la3PCOa8E+6QB5Iy+b5zg==
Date:   Thu, 5 Dec 2019 09:53:56 +0000
Message-ID: <20191205095326.5094-9-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: 221e222c-ee38-417f-cb3f-08d779690b71
x-ms-traffictypediagnostic: MN2PR11MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB367770609B3AD01ED84D58F1F05C0@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:121;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(2616005)(66556008)(305945005)(66476007)(66446008)(102836004)(64756008)(11346002)(5660300002)(52116002)(76176011)(99286004)(36756003)(66946007)(2906002)(54906003)(26005)(6916009)(6506007)(1076003)(8676002)(6486002)(4326008)(50226002)(1730700003)(8936002)(14454004)(81156014)(186003)(86362001)(81166006)(5640700003)(478600001)(6512007)(71200400001)(25786009)(316002)(71190400001)(14444005)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3677;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8C4tysKQFVrgOOyR6gJ1bm989u1Ab2p2IyNZTwHJfsvYD3uhL2B7Ys723T9mxsQI7EtJOKkcBXC6HSsyuDekIG0kVH3wGCzSX+ATP8kNsdSzHOvJvZyCfaRtP4YtoyVMcOjNWFIGGoyVzRKIEQwzkRJ4GRqDqhm9ttZWbHcLbpz1dfGJQrrdoZzlVq31nayuYFaii97RF7gQSUckiTH15w6t6Po6IowgHeDLxlCvJYCkvgKkSrvqmjN5l3LtiS68yPOupVsXaYQLVnv6sKkE+o+elKpqjWJN138ZiABjOY4g8KtvLnbO1D42G5mVck34aDot/P+CblGh1VF4CTWW/GYIIF+lkx5u5zOfUOiZleZJiqzy3/5afsHHrUTwVG9GJIp5imGkJ8itddOta3FoBgdLqOGv/RXresMm3BEdt2IFW33yd94soPcdOKhHLAlc
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 221e222c-ee38-417f-cb3f-08d779690b71
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:53:56.8377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v2XlPvL2HApJksX/78QTzxfobO6Z8ysmu8bqUBgdwcUXSClnIeVK9JKJjV0Tobic9Cn4fyI2cVjw9FA/71UyHi4WLIq73Ygqu0wYJ68dHeE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

Simplifies the configuration of the TDES IP.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-tdes.c | 144 ++++++++++++++++++++++------------------=
----
 1 file changed, 71 insertions(+), 73 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 0b9badbd232d..ddb211706cba 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -40,20 +40,23 @@
 #define ATMEL_TDES_PRIORITY	300
=20
 /* TDES flags  */
-#define TDES_FLAGS_MODE_MASK		0x00ff
-#define TDES_FLAGS_ENCRYPT	BIT(0)
-#define TDES_FLAGS_CBC		BIT(1)
-#define TDES_FLAGS_CFB		BIT(2)
-#define TDES_FLAGS_CFB8		BIT(3)
-#define TDES_FLAGS_CFB16	BIT(4)
-#define TDES_FLAGS_CFB32	BIT(5)
-#define TDES_FLAGS_CFB64	BIT(6)
-#define TDES_FLAGS_OFB		BIT(7)
-
-#define TDES_FLAGS_INIT		BIT(16)
-#define TDES_FLAGS_FAST		BIT(17)
-#define TDES_FLAGS_BUSY		BIT(18)
-#define TDES_FLAGS_DMA		BIT(19)
+/* Reserve bits [17:16], [13:12], [2:0] for AES Mode Register */
+#define TDES_FLAGS_ENCRYPT	TDES_MR_CYPHER_ENC
+#define TDES_FLAGS_OPMODE_MASK	(TDES_MR_OPMOD_MASK | TDES_MR_CFBS_MASK)
+#define TDES_FLAGS_ECB		TDES_MR_OPMOD_ECB
+#define TDES_FLAGS_CBC		TDES_MR_OPMOD_CBC
+#define TDES_FLAGS_OFB		TDES_MR_OPMOD_OFB
+#define TDES_FLAGS_CFB64	(TDES_MR_OPMOD_CFB | TDES_MR_CFBS_64b)
+#define TDES_FLAGS_CFB32	(TDES_MR_OPMOD_CFB | TDES_MR_CFBS_32b)
+#define TDES_FLAGS_CFB16	(TDES_MR_OPMOD_CFB | TDES_MR_CFBS_16b)
+#define TDES_FLAGS_CFB8		(TDES_MR_OPMOD_CFB | TDES_MR_CFBS_8b)
+
+#define TDES_FLAGS_MODE_MASK	(TDES_FLAGS_OPMODE_MASK | TDES_FLAGS_ENCRYPT)
+
+#define TDES_FLAGS_INIT		BIT(3)
+#define TDES_FLAGS_FAST		BIT(4)
+#define TDES_FLAGS_BUSY		BIT(5)
+#define TDES_FLAGS_DMA		BIT(6)
=20
 #define ATMEL_TDES_QUEUE_LENGTH	50
=20
@@ -287,35 +290,15 @@ static int atmel_tdes_write_ctrl(struct atmel_tdes_de=
v *dd)
 		valmr |=3D TDES_MR_TDESMOD_DES;
 	}
=20
-	if (dd->flags & TDES_FLAGS_CBC) {
-		valmr |=3D TDES_MR_OPMOD_CBC;
-	} else if (dd->flags & TDES_FLAGS_CFB) {
-		valmr |=3D TDES_MR_OPMOD_CFB;
-
-		if (dd->flags & TDES_FLAGS_CFB8)
-			valmr |=3D TDES_MR_CFBS_8b;
-		else if (dd->flags & TDES_FLAGS_CFB16)
-			valmr |=3D TDES_MR_CFBS_16b;
-		else if (dd->flags & TDES_FLAGS_CFB32)
-			valmr |=3D TDES_MR_CFBS_32b;
-		else if (dd->flags & TDES_FLAGS_CFB64)
-			valmr |=3D TDES_MR_CFBS_64b;
-	} else if (dd->flags & TDES_FLAGS_OFB) {
-		valmr |=3D TDES_MR_OPMOD_OFB;
-	}
-
-	if ((dd->flags & TDES_FLAGS_ENCRYPT) || (dd->flags & TDES_FLAGS_OFB))
-		valmr |=3D TDES_MR_CYPHER_ENC;
+	valmr |=3D dd->flags & TDES_FLAGS_MODE_MASK;
=20
 	atmel_tdes_write(dd, TDES_MR, valmr);
=20
 	atmel_tdes_write_n(dd, TDES_KEY1W1R, dd->ctx->key,
 						dd->ctx->keylen >> 2);
=20
-	if (((dd->flags & TDES_FLAGS_CBC) || (dd->flags & TDES_FLAGS_CFB) ||
-		(dd->flags & TDES_FLAGS_OFB)) && dd->req->iv) {
+	if (dd->req->iv && (valmr & TDES_MR_OPMOD_MASK) !=3D TDES_MR_OPMOD_ECB)
 		atmel_tdes_write_n(dd, TDES_IV1R, (void *)dd->req->iv, 2);
-	}
=20
 	return 0;
 }
@@ -406,6 +389,7 @@ static int atmel_tdes_crypt_pdc(struct crypto_tfm *tfm,=
 dma_addr_t dma_addr_in,
 {
 	struct atmel_tdes_ctx *ctx =3D crypto_tfm_ctx(tfm);
 	struct atmel_tdes_dev *dd =3D ctx->dd;
+	struct atmel_tdes_reqctx *rctx =3D skcipher_request_ctx(dd->req);
 	int len32;
=20
 	dd->dma_size =3D length;
@@ -415,12 +399,19 @@ static int atmel_tdes_crypt_pdc(struct crypto_tfm *tf=
m, dma_addr_t dma_addr_in,
 					   DMA_TO_DEVICE);
 	}
=20
-	if ((dd->flags & TDES_FLAGS_CFB) && (dd->flags & TDES_FLAGS_CFB8))
+	switch (rctx->mode & TDES_FLAGS_OPMODE_MASK) {
+	case TDES_FLAGS_CFB8:
 		len32 =3D DIV_ROUND_UP(length, sizeof(u8));
-	else if ((dd->flags & TDES_FLAGS_CFB) && (dd->flags & TDES_FLAGS_CFB16))
+		break;
+
+	case TDES_FLAGS_CFB16:
 		len32 =3D DIV_ROUND_UP(length, sizeof(u16));
-	else
+		break;
+
+	default:
 		len32 =3D DIV_ROUND_UP(length, sizeof(u32));
+		break;
+	}
=20
 	atmel_tdes_write(dd, TDES_PTCR, TDES_PTCR_TXTDIS|TDES_PTCR_RXTDIS);
 	atmel_tdes_write(dd, TDES_TPR, dma_addr_in);
@@ -442,8 +433,10 @@ static int atmel_tdes_crypt_dma(struct crypto_tfm *tfm=
, dma_addr_t dma_addr_in,
 {
 	struct atmel_tdes_ctx *ctx =3D crypto_tfm_ctx(tfm);
 	struct atmel_tdes_dev *dd =3D ctx->dd;
+	struct atmel_tdes_reqctx *rctx =3D skcipher_request_ctx(dd->req);
 	struct scatterlist sg[2];
 	struct dma_async_tx_descriptor	*in_desc, *out_desc;
+	enum dma_slave_buswidth addr_width;
=20
 	dd->dma_size =3D length;
=20
@@ -452,23 +445,23 @@ static int atmel_tdes_crypt_dma(struct crypto_tfm *tf=
m, dma_addr_t dma_addr_in,
 					   DMA_TO_DEVICE);
 	}
=20
-	if (dd->flags & TDES_FLAGS_CFB8) {
-		dd->dma_lch_in.dma_conf.dst_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_1_BYTE;
-		dd->dma_lch_out.dma_conf.src_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_1_BYTE;
-	} else if (dd->flags & TDES_FLAGS_CFB16) {
-		dd->dma_lch_in.dma_conf.dst_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_2_BYTES;
-		dd->dma_lch_out.dma_conf.src_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_2_BYTES;
-	} else {
-		dd->dma_lch_in.dma_conf.dst_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_out.dma_conf.src_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
+	switch (rctx->mode & TDES_FLAGS_OPMODE_MASK) {
+	case TDES_FLAGS_CFB8:
+		addr_width =3D DMA_SLAVE_BUSWIDTH_1_BYTE;
+		break;
+
+	case TDES_FLAGS_CFB16:
+		addr_width =3D DMA_SLAVE_BUSWIDTH_2_BYTES;
+		break;
+
+	default:
+		addr_width =3D DMA_SLAVE_BUSWIDTH_4_BYTES;
+		break;
 	}
=20
+	dd->dma_lch_in.dma_conf.dst_addr_width =3D addr_width;
+	dd->dma_lch_out.dma_conf.src_addr_width =3D addr_width;
+
 	dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf);
 	dmaengine_slave_config(dd->dma_lch_out.chan, &dd->dma_lch_out.dma_conf);
=20
@@ -703,30 +696,38 @@ static int atmel_tdes_crypt(struct skcipher_request *=
req, unsigned long mode)
 	struct atmel_tdes_ctx *ctx =3D crypto_skcipher_ctx(skcipher);
 	struct atmel_tdes_reqctx *rctx =3D skcipher_request_ctx(req);
=20
-	if (mode & TDES_FLAGS_CFB8) {
+	switch (mode & TDES_FLAGS_OPMODE_MASK) {
+	case TDES_FLAGS_CFB8:
 		if (!IS_ALIGNED(req->cryptlen, CFB8_BLOCK_SIZE)) {
 			pr_err("request size is not exact amount of CFB8 blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size =3D CFB8_BLOCK_SIZE;
-	} else if (mode & TDES_FLAGS_CFB16) {
+		break;
+
+	case TDES_FLAGS_CFB16:
 		if (!IS_ALIGNED(req->cryptlen, CFB16_BLOCK_SIZE)) {
 			pr_err("request size is not exact amount of CFB16 blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size =3D CFB16_BLOCK_SIZE;
-	} else if (mode & TDES_FLAGS_CFB32) {
+		break;
+
+	case TDES_FLAGS_CFB32:
 		if (!IS_ALIGNED(req->cryptlen, CFB32_BLOCK_SIZE)) {
 			pr_err("request size is not exact amount of CFB32 blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size =3D CFB32_BLOCK_SIZE;
-	} else {
+		break;
+
+	default:
 		if (!IS_ALIGNED(req->cryptlen, DES_BLOCK_SIZE)) {
 			pr_err("request size is not exact amount of DES blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size =3D DES_BLOCK_SIZE;
+		break;
 	}
=20
 	rctx->mode =3D mode;
@@ -845,17 +846,17 @@ static int atmel_tdes_setkey(struct crypto_skcipher *=
tfm, const u8 *key,
=20
 static int atmel_tdes_ecb_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT);
+	return atmel_tdes_crypt(req, TDES_FLAGS_ECB | TDES_FLAGS_ENCRYPT);
 }
=20
 static int atmel_tdes_ecb_decrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, 0);
+	return atmel_tdes_crypt(req, TDES_FLAGS_ECB);
 }
=20
 static int atmel_tdes_cbc_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CBC);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CBC | TDES_FLAGS_ENCRYPT);
 }
=20
 static int atmel_tdes_cbc_decrypt(struct skcipher_request *req)
@@ -864,50 +865,47 @@ static int atmel_tdes_cbc_decrypt(struct skcipher_req=
uest *req)
 }
 static int atmel_tdes_cfb_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB64 | TDES_FLAGS_ENCRYPT);
 }
=20
 static int atmel_tdes_cfb_decrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_CFB);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB64);
 }
=20
 static int atmel_tdes_cfb8_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB |
-						TDES_FLAGS_CFB8);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB8 | TDES_FLAGS_ENCRYPT);
 }
=20
 static int atmel_tdes_cfb8_decrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_CFB | TDES_FLAGS_CFB8);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB8);
 }
=20
 static int atmel_tdes_cfb16_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB |
-						TDES_FLAGS_CFB16);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB16 | TDES_FLAGS_ENCRYPT);
 }
=20
 static int atmel_tdes_cfb16_decrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_CFB | TDES_FLAGS_CFB16);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB16);
 }
=20
 static int atmel_tdes_cfb32_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB |
-						TDES_FLAGS_CFB32);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB32 | TDES_FLAGS_ENCRYPT);
 }
=20
 static int atmel_tdes_cfb32_decrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_CFB | TDES_FLAGS_CFB32);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB32);
 }
=20
 static int atmel_tdes_ofb_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_OFB);
+	return atmel_tdes_crypt(req, TDES_FLAGS_OFB | TDES_FLAGS_ENCRYPT);
 }
=20
 static int atmel_tdes_ofb_decrypt(struct skcipher_request *req)
--=20
2.14.5

