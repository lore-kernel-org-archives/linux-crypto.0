Return-Path: <SRS0=KDyu=3C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FF0C33CA8
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 09:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98D9A2080D
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 09:41:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="OicGA1dL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgAMJlv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jan 2020 04:41:51 -0500
Received: from mail-eopbgr50083.outbound.protection.outlook.com ([40.107.5.83]:41550
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbgAMJlv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jan 2020 04:41:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2BavV0W0+wV3fQdR3tvMN9mLvKVqscJ+kHnnrFNJVQNLkUsJEYSkqPVfBgnyhCIeObXJhvfg7+S2xLrn9mauD0J3WlpXTrfolixDufKLtjjgbgxRgOHZzVhNdgyhz80DVa3oTlemj23szj61BB6fpSc5hOXT2KnwaVWWnkQqtx63d3O3AYPyfWbLcUexZTw6Y/iFMQvEi7Ia9I4/9y4ChD6BiraiytRM71pm85rMHEBT3bhlbkNUrHJuF6MJRybFVWmekG+AVt8suu/Un8wMO/+2OdX+T2Wqg5p4wfD7vw4J/oYCChQWDH0VX6nLnUf/nfyglGB/iwjGJX+ScDY4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3r+jATN8vMlxq+TdVqp/qk6QFOmIjNHIT0zH94l59c=;
 b=iPu4FB5RjDNr1daqalm3NJAXZxjr/89L6mmlHQjzNyxq163MjtEDISddM2uR2MOPcFVLAG3vYAMzQBCuVBt3QG9pee2i8uvZg+PgzEBfIeXT5yspOH7kfWUI05sSLY1g0jvu2IyaCOQoT+7OCsJ7MwuaPg8NBu1m4BppyTVtkmP0JCEG6eiRUL5Hw+oNYsB85exCVj1mRIkYsEWkeF0Lf0Oe5wc3dIpi2AqaOs9Ys6cmhNJzpUg5Mar0yqVd704Ykln8s+AXltBNORFenRwsabh57D0ZGGKRnsJLx+y9pU7HLWIP0HsnAIEuuQsbYMUelFdjzsWjoL2kHAzRJepN4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3r+jATN8vMlxq+TdVqp/qk6QFOmIjNHIT0zH94l59c=;
 b=OicGA1dL3CNxzJUlGLgQ+Z7OGL/Ggz/x3I0XRipvUcVYe12Gm3QF7edVsvVG0GvAmKgDHTsaJVh+0hJ8OU5xo/8wgLWa+OHjnt3f6fIeqLBT6B2h+ga+yL9E4Js4/iW1SnGNcEo/H0GILH0T2SZzT0+0dv2gDswJTE0DsgCMLWI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3342.eurprd04.prod.outlook.com (52.134.8.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Mon, 13 Jan 2020 09:41:47 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 09:41:47 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 2/7] crypto: caam - drop global context pointer and
 init_done
Thread-Topic: [PATCH v6 2/7] crypto: caam - drop global context pointer and
 init_done
Thread-Index: AQHVxjorybhrSXCVfEWf2tbJo513AA==
Date:   Mon, 13 Jan 2020 09:41:47 +0000
Message-ID: <VI1PR0402MB3485A38A9A71500E632191AD98350@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
 <20200108154047.12526-3-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0dd421a7-c854-411f-21fa-08d7980ccf2c
x-ms-traffictypediagnostic: VI1PR0402MB3342:|VI1PR0402MB3342:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB334210E3925704AB297781F098350@VI1PR0402MB3342.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(189003)(199004)(8676002)(2906002)(81156014)(66476007)(91956017)(76116006)(54906003)(4326008)(110136005)(44832011)(478600001)(66556008)(81166006)(316002)(8936002)(66946007)(66446008)(64756008)(7696005)(5660300002)(86362001)(26005)(33656002)(71200400001)(6506007)(53546011)(52536014)(9686003)(55016002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3342;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nN560O4rVYojNGA4pL04kWfgQBtBffJpfnTT+supTgUCpYuBqIg/FtqSbTu6k7h/l2M7eKusNdNNjcOgA3UA/+elZJEqshbIKzECJf/ejRp1f4a01tNNrVsjD1hSSFsIlWIYZKXt+ul69H9VXnXsSS49PoRFRPczLcmDBp/bmTJbTvux9mzVaP/uI2g8dKAz0K462kiQQZeudUFXciWAjtPPYB+10Uub8pesVD1l7aFfB+snvc2cxhnD8J4SSx0rUlrT8nWLqfHL7hfXG3/3J14fIu3ZuFZ+QNlmbgpgJB8CzzpWp0WTNQ+DU++8A2KpKWO+evOcxMPAvs5OzLASPyiX/K2hTceB9QB9TAc0oK0h46xA1pU3JfLCUO1AB7mmBatGdsaDUpPgQJVyzHkITZVjbX7NPhTENDBfKxv9SLdQjKidp9+5QCzf7vobwQuN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd421a7-c854-411f-21fa-08d7980ccf2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 09:41:47.8260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5C5eUl1subrNY7kEieizAykIRN3eTSSfUXnye6GZQxBM+SNAK2LVeAEZdsSLswmYDkvNCPOIbs7sNibeM99Y+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3342
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/8/2020 5:42 PM, Andrey Smirnov wrote:=0A=
> @@ -342,18 +324,16 @@ int caam_rng_init(struct device *ctrldev)=0A=
>  	if (!rng_inst)=0A=
>  		return 0;=0A=
>  =0A=
> -	rng_ctx =3D kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);=0A=
> -	if (!rng_ctx)=0A=
> +	ctx =3D devm_kzalloc(ctrldev, sizeof(*ctx), GFP_DMA | GFP_KERNEL);=0A=
> +	if (!ctx)=0A=
>  		return -ENOMEM;=0A=
>  =0A=
> -	dev_info(ctrldev, "registering rng-caam\n");=0A=
> +	ctx->rng.name    =3D "rng-caam";=0A=
> +	ctx->rng.init    =3D caam_init;=0A=
> +	ctx->rng.cleanup =3D caam_cleanup;=0A=
> +	ctx->rng.read    =3D caam_read;=0A=
>  =0A=
> -	err =3D hwrng_register(&caam_rng);=0A=
> -	if (!err) {=0A=
> -		init_done =3D true;=0A=
> -		return err;=0A=
> -	}=0A=
> +	dev_info(ctrldev, "registering rng-caam\n");=0A=
>  =0A=
> -	kfree(rng_ctx);=0A=
> -	return err;=0A=
> +	return devm_hwrng_register(ctrldev, &ctx->rng);=0A=
This means hwrng_unregister() is called only when ctrldev is removed.=0A=
=0A=
OTOH caam_rng_init() could be called multiple times, e.g. if there's only o=
ne=0A=
jrdev left in the system and it's removed then added back.=0A=
This will lead to caam_rng_init() -> hwrng_register() called twice=0A=
with the same "rng-caam" name, without a hwrng_unregister() called in-betwe=
en.=0A=
=0A=
Horia=0A=
