Return-Path: <SRS0=WjNG=6M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C82BCC83000
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 07:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E00A2051A
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 07:48:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="FS0euvPw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgD1Hsa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Apr 2020 03:48:30 -0400
Received: from mail-eopbgr150083.outbound.protection.outlook.com ([40.107.15.83]:4750
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726256AbgD1Hs3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Apr 2020 03:48:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BI+5dSL3YpvxdaLq6PFbCZewYircjD7z3ZUsLXx/gjeaINF2540+TTJ0uoOMYkgTsdThQ/M1C35lEXi6RwvTCqCPtFdIa4OJC0PA3VNV7l4AURHGr9JQMDOS9gxX49evX+I/n+PHqpdPN5CIXmM8aBLKr8E3pi65sxICIWjWFkV9K/PziRWNKfKD++0LnCtngQpUc0SM1g2nxK/7k7ndcILxFGZ0OslmBkierEjSXyRdYkMEoNc+5wka0gRmcT3qZ/hK3Ened/EKMBo4/o+fKCb59vmWHC9dTGlq7Lj/49flEN0nXf8d//b67NgXSHRtdeocG/DXDpbkA2jUGvvMQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgjJTkNh6RtBjCyifu/+TNr1C8MJq5/Efyq5HaSpCNc=;
 b=jxdEpa4n5F/4i2dNOc5EzNucn3ZQqZV9eWs9OUeeosSZeifRwqUA8WNYMq88xnK+A7523qYbQ7jY7OdCnu9VtcezgPeJIx0Qv250Zw9+yURg2Q81acCJtiMTCH5yxHtz8ZEXMiEMcvFi9VaI26AYjMobyGysPZXkgtTaEjfRF+O5ypXv1Hw4k8NahBzfK9VVlIdhUZ3AZ2iA7Pw9NAkOk/5EcyoGYklCV0/i43p22LmBeJ7lTI9qmdnp2r7WGesJbWNfkqB4+zoXQYeeNs9wcKOmslzKmRP9jGR5YonlRWvIhwcNA4zl9z8RtDPKsFG6/ucVNN7lJybLfW1SD8vEog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgjJTkNh6RtBjCyifu/+TNr1C8MJq5/Efyq5HaSpCNc=;
 b=FS0euvPwU+wwLRJPq9vBSW3S7JKIf3Pi+5Szongjf59dZe8vi8illQVdUvDU55LKDEo3HtzDDuLDHdqYi77houGI+CO+O8A3xNX66z24tRO0v7WABoeUWpTCcLO8AyKovVNBD6XmpS3rW1diu05KfEzmWND3ORwSBo3ix/zwV44=
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR0402MB2799.eurprd04.prod.outlook.com
 (2603:10a6:800:b0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 07:48:26 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::c465:f38f:6be3:5d97]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::c465:f38f:6be3:5d97%7]) with mapi id 15.20.2937.020; Tue, 28 Apr 2020
 07:48:26 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: caam - fix use after free issue in *_crypt_done
Thread-Topic: [PATCH] crypto: caam - fix use after free issue in *_crypt_done
Thread-Index: AQHWHRvtT9LOWs0K8UK7DEdR/IFCQg==
Date:   Tue, 28 Apr 2020 07:48:26 +0000
Message-ID: <VI1PR0402MB3712A2A328540479261ACCA68CAC0@VI1PR0402MB3712.eurprd04.prod.outlook.com>
References: <20200428051427.508-1-zhenzhong.duan@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.121.160.118]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1722f9c3-747f-41e8-6bb7-08d7eb4888c7
x-ms-traffictypediagnostic: VI1PR0402MB2799:|VI1PR0402MB2799:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2799CABDC1E487B8697AC4D38CAC0@VI1PR0402MB2799.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:416;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(33656002)(6506007)(53546011)(186003)(26005)(55016002)(316002)(71200400001)(54906003)(7696005)(110136005)(9686003)(4326008)(8936002)(478600001)(44832011)(66446008)(966005)(86362001)(66946007)(52536014)(76116006)(8676002)(5660300002)(2906002)(91956017)(81156014)(66556008)(66476007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aLzBcCBWjMF0uqxY8tUFVadL3EpE5hiSsqvnWl5y7m+K+mKnrIiHcj3AxA1T2UOv+3kGOKBtmIdJ8KEKLhWvkq9rVoYLnHuSDcwtUISbwmVC3HlLhlsUo1VisVzbzWC/xWVyuvuF72VlGWGp1/8lkuPXm4YoiJUuYCwsB/SfXCx9lbgKT5Blh7V21VehN2Htm7dH/5mmh1XfdznD+W+nUnv3U61Hlxt/fQp6zDYCvHU/WDG+Q2qPcoRyOt/GqoqpkDMudCWwYAnvYbbgdfivatFukZikYC4nf1KlPBnFibFjTUisBCCmmzwznmX1hMijx1KeZjA3MMcc0ekBSTZcmUOjTuLXagobIzHuqtecAaHtOBPEiE1SH7wYLA96fO+8/KJJ9jrMgjwgXQD0MAY0A1DQ/HJskYfXMXNyo/f0wKmZtvd1deOq25gDQGuBI+BxIgH+IyspCT+7rxKkxXpvBtYbA7aGD+QRMpIL/9PuBabBtrNyFrOyDCCLCXyQhbAdtQMzyLQ3WPqRqQVAl+CdbA==
x-ms-exchange-antispam-messagedata: Dgtg/zGldgORQ15jGudtCoMheCD9GAQo+XKhX2nEDfmKfk0tAkHLYiB7PU31qcU16Nf9vbUqaKxxTSLmlGNHwKzqTBrRxEZgV6G5E6dGLuNQuJx9qR/mM1oxcDKxUCE+9mX4AvyLYV9vjtYUFNkaTC7aiWcFJLwkeLPp2m/lf49tq7XrugBF58mJS4ma+JcB19XGrzfGrZ8mO0s4kzq3AtrTdVs3an/XTlXLLq+fgfCt5sDrm1Oj0i4NEOvsjz7/MiT1RVx0iN9zbQVjdER6yFdNcq55MtaPebjkT4WOQRh6DvZnnqd7H2qTyYcyR1/g7sFFM3Oqy1TUNrIVZOBGxgVtvazAlAh0p+6pO9CVwyuSVmpi94HSLjXCckYCnDiIszxtvoQXT0HU1ih/8/pUs4x5gb8CUaG8O+fiQqdV1XdDqM3QX1SuZ0LKPHoeGoNS8diM+3G2+z0GSaAmBqzEYR2oPF7EwWPUpSZrUen9UopT5jXvSVM38C3IK2BuJog21QnU+rq8nmapVYUv7BuAjbmo8wMMOZPyA2kB+Nayq4/1h9u5lUlZklY1CPtSkDwx5e7T+NUeZJswstD+E8DLoGUcPJlF6gIa2IEToX+r8SVyzfJV12Y58EiqaJKOTq8fBWFmLeUWf0+/Enq7dzmajMdan2dvY4/IXmVUpkOfpKaH0kYLkYFCagP5W6zJWNhf9/VZSM3zLHsmz8lo+xO7rkPLYTeiT2Owe4ebDgLE4pE/+24rj3wWlKCwmzz+G9XQR+4kT2rwl1xD/aYqF8y5+V3qDtPiApoReu8gL6IJmtQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1722f9c3-747f-41e8-6bb7-08d7eb4888c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2020 07:48:26.0098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XziSfff3+Rvm1QW4jr3KjjkhQS4hZTl9ZG5zCVQZAir6huRQYXvDuv2Co9QighcVmhzNwcvTjaKHpafl6WB24Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2799
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/28/2020 8:14 AM, Zhenzhong Duan wrote:=0A=
> In both aead_crypt_done and skcipher_crypt_done, edesc->bklog is=0A=
> referenced after the structure pointed by edesc is freed.=0A=
> =0A=
> Fix them by moving kfree(edesc) to the end of function call.=0A=
> =0A=
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>=0A=
=0A=
These issues were already fixed, and applied on cryptodev, by this =0A=
series: https://patchwork.kernel.org/cover/11476799/=0A=
=0A=
Regards,=0A=
Iulia=0A=
=0A=
> ---=0A=
>   drivers/crypto/caam/caamalg.c | 8 ++++----=0A=
>   1 file changed, 4 insertions(+), 4 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index b7bb7c30adeb..6d746ef5e650 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -973,8 +973,6 @@ static void aead_crypt_done(struct device *jrdev, u32=
 *desc, u32 err,=0A=
>   =0A=
>   	aead_unmap(jrdev, edesc, req);=0A=
>   =0A=
> -	kfree(edesc);=0A=
> -=0A=
>   	/*=0A=
>   	 * If no backlog flag, the completion of the request is done=0A=
>   	 * by CAAM, not crypto engine.=0A=
> @@ -983,6 +981,8 @@ static void aead_crypt_done(struct device *jrdev, u32=
 *desc, u32 err,=0A=
>   		aead_request_complete(req, ecode);=0A=
>   	else=0A=
>   		crypto_finalize_aead_request(jrp->engine, req, ecode);=0A=
> +=0A=
> +	kfree(edesc);=0A=
>   }=0A=
>   =0A=
>   static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 er=
r,=0A=
> @@ -1022,8 +1022,6 @@ static void skcipher_crypt_done(struct device *jrde=
v, u32 *desc, u32 err,=0A=
>   		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,=0A=
>   		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);=0A=
>   =0A=
> -	kfree(edesc);=0A=
> -=0A=
>   	/*=0A=
>   	 * If no backlog flag, the completion of the request is done=0A=
>   	 * by CAAM, not crypto engine.=0A=
> @@ -1032,6 +1030,8 @@ static void skcipher_crypt_done(struct device *jrde=
v, u32 *desc, u32 err,=0A=
>   		skcipher_request_complete(req, ecode);=0A=
>   	else=0A=
>   		crypto_finalize_skcipher_request(jrp->engine, req, ecode);=0A=
> +=0A=
> +	kfree(edesc);=0A=
>   }=0A=
>   =0A=
>   /*=0A=
> =0A=
=0A=
