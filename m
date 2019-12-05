Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18277C2D0BF
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D863724654
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="j1XZu3XJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfLEJyK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:54:10 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:51688 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729423AbfLEJyJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:54:09 -0500
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
IronPort-SDR: 89BBUmjWwvBOA59gTX/U/LyEe0N20i91lR2OMUczO/mbSxr8Dg320ouxE28xlGCvIb19GS0MKe
 2Iri3tkly8ZMehSbrW3HHvMvrQcxqV8JtR0b32WAB1ZCrlo9VjVhanYux1tA+WJm793525TSqB
 bdGNPr9tojr6/EUwnHSN/fHj+o8YS2Wht46ZMameh6mjyyEy3lBoOjWhliujziDv6vOpo8z1Es
 JniGIBNqIISX+bh0y7XlMe4sen3sNkaEfXEjsqLiPtlyrHGWUqsKu6FAAoiOPJ4mB6ARgkgqGq
 jkU=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="57544900"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:54:08 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:54:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 5 Dec 2019 02:54:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrNib3qjvFvQWfcpgyUx2xEgxIBMqV8w5W9INRYG6cRbVLW2eD6Ph1fo3EMJRg2mTEW0V9aBj65ngruVxLbp6777IV3g4btqlC3dqKQZOnuklj//DZl93G0Z17k5Bktxp4kGsW8I6AOJfKa4l90133F4RRJmRpq8ObTBx5t95ZS5bPpdZ90CeH/RcA9y/x+HXAErGMdEcEjmkvwlwWhNSqEykXcVIrviEs2yC5UQC80U1LsHl1mLDurHY66D/gINFyVV2urEAGH8DIitHzpItc9f5WWTBsV6g3fGdCAXRMZEj9beCexnLUoNO6ZSKOxnuv+/stiZmCs1pN/QImYuyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMeyqkkhOwQHzD1TZP1b7p/kc7yXc3GgOWu9Lw2uvmY=;
 b=BAun4E6nm4iFqaWMSD8iXGeiqHz/fvuwIRlvNE9ZoPrVpjS57vpfgjK+q5iq1DtNrAJlyyKzygAuKw9W2sbfKPXgKrRncPW0kgDUdHXxY46BujfuFqJ+U7W0IlP+omUXVp5VNEALVIBEtIh5C4J7kBPHPrrjwiR7GtfeBeMvD1nnP1Ti/kiAbBoeV1UOr2/7GR1awpM7aYiIrk7+wuEu5v89lNRAQADd/k0jOiFrZC/ETmbp9bWwUPKmtFqh342FNFpY7hxapL0hsAWHz7z7oIVRFSu1b93tmxviV7PtsdSrA88t5ph3ccYJvI76LL2TjUDsLyDB+KLMt+xGL0qgOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMeyqkkhOwQHzD1TZP1b7p/kc7yXc3GgOWu9Lw2uvmY=;
 b=j1XZu3XJmumpecv4zj3hg/sLbxpYGEHp1KmYYy3m0xzkxQT9mJK+8jre6IFRossfbK0IionkYAVSy+ATrsMoPy1bCp5xOa+fCvb8Ccr1yeO+Z4mk/6kextBuX/R2kj1zZTd2wx2Aa4ICcW4Z/2QuZ9V3A2qhJtO/VtlsceqgdSk=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3677.namprd11.prod.outlook.com (20.178.253.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 09:54:07 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:54:07 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 14/16] crypto: atmel-sha - Void return type for
 atmel_sha_update_dma_stop()
Thread-Topic: [PATCH 14/16] crypto: atmel-sha - Void return type for
 atmel_sha_update_dma_stop()
Thread-Index: AQHVq1HvDQITs5W+m0SHjGvsCwHDGQ==
Date:   Thu, 5 Dec 2019 09:54:06 +0000
Message-ID: <20191205095326.5094-15-tudor.ambarus@microchip.com>
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
x-ms-office365-filtering-correlation-id: bee9dbf6-638f-4990-6fc9-08d779691175
x-ms-traffictypediagnostic: MN2PR11MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3677326DD38C7E93CC76F740F05C0@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:221;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(2616005)(66556008)(305945005)(66476007)(66446008)(102836004)(64756008)(11346002)(5660300002)(52116002)(76176011)(99286004)(36756003)(66946007)(4744005)(2906002)(54906003)(26005)(6916009)(6506007)(1076003)(8676002)(6486002)(4326008)(50226002)(1730700003)(8936002)(14454004)(81156014)(186003)(86362001)(81166006)(5640700003)(478600001)(6512007)(71200400001)(25786009)(316002)(71190400001)(14444005)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3677;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xROzuMCWirXXb8EruNr0D2VdtMX4o8shQSK56TbbDmu4DLN0NkqJPkEku5zCUWrvjonu0tfPSaoe1qS0KDJZAewjeIDZDWjK0NWEzWtL+NXa17wuFRZbuPenY8ggGigGHb5M+PPnlo+36Htj0gJcLO0Uhn0FgDn8qKZ5TO3fEUSEeY6GMxoNtuYqHQBDOvBFBsVzI2p/52M3N+ZLZFfORQwtcWWYfGfa45bsqN0d54Qbq+n8LlJb9ewN8BOaHS15oIWQdRvcR74jrrGJ9vACV2Q6le7YoREGTGlOQGfwGASfG5k6RuP4ckfKoeMvKO7/0dji4u4+yFVQsj1wODO8RcjDO4YA7P3+OAvpTBtDNyIYHuvTd333gyBN6dl5/WbeyPQPOzFKLUfxVMeurx/eYkFeffMlOj6LdIs2EbkBOhU5ss7IKHs97uXYYUHx2Wnu
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bee9dbf6-638f-4990-6fc9-08d779691175
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:54:07.0159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uCQrLuOv9MREEM5wcBVGvf59e7TuOnwW6SbzrFrlbNo6eIvrQyKN7ViGkdYywNAKr9IAQ8dlgZ0abMuJgkBf0YD94J88i9xeLjVbZFSMGgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

No error handling, change return type to void.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-sha.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 391a72728c2a..a620a6a1cee3 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -852,7 +852,7 @@ static int atmel_sha_update_dma_start(struct atmel_sha_=
dev *dd)
 								0, final);
 }
=20
-static int atmel_sha_update_dma_stop(struct atmel_sha_dev *dd)
+static void atmel_sha_update_dma_stop(struct atmel_sha_dev *dd)
 {
 	struct atmel_sha_reqctx *ctx =3D ahash_request_ctx(dd->req);
=20
@@ -871,8 +871,6 @@ static int atmel_sha_update_dma_stop(struct atmel_sha_d=
ev *dd)
 		dma_unmap_single(dd->dev, ctx->dma_addr, ctx->buflen +
 						ctx->block_size, DMA_TO_DEVICE);
 	}
-
-	return 0;
 }
=20
 static int atmel_sha_update_req(struct atmel_sha_dev *dd)
--=20
2.14.5

