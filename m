Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D43C352A3
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 12:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D625C20714
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 12:25:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="meoRpJzG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgBKMZx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 07:25:53 -0500
Received: from mail-eopbgr30083.outbound.protection.outlook.com ([40.107.3.83]:4366
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727887AbgBKMZx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 07:25:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9exbgStF+Rnf2q2cJrWnBsUllsdAtGheN39/5+v2FBz7k5JaSUJK5AtbfZgPbLFauMB2hmCU515GgdhfbPYRuJZPF7tGrgNt/kk0D32NFEm4ERrlrcHhgxszNIiUfc7LAcLryM/Zebr4xWfb6pKnhJ1klpD2txn9rwqRS4NtNEAJlhzj5y5wEV33fbU/s9T/GqGoOs5EM7y+xRqZ/6Sa3NqtYw0jmeEXDkr827sTqbbtS9xyi633OKsBGhnyyeAs+8A3595mGLEwIiru7hzCYF5vTACERAnJXyisDMqxw/iNV3CNAZP0yqG9OB4kN8m+7vlhaRwcu3sWenX50bPbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qxjmzh0o2QKrAHpD+MFKKmRcBjIpn7pzlyWEtkwg45s=;
 b=RPHVNWomZ90UesdtKX03lfePAzP2U6NuzZiFKiBU3UIDEuoucXeQcFv6r7TI8smg3nNXUOq0Gky0RAMq96Cb3iD4+TG/DjqQNkZK+D+CAJS+vLZ3mGQTNlhiiqZLqtnWRDClv4YiZgEuykhOVawQ0iH/N2TzIu9UDFIsPSIJ/Y3YNhQxezEQcwUTa/uZC27nEp+shRKbUb9fDIq1Jv+ZxJpLMPm5HE3o5pPthEZ9rUnp/7bieiQ/tsL6TPg1m7yweplDwvxSGNnNvbOpdcDPjc9gjIS3IEHtwG8tnqyUPMsB85qL8ygwcIQrxULAX7YtE0ArfxnfUwPoMOeGEl+yyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qxjmzh0o2QKrAHpD+MFKKmRcBjIpn7pzlyWEtkwg45s=;
 b=meoRpJzGOUmQQ2ylu1DYFcMONgcVabzbOOrDosxthig3RHr8RFD2lZnhuosV0JQUPN2hf3jkdC4nk1+e4qfE1mIvWxkRhRgtVGV8WZkt9aYfWqqDLZRpjcItOvsfRcrqnQ5zT2eGawkbH3N1txsqWCiT7N0irnIpqIm8P/1I6PQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2880.eurprd04.prod.outlook.com (10.175.22.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Tue, 11 Feb 2020 12:25:49 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 12:25:49 +0000
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
Subject: Re: [PATCH v5 9/9] crypto: caam - add crypto_engine support for HASH
 algorithms
Thread-Topic: [PATCH v5 9/9] crypto: caam - add crypto_engine support for HASH
 algorithms
Thread-Index: AQHV1wcsOwHkZptGCkC3XATUEKlSzg==
Date:   Tue, 11 Feb 2020 12:25:49 +0000
Message-ID: <VI1PR0402MB3485F2EA456432F03B2422FF98180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1580345364-7606-1-git-send-email-iuliana.prodan@nxp.com>
 <1580345364-7606-10-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a3040dd6-6d1b-425c-8dff-08d7aeed876b
x-ms-traffictypediagnostic: VI1PR0402MB2880:|VI1PR0402MB2880:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB28804BF3ED46F3AF8E6E8BFD98180@VI1PR0402MB2880.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 0310C78181
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(189003)(199004)(8676002)(316002)(186003)(4326008)(9686003)(8936002)(81166006)(26005)(91956017)(53546011)(110136005)(54906003)(81156014)(6506007)(76116006)(55016002)(7696005)(478600001)(86362001)(2906002)(5660300002)(64756008)(71200400001)(6636002)(66946007)(66556008)(66476007)(66446008)(52536014)(33656002)(44832011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2880;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /itCSi7HgVCHZesTt+RnZmZr/AXzOCKEZYAmYtP8op5yQCQdYMXqd98eBfIcQI0GQ3qagCzP2JIijLa12wRZsi+pJXfwqYIQCHGXwGNsI7f+M20KOYc4Lhpiu3OFsC7+npvcjuyKgsxfwilve7d+CHUQ2dxcCfLB7w765Viy4dK2MfN2H1dM4o/uhbtFUppvVEPrp7l7nbpmVgxKkG0Ik/ceQL8ESB6mQhqzcvqheaWshjE4vjqCBSv4/dpRqC3Hq/JxcIkj4eqIj1Q6mr9CWhPb3+38cc6xI/SgcsqmZRruk5r707xjbbEoDbtgCybOb74eL2c99eNVIVbtlys9IcA9k2vPiZKZjfh2E/A7pTZ4TOBwwRWSLNL7w5zX/5um0mOGmLXX1gvPAgU83kwCM2BrjQjplTkSva8Jmk4csb0yL+nqhrV+DVg4uqND9RMR
x-ms-exchange-antispam-messagedata: t9k4MGabGEdK+gCLNbamixrZinR21WDXM6xSvfQ2ClJ4YlD3/HhR2Esq2nMV7IglBQj33mQQCNyE0hAFl8Xs3pQ253GcWYgGxhSj3tXQnVW/XRmuKiTcIf4MRJqMnNAVIIx+/WRp0pfrQ01nnSFftA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3040dd6-6d1b-425c-8dff-08d7aeed876b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2020 12:25:49.7110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pQZVX9dejtJX+jmnPvJP4XKWWeKE1oxhwsA+WEq+ioBAbt3wqt6Mc3NEZ3gEhvwjZ9QkZIJEbOR23g+32Zkxdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2880
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/30/2020 2:49 AM, Iuliana Prodan wrote:=0A=
> @@ -123,6 +128,9 @@ struct caam_export_state {=0A=
>  	int (*update)(struct ahash_request *req);=0A=
>  	int (*final)(struct ahash_request *req);=0A=
>  	int (*finup)(struct ahash_request *req);=0A=
> +	struct ahash_edesc *edesc;=0A=
> +	void (*ahash_op_done)(struct device *jrdev, u32 *desc, u32 err,=0A=
> +			      void *context);=0A=
These members are used internally by the driver,=0A=
during ahash request processing.=0A=
They are recomputed each time a new request is received.=0A=
=0A=
This means .import/.export callbacks don't have to deal with them.=0A=
=0A=
>  /* submit ahash update if it the first job descriptor after update */=0A=
> @@ -1209,9 +1280,8 @@ static int ahash_update_no_ctx(struct ahash_request=
 *req)=0A=
>  				     DUMP_PREFIX_ADDRESS, 16, 4, desc,=0A=
>  				     desc_bytes(desc), 1);=0A=
>  =0A=
> -		ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);=0A=
> -		if (ret !=3D -EINPROGRESS)=0A=
> -			goto unmap_ctx;=0A=
> +		ret =3D ahash_enqueue_req(jrdev, ahash_done_ctx_dst, req,=0A=
> +					ctx->ctx_len, DMA_TO_DEVICE);=0A=
In case ahash_enqueue_req() fails, driver's callbacks state machine=0A=
changes since the code falls through.=0A=
=0A=
>  =0A=
>  		state->update =3D ahash_update_ctx;=0A=
>  		state->finup =3D ahash_finup_ctx;=0A=
=0A=
> @@ -1394,9 +1459,8 @@ static int ahash_update_first(struct ahash_request =
*req)=0A=
>  				     DUMP_PREFIX_ADDRESS, 16, 4, desc,=0A=
>  				     desc_bytes(desc), 1);=0A=
>  =0A=
> -		ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);=0A=
> -		if (ret !=3D -EINPROGRESS)=0A=
> -			goto unmap_ctx;=0A=
> +		ret =3D ahash_enqueue_req(jrdev, ahash_done_ctx_dst, req,=0A=
> +					ctx->ctx_len, DMA_TO_DEVICE);=0A=
Same here.=0A=
=0A=
>  =0A=
>  		state->update =3D ahash_update_ctx;=0A=
>  		state->finup =3D ahash_finup_ctx;=0A=
=0A=
> @@ -1752,7 +1820,9 @@ static int caam_hash_cra_init(struct crypto_tfm *tf=
m)=0A=
>  	}=0A=
>  =0A=
>  	dma_addr =3D dma_map_single_attrs(ctx->jrdev, ctx->sh_desc_update,=0A=
> -					offsetof(struct caam_hash_ctx, key),=0A=
> +					offsetof(struct caam_hash_ctx, key) -=0A=
> +					offsetof(struct caam_hash_ctx,=0A=
> +						 sh_desc_update),=0A=
>  					ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);=0A=
>  	if (dma_mapping_error(ctx->jrdev, dma_addr)) {=0A=
>  		dev_err(ctx->jrdev, "unable to map shared descriptors\n");=0A=
> @@ -1770,11 +1840,19 @@ static int caam_hash_cra_init(struct crypto_tfm *=
tfm)=0A=
>  	ctx->sh_desc_update_dma =3D dma_addr;=0A=
>  	ctx->sh_desc_update_first_dma =3D dma_addr +=0A=
>  					offsetof(struct caam_hash_ctx,=0A=
> -						 sh_desc_update_first);=0A=
> +						 sh_desc_update_first) -=0A=
> +					offsetof(struct caam_hash_ctx,=0A=
> +						 sh_desc_update);=0A=
>  	ctx->sh_desc_fin_dma =3D dma_addr + offsetof(struct caam_hash_ctx,=0A=
> -						   sh_desc_fin);=0A=
> +						   sh_desc_fin) -=0A=
> +					  offsetof(struct caam_hash_ctx,=0A=
> +						   sh_desc_update);=0A=
>  	ctx->sh_desc_digest_dma =3D dma_addr + offsetof(struct caam_hash_ctx,=
=0A=
> -						      sh_desc_digest);=0A=
> +						      sh_desc_digest) -=0A=
> +					     offsetof(struct caam_hash_ctx,=0A=
> +						      sh_desc_update);=0A=
offsetof(struct caam_hash_ctx, sh_desc_update) is used several times,=0A=
it deserves a local variable.=0A=
=0A=
Horia=0A=
