Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA1FC76191
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 11:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD34321783
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 11:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="r62DtUyA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfGRL3V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 07:29:21 -0400
Received: from mail-eopbgr10086.outbound.protection.outlook.com ([40.107.1.86]:11687
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726608AbfGRL3V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 07:29:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0sgHjIhmrgc4xzcMvSUqdZJioGX45meNfjtqDOOzX9Fv+swPjgYIxVzu1bikv7HZIMA8kRo8AbkGOOPgBFRp0fK76R/g2xIdDYpBv0P644oWbVxYC/6bVU47iFhqc2o2bkTwJY+PXNLYdP1ZBZVG9v4r878stg1Xt2z+qdmuMXS+FboDBp9SWIOaY1QZvILsWP/G3u5ALFmNZYo5CTNdvFYLXDopkAvxpo+dNSetz7yaM+BmvHryJv/yWRmd0+xQ//3hPXd/PIq7fJAV87PA6NE4z778ayaZFms8s2GnOHLi+wAWLJPsYhO+7noTx7oDXyWOeXabwZV/gKNFxSdvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAOOWmEv99YeAlPnX3CVPA4vjaGkOuUC7Voy1trkEJw=;
 b=Z2Vo6+aoXGRUu+lSkArU07mjzgiC/DRD/nT/1nF6c2/SeZcHDaiJeoVfxqOAdHGvC2WKQdFAqEZAe+jyxUEruS+mDy1NjjZ2l8q+qjQNfFdyifIZEU5mVkiglXpqTSafLltOMhX6V1GEPC+WCEa9rRutUmLrRLatSjNNVOfN1g7pXutgEw/Nooy6we9ds8/tx4N4twcGPp1woAsHbMmg+J08KYBqeHYRl06njqopioa7O7t0QhkJpL9eR+e6qjqjlTdkmQHjK/O5I2FoEpja8rROZKb3YXkGxwE/FDpzqyDuckyq3Dsxu+YDKnD7MRZ93aO0es9U9usJyxpY8tXnLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAOOWmEv99YeAlPnX3CVPA4vjaGkOuUC7Voy1trkEJw=;
 b=r62DtUyAM7Ut0JSf3lt9deYUeDWAistZL7nFS1ylGmA/s+VgIECq3/OGVF5tN6dG+n5gbLS9OflCkI+vcUz+cOQBDx6cjMuFbUQLY25/G0kVBcJaTFR/erstJZgn891CViV4ztxk3+GNJpFhEx9piougNTCghP6PIDI3Rh5S2Fs=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4569.eurprd04.prod.outlook.com (52.135.138.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.12; Thu, 18 Jul 2019 11:29:16 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f%5]) with mapi id 15.20.2073.015; Thu, 18 Jul 2019
 11:29:16 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH] crypto: caam/qi2 - Increase napi budget to process more caam
 responses
Thread-Topic: [PATCH] crypto: caam/qi2 - Increase napi budget to process more
 caam responses
Thread-Index: AQHVPVwIjltj49haakO+KNMG6PEHuw==
Date:   Thu, 18 Jul 2019 11:29:16 +0000
Message-ID: <20190718112440.4052-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR0101CA0045.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::31) To DB7PR04MB4620.eurprd04.prod.outlook.com
 (2603:10a6:5:39::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87f6bb7f-ab72-42ca-f8da-08d70b732aba
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4569;
x-ms-traffictypediagnostic: DB7PR04MB4569:
x-microsoft-antispam-prvs: <DB7PR04MB456989DF5B850EB1D7AB58168BC80@DB7PR04MB4569.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(199004)(189003)(2501003)(1076003)(99286004)(66066001)(25786009)(7736002)(486006)(256004)(66946007)(14444005)(4326008)(66476007)(305945005)(44832011)(36756003)(71200400001)(71190400001)(6916009)(53936002)(6512007)(68736007)(5660300002)(66556008)(64756008)(66446008)(386003)(6436002)(50226002)(6506007)(81166006)(81156014)(316002)(86362001)(8936002)(26005)(186003)(52116002)(102836004)(54906003)(6486002)(478600001)(2906002)(476003)(2616005)(8676002)(14454004)(3846002)(5640700003)(2351001)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4569;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CCqo+/vwxEmwAYiRDWJNzhzDg5lGxWx46MfDCl9CJyFmMZDE7G3uwhTV8q7+uZxsig31j+40CP4+y3XJ0SVCR/8LtILzkIfcbVdfQNkqH5r8hdpxm9PfPalvgMno11L/4Bm98oxEK4vY6MVqNMLQxW76jJP1RXnYqWou+xxnHGa7rXeCe4KS9xVyE5f2GLUalrSysahXcPh8FAMr9loccmLNXr6yhWAZJPCEPe5oPI3XFm+D2Hdu3w4PmZXeUFMLm9WKPFJCiUVfP08QnRfVJ9v9BYAIrt0+PmvqllF2rvNtwcVMct+tl54sraVmjN3ztHWyZ2cyzZwJRb00O36jygGnUNpr8p2PJ92WurRdJlQluNm2k06OL9nGLXbJkpLQQ6r0eC0JxkOtk+oREuFsk2YZ6OrC9qqroWeK5pKgRVE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f6bb7f-ab72-42ca-f8da-08d70b732aba
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 11:29:16.4544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vakul.garg@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4569
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

While running ipsec processing for traffic through multiple network
interfaces, it is observed that caam driver gets less time to poll
responses from caam block compared to ethernet driver. This is because
ethernet driver has as many napi instances per cpu as the number of
ethernet interfaces in system. Therefore, caam driver's napi executes
lesser than the ethernet driver's napi instances. This results in
situation that we end up submitting more requests to caam (which it is
able to finish off quite fast), but don't dequeue the responses at same
rate. This makes caam response FQs bloat with large number of frames. In
some situations, it makes kernel crash due to out-of-memory. To prevent
it We increase the napi budget of dpseci driver to a big value so that
caam driver is able to drain its response queues at enough rate.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamal=
g_qi2.h
index 8646a7883c63..aa0aff4cd25b 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -15,7 +15,7 @@
=20
 #define DPAA2_CAAM_STORE_SIZE	16
 /* NAPI weight *must* be a multiple of the store size. */
-#define DPAA2_CAAM_NAPI_WEIGHT	64
+#define DPAA2_CAAM_NAPI_WEIGHT	512
=20
 /* The congestion entrance threshold was chosen so that on LS2088
  * we support the maximum throughput for the available memory
--=20
2.13.6

