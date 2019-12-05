Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75591C43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70060224F8
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="k3R9hM2s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfLEJyD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:54:03 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:51688 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfLEJyC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:54:02 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: hrATsF0QTA3/PX8Q25botiIk4vt2gud01XRJOsriLSBVR1uUhq72/Mueyrg+IMMGiUoKsWNeDV
 HH1CrEIGZWpfQo+hFl5p1vkX8TzfJQ4bESAa59gpEUMzTiYwilcHsUOS8f69bnEq5r6zyIlyTQ
 SRh0T8aD8IB6f98DDn3cTj+8JmAOCvlDlRsPrU82TvI29sjOn9ltAzOXmFrgfd98L7d2vHS4qY
 ohENQs8bW61DhPrhMCGUJWdgijX/gKLW7gC6xcgAmxPzjfA96p/hHDe7Td9gQAbqrwYNXjTq8L
 njg=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="57544870"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:54:02 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:54:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Dec 2019 02:54:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNx05UXQp3Y/1KO85jn+JNytWZ73DVcOGbUEtbf6mMB0DupyKv697jBAixYB0NMtsNra7z6b+Q/PHOoZb3e3dbwZtXiDbSMMO4WdF8QGbtOdiWhuYbwQ2/n8sQSo9CZIGsfilmxKUo6q+pyIpTI85c+qu/CvPGxi89NnY4eC6+rp4qzXU4VsqYHJvFri8A5zHuQptOqPtYHvtz8eZ1qxf7F/7BWy3xQrM6mTPsJ8U6VrMkzW3E6c2EJBy7/1OCFwMQtnGs8r80I6iewv9ozmU+dkIo+dnpruVbUzv2VuKSUhwcA+megmOXwoCpXctNUE4Sw0SBB+rX47juKH75VFXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmJd25C5YBBiPPsSk7oRQ686fNVjw4Y2+m8wo4Qwea4=;
 b=GbOs8+B5603eWebjS7xRGExiE0zdn8LSH4DxD52RNMoMtM5zqOdEfIXeqyQO/8Ff6eYLv2jkBLVenSBHcB3t6wGNWVYcQsw3WnRCAfrw6qKgWsiBVv1GJTXERFrCIVV8CjMb/mILDcITCkToxkBGAqQtboFVmjtTu7GIGbyVTkMUWnTN9QcNp2NMmJMojHTVqsg0EauRsonv+Gmzw0bMqzDYW3kJ2+vC+Y2dcAMzhFwtkgcH0LX3SE1W2J+9yAwo5l7HvaTa2r7KKaE6+X3hfr+Mo097nJqtlw06IJtIrWoQNY/7hOKyuO1pM3Zs2owvoQFRoJ7aLStxR07giG4XTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmJd25C5YBBiPPsSk7oRQ686fNVjw4Y2+m8wo4Qwea4=;
 b=k3R9hM2svTCZb/lONIgJ1PS/LFIypoyO3Ax8a8xRPZBE8xydtC5E4OsaL66fAuOv2YnObMWakk+Q/N9UHo/MMoT8bN/+yIgvRiNLjnSmUEo5VsZFlnqe8E4NGni7M6cEbBQppTjPmN00vGmvulcvB0D4GXpMX+4MD2OGG/njLsg=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3677.namprd11.prod.outlook.com (20.178.253.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 09:54:00 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:54:00 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 10/16] crypto: atmel-{aes,tdes} - Do not save IV for ECB mode
Thread-Topic: [PATCH 10/16] crypto: atmel-{aes,tdes} - Do not save IV for ECB
 mode
Thread-Index: AQHVq1Hr4YZFL3TcKEOdpojqCaJKbg==
Date:   Thu, 5 Dec 2019 09:54:00 +0000
Message-ID: <20191205095326.5094-11-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: 0e645a13-9262-4ad7-73ce-08d779690d66
x-ms-traffictypediagnostic: MN2PR11MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB36772DFFE40AF591DC290097F05C0@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:247;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(2616005)(66556008)(305945005)(66476007)(66446008)(102836004)(64756008)(11346002)(5660300002)(52116002)(76176011)(99286004)(36756003)(66946007)(2906002)(54906003)(26005)(6916009)(6506007)(1076003)(8676002)(6486002)(4326008)(50226002)(1730700003)(8936002)(14454004)(81156014)(186003)(86362001)(81166006)(5640700003)(478600001)(6512007)(71200400001)(25786009)(316002)(71190400001)(14444005)(107886003)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3677;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IIMxyLbwRM8xKsJMf+iVeFlDWEeZPu+icSxuh3/qutRwwK8Bd3JbsAWPFjHLWSypyVsKbA68xSI4FdfpKfh/+cSQCcSWyzq8AVLUWch7UiQpHtxG2UFC2JH/ERMyaZHhsqY+SheWkG0vMa4/KE3JB0tckmuB2aFqAtWRcHtvqsJP/Vooa7SDIWqlqU3lESPRxnRUQc8CVHMqn35h5/IASTmD2QX86HQsX4Z+EEXAJe/4YXBXgSSpF1BqsPxuJJQkcTLHGN3YJ3sSpPvoUHOTkfEVpAi3kCFM9rY9AefNZF+2F6KoZENscVsHvvWNKXRGEodCdT0NIAYopl9z/hDoMRSVyWeVdK6Tat26eHkLb5OS8isF7W8Qw1fB4cIltyvBu/Jmtovs3iGsAxZ+B5QZD+Tcl+BNdPV8BNgo8BPjuxBx0IjesGSATsIMWkdF7GvyZigyDry7LoYg+rG/OfGd66L+/Zqvc+LenMuVSAJAsTtHWtKopfsVeBMSnxdo9dYs
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e645a13-9262-4ad7-73ce-08d779690d66
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:54:00.0898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nor0RR/Q4tsjOz8sV4lroSTBnnajkCNr9qHiDyPh00EA4qUt4rO/cT0ZFXHI7lHzK9L6JPsxeUnVIpSFyMBAOj8JA9vQro1BLs3tI7DvUlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

ECB mode does not use IV.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 9 +++++++--
 drivers/crypto/atmel-tdes.c | 7 +++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 0744859ec793..d7e28ec456ff 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -516,6 +516,9 @@ static void atmel_aes_set_iv_as_last_ciphertext_block(s=
truct atmel_aes_dev *dd)
=20
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
+	struct skcipher_request *req =3D skcipher_request_cast(dd->areq);
+	struct atmel_aes_reqctx *rctx =3D skcipher_request_ctx(req);
+
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->ctx->is_aead)
 		atmel_aes_authenc_complete(dd, err);
@@ -524,7 +527,8 @@ static inline int atmel_aes_complete(struct atmel_aes_d=
ev *dd, int err)
 	clk_disable(dd->iclk);
 	dd->flags &=3D ~AES_FLAGS_BUSY;
=20
-	if (!dd->ctx->is_aead)
+	if (!dd->ctx->is_aead &&
+	    (rctx->mode & AES_FLAGS_OPMODE_MASK) !=3D AES_FLAGS_ECB)
 		atmel_aes_set_iv_as_last_ciphertext_block(dd);
=20
 	if (dd->is_async)
@@ -1131,7 +1135,8 @@ static int atmel_aes_crypt(struct skcipher_request *r=
eq, unsigned long mode)
 	rctx =3D skcipher_request_ctx(req);
 	rctx->mode =3D mode;
=20
-	if (!(mode & AES_FLAGS_ENCRYPT) && (req->src =3D=3D req->dst)) {
+	if ((mode & AES_FLAGS_OPMODE_MASK) !=3D AES_FLAGS_ECB &&
+	    !(mode & AES_FLAGS_ENCRYPT) && req->src =3D=3D req->dst) {
 		unsigned int ivsize =3D crypto_skcipher_ivsize(skcipher);
=20
 		if (req->cryptlen >=3D ivsize)
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 0a096f36785e..f44ef17420fb 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -593,12 +593,14 @@ atmel_tdes_set_iv_as_last_ciphertext_block(struct atm=
el_tdes_dev *dd)
 static void atmel_tdes_finish_req(struct atmel_tdes_dev *dd, int err)
 {
 	struct skcipher_request *req =3D dd->req;
+	struct atmel_tdes_reqctx *rctx =3D skcipher_request_ctx(req);
=20
 	clk_disable_unprepare(dd->iclk);
=20
 	dd->flags &=3D ~TDES_FLAGS_BUSY;
=20
-	atmel_tdes_set_iv_as_last_ciphertext_block(dd);
+	if ((rctx->mode & TDES_FLAGS_OPMODE_MASK) !=3D TDES_FLAGS_ECB)
+		atmel_tdes_set_iv_as_last_ciphertext_block(dd);
=20
 	req->base.complete(&req->base, err);
 }
@@ -728,7 +730,8 @@ static int atmel_tdes_crypt(struct skcipher_request *re=
q, unsigned long mode)
=20
 	rctx->mode =3D mode;
=20
-	if (!(mode & TDES_FLAGS_ENCRYPT) && req->src =3D=3D req->dst) {
+	if ((mode & TDES_FLAGS_OPMODE_MASK) !=3D TDES_FLAGS_ECB &&
+	    !(mode & TDES_FLAGS_ENCRYPT) && req->src =3D=3D req->dst) {
 		unsigned int ivsize =3D crypto_skcipher_ivsize(skcipher);
=20
 		if (req->cryptlen >=3D ivsize)
--=20
2.14.5

