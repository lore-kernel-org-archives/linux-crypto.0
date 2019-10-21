Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36105CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 10:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA6312089C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 10:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="KtM/kEfh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfJUKXi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 06:23:38 -0400
Received: from mail-eopbgr770057.outbound.protection.outlook.com ([40.107.77.57]:46053
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727328AbfJUKXh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 06:23:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsJQpvtO4capHiUpytHatOj9pgBhM0wgb28DACRljX7U1C/E7eA4V+sDsXvYN9x7LoUsp/jGeExav5U6NE3SXm+RElKaAmPOyLz0NgIOlBF50MkIzC+BFamJG6WUCKslSEJC9fbX/QVcxXolCLGEacN1vDGPuxYquChQwiV31CYxeCC/nVvN9+Te0vfgZ9zJBZnRrRkHdOaZtuAZIDxCnqypxBVIXFJdv2c69Uq9N3gnrcxswdnj4DZIf6N+o6m1uUApTjN+7vP3mjG1jZcBrc8GyXgIIVtGil97GqPuxtuB5j+HDxGXwqwdZBmoJCk8VzSG4dqsInFv2r/qdNwpgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5eUZp6JzuHcHAyv5xCqnq5+JMeZGICotQn5K0+faAk=;
 b=KBxAliZM1rjcyAGbsVChNzxsZBwRNWzEWaJI//CgwNxCnVR9b3lAXg0IBo+Agy0IqXCCT1TfLU15FSo49ZYO5tzLonxDMo3+PxM/ELDiUTk+4AjwLokiArIJeJN3mQrAxLtn4b8gDbsLRDpG9TGCCBFUZDjHAXHLZOjpAET8ka7VcwK844G10jgjfJ4qSHFvCli7GPXPyTuALD4bfHM2MpXKyRK0bb351uGh3+iaSCYciLLqD/IU0dBC+2mObDU5ZBd5utZ26tb41oapHZ+HDmV4g32+zg84zEeQ5CijnlAoJWg7pZsm1jClAs29B+cYiizwwTbvYxX4bnOGOuhptQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5eUZp6JzuHcHAyv5xCqnq5+JMeZGICotQn5K0+faAk=;
 b=KtM/kEfhEWB5yV5qONaS3tsPpozijphzKclD0JraGk7m2p8QqSvJuLt1lXGfhAIFLTn0l0r29uKJAqbeTLd5/eil/DK74awVMpmr0GeWitE94dkgxaAviaJN47s0tgX4IZCdCi7SfwkamdMEcee0q78jtM5VBUUqt4BdT0CgqJE=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB3005.namprd20.prod.outlook.com (52.132.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Mon, 21 Oct 2019 10:23:32 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 10:23:32 +0000
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
Thread-Index: AQHVhBfWMp/OQ1W3YkiqzB+SEDRBb6dfDogAgAAvRhCABaqlQA==
Date:   Mon, 21 Oct 2019 10:23:32 +0000
Message-ID: <MN2PR20MB29732240A7D7ECE5BA80E474CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191016114945.30451-1-ben.dooks@codethink.co.uk>  
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05a5a4eb-f546-4d44-4ef0-08d75610b978
x-ms-traffictypediagnostic: MN2PR20MB3005:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3005F99D362BE0168205E5FBCA690@MN2PR20MB3005.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:534;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(136003)(376002)(366004)(346002)(189003)(199004)(13464003)(64756008)(8676002)(2906002)(9686003)(66476007)(53546011)(8936002)(76116006)(66446008)(102836004)(66556008)(6506007)(26005)(74316002)(76176011)(99286004)(7696005)(186003)(81156014)(33656002)(81166006)(25786009)(486006)(476003)(478600001)(3846002)(6116002)(4326008)(305945005)(7736002)(6246003)(52536014)(5660300002)(66946007)(446003)(110136005)(6436002)(316002)(229853002)(14454004)(66066001)(71190400001)(86362001)(71200400001)(256004)(14444005)(2501003)(55016002)(54906003)(15974865002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3005;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8cjbwv5ou0OA+0wb7jv+82Ntnd3DcpoN6hpbheqvgfjp546mQ4F9FcTnUDyBT2iZFhzw9Ld9xc7iM6lcqRCgCKuU7R4NXfyf6Yh19HQyvxED5BvcjbbvDKkcn7liXVqsNdUbUQttdO7APD+OL9xKz+AlSx/RoW+QlPUqLRCZ7wsD6xkzTDG55FiV6chrohN5Qv6lwBPIKTTOfRj2jJaXiXxCVZGrp4LFFBBRDSyQb73zP/Cj8BYxcNv1/Iekj4Sou1AOQJoHy3xLHZAus1n+h++O+GpL4VR1ecNSQvkE1blnW8/sWLSWPjoFiZ6ZEHW80d6S4plDQ524yKM/RDQ/9sk6v1GVUP3TXoY3XW40GFVwV9srcrKefZEl3Sz2BPWHXeGKW+D6ireefj9OYoKVaBjrv5NgBZ1DJK7S3IoJaAk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05a5a4eb-f546-4d44-4ef0-08d75610b978
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 10:23:32.6769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 28nOnlujFF92ppnlmfhpbTfqUi6+5jc9dlHgKl7pn2bUBjZrcWssQAN7xQG8EDD8Awz/wJfoWarC9H3VXKZbxKjSxnuGmwK8gGgzBVtyBLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3005
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Pascal Van Leeuwen
> Sent: Thursday, October 17, 2019 9:46 PM
> To: 'Ben Dooks (Codethink)' <ben.dooks@codethink.co.uk>; 'linux-kernel@li=
sts.codethink.co.uk'
> <linux-kernel@lists.codethink.co.uk>
> Cc: 'Antoine Tenart' <antoine.tenart@bootlin.com>; 'Herbert Xu' <herbert@=
gondor.apana.org.au>;
> 'David S. Miller' <davem@davemloft.net>; 'linux-crypto@vger.kernel.org' <=
linux-
> crypto@vger.kernel.org>; 'linux-kernel@vger.kernel.org' <linux-kernel@vge=
r.kernel.org>
> Subject: RE: [PATCH] crypto: inside-secure - fix type of buffer in eip197=
_write_firmware
>=20
> > -----Original Message-----
> > From: Pascal Van Leeuwen
> > Sent: Thursday, October 17, 2019 7:14 PM
> > To: 'Ben Dooks (Codethink)' <ben.dooks@codethink.co.uk>; linux-
> > kernel@lists.codethink.co.uk
> > Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Herbert Xu
> > <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>; l=
inux-
> > crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: RE: [PATCH] crypto: inside-secure - fix type of buffer in eip1=
97_write_firmware
> >
> > > -----Original Message-----
> > > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.ker=
nel.org> On Behalf
> > Of Ben
> > > Dooks (Codethink)
> > > Sent: Wednesday, October 16, 2019 1:50 PM
> > > To: linux-kernel@lists.codethink.co.uk
> > > Cc: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>; Antoine Tenart
> > > <antoine.tenart@bootlin.com>; Herbert Xu <herbert@gondor.apana.org.au=
>; David S. Miller
> > > <davem@davemloft.net>; linux-crypto@vger.kernel.org; linux-kernel@vge=
r.kernel.org
> > > Subject: [PATCH] crypto: inside-secure - fix type of buffer in eip197=
_write_firmware
> > >
> > > In eip197_write_firmware() the firmware buffer is sent using
> > > writel(be32_to_cpu(),,,) this produces a number of warnings.
> > >
> > > Note, should this really be cpu_to_be32()  ?
> > >
> > No, it should certainly not be cpu_to_be32() since the HW itself is mos=
t
> > definitely little endian, so that would not make sense to me.
>
Never mind that. While looking into more endianness related sparse issues,
I realised that the HW register access is actually configured to match the
CPU endianness. So the CPU will not need to swap bytes when accessing the
hardware registers.
(Technically, the hardware _is_ little endian but our slave interface
contains byte swapping logic that is enabled for big-endian CPU's ...)

> >
> > Actually, I don't think either solution would be correct on a big-endia=
n
> > CPU. But I don't have any big-endian CPU available to test that theory.
> >
> > What I believe must happen is that the bytes must *always* be swapped
> > here, regardless of the endianness of the CPU. And with a little-endian
> > CPU, be32_to_cpu() coincidentally always does that.
> >
> > Basically, what we need here is: read a dword (32 bits) from the memory
> > subsystem and write it back to the memory subsystem with bytes reversed=
.
> >
> > Does the kernel have any dedicated function for just always swapping?
> >
>=20
> After some more thought on the train home:
>=20
> I think the correct construct would be cpu_to_le32(be32_to_cpu(data[i]))
> This would correctly reflect that the data is read from big-endian
> memory and subsequently written to little-endian "memory" (aka the EIP).
> It also fits in nicely with your other changes. Could you work that into
> a patch v2? Then I would ack it (after testing).
>=20
Since the HW slave ifc is configured to match the CPU endianness, the
cpu_to_le32() I suggested should NOT be performed and the code is fine as
it was.

> > Anyway: NACK on this patch for now due to this.
> >
Apologies for the mistake and inconvenience. Correction:
Acked-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>


> > > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to rest=
ricted __be32
> > > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to rest=
ricted __be32
> > > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to rest=
ricted __be32
> > > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to rest=
ricted __be32
> > > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to rest=
ricted __be32
> > > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to rest=
ricted __be32
> > >
> > > Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> > > ---
> > > Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: linux-crypto@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >  drivers/crypto/inside-secure/safexcel.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto=
/inside-
> > secure/safexcel.c
> > > index 223d1bfdc7e6..dd33f6dda295 100644
> > > --- a/drivers/crypto/inside-secure/safexcel.c
> > > +++ b/drivers/crypto/inside-secure/safexcel.c
> > > @@ -298,13 +298,13 @@ static void eip197_init_firmware(struct safexce=
l_crypto_priv
> > *priv)
> > >  static int eip197_write_firmware(struct safexcel_crypto_priv *priv,
> > >  				  const struct firmware *fw)
> > >  {
> > > -	const u32 *data =3D (const u32 *)fw->data;
> > > +	const __be32 *data =3D (const __be32 *)fw->data;
> > >  	int i;
> > >
> > >  	/* Write the firmware */
> > > -	for (i =3D 0; i < fw->size / sizeof(u32); i++)
> > > +	for (i =3D 0; i < fw->size / sizeof(__be32); i++)
> > >  		writel(be32_to_cpu(data[i]),
> > > -		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(u32));
> > > +		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(__be32=
));
> > >
> > >  	/* Exclude final 2 NOPs from size */
> > >  	return i - EIP197_FW_TERMINAL_NOPS;
> > > --
> > > 2.23.0
> >
> > Regards,
> > Pascal van Leeuwen
> > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > www.insidesecure.com
>=20
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
