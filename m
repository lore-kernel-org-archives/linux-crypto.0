Return-Path: <SRS0=21Gj=5M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5C3C43331
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 10:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53EF92073B
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 10:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="RqQskwD/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgC0KoG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Mar 2020 06:44:06 -0400
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:11429
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726215AbgC0KoG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Mar 2020 06:44:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkqTObYEhAhAxLMT7AE7AWPT2ilstylLWrzzPtLCIankjd1Zoh493b0W9YL5jTfqTeYJRzejjgt///5dJzcLGYOcqrDfBl5FfAagC84UTtQT/tLx6juZSzbaIAxie4pj3KkuvCMpAEUAAQ4Iasmxp4XQfqcIL6F+PLeR6rzXQ66ogEUOORc9A5mBExVr6QFpU1mZlVsqiWQmidWShNHN1B2jq1971aB6JkyMF9nINLDrB1jTq6L+wqVjmH87o5F0oRYfsKxJq/XrJQvSTfGpbH8LO5AXhE+dU2xlR/7XYY1bXJ25DE8g+4J2ySzmU94HMfBGCSr5lJt6Ll3G5zhgEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mT4wf7BleKVliBmFMMu8r6p+GJ3fTxeMgjUCqejqCw=;
 b=D8yR54R1c6rpnbeKPvlKpDloKdQZ/8PX94OJjxF2A+fanxoN56YJDq2fe12S5+pgQXPdg/HNUvXZyWqXM+ATNNTUiXkDtqqF/eaknqPEdYoIRKCN/6WFSLXgaLLf+Qb4eI18PbXakTTn/gehKXEEQFabOGNCPo5hx1GwDZromz/Ecif+JuF75ZpOfje3sO/25ynRblbo0npYzrZuGA6MXMW8k2pP3fZSLLyoCcI6r7zdWrpHzSg4zr9Rpm7QPfkEyegOKFm2FQpZdGz+QUiK0XAnrSWBGgcCULGgZgskfFQYJcFz/Ftxh44GP98vqYcBIIcc0V0Q2h/Wez/sGl5/Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mT4wf7BleKVliBmFMMu8r6p+GJ3fTxeMgjUCqejqCw=;
 b=RqQskwD/trCNv71T9xOJkgl51jGgO0cniOdiDTYpSVEiTJQWtCeOEB0O2DFCFow3Di4M3v01acfMNdaqiAUFO3rTwEY5+/4yAnarXleFByHa8c3BWmVZPyjcWTn5xVRkJxn+nqDVg6qKzBP0FErw/v2hVouiqsNQmO0Ar5XJV/o=
Received: from AM6PR0402MB3701.eurprd04.prod.outlook.com (52.133.29.16) by
 AM6PR0402MB3336.eurprd04.prod.outlook.com (52.133.25.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Fri, 27 Mar 2020 10:44:02 +0000
Received: from AM6PR0402MB3701.eurprd04.prod.outlook.com
 ([fe80::d8e6:42db:b8be:1e1c]) by AM6PR0402MB3701.eurprd04.prod.outlook.com
 ([fe80::d8e6:42db:b8be:1e1c%3]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 10:44:02 +0000
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
Subject: Re: [PATCH v4 1/2] crypto: engine - support for parallel requests
Thread-Topic: [PATCH v4 1/2] crypto: engine - support for parallel requests
Thread-Index: AQHV9ZwplCPBsoqUKkWl+/E0XiXZQA==
Date:   Fri, 27 Mar 2020 10:44:02 +0000
Message-ID: <AM6PR0402MB370147736BEAD099AAF061558CCC0@AM6PR0402MB3701.eurprd04.prod.outlook.com>
References: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
 <1583707893-23699-2-git-send-email-iuliana.prodan@nxp.com>
 <20200312032553.GB19920@gondor.apana.org.au>
 <AM0PR04MB71710B3535153286D9F31F8B8CFD0@AM0PR04MB7171.eurprd04.prod.outlook.com>
 <20200317032924.GB18743@gondor.apana.org.au>
 <VI1PR0402MB3712DC09FC02FBE215006C5B8CF60@VI1PR0402MB3712.eurprd04.prod.outlook.com>
 <20200327044404.GA12318@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d1d40d99-3204-4dbe-6f83-08d7d23bc3f1
x-ms-traffictypediagnostic: AM6PR0402MB3336:|AM6PR0402MB3336:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB333692B9A7808CE2B078F3A18CCC0@AM6PR0402MB3336.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3701.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(66946007)(91956017)(52536014)(26005)(53546011)(186003)(76116006)(478600001)(316002)(81166006)(71200400001)(33656002)(6916009)(8936002)(7416002)(6506007)(7696005)(81156014)(8676002)(66556008)(66476007)(5660300002)(2906002)(44832011)(64756008)(54906003)(9686003)(55016002)(4326008)(66446008)(86362001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6HKlWhWIp5DENAP9ScsiceKv5uK+r1saI2luPBFmo0pARiaC2sxcDWr1rtH6eVoxeZZGgn5i5TpG+L/PVe6IXFXly5VNrgeVXknH4fshKSqlP5+vnwtgW1/T/WpEP7AtR7CfBxSPSQ5rkX5G0ORKnoYy2vqoXM7KGEJzyYJJlJtFLkbgPe+SZjydrw/5eaVVdNAbW85peJG/zWXO2kEd4KutEkvOLY7BHUnfcMkpySqxyYE/Bp5sxMIt8ojgkWhRSV8l7OB3ui7R5b20HG3gbaR1EM5eG9TXk6JinS0FfEQn/0P+TqMgc+QMVVNt2b1MGScKy3M/YnNCGHIGCS1qkGP9eoaLGihm9Fehu5cHBnYK50eac+Hvl0GmKxqZUnaQySb9I+gwS4mnqgDAJfEHz33G9Y/dY0M1F0Hj9xNoRVX1VCFeJYWDhvNubt/2j6g9
x-ms-exchange-antispam-messagedata: HW3yJ29/MO2jP3D5a+u9Vyr5tYekYZuCnyXtPSGKoQLktCvfGx9T/pAYUCflZsukLe2IEw9jHzaQCZmrUI6lOBd2tlXXGFzWTtgVdCdhOYgd7qVZ/kulLu4F6Z1EEuXgLaIjCf6EXSM2R/pkGB2x1A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1d40d99-3204-4dbe-6f83-08d7d23bc3f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 10:44:02.6798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cMuaKsB8MxraxVqV62ICQVCN+cFflqoM3vn40nuC0MsfSoAHPIW03cE8dA9g+qhPzmKW4++7CcE3B/MvVHmfbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3336
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/27/2020 6:44 AM, Herbert Xu wrote:=0A=
> On Tue, Mar 17, 2020 at 01:08:18PM +0000, Iuliana Prodan wrote:=0A=
>>=0A=
>> This case can happen right now, also. I can't guarantee that all drivers=
=0A=
>> send all requests via crypto-engine.=0A=
> =0A=
> I think this is something that we should address.  =0A=
=0A=
=0A=
I agree we should not have failed requests, _with_ MAY_BACKLOG, that =0A=
pass through crypto-engine. All these requests must me executed. For =0A=
this case I have a solution and I'll work on it.=0A=
=0A=
> If a driver=0A=
> is going to use crypto_engine then really all requests should go=0A=
> through that.  IOW, we should have a one-to-one relationship between=0A=
> engines and hardware.=0A=
> =0A=
This cannot happen right now.=0A=
For non-crypto API requests (like split key or rng) I cannot pass them =0A=
through crypto-engine which only supports aead, skcipher, hash and =0A=
akcipher requests.=0A=
=0A=
So, I believe that if the first problem is solved (to have all crypto =0A=
API requests, that have backlog flag executed - retry mechanism instead =0A=
of reporting failure) the non-crypto API request doesn't have to be pass =
=0A=
through crypto-engine - these can be handled by driver.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
=0A=
