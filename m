Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF1CC76188
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 10:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DE2521897
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 10:27:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="cCJowD9j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbfGVK10 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 06:27:26 -0400
Received: from mail-eopbgr720078.outbound.protection.outlook.com ([40.107.72.78]:19769
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726846AbfGVK10 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 06:27:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnabcMiR1Zv6qq9rVdyUstJIOgMA3Pls5svxRl3nO8cKPOGzKUzOwfQVGiXMDnj4jn+H2Ztr/+gIFSS5ooOL3+yDUYkGXtE1e3W1ZlhAJnrFrLl2klnVgCEL+B18LZ29Xsj22RxMXqhxXcOXXyhrp5YINYZJ+NifUYCjGcyBxvBuRzvpGt3ZaH+pSmW65pX+K3nit0VCdgMq8wyIaBCWetAKolkAnV70RClQrWYcjp+LpFC+jdyZh/dx+TI68mlM2uewfykYk+pHBjB3CNEP0oBD0gXwBtyj+Bm9N6dS+S+49SyqkFb4lKfNGjy1P9ZPG9uyjDz0bXXLnjsV4jIfZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrzIQqFwwvtmiHYKMO0hL/p1ROzX/4fe60hrR+y4YjM=;
 b=Pgc4dddsJQsALp4daVpMIbX/RhP2qci51urD7pzed3A36egcWhY8Dlw2ANKWwuw7c5CyK8rOb5X6q5FT5j/CRIcy4+zF/X5Dpebr0sSSxnbK6OHhlWOuChGqLrlGsmYuSYaoD8G3A8Jio69q/o+tT2jzAE+vYT0xUj4BCJbDfBqukijO2xqehUYmNuWjlpGMP9saK1fpQdWZns9SaYchWXfcdoNE9DIoT4nwReN52pgdybAWol4bD/xmX2KjwMx1cAQ/mm0nFRnDpr9KXBuEZPTr2OvVxt/iSAUZdQlE1A/GOd1BIxfT91STyVxbGyxig1KeFqYAfyXMouZSgOlmHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrzIQqFwwvtmiHYKMO0hL/p1ROzX/4fe60hrR+y4YjM=;
 b=cCJowD9j5kpLyhKD9JI8eobYm9AMYuTed75N/hIisPvvoUP39gYQARbw3bobsLW4nEdZDoXjbQ+3HnNCa0bfL7cRPFxx3RznPUgvkltDrmFaFTnRiP5DsDN5UyezCkWXy9WNn7UHtM+IaZAa7rrcYsM5ZIbbareuhjO0PDG7fGY=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2302.namprd20.prod.outlook.com (20.179.145.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 10:27:22 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Mon, 22 Jul 2019
 10:27:22 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Testmgr fuzz testing
Thread-Topic: Testmgr fuzz testing
Thread-Index: AdVAdUj98zKx4A/DSr+aRU+NlJJ9GQ==
Date:   Mon, 22 Jul 2019 10:27:22 +0000
Message-ID: <MN2PR20MB2973F2047FCE9EA5794E7DF7CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c22119d-0658-45c1-27f7-08d70e8f2f08
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2302;
x-ms-traffictypediagnostic: MN2PR20MB2302:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2302793B182D8FFA368E7AEFCAC40@MN2PR20MB2302.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(346002)(366004)(136003)(376002)(199004)(189003)(256004)(71190400001)(7736002)(71200400001)(14444005)(6116002)(2351001)(14454004)(3846002)(2906002)(66066001)(74316002)(7116003)(54906003)(4326008)(6916009)(305945005)(68736007)(2501003)(33656002)(99286004)(486006)(478600001)(15974865002)(8676002)(25786009)(3480700005)(55016002)(8936002)(7696005)(5640700003)(102836004)(86362001)(81166006)(6436002)(6506007)(476003)(9686003)(81156014)(76116006)(5660300002)(26005)(66556008)(52536014)(66446008)(66946007)(64756008)(186003)(316002)(66476007)(53936002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2302;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5lA0Io+pVm/DQATsKSYMGVEZOcRhnGLlaYaKAV8r4zTe1Z+sW0GnhzPn/Scr4WKkZk0gOIW9htlMVy7Sv3LhoCT0zz7kijD4JBt14msnXTXIrIhFVN5tJdQqhmLIf6w4/aztq5hJNKkgVjjMNkg9gm5lmZpNZ0PBHxm1wduIpRT6bPer7J5sPDcXhSb2kc9P4kztqMyN0HCYTHiNVd9J533h9S/WvwF0Nvfm3wrOdOvIO5Nutba9z+eDphjZMTMu4gqqOIi4WdfkygeqB2BbCh90vg2zaf/q0HCumUzz+tYBfZbLVSlGzHHmUX0ic8GSn7RVUbKBcIr3S9sxQmiF7jfDDdFs9kdHdrLDQqcTLBY/cDvRtMpu4S1rc8AEGYg0ymdpF3DMYklDAAPC4o0lodrHUGsxZZBSGNOpSWAFHW4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c22119d-0658-45c1-27f7-08d70e8f2f08
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 10:27:22.7021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2302
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric,

While fixing some issues in the inside-secure driver reported by the fuzz, =
I noticed that the
results are actually not repeatable: odds are  high that on the next run, t=
he error case is=20
actually not hit anymore since they're typically very specific  corner case=
s.

There's 2 problems with that:
a) Without repeatability, I cannot verify whether my fix actually worked. I=
n fact, I cannot
even verify with any certainty that any modification I do won't fail somewh=
ere else :-(
b) Odds are very significant that important corner cases are not hit by the=
 fuzzing

Issue a) is usually solved by making the random generation deterministic, i=
.e. ensure
you seed it with a known constant and pull the random numbers strictly sequ=
entially.
(you may or may not add the *option* to  pull the seed from some true rando=
m source)

Issue b) would be best solved by splitting the fuzz testing into two parts,=
 a (properly
constrained!) random part and a part with fixed known corner cases where yo=
u use
constant parameters (like lengths and such) but depend on the generic imple=
mentation
for the actual vector generation (as specifications usually don't provide v=
ectors for
all interesting corner cases but we consider the generic implementation to =
be correct)=20

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

