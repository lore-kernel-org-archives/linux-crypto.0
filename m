Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30217C0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 08:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE25F2067D
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 08:23:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IS45fEZu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfHEIXQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 04:23:16 -0400
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:55298
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726394AbfHEIXP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 04:23:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIdeHaDqw9NYgbkH0NCPZqyn9dyecgp2MJfaY4fD+GUd8zhiAR49rdVc36iJPgUJS85+QDQNk5L2APxsd2bohD8cNs3GIchP1bMRKVBakqrF6inBU68wrQaGi2BG+4fanJyXh53AINQDWXaiPDiqDBKePuNABNqS7c0o+huV22CG+dmLCDYA6Ir/aahsNmwZM4FgG8ImWeaHrQPWeyxrTozkG8KI9o1/wGGzrBxk9QJX+JWA8LDEF5uBXf5hFhroHYr+YwTdXLj32TozCVW1qy3OZxckixqVxUz2LbRq9KxDiXbLGmgFrVbBtE18cYWdfcf7MHsmPz9Ur8cWiIjGDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6eMfSpzxTPsFNZgc0igVFgWrsMXGbM9eexBVZ2Ou9s=;
 b=efpS6VEug2cgylWkdsdDp54mtdGLt3YKmIZtlfIkeZZgzpVXcSq2D2Xpb/6inUF9H6TN2VcBGqMHDRn6VJghZLxKfAfj/9Vpwn9or9V3LWsE8T98Cm5ZI5x2VFQgWLgx3Iw++2+LNtukHhCwJ4OquPgdUri54eqg9kIml2r6ZNXNDPLKkBcZn1n/D1X0ToPwbdRTx9B0awPAZEvDXitijFrwcJ7Jpbd/o3BpWeQJcF0wAeYeq6MFZ020UAosW4IjLvfPgF8e6e9+OnTC0jxvd733Uth+OM3j2G1qr0DxLpaDFZXPC9sUzT1/NXwOcM7toMokATqWX6Tg/sXaR59fFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6eMfSpzxTPsFNZgc0igVFgWrsMXGbM9eexBVZ2Ou9s=;
 b=IS45fEZuWInaX2RzhTc2LnPZSzBhjyZyGl7gI9J9fSSaG8OT5sThHgeRsbjdMa/92bx0F5GDyc5zvsA7a3mIoNvpsQ/6arM6eXTCjsBvp+5zMYWq9E4mg/GiiK9gvGiPGIy8NKmWg1qlwMIyHBiihn0gIO4NmIGkH+TWO4AwCS0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3519.eurprd04.prod.outlook.com (52.134.4.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 5 Aug 2019 08:23:10 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 08:23:10 +0000
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
Subject: Re: [PATCH v6 12/14] crypto: caam - force DMA address to 32-bit on
 64-bit i.MX SoCs
Thread-Topic: [PATCH v6 12/14] crypto: caam - force DMA address to 32-bit on
 64-bit i.MX SoCs
Thread-Index: AQHVPLPfAFYTXvqoskun8b5hNYNNGA==
Date:   Mon, 5 Aug 2019 08:23:10 +0000
Message-ID: <VI1PR0402MB348580480F5EAF5F539B585A98DA0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-13-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6130c1b6-7258-43b9-d90a-08d7197e269f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3519;
x-ms-traffictypediagnostic: VI1PR0402MB3519:
x-microsoft-antispam-prvs: <VI1PR0402MB35194037DED914633DBEC4C098DA0@VI1PR0402MB3519.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(6029001)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(189003)(199004)(52536014)(14454004)(81166006)(256004)(4326008)(71200400001)(66556008)(76176011)(66476007)(53936002)(81156014)(229853002)(186003)(102836004)(8936002)(305945005)(7696005)(66946007)(7736002)(86362001)(71190400001)(55016002)(68736007)(64756008)(9686003)(44832011)(2501003)(446003)(74316002)(5660300002)(6246003)(91956017)(53546011)(33656002)(316002)(6116002)(99286004)(110136005)(54906003)(478600001)(8676002)(3846002)(486006)(2906002)(6436002)(25786009)(476003)(76116006)(6506007)(66446008)(66066001)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3519;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hz9XACouxVHOKO0woj/vSVE/jihpZ+O1vFw8OVaAfd1XL7ZxYgsC+2TrPJRMb6zS7njXfQS8Np2fwZ+sw4Xn84tyYD83z3w/hhp5cXSLsk+zkecLo67Hi+jlEPNQvzRzKKf3aiiF6IkrEhf/GEffNnYJvQ6locDBVQfSQYRhJt0otMpzz6IcAIuajQkcBvnBeathXhvprKRXHkJ77G7EMUCWXF1DIcItXJM/S7TQMwaa9tVP1LsULKffPQqbp+ZhdludAdY0y/Hdc5o3nsMvAmNqOYRBxbsC8VMe6pqh0vnUfsEyW9siyDRUpnLn7W6oljmJFv3DxqMsUbiUowrXm2HtQuRiR4pAHrcABJgupzJAd+v3iRzEfpCYFbuXMAiTbXJJBTU2HmniKuUqZ/SgTXBJoHHC2kq5De6mP3Z4O+4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6130c1b6-7258-43b9-d90a-08d7197e269f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 08:23:10.0338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3519
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/2019 6:25 PM, Andrey Smirnov wrote:=0A=
> i.MX8 SoC still use 32-bit addresses in its CAAM implmentation, so=0A=
i.MX8 SoC or i.MX8 mScale?=0A=
Looking at the documentation, some i.MX8 parts (for e.g. QM and QXP)=0A=
allow for 36-bit addresses.=0A=
=0A=
> change all of the code to be able to handle that.=0A=
> =0A=
Shouldn't this case (32-bit CAAM and CONFIG_ARCH_DMA_ADDR_T_64BIT=3Dy) work=
=0A=
for any ARMv8 SoC, i.e. how is this i.MX-specific?=0A=
=0A=
> @@ -603,11 +603,13 @@ static int caam_probe(struct platform_device *pdev)=
=0A=
>  		ret =3D init_clocks(dev, ctrlpriv, imx_soc_match->data);=0A=
>  		if (ret)=0A=
>  			return ret;=0A=
> +=0A=
> +		caam_ptr_sz =3D sizeof(u32);=0A=
> +	} else {=0A=
> +		caam_ptr_sz =3D sizeof(dma_addr_t);=0A=
caam_ptr_sz should be deduced by reading MCFGR[PS] bit, i.e. decoupled=0A=
from dma_addr_t.=0A=
=0A=
There is another configuration that should be considered=0A=
(even though highly unlikely):=0A=
caam_ptr_sz=3D1  - > 32-bit addresses for CAAM=0A=
CONFIG_ARCH_DMA_ADDR_T_64BIT=3Dn - 32-bit dma_addr_t=0A=
so the logic has to be carefully evaluated.=0A=
=0A=
> @@ -191,7 +191,8 @@ static inline u64 caam_dma64_to_cpu(u64 value)=0A=
>  =0A=
>  static inline u64 cpu_to_caam_dma(u64 value)=0A=
>  {=0A=
> -	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))=0A=
> +	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&=0A=
> +	    !caam_imx)=0A=
Related to my previous comment (i.MX-specific vs. SoC-generic),=0A=
this should probably change to smth. like: caam_ptr_sz =3D=3D sizeof(u64)=
=0A=
=0A=
>  		return cpu_to_caam_dma64(value);=0A=
>  	else=0A=
>  		return cpu_to_caam32(value);=0A=
> @@ -199,7 +200,8 @@ static inline u64 cpu_to_caam_dma(u64 value)=0A=
>  =0A=
>  static inline u64 caam_dma_to_cpu(u64 value)=0A=
>  {=0A=
> -	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))=0A=
> +	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&=0A=
> +	    !caam_imx)=0A=
Same here.=0A=
=0A=
>  		return caam_dma64_to_cpu(value);=0A=
>  	else=0A=
>  		return caam32_to_cpu(value);=0A=
> @@ -213,13 +215,24 @@ static inline u64 caam_dma_to_cpu(u64 value)=0A=
>  static inline void jr_outentry_get(void *outring, int hw_idx, dma_addr_t=
 *desc,=0A=
>  				   u32 *jrstatus)=0A=
>  {=0A=
> -	struct {=0A=
> -		dma_addr_t desc;/* Pointer to completed descriptor */=0A=
> -		u32 jrstatus;	/* Status for completed descriptor */=0A=
> -	} __packed *outentry =3D outring;=0A=
>  =0A=
> -	*desc =3D outentry[hw_idx].desc;=0A=
> -	*jrstatus =3D outentry[hw_idx].jrstatus;=0A=
> +	if (caam_imx) {=0A=
Same here: if (caam_ptr_sz =3D=3D sizeof(u32))=0A=
=0A=
> +		struct {=0A=
> +			u32 desc;=0A=
> +			u32 jrstatus;=0A=
> +		} __packed *outentry =3D outring;=0A=
> +=0A=
> +		*desc =3D outentry[hw_idx].desc;=0A=
> +		*jrstatus =3D outentry[hw_idx].jrstatus;=0A=
> +	} else {=0A=
> +		struct {=0A=
> +			dma_addr_t desc;/* Pointer to completed descriptor */=0A=
> +			u32 jrstatus;	/* Status for completed descriptor */=0A=
> +		} __packed *outentry =3D outring;=0A=
> +=0A=
> +		*desc =3D outentry[hw_idx].desc;=0A=
> +		*jrstatus =3D outentry[hw_idx].jrstatus;=0A=
> +	}=0A=
>  }=0A=
>  =0A=
>  #define SIZEOF_JR_OUTENTRY	(caam_ptr_sz + sizeof(u32))=0A=
> @@ -246,9 +259,15 @@ static inline u32 jr_outentry_jrstatus(void *outring=
, int hw_idx)=0A=
>  =0A=
>  static inline void jr_inpentry_set(void *inpring, int hw_idx, dma_addr_t=
 val)=0A=
>  {=0A=
> -	dma_addr_t *inpentry =3D inpring;=0A=
> +	if (caam_imx) {=0A=
And here: if (caam_ptr_sz =3D=3D sizeof(u32))=0A=
=0A=
> +		u32 *inpentry =3D inpring;=0A=
>  =0A=
> -	inpentry[hw_idx] =3D val;=0A=
> +		inpentry[hw_idx] =3D val;=0A=
> +	} else {=0A=
> +		dma_addr_t *inpentry =3D inpring;=0A=
> +=0A=
> +		inpentry[hw_idx] =3D val;=0A=
> +	}=0A=
>  }=0A=
=0A=
Horia=0A=
