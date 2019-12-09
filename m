Return-Path: <SRS0=S8oY=Z7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A26CC43603
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 15:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD356207FF
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 15:45:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="fM13N4iC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfLIPpB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 10:45:01 -0500
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:3202
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726197AbfLIPpB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 10:45:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+2dC/iK/Lh4tuc6qY1H4VmssIrYCtHFSxteEIrWRZts4CwCfBW9C8ee/depAyBHQbUyq/slQgjHuisUgwvsbImpBRj9MUOeNdZ/2ecUgio+BY6O3bNrtMlRMCGyvPtpEY4/dA6Rg6zn4f6kLazsQ3Q7B5ZDsegqHd0jYC62dlHgCXV4pzFGWNQipkru1LmDMX0dm4kO1vMumH5nptT94WMLd4A621WNx0AjIqLKJ39vRwPk7kXCNVtgBoSnzTBFVXmyKAPG87s3prwqR8EfJCmglPPSV7ncp8IuBq80JTBpUwbmEc2P+u/sLXp7WWurQtM3Dqk3jWfx4LjkNXE1/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HgjuyrInZPIt6JgNSyYk+NBewPTa5N3Du30ED4X27c=;
 b=NaCFxTXGp9TR1fHPoS1I9/qRYD2q+EWTwyegF7KAlttqdh4HPxnd6t0yhGUKEL5Vr5soADoGPNoOKif7oMe6detqTDP8j6J0ZEtzHU39HXilYy48WYeM11c72B2HVEmWnVyfFteJdn2TcLWV6UyDwpw847FXAOQrMsjuabYff1jswNKOPTus8nd/1oU7qgDW7Via8PH42s8Zo4P66Z9zgW6umHgCLWjJn9MuIfXRQcEgpTlIop0rvyd8pgXqczSWLcXXTTMDyucF1R4MdHUdmBQ4NOZ12ZXHLJDzkRVuwZwO0W/law51r30HAbQapcuE2Dx62lySW6w1szYYjV0EOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HgjuyrInZPIt6JgNSyYk+NBewPTa5N3Du30ED4X27c=;
 b=fM13N4iCHgioD3kw9CN0RzQ7KurQO7HoPD/QWfZnQEWa+MwMHrUVqYs9nlREStrelZy5kSIkWqJz7nTYDfi8DZANyyx21JoHbwInj3+FSJ7V1smZCwIyfXHkey0RO2UvFMSYSeQ5V/JezAkBN7uBLPGGm2DbVfotPTTUCp7NvV0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3806.eurprd04.prod.outlook.com (52.134.11.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.18; Mon, 9 Dec 2019 15:44:15 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4%6]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 15:44:15 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v5 0/4] enable CAAM's HWRNG as default
Thread-Topic: [PATCH v5 0/4] enable CAAM's HWRNG as default
Thread-Index: AQHVqfYbrp2ap031c0mfNElXDRWd5w==
Date:   Mon, 9 Dec 2019 15:44:15 +0000
Message-ID: <VI1PR0402MB3485EF10976A4A69F90E5B0F98580@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191203162357.21942-1-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1948729b-3fae-4a70-249a-08d77cbea52e
x-ms-traffictypediagnostic: VI1PR0402MB3806:|VI1PR0402MB3806:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3806A0B258E6F8FD3796086198580@VI1PR0402MB3806.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:366;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(189003)(199004)(8676002)(305945005)(6506007)(66446008)(71190400001)(64756008)(66556008)(53546011)(5660300002)(81156014)(81166006)(8936002)(26005)(229853002)(86362001)(7696005)(186003)(4326008)(33656002)(44832011)(316002)(478600001)(966005)(55016002)(91956017)(76116006)(66476007)(71200400001)(110136005)(9686003)(2906002)(54906003)(52536014)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3806;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YJ0bUCnQfRa4zYEexjXZjEPu0wRIjat/buM9FRFdtQ+lWV+jjlsIppNCchtD/yuaOGcpPfh2fa3UOvmWRuVU+HNbVWS6OiQu+1lV7eOIQ3G+YP5Y6xkMVtL9DHOTJ8PZG1Q3x8/rIvc9X2xDTZwNdfQrvJ6iSXr8C0EY6UuFGeUCFAKwvt5N4vOMH068YPurh5qUcd7WwUqvMG6ahyhXRoarwzE/QNwTzzFTxb+CJAx6fui//o5oJLAgW2XWfNUWUp0yKpMxyKa5lUGPlYBY12IlMD/3Ei2Kizwnt5jkEqtGJsjnvg6fS0CQiQU9OKZgZP1iqtyFIsJgJbHwGZ0awX1aEWD8Bd944q7tKeewhlR0zW7xZjcAclU3Xkp0+RgMAJIFgYAnyBCFOL/jaQ3qP0Vh1QbqyHn65/LhA1vpcl7r1oLR1ic8S9nYVm1KQg4CUtgUTSUb/om8J//ZBtJfzG+BzUhVyUp361zvTsi2PaM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1948729b-3fae-4a70-249a-08d77cbea52e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 15:44:15.1750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kKIWjN16MLB2dSHt97tVuHTynvw4Byo7TYZmUrTMeMdrYC85Pv1wUMt8JjXi7P6HzTe1ft8YtvC/Yx/tcecXKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3806
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/3/2019 6:24 PM, Andrey Smirnov wrote:=0A=
> Everyone:=0A=
> =0A=
> This series is a continuation of original [discussion]. I don't know=0A=
> if what's in the series is enough to use CAAMs HWRNG system wide, but=0A=
> I am hoping that with enough iterations and feedback it will be.=0A=
> =0A=
> Changes since [v1]:=0A=
> =0A=
>     - Original hw_random replaced with the one using output of TRNG direc=
tly=0A=
> =0A=
>     - SEC4 DRNG IP block exposed via crypto API=0A=
> =0A=
>     - Small fix regarding use of GFP_DMA added to the series=0A=
> =0A=
> Chagnes since [v2]:=0A=
> =0A=
>     - msleep in polling loop to avoid wasting CPU cycles=0A=
> =0A=
>     - caam_trng_read() bails out early if 'wait' is set to 'false'=0A=
> =0A=
>     - fixed typo in ZII's name=0A=
> =0A=
> Changes since [v3]:=0A=
> =0A=
>     - DRNG's .cra_name is now "stdrng"=0A=
> =0A=
>     - collected Reviewd-by tag from Lucas=0A=
> =0A=
>     - typo fixes in commit messages of the series=0A=
> =0A=
> Changes since [v4]:=0A=
> =0A=
>     - Dropped "crypto: caam - RNG4 TRNG errata" and "crypto: caam -=0A=
>       enable prediction resistance in HRWNG" to limit the scope of the=0A=
>       series. Those two patches are not yet ready and can be submitted=0A=
>       separately later.=0A=
> =0A=
I don't agree with dropping the Job Ring Interface (JRI) in favor of=0A=
using TRNG registers directly - for the purpose of extracting entropy.=0A=
=0A=
One of the reasons is that TRNG registers are part of page 0,=0A=
which is not accessible in the Linux kernel in some cases.=0A=
=0A=
It's possible to use JRI for extracting entropy following these steps:=0A=
=0A=
1. Instantiate RNG state handle with Prediction Resistance (PR) support=0A=
This is optional in cases when page 0 is not under kernel's control.=0A=
We'll separately modify SW controlling page 0 to offer PR support.=0A=
=0A=
2. For each hwrng read(), enqueue via JRI one or more job descriptors (JD)=
=0A=
having the PR bit set in the ALGORITHM OPERATION command.=0A=
=0A=
Note that according to hwrng API, it's ok to *partially* fulfill the reques=
t:=0A=
 * @read:		New API. drivers can fill up to max bytes of data=0A=
 *			into the buffer. The buffer is aligned for any type=0A=
 *			and max is a multiple of 4 and >=3D 32 bytes.=0A=
=0A=
It's important to limit the output of each JD, such that the recommendation=
=0A=
in SP800-90C (section "9.4 The Oversampling-NRBG Construction") is followed=
:=0A=
https://csrc.nist.gov/CSRC/media/Publications/sp/800-90c/draft/documents/sp=
800_90c_second_draft.pdf=0A=
=0A=
For CAAM RNG4, the DRBG security strength is s =3D 256 bits (32 bytes),=0A=
thus each JD must extract at most s/2 - 128 bits (16 bytes).=0A=
=0A=
Similar to what's being done for TRNG registers-based implementation,=0A=
some back-off mechanism is needed, such that DECO won't stall=0A=
waiting for the TRNG.=0A=
This is important on i.MX platforms where there's a single DECO=0A=
(on PPC & Layerscape platforms there are multiple DECOs).=0A=
=0A=
Horia=0A=
