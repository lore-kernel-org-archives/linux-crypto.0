Return-Path: <SRS0=Wq3S=VB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD2AC06518
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 09:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88C4A218A6
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 09:36:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="ByenDj34"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfGDJgO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jul 2019 05:36:14 -0400
Received: from mail-eopbgr770051.outbound.protection.outlook.com ([40.107.77.51]:65188
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727365AbfGDJgN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jul 2019 05:36:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3+qaEh1Kvfqn4aUKoeCh68a4VOPZ51BNsv2PK/O2nA=;
 b=ByenDj34iSEa7TnUXO0SHeUzVE6MIP1L3D1p/w/QvOcjXvqPoO/zYt8B/oB6GJGEMNlKBaH9E501/3A6M1UVHwd+d7ILgD+Yu39/N11fSVkjlO/Hp+rxK1AezPSmKyckphy8hYY5M5I6XQIO5vpdVOQvR0cvBppOb4EmVoNPWC4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2736.namprd20.prod.outlook.com (20.178.254.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.16; Thu, 4 Jul 2019 09:36:10 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 09:36:10 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: RE: testmgr fuzzing for AEAD ciphers
Thread-Topic: testmgr fuzzing for AEAD ciphers
Thread-Index: AdUyQjTY1c0oiQ20QKyM6t3OYyJc2gACPKlg
Date:   Thu, 4 Jul 2019 09:36:10 +0000
Message-ID: <MN2PR20MB29730FC9714D461190AF9179CAFA0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB297300C9DA57540354107BEBCAFA0@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB297300C9DA57540354107BEBCAFA0@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e429f5f-27dd-4f7d-0d8f-08d700630c87
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2736;
x-ms-traffictypediagnostic: MN2PR20MB2736:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2736342EA26A768A4FF3DFF4CAFA0@MN2PR20MB2736.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(136003)(376002)(346002)(366004)(13464003)(199004)(189003)(486006)(2940100002)(2501003)(53936002)(52536014)(14454004)(55016002)(11346002)(476003)(9686003)(66946007)(66446008)(64756008)(66556008)(66476007)(446003)(76116006)(33656002)(2906002)(6246003)(8936002)(15974865002)(2351001)(68736007)(7736002)(316002)(305945005)(3846002)(73956011)(6116002)(8676002)(81156014)(74316002)(81166006)(6916009)(54906003)(478600001)(7696005)(6436002)(5640700003)(99286004)(66066001)(229853002)(6506007)(26005)(71200400001)(25786009)(71190400001)(76176011)(186003)(53546011)(102836004)(4326008)(5660300002)(86362001)(256004)(14444005)(21314003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2736;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Sj5eI8DWnP0LUv6PqG/hG+9HpuNh4AQkEl8Bh4X/u02GektUAqjjYeYpF8/EEOKagrMYCc3z3YRK0ZvaemhSNNu+81ctqy0aF0/QjHb6aisFGUz1oKEfhIP2xTMSNc5u30g1nXkXB1ysXvTLkxnuo2GKTac2WAJuFdPmIHwO03Na3+KOzJNxdAPAfwf6rsDP7WS3EB84QJPLqCIdVJzBR40tEI0T87r6Xzq68vmzkdVh5iJ6CX3qsz9XC1x+GTSN4IP1zfY0ykcPkyeTaipwvmJid2f0sgk/8HiyQhrVKlzFvFTvAdjn1cIByS1WsJPnWjquGviXzDKpQkFusi+62hu7HewpHYVNa4j7WmlRGt06GQfCqV1a1tXBzSaOAh2LekaL3KsoRH6LlKQsBbTUeu+Fvobwu5n4Ui+KgmDJrR4=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e429f5f-27dd-4f7d-0d8f-08d700630c87
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 09:36:10.7304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2736
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Pascal Van Leeuwen
> Sent: Thursday, July 4, 2019 10:37 AM
> To: linux-crypto@vger.kernel.org
> Cc: Eric Biggers <ebiggers@kernel.org>; Herbert Xu <herbert@gondor.apana.=
org.au>
> Subject: testmgr fuzzing for AEAD ciphers
>=20
> Hi,
>=20
> I was attempting to get some fuzzing going for the RFC3686 AEAD ciphers I=
'm adding to the
> inside-secure driver, and I noticed some more things besides what I menti=
oned below:
>=20
> 1) If there is no test suite, but the entry does point to something other=
 then alg_test_null,
> then fuzzing is still not performed if there is no test suite, as all of =
the alg_test_xxx routines
> first check for suite->count being > 0 and exit due to count being 0 in t=
his case.
> I would think that if there are no reference vectors, then fuzzing agains=
t the generic
> implementation (if enabled) is the very least you can do?
>=20
> 2) The AEAD fuzzing routine attempts to determine the maximum key size by=
 actually
> scanning the test suite. So if there is no test suite, this will remain a=
t zero and the AEAD
> fuzzing routine will still exit without performing any tests because of t=
his.
> Isn't there a better way to determine the maximum key size for AEAD ciphe=
rs?
>=20
> 3) The AEAD fuzzing vector generation generates fully random keydata that=
 is <=3D maxlen.
> However, for AEAD ciphers, the key blob is actually some RTA struct conta=
ining length
> fields and types. Which means that most of the time, it will simply be ge=
nerating illegal
> key blobs and you are merely testing whether both implementations correct=
ly flag the
> key as illegal. (for which they likely use the same crypto_authenc_extrac=
tkeys
> subroutine, so that check probably/likely always passes - and therefore i=
s not very useful)
>=20
I just confirmed the last point by adding some pr_info statements:
Even though I advertise 10 AEAD cipher suites, I have the fuzzing tests ena=
bled
with the default iter count and the fuzzing tests are actually started, NON=
E of
the generated vectors actually hits the point where an actual encryption is=
 being
performed, they ALL fail on illegal keys.
In other words: nothing relevant is tested at all by the fuzzing tests.

Actually I tried to be "smart" and loop the random key generation until a v=
alid
key was generated. Which caused some nice softlock :-)
Which is when I realized that with 8 bytes of RTA header (i.e. 2^64 combo's=
)
and only a handful of legal values thereof, the odds of hitting a legal val=
ue
are far less than winning the main price in the local lottery ;-)

=C1nd generating legal values is actually not so trivial if you don't know =
the
actual cipher and authentication key sizes supported ...

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

