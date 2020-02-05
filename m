Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658FAC3F68F
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 08:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 184122082E
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 08:56:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="kz4yILOL";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="kz4yILOL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgBEI4m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 03:56:42 -0500
Received: from mail-eopbgr60057.outbound.protection.outlook.com ([40.107.6.57]:16453
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727231AbgBEI4m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 03:56:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0yTgf9y0YyIyyRbruPLTm6/4OjRk15Hbd6nh2k1e9g=;
 b=kz4yILOLHmye8DHIYh77BJ/BVKnXXc/QzsqTTPvx8MC0axWcFoKw4RC/l2jPiZMgW6XYbTKFvgswdjJMTIEavOFZuj0tYc49WXfQCqZVlMG24RFAnUcZKgwRO8xHPso7zvF+r7d9FHko9fPqNsRa0ihhdJ4WgqGtUoR/kYTaGpg=
Received: from VE1PR08CA0004.eurprd08.prod.outlook.com (2603:10a6:803:104::17)
 by VI1PR08MB5391.eurprd08.prod.outlook.com (2603:10a6:803:138::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.30; Wed, 5 Feb
 2020 08:56:37 +0000
Received: from DB5EUR03FT010.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::202) by VE1PR08CA0004.outlook.office365.com
 (2603:10a6:803:104::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend
 Transport; Wed, 5 Feb 2020 08:56:37 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT010.mail.protection.outlook.com (10.152.20.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.18 via Frontend Transport; Wed, 5 Feb 2020 08:56:37 +0000
Received: ("Tessian outbound 62d9cfe08e54:v42"); Wed, 05 Feb 2020 08:56:37 +0000
X-CR-MTA-TID: 64aa7808
Received: from d51231fe70d6.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 5477F70A-732D-4268-B176-CFB55EB982BB.1;
        Wed, 05 Feb 2020 08:56:32 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id d51231fe70d6.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 05 Feb 2020 08:56:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+GVYe6b8FzsNI85T36FeaOd5sPioWXAf3C7GjYbyPzObULvmYkKH2ZGW6nPGwmwbzTfM+bPgKYuj5TluAS0jDzY0AApOGFKITIJYvzBsdbEOBsT022dVxV/AdNQiPqJb8bDuFGJlizPR8zZh6jTu7naAxlBWRFYm5Esr5jAf8Mf4pkpfcoz1wz78iSwHuh3LegAMm2MoO3Z5L0GoD2ampHHNLfq6HpHU4jqDAw9NYedytD7LS5fY5TG4zLm/yM846C+Wu2jjXYYQm3ct8ReaE8GSIGunvHsdvLTQRziaau0+h4zrAzT9Rea3RmeKdtdHfSeNyMhWxkDy3FGnI9QkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0yTgf9y0YyIyyRbruPLTm6/4OjRk15Hbd6nh2k1e9g=;
 b=fCpdvWZr+6L/b+RhbCRQ9gIU53AXlVexzDg8oXVZCmIxcLg/veR1MW0jw0Xo4WqRC4Hbg9w8LqHOw1KzJNNaPys+IlOG9+Hzs3/qck/UrZYnKhUxXs2wSf2bPZIZv8nDF5BtdN6PyFi7pi2b4NT8IX5BGIFLaH8aujAOJNxXPgj7DL1AQi16TLT7pgj6n8JA+lTzSWttsVk3ZyU0n007xNttkZk2I5rvTWjIHhJ0JR6+kc9LVmx04yC00FVQaDxETR7b0yqe5QDD7va1aub2iDwKdtAKDUwBe78o1n4ho9AIWx5nWyzc1mSVaRM2kVYNj7EfNLbiidno2zfG87bcRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0yTgf9y0YyIyyRbruPLTm6/4OjRk15Hbd6nh2k1e9g=;
 b=kz4yILOLHmye8DHIYh77BJ/BVKnXXc/QzsqTTPvx8MC0axWcFoKw4RC/l2jPiZMgW6XYbTKFvgswdjJMTIEavOFZuj0tYc49WXfQCqZVlMG24RFAnUcZKgwRO8xHPso7zvF+r7d9FHko9fPqNsRa0ihhdJ4WgqGtUoR/kYTaGpg=
Received: from AM5PR0801MB1665.eurprd08.prod.outlook.com (10.169.247.15) by
 AM5PR0801MB2068.eurprd08.prod.outlook.com (10.168.159.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 5 Feb 2020 08:56:29 +0000
Received: from AM5PR0801MB1665.eurprd08.prod.outlook.com
 ([fe80::a9de:d56:93b9:46ec]) by AM5PR0801MB1665.eurprd08.prod.outlook.com
 ([fe80::a9de:d56:93b9:46ec%6]) with mapi id 15.20.2707.020; Wed, 5 Feb 2020
 08:56:29 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
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
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, DTML <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v2 0/3] hw_random: introduce Arm CryptoCell TRNG driver
Thread-Topic: [PATCH v2 0/3] hw_random: introduce Arm CryptoCell TRNG driver
Thread-Index: AQHV2cyFOhc6p7+w10q7pqI+6jMyYqgJPFcAgAMTfOA=
Date:   Wed, 5 Feb 2020 08:56:28 +0000
Message-ID: <AM5PR0801MB166550B5D63DEDA2DD64A0D7E9020@AM5PR0801MB1665.eurprd08.prod.outlook.com>
References: <1580650021-8578-1-git-send-email-hadar.gat@arm.com>
 <CAK8P3a3C7hfCQwupKQqtnOmwu7faoeKH9fcEZFQW3WmrScKzUw@mail.gmail.com>
In-Reply-To: <CAK8P3a3C7hfCQwupKQqtnOmwu7faoeKH9fcEZFQW3WmrScKzUw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 0c53b9a7-a9be-4a16-96fb-781d156538ad.0
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [217.140.106.29]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6f77a82a-fe9f-4fbb-8b4a-08d7aa194f31
X-MS-TrafficTypeDiagnostic: AM5PR0801MB2068:|AM5PR0801MB2068:|VI1PR08MB5391:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB5391899633252FF41C9A39D4E9020@VI1PR08MB5391.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 0304E36CA3
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(189003)(199004)(8936002)(71200400001)(86362001)(478600001)(2906002)(52536014)(76116006)(66946007)(5660300002)(7416002)(186003)(6916009)(54906003)(8676002)(66476007)(66556008)(66446008)(64756008)(316002)(53546011)(26005)(6506007)(33656002)(81156014)(9686003)(81166006)(55016002)(7696005)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0801MB2068;H:AM5PR0801MB1665.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: b7t5tUNtWLkD5OwrJWBObGdOhhGby3XDBexRzHJ9J7OPnv4/vMyyMwKsY/FMUv6NRdXcUeO61X/8bV4bB/piAqbr9GWPM52Mpd10sxUjEBwoHtkIW6Gu8Ldgg6MJzQRfiggXI+EJGLlEowKtTyOKsk4N49rXbdMe5WvkSYkelbORf5ik6PKxEltsQF6i4V753zH12DxElNA2I9qXZLyuEMaWIQPhpGtaHQBcEkpIDyEtKUYkmdXQy2MX+gFTPmaqYyw1tRHYU7LDW9xruRPzu93JT/mI74mN8rSvEDo2NV7CAqEm8Dc2snRzxn+X/+YErwpEHdnIcpLhvjjUgMUVLaqi2J1hSmOE4MjD9nnVZKcPX0tp7bkI/tXb3DoUuKCDFquSuIZ3AiV/aa9RpidVfMBffEG/dy7gQ/SKcg2o0R3CmBG++W2SRMtVI0uYy+w2
x-ms-exchange-antispam-messagedata: sNoUVXBCSziqjctWa/dn2lhKH0IW18D/hXdX0XR/ekVCo4w8sfIDjUwSnS2zYs3ISOSQy+ZncGRsJmC7wuZBU9WIzfE7t/4d96Hrl5U6ehYoolmiK3yQYv6gUJgCl/20YhoqA3sU0dXJSk7Ch6dKiQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB2068
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT010.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(136003)(39860400002)(189003)(199004)(478600001)(86362001)(9686003)(70206006)(186003)(6862004)(81166006)(4326008)(8676002)(356004)(2906002)(26826003)(336012)(8936002)(70586007)(53546011)(55016002)(81156014)(6506007)(5660300002)(54906003)(316002)(52536014)(26005)(33656002)(7696005)(450100002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR08MB5391;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 458ca4bb-0145-46c9-104d-08d7aa194a23
X-Forefront-PRVS: 0304E36CA3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IZvv/wn1XPEJE4mhXMsgkDOW65pNyYWmEBS+8eHeG5dfY6QBqj5R8VW8J2DSaZKfnrp8hU8aUCPN1ETGuvzDGjeRbOP8RN+jBi/QJ7loBFOxZxXvJLuWcat++NAxCdA21BSOLMoBfueFXEaMt9neL6EbdschdGCs6QERwWJBfA3/XmYC2WQaiSmjErfcEQ9BehEpPyIJytmD5EgvXA7uSW9Z81vobzlokhLcZy2DmeIPVyP013BBgnVy74wUuWCQql0+qISRbOT0k0b/QNph3aX7HpvHbsCBMQFU8DoxokfWhTbcQFP9jR8IdPi/bf8Zjp2DB/Fp+fmQ5IDZxmKPt1Th0Wfd7My2fXDJTvLXRXBSsL8cw5Oxzti32Lo7JbBfgyku8lUqhFp3Tc18jDBtKJWuxJYpD8CEx0K0jXPuHyelCXj3qHDKdmcrpnTQlNZM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2020 08:56:37.4855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f77a82a-fe9f-4fbb-8b4a-08d7aa194f31
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5391
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IA0KPiBPbiBTdW4sIEZlYiAyLCAyMDIwIGF0IDI6MjcgUE0gSGFkYXIgR2F0IDxoYWRhci5n
YXRAYXJtLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBUaGUgQXJtIENyeXB0b0NlbGwgaXMgYSBoYXJk
d2FyZSBzZWN1cml0eSBlbmdpbmUuDQo+ID4gVGhpcyBwYXRjaCBpbnRyb2R1Y2VzIGRyaXZlciBm
b3IgaXRzIFRSTkcgKFRydWUgUmFuZG9tIE51bWJlcg0KPiA+IEdlbmVyYXRvcikgZW5naW5lLg0K
PiA+DQo+ID4gQ2hhbmdlcyBmcm9tIHByZXZpb3VzIHZlcmlvc246IGZpeGVkICdtYWtlIGR0X2Ju
ZGluZ19jaGVjaycgZXJyb3JzLg0KPiA+DQo+ID4gSGFkYXIgR2F0ICgzKToNCj4gPiAgIGR0LWJp
bmRpbmdzOiBhZGQgZGV2aWNlIHRyZWUgYmluZGluZyBmb3IgQXJtIENyeXB0b0NlbGwgdHJuZyBl
bmdpbmUNCj4gPiAgIGh3X3JhbmRvbTogY2N0cm5nOiBpbnRyb2R1Y2UgQXJtIENyeXB0b0NlbGwg
ZHJpdmVyDQo+ID4gICBNQUlOVEFJTkVSUzogYWRkIEhHIGFzIGNjdHJuZyBtYWludGFpbmVyDQo+
IA0KPiBJIGxvb2tlZCBhdCB0aGUgcGF0Y2hlcyBicmllZmx5IGFuZCBldmVyeXRoaW5nIG1ha2Vz
IHNlbnNlIHRvIG1lLA0KPiANCj4gQWNrZWQtYnk6IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIu
ZGU+DQo+IA0KPiBUaGVyZSBhcmUgdHdvIHN0eWxlIGlzc3VlcyB0aGF0IHlvdSBjb3VsZCBpbXBy
b3ZlOg0KPiANCj4gLSBUaGUgaGVhZGVyIGlzIG9ubHkgaW5jbHVkZWQgZnJvbSBhIHNpbmdsZSBm
aWxlLCBzbyBJIHdvdWxkIGp1c3QgZm9sZA0KPiAgIGl0cyBjb250ZW50cyBpbnRvIHRoZSBkcml2
ZXIgaXRzZWxmLg0KDQpBbHRob3VnaCBpdCBpcyBpbmNsdWRlZCBmcm9tIGEgc2luZ2xlIGZpbGUs
IEkgcHJlZmVyIGEgc2VwYXJhdGVkIGZpbGUgYmVjYXVzZSBpdCBpcyBhbHJlYWR5IGNvbnRhaW5z
IG1vcmUgdGhhbiBhIGZldyBkZWZpbml0aW9ucyBhbmQgaXQgaXMgbW9zdCBsaWtlbHkgdGhhdCBp
dHMgY29udGVudCB3aWxsIGdyb3cgaW4gbmV4dCB2ZXJzaW9ucyBvZiBBcm0gQ3J5cHRvQ2VsbCBI
Vy4NCg0KPiANCj4gLSBZb3UgaGF2ZSBhIGxvdCBvZiAiI2lmZGVmIENPTkZJR19QTSIgdGhhdCBh
cmUgZWFzeSB0byBnZXQgd3JvbmcNCj4gICB3aXRoIHZhcmlvdXMgY29tYmluYXRpb25zIG9mIGNv
bmZpZyBzeW1ib2xzLiBJdCdzIG9mdGVuIGJldHRlciB0bw0KPiAgIGxlYXZlIHRoYXQgYWxsIGNv
bXBpbGVkIHVuY29uZGl0aW9uYWxseSBhbmQgaGF2ZSB0aGUgbG9naWMgaW4NCj4gICBVTklWRVJT
QUxfREVWX1BNX09QUygpIHRha2UgY2FyZSBvZiBkcm9wcGluZyB0aGUgdW51c2VkDQo+ICAgYml0
cywgd2l0aCBhIF9fbWF5YmVfdW51c2VkIGFubm90YXRpb24gb24gZnVuY3Rpb25zIHRoYXQgY2F1
c2UNCj4gICBhIHdhcm5pbmcgb3RoZXJ3aXNlLg0KDQpUaGFua3MgQXJuZC4gSSdsbCByZW1vdmUg
dGhlc2UgI2lmZGVmIGFzIHlvdSBzdWdnZXN0ZWQuDQoNCj4gDQo+ICAgICAgICBBcm5kDQoNCkhh
ZGFyDQo=
