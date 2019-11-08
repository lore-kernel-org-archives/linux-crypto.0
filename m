Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230E5C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D40C02178F
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:40:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="LwiH4P8A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfKHIkd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:40:33 -0500
Received: from mail-eopbgr790082.outbound.protection.outlook.com ([40.107.79.82]:34112
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727016AbfKHIkd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 03:40:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOtF1OXvk30bgRMN6qloBalEqGhwbTPIDtU9HkUoE3q7Q3z9/lD6Kz5L0cWaD2Fj/M/gvc3o1bh+w9TBuI18M16DyUVRzF2B8mTu0/f5GQZB/QX7dQ/mMPkzQbc9cw1vBBj6LQJFsVOAvgFhBkViiSXY4GYk+erzv651SSA4zf6EVN8oGUfmtpJUEUo53BwnJI8d5jJZHo6tUwaMhVGwNovRoB6XMJcTFzDbgBY5j+Cov0aQ7WUUapiqeES6E1/AaGrtiUQTrl5OIUsCriM8qDdrtS1EjGxYJTixO1GVNHNJLFkyNeTrPdrE4LRgj9OvVKzgZTXNil/Kl/HgqfUM2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NWde++gVCECsvbpiqAw+3IzV3/RWUWXX2aeuvw/UJw=;
 b=YkR88Z1Zef/v+crrF2qbT8iPXO+Mlzh4poLFm8Wpu0/jBL9MfTdb02bT4ZScDT/7VAJUOD8jsIgTnHX+QvHUXdPQbO6Qtnqmmim4/qyJUrw71KgF5iGMka1O31nIHz6Pa63oT+13ScTgShBIr0s8nLl8utY89Ns3Xxg1HLP21bFswRWfxkkj+62Vfxbss/VuXCcA6qiDk0b9ub2NbcXpuZ39BWO1PLK84gtn2QvP0gZwO9TuauBH/2Yxsj6MBgyw03YUB+PJpj7l/cUywQTWDlEph8sBYRgRGzWP6exZzzFWDy3Nn/27Ew1eZzfTa54dfpEjL1EjIO7Ow0zPteSwfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NWde++gVCECsvbpiqAw+3IzV3/RWUWXX2aeuvw/UJw=;
 b=LwiH4P8AIn41PioRxTVBtQoXFBhAfnpy+0YdV/GhW8RrSc5ALOydyypRRm6S4QtajX7lgyyIHA5QKV2Uu2n30R/MLWW45bVvSjCFSDBJppxpm0rZ7yZvn2jlmuxycbFLIQQmHHeNcVdmg4v1kA4VpWvyq2tapbhyHgbgubs1nRc=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2669.namprd20.prod.outlook.com (20.178.251.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 08:40:30 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::18b4:f48a:593b:eac9]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::18b4:f48a:593b:eac9%3]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 08:40:29 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: inside-secure - Fixed authenc w/ (3)DES fails on
 Macchiatobin
Thread-Topic: [PATCH] crypto: inside-secure - Fixed authenc w/ (3)DES fails on
 Macchiatobin
Thread-Index: AQHVlgkEZiAwJ1uEqUmpCLW+07a2uqeA86EAgAAAOZA=
Date:   Fri, 8 Nov 2019 08:40:29 +0000
Message-ID: <MN2PR20MB2973F06785376947972AA751CA7B0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1573199165-8279-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20191108083810.GB111259@kwain>
In-Reply-To: <20191108083810.GB111259@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fecac87e-9cf4-4335-e224-08d764274f94
x-ms-traffictypediagnostic: MN2PR20MB2669:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2669681D0CA9AAF29CD7C9ABCA7B0@MN2PR20MB2669.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:483;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39840400004)(396003)(376002)(346002)(199004)(189003)(13464003)(26005)(33656002)(66574012)(15974865002)(99286004)(256004)(52536014)(6506007)(186003)(9686003)(55016002)(102836004)(66066001)(76176011)(2906002)(66446008)(66946007)(7696005)(5660300002)(66556008)(3846002)(66476007)(6116002)(4326008)(14444005)(74316002)(229853002)(14454004)(478600001)(6436002)(53546011)(76116006)(6306002)(54906003)(64756008)(305945005)(110136005)(476003)(81156014)(25786009)(11346002)(8676002)(486006)(6246003)(446003)(71200400001)(71190400001)(86362001)(7736002)(81166006)(966005)(8936002)(316002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2669;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WN+zqH1fUyfKnYO6GDaJMNCPdPVXhHulBqyaa1Q0GV5UwIrytacn5RnRuapamm+xH/qRZMGmp8E9y4pEsJjWmuoVLEPITDAcxPoG6AXZckOOWi7LQoYGFQsqNDYsyhZ/6LZiNhDW5VTYKjSB0/cccYbOp0qLNEclX2unrkMG7yWwcBY4o6eSvPFdtyLTlHGbNSkHkloN5BS/EdBkfPWLngH+KM2ZK1Z2O3b39dw9X//h+cK8EtOQ3mxSnXUvEimMyk4O711ISH8aZti8LTvzrII29SIrm4ecBSIZ+8b+olEtaJDt/9o9irHxaChMw6O8L9h2ksBrDuQUIIr48Ho7L0XA6YebWGTkr5zSqef4WcQUlsvm9hZ+6WzGTw0uouOQxzME04d2QPc23RnlQ3rsDSpLmxWh2VFzlunCg52U8yvTe75iQVcDJOzsAlYIuF3c9AGYjilNZ1a1p8UIXNL94UK7U9NuGRTCDx2LmUiheRg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fecac87e-9cf4-4335-e224-08d764274f94
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 08:40:29.3066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Azu2++Y+y2aGlIZJcpedfJDGygxmNouf3idYM2CrehA4rob/swrCME93MoySw4XsMvt0iwlFQ7jYp0VwJMAm/CqWoUh+1piTcfItFlc1pAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2669
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Antoine Tenart
> Sent: Friday, November 8, 2019 9:38 AM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au;
> davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH] crypto: inside-secure - Fixed authenc w/ (3)DES fail=
s on Macchiatobin
>=20
> Hi Pascal,
>=20
> On Fri, Nov 08, 2019 at 08:46:05AM +0100, Pascal van Leeuwen wrote:
> > Fixed 2 copy-paste mistakes made during commit 13a1bb93f7b1c9 ("crypto:
> > inside-secure - Fixed warnings on inconsistent byte order handling")
> > that caused authenc w/ (3)DES to consistently fail on Macchiatobin (but
> > strangely work fine on x86+FPGA??).
> > Now fully tested on both platforms.
>=20
> Can you add a Fixes: tag?
>=20
Sure I can :-) If I know what I should put in such a Fixes: tag?
(I'm off Googling now, but a response here might be faster :-)

> Thanks!
> Antoine
>=20
> > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > ---
> >  drivers/crypto/inside-secure/safexcel_cipher.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/c=
rypto/inside-
> secure/safexcel_cipher.c
> > index 98f9fc6..c029956 100644
> > --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> > +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> > @@ -405,7 +405,8 @@ static int safexcel_aead_setkey(struct crypto_aead =
*ctfm, const u8
> *key,
> >
> >  	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
> >  		for (i =3D 0; i < keys.enckeylen / sizeof(u32); i++) {
> > -			if (le32_to_cpu(ctx->key[i]) !=3D aes.key_enc[i]) {
> > +			if (le32_to_cpu(ctx->key[i]) !=3D
> > +			    ((u32 *)keys.enckey)[i]) {
> >  				ctx->base.needs_inv =3D true;
> >  				break;
> >  			}
> > @@ -459,7 +460,7 @@ static int safexcel_aead_setkey(struct crypto_aead =
*ctfm, const u8
> *key,
> >
> >  	/* Now copy the keys into the context */
> >  	for (i =3D 0; i < keys.enckeylen / sizeof(u32); i++)
> > -		ctx->key[i] =3D cpu_to_le32(aes.key_enc[i]);
> > +		ctx->key[i] =3D cpu_to_le32(((u32 *)keys.enckey)[i]);
> >  	ctx->key_len =3D keys.enckeylen;
> >
> >  	memcpy(ctx->ipad, &istate.state, ctx->state_sz);
> > --
> > 1.8.3.1
> >
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

