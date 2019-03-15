Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66AAEC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 11:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1441D21872
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 11:25:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="DRXH10qI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfCOLZX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 07:25:23 -0400
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:49846
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726785AbfCOLZX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 07:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49l1fhmwbY+QGfft/mE5s22Lw458YIifmpsL+rJviKA=;
 b=DRXH10qIVOPbASklr6PmYSNAmx22Z6FhfRmAIFGwka5LDPaEwV5npvPfcLgfPIYSiqbc7TONt3hipUwOYchaoUPXv/rf778+Gmqb3Chama7eajIe4dB4lPGCDdlEDNdNn/h/hkxNqnnaVj3CEwTyvOmnQ4KPdSZ21BzMaLWDme4=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4428.eurprd04.prod.outlook.com (52.135.137.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.13; Fri, 15 Mar 2019 11:25:20 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1709.011; Fri, 15 Mar 2019
 11:25:20 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v2 0/3] CAAM job ring driver cleanups
Thread-Topic: [PATCH v2 0/3] CAAM job ring driver cleanups
Thread-Index: AQHU2yHFyZWyQQKIrk+NmqJ8Ls1JCw==
Date:   Fri, 15 Mar 2019 11:25:19 +0000
Message-ID: <20190315112238.24337-1-vakul.garg@nxp.com>
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
x-ms-office365-filtering-correlation-id: 99b2cec8-cb6b-41f0-f243-08d6a938e7e7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4428;
x-ms-traffictypediagnostic: DB7PR04MB4428:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB7PR04MB4428148F6C29D3DE0CC8E8DA8B440@DB7PR04MB4428.eurprd04.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(199004)(189003)(6436002)(6486002)(8676002)(316002)(8936002)(81156014)(81166006)(2906002)(50226002)(66066001)(2501003)(6306002)(86362001)(6512007)(486006)(1076003)(256004)(2616005)(4744005)(14454004)(476003)(25786009)(44832011)(71190400001)(71200400001)(99286004)(4326008)(36756003)(966005)(68736007)(478600001)(105586002)(52116002)(53936002)(97736004)(186003)(6506007)(54906003)(386003)(110136005)(26005)(102836004)(6116002)(305945005)(7736002)(5660300002)(3846002)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4428;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kSo8h3eYRC0ahSsKdCZhOUorHlVKhZb64lxSQKsPhPkZ8nifyuuEnT701iA5+Lx1s3BYCY4rAhx8gmtYP3ORW61Zw4RMXE9DA/fgVQ0mv72SgddXDvdN8mpaIcUF/BKhZMhktIUYOJdd6zkoATqWluWO45u7XkB3LIf762FCF6Ps6I5bD9Wco6vZls9QTVGpTAe5De1NLGqw0rIcMwZjqIB+qGLOOhO3LVT1CEl0MsIK5Mg6altzDT1JfAC1FJdNaK9/0Ayt6LUReYkiSlieVnHBg3cfLKOGwcxCQf6o2m/zL7jOVOHRKcCt86+hkJw9GsjUvkLGgV116Z38Mw2mPxpeqFiZVqGNcOLzpgB50y8Fsj8+scJp7vLuh9eVlQYEiEo0MIHwZs+rgG/siTt1fiEEAx9/gI+lKxk8pg2SWLQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b2cec8-cb6b-41f0-f243-08d6a938e7e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 11:25:19.9988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4428
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset cleans up caam job ring driver.
The patch series needs to be applied after merging below mentioned
patch.

https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg37068.html

Vakul Garg (3):
  crypto: caam/jr - Remove spinlock for output job ring
  crypto: caam/jr - Remove redundant vars from job ring private data
  crypto: caam/jr - Remove extra memory barrier during job ring enqueue

 drivers/crypto/caam/intern.h |  3 ---
 drivers/crypto/caam/jr.c     | 17 +++++------------
 2 files changed, 5 insertions(+), 15 deletions(-)

--=20
2.13.6

