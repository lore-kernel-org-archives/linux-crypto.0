Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43559C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 114DC2077B
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:05:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="o1iFBcIy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfCOEFb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:05:31 -0400
Received: from mail-eopbgr50078.outbound.protection.outlook.com ([40.107.5.78]:60967
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726493AbfCOEFb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 00:05:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYrYr1gB2L4p5DUFLqv8O9tswBEihjFm1LuIikvCmP0=;
 b=o1iFBcIyiRjC5REZ3iRmOFPeXfCV/luohMQXsZOCW2Kn7TtBfQ0YNiXtmRt88jhgqyibWQZq13oR0kXhiDT+IEffZJMQG4mto0AA65QYx2i2zTX1yMp57qLldqjzG0Psx7bMylrx/xkdVMzbVeN6V2HRrkLlgGpCqLmgpexI7L4=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4716.eurprd04.prod.outlook.com (20.176.233.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.13; Fri, 15 Mar 2019 04:05:25 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1709.011; Fri, 15 Mar 2019
 04:05:25 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH 3/3] crypto: caam/jr - Remove extra memory barrier during job
 ring enqueue
Thread-Topic: [PATCH 3/3] crypto: caam/jr - Remove extra memory barrier during
 job ring enqueue
Thread-Index: AQHU2uRRR0cYYITjQEyV02QNgFhbdA==
Date:   Fri, 15 Mar 2019 04:05:25 +0000
Message-ID: <20190315040239.24705-4-vakul.garg@nxp.com>
References: <20190315040239.24705-1-vakul.garg@nxp.com>
In-Reply-To: <20190315040239.24705-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::23) To DB7PR04MB4252.eurprd04.prod.outlook.com
 (2603:10a6:5:27::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f5d0390-66ff-44ce-d5e6-08d6a8fb73f9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4716;
x-ms-traffictypediagnostic: DB7PR04MB4716:
x-microsoft-antispam-prvs: <DB7PR04MB4716FCF27655300DCAF095C88B440@DB7PR04MB4716.eurprd04.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(97736004)(8676002)(105586002)(476003)(36756003)(44832011)(71190400001)(2616005)(52116002)(316002)(386003)(76176011)(4326008)(106356001)(486006)(110136005)(54906003)(71200400001)(102836004)(6506007)(25786009)(81156014)(81166006)(478600001)(7736002)(2906002)(14454004)(66066001)(2501003)(68736007)(14444005)(256004)(1076003)(99286004)(6116002)(53936002)(5660300002)(11346002)(305945005)(86362001)(8936002)(186003)(50226002)(6512007)(6436002)(3846002)(446003)(26005)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4716;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dgQVl3a91V4vuPRNlOkSJWcBR0crOFet4AnPY9Ha21WOEAHECR0dTGOMUKMcPVGX6U/JNbVeR8j6HxudLvgcc7cGtBZqqmroS5VJFhDLhUrZz7ED2hwZTLzTJghI2JXuGe4Es72FbwGyNFRqFqZkHF5aNSVht3qq/s9XzJ6mUsGvWOEtx7EUKV0HJUao48IlxJdLSsBDqbe4cMW70wzhlyi2FKTHcEldGRb12wtPT4ywjkxsr3zt709pkqzHdpE/i+m5ImKNPW24qU4/5CBUGjzZOOkux78x8PRoGLLQOSbGOrYIhJ8BEkQUwrFD9QFLXjn7wmW55cOaiy1X705cCq99wWdAS+GdTD6HBauJFoxy/YixoKLDD6EA7q6sgkvXKG8Im2Po349rkdWEwm04eeDG0ZJA2JLutmNKrZplRb8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5d0390-66ff-44ce-d5e6-08d6a8fb73f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 04:05:25.9057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4716
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
---
 drivers/crypto/caam/jr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 02f02fa996da..3bd28386eb07 100644
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

