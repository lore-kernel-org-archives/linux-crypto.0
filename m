Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8EFC43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FA2E224F8
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="P8nGCDAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbfLEJyB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:54:01 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:30705 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729314AbfLEJyA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:54:00 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: xWIl1TfuKLrpcpDky5uJNSw9Ov/KshyYp63cB4KYlb+OcuQ2i4HcQnLM8AdHII9MpMBbbyPA2c
 WyWXTcnwlVOD7pGkBGTsEnepzHCO7e72gdafj0TmB2aH7lABhwVdjyRPcjAh+s4BQqBtL+hdQW
 RJFJmIG+m6bWGSIYELgBWMtdR29wc7KDrDedYyPWLjfft63sUb3z6WyPWXPIPHoO7TXvnkQ1wr
 zKgG7vcpJGLmbCJQ0HRlimN7QZDnfp4m8V6E0kKl/9wIeP9XRICkpb4J1wjCu45WFlwm9UnSZZ
 hL4=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="60720966"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:53:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:54:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 5 Dec 2019 02:54:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUv0tJAqLcg1pC45jr/6i241N6bxqxshLvkQJs1OzZgyLYty5b/Sa+MsKMua7wfpyUdQf5epqudfBgfjNafm8WYolFiaVhfOx8Urn/0KtdB/LYtXsLNuwCPvSBkCrLwK9kPPmzWCjNO7CMZRNGA7ZPW/4Vg0tZ+14RxtIOIS7MPzr0AuD8NboQtMdd4jYl/eNevfPJL6JzJBewVIwv1btqEEMlq2zAtGBWNpWhczkZd/b6Iwdv0Vnj5KUZG+ejCpLDJX3eQ3cJNz0tvh0RS//J+YdFeHISrKH4P75q1GIZw+U+yKDoD1V2gE+ojffnaSSBfgQyPPG0tEvo4VsMOckQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlLAtxYyEcImY7l8LGhn6lX5lztP7CGu2CYsGUXqgjI=;
 b=E/ncy1tGD6TEGvkchMVpIATVtnGiYti7IxK0FeVHMRJIiaFILdiePlEVqvfHN1QL/ltSipdu8yHqZYTHB8R+M3vxego6H7uDtj9esWO78N7ED+6CWkCjHHnIXeB/SB2AoaBX2BJxCarSTlqaFIQHQZfe7IgI5GAOiV3ao2PWUzeENFfA0OFLvzS63vE4yo/ieJwzfXzraEGYVm9lx5sFUya8daP+mxVNYIQ1j0EDrw/9Brd2hGdee7pg01MJVyPHIN9rWI5HmRbud3+eLH2nX0BqTz74JQUFthKISWuFCeX0uI0R6dQ0a2ZHsxUiSxsiaz58lDYlgew/OWjTzgIVlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlLAtxYyEcImY7l8LGhn6lX5lztP7CGu2CYsGUXqgjI=;
 b=P8nGCDAglCFwmJLh2Ariuj6SfIEry8j+3MRFnWMP0s9nJUMwwLeBSPJUzIXe3/TFxVHBMFrBymSypoVJcGBPYl8MAKSOLMePZ9JSmLeoRQHeBP/XeP7XREo5LX3Nr9+VjwRbBXEBS9l5C4QTOvAWKd/ei46FZ/tNHsP/f18lRE0=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3677.namprd11.prod.outlook.com (20.178.253.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 09:53:58 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:53:58 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 09/16] crypto: atmel-tdes - Drop unnecessary passing of tfm
Thread-Topic: [PATCH 09/16] crypto: atmel-tdes - Drop unnecessary passing of
 tfm
Thread-Index: AQHVq1HqAp3eRVJX4kSfqtexQKotew==
Date:   Thu, 5 Dec 2019 09:53:58 +0000
Message-ID: <20191205095326.5094-10-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: 5715a154-7454-48c5-030b-08d779690c70
x-ms-traffictypediagnostic: MN2PR11MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3677F87F290EBD709F3F73ADF05C0@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(2616005)(66556008)(305945005)(66476007)(66446008)(102836004)(64756008)(11346002)(5660300002)(52116002)(76176011)(99286004)(36756003)(66946007)(2906002)(54906003)(26005)(6916009)(6506007)(1076003)(8676002)(6486002)(4326008)(50226002)(1730700003)(8936002)(14454004)(81156014)(186003)(86362001)(81166006)(5640700003)(478600001)(6512007)(71200400001)(25786009)(316002)(71190400001)(14444005)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3677;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Vs5m6+A4Rd/GqlDwsjz9t3Fh3AXWo6WhjBkrUD/QoLgkws2i9fsXzvJ2Wo043VeQfIXUdFKH0AZElJKZ9zUWpF4zhKzPUvtzEhxi+krulY0DiBR+BibkLdHgS5ILV0KhQsyLKieePQdGDvINOqPh4flvFf0EF3B6QmtKVic+ZbWtSbimjuG3UN/BKbMr2d82qJ/tdxO9+APvO61rajG1ZK32Kl/um90bpeOSbsxpKZPWlUs5Ugz52KKskIckAVWlczhzwbWj1Kbi98lhOGL942sCulN1qljTNdgssg/rPmMbuHGCQiqIPtXUowO730qt3Jv2D9Ugf7G6/i2xj2J3RQ6s67faqx8MfPpeNetsJUwsychGz7v5TI/ziEUHIG9Plt/dQl+wi3k6sV5t3FRt0cuDy+rj96SzvPiLTjo2GyNZbZ/p5qe4axie/9zOfG3
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5715a154-7454-48c5-030b-08d779690c70
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:53:58.5097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rVGQrdI65pL6ASeHiLF/6ns2sPW1dXcVcFtDsyadqOSnjAvyzd/xCe/hAfMcGPu3KSgABy672pBg14I3ckiNS+eFc14bZIOPdTOD66lt+EU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

atmel_tdes_crypt_start() obtained a pointer to tfm from dd,
passed the tfm pointer to atmel_tdes_crypt_{dma,pdc}, and in
the calles we obtained dd back from the tfm. Pass pointer to
dd directly.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-tdes.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index ddb211706cba..0a096f36785e 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -384,11 +384,10 @@ static void atmel_tdes_buff_cleanup(struct atmel_tdes=
_dev *dd)
 	free_page((unsigned long)dd->buf_in);
 }
=20
-static int atmel_tdes_crypt_pdc(struct crypto_tfm *tfm, dma_addr_t dma_add=
r_in,
-			       dma_addr_t dma_addr_out, int length)
+static int atmel_tdes_crypt_pdc(struct atmel_tdes_dev *dd,
+				dma_addr_t dma_addr_in,
+				dma_addr_t dma_addr_out, int length)
 {
-	struct atmel_tdes_ctx *ctx =3D crypto_tfm_ctx(tfm);
-	struct atmel_tdes_dev *dd =3D ctx->dd;
 	struct atmel_tdes_reqctx *rctx =3D skcipher_request_ctx(dd->req);
 	int len32;
=20
@@ -428,11 +427,10 @@ static int atmel_tdes_crypt_pdc(struct crypto_tfm *tf=
m, dma_addr_t dma_addr_in,
 	return 0;
 }
=20
-static int atmel_tdes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_add=
r_in,
-			       dma_addr_t dma_addr_out, int length)
+static int atmel_tdes_crypt_dma(struct atmel_tdes_dev *dd,
+				dma_addr_t dma_addr_in,
+				dma_addr_t dma_addr_out, int length)
 {
-	struct atmel_tdes_ctx *ctx =3D crypto_tfm_ctx(tfm);
-	struct atmel_tdes_dev *dd =3D ctx->dd;
 	struct atmel_tdes_reqctx *rctx =3D skcipher_request_ctx(dd->req);
 	struct scatterlist sg[2];
 	struct dma_async_tx_descriptor	*in_desc, *out_desc;
@@ -501,8 +499,6 @@ static int atmel_tdes_crypt_dma(struct crypto_tfm *tfm,=
 dma_addr_t dma_addr_in,
=20
 static int atmel_tdes_crypt_start(struct atmel_tdes_dev *dd)
 {
-	struct crypto_tfm *tfm =3D crypto_skcipher_tfm(
-					crypto_skcipher_reqtfm(dd->req));
 	int err, fast =3D 0, in, out;
 	size_t count;
 	dma_addr_t addr_in, addr_out;
@@ -558,9 +554,9 @@ static int atmel_tdes_crypt_start(struct atmel_tdes_dev=
 *dd)
 	dd->total -=3D count;
=20
 	if (dd->caps.has_dma)
-		err =3D atmel_tdes_crypt_dma(tfm, addr_in, addr_out, count);
+		err =3D atmel_tdes_crypt_dma(dd, addr_in, addr_out, count);
 	else
-		err =3D atmel_tdes_crypt_pdc(tfm, addr_in, addr_out, count);
+		err =3D atmel_tdes_crypt_pdc(dd, addr_in, addr_out, count);
=20
 	if (err && (dd->flags & TDES_FLAGS_FAST)) {
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
--=20
2.14.5

