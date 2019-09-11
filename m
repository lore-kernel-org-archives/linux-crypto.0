Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFE7ECDE20
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A982F2089F
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:37:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="tPLttuQy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfIKPhk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 11:37:40 -0400
Received: from mail-eopbgr740059.outbound.protection.outlook.com ([40.107.74.59]:52352
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727839AbfIKPhk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 11:37:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iisk0tj31GrSnYsfASHOicERPBU7VALU8DtkGho4dGBYP9DdzJXxAgCyE8LjxseqRS490dgzCmQlyLMgZ+IEzFVYxtU+5jDH4ns+5adM1eVp4kKipcVa7/wMwHvLk6YQrkqliDx9olYaniCQfXadVDL1SZqUgySiI2aTA2DedZ/sU9tx/wK4W2x40aFz1H/nl4nodVe92e7IwAOCFFjbmiVcdpwb7nMPQjneEkvv056MilNV8sW3PPobhCQw1nvrwH0g4VSApUiL8+W+jLwTPHlSRMzQUN8y2e1D+nyUcGH7oqNfehB+Vc/wpx5C+WPiMBv4HOB9S16h7NZvZ/Egdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLGNkGgqlvq5EQAUJKfUCng1CM1Mn31LjjDsAnNH8D4=;
 b=EMfwj2iK5W31KyuQ97Ikv6xqKs9+VFXbnVRr2hcx0/LHPUWtnpIHBZi7mc0QNa6m2PiNm5YNa9B5V6Ovg/5lOfiQW47J1KAqxjeXuJMtayJYgeWQqIrxttpGZhYQmu4+NyTmJvWl911ta0izHE0957lo6lKcaRcG3RIZsgVyZgom54OU3aicufhmrlLaKdjDJW+Va8wwTcAf6i5oTg8d9lvlRLy6kLncMdZXajE6HRJGN3P/6V9aE2ueNf4Qds4e2JcORkak0FKkwwnydjb9qgw5Pnq0Afh+xCD7Jrxf7qreehgVCQTeTQtLj0pOM997PvUP3AfQ+qMFodWtvJt31A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLGNkGgqlvq5EQAUJKfUCng1CM1Mn31LjjDsAnNH8D4=;
 b=tPLttuQyjka3A6t1ppAbWFdIdn6BTCFky3/QGOkjkeRR1Ia05+e5vh0ODD48TBFCwmFJRCTAqJtSSTP4JGOglXPpmcvzJaJ7+9l963UdLXNo1fpplO2pQvahVMeODjt8HWvTmz+kYEIuqBGPMHSCF9sgqvjdzEU+r59AhglSms8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2238.namprd20.prod.outlook.com (20.179.145.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 15:37:25 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.022; Wed, 11 Sep 2019
 15:37:25 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 2/2] crypto: inside-secure - Add support for the
 Chacha20-Poly1305 AEAD
Thread-Topic: [PATCH 2/2] crypto: inside-secure - Add support for the
 Chacha20-Poly1305 AEAD
Thread-Index: AQHVZ+4ol4/3NLRDH0mF4MnFPC9b36cmm6CAgAAAuWA=
Date:   Wed, 11 Sep 2019 15:37:25 +0000
Message-ID: <MN2PR20MB297364B0CA33E6B03041D9DECAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568126293-4039-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190911152947.GB5492@kwain>
In-Reply-To: <20190911152947.GB5492@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c868b033-769a-45b5-253e-08d736cdf21f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2238;
x-ms-traffictypediagnostic: MN2PR20MB2238:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2238B94889631C1A772FD184CAB10@MN2PR20MB2238.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(39850400004)(396003)(376002)(199004)(189003)(13464003)(110136005)(55016002)(64756008)(102836004)(6506007)(7736002)(8936002)(53546011)(6306002)(305945005)(33656002)(9686003)(81166006)(66574012)(81156014)(26005)(8676002)(256004)(186003)(14444005)(52536014)(2906002)(316002)(54906003)(66476007)(66946007)(66446008)(74316002)(66556008)(3846002)(6116002)(476003)(486006)(71190400001)(71200400001)(76176011)(7696005)(11346002)(99286004)(5660300002)(15974865002)(478600001)(14454004)(966005)(6246003)(76116006)(229853002)(4326008)(6436002)(66066001)(25786009)(86362001)(446003)(53936002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2238;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YoirUl3GzeKWGI5V20dhvRpWNzFHuvMiKa0mKLoZKWjxX9NV9yiG4itj9E3f9dp7fi4ACWNRtCiqsXh29shCXr2fMQOdkFiZc4ikzzNRa32BKdOyVXx5poZTbdyIynOmYErbPeXIlXhOnGHOq8ktXEsfb+LvcuI9fK4uHkO2I+JQR7yVFhwoOiYbcyd6zSYsA2LHhqj6o0hOyzWIcHOZVcRSpQ2hb1ApDQythxSvH8Ep4XWleBLuGSx+eWAXwUOCiq0wTnBF9LkuW2MzohijiKGmB+mhsQzikaoIQXrLdmgFy8y7GntP9TvyJD2h28R46HIby+F+ijFPS8jO7AiV4a20EbqOxCAgk6Gy/2KcZ3//D7g/EpwMElimq/bnsnT7+y+0TqhRkblrsY63OI3TxHXiLbedSHBobrYoaMG0jZs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c868b033-769a-45b5-253e-08d736cdf21f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 15:37:25.3458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mt2sMKKCHO3LpzDIGEeQsmnloj5O9yt/q/pKN7CCSlaAEqjTmCb5wLzZXBdvfq70EzyoYRCbg5HADrVrh0BGGh4oBJykAydal3xpoPiMWQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2238
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Wednesday, September 11, 2019 5:30 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com;
> herbert@gondor.apana.org.au; davem@davemloft.net; Pascal Van Leeuwen
> <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH 2/2] crypto: inside-secure - Add support for the Chac=
ha20-Poly1305
> AEAD
>=20
> Hello Pascal,
>=20
> On Tue, Sep 10, 2019 at 04:38:13PM +0200, Pascal van Leeuwen wrote:
> > @@ -43,8 +44,8 @@ struct safexcel_cipher_ctx {
> >
> >  	u32 mode;
> >  	enum safexcel_cipher_alg alg;
> > -	bool aead;
> > -	int  xcm; /* 0=3Dauthenc, 1=3DGCM, 2 reserved for CCM */
> > +	char aead; /* !=3D0=3DAEAD, 2=3DIPSec ESP AEAD */
> > +	char xcm;  /* 0=3Dauthenc, 1=3DGCM, 2 reserved for CCM */
>=20
> You could use an u8 instead. It also seems the aead comment has an
> issue, I'll let you check that.
>=20
Yes, u8 would be better, I'll fix that.
I don't see what's wrong with the comment though?
Anything unequal to 0 is AEAD, with value 2 being the ESP variant.

> > -		dev_err(priv->dev, "aead: unsupported hash algorithm\n");
> > +		dev_err(priv->dev, "aead: unsupported hash algorithmn");
>=20
> You remove the '\' here.
>=20
Oops. Must've accidentally happended during editing. Good catch.

> > @@ -440,6 +459,17 @@ static int safexcel_context_control(struct safexce=
l_cipher_ctx
> *ctx,
> >  				CONTEXT_CONTROL_DIGEST_XCM |
> >  				ctx->hash_alg |
> >  				CONTEXT_CONTROL_SIZE(ctrl_size);
> > +		} else if (ctx->alg =3D=3D SAFEXCEL_CHACHA20) {
> > +			/* Chacha20-Poly1305 */
> > +			cdesc->control_data.control0 =3D
> > +				CONTEXT_CONTROL_KEY_EN |
> > +				CONTEXT_CONTROL_CRYPTO_ALG_CHACHA20 |
> > +				(sreq->direction =3D=3D SAFEXCEL_ENCRYPT ?
> > +					CONTEXT_CONTROL_TYPE_ENCRYPT_HASH_OUT :
> > +					CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN) |
> > +				ctx->hash_alg |
> > +				CONTEXT_CONTROL_SIZE(ctrl_size);
>=20
> I think you could use an if + |=3D for readability here.
>=20
Ok, I can do that

> > +static int safexcel_aead_chachapoly_crypt(struct aead_request *req,
> > +					  enum safexcel_cipher_direction dir)
> > +{
> > +	struct safexcel_cipher_req *creq =3D aead_request_ctx(req);
> > +	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);
> > +	struct crypto_tfm *tfm =3D crypto_aead_tfm(aead);
> > +	struct safexcel_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
> > +	struct aead_request *subreq =3D aead_request_ctx(req);
> > +	u32 key[CHACHA_KEY_SIZE / sizeof(u32) + 1];
>=20
> Shouldn't you explicitly memzero the key at the end of the function?
>
Yes! :-) And good catch, again.

> Thanks!
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Thanks,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

