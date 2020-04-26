Return-Path: <SRS0=DsWe=6K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96A9C55191
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Apr 2020 13:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8CA62074F
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Apr 2020 13:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="oWD7NgZQ";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="oWD7NgZQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgDZNG4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Apr 2020 09:06:56 -0400
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:63489
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbgDZNGz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Apr 2020 09:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9aF+NSp/k+b3QXD4vcGnF8IE4xBv1bGccE/ziZ4N9c=;
 b=oWD7NgZQYfNceDr8eGWxv73Fbd9sGyEuQSogK+TziqgSacAlIvvocRZXdApypo5hN+ZcIWBZaJpecPN3OOIDBC5uw3Weh0aKSdq59R3ORx5BdDQFrpyUw1lDHBcwj4Nf2E2nRJN5ErA2neF2ymXY47gS0b7hvwgsCO8rX5FfDFE=
Received: from AM5PR0201CA0012.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::22) by DB8PR08MB5516.eurprd08.prod.outlook.com
 (2603:10a6:10:f9::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Sun, 26 Apr
 2020 13:06:49 +0000
Received: from AM5EUR03FT056.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:3d:cafe::5b) by AM5PR0201CA0012.outlook.office365.com
 (2603:10a6:203:3d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Sun, 26 Apr 2020 13:06:49 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT056.mail.protection.outlook.com (10.152.17.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.19 via Frontend Transport; Sun, 26 Apr 2020 13:06:49 +0000
Received: ("Tessian outbound 4cdf5642225a:v54"); Sun, 26 Apr 2020 13:06:48 +0000
X-CR-MTA-TID: 64aa7808
Received: from ae9bbbfe2a3a.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6304621D-373B-43EF-83F6-C760DEA0EEF6.1;
        Sun, 26 Apr 2020 13:06:43 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ae9bbbfe2a3a.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Sun, 26 Apr 2020 13:06:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxtWLwCeR60AqT1/XfWN8X1sPJkYQ/PwgXJFgSwo6/en8Yt0Sus2Q5pg0tDyJBCRVIH7+7myvcR9LZrG1H1oPQyynd7Akdl2dCbR5lJg/FJxgJkJ3tZZw3g5SCKxzddte4Wr6BZq5LnwdyQLdEmbxFQzUvm88MtUyaEJLzhRDu/+XytMlJUOVwvxjs/gROgNwGHOuaH0d1898JhUhb9CRC2YDpwGZLTVeArVaPl3U045MvpNKH+i4AwYgggjXNG+hSH/zIKQAUteM3DV6A1UQJOzYXO5r/Ehrb3ARx5hSiuDOs8USG6PONPncqgdToltypRsIZRygdAVr5jhVZO6cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9aF+NSp/k+b3QXD4vcGnF8IE4xBv1bGccE/ziZ4N9c=;
 b=T+lMJ2AOAekoldCcGF1CdzcBhhk9zDnb6z3Uxz1bYfpxkIJHgmIcOpZ71D1lFdwAh0jQauBQHA2u0N737NC+XIbYh23OPzch8nJ7HwPpTgBQm/dVEzn6lu8SS2ekDP4zswlQsvbIO5Ale3hGuh0cuoZTRDfDnTbLZx2do7KF+rOtqVDLEujygFzsAUjEXQexJw+u7cUunkEyQB1wMa6UFbbufKuOopi64wM+tXY1MDLDNjvvLtkszRu09RjJN85ZAmEWmcJ6DzTH+uDkRw6lmNdSJ7KwxpNF8+SiyQHaBxgvI1Xze69oZe7kO2TBENxVFyTO+ZjJwCATEXBCtOGFlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9aF+NSp/k+b3QXD4vcGnF8IE4xBv1bGccE/ziZ4N9c=;
 b=oWD7NgZQYfNceDr8eGWxv73Fbd9sGyEuQSogK+TziqgSacAlIvvocRZXdApypo5hN+ZcIWBZaJpecPN3OOIDBC5uw3Weh0aKSdq59R3ORx5BdDQFrpyUw1lDHBcwj4Nf2E2nRJN5ErA2neF2ymXY47gS0b7hvwgsCO8rX5FfDFE=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2184.eurprd08.prod.outlook.com (2603:10a6:4:83::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Sun, 26 Apr
 2020 13:06:41 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2937.020; Sun, 26 Apr 2020
 13:06:41 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        nd <nd@arm.com>
Subject: RE: Fw: Arm CryptoCell driver -- default Y, even on machines where it
 is obviously useless
Thread-Topic: Fw: Arm CryptoCell driver -- default Y, even on machines where
 it is obviously useless
Thread-Index: AQHWFW48sqdeVFxZnkOUS/sdJEIQwah/VA9QgACqAwaAACd7AIALPwIAgAAE44CAAAGvEA==
Date:   Sun, 26 Apr 2020 13:06:41 +0000
Message-ID: <DB6PR0802MB25337F3E99821E87803B3786E9AE0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <20200418104343.GA5132@amd>
 <DB6PR0802MB2533670AFC1473E5C5EDAD28E9D60@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <VI1PR08MB3584451F0B0B21E00ACF56A7FED70@VI1PR08MB3584.eurprd08.prod.outlook.com>
 <CAOtvUMfNgdYZF5VaqgF-51b0+KtxqgUFD6njXFX7evz1yAJc9A@mail.gmail.com>
 <CAMj1kXEGSAD2Kkjg56UhMGgjuLBSOAKJ7ZMHdzfP2szGncu-4Q@mail.gmail.com>
 <DB6PR0802MB25337F768E6B2DCF943AC11CE9AE0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <CAMj1kXECTnTg+2V+oh1+ONca9mUi14CJ1QXoaktM4N2rVs_+EQ@mail.gmail.com>
In-Reply-To: <CAMj1kXECTnTg+2V+oh1+ONca9mUi14CJ1QXoaktM4N2rVs_+EQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: e0cf4e48-7562-466f-a16b-d9fcafd38db7.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bd65a632-74c3-48ca-27ab-08d7e9e2ae41
x-ms-traffictypediagnostic: DB6PR0802MB2184:|DB8PR08MB5516:
X-Microsoft-Antispam-PRVS: <DB8PR08MB55169006C08D6E03F821005BE9AE0@DB8PR08MB5516.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 03853D523D
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(7696005)(64756008)(26005)(2906002)(4326008)(478600001)(6916009)(66476007)(316002)(186003)(6506007)(86362001)(9686003)(66446008)(54906003)(55016002)(33656002)(81156014)(8676002)(52536014)(8936002)(66556008)(66946007)(5660300002)(76116006)(71200400001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: HRmVfQXBqut3G9VqxOt7JPPxJ52UUtn6PcKA2+aLUGEFuN5f6qN5axnHASU0S3hthQ7jauqoEZRjF9obo+71vUwk7GhNdx1dAda6VUcTHOu+/ckCnEIGMbpDs+W3Gwgw0Kh6Ks9nLmyBIGmN8qdjWSM6w/gQldbrPtJ60kBuFiy5Ya1tc9u6m+PEA4F3wR97eaqWr5tiDxVfPijv93tWDB0ZN6sMgq/aiOFpmNqDcHfSx9EA8EWTIOB32005gdqbe5pqI6nQ+gXnr4MSvJVxPGi0sFGsMVzEACZ5kbDpP6gsa6zMArcj0oXTnwR8+INZ0JmUYoYdQjMhdyoZCG/9VaiS0nM5WpUH5FnHTfXtUrwsiUvCFsjdSPgdNuMKX0ozNtf3qgYbTwwXXoyV1EKgNnZ+Ai7k5aKBZ9FLhG3PbUpf99Phk+WO+iM60K37MPI2
x-ms-exchange-antispam-messagedata: Unb2iKiKoc6e7ee/tak31FQ5mAU9HyNvtEHWzGmBl4l9DDHY4u+sgmEcMwJK4XyckoCxp7NlxLfzCujc2805V3vkcYzm7lX2DY9KjELTvz4+j7McgZ8E/Oo/ZsNbPFXmGW4wc2sJk4rMOyacSc/i97Pq7iIibvMuL54c0o43IPYm2IN77Jy774i8iYLCKotUX5mOO6f7jh+U1G3PsPbEnTh4REM33QldycjB9SkULn02nFzhUgNVdB2yinGajJ2MVYBSkai2Uf+XJ5dLUcERtOjp+E8cBv1fSyXAhZouXQTqkdZMkmGdCo55DTXlCxunJKD1eJkhSoteBkzExfm3v+C07MJmO8Ry0blK3EKkqIx1agu6M/egB5puRBif+txMJfS0ciAvcvnrlxskJRM7XEajyvNp383HDBUgfqKNxxxA4YdT2gbM5zMF1TH/3covMQiX6sx/s9V9wS7Sh0f/XLVb+AJbu1V6ma9596ochKhSNoNz1m7uJAzZ3nl5E5trGB7GJquf64nNsAd1BYIgG6lnrDzNHEbPyMerTSyKuN+CR3zES5bTf6ytxHS8GeMPOVI+DtvkEBfybJ1UYL3ylm6rrjhUra9CNGCeLfu+gycGC2u5S7x5ee7SUb4CNleNi1d6cJ5y8QRz/1w7TSXRfXMZaV/rS7RtHsnu7rQZJLo/hmuzOYHoS0Jiw9YCKpJbd+8jsj53LuMSK0yfdjOUKtfJRYjxGKOYDfwfRNPwVzXsYaMhsi1iiNlEdLXI4GSuU/KxWVG6ZBqQ+u4xtrJafmwryiUxGdt9ho4979XcEQM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2184
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT056.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(46966005)(70206006)(82310400002)(316002)(82740400003)(356005)(26005)(47076004)(81166007)(6506007)(86362001)(33656002)(36906005)(52536014)(2906002)(4326008)(186003)(54906003)(8676002)(450100002)(8936002)(55016002)(7696005)(70586007)(478600001)(336012)(5660300002)(9686003)(81156014)(6862004);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 1f669983-0cf3-4a85-4e82-08d7e9e2a9d2
X-Forefront-PRVS: 03853D523D
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CosWpGMfWFzYSSeRzNpkPE2853qWGWn8VMH7V5yasbQknoWdXiGprbrbbTcj2xQnY8UHNo54v/VXCcEutxOkqVUrDWk7ar1IIN2vLw5gDHEk9/yoi+LuWOmrbQewPSPlGFrLOq7hwz+8U7A33/nOQLxupoxFICOnPRSMonQSaqrYPrWPu/r9KlwfuACK0nPAOUFIjZqzjEDf+9GpBql+eP566MGFat5+ts4/7ENPaRX1IbNhBzPh7h3A9OAGwZ6CbiEg/BDGs+Kn+buhWc6kzLHyZ7V3i7NBT8ImU+V5g+u6eDQCwFM1JIGhEKy0oA9mgJFskCm3GYDoo4p7N3C9T7vslLwjUsImkIl/0Y1Cr0Pej47oQcaJSlU48cQb+f/IgPdWX+UwgBbiu7rPoBLq2EKZlEbUXAJxQxXAriqO9WJGezGGw2WMKinmzFji34BMwwwiUDo2AJB+zkvxrokHU1jIMO+Bsxh38Yu3KTivucsokypCx9ECwfNPx4zZE2insGxThg5BfdRUJfBjeestNg==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2020 13:06:49.0531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd65a632-74c3-48ca-27ab-08d7e9e2ae41
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5516
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogQXJkIEJpZXNo
ZXV2ZWwgPGFyZGJAa2VybmVsLm9yZz4NCj4gPiA+IFNlbnQ6IFN1bmRheSwgMTkgQXByaWwgMjAy
MCAxMTo1NQ0KPiA+ID4NCj4gPiA+IEJvdGggdGhlIGRlZmF1bHQgeSBhbmQgYW5kIHRoZSBoZWxw
IHRleHQgYXJlIGluZGVlZCBpbmNvcnJlY3QuIFRoaXMNCj4gPiA+IHNob3VsZCBiZSBmaXhlZC4g
V2UgZG9uJ3QgZW5hYmxlIGRldmljZSBkcml2ZXJzIGJ5IGRlZmF1bHQsIGFuZA0KPiA+ID4gZGVm
aW5pdGVseSBub3QgYXMgYXMgYnVpbHRpbnMuIEEgY29uZGl0aW9uYWwgZGVmYXVsdCBtIGNvdWxk
IGJlDQo+ID4gPiBhY2NlcHRhYmxlIGlmIHRoZSBjb25kaXRpb24gaXMgc3VmZmljaWVudGx5IG5h
cnJvdy4NCj4gPg0KPiA+IE9uIG9uZSBoYW5kIEkgdG90YWxseSBhZ3JlZSB3aXRoIHRoYXQgYW5k
IHRoaW5rIHRoZSBkZWZhdWx0IHNob3VsZCBiZSBOLg0KPiA+IE9uIHRoZSBvdGhlciBoYW5kLCBt
b3N0IG9mIHRoZSBIV19SQU5ET00gZHJpdmVycyBzZXQgdGhlIGRlZmF1bHQgdG8NCj4gPiBIV19S
QU5ET00gYW5kIGl0IGRvZXNuJ3QgbWFrZSBzZW5zZSB0byBtZSB0byBkbyBzb21ldGhpbmcgZGlm
ZmVyZW50DQo+IHRoYW4gYWxtb3N0IGV2ZXJ5IG90aGVyIEhXIFJBTkRPTSBkZXZpY2UuDQo+ID4g
RG8gSSBtaXNzIHNvbWV0aGluZyBoZXJlPw0KPiA+DQo+IA0KPiBZZXMuIEZpcnN0IG9mIGFsbCwg
dXNpbmcgJ2RlZmF1bHQgSFdfUkFORE9NJyBldmVyeXdoZXJlIG1ha2VzIG5vIHNlbnNlIGF0DQo+
IGFsbCwgYnV0IHRoYXQgaXMgbm90IHlvdXIgZmF1bHQuDQo+IA0KPiBJZiB5b3UgbG9vayBhdCBk
cml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWcsIHlvdSB3aWxsIHNlZSB0aGF0IG1vc3QNCj4g
ZHJpdmVycyBoYXZlIGFkZGl0aW9uYWwgZGVwZW5kcyBsaW5lcywgd2hpY2ggbWVhbnMgdGhhdCAn
ZGVmYXVsdCBtJw0KPiAob3IgJ2RlZmF1bHQgeScgaW4gY2FzZSBDT05GSUdfSFdfUkFORE9NPXkp
IHdpbGwgb25seSB0YWtlIGFmZmVjdCBpZiB0aGUNCj4gZGVwZW5kZW5jeSBpcyBmdWxmaWxsZWQu
DQo+IA0KPiBJdCBtYWtlcyBubyBzZW5zZSB0byBlbmFibGUgdGhpcyBkcml2ZXIgb24gKmV2ZXJ5
KiBzaW5nbGUgTGludXggc3lzdGVtLCByaWdodD8NCj4gRXNwZWNpYWxseSBnaXZlbiB0aGF0IG1h
bnkgYXJjaGl0ZWN0dXJlcyBkbyBub3QgZXZlbiBzdXBwb3J0IGRldmljZSB0cmVlLA0KPiB3aGlj
aCBpcyBhIHByZXJlcXVpc2l0ZSB0byBiZSBhYmxlIHRvIGV2ZW4gcHJvYmUuDQo+IA0KDQpUaGFu
a3MgeW91IEFyZCBmb3IgY2xlYXJpbmcgaXQgdXAgZm9yIG1lLg0KSSdsbCBmaXggdGhhdCBzaG9y
dGx5Lg0KDQpIYWRhcg0KDQo+IA0KPiANCj4gDQo+IGRyaXZlcnMvY2hhci9od19yYW5kb20vS2Nv
bmZpZy1jb25maWcgSFdfUkFORE9NX0lOVEVMDQo+IGRyaXZlcnMvY2hhci9od19yYW5kb20vS2Nv
bmZpZy0gZGVwZW5kcyBvbiAoWDg2IHx8IElBNjQpICYmIFBDSQ0KPiAtLQ0KPiBkcml2ZXJzL2No
YXIvaHdfcmFuZG9tL0tjb25maWctY29uZmlnIEhXX1JBTkRPTV9BTUQNCj4gZHJpdmVycy9jaGFy
L2h3X3JhbmRvbS9LY29uZmlnLSBkZXBlbmRzIG9uIChYODYgfHwgUFBDX01BUExFKSAmJiBQQ0kN
Cj4gLS0NCj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLWNvbmZpZyBIV19SQU5ET01f
QVRNRUwNCj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLSBkZXBlbmRzIG9uIEFSQ0hf
QVQ5MSAmJiBIQVZFX0NMSw0KPiAmJiBPRg0KPiAtLQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9t
L0tjb25maWctY29uZmlnIEhXX1JBTkRPTV9CQ00yODM1DQo+IGRyaXZlcnMvY2hhci9od19yYW5k
b20vS2NvbmZpZy0gZGVwZW5kcyBvbiBBUkNIX0JDTTI4MzUgfHwNCj4gQVJDSF9CQ01fTlNQIHx8
IEFSQ0hfQkNNXzUzMDFYIHx8IFwNCj4gLS0NCj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29u
ZmlnLWNvbmZpZyBIV19SQU5ET01fSVBST0NfUk5HMjAwDQo+IGRyaXZlcnMvY2hhci9od19yYW5k
b20vS2NvbmZpZy0gZGVwZW5kcyBvbiBBUkNIX0JDTV9JUFJPQyB8fA0KPiBBUkNIX0JDTTI4MzUg
fHwgQVJDSF9CUkNNU1RCDQo+IC0tDQo+IGRyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZy1j
b25maWcgSFdfUkFORE9NX0dFT0RFDQo+IGRyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZy0g
ZGVwZW5kcyBvbiBYODZfMzIgJiYgUENJDQo+IC0tDQo+IGRyaXZlcnMvY2hhci9od19yYW5kb20v
S2NvbmZpZy1jb25maWcgSFdfUkFORE9NX04yUk5HDQo+IGRyaXZlcnMvY2hhci9od19yYW5kb20v
S2NvbmZpZy0gZGVwZW5kcyBvbiBTUEFSQzY0DQo+IC0tDQo+IGRyaXZlcnMvY2hhci9od19yYW5k
b20vS2NvbmZpZy1jb25maWcgSFdfUkFORE9NX1ZJQQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9t
L0tjb25maWctIGRlcGVuZHMgb24gWDg2DQo+IC0tDQo+IGRyaXZlcnMvY2hhci9od19yYW5kb20v
S2NvbmZpZy1jb25maWcgSFdfUkFORE9NX0lYUDRYWA0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9t
L0tjb25maWctIGRlcGVuZHMgb24gQVJDSF9JWFA0WFgNCj4gLS0NCj4gZHJpdmVycy9jaGFyL2h3
X3JhbmRvbS9LY29uZmlnLWNvbmZpZyBIV19SQU5ET01fT01BUA0KPiBkcml2ZXJzL2NoYXIvaHdf
cmFuZG9tL0tjb25maWctIGRlcGVuZHMgb24gQVJDSF9PTUFQMTZYWCB8fA0KPiBBUkNIX09NQVAy
UExVUyB8fCBBUkNIX01WRUJVDQo+IC0tDQo+IGRyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZp
Zy1jb25maWcgSFdfUkFORE9NX09NQVAzX1JPTQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tj
b25maWctIGRlcGVuZHMgb24gQVJDSF9PTUFQMw0KPiAtLQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFu
ZG9tL0tjb25maWctY29uZmlnIEhXX1JBTkRPTV9PQ1RFT04NCj4gZHJpdmVycy9jaGFyL2h3X3Jh
bmRvbS9LY29uZmlnLSBkZXBlbmRzIG9uIENBVklVTV9PQ1RFT05fU09DDQo+IC0tDQo+IGRyaXZl
cnMvY2hhci9od19yYW5kb20vS2NvbmZpZy1jb25maWcgSFdfUkFORE9NX1BBU0VNSQ0KPiBkcml2
ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWctIGRlcGVuZHMgb24gUFBDX1BBU0VNSQ0KPiAtLQ0K
PiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWctY29uZmlnIEhXX1JBTkRPTV9WSVJUSU8N
Cj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLSBkZXBlbmRzIG9uIFZJUlRJTw0KPiAt
LQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWctY29uZmlnIEhXX1JBTkRPTV9UWDQ5
MzkNCj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLSBkZXBlbmRzIG9uIFNPQ19UWDQ5
MzkNCj4gLS0NCj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLWNvbmZpZyBIV19SQU5E
T01fTVhDX1JOR0ENCj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLSBkZXBlbmRzIG9u
IFNPQ19JTVgzMQ0KPiAtLQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWctY29uZmln
IEhXX1JBTkRPTV9JTVhfUk5HQw0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWctIGRl
cGVuZHMgb24gSEFTX0lPTUVNICYmIEhBVkVfQ0xLDQo+IC0tDQo+IGRyaXZlcnMvY2hhci9od19y
YW5kb20vS2NvbmZpZy1jb25maWcgSFdfUkFORE9NX05PTUFESUsNCj4gZHJpdmVycy9jaGFyL2h3
X3JhbmRvbS9LY29uZmlnLSBkZXBlbmRzIG9uIEFSQ0hfTk9NQURJSw0KPiAtLQ0KPiBkcml2ZXJz
L2NoYXIvaHdfcmFuZG9tL0tjb25maWctY29uZmlnIEhXX1JBTkRPTV9QU0VSSUVTDQo+IGRyaXZl
cnMvY2hhci9od19yYW5kb20vS2NvbmZpZy0gZGVwZW5kcyBvbiBQUEM2NCAmJiBJQk1WSU8NCj4g
LS0NCj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLWNvbmZpZyBIV19SQU5ET01fUE9X
RVJOVg0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWctIGRlcGVuZHMgb24gUFBDX1BP
V0VSTlYNCj4gLS0NCj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLWNvbmZpZyBIV19S
QU5ET01fSElTSQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWctIGRlcGVuZHMgb24g
SFdfUkFORE9NICYmDQo+IEFSQ0hfSElTSQ0KPiAtLQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9t
L0tjb25maWctY29uZmlnIEhXX1JBTkRPTV9ISVNJX1YyDQo+IGRyaXZlcnMvY2hhci9od19yYW5k
b20vS2NvbmZpZy0gZGVwZW5kcyBvbiBIV19SQU5ET00gJiYgQVJNNjQNCj4gJiYgQUNQSQ0KPiAt
LQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWctY29uZmlnIEhXX1JBTkRPTV9TVA0K
PiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWctIGRlcGVuZHMgb24gSFdfUkFORE9NICYm
IEFSQ0hfU1RJDQo+IC0tDQo+IGRyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZy1jb25maWcg
SFdfUkFORE9NX1hHRU5FDQo+IGRyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZy0gZGVwZW5k
cyBvbiBIV19SQU5ET00gJiYNCj4gQVJDSF9YR0VORQ0KPiAtLQ0KPiBkcml2ZXJzL2NoYXIvaHdf
cmFuZG9tL0tjb25maWctY29uZmlnIEhXX1JBTkRPTV9TVE0zMg0KPiBkcml2ZXJzL2NoYXIvaHdf
cmFuZG9tL0tjb25maWctIGRlcGVuZHMgb24gSFdfUkFORE9NICYmDQo+IChBUkNIX1NUTTMyIHx8
DQo+IENPTVBJTEVfVEVTVCkNCj4gLS0NCj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmln
LWNvbmZpZyBIV19SQU5ET01fUElDMzINCj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmln
LSBkZXBlbmRzIG9uIEhXX1JBTkRPTSAmJg0KPiBNQUNIX1BJQzMyDQo+IC0tDQo+IGRyaXZlcnMv
Y2hhci9od19yYW5kb20vS2NvbmZpZy1jb25maWcgSFdfUkFORE9NX01FU09ODQo+IGRyaXZlcnMv
Y2hhci9od19yYW5kb20vS2NvbmZpZy0gZGVwZW5kcyBvbiBIV19SQU5ET00NCj4gLS0NCj4gZHJp
dmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLWNvbmZpZyBIV19SQU5ET01fQ0FWSVVNDQo+IGRy
aXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZy0gZGVwZW5kcyBvbiBIV19SQU5ET00gJiYgUENJ
ICYmDQo+IChBUk02NA0KPiB8fCAoQ09NUElMRV9URVNUICYmIDY0QklUKSkNCj4gLS0NCj4gZHJp
dmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLWNvbmZpZyBIV19SQU5ET01fTVRLDQo+IGRyaXZl
cnMvY2hhci9od19yYW5kb20vS2NvbmZpZy0gZGVwZW5kcyBvbiBIV19SQU5ET00NCj4gLS0NCj4g
ZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLWNvbmZpZyBIV19SQU5ET01fUzM5MA0KPiBk
cml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWctIGRlcGVuZHMgb24gUzM5MA0KPiAtLQ0KPiBk
cml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWctY29uZmlnIEhXX1JBTkRPTV9FWFlOT1MNCj4g
ZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnLSBkZXBlbmRzIG9uIEFSQ0hfRVhZTk9TIHx8
DQo+IENPTVBJTEVfVEVTVA0KPiAtLQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWct
Y29uZmlnIEhXX1JBTkRPTV9PUFRFRQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWct
IGRlcGVuZHMgb24gT1BURUUNCj4gLS0NCj4gZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmln
LWNvbmZpZyBIV19SQU5ET01fTlBDTQ0KPiBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWct
IGRlcGVuZHMgb24gQVJDSF9OUENNIHx8DQo+IENPTVBJTEVfVEVTVA0K
