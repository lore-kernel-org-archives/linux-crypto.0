Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3947C76188
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 14:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A05BD2085A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 14:41:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="ThhmxY5/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfGSOlJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 10:41:09 -0400
Received: from mail-eopbgr750049.outbound.protection.outlook.com ([40.107.75.49]:24134
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727344AbfGSOlJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 10:41:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=byk417UmrKcDgKtMFltKFOgD11h5Diw1u/+q2Q/XEe5CT3mIZRYcUBgdUgmQYETichpujHejtG7lYCLlbRaJO/S3b/tVXtOCRg8wgm6SOybG07Kcrxzr2OYxjT/0MEBZO7f5eUfDwN7ZHaWqlyJ+17UMfroM7leiypdisASEmYaONszbVtdqj3vtH9kmQSOUaD8OmEdNrT1K2gcI/qIkyyjKA+s5hiuJr9jrPtSZw8tajmS4s2nJKYq3Og17HlH79cq968JcmwGHA47GnNlu8XGt1JlyiMljckpEu853xRuPTmlNOq2WUiqgBkACZ2kxlGXs/NCkEw1B+LuA7ibgYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/82CwSlCGLJ0qIR6NiwripCgPokvEOlGaG267JD/dps=;
 b=DEdBV9PDhhs6Lcc8ukbrmWqaXTjX/v8wBACPbi5Q11XtPR5MtRkaFaEtvwPCIRdCWxsARycnNQoVbbjYFOiIP4U4I00iL3Hsn2YmoNycMQf30dPGw7NfS2wlqKcQXu8RWpb001beBlX7THFBT+xsjD3IXhU7y0wZLK8iC0mBaHJzIDePp/JVS9N5qxHtxGh3iVwDmTAWTShyuap/ARuUDoE+L7Thgo4UPKaCnp9KTkw3ERQp1Awc+7JmSOKs9Q0pjNiiEizcJBUbhrRTu/OTR1ABvPLEx/oMcyfAtzBP5ZqJtKWfQDXLSihxe9+IpEO91dPJaRLSvZ3J66lZ7STqfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/82CwSlCGLJ0qIR6NiwripCgPokvEOlGaG267JD/dps=;
 b=ThhmxY5/3v6cmL3ZxirNv88gaaQGpStwZuBPvb3RrxExJrsSj1He+3L0Tn1Fi1CVefFhhiwKJt1R/BhZUEXTsSeiQNhvjol7rYE7L5KH7jWDsK7Li2/6hCe2C0aL0g5/6hOlB/Dqz6nde2LB4bUASAAAYh+yx2tBJARiQueiRfs=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2239.namprd20.prod.outlook.com (20.179.147.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 14:41:03 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.013; Fri, 19 Jul 2019
 14:41:03 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: generic ahash question
Thread-Topic: generic ahash question
Thread-Index: AdU+Pz/3ICV8h5GxTo+QH6d8mlFU5Q==
Date:   Fri, 19 Jul 2019 14:41:03 +0000
Message-ID: <MN2PR20MB297347B80C7E3DCD19127B05CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 373499e5-84c8-456f-9f88-08d70c571fd8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2239;
x-ms-traffictypediagnostic: MN2PR20MB2239:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2239F6069C01E9A0F14CBA67CACB0@MN2PR20MB2239.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(136003)(376002)(366004)(396003)(346002)(189003)(199004)(478600001)(14454004)(7696005)(66946007)(305945005)(66476007)(66556008)(99286004)(476003)(5660300002)(25786009)(76116006)(14444005)(256004)(2501003)(7736002)(3480700005)(102836004)(33656002)(81156014)(74316002)(8936002)(186003)(6916009)(26005)(81166006)(64756008)(66066001)(486006)(4326008)(4744005)(6506007)(52536014)(66446008)(86362001)(9686003)(15974865002)(6436002)(5640700003)(6116002)(316002)(8676002)(2351001)(3846002)(68736007)(53936002)(2906002)(54906003)(71200400001)(71190400001)(7116003)(55016002)(41533002)(133083001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2239;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kfS52IN0GOifJsvvFgWP70aK52rxHZ0xrMQoj77ghL0BHvMlv1QQPHJuLRmjjRRQfa/zQF0SBh6IHRUbusSzHt+oqsvlkeafdUEnebwEQP6VjMcfrDoFZ5zeS2f/bSMw8YO+iWf/ktJzCtMRjpAPYn5SE4hf7WV9OJdrHh56I1QMoeivjPol8Lmi43GBWfU+aMfiL9Y7hhfy1W1Yz9C9OkVsNq2hnCa6Uc8SwQz5CpnosYABU549VfyY2EpepNBlya/0EWxSXWKBqkgHriHeoY2VET97WF0AJ342ebVJylgGBesZFp4/Rx5UAMa/uxQCU5aNQKSqJddDIqve5RulE2QbtXPQdwm4xYD7fjP2prQIeVVLvQHwcMoj4SZhnfPD8JfZW8iyRfs0Xb2svZ9qYeybA5+JzEfNQ++ZYPKm73s=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 373499e5-84c8-456f-9f88-08d70c571fd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 14:41:03.0134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2239
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I recall reading somewhere in the Linux Crypto documentation that support f=
or finup() and digest()
calls were explicitly added to support hardware that couldn't handle sepera=
te init/update/final
calls so they could at least be used with e.g. the IPsec stack.  I also not=
iced that testmgr *does*
 attempt to verify these seperate calls ...

So I'm guessing there must be some flags that I can set to indicate I'm not=
 supporting seperate
init/update/final calls so that testmgr skips those specific tests? Which f=
lag(s) do I need to set?

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

