Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2E3C33CA2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 08:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B418F2072A
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 08:13:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="UOl/LM/s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgAJIND (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 03:13:03 -0500
Received: from mail-am6eur05on2040.outbound.protection.outlook.com ([40.107.22.40]:6095
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbgAJIND (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 03:13:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJNDRLExtiCAhG07pks7KfV7MOnfL4MtBhS7uuq7BbSUFhvKIbCoBHQyPkZ6d6cjY1ZdnqrWuxafpyTEHBPA4ewJ9WaQgob1qK2u9F41d7oLBBoF1tmJ+sNvROrnjPEK5ChWjaNC1O3qLQrWcXCrg/TkPNUdN5rjqW/1CE+LSrCoZUk3jSKVcyyXNf9rCRbGwEnV6YpHNVqYBguftV1iVWmlgLOuPaIbiB+GspbY4vA/6MF4NsZZ9kXaIj3T2g405u2+ONA/UCQkryTbP0KSh9FuDJTPPKalYswVVG6eBu2Q/iaKyw95iDew3J75G1yrRwJly69Cye3bPUUUNmUNFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+W9wKCgZjtjfs8sMZzI0jbTd/L/r0MSp4pJXT78fYgo=;
 b=F9cX8E3qf7MqwF9Mxoc2c7XqKM8Fs8FRjqYzVDwlZi/7McTSlaYxeHrN9uY60YqjokSLCdqWxRUd+5iD6D1K2GwGwSf678bZVf1imi+65H3SduppYVQWg6/AfAK8XIY4/Gq+tJPk/Gw+OdnsagqkFhqsOAGYwaj2wxuio2dSiqSmAj/zDHW2QGWpCbmkY10CVemlg+w8rpU8oL4UdXL9xSnX8+LDhzpUC1clmcgarnzNS7vZ5mcJfiVm6BrNolOzZMor1sfOa2nxUOlVkOvDUjY7hJ5sgudhXShbjXWVzzV8rMjKq00NUyfZiuYo208TVaSDJyd/Jy/gmbfAJRut3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+W9wKCgZjtjfs8sMZzI0jbTd/L/r0MSp4pJXT78fYgo=;
 b=UOl/LM/sYqcaQkY0WgF5cJiNdi87OMboowPwKEIAwbz1Qox5nn8tVn6JDLpbjMMkPTdFYznMwObdO8fNQmLrQSyANjlSyUzwDdYttF7ACAzeJfFy0Myk+rkRZYlTkSvEQqw5iwGM4x8YAdFntYOXSqgAIhmTF7O8dREH+7qBHUU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2814.eurprd04.prod.outlook.com (10.172.255.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.8; Fri, 10 Jan 2020 08:12:59 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2623.011; Fri, 10 Jan 2020
 08:12:59 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 07/10] crypto: caam - support crypto_engine framework
 for SKCIPHER algorithms
Thread-Topic: [PATCH v2 07/10] crypto: caam - support crypto_engine framework
 for SKCIPHER algorithms
Thread-Index: AQHVwdGqM0qwaleo9Eyqk6LOOqe5nA==
Date:   Fri, 10 Jan 2020 08:12:59 +0000
Message-ID: <VI1PR0402MB3485B7BC37DFEB1CF264D26E98380@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
 <1578013373-1956-8-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8f61dd13-872c-4752-860a-08d795a4e7f6
x-ms-traffictypediagnostic: VI1PR0402MB2814:|VI1PR0402MB2814:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2814C687438399EDB3F835B698380@VI1PR0402MB2814.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(189003)(199004)(51234002)(52536014)(5660300002)(76116006)(44832011)(53546011)(91956017)(4326008)(66446008)(9686003)(66946007)(66476007)(64756008)(66556008)(55016002)(71200400001)(33656002)(6636002)(2906002)(6506007)(316002)(8936002)(26005)(86362001)(7696005)(8676002)(54906003)(478600001)(110136005)(186003)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2814;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SgC7UbsZ33WzQa5d7KYZN8MK3xwiPMEwprwj5ojurFoRAm9OzqMOoEsUItUdHQyMG60f1wrOGKqEqJpPZIEmXA5beI555jr3UnIal46SLsUsf6A0/xoBLPcNA2HPyC2BSpI5bRuab+L0qVa/TFnriu4rqdaPvX54Hq+j40EaKVAe41z04icTC1RomlAhm2lZ3HDrVP1lwc+rUKPfoP1uUWJHhRNOBKMlf/KqQ4F4oPrA1BcNbYTFffOWxIqMOmk4fwNDPLqBnZ3CAReXUoCBII0mutzgPma3yahu/rJSo6SKjH8D9KwI+BjHUULvuQlC8fpDAeQl2hBTajAZQ+mXu5HkiOjtbVpk4EA7V20q7Awe/fyBxiq9xI61Mm7Lxy75wAP5zNCH/16Hrfcszh7Abin2GewfWaSvV1Hu/BOqm5CkFuQjbWGRZ2IjN3G6JbJDOfM5AzEkbKPOluSTMnGBZ1tPzox2/L9LYvK42SNWKhU/7Rlw7Z2Q61bBIjbRfyzH
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f61dd13-872c-4752-860a-08d795a4e7f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 08:12:59.4073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UiX7VQbfEWL52710VOw7y3OdrVoTlloGDMHD4iZEUdwRaeEPxMFzHWlRvc+agxC7YBft7EUif2V1WW99iTcXUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2814
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/3/2020 3:03 AM, Iuliana Prodan wrote:=0A=
> Integrate crypto_engine into CAAM, to make use of the engine queue.=0A=
> Add support for SKCIPHER algorithms.=0A=
> =0A=
> This is intended to be used for CAAM backlogging support.=0A=
> The requests, with backlog flag (e.g. from dm-crypt) will be listed=0A=
> into crypto-engine queue and processed by CAAM when free.=0A=
> This changes the return codes for caam_jr_enqueue:=0A=
> -EINPROGRESS if OK, -EBUSY if request is backlogged,=0A=
caam_jr_enqueue() is no longer modified to return -EBUSY=0A=
(as it was in v1).=0A=
=0A=
> -ENOSPC if the queue is full, -EIO if it cannot map the caller's=0A=
> descriptor.=0A=
[...]=0A=
> +struct caam_skcipher_req_ctx {=0A=
> +	struct skcipher_edesc *edesc;=0A=
> +	void (*skcipher_op_done)(struct device *jrdev, u32 *desc, u32 err,=0A=
> +				 void *context);=0A=
skcipher_op_done doesn't seem to be needed, see below.=0A=
=0A=
> @@ -1669,6 +1687,9 @@ static struct skcipher_edesc *skcipher_edesc_alloc(=
struct skcipher_request *req,=0A=
>  						  desc_bytes);=0A=
>  	edesc->jrentry.base =3D req;=0A=
>  =0A=
> +	rctx->edesc =3D edesc;=0A=
> +	rctx->skcipher_op_done =3D skcipher_crypt_done;=0A=
skcipher_op_done is always set to skcipher_crypt_done...=0A=
=0A=
> +static int skcipher_do_one_req(struct crypto_engine *engine, void *areq)=
=0A=
> +{=0A=
> +	struct skcipher_request *req =3D skcipher_request_cast(areq);=0A=
> +	struct caam_ctx *ctx =3D crypto_skcipher_ctx(crypto_skcipher_reqtfm(req=
));=0A=
> +	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx(req);=0A=
> +	struct caam_skcipher_request_entry *jrentry;=0A=
> +	u32 *desc =3D rctx->edesc->hw_desc;=0A=
> +	int ret;=0A=
> +=0A=
> +	jrentry =3D &rctx->edesc->jrentry;=0A=
> +	jrentry->bklog =3D true;=0A=
> +=0A=
> +	ret =3D caam_jr_enqueue(ctx->jrdev, desc, rctx->skcipher_op_done,=0A=
> +			      jrentry);=0A=
...thus skcipher_crypt_done could be used directly here=0A=
instead of rctx->skcipher_op_done.=0A=
=0A=
> @@ -1742,15 +1789,18 @@ static inline int skcipher_crypt(struct skcipher_=
request *req, bool encrypt)=0A=
>  =0A=
>  	/* Create and submit job descriptor*/=0A=
>  	init_skcipher_job(req, edesc, encrypt);=0A=
> +	desc =3D edesc->hw_desc;=0A=
>  =0A=
>  	print_hex_dump_debug("skcipher jobdesc@" __stringify(__LINE__)": ",=0A=
> -			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,=0A=
> -			     desc_bytes(edesc->hw_desc), 1);=0A=
> +			     DUMP_PREFIX_ADDRESS, 16, 4, desc,=0A=
> +			     desc_bytes(desc), 1);=0A=
>  =0A=
> -	desc =3D edesc->hw_desc;=0A=
> -=0A=
> -	ret =3D caam_jr_enqueue(jrdev, desc, skcipher_crypt_done,=0A=
> -			      &edesc->jrentry);=0A=
> +	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)=0A=
> +		return crypto_transfer_skcipher_request_to_engine(jrpriv->engine,=0A=
> +								  req);=0A=
In case request transfer to crypto engine fails, some resources will leak.=
=0A=
=0A=
> +	else=0A=
> +		ret =3D caam_jr_enqueue(jrdev, desc, skcipher_crypt_done,=0A=
> +				      &edesc->jrentry);=0A=
It's worth mentioning (in the commit message) the reasons for sending=0A=
only some of the requests (those with MAY_BACKLOG flag) to the crypto engin=
e.=0A=
=0A=
Horia=0A=
