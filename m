Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F580ECE58D
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF17D21925
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:46:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="RlcreHUY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440541AbfJQTq1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:46:27 -0400
Received: from mail-eopbgr720085.outbound.protection.outlook.com ([40.107.72.85]:55474
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387813AbfJQTq1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:46:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIss7AYQLZMIVO0LcKS14980i/WfEsUKexRlnkm0wv0o8UaAfW/G05dUDjRvF8wALVmMtsXwECmOH6PUQ7879WsQj6TeTqr+E80fFwKtEWWLK3Kg+fjb1jSnLixS7Fh43QXNx9Ad5BpEiRLPEJPCdRhkl7x6aemc3ybjBvCmH9ox05KRZiMc4FDIO36xZ4J0LHzHBYo/zVlo1ypoEB1CnJT5+bEcfqEevHk6j7XGO05wuBnsPSf7r2KQPMp73ebLvq2q1rYQ9QeToA+L6Kbz6tx3/Q1/ad051ea+YRc8VV4Jd+Ne0KGTIOlaE9R3EDPCpvw6yygIIuHFVhJYBc6L9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMRL204//eSw8H5dDzYGDxtWXbvYm1u29QntHYqTg8Q=;
 b=hvTtFFW+mEYv4J4+w1FEes5wCA+LYUj2rkjddt3VuvKeY8Hwb+x1oin8GUGSYXpECePdJV4KssjYeM7GdW8pxbWfVfAgovAagCHXzl++91ZrqertdDs50O/ZmaRjKr70O8iNIuOUiJCT4VEp0Zeb0tK5VhZRnZJXBW6Fu3ae1MSA6rpk6ZenvGyrT+6WaTsZ7TraJRIYj8zxwsspW2tYgQUmRtVXejOfWR0nf6isFE89l0iAA9vbjyQtzOcbRm1L8sCPObKypFuQU8eY8xsDJdPmlsMu6o3xhQgmyEOweEVbZsdnUqIQWFkcq6d6MbUEL4CyYQqBf4gAVXEgVP4yag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMRL204//eSw8H5dDzYGDxtWXbvYm1u29QntHYqTg8Q=;
 b=RlcreHUYLPiC4gRtpy8Aux08WUCWSJQeH61ino+dggn3m20JOnhxRcuhjEX0ILBIH0SYaeOKIHPGS+onGwaZogrNKdvlQUVoqZ6vGwJWBh0FPvPp7jHVLneWn9zVfwKiZJva+D6D9NZ8ZxlPVBxIy2s2BA9lKQD7CXAHnXixzUY=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2639.namprd20.prod.outlook.com (20.178.251.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.23; Thu, 17 Oct 2019 19:46:23 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 19:46:23 +0000
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
Thread-Index: AQHVhBfWMp/OQ1W3YkiqzB+SEDRBb6dfDogAgAAvRhA=
Date:   Thu, 17 Oct 2019 19:46:21 +0000
Message-ID: <MN2PR20MB2973592C6237B840BC63B71ACA6D0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191016114945.30451-1-ben.dooks@codethink.co.uk> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc2b18a1-3102-40a9-92a0-08d7533ab08e
x-ms-traffictypediagnostic: MN2PR20MB2639:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB263972D9F8F19424C89158EFCA6D0@MN2PR20MB2639.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:260;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39850400004)(396003)(346002)(136003)(366004)(13464003)(189003)(199004)(3846002)(6116002)(81166006)(14454004)(476003)(81156014)(8936002)(25786009)(8676002)(55016002)(446003)(71190400001)(9686003)(14444005)(256004)(6436002)(33656002)(71200400001)(2501003)(52536014)(478600001)(486006)(316002)(66066001)(305945005)(7736002)(229853002)(15974865002)(4326008)(64756008)(66946007)(2906002)(186003)(74316002)(76116006)(66476007)(54906003)(86362001)(66556008)(5660300002)(66446008)(110136005)(26005)(53546011)(6506007)(102836004)(76176011)(7696005)(6246003)(99286004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2639;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PUEni7NPqFamYko+ExhLNjhmQp6orsX7NxSHw89ZfAzEmVHOTSsf06O8Uh1XvzBv0qkuVRWbIf3AYMhPnTUjj9KUGm32Uvlm5znrvyyzzJyrg1L/BJkmgihqYAcJQNoE3glpbjFtY7l5x4SBg9PbVF5Y3VW+ikKngOFtuyhrT0ZxSWspfReTCOYzJ0RD8nB83HZXIWu/y9bPPp2et7o0aBQ17vnlVvppmnqjZHvoLJb2k9mOqFOQtaEwXrtoJF/4b8lkIbbjZHr0gOmUnTd4opursWfmqWUxmb3LcQwQfnRjWycCTh3fpCVA/K5ZuJSlI+OJW3qRTP4u6MetR4TDFNtH5SZPE3zudFe2PRnQlUIAQOJQf/InXrXc8idLJaRPdIl1QprInJ5sNAB4v+RfCV1HI+EhTrLDNzesrUD0jnI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2b18a1-3102-40a9-92a0-08d7533ab08e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 19:46:22.5250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AygHh9atVGNV3UOdDiX8dmTHLUuiy+Ukvyj9hUNcbcZExW0c/Z8w84UgnZbb8I/61drJicO+Wuq7SxBBqvyW3jXcJVO6ilQp5i5FMtBoKBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2639
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Pascal Van Leeuwen
> Sent: Thursday, October 17, 2019 7:14 PM
> To: 'Ben Dooks (Codethink)' <ben.dooks@codethink.co.uk>; linux-
> kernel@lists.codethink.co.uk
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Herbert Xu
> <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>; lin=
ux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] crypto: inside-secure - fix type of buffer in eip197=
_write_firmware
>=20
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kerne=
l.org> On Behalf
> Of Ben
> > Dooks (Codethink)
> > Sent: Wednesday, October 16, 2019 1:50 PM
> > To: linux-kernel@lists.codethink.co.uk
> > Cc: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>; Antoine Tenart
> > <antoine.tenart@bootlin.com>; Herbert Xu <herbert@gondor.apana.org.au>;=
 David S. Miller
> > <davem@davemloft.net>; linux-crypto@vger.kernel.org; linux-kernel@vger.=
kernel.org
> > Subject: [PATCH] crypto: inside-secure - fix type of buffer in eip197_w=
rite_firmware
> >
> > In eip197_write_firmware() the firmware buffer is sent using
> > writel(be32_to_cpu(),,,) this produces a number of warnings.
> >
> > Note, should this really be cpu_to_be32()  ?
> >
> No, it should certainly not be cpu_to_be32() since the HW itself is most
> definitely little endian, so that would not make sense to me.
>=20
> Actually, I don't think either solution would be correct on a big-endian
> CPU. But I don't have any big-endian CPU available to test that theory.
>=20
> What I believe must happen is that the bytes must *always* be swapped
> here, regardless of the endianness of the CPU. And with a little-endian
> CPU, be32_to_cpu() coincidentally always does that.
>=20
> Basically, what we need here is: read a dword (32 bits) from the memory
> subsystem and write it back to the memory subsystem with bytes reversed.
>=20
> Does the kernel have any dedicated function for just always swapping?
>=20

After some more thought on the train home:

I think the correct construct would be cpu_to_le32(be32_to_cpu(data[i]))
This would correctly reflect that the data is read from big-endian
memory and subsequently written to little-endian "memory" (aka the EIP).
It also fits in nicely with your other changes. Could you work that into
a patch v2? Then I would ack it (after testing).

> Anyway: NACK on this patch for now due to this.
>=20
> > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restri=
cted __be32
> > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restri=
cted __be32
> > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restri=
cted __be32
> > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restri=
cted __be32
> > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restri=
cted __be32
> > drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restri=
cted __be32
> >
> > Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> > ---
> > Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: linux-crypto@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/crypto/inside-secure/safexcel.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/i=
nside-
> secure/safexcel.c
> > index 223d1bfdc7e6..dd33f6dda295 100644
> > --- a/drivers/crypto/inside-secure/safexcel.c
> > +++ b/drivers/crypto/inside-secure/safexcel.c
> > @@ -298,13 +298,13 @@ static void eip197_init_firmware(struct safexcel_=
crypto_priv
> *priv)
> >  static int eip197_write_firmware(struct safexcel_crypto_priv *priv,
> >  				  const struct firmware *fw)
> >  {
> > -	const u32 *data =3D (const u32 *)fw->data;
> > +	const __be32 *data =3D (const __be32 *)fw->data;
> >  	int i;
> >
> >  	/* Write the firmware */
> > -	for (i =3D 0; i < fw->size / sizeof(u32); i++)
> > +	for (i =3D 0; i < fw->size / sizeof(__be32); i++)
> >  		writel(be32_to_cpu(data[i]),
> > -		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(u32));
> > +		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(__be32))=
;
> >
> >  	/* Exclude final 2 NOPs from size */
> >  	return i - EIP197_FW_TERMINAL_NOPS;
> > --
> > 2.23.0
>=20
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
