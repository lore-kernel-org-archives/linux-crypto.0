Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82750C2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 14:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C911214AF
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 14:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="YxDU0BNb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgAWOsC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 09:48:02 -0500
Received: from mail-eopbgr00064.outbound.protection.outlook.com ([40.107.0.64]:33679
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728921AbgAWOsC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 09:48:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2+/7dWPaA58oJxU6wnwmkwrNBguTGWji9eORLCOdeZYYJekaPHOxenNinhUur9L2QHWt+2a0WcihqtU9noVg1/4opyDJ+4DG0WprN3mssgSPlMDNby94U9yX0NRGv0/ZHWvuogv1DqbhIMvMjZFQ9i8isvJLqxul/dRi6gPRSyYyssWAdr7F28VisXBcwX6Htk6O2jWFlWn2LHiOFKV8xcfoAqTgaQYF9k/di8MAPmJN4jey2ACMcYFWTMMCitNl7ZBD0olNDlPtIox+s3Vg5soba1JJ91PjrNX7gHfqZPwqghECOgjZafkJ8pwraUC0fz0A41STuHOPbZCUdPp4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJuDDdkOR6J7Zi7B5yj9y6OQP/qoFMNiWYh4gszCEH0=;
 b=iwXpEtQvKmjgreFt2bRbCps4xjWvYPzmGbvhGDbsz0WtsSayxfCf/CMA2mr5g/nEfI6j9rwDmGcy4NQbF/+qJAqN8QbKelKtnse92zAC9JhWCbhUE/C1+Grgv4Te+jpXjp/JAIv9sG32W6mKFaTa4oSt9eHEWhjsdMDb0+Gd8kuTFVNw96JqauNokt0tpWSHbgSCVRaux6Dsbbm0w2wxWEpERsCpi+BdOJZyU/EtFILHmgTMfJ5BBqabyOS4VkPxOGYCaefmhAklY5aG+172/GIIPqB0L9VKnEev+mCsdXl/DKaSzi3ycg/U9Dn7PFCTBS5gc5dlw5/BgfZ/Hsf5aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJuDDdkOR6J7Zi7B5yj9y6OQP/qoFMNiWYh4gszCEH0=;
 b=YxDU0BNbnXeHhtFpsqyNhAxCeTTuo26MMqn9DCoAz+EuvZas4mr2KfEVCBwQ/EKimlMaz3hBPLrQHnvXAHALZzIhyvimvGvmF4HUqr60btXIdhWpQSmYYeKxcr4T8lwbfEtCwSQZUU2fts2jwqAphBebg+1Nh1O0/YbQC/tXSiA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3821.eurprd04.prod.outlook.com (52.134.13.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 14:47:58 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 14:47:58 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Arun Pathak <arun.pathak@nxp.com>
Subject: Re: [PATCH] add support for TLS1.2 algorithms offload
Thread-Topic: [PATCH] add support for TLS1.2 algorithms offload
Thread-Index: AQHV0d9fpUp9vdyUr0ua541zV8eJNw==
Date:   Thu, 23 Jan 2020 14:47:58 +0000
Message-ID: <VI1PR0402MB34855705F10BB498911FEF78980F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200123110413.23064-1-pankaj.gupta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f9d68ff8-6262-4603-32ff-08d7a0133ce5
x-ms-traffictypediagnostic: VI1PR0402MB3821:|VI1PR0402MB3821:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB382140965DBCC77B37E96241980F0@VI1PR0402MB3821.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(199004)(189003)(7696005)(4326008)(66946007)(66446008)(66476007)(64756008)(9686003)(478600001)(55016002)(91956017)(8936002)(76116006)(86362001)(33656002)(66556008)(966005)(5660300002)(44832011)(4744005)(186003)(53546011)(26005)(110136005)(52536014)(71200400001)(2906002)(316002)(81156014)(6506007)(81166006)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3821;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pzjCd6GNSeaFxXrWCFoobLaK2c80vD/5RPjTHidAqZkwgdFiPTZ5K0sQhGnBGjCywLo+KSK6+h3vy3L+YiBtWxXilzhvtdfSKJY9khAm8u0C4OIacmI4qYDoV44lIfQvY7bNh2qS5O3wgyyqPKU45VFqE9eelkOKe/kBz7wgxeo/XIyWW3K1nHHUHQm0OqCPDb5kpQs67PMhtDQSjTyU/ofImA0iz42UZWFgQeeibdh5iXD+JgJB6iNxI9LhZLNRIZrew9a3k40T+H17PL2TpM/p0Ii1tARDvYxg61BPCiplyb61Xao0KqHhrJJJR9/G66IxB3d60oA4u9gVVNeUKRQzzHItOKN79ogQRS552bBKES3KxWY0/2n6nvdTQKWl6V4yyutzzyf9BMQ2cRBFWIyjlpNdsYdc45kIvdsGafwTEWAGFY95k29KftTg6WZlLhEUQuxDORFKN2QSyucJbZP9kPowYNBmyzVvNLVp7I0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d68ff8-6262-4603-32ff-08d7a0133ce5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 14:47:58.0944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QLJRwQa2K74ZUfO8ioUncGeH6N8pgUVwoR4lWcbMXt5G+UgHRFEYE7i86muPTU7xOuFPRl0+xpoS6BN62KnstQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3821
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/23/2020 1:22 PM, Pankaj Gupta wrote:=0A=
>         - aes-128-cbc-hmac-sha256=0A=
>         - aes-256-cbc-hmac-sha256=0A=
> =0A=
> Enabled the support of TLS1.1 algorithms offload=0A=
> =0A=
>         - aes-128-cbc-hmac-sha1=0A=
>         - aes-256-cbc-hmac-sha1=0A=
> =0A=
Patch does not apply, since there's no specific tls support=0A=
in upstream caam drivers.=0A=
=0A=
caam drivers register crypto algorithms to the crypto API,=0A=
and ktls uses whatever it pleases:=0A=
https://www.kernel.org/doc/html/latest/networking/tls-offload.html=0A=
https://www.kernel.org/doc/html/latest/networking/tls.html=0A=
=0A=
Horia=0A=
