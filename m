Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2F9C4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 407D121A4A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:22:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="b1SSD20B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387785AbfIIMWe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 08:22:34 -0400
Received: from mail-eopbgr700043.outbound.protection.outlook.com ([40.107.70.43]:22369
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387764AbfIIMWe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 08:22:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gE3M5DZRy0FYUOsU+W8md14q+ytOujwWliq6G/dKeUt8gSt8ssuv5JdH5iTSapmZvDYF/S/bKTJ8dFYoS1aCihhYrTgpHr0vszH/EvSjr3gKzFX0GvT8o9oZ/5ch35ycEweoCj7TmEa/B/rCgYS4/AK9tkpVMRjDmurYRWrmWA6H9NM00XlJKUDiDN2tE5HOirVt/6DTx/8Ze8rbu4XKxLSTa0XMTDEOIxOFDtGOhz8CPBB4dRVWAqAFaT4bWAp58X3czeOpls6lE25a90ysvMMNDcstJFxC2RtEBj5dgH485o6IK38sLzO07kh/jSrvsZDQY9kHh4+p+vNqddPRWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bs9ZRtmctKHFA9Nf7uL/GaseZyPZtYP+gRR302qSK8=;
 b=c4cpn+G6+FwUG99nJBtP4/vY6q+U//hQiyt6Wa+QX4v6VkoANfVBj7EBZ6Mgp6nsnqijHjnKWohR97zD4iqVHWvcPrsQv/BkeXWsF08lbUJmAg5+6GpGDQElqpX0gwDVTez4y6dMNGYH14U387H19bI0JDP8sYsRE6UV7xq/benutx584yg7gM3PIomRF1b3jufT7KGizZ1yzqxwuVn8keFAG3LMlGCEFwmQ8d933sy/jpIMtSv+5Qphs4MdbwsdG4uNMlwTh/FcM2SjFCleRoFsk9lz+3V94n8SWUlLBMOQk/4rULmHpY3wrc1sHd+YkyykOQMoa64idyL9C3yEVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bs9ZRtmctKHFA9Nf7uL/GaseZyPZtYP+gRR302qSK8=;
 b=b1SSD20BXkTr3J8BFK18IYRcWTmB6rHUMJJnCidkeANvEnR2Eh1Lphd/qHZuOZOqG2MFl17qG3dmaLBp22tnSyahm1kwDVnfO7mEfQ0o4caqVONkh9fzZoEk53MrEbFbXxcJct4KR3csMnBCk83pDvgNKiQhkh2YRIsR5qHBLzQ=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2544.namprd20.prod.outlook.com (20.179.148.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Mon, 9 Sep 2019 12:22:31 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 12:22:31 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 0/3] crypto: inside-secure - Add support for the CBCMAC
Thread-Topic: [PATCH 0/3] crypto: inside-secure - Add support for the CBCMAC
Thread-Index: AQHVYv9asl0eADp8PE2B9pjhBKQu46ci/PoAgAAwu6CAAAPgMIAADa0AgAALdiA=
Date:   Mon, 9 Sep 2019 12:22:31 +0000
Message-ID: <MN2PR20MB2973FC7574231C059FB72567CAB70@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1567582608-29177-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190909073752.GA20487@gondor.apana.org.au>
 <MN2PR20MB297379E80B6CD087822AD9CDCAB70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB29735284B8567182E7B916D0CAB70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190909113506.GA4011@gondor.apana.org.au>
In-Reply-To: <20190909113506.GA4011@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fffa9ce-63b8-4bc9-8329-08d73520631f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2544;
x-ms-traffictypediagnostic: MN2PR20MB2544:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB25448EDD23F18D709244DC3BCAB70@MN2PR20MB2544.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(366004)(39850400004)(396003)(346002)(136003)(376002)(199004)(189003)(13464003)(81156014)(229853002)(33656002)(9686003)(8676002)(186003)(76116006)(71190400001)(71200400001)(4326008)(53546011)(6246003)(6306002)(6436002)(6506007)(2906002)(26005)(55016002)(81166006)(8936002)(86362001)(53936002)(14444005)(256004)(102836004)(966005)(5660300002)(316002)(476003)(486006)(3846002)(6116002)(15974865002)(478600001)(74316002)(52536014)(14454004)(305945005)(25786009)(7736002)(66066001)(54906003)(11346002)(99286004)(66946007)(66476007)(66556008)(446003)(76176011)(64756008)(66446008)(6916009)(7696005)(18886075002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2544;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 34FNFD0DbnYbwEv7wb3cn58EWblYpx+5xTvYGoEHhQ6wm7yNKSDu857H6PUSlF440PS86MevE3qWAwXlD7eC6nTkEDIdCGa2JbuyELvbaTjONmU+kZ2MM7KQhtfxaqFRjornGjk7wGIa+5lOIZVqfLFLcfSsucFTYc5X86JANlQBzx9qzYOm+rVigu+kz0igP0HPF6I50lvC3wnr8rSFmzwdFhIGWCI2C7f0oe8UgISEDJz3I55oIHTeTcfFrab/dsVV+mK5YDqCfBtHTqNHxOzzuRADeK9srxhPGY0qfpAN/y5XI003eD/B4Mhd9RIY69rOfvU/vRbwn93ZfKpYL0Bg+oMHUrG/qMc4c2eGGBYDzge9KdZEDeRe18kPYuz61I5h2D+SxPbxB2Q5uipIffnR5ncjejARWOPmV5D4OtA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fffa9ce-63b8-4bc9-8329-08d73520631f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 12:22:31.2141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +/c1+gDbCIMG+xlItvUPNydO4SwIGViQhSF6FT9rEzg5BnxZIRegsFUGkMkF7iCNB/JuflPAHKSL/Ch2pDOYRzqX6W8PRUBHM+WBz9A+r50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2544
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf
> Of Herbert Xu
> Sent: Monday, September 9, 2019 1:35 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Pascal van Leeuwen <pascalvanl@gmail.com>; linux-crypto@vger.kernel.o=
rg;
> antoine.tenart@bootlin.com; davem@davemloft.net
> Subject: Re: [PATCH 0/3] crypto: inside-secure - Add support for the CBCM=
AC
>=20
> On Mon, Sep 09, 2019 at 10:50:12AM +0000, Pascal Van Leeuwen wrote:
> >
> > So my suggestion would be to supply the CRC32 patch and
> > then resubmit this patchset unmodified. Would that be OK?
>=20
> That's fine.
>
Ok, I just submitted a patch called "crypto: inside-secure - Added support
for CRC32" and then resubmitted the "crypto: inside-secure - Added support
for the AES-CMAC" patchset.

If you apply them in the order I just sent them (i.e., CRC32 first), it=20
should apply just fine.

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
