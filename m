Return-Path: <SRS0=Wq3S=VB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F8AC0650E
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 08:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BC842189E
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 08:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="OzRuzBI3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfGDIhP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jul 2019 04:37:15 -0400
Received: from mail-eopbgr730043.outbound.protection.outlook.com ([40.107.73.43]:39040
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726805AbfGDIhO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jul 2019 04:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zhpan8ykED7nbKSstMFVTotIAbis9JPN4qdFf67O1tw=;
 b=OzRuzBI3g2IxIm7Xpx8uxHvO1xTy8sKInyRrr15FlSNgI1W2C25AO/MrQszpbhdssimGxxinXn05M5EJcOR+6kRRhKX8gBCp5UmfGfZa7DfI2w0bfasc6Xbjyxrv0lLyYC85uh+eoU/l9yRaZR7UkYmflDQvNl76XFGbsOlCKwc=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3101.namprd20.prod.outlook.com (52.132.174.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.16; Thu, 4 Jul 2019 08:37:11 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 08:37:11 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: testmgr fuzzing for AEAD ciphers
Thread-Topic: testmgr fuzzing for AEAD ciphers
Thread-Index: AdUyQjTY1c0oiQ20QKyM6t3OYyJc2g==
Date:   Thu, 4 Jul 2019 08:37:11 +0000
Message-ID: <MN2PR20MB297300C9DA57540354107BEBCAFA0@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17733ceb-2086-4202-b994-08d7005acef3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3101;
x-ms-traffictypediagnostic: MN2PR20MB3101:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB31013712B4BAB44139865C85CAFA0@MN2PR20MB3101.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39850400004)(136003)(346002)(13464003)(189003)(199004)(8676002)(7736002)(68736007)(9686003)(476003)(256004)(81156014)(81166006)(55016002)(33656002)(25786009)(7696005)(53936002)(2906002)(66066001)(54906003)(3846002)(6116002)(5640700003)(478600001)(14454004)(99286004)(66556008)(66476007)(74316002)(186003)(6916009)(71190400001)(4326008)(2501003)(53546011)(66946007)(73956011)(76116006)(316002)(6506007)(2351001)(102836004)(66446008)(64756008)(26005)(71200400001)(52536014)(305945005)(86362001)(15974865002)(486006)(5660300002)(8936002)(6436002)(21314003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3101;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TBqCan8aF81KnogD6guHX9TIKfmHKzOzbVmJxq5ffyW6YUZm3F8hH2JCMWEPb5Xx36x00+JCQUS5iIfNeoK8tZpMAVMtdEPHSJWfoUdqCp3nldoY56T/JC36SdzLcQrThzSo2b5RD3rVuiseNerlg9QIqML54XCVQwjqo3H8SWUtVRnngTGNQf63Lgj3ZBEQHsSygMilrU7fTp/QSAyNYiPENjW8jkhb4BKTfp9pAnmCKMgsH743n7qdFM0sNLM11AGUuRMKGP9twVeDSfZj8k+apdBinSPUDnidV717pr/6bS+8/YepTt/2kp8Mbff3uBZfGjTciyVwdjpdcNUc3/i6DIf5Qk+rVSrp30Xja6IFsafcAAxLFOl01rmSotjnTDBkhCu3NOhf1aJzGLhu4wSujHmEklTqi7lc5vRf/dI=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17733ceb-2086-4202-b994-08d7005acef3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 08:37:11.4321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3101
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I was attempting to get some fuzzing going for the RFC3686 AEAD ciphers I'm=
 adding to the=20
inside-secure driver, and I noticed some more things besides what I mention=
ed below:

1) If there is no test suite, but the entry does point to something other t=
hen alg_test_null,
then fuzzing is still not performed if there is no test suite, as all of th=
e alg_test_xxx routines
first check for suite->count being > 0 and exit due to count being 0 in thi=
s case.
I would think that if there are no reference vectors, then fuzzing against =
the generic=20
implementation (if enabled) is the very least you can do?

2) The AEAD fuzzing routine attempts to determine the maximum key size by a=
ctually
scanning the test suite. So if there is no test suite, this will remain at =
zero and the AEAD
fuzzing routine will still exit without performing any tests because of thi=
s.
Isn't there a better way to determine the maximum key size for AEAD ciphers=
?

3) The AEAD fuzzing vector generation generates fully random keydata that i=
s <=3D maxlen.
However, for AEAD ciphers, the key blob is actually some RTA struct contain=
ing length
fields and types. Which means that most of the time, it will simply be gene=
rating illegal
key blobs and you are merely testing whether both implementations correctly=
 flag the
key as illegal. (for which they likely use the same crypto_authenc_extractk=
eys
subroutine, so that check probably/likely always passes - and therefore is =
not very useful)

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Pascal Van Leeuwen
> Sent: Wednesday, July 3, 2019 11:51 PM
> To: linux-crypto@vger.kernel.org
> Subject: testmgr question
>=20
> Hi,
>=20
> I'm currently busy adding support for some AES-CTR based authenticated en=
cryption suites to the
> inside-secure driver, and I got the distinct impression they were silentl=
y not getting tested at all.
>=20
> Looking at testmgr.c, I noticed that they point to alg_test_null, confirm=
ing my suspicion.
> I was wondering whether this was intentional and, if so, why that is the =
case?
>=20
> I get that there are no reference vectors for these ciphersuites yet, but=
 that shouldn't stop
> testmgr from at least fuzzing the ciphersuite against the reference imple=
mentation?
>=20
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com

