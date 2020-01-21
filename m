Return-Path: <SRS0=kzJ7=3K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F71C33CAA
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 10:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48DD420882
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 10:08:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="A+YazgyR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAUKI5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jan 2020 05:08:57 -0500
Received: from mail-vi1eur05on2050.outbound.protection.outlook.com ([40.107.21.50]:17006
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728512AbgAUKI5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jan 2020 05:08:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJJKCVdPg4IXv8PQnCbnptqP+ah3xtx/4FLjG5xj9XwQGZSy3BYjtFwhieupzXFvp9dJH4XoWxxBQhkm7DvFnhjuCZwHK+B/3KPT3Pm0XgVC0NTrERw4le1Q1/BPbrrrPFnFoNVSPY3n7Ty8BF5BCbDNOuBYlDwbS9vQJKd95e9vonD1bl801nFnIHmxYFxYtOx8Wq8Bgr+kl23RS9ETo5fHa6v6P1Yt1/eC1eAaWwGr/U92Zv3xE74qSa3M8uT++xhtsbnK2YNl0snarlpimJy+Jd8cacQI2JlypvF0Zwvb+dT5f4TDleiKPLVXk/9VrYx++p0bWdkez88/SiJliw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vw4JK3ECOBOqOQS6fl1HZ3Z+jP0Bujttb3n8t1cuqN8=;
 b=fXdMdAg51TZgem4bBY2yxCEPKWTLH84mpysNoDNaX3HCspPW/8bmrM0jhMni6grWtV9koWE7zCxmONv8Kwo+f83z1CJj7bMbejQdSJELyJQHNGD1nfi7wf8HEwa3znOokT/GogLBNSNM7f7B1oSzaQpVPzFsA68LW61rZzhIcF+RX6sESpSAE8AmuUoHvEodyaywfh47E6nGs9RgPXmKYdkSwNEZwsVCXvqzaQ3/iGTlPl9Fqin5gM74/D9UVQ1rnbxb6i3elwpxmyH9j8Y0ivCEXsNlOIx4DrFPrTZhrNMvSeDNb+LTe3GE/6ZBlUfK9FIoMUeZubvE2Z3huD26Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vw4JK3ECOBOqOQS6fl1HZ3Z+jP0Bujttb3n8t1cuqN8=;
 b=A+YazgyRgfZTybvUC0tHfEK9QWuLUWbwc2KL1RveUp2yy9CcVMZiktXia4VkFP5BNVItkUZAiuw1ovIPDdINB4VFoNGPwSEor4UGtFqcWXziPz3gYr7X//OQosx4dLPeS0Xtkzze2HLUF7TFVaAWbIrOmic/vuQqtwEunEIAX7I=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4606.eurprd04.prod.outlook.com (20.177.56.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Tue, 21 Jan 2020 10:08:53 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 10:08:53 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <mripard@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [RFC PATCH] Crypto-engine support for parallel requests
Thread-Topic: [RFC PATCH] Crypto-engine support for parallel requests
Thread-Index: AQHVz+nyH19jpegvq0OzoQlSx1aIPw==
Date:   Tue, 21 Jan 2020 10:08:53 +0000
Message-ID: <VI1PR04MB444594375C6CAAEE125C65C48C0D0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1579563149-3678-1-git-send-email-iuliana.prodan@nxp.com>
 <20200121091102.magzogr7tnj6joqm@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7df4c1a5-3303-4ee7-8fbe-08d79e59eb79
x-ms-traffictypediagnostic: VI1PR04MB4606:|VI1PR04MB4606:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB46060C9506572EB60C6600638C0D0@VI1PR04MB4606.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(189003)(199004)(7696005)(55016002)(4326008)(76116006)(2906002)(316002)(86362001)(66556008)(64756008)(91956017)(44832011)(66946007)(7416002)(66476007)(66446008)(478600001)(54906003)(186003)(6916009)(5660300002)(53546011)(52536014)(6506007)(33656002)(8676002)(9686003)(71200400001)(81166006)(26005)(81156014)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4606;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7K6NTZ0hbCFfnll2mBADtGoPLAjGnCHtkrFrVAMxtxQpLx41xZhUJqYSQnsPCvW5thrHAqWqqCMZfYFtxPJTfqZdSV0qnqI+qyy+G2WePfWavYUGVEsH0WuONpnQnO5McmdeVrBpDRwjGgeBBIzVtpXYSGlG3tFgpR6KZp7+h94bweWL+Z4Cx0v2+eqHeQVHndpvyO4r6ocpz5n6ezLCpbsHATfev766RoUzzKIP5PgxpfaEm6mhRn0Tg6T+niutXzBm6Y/iPzFqDnG+v2ZOWDEMY1aMcNMs4fFMiRLSLfUMgDTXfMRFxbB6IgQaf/MECLYkB4ghCQi1PnLhSPrXu4ZzGQ2+pr04GNJ0RaqH9V0fJKBNVIrZ7l7mlaE94Bzrt3Jn9t5pvVtdZWoRXtNK25XWp7q58E8CXfcKhm3zTxudHoipeV7U5NZmOmYvYLSo
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df4c1a5-3303-4ee7-8fbe-08d79e59eb79
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 10:08:53.4742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S5s5BcNcYQPNBhEyz0ReyGTPvBwFHoZZpz7S2St04TLLknBggMzrL1RQSw8jsNIsOF6jGmLCfRi5UHvY2Pq/9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4606
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/21/2020 11:11 AM, Herbert Xu wrote:=0A=
> On Tue, Jan 21, 2020 at 01:32:29AM +0200, Iuliana Prodan wrote:=0A=
>>=0A=
>> +	if (engine->no_reqs < engine->max_no_reqs)=0A=
>> +		goto retry;=0A=
> =0A=
> We should not hard-code this number into the engine.  Instead,=0A=
> we should just let the driver tell us when it is ready to accept=0A=
> more requests.=0A=
> =0A=
This is not hardcoded in crypto-engine.=0A=
I've added the crypto_engine_alloc_init_and_set function to configure =0A=
how crypto-engine works.=0A=
The max_no_req means how many request the driver can process in parallel.=
=0A=
If this doesn't apply on some drivers they can call =0A=
crypto_engine_alloc_init, which has max_no_req =3D 1 - this is the current =
=0A=
behavior. That is serialization of requests by crypto-engine which is a =0A=
bottleneck.=0A=
=0A=
> Perhaps we should add a new function for drivers that wish to=0A=
> support this that would accept a list of requests instead of=0A=
> a single one.  It would then process as many requests as it=0A=
> can from that list and only return either when the list is=0A=
> exhausted or when it can't process any more requests.=0A=
> =0A=
=0A=
Linking requests is something different that is not addressed by my =0A=
proposal.=0A=
I want to remove this serialization, done by crypto-engine, of unrelated =
=0A=
requests.=0A=
