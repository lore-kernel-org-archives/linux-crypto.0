Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9025FC4360C
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 08:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D60E20673
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 08:33:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="S+wuLjKL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfJHIdk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Oct 2019 04:33:40 -0400
Received: from mail-eopbgr810050.outbound.protection.outlook.com ([40.107.81.50]:60289
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728866AbfJHIdk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Oct 2019 04:33:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSIhPu8/3/kAUG4nbBLuAmTW2ogf+/Xpd3+Nij1ZuHVeXx8NoBOxufj4/v7TrDD6AYZHWSDpDYUPI1SWacBH5D27PJCSJh9cqMguoiAHcDWAEWRA64TqNaSfVGxgDfrIjOXeCRlv2zeXSlJivzpCKiplMzkZKLCUtNJweiY3ofE18RMM7PgHHcKsDsEaUq7n3o1i0fLpq6IyElW0VEt9AlkQLjeR6XPtp9VaI02WSx0/TLMfrI6EfOgH/E+YYB7nt+zNsiuVZWG86BQh1mTxLGPTGCzZuG0Zu7uwSgQBLwqsMZJED/90EdP/e+aFy47OmhFXfTicHyLmBRZCic7bQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KL6nCTI8avtdDO1+DUELOote4DR2Ynei3eSCXN7aks4=;
 b=GiGyaT8dAkGnWbMg0ZRzU3X3/Mns5rLTOpxo5Wl1L5viy/A0fRnSxtSM66dRqWKpzOT+uur3BrhFjo1bPVeZTO9OmscLBMxPJrdB1B5B5aivn9ABn/eL5ASsnpahiSSmO2i1D2P6oa/l5XWWztHYA+O2SyGUTZ4hPk7KMYyYaihnr69c71lA8Akl5SgR5jcGZ2ihNE+1uxT3Mnm+6X/thzOuF45IMGLOPpNipTqvFiUBFeKkjzqv0BbBfn6jBde/PNCsveD+B0MHuNWfsxtVFFOq0sCxs6ICRrHxgwQeGg7V5QbZ/9kXgMQZfTg1f4R9xi0yX+PD26M+SHu0O8keRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KL6nCTI8avtdDO1+DUELOote4DR2Ynei3eSCXN7aks4=;
 b=S+wuLjKLovUVSLDDzihYssWOE7eQw4E0WaeR1eh74gAEq6Vzr2R+GJ3PxhVAS45/ndGt+SB8umtIsdr5tBf0QK1uMbPFkyOOJlOzvHHTV8nTgGZt807MgZNTjAwnYZL490jf3UUSKmOVQ8AxZ7p8w1vHAtzFw7DcRZH5Un1RYRU=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB3136.namprd20.prod.outlook.com (52.132.175.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Tue, 8 Oct 2019 08:33:35 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 08:33:35 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Joe Perches <joe@perches.com>,
        Colin King <colin.king@canonical.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] crypto: inside-secure: fix spelling mistake
 "algorithmn" -> "algorithm"
Thread-Topic: [PATCH][next] crypto: inside-secure: fix spelling mistake
 "algorithmn" -> "algorithm"
Thread-Index: AQHVfbBiWkZb4mCzbk2SwbBbsORNa6dQZX5AgAAD7YCAAAB/4A==
Date:   Tue, 8 Oct 2019 08:33:34 +0000
Message-ID: <MN2PR20MB297358121F5F6D5B4B07ED13CA9A0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191008081410.18857-1-colin.king@canonical.com>
         <MN2PR20MB29735A64971670E9CE56821ECA9A0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <f7fada8a8afce542e5ac08f804df8d5c8d8a726b.camel@perches.com>
In-Reply-To: <f7fada8a8afce542e5ac08f804df8d5c8d8a726b.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7f58ca6-91c5-41a5-c12c-08d74bca359a
x-ms-traffictypediagnostic: MN2PR20MB3136:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3136EA60F5E7CA5C4C75A601CA9A0@MN2PR20MB3136.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39850400004)(366004)(189003)(199004)(13464003)(7736002)(33656002)(305945005)(76176011)(15974865002)(8936002)(99286004)(25786009)(110136005)(74316002)(316002)(7696005)(5660300002)(81166006)(2501003)(478600001)(14454004)(8676002)(54906003)(81156014)(71190400001)(52536014)(71200400001)(11346002)(446003)(66556008)(3846002)(14444005)(66476007)(256004)(6246003)(64756008)(66946007)(486006)(102836004)(9686003)(76116006)(66446008)(476003)(229853002)(66066001)(186003)(26005)(6506007)(53546011)(55016002)(6436002)(2906002)(86362001)(6116002)(4326008)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3136;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kDtJdm0WhEXiZN3MnET6WYidea3oPaTinMMepnkzASULJhoj0G7mmRM/AxYSL3HIHX8Z0ZvVoDZcQNKXcMhr331ajd1TQfp99ydEeGgZB3JYT3qdr0qse70C7g5znZ7BegMnsGFIhnNBhiUrud9auaCWCsdtDyWcHrDwzl39wlwPCsr2niHvqjx48iGek0BCip/ac6JTI8HvKdu58/hT8oPGJwKnAatHlS2sc3eXsla2h3q3t2gqQaAhx87kap/ukYoos4GCDiWgTdcgHOTICxB2EkU7dERrbBZevCeHxXFrDzijgiPweakyzNaGbx9JdTz4YqO4Rk2mWtdJWLUaeMenKlBBz1naGXx/DpgK7seNSUH0CYt3UQ8GuhQ6lbCred2PO6fWXg3oL2DYl242PQ1F3T+uwx68fIBZMXOKygc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f58ca6-91c5-41a5-c12c-08d74bca359a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 08:33:35.0066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ogOlx220Vl6DEhaL2NriDIZFvgz3kZ0x+NN/UGLl/WG76clpfkg47u9qfxtNmkKyP5OxmKE42UgKEtVSkru6O0wm+/5Wi4vYeioJPbydVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3136
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Joe Perches <joe@perches.com>
> Sent: Tuesday, October 8, 2019 10:29 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Colin King <colin.ki=
ng@canonical.com>;
> Antoine Tenart <antoine.tenart@bootlin.com>; Herbert Xu <herbert@gondor.a=
pana.org.au>; David S .
> Miller <davem@davemloft.net>; linux-crypto@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH][next] crypto: inside-secure: fix spelling mistake "a=
lgorithmn" ->
> "algorithm"
>=20
> On Tue, 2019-10-08 at 08:15 +0000, Pascal Van Leeuwen wrote:
> > > There is a spelling mistake in a dev_err message. Fix it.
> []
> > > diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers=
/crypto/inside-
> []
> > > @@ -437,7 +437,7 @@ static int safexcel_aead_setkey(struct crypto_aea=
d *ctfm, const u8 *key,
> > >  			goto badkey;
> > >  		break;
> > >  	default:
> > > -		dev_err(priv->dev, "aead: unsupported hash algorithmn");
> > > +		dev_err(priv->dev, "aead: unsupported hash algorithm");
> > >  		goto badkey;
> > >  	}
> []
> > Actually, the typing error is well spotted, but the fix is not correct.
> > What actually happened here is that a \ got accidentally deleted,
> > there should have been a "\n" at the end of the line ...
>=20
> Other missing newlines in the same file:
> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/cry=
pto/inside-
> secure/safexcel_cipher.c
> index cecc56073337..47fec8a0a4e1 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -695,21 +695,21 @@ static int safexcel_send_req(struct crypto_async_re=
quest *base, int ring,
>  		sreq->nr_dst =3D sreq->nr_src;
>  		if (unlikely((totlen_src || totlen_dst) &&
>  		    (sreq->nr_src <=3D 0))) {
> -			dev_err(priv->dev, "In-place buffer not large enough (need %d bytes)!=
",
> +			dev_err(priv->dev, "In-place buffer not large enough (need %d bytes)!=
\n",
>  				max(totlen_src, totlen_dst));
>  			return -EINVAL;
>  		}
>  		dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
>  	} else {
>  		if (unlikely(totlen_src && (sreq->nr_src <=3D 0))) {
> -			dev_err(priv->dev, "Source buffer not large enough (need %d bytes)!",
> +			dev_err(priv->dev, "Source buffer not large enough (need %d bytes)!\n=
",
>  				totlen_src);
>  			return -EINVAL;
>  		}
>  		dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
>=20
>  		if (unlikely(totlen_dst && (sreq->nr_dst <=3D 0))) {
> -			dev_err(priv->dev, "Dest buffer not large enough (need %d bytes)!",
> +			dev_err(priv->dev, "Dest buffer not large enough (need %d bytes)!\n",
>  				totlen_dst);
>  			dma_unmap_sg(priv->dev, src, sreq->nr_src,
>  				     DMA_TO_DEVICE);

Yes, thanks!

Acked-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
