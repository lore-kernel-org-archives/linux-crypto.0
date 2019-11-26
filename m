Return-Path: <SRS0=6oT7=ZS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C33C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 07:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C88720748
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 07:44:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="qP52E2V3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfKZHoT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Nov 2019 02:44:19 -0500
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:37078
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbfKZHoT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Nov 2019 02:44:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2PiuZRigbmHaEXpYA/BxI9CkqGH38qHblajwEi3TsNIf6HCfvfSBOjh9FJV9thmHDwawJzlUmNGjzRwM/0X43ImiNwN4LAfMJoV1pDw/LNt53wU4M1IOE2ZFpRpdf3TO/eNdyakbRmf6fvOL5QEdmBj4bQSwG4oCc1i30EYP/gRVfriuJUI2ba+5oKJjNL7xhUzVH2fepciIpBLIdNtF9qsMZp3mlq5fECWrYqblBuADqjwgTH+Tn/SkRWoFv0V/cWroHCIHzZ7a95WGGGybzYBrKmqQpxN24F+yN+BdyjmtaineUQia3GhfO7nb94s0APWuZdgK9PfD81Q1rcFoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AznrVe91wsESl/9cuugSqejB9ELrkC3qsGlKaaOVd2s=;
 b=NrwrMhNgEYVrJVs3iSZCZuwE6RzxhjL2PNl2teq+vIPbEENA5YMqGv5EQ7JlT1dCRSTre+8h+yodkIuWAW4FqOh6WCnV1JbD9Gr9sMdvw7XWd4Mok/m5Tr6hbNfCIbHBsQVitBjojYnpgWyRA+yrqoBMMrH/Tmm+CqxfCEIIV22IanhGZNNEhcNrFuTnjH3jwj9ZxfTpxVGfj4FmJhDz4yBafYBrBTNclvjc0ADa5gi7wniCw/3vP0F70MLIivDqeWdA/0feqMMZkLIRHNH7TPeSYguUaLiAOTPGFsOi4ZS+ZNOq1RVaZU2wUDQzaKRDoYkzUKFrr1TzDFUn+2yuXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AznrVe91wsESl/9cuugSqejB9ELrkC3qsGlKaaOVd2s=;
 b=qP52E2V388dE2jJ86aA95KDE0OgsbLQIMdDRcwytpXCPQFQnmjHHJe6X5MNRTC8t6tFdl89YwGMwLhywszP7PJ/QQBPs6Ux0QBH0ekRgNLXGYE0nR15pCqAktu7L1qSIEL+fXbhlsNXRiBzM5uKMNgCBwoQhGP0Jy2oN0ShRxMI=
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com (52.133.50.141) by
 AM0PR0402MB3601.eurprd04.prod.outlook.com (52.133.49.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Tue, 26 Nov 2019 07:44:15 +0000
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::ac4f:f733:bc41:1e84]) by AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::ac4f:f733:bc41:1e84%7]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 07:44:15 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4 1/6] crypto: caam - RNG4 TRNG errata
Thread-Topic: [PATCH v4 1/6] crypto: caam - RNG4 TRNG errata
Thread-Index: AQHVoIQxRNGIQZ6nZ0+/zH6oZ3HYNQ==
Date:   Tue, 26 Nov 2019 07:44:15 +0000
Message-ID: <AM0PR0402MB3476636E6BF1CAE4B80435F198450@AM0PR0402MB3476.eurprd04.prod.outlook.com>
References: <20191121155554.1227-1-andrew.smirnov@gmail.com>
 <20191121155554.1227-2-andrew.smirnov@gmail.com>
 <VI1PR0402MB348579B485FC139EDA222B0C984A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAHQ1cqF_SW16_cvxpDmn6kYoLQDy7CBRfkftUs=u7gR8SQ=MTw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 17ebacb2-1c3a-4f41-dd1b-08d772446fc5
x-ms-traffictypediagnostic: AM0PR0402MB3601:|AM0PR0402MB3601:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0402MB3601A0C4BDD9BD55BE93676B98450@AM0PR0402MB3601.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(199004)(189003)(52536014)(86362001)(53546011)(6506007)(71200400001)(102836004)(26005)(6436002)(186003)(7696005)(76116006)(8936002)(54906003)(9686003)(25786009)(55016002)(110136005)(66446008)(2906002)(71190400001)(66476007)(66556008)(64756008)(66946007)(6116002)(3846002)(99286004)(446003)(5660300002)(66066001)(14454004)(44832011)(6246003)(33656002)(14444005)(256004)(74316002)(305945005)(7736002)(6636002)(316002)(81166006)(81156014)(229853002)(8676002)(478600001)(4326008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0402MB3601;H:AM0PR0402MB3476.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +G7ZmmRzjp0lsNiiuN3M5cjnbx71c0by6s5HUsHbzOUCaYgcOKLZaDBTO845CbdoxlYeWBIFwBfUrAnA961MVwVP4u5Du1id+3RtWUOfxXCzCZMnZuw6kWY6c/+aVJehJ+w+K0ZEnAk4vWKecNqLwCzTrpMNyT2JbdyScjxksWLR7A1obvD2ePfw+ZJ5EcXZ9XoPAgUn+4YEBzMP4ocQf4wWEBymbLC2XDVTaX1urKDS3pjiBWCjVCaejBSlxv4Av1+Hz3pxzqghva4Rzj1XnlqwrzTft9VrKxXsknCpVIUfNqUTcMraiHmHspx/EH/Yn/g7ZuWrTqhkNR58qFi2+jAJfojRjznvMXwSrImhPLIYsREWet4ku6qHSZzK/PivtTfbt0yvGbAtaTM8n0b/rAtUylWv8dx7jz0NDmfp9UVIk3HG0LYXzJwM273r3/15
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ebacb2-1c3a-4f41-dd1b-08d772446fc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 07:44:15.3945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XiPHinMicC/7JpS2jUCQebg/Un8pn4FvHy7rkeQvPKOfwL6J/tjDD9FP3oxB9LDhXhhX2X5xzRY1HuwGl9W9Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3601
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/25/2019 3:22 PM, Andrey Smirnov wrote:=0A=
> On Mon, Nov 25, 2019 at 12:02 AM Horia Geanta <horia.geanta@nxp.com> wrot=
e:=0A=
>>=0A=
>> On 11/21/2019 5:56 PM, Andrey Smirnov wrote:=0A=
>>> The TRNG as used in RNG4, used in CAAM has a documentation issue. The=
=0A=
>> I assume the "erratum" consists in RTMCTL[TRNG_ACC] bit=0A=
>> not being documented, correct?=0A=
>>=0A=
>> Is there an ID of the erratum?=0A=
>> Or at least do you know what parts / SoCs have incorrect documentation?=
=0A=
>>=0A=
>>> effect is that it is possible that the entropy used to instantiate the=
=0A=
>>> DRBG may be old entropy, rather than newly generated entropy. There is=
=0A=
>>> proper programming guidance, but it is not in the documentation.=0A=
>>>=0A=
>> Is the "programming guidance" public?=0A=
>>=0A=
> =0A=
> I don't know the answers to any of those questions. I am not the=0A=
> original author of this change, just ported if from NXP tree because=0A=
> it seemed important. More than happy to drop this if you think it's=0A=
> bogus.=0A=
> =0A=
The implementation is fine.=0A=
I am just trying to understand the commit message.=0A=
=0A=
Maybe Aymen, as author, could help.=0A=
Otherwise I suggest rewriting it, i.e. drop the mention of an erratum=0A=
and just say what's the problem in the RNG initialization code.=0A=
=0A=
Thanks,=0A=
Horia=0A=
