Return-Path: <SRS0=sRio=6G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62086C5518A
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 10:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3339520656
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 10:37:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="FH/gP0kD";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="FH/gP0kD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbgDVKhl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:37:41 -0400
Received: from mail-db8eur05on2048.outbound.protection.outlook.com ([40.107.20.48]:6046
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731407AbgDVKhj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Apr 2020 06:37:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GhTnVoSdfWnzJOWfX2LANJpfpVFruZgqZMi2/7DKYg=;
 b=FH/gP0kDHpA7+jFsn3YPn9pAgdASHqj33+O9G02wuGrUsivmIGcZUXldFHURYIm919H37jE9V3VqeC9PJ+j6vJXKJwGUvYK9jJGpMaVAQR6R9JCJycEFDuI3Um1Y0cNw+sgdJ8fUUuZkYNfVUia9N1sLB3Gl7ttmAVewtbXKECE=
Received: from AM6P194CA0015.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::28)
 by AM6PR08MB3863.eurprd08.prod.outlook.com (2603:10a6:20b:8b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Wed, 22 Apr
 2020 10:37:34 +0000
Received: from AM5EUR03FT059.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:90:cafe::f7) by AM6P194CA0015.outlook.office365.com
 (2603:10a6:209:90::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Wed, 22 Apr 2020 10:37:34 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT059.mail.protection.outlook.com (10.152.17.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.15 via Frontend Transport; Wed, 22 Apr 2020 10:37:33 +0000
Received: ("Tessian outbound 76e9a4cf1540:v53"); Wed, 22 Apr 2020 10:37:32 +0000
X-CR-MTA-TID: 64aa7808
Received: from 4d0aa9211465.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id FE232943-C2D7-41FD-8A3B-E7FDDC1FAC0A.1;
        Wed, 22 Apr 2020 10:37:27 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 4d0aa9211465.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 22 Apr 2020 10:37:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVUvlQCKaHJ75Z0UhcTB7gOPvfw3vw+a7s7oJOKJ+ydpE8ROjRTZskejeCrqnWSjVRHdbbqbjIUURt+Ps3b4Z3tjA8rhC0ghITPxuOHbYDbyckVtcZNub0GSLFhA2F3CZFi/5NkGisJiopNP0vcUASjG0SKnpAGnuXPutzbNii4tPFQb+fPUuzI6fbSDJ1aWyqXgrkeWNUMSM4etyDDaOzEXf/lF/vQe12/Z22kXw+B7xikoDfxyHwsqfwNKD7YiIBi72Xw3zq9YbhMnzq7dfsAsxudrvT2x/4K1jOvTb/3JIwRPNkaiqc0GsuN7pdsLoVZEYXULCBf5hPDDAJz+pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GhTnVoSdfWnzJOWfX2LANJpfpVFruZgqZMi2/7DKYg=;
 b=RQL5GMXOpGF4r7l3K5BrBASyjmYWCr4GfXDYx55Y8P+z6VmumVpVAKaXiRyyThp80ohc1Ho1qeByE9wttslfFfOM5syzwbNSxJ5OmRdrCX9kdc0bJkp/APyiwOp8ztxZCkb0rZTymoN3kyBMNpplnuQCojz0M5Icn11S/jvy9kYe69NQgrow/X0HhTFyVJ2eSpwiK6o1i1zsJnVz10/aMktiHlzw730u68lQhZtdxANHaBczvgmc+nn42qrioLR/y0ts0x/+y1g1us/BRQndsDgbFUW2rEOgOngdzzfXIwcbV6GdU8mXbzIEyiLFt2dT4MSr8PIh7FMp1Df+k9Yj2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GhTnVoSdfWnzJOWfX2LANJpfpVFruZgqZMi2/7DKYg=;
 b=FH/gP0kDHpA7+jFsn3YPn9pAgdASHqj33+O9G02wuGrUsivmIGcZUXldFHURYIm919H37jE9V3VqeC9PJ+j6vJXKJwGUvYK9jJGpMaVAQR6R9JCJycEFDuI3Um1Y0cNw+sgdJ8fUUuZkYNfVUia9N1sLB3Gl7ttmAVewtbXKECE=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2168.eurprd08.prod.outlook.com (2603:10a6:4:84::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Wed, 22 Apr
 2020 10:37:23 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 10:37:23 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v7 2/3] hw_random: cctrng: introduce Arm CryptoCell driver
Thread-Topic: [PATCH v7 2/3] hw_random: cctrng: introduce Arm CryptoCell
 driver
Thread-Index: AQHWA/5/37ByIllroUeQ0w3cVWDDJKiCK72AgABugaCAASDNgIAAFS7QgAAbIgCAAS6MQA==
Date:   Wed, 22 Apr 2020 10:37:22 +0000
Message-ID: <DB6PR0802MB253305028DB2B89F9BE09E5CE9D20@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
 <1585289423-18440-3-git-send-email-hadar.gat@arm.com>
 <CAMuHMdV6Uce79MPs7jfJfX3WOqAMH22vf2V_=Ui0zLHYqsJ+Xg@mail.gmail.com>
 <DB6PR0802MB25338BD19DD2F7E662BB1065E9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <CAMuHMdWujabV8dr=EojXFBVD0TcUuZ2kCGjjo93u=PE-AmzVHA@mail.gmail.com>
 <DB6PR0802MB2533347A35A466B99ADD4D23E9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <CAMuHMdVGwLQxDj9dtF02L3P5MxBCZAiJ1_4OyK3Yomn9y-nPzQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVGwLQxDj9dtF02L3P5MxBCZAiJ1_4OyK3Yomn9y-nPzQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 6c7a9fd2-af90-4d13-9723-347aa36bc933.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ae8e0780-b021-49fe-59f7-08d7e6a92af4
x-ms-traffictypediagnostic: DB6PR0802MB2168:|DB6PR0802MB2168:|AM6PR08MB3863:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB3863A069B0623315996E6C84E9D20@AM6PR08MB3863.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;OLM:8273;
x-forefront-prvs: 03818C953D
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(7416002)(33656002)(71200400001)(478600001)(5660300002)(26005)(316002)(2906002)(54906003)(55016002)(6916009)(9686003)(86362001)(66946007)(4326008)(6506007)(7696005)(66446008)(76116006)(64756008)(66556008)(8936002)(52536014)(81156014)(66476007)(8676002)(186003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: gv0BEIouMUpq5EHyNNcCvj+c6WRsETHUaQd4zATEv/HUczPoe3blr6yvV27l9dQpEEg/U9ukuMRWFSHW3OQQ3zILxGnlWqmz21NNgOWAF+3v2P1NaHDJ+5fKGttfgFqfH35IEnJHCAwJlYCngseO6X+d/gaeRUGU/S/RNdSBmTILuZW6BLwpp/dNfrh5teLoT7evvA9knvjerX4Rqw6Ox2VT++ILDyJjEnv5jLtMGrTOgo/h323Pxad+crOn5Gp/w2BoGuvPikfJ569UEFmNL6dRztWZxdOPEcvXTLV1QJKj8tfzPRwlfRtmTdWMrtDQP+JIMd7r1Y6Ay1aJ7qSYPSFe4SIQaP8murdBzOs4LyHTPzykSD6K/LxRhKxtZzHUpyCrADPcUZCW/aWYV18hxkt7p56uHx0SgSYNvpU6wlfiwlJlViT+09QqSqWNPmvI
x-ms-exchange-antispam-messagedata: aJodZEcJC1+TGw8E1TRAMlSOa5bVrftJEM7eMr05EAXlICqwv6tcexczRh4qfrIgg+Y1bU2FEeKmS/6NAXQlRwnIgCemam89OFhIfUNA5g07w7czWgR8L4uWlM4XYyR/y0/3b+5Xs71lPomdbDXi+A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2168
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT059.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(396003)(39860400002)(136003)(46966005)(4326008)(47076004)(82740400003)(9686003)(316002)(8676002)(86362001)(52536014)(8936002)(356005)(2906002)(6506007)(70206006)(81156014)(81166007)(70586007)(55016002)(7696005)(26005)(5660300002)(478600001)(450100002)(6862004)(33656002)(54906003)(36906005)(186003)(336012)(82310400002);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 5a9c88fa-b9fa-4933-0373-08d7e6a92476
X-Forefront-PRVS: 03818C953D
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PPO0TJRcAxjMhdMsl/4vEXYPUxIU1PzjwVxCHrBRYt5aorYhizIJ1Pk7o39xigXaHuXTVkqnSKt6MvucJBLuUZwa/y5wUJcBM4OptTQpwY4JQpER+GGIW0r9WsWUFmTUW5bgr5bvmS3bdV/sYmYEMT/imGzHJKGMsos+18+TGbziG8LXuJEoRMSZ6Leo4EHUSDuImdkkORGelGEAuiGFAS7FmFteoppg/3R8z2WA6g0elHITQCWgB2m+zwldaq0NP+au9Dc5B+7QBud0MkNKA4Nnu+xuVxWFjpFVOotjc483/1tnQmUcOdCOG9+sLRsv6XBJjYrQ+8U+ugUTxniD4qEjfwR9R0H2n4Axn5vSu8K5zPBNdUHhYutphM/QmdDdP+CMcL09GKHmuinvZ5ccjD+cnBj8r7mBGjGtFL3VEtmceTlEl+G9MGjV5qa6uPZRVq9rZES2IPLbkp2Hgzwqy3PXbOhts/awSPyCpq7J4t0efrXrSxdi6xydjg580V4+RmFDe2dsZ4eaG1pYfIoeIw==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 10:37:33.9652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae8e0780-b021-49fe-59f7-08d7e6a92af4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3863
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+ID4gPiA+ID4gK3N0YXRpYyBpbnQgY2N0cm5nX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZp
Y2UgKnBkZXYpIHsNCj4gDQo+ID4gPiA+ID4gPiArICAgICAgIC8qIHJlZ2lzdGVyIHRoZSBkcml2
ZXIgaXNyIGZ1bmN0aW9uICovDQo+ID4gPiA+ID4gPiArICAgICAgIHJjID0gZGV2bV9yZXF1ZXN0
X2lycShkZXYsIGlycSwgY2NfaXNyLCBJUlFGX1NIQVJFRCwNCj4gPiA+ID4gPiA+ICsgImNjdHJu
ZyIsIGRydmRhdGEpOw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gU2hvdWRuJ3QgdGhpcyBiZSBkb25l
IGFmdGVyIGNsZWFyaW5nIHRoZSBwZW5kaW5nIGludGVycnVwdHMgYmVsb3c/DQo+ID4gPiA+DQo+
ID4gPiA+IEknbSBub3Qgc3VyZSB3aGF0IGRvIHlvdSBtZWFuIGluIHlvdXIgcXVlc3Rpb24uLi4N
Cj4gPiA+ID4gSSBhc3N1bWUgeW91J3JlIHN1Z2dlc3RpbmcgdGhhdCB0aGUgcmVnaXN0cmF0aW9u
IG9mIHRoZSBkcml2ZXIgSVNSDQo+ID4gPiA+IGZ1bmN0aW9uDQo+ID4gPiBzaG91bGQgYmUgZG9u
ZSBvbmx5IGFmdGVyIGNsZWFyaW5nIHRoZSBwZW5kaW5nIGludGVycnVwdHM/IQ0KPiA+ID4NCj4g
PiA+IEluZGVlZC4NCj4gPiA+DQo+ID4gPiA+IEFueXdheSwgYW55IHBlbmRpbmcgaW50ZXJydXB0
IHRoYXQgbWlnaHQgZXhpc3QgaXMgaXJyZWxldmFudCB0bw0KPiA+ID4gPiB0aGUgY3VycmVudCBj
Y3RybmcgZHJpdmVyIHdoaWNoIGp1c3Qgc3RhcnRlZCAod2UncmUgaW4gdGhlIHByb2JlDQo+ID4g
PiA+IGZ1bmN0aW9uKQ0KPiA+ID4NCj4gPiA+IElmIHRoZXJlIGlzIGEgcGVuZGluZyBpbnRlcnJ1
cHQsIHlvdXIgaW50ZXJydXB0IGhhbmRsZXIgKHdoaWNoDQo+ID4gPiByZXR1cm5zIElSUV9OT05F
IGluIHRoaXMgY2FzZSkgd2lsbCBiZSBjYWxsZWQgcmVwZWF0ZWRseSwgdW50aWwgdGhlDQo+ID4g
PiBkcml2ZXIgZ2V0cyB0byBjbGVhcmluZyB0aGUgcGVuZGluZyBpbnRlcnJ1cHRzIGJlbG93LCBv
ciB1bnRpbCB0aGUNCj4gPiA+IGludGVycnVwdCBjb3JlIGRlY2lkZXMgdG8gZ2l2ZSB1cCwgYW5k
IGRpc2FibGUgaXQgZm9yIGdvb2QuDQo+ID4NCj4gPiBPaywgSSBnZXQgeW91ciBwb2ludCBub3cu
DQo+ID4gQnV0IG5vdGUgdGhhdCB3aGVuIHRoZSBjY3RybmcgSFcgYm9vdHMsIHRoZSBkZWZhdWx0
IGlzIHRoYXQgYWxsIGludGVycnVwdHMNCj4gYXJlIG1hc2tlZCwgaGVuY2UgdGhlIGludGVycnVw
dCBoYW5kbGVyIHdpbGwgbm90IGJlIGNhbGxlZC4NCj4gDQo+IElzIHRoYXQgYWxzbyB0aGUgY2Fz
ZSB3aGVuIGJvb3RpbmcgaW50byBhIG5ldyBrZXJuZWwgdXNpbmcga2V4ZWM/DQoNCldlbGwuLiBu
by4g4pi5DQpBIGZpeCBpcyBuZWVkZWQgaGVyZSB0byBjb25zaWRlciBhbHNvIHRoZSBjYXNlIG9m
IGtleGVjLg0KSSdsbCBmaXggdGhhdCBpbiBhbm90aGVyIHBhdGNoLg0KVGhhbmtzIQ0K
