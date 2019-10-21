Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64645CA9EB5
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 08:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21BA82064A
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 08:29:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="PgdtUpmv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfJUI3h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 04:29:37 -0400
Received: from mail-eopbgr790070.outbound.protection.outlook.com ([40.107.79.70]:46448
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727576AbfJUI3g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 04:29:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjMmAsBJXFA+TRAGUnRcAe5jw6U6jlsnd+FcFOGPPJPZLHGpr0uZhvTl7Wp3VJoX6tnJ/OdJLZiEjkOuu+b1CRfCtMCYnz2WYQzoVLSmaCNdr0LSo35JHh7VVYkkYH3/3jFb2D2e3fP10J2jSIpmhLExbkm+oAhuWIsSGEu/48SRMwL8dcpNZ784AqQma++ve5NSP2czzjCJ0OQNbTnHdSlauRaxgBI1T1kq/2Q8SJ5ULxBclezK4s1RYL3hm+y72zXJ5GrWVHCS8Yi7mrvhyVBAEAn+kqm7eyT5wZNv20Q/GkpizU9xHV+4oFFELSZ1KpxcXIExRAuaaqOuTRdNjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaJyvh9DylieXzzvDNz9X/GiZZpTkM751sPrjP3pVuc=;
 b=m23UeMehxqSuuQc1tEwkxoq/OlFJaZ/GUrbIwaLCCr4xj4HaSKeLy1jxJHpgUYdYpL43J3RNbBtbvak9BiFO09okXQvTXXi3/qwBx5CG6n+aK3ekhEp840Kl/aYIy5NtvSmOsUOOZY0PpBsNrjbi+RuxxwQIcpEU8HU8EgU6CsIUous/bYzvhCvQ8kflsa5E//MABWVsK+IUWGmif7kLN12/p4QUwGV0wX++64cd+ffX0Qy9d2Km2h8OAEjV6XUjFLhbbPJ81zFVPwZxCvuAP4TBw3Ts+rzybNu8zff6PE3LdPxLw+LeH/+jPQO9j+AL+HCWGeK2f/OFvj8y3XXYKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaJyvh9DylieXzzvDNz9X/GiZZpTkM751sPrjP3pVuc=;
 b=PgdtUpmvjIJmoI0d3bfi3yBK8DcB3N9HZ6mNxQsv90wJMA4+riXwsSegL3rE6puE1qSiReq7ZPR4G65UbP8UDPp3RgrdhqYuJD4bnq5uoDTRnjbBdfdHjrUHHageD5yqBuPQMNsDIvrrJshDUeePLDjBcDiRDj+bTvxPV5ADTeQ=
Received: from CH2PR20MB2968.namprd20.prod.outlook.com (10.255.156.33) by
 CH2PR20MB3013.namprd20.prod.outlook.com (52.132.231.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Mon, 21 Oct 2019 08:29:33 +0000
Received: from CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::e8b0:cb5f:268e:e3ae]) by CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::e8b0:cb5f:268e:e3ae%5]) with mapi id 15.20.2347.028; Mon, 21 Oct 2019
 08:29:32 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Tian Tao <tiantao6@huawei.com>,
        "gilad@benyossef.com" <gilad@benyossef.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linuxarm@huawei.com" <linuxarm@huawei.com>
Subject: RE: [PATCH] crypto: fix safexcel_hash warning PTR_ERR_OR_ZERO can be
 used
Thread-Topic: [PATCH] crypto: fix safexcel_hash warning PTR_ERR_OR_ZERO can be
 used
Thread-Index: AQHVhhbVQBWlAzI6WUy2fRE/LiLWVadkxtcw
Date:   Mon, 21 Oct 2019 08:29:31 +0000
Message-ID: <CH2PR20MB2968AC51749DDF5E457B70C5CA690@CH2PR20MB2968.namprd20.prod.outlook.com>
References: <1571445880-34025-1-git-send-email-tiantao6@huawei.com>
In-Reply-To: <1571445880-34025-1-git-send-email-tiantao6@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89b12d04-dbf4-47c9-5401-08d75600cc6c
x-ms-traffictypediagnostic: CH2PR20MB3013:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CH2PR20MB30136EDD89B24D263FEAAB43CA690@CH2PR20MB3013.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(39840400004)(376002)(136003)(346002)(366004)(13464003)(199004)(189003)(2906002)(15974865002)(110136005)(6116002)(71190400001)(66556008)(14454004)(64756008)(66446008)(6246003)(26005)(4326008)(25786009)(3846002)(76116006)(102836004)(5660300002)(186003)(6506007)(53546011)(66946007)(99286004)(52536014)(7696005)(316002)(76176011)(8936002)(71200400001)(2501003)(86362001)(229853002)(476003)(2201001)(7736002)(256004)(486006)(14444005)(66476007)(478600001)(81156014)(305945005)(74316002)(81166006)(6436002)(9686003)(8676002)(55016002)(11346002)(446003)(66066001)(33656002)(18886075002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR20MB3013;H:CH2PR20MB2968.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JwNDwmv9PrWN6O+pmPDk+fmnorfuDMgxezI7HlnhHbo8eB3XWKIuSUMAFj0K0GI2oeSMGQZwYPlHT/e3oHcjoiDlkt6YdQPkhI57CydXNp9U4fSFe8eH1g6tRKQ9g7hOzOUkDS1MYhYjAMV7X88LsJYu5UMAforhhmUwr4elWYnpbOcl7c1rNWVUOPbEY2MoKfG2cvgPlkIeK7IEobQV1QN/xvL76giYI1WQW38eWbuAy5KfECZL/sVnCcz4JkJ6AiInYOcrzp4oxl2aAmE5/LOex1f9wHey+w8/1aQIWJUv68lfUibCB4/hOVL7saj94WxxH3+htWasv8QbZoyT4aI+Cwiqr9/o4dHEP4SwEizx20mBxVeJFgObFlDXrN4hnjuw0FGAKoALXINhRTROdCF5iIaD4E55NuPkFQvJkeE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b12d04-dbf4-47c9-5401-08d75600cc6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 08:29:32.3875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: thgKvwFTU4pivR8wD/416e7xVjHAYrUhWU+W+Wo+wRU/qdPy1cYE32KtIDV8ZFJex+tthET4HnEqJG7WZeLzn/cRgdnV9Wmued78k2Djlxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR20MB3013
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Tian Tao
> Sent: Saturday, October 19, 2019 2:45 AM
> To: gilad@benyossef.com; herbert@gondor.apana.org.au; davem@davemloft.net=
; linux-
> crypto@vger.kernel.org
> Cc: linuxarm@huawei.com
> Subject: [PATCH] crypto: fix safexcel_hash warning PTR_ERR_OR_ZERO can be=
 used
>=20
> fix below warning reported by coccicheck.
> the below code is only in the crypto-dev tree currently.
> drivers/crypto/inside-secure/safexcel_cipher.c:2527:1-3: WARNING:
> PTR_ERR_OR_ZERO can be used.
>=20
> Fixes: 38f21b4bab11 ("crypto: inside-secure - Added support for the AES X=
CBC ahash")
>=20
> Signed-off-by: Tian Tao <tiantao6@huawei.com>
> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypt=
o/inside-
> secure/safexcel_hash.c
> index 85c3a07..3c71151 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -2109,10 +2109,8 @@ static int safexcel_xcbcmac_cra_init(struct crypto=
_tfm *tfm)
>=20
>  	safexcel_ahash_cra_init(tfm);
>  	ctx->kaes =3D crypto_alloc_cipher("aes", 0, 0);
> -	if (IS_ERR(ctx->kaes))
> -		return PTR_ERR(ctx->kaes);
>=20
> -	return 0;
> +	return PTR_ERR_OR_ZERO(ctx->kaes);
>  }
Thanks for spotting, but a similar patch has already been applied.
So this patch is obsolete now.

>=20
>  static void safexcel_xcbcmac_cra_exit(struct crypto_tfm *tfm)
> --
> 2.7.4


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
