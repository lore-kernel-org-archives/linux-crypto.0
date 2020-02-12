Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B473EC2BA83
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 05:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ED012073C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 05:10:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="T9jemaU9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgBLFKY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 00:10:24 -0500
Received: from mail-bn7nam10on2068.outbound.protection.outlook.com ([40.107.92.68]:6031
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbgBLFKY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 00:10:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnDqWNGY3R0DR7D6nA1GYoIM6SBrCWv+/Q1FEFhilbaprh/+bff+AXFLXG4oAQw39uebfOxSDF89H+9GOhWiqBYhOmBEAnmFNCg9zrWLivGF7E/sNZoJGQEKb+ug2Rsp5VRMQ9yyZ+xTktVJgvv7i/V7KAdz8GMA2gXC897B+czwv8frg0E+vqYFep7rvRlaXpNZzRYWB6TTAU8wChWdzgp5n9VxEmJpaSgu1/EEqhFmU/fqo93PvH+5LvhimBSZs3vSZIhiDucmF0F+uza8tgXRv4/KMJ2TPqOvjzydij0AhsxTy9H1ZcJtcrJbGAIM2CrXPFZMLy0OGG1U9W1dhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2TDpxxDqRiemWKqPM1xmti2ELd37TRpQ9mtfxsk8oI=;
 b=k0fGSLPq0u18R3hYv4IWy+x9aNuqXf1IZzp25e/t9qsv433YxYq/FftKcJjwBnUapiXV4MTidO+5+aj5BjiyaBUkX+XjZgICbcVIoV25AfU0rVw4EuU4HnpStCdWp24m7l6CbRHi+C9FDRo2oQLa4Eyyx1ebn1KaZxjHgl6KD/vEkSy92XBH0SQOiGU6Mjydb/3J9XCzPaM1hRTPHZfdw/UPvKqPQ6Q8UpMRfT9DU83aYN2VQdUTII1yY5c/19uxBFFeqYq0QJcYPSf7lGIdp2pPwVmt0BayobVVJiPr3r9JVzxUrk9/d/TPjTA8r0WlyZ9VfYR5UgXQyoQCBNprZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2TDpxxDqRiemWKqPM1xmti2ELd37TRpQ9mtfxsk8oI=;
 b=T9jemaU9ptjBO1zkTNJPWXaCI3cW3DWLzrYKrvovxFhnPZWd74mPM+MeclKUAHZtgl6Ijxa98GBsmk+93GXvQJXnfEdYUo+b7FsE5Qmx17W5+nnfnIfkOAkBR4jb2fiCXcMNvzfb1KKCuonvLGfserrfPlZp+5oup7AQyQPaWuU=
Received: from BN7PR02MB5124.namprd02.prod.outlook.com (20.176.27.215) by
 BN7PR02MB4068.namprd02.prod.outlook.com (52.133.221.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 05:10:18 +0000
Received: from BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::2080:b53d:b5bd:cbe2]) by BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::2080:b53d:b5bd:cbe2%5]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 05:10:17 +0000
From:   Kalyani Akula <kalyania@xilinx.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "monstr@seznam.cz" <monstr@seznam.cz>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        git-dev <git-dev@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Michal Simek <michals@xilinx.com>,
        Kalyani Akula <kalyania@xilinx.com>
Subject: RE: [PATCH V6 0/4] Add Xilinx's ZynqMP AES-GCM driver support
Thread-Topic: [PATCH V6 0/4] Add Xilinx's ZynqMP AES-GCM driver support
Thread-Index: AQHV1aLL+qOyLD1FZ0K9Asrl2Q9GTagXGSkQ
Date:   Wed, 12 Feb 2020 05:10:16 +0000
Message-ID: <BN7PR02MB51244DF14A79839729851EF4AF1B0@BN7PR02MB5124.namprd02.prod.outlook.com>
References: <1580192308-10952-1-git-send-email-kalyani.akula@xilinx.com>
In-Reply-To: <1580192308-10952-1-git-send-email-kalyani.akula@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kalyania@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c57db2bf-b03f-4295-4cf3-08d7af79d9ea
x-ms-traffictypediagnostic: BN7PR02MB4068:|BN7PR02MB4068:
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR02MB4068ABAD41523B16E3A95491AF1B0@BN7PR02MB4068.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:586;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(189003)(199004)(110136005)(66556008)(8936002)(66476007)(5660300002)(66946007)(76116006)(316002)(52536014)(54906003)(7696005)(64756008)(966005)(71200400001)(2906002)(66446008)(478600001)(4326008)(26005)(33656002)(9686003)(55016002)(186003)(86362001)(53546011)(6506007)(8676002)(81156014)(81166006)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB4068;H:BN7PR02MB5124.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cZ0DXBp9f4X1R4iMPMgLTjL0sAnPdIUjPSEzFVA4hPmhksWnsuX+ePVS4G0M8amnb191aPQfFaqhNfJoadtEor2hCsZx1UYG07Z5iNiMSkbOPL1g7/6Zi2R2ji9vF0cNfQB9+UXBOkxgQHZchp2mHNxLFsD+BEixiP6ndjEXld5IlGUO+GUIylBQBvt0Ol4EQ/l/wLYguQGiQ5ms0vvVNrqpLQLsiXdZUEHEP0rTAwJPPXibZd55haGE5Jlz2z/HuS6xlm2YA869ETkOeLLO6dtEYFAoJ6J1lgkdOgU1Tz76Fe7hy0fybFY/A8BdYdizKEfJzVup3/5W1Mrhn2dC4zEklDToUAZUfupwqlDPhXs7UN3zKgwB7MK/o1JZMDzXzcDyer9A42G1/D29A70E3E937JRxqAQ/5zWUbBFQ2/xm8I9A/lo1JI+Cnllg47ntpvB1tvhPSOa5ULEKQ2mjzUtb9FYsrwL2wmPzDSb/LHs703b9EoyHxU+n5ipvuScbCpWrH+YdT1HPbwVeXJZqMw==
x-ms-exchange-antispam-messagedata: nq9rFp+EZ+FF+c2SuQU6YOqf08humxIhggsYTjTCjNdfroF9p2rYphnDq5ZZ9boGT4kZy+zoH3LcoBb0f51iTx315MrMb8w1I36zEGhUU/aEHEt/zwC0UEr0cOhKHeNbkyr3Hot2TbvPIVzTdc8gPA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c57db2bf-b03f-4295-4cf3-08d7af79d9ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 05:10:17.0983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vvRsmdPdM6+fKd0bCRyftMKqeIY8ULX2tyzNSTWOUYx5yC/ImsIbWhOjnInBbCBZfe46Q2rX5DgUvsetnu9y4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB4068
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

When can we expect this patch-set to be merged.

Regards,
Kalyani

> -----Original Message-----
> From: Kalyani Akula <kalyani.akula@xilinx.com>
> Sent: Tuesday, January 28, 2020 11:48 AM
> To: herbert@gondor.apana.org.au; davem@davemloft.net;
> monstr@seznam.cz; linux-crypto@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Rob Herring <robh+dt@kernel.org>; devicetree@vger.kernel.org; git-dev
> <git-dev@xilinx.com>; Mohan Marutirao Dhanawade
> <mohand@xilinx.com>; Sarat Chand Savitala <saratcha@xilinx.com>; Harsh
> Jain <harshj@xilinx.com>; Michal Simek <michals@xilinx.com>; Kalyani Akul=
a
> <kalyania@xilinx.com>; Kalyani Akula <kalyania@xilinx.com>
> Subject: [PATCH V6 0/4] Add Xilinx's ZynqMP AES-GCM driver support
>=20
> This patch set adds support for
> - dt-binding docs for Xilinx ZynqMP AES driver
> - Adds device tree node for ZynqMP AES driver
> - Adds communication layer support for aes in zynqmp.c
> - Adds Xilinx ZynqMP driver for AES Algorithm
>=20
> NOTE: This patchset is based on Michal's branch
> https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git/log/?h=3Darm/=
driv
> ers
> because of possible merge conflict for 1/4 patch with below commit commit
> 461011b1e1ab ("drivers: firmware: xilinx: Add support for feature check")
>=20
> V6 Changes:
> - Updated SPDX-License-Identifier in xlnx,zynqmp-aes.yaml.
>=20
> V5 Changes :
> - Moved arm64: zynqmp: Add Xilinx AES node from 2/4 to 4/4.
> - Moved crypto: Add Xilinx AES driver patch from 4/4 to 3/4.
> - Moved dt-bindings patch from 1/4 to 2/4
> - Moved firmware: xilinx: Add ZynqMP aes API for AES patch from 3/4 to 1/=
4
> - Converted dt-bindings from .txt to .yaml format.
> - Corrected typo in the subject.
> - Updated zynqmp-aes node to correct location.
> - Replaced ARCH_ZYNQMP with ZYNQMP_FIRMWARE in Kconfig
> - Removed extra new lines and added wherever necessary.
> - Updated Signed-off-by sequence.
> - Ran checkpatch for all patches in the series.
>=20
> V4 Changes :
> - Addressed review comments.
>=20
> V3 Changes :
> - Added software fallback in cases where Hardware doesn't have
>   the capability to handle the request.
> - Removed use of global variable for storing the driver data.
> - Enabled CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy and executed all
>   the kernel selftests. Also covered tests with tcrypt module.
>=20
> V2 Changes :
> - Converted RFC PATCH to PATCH
> - Removed ALG_SET_KEY_TYPE that was added to support keytype
>   attribute. Taken using setkey interface.
> - Removed deprecated BLKCIPHER in Kconfig
> - Erased Key/IV from the buffer.
> - Renamed zynqmp-aes driver to zynqmp-aes-gcm.
> - Addressed few other review comments
>=20
>=20
> Kalyani Akula (4):
>   firmware: xilinx: Add ZynqMP aes API for AES functionality
>   dt-bindings: crypto: Add bindings for ZynqMP AES-GCM driver
>   crypto: Add Xilinx AES driver
>   arm64: zynqmp: Add Xilinx AES node.
>=20
>  .../bindings/crypto/xlnx,zynqmp-aes.yaml           |  37 ++
>  arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +
>  drivers/crypto/Kconfig                             |  12 +
>  drivers/crypto/Makefile                            |   1 +
>  drivers/crypto/xilinx/Makefile                     |   2 +
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c             | 466
> +++++++++++++++++++++
>  drivers/firmware/xilinx/zynqmp.c                   |  25 ++
>  include/linux/firmware/xlnx-zynqmp.h               |   2 +
>  8 files changed, 549 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
>  create mode 100644 drivers/crypto/xilinx/Makefile  create mode 100644
> drivers/crypto/xilinx/zynqmp-aes-gcm.c
>=20
> --
> 1.9.5

