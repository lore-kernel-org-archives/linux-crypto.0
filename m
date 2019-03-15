Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2E7C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 11:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C6DF2184C
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 11:25:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="badW8M1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbfCOLZb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 07:25:31 -0400
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:49846
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726785AbfCOLZa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 07:25:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGakhChNRo9dfWTUfS3cRzJ3fdqvF6SCppledGRgTHI=;
 b=badW8M1MHodCRb6qSAEQcMHXsb9XUAddCEtTlrDCM9k6zVUnNoPVY3ZjGIi6mwInTnspbHhMWtXlUnsicBDwZ1QEOvzBpnqZtVY7+3JdlTQtpLHHGgWuxUa+lW5McOC25iznWuwbk/mxx16n7SjyxZlWb0WWW2Da4ksLbGvf4ZQ=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4428.eurprd04.prod.outlook.com (52.135.137.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.13; Fri, 15 Mar 2019 11:25:25 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1709.011; Fri, 15 Mar 2019
 11:25:25 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v2 3/3] crypto: caam/jr - Remove extra memory barrier during
 job ring enqueue
Thread-Topic: [PATCH v2 3/3] crypto: caam/jr - Remove extra memory barrier
 during job ring enqueue
Thread-Index: AQHU2yHJ0NGh70TZ50KNYr94J5qJrA==
Date:   Fri, 15 Mar 2019 11:25:25 +0000
Message-ID: <20190315112238.24337-4-vakul.garg@nxp.com>
References: <20190315112238.24337-1-vakul.garg@nxp.com>
In-Reply-To: <20190315112238.24337-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:e::28) To DB7PR04MB4252.eurprd04.prod.outlook.com
 (2603:10a6:5:27::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 929f4936-fc2f-4bb6-7edf-08d6a938eb1e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4428;
x-ms-traffictypediagnostic: DB7PR04MB4428:
x-microsoft-antispam-prvs: <DB7PR04MB44287983CAE877F1300E049C8B440@DB7PR04MB4428.eurprd04.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(199004)(189003)(6436002)(6486002)(8676002)(316002)(8936002)(81156014)(81166006)(2906002)(50226002)(66066001)(2501003)(86362001)(6512007)(486006)(1076003)(256004)(14444005)(2616005)(14454004)(11346002)(476003)(25786009)(44832011)(71190400001)(71200400001)(99286004)(76176011)(4326008)(36756003)(68736007)(478600001)(105586002)(52116002)(446003)(53936002)(97736004)(186003)(6506007)(54906003)(386003)(110136005)(26005)(102836004)(6116002)(305945005)(7736002)(5660300002)(3846002)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4428;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kQyW3F+WHVQKTPs9k7+JGa3FqjIvv4YIg1DsQrIVhbraAWqVOALJ06/zX3l+7DdlbfACqLo5+omJJl2AyrYKLl5vuqFp53Cr0zSwAt1lW8KzK/PL4vM5lv+R43wYSYV/xLso7cpPd4qvzMpL3fGRMaz2FqcvUMZHl0TaDMCC+0mCEPt8Lh5ZeGA0wA21DkTQRcr/ji6arZSV0B1cJpB/dCdt3tNlZCTfl7OURZu1gsWv/Tb+1PiPMMxAoCsB7sKg/vRVJf4H+qEI6WYOIg42bsf5jxultyTfZhN3OG0lvwjxFF7UhG+jMVLKMfDa8O9V4v89miiF2d4ilX2OvHEU8iFa9UMKkQc2bszNQ8HPnMnDeEe3pDcW9QgSPNI32l2KS8uGWn5ANAd0hzOuRL7pZSiVuf2V1xjvi9uTn27VrnM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929f4936-fc2f-4bb6-7edf-08d6a938eb1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 11:25:25.4946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4428
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

