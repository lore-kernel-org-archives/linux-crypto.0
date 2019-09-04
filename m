Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51A4C3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 11:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9950322CF5
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 11:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="gfYEtsJK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbfIDL5a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Sep 2019 07:57:30 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:58368
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728717AbfIDL5a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Sep 2019 07:57:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nkyz75eiMcsnrMFViwP2Jsm1FSfvXgrsqZsfXv82GQsL9Li3tONWAyYLgxpqleNehyJzvBMktc0zwoZVE0/oadYAVjWn0Tx9MDyzschidbfrvdDllf6cCLIP7lB/glC58IRs/yNK5PzkDJuFUjx/gXDQT+OmPn34FCEowYkbw8F6ockmEJ5REikGPmPfWXPvL9aDHvSfqOy2sqrGK2LzVtbmLIuwENEAgM93S2egYkVlEhYkBMuh287YFVZ84IgMVoRhdvNoilRXaTFf0SXvGL8XvheCSdf1WEo2qAHOYYIqPJcOQClDHg3o5zBhz1kLcegt4XBzHN/O55T5oi3gDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ued2ZMaYK+0WuykWgpyBsTMQo8CW210avIMCizu6v8k=;
 b=OsDc7QSIUiy3kSoibKrUbbYys9lQjZpYWSVC4DKYVq1VGC/M+gWCy60/iXvJoKmbRG5k5/gJBrnxVEyImLsIGnCYlcg53BvhDPNY/vlIupELEMloa08zYCAdKTU/l0FHZ+Q/Tk1aI2UVwmF9sDbkEV+an7+OxbRjKksEHYB32KLIXooyXRXTMaH11e5zGfF/r7OHp4yFxJi1G7mLQg0EDgvpVsnc27aqx2jsz0EH5dhNzh4A+LovB1t8sjKCvbt0uIasaXagyKkLDnmDZ1/LnzRU/rUzKyEyn2nN23OygGu1+Io3H80mVxSWX169kgnmh7cDdFnP1zZzFwLW5XilTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ued2ZMaYK+0WuykWgpyBsTMQo8CW210avIMCizu6v8k=;
 b=gfYEtsJK6ererVlGDXVGgnURT1JE9ld7yEcv4PSWKkAm15o1Lvqk4438MzX1UgFLdNcUr24W2S6CV69SEqglxh5VMbqL+sc/zVXsjzlztt+2Ek+XhCRfjboomCsYVmCI4aW+wYkDvxJQ+A8IIQzSIYZYIDf8zWDi1Ng3qHaws1A=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2255.namprd20.prod.outlook.com (20.179.148.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Wed, 4 Sep 2019 11:57:24 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.014; Wed, 4 Sep 2019
 11:57:24 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pvanleeuwen@insidesecure.com" <pvanleeuwen@insidesecure.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 -next] crypto: inside-secure - Fix build error without
 CONFIG_PCI
Thread-Topic: [PATCH v2 -next] crypto: inside-secure - Fix build error without
 CONFIG_PCI
Thread-Index: AQHVYfrTy4jcxbeEsEeyU2s27hKUDqcbaoBw
Date:   Wed, 4 Sep 2019 11:57:24 +0000
Message-ID: <MN2PR20MB29732EEECB217DDDF822EDA5CAB80@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190902141910.1080-1-yuehaibing@huawei.com>
 <20190903014518.20880-1-yuehaibing@huawei.com>
In-Reply-To: <20190903014518.20880-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56e0b1d0-28b9-460f-248b-08d7312f0ce9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2255;
x-ms-traffictypediagnostic: MN2PR20MB2255:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB22558D56A0E0FB53933D40B1CAB80@MN2PR20MB2255.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39850400004)(346002)(376002)(396003)(199004)(13464003)(189003)(3846002)(2501003)(66556008)(66446008)(64756008)(76116006)(316002)(6116002)(476003)(5660300002)(53936002)(66946007)(66476007)(8936002)(25786009)(478600001)(86362001)(6436002)(55016002)(15974865002)(99286004)(4326008)(52536014)(6246003)(2201001)(81156014)(7736002)(14454004)(7696005)(76176011)(486006)(26005)(110136005)(71190400001)(71200400001)(6506007)(54906003)(8676002)(53546011)(256004)(14444005)(229853002)(74316002)(66066001)(2906002)(11346002)(102836004)(186003)(305945005)(81166006)(446003)(33656002)(9686003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2255;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1VzfMrkn/WYRcQyXu2X1N0kmDLGy3pXao0jKVJbkcbG69XW70qyVrQjggn5PQbDbejQuoEcrDarIr7kli+T4SaU8PwRBsdYFMcmojBkTsq7LJNPux3pycLpSrKKTQ5CVSEY70XaT9Keh82cW0TbYVTv6OYKwIfSeC5VdksFzqsgbo2zoWOxX5YrEf7sxnHVzq1RtHQWverSm4IwF49of2EnDi5AainaoQlkPpUkbUC5ThtxqJmDBoqHpHYXbsBhcg3pr+jiTc4vHoKrQpoOM8On+0spVhjtJuJxKdmTOMjDmPutQN/ut35k7AD8jkjQxyYvn3qzIilp0xqJ3BcGy2pYiry5uZW8ujRUb4iSJYKospNb60c//2QDCjWzX73QCNMzVV2WFPjjRZrV7qaKF3zbAU10nnHBUrGTXeBwMT2c=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56e0b1d0-28b9-460f-248b-08d7312f0ce9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 11:57:24.3875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pwBp+2UwSr6RWBAeoKNUfaV7+Doi5WBZ83zS+sigfXNOa8JeWoJEL1Ya+Z92uVtBL72HDtaHU8SxazY2xOte+G31YG23AAD2ZWr4YRw9yYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2255
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> YueHaibing
> Sent: Tuesday, September 3, 2019 3:45 AM
> To: antoine.tenart@bootlin.com; herbert@gondor.apana.org.au; davem@daveml=
oft.net;
> pvanleeuwen@insidesecure.com
> Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; YueHaibin=
g
> <yuehaibing@huawei.com>
> Subject: [PATCH v2 -next] crypto: inside-secure - Fix build error without=
 CONFIG_PCI
>=20
> If CONFIG_PCI is not set, building fails:
>=20
> rivers/crypto/inside-secure/safexcel.c: In function safexcel_request_ring=
_irq:
> drivers/crypto/inside-secure/safexcel.c:944:9: error: implicit declaratio=
n of function
> pci_irq_vector;
>  did you mean rcu_irq_enter? [-Werror=3Dimplicit-function-declaration]
>    irq =3D pci_irq_vector(pci_pdev, irqid);
>          ^~~~~~~~~~~~~~
>=20
> Use #ifdef block to guard this.
>=20
Actually, this is interesting. My *original* implementation was using
straight #ifdefs, but then I got review feedback stating that I should not
do that, as it's not compile testable, suggesting to use regular C if's
instead. Then there was quite some back-and-forth on the actual
implementation and I ended up with this.

So now it turns out that doesn't work and I'm suggested to go full-circle
back to straight #ifdef's? Or is there some other way to make this work?
Because I don't know where to go from here ...

> Fixes: 625f269a5a7a ("crypto: inside-secure - add support for PCI based F=
PGA development
> board")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: use 'ifdef' instead of 'IS_ENABLED'
> ---
>  drivers/crypto/inside-secure/safexcel.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/ins=
ide-
> secure/safexcel.c
> index e12a2a3..5253900 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -937,7 +937,8 @@ static int safexcel_request_ring_irq(void *pdev, int =
irqid,
>  	int ret, irq;
>  	struct device *dev;
>=20
> -	if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
> +#ifdef CONFIG_PCI
> +	if (is_pci_dev) {
>  		struct pci_dev *pci_pdev =3D pdev;
>=20
>  		dev =3D &pci_pdev->dev;
> @@ -947,7 +948,10 @@ static int safexcel_request_ring_irq(void *pdev, int=
 irqid,
>  				irqid, irq);
>  			return irq;
>  		}
> -	} else if (IS_ENABLED(CONFIG_OF)) {
> +	} else
> +#endif
> +	{
> +#ifdef CONFIG_OF
>  		struct platform_device *plf_pdev =3D pdev;
>  		char irq_name[6] =3D {0}; /* "ringX\0" */
>=20
> @@ -960,6 +964,7 @@ static int safexcel_request_ring_irq(void *pdev, int =
irqid,
>  				irq_name, irq);
>  			return irq;
>  		}
> +#endif
>  	}
>=20
>  	ret =3D devm_request_threaded_irq(dev, irq, handler,
> @@ -1137,7 +1142,8 @@ static int safexcel_probe_generic(void *pdev,
>=20
>  	safexcel_configure(priv);
>=20
> -	if (IS_ENABLED(CONFIG_PCI) && priv->version =3D=3D EIP197_DEVBRD) {
> +#ifdef CONFIG_PCI
> +	if (priv->version =3D=3D EIP197_DEVBRD) {
>  		/*
>  		 * Request MSI vectors for global + 1 per ring -
>  		 * or just 1 for older dev images
> @@ -1153,6 +1159,7 @@ static int safexcel_probe_generic(void *pdev,
>  			return ret;
>  		}
>  	}
> +#endif
>=20
>  	/* Register the ring IRQ handlers and configure the rings */
>  	priv->ring =3D devm_kcalloc(dev, priv->config.rings,
> --
> 2.7.4
>=20

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
