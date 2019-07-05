Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8D1C4649B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 15:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08F3521738
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 15:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="Q4Tq1mO4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbfGEPEQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 11:04:16 -0400
Received: from mail-eopbgr760073.outbound.protection.outlook.com ([40.107.76.73]:15559
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725837AbfGEPEQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 11:04:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBO/hLM+MT5pWR/veDAO3j9pKxGNfrMHvhSpXcE+IFg=;
 b=Q4Tq1mO46gAUAPEGQeTX27lZsHTEtftRAhgYcCcpSlmijc5ffoL/1YHqsHsg2GyUqlZ3Ipx0RiXrJN6SgQwLW+0cyGTuRdIdW3JcN7GQyIH0vohfQCfJEDokcpp0/sP8HRju4MbICXGuxba1Xe2bhzGE7b0uSFzgsrwot9oNXw4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2959.namprd20.prod.outlook.com (52.132.172.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Fri, 5 Jul 2019 15:04:13 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2052.019; Fri, 5 Jul 2019
 15:04:13 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>
Subject: FW: skcipher and aead API question
Thread-Topic: skcipher and aead API question
Thread-Index: AdUzFZSC+g/TbhjQSoOcPg+7Aq6e8gAG+c8AAAMQdVAAAUBxwA==
Date:   Fri, 5 Jul 2019 15:04:13 +0000
Message-ID: <MN2PR20MB2973B45332A6CBDCAE43B91ACAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <BY5PR20MB296261AC5E07B6E7E2B7E6A9CAF50@BY5PR20MB2962.namprd20.prod.outlook.com>
 <20190705125930.7idte7awvhixvsnc@gondor.apana.org.au> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3c07073-2e16-4b07-2c7e-08d7015a0aa3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2959;
x-ms-traffictypediagnostic: MN2PR20MB2959:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB29596A3E7E3E6CDBFE393A16CAF50@MN2PR20MB2959.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(346002)(376002)(366004)(136003)(199004)(189003)(81156014)(76176011)(6306002)(52536014)(81166006)(476003)(8676002)(446003)(4326008)(99286004)(15974865002)(71190400001)(86362001)(14454004)(71200400001)(229853002)(53936002)(966005)(55016002)(68736007)(74316002)(5640700003)(305945005)(7736002)(2473003)(256004)(6436002)(9686003)(6916009)(2906002)(66066001)(33656002)(2351001)(2501003)(186003)(26005)(5660300002)(6506007)(7696005)(316002)(478600001)(486006)(25786009)(8936002)(3846002)(6116002)(66476007)(66446008)(66556008)(102836004)(64756008)(66946007)(73956011)(76116006)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2959;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qTlX61WAjnl769Auw9cbMBtyhkbvIXtAZPf8xwpGeDAZ+4uruTm/KOdKOpxW5ONAvhlxmTi2pyIFq0H3K1mgHlfPAjsPlAzLlLXV3MYHTUxXXG/W+nB5huAPWxXHdL5TCHRNlRRRa+120/2k8IR5VBeS/LkRYpP5t78i831SqetN4F2yMmfOAiYxj9KP6+Ou0VzJGEKeb5bhm64haE7vTTAvJ9M3u+qPzWH0LHb5yJr67EyqPISPh4qdjVoPtVq1IBiauRug69Dd0ZYW1rMuK+BfWB/KgmuSAZbb4NrGjHmJSRH4sayZCeU5k7W8aPieQdbQdoOFg2mvGv8K3yRBqUSIDG6KTCmcIJLx+19TaKgp4MfU0DO3lfno/m1GIiVZPHGhwvmP5zKOe3Bl1AbNWWIltQxGQYRkxmT8Q7LOEFo=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c07073-2e16-4b07-2c7e-08d7015a0aa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 15:04:13.1805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2959
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+mailing list +davem)
>=20
> > Finally, I noticed that aead.h defines an additional callback 'setauths=
ize', which the
> > driver currently also keeps at NULL and that *seems* to work fine with =
all current
> > testmgr tests ... so I do wonder whether that is a must implement or no=
t?
> > And if so, which subset of auth sizes MUST be implemented?
>=20
> This however must be implemented *if* the underlying algorithm
> (IOW refer to the generic implementation) supports them.  The
> set of supported values must not be smaller than that of the
> generic algorithm.
>=20
> In practice this shouldn't be a big deal as it's just a matter
> of truncating the ICV.
>=20
Hmmm .... for a HW driver, the HW would have to do the truncation.
So it must be capable of doing that AND it must be instructed to do so.
I guess big deal is a relative term :-)

> Note that you don't actually need to supply a setauthsize function
> if all values (less than maxauthsize are supported).
>=20
If I don't implement that function that I cannot tell my HW how the
tag should be truncated ...

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
