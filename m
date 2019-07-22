Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB51BC76188
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 12:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A732D2084D
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 12:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="d8jqprcM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbfGVMzp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 08:55:45 -0400
Received: from mail-eopbgr780079.outbound.protection.outlook.com ([40.107.78.79]:29224
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727164AbfGVMzp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 08:55:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l83oh4kHUGCbJtuYfK1xlsmoyKs6a2Okz6dO8GoxG4VD4w3XoLzJBDZiUAwhhFQi9DVDlu7uqG7M829zHI+2jGdblNozCBJghqqYdLxN7/f8yd4gOYmA2P4qKMNkJBljUcv5YsT7zqItExH9aU4vBCxBUtzM2+VeV9+UM74u+Sz0N175MPxvOzx6er/YUIiYuMX4QcnKQmySiivNhzJJhPRuf2K/8oP4wtgeQAhKXuKYXsSRvGiwZNSj9mIvoFGLRTcBpWMfCm2kqJulXfaVqyudjfaUSRVWGPkYzovYx8wXDXjEf4xzDoh5u3zLnUyXEhKusG5/xiV3iKwyX3coEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmTj5bQmYBy37LeT4EIRyflZmSaKN+lpoiXzjPuzXx8=;
 b=ObCxAd1lZMeOgNFiFWqcEUB5J+uS/jnWpqeYXa5kucH/KmickOAiUORW7BuPRcJZkklaONuAphcDBS76K0Z+q/5kvgSH8EMV2Ix1fog22Y/wGMs/FSWkdd3lwkzTzjletsem4J1JMUne5twMi1N/ZAvDwPvaISe9u3X8vEbTVT3AB/yM7MWmEgKJvE5ZTnEgL5G3y6el18Q9KElHjZMTstevTEsTWUhXM34p2/CeD+KS/7tdWxZy24+Pa4Y82lzmVPw4h59a5HDTkoC2sMIyiULxoPqgjVicmLJfinko+sPXIrurll7jgE0XcmW+jW2007tUojecqGZn5gA5aHC33A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmTj5bQmYBy37LeT4EIRyflZmSaKN+lpoiXzjPuzXx8=;
 b=d8jqprcM9uMiL3jbgI8vWY6INUec3B2uNww+jKKg4mlRndlC6/VJWye4OOFbdHR3ynl/vYly4fEin8u/4O0wUtfD0Zno6swSnCj115ieMetvJOEDUDMnmwwuS92CcHyIMRl0L90D4LZHYb3t4IlWHL+SIIyUDNgc6aaKCrHbdI8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2861.namprd20.prod.outlook.com (20.178.252.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 12:55:39 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Mon, 22 Jul 2019
 12:55:39 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: AEAD question
Thread-Topic: AEAD question
Thread-Index: AdVAg8AmA/XQEiKgTqyXrFAlioQdkw==
Date:   Mon, 22 Jul 2019 12:55:39 +0000
Message-ID: <MN2PR20MB29734143B4A5F5E418D55001CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b071073-64f5-45e6-2689-08d70ea3e5e5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2861;
x-ms-traffictypediagnostic: MN2PR20MB2861:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2861EE3A7EF77A2E5C0F26CFCAC40@MN2PR20MB2861.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(6916009)(102836004)(6506007)(53936002)(33656002)(186003)(74316002)(52536014)(5660300002)(476003)(7696005)(6436002)(2906002)(5640700003)(26005)(9686003)(55016002)(3846002)(7736002)(6116002)(305945005)(68736007)(8676002)(71200400001)(71190400001)(2501003)(2351001)(3480700005)(4744005)(8936002)(221733001)(66066001)(66476007)(66946007)(66446008)(64756008)(15974865002)(66556008)(76116006)(81156014)(81166006)(14454004)(99286004)(256004)(54906003)(316002)(486006)(86362001)(25786009)(4326008)(7116003)(478600001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2861;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /iR9iKgTJfsiusNeNXNIsSr7+vkTfMox+NOdvhEjRzx0ZS8oPq59EOuBEgTlYj+HrZlBR9whoB0ZstznAJSX9CI4EW5f8SKekO02Fvmp1GcxSjCP7wTYBs1TCuNmtFSAweW2SCg34vYNvSfmvUF9G7koCGVzdp1CqkYJPf2JYEJbhQLdWGcUOhxm2Ceb84Po2ocdB+NmwBkXffSDIpnjsfLZ8bHC0tE6tPNZfsB3s4FV74w3KghD37IzuKR7yZ6xpS2v2RILZi038HR51K41c0HC6CMAD+NcenpmZS5/IV23CW75HAW1mJnWTFnl4m4Rw2dR/Xm9cstHX1kWKbzoM1Tw4Kgze/Mu1WexL/LjWgirB5G7yqg2T68SXLtmsoA//akqpVUp79SO7Xtu36nBGh7EkxSwsAYYJLfbZtORG6M=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b071073-64f5-45e6-2689-08d70ea3e5e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 12:55:39.1355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2861
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric & Herbert,

I noticed the testmgr fuzz tester generating (occasionally, see previous ma=
il) tests cases with=20
authsize=3D0 for the AEAD ciphers. I'm wondering if that is intentional. Or=
 actually, I'm wondering
whether that should be considered a legal case.
To me, it doesn't seem to make a whole lot of sense to do *authenticated* e=
ncryption and then
effectively throw away the authentication result ... (it's just a waste of =
power and/or cycles)

The reason for this question is that supporting this requires some specific=
 workaround in my=20
driver (yet again). And yes, I'm aware of the fact that I can advertise I d=
on't support zero length
authentication tags, but then probably/likely testmgr will punish me for th=
at instead.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

