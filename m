Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DA5C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E93CD2077B
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="oLpfpoVz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfCOEFZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:05:25 -0400
Received: from mail-eopbgr20056.outbound.protection.outlook.com ([40.107.2.56]:56206
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726315AbfCOEFY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 00:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49l1fhmwbY+QGfft/mE5s22Lw458YIifmpsL+rJviKA=;
 b=oLpfpoVz8o5GbcJgrCabAR0SfQTu/J/HI2sIawQ9vTO6F/daGCH53BpLt8jG0ENuYS94zdDIDCfxpzdwhf96V7mLDAjA3d5I3509aB15bsNWKCMu/XgEWEsZ58zQfXcfKkPvJZLVP0vnRa1ftj4J009DrAwjqLsNYhfZaF8+RR4=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB5050.eurprd04.prod.outlook.com (20.176.234.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.13; Fri, 15 Mar 2019 04:05:21 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1709.011; Fri, 15 Mar 2019
 04:05:21 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH 0/3] CAAM job ring driver cleanups
Thread-Topic: [PATCH 0/3] CAAM job ring driver cleanups
Thread-Index: AQHU2uRPZG2qMFNge0CuyALTTTfntw==
Date:   Fri, 15 Mar 2019 04:05:21 +0000
Message-ID: <20190315040239.24705-1-vakul.garg@nxp.com>
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
x-ms-office365-filtering-correlation-id: 5e1ea9ed-b6d2-46a1-d4b8-08d6a8fb7143
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB5050;
x-ms-traffictypediagnostic: DB7PR04MB5050:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB7PR04MB50501731256568FE2400CCD18B440@DB7PR04MB5050.eurprd04.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(39860400002)(346002)(396003)(136003)(189003)(199004)(2616005)(25786009)(54906003)(110136005)(66066001)(486006)(478600001)(476003)(6306002)(6512007)(1076003)(26005)(2906002)(71190400001)(6436002)(71200400001)(3846002)(106356001)(5660300002)(105586002)(86362001)(6116002)(6486002)(4326008)(4744005)(36756003)(8936002)(97736004)(186003)(81166006)(102836004)(966005)(2501003)(256004)(6506007)(52116002)(386003)(8676002)(81156014)(305945005)(7736002)(50226002)(316002)(68736007)(53936002)(44832011)(99286004)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5050;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GafnG1DJsT1BqkMS+NQXCOr30J52VylHMVQOHjT8rYbrNucX3GWLz2kVdtCazNGJFjEB4D1OkszVoy4GlH8Ukks0U60n9tttX1W6HATcdcT0lk4lLMzTJFZf2A8X1F0bga7PT/z1pp5RLhvxlkKt0gGqjzWR+zfa7Qi9UigSjbUwK70nWMWbotzjLLy9+7E8GoO9Bpk86PW74scll4FAgUe4v7TFGUokkLxHGBR9YuUiAETuns5HU6q/pePMoO5zXb52lWoWAjyb2I2vXwAyKVK68785A0WhR8MZOvGTIngGk3tRYvfGpmQZwa5WRZm6ea3fWKNKEc1pGnlVZnHGZtT0eWPSon+gNNyKDYQfaq8hChBFvJep+CPiOSCupFtTGQmtEhGRxli7kOWJebzRjRp5bnEzxgKjnWdn2KaSmcU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1ea9ed-b6d2-46a1-d4b8-08d6a8fb7143
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 04:05:21.4495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5050
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

