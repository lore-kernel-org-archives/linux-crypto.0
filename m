Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42288C352A3
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 09:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6878206D7
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 09:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="O3mHA/19"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBKJvZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 04:51:25 -0500
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:29702
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727947AbgBKJvZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 04:51:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTWSbDPHxyM8TH54eKRefePnxhm13gE/JmTSGrM9dWXit8ZB0qT3ZJzh8UbhuDT4ahSFv0F9zqCKFl5mbjCOmoPwLZ61d5Awl87VhDODOwYXZylq6wUg9plcrSy+ghfnqoM9+FQjM/ZciNlXzWvGG6XjTM4FVTVgShRjeFTXW/p8wQ4eXONsTcrpixnF26wACAKER7ZzHqej4CB2n4XkyJ8UgDhQY+p4NhKTcFfBp6AQZUUv4vv+2EqHAIlT3+CkMBC0WTEJR1hmEW2pJnFHnRQNFbE3cOZOH0l0JaV7Fylxqtmr4iPEFoAIxdYSlLzI4bGviWpGwTuNwRbaK0Z3Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Due0pS6A0vooP9mgN6gP2+0SZTxxDQO3DpDfxXSEBlI=;
 b=cO5fzBZzbj1UbFvNMk1tAN29LIQas95WtKFRvhWnFDvw9JkZdzn2hdv9MQjl+dhH3LsJfYQoa/5cqmqU65QBCrBOPFDmh7DF4q3o6t/0l9wgqkZssAKZSeDxz3rwZvWOiqaOJiJKjwVwoQVGwaKE8ixwQLAg/LSTQ8e4u3pfSn+UH4T8yz5HESXpL3J9sPI0ed3PC4gLR19si4eAQakl6guz43T4JEZaY1xIwQuUyvtCFoYqswl3TUke0Ma5J4uXL/kIoo0Q1Fb2wHpgk+Co28r1w1Q+Olr7J4U3t38JDQVP7JxLT/Vn9dwSgZqoqy4nrBF06WZF3vWI6z6m+QeS+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Due0pS6A0vooP9mgN6gP2+0SZTxxDQO3DpDfxXSEBlI=;
 b=O3mHA/19J/ub05cgYWPJdevP4MJru4WG2YgJDOb1TTJ2yPK7Qxn+3ThW5AtVY790n4g4eDBEjQRwAv+Pkmjoc25S5eNjkjHdNIqMDxLn615d+10DKaSbUtTnE3TqNqBUSprlmFTMwjRDSh1R4n0A24o+o3z7i0J1Qw5n15yDRz0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3440.eurprd04.prod.outlook.com (52.134.3.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Tue, 11 Feb 2020 09:51:20 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 09:51:20 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v5 6/9] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
Thread-Topic: [PATCH v5 6/9] crypto: caam - support crypto_engine framework
 for SKCIPHER algorithms
Thread-Index: AQHV1wcr0m0Ki7Td90i9OY9gtILG6A==
Date:   Tue, 11 Feb 2020 09:51:20 +0000
Message-ID: <VI1PR0402MB3485F56EEA82139A2BCF698F98180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1580345364-7606-1-git-send-email-iuliana.prodan@nxp.com>
 <1580345364-7606-7-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 95a6e84b-2e8c-45ee-02bf-08d7aed7f2aa
x-ms-traffictypediagnostic: VI1PR0402MB3440:|VI1PR0402MB3440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3440428DACD430F1CFE4A0F098180@VI1PR0402MB3440.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0310C78181
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(199004)(189003)(6636002)(54906003)(91956017)(110136005)(6506007)(53546011)(86362001)(76116006)(2906002)(478600001)(316002)(26005)(44832011)(4326008)(81156014)(8936002)(5660300002)(52536014)(81166006)(8676002)(186003)(7696005)(33656002)(66446008)(64756008)(66556008)(66476007)(66946007)(71200400001)(9686003)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3440;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ek+6UIFh7PcbOU50tQCU3PHw87au0XTdm2u5kttDL/8API4CjipAEYvFDUrRTnMltC3i4G/BdDxP2lr3/f1714xcWyamyaYSWE1OkhwexSyV+tpfD0IwC6h5HCvqKpY9TuXFpxwLkwZwSig68fE+w/tsbB639dWyG4sXLt6zT9/0cuB1tJWvlAqvq4xOIM7NHUE3LzfGuCmvITv8h2VoexwQkuTPy4BA5zxnVVLoojhBCi0XWp4iNowxc6Y9pBjGx52P2hugw9Qo47rkxB1vvqL1WuzwvwUrjJSm+geOZoAiPTBP98QXdVkBQiFbaQoS1n4Xf0DjipOH5vtkEn+2r3ujfy/FPlej2vTlwEL9xyDK+BmbmT/UZJES0JeKoJPsoZ5aVS36DRCODIqNrFbWvDxh4ZyYE66ZHNgDBMuXhG3okd03C07wiaWOwRuwDkpX
x-ms-exchange-antispam-messagedata: qjnKcDXOwEz3e9vq06eVsltV16Kn/iJ/C4q42jI3Ic6liqR8YUQc4Sd5SG9lu674tcdXyNqYRE3o7wdlKnJupuflSukdkiGEn8nXRdFpfCqP4frk5TV3hoe2zobPBzGHXn7+cg/9Tk/eCNk52DMF5w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a6e84b-2e8c-45ee-02bf-08d7aed7f2aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2020 09:51:20.7414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haZCj0f7iRnS5v2x+DI6QY2S8GXaGXagvqbIXCT32rmzdPiOpDZfaJuaw85U4TqIOM52CUD4u+vS3wGdOxHQpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3440
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/30/2020 2:49 AM, Iuliana Prodan wrote:=0A=
> @@ -1618,6 +1636,8 @@ static struct skcipher_edesc *skcipher_edesc_alloc(=
struct skcipher_request *req,=0A=
>  	edesc->sec4_sg_bytes =3D sec4_sg_bytes;=0A=
>  	edesc->sec4_sg =3D (struct sec4_sg_entry *)((u8 *)edesc->hw_desc +=0A=
>  						  desc_bytes);=0A=
> +	edesc->bklog =3D false;=0A=
Since edesc is allocated using kzalloc(), this is redundant.=0A=
=0A=
> @@ -3236,7 +3288,9 @@ static int caam_init_common(struct caam_ctx *ctx, s=
truct caam_alg_entry *caam,=0A=
>  =0A=
>  	dma_addr =3D dma_map_single_attrs(ctx->jrdev, ctx->sh_desc_enc,=0A=
>  					offsetof(struct caam_ctx,=0A=
> -						 sh_desc_enc_dma),=0A=
> +						 sh_desc_enc_dma) -=0A=
> +					offsetof(struct caam_ctx,=0A=
> +						 sh_desc_enc),=0A=
>  					ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);=0A=
>  	if (dma_mapping_error(ctx->jrdev, dma_addr)) {=0A=
>  		dev_err(ctx->jrdev, "unable to map key, shared descriptors\n");=0A=
> @@ -3246,8 +3300,12 @@ static int caam_init_common(struct caam_ctx *ctx, =
struct caam_alg_entry *caam,=0A=
>  =0A=
>  	ctx->sh_desc_enc_dma =3D dma_addr;=0A=
>  	ctx->sh_desc_dec_dma =3D dma_addr + offsetof(struct caam_ctx,=0A=
> -						   sh_desc_dec);=0A=
> -	ctx->key_dma =3D dma_addr + offsetof(struct caam_ctx, key);=0A=
> +						   sh_desc_dec) -=0A=
> +					offsetof(struct caam_ctx,=0A=
> +						 sh_desc_enc);=0A=
> +	ctx->key_dma =3D dma_addr + offsetof(struct caam_ctx, key) -=0A=
> +					offsetof(struct caam_ctx,=0A=
> +						 sh_desc_enc);=0A=
Let's make this clearer by using a local variable for=0A=
offsetof(struct caam_ctx, sh_desc_enc).=0A=
=0A=
> @@ -538,6 +547,26 @@ static int caam_jr_probe(struct platform_device *pde=
v)=0A=
>  		return error;=0A=
>  	}=0A=
>  =0A=
> +	/* Initialize crypto engine */=0A=
> +	jrpriv->engine =3D crypto_engine_alloc_init(jrdev, false);=0A=
> +	if (!jrpriv->engine) {=0A=
> +		dev_err(jrdev, "Could not init crypto-engine\n");=0A=
> +		return -ENOMEM;=0A=
> +	}=0A=
> +=0A=
> +	/* Start crypto engine */=0A=
> +	error =3D crypto_engine_start(jrpriv->engine);=0A=
> +	if (error) {=0A=
> +		dev_err(jrdev, "Could not start crypto-engine\n");=0A=
> +		crypto_engine_exit(jrpriv->engine);=0A=
> +		return error;=0A=
> +	}=0A=
> +=0A=
> +	error =3D devm_add_action_or_reset(jrdev, caam_jr_crypto_engine_exit,=
=0A=
> +					 jrdev);=0A=
> +	if (error)=0A=
> +		return error;=0A=
This should be moved right after crypto_engine_alloc_init(),=0A=
and crypto_engine_exit() should be removed from=0A=
crypto_engine_start() error path.=0A=
=0A=
Horia=0A=
