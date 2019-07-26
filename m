Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163C5C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCC9B21873
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="pnHEfHfv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfGZPx1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 11:53:27 -0400
Received: from mail-eopbgr20049.outbound.protection.outlook.com ([40.107.2.49]:39497
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387865AbfGZPx0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 11:53:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvVJnsYc51YIyyyr82J42+ySLxTImm7WGTw7zgSkxHqn1TCeqOFT+fr9L9IQ36nfqjvg0BxjTgo861tHVb+bctPCgO8cLEonNVCxxDm01WGmiS17mrT6/HvF6y26gUAtUyS8ZYs4ajZr8k/SjUDMapL0UrzMXbKdMnhwzvMNOCLwX26b3V0e1OVgg1dkALWqYkCenymBnihoXEbhIV7fZKMLLLWD48liHDpJRa/HaGlchYHbsPoGD7Q6vQnjsED5KCH1xLP2OQ94xqtEfYrMSG4271bdiERAoKqwkcN1zOogdR23ez+t/ACEFSyYgmgUMZFxM0EerxKV7uioetKXig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wM4mTTHbcKSkTsMbyOcIt13vc9lVrRU6hxtbHOQNQIc=;
 b=H0l+9m3Wf0gJ5uJhnTlE7PoJDjM+aibVX6m/cz4QLLRdF4d/u0FeNohhUHemq7mxiKF35zw6Bh6RBCZAYQrPolBBuoqwb6uM7hSrw1EtCHA6brMps3QkIs4M8CrKANL340uYboLE1i54Wea9Yv9jnO2CQ4E01u++kyR6aW/00g0+zbRtIB1crgwGfpI+jf8r9608tIqpOUAvNDjc6wMHfwOBnX2JZzzehe0LPpvXm6CfuJ4yWMjuAr99J1BNjm6lchHZSefjL3UIS+F7rWX54DtaL0TUplzNi+9Xl2+7MX9QqMxz0V24WlHvqeBgOfH2JLhkCSy97aPvftSndH31lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wM4mTTHbcKSkTsMbyOcIt13vc9lVrRU6hxtbHOQNQIc=;
 b=pnHEfHfvA1JBjTT5UzDKwTInPGZ0VFe+WxTCQJV1xWIDWtXUcyRSW7oKnUcyWOC0NCuMuqIw4CS8yr3aoFvo1Za/N0baTTDPgrWGRsBSiFInkPl3dkJIJoeVBx7tstNtH1tH8kbSDWF+MKe77F8Vh4vKqbH7W7j+fu/eeqvvZ4Y=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3472.eurprd04.prod.outlook.com (52.134.3.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Fri, 26 Jul 2019 15:53:23 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 15:53:23 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3 11/14] crypto: caam - free resources in case caam_rng
 registration failed
Thread-Topic: [PATCH v3 11/14] crypto: caam - free resources in case caam_rng
 registration failed
Thread-Index: AQHVQvERu4ZDykuEyEWKG/zLTBxy8Q==
Date:   Fri, 26 Jul 2019 15:53:23 +0000
Message-ID: <VI1PR0402MB3485406F10306B19151611B198C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564063106-9552-1-git-send-email-iuliana.prodan@nxp.com>
 <1564063106-9552-12-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.216.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcdb26c3-0c8b-4653-b5ef-08d711e163a8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3472;
x-ms-traffictypediagnostic: VI1PR0402MB3472:
x-microsoft-antispam-prvs: <VI1PR0402MB347265DBD8566083A760B95D98C00@VI1PR0402MB3472.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(81156014)(71190400001)(2906002)(6246003)(81166006)(6506007)(66066001)(256004)(66946007)(6436002)(91956017)(6116002)(74316002)(53546011)(76176011)(52536014)(305945005)(4326008)(76116006)(64756008)(66446008)(14444005)(66556008)(7696005)(8676002)(66476007)(9686003)(55016002)(102836004)(316002)(3846002)(71200400001)(68736007)(6636002)(8936002)(110136005)(26005)(86362001)(14454004)(229853002)(7736002)(186003)(478600001)(476003)(25786009)(44832011)(4744005)(99286004)(5660300002)(486006)(53936002)(54906003)(33656002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3472;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wusNE/+VkqCwsr3MJn9lqv7Ul0aWY07BPB3u0xWobwxWyIxzGXLiFCJ+G2EuYgGIff7sl4DPaKgjvQOKIZYMWKMt4XcUID0moxIXm5bH4LwxJ1AM/idw+VeE3vtWkNjBwaqRdK2WcD9xuYYETZalTR2pRfzzS9rcIBEzUwOtMg1BwANq16/gnS+B+IRE0QbNUGnW3/GfWW0e2t80Pk1qOCONe3vkHYamUCp2NhkpOWDNeQZEV8vcOzdoYatRECwxBoOzrjeUptice0qRda10S4+Doikq/lwOFrJkHL0TpbUzql9v8tOREBKpXG7oCpMpfqX+9snubpLrvqljL/hGP0XLH0eVFYwcp0awmyQ1kM78sjv+CKQsTb+AWjMcUPHdZDsG8T9DvnKi+TJDJAWpn8tbjRGw5UEwu6Pbw2+CcN8=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcdb26c3-0c8b-4653-b5ef-08d711e163a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 15:53:23.1140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3472
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/25/2019 4:58 PM, Iuliana Prodan wrote:=0A=
> Check the return value of the hardware registration for caam_rng and free=
=0A=
> resources in case of failure.=0A=
> =0A=
> Fixes: e24f7c9 ("crypto: caam - hwrng support")=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
but please use at least 12 characters for the SHA1.=0A=
=0A=
Horia=0A=
