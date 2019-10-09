Return-Path: <SRS0=7GLU=YC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0124ECE58D
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Oct 2019 13:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 649E421848
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Oct 2019 13:28:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="MEaCa84t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731178AbfJIN2x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Oct 2019 09:28:53 -0400
Received: from mail-eopbgr800049.outbound.protection.outlook.com ([40.107.80.49]:26720
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731181AbfJIN2w (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Oct 2019 09:28:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlsdi+FEsN2MXsYxwPNF5NQmU1PaPwDPsSmPwoRFSnQib0QjFEdbRbFW/+rNOLlVHeb/OPrb0M7zUVJj1aatUKoTwBgZNP0DMUUYa2/qyEzy+jrLSN2giir15pvIeFlltxIhRtN8k8cuUVWVS3Vn4AqNeuu1XaRnCQ2aZsOpTgxFmJNQxTo4aHJUF+iibFrOZ593D7mmN0t5ct2H/UiTsIW6r4rEt690ZsBOz2fBo/IkkK41wrpxztNz4bJXvMXWg7YolW+dIJD5bfALGfo0a8VtpTQd3sqEqVZ3PQ5+R4Ff7fyHYlnj+wPxSqCq7bABt49G54eVjFGXxHfNkOnoPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KufVDrgc3cSmHNaiLmnxc39UBT0aFIAmnFrAJm7jr6M=;
 b=LrUHgMwYyK/UDYRD3SJNehFAtYgr0pOLo05rKFQUxZ6Xkgb5dTBcyzNr8nRUsHKCxJ1TpQNu8yeGyZiL4oAnHRjUnb7nbc6OufiTsGZhNT+MAzjOqzVRjvpgm8csteiFYuyXT/J2rzeCPWc8YFRDOZrH9yVgSHghJM5r1zpMP760cCRaNhjJe9he5epCjI1VC+hbbqWzeoTTVh+ohZVsrfqDTRtzdQGmPMgRL8cEbpLj9U3GRkTDCOavrE8eo2hBgHgRKziXoWFAxvt1RXUwC3ZG9ANP4/LihxHL1PyqfVyqMCPqC6RXnuKHwKao3qT552/I+FQPSqLaiKLJuMBP9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KufVDrgc3cSmHNaiLmnxc39UBT0aFIAmnFrAJm7jr6M=;
 b=MEaCa84tzoBmT7z3hEx4aJ4TNZ4zHixn41eGiTfOPG4J4UCjKFcvExn1UPP0qKmHtUfeLcY2N6U+qKqpdMkVixgmT8cc0bf16uqsyofQgr+mjRMxnrHe/ATTMxLf8ZKjqAM3aoyY+JlA4z1RsNsD/hjsVGnGsmPWYSAwnPf7kBE=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB3023.namprd20.prod.outlook.com (52.132.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Wed, 9 Oct 2019 13:28:48 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 13:28:47 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH -next] crypto: Use PTR_ERR_OR_ZERO in
 safexcel_xcbcmac_cra_init()
Thread-Topic: [PATCH -next] crypto: Use PTR_ERR_OR_ZERO in
 safexcel_xcbcmac_cra_init()
Thread-Index: AQHVfpoPpEbnac0BKUSyYpyAmlCIvadSTTXQ
Date:   Wed, 9 Oct 2019 13:28:47 +0000
Message-ID: <MN2PR20MB29737A41C34E055FB7FFD9FBCA950@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191009120621.45834-1-yuehaibing@huawei.com>
In-Reply-To: <20191009120621.45834-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3b5499b-20f3-49a2-73b0-08d74cbc9db5
x-ms-traffictypediagnostic: MN2PR20MB3023:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB30230FA02D90B51FFD3BC3DACA950@MN2PR20MB3023.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:525;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39850400004)(396003)(136003)(366004)(376002)(13464003)(199004)(189003)(8936002)(81166006)(6116002)(71190400001)(66446008)(110136005)(316002)(305945005)(66946007)(256004)(446003)(8676002)(54906003)(81156014)(7736002)(33656002)(66556008)(64756008)(14454004)(11346002)(66476007)(52536014)(5660300002)(76116006)(74316002)(3846002)(71200400001)(25786009)(26005)(53546011)(6506007)(102836004)(99286004)(4326008)(7696005)(55016002)(6246003)(15974865002)(9686003)(478600001)(76176011)(229853002)(476003)(2906002)(186003)(486006)(66066001)(86362001)(6436002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3023;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9GSDfD+bcuy4NJNlTKcku2CQ8zzdlMC/HbnJ8bae1oc22ub/Ha70Q4Y7N0UGXqVySdlqHV3GIlc4jaPkPWxxrNYpcIINxutJb3c2JUmJEPKnuHHNqRorW4OoDXPGR2Stx0v8zR3aqeXaZlEiQJy6H//v85Q7GpAXmrc3sTCeChM3XemVoJgjmQE9G3Wx9fzu0l5sjvkJDeiofF9KVapZF6qtIebPlaTLDb0frGaoaD+ysHQ8nJ8Vfk6bLHGFQanUSI1koRzNhgT5WFexQnMoxJt+ooHRtx0k3wDk0RbOBs/Mgm1RCs1774LOAZw1GEGSn2IhNbd7zOdZ67AdOvHf/38o3m8z8zf0lUe28ykqT2l3AFfliJ2uflC/GPuiTpRKlc+eYIRsapzWcVS4XMbAf63v0N2/9Z7UTNrTtNX3ejM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3b5499b-20f3-49a2-73b0-08d74cbc9db5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 13:28:47.5564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LStnmcMsMKS8S2g7fqCuR3tVHT7XK+h++Q9S7LEfZop+BYsnf2T8cd3iZija62VWf/KGYkP6hDVBB/dFcyPHyzLwtalKxQ988Fao4gy+q18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3023
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> YueHaibing
> Sent: Wednesday, October 9, 2019 2:06 PM
> To: Antoine Tenart <antoine.tenart@bootlin.com>; Herbert Xu <herbert@gond=
or.apana.org.au>
> Cc: YueHaibing <yuehaibing@huawei.com>; linux-crypto@vger.kernel.org; ker=
nel-
> janitors@vger.kernel.org
> Subject: [PATCH -next] crypto: Use PTR_ERR_OR_ZERO in safexcel_xcbcmac_cr=
a_init()
>=20
> Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) + PTR_ERR
>=20
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>
Acked-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypt=
o/inside-
> secure/safexcel_hash.c
> index 85c3a075f283..a07a2915fab1 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -2109,10 +2109,7 @@ static int safexcel_xcbcmac_cra_init(struct crypto=
_tfm *tfm)
>=20
>  	safexcel_ahash_cra_init(tfm);
>  	ctx->kaes =3D crypto_alloc_cipher("aes", 0, 0);
> -	if (IS_ERR(ctx->kaes))
> -		return PTR_ERR(ctx->kaes);
> -
> -	return 0;
> +	return PTR_ERR_OR_ZERO(ctx->kaes);
>
Ah cool, you can do that in one go, didn't know that yet :-) Thanks!

>  }
>=20
>  static void safexcel_xcbcmac_cra_exit(struct crypto_tfm *tfm)
>=20
>=20
>=20
>=20

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

