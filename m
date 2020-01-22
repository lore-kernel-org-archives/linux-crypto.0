Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFFCC2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 15:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64B0824125
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 15:11:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kuh+mD9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgAVPLz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 10:11:55 -0500
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:50108
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725928AbgAVPLz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 10:11:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEyOvh99v69RjfBhzM7Cshpo7xWvEIwGSlijk1jcVGJBWA7E6evOwGg0mIxOmUsVenUKDEXbfaE6RwKKU6zo6naM7oHKMGPjcXCvlVeH/kcfXGkaE5Bv/g1vrUjXIQ5FzjasISlDsDSnLtGNjJHPaUlm0eTL+sw+B5hCG/4tVbIcxs+++zb7h2erlAeSh0xW5gOSMQUhhgqs8nwJujgtm61XKtjWUKpSPn26kw+6VKw0irepK17O7xGMv6yumobMiU8sUJfCPYK7xCaa+BP21eaIf4BBmejNRlUvzpZuCOMYFEiPE8iUxpN/OgwA9D2QnKvn4UE2F434NgqVsc7Tzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Gi/JVocE/IQO1CICKM3jipHINJ9lHvNGOkKoTPNg+g=;
 b=eMkPad1yOWWnr/NQhXoaRfXWlgE7zbJGgYRWnNu/jqDd0UMvvml8psgIEZ7suDr3gISB5Ad79lSRKNLqB4IwlAXc+ZBfcbhcd7RKx1sIlBzaZkclfMG1IqBbmg4ZjvuWmwDs/21WcvLYTa9gVDzmINtj49H4t5ndzKFySJMRJxGwGrCDcTXQXFoLoqDaQPv/S78pwwD3xfLwoPhI7ZMEMOnXLLEa1BlnRCrVn2RHyk6kaQ/2Y08oB7QwHaVwUrNwjeH5JIv+zWi+bdJXqB94lde4we1tAprnltmj753oM9YZcBI+FyJgDd/ca7tDOPgs63IS8bru6/91OeGBKk/wkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Gi/JVocE/IQO1CICKM3jipHINJ9lHvNGOkKoTPNg+g=;
 b=kuh+mD9WGRhAPc/YREskCZfP0Qz2HLaF1/6GQ5gg6h3FL4MM6j5GxRASFLgmmVapPXqIq6wqnj2Zgd6YfUcXkqSNkGtjo4DAtQb0Mol/s9IF9HWwGv7yWDyQqmtvcMC/ecD8HVh7aGRgYyUHfvuDjX4SU3F9O/FyXaun09Q74+4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3469.eurprd04.prod.outlook.com (52.134.6.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Wed, 22 Jan 2020 15:11:51 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 15:11:51 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: Re: [PATCH v6 0/7] enable CAAM's HWRNG as default
Thread-Topic: [PATCH v6 0/7] enable CAAM's HWRNG as default
Thread-Index: AQHVxjopojbABEfYu0izDuntHRvy8g==
Date:   Wed, 22 Jan 2020 15:11:51 +0000
Message-ID: <VI1PR0402MB34850E6CC88CD55642C7386C980C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 428647f0-fd9f-40fd-c886-08d79f4d68b5
x-ms-traffictypediagnostic: VI1PR0402MB3469:|VI1PR0402MB3469:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3469801837908756C83A03E9980C0@VI1PR0402MB3469.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(199004)(189003)(26005)(186003)(86362001)(53546011)(6506007)(55016002)(52536014)(76116006)(66946007)(5660300002)(91956017)(64756008)(478600001)(7696005)(66556008)(66476007)(66446008)(44832011)(8676002)(110136005)(71200400001)(2906002)(4326008)(9686003)(316002)(81156014)(33656002)(81166006)(54906003)(8936002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3469;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ag8VoGjDGnL3NcX3L3Ex4XZVsW2hG351mcMlRoEUzP2l0P8sKYDk4o1DiGfEZvDJSRKsyUPMKivrF2DgEaaaojpOK1e1xMApklw9IA2DFgMic39Az4Ea2l5wgZRRpBfdBjMCC+gWeEnv5Ft1hjSfPIsupBiiaqot6b2o/iztgSCG7kkA5Cfb1k/VjgGJvxDbPF2yV77hYWb15jP0syRq4WUUo1ySxDH343FrxN+TD9BrTsNYwJYZNCAuW7ur8lOG1pPZz/qW1fZK4P5PSwkm03S0gxpOhiSeE6kQZ9hqiIU+rjQTfKBTCgD6JTlmNaaz5i3gfVia8pRr+c36sMgM0osH+C5jwXjIypuvEGGub4ixDzdqsNfSWmVnMOPngQpzekEgAjNzKG5HDvaVvi/aj6l3XyXvP9q115b1eXKnfvV4NnPSqD2dj6yJkfNfTh/5zKIyW1AIdJkplxFOmvIdVg9tCJ333d0HjkOnCW3sbcpEvmEAPH++YKO8dyUiyzOl
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 428647f0-fd9f-40fd-c886-08d79f4d68b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 15:11:51.1985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zYO2oR418R1zCoO7NAqRDwD32uvxOVzXB1/vU/lqG3Apat1F80qsEiixZZIKAJ81nwE+7eD02bVqUpyl1G0AbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3469
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/8/2020 5:41 PM, Andrey Smirnov wrote:=0A=
> Everyone:=0A=
> =0A=
> This series is a continuation of original [discussion]. I don't know=0A=
> if what's in the series is enough to use CAAMs HWRNG system wide, but=0A=
> I am hoping that with enough iterations and feedback it will be.=0A=
> =0A=
Testing on DPAA2-based Layerscape platforms, for e.g. LS1088A:=0A=
[...]=0A=
[   12.379136] caam_jr 8010000.jr: 20000256: CCB: desc idx 2: RNG: Predicti=
on resistance=0A=
[   12.387036] hwrng: no data available=0A=
[...]=0A=
=0A=
caamrng driver fails, because RNG initialization is skipped=0A=
in ctrl.c - caam_probe():=0A=
	[...]=0A=
	np =3D of_find_compatible_node(NULL, NULL, "fsl,qoriq-mc");=0A=
	ctrlpriv->mc_en =3D !!np;=0A=
	[...]=0A=
	/*=0A=
	 * If SEC has RNG version >=3D 4 and RNG state handle has not been=0A=
	 * already instantiated, do RNG instantiation=0A=
	 * In case of SoCs with Management Complex, RNG is managed by MC f/w.=0A=
	 */=0A=
	if (!ctrlpriv->mc_en && rng_vid >=3D 4) {=0A=
	[...]=0A=
=0A=
NXP is working at adding RNG Prediction Resistance support in MC f/w=0A=
(will be available in v10.20.1).=0A=
=0A=
However, there's a backwards-compatibility requirement: kernel should work=
=0A=
with older MC f/w versions.=0A=
To fix this, my suggestion is to force RNG (re)initialization in case=0A=
MC f/w is present and its version is < 10.20.1, i.e.:=0A=
	if ((!ctrlpriv->mc_en || (fsl_mc_get_version() < "10.20.1")) &&=0A=
	    rng_vid >=3D 4) {=0A=
	[...]=0A=
=0A=
fsl_mc_get_version() - I've made this up, it currently doesn't exist,=0A=
it should be added in fsl-mc bus driver (drivers/bus/fsl-mc).=0A=
We will provide this shortly, the plan being to integrate this change=0A=
as part of this series.=0A=
=0A=
Thanks,=0A=
Horia=0A=
