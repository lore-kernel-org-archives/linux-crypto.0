Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43201C3499D
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E38424788
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:37:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="kNHohwlH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfLMOpr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 09:45:47 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:47331 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfLMOpr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Dec 2019 09:45:47 -0500
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
IronPort-SDR: Ch8asyW/vEPABRO70V9qeeVjh/GmJAmHEEWd1z1QvYDjrI1Ws/ORpQXNSb6S/1GopSQUVN3p5h
 jTfGie0FL615s5UN6C6kREuHfyZTdzdDOFGXhv8P03l2tddFl51r+8QMHDm7ECUyY+N0w5fSW/
 pQo8DXQ/JbDlXHO+d0d4NqbhKKsuPkZAaOYfRASvqEjL8fU+TpVmPzXOs0FJzp9OQ6WtpQIboZ
 z8dy8uaUTJRyypwm2mXDqZdEfmL0hacFNA9TfESR67WIkkVE+6KueyhcyoBGVTh3XgOGnceYFR
 4/g=
X-IronPort-AV: E=Sophos;i="5.69,309,1571727600"; 
   d="scan'208";a="59715413"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2019 07:45:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 07:45:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 07:45:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5qjXRiI94UqmjeT+jMXDXmTBB3YMZf1UFKo7eDO/wJInMPPWfIf5b9BAeq0q2y+vAKG+7Ee5jz63wcevvT5NGPJpKoCxGIawPjE8/oR/gO8oREpbXnoTahi2aQ2E/snkDQa1ui64mAHR7D3t0hq1No1F5NP0W75xJRULtoaUmL2gtig2q/FCZmYjJC7i5U3VEv6+1ybTWNibdUfJ3z2SPd6Z3dP4mqDHVXJNUNKNKncBDhrRL/bfmVfY04U/s5jmlqMYEe4vCNAVBMvKCYmCC/LTji3IiqoidIaY7sTzZlEfBeeEMVmhy/+Cjd92RTUzaqX3LBv6Ged6e4xEOMCGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGfvwJ9DrnnRpxDwVZRXLvOfnDbmqCcC+6yb+womu9g=;
 b=AOSW65KihgV+2yeOFn6LQnH7cCK7gnZAf1Tv64OQfMeIyZFT5vwvoDPosHDZlql39cH6VX5JwGyWFwulk+l3l5sxDDFDURCMBM7RKHeC5fAU0+FZN7yx25+ihYfxsykDwy4X9aH1/DiVp758ZyfNDYXYp8tQr0omRRYpFPAMzlumPfcn9h6wHGbwGepV0M/p/IEKZridJdSWnR5Bwn6CjGr8Mnc9UFYIV2IrU7hBZ+Czt8Og3X3XL4qr5BMzYDgBkltpkv9nL/Eo1iZUHCh4L+IMvIOGVYqhTAjkt2y2cwZRqadtFyXQ8FWORl1XfVsp+Uzbx8xdr2nmz9Ksu23Fgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGfvwJ9DrnnRpxDwVZRXLvOfnDbmqCcC+6yb+womu9g=;
 b=kNHohwlHYBc9s3XZyuml4UhgPzJyoIhUbbieDT1xjLGgHa3vzI39Y1gTaXcSc2DXzP/hmmKlMqW5H2eJxoehALQFa8wIO3TVWZyhXWLBzfqVw6180aTvBnwhFfk3VVXUIREOQUty2RYvf4frS4r1zuP45VM8QWomY3E/mwF3mZY=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3997.namprd11.prod.outlook.com (10.255.181.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Fri, 13 Dec 2019 14:45:44 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2538.017; Fri, 13 Dec 2019
 14:45:44 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>, <dan.carpenter@oracle.com>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <Tudor.Ambarus@microchip.com>
Subject: [PATCH] crypto: atmel-aes - Fix CTR counter overflow when multiple
 fragments
Thread-Topic: [PATCH] crypto: atmel-aes - Fix CTR counter overflow when
 multiple fragments
Thread-Index: AQHVscP/R3ZoerXL90ST/0ph9ePc0g==
Date:   Fri, 13 Dec 2019 14:45:44 +0000
Message-ID: <20191213144529.9613-1-tudor.ambarus@microchip.com>
References: <20191213123800.dsnxfh4tja2q5kbv@kili.mountain>
In-Reply-To: <20191213123800.dsnxfh4tja2q5kbv@kili.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR08CA0235.eurprd08.prod.outlook.com
 (2603:10a6:802:15::44) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [86.122.210.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6a851e6-cac1-4c21-94ca-08d77fdb21dc
x-ms-traffictypediagnostic: MN2PR11MB3997:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39973BD9DED9C36E74D95BCBF0540@MN2PR11MB3997.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(396003)(366004)(376002)(189003)(199004)(26005)(8936002)(316002)(36756003)(2906002)(52116002)(6506007)(66556008)(66476007)(64756008)(66446008)(110136005)(71200400001)(186003)(66946007)(54906003)(6486002)(478600001)(8676002)(81156014)(2616005)(81166006)(1076003)(5660300002)(4326008)(107886003)(6512007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3997;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZnvFF3BbDA69dF2EpNrhaqfutfVzfK4vsMUVhEZrAHoAwxPxWQ/6SDEX4LN4CHygTW6vjtqNPAj2T0+gPp0ZXPynPx85/YM3hK3VMMww4QDfs3J5V4xcKsivW9MDNehwNS6zQ7peO/GZe7yxLE8bMqKomHWlVHWffbQ6zLI2k+3qkiZfd7ungJm+lrA2pqyd72DaCLmNWdCgcj49aGZ8ckzZnlvkHtZTQqMHIZO97xKYI8DAb6hxw5F30GhAJ5G1N23ufjO9jq9Jns/9BMTUKxcItmO37w96cQYQyWUieP3F0T/10s6CEShRsP6RPG5lVmcO9YQSI4iTvdZhaBuwgU/Fn+fD8SuAs2vfaLhyMA0uN1PJ3buibtMBexoE2V2ruL704g1TUbDYt8AHMeefdRt6jnjpAhPGoa5MlFXbPvWD+TY5OWh3wDAl2QMiHGLU
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f6a851e6-cac1-4c21-94ca-08d77fdb21dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 14:45:44.3811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aEOsxbB/JT0Tzkzn+ueskQCRp9Dq/RnDj2cKIY9HW81o8O5HHHoO0Qa9pwEScZWrhFiize050jRoq6b06LMNnyCw6cfIwsSD5uMmYgxmyas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3997
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

The CTR transfer works in fragments of data of maximum 1 MByte because
of the 16 bit CTR counter embedded in the IP. Fix the CTR counter
overflow handling for messages larger than 1 MByte.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 781a08d9740a ("crypto: atmel-aes - Fix counter overflow in CTR mode"=
)
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
Thanks, Dan.

 drivers/crypto/atmel-aes.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 245d45f93b61..b001fdcd9d95 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -120,7 +120,7 @@ struct atmel_aes_ctr_ctx {
 	size_t			offset;
 	struct scatterlist	src[2];
 	struct scatterlist	dst[2];
-	u16			blocks;
+	u32			blocks;
 };
=20
 struct atmel_aes_gcm_ctx {
@@ -527,6 +527,12 @@ static void atmel_aes_ctr_update_req_iv(struct atmel_a=
es_dev *dd)
 	unsigned int ivsize =3D crypto_skcipher_ivsize(skcipher);
 	int i;
=20
+	/*
+	 * The CTR transfer works in fragments of data of maximum 1 MByte
+	 * because of the 16 bit CTR counter embedded in the IP. When reaching
+	 * here, ctx->blocks contains the number of blocks of the last fragment
+	 * processed, there is no need to explicit cast it to u16.
+	 */
 	for (i =3D 0; i < ctx->blocks; i++)
 		crypto_inc((u8 *)ctx->iv, AES_BLOCK_SIZE);
=20
--=20
2.20.1

