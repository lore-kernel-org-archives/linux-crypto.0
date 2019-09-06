Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CE6C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 13:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BF8720842
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 13:48:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="gwet2tYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404551AbfIFNsA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 09:48:00 -0400
Received: from mail-eopbgr730040.outbound.protection.outlook.com ([40.107.73.40]:54432
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727031AbfIFNsA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 09:48:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exIa6Ehm88OO99lVijHP8ls6WcHTYOjD8F/hJhO+L0TQim0s1IXa8GOA6IqIZqurqOK7r3RmWbPjo+Qq6wbMGDbWso4FXzIu6qmyX27wiviy1Br5PNUIWGYmTq3o7jXrKq0ChqMHZ/ijp16F6KRrDZ4m7jzRBxEDRCjuB1OUIjEZZFR5cWgkC34tQLMnm7heE+WZgygIoMuScV4F9ulIomzjZu8cgbJc8NdQR1+P8DteBGKQOwTjOOlL1nDqy6g0o/Ae6EWHUvrGBk3cTK3D6khMKButUygsV6rtg16++YRxXspvB4DQSANFoWev6gn+qxqehG2KaPXJv8bchs54uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3MbVhLjuFsh0eUHdarKFu1WjVD2PH2yAgLMZ2utrmE=;
 b=cHMETx45TE9DLVUNgeNXFNsldCCTSwFkEoKEmBNxuzrzNOmjM3DVkXP/E8wK3fs+lYR0dsP0aMueg9eYHJXDRZ+W13Ej+ITSStANHy6n2j6vNwsYxMl66RKL8yZyRNPCO4IixlLAySZFLIOU6uaQzf28jn2tmw53+E5kuxN8mnlrbC72W0LufmPuCdoDjAD51RC4sgKqkXx1ypkO8DPTxTvIznYg4RloZ6S6wl5itZy8bB6dn3b6QTU9NeIbgYbFmJONHFOq4tWa1fCnUnEsXUVSeZNZEjZLTKdeFRsaarrC3wet7VLDTQEiSMaaafp9NEaYYd7mmmNWe7ZsC+P9wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3MbVhLjuFsh0eUHdarKFu1WjVD2PH2yAgLMZ2utrmE=;
 b=gwet2tYRV00i25spyaONwcA0ASVXmjA0R7rp/i7Dw4+zvH3Lo5Wd4P46FHiUaYTmQ6aPOg6pVJDIJMAh6sV5wK+ZaVFiPkBXuGSWiVLdJ1/kwgmI9bL1NorryQ+O5c4QlEAU6e5hbTM2U66pHsS5FcO0KNf+i3tzLnAfHLWU4Wo=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2319.namprd20.prod.outlook.com (20.179.146.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Fri, 6 Sep 2019 13:47:56 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.014; Fri, 6 Sep 2019
 13:47:56 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: RE: [PATCHv2] crypto: inside-secure - Fix unused variable warning
 when CONFIG_PCI=n
Thread-Topic: [PATCHv2] crypto: inside-secure - Fix unused variable warning
 when CONFIG_PCI=n
Thread-Index: AQHVZJLkcblhpiNCdkqzLJoi3G2RDacekUyAgAAKwpCAAAJGgIAACz7A
Date:   Fri, 6 Sep 2019 13:47:56 +0000
Message-ID: <MN2PR20MB297358EF5BC301258B888DA9CABA0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1567757243-16598-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190906121843.GA22696@gondor.apana.org.au>
 <MN2PR20MB2973DC6D4E1DC55EB1AF2825CABA0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190906130521.GA26780@gondor.apana.org.au>
In-Reply-To: <20190906130521.GA26780@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3c07999-e25b-4a5c-a1c3-08d732d0d2b7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2319;
x-ms-traffictypediagnostic: MN2PR20MB2319:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB2319A880C2C969893CB5103FCABA0@MN2PR20MB2319.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39840400004)(396003)(376002)(346002)(366004)(13464003)(189003)(199004)(6246003)(55016002)(9686003)(81166006)(81156014)(6436002)(53936002)(5660300002)(6306002)(99286004)(229853002)(7736002)(316002)(52536014)(54906003)(966005)(14454004)(4326008)(74316002)(305945005)(8936002)(8676002)(7696005)(6916009)(476003)(446003)(11346002)(478600001)(25786009)(486006)(14444005)(256004)(26005)(102836004)(186003)(15974865002)(71200400001)(76176011)(66946007)(66476007)(53546011)(6506007)(2906002)(76116006)(66446008)(64756008)(66556008)(33656002)(71190400001)(86362001)(6116002)(3846002)(66066001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2319;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MLUwPc4jQDzjtO9E3kO3QVK4XFGisiu/02ZBf4639kFI6c4KACzX/+aLK0yiesk8fPHpl2WVxnCeNGiuuROtfA2EOhXvkKmSmewd00B7DpHmdQbjrfJhwoUvRxGE6WtC8uxGhdWRsrO7hRxfmMdWNfgc19dcK9H9HS0F+owwuqJcFHPq23exekyReZw0KpvZmmGOOpiklD+EQfkY/EAtBNgDjmXgWfUrtBLKW8DPwaGcKvJZO8MsMrmpqNRPmD55GZVxBgAOFmaBJiWL19trdqQVU9sm29VgmvamHoOGsc/hsSqVIAIt5ypppVzeyupuuU9R8CCG16Iiekm/n4E15N3sdoYHmiduBntrqFykgFVfMfPj2x6KyFVN+3VQYAto/jc8Fjetbem7/kN38wbL+kMdbXSEcvjGGWMkLnR0eJw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c07999-e25b-4a5c-a1c3-08d732d0d2b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 13:47:56.5700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 78iRWmb8h9IbGybkyozxESqoI9gvkKxwckYtRxz/DtY4Hm/DszLdZtVx4UtsD37tuERhuzLbXTpPFFrQc9RyY3APoI1yMFnLM7RlMdNqaS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2319
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, September 6, 2019 3:05 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Pascal van Leeuwen <pascalvanl@gmail.com>; linux-crypto@vger.kernel.o=
rg;
> antoine.tenart@bootlin.com; davem@davemloft.net; Bjorn Helgaas <helgaas@k=
ernel.org>
> Subject: Re: [PATCHv2] crypto: inside-secure - Fix unused variable warnin=
g when
> CONFIG_PCI=3Dn
>=20
> On Fri, Sep 06, 2019 at 01:01:19PM +0000, Pascal Van Leeuwen wrote:
> >
> > I explicitly DON'T want to abort if the PCI registration fails,
> > since that may be irrelevant if the OF registration passes AND
> > the device actually happens to be Device Tree.
> > So not checking the result value is on purpose here.
>=20
> Well if you want to support that you'll need to remember whether
> PCI registration succeeded or not before unregistering it in the
> exit function.
>=20
Hmmm, actually I was assuming those unregister calls to be effective
nops if no matching register succeeded previously. Like free() is a=20
NOP if you pass it a null pointr.

If that is not the case, then I indeed need to remember which call(s)
passed, such that I only unregister those. But since the exit()
function does not take any parameters, I don't see any way of doing
that without using some global variable ...

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
