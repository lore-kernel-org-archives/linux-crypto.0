Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B827DC33CA2
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 16:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 853212073A
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 16:06:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="f4pI9bXZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgAHQGK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 11:06:10 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:63553 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728399AbgAHQGJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 11:06:09 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: nutv9ZNUF9QsbJSld5Xi2dVCAMacL/rmV2e6QosdpEFK/zm1KVQRZw3TsQBB0EDXwJYb+O0idC
 CiPIZ0/nTW3VovVqXjZA5COB5asWtqM57CP//wRDZFKlmRsxL2wqeokI+1JzWV4YlCC6Pt7I8t
 F2T4QjHmtnTOqfT4amE1BsuPavedXLa9xqoZCwFS0b4f9e9jT8cpIILdYJiEffSy7guHSgqsOB
 zJ640Txkbp548L5ZgCPMAwg22gjEfhu8e9sbAbDfbXWlNCtrI/asIyCMkifDt4DcDG/xmaT75k
 LrY=
X-IronPort-AV: E=Sophos;i="5.69,410,1571727600"; 
   d="scan'208";a="61974856"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jan 2020 09:06:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jan 2020 09:06:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Wed, 8 Jan 2020 09:06:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKHJ2UObMKLmhPvHlWj5iz+heeFK32F/oKoU/HKuA0KXPTya/E8zn1kenNNbiF3fQTiTYOHQ7bkAT/qKdRkQ2D9f9WJwKjz2zh6oeSp5kXj2l0+r6ixTA6KL0QyMBKDFt6kF31Rc1tv8IIHaqWuDvUAmNA0zdvGIozHXARQrKu5qY116CVWYNcnA2h+y/Me31kGZvgUPtkk1KV4h13phWtW/T7qXojIuV3nbLilIdg95L0xGAxz4hIP22iVEJSiLmbDG/QNnB06B4Ugt94TeDyzhuJRpnreVZEp1/ltWCGmcLU09A0Cz3801A9MxoUkWKl8E3WK7+l6tye+QV5QQ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi7KgIqjlA6akDQu6a5zgdXw9YfnT7ZrvZffezTdOGY=;
 b=AzxPC5uki4f4363MuDbhD2UJbqZMe1U4VhK4bsHe025sX2vBHGJRQleDOM1CQYTl7ewzybooPrNWT1C8eefIafOaM6oB5TD09t3Z663uc1hOSMO7vSISHyzHBRPXT61VWI80y/dPu796o+45X4+bBHB553Q2wWjiAtaEmkjuK24YOH2Si8CjY1wBnZNJi3TBHOnRkDGL9kjY4AJQA4T0QUFBSy8F0bI6pnITr90HaYY4+SRzJgoGLwhpb9AYEbVMa87FVWG1mmSk9+QRsoeUlOYgquv1WWZjrUW34YXl2BLg8nsicTq9QeHIoruDrnPREVooUm3b2lojMvMcuhJKag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi7KgIqjlA6akDQu6a5zgdXw9YfnT7ZrvZffezTdOGY=;
 b=f4pI9bXZKnTgZ8RtEhkJ8BMTEWtqOF4iNigdduvbzg1DCJFmInP0JsitRroVIvOjZZasdG6ShXDHbWduz8WuEOIx/AXbrfdtr3+9iiP28O56RMgJuF4adHcmGX3r1ExbjHPF4bN4I9mO81tKufD1NubklhNVHKl8K2DeBQ60crs=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3886.namprd11.prod.outlook.com (20.179.150.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 8 Jan 2020 16:06:06 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::71cc:a5d4:8e1a:198b]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::71cc:a5d4:8e1a:198b%7]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 16:06:06 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <linux-crypto@vger.kernel.org>
CC:     <ebiggers@kernel.org>
Subject: Re: [PATCH 3/8] crypto: atmel-sha - fix error handling when setting
 hmac key
Thread-Topic: [PATCH 3/8] crypto: atmel-sha - fix error handling when setting
 hmac key
Thread-Index: AQHVxj2Ii3AtBld1UEew6HdX3jag3A==
Date:   Wed, 8 Jan 2020 16:06:06 +0000
Message-ID: <2028004.Oqa5o8bvTI@localhost.localdomain>
References: <20191231031938.241705-1-ebiggers@kernel.org>
 <20191231031938.241705-4-ebiggers@kernel.org>
In-Reply-To: <20191231031938.241705-4-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3078aded-d291-4a69-7fa9-08d79454ab38
x-ms-traffictypediagnostic: MN2PR11MB3886:
x-microsoft-antispam-prvs: <MN2PR11MB3886C33F00B9DC63691D37C2F03E0@MN2PR11MB3886.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(136003)(346002)(376002)(366004)(189003)(199004)(6512007)(9686003)(4326008)(6486002)(2906002)(6916009)(81156014)(81166006)(26005)(71200400001)(8676002)(66446008)(66556008)(8936002)(66476007)(66946007)(76116006)(91956017)(316002)(64756008)(53546011)(5660300002)(478600001)(6506007)(86362001)(186003)(39026012);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3886;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L77P0WM8mvHTV7cby49KHAwI9TO2jJu3d+eMFAI0DYgQ9Odsb9DWirAUtWa+Y0HAuyUnq/TrBcznMeaMBBEd3/icckwBMBQoOv7QLPJxvnWHE4KpvzcAU9kKPp6WgNvj7jnO4THGwvoVG/YrxekzkkzmKu0TgQvwpbBwhj1LTkKlFj6JEynS7sGRZpWDHSkqc8wOS6bQZcj/p+2cpfKhghghoX08OoTF9oETJe7n2W4niru0soiCPdnlkQZ7rUtCNK1wsG+Y5sCVrvlpvuaMF0+SBVLYgC5X1g+O+rgnwm5CALg1Ps6OXp/vaPAGZ2DvPb2pXoBhALviaou92ZfVSSutyBGFsZs0vvGgu3OnasqiJ+2cgODQYgKlRZmnb991lcEBkxC47/79k7y5h+j9fc8mTom5IpU7c5ok+UoJK69Wb6Gs0M9R1q2PvyaddqPU6aCUwsNNQp93JHjU54SLcwHoy17EfUZd19MLIChL+Wrjk8A8Sn29H8tx1AP2ZK4T
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0869F0EF533E26408ED7E6D835DAB7E3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3078aded-d291-4a69-7fa9-08d79454ab38
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 16:06:06.5995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d6bHJrfy964DV2wkTJaMnQvb78SYArCBLqfvpAG3I3fOzXKQQK6IkThrQvfDgUFqoZu1lOJ8o3oWwukUVgFe6mao/ghqMmaycCjFpJVJDk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3886
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tuesday, December 31, 2019 5:19:33 AM EET Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> HMAC keys can be of any length, and atmel_sha_hmac_key_set() can only
> fail due to -ENOMEM.  But atmel_sha_hmac_setkey() incorrectly treated
> any error as a "bad key length" error.  Fix it to correctly propagate
> the -ENOMEM error code and not set any tfm result flags.
>=20
> Fixes: 81d8750b2b59 ("crypto: atmel-sha - add support to hmac(shaX)")
> Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/atmel-sha.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>=20
> diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
> index e8e4200c1ab3..d3bcd14201c2 100644
> --- a/drivers/crypto/atmel-sha.c
> +++ b/drivers/crypto/atmel-sha.c
> @@ -1853,12 +1853,7 @@ static int atmel_sha_hmac_setkey(struct crypto_aha=
sh
> *tfm, const u8 *key, {
>  	struct atmel_sha_hmac_ctx *hmac =3D crypto_ahash_ctx(tfm);
>=20
> -	if (atmel_sha_hmac_key_set(&hmac->hkey, key, keylen)) {
> -		crypto_ahash_set_flags(tfm,=20
CRYPTO_TFM_RES_BAD_KEY_LEN);
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> +	return atmel_sha_hmac_key_set(&hmac->hkey, key, keylen);

The atmel_sha_hmac_key_set() is used just here, maybe it is worth getting r=
id=20
of the function and copy its body here. As this is just a cosmetic suggesti=
on,=20
with or without this, one can add:

Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>

>  }
>=20
>  static int atmel_sha_hmac_init(struct ahash_request *req)



