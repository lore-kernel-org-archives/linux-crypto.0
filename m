Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4AEC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 02:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89783218FE
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 02:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="OTqmwPaE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbfCVCAg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 22:00:36 -0400
Received: from mail-eopbgr00061.outbound.protection.outlook.com ([40.107.0.61]:26068
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727535AbfCVCAg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 22:00:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFkG7tSR2Gjq1v9eDFNNIWBNTXgwgWOQ6FRDgh7ne18=;
 b=OTqmwPaE2ypq1t8w7Q6imaNNMMnYPC65H4VUMJR14ma3AH5gtZTUsLDnZ607iOl4lIVtW0JHHzP2rOhW/5AsBYe81AHspWSND+TxLgWM/ALMugImgOePXHAyn/tbsL+6LGp6V5czEzLmVmXBL289pgcQ/RJNMeeIvzV74q0TOT4=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4187.eurprd04.prod.outlook.com (52.135.130.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.16; Fri, 22 Mar 2019 02:00:33 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1730.013; Fri, 22 Mar 2019
 02:00:33 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v3 0/3] CAAM job ring driver cleanups
Thread-Topic: [PATCH v3 0/3] CAAM job ring driver cleanups
Thread-Index: AQHU4FMI7cL4deuKsk+aqZy0MdGBEQ==
Date:   Fri, 22 Mar 2019 02:00:32 +0000
Message-ID: <20190322015746.27395-1-vakul.garg@nxp.com>
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
x-ms-office365-filtering-correlation-id: 81c98452-bef1-4fc7-4f15-08d6ae6a2aa4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4187;
x-ms-traffictypediagnostic: DB7PR04MB4187:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB7PR04MB4187B8A2C38391DAC08D2C548B430@DB7PR04MB4187.eurprd04.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(86362001)(6436002)(81156014)(66066001)(97736004)(7736002)(99286004)(71190400001)(6116002)(8676002)(3846002)(4326008)(6486002)(2616005)(2501003)(476003)(81166006)(26005)(71200400001)(102836004)(52116002)(486006)(54906003)(386003)(6506007)(316002)(110136005)(305945005)(256004)(1076003)(4744005)(6306002)(2906002)(6512007)(44832011)(36756003)(25786009)(50226002)(53936002)(478600001)(105586002)(106356001)(186003)(68736007)(5660300002)(14454004)(966005)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4187;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f81NTfs2gkiBxq+ieAUtRV6/15a5wsL0ouNNFF7HU5ouvqu6L0JdZ1KX7aUzzNA03qV8In3adx8IC615sJ9u9osBZA9+y6lPyV5RJymujDDlmXu+hj7wykdCgflbPrv0JLYMsIShyrkfvVU7UgnsENghGCWK00vNoEDXzqzCh8pXNgne+IdndzBfZwARwAoVteeSJITmUWl0/3bmUBcDkfM2BGoq8xeYZq1ZWDXKMxdpNghOIggEeSUGnqoDbVmo8qFSNdYN80/EcRRjeVEKnyJgW6YydthwEz0F5uZ/jZER9/JD+QqMteU6GWIEDlg6rgBzwMUYqZyOVWpe+1gmR4d5fVPvtJ0RQwGQj0J+eZdjo+9xNA0yIe6dpNxoMXrnqyOdUS83WT/Wj5R7lsLrqsR7p3JkGbqXcJZTJf91o6Q=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c98452-bef1-4fc7-4f15-08d6ae6a2aa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 02:00:32.8804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4187
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
  crypto: caam/jr -  Removed redundant vars from job ring private data
  crypto: caam/jr - Remove extra memory barrier during job ring enqueue

 drivers/crypto/caam/intern.h |  3 ---
 drivers/crypto/caam/jr.c     | 19 ++++++-------------
 2 files changed, 6 insertions(+), 16 deletions(-)

--=20
2.13.6

