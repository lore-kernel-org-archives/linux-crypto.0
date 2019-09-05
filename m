Return-Path: <SRS0=9BFZ=XA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2610AC3A5A5
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 13:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C649720828
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 13:55:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="QML6+bhs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfIENz5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 09:55:57 -0400
Received: from mail-eopbgr780084.outbound.protection.outlook.com ([40.107.78.84]:27657
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730303AbfIENz5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 09:55:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9XqHJKnRLADYGIfQSul5WOeJxr53yzLQJyEihrEQUQLTd5fpasyMiWRMInN+hw/iJ7Bce+r2cdaZzlCMvFuKKJhjUv4yAKeDxVNa9bkksohGhZcTyK1EECM4hGLodRgRN8pL6D7uMuk+4vYHhvP+DqAjSQTFAVySI1KgHJtgK6wcYvNCQsPWrwZ73UfktDeN3DILz28uVw5SyuyHmTAZrRte57z6mhqfj/Sax8j/jpIfe1Jwr9x/RdFDsr+b6Q3A4yxDk5BANNlfF+Q1q9k2BzEi2mmkUoWTbHtQL2vdrq2/KAwcahz2oxVwDQI5tdxBUp6d1Uqc1F1TtwNU82asg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68OuvNh+P+GxtE6JQcq4MIsELOcRwSmXAYE13okJjZk=;
 b=PBJGQDQDWUEREujWHfLv0GRZIBjpN1LUuf0lczbrYCC8MuFYlTiGfT6Zo/QnyJr5YFqp1+x0HCQmRJ1IfAT6jkT6sJppV3391rWGPcdEwXU2eezostcn/cCKPD9KaUFLG5eZIXo1/LpSdXWcRUN9dOMFH3Ds5PKJXOmUfBy+4x/uPteoyBDMrqr9kVUOUnNv1EVDjJA5PpkO1vFOOBxSuSzBY/5nU2gWGcynFZD3QHBIN/o6FDGM6PTqjUtT6l1BwW7b6QLIqPzReR3zlDsHJHgZzBhINDZ7fhJDiOc1HgpYs93nkqvuKc0rGGeeAAjSB2LXDJCfpyFDqsuEcLsiLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68OuvNh+P+GxtE6JQcq4MIsELOcRwSmXAYE13okJjZk=;
 b=QML6+bhs83c7eWyW7I3DK1X/H9cI4QKSfWjREdrH0JdDxuGC0X0ktLc7qua1y8U5llCy82xyswh/Kx5QAg+zSu5c27Dfmcnl+zWE6hrDwMG+4JzrKkQ+D1f20ReZvkb/S8ZAnOL0WBOTV0cdEORtS7ve6QLBo+tXzSNeh8apPkQ=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2671.namprd20.prod.outlook.com (20.178.254.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Thu, 5 Sep 2019 13:55:54 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.014; Thu, 5 Sep 2019
 13:55:54 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: inside-secure - Fix unused variable warning when
 CONFIG_PCI=n
Thread-Topic: [PATCH] crypto: inside-secure - Fix unused variable warning when
 CONFIG_PCI=n
Thread-Index: AQHVY7gb6ppjCLb4NEeGzjBZPyb4pqcdDTiAgAAODOA=
Date:   Thu, 5 Sep 2019 13:55:54 +0000
Message-ID: <MN2PR20MB2973E751CAEA963B3C43110ECABB0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1567663273-6652-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190905130337.GA31119@gondor.apana.org.au>
In-Reply-To: <20190905130337.GA31119@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 785f1051-c5ea-4cd6-e01f-08d73208c567
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2671;
x-ms-traffictypediagnostic: MN2PR20MB2671:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB2671E3F03F149B800CF490C0CABB0@MN2PR20MB2671.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:126;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39840400004)(136003)(376002)(396003)(346002)(366004)(189003)(199004)(13464003)(8936002)(76116006)(86362001)(229853002)(186003)(52536014)(305945005)(7736002)(66946007)(256004)(14444005)(7696005)(74316002)(2906002)(3846002)(99286004)(6116002)(316002)(26005)(5660300002)(8676002)(66066001)(81156014)(81166006)(76176011)(102836004)(53546011)(110136005)(54906003)(6506007)(53936002)(6246003)(14454004)(966005)(446003)(25786009)(9686003)(6306002)(55016002)(4326008)(6436002)(33656002)(71190400001)(71200400001)(11346002)(66556008)(66446008)(486006)(476003)(478600001)(66476007)(15974865002)(64756008)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2671;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cxdPXQNrfYjeH/VkiGFup96wvDqZAux6TpKCTg5JEo7XmXja0Nb+LbWzi5QDbPFWDXU5kan2ZuhUlh0Eo7Fq0ieHZTJNVyzbkZvHmCy93oEESO19/6igYWRoEc2Ph4vcGG0B34dSqAneu6fSi4Sqk2lmQbv6RSvbER9FTCdCF0LImd7UrmpI8QUndpOEWQ18E2vBaJQvmt09L48xnhOSGsOna+xqsjSaVfsAc/wZB4HW8k5yA4j7vhOSm00Qy9Tauhc4/mI9gkQfb32AAx0W93WGY/hKyekRR2/KStcXb4l+EqxoEDGYccSPj9Owg+b50jjQL8yN1pSrsRwZb3XkujuLrA4YpuwAABKjEd+bqqlEedbv05io3Mkb7dNMFbH/fff5nHkn7rWjjgy2+OZHB7aJ+NoYBJ6R3II7y9mw+0k=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 785f1051-c5ea-4cd6-e01f-08d73208c567
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 13:55:54.8841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XV3QGlZfeIMkUGt8J0oTtRcqoTfqSWiux1WvWr3rqQP6HJp0DOn2bIWQ2OGBgdPmmXePwe+8SKqjYrQ6QPqxEcrlSlO66p14hQZX39VtrCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2671
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Thursday, September 5, 2019 3:04 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; davem@davem=
loft.net;
> Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH] crypto: inside-secure - Fix unused variable warning =
when
> CONFIG_PCI=3Dn
>=20
> On Thu, Sep 05, 2019 at 08:01:13AM +0200, Pascal van Leeuwen wrote:
> > This patch fixes an unused variable warning from the compiler when the
> > driver is being compiled without PCI support in the kernel.
> >
> > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > ---
> >  drivers/crypto/inside-secure/safexcel.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/i=
nside-
> secure/safexcel.c
> > index e12a2a3..0f1a9dc 100644
> > --- a/drivers/crypto/inside-secure/safexcel.c
> > +++ b/drivers/crypto/inside-secure/safexcel.c
> > @@ -1503,7 +1503,9 @@ void safexcel_pci_remove(struct pci_dev *pdev)
> >
> >  static int __init safexcel_init(void)
> >  {
> > +#if IS_ENABLED(CONFIG_PCI)
> >  	int rc;
> > +#endif
> >
> >  #if IS_ENABLED(CONFIG_OF)
> >  		/* Register platform driver */
>=20
> Shouldn't you check for errors for CONFIG_OF too?
>=20
You are correct, the platform_driver_register can also return an error=20
code. So just fixing the compile warning was a bit short-sighted on my
behalf.

I'll redo that patch.

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

