Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B85C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 882EF20874
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:15:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="PWMgHjMg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437485AbfFLNPv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 09:15:51 -0400
Received: from mail-eopbgr30085.outbound.protection.outlook.com ([40.107.3.85]:38241
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437484AbfFLNPv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 09:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXdIHPpuSjDheyPgihf3Q7vYaDMAM59wyvzLKc7MtHk=;
 b=PWMgHjMgAKCSU8dx/dSoYG/IYECgOllH386KQWzHOqqAcFAc60y4NZCZNo+B39m+NatK+e3Se/HFUu/SGSn8Cy/rnoZhurgjy/BNuClFt6ZQLQ9VdDtEJx0F+W+TOPKouFNDEqIDpM8U9CSMjfza7zvRRFv4GRFJNX/CptHZ9VQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2877.eurprd04.prod.outlook.com (10.175.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 12 Jun 2019 13:15:46 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1987.012; Wed, 12 Jun 2019
 13:15:46 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: imx7ulp: add crypto support
Thread-Topic: [PATCH] ARM: dts: imx7ulp: add crypto support
Thread-Index: AQHVHD5HxT1VnrKm20mxf/1ryD4CPA==
Date:   Wed, 12 Jun 2019 13:15:46 +0000
Message-ID: <VI1PR0402MB348596BF52CE43B5D4CD534798EC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190606080255.25504-1-horia.geanta@nxp.com>
 <20190612103926.GE11086@dragon>
 <VI1PR0402MB3485A573518D60A573BA55C298EC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190612130602.GH11086@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ef5e611-3773-4889-3fa7-08d6ef3814ac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB2877;
x-ms-traffictypediagnostic: VI1PR0402MB2877:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB2877041CF702412A516A242298EC0@VI1PR0402MB2877.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(346002)(39860400002)(396003)(376002)(189003)(199004)(99286004)(6436002)(305945005)(76176011)(446003)(316002)(7416002)(74316002)(7696005)(6116002)(73956011)(76116006)(66946007)(4326008)(229853002)(64756008)(66476007)(66556008)(66446008)(14444005)(2906002)(6916009)(6246003)(66066001)(256004)(3846002)(71200400001)(71190400001)(8936002)(25786009)(8676002)(53546011)(6506007)(81166006)(81156014)(966005)(68736007)(52536014)(33656002)(102836004)(478600001)(5660300002)(44832011)(54906003)(14454004)(86362001)(9686003)(6306002)(186003)(476003)(26005)(7736002)(55016002)(53936002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2877;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: G8XmBXCZJGn40PLT3TZJCE4KySzicfIQZv03UcS7DZbS8tYhWE8SWc/GN03xHePvSIUUz2q5aZLqWSsMGrCemtLCPYxok0GrBf5KgRLuULv2lTweYVvONuUskvr29W3WFEWhTXzGpdduzVelnfX9MtoxDuH7Lu12GPXK+NVy2twzWk8ZbkYs5XHoHGBz7bpV3i7GFsJ8W6fumlSe/0/EMTApNVaTSO/jeg2qzYo2GmftuvSmoPfxOexw5npNQILPoVn7v5awn8Ozytyt0huVD05mQBFy+xSsLJUMUjUJXBMwggFWNyhyKJH2nbj5Dgk1qc93hw73eYd05GJGR4QyjPU4i0fjogtfc8cv/udh4Pf9b3CaOWhbhJCIxN6xMYlUpcaij35RzJD5KVHqPL46mGFzmRRVPXN4p9cHLn62vHM=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef5e611-3773-4889-3fa7-08d6ef3814ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 13:15:46.2354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2877
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/12/2019 4:06 PM, Shawn Guo wrote:=0A=
> On Wed, Jun 12, 2019 at 11:45:18AM +0000, Horia Geanta wrote:=0A=
>> On 6/12/2019 1:40 PM, Shawn Guo wrote:=0A=
>>> On Thu, Jun 06, 2019 at 11:02:55AM +0300, Horia Geant=E3 wrote:=0A=
>>>> From: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>>>>=0A=
>>>> Add crypto node in device tree for CAAM support.=0A=
>>>>=0A=
>>>> Noteworthy is that on 7ulp the interrupt line is shared=0A=
>>>> between the two job rings.=0A=
>>>>=0A=
>>>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>>>> Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>=0A=
>>>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>>>> ---=0A=
>>>>=0A=
>>>> I've just realized that this patch should be merged through the crypto=
 tree,=0A=
>>>> else bisectability could be affected due to cryptodev-2.6=0A=
>>>> commit 385cfc84a5a8 ("crypto: caam - disable some clock checks for iMX=
7ULP")=0A=
>>>> ( https://patchwork.kernel.org/patch/10970017/ )=0A=
>>>> which should come first.=0A=
>>>=0A=
>>> I'm not sure I follow it.  This is a new device added to imx7ulp DT.=0A=
>>> It's never worked before on imx7ulp.  How would it affect git bisect?=
=0A=
>>>=0A=
>> Driver corresponding to this device (drivers/crypto/caam) has to be upda=
ted=0A=
>> before adding the node in DT.=0A=
>> Is there any guarantee wrt. merge order of the crypto and DT trees?=0A=
> =0A=
> Do not merge DT changes until driver part hits mainline.=0A=
> =0A=
That would mean driver changes would be merged in v5.3 and DT node in v5.4.=
=0A=
=0A=
Would going through the crypto tree with this patch be such a big issue?=0A=
I don't think it's the first time (relatively small) DT patches=0A=
are merged via other trees.=0A=
=0A=
Thanks,=0A=
Horia=0A=
