Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11296C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 23:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C71A521849
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 23:25:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="KFhaursU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732211AbfGSXZe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 19:25:34 -0400
Received: from mail-eopbgr810072.outbound.protection.outlook.com ([40.107.81.72]:51866
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728909AbfGSXZe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 19:25:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S54gLT0ZA6VC04UrcbQ0bcRcB1l4ojrmG+19XQOX0Rqi1wKJDqRQy+hpNrMY4RPrDQF3qNRqsf7NYA3bUKCnuE61pYAgHWP5JoL0233/XIwt8XmqIjU8X26NWYvLIxoTnW+d2fp/kJTJVOufgEZkx7d28nE/K2LQdN5Uuf1Pk0J+rsBqZODo47srn5rOzehglSS3lWVYLDQ+7VGKJnR3xe9K0tlJXdaTvLHawFcohToXyb3OgM5TfwaT0kxXxyb1Ms1CNc/ofQLJ3/pV+6Dj5/bz3gb8Kv44O7Zj+N7djcClDrXh4ZVNeY2kiGT7m5olfmhF4V3aI0lN3gCfqddjMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6PAkVwDw6BLYvQ1xyXMXCqEAIRPMNtmz8QAhvtU8wE=;
 b=Ze9nPSJJcF6XzVPajBx7XOZ8Kqpwk9pNiFG6qTCNOtpj9YYem0xXlc2dbY4apsblws/QmyegqeN5N71awFcCRJocafkn/WqbGSiQbBWd16Ylid0CFKQrDK1+sJ5hZIdMihRrFvki6ZeLK1fvr6rMFjRwyz5BRpwZaxxWY0E62XaoFTy6p9XiHbc9BLDT+3S/gK4ozT3LuyBug3SFD4ln8mONyf3WnX+uCPmFM6MvE5AyCtQ1tWY8D+Bvl3tFAuIImtbdM1h9ponwcTdglWv8+WZOp7qn9JI8L4hPxJFqJlsJ+Gde3DPHg6hk8MbbsXGWnMUsplx00WT2sQY50y2+tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6PAkVwDw6BLYvQ1xyXMXCqEAIRPMNtmz8QAhvtU8wE=;
 b=KFhaursU8fHsuQ0h2Eq/VJlL174oIg/mVLh/6c0PEnwNiSDhjWMKCRqOmTpMSXBHlqZkL06wMloUwXr6PX+fTz9T9Db9z0eQQpgZtwaNE0nPbV0njrrogMIdAT8ZE3SwgxYVyZrzFG3QGYqjgk5sXcOkgbRuXAiL9qbvCxtyyzs=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2589.namprd20.prod.outlook.com (20.178.251.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Fri, 19 Jul 2019 23:25:31 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.013; Fri, 19 Jul 2019
 23:25:31 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: ghash
Thread-Topic: ghash
Thread-Index: AdU+OcccbSpphUQDQMqR1uphPmes/wAE33+AAAYsZgAAAYlpgAAAwhCgAAMhLwAAAaNSAAABVAaA
Date:   Fri, 19 Jul 2019 23:25:31 +0000
Message-ID: <MN2PR20MB297363B1B642361BBBBF28FACACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB29737F1F60B3CBACBC4BD287CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719161606.GA1422@gmail.com>
 <MN2PR20MB297309BE544695C1B7B3CB21CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719195652.GC1422@gmail.com>
 <MN2PR20MB2973FF077218AB3C2DF2E4A0CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719214811.GE1422@gmail.com> <20190719223505.GF1422@gmail.com>
In-Reply-To: <20190719223505.GF1422@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6e0cc07-9a38-4e8a-1f18-08d70ca06479
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2589;
x-ms-traffictypediagnostic: MN2PR20MB2589:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2589D5FDDACA74AF64A62161CACB0@MN2PR20MB2589.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(136003)(376002)(366004)(39850400004)(346002)(199004)(189003)(81166006)(81156014)(99286004)(8936002)(221733001)(66066001)(68736007)(64756008)(316002)(110136005)(66446008)(76176011)(3480700005)(102836004)(6506007)(3846002)(6116002)(2501003)(7696005)(2906002)(15974865002)(86362001)(71190400001)(486006)(256004)(14444005)(6436002)(55016002)(9686003)(7116003)(229853002)(305945005)(74316002)(7736002)(33656002)(8676002)(6246003)(53936002)(25786009)(478600001)(476003)(52536014)(76116006)(66946007)(66556008)(66476007)(26005)(14454004)(11346002)(186003)(446003)(71200400001)(5660300002)(18886075002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2589;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aaKg+4PgBcNpcCW+8R4m8uftnnC49fQ056jDGtomvMFhML+4+WI7GXGDuUDLOZPpV/P3Sr3GVTJzGyNe7sP/Aif2m1xLCN8Ig9V8HeZP9vLW+HfJMdC8eQnWEs5Y7usPsmMUlvK1NroJ5H9iNkoa5UdBGvA1ln9SaWgONmQDczzL7oUo9HiYCp/HLtiMSrUpDCDBSaBvn/6y4ODEA8xFeOJo4QUGU3i49jJsWPPxxSHU+k4/JD91A+lozyCwiMFQjk6MSlVfnGj5sVaPcRaPSWbQmH41m8FY2qvqQkyG104qlVw9PL8582Fv5csjURfiFWVRHDC3PkPzKkiIc4zQLaDEkQl3oeBXZRFCrBaodTT/k+EHPQTt9rC7tO/Rn9BDLz+9lXsFOo0jQ4COpSR0SlW1vk23sUhWN2a7Pg5Qs1g=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e0cc07-9a38-4e8a-1f18-08d70ca06479
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 23:25:31.4475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2589
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>=20
> Hmm, NIST SP 800-38D actually defines GHASH to take one argument, same as=
 the
> Linux version.  So even outside Linux, there is no consensus on whether "=
GHASH"
> refers to the one argument or two argument versions.
>=20
Funny, I just stumbled upon that 2007 NIST specification myself minutes ago=
, before I
saw this mail. So yes, it looks like they redefined GHASH from the original=
 2005=20
McGrew/Viega definition there, although I don't have a clue as to why ...
Must've been after our initial hardware implementation though, since all of=
 our=20
hardware strictly implements it according to the original McGrew/Viega defi=
nition
(which is also still surviving on Wikipedia)

> I.e. even if we had an API where the AAD and ciphertext were passed in
> separately, which is apparently what you'd prefer, people would complain =
that it
> doesn't match the NIST standard version.
>=20
Prefer is a big word ... it's just that our hardware cannot do unformatted =
GHASH
that way as that was not the specification at the time we implemented it.
And that redefinition went totally unnoticed.

> Of course, in the end the actually important thing is that everyone agree=
s on
> GCM, not that they agree on GHASH.
>=20
As long as GHASH is not being used for much else, probably. And in either c=
ase,
the crypto API implementation is flexible as it just pushes all the formatt=
ing out.
Our hardware, on the other hand :-(

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
