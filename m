Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748E9C4360F
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 02:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 419E4218FE
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 02:00:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="rMvTm0Ru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfCVCAn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 22:00:43 -0400
Received: from mail-eopbgr00050.outbound.protection.outlook.com ([40.107.0.50]:43622
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727535AbfCVCAn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 22:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYsj3zdWfXEr+MslexYiKsYMY+y5tkOkXVUINGvf0M4=;
 b=rMvTm0RuyHXUabRLnxuJxE/5mua0DxYPyuqD0mqwH9zAVdVejGpgfO7Y31S6nlpD6zWyEWrJd9nZzdoeyuB0Rq8MPl6FjRRrC2fcZe0uhdpcEDaZr5Mo9R0dGsBd1QxLUWFJXahdajjlFBMTPNO+hJ7GpcVv3LQ1mI1bdgXau00=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4187.eurprd04.prod.outlook.com (52.135.130.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.16; Fri, 22 Mar 2019 02:00:37 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1730.013; Fri, 22 Mar 2019
 02:00:37 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v3 3/3] crypto: caam/jr - Remove extra memory barrier during
 job ring enqueue
Thread-Topic: [PATCH v3 3/3] crypto: caam/jr - Remove extra memory barrier
 during job ring enqueue
Thread-Index: AQHU4FMLakYpNAFWNkKDIm/X7dQUTA==
Date:   Fri, 22 Mar 2019 02:00:37 +0000
Message-ID: <20190322015746.27395-4-vakul.garg@nxp.com>
References: <20190322015746.27395-1-vakul.garg@nxp.com>
In-Reply-To: <20190322015746.27395-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0113.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::29)
 To DB7PR04MB4252.eurprd04.prod.outlook.com (2603:10a6:5:27::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98ec7f92-fbb9-4bb7-6a52-08d6ae6a2d74
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4187;
x-ms-traffictypediagnostic: DB7PR04MB4187:
x-microsoft-antispam-prvs: <DB7PR04MB4187573EFF78269A3E18A9D08B430@DB7PR04MB4187.eurprd04.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(446003)(86362001)(6436002)(81156014)(66066001)(97736004)(7736002)(99286004)(71190400001)(6116002)(8676002)(3846002)(4326008)(6486002)(2616005)(2501003)(476003)(81166006)(26005)(71200400001)(102836004)(52116002)(76176011)(486006)(54906003)(386003)(6506007)(316002)(110136005)(305945005)(14444005)(256004)(1076003)(2906002)(6512007)(44832011)(36756003)(25786009)(50226002)(53936002)(11346002)(478600001)(105586002)(106356001)(186003)(68736007)(5660300002)(14454004)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4187;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HcB0w52j8bsGJPUGMpameJnFJzm+4N1Ur7zWbxfOfzKwQFIAMqP0znfqmZaSXqwyZKlYOgnoVshYsXsCVlmeivMcLGpb+cg15sdm5eMmTS1DzBQrxeRyjdHYebiFCqrsfqiMpBtGjPAkUnBcuYpBG6rXEJMwV15aJbxdfrgsbq1S2JWNALqg1e5aQL2IGgzFho9nz6MtCH2dRisflEnEjbPuMZb0dVIRgbXaumxKp1AMxfEtESLAqKclYsWIdOZevDyZHiBN4IH/hCM2CWN7QwtQlAQ4Z7Gvm/f73DOuuVKmLsuH2qAKa9RRutwRbh/ZgTma67gG1gBFtNVKbjxDkG/DR4ueVUiZU5ogVKLu2s4KoSpwgEt/L9oHxGSOu+usvepLCkjem6S5F2Y/UU3AGXzj0CavvhKH1Yr3eQWg/3g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ec7f92-fbb9-4bb7-6a52-08d6ae6a2d74
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 02:00:37.5977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4187
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In caam_jr_enqueue(), a write barrier is needed to order stores to job
ring slot before declaring addition of new job into input job ring.
The register write is done using wr_reg32() which internally uses
iowrite32() for write operation. The api iowrite32() issues a write
barrier before issuing write operation. Therefore, the wmb() preceding
wr_reg32() can be safely removed.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
---
 drivers/crypto/caam/jr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index e95f82778fa1..1de2562d0982 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -371,9 +371,11 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
=20
 	/*
 	 * Ensure that all job information has been written before
-	 * notifying CAAM that a new job was added to the input ring.
+	 * notifying CAAM that a new job was added to the input ring
+	 * using a memory barrier. The wr_reg32() uses api iowrite32()
+	 * to do the register write. iowrite32() issues a memory barrier
+	 * before the write operation.
 	 */
-	wmb();
=20
 	wr_reg32(&jrp->rregs->inpring_jobadd, 1);
=20
--=20
2.13.6

