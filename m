Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81591C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 575712083B
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:51:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="czNwe+UP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfF0KvB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:51:01 -0400
Received: from mail-eopbgr10076.outbound.protection.outlook.com ([40.107.1.76]:30947
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfF0KvB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUM8k4FmT9GXCoQAase0IMMolH9VA/ThvqXPbwPHCpA=;
 b=czNwe+UPDrdHoVYT0+tUMsFFw/BD4jFwGAj3xceOVRMZLLUbGrHFG1BX7IEEcyjh4F5VykZ6oDdbkNfuWJ9qIrcCriqJZkPydqVAdvDCh1CBzNtGUkxYOpZxb0wWSq+Shxr9G9Ph19RTA+MwLuMPV81Sk9lneDY3ecXQ02vULss=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2816.eurprd04.prod.outlook.com (10.175.24.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Thu, 27 Jun 2019 10:50:56 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2008.014; Thu, 27 Jun 2019
 10:50:56 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] crypto: caam - move DMA mask selection into a
 function
Thread-Topic: [PATCH v3 1/5] crypto: caam - move DMA mask selection into a
 function
Thread-Index: AQHVJSZHrfiT286a+kWx5sqHeT0JfA==
Date:   Thu, 27 Jun 2019 10:50:56 +0000
Message-ID: <VI1PR0402MB3485542286BC0F8814DE4EB098FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190617160339.29179-1-andrew.smirnov@gmail.com>
 <20190617160339.29179-2-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e39a149b-f2d7-454e-ed80-08d6faed5525
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2816;
x-ms-traffictypediagnostic: VI1PR0402MB2816:
x-microsoft-antispam-prvs: <VI1PR0402MB281633DE0A9DF7C13C24875E98FD0@VI1PR0402MB2816.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(39860400002)(346002)(136003)(199004)(189003)(6116002)(446003)(3846002)(71200400001)(76176011)(8676002)(2501003)(64756008)(110136005)(2906002)(71190400001)(256004)(25786009)(66446008)(54906003)(66556008)(7696005)(316002)(102836004)(8936002)(6506007)(53546011)(53936002)(66946007)(6246003)(4744005)(478600001)(476003)(86362001)(26005)(486006)(66066001)(68736007)(99286004)(44832011)(76116006)(186003)(14454004)(66476007)(52536014)(55016002)(73956011)(9686003)(305945005)(229853002)(7736002)(6436002)(74316002)(5660300002)(4326008)(81166006)(33656002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2816;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zR4sSnS3pFNxtckoPB2AzQpXEugP1Phj+bgPzpM6t/SsBiOPsUlzK0pz1khDh4ZI0bsINCBTHSYJf+2cPnTVzVwukBB7jXNjcV3LrJtkzj76V9IVVHZGFUqM9TKiHQtMfsAwAJkQuYABxeJLZEoxyFIxpeiHuuSu5wT7whiAAklCbmFVDbggAP3D2wfFTHw9fWqrWeKZcyZkc1TatLas0gkKm0kF8toCdeqm4TqOYBv1vJsVB4fnjoCDUKW9XDO/6sVZ2JL5f/71u3Hi1Jkc0rMNvSgzB2QovQAYCuxVeKg1RZwe4nbgfcPT5YQ4Emswm6RLjP5TuLmACP46WaNpy9Xw5EMj5j+tEsShgSB7D0AF+zH2OLM9wc09XBdksPjTK2Zx18Y+WIyOFO3KHYznek2jJE9cYmfu/U+zkUzu95I=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e39a149b-f2d7-454e-ed80-08d6faed5525
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 10:50:56.1346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2816
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/17/2019 7:04 PM, Andrey Smirnov wrote:=0A=
> Exactly the same code to figure out DMA mask is repeated twice in the=0A=
> driver code. To avoid repetition, move that logic into a standalone=0A=
> subroutine in intern.h. While at it re-shuffle the code to make it=0A=
> more readable with early returns.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Spencer <christopher.spencer@sea.co.uk>=0A=
> Cc: Cory Tusar <cory.tusar@zii.aero>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>=0A=
> Cc: Leonard Crestez <leonard.crestez@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Being the 1st patch in the series and not i.MX8-specific, I'd say it should=
=0A=
be merged separately.=0A=
=0A=
Thanks,=0A=
Horia=0A=
