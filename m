Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC50C43215
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 17:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2272E21823
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 17:56:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="P77v8NRb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfKSR4p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 12:56:45 -0500
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:42661
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726792AbfKSR4o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 12:56:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OD+mIQWS7i/Y98y4BtHG5Kt5B1Ngq6UzHXGXyD79Ld7z+Fwvovko+gQYloojMpF+7I77Hsy6cIp9g4ID8cumeYlb4M1miPUzPsYWwCzQYOeJa/9nP3nrzT2NmDC+p7aLC2EU3EIbhUish1unHdTTeVghLvzqIiIf8oy0Ko0rVHfnr/ZwZ12qtwRprng+CvU+SVaSVGqtw8hVdVtFHTHQb71l2nyoG/4RAhPa2Gg1W5dch8cgoCNyKHU42VZcF9YiuuV5LEhw2fQ+NxCKBPUrahsrpvKz8RyFv+y82ojE2WbbRMrNieQ7da1k8R1ndxvU0T+BfWrgiOADGvagX9TMlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ug9a2kxCguORGCNNldpnPaK2L8TRYIjJLtVAz51utHI=;
 b=lL0tdeARMxArjByJh/a6zecEP0qQQww+odg2e4rTPhTWw5ANUWF6HMhf0XRi2P1onHwBLCdW3bwBWlU41IsKdK2fVrDy6aEkr/YUvoNrypohPXpsd5yXRmzl5I2/8ID+p6CAZU2TFyevQFfZ4i+owhaiqTbW/K3qO36ogVe0GbOpIiV8VQahCNi8NmeNVrBHfgu+vhvCEohVEuZbDahkUESzGpQIpSdDUOizbyehrIL4N3XrGEItRRcnGIE12eiTBGCBfkiU/B/YlsaCn8FH+zV1AY+6sijHuYYYvToesfnntadaO8M5d2AGpuj7vbwbXj3vhgDFcfJj8wTs0eBxAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ug9a2kxCguORGCNNldpnPaK2L8TRYIjJLtVAz51utHI=;
 b=P77v8NRbHlfJEI5YGYDr0g05lBId3WnwNvvFzYmKdKqNmSEYikFlrPLLvyYDf6qkzh+cwI80qywxW7q42cubw6GGZUcNHLDDwBkTCm/oiPG9DzGx4qsX61Jxq7cAZJsso1GbKsjHqtV4mOJWQsjZbuqT3fHskHdPQ+Vz/jpW3fQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2925.eurprd04.prod.outlook.com (10.175.24.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 19 Nov 2019 17:55:00 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.015; Tue, 19 Nov 2019
 17:55:00 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 07/12] crypto: caam - refactor caam_jr_enqueue
Thread-Topic: [PATCH 07/12] crypto: caam - refactor caam_jr_enqueue
Thread-Index: AQHVnZa0sS6CFfezokOAnr5a2apfuA==
Date:   Tue, 19 Nov 2019 17:55:00 +0000
Message-ID: <VI1PR0402MB34853893505F95195F4C125B984C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-8-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 651a818c-7e77-4e68-dbac-08d76d1998f0
x-ms-traffictypediagnostic: VI1PR0402MB2925:|VI1PR0402MB2925:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2925E93065410A6F7310E225984C0@VI1PR0402MB2925.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(199004)(189003)(54906003)(9686003)(8676002)(76116006)(8936002)(33656002)(81166006)(81156014)(52536014)(5660300002)(71190400001)(316002)(71200400001)(86362001)(478600001)(110136005)(99286004)(14454004)(44832011)(76176011)(6246003)(7696005)(305945005)(4326008)(91956017)(476003)(486006)(66066001)(74316002)(446003)(6636002)(26005)(186003)(14444005)(6436002)(6506007)(66476007)(2906002)(3846002)(102836004)(6116002)(53546011)(229853002)(66946007)(55016002)(7736002)(64756008)(66556008)(25786009)(66446008)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2925;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CQE7RUpaYkzKm3yo4XemFaJCjIAOTWUEsHG4af6jQtjMy/3g8iv7tAc1ZCtRivqVF5OVQEu7VZAhNhFHGWE/kmupm/tn6p5qv/NIOauO1SK8XY9hhIMHpra2K8UswW44rd7CJSaFQo8sDGofWCQraHS4C7s/Lkukwspwib6Xk15vwBXsXTxLCbZUYEyC01F/pW13W8od+bfY7bWXs7kmDyBfT5yIlbgwuUNnaQ2deTUbws5y4yR9vvVkelsthI56IyPP15n6VDmebj45+PjGBgKV2zcb9biy9PYX/+arXDAZLjQi8y/3JAU7uUU7uJHQnY511GcpebxAj9TaiqDHjvl3Q+AX7xq54zSmXdJ2vWYIz/3/Qz5xz90MvCo7ortjdn6EMy92DopCQbRwrWGEriCvqbeYdOZP4Y57JbGJfUcXnSA4QV5oj7KyjetRaziy
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 651a818c-7e77-4e68-dbac-08d76d1998f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 17:55:00.2726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o4ETwvyDzHLQIKf4eNxOIVcrcp0av6K3PmPpfhAEVSGI3bbCGOhsJB3DCYReEkPK8vLPrvIl5DcxynpI7Vr7BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2925
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> Added a new struct - caam_jr_request_entry, to keep each request=0A=
> information. This has a crypto_async_request, used to determine=0A=
> the request type, and a bool to check if the request has backlog=0A=
> flag or not.=0A=
> This struct is passed to CAAM, via enqueue function - caam_jr_enqueue.=0A=
> =0A=
> The new added caam_jr_enqueue_no_bklog function is used to enqueue a job=
=0A=
> descriptor head for cases like caamrng, key_gen, digest_key, where we=0A=
Enqueuing terminology: either generic "job" or more HW-specific=0A=
"job descriptor".=0A=
Job descriptor *head* has no meaning.=0A=
=0A=
> don't have backlogged requests.=0A=
> =0A=
...because the "requests" are not crypto requests - they are either coming=
=0A=
from hwrng (caamrng's case) or are driver-internal (key_gen, digest_key -=
=0A=
used for key hashing / derivation during .setkey callback).=0A=
=0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index 21b6172..abebcfc 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
[...]=0A=
> @@ -1416,7 +1424,7 @@ static inline int chachapoly_crypt(struct aead_requ=
est *req, bool encrypt)=0A=
>  			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),=0A=
>  			     1);=0A=
>  =0A=
> -	ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);=0A=
> +	ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry);=
=0A=
>  	if (ret !=3D -EINPROGRESS) {=0A=
>  		aead_unmap(jrdev, edesc, req);=0A=
>  		kfree(edesc);=0A=
> @@ -1440,6 +1448,7 @@ static inline int aead_crypt(struct aead_request *r=
eq, bool encrypt)=0A=
>  	struct aead_edesc *edesc;=0A=
>  	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);=0A=
>  	struct caam_ctx *ctx =3D crypto_aead_ctx(aead);=0A=
> +	struct caam_jr_request_entry *jrentry;=0A=
>  	struct device *jrdev =3D ctx->jrdev;=0A=
>  	bool all_contig;=0A=
>  	u32 *desc;=0A=
> @@ -1459,7 +1468,9 @@ static inline int aead_crypt(struct aead_request *r=
eq, bool encrypt)=0A=
>  			     desc_bytes(edesc->hw_desc), 1);=0A=
>  =0A=
>  	desc =3D edesc->hw_desc;=0A=
> -	ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);=0A=
> +	jrentry =3D &edesc->jrentry;=0A=
> +=0A=
> +	ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done, jrentry);=0A=
Let's avoid adding a new local variable by using &edesc->jrentry directly,=
=0A=
like in chachapoly_crypt().=0A=
Similar for the other places.=0A=
=0A=
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhas=
h.c=0A=
> index baf4ab1..d9de3dc 100644=0A=
> --- a/drivers/crypto/caam/caamhash.c=0A=
> +++ b/drivers/crypto/caam/caamhash.c=0A=
[...]=0A=
> @@ -933,11 +943,13 @@ static int ahash_final_ctx(struct ahash_request *re=
q)=0A=
>  			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),=0A=
>  			     1);=0A=
>  =0A=
> -	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);=0A=
> +	jrentry =3D &edesc->jrentry;=0A=
> +=0A=
> +	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, jrentry);=0A=
>  	if (ret =3D=3D -EINPROGRESS)=0A=
>  		return ret;=0A=
>  =0A=
> - unmap_ctx:=0A=
> +unmap_ctx:=0A=
That's correct, however whitespace fixing should be done separately.=0A=
=0A=
> @@ -1009,11 +1022,13 @@ static int ahash_finup_ctx(struct ahash_request *=
req)=0A=
>  			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),=0A=
>  			     1);=0A=
>  =0A=
> -	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);=0A=
> +	jrentry =3D &edesc->jrentry;=0A=
> +=0A=
> +	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, jrentry);=0A=
>  	if (ret =3D=3D -EINPROGRESS)=0A=
>  		return ret;=0A=
>  =0A=
> - unmap_ctx:=0A=
> +unmap_ctx:=0A=
Again, unrelated whitespace fix.=0A=
=0A=
> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.=
c=0A=
> index 7f7ea32..bb0e4b9 100644=0A=
> --- a/drivers/crypto/caam/caampkc.c=0A=
> +++ b/drivers/crypto/caam/caampkc.c=0A=
[...]=0A=
> @@ -315,6 +317,8 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcip=
her_request *req,=0A=
>  	edesc->mapped_src_nents =3D mapped_src_nents;=0A=
>  	edesc->mapped_dst_nents =3D mapped_dst_nents;=0A=
>  =0A=
> +	edesc->jrentry.base =3D &req->base;=0A=
> +=0A=
>  	edesc->sec4_sg_dma =3D dma_map_single(dev, edesc->sec4_sg,=0A=
>  					    sec4_sg_bytes, DMA_TO_DEVICE);=0A=
>  	if (dma_mapping_error(dev, edesc->sec4_sg_dma)) {=0A=
[...]=0A=
> @@ -633,7 +638,10 @@ static int caam_rsa_enc(struct akcipher_request *req=
)=0A=
>  	/* Initialize Job Descriptor */=0A=
>  	init_rsa_pub_desc(edesc->hw_desc, &edesc->pdb.pub);=0A=
>  =0A=
> -	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done, req);=0A=
> +	jrentry =3D &edesc->jrentry;=0A=
> +	jrentry->base =3D &req->base;=0A=
This field is already set in rsa_edesc_alloc().=0A=
=0A=
> @@ -666,7 +675,10 @@ static int caam_rsa_dec_priv_f1(struct akcipher_requ=
est *req)=0A=
>  	/* Initialize Job Descriptor */=0A=
>  	init_rsa_priv_f1_desc(edesc->hw_desc, &edesc->pdb.priv_f1);=0A=
>  =0A=
> -	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);=
=0A=
> +	jrentry =3D &edesc->jrentry;=0A=
> +	jrentry->base =3D &req->base;=0A=
The same here.=0A=
=0A=
> @@ -699,7 +712,10 @@ static int caam_rsa_dec_priv_f2(struct akcipher_requ=
est *req)=0A=
>  	/* Initialize Job Descriptor */=0A=
>  	init_rsa_priv_f2_desc(edesc->hw_desc, &edesc->pdb.priv_f2);=0A=
>  =0A=
> -	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);=
=0A=
> +	jrentry =3D &edesc->jrentry;=0A=
> +	jrentry->base =3D &req->base;=0A=
And here.=0A=
=0A=
> @@ -732,7 +749,10 @@ static int caam_rsa_dec_priv_f3(struct akcipher_requ=
est *req)=0A=
>  	/* Initialize Job Descriptor */=0A=
>  	init_rsa_priv_f3_desc(edesc->hw_desc, &edesc->pdb.priv_f3);=0A=
>  =0A=
> -	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);=
=0A=
> +	jrentry =3D &edesc->jrentry;=0A=
> +	jrentry->base =3D &req->base;=0A=
Also here.=0A=
=0A=
> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h=
=0A=
> index c7c10c9..58be66c 100644=0A=
> --- a/drivers/crypto/caam/intern.h=0A=
> +++ b/drivers/crypto/caam/intern.h=0A=
[...]=0A=
> @@ -104,6 +105,15 @@ struct caam_drv_private {=0A=
>  #endif=0A=
>  };=0A=
>  =0A=
> +/*=0A=
> + * Storage for tracking each request that is processed by a ring=0A=
> + */=0A=
> +struct caam_jr_request_entry {=0A=
> +	/* Common attributes for async crypto requests */=0A=
> +	struct crypto_async_request *base;=0A=
> +	bool bklog;	/* Stored to determine if the request needs backlog */=0A=
> +};=0A=
> +=0A=
Could we use kernel-doc here?=0A=
=0A=
Horia=0A=
