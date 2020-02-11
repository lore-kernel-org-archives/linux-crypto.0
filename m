Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CFFC35242
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 20:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81369206D6
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 20:57:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="qR9asT5p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731844AbgBKU5I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 15:57:08 -0500
Received: from mail-eopbgr10057.outbound.protection.outlook.com ([40.107.1.57]:2103
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728078AbgBKU5H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 15:57:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GioxEj8qRyQ7BhpyT7FSyQZUP6qA7YTxJUJJGpmNXBhYZIhsSf09rkRzqIBUW/zJwR9anPy66chVaWJtOLAtjHxxzHJE6HZsog44BVDUeaC+JpmDVELQahZGgTag6SWLPhppSpFRXn3uYmzWTcD8ezxybyIT1GwNL5aFiBgGpBWhUd/u0fEqhYn0Uh5KXAV9JhdGCa7+5OsT9+fqUhpJOcoslWfm8Fs/yl9eDsT28HHZjsLuBgoTzHv8Xmt39FmJYseTVCvBUXD9kS9Hh/GIOzAI9d+M8v1QVx9mqxODQ2qZmpX9b4waqO3PruWGlrRsXLGGCn+ce+NXtrzGP56gXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5FaFwZKlOiZqVx01x2vo6NrpwmGwmkdmJeErTwK78o=;
 b=jdtBElwrZerFuI0NinVMYPsP3e2Vcgujw4J+3O0llAmOftJLNWhUf/ht1PPvBidOdApUrbyLY22zJozq1xFaOQIC74kGaDHCf1ASxzgYNIjL0kO4Q711Q50cdb6T5VaymxQdMzqgLtXYeE/tVtT9oKOXo3dJ4LnUGK+xKDn3FoViB/Mg6xDPN5RlAGmam1ht9KI9cxRyLoyh+IvsQjUnFBvP8AN6VVBPe0JxvVeW/OEooAzgUXaZi6Cjmy8+1hQv509UgntxxozBXyLgWQmAFDc90rhhnWNcdtvtelhRrCGerfj3t1V2AjxjTzj7xpuVOWqwVQEx3ZmUK8M5yMFMbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5FaFwZKlOiZqVx01x2vo6NrpwmGwmkdmJeErTwK78o=;
 b=qR9asT5p1KmU6l7rjow66wWz7D5dggQ1CKAcRrhvH9BaVssQmEMBh1IvZWwP2A7njSJBZ+cBSNftGU0o6YyvBmdoUNIcctD1bePs9r7FovHtMWseF5tJQSG6vsJag+tyWXsVZ/JtNT9N+VNORFfnY0IFWpgYWdoqm6gkSFl/kSE=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3709.eurprd04.prod.outlook.com (52.134.15.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Tue, 11 Feb 2020 20:57:01 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 20:57:01 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v7 4/9] crypto: caam - drop global context pointer and
 init_done
Thread-Topic: [PATCH v7 4/9] crypto: caam - drop global context pointer and
 init_done
Thread-Index: AQHV1TLT2rTrmTBv2U6pvLOb9zqi1Q==
Date:   Tue, 11 Feb 2020 20:57:00 +0000
Message-ID: <VI1PR0402MB3485A733C0A6B57E129A339198180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-5-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 45b5f212-200a-4053-79f8-08d7af34f0e7
x-ms-traffictypediagnostic: VI1PR0402MB3709:|VI1PR0402MB3709:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3709BBD1925D4126C820138198180@VI1PR0402MB3709.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0310C78181
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(189003)(199004)(5660300002)(4326008)(478600001)(55016002)(9686003)(2906002)(52536014)(316002)(110136005)(54906003)(33656002)(91956017)(76116006)(66476007)(66556008)(64756008)(66446008)(44832011)(186003)(81156014)(53546011)(7696005)(26005)(6506007)(81166006)(86362001)(66946007)(8936002)(71200400001)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3709;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q22zIBnWCK7T09YgwxA09M3rBBGKC9qoJ3PB5OqEMTPNoexbjPfO6FmMKkjOegFEzVMbiovmkoWvKuqsHPzV8Xo46sBVO4jGnL9Vp/shSSg5WnDa0U/x1xREu8q5QSyTygjC69m7sPsuSZkCj/5l3tQ04uETkXVPETrAXpNEonp8N94PO8QAnidXyj5gATECjBAElvBvvqfQZl6p/jZCOsJF6FKKMfdz7Hi/97Byca6S3r3+/GUL+GNr4vQu96CPIrzCVW01vNqkqmkaUSQtHia2zXtcKKzLdK3qvQo0uW48vKr2MCPfV5oatr4vbsNVypVW9YL1S3gpuF2b5IKav3yPJIHBQM364BSESiGaNjgZhhNRW4c+ueyvzz9sS1/7WEcfK+Yayms8rqBL9YbOd8BDv61FeM90sNJxz+SDTEAPE/fZKe9yH23jsAGXhilP
x-ms-exchange-antispam-messagedata: UyvD1RAK7etgne3yhFZpKK263T4g9RquIhmDUrKRVp5r0NtwLsYDfydvsaxGFQPdOUGbbrW0UlNwewmotcMHUeR8IV7BaYzM+vRkyxAlNb8sDP59zpvt/6OkKnThJozZM1FY7yYsj7LuV9SUi4aMSg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b5f212-200a-4053-79f8-08d7af34f0e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2020 20:57:00.9947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ENu5nzjHiIowfGCdQmFl7oEsZjC1cIGBxTHS5/VspUv3iE3l+0wilxBkmNsMaW234El3RRtINZb3oZEQz3N9Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/27/2020 6:57 PM, Andrey Smirnov wrote:=0A=
> @@ -70,6 +70,7 @@ struct buf_data {=0A=
>  =0A=
>  /* rng per-device context */=0A=
>  struct caam_rng_ctx {=0A=
> +	struct hwrng rng;=0A=
>  	struct device *jrdev;=0A=
>  	dma_addr_t sh_desc_dma;=0A=
>  	u32 sh_desc[DESC_RNG_LEN];=0A=
> @@ -78,13 +79,10 @@ struct caam_rng_ctx {=0A=
>  	struct buf_data bufs[2];=0A=
>  };=0A=
>  =0A=
> -static struct caam_rng_ctx *rng_ctx;=0A=
> -=0A=
> -/*=0A=
> - * Variable used to avoid double free of resources in case=0A=
> - * algorithm registration was unsuccessful=0A=
> - */=0A=
> -static bool init_done;=0A=
> +static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)=0A=
> +{=0A=
> +	return container_of(r, struct caam_rng_ctx, rng);=0A=
> +}=0A=
[...]=0A=
> -static struct hwrng caam_rng =3D {=0A=
> -	.name		=3D "rng-caam",=0A=
> -	.init           =3D caam_init,=0A=
> -	.cleanup	=3D caam_cleanup,=0A=
> -	.read		=3D caam_read,=0A=
> -};=0A=
[...]> +	ctx->rng.name    =3D "rng-caam";=0A=
> +	ctx->rng.init    =3D caam_init;=0A=
> +	ctx->rng.cleanup =3D caam_cleanup;=0A=
> +	ctx->rng.read    =3D caam_read;=0A=
An alternative (probably better) for storing caamrng context=0A=
is to use what is already available in struct hwrng:=0A=
 * @priv:               Private data, for use by the RNG driver.=0A=
=0A=
Horia=0A=
