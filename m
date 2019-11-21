Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43815C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 11:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F5D120872
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 11:53:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Q/BTCNmP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKULxc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 06:53:32 -0500
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:27266
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbfKULxc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 06:53:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOwLvDU3b0MPTYIUfe8wsDMwQK0mSGsiAv+wCBB6SX1we3RNk9p+bZzV1xGpyBZrww2J+L2JLRMnfTn0g8H/akE0+ulZSDBj6nDumtm+CRYxoRXdMn4rUqqvkeO8efc+ykvcVXGC9D5mRv95uJtp4SCrVtTrFlTjSmC/vMAwaBRaYzisC19z0ftoreXJtHq0V5lrGY5+yPVf3mH6Ue1QKL2X58IeU/reJQYH3ceYkg2xW/ZQXBJGL3i7jayZX5lafp7hMz8oAQ8x4SWHjKbX8tUizur82DLPDRmhO5iMEb6ReMHZBaoQFBhKqorzwTMEryVRWdPoECaTXTr1cLULFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpGAUChRtVpHopiO1QH4MJ5aBUAGSccuZ50QTtiIL6g=;
 b=N+2Xd06T44dND4W9CXFj5uNq9Zl6IibLjIaJK5bGeUeQZLljx3UZKZt4U+dZdybGqzBSqnru45zQ7AIM2+/AoZDmiRE/2hvy7cxDz6V8J31Z8oWu7542S6ToZ9+VeofgjaMc3ylrBBvQ6EtzlzTHttDE3uDLSJuIQaLo0PudGNYdVGP+09fCZNvPe8Rc9PFL+3ZNlHuPY98ObbV8OICieMny866zNhOp+/LAsO/fXSmH1zkJwjop5haInpkRy6224x0pK8191QnEgYbLn3s2in5vDM7dvHUzpZ8uXirpkWv9UEO6YTzwq2XY8PbGAGvhurLtk2dTeWeCmQSE5Vjt4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpGAUChRtVpHopiO1QH4MJ5aBUAGSccuZ50QTtiIL6g=;
 b=Q/BTCNmPoRAbse4HPSlPjMse8q4npGXn/OKCMym2QQ1d+9nKctKTYnzeJzl2qOoBOO6N8dGtfie7RksSOOWEk6j8sgrI5x1CncPEeNfZaAAkrkKSxP4gbREf+Be27+VdLnFjYKUaDys0H9lH0sxMCc0gloqNUlF8ooGuaLKpLNk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2861.eurprd04.prod.outlook.com (10.175.23.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Thu, 21 Nov 2019 11:53:28 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.018; Thu, 21 Nov 2019
 11:53:28 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Baolin Wang <baolin.wang@linaro.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 09/12] crypto: caam - bypass crypto-engine sw queue, if
 empty
Thread-Topic: [PATCH 09/12] crypto: caam - bypass crypto-engine sw queue, if
 empty
Thread-Index: AQHVnZa0zmFv7pEz2UeOgv3ju3yk4A==
Date:   Thu, 21 Nov 2019 11:53:28 +0000
Message-ID: <VI1PR0402MB348532182CBA23131430DAA9984E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-10-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c864857-6b9f-43ff-b24a-08d76e796c71
x-ms-traffictypediagnostic: VI1PR0402MB2861:|VI1PR0402MB2861:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2861A84C1D43675E440259C4984E0@VI1PR0402MB2861.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(199004)(189003)(33656002)(3846002)(64756008)(91956017)(66446008)(99286004)(6116002)(478600001)(110136005)(86362001)(66946007)(71190400001)(71200400001)(316002)(66476007)(66556008)(14444005)(256004)(102836004)(2906002)(44832011)(54906003)(14454004)(26005)(76116006)(446003)(7736002)(4326008)(305945005)(6436002)(52536014)(229853002)(7696005)(76176011)(8936002)(81166006)(25786009)(74316002)(66066001)(6246003)(6506007)(81156014)(8676002)(9686003)(55016002)(5660300002)(186003)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2861;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8/HP6JW+niFzfBI5g4pnFm5/uaxwtgibFdrLHSeGwsqtUg/L+C5ubuwxR+ILd+xGXf/RYXaO/K07vKD9Ls0odPBMGN6Peh3AYSU3dA7DRFQ/e/t0Ex+udvmmV6+03kEYISQM/sJaTk3HEw+QeN9dYpidWS1x7o9ZyFkG6N2OF5aiE0ZFqjyov26JZHTvQFz9JGHRL7/0OcKyVv1nwsTNv521x3dV3RxQmnLU05n2WafCCBKvt3hwpP4b0Z01fatQakSp/omBenW8LST4TQkHHb7JCYeKBkrjlHeXzM2CRaTcsJhfIShvc+VnkAho27qn1k6d/KNY1YLilPVQlVwIVM4rE1ZAsWXbP5ZvhfNHe+qsHOGDpaR/G61uGj5DdzfPpPVAEeHgMENsk3v8kBhqJ2xxlm9BcBnr7t216YrHHxbSymw0ezP8b1gOz5+rQLSc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c864857-6b9f-43ff-b24a-08d76e796c71
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 11:53:28.4763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aRdQi70qp+wCDVXx4b39KSdtLDU4bwWcYMtG7mpzQIAbUqvueS90Ya2qLHbQR/W3o3mJuAp6nrXEde1Mk+lL3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> Bypass crypto-engine software queue, if empty, and send the request=0A=
> directly to hardware. If this returns -ENOSPC, transfer the request to=0A=
> crypto-engine and let it handle it.=0A=
> =0A=
Could this optimization be added directly into the crypto engine?=0A=
=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> ---=0A=
>  drivers/crypto/caam/jr.c | 29 ++++++++++++++++++++++++++---=0A=
>  1 file changed, 26 insertions(+), 3 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c=0A=
> index 5c55d3d..ddf3d39 100644=0A=
> --- a/drivers/crypto/caam/jr.c=0A=
> +++ b/drivers/crypto/caam/jr.c=0A=
> @@ -476,10 +476,33 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,=
=0A=
>  	struct caam_drv_private_jr *jrpriv =3D dev_get_drvdata(dev);=0A=
>  	struct caam_jr_request_entry *jrentry =3D areq;=0A=
>  	struct crypto_async_request *req =3D jrentry->base;=0A=
> +	int ret;=0A=
>  =0A=
> -	if (req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)=0A=
> -		return transfer_request_to_engine(jrpriv->engine, req);=0A=
> -=0A=
> +	if (req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {=0A=
> +		if (crypto_queue_len(&jrpriv->engine->queue) =3D=3D 0) {=0A=
> +			/*=0A=
> +			 * send the request to CAAM, if crypto-engine queue=0A=
> +			 * is empty=0A=
> +			 */=0A=
> +			ret =3D caam_jr_enqueue_no_bklog(dev, desc, cbk, jrentry);=0A=
> +			if (ret =3D=3D -ENOSPC)=0A=
> +				/*=0A=
> +				 * CAAM has no space, so transfer the request=0A=
> +				 * to crypto-engine=0A=
> +				 */=0A=
> +				return transfer_request_to_engine(jrpriv->engine,=0A=
> +								  req);=0A=
> +			else=0A=
> +				return ret;=0A=
> +		} else {=0A=
> +			/*=0A=
> +			 * crypto-engine queue is not empty, so transfer the=0A=
> +			 * request to crypto-engine, to keep the order=0A=
> +			 * of requests=0A=
> +			 */=0A=
> +			return transfer_request_to_engine(jrpriv->engine, req);=0A=
> +		}=0A=
> +	}=0A=
>  	return caam_jr_enqueue_no_bklog(dev, desc, cbk, jrentry);=0A=
>  }=0A=
>  EXPORT_SYMBOL(caam_jr_enqueue);=0A=
> =0A=
