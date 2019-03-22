Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07003C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C78EF218B0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZBgPMVLJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfCVNtP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:49:15 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:36376
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728005AbfCVNtO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 09:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJAU8HfhEeBWxNFZQDzx0L9V6CZVs4e7iDml7bkmpuQ=;
 b=ZBgPMVLJ0GS1QBXc8DceIHfOt5a9zjYt/WAoMy0jcxVHkPJcMcsNKGtmO/lCuhxvKfdt1SwMNH832/7MlD6R943b0sn1/4Pb1DaKvHsHLIveaUnBW4JbpzViEmHnS74rIA0YwbDe3MyVQY5toXakopSSzeZfo5miBGhG+s+dAtk=
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com (52.133.50.141) by
 AM0PR0402MB3780.eurprd04.prod.outlook.com (52.133.39.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Fri, 22 Mar 2019 13:49:11 +0000
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::211a:4b31:ec05:6b2d]) by AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::211a:4b31:ec05:6b2d%4]) with mapi id 15.20.1730.017; Fri, 22 Mar 2019
 13:49:11 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam - limit AXI pipeline to a depth of 1
Thread-Topic: [PATCH] crypto: caam - limit AXI pipeline to a depth of 1
Thread-Index: AQHU4LS0PhbDv36r/UaEkV+h8tAXFw==
Date:   Fri, 22 Mar 2019 13:49:10 +0000
Message-ID: <AM0PR0402MB3476CFA25333D7821B5079D898430@AM0PR0402MB3476.eurprd04.prod.outlook.com>
References: <1553261968-5766-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6fa8235-57fb-4e48-1e04-08d6aecd29b1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:AM0PR0402MB3780;
x-ms-traffictypediagnostic: AM0PR0402MB3780:
x-microsoft-antispam-prvs: <AM0PR0402MB37808804F7784751278B504298430@AM0PR0402MB3780.eurprd04.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(9686003)(186003)(81166006)(66066001)(81156014)(55016002)(478600001)(74316002)(44832011)(6436002)(2906002)(52536014)(68736007)(7736002)(71190400001)(3846002)(305945005)(71200400001)(6116002)(316002)(97736004)(86362001)(7696005)(5660300002)(229853002)(53936002)(486006)(53546011)(26005)(446003)(6246003)(476003)(25786009)(102836004)(6636002)(4326008)(4744005)(105586002)(14444005)(54906003)(99286004)(106356001)(33656002)(8936002)(110136005)(14454004)(8676002)(76176011)(6506007)(256004)(6346003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0402MB3780;H:AM0PR0402MB3476.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rv7q/d5P66k6SnshxXSzrEy2Oah3nhb+iEp9I7zlG0qXk7VMIg3cA2kHdQtzqTU+T6343R4UdnFwCgwndv2XCz8apLw98OvBYk+vcdc2G0jCaHCnYyCwSFQ6BYECusD443UHUYNtqZpGJwgqFui4LwX5heuRT44k7eQ/WCsmFJAVKm1ADjJBSk08mFwZQ3ydscF/Js3pTxjjxW1vtYPAPhVf2v3VsCD3fwyyBPwJEs9tKRO7JTN6Y1WP03zqj4teca4aGXIvKa8jFJPSYUCZegIQgp/9F8KQRxEyQM+l6o3Ii0syd02tVRk5MUv4wrHu57GdNV8lDxErWjWX96zCm1GoI3Pm1xdLhy/2xRhwKZ+OyWdLNQ0C9uxUthPgL0ojCWkJ+v6STgSqQyabgQgec/QHqbr4dbPHpLO8j1Z6n40=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6fa8235-57fb-4e48-1e04-08d6aecd29b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 13:49:10.9415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3780
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/22/2019 3:39 PM, Iuliana Prodan wrote:=0A=
> Some i.MX6 devices (imx6D, imx6Q, imx6DL, imx6S, imx6DP and imx6DQ) have=
=0A=
> an issue wherein AXI bus transactions may not occur in the correct order.=
=0A=
> This isn't a problem running single descriptors, but can be if running=0A=
> multiple concurrent descriptors. Reworking the CAAM driver to throttle=0A=
> to single requests is impractical, so this patch limits the AXI pipeline=
=0A=
> to a depth of one (from a default of 4) to preclude this situation from=
=0A=
> occurring.=0A=
> This patch applies to known affected platforms.=0A=
> =0A=
> Signed-off-by: Radu Solea <radu.solea@nxp.com>=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
