Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9938C33CA2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 08:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9137220721
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 08:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="hZeapCIn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAJIqU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 03:46:20 -0500
Received: from mail-eopbgr140042.outbound.protection.outlook.com ([40.107.14.42]:62718
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727152AbgAJIqT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 03:46:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GejFbDb14LTYDt7I8ahleMxOMV1+ULdNvlegk9Vyo/N7mUwIxyb1LinYcRSfimIsWTeJsbLQdrwcVCHFkF6E4pxVAbBnShmGsGQWNJ2UTf4CkrKRWf0bqLhNZJitrGAX1S3h4rJ9OeJ3ZXea/02zC+tIGldmz5kIqD9iWBpWBZD0SkHENn+gG9pEsG4f8ZGflGxSx9E0jmipYRQg+3KVKWSYL5//johr7HUcQTlXqSeRj5FntEL9qhRZDpBi6NJ3jIyTAp1PGfeEHIuBSn99fArzF3gL19OHMugwd1cK2PA/JGoPzTDodWJKgRSMbvinXGuF0HLgD0eFipIFAiP8VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRiQXzdsw3mfp7s1vF0UTtBBpnf3OQTc6xpe3epTiww=;
 b=YGLyTDZGqqjNVKUSzzBiVJYdAZxPXlp+ovttBVGCh49GMszktvuUdRvq3M/XfRwJhsV2mHsZ80s7XqYByyPrkjq7wlaiIbRD5AxgsvG4iVD8/nsVC4/Hy9p2Dl/QBB5HtSVeAvrSl9YNVeVACdvmt9pcURV4KViF9VEylVUcOg6uZHD3Qu3m2isFovkgUktZLGWzzHzuNWh+upQAwDmrHcQ5z5LGhjERqvMmJeTxe7HIu5Tn96Dbht3qu+lyASlu0jpm5N4cprh0s6HJ+HgvCVg/vDI98e2oGjoS5WeBYRjT5OBT8F98qLJYFUOdiXpIHBSbRSmLUGRQ6ki+CimFtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRiQXzdsw3mfp7s1vF0UTtBBpnf3OQTc6xpe3epTiww=;
 b=hZeapCInKOxrP/QxWHIbbDvFXd0kVwff/85eApnBfZtLyt3QuA1EO1auVEVBxCMHlUH9UMQiHhPTkIwtdfNK2EpXFL7SajPb2sieAVXeVuOOYPBF4IcFfC3iNNYG3aAyy5UfTlCvSqJfysr9rKhVIlKhJhrFFLACjZ5h9En/Rfk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3549.eurprd04.prod.outlook.com (52.134.4.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 08:46:12 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2623.011; Fri, 10 Jan 2020
 08:46:12 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 09/10] crypto: caam - add crypto_engine support for RSA
 algorithms
Thread-Topic: [PATCH v2 09/10] crypto: caam - add crypto_engine support for
 RSA algorithms
Thread-Index: AQHVwdGq8rD6kVc2eEOuvzLis67wVg==
Date:   Fri, 10 Jan 2020 08:46:12 +0000
Message-ID: <VI1PR0402MB3485162217C242B16CF1371B98380@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
 <1578013373-1956-10-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c3a1cf64-898d-44f6-b5c6-08d795a98c13
x-ms-traffictypediagnostic: VI1PR0402MB3549:|VI1PR0402MB3549:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3549950AAE707B12B50480DD98380@VI1PR0402MB3549.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(199004)(189003)(478600001)(33656002)(2906002)(8936002)(81166006)(4326008)(316002)(86362001)(54906003)(110136005)(81156014)(8676002)(91956017)(6636002)(26005)(76116006)(66476007)(66446008)(44832011)(5660300002)(186003)(53546011)(64756008)(6506007)(66946007)(66556008)(7696005)(9686003)(71200400001)(52536014)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3549;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wjS0HrXbmMIYL367fr6xzsyPTZ3n/bQQqmxue51hxl5hTWdXKkv24lw7cOkLe6YqrNmGXpJKecJwe2iOgGlGmB60FFBKq5zVCDqy5wFdgMWefXhTe44q57Jcs933XNiQLDxBi6r5Gtk0RbLMEZOtvKxzTu2O30gA2eQVGiy/dKAGEUFj8Rq/PesFZyZZ0PYkXhVGj1ZCVBr5nstOwqocdJmu/bXc/BnCnyMNYlcp43YBdZmZZQqL/noXSE0DNU3I8HxHTboe8p9sJwyGDzNLhUb9ezPu98R2/7mtNbKTzEVH8q7TQW+E9NWHg1EBl8tbMopaV1NQbgGbOGTkzG5NQyOQD/R3+lBJ2c7dny/m0+Lal5Ag/1wvoRf7zXBxh8lW8wDEl5R5Ti0Z9oOHyD8nItc4bz9cBvCfJUaT0GYzZ8BKKo9h6uhHwzn0lJJLl4Dn
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a1cf64-898d-44f6-b5c6-08d795a98c13
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 08:46:12.7408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zU2lnJcSvoEiSGBS1zWFasgRtwuLibVkYZDaMawW7yAcqJ2SXxT5VaZfDC1jZMrKIj+7c0M1S4eD3jLUXcVJFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/3/2020 3:03 AM, Iuliana Prodan wrote:=0A=
> +static int akcipher_enqueue_req(struct device *jrdev, u32 *desc,=0A=
> +				void (*cbk)(struct device *jrdev, u32 *desc,=0A=
> +					    u32 err, void *context),=0A=
> +				struct akcipher_request *req,=0A=
> +				struct rsa_edesc *edesc)=0A=
> +{=0A=
> +	struct caam_drv_private_jr *jrpriv =3D dev_get_drvdata(jrdev);=0A=
> +	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);=0A=
> +	struct caam_rsa_ctx *ctx =3D akcipher_tfm_ctx(tfm);=0A=
> +	struct caam_rsa_key *key =3D &ctx->key;=0A=
> +	int ret;=0A=
> +=0A=
> +	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)=0A=
> +		return crypto_transfer_akcipher_request_to_engine(jrpriv->engine,=0A=
> +								  req);=0A=
Resource leak in case transfer fails.=0A=
=0A=
> +	else=0A=
> +		ret =3D caam_jr_enqueue(jrdev, desc, cbk, &edesc->jrentry);=0A=
What's the problem with transferring all requests to crypto engine?=0A=
=0A=
> +=0A=
> +	if (ret !=3D -EINPROGRESS) {=0A=
> +		switch (key->priv_form) {=0A=
> +		case FORM1:=0A=
> +			rsa_priv_f1_unmap(jrdev, edesc, req);=0A=
> +			break;=0A=
> +		case FORM2:=0A=
> +			rsa_priv_f2_unmap(jrdev, edesc, req);=0A=
> +			break;=0A=
> +		case FORM3:=0A=
> +			rsa_priv_f3_unmap(jrdev, edesc, req);=0A=
> +			break;=0A=
> +		default:=0A=
> +			rsa_pub_unmap(jrdev, edesc, req);=0A=
> +		}=0A=
> +		rsa_io_unmap(jrdev, edesc, req);=0A=
> +		kfree(edesc);=0A=
> +	}=0A=
> +=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
>  static int caam_rsa_enc(struct akcipher_request *req)=0A=
>  {=0A=
>  	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);=0A=
>  	struct caam_rsa_ctx *ctx =3D akcipher_tfm_ctx(tfm);=0A=
> +	struct caam_rsa_req_ctx *req_ctx =3D akcipher_request_ctx(req);=0A=
>  	struct caam_rsa_key *key =3D &ctx->key;=0A=
>  	struct device *jrdev =3D ctx->dev;=0A=
>  	struct rsa_edesc *edesc;=0A=
> @@ -637,13 +726,9 @@ static int caam_rsa_enc(struct akcipher_request *req=
)=0A=
>  	/* Initialize Job Descriptor */=0A=
>  	init_rsa_pub_desc(edesc->hw_desc, &edesc->pdb.pub);=0A=
>  =0A=
> -	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done,=0A=
> -			      &edesc->jrentry);=0A=
> -	if (ret =3D=3D -EINPROGRESS)=0A=
> -		return ret;=0A=
> -=0A=
> -	rsa_pub_unmap(jrdev, edesc, req);=0A=
> -=0A=
> +	req_ctx->akcipher_op_done =3D rsa_pub_done;=0A=
This initialization could be moved into akcipher_enqueue_req().=0A=
=0A=
> +	return akcipher_enqueue_req(jrdev, edesc->hw_desc, rsa_pub_done,=0A=
> +				    req, edesc);=0A=
edesc, edesc->hw_desc parameters not needed - can be deduced internally=0A=
via req -> req_ctx -> edesc- > hw_desc.=0A=
=0A=
Horia=0A=
