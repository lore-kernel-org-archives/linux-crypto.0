Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2ECEC5B578
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 21:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B53021871
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 21:50:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="CoBVe9b5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfGCVuu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 17:50:50 -0400
Received: from mail-eopbgr760083.outbound.protection.outlook.com ([40.107.76.83]:9661
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726550AbfGCVuu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 17:50:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNh8CoCSzQPSn2C0/aXml2NtkxYgAdiwr+Dgbc9K3Lw=;
 b=CoBVe9b5m1wL0TW56/LqxQ3ahFcC8baKAgNoC1CN/KqnDcEEX3FoE1MfpEsvmzeCtg5j5FiMIP/y1qAJNBMLXrNUQxnPNBdM0KHsPQDfnX9S1L2EWM+Y0lo3z73Z73HcbBAIKejvd4WkG19hqQx968OQNrH3nhG7kyGl9NQb8lg=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2959.namprd20.prod.outlook.com (52.132.172.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 21:50:46 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 21:50:46 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: testmgr question
Thread-Topic: testmgr question
Thread-Index: AdUx6JvA0/qKH73vRlimi9Aq3V9Bnw==
Date:   Wed, 3 Jul 2019 21:50:46 +0000
Message-ID: <MN2PR20MB29739BA802F0A8ECA7E96B8BCAFB0@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4310ab8e-ad10-497f-c8b1-08d700008168
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2959;
x-ms-traffictypediagnostic: MN2PR20MB2959:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2959BF71C25F63D1F1F73F46CAFB0@MN2PR20MB2959.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(366004)(376002)(136003)(396003)(346002)(189003)(199004)(81166006)(74316002)(6916009)(8676002)(64756008)(3480700005)(52536014)(81156014)(6506007)(73956011)(2906002)(5640700003)(66066001)(86362001)(7736002)(66946007)(76116006)(2351001)(3846002)(102836004)(6116002)(478600001)(66556008)(66476007)(6436002)(221733001)(8936002)(66446008)(9686003)(71190400001)(5660300002)(25786009)(7116003)(15974865002)(55016002)(7696005)(476003)(4744005)(316002)(68736007)(71200400001)(486006)(33656002)(14454004)(26005)(186003)(2501003)(99286004)(256004)(53936002)(305945005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2959;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2WzccX0trho78qHDy6Cburkz19vOTbe7nTR9lD1P7mqG/Vpxo+xGxQn9E1ve8GyullKo7SRrx9f2hB5H7JmHqcmdTkavdL8zrTijvKvkP4BVurLFQ1roru+qYxM7aowVMEdI09XRho78/v3e0gIfF2XJRXRO6/jb2whus1oP6HuLiSmWDDBePgoS1FwrWYkgq1Kf/Lv4GQMc4oknsK3HF1ksbjt6VIY9JBueq8zhQB5UMn/rM5DnPr/oX3UIqyjuNgASxnmnV9KVa5rxKanLi9iCAk28P4EMaiGGuZie7PkK7td4rfRWGQtiFkri4hcg9nUXjGgQQMZayBUS2ezlIelwV8xjSxGs/fOY48sRL/wOWPelZ4LNZiwcC6BaJfAiCEgqi7AWDPNnenSUEatEIWUHl20uWkLWtL+nHIDkYZ8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4310ab8e-ad10-497f-c8b1-08d700008168
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 21:50:46.5633
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

Hi,

I'm currently busy adding support for some AES-CTR based authenticated encr=
yption suites to the
inside-secure driver, and I got the distinct impression they were silently =
not getting tested at all.

Looking at testmgr.c, I noticed that they point to alg_test_null, confirmin=
g my suspicion.
I was wondering whether this was intentional and, if so, why that is the ca=
se?

I get that there are no reference vectors for these ciphersuites yet, but t=
hat shouldn't stop
testmgr from at least fuzzing the ciphersuite against the reference impleme=
ntation?

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

