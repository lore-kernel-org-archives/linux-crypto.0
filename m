Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0CAC4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 15:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CAE21920
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 15:39:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ekf6GuV0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbfIIPje (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 11:39:34 -0400
Received: from mail-eopbgr130083.outbound.protection.outlook.com ([40.107.13.83]:22915
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727003AbfIIPje (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 11:39:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRBJ4vRg25cZD2EvCjwsb4hdE0O44rHj2j1kJdTQ0eSzzMG3WfllMjjbPqkcl78N1wGG1yVkM3Jq4mbBizeDUSMfUehW/pEDqv4QAcWCXai9MN8nKCLaQJOMN4c8m1lPT53HVhyn+NW+2L6MVkVa877WwnJRDXyRoM6OFfdHBfIMGRT6/Tu03ECAtMuK4Y6WHMGPljp7pvn1CrZ4r5wIET425PFHUyfxNQLb9XsrOO2dq7E6HpzvLYcO1x3a4XsU/Jt8e3SnRNPAtfOcU9QbH1eSYKx+4XRQBLk18o/uR8/UG4X0HIEmPHUzJwxZ825DhvcW8lxXSy2dKt/mVW998Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apYNX4yOZvoV/22R2FMeu1jf8YYXt1rkrjcxM2wyi68=;
 b=AI0MvaJlgeh00UF8px96mUaWfG4IiVmCpBelmpJt0uhuO1Ev+9FqXxjYG7qXNn6gu+xZVsJ81SxVRw7ckNessunwOAD1EqPReJ6PVo7D22rBEpQ8BinJjc3F9Hd1rf1PrXXPvVTMplRE1Xf76kmCRPKx3+2vYnUpS1WQhjDMFJZNZVm2AKYwVhbiaRuiAvG/E7sgL2GC7Mt18+vBKlRDCBj0d8y5DBKQZqprbfRjmP1vyiheqeUWwNWod7kG/M0uymYUjvz79phOnRQH41B2xewwAamMfMP7w7Xd67eVghK7Xfvo/BrK2RpnQ5uYu0eYdgt08zVMEF+Pz3VpfvufGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apYNX4yOZvoV/22R2FMeu1jf8YYXt1rkrjcxM2wyi68=;
 b=ekf6GuV0iaOLJA3WWNZeudRY4KisiO3XwLQtipDzlILDzpzTQgJ7S+TpoVf82y8OCJuwy6eXTaDgBoMRGtMvZgbo1aXKGTtdGcscBBLV8EyzoxHcXg1uwFpvnt0buaFwFSpPhcPYYAgVhr/B5EdZ1+3/D+yFhFpyM5/Oo78ckLs=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2863.eurprd04.prod.outlook.com (10.175.20.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 15:39:26 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 15:39:26 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/12] crypto: caam - use devres to de-initialize the RNG
Thread-Topic: [PATCH 07/12] crypto: caam - use devres to de-initialize the RNG
Thread-Index: AQHVYslzat3rKGnTJkeyvK0f97ip2w==
Date:   Mon, 9 Sep 2019 15:39:26 +0000
Message-ID: <VI1PR0402MB3485C8B22FD2B66F8FD9653E98B70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-8-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e3af14a-8ed6-4733-5c3a-08d7353be57f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2863;
x-ms-traffictypediagnostic: VI1PR0402MB2863:|VI1PR0402MB2863:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2863ECD469AD3FF49FE1505698B70@VI1PR0402MB2863.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(189003)(199004)(5660300002)(25786009)(64756008)(305945005)(66556008)(8936002)(81156014)(81166006)(446003)(53546011)(8676002)(229853002)(6506007)(102836004)(486006)(76176011)(478600001)(54906003)(110136005)(186003)(7696005)(6436002)(476003)(14454004)(99286004)(74316002)(316002)(66446008)(66476007)(7736002)(66946007)(2906002)(76116006)(91956017)(26005)(2501003)(86362001)(44832011)(52536014)(9686003)(6246003)(53936002)(3846002)(55016002)(6116002)(71190400001)(71200400001)(66066001)(4326008)(256004)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2863;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zCSMw1fqKumW8I+MZWyQxTcDe4dLpdrcKbSA/R+nFiGaZenQw8x9Ek/OVjsulZp9UFi/zTHZ3GbchDaP7z72SwussXYmQrRia4EUC87Ls0gxn42yYdUYw6JlXDiWG1XuS7yM6rVmZldkf5Em5e+92VJ2mFy8gd7mmbZTksCc/WwON4JlPNMnKLRWHVgW8hWBsw4d4M3pTDNDcQJ1hROklD+XVEg6ZlRgbSZbYKT3h8BkN65z1cTvcPEGZZQSwr/E8pgxn/HA0zMei4tRf3wU3VqoEdQt8TxH+hjRK4Qqxv+0jmrnbBz1udQ5BbJfedpO2mpSpkvbkB7xgU0ng/WrK9ynZbuoKoWds+1s0VrUa/z9vVP6Tgvu0DOJJJKWW8KQ9F2w0ZxlLdlk4CxgVS/MlsS/RIxCcoza5V/7Ea9hoJQ=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3af14a-8ed6-4733-5c3a-08d7353be57f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 15:39:26.5446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UbcMtxe4+KCaEIzsSZ5BNvNzxxRGMIq6WU7InZda1BNOmZqxkcRD6ka9Xrz1azEY6WkL7DVvLFLiIvhnWhOVdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
> Use devres to de-initialize the RNG and drop explicit de-initialization=
=0A=
> code in caam_remove().=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
> ---=0A=
>  drivers/crypto/caam/ctrl.c | 129 ++++++++++++++++++++-----------------=
=0A=
>  1 file changed, 70 insertions(+), 59 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c=0A=
> index 254963498abc..25f8f76551a5 100644=0A=
> --- a/drivers/crypto/caam/ctrl.c=0A=
> +++ b/drivers/crypto/caam/ctrl.c=0A=
> @@ -175,6 +175,73 @@ static inline int run_descriptor_deco0(struct device=
 *ctrldev, u32 *desc,=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * deinstantiate_rng - builds and executes a descriptor on DECO0,=0A=
> + *		       which deinitializes the RNG block.=0A=
> + * @ctrldev - pointer to device=0A=
> + * @state_handle_mask - bitmask containing the instantiation status=0A=
> + *			for the RNG4 state handles which exist in=0A=
> + *			the RNG4 block: 1 if it's been instantiated=0A=
> + *=0A=
> + * Return: - 0 if no error occurred=0A=
> + *	   - -ENOMEM if there isn't enough memory to allocate the descriptor=
=0A=
> + *	   - -ENODEV if DECO0 couldn't be acquired=0A=
> + *	   - -EAGAIN if an error occurred when executing the descriptor=0A=
> + */=0A=
> +static int deinstantiate_rng(struct device *ctrldev, int state_handle_ma=
sk)=0A=
I assume this function is not modified, only moved further up=0A=
to avoid forward declaration.=0A=
=0A=
> +	if (!ret) {=0A=
> +		ret =3D devm_add_action_or_reset(ctrldev, devm_deinstantiate_rng,=0A=
> +					       ctrldev);=0A=
>  	}=0A=
Braces not needed.=0A=
=0A=
Is there any guidance wrt. when *not* to use devres?=0A=
=0A=
Horia=0A=
