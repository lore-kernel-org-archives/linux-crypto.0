Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45133C00307
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 16:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EB572173B
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 16:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="efiM2UCZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405884AbfIFQIg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 12:08:36 -0400
Received: from mail-eopbgr710087.outbound.protection.outlook.com ([40.107.71.87]:60950
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405882AbfIFQIg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 12:08:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4Nn1gi+eHo6NGuHawtq/elsMuVy2g2xLSo0GWjNal9FpeYa6vZmH2I9Orw71KgbSoaXrY+4nNo0I+8BbPw3Wjlc5NL6yzoWVugjwfvcJf13Kvwo1ren21d/0BoqvM3cGjYmrAoMbVHCBWWPcQWsrAT5+surGI1tNMwUL7InVRqi5B9+u4vIiREQb7/+CU9KDJrpvxjuA3e46su7Yao0pj6JadLITOggF0DvZ39fRoR00+7x3ksLJJgsA9y5qhlKd6glWXMHaiFn8ppr/ZiEGZMsI4QSM+w4+8nn3ymK6wGoPSd2uInsQgxI8OAEYCAW7Bmn5yTO911doklYqzvs4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvbIs/JRjkY5TL/gVMyjSz537Q64G56D2Pphed4TZr0=;
 b=OPNPo1Dma35kPGRSpbWTmsCAoV9EpCdDR1Y36KmV4JRidW/uBgU4gWZDMZhXPSTLj36/RqabhyFNcrBazwRP+3ffwlKSV11NHQeNNpNEjOHCWuI4qhDOcas0ySnB587pAmuv7bqG5fFk1FlP/x8113su/wts4Btl7ewu1PaB9+pShxNxwlPnzxkwiuJ7OXxrFvriYRpDwCPzvKnWSi6xIj+vfRAc1H6N7H/60GQaEs9+m4eyMnnKLojU/oK0w0uv/eNbjG7cdPVqa5tinSFL6k2xyYO8bA688mOsnuqCPps7P19dz+kxFM4Tg4WW5ZibUv6ndqmXbct7vFaKkHxLJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvbIs/JRjkY5TL/gVMyjSz537Q64G56D2Pphed4TZr0=;
 b=efiM2UCZgYjrjVXB5+cG0y2mJ+47YB8xNgm4oUUtQjb4TJkTGIQcd4O3Izhv3WEqzlT7QN4+DGRS1dRCkldUsNAUgIrAptB/gdPi4OJJ+MZksHy5f+gYvDkWuJbjh3K7xJIgQ+b7GZXqHkrzxlNuP4LKpDsNgjH1CwKPaf3HP3Y=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3102.namprd20.prod.outlook.com (52.132.174.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.13; Fri, 6 Sep 2019 16:08:33 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.014; Fri, 6 Sep 2019
 16:08:33 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] crypto: inside-secure - fix uninitialized-variable
 warning
Thread-Topic: [PATCH 1/2] crypto: inside-secure - fix uninitialized-variable
 warning
Thread-Index: AQHVZMb9qMxHnA67BkKvoz9dTWlgFKcez7HQ
Date:   Fri, 6 Sep 2019 16:08:33 +0000
Message-ID: <MN2PR20MB297378A683764AF4F2171B7CCABA0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190906152250.1450649-1-arnd@arndb.de>
In-Reply-To: <20190906152250.1450649-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de518abb-7ed0-4f8b-b143-08d732e4775b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3102;
x-ms-traffictypediagnostic: MN2PR20MB3102:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB310272B86DE4400BEEAF8729CABA0@MN2PR20MB3102.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(376002)(366004)(346002)(396003)(43544003)(199004)(189003)(13464003)(64756008)(52536014)(66946007)(66476007)(66556008)(66446008)(6436002)(26005)(256004)(9686003)(5660300002)(66066001)(55016002)(186003)(4326008)(110136005)(54906003)(316002)(14444005)(305945005)(99286004)(76116006)(229853002)(53936002)(2906002)(102836004)(446003)(476003)(486006)(11346002)(25786009)(8676002)(53546011)(6246003)(81166006)(81156014)(86362001)(71190400001)(71200400001)(33656002)(7696005)(6506007)(76176011)(7736002)(15974865002)(478600001)(74316002)(6116002)(3846002)(8936002)(14454004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3102;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zTWjbPFbbMAMTS9E+AuugW7O6CeJOaUw0y3PD2lZ9YVhsd4XUUZTR3qHXmfXqd9q+2frPXdTuHGJD4turgcdVdI0ZcgRwRVewfodFraC+gG/zJpmVursQTnqC0fok+9Dhf1VvOOjI/vX8dm5fnwd2bpSWIAO9Ogrknpl/zCUnnfVl7pb8yDCfHjWXH0Zu8bow72CUMcxp6IDnxEEzE3C25qr6e4eRA4dQxYXJ8vc+e8WDind/AGPzFvdhY7Tc8ZUmovCPStIKhmquP/XJl5nT5sab5iC4wJ3H1tqjFSC6n5VJ94etnV7SUZE8fF/o+WX5sRqfaiPXZUXYxyM5HiU+fZA4H39WpuZJpJX3vc8+QpaH3ppqtzmy4Ck860Fez1y2sf8QJNEDjVbi5CsLwW/pWQS74o7HkFuGPsG23s35BU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de518abb-7ed0-4f8b-b143-08d732e4775b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 16:08:33.1415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8P42xvmGzy9RkRyeD3aXCZVliVOUwJzawfqVVO0w8Pw6wkUi8Dt2GEJmHmGgk6MAu9Ehidimm1a410BiEUYIA+5Jpj/Pd8uOtjfDTYxUnbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3102
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann <arnd@arndb.de>
> Sent: Friday, September 6, 2019 5:22 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>; David S. Miller <davem@dave=
mloft.net>;
> Antoine Tenart <antoine.tenart@bootlin.com>
> Cc: Arnd Bergmann <arnd@arndb.de>; Pascal Van Leeuwen <pvanleeuwen@verima=
trix.com>; Ard
> Biesheuvel <ard.biesheuvel@linaro.org>; Kees Cook <keescook@chromium.org>=
; linux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 1/2] crypto: inside-secure - fix uninitialized-variable w=
arning
>=20
> The addition of PCI support introduced multiple randconfig issues.
>=20
> - When PCI is disabled, some external functions are undeclared:
> drivers/crypto/inside-secure/safexcel.c:944:9: error: implicit declaratio=
n of function
> 'pci_irq_vector' [-Werror,-Wimplicit-function-declaration]
>=20
> - Also, in the same configuration, there is an uninitialized variable:
> drivers/crypto/inside-secure/safexcel.c:940:6: error: variable 'irq' is u=
sed
> uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-unini=
tialized]
>=20
> - Finally, the driver fails to completely if both PCI and OF
>   are disabled.
>=20
> Take care of all of the above by adding more checks for CONFIG_PCI
> and CONFIG_OF.
>=20
> Fixes: 625f269a5a7a ("crypto: inside-secure - add support for PCI based F=
PGA development
> board")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/Kconfig                  | 2 +-
>  drivers/crypto/inside-secure/safexcel.c | 8 ++++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 3c4361947f8d..048bc4b393ac 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -719,7 +719,7 @@ source "drivers/crypto/stm32/Kconfig"
>=20
>  config CRYPTO_DEV_SAFEXCEL
>  	tristate "Inside Secure's SafeXcel cryptographic engine driver"
> -	depends on OF || PCI || COMPILE_TEST
> +	depends on OF || PCI
>

This seems like it just ignores the problem by not allowing compile testing
anymore? Somehow that does not feel right ...

>  	select CRYPTO_LIB_AES
>  	select CRYPTO_AUTHENC
>  	select CRYPTO_BLKCIPHER
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/ins=
ide-
> secure/safexcel.c
> index e12a2a3a5422..9c0bce77de14 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -938,6 +938,7 @@ static int safexcel_request_ring_irq(void *pdev, int =
irqid,
>  	struct device *dev;
>=20
>  	if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
> +#ifdef CONFIG_PCI
>

The whole point was NOT to use regular #ifdefs such that the code can
be compile tested without needing to switch configurations.
There is already a different solution in the works involving some empty
inline stubs for those pci routines, please see an earlier mail by Herbert
titled "PCI: Add stub pci_irq_vector and others".=20

>  		struct pci_dev *pci_pdev =3D pdev;
>=20
>  		dev =3D &pci_pdev->dev;
> @@ -947,6 +948,7 @@ static int safexcel_request_ring_irq(void *pdev, int =
irqid,
>  				irqid, irq);
>  			return irq;
>  		}
> +#endif
>  	} else if (IS_ENABLED(CONFIG_OF)) {
>  		struct platform_device *plf_pdev =3D pdev;
>  		char irq_name[6] =3D {0}; /* "ringX\0" */
> @@ -960,6 +962,8 @@ static int safexcel_request_ring_irq(void *pdev, int =
irqid,
>  				irq_name, irq);
>  			return irq;
>  		}
> +	} else {
> +		return -ENXIO;
>  	}
>=20
>  	ret =3D devm_request_threaded_irq(dev, irq, handler,
> @@ -1138,6 +1142,7 @@ static int safexcel_probe_generic(void *pdev,
>  	safexcel_configure(priv);
>=20
>  	if (IS_ENABLED(CONFIG_PCI) && priv->version =3D=3D EIP197_DEVBRD) {
> +#ifdef CONFIG_PCI
>  		/*
>  		 * Request MSI vectors for global + 1 per ring -
>  		 * or just 1 for older dev images
> @@ -1152,6 +1157,7 @@ static int safexcel_probe_generic(void *pdev,
>  			dev_err(dev, "Failed to allocate PCI MSI interrupts\n");
>  			return ret;
>  		}
> +#endif
>  	}
>=20
>  	/* Register the ring IRQ handlers and configure the rings */
> @@ -1503,7 +1509,9 @@ static struct pci_driver safexcel_pci_driver =3D {
>=20
>  static int __init safexcel_init(void)
>  {
> +#ifdef CONFIG_PCI
>  	int rc;
> +#endif
>
I'm working on a fix for this part already, seems to involve a bit
more than just removing the int declaration ...

>=20
>  #if IS_ENABLED(CONFIG_OF)
>  		/* Register platform driver */
> --
> 2.20.0

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
