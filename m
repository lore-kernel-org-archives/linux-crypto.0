Return-Path: <SRS0=1Cfx=ZR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB812C432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 07:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D8C320815
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 07:50:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="eizX+00F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbfKYHuB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Nov 2019 02:50:01 -0500
Received: from mail-eopbgr30064.outbound.protection.outlook.com ([40.107.3.64]:13710
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbfKYHuB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Nov 2019 02:50:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbuUIjCvpxEEzmGZBMl27ank2Qk7nhSseicG1/agiuCR69+MI1140HrvoaGYDTa8MdWKlHCfGbFfRr0vlo5+rurxi870eCY1mCuoXEb7lf0Zq3ZOM6KfLHnFgfrMtybNu89hCdJbn8uPab37dKIzDIToSjp63XZly+qmJZHbj4h4BGlZOD4e5qNWlfYjMvi/jpMIHxmXNcw2KqxRdnV8h3+uxmg1Avilde3jdDuVV16Mz2h4juIwfINflfHkAg/yEIxb1V3d/WLoosEe+IlHA30nl8Vdggr9YRx3HUh3kM2FHd8jouv9Kcwe1lXf0wKlJ3hBT9rp567atE/dgL/d3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWbyor9pteCdGi3HGZeT+lYMBrvfwijqQ81TMY7rkoU=;
 b=XqOhmb4TtzXyyNKM+BPY/WwMtRaEZtPBl4ZUrmAWVxoQPSkTe8XL5bdPhCahqS4c3extUPmq0VaW+P0MtSkh0GZ5WdEiiV1LeJb75Z5/PuPSiIs/1qYRudWQ8xCjlwFUrIDjroJbvDLihJxsPjX0tAaYYCJ86P53k+OtSh7DzKxIEgYkm+L4Mtyq/b90cIiuGZPpNgTOHaE7nM5v530e538zfuCbAV6W0I2EHcpMN8LBNqMMgtlzDvY4oEfYOjKEMIxbfp2x4sjVgVgzNDvypxPxvEC80zwxBrQaLyx7Kyfz9SOS7xXyN/v70jYeciEfphyxCxEvCATqPWtYVSwgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWbyor9pteCdGi3HGZeT+lYMBrvfwijqQ81TMY7rkoU=;
 b=eizX+00FfRDU3ET6CnIuzQsMuBkDNiI7Hl1Ibal2AMBKcXvRj4syQEoYYSDdKokw8mUw8pSqzgNq7f6PvuOnxxKrd+chkgRtfP6QuzUxhJFvwQX+0BHabPXXQSMtcyEA3ZYUQ3qWa8485A/974gwlZ+cRWpgc5wDnHyj+i/tCD4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2765.eurprd04.prod.outlook.com (10.175.20.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Mon, 25 Nov 2019 07:49:55 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 07:49:55 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Alison Wang <alison.wang@nxp.com>
Subject: Re: [PATCH] crypto: caam - do not reset pointer size if caam_ptr_size
 is 64 bits
Thread-Topic: [PATCH] crypto: caam - do not reset pointer size if
 caam_ptr_size is 64 bits
Thread-Index: AQHVoxctUNzeX8yZBkC+zm/l8nUrRQ==
Date:   Mon, 25 Nov 2019 07:49:55 +0000
Message-ID: <VI1PR0402MB34857C5B83AC9811BB87F419984A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574634784-10571-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8ef7e74e-e43f-4b28-20d4-08d7717c0fd3
x-ms-traffictypediagnostic: VI1PR0402MB2765:|VI1PR0402MB2765:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB27659A09DA37327D18A7DAFA984A0@VI1PR0402MB2765.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(189003)(199004)(66556008)(64756008)(66446008)(6436002)(66066001)(102836004)(3846002)(6116002)(478600001)(305945005)(53546011)(316002)(229853002)(7736002)(6506007)(55016002)(71200400001)(71190400001)(76116006)(6636002)(91956017)(44832011)(26005)(14454004)(66476007)(186003)(99286004)(81166006)(110136005)(33656002)(14444005)(256004)(8936002)(6246003)(5660300002)(4326008)(74316002)(25786009)(8676002)(2906002)(7696005)(81156014)(446003)(9686003)(86362001)(76176011)(54906003)(52536014)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2765;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?lCZECdh9NAPOVvCk4jGwMUdkgxIXHRKXv1HvtKV231wYGJblnoaVGqIYmVIy?=
 =?us-ascii?Q?ZFyIffSLKvCwhVjpGFDu3W15CwZfiG8EYHzmpg5yXb/6/ZiSbQ/l2GEGKdgo?=
 =?us-ascii?Q?+eVUy2qM+hDRMp5rkv4MUWI3dcR0AFsHQgnyKNpZ8HytRW3xQwkQoqq1y8cw?=
 =?us-ascii?Q?aXHtxZOUuZR093mvSsKqanmyLWzgQ3JAXhGH63zjJJRq03M164ZBm5cHxF4t?=
 =?us-ascii?Q?1lvNcIPJWZulh1Yq0/7B7lh+NjmeFsE66iWqMK43FKin+6rDzj/jGiCDfaeD?=
 =?us-ascii?Q?D6CXG+xiD1sQpGwvac3hF70TZ/rNZmktDMIXl22JQGYV8CssGXKReoi8VGGD?=
 =?us-ascii?Q?v5Ud33dL6ARb8kg9GApGQj2VNemSV5Px1mL+MCl6+oZ3c3wib+8578pwyzqb?=
 =?us-ascii?Q?SjKKVswd7jLhw49nxrqHcSRSHAGwrVaPJgJgIVn1CVn2VofmbgADncUm5VEf?=
 =?us-ascii?Q?7GU6zA+pG6R99ST5UiEDp9I2Yc5htA08YHn5yj6jmiH41kW+e5YMcN3+KTaS?=
 =?us-ascii?Q?43EBj7gsQ+laLKo9N8UqNlviIHXQG8v0CDrQOlwhf5PMiQM27RP+AQzLqIRB?=
 =?us-ascii?Q?qrdGqkdp2psLxDn1+t6d/ev2lUZDxFMoYj9nr5j2fUJZRMHZWitA9IfaYd2i?=
 =?us-ascii?Q?0NG2oxq6gtOjYTZZ3OMk1WAGDiioDev8qL/IzAw4d43GXBJckzajys3TtRil?=
 =?us-ascii?Q?LlkLFD1CU6vkSnR8iRWvU7mjEyk3PtC8zM1M4wmCKihld9AXGm8Fnt8m7ndk?=
 =?us-ascii?Q?CNaZCluwTyF6JEdyJuB2Z24WMbB/YOJfImqePJRxoele112vav8a6Ej6jKqs?=
 =?us-ascii?Q?KcdiTdcUEt5gHCv6hx+cBSgYqP+w7qOSvWTYwkj1uSB0jHib5S/QVUXGsg8K?=
 =?us-ascii?Q?fHfc41BNWxlk91J4NORm9B03QEfhusIPk7nlcy2XvlqgdmmrUXNkfOT+w4S2?=
 =?us-ascii?Q?ZhYmEgoP0CGWTu0ubY8fzDGXUoOtVGskUVEszT2jk9EBy3R7WtFmOo5hX1kI?=
 =?us-ascii?Q?tR9YPiYSZGPzzHlbbFFwSc4akJ+O2l7xO8qsPtnXi7fX4mbW0OF7KVpP2agK?=
 =?us-ascii?Q?eMLqkQYctxY4UDt7WXfA9mAM0dgR+HmXGNanZb28XfREjmtxZ07l7IvVROxN?=
 =?us-ascii?Q?Tw59VNk31cOoqiEebmx57B/YL0IS/aWgApTwfIZ5vrcHKERmt7WYtvSED0Dx?=
 =?us-ascii?Q?AXz6OgO8wwrDF6KBSGxsl0TLttdfLxnV1CPrDYZVp39BVg9roOybLfHCp4VG?=
 =?us-ascii?Q?XlkYuXbsGzKzd9GTYhiQYbHSKU3DEVzzMzb6QN62rupXhuIx7io9hLtG4aLf?=
 =?us-ascii?Q?lNTVU13gFip3ANSYVbZ3rAcgohMHNecOgJt+GDMDYprm+tdyuqNT9qW10qnq?=
 =?us-ascii?Q?ufa83c5qYJAoVqhCOVSpdM3rCanv/+0DSz9XtlgD4rzbXztJsLWMGS0AA9Sa?=
 =?us-ascii?Q?1jxWV1V2MLrAV9CzD1yeIUzKUeZ0vD3N6f+kG8IP+iZ+sq1X2oB5uYtqDM1N?=
 =?us-ascii?Q?sCCUQH/iU4C0ibk7/SZnRPlgT88Ram+Rgv15ROXl4TLwiarabm1t7rE/lkZ9?=
 =?us-ascii?Q?NRdfJ7kakyeqgE7FignreOORRJQKx215Vzh0DVCfn2hdHzDeH25WmMCBTEBo?=
 =?us-ascii?Q?WkO51Q13sk25heZRJDtYp5CJm3bq1nQnNDVHZ1yVNq7UHFEen6/jTXlkc7dH?=
 =?us-ascii?Q?WRX+iLJQTdZGftngB/dE6FEVt2xQeSA0GMKcB+Zo9gjZ0OUGFELOQPhWCLbd?=
 =?us-ascii?Q?bd0zFnD323Dtgay0p9UrX5wjwQBKmSnvgC0CztsTcZQgqwiH8G6MVbd0Q+rC?=
 =?us-ascii?Q?4f//HHtGeAtyIw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef7e74e-e43f-4b28-20d4-08d7717c0fd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 07:49:55.0673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HRU4FHwrdCR9v1eeHpxNHrvrUD8yInkQ5nPJqMONRDzt0cb8EwisyLAmNyloKzCHUm//nFlQgl6y1CS+u/w5kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2765
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/25/2019 12:33 AM, Iuliana Prodan wrote:=0A=
> In commit 'a1cf573ee95 ("crypto: caam - select DMA address=0A=
> size at runtime")' CAAM pointer size (caam_ptr_size) is changed=0A=
> from sizeof(dma_addr_t) to runtime value computed from MCFGR register.=0A=
> At some point, the bit for Pointer Size should be reset to 0,=0A=
> but only for the case when the CAAM pointer size if 32 bits.=0A=
> Therefore, use caam_ptr_size instead of sizeof(dma_addr_t).=0A=
> =0A=
The logic is circular, see below.=0A=
=0A=
> Fixes: a1cf573ee95 ("crypto: caam - select DMA address size at runtime")=
=0A=
Please Cc the author(s) when adding Fixes tag.=0A=
=0A=
> Cc: <stable@vger.kernel.org>=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> ---=0A=
>  drivers/crypto/caam/ctrl.c | 2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c=0A=
> index d7c3c38..786eef6 100644=0A=
> --- a/drivers/crypto/caam/ctrl.c=0A=
> +++ b/drivers/crypto/caam/ctrl.c=0A=
> @@ -674,7 +674,7 @@ static int caam_probe(struct platform_device *pdev)=
=0A=
>  		clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK | MCFGR_LONG_PTR,=0A=
>  			      MCFGR_AWCACHE_CACH | MCFGR_AWCACHE_BUFF |=0A=
>  			      MCFGR_WDENABLE | MCFGR_LARGE_BURST |=0A=
> -			      (sizeof(dma_addr_t) =3D=3D sizeof(u64) ?=0A=
> +			      (caam_ptr_sz =3D=3D sizeof(u64) ?=0A=
>  			       MCFGR_LONG_PTR : 0));=0A=
>  =0A=
Before this in caam_probe() there's:=0A=
	if (comp_params & CTPR_MS_PS && rd_reg32(&ctrl->mcr) & MCFGR_LONG_PTR)=0A=
		caam_ptr_sz =3D sizeof(u64);=0A=
	else=0A=
		caam_ptr_sz =3D sizeof(u32);=0A=
=0A=
thus caam_ptr_sz is determined based on MCFGR:=0A=
MCFGR[PS] =3D=3D> caam_ptr_sz=0A=
so it no longer makes sense to reconfigure MCFGR based on caam_ptr_sz:=0A=
caam_ptr_sz =3D=3D> MCFGR[PS]=0A=
=0A=
The short-term fix would be to no longer touch MCFGR[PS], which is in line =
with=0A=
commit a1cf573ee95 ("crypto: caam - select DMA address size at runtime")=0A=
=0A=
Note however there's a small issue with the logic of kernel relying on=0A=
MCFGR[PS] being previously configured (by U-boot etc.), see=0A=
commit 39eaf759466f ("crypto: caam - fix pointer size for AArch64 boot load=
er, AArch32 kernel")=0A=
=0A=
In the long run, IMO the proper thing for the driver to do is to rely,=0A=
whenever possible, on DT ("dma-ranges" property) / dma_mask provided by=0A=
the device driver infrastructure, and not on MCFGR[PS]:=0A=
[ DT "dma-ranges" =3D=3D> ] dma_mask =3D=3D> MCFGR[PS], caam_ptr_sz =0A=
but that would probably involve too many changes for getting into -stable.=
=0A=
=0A=
Horia=0A=
