Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E8EC55191
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0AB02075A
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:35:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="d62+MBKQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgDXOfC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:35:02 -0400
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:14336
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727123AbgDXOfA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 10:35:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNYONhvfq+/yhEd4q1kkywIldPEMxQtBgK/tJH6knaUg7VEiVTsRXo4HqiTbTpFD8eig1SVd4+j14G6ayKusp08WVesVG6XWy7CszYr7289Ee/MBSX9Kn3kqxaxi+n9Br82hQ+cUJWwGzxuX+G3E+MNuli/RLhZ23r2pgcnTNz4b+q6a2/yKMK2P9bHH/6H83OnKwUVmqSgwG7GYKxpAWwgFTYmPoUUBIgZUdVsk2ADh8XI2JmoWkiskIrqGfqVXR2TJ/cjjkshW7nH+zcK+JBnENZDhSCX5Z2whuCKOF+3RrIqKb6foVtk1naL5t3jQq4rgbf3mnAeXwHQV1l7LWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKHp6yD/yG6XY+x6f2fDDlHCKv3M0iULGlnuN6GjnAI=;
 b=YaTz3elnrSSCxw8EnbiDc9/WhGjBQ/4zfn5b6cOk3fdY+ODz5VNhXuFjgbtkuwf3YK9l64Vk+3vPMv7A+1n4dqslxvbBTTrRzcqn7N/Dcx0CuZJVbnGqJWX3dm+Fc2cnSKOhLI62jzWEU/Bx0MaR5rKpcAONHcoYe1G9ieZ82TmJyUm4PhsTqLoQkTuGQ0tHgDordb2mcdvsBwmwsh1RQVZclyTr9vviK87sau50z7iUHluRy2IcOkGeW5oERoluDJ4e+LsTOG2Uc5yCboOMa0Drk8b2OHiX/tEmO+Xov/PSJENhW+poGbLFA/bsUMF5cqvJl7jUZZlKmVotoFH7ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKHp6yD/yG6XY+x6f2fDDlHCKv3M0iULGlnuN6GjnAI=;
 b=d62+MBKQ7vBCi87sCPAO2BlGuDKu1P4RC992HNp6jjwQZVPeBEDX7QkfpiTzsU3IQFNh5F3QUUT4iCRL1bhVKy5rE4y57xFIepu5MSVkwlEbNav8Pu5g3eaQjtiMyL9GAIzjmgVouzr7+z6LKvqJPPAHJ5Km38eQWH0IxpNR0dg=
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR0402MB2893.eurprd04.prod.outlook.com
 (2603:10a6:800:ba::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 14:34:57 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::c465:f38f:6be3:5d97]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::c465:f38f:6be3:5d97%7]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 14:34:57 +0000
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
Subject: Re: [PATCH v5 2/3] crypto: engine - support for parallel requests
 based on retry mechanism
Thread-Topic: [PATCH v5 2/3] crypto: engine - support for parallel requests
 based on retry mechanism
Thread-Index: AQHWE2Qot8PxFDaTpUuNLpWYBZnAxA==
Date:   Fri, 24 Apr 2020 14:34:57 +0000
Message-ID: <VI1PR0402MB3712298355411E273294E5F38CD00@VI1PR0402MB3712.eurprd04.prod.outlook.com>
References: <1586982375-18710-1-git-send-email-iuliana.prodan@nxp.com>
 <1586982375-18710-3-git-send-email-iuliana.prodan@nxp.com>
 <20200423114640.GA14399@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [86.121.160.118]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1ea1808f-10d0-4042-215d-08d7e85ca998
x-ms-traffictypediagnostic: VI1PR0402MB2893:|VI1PR0402MB2893:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB28938393DD77B4EA08B18D648CD00@VI1PR0402MB2893.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(8676002)(2906002)(8936002)(186003)(55016002)(9686003)(66446008)(6506007)(6916009)(66556008)(66476007)(7416002)(91956017)(478600001)(76116006)(64756008)(26005)(81156014)(53546011)(66946007)(5660300002)(44832011)(86362001)(33656002)(7696005)(54906003)(71200400001)(52536014)(4326008)(316002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ery8rdRWfvn7rMZHpG4hlFNn4l4b/sumGjU8GJU/5xMddVg64FW9X1RZolfcRp9riZMX4ZawvwhgzYq+AHs9G/4jy4yKnnqGa586c92Zp67ftCENvGLgkUSKTnAOCh4t2mPdRr016lzJXyvCqU7/FcBnZ831Dbx2t9JufyRiCgCuLm0QeWvBnQTLAV7ZaCBiLpEcWUE1XSbb1Zq/8p3DvhacCr8ctQk6WrRKIW43cWOL8G0Wiy0UC4o31unLF/nLngApfbnT869k0BUTJ+iji0B/7h33DF/XnvUVXGCFtqlWHDpRR1p8rb03+9PMxaAATuXRKqg0a4b9Zc2nQ/1vhEQmvCNW/HGRzxto5sUOkFmyolKWIzth8L6iyJUEp6YVV9MUxaDGBO4tZtHWiEQd8vnIO1GaJZhqGyk9rYSUq2RJe1XD/ZotAoXDbYVfF5sr
x-ms-exchange-antispam-messagedata: gt2Ngd6aQlu3Gf83v6J9RB68UWXUXHOhZqo9leM5Q/jrHoo6hxy80KK9iyDR2OQzb0ba99m5K+424CmuOEbfdEwyuMXamI85N52AlcUYIffAf8WQ6HZ6uquLSCph2ohoW9NZ6f1MsJ319MH/8hru/Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea1808f-10d0-4042-215d-08d7e85ca998
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 14:34:57.5101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v4ifUf9S6go6yQacbJpnnJn/kX6wBMehWGuq+72rZAEh7Mtl7TjyL/Xskr/wUsyN8VfgQZsnOsdPGHJjL11ebw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2893
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/23/2020 2:47 PM, Herbert Xu wrote:=0A=
> On Wed, Apr 15, 2020 at 11:26:14PM +0300, Iuliana Prodan wrote:=0A=
>> Added support for executing multiple requests, in parallel,=0A=
>> for crypto engine based on a retry mechanism.=0A=
>> If hardware was unable to execute a backlog request, enqueue it=0A=
>> back in front of crypto-engine queue, to keep the order=0A=
>> of requests.=0A=
>>=0A=
>> A new variable is added, retry_support (this is to keep the=0A=
>> backward compatibility of crypto-engine) , which keeps track=0A=
>> whether the hardware has support for retry mechanism and,=0A=
>> also, if can run multiple requests.=0A=
>>=0A=
>> If do_one_request() returns:=0A=
>>> =3D 0: hardware executed the request successfully;=0A=
>> < 0: this is the old error path. If hardware has support for retry=0A=
>> mechanism, the request is put back in front of crypto-engine queue.=0A=
>> For backwards compatibility, if the retry support is not available,=0A=
>> the crypto-engine will work as before.=0A=
>> Only MAY_BACKLOG requests are enqueued back into=0A=
>> crypto-engine's queue, since the others can be dropped.=0A=
> =0A=
> This looks a lot nicer!=0A=
> =0A=
> However, I do have one little issue with the error case.  I think=0A=
> we should not lump all errors together.  For queueing errors, we=0A=
> should requeue regardless of MAY_BACKLOG.  After all, we don't=0A=
> want to have random packet loss just becayse the queue was full.=0A=
> =0A=
> For other errors (e.g., a kmalloc error), we should requeue the=0A=
> MAY_BACKLOG requests and drop everythin else.=0A=
> =0A=
=0A=
Do you refer to the error codes returned by do_one_request (which sends =0A=
the req to hw for execution)?=0A=
=0A=
If this returns:=0A=
1. 0, success;=0A=
2. -ENOSPC, I'll requeue it regardless of MAY_BACKLOG;=0A=
3. any other error (-EIO, -EINVAL, -ENOMEM, etc), I'll requeue only =0A=
MAY_BACKLOG requests.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
