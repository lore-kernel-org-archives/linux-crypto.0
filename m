Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C00C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 13:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52E432083B
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 13:26:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ScE79fmd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfF0N0o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 09:26:44 -0400
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:7022
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726059AbfF0N0o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 09:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gyMevtMb9EwFRn5zNy9qWVNQjV6M96HZ+ziXnigQpsA=;
 b=ScE79fmdF0iVRUa9mWlpV2CwjoC8QwJt2lp2S+Gzj4o6Vhqju11GIPuikko1nnyBkFCmN/ZUCsX2dfohNKDgGILfBgrfYhGPjKTVHqXFUCdiOn0loC9CHp1nfI4tVv//SepqrLS1q2+AvSfFAy7FmCG0gXFRnDUOLAawn/y1U98=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3853.eurprd04.prod.outlook.com (52.134.16.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 13:26:40 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2008.014; Thu, 27 Jun 2019
 13:26:40 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Subject: Re: [PATCH v2 06/30] crypto: caam/des - switch to new verification
 routines
Thread-Topic: [PATCH v2 06/30] crypto: caam/des - switch to new verification
 routines
Thread-Index: AQHVLOBY89fT5Pwhp0Geyrqw7e8u3g==
Date:   Thu, 27 Jun 2019 13:26:40 +0000
Message-ID: <VI1PR0402MB348532DF646DA7522F7B689698FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
 <20190627120314.7197-7-ard.biesheuvel@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7616284f-9198-411e-f61e-08d6fb0316ea
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB3853;
x-ms-traffictypediagnostic: VI1PR0402MB3853:
x-microsoft-antispam-prvs: <VI1PR0402MB38535A81AC372075080A6A5498FD0@VI1PR0402MB3853.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(396003)(366004)(376002)(189003)(199004)(256004)(66946007)(6506007)(86362001)(316002)(53546011)(26005)(99286004)(44832011)(102836004)(81156014)(76176011)(71200400001)(71190400001)(6116002)(6246003)(305945005)(3846002)(74316002)(2501003)(14454004)(33656002)(68736007)(8676002)(73956011)(7696005)(476003)(81166006)(5660300002)(478600001)(7736002)(486006)(186003)(14444005)(4326008)(64756008)(66066001)(52536014)(2906002)(66446008)(6436002)(54906003)(229853002)(110136005)(66476007)(8936002)(15650500001)(53936002)(25786009)(9686003)(446003)(55016002)(66556008)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3853;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U5+DovVvPe+AulRpMlxt8c60KxtCj/B8a+qznLpKl1PalukQzN1ib0JMuhysAyvD8PIUA4M/ljsOox0G4SQt1Mdga9Eo5ALDcuUQb3ZkbmjDTlO5b770bQJ49v0RlGEJIh2PziDhCFjTlI+kaQbWoV/FCtoPCwlnNOfjqWbyAuLjmosnZDi59QoNB/KHn8e9Fi49vZ49lqz8Q7QjFnqdwqk9aAGev034c/uaKAOGkM7WzK2pFWVEUiFaHVcc+wqrpTOah3LcmUOdbJrqjpi6wjPhoxmIz2gVTNKa3mrqR6/L8gguLXRAI75Ve2hx8At4aOa3BVRWbsjhfYv48VlpZ3Hef5YRHAYgoz49uQkTzD1RCTE3ECqgFV7wTu2SQaapXR834Hf6M0lvpjaFOMKC3nQ708EUKVpmfks7w1vHVK8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7616284f-9198-411e-f61e-08d6fb0316ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 13:26:40.5845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3853
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/27/2019 3:03 PM, Ard Biesheuvel wrote:=0A=
> @@ -785,20 +781,23 @@ static int skcipher_setkey(struct crypto_skcipher *=
skcipher, const u8 *key,=0A=
>  static int des_skcipher_setkey(struct crypto_skcipher *skcipher,=0A=
>  			       const u8 *key, unsigned int keylen)=0A=
>  {=0A=
> -	u32 tmp[DES3_EDE_EXPKEY_WORDS];=0A=
> -	struct crypto_tfm *tfm =3D crypto_skcipher_tfm(skcipher);=0A=
> +	int err;=0A=
>  =0A=
> -	if (keylen =3D=3D DES3_EDE_KEY_SIZE &&=0A=
> -	    __des3_ede_setkey(tmp, &tfm->crt_flags, key, DES3_EDE_KEY_SIZE)) {=
=0A=
> -		return -EINVAL;=0A=
> -	}=0A=
> +	err =3D crypto_des_verify_key(crypto_skcipher_tfm(skcipher), key);=0A=
> +	if (unlikely(err))=0A=
> +		return err;=0A=
>  =0A=
> -	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &=0A=
> -	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {=0A=
> -		crypto_skcipher_set_flags(skcipher,=0A=
> -					  CRYPTO_TFM_RES_WEAK_KEY);=0A=
> -		return -EINVAL;=0A=
> -	}=0A=
> +	return skcipher_setkey(skcipher, key, keylen);=0A=
=0A=
This would be a bit more compact:=0A=
=0A=
	return unlikely(crypto_des_verify_key(crypto_skcipher_tfm(skcipher), key))=
 ?:=0A=
	       skcipher_setkey(skcipher, key, keylen);=0A=
=0A=
and could be used in most places.=0A=
=0A=
Actually here:=0A=
=0A=
> @@ -697,8 +693,13 @@ static int skcipher_setkey(struct crypto_skcipher *s=
kcipher, const u8 *key,=0A=
>  static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,=0A=
>  				const u8 *key, unsigned int keylen)=0A=
>  {=0A=
> -	return unlikely(des3_verify_key(skcipher, key)) ?:=0A=
> -	       skcipher_setkey(skcipher, key, keylen);=0A=
> +	int err;=0A=
> +=0A=
> +	err =3D crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key);=
=0A=
> +	if (unlikely(err))=0A=
> +		return err;=0A=
> +=0A=
> +	return skcipher_setkey(skcipher, key, keylen);=0A=
>  }=0A=
=0A=
this pattern is already used, only the verification function=0A=
has to be replaced.=0A=
=0A=
Horia=0A=
