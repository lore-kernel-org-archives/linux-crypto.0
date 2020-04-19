Return-Path: <SRS0=r6//=6D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889B4C3A5A0
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Apr 2020 14:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EAE3214AF
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Apr 2020 14:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="Vc8GUjQa";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="Vc8GUjQa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgDSOOP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Apr 2020 10:14:15 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:63073
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725949AbgDSOOO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Apr 2020 10:14:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbFN8oBIUJQLWk7U2ZNZDKc6aBY70XiLGQ73ztltpU4=;
 b=Vc8GUjQal+T2B5cPL1wP1fsy/4YOADiHPXfE1o0NO66eZohvllnPm4bn+zi71+9ZmHxfJkuofKTR8WM9TN4OWvMe+kZlDmfDBacSARqWL1FXL3UW9ngdnPn/wLzPTjFmVZYnu7uSw/4Y9tN7e85myRH4J8/W1UZqEL82ijhpN1c=
Received: from DB6PR0202CA0024.eurprd02.prod.outlook.com (2603:10a6:4:29::34)
 by AM6PR08MB4982.eurprd08.prod.outlook.com (2603:10a6:20b:e9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Sun, 19 Apr
 2020 14:14:09 +0000
Received: from DB5EUR03FT004.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:29:cafe::d0) by DB6PR0202CA0024.outlook.office365.com
 (2603:10a6:4:29::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend
 Transport; Sun, 19 Apr 2020 14:14:09 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT004.mail.protection.outlook.com (10.152.20.128) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.15 via Frontend Transport; Sun, 19 Apr 2020 14:14:09 +0000
Received: ("Tessian outbound 43fc5cd677c4:v53"); Sun, 19 Apr 2020 14:14:09 +0000
X-CR-MTA-TID: 64aa7808
Received: from afb94f8e0742.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 3D2FB27E-B099-4947-A581-C7F3F9FDDDFA.1;
        Sun, 19 Apr 2020 14:14:04 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id afb94f8e0742.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Sun, 19 Apr 2020 14:14:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuSTAVgHFpvHsHiu70uV+2FU5gIKDuajFo/w+7mCDIXX3eRVLWZPy4UoXL221f+VVJdG6Wba0bvQlgYsmwXHwaeM9I1S5tHCuHrJvgu4eTeTGHl+jnikB5YgrHtXyz7ejmOjSeg9RHuRDPkgDz8xY7NXUGC6dWkDADuKbfkpgp8+UE8mGXpzUwvOdhAX9m/IRJuqsMyp7qSHMWlWs4F0cjA4HUSCdEv2VvJY+qZouRyT2OuPS60G1zSAehb6RA4qbn0bBn9JZFDbxuoztyeJzW70/4MiobXcz4QuWLHzZRKNa/FHohRqApZ7vfQASTYwv6VSYnk8zWtzI2pJ48rXjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbFN8oBIUJQLWk7U2ZNZDKc6aBY70XiLGQ73ztltpU4=;
 b=JnWtkB24TJtalkcdY5SZbPxvXyISaSbbaU35gUDAWp35SuYleNJnZs0mpYRwkEf3W6CNyk1gx3QPpLYwokpOaOnxfAmC7N5OiMkxkLdxNwc0cRaWrbifujuUow5LL6uNG2MuCodqoMO0R0cg/NKmUU+LaBi4HT+34MbtZY1rY69tTMWmglKPDXLTX0snhEqJSB5xUX69u9SBVMndkUcnNGzhna5BY+jVT159j2K1kY9214deSVybnzVusW3ji3ZKii5gL1Fx9xkCRnh4vz+r26LR9dR4PXY7Yl4COl4snMIwX6VI2bHieiJzhK8L4eD+L0qiHKYAEAkunKIyt9voJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbFN8oBIUJQLWk7U2ZNZDKc6aBY70XiLGQ73ztltpU4=;
 b=Vc8GUjQal+T2B5cPL1wP1fsy/4YOADiHPXfE1o0NO66eZohvllnPm4bn+zi71+9ZmHxfJkuofKTR8WM9TN4OWvMe+kZlDmfDBacSARqWL1FXL3UW9ngdnPn/wLzPTjFmVZYnu7uSw/4Y9tN7e85myRH4J8/W1UZqEL82ijhpN1c=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2421.eurprd08.prod.outlook.com (2603:10a6:4:a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Sun, 19 Apr
 2020 14:14:03 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2921.027; Sun, 19 Apr 2020
 14:14:03 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     "jagdsh.linux@gmail.com" <jagdsh.linux@gmail.com>,
        "mpm@selenic.com" <mpm@selenic.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH] drivers/char/hw_random/cctrng.c: Compilation fix.
Thread-Topic: [PATCH] drivers/char/hw_random/cctrng.c: Compilation fix.
Thread-Index: AQHWFjA4GHnBoMa400Ogq6zLhEJgsKiAe7AA
Date:   Sun, 19 Apr 2020 14:14:03 +0000
Message-ID: <DB6PR0802MB25339C3460BC71D65B4488DAE9D70@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1587289878-121900-1-git-send-email-jagdsh.linux@gmail.com>
In-Reply-To: <1587289878-121900-1-git-send-email-jagdsh.linux@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 049ca355-031b-4e3e-8227-175c8b89f751.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5dc4f8ce-a621-4e34-9f31-08d7e46bedb4
x-ms-traffictypediagnostic: DB6PR0802MB2421:|DB6PR0802MB2421:|AM6PR08MB4982:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB4982F9F1AEBA86B8C822DA7AE9D70@AM6PR08MB4982.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;OLM:7691;
x-forefront-prvs: 0378F1E47A
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(396003)(346002)(136003)(39850400004)(52536014)(186003)(7696005)(71200400001)(26005)(76116006)(33656002)(4326008)(66476007)(66446008)(6506007)(66946007)(64756008)(55016002)(86362001)(5660300002)(9686003)(8936002)(66556008)(2906002)(8676002)(54906003)(316002)(478600001)(81156014)(110136005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 0Kcs4NCfeUK7wI2/CBqeFSbEatkwWO1O/OUcNnAJw1OfHRVO4g/SZEKBedPWsW2n34Mp+WBvuN9Qnq1L8lCjxLesqG/D4ASVVxEI4HKE2YCHm71V9HOlIla6mqMr+bsSyXDUDIxWvHPsf2PcgYvffdTop6SrZPMW35qXDzpLoBOS9Y25iRlaTeDpWtk84WNAHGKEfNMNOD7PNULTE+PB9/ffzU4JXrD+ApQXB43zQhKrp7l4b+GK328XWY+PhACdRYMXhAXQzu2m4C0vc1RL4wRh9cp3RvZEwvfAUKcANWsgOigu1MO6hQ2tRsRTHXUpaEx6dgtWUJTATRM1I8VqzsU48bm8FR1trRaXHF7IknG8uhMVZ2qCjk0oYkmwz7x7tlW9UDq4dqVc7LTFQVnjGQEM/5/0qm1lWqUnDg4wOvnGm9V7lwBl0Pbp748PwYEO
x-ms-exchange-antispam-messagedata: oqrWWo4RnMZJsFPDxcporRJZ9ZXUF9siIeHxGFxoLX0eFVzcpFjTxBrP9ywbuIlc5/J7sWzFx2t3LWez1u7YaOnysrKwQPot0rxOgSv03ewYt7ydwoc+6kqre0yKQm4asO/Ibz7NEuqhsg1YpbyO+A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2421
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT004.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(39850400004)(376002)(136003)(396003)(46966005)(86362001)(450100002)(5660300002)(316002)(82740400003)(47076004)(6506007)(7696005)(26005)(54906003)(70586007)(52536014)(2906002)(110136005)(70206006)(9686003)(33656002)(55016002)(81156014)(81166007)(356005)(4326008)(478600001)(8936002)(336012)(186003)(8676002);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 092df8c8-4654-4158-a516-08d7e46bea1c
X-Forefront-PRVS: 0378F1E47A
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rgMoaNzCxyZIef1Ud7go4B0w7fkpb+/98iHUWOPUoKKjMMfK3Vw+KCxMezBDXPtryjlpUfGFr2TTO7uebQs3ufKy3ZrIo4UH4S1nxPITxo0pPc9i62hmCDBgZ4lB3FXurpByngy4ZBiJtxLOLOjwceVdFEB3lH4W36t7T5AQ/O59J/GYmQKJ/5ujNMbSoablnc6OeXGHO0f71UC+KhEyOPN15LC1aE1JKxR5MPgxFbv4d/wdtfKx9GeJ9ZP0EFQMObKzQDsNTWAkcRbh53Emkq5moMrAvLZYYEK2d0MLlxV9KXblc0irZrJHLQnO+TFzlsjl9asBjmxjbbjb8ASU8pxh+GMlQc6A0WSO68kySnLsaY7Sn0LvENbfKMyLbZ6lOmv6urzgtms4ppPCzo9ZLHK1eofKgGbZO6mXRnxqsKe54E5ljioD808htB8UuWR0xjUzFsXjRSk8U19P7nsys3FS1URW8UucXKFhWQeey4EbQE3hKxjDIJmQh5jT2ZDKIB14MMSLhbUqqZNfEQHK7A==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2020 14:14:09.6805
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc4f8ce-a621-4e34-9f31-08d7e46bedb4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4982
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IEZyb206IEphZ2FkZWVzaCBQYWdhZGFsYSA8amFnZHNoLmxpbnV4QGdtYWlsLmNvbT4NCj4g
DQo+IEFkZGluZyB0aGUgbmVlZGVkIGhlYWRlciA8bGludXgvZmlwcy5oPiB0byBmaXggZm9sbG93
aW5nIGNvbXBpbGF0aW9uIGVycm9yLg0KPiANCj4gCUNDICAgICAgZHJpdmVycy9jaGFyL2h3X3Jh
bmRvbS9jY3Rybmcubw0KPiAJZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9jY3RybmcuYzogSW4gZnVu
Y3Rpb24NCj4g4oCYY2NfdHJuZ19jb21wd29ya19oYW5kbGVy4oCZOg0KPiAJZHJpdmVycy9jaGFy
L2h3X3JhbmRvbS9jY3RybmcuYzozMzQ6NDk6IGVycm9yOiDigJhmaXBzX2VuYWJsZWTigJkNCj4g
dW5kZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pDQo+IAkgIGlmIChDQ19SRUdf
RkxEX0dFVChSTkdfSVNSLCBDUk5HVF9FUlIsIGlzcikgJiYgZmlwc19lbmFibGVkKSB7DQo+IAkJ
CQkJCQkgXg0KPiAJZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9jY3RybmcuYzozMzQ6NDk6IG5vdGU6
IGVhY2ggdW5kZWNsYXJlZA0KPiBpZGVudGlmaWVyIGlzIHJlcG9ydGVkIG9ubHkgb25jZSBmb3Ig
ZWFjaCBmdW5jdGlvbiBpdCBhcHBlYXJzIGluDQo+IAlkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2Nj
dHJuZy5jOjMzNTozOiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YNCj4gZnVuY3Rpb24g
4oCYZmlwc19mYWlsX25vdGlmeeKAmSBbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJh
dGlvbl0NCj4gCSAgIGZpcHNfZmFpbF9ub3RpZnkoKTsNCj4gCSAgIF4NCj4gCWNjMTogc29tZSB3
YXJuaW5ncyBiZWluZyB0cmVhdGVkIGFzIGVycm9ycw0KPiAJbWFrZVs0XTogKioqIFtkcml2ZXJz
L2NoYXIvaHdfcmFuZG9tL2NjdHJuZy5vXSBFcnJvciAxDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBK
YWdhZGVlc2ggUGFnYWRhbGEgPGphZ2RzaC5saW51eEBnbWFpbC5jb20+DQo+IC0tLQ0KPiAgZHJp
dmVycy9jaGFyL2h3X3JhbmRvbS9jY3RybmcuYyB8IDQgKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci9od19yYW5k
b20vY2N0cm5nLmMNCj4gYi9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2NjdHJuZy5jIGluZGV4IGJk
Y2Q1NjIuLjMxMjQyNjkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY2hhci9od19yYW5kb20vY2N0
cm5nLmMNCj4gKysrIGIvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9jY3RybmcuYw0KPiBAQCAtMTgs
NiArMTgsMTAgQEANCj4gDQo+ICAjaW5jbHVkZSAiY2N0cm5nLmgiDQo+IA0KPiArI2lmZGVmIENP
TkZJR19DUllQVE9fRklQUw0KPiArI2luY2x1ZGUgPGxpbnV4L2ZpcHMuaD4NCj4gKyNlbmRpZg0K
PiArDQo+ICAjZGVmaW5lIENDX1JFR19MT1cobmFtZSkgIChuYW1lICMjIF9CSVRfU0hJRlQpICAj
ZGVmaW5lDQo+IENDX1JFR19ISUdIKG5hbWUpIChDQ19SRUdfTE9XKG5hbWUpICsgbmFtZSAjIyBf
QklUX1NJWkUgLSAxKQ0KPiAjZGVmaW5lIENDX0dFTk1BU0sobmFtZSkgIEdFTk1BU0soQ0NfUkVH
X0hJR0gobmFtZSksDQo+IENDX1JFR19MT1cobmFtZSkpDQo+IC0tDQo+IDEuOC4zLjENCg0KSGkg
SmFnYWRlZXNoLA0KVGhhbmtzIGZvciB5b3VyIGZpeCBidXQgdGhpcyBjb21waWxhdGlvbiBpc3N1
ZSBpcyBhbHJlYWR5IGZpeGVkLg0KSXQgd2FzIHB1c2hlZCBmZXcgZGF5cyBhZ28gYW5kIGlzIHdh
aXRpbmcgdG8gYmUgYXBwbGllZC4NCkJSLA0KSGFkYXINCg0K
