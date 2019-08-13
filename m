Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE7BC32750
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 13:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BAAA206C2
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 13:59:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="A25k5EnS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbfHMN7b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Aug 2019 09:59:31 -0400
Received: from mail-eopbgr00071.outbound.protection.outlook.com ([40.107.0.71]:51556
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727427AbfHMN7b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Aug 2019 09:59:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJ2F6Jvq8RqAZGZsnFCFWMHTjsTtbvWr4TwzhJKle4FchpvuWhE4URxSkQNu/e2zYeYSAw393TfutliAEA1gfRxYzHH3Tukm5lvtzEJWULET0O2XplMLSvyY153ah2iV2/e1R0PddHRE4RXGJiG+yWYD+gI1uwrztGnKu3qYOBdRRkwivc+U0IuKRur+NedkwO0rTlScoe4Ay1Mp5iwTF61nDctlkUQmmoNMnmZDBNR8wqTuuhW6hAwdrsfXEDaz4alBlqrqoSApEL+Pa//4uJjRIsT8+xze7PtQA/Ay6ca0lwykTY4h9uIGM2sK2Yt6/odGn722OoX+qiq9mDrpZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fi4SXYIyb6F9PNgzignVr5pyf3AcXXAVESOdExma4AA=;
 b=dsxvhlBRc/KXtP7NiVQKusCkIM8GUQXj4rxTRIbxYLaRicDNkhemMXCoDhoJItAZ1XQlj4r2lOpJCX6mWTWe7AfRqt3ccJKXbluaLew5wIrYebC5QG0wQrHeRm3Y8x14cfTnBowKvPXMdycXwwwhdeLNR9C1a6Ky1Unujr5Zv+Tz7djke36u8oiyDcZKY22A+3GINESf45A+IwIIoYvILc5JCk8RBTW3wk9NHpOqQ2Fu5Tjmf0uq2/AMo0OptF/H8KLyREG2rMpRGXLtgz4ApAg27FId+3NupWIhjQLRpL0shjyx+0eBbUWwpkorA3/a7B+0GbOVfrLlgNFTAWXfjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fi4SXYIyb6F9PNgzignVr5pyf3AcXXAVESOdExma4AA=;
 b=A25k5EnSO5Q8HDxNv6SOZFYuW9rvxM79b0XMRv/j7Os4mUiGKINdAp8TIKshPnkTcOL6P3rrbQA1NrZwvIaKm7vNxb9IlfrJLD78wEH/H028Z71W6OSZDaMq2gaIJhNshyV6iL5fhate0+9IR1XuDxikYyg9+Tv7cOArPXhILDk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3950.eurprd04.prod.outlook.com (52.134.17.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.13; Tue, 13 Aug 2019 13:59:22 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a070:859:ccf8:3617]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a070:859:ccf8:3617%7]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 13:59:22 +0000
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
Subject: Re: [PATCH v7 00/15] crypto: caam - Add i.MX8MQ support
Thread-Topic: [PATCH v7 00/15] crypto: caam - Add i.MX8MQ support
Thread-Index: AQHVUUmn1hIaCFgDckirZJX9STyHyw==
Date:   Tue, 13 Aug 2019 13:59:22 +0000
Message-ID: <VI1PR0402MB34857B6486BDFE28B75A642398D20@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190812200739.30389-1-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ba7ed39-115f-430a-c6df-08d71ff67184
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3950;
x-ms-traffictypediagnostic: VI1PR0402MB3950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB395044078E4147E7821BCF3B98D20@VI1PR0402MB3950.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(199004)(189003)(4326008)(4744005)(33656002)(76176011)(99286004)(71200400001)(2906002)(26005)(5660300002)(8676002)(86362001)(66476007)(53936002)(14454004)(66946007)(66446008)(52536014)(66556008)(256004)(53546011)(14444005)(64756008)(91956017)(76116006)(186003)(6246003)(55016002)(102836004)(7696005)(478600001)(9686003)(6506007)(71190400001)(486006)(44832011)(476003)(25786009)(6436002)(81166006)(81156014)(8936002)(229853002)(446003)(66066001)(7736002)(2501003)(110136005)(54906003)(316002)(3846002)(6116002)(74316002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3950;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: v5Y3n+Ve9qwKY9sg4+yJVrkwAPQ+QOArqG1PmX4VX2DqTzoJvP3Tc8+o4t85iM8UM/YXwUuyUq3YlyDujl9td9twvdF5O8F/N/bKx5+HkZSpXBc7AEZdmiy0d5Gqa4wxm38Jg/kD24fSvyBsHGeAb9k3Tr82qra+BERx2Ngugup9s8mrGy+etr+yC/LLusbQ00uZXj+uWu/nHiXiAZuElzmGnQPYGwHVJNTO9jNLSI+de8KNNLCbeBNtaCYZS0wyowMYWxEQqd3eCqLA3LL+0WQe1wXmAkimpYCqIi0UjhJeMQW9Rci9QMJ0TzNEED+MlHzXQ+iO9lVIcemOkQ+iwsk4GbLTPyMdAsFEY+om1MdbXYygKj/fcFUJIE7EuFBkLj38t5zm/AlPNoV+SELcCCK9fkB7TI6v223kEvpFQzE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba7ed39-115f-430a-c6df-08d71ff67184
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 13:59:22.2807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eWSk/fpCJrR8oxUUmGBG8t693Da9fLtsTw/+pMoRV2dL4uo9a81chVx41fTLz0kQlnwD73mfTVlTjQV34aqGOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3950
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/12/2019 11:08 PM, Andrey Smirnov wrote:=0A=
> Everyone:=0A=
> =0A=
> Picking up where Chris left off (I chatted with him privately=0A=
> beforehead), this series adds support for i.MX8MQ to CAAM driver. Just=0A=
> like [v1], this series is i.MX8MQ only.=0A=
> =0A=
> Feedback is welcome!=0A=
> Thanks,=0A=
> Andrey Smirnov=0A=
> =0A=
> Changes since [v6]:=0A=
> =0A=
>   - Fixed build problems in "crypto: caam - make CAAM_PTR_SZ dynamic"=0A=
> =0A=
>   - Collected Reviewied-by from Horia=0A=
> =0A=
>   - "crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs"=0A=
>     is changed to check 'caam_ptr_sz' instead of using 'caam_imx'=0A=
>     =0A=
>   - Incorporated feedback for "crypto: caam - request JR IRQ as the=0A=
>     last step" and "crypto: caam - simplfy clock initialization"=0A=
> =0A=
FYI - the series does not apply cleanly on current cryptodev-2.6 tree.=0A=
=0A=
Horia=0A=
