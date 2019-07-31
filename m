Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BCCC433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 14:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D417F206B8
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 14:54:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="SziZJ8OZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388106AbfGaOyB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 10:54:01 -0400
Received: from mail-eopbgr690049.outbound.protection.outlook.com ([40.107.69.49]:29445
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388075AbfGaOyB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 10:54:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NjsYKb1PDY2FNMapfSvf2faKEOYKIPC9VF9t1HsKAjkmbz6TlGCVYOhIFIuvcIk+Op0sBJ8kMCF04hDAVlnWuIN2iIAKn6BGBxef+HIJibYFchBNFF/fKkmrW6/6s5Bn1vmbexFr4cnbE/3cDW9ckbG3LCd5s2apnSF+1gHTHFTdbEEStMPb2F+EBWr1Fmpa/EmtGYmrW5cy5Pcgb3ejR9/wDhidQay0DRIMzd69h65wokRhNHTKZQLbBcgcwGgofGRjGfh35BKcRRFk0WKF/zRXavNvcAMbm146EeI+S9yY7YNZYsg0Vdx8K1AWodzstDmFFwU/cHqcmtgCTnLgiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1IgFiw4ATWbdoRVh49aQFL/ms+8QNdMEQQi+oqshK4=;
 b=IHvLV7rA9AJE2rTYczNGOZT5k9nyUC/ekbAROx768joxiTHL8/Al3t9jiBLRV8apVsDJXVLxp4ygXNOn6rEoGBCmNI7Qfy7nzfdPitNiOURysbOQHvNkp5dv/+rbFh1Ptr/bRb3X2RPD8xKaqJBxZP1FGI2rjz8qnyLrVWZdrApxVLIzT7C2h++5F8qXtRKwFiJ4a9wADmJAbdKkC/EZBR/dXB/zaWJXMYmtfWB0iQwqyf0udAx7L1nOKSmzpDciRXcXaAjpH1ypHcw4tJhY/pFPDnNE6Hj0Akgfz+oYVO9BbTWSWGqIRviAWR2/Y8rXGExm25f2+u2SDwXq19CRiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1IgFiw4ATWbdoRVh49aQFL/ms+8QNdMEQQi+oqshK4=;
 b=SziZJ8OZFRvQXxeAqgbzovBry2BLnv6uNn0NWBYkKKL+2s+ilE1pTgKVO7itdcmv39Ms33BNKUtYyVgeI0bcAdPlYF2Nqb91m1MgrGUI6DCa6wKfyr4RqDUqSP7B+Xr1OVtRhqKbSg8YLVzkLQO0CKon8GoulfAwRJ9wC/EC4kw=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2686.namprd20.prod.outlook.com (20.178.251.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Wed, 31 Jul 2019 14:53:57 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 14:53:57 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 3/3] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Thread-Topic: [PATCHv2 3/3] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Thread-Index: AQHVQ7iGh/FCPWFvzEu8OjwaBoGczKbkruqAgAAcroCAAAo6AIAAAdBg
Date:   Wed, 31 Jul 2019 14:53:57 +0000
Message-ID: <MN2PR20MB2973CC96402B698AD1F37930CADF0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-4-git-send-email-pvanleeuwen@verimatrix.com>
 <20190731122629.GC3579@kwain>
 <MN2PR20MB297305FF43E83B4BBB5728B7CADF0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190731144544.GE3579@kwain>
In-Reply-To: <20190731144544.GE3579@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95b54bf0-3f34-4d90-56f0-08d715c6ea8b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2686;
x-ms-traffictypediagnostic: MN2PR20MB2686:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2686E095CCA8B36A075E9C19CADF0@MN2PR20MB2686.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(366004)(39850400004)(376002)(13464003)(189003)(199004)(55016002)(478600001)(76176011)(6436002)(7696005)(25786009)(3846002)(71190400001)(71200400001)(6916009)(486006)(446003)(52536014)(6116002)(4326008)(8676002)(68736007)(229853002)(11346002)(186003)(53936002)(256004)(6246003)(26005)(86362001)(476003)(6306002)(316002)(66066001)(14454004)(33656002)(74316002)(66556008)(66446008)(8936002)(66476007)(15974865002)(66946007)(102836004)(64756008)(81166006)(54906003)(2906002)(6506007)(9686003)(5660300002)(81156014)(966005)(7736002)(76116006)(53546011)(305945005)(66574012)(99286004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2686;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TJnei06hkif/CG3DRxQ586vpxCnEzEEiORaNtsPR3Xb3EC0EwxtPdyKZAwYzSjPHRN+W9o+nd86NPZvgP4EMooxfm+qytN2T53TyBY4IJwB2B3bNIuXjWjaP6uzbIoe+28+C+HynwZSA8ryjjiGVenL1DQA6s/FiU3utsOXHo5i2ry6kJpAnUDOx5B73YN42t3//blMnuEJgWEmHY/oJfkEsWDMjM/mvTHzk2q/0VLq5OqUMdoeqimRoROsY+AAUiihKRNQleqswhlbhaVYxyM73uafcbQDyDgxpfU37qzBZdLg9NBZBTCqlb5LqEgEdPPCdRSE+g72brnasUDgCFerUNVvNDX9VmlH58PPZMCFGxYqxlvokdXETDUz3m6Y11ZgvIQfMQipzjgkQeSQnA7uCMCcfjodsmTWJCvAk78Y=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b54bf0-3f34-4d90-56f0-08d715c6ea8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 14:53:57.7483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2686
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Wednesday, July 31, 2019 4:46 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen
> <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; herbert@gondor.apan=
a.org.au;
> davem@davemloft.net
> Subject: Re: [PATCHv2 3/3] crypto: inside-secure - add support for using =
the EIP197
> without vendor firmware
>=20
> On Wed, Jul 31, 2019 at 02:23:27PM +0000, Pascal Van Leeuwen wrote:
> > > From: Antoine Tenart <antoine.tenart@bootlin.com>
> >
> > > What happens if i < 2 ?
> > >
> > Ok, I did not consider that as it can't happen for any kind of legal FW=
. But it
> > wouldn't be pretty (neither would 2 itself, BTW). I could throw an erro=
r for it
> > but it wouldn't make that much sense as we don't do any checks on the f=
irm-
> > ware *contents* either ... So either way, if your firmware file is no g=
ood, you
> > have a problem ...
>=20
> The thing is to avoid doing harm to the kernel if a single driver can't
> work as expected, especially when we have an user input (the firmware).
> The firmware being a valid one is another topic. But honestly I'm not
> sure if a wrong returned value would change anything here, apart from
> not probing the driver successfully as we know something went wrong.
>=20
Initially I thought it would hang (as the HW would hang for sure), but on
second observation the driver already has a nice time-out mechanism on the
firmware startup, so it would just throw a nice error and bail out. Same
as it would do for a e.g. a corrupted image. So I think this is just fine.

> Thanks,
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
