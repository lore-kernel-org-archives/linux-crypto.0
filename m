Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EA2C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 09:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91AE920843
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 09:58:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ofPA8Qj8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfF0J6E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 05:58:04 -0400
Received: from mail-eopbgr130055.outbound.protection.outlook.com ([40.107.13.55]:53946
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbfF0J6E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 05:58:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPfeXhm6D2agRFUHBOjUtedxomL5AmEiF9vJR6LO7IA=;
 b=ofPA8Qj8JegMkOCqC2+B22jfDrcrApyCgyO8ZmPHi5wqHNq/Wjgy/ZvLQNSxhkW171AyWOG51Cw//7ExBOMXS83wouyiVfvw8wTMiah+uQukiUjx53TgSnbYPKAj4jYdVh2Iq5dbaETj9bXkS1ceTZDVfHNvXMB+s0PcHPtxq5A=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3807.eurprd04.prod.outlook.com (52.134.16.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 09:57:59 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2008.014; Thu, 27 Jun 2019
 09:57:59 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: Re: [RFC PATCH 06/30] crypto: caam/des - switch to new verification
 routines
Thread-Topic: [RFC PATCH 06/30] crypto: caam/des - switch to new verification
 routines
Thread-Index: AQHVKJHoKzHqX3yvGUWbxJWx4NJmMw==
Date:   Thu, 27 Jun 2019 09:57:59 +0000
Message-ID: <VI1PR0402MB34854404F8EBC4E158ED386F98FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
 <20190622003112.31033-7-ard.biesheuvel@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c87f71dc-2f1b-42ce-560f-08d6fae5efe6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3807;
x-ms-traffictypediagnostic: VI1PR0402MB3807:
x-microsoft-antispam-prvs: <VI1PR0402MB380796E4CF80B860E6C759A398FD0@VI1PR0402MB3807.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(39860400002)(376002)(189003)(199004)(66946007)(76116006)(73956011)(66066001)(33656002)(2501003)(66476007)(66556008)(66446008)(64756008)(478600001)(6116002)(14454004)(3846002)(68736007)(5660300002)(8936002)(8676002)(14444005)(74316002)(53546011)(486006)(305945005)(256004)(2906002)(44832011)(102836004)(186003)(6436002)(229853002)(7736002)(446003)(52536014)(476003)(26005)(86362001)(76176011)(110136005)(54906003)(6246003)(6506007)(9686003)(25786009)(4326008)(53936002)(7696005)(81166006)(71200400001)(71190400001)(99286004)(55016002)(81156014)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3807;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: y/HrHX59AKcSa/gvGWNF3wlSRaJaY+QWgwQD80l/D2l1eBEbqC9JmIGK1FKedrYO80RUFWV+d+ffSL3+l9PDWB4AXnccKwoH+EMq9Zz8dMHBq8iyIr84YE1JB/fSb15rXzMhuZDlLN3XuQKFFDmPoC+ttr8Yuh9862LdG4Vczt+iYzdXr+n2GR+Qp0UhbwPt3imdBROWQ1xbw/JVtT9G4zZL2jGfJftbZVIQD4pTT5LPdB/fGGQr42rw00RScHHzf6rXbPjzL4M4ugaFRD1LhrMqtqxNvF1XnzWbPaaDjHHFo2pfRvkMVOavQZdfNR3/llmcMC94Dn7UPnaKzkPxLiMpcZIFMCyPnykUhGfO/d6gKIZ/MFIi3YzpehvdXgDd57kHv53YNIsz5vphniPhZYQ5AMJswm/deaMDmokLF38=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c87f71dc-2f1b-42ce-560f-08d6fae5efe6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 09:57:59.8168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3807
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/22/2019 3:32 AM, Ard Biesheuvel wrote:=0A=
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>=0A=
> ---=0A=
>  drivers/crypto/caam/caamalg.c     | 13 +++--------=0A=
>  drivers/crypto/caam/caamalg_qi.c  | 23 ++++++++++----------=0A=
>  drivers/crypto/caam/caamalg_qi2.c | 23 ++++++++++----------=0A=
>  drivers/crypto/caam/compat.h      |  2 +-=0A=
>  4 files changed, 26 insertions(+), 35 deletions(-)=0A=
> =0A=
Compiling the patch set, I get the following errors:=0A=
=0A=
drivers/crypto/caam/caamalg.c: In function 'des3_aead_setkey':=0A=
drivers/crypto/caam/caamalg.c:642:51: error: 'tfm' undeclared (first use in=
 this function)=0A=
  err =3D crypto_des3_ede_verify_key(crypto_aead_tfm(tfm), keys.enckey,=0A=
                                                   ^=0A=
drivers/crypto/caam/caamalg.c:642:51: note: each undeclared identifier is r=
eported only once for each function it appears in=0A=
drivers/crypto/caam/caamalg.c: In function 'des_skcipher_setkey':=0A=
drivers/crypto/caam/caamalg.c:783:2: error: implicit declaration of functio=
n 'des_verify_key' [-Werror=3Dimplicit-function-declaration]=0A=
  err =3D des_verify_key(crypto_skcipher_tfm(skcipher), key, keylen);=0A=
  ^=0A=
drivers/crypto/caam/caamalg.c: In function 'des3_skcipher_setkey':=0A=
drivers/crypto/caam/caamalg.c:795:28: warning: passing argument 1 of 'des3_=
ede_verify_key' from incompatible pointer type=0A=
  err =3D des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key, keylen);=
=0A=
                            ^=0A=
In file included from drivers/crypto/caam/compat.h:35:0,=0A=
                 from drivers/crypto/caam/caamalg.c:49:=0A=
./include/crypto/internal/des.h:49:19: note: expected 'const u8 *' but argu=
ment is of type 'struct crypto_tfm *'=0A=
 static inline int des3_ede_verify_key(const u8 *key, unsigned int key_len,=
=0A=
                   ^=0A=
drivers/crypto/caam/caamalg.c:795:59: warning: passing argument 2 of 'des3_=
ede_verify_key' makes integer from pointer without a cast=0A=
  err =3D des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key, keylen);=
=0A=
                                                           ^=0A=
In file included from drivers/crypto/caam/compat.h:35:0,=0A=
                 from drivers/crypto/caam/caamalg.c:49:=0A=
./include/crypto/internal/des.h:49:19: note: expected 'unsigned int' but ar=
gument is of type 'const u8 *'=0A=
 static inline int des3_ede_verify_key(const u8 *key, unsigned int key_len,=
=0A=
                   ^=0A=
=0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index 5d4fa65a015f..b4ab64146b21 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -633,23 +633,16 @@ static int des3_aead_setkey(struct crypto_aead *aea=
d, const u8 *key,=0A=
>  			    unsigned int keylen)=0A=
>  {=0A=
>  	struct crypto_authenc_keys keys;=0A=
> -	u32 flags;=0A=
>  	int err;=0A=
>  =0A=
>  	err =3D crypto_authenc_extractkeys(&keys, key, keylen);=0A=
>  	if (unlikely(err))=0A=
>  		goto badkey;=0A=
>  =0A=
> -	err =3D -EINVAL;=0A=
> -	if (keys.enckeylen !=3D DES3_EDE_KEY_SIZE)=0A=
> -		goto badkey;=0A=
> -=0A=
> -	flags =3D crypto_aead_get_flags(aead);=0A=
> -	err =3D __des3_verify_key(&flags, keys.enckey);=0A=
> -	if (unlikely(err)) {=0A=
> -		crypto_aead_set_flags(aead, flags);=0A=
> +	err =3D crypto_des3_ede_verify_key(crypto_aead_tfm(tfm), keys.enckey,=
=0A=
> +					 keys.enckeylen);=0A=
> +	if (unlikely(err))=0A=
>  		goto out;=0A=
> -	}=0A=
>  =0A=
>  	err =3D aead_setkey(aead, key, keylen);=0A=
>  =0A=
> diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caama=
lg_qi.c=0A=
> index 32f0f8a72067..01d92ef0142a 100644=0A=
> --- a/drivers/crypto/caam/caamalg_qi.c=0A=
> +++ b/drivers/crypto/caam/caamalg_qi.c=0A=
> @@ -296,23 +296,16 @@ static int des3_aead_setkey(struct crypto_aead *aea=
d, const u8 *key,=0A=
>  			    unsigned int keylen)=0A=
>  {=0A=
>  	struct crypto_authenc_keys keys;=0A=
> -	u32 flags;=0A=
>  	int err;=0A=
>  =0A=
>  	err =3D crypto_authenc_extractkeys(&keys, key, keylen);=0A=
>  	if (unlikely(err))=0A=
>  		goto badkey;=0A=
>  =0A=
> -	err =3D -EINVAL;=0A=
> -	if (keys.enckeylen !=3D DES3_EDE_KEY_SIZE)=0A=
> -		goto badkey;=0A=
> -=0A=
> -	flags =3D crypto_aead_get_flags(aead);=0A=
> -	err =3D __des3_verify_key(&flags, keys.enckey);=0A=
> -	if (unlikely(err)) {=0A=
> -		crypto_aead_set_flags(aead, flags);=0A=
> +	err =3D crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey,=
=0A=
> +					 keys.enckeylen);=0A=
> +	if (unlikely(err))=0A=
>  		goto out;=0A=
> -	}=0A=
>  =0A=
>  	err =3D aead_setkey(aead, key, keylen);=0A=
>  =0A=
> @@ -697,8 +690,14 @@ static int skcipher_setkey(struct crypto_skcipher *s=
kcipher, const u8 *key,=0A=
>  static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,=0A=
>  				const u8 *key, unsigned int keylen)=0A=
>  {=0A=
> -	return unlikely(des3_verify_key(skcipher, key)) ?:=0A=
> -	       skcipher_setkey(skcipher, key, keylen);=0A=
> +	int err;=0A=
> +=0A=
> +	err =3D crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key,=
=0A=
> +					 keylen);=0A=
> +	if (unlikely(err))=0A=
> +		return err;=0A=
> +=0A=
> +	return skcipher_setkey(skcipher, key, keylen);=0A=
>  }=0A=
>  =0A=
>  static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u=
8 *key,=0A=
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caam=
alg_qi2.c=0A=
> index 06bf32c32cbd..074fbb8356e5 100644=0A=
> --- a/drivers/crypto/caam/caamalg_qi2.c=0A=
> +++ b/drivers/crypto/caam/caamalg_qi2.c=0A=
> @@ -329,23 +329,16 @@ static int des3_aead_setkey(struct crypto_aead *aea=
d, const u8 *key,=0A=
>  			    unsigned int keylen)=0A=
>  {=0A=
>  	struct crypto_authenc_keys keys;=0A=
> -	u32 flags;=0A=
>  	int err;=0A=
>  =0A=
>  	err =3D crypto_authenc_extractkeys(&keys, key, keylen);=0A=
>  	if (unlikely(err))=0A=
>  		goto badkey;=0A=
>  =0A=
> -	err =3D -EINVAL;=0A=
> -	if (keys.enckeylen !=3D DES3_EDE_KEY_SIZE)=0A=
> -		goto badkey;=0A=
> -=0A=
> -	flags =3D crypto_aead_get_flags(aead);=0A=
> -	err =3D __des3_verify_key(&flags, keys.enckey);=0A=
> -	if (unlikely(err)) {=0A=
> -		crypto_aead_set_flags(aead, flags);=0A=
> +	err =3D crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey,=
=0A=
> +					 keys.enckeylen);=0A=
> +	if (unlikely(err))=0A=
>  		goto out;=0A=
> -	}=0A=
>  =0A=
>  	err =3D aead_setkey(aead, key, keylen);=0A=
>  =0A=
> @@ -999,8 +992,14 @@ static int skcipher_setkey(struct crypto_skcipher *s=
kcipher, const u8 *key,=0A=
>  static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,=0A=
>  				const u8 *key, unsigned int keylen)=0A=
>  {=0A=
> -	return unlikely(des3_verify_key(skcipher, key)) ?:=0A=
> -	       skcipher_setkey(skcipher, key, keylen);=0A=
> +	int err;=0A=
> +=0A=
> +	err =3D crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key,=
=0A=
> +					 keylen);=0A=
> +	if (unlikely(err))=0A=
> +		return err;=0A=
> +=0A=
> +	return skcipher_setkey(skcipher, key, keylen);=0A=
>  }=0A=
>  =0A=
>  static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u=
8 *key,=0A=
> diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h=
=0A=
> index 8639b2df0371..60e2a54c19f1 100644=0A=
> --- a/drivers/crypto/caam/compat.h=0A=
> +++ b/drivers/crypto/caam/compat.h=0A=
> @@ -32,7 +32,7 @@=0A=
>  #include <crypto/null.h>=0A=
>  #include <crypto/aes.h>=0A=
>  #include <crypto/ctr.h>=0A=
> -#include <crypto/des.h>=0A=
> +#include <crypto/internal/des.h>=0A=
>  #include <crypto/gcm.h>=0A=
>  #include <crypto/sha.h>=0A=
>  #include <crypto/md5.h>=0A=
> =0A=
=0A=
