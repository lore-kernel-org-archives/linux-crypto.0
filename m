Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597D3C76188
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 14:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3B552077C
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 14:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IPn83iSZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfGSOib (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 10:38:31 -0400
Received: from mail-eopbgr00084.outbound.protection.outlook.com ([40.107.0.84]:7815
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729238AbfGSOia (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 10:38:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2OLTAlmyoq7ZelUxA7tY1mmUUjL03p9j30WfJLFTJcilpUE2RYjtIekjmrY42BrH863d2Pa8CsrlVACV2T4uyeVwH94V9HotZ52irrsBg/1ZzmBrYK0Ug4YV3QMOH8is60NOvDyXVlDflpq8iwQyXSEnqcVbakNoymynmA60iN93zHc++IwHwHDKlzsyz/BrvfgHUWPPIIvgdSQrtLxUzW8fc67FiO+Ly/XMcAGjPgIiHoZG4x+wYUfwvZ6PAXuALPOWka0fz273J14b9gFx0tFYHqHkXAl1lCr0P73xsFQlIJ2Ga9QdlBxTr+mpiHYh2Uib4dRS9iWMC6u/gBJXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUDwEzmzzjm2bjaXbWUVHFyi3pJFliRK14CNAKAQ60c=;
 b=RM/wJNMdsqxMcBt5KPMPjbo3Oc8Jl7xSllpFQqXedR0ujRc9p46nMK+20yP1j/sFC5JsgvBr9diS1MQMRjR/q8XEW3x5oq3llQ44CppRwQZXJAdiVA+H6LkdMEJIhVUMYYEm4I6aD3YKwjre3dhgaMNKoR7kMtym3/iDE/dkXg6oNMlyi2V7aiD3oOTpUXChn/hKFoUQpW4WnPGqf5XPgVlQVBlxpBvoUrnLnEDDUUL2mH0/ODvpuJQ9BzDmvndS0T5pL1N/52zYxdBdzgmV647JxnlPb07nKZhbz0j4SasZvTialYHFYTQMHYWtDxcAWv93uxVixdWNnpDEmSukVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUDwEzmzzjm2bjaXbWUVHFyi3pJFliRK14CNAKAQ60c=;
 b=IPn83iSZFWZnE0NYTW/+8c+LLkynqQb53BM581Gk8iTCEMBNLf2TyEyDuePRFK+vtavCa76OkzY4ap35/EQOWlrnka417TNuLFMaEJhK6vUhUhcrkyKBq5kfqgiHyHTgweTBUyshKppJaY1tE/7eHLbiP/Yo3axwG8e7qz5/tZ4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1SPR00MB252.eurprd04.prod.outlook.com (10.172.82.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.12; Fri, 19 Jul 2019 14:38:25 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 14:38:25 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 04/14] crypto: caam - check key length
Thread-Topic: [PATCH v2 04/14] crypto: caam - check key length
Thread-Index: AQHVPcSq554Fd8UEEU2cDr3CFuYMbg==
Date:   Fri, 19 Jul 2019 14:38:25 +0000
Message-ID: <VI1PR0402MB34855E46247C86307CFE871898CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
 <1563494276-3993-5-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb566b9e-39e8-410b-d40d-08d70c56c1b0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1SPR00MB252;
x-ms-traffictypediagnostic: VI1SPR00MB252:
x-microsoft-antispam-prvs: <VI1SPR00MB252A81DB1AA1E87C8B74F9C98CB0@VI1SPR00MB252.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(189003)(199004)(256004)(8936002)(26005)(7696005)(76116006)(68736007)(91956017)(86362001)(186003)(76176011)(14444005)(6506007)(25786009)(53546011)(8676002)(81166006)(102836004)(33656002)(478600001)(7736002)(81156014)(476003)(74316002)(14454004)(53936002)(446003)(305945005)(6436002)(44832011)(3846002)(486006)(2906002)(4326008)(6636002)(316002)(9686003)(55016002)(6246003)(6116002)(52536014)(5660300002)(66946007)(66556008)(64756008)(66446008)(66476007)(71190400001)(71200400001)(229853002)(110136005)(66066001)(54906003)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR00MB252;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zj4tyhvOYhJVcTNgKLGOkyhiOP13gjduWwirxRyPdLB1MoiukC3lurgkvoCRetJWzODM/J14e0zAsthxjZqdgN4zJsW1e97WT2rQRbPdXe3trNj96DyVszO8bEe1asd9ec0U6t9hRPCGFot3AApJUdlC+4srMGebbDGjDl1q/OI+HMiZrbm5xeby4gN8WGi8vWiZhg0jvvpzKFZrz7YbJPKkoq/iXxDK39j5PeiZnbyE5ou/Djnx21u+a9UIAH4wI/izsn8v19K+dAwyLfQede1lP77lMll33g5suGohvNzqCsqjqTmfdnxj5zOoM01rVKhX8iVE17h0kAZZDgmtjiDJnBAZUPvuDFim+zHw3EbJQtYIyHH2DsTJXbbwkR7hPHnnggwEzIEW3I3VntyaOgx6KtbArlWoBdBwgUrAzQ0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb566b9e-39e8-410b-d40d-08d70c56c1b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 14:38:25.1217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR00MB252
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/2019 2:58 AM, Iuliana Prodan wrote:=0A=
> Check key length to solve the extra tests that expect -EINVAL to be=0A=
> returned when the key size is not valid.=0A=
> =0A=
> Validated AES keylen for skcipher and ahash.=0A=
> =0A=
Also aead was updated.=0A=
=0A=
> The check_aes_keylen function is added in a common file, to be used=0A=
> also for caam/qi and caam/qi2.=0A=
> =0A=
[...]=0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index 28d55a0..6ac59b1 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
[...]=0A=
> @@ -683,10 +691,17 @@ static int rfc4106_setkey(struct crypto_aead *aead,=
=0A=
>  {=0A=
>  	struct caam_ctx *ctx =3D crypto_aead_ctx(aead);=0A=
>  	struct device *jrdev =3D ctx->jrdev;=0A=
> +	int err;=0A=
>  =0A=
>  	if (keylen < 4)=0A=
>  		return -EINVAL;=0A=
>  =0A=
This is no longer needed, check_aes_keylen() catches this case too.=0A=
=0A=
> +	err =3D check_aes_keylen(keylen - 4);=0A=
> +	if (err) {=0A=
> +		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);=0A=
> +		return err;=0A=
> +	}=0A=
> +=0A=
>  	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",=0A=
>  			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);=0A=
>  =0A=
> @@ -707,10 +722,17 @@ static int rfc4543_setkey(struct crypto_aead *aead,=
=0A=
>  {=0A=
>  	struct caam_ctx *ctx =3D crypto_aead_ctx(aead);=0A=
>  	struct device *jrdev =3D ctx->jrdev;=0A=
> +	int err;=0A=
>  =0A=
>  	if (keylen < 4)=0A=
>  		return -EINVAL;=0A=
>  =0A=
Same here, check_aes_keylen() handles this case.=0A=
=0A=
> +	err =3D check_aes_keylen(keylen - 4);=0A=
> +	if (err) {=0A=
> +		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);=0A=
> +		return err;=0A=
> +	}=0A=
> +=0A=
>  	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",=0A=
>  			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);=0A=
>  =0A=
[...]=0A=
> diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caama=
lg_qi.c=0A=
> index 66531d6..46097e3 100644=0A=
> --- a/drivers/crypto/caam/caamalg_qi.c=0A=
> +++ b/drivers/crypto/caam/caamalg_qi.c=0A=
> @@ -385,6 +385,12 @@ static int gcm_setkey(struct crypto_aead *aead,=0A=
>  	struct device *jrdev =3D ctx->jrdev;=0A=
>  	int ret;=0A=
>  =0A=
> +	ret =3D check_aes_keylen(keylen);=0A=
> +	if (ret) {=0A=
> +		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
>  	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",=0A=
>  			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);=0A=
>  =0A=
> @@ -483,6 +489,12 @@ static int rfc4106_setkey(struct crypto_aead *aead,=
=0A=
>  	if (keylen < 4)=0A=
>  		return -EINVAL;=0A=
>  =0A=
Same here, check_aes_keylen() handles this case.=0A=
=0A=
> +	ret =3D check_aes_keylen(keylen - 4);=0A=
> +	if (ret) {=0A=
> +		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
>  	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",=0A=
>  			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);=0A=
>  =0A=
> @@ -585,6 +597,12 @@ static int rfc4543_setkey(struct crypto_aead *aead,=
=0A=
>  	if (keylen < 4)=0A=
>  		return -EINVAL;=0A=
>  =0A=
Same here, check_aes_keylen() handles this case.=0A=
=0A=
> +	ret =3D check_aes_keylen(keylen - 4);=0A=
> +	if (ret) {=0A=
> +		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
>  	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",=0A=
>  			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);=0A=
>  =0A=
[...]=0A=
> +static int des_skcipher_setkey(struct crypto_skcipher *skcipher,=0A=
> +			       const u8 *key, unsigned int keylen)=0A=
> +{=0A=
> +	u32 tmp[DES_EXPKEY_WORDS];=0A=
> +=0A=
> +	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &=0A=
CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI needs to select CRYPTO_DES,=0A=
such that des_ekey is available.=0A=
=0A=
> +	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {=0A=
> +		crypto_skcipher_set_flags(skcipher,=0A=
> +					  CRYPTO_TFM_RES_WEAK_KEY);=0A=
> +		return -EINVAL;=0A=
> +	}=0A=
> +=0A=
> +	return skcipher_setkey(skcipher, key, keylen, 0);=0A=
>  }=0A=
>  =0A=
>  static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u=
8 *key,=0A=
[...]=0A=
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caam=
alg_qi2.c=0A=
> index bc370af..da4abf1 100644=0A=
> --- a/drivers/crypto/caam/caamalg_qi2.c=0A=
> +++ b/drivers/crypto/caam/caamalg_qi2.c=0A=
[...]=0A=
> @@ -817,10 +823,17 @@ static int rfc4106_setkey(struct crypto_aead *aead,=
=0A=
>  {=0A=
>  	struct caam_ctx *ctx =3D crypto_aead_ctx(aead);=0A=
>  	struct device *dev =3D ctx->dev;=0A=
> +	int ret;=0A=
>  =0A=
>  	if (keylen < 4)=0A=
>  		return -EINVAL;=0A=
>  =0A=
Same here, check_aes_keylen() handles this case.=0A=
=0A=
> +	ret =3D check_aes_keylen(keylen - 4);=0A=
> +	if (ret) {=0A=
> +		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
>  	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",=0A=
>  			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);=0A=
>  =0A=
> @@ -911,10 +924,17 @@ static int rfc4543_setkey(struct crypto_aead *aead,=
=0A=
>  {=0A=
>  	struct caam_ctx *ctx =3D crypto_aead_ctx(aead);=0A=
>  	struct device *dev =3D ctx->dev;=0A=
> +	int ret;=0A=
>  =0A=
>  	if (keylen < 4)=0A=
>  		return -EINVAL;=0A=
>  =0A=
Same here, check_aes_keylen() handles this case.=0A=
=0A=
> +	ret =3D check_aes_keylen(keylen - 4);=0A=
> +	if (ret) {=0A=
> +		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
>  	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",=0A=
>  			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);=0A=
>  =0A=
[...]=0A=
> +static int chacha20_skcipher_setkey(struct crypto_skcipher *skcipher,=0A=
> +				    const u8 *key, unsigned int keylen)=0A=
> +{=0A=
> +	return skcipher_setkey(skcipher, key, keylen, 0);=0A=
> +}=0A=
Missing check for key length.=0A=
=0A=
> +=0A=
> +static int des_skcipher_setkey(struct crypto_skcipher *skcipher,=0A=
> +			       const u8 *key, unsigned int keylen)=0A=
> +{=0A=
> +	u32 tmp[DES3_EDE_EXPKEY_WORDS];=0A=
> +	struct crypto_tfm *tfm =3D crypto_skcipher_tfm(skcipher);=0A=
> +=0A=
> +	if (keylen =3D=3D DES3_EDE_KEY_SIZE &&=0A=
> +	    __des3_ede_setkey(tmp, &tfm->crt_flags, key, DES3_EDE_KEY_SIZE)) {=
=0A=
> +		return -EINVAL;=0A=
> +	}=0A=
> +=0A=
> +	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &=0A=
CRYPTO_DEV_FSL_DPAA2_CAAM needs to select CRYPTO_DES,=0A=
such that __des3_ede_setkey and des_ekey are available.=0A=
=0A=
> +	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {=0A=
> +		crypto_skcipher_set_flags(skcipher,=0A=
> +					  CRYPTO_TFM_RES_WEAK_KEY);=0A=
> +		return -EINVAL;=0A=
> +	}=0A=
> +=0A=
> +	return skcipher_setkey(skcipher, key, keylen, 0);=0A=
>  }=0A=
[...]=0A=
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhas=
h.c=0A=
> index 73abefa..2ec4bad 100644=0A=
> --- a/drivers/crypto/caam/caamhash.c=0A=
> +++ b/drivers/crypto/caam/caamhash.c=0A=
> @@ -62,6 +62,7 @@=0A=
>  #include "desc_constr.h"=0A=
>  #include "jr.h"=0A=
>  #include "error.h"=0A=
> +#include "common_if.h"=0A=
>  #include "sg_sw_sec4.h"=0A=
>  #include "key_gen.h"=0A=
>  #include "caamhash_desc.h"=0A=
> @@ -501,6 +502,9 @@ static int axcbc_setkey(struct crypto_ahash *ahash, c=
onst u8 *key,=0A=
>  	struct caam_hash_ctx *ctx =3D crypto_ahash_ctx(ahash);=0A=
>  	struct device *jrdev =3D ctx->jrdev;=0A=
>  =0A=
> +	if (keylen !=3D AES_KEYSIZE_128)=0A=
> +		return -EINVAL;=0A=
> +=0A=
CRYPTO_TFM_RES_BAD_KEY_LEN flag should be set on the error path.=0A=
=0A=
>  	memcpy(ctx->key, key, keylen);=0A=
>  	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);=
=0A=
>  	ctx->adata.keylen =3D keylen;=0A=
> @@ -515,6 +519,13 @@ static int acmac_setkey(struct crypto_ahash *ahash, =
const u8 *key,=0A=
>  			unsigned int keylen)=0A=
>  {=0A=
>  	struct caam_hash_ctx *ctx =3D crypto_ahash_ctx(ahash);=0A=
> +	int err;=0A=
> +=0A=
> +	err =3D check_aes_keylen(keylen);=0A=
> +	if (err) {=0A=
> +		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);=0A=
> +		return err;=0A=
> +	}=0A=
>  =0A=
>  	/* key is immediate data for all cmac shared descriptors */=0A=
>  	ctx->adata.key_virt =3D key;=0A=
=0A=
Horia=0A=
