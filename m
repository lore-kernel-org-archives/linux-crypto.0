Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB87C46499
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 14:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1456A216E3
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 14:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="O15R4YG0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfGEOct (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 10:32:49 -0400
Received: from mail-eopbgr700083.outbound.protection.outlook.com ([40.107.70.83]:52897
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725763AbfGEOct (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 10:32:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFyXb4Kgoze07YeE6wKNlMOuGRPHNRf0T3/asIZChCE=;
 b=O15R4YG068DOdzO9mgnF29qobK65s74z3TFM6CWM2Mx56U+ZSjdMZrV59a2aSgisOt2Bf+5DF1tDXkZGOBOeuw4PRzSradVdpxleayXbLbCQYnZ3HZ9tLwuh9XTSe+rvUJN4ImwTAC2Fii/CPAfuKDnDCXaU3EOB4o7SvamRMvo=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2429.namprd20.prod.outlook.com (20.179.144.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Fri, 5 Jul 2019 14:32:46 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2052.019; Fri, 5 Jul 2019
 14:32:46 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: inside-secure - remove unused struct entry
Thread-Topic: [PATCH] crypto: inside-secure - remove unused struct entry
Thread-Index: AQHVMxLQ7vPFXQM6xUS4XzVd0Ihqpqa8EsAAgAADdmA=
Date:   Fri, 5 Jul 2019 14:32:46 +0000
Message-ID: <MN2PR20MB297394029C591248FA258760CAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1562314645-22949-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190705141800.GE3926@kwain>
In-Reply-To: <20190705141800.GE3926@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53f8eba3-f521-438d-7dd7-08d70155a5f4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2429;
x-ms-traffictypediagnostic: MN2PR20MB2429:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB24290342EB97D8BAB31AED25CAF50@MN2PR20MB2429.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39840400004)(396003)(13464003)(189003)(199004)(73956011)(478600001)(66446008)(64756008)(4326008)(14444005)(6436002)(256004)(66476007)(8936002)(102836004)(15974865002)(66946007)(33656002)(66066001)(66556008)(5660300002)(229853002)(6506007)(53546011)(9686003)(316002)(966005)(6306002)(55016002)(110136005)(54906003)(53936002)(2906002)(6246003)(99286004)(14454004)(7696005)(86362001)(6116002)(74316002)(76176011)(52536014)(68736007)(25786009)(305945005)(7736002)(66574012)(8676002)(71200400001)(476003)(486006)(186003)(81156014)(81166006)(71190400001)(11346002)(446003)(76116006)(26005)(3846002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2429;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GPL4Rf/2W8x1rCELG7xUmup5S/efiBKpCtM/ifp+VE3XZzv31mqzbJP+zAytCQzV9L/cab/IUMR6zkyKdjx+M4JZzY3hqYK1GTrj5vGIHOUHHvB+jzOMJkJgLrvMPy53JF3UkvvnknogjniLiQt9moPBFbYM95eYFM8HePzJYdoA/52fiKqCsyC9TCxvR1QxTe/aryDItlle4ul2aGG1MIt658mN2SKgzGeUBM+ocVqq4k/t0qQ/fcxFV3hKiQl9ywoppZQDWbVtcC432oOoz0wW5zQAvmMeflGvY3AhLxKlsTnNmykKimza+/AHxZ/wLF1tVa+NfJFPYh3BZE4A4Fok9226b3Yz3crBfzWnyISOqQdlaCsyAkZU+i07s1gucboy4DUtJ6DvussAewLOIJD+aJ1dlL/pBS01XBFhitE=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f8eba3-f521-438d-7dd7-08d70155a5f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 14:32:46.2007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2429
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Friday, July 5, 2019 4:18 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au; davem@davemloft.net; Pascal Van
> Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH] crypto: inside-secure - remove unused struct entry
>=20
> Hello Pascal,
>=20
> On Fri, Jul 05, 2019 at 10:17:25AM +0200, Pascal van Leeuwen wrote:
> > This patch removes 'engines' from struct safexcel_alg_template, as it i=
s
> > no longer used.
> >
> > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > ---
> >  drivers/crypto/inside-secure/safexcel.h | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/i=
nside-secure/safexcel.h
> > index 379d0b0..30a222e 100644
> > --- a/drivers/crypto/inside-secure/safexcel.h
> > +++ b/drivers/crypto/inside-secure/safexcel.h
> > @@ -660,7 +660,6 @@ struct safexcel_ahash_export_state {
> >  struct safexcel_alg_template {
> >  	struct safexcel_crypto_priv *priv;
> >  	enum safexcel_alg_type type;
> > -	u32 engines;
>=20
> This patch can't be applied to the cryptodev branch, as 'engines' is
> still used. I guess this is done as other (non-applied) patches are
> removing the use of this member.
>=20
> You should wait for either those patches to be merged (or directly
> integrate this change in a newer version of those patches), or send this
> patch in the same series. Otherwise it's problematic as you do not know
> which patches will be applied first.
>=20
> Thanks,
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

This patch indeed depends on earlier patches. I was just assuming=20
people to be smart enough to apply the patches in the correct order :-)

So please ignore, I'll either resend or incorporate it in an update of the=
=20
earlier series later. It's nothing important (i.e. functional) anyway.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

