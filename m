Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C658C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA75A208C2
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:37:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="cdisKLcD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfFLNhG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 09:37:06 -0400
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:7889
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726023AbfFLNhG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 09:37:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IN1Yj40/by2KsmjhGsp4WN01KK7a3AXQxR9ZRmuakl0=;
 b=cdisKLcDlWqNClCoLm7jqBK1neb55ssDdYTnpS9MDHCRW2i57SN7pAzrpU31gJtnw9Iag9KT34rnmaKVjqfobjcZhGn4tmRn7dp1084rCUSEuKVDVs0vQVmZ4mMGacZIFlcwgla08AtSqB8/MoRxs5h5MgXMNmA2kFi5FAzXiwc=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3663.eurprd04.prod.outlook.com (52.134.14.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 12 Jun 2019 13:37:01 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1987.012; Wed, 12 Jun 2019
 13:37:01 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] crypto: talitos - fix max key size for sha384 and sha512
Thread-Topic: [PATCH] crypto: talitos - fix max key size for sha384 and sha512
Thread-Index: AQHVIOKokm/zeEv5yEq7PjGly7PKww==
Date:   Wed, 12 Jun 2019 13:37:01 +0000
Message-ID: <VI1PR0402MB3485C8E7572B6EAB6D1CEF7898EC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <5f1004d33b2347dcfbc677551bafc9d469bb079e.1560318544.git.christophe.leroy@c-s.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19a90e58-c77f-4f25-3da6-08d6ef3b0c95
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3663;
x-ms-traffictypediagnostic: VI1PR0402MB3663:
x-microsoft-antispam-prvs: <VI1PR0402MB3663907B4FCF6CA03D7DD43498EC0@VI1PR0402MB3663.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:234;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(366004)(39860400002)(396003)(376002)(346002)(189003)(199004)(478600001)(316002)(8936002)(81166006)(68736007)(4326008)(102836004)(53546011)(14454004)(6506007)(8676002)(81156014)(476003)(86362001)(44832011)(3846002)(6116002)(66066001)(2906002)(256004)(5660300002)(71200400001)(71190400001)(4744005)(486006)(52536014)(33656002)(7736002)(66946007)(76116006)(73956011)(66556008)(66476007)(305945005)(74316002)(9686003)(25786009)(26005)(66446008)(64756008)(446003)(7696005)(54906003)(53936002)(6246003)(229853002)(76176011)(99286004)(55016002)(110136005)(186003)(6436002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3663;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +b8+ecrZ9nnfoQH/76auY3N5xI622mxai7luPpkXHzyxxvkbauRZW707tIQeBwaMDVKzuAXOhI9HywDhCu0xJh2h8C4atgYY683CdCrLKSMjWp+eOiUHEiCPQiycPbwOXytIbdAyp/Pcgo2hJ53xm30BCsr2UjMsJekSJO/PLOkunzNbELnEpqHpfmYtFUgIcfhOH++VXIrZapEvQ5gW68E8H07nKZU4UexDG2RInRxZnzmG1UME4/6m9mlKBWib/09DE67JH2zfhRGTe+MHuLR6vwiBQ2ewbit8VvQAj/uOHaa2+P38nRQ/rQMmImXruY9wHL625w6NGyPOj6Qb7aQxTi4Elq0X43wi5ALuh3oiOuJ0GxesssOwvvrjLhbREbz5OtRvKnyxpHmPga2+76FD7DI5nSo8ZmY/DIGR4vQ=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a90e58-c77f-4f25-3da6-08d6ef3b0c95
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 13:37:01.1680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3663
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/12/2019 8:49 AM, Christophe Leroy wrote:=0A=
> Below commit came with a typo in the CONFIG_ symbol, leading=0A=
> to a permanently reduced max key size regarless of the driver=0A=
> capabilities.=0A=
> =0A=
> Reported-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Fixes: b8fbdc2bc4e7 ("crypto: talitos - reduce max key size for SEC1")=0A=
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
