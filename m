Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B412C76195
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 10:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4001921851
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 10:08:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="TEKSvzQG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfGSKIh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 06:08:37 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:64067
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725794AbfGSKIh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 06:08:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CcU10ifY89d1sgEu08MHlYDAXLSLXqtvLURX/UHjhdnozZ0/6yf0G9hozb85NHhO27KLsGB/ukqbaBgOwzJr/lGF3cgzHukxVIlMxlsGiqTVcx4DWirxzAa4HsQlU52E8PqXmmT3LJ+1qZ0/MC7KDM8alZSqc0wU1pTN3gSBiQVU9l9V29JrYt7JOrTNCLxjb4GOVp+DF2fYkL3yZa0kPiOCCECOCbgcVSAHqNCDRwrditriJgc3q9M91bo8uLt7OgGW9Zpke5FlOJIwMwvjcUJpv9IeiTZ7UaBh8pb1boB7ghQbuCBlZaWziXdSEcdmmZXQgKdiUrvAm2OX9ynVhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFXReoj9qkBzR0qlZe4HPyQSGnt+PAUVIRSj9fzhf/U=;
 b=VjnsbvebQi3RRfe1eLmL6fg1XlCjsKDnIHcwgqJffiv3LSuJppZjEdV+HJurGYb3Pf9gRNng3vyTFVawmzczy8Yoesh0dGlWpJPu1I67+PKUQYp4M1UAMOBWipW5zXqeG4Pwt7OsTFfEI4EUJXWE4xLDKYAaJLn9kl2ZsvXv4c9qbEJK7CoqE/fC3UAkHNlrtr6rJsDXje/j2LZ7eMk/ptfR3EkvYKtx2ITj4tw60QIV6b1bwJBGh0goMJCJmIJ+QRT3th/OFuapm5pYzGCcwN3o54u10vMtQQot14mtycj+z4DL1QN47t9wIMgH3tYpMTk15FoccWFLbMl0cVXjNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFXReoj9qkBzR0qlZe4HPyQSGnt+PAUVIRSj9fzhf/U=;
 b=TEKSvzQG6ANDelBrFscNR3rJuKAL159czXEDhe8y6vMvgp8NNNg74q6ZMKrfKBhM4tTtXKfiOqtWlTbCyBeyfvh2DTsyAMPiv9pOMFeegtzsj3qDRseziTYEMvYSSn9gI6zNNcRTGbi5pBMczsz4nDUKuj7K/xZCXQgmdiefCnA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3438.eurprd04.prod.outlook.com (52.134.3.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 10:08:32 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 10:08:32 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 09/14] crypto: caam - keep both virtual and dma key
 addresses
Thread-Topic: [PATCH v2 09/14] crypto: caam - keep both virtual and dma key
 addresses
Thread-Index: AQHVPcSrL0fOkGV3mUijL9yeORi/pQ==
Date:   Fri, 19 Jul 2019 10:08:32 +0000
Message-ID: <VI1PR0402MB348509F1A53E377B9343976198CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
 <1563494276-3993-10-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8752321e-6cd3-486d-8abe-08d70c310e4d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3438;
x-ms-traffictypediagnostic: VI1PR0402MB3438:
x-microsoft-antispam-prvs: <VI1PR0402MB34382091197DBDD5E919C8CB98CB0@VI1PR0402MB3438.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(396003)(346002)(39860400002)(189003)(199004)(66556008)(305945005)(44832011)(25786009)(256004)(476003)(6246003)(68736007)(66946007)(486006)(66066001)(7736002)(66476007)(64756008)(6636002)(14444005)(99286004)(76176011)(6116002)(7696005)(66446008)(229853002)(3846002)(33656002)(52536014)(2906002)(4326008)(446003)(53546011)(5660300002)(6506007)(76116006)(26005)(102836004)(186003)(71200400001)(71190400001)(86362001)(53936002)(14454004)(8676002)(81156014)(81166006)(8936002)(478600001)(55016002)(9686003)(6436002)(316002)(91956017)(74316002)(54906003)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3438;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZvX81TijFiW+FoSYZpMacM/nD0LqussgjA0lqOuS4gskVyvYQUwqrcovdTkhd5gIfw50mOMUku/bkdEo6qCSKM4E+2l0AIAQeLohQbVtnq/BJUBqnfT9T2VSfajQetb83ebc7izxlomevMv3AmZv9E4dKmXwCYFNsaO0O1e+Q520LT64+PCTii9CIvoRIdY65xYVOPpyp0I5HKFyqbb20B6uO1npFlqCnFZgIOam+gR36i9UvrcEaDK6nv8JZKnp202wPMYI5+JjybgEg6PXM/bhWaLSJ0YfrGMP3Ds6tX4FwxygJ1UZ5YsBCQF1eWHl/Mtjwf7M4aCCKWf2cj4svPW8/C3a4N60sD0ahRcQX93gQRJkkkLXyEGvHzK185ENBcJJyltS3fgKyFJOG3TlYfaM+eACUgXMtuGVksi+oTA=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8752321e-6cd3-486d-8abe-08d70c310e4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 10:08:32.8038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3438
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/2019 2:58 AM, Iuliana Prodan wrote:=0A=
> From: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> Update alginfo struct to keep both virtual and dma key addresses,=0A=
> so that descriptors have them at hand.=0A=
> One example where this is needed is in the xcbc(aes) shared descriptors,=
=0A=
> which are updated in current patch.=0A=
> Another example is the upcoming fix for DKP.=0A=
> =0A=
> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> ---=0A=
>  drivers/crypto/caam/caamhash.c      | 26 ++++++++++++--------------=0A=
>  drivers/crypto/caam/caamhash_desc.c |  5 ++---=0A=
>  drivers/crypto/caam/caamhash_desc.h |  2 +-=0A=
>  drivers/crypto/caam/desc_constr.h   | 10 ++++------=0A=
>  4 files changed, 19 insertions(+), 24 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhas=
h.c=0A=
> index 2ec4bad..14fdfa1 100644=0A=
> --- a/drivers/crypto/caam/caamhash.c=0A=
> +++ b/drivers/crypto/caam/caamhash.c=0A=
[...]=0A=
> @@ -508,6 +502,10 @@ static int axcbc_setkey(struct crypto_ahash *ahash, =
const u8 *key,=0A=
>  	memcpy(ctx->key, key, keylen);=0A=
>  	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);=
=0A=
>  	ctx->adata.keylen =3D keylen;=0A=
> +	/* key is loaded from memory for UPDATE and FINALIZE states */=0A=
> +	ctx->adata.key_dma =3D ctx->key_dma;=0A=
> +	/* key is immediate data for INIT and INITFINAL states */=0A=
> +	ctx->adata.key_virt =3D ctx->key;=0A=
>  =0A=
Now that it's possible to store both virtual and dma key addresses,=0A=
it would be more efficient to move these assignments .cra_init callback.=0A=
=0A=
I'll submit the changes in v3.=0A=
=0A=
Horia=0A=
=0A=
[...]=0A=
> diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc=
_constr.h=0A=
> index 5988a26..8154174 100644=0A=
> --- a/drivers/crypto/caam/desc_constr.h=0A=
> +++ b/drivers/crypto/caam/desc_constr.h=0A=
> @@ -457,8 +457,8 @@ do { \=0A=
>   *           functions where it is used.=0A=
>   * @keylen: length of the provided algorithm key, in bytes=0A=
>   * @keylen_pad: padded length of the provided algorithm key, in bytes=0A=
> - * @key: address where algorithm key resides; virtual address if key_inl=
ine=0A=
> - *       is true, dma (bus) address if key_inline is false.=0A=
> + * @key_dma: dma (bus) address where algorithm key resides=0A=
> + * @key_virt: virtual address where algorithm key resides=0A=
>   * @key_inline: true - key can be inlined in the descriptor; false - key=
 is=0A=
>   *              referenced by the descriptor=0A=
>   */=0A=
> @@ -466,10 +466,8 @@ struct alginfo {=0A=
>  	u32 algtype;=0A=
>  	unsigned int keylen;=0A=
>  	unsigned int keylen_pad;=0A=
> -	union {=0A=
> -		dma_addr_t key_dma;=0A=
> -		const void *key_virt;=0A=
> -	};=0A=
> +	dma_addr_t key_dma;=0A=
> +	const void *key_virt;=0A=
>  	bool key_inline;=0A=
>  };=0A=
>  =0A=
> =0A=
