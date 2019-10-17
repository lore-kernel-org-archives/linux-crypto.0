Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077AFECE58D
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 17:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C61A02089C
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 17:14:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="KABAa4BW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440595AbfJQRO5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 13:14:57 -0400
Received: from mail-eopbgr710075.outbound.protection.outlook.com ([40.107.71.75]:21568
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728639AbfJQRO5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 13:14:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSHB97b/zAEi15EsGrbKQjQe75tSTYBTaTTxD/5odaTB96XQbIu3o6B2bRN7oTCYfjl8JooFOEQXMZFWFSNWQclmOmB/T+J0QQHKOjEQjlgipkXIll9iLhbfZY+5EnhtSY8c8hRpDPjgOoHt2H3Xy8+krMFr6UsDzuVXw31iur1YUYq2okjtDH3YPFR49o9krry0il+RwQCiznSYdliQZvcJNpMvRurcH1MruvmWb8e/DlMuhbHjfoiErTSIvLhtNC0ucDGipPVGw6ssHHcg39kIh+vRzU+WYycNzBo4nl9xL626SlgantfNSXjwmqr3V5j/Po1vvukBWYgwCuuptg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaYbGk8wdhmAk9YVnVygO79tpxZjGidIkv15JoRx+6g=;
 b=YsM+83L9zLMhrmd6y3l678gZYpL2RiIdIZedo/fWFM5GawnVmlVVdcU6UVhp54UhCJU1EYsZ5onIfdKd/1MpC7rZ81vnvfTDNvClBGHb1BOQ7FBsuNza7+pidGYGga304kp/K4jHMuAOIlSHQ/n30dFlDuuZsgaCZFHKcXMKeiNwFbxwwdcsxZksuda7XJEvr9hS3GMrxvxohJxzXaA9BVVaV0ozZWNLnuC5gaTcZjfk/ZoO4wkQqqq7f/CQnarfDc2G+jzq3f9XU19iHw6qgzaH1AxSaI1oZ+0kVtAL2pEzXUOp9byFwjfTuBqx1Y+5Ej2mh06tv4+FGwwrRwi1cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaYbGk8wdhmAk9YVnVygO79tpxZjGidIkv15JoRx+6g=;
 b=KABAa4BWK09Isa/UshMW931KBx/gKn6cAgdQUU8fq6jkTHSE5zTqaSByCfOCDBOhGnXdQpn5fIYO5B6rQybFX3LeYguReT09wEbajwyLCvt9g321V3WvfxndHM6bvAq+KTHzgRwn9ZsqoAbuzxYfaB2Gtr/GBYNTK5bCtBRGPs8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2573.namprd20.prod.outlook.com (20.179.145.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Thu, 17 Oct 2019 17:14:14 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 17:14:14 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        "linux-kernel@lists.codethink.co.uk" 
        <linux-kernel@lists.codethink.co.uk>
CC:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: inside-secure - fix type of buffer in
 eip197_write_firmware
Thread-Topic: [PATCH] crypto: inside-secure - fix type of buffer in
 eip197_write_firmware
Thread-Index: AQHVhBfWMp/OQ1W3YkiqzB+SEDRBb6dfDogA
Date:   Thu, 17 Oct 2019 17:14:14 +0000
Message-ID: <MN2PR20MB29739F7E3C145AB915E4A2DECA6D0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191016114945.30451-1-ben.dooks@codethink.co.uk>
In-Reply-To: <20191016114945.30451-1-ben.dooks@codethink.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afd25bc5-bc6a-4a23-e759-08d753256f7d
x-ms-traffictypediagnostic: MN2PR20MB2573:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2573916281DAF864A4636563CA6D0@MN2PR20MB2573.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:241;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(39850400004)(136003)(396003)(13464003)(189003)(199004)(110136005)(2501003)(15974865002)(5660300002)(26005)(74316002)(305945005)(7736002)(186003)(14454004)(86362001)(99286004)(71200400001)(71190400001)(54906003)(66476007)(64756008)(66556008)(66066001)(66946007)(66446008)(76116006)(316002)(3846002)(33656002)(478600001)(6506007)(6116002)(53546011)(6436002)(102836004)(14444005)(256004)(76176011)(2906002)(9686003)(476003)(446003)(25786009)(11346002)(486006)(8936002)(6246003)(81156014)(7696005)(55016002)(81166006)(4326008)(52536014)(229853002)(8676002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2573;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6FMcDumLldHLfPvqpqnXp/UxdpN2rqd2IcWcjnxJmMFOKrER+uaVgo2fc8K4So2gRYGYXMAfXNOwdzQJ32/nQOw2R6drBteexg29DqRGHg3+H4GW6iOqLsp/rFNyZ1tDUl8nb6gBylxhFMFGJsGfbcISYVd/9QK2oAF+ix6zzkFGltlIqmu13BQuqTD8q/EMftqy4RlRUs9N4rgSErzBR+lZkxRB2o0XH1LXEdYyjo8t9SN3zlWWhW916e/WU5EbqYDSO8Y/Zlv7jHeNH77EVb5EzLH4AQx8AP0xxYK2mSq45VFD8dNefMpkq/QNOYBeh1VchKGgpICKrSDO7p8eEugMHGLSPDfrSVhA+ewZZz6EGeme7jT5pmYzw3o6idOH7UsOdjROOhB4sk0y2ekmbVsIvwAjRIWK2+vQsa8MHfU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd25bc5-bc6a-4a23-e759-08d753256f7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 17:14:14.4652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t/1TdEPrvy/7lo8TVXxL4kYk5pGbKL2zcO5m41ifD8JUTgQL759k5fOGpA4jd2d3i9DrHP4+aEPxixhvtViZNM8QrO/eTYFWzHwHlZ5VPV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2573
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Ben
> Dooks (Codethink)
> Sent: Wednesday, October 16, 2019 1:50 PM
> To: linux-kernel@lists.codethink.co.uk
> Cc: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>; Antoine Tenart
> <antoine.tenart@bootlin.com>; Herbert Xu <herbert@gondor.apana.org.au>; D=
avid S. Miller
> <davem@davemloft.net>; linux-crypto@vger.kernel.org; linux-kernel@vger.ke=
rnel.org
> Subject: [PATCH] crypto: inside-secure - fix type of buffer in eip197_wri=
te_firmware
>=20
> In eip197_write_firmware() the firmware buffer is sent using
> writel(be32_to_cpu(),,,) this produces a number of warnings.
>=20
> Note, should this really be cpu_to_be32()  ?
>=20
No, it should certainly not be cpu_to_be32() since the HW itself is most
definitely little endian, so that would not make sense to me.

Actually, I don't think either solution would be correct on a big-endian
CPU. But I don't have any big-endian CPU available to test that theory.

What I believe must happen is that the bytes must *always* be swapped=20
here, regardless of the endianness of the CPU. And with a little-endian
CPU, be32_to_cpu() coincidentally always does that.

Basically, what we need here is: read a dword (32 bits) from the memory
subsystem and write it back to the memory subsystem with bytes reversed.

Does the kernel have any dedicated function for just always swapping?

Anyway: NACK on this patch for now due to this.

> drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restrict=
ed __be32
> drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restrict=
ed __be32
> drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restrict=
ed __be32
> drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restrict=
ed __be32
> drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restrict=
ed __be32
> drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restrict=
ed __be32
>=20
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/inside-secure/safexcel.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/ins=
ide-secure/safexcel.c
> index 223d1bfdc7e6..dd33f6dda295 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -298,13 +298,13 @@ static void eip197_init_firmware(struct safexcel_cr=
ypto_priv *priv)
>  static int eip197_write_firmware(struct safexcel_crypto_priv *priv,
>  				  const struct firmware *fw)
>  {
> -	const u32 *data =3D (const u32 *)fw->data;
> +	const __be32 *data =3D (const __be32 *)fw->data;
>  	int i;
>=20
>  	/* Write the firmware */
> -	for (i =3D 0; i < fw->size / sizeof(u32); i++)
> +	for (i =3D 0; i < fw->size / sizeof(__be32); i++)
>  		writel(be32_to_cpu(data[i]),
> -		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(u32));
> +		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(__be32));
>=20
>  	/* Exclude final 2 NOPs from size */
>  	return i - EIP197_FW_TERMINAL_NOPS;
> --
> 2.23.0

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

