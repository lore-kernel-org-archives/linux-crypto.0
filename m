Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73362C4CED1
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 08:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37586222BE
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 08:55:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="EhD4wEzy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbfJDIzl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 04:55:41 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:17488 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728942AbfJDIzk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 04:55:40 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: c//FpLz2DVMttP510VOpctXApYv149oqdG7h+2rwW4qcIelqeJR5bO9IQnS+w3Ry84bztHnBVw
 AuH5g98HMTbJd3V/oe6i0HDNlQlMV2XewQgspwhbJ2YYiGu5LcXCKKjrEuIFaAgVeWjIInZmge
 SV5HozQC24OK/6upeVNjPzdH8S4hUMQHpLJ7R798PcVzOq9IRaD0Vuo/9nccMuhtmPTrm9E3+h
 Wat/+IDT0uUXf8/vZCK4Fa1PynADldqd7TASMlAUaMNBtLhEKjhuBt9kCNUSwtFgYm7B45ExFn
 Xuo=
X-IronPort-AV: E=Sophos;i="5.67,255,1566889200"; 
   d="scan'208";a="53042964"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Oct 2019 01:55:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Oct 2019 01:55:39 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 4 Oct 2019 01:55:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Es2Tpptiu5AndGzoIgsNS0IOf675QoOosO9vqfL/cTwyS/zl1X2Y9LA5z6AzL3EZCTt03oxiRNF8c+GjZ5Hhj+jDiDG5EPM7eZ36nZiB4V56q3vDZmquY9t4ARyFGi529GC6zwiUbeC4TzxB9TrOCHUm0XZV+MnzUj9YE2VMHPxZBMmZIBV/hf9Hrj0o1AXO5r2NfwcRoo1ZyuAGamRnIMz4gpvk9o0d6jRjdASgMPfxhXONqm0cXMYXFEx2BNdiJcQ0Sevj2fQ6qLEGLIqXdry6WHaRXBc9y6EOOdJhD9FN2b69IBgccDPAFswLVAZ7a5fYK8YM8XqWyZA8jkZxKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VH802tqUPY6rA+TmES5z3qzjNUEG1aBxZvB6LtgJrxk=;
 b=VcbIIeE+HzFqvWQV2mGZ5sRNF/UmXXRRXhH2JT+7TqVo9MFNnWZoJLTYDIcL2UUGQ3l6db6xwcULohDlA5/i77GGygNGqmQsjFZFb/mjsEOsM7YxjoBiHTxaY/ylN1LsIWKshSyAQYKWNFwTp6pvSARm0/pXG9+liwJae9SZ092jExQ9mHzp7g3L0+MdV+X5tsAuB81bqME5qgwbD/JrIjc+2/ih6jAb5w+YLweX4EOY9o9/JNY4tWDF+ga2OnIU+LVPFvNIsI5cybLba+dud0AMGG5FKBx8CQ+C88z8tw4C6JtNwabRx2vjWULcJVGknpNu799qYRZzhbNWkENK7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VH802tqUPY6rA+TmES5z3qzjNUEG1aBxZvB6LtgJrxk=;
 b=EhD4wEzyMhswRdd0MiO0ejnwmFQWvHIdzxqaeByAKTnUR6TplA8LqgS019KFHjvGKl6WO2A2EDOUESSLmUIJk74DFAYJrQWilu6fe6VRbWSh7rblMNOLSUfWDN7iref4j87ZoCOrVwb2+kSHggatQHTZBkdAhPGvrR/oxJVohic=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3856.namprd11.prod.outlook.com (20.178.251.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.23; Fri, 4 Oct 2019 08:55:37 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::340d:5a33:dc79:1184]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::340d:5a33:dc79:1184%5]) with mapi id 15.20.2305.023; Fri, 4 Oct 2019
 08:55:37 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <Tudor.Ambarus@microchip.com>
Subject: [PATCH] crypto: atmel-aes - Fix IV handling when req->nbytes < ivsize
Thread-Topic: [PATCH] crypto: atmel-aes - Fix IV handling when req->nbytes <
 ivsize
Thread-Index: AQHVepF9ZAXIetW8+ESPkvolyNfDIA==
Date:   Fri, 4 Oct 2019 08:55:37 +0000
Message-ID: <20191004085528.12323-1-tudor.ambarus@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0102CA0066.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::43) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.9.5
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 325f3f9e-8c1d-44d2-f253-08d748a8a006
x-ms-traffictypediagnostic: MN2PR11MB3856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3856B0CAF197C0B60D85463AF09E0@MN2PR11MB3856.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(102836004)(386003)(1076003)(4326008)(99286004)(2201001)(52116002)(3846002)(6506007)(6116002)(186003)(36756003)(26005)(66946007)(2501003)(2906002)(66446008)(64756008)(66556008)(66476007)(7736002)(2616005)(476003)(305945005)(25786009)(110136005)(71200400001)(81166006)(8936002)(6512007)(8676002)(66066001)(478600001)(316002)(81156014)(71190400001)(256004)(86362001)(107886003)(6486002)(14444005)(486006)(14454004)(6436002)(5660300002)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3856;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hKfitoYlaBIIkxN5nIW4Vh6LSSq2p00VmHq0L/0oPf5RMVB+zUNVUifCHbQ4hGSMBOu7y+v2VnHKMdRL9inIhvwtb6MqxmsJn3ivZUK9qBbArykFGlcjccPyRShAPliWHYITAzeUUOEDPsWGhDZc5XLVLFIK08Q0+1CvH+OhB5lGmgkQFtW7nUmG5A7zYG6JvtitoOUn48/GKihf0f19shpJAsVybz2jmYqSsS/uFiWT6zID5iWWHbgA9gsCswjzdNhfJE2lBeJMW1xrQF0xYnL+DJZ5A+hMBgtE8N3bKfOHQYZXwxLd3aIQ+Pgwlym3HOfFLGURG+Pd9Moab0aEHYEl247YIMZu/t+UQ+AyjNiwRpsSk9ozqK1AemIlg2M2EN2gT1jB6kzbaFD3E62HrdZsBQ/wHHJtGkl4GQZ4DC8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 325f3f9e-8c1d-44d2-f253-08d748a8a006
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 08:55:37.5928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GY84VkGSwOaTiKEWvz8NiQ3IklGvsyKbhR8GYnndCxnRateCa2WGIy386rbs4QuxSghzh7EJhhLNHhMMEXzKk5lIecgR+0Qaj5w5i0ZksZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3856
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 394a9e044702 ("crypto: cfb - add missing 'chunksize' property")
adds a test vector where the input length is smaller than the IV length
(the second test vector). This revealed a NULL pointer dereference in
the atmel-aes driver, that is caused by passing an incorrect offset in
scatterwalk_map_and_copy() when atmel_aes_complete() is called.

Do not save the IV in req->info of ablkcipher_request (or equivalently
req->iv of skcipher_request) when req->nbytes < ivsize, because the IV
will not be further used.

While touching the code, modify the type of ivsize from int to
unsigned int, to comply with the return type of
crypto_ablkcipher_ivsize().

Fixes: 91308019ecb4 ("crypto: atmel-aes - properly set IV after {en,de}cryp=
t")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c | 53 ++++++++++++++++++++++++++----------------=
----
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 026f193556f9..00920a2b95ce 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -490,6 +490,29 @@ static inline bool atmel_aes_is_encrypt(const struct a=
tmel_aes_dev *dd)
 static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err);
 #endif
=20
+static void atmel_aes_set_iv_as_last_ciphertext_block(struct atmel_aes_dev=
 *dd)
+{
+	struct ablkcipher_request *req =3D ablkcipher_request_cast(dd->areq);
+	struct atmel_aes_reqctx *rctx =3D ablkcipher_request_ctx(req);
+	struct crypto_ablkcipher *ablkcipher =3D crypto_ablkcipher_reqtfm(req);
+	unsigned int ivsize =3D crypto_ablkcipher_ivsize(ablkcipher);
+
+	if (req->nbytes < ivsize)
+		return;
+
+	if (rctx->mode & AES_FLAGS_ENCRYPT) {
+		scatterwalk_map_and_copy(req->info, req->dst,
+					 req->nbytes - ivsize, ivsize, 0);
+	} else {
+		if (req->src =3D=3D req->dst)
+			memcpy(req->info, rctx->lastc, ivsize);
+		else
+			scatterwalk_map_and_copy(req->info, req->src,
+						 req->nbytes - ivsize,
+						 ivsize, 0);
+	}
+}
+
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
 #ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
@@ -500,26 +523,8 @@ static inline int atmel_aes_complete(struct atmel_aes_=
dev *dd, int err)
 	clk_disable(dd->iclk);
 	dd->flags &=3D ~AES_FLAGS_BUSY;
=20
-	if (!dd->ctx->is_aead) {
-		struct ablkcipher_request *req =3D
-			ablkcipher_request_cast(dd->areq);
-		struct atmel_aes_reqctx *rctx =3D ablkcipher_request_ctx(req);
-		struct crypto_ablkcipher *ablkcipher =3D
-			crypto_ablkcipher_reqtfm(req);
-		int ivsize =3D crypto_ablkcipher_ivsize(ablkcipher);
-
-		if (rctx->mode & AES_FLAGS_ENCRYPT) {
-			scatterwalk_map_and_copy(req->info, req->dst,
-				req->nbytes - ivsize, ivsize, 0);
-		} else {
-			if (req->src =3D=3D req->dst) {
-				memcpy(req->info, rctx->lastc, ivsize);
-			} else {
-				scatterwalk_map_and_copy(req->info, req->src,
-					req->nbytes - ivsize, ivsize, 0);
-			}
-		}
-	}
+	if (!dd->ctx->is_aead)
+		atmel_aes_set_iv_as_last_ciphertext_block(dd);
=20
 	if (dd->is_async)
 		dd->areq->complete(dd->areq, err);
@@ -1125,10 +1130,12 @@ static int atmel_aes_crypt(struct ablkcipher_reques=
t *req, unsigned long mode)
 	rctx->mode =3D mode;
=20
 	if (!(mode & AES_FLAGS_ENCRYPT) && (req->src =3D=3D req->dst)) {
-		int ivsize =3D crypto_ablkcipher_ivsize(ablkcipher);
+		unsigned int ivsize =3D crypto_ablkcipher_ivsize(ablkcipher);
=20
-		scatterwalk_map_and_copy(rctx->lastc, req->src,
-			(req->nbytes - ivsize), ivsize, 0);
+		if (req->nbytes >=3D ivsize)
+			scatterwalk_map_and_copy(rctx->lastc, req->src,
+						 req->nbytes - ivsize,
+						 ivsize, 0);
 	}
=20
 	return atmel_aes_handle_queue(dd, &req->base);
--=20
2.9.5

