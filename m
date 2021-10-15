Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FBFC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 08:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BD3761053
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 08:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbhJOJBJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Oct 2021 05:01:09 -0400
Received: from mail-am6eur05on2078.outbound.protection.outlook.com ([40.107.22.78]:4448
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229656AbhJOJBF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Oct 2021 05:01:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivqMb+Xz4L1D9pBbyNoku1Kk0mAV97Rk1vTgI3akMOE=;
 b=TquGEMlwDwv6mRf6VT/4gjR++/xxPjomY83Ji03QDauqGf4z+Cjtg/2Io5JgZfAEq74Vs77F46O0KMviLm2uYPnJYNJCrGJkU0PADcesjQ5wKyB7D1q49Yvdtpq3V0ZxOiVcYvjHfstVmZhRtSjH437IO+vxJVT1qPq4wC7nTp8=
Received: from AS8P189CA0025.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:31f::26)
 by HE1PR0801MB1692.eurprd08.prod.outlook.com (2603:10a6:3:84::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 08:58:56 +0000
Received: from VE1EUR03FT021.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:31f:cafe::6c) by AS8P189CA0025.outlook.office365.com
 (2603:10a6:20b:31f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Fri, 15 Oct 2021 08:58:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT021.mail.protection.outlook.com (10.152.18.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 08:58:55 +0000
Received: ("Tessian outbound f1898412aff1:v103"); Fri, 15 Oct 2021 08:58:55 +0000
X-CR-MTA-TID: 64aa7808
Received: from d250271af952.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 21C670C6-6540-4384-9521-5346581F63B6.1;
        Fri, 15 Oct 2021 08:58:44 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id d250271af952.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 15 Oct 2021 08:58:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8rpKCyiJQlQHT+l2Apwbeb/hSRdzUBih44kctxHH+rJhWo45aPaEd/KNw8oa3RTZDhIRSwRSSKitW2kL6Ux6LozU8jRakTKSrUkppwqzQAtljGFFey1vnJlyyflwoX350n1pMWQNlrirXjiFo0EAAPgyRg/6TG2By1AKGDmgnigmyP5dRRCx/WnxJtCXGgPGzr4q2/T9DKwu/JSTXfPp/tjHKviujiTy543MXDFvU7WWkU5CDUvtYp7UUBOMaGqNJZ9pTAWOQd4xfXh66pvMEX8gPb4r0RTAQeQNMJ57e5dp0KVVkQ+VSSnm+x76KeE8ZawX6+FVQwKX5diT5K2zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ivqMb+Xz4L1D9pBbyNoku1Kk0mAV97Rk1vTgI3akMOE=;
 b=DYCHIennCmjkyCZMv6vxHLA0zXJzWhak2jgL1iQ3h3jPfUr8YIdDtjPtkQftNbmenFQhm5Sxsg2ldWnbD00+AAkovQ6qZD26lW0rIsqOa5QkZ0TcV9JkdnGYXdpwgxOpVhANqDa+KeyO7lUMfUAHQViciFvvPwfaKESr7BNT9Yay2LG7UG8P4vDMnxoDKKe/JsIhoyJg/jIYPFxh65DkozBQad/loCMa7j8NwL8A9bRgO8xB8kH/vdlrlUqs9+9CAT60JNB4YAd8O/pzsUqWmQtEomKgvrQDQXyuz8o3AQ/jj/qlIAljtv/pR/8cvPTbbJ9WZhjp9pEQpSd99CnYUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivqMb+Xz4L1D9pBbyNoku1Kk0mAV97Rk1vTgI3akMOE=;
 b=TquGEMlwDwv6mRf6VT/4gjR++/xxPjomY83Ji03QDauqGf4z+Cjtg/2Io5JgZfAEq74Vs77F46O0KMviLm2uYPnJYNJCrGJkU0PADcesjQ5wKyB7D1q49Yvdtpq3V0ZxOiVcYvjHfstVmZhRtSjH437IO+vxJVT1qPq4wC7nTp8=
Received: from PA4PR08MB6016.eurprd08.prod.outlook.com (2603:10a6:102:e3::9)
 by PAXPR08MB6624.eurprd08.prod.outlook.com (2603:10a6:102:dd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 08:58:40 +0000
Received: from PA4PR08MB6016.eurprd08.prod.outlook.com
 ([fe80::2567:667e:8f4e:d831]) by PA4PR08MB6016.eurprd08.prod.outlook.com
 ([fe80::2567:667e:8f4e:d831%6]) with mapi id 15.20.4608.016; Fri, 15 Oct 2021
 08:58:40 +0000
From:   Xiaokang Qian <Xiaokang.Qian@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will@kernel.org>, nd <nd@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: arm64/gcm-ce - unroll factors to 4-way interleave
 of aes and ghash
Thread-Topic: [PATCH] crypto: arm64/gcm-ce - unroll factors to 4-way
 interleave of aes and ghash
Thread-Index: AQHXsESW0x0OVrc26UKxttoWchWUMKu5Ay+AgAD1A4CAAdlKEIAA5N2AgBcrm1A=
Date:   Fri, 15 Oct 2021 08:58:40 +0000
Message-ID: <PA4PR08MB6016113128CCEC71AC3D9D5BEEB99@PA4PR08MB6016.eurprd08.prod.outlook.com>
References: <20210923063027.166247-1-xiaokang.qian@arm.com>
 <YVK1u4BgVAa84fMa@sol.localdomain>
 <CAMj1kXHeJBUAzcLHRNYDbbUDe5vRS7Bxy_LKF5gdRLJca7TNRQ@mail.gmail.com>
 <PA4PR08MB60168642B59CCFC91A3F4ABDEEAA9@PA4PR08MB6016.eurprd08.prod.outlook.com>
 <CAMj1kXEHOscYf0qxdzAw2u_J+zb2dXfWdK07MkBZUnJZv0Ds0g@mail.gmail.com>
In-Reply-To: <CAMj1kXEHOscYf0qxdzAw2u_J+zb2dXfWdK07MkBZUnJZv0Ds0g@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: D3FBDA316F8AA34E9338DB6271286C1B.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 3c3355ab-a161-42a3-e80a-08d98fba04e6
x-ms-traffictypediagnostic: PAXPR08MB6624:|HE1PR0801MB1692:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0801MB1692E1303E24359DEF59E399EEB99@HE1PR0801MB1692.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: qo5ccoXqh+2ODI7qJRecBj57DnZfL1wHp6i+f/yDB9ub7z5zgwbmcrueQNNoVf7GlSVPrv1eaQZuf1sYPUhDt1o1jRmK3ReUmv0tI9niJqISad5rDgynrcvtkxAb59ImTr8O5U4nRZ5g0lDM5+omheCag/An3XwjgQim9Lq0vjCnyANFbqPeIQAGNsDpVGTlDAJeCLBLzRl3qmSjMRcc7wl0r38x3dhdkq7OFRuqusRFvN9SV8NN8xQOq7w+BYuwqvDhzr1xUUQ7zx9EP7TD/mFnlDc386ZCN4aRhJhmmX3pfzQeuEhUWCGux2kJ65Uzpy3th2NYydtu0417Fmh6MUVjrstG6H1ntKSkumJUj0vMYd3ZpHm2dgONErdwcIrHO24eyOEr+6Wi7F2Dw9gQJZmumBWJF/fGJDKJ7AtquaF27rmSctEB7Ln+YNgcQJJoskxdUXPDQetcGtEH81G0aPLfDdyywqJbKnUWGgJL12U+GbQHCKOicZgKUDWIKwdc4upn10e06F3XEMmXxorb0QvIWO4lWpG23F2LfD8zhxyewZ5aq5XrA+M7eiOTvuG2S8RqRuU+DzT/mOk42d2JxtqL5twxVwo5pWY0V2nv0kNJ4dxKRgr27MRa94ZQWGzcINMjtyG4lXUFspLHiTIn1NXGzW5pcZA8pTpsWV8go1QKVFfjhUGkVJyMAR6Dpuxs92frdDGo7U++VDJr9hNcLw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR08MB6016.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(7696005)(83380400001)(508600001)(66946007)(76116006)(54906003)(6506007)(26005)(38100700002)(122000001)(316002)(53546011)(4326008)(66476007)(66556008)(64756008)(66446008)(55016002)(8936002)(6916009)(52536014)(38070700005)(5660300002)(33656002)(2906002)(186003)(8676002)(71200400001)(9686003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6624
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT021.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 4f835618-343b-44fc-c32d-08d98fb9fbaf
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6XeusnXe9qVz6zAml3q90u3srbc0PaN2PhhRZdnqmjwjrPjFRBO8gjB6vZz6EcMrxYl4YVqRXdWXE3e+6GxbKBU+bhuljy7r16M+mK6x3wTNmbwZiVctvcs7A1Mx/7nRx+GOpY7i8eMDBORez1Z8SZMeVzlsLn7fBjvxZp3QZcE/5iN0utiNOg583P6NeXgkGyTx/3JyADu7pOIgW4UBmwP7HYvsIcL6VVsQf/PTWBmQrj1RBn4Hf4gqt5NdY8Rdm5a9qCD1UolPMGLZI/y5teL5FPQL1n4NBC29g1P9dWvfk00GJ//DUjgDYPu5HMqk7lq1pozMKiF1z0BqFRVBJ4GGOO5PXLEwogErTI9hgasrFGmX3PLiwly2oeM9v9mEw0OcX8itTdoX5dISGaUdTYtMu0dP02YqOSbyerm0UFzrMMqi77L+5xW8kXclqAOhrNdXjc0cqSx3N1O+wQDHDmcvF53KBzhC7AAysAMLHqB++RylBIz4tBV+llyNbdhiLcj6uftEgcNFgf6Jkv17N7WvR3bemN7k93fmd8TnJRe3JL93kPfSKtiSBsNviup+YOWXBWGKEot2RypT+/EuRRSpb5YnlvMAzHT2WnXzLSoC7/pxtUzROFXgZRKCjYI/vO0FIdh8eMU+0rMfOmC2Hed6jCMBx63ciOeuWyGbzBSxhUQn7NHjBaA8KTeJv1e1gY3wsp/K6tOdiZZ6p2FWGA==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(336012)(81166007)(356005)(55016002)(53546011)(4326008)(6506007)(8676002)(450100002)(7696005)(47076005)(186003)(86362001)(5660300002)(33656002)(52536014)(6862004)(36860700001)(26005)(83380400001)(2906002)(508600001)(316002)(70206006)(70586007)(8936002)(82310400003)(9686003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 08:58:55.6587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c3355ab-a161-42a3-e80a-08d98fba04e6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT021.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1692
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIFRodSwgU2VwdGVtYmVyIDMwLCAyMDIxIDEwOjU3IFBNLCBBcmQgQmllc2hldXZlbCA8
YXJkYkBrZXJuZWwub3JnPg0Kd3JvdGU6DQo+IA0KPiBPbiBUaHUsIDMwIFNlcHQgMjAyMSBhdCAw
MzozMiwgWGlhb2thbmcgUWlhbiA8WGlhb2thbmcuUWlhbkBhcm0uY29tPg0KPiB3cm90ZToNCj4g
Pg0KPiA+IFRoYW5rcyBmb3IgdGhlIHJldmlldy4NCj4gPg0KPiA+IEkgd2lsbCBmaXJzdGx5IGNo
YW5nZSB0aGUgZGVjcnlwdCBwYXRoIHRvIGNvbXBhcmUgdGhlIHRhZyB1c2luZyBTSU1EIGNvZGUs
DQo+IGFuZCB0aGVuICBwYXNzIGFsbCBvZiB0aGUgc2VsZiB0ZXN0cyBpbmNsdWRlIGZ1enogdGVz
dHMoZW5hYmxlZCBieQ0KPiBDT05GSUdfQ1JZUFRPX01BTkFHRVJfRVhUUkFfVEVTVFM9eSksIGJp
ZyBlbmRpYW4gLGxpdHRsZSBlbmRpYW4NCj4gdGVzdHMuDQo+ID4NCj4gDQo+IE9LDQo+IA0KPiA+
IEFib3V0IHRoZSAxSyBkYXRhIHBvaW50LCBJIGp1c3QgcmVtZW1iZXIgdGhhdCB0aGUgMTQyMCBi
eXRlcyBwYWNrZXQgaXMNCj4gY29tbW9ubHkgdXNlZCBpbiBJUFNFQy4NCj4gPg0KPiANCj4gWWVz
LCBidXQgeW91ciBjb2RlIGlzIGZhc3RlciB0aGFuIHRoZSBleGlzdGluZyBjb2RlIGZvciAxNDIw
IGJ5dGUgcGFja2V0cywgcmlnaHQ/DQo+IFNvIHdoeSBzaG91bGQgd2Uga2VlcCB0aGUgb3JpZ2lu
YWwgY29kZT8gV2UgZG9uJ3QgdXNlIEdDTSBmb3IgYmxvY2sNCj4gc3RvcmFnZSwgYW5kIGlmIElQ
c2VjIHRocm91Z2hwdXQgaXMgYSBrZXkgcGVyZm9ybWFuY2UgbWV0cmljIGZvciB5b3VyIHN5c3Rl
bSwNCj4geW91IGFyZSBsaWtlbHkgdG8gYmUgdXNpbmcgdGhlIG1heGltdW0gcGFja2V0IHNpemUg
c28gMTQyMCBieXRlcyBub3QgMWsuDQo+IA0KPiANCg0KWWVzLCB0aGUgY29kZSBpcyBmYXN0ZXIg
dGhhbiB0aGUgZXhpc3RpbmcgY29kZSBmb3IgMTQyMCBieXRlcyBwYWNrZXRzLCBhbmQgdGhlIGJp
Z2dlciB0aGUgZGF0YSBzaXplLCB0aGUgbW9yZSB0aGUgcGVyZm9ybWFuY2UgaXMgdXBsaWZ0ZWQu
DQpCdXQgdGhlcmUgaXMgb25lIGlzc3VlLCAgb3VyIGNvZGUgd2lsbCBpbnRlcmxlYXZlIDQgYmxv
Y2tzIGZvciBjcnlwdG8tQUVTIGluc3RydWN0aW9ucyBhbmQgYW5vdGhlciA0IGJsb2NrcyBmb3Ig
Z2hhc2gocG11bGwpIGluIHBhcmFsbGVsLCBzbyANCml0J3MgbW9yZSBmcmllbmRseSB0byB0aGUg
YmlnZ2VyIGRhdGEgc2l6ZSBidXQgbm90IGZyaWVuZGx5IHRvIHRoZSBzbWFsbGVyIG9uZXMuDQpG
b3IgdGhlIGRhdGEgc2l6ZSB0aGF0IGlzIHNtYWxsZXIgdGhhbiAxayBkYXRhIHNpemUsIHRoZSBw
ZXJmb3JtYW5jZSAgd2lsbCBoYXZlIHNvbWUgcmVncmVzc2lvbi4gDQpTbyB3ZSBrZWVwIHRoZSB0
d28gZHJpdmVyIGV4aXN0IHRvZ2V0aGVyLg0KDQo+ID4NCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KPiA+IEZyb206IEFyZCBCaWVzaGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+DQo+ID4g
U2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgMjksIDIwMjEgNTowNCBBTQ0KPiA+IFRvOiBFcmlj
IEJpZ2dlcnMgPGViaWdnZXJzQGtlcm5lbC5vcmc+DQo+ID4gQ2M6IFhpYW9rYW5nIFFpYW4gPFhp
YW9rYW5nLlFpYW5AYXJtLmNvbT47IEhlcmJlcnQgWHUNCj4gPiA8aGVyYmVydEBnb25kb3IuYXBh
bmEub3JnLmF1PjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsNCj4gPiBD
YXRhbGluIE1hcmluYXMgPENhdGFsaW4uTWFyaW5hc0Bhcm0uY29tPjsgV2lsbCBEZWFjb24NCj4g
PiA8d2lsbEBrZXJuZWwub3JnPjsgbmQgPG5kQGFybS5jb20+OyBMaW51eCBDcnlwdG8gTWFpbGlu
ZyBMaXN0DQo+ID4gPGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc+OyBMaW51eCBBUk0NCj4g
PiA8bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnPjsgTGludXggS2VybmVsIE1h
aWxpbmcgTGlzdA0KPiA+IDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPg0KPiA+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0hdIGNyeXB0bzogYXJtNjQvZ2NtLWNlIC0gdW5yb2xsIGZhY3RvcnMgdG8g
NC13YXkNCj4gPiBpbnRlcmxlYXZlIG9mIGFlcyBhbmQgZ2hhc2gNCj4gPg0KPiA+IE9uIFR1ZSwg
MjggU2VwdCAyMDIxIGF0IDA4OjI3LCBFcmljIEJpZ2dlcnMgPGViaWdnZXJzQGtlcm5lbC5vcmc+
IHdyb3RlOg0KPiA+ID4NCj4gPiA+IE9uIFRodSwgU2VwIDIzLCAyMDIxIGF0IDA2OjMwOjI1QU0g
KzAwMDAsIFhpYW9rYW5nUWlhbiB3cm90ZToNCj4gPiA+ID4gVG8gaW1wcm92ZSBwZXJmb3JtYW5j
ZSBvbiBjb3JlcyB3aXRoIGRlZXAgcGlwbGluZXMgc3VjaCBhcyBBNzIsTjEsDQo+ID4gPiA+IGlt
cGxlbWVudCBnY20oYWVzKSB1c2luZyBhIDQtd2F5IGludGVybGVhdmUgb2YgYWVzIGFuZCBnaGFz
aA0KPiA+ID4gPiAodG90YWxseQ0KPiA+ID4gPiA4IGJsb2NrcyBpbiBwYXJhbGxlbCksIHdoaWNo
IGNhbiBtYWtlIGZ1bGwgdXRpbGl6ZSBvZiBwaXBlbGluZXMNCj4gPiA+ID4gcmF0aGVyIHRoYW4g
dGhlIDQtd2F5IGludGVybGVhdmUgd2UgdXNlZCBjdXJyZW50bHkuIEl0IGNhbiBnYWluDQo+ID4g
PiA+IGFib3V0IDIwJSBmb3IgYmlnIGRhdGEgc2l6ZXMgc3VjaCB0aGF0IDhrLg0KPiA+ID4gPg0K
PiA+ID4gPiBUaGlzIGlzIGEgY29tcGxldGUgbmV3IHZlcnNpb24gb2YgdGhlIEdDTSBwYXJ0IG9m
IHRoZSBjb21iaW5lZA0KPiA+ID4gPiBHQ00vR0hBU0ggZHJpdmVyLCBpdCB3aWxsIGNvLWV4aXN0
IHdpdGggdGhlIG9sZCBkcml2ZXIsIG9ubHkgc2VydmUNCj4gPiA+ID4gZm9yIGJpZyBkYXRhIHNp
emVzLiBJbnN0ZWFkIG9mIGludGVybGVhdmluZyBmb3VyIGludm9jYXRpb25zIG9mDQo+ID4gPiA+
IEFFUyB3aGVyZSBlYWNoIGNodW5rIG9mIDY0IGJ5dGVzIGlzIGVuY3J5cHRlZCBmaXJzdCBhbmQg
dGhlbg0KPiA+ID4gPiBnaGFzaGVkLCB0aGUgbmV3IHZlcnNpb24gdXNlcyBhIG1vcmUgY29hcnNl
IGdyYWluZWQgYXBwcm9hY2ggd2hlcmUNCj4gPiA+ID4gYSBjaHVuayBvZg0KPiA+ID4gPiA2NCBi
eXRlcyBpcyBlbmNyeXB0ZWQgYW5kIGF0IHRoZSBzYW1lIHRpbWUsIG9uZSBjaHVuayBvZiA2NCBi
eXRlcw0KPiA+ID4gPiBpcyBnaGFzaGVkIChvciBnaGFzaGVkIGFuZCBkZWNyeXB0ZWQgaW4gdGhl
IGNvbnZlcnNlIGNhc2UpLg0KPiA+ID4gPg0KPiA+ID4gPiBUaGUgdGFibGUgYmVsb3cgY29tcGFy
ZXMgdGhlIHBlcmZvcm1hbmNlIG9mIHRoZSBvbGQgZHJpdmVyIGFuZCB0aGUNCj4gPiA+ID4gbmV3
IG9uZSBvbiB2YXJpb3VzIG1pY3JvLWFyY2hpdGVjdHVyZXMgYW5kIHJ1bm5pbmcgaW4gdmFyaW91
cw0KPiA+ID4gPiBtb2RlcyB3aXRoIHZhcmlvdXMgZGF0YSBzaXplcy4NCj4gPiA+ID4NCj4gPiA+
ID4gICAgICAgICAgICAgfCAgICAgQUVTLTEyOCAgICAgICB8ICAgICBBRVMtMTkyICAgICAgIHwg
ICAgIEFFUy0yNTYgICAgICAgfA0KPiA+ID4gPiAgICAgICNieXRlcyB8IDEwMjQgfCAxNDIwIHwg
IDhrIHwgMTAyNCB8IDE0MjAgfCAgOGsgfCAxMDI0IHwgMTQyMCB8ICA4ayB8DQo+ID4gPiA+ICAg
ICAgLS0tLS0tLSstLS0tLS0rLS0tLS0tKy0tLS0tKy0tLS0tLSstLS0tLS0rLS0tLS0rLS0tLS0t
Ky0tLS0tLSstLS0tLSsNCj4gPiA+ID4gICAgICAgICBBNzIgfCA1LjUlIHwgIDEyJSB8IDI1JSB8
IDIuMiUgfCAgOS41JXwgIDIzJXwgLTElICB8ICA2LjclfCAxOSUgfA0KPiA+ID4gPiAgICAgICAg
IEE1NyB8LTAuNSUgfCAgOS4zJXwgMzIlIHwgLTMlICB8ICA2LjMlfCAgMjYlfCAtNiUgIHwgIDMu
MyV8IDIxJSB8DQo+ID4gPiA+ICAgICAgICAgTjEgIHwgMC40JSB8ICA3LjYlfDI0LjUlfCAtMiUg
IHwgIDUlICB8ICAyMiV8IC00JSAgfA0KPiA+ID4gPiAyLjclfCAyMCUgfA0KPiA+ID4gPg0KPiA+
ID4gPiBTaWduZWQtb2ZmLWJ5OiBYaWFva2FuZ1FpYW4gPHhpYW9rYW5nLnFpYW5AYXJtLmNvbT4N
Cj4gPiA+DQo+ID4gPiBEb2VzIHRoaXMgcGFzcyB0aGUgc2VsZi10ZXN0cywgaW5jbHVkaW5nIHRo
ZSBmdXp6IHRlc3RzIHdoaWNoIGFyZQ0KPiA+ID4gZW5hYmxlZCBieSBDT05GSUdfQ1JZUFRPX01B
TkFHRVJfRVhUUkFfVEVTVFM9eT8NCj4gPiA+DQo+ID4NCj4gPiBQbGVhc2UgdGVzdCBib3RoIGxp
dHRsZS1lbmRpYW4gYW5kIGJpZy1lbmRpYW4uIChOb3RlIHRoYXQgeW91IGRvbid0DQo+ID4gbmVl
ZCBhIGJpZy1lbmRpYW4gdXNlciBzcGFjZSBmb3IgdGhpcyAtIHRoZSBzZWxmIHRlc3RzIGFyZSBl
eGVjdXRlZA0KPiA+IGJlZm9yZSB0aGUgcm9vdGZzIGlzIG1vdW50ZWQpDQo+ID4NCj4gPiBBbHNv
LCB5b3Ugd2lsbCBoYXZlIHRvIHJlYmFzZSB0aGlzIG9udG8gdGhlIGxhdGVzdCBjcnlwdG9kZXYg
dHJlZSwgd2hpY2gNCj4gY2FycmllcyBzb21lIGNoYW5nZXMgSSBtYWRlIHJlY2VudGx5IHRvIHRo
aXMgZHJpdmVyLg0KPiA+DQo+ID4gRmluYWxseSwgSSdkIGxpa2UgdG8gZGlzY3VzcyB3aGV0aGVy
IHdlIHJlYWxseSBuZWVkIHR3byBzZXBhcmF0ZQ0KPiA+IGRyaXZlcnMgaGVyZS4gVGhlIDFrIGRh
dGEgcG9pbnQgaXMgbm90IGFzIHJlbGV2YW50IGFzIHRoZSBvdGhlciBvbmVzLA0KPiA+IHdoaWNo
IHNob3cgYSB3b3J0aHdoaWxlIHNwZWVkdXAgZm9yIGFsbCBtaWNybyBhcmNoaXRlY3R1cmVzIGFu
ZCBkYXRhDQo+ID4gc2l6ZXMgKGFsdGhvdWdoIEkgd2lsbCBnaXZlIHRoaXMgYSBzcGluIG9uIFRY
MiBteXNlbGYgd2hlbiBJIGhhdmUgdGhlDQo+ID4gY2hhbmNlKQ0KPiA+DQo+ID4gKklmKiB3ZSBz
d2l0Y2ggdG8gdGhpcyBpbXBsZW1lbnRhdGlvbiBjb21wbGV0ZWx5LCBJIHdvdWxkIGxpa2UgdG8g
a2VlcCB0aGUNCj4gaW1wcm92ZW1lbnQgSSBhZGRlZCByZWNlbnRseSB0byB0aGUgZGVjcnlwdCBw
YXRoIHRvIGNvbXBhcmUgdGhlIHRhZyB1c2luZw0KPiBTSU1EIGNvZGUsIHJhdGhlciB0aGFuIGNv
cHlpbmcgaXQgb3V0IGFuZCB1c2luZyBtZW1jbXAoKS4NCj4gPiBDb3VsZCB5b3UgbG9vayBpbnRv
IGFkb3B0aW5nIHRoaXMgZm9yIHRoaXMgdmVyc2lvbiBhcyB3ZWxsPw0KPiA+DQo+ID4gLS0NCj4g
PiBBcmQuDQo=
