Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CC1C33CA1
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 09:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 092A2217F4
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 09:22:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="BvKgxnwE";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="BvKgxnwE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgBEJWh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 04:22:37 -0500
Received: from mail-eopbgr00058.outbound.protection.outlook.com ([40.107.0.58]:55619
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728035AbgBEJWh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 04:22:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yxuuRx6VAPDpgiep9kboX9WSyIKdMk+IDcq2kLGn30A=;
 b=BvKgxnwE6TfcZckyKL43mVMlELjLC85JdNRWhtsPzsok7G0yrkfdn+OOnFtzJtWh70/7ebGEzkSDncNFSg6O2ZyaXqt7wxcp3ZyssinhODHzWnUrw2mDr49FdfMApaE70RwmboBgbTRpLP+rClibGtOE3ObO2TZnX1vdOJkvPAs=
Received: from VI1PR08CA0224.eurprd08.prod.outlook.com (2603:10a6:802:15::33)
 by DB6PR0802MB2311.eurprd08.prod.outlook.com (2603:10a6:4:87::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21; Wed, 5 Feb
 2020 09:22:32 +0000
Received: from DB5EUR03FT055.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::204) by VI1PR08CA0224.outlook.office365.com
 (2603:10a6:802:15::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend
 Transport; Wed, 5 Feb 2020 09:22:32 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT055.mail.protection.outlook.com (10.152.21.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.18 via Frontend Transport; Wed, 5 Feb 2020 09:22:32 +0000
Received: ("Tessian outbound 846b976b3941:v42"); Wed, 05 Feb 2020 09:22:31 +0000
X-CR-MTA-TID: 64aa7808
Received: from 528b6db8faf1.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2D2DEAEF-7AFF-4E22-8FD9-C067BCE1AA81.1;
        Wed, 05 Feb 2020 09:22:26 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 528b6db8faf1.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 05 Feb 2020 09:22:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqbhsXwjs6YfG+HZlErzEgmvhbXY3oj+wXIh7PAohGeAZxjhT1oemdoWH/7k+YTaPIkTNw9r30/EwG8ieVpEm3zSsz356QabxiOxG1Jr61isBoU6EvWIE8ugtobQIglWaPEpDEWdNiTxQsCBpMWZbYhLgmpAivA5UT+OuqYZ0My64KROrA/HMMdg82KNCC9NtoUL/R4H3r4PJaWR9/gzBm44I6ziVjrApm1r3bpxQOUjRrE0cWMv9v50mxaM5CGUCJ/ohMIJqvvJHVBNO3A8qjSUN6Lq2QBbwe6q1Pbgxv7I8rW7BdDOs1M65ZiRHEMNon5f5stbHB7x7i6Zf6/Xog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yxuuRx6VAPDpgiep9kboX9WSyIKdMk+IDcq2kLGn30A=;
 b=gMomP7rPEjGz0C2IgBJml8RPffqXXXhLtK6DV8+gL8oSlOyD/P8aQMzWb6SwJsnB+mKoCor2XzBGCAIvj99qiJ8Ll9tgYWB6IYvfKt0O7YUfIsL+o86yQHwE9ez/39Q2dszQp2s2snUoGdE+o3hM+moSxIgEYq/Q9wgx9jG+nDvEeHIASL6agSOq4oeOqGNWMfbIM+goW13+PPtvSjK0CwsSkMGVgQJRoZ2hnpHCuwym4bup4rgp1smY7GrhVM9uRsHPVqva+DgtiKK4WVd0rpF3S4zj1tOrw0+dKMFYuTeZ+nIIrMmNBlXGIbLqwQsdrJSTlhYHqXk1nqPzpyvu2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yxuuRx6VAPDpgiep9kboX9WSyIKdMk+IDcq2kLGn30A=;
 b=BvKgxnwE6TfcZckyKL43mVMlELjLC85JdNRWhtsPzsok7G0yrkfdn+OOnFtzJtWh70/7ebGEzkSDncNFSg6O2ZyaXqt7wxcp3ZyssinhODHzWnUrw2mDr49FdfMApaE70RwmboBgbTRpLP+rClibGtOE3ObO2TZnX1vdOJkvPAs=
Received: from AM5PR0801MB1665.eurprd08.prod.outlook.com (10.169.247.15) by
 AM5PR0801MB1651.eurprd08.prod.outlook.com (10.169.246.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Wed, 5 Feb 2020 09:22:23 +0000
Received: from AM5PR0801MB1665.eurprd08.prod.outlook.com
 ([fe80::a9de:d56:93b9:46ec]) by AM5PR0801MB1665.eurprd08.prod.outlook.com
 ([fe80::a9de:d56:93b9:46ec%6]) with mapi id 15.20.2707.020; Wed, 5 Feb 2020
 09:22:23 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v2 3/3] MAINTAINERS: add HG as cctrng maintainer
Thread-Topic: [PATCH v2 3/3] MAINTAINERS: add HG as cctrng maintainer
Thread-Index: AQHV2cyflDUjAqX7t0qCXDEExzT+K6gJQO2AgAMVRxA=
Date:   Wed, 5 Feb 2020 09:22:23 +0000
Message-ID: <AM5PR0801MB166546181D4D2EB9AE8DD26CE9020@AM5PR0801MB1665.eurprd08.prod.outlook.com>
References: <1580650021-8578-1-git-send-email-hadar.gat@arm.com>
 <1580650021-8578-4-git-send-email-hadar.gat@arm.com>
 <CAHp75Vd4VYJD9kSgMU+iKOC5FOarPtMG4eG3Jbnf7OeebWuC7w@mail.gmail.com>
In-Reply-To: <CAHp75Vd4VYJD9kSgMU+iKOC5FOarPtMG4eG3Jbnf7OeebWuC7w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: f2c14ebd-960d-4b74-9cdb-b5671e81e866.0
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [217.140.106.29]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a14400f5-fa69-40da-0095-08d7aa1cedca
X-MS-TrafficTypeDiagnostic: AM5PR0801MB1651:|AM5PR0801MB1651:|DB6PR0802MB2311:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB23119624D5E0425A51AA2AA8E9020@DB6PR0802MB2311.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 0304E36CA3
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(189003)(199004)(6916009)(7696005)(55016002)(4326008)(186003)(478600001)(9686003)(81166006)(8936002)(2906002)(8676002)(52536014)(81156014)(54906003)(5660300002)(4744005)(7416002)(76116006)(66476007)(66946007)(66556008)(66446008)(64756008)(26005)(6506007)(33656002)(966005)(53546011)(86362001)(71200400001)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0801MB1651;H:AM5PR0801MB1665.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: IRg7lA5oInwe5NmlAqkjPrloXGj6j2tCQomFWuRzP9LwYtR/5gsQfsmvvDfrBjDbBtXPlvTuc5b0fk79PeavLkkIa92pJP+4vceeqFuakPHPO1z3HAuuXjKDjlWwIzLygOGfvaWMg8y1AhDtpzvXwhXueqebnmEgQhRF+4GNn83CgU4GTcBspR5raf3uS/GQYK0Sr1yf0VLjrdiq3CLmDmdrRyMtD22GXpozU5NGnibg01nX7Z5Cc58uDMfBbbOb/JrIDw0+NsgzQoOvrrE5qsvb0VmHwOcAcriHz32Otp8k+u8jwxDiXUKB4gi2EKqoEhWD/s1kgdVGL6BZbmQm2M6vIc87uI/qGCfEKb2tHw0KdBO5JW3tgXQgNXqbGF1v34r5hS7ow+b+I9pUr6dRy/LQNsgBphtYx4vV8nHgZ5UUEnXns9sVAnGgxLDVT+YIc/0OBvxzBVcmM26vneYT8o1A21r3RXu9Ns41VvWq3ONUsFKFMNVybo+ooe9bSFWhFEvIsTAqtfJGK4xW897nLw==
x-ms-exchange-antispam-messagedata: 0H91j9gpAYfAeZ9LJeZOGZVgJcMyvufEMmOe0t08FH/GzPOVBRa4KZ2thMTgradavK91HxJnX/gGy293grBpQmQcvDuWWjvQ5ixqqjG7wdbKXgQvzP2BHfEofFJlABU+vaE854y33wZ7qXJYuqVxtA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1651
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT055.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(396003)(189003)(199004)(26826003)(8936002)(356004)(336012)(86362001)(478600001)(2906002)(966005)(52536014)(70586007)(70206006)(5660300002)(4326008)(450100002)(54906003)(8676002)(316002)(186003)(26005)(6506007)(53546011)(33656002)(9686003)(81166006)(81156014)(55016002)(7696005)(4744005)(6862004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0802MB2311;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 90edbec9-8288-42cd-6f32-08d7aa1ce8d6
X-Forefront-PRVS: 0304E36CA3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u23q3ADLv4b1395uurTe9U0gM6ri0Jwb9+2kU+hyp/F+aFRRLv7yfZcnaif86fG2tZLFaMUv0h+FHkygS9t2vXK2l45zMTOv8YplLATdg3BgMBgFBVno+QwQelhkn7C6PN1nihk4eKe8K9az1selCuJYQxIu1UPgdD2123K++JoXDDyQHSZ+jFp036lMucZbgqFe7NMn/A1i7wfqtsINeAkRPetVQxnc4FhwYiU31qu8GsGs9mBVxAMjU0sGxarhtLRfQvTOdEPKoTrD9nGHK76SJoEs+Rg9QLPXKUEMMaV4nwdJn4/DeDzx+wpBStvYa6vx4DRxiSFxLKvdzOBEeGeTzM+ZA9ADFwvQLvq5pz/A2y0LR++eg1KwG+YPhbyucf0dGY/RZcAx7FRyT0e3iQeWTljeIiXDBiJMNgVuRiHdRlfLLDEgNq4nGcDjgj88Sh7HRuPbzWOyQ1GNLoH3fd3nfUwNmwfSrt1N1hmHyj5p7z4i5UrpVhN4LYHomQrmotGIwHilg6ZWT5da7Y5yNQ==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2020 09:22:32.0588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a14400f5-fa69-40da-0095-08d7aa1cedca
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2311
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IE9uIFN1biwgRmViIDIsIDIwMjAgYXQgMzoyOSBQTSBIYWRhciBHYXQgPGhhZGFyLmdhdEBh
cm0uY29tPiB3cm90ZToNCj4gPg0KPiA+IEkgd29yayBmb3IgQXJtIG9uIG1haW50YWluaW5nIHRo
ZSBUcnVzdFpvbmUgQ3J5cHRvQ2VsbCBUUk5HIGRyaXZlci4NCj4gDQo+ID4gK0NDVFJORyBBUk0g
VFJVU1RaT05FIENSWVBUT0NFTEwgVFJVRSBSQU5ET00gTlVNQkVSDQo+IEdFTkVSQVRPUiAoVFJO
RykgRFJJVkVSDQo+ID4gK006ICAgICBIYWRhciBHYXQgPGhhZGFyLmdhdEBhcm0uY29tPg0KPiA+
ICtMOiAgICAgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiA+ICtTOiAgICAgU3VwcG9y
dGVkDQo+ID4gK0Y6ICAgICBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2NjdHJuZy5jDQo+ID4gK0Y6
ICAgICBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2NjdHJuZy5oDQo+ID4gK0Y6ICAgICBEb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mvcm5nL2FybS1jY3RybmcudHh0DQo+ID4gK1c6ICAg
ICBodHRwczovL2RldmVsb3Blci5hcm0uY29tL3Byb2R1Y3RzL3N5c3RlbS1pcC90cnVzdHpvbmUt
DQo+IGNyeXB0b2NlbGwvY3J5cHRvY2VsbC03MDAtZmFtaWx5DQo+ID4gKw0KPiANCj4gSGFkIHlv
dSBydW4gcGFyc2UtbWFpbnRhaW5lcnMucGwgYWZ0ZXJ3YXJkcyB0byBiZSBzdXJlIGV2ZXJ5dGhp
bmcgaXMgb2theT8NCg0KSSBydW4gcGFyc2UtbWFpbnRhaW5lcnMucGwgbm93IGFuZCBpdCBzZWVt
cyBldmVyeXRoaW5nIGlzIG9rYXkuDQpCdXQgdGhlIGdlbmVyYXRlZCBNQUlOVEFJTkVSUyBmaWxl
IGhhcyBtYW55IGRpZmZlcmVuY2VzIGZyb20gdGhlIG9uZSBJIGhhdmUgYWxsIG92ZXIgaXQuDQpJ
IGNvdWxkbid0IGZpbmQgYW55IGRvY3VtZW50YXRpb24gYWJvdXQgdGhpcyBzY3JpcHQgKHVuZGVy
IERvY3VtZW50YXRpb24vKS4NCkNhbiB5b3UgcG9pbnQgbWUgdG8gdGhlIGRvY3VtZW50YXRpb24g
aWYgZXhpc3RzPw0KDQo+IA0KPiAtLQ0KPiBXaXRoIEJlc3QgUmVnYXJkcywNCj4gQW5keSBTaGV2
Y2hlbmtvDQoNClRoYW5rcywNCkhhZGFyDQo=
