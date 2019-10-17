Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3ABFA372A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 16:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82EF320872
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 16:53:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="pEbee7aa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436718AbfJQQxJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 12:53:09 -0400
Received: from mail-eopbgr710069.outbound.protection.outlook.com ([40.107.71.69]:63981
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394354AbfJQQxI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 12:53:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciquDOPsoSSAbXFp+ElPFdrAiikSYkgemdXd42EniJyljssC95FKHa/ZVUyR+7UaUJTDh+AmnjQUj/K739J9F82aOqp4YxxfVQWEFw+q7hjUI2ZynsadhoDWcWpQdINxI1b9V3Dc0SInomsV4klyvcZWWWN3xx0gSC2FxBOUwpIfSL1EAWq/d5lwpVu75+C7LbWoL4NNiIKgPvIJgmXd83ctC+CTFycFGHxU89q+gf0lMWoU8zueAwTBC9OpO3enBPkMieJY3OcIjZz0mW1uDcYnOskGVJiu2GCPOXKAuAoVLPavFiClP5VnRcs9wBN7v9QxdVAkXn1enBX3qdFWUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mjik2Jkn23mwIIhgrUm5H4hTLwlc9IBbS2+z/7BApz0=;
 b=iXpXJ52HeutQKjJAYLfNHnhUH7+qMK9E6gtyVJ7/Rzh46roSrcd0SIa5CEW178Rr9hzXfcPIPk8aE20OVAwL7OjLw1sDYvmzuUcVnL+iXvo6AvX2W+CH0Xa7no+blTLlxCCqYmZ4b+lnyCzmC6jjnH/eaTEj97/amYGsqPeodJcnJ0G816CMOo1CQfbyoFh44Ge/bfrvcjM79ojT0VA/WfcvdmnqxqHEEoWIi+dIMnEzmiMSRoR98N2WF5hHXrWQxWISJSrQfWzsKvVM+n3RejnUzDjNGr91zn+N01tSUUyYbVDjXtqr1xdumZ0B03DGgjrZmfuHsnIanXbf1YPv8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mjik2Jkn23mwIIhgrUm5H4hTLwlc9IBbS2+z/7BApz0=;
 b=pEbee7aa5NEpw4f+LC+RGphGwR02KKrdYWGI5kpNIJ95pbrESqTr7w8wz6B7XC6x1d2Py/QM9+6hpLK68mZk0lxHpIme41y6F6Uit7l1taSfvCJs68JQQ3K95LVAEfp4YOzzjkxk2HMdpPhAvjkBfZAHEdhpV5jrzgX/koi9WpM=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB3008.namprd20.prod.outlook.com (10.255.7.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 17 Oct 2019 16:53:04 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 16:53:04 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        "linux-kernel@lists.codethink.co.uk" 
        <linux-kernel@lists.codethink.co.uk>
CC:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: inside-secure - fix unexported warnings
Thread-Topic: [PATCH] crypto: inside-secure - fix unexported warnings
Thread-Index: AQHVhBc10GGkU+DvaEyaOxv0s+1VdqdfBGsA
Date:   Thu, 17 Oct 2019 16:53:04 +0000
Message-ID: <MN2PR20MB297372195F99452234B9E48ECA6D0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191016114512.8138-1-ben.dooks@codethink.co.uk>
In-Reply-To: <20191016114512.8138-1-ben.dooks@codethink.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b94f58e-a588-49c4-6e1f-08d753227a68
x-ms-traffictypediagnostic: MN2PR20MB3008:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB30080460A134CD646978823CCA6D0@MN2PR20MB3008.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(366004)(376002)(346002)(136003)(13464003)(189003)(199004)(316002)(74316002)(66066001)(81166006)(102836004)(110136005)(486006)(71190400001)(476003)(71200400001)(2501003)(305945005)(7736002)(66446008)(64756008)(66556008)(66476007)(81156014)(8676002)(5660300002)(478600001)(99286004)(15974865002)(26005)(446003)(11346002)(66946007)(186003)(54906003)(8936002)(3846002)(76116006)(52536014)(14444005)(6436002)(6116002)(76176011)(86362001)(256004)(25786009)(55016002)(9686003)(229853002)(4326008)(14454004)(6246003)(7696005)(53546011)(33656002)(6506007)(2906002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3008;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1yIx8TYJl6A8nOoEC2Be7f0LAhkRybXYqKQwr6GZnFzwvpowrj+L62FSA/DqVh718GLGoYUbwuHaDSFNxInOJvopaVCMWyBArAdgke4FRentEYhHyclK4esVoxxq1Esy0eF6lktRaM4PyZ0XPZSek1wBIaEB6xhdFJWh36/r05FnraEUgMtBfnNTL7MEysbY7rzQ9itoOUG3YS8uRnDAwA11Eyzot62M6c1+/NV78WdAbonnDbtOsO0pDoUjga/YT2NABDMRGOcOR5pIthzizva3YRP9ywaTe1qr5fJLRxedtKtN4L1bCE8ngX/2KQHoNoyUQclmhFvk0FSCD/u38HTT6RgmzGcRq4pkuRBRM2kqCkRrF9OK+hIrPRRK+uaf2QFmq4AbLodEX3MCoiqd6//SbjJL4QBGddB9o+U5UJg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b94f58e-a588-49c4-6e1f-08d753227a68
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 16:53:04.1703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2jik66/UZk/A2GwiZj1Y1JT+HFNahWMff9rMOr+Jv84S4UYaKClj5nFA7gFYch8sdn3/bFk3j67VkB0UGMy4gsHoBnVpWAm46RKxcqgCrbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3008
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Ben
> Dooks (Codethink)
> Sent: Wednesday, October 16, 2019 1:45 PM
> To: linux-kernel@lists.codethink.co.uk
> Cc: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>; Antoine Tenart
> <antoine.tenart@bootlin.com>; Herbert Xu <herbert@gondor.apana.org.au>; D=
avid S. Miller
> <davem@davemloft.net>; linux-crypto@vger.kernel.org; linux-kernel@vger.ke=
rnel.org
> Subject: [PATCH] crypto: inside-secure - fix unexported warnings
>=20
> The safexcel_pci_remove, pcireg_rc and ofreg_rc are
> not exported or declared externally so make them static.
>=20
> This avoids the following sparse warnings:
>=20
> drivers/crypto/inside-secure/safexcel.c:1760:6: warning: symbol 'safexcel=
_pci_remove' was not
> declared. Should it be static?
> drivers/crypto/inside-secure/safexcel.c:1794:5: warning: symbol 'pcireg_r=
c' was not declared.
> Should it be static?
> drivers/crypto/inside-secure/safexcel.c:1797:5: warning: symbol 'ofreg_rc=
' was not declared.
> Should it be static?
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
> index 4ab1bde8dd9b..223d1bfdc7e6 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1757,7 +1757,7 @@ static int safexcel_pci_probe(struct pci_dev *pdev,
>  	return rc;
>  }
>=20
> -void safexcel_pci_remove(struct pci_dev *pdev)
> +static void safexcel_pci_remove(struct pci_dev *pdev)
>  {
>  	struct safexcel_crypto_priv *priv =3D pci_get_drvdata(pdev);
>  	int i;
> @@ -1791,10 +1791,10 @@ static struct pci_driver safexcel_pci_driver =3D =
{
>=20
>  /* Unfortunately, we have to resort to global variables here */
>  #if IS_ENABLED(CONFIG_PCI)
> -int pcireg_rc =3D -EINVAL; /* Default safe value */
> +static int pcireg_rc =3D -EINVAL; /* Default safe value */
>  #endif
>  #if IS_ENABLED(CONFIG_OF)
> -int ofreg_rc =3D -EINVAL; /* Default safe value */
> +static int ofreg_rc =3D -EINVAL; /* Default safe value */
>  #endif
>=20
>  static int __init safexcel_init(void)
> --
> 2.23.0

Actually those variables have already disappeared from the=20
cryptodev tree due to an earlier patch by Arnd.
So this patch won't apply anyway.

I'll see if I can spin a patch that makes safexcel_pci_remove
static.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
