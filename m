Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC19C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1D3A20693
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:51:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="w32NHcWb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfG3QvS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 12:51:18 -0400
Received: from mail-eopbgr740078.outbound.protection.outlook.com ([40.107.74.78]:52544
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727778AbfG3QvS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 12:51:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8uV2UNzGPHExq+ghVLBFEq4XCs9IB20W2U+DQ1C8SS2P+x7gbHJMHKtAAF+Jfa9M04cJUCcdZMUJNuwkBP7neHBVKQQp9alhfZ0oa/ICIsoDnV0UvaOj1TKDH4VISsqRnKOC5LUjTWrehuti35ViLDWRfwk0M0QmNjompklILeKrfRXdxUIOOXxPPPphcZwsz3I8CjZLaqMtq0DsjDNhWG5nP5gjsG2/3h7WbUsBASAXAhYwGzYdDB1ZoQjPMpGO8JtRmwQi+73TuPpcO7gFebo0qXRc4fcvldHT1vStugpxihKyh9FiQ12X5U5uhay2Z8NhzU0HFSbQzkm3oqKTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3fhH7hGeJEDG5tWNqN711sVZg5suezeYeoksWfqYuM=;
 b=hFSiPu35ELO3ATi1lVdYDCo/uo8tx6K7+5Q24EZRDrRpMBasbRHUa60zvD8JeOU/yL1yIZ59s2fRwZ8kYiguUSpLhMfymbJRxO0PJQq2/CesvuHxOlYNB4AizhVmKSz/94f5kQzGYpCcGHoZSG/XZoBZRWN/eHbx3eg5SCMeslnfTmVnvfTy4F0xSnRrBiN/8pQu+bdtiLIcuqqxQLs8PQoq/rD0XggjYqRh0qheqgyJCvw6J0zjEwxIQfTQhbaWzYTulbFl8VYdyLhrxhlw8HY2THqJAq8kC5BmxQi/z6WmMAAf6Pa3rQrHBuxzaJAfGmA7XbHc1+NN8JSJ8Ox7wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3fhH7hGeJEDG5tWNqN711sVZg5suezeYeoksWfqYuM=;
 b=w32NHcWbAA63EETiGIA7EfRqiN6xKgNCS0EeB2fzEZlJRPIbHMd/Y0HBvEupP2K7yGJ85xseBEOJhqiKn1lhVq/DhQoX5QEFOSk2D5cTmDRFSlND2HTEmUViQZQRuYr1ufAIz+bDbifeaqPiSX521sdTNaV8UYpQbW5CBr3TKyE=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2351.namprd20.prod.outlook.com (20.179.145.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Tue, 30 Jul 2019 16:51:15 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 16:51:15 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Crypto API skcipher key size question
Thread-Topic: Crypto API skcipher key size question
Thread-Index: AdVG9vFLzkR+4hy6R3+i1yOzwiX+cQ==
Date:   Tue, 30 Jul 2019 16:51:15 +0000
Message-ID: <MN2PR20MB2973E98FDE7526BE53169C4DCADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d470e79e-c20d-405f-4d63-08d7150e231a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2351;
x-ms-traffictypediagnostic: MN2PR20MB2351:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB23516C8312305B6B2449F21ECADC0@MN2PR20MB2351.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(39850400004)(396003)(199004)(189003)(86362001)(5660300002)(81156014)(478600001)(66476007)(7696005)(25786009)(53936002)(52536014)(81166006)(66946007)(64756008)(66556008)(99286004)(55016002)(102836004)(476003)(66066001)(486006)(6506007)(9686003)(2501003)(76116006)(14454004)(6116002)(3846002)(256004)(71190400001)(2906002)(7736002)(186003)(316002)(33656002)(66446008)(305945005)(71200400001)(8936002)(74316002)(4744005)(26005)(110136005)(6436002)(68736007)(8676002)(15974865002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2351;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kY+iJAs21pwrYBLIM9+sDNnnvImMyk5dbOQsDCZyf0zInpV/XNbHcJj2d9KPz6YIQ7QES8U2JsXQk/q/LozaiwfG8xg2oS5vI90KsCwCeGZj5x1wLzW9mb0BZbVT23Hws09aOKpZGiZmFZs8hc9UgDvh5PNvlIMlBWZv3XX57Ri1lPjM0uUFMW5Wb+fCQLABgQuU0ms6+Ufha6AwCm6wI8YSvMPu6kNsooADdHvrIcSPDiIhClBrjJV9c+zpXwdVhUFWDJLKtdB1cmkG5fvRCoPGKYt2MRjvTnzVR1wTo6IqE+P0CCRBn6xxwtypboYXAKLqb2Ls8PJINqiLGqA6RqcChcdoDmXQXiS49jLyfKHWs6eyBs2iNXRrEjC4bNqTHb97UfvEB9m6eqUObjZbLgMqEzUpj6WaUy0pd3JvWvc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d470e79e-c20d-405f-4d63-08d7150e231a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 16:51:15.6917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2351
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Quick question about skcipher algorithms supporting only
a single keysize, i.e. having min_keysize =3D max_keysize:

Do I need to do a key size check here or does the crypto
API already ensure the key size is between min and max?
(and therefore guaranteed to be always correct here)

Just trying to avoid posting a redundant patch here :-)

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

