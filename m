Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D910C4360C
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 07:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6711F20867
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 07:32:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="HO4AFZqG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbfJHHck (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:32:40 -0400
Received: from mail-eopbgr720079.outbound.protection.outlook.com ([40.107.72.79]:24000
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730279AbfJHHck (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Oct 2019 03:32:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBu0/9QV6vJflvwxE+391y0gg2Enz4Vks4kO1+o6JZfnn0xtwO58tOR+XXRbmpkfxpz0pcpTFTITm7LolMGu90OkmZvccg7/DYQt3otYUFBtG6CNvFipytHqmoiwIGSmP4j+uOgWma3xSuetsKuhURwk39z01OmKoTdRpyZghAG6SZNGR/y3RHCg0INZ5Wo+KI/hSPdzqJJ1Mh3BIpWdyj4/IL69b/bVBXWbcZeEC84qNUYeKZP69YGBdC223japLJpbJL/cMIOMkNo9pSimikK/Bdoz8VdNrYdqSfqaRkKEyQUHTQ0qmFcvxtMLCxcge0b6dNJYP97uiAhpnrupKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0UhBLQO6kOrOml5xdd43BlfTEY800Zg4E7iBXShVys=;
 b=XcBDao2RNh5ACKcArk11Bci4to7YygQU3EwU4guvF9W0dkoNBCQD3ef41n2uikvie7nSv10twXacvIzU7E1kDgI13pOAyg47VfOf/ovDyUZjbhiPG6BQAEeVdxJePE60RUwiQoczf0hgup/2eKh0GpnQtq8eYVtsxvJ/OWXJPI1ssBO+XXX5hA4lvR19StRKbD9kzQagYYc69j8ScHpsEemWDaYALhK8n/IM/SF14+lS2uw27nXhsVC9vOr0rvdA8+qqLyo67UCD3YZNe1jzpyAJ9/judb6NZhH8BtG7+cSP0msENOcF9vQRO/Mk5lSw1sEcjF48/hsm3eRSc6vG+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0UhBLQO6kOrOml5xdd43BlfTEY800Zg4E7iBXShVys=;
 b=HO4AFZqGiefYI918x/v1vtWds71v3C7ht/n+VX2jEeNQHUBF5pRIAm/hl9EN3BlltGCMf3EkP+/if3t8ROA7dohvKcjUWPrC06C8j5+IrXRsQPZ9UMQU3icjD2ODvILZVzr5jvxhcC8PraAH6gZqe8zBmNoSphU+737u6Bimjto=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2590.namprd20.prod.outlook.com (20.178.250.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 07:32:37 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 07:32:37 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pascalvanl@gmail.com" <pascalvanl@gmail.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] crypto: inside-secure - Fix randbuild error
Thread-Topic: [PATCH -next] crypto: inside-secure - Fix randbuild error
Thread-Index: AQHVfagq9QgwAxh3xk6Yw1cHeAjlcqdQWBng
Date:   Tue, 8 Oct 2019 07:32:36 +0000
Message-ID: <MN2PR20MB297342D98080781DB5DC7BABCA9A0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191008071503.55772-1-yuehaibing@huawei.com>
In-Reply-To: <20191008071503.55772-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8794216e-f80a-4aa3-93a6-08d74bc1b141
x-ms-traffictypediagnostic: MN2PR20MB2590:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB25906E7382DDBB9C019474D9CA9A0@MN2PR20MB2590.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39850400004)(136003)(396003)(366004)(346002)(189003)(199004)(13464003)(66556008)(66946007)(64756008)(476003)(4326008)(66476007)(2501003)(305945005)(66446008)(76116006)(9686003)(8676002)(66066001)(14454004)(99286004)(55016002)(8936002)(15974865002)(6246003)(256004)(26005)(7736002)(186003)(54906003)(2201001)(11346002)(486006)(446003)(52536014)(102836004)(3846002)(229853002)(478600001)(71200400001)(71190400001)(7696005)(76176011)(25786009)(5660300002)(81156014)(81166006)(6436002)(53546011)(74316002)(6116002)(6506007)(110136005)(2906002)(316002)(86362001)(33656002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2590;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u8NfWeRG0/lX1GYpijq8HBlZsUfJgAdkGzLMkSI9/NBVbmL0PqzIhf01gZ7WJPG1FPVcAmvtd0khibpD+Tkhn0O0zVJOzVG75ZIeveInofMMz489mNgdWatZYj1lQ8UnSwuLrolCecLusNfnTOb33+rC9KiiXBWdVgaFiqlpCJh00yPI0tXg5dVZ9v3C3yliIOxn3gexknOMBe5gSFWM3zPIwdYAnlGlPTdhJTO/Ub//S8z50m++SC2DdT8KbpW2PAiEth+9rM7oL4u5vP/0S2RJmg9nh7nDKISLyCfZklUYTAlfflgRp08kB75jx5uUaDyqAX3duNIj1xrT9izcsBhFz1RvlkM4gy786eJFu8E2+QpsO6RN1oqaaQDhGrFc86PpR1kfrD1CtJ3lyzPlfjEzUI55WRGEbSZiP188UmY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8794216e-f80a-4aa3-93a6-08d74bc1b141
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 07:32:36.7172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GQuga7WVYi8ivjg9GRdnjtzGaJ6/HtIizWxkEitxhSQvbpoXBoOPK/hsPGOpQtFtpCA0bXQtPsmbPTMaRwgtZAJhiCAa8JIt0+2BA7G3mcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2590
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> YueHaibing
> Sent: Tuesday, October 8, 2019 9:15 AM
> To: herbert@gondor.apana.org.au; davem@davemloft.net; pascalvanl@gmail.co=
m;
> antoine.tenart@bootlin.com
> Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; YueHaibin=
g
> <yuehaibing@huawei.com>
> Subject: [PATCH -next] crypto: inside-secure - Fix randbuild error
>=20
> If CRYPTO_DEV_SAFEXCEL is y but CRYPTO_SM3 is m,
> building fails:
>=20
> drivers/crypto/inside-secure/safexcel_hash.o: In function `safexcel_ahash=
_final':
> safexcel_hash.c:(.text+0xbc0): undefined reference to `sm3_zero_message_h=
ash'
>=20
> Select CRYPTO_SM3 to fix this.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 0f2bc13181ce ("crypto: inside-secure - Added support for basic SM3=
 ahash")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 3e51bae..5af17db 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -751,6 +751,7 @@ config CRYPTO_DEV_SAFEXCEL
>  	select CRYPTO_SHA512
>  	select CRYPTO_CHACHA20POLY1305
>  	select CRYPTO_SHA3
> +	select CRYPTO_SM3
>  	help
>  	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptogra=
phic
>  	  engines designed by Inside Secure. It currently accelerates DES, 3DES=
 and
> --
> 2.7.4
>=20
But ... I don't really want to build SM3 into the kernel for all Inside
Secure drivers, since in the majority of cases, the HW will not actually
support SM3 and I don't want to bloat the kernel image in that case.

So maybe it's better to #ifdef out the failing part of the driver if
CONFIG_SM3 is not set?

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
