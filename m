Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1163CC3F68F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 08:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAABD24687
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 08:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="QI6Xspj4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbfLTIHj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 03:07:39 -0500
Received: from mail-eopbgr140087.outbound.protection.outlook.com ([40.107.14.87]:32686
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725965AbfLTIHi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 03:07:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3z7sxgjcgOeSsRD7IPKuNtcHur/ZedOBQWSkP6qp5w/hvbSnUhbukEUp1+1iC1FPnhEQGofHExZDFMl0M4u4GQJyGnpzBd3yODdn9v9c1jXdhhBqbPKg6n6laTLzY361N/AkuW53ncyI0ukBMpBie3xzONG/XqShUfFscgeMb1pYyHlbFaPVl5N3CbMhG3HSckxyk8p+KzLY5lXb9/lAqrjET1149SUArDOLaS4tH8aZ44xUbrRX1jXQ+8bnKAvBIuIEidre+ZFLG3FfKvpp2siD0cFD1vybnBjJ+lCBRamUu4hl5kAmHZN4T7JZnazbcuPmvTJoLyrBbtIsxV0Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wRRDOOXWawmFvFi5W+shZcITERvWyl2faS1S9gvxH8=;
 b=jfxHc9ai43bcbutdD6k4hoqhZ3gTPdPG5AAQXxtGjJYMKnK1rxpHsB/TzPR7/XCLvAbsHtypalWIVlXrMM9HzGXQbcRym6hJLmoNcStihKhb3uxYX7qLhAmqn61dLqp1oU9QOGLRY9Y8qQwTHEJIjeIzOsF0kMC3mO9okhR2YFhIqiO0VDjgSjmmMDnzbJ8v6d+S9lqG974biUdmbqXAKJ2SqZgJCwSXloua/BNzHhxrvKH2fMIXrJZX6gQ2aDIZuewVVYmS920WoPgULltl2GLheJPTIRYEkBnokZbkkyPueubNs7G6oh7oQZEddqOeCB4b6HPwdxBPFBnUJX8hzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wRRDOOXWawmFvFi5W+shZcITERvWyl2faS1S9gvxH8=;
 b=QI6Xspj4FVLLPGm4Q41Y50nUtvpFpz1u4Yp0GC0VM9v0RZEw82uZBD6Ax6L5xdErqVTcT4IhLtYLRVJiFJegZNNA5sPQ3B0gn3NPNo28Q35KpAK3ZJKF9wNclc0vmomG30M42OlL1tb62yjgr5U+kMLv3BhGcLmybnzR2zUInY0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2832.eurprd04.prod.outlook.com (10.175.22.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Fri, 20 Dec 2019 08:07:34 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4%6]) with mapi id 15.20.2559.016; Fri, 20 Dec 2019
 08:07:34 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>, Adam Ford <aford173@gmail.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2 3/3] arm64: defconfig: Enable CRYPTO_DEV_FSL_CAAM
Thread-Topic: [PATCH V2 3/3] arm64: defconfig: Enable CRYPTO_DEV_FSL_CAAM
Thread-Index: AQHVscuAzDa0y7DjIUSGaSZVWPlDjw==
Date:   Fri, 20 Dec 2019 08:07:34 +0000
Message-ID: <VI1PR0402MB348519E941CC80DA8D2E15EF982D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191213153910.11235-1-aford173@gmail.com>
 <20191213153910.11235-3-aford173@gmail.com>
 <VI1PR0402MB3485AB1908AD6B6617CFC08C98500@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAHCN7xLrX0R7Uag2vc1qMp4z=1r3haCWrcp4qJT0H0eC3RiA4Q@mail.gmail.com>
 <CAOMZO5B_CCEf_cdAWs_FDC1c6t0RG1KjRjGidoDPmPmgxY=ebg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a2594434-e66a-43f3-9106-08d78523aba2
x-ms-traffictypediagnostic: VI1PR0402MB2832:|VI1PR0402MB2832:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2832AB038DF844CFB988C596982D0@VI1PR0402MB2832.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(189003)(199004)(4326008)(44832011)(66446008)(66476007)(64756008)(66556008)(7416002)(91956017)(478600001)(66946007)(81166006)(81156014)(8676002)(8936002)(86362001)(9686003)(53546011)(33656002)(55016002)(52536014)(54906003)(316002)(110136005)(2906002)(76116006)(7696005)(71200400001)(5660300002)(6506007)(186003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2832;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WfQ8ToIh0zYfUfEFnVhGnI5P/QihfhSMtw/GlHuKXZhRQLaxmIMSTH5i+E8WPletVoyEtW19UoyN7XB8sv/pzgi+kiZ33sat1lGMFZCK79woIVu5Fs3UVj296y6tU2ot0vCb7QlEQ1CSsGfeQQVMCj7tnxPLZNWytFRhrmb66ZHfUMjYUvIIKVp+58XlaVHjulhawX8sO3FNxSGdraLB5inJ+i43TQH/K/bbVuGGM8XcpVzifV29jpMfMumBCqTGkTf5TfJM5moLgyNmoyCmw6tKRqWxIe4djcXdVIVn8/PNKM0EYCFfCWNl6vbbjP05iTqr8qQu+ufvwL9MWDPr/LKWmx3swholi2vyxPXsFVfblRBnCT8tc8qhC9BklNENTi0eCuy8Zs4WvGl1mtDss2edHn5gwODznChlET1zxKLA9mcm1JDiVOHop43/XgOl
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2594434-e66a-43f3-9106-08d78523aba2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 08:07:34.4904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: peDjrjfV/quQQ8bOvYdtcIcFqri+oy+W6VDaUegtGT4V6ZPj8vLmoPJCjYMlYKu20VRHurTssIx8H3kT9ugJhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2832
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/17/2019 8:25 PM, Fabio Estevam wrote:=0A=
> Hi Adam,=0A=
> =0A=
> On Tue, Dec 17, 2019 at 10:07 AM Adam Ford <aford173@gmail.com> wrote:=0A=
> =0A=
>> Out of curiosity, what is the rule for when things are 'm' vs 'y'?=0A=
>>=0A=
>> In the Code Aurora repo, it is set to 'y' and the mainline kernel for=0A=
>> the i.MX6/7, the imx_v6_v7_defconfig is also set to 'y' which is why I=
=0A=
>> used 'y' here.=0A=
>>=0A=
>> I can do a V3 to address the other items you noted, but I want to=0A=
>> understand the rules about the defconfig so I don't make the same=0A=
>> mistake again.=0A=
> =0A=
> In arch/arm64/configs/defconfig we try to select modules whenever possibl=
e.=0A=
> =0A=
> The exceptions are drivers that are vital for boot such as PMIC,=0A=
> pinctrl, clks, etc.=0A=
> =0A=
> The CAAM driver does not fall into this category, so selecting it as=0A=
> module is preferred here.=0A=
> =0A=
One comment here though.=0A=
=0A=
CAAM's RNG is not "vital" for booting, but IIUC it would decrease the boot =
time=0A=
since it feeds the entropy pool through the hwrng interface.=0A=
=0A=
Once RNG driver is fixed, would it be acceptable to add:=0A=
CONFIG_HW_RANDOM=3Dy=0A=
CONFIG_CRYPTO_DEV_FSL_CAAM=3Dy=0A=
in arm64 defconfig?=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
