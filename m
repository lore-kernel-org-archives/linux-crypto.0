Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7842C54FD0
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 07:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE8721707
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 07:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="0Vd/6Uco";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="0Vd/6Uco"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgD0H05 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 03:26:57 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:6029
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726685AbgD0H04 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 03:26:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtnAvDoin0FjTGa6HPADEx1cLKRMV9FQRXiKvmqI0Z0=;
 b=0Vd/6Uco+G1dH2FPKvtoLH85JsU/0dMwsauXqeH3CkmJt+3R88NwYzGGPyRzqxof4IkbzEBCTO3sQV0M48caOQ1Oq0LnZ7Uau7iYbkF98/9rW1mI2UfZyu/N0cCoCW8ROSYo9qLt/DJcswKAnggp30Rc+uryLlDUZpxrjJfZExY=
Received: from AM6PR05CA0030.eurprd05.prod.outlook.com (2603:10a6:20b:2e::43)
 by AM6PR08MB4818.eurprd08.prod.outlook.com (2603:10a6:20b:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 07:26:51 +0000
Received: from VE1EUR03FT023.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:2e:cafe::d1) by AM6PR05CA0030.outlook.office365.com
 (2603:10a6:20b:2e::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Mon, 27 Apr 2020 07:26:51 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT023.mail.protection.outlook.com (10.152.18.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.19 via Frontend Transport; Mon, 27 Apr 2020 07:26:50 +0000
Received: ("Tessian outbound ff098c684b24:v54"); Mon, 27 Apr 2020 07:26:50 +0000
X-CR-MTA-TID: 64aa7808
Received: from 844878ed3a3a.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 924A14B0-59A8-4036-9B31-0F79AAACCC5D.1;
        Mon, 27 Apr 2020 07:26:45 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 844878ed3a3a.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 27 Apr 2020 07:26:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzkY+f7Ucb3iWmGXimD6dt6DK+cMXH69LOleKDGFhK1EvTA1zv8w6LyuFDPZclz92QcFgoLdEDXdrqAkWl5qC0b5CGHx8XLT9rmdBqYNOb7ku/yBfLyc+lTafcCJPR6PHw19haMQfnECqff5NDawoZJQkDhOJi2F2V4k9gTrbCvNhWOeo3C//ZP722uIf2sOip73yEdGkyeEHbgOhHqFdGpLquTS2iNtMCo/Jzc5v6HGH8X3PdXl4I70Q+USVLM7S2vbNzKEFevcK3KWydT0Vtgqqbaz7iZCnhb7imEhI/mcII7aDPBlEvw5Poauv7lDI8zoRXRPeYPY4kjzAuqEVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtnAvDoin0FjTGa6HPADEx1cLKRMV9FQRXiKvmqI0Z0=;
 b=hltlw4KM4N/Be0eP4ys2j1VyqKa/B4ChBpce7TIjEOixRxJdsTVb0T8iiXATq4oFdn5Nr09mgPRkka/eWAwlfdzygOnwoAtTtKra9NQe4kgHaiOID2mIaBPNgBEvSXsr+W9P+SgeZ7KchpFokNDSU+ZpjhyKOX88V4UMa2rEqW93DdhyYyyvJbsZtpTFINWSikH87I1j3uUm2F9xgP1GRMW1f9vlSnHRjl5rXFCebZDSDwloEzjXShZY575gVpUs/Y1z+pGvDbY374lI7WG64W4u4mYKypCLpBZWT+zHVR34x9nNSjKbK3P62aRhITWs9b/Yr2aKx1O94DJNFIVvsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtnAvDoin0FjTGa6HPADEx1cLKRMV9FQRXiKvmqI0Z0=;
 b=0Vd/6Uco+G1dH2FPKvtoLH85JsU/0dMwsauXqeH3CkmJt+3R88NwYzGGPyRzqxof4IkbzEBCTO3sQV0M48caOQ1Oq0LnZ7Uau7iYbkF98/9rW1mI2UfZyu/N0cCoCW8ROSYo9qLt/DJcswKAnggp30Rc+uryLlDUZpxrjJfZExY=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2247.eurprd08.prod.outlook.com (2603:10a6:4:83::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 07:26:44 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 07:26:44 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH 2/3] hwrng: cctrng - change default to n
Thread-Topic: [PATCH 2/3] hwrng: cctrng - change default to n
Thread-Index: AQHWHFaa2ILie1hr/Ua7OdXaSVzplaiMigqAgAAGr1A=
Date:   Mon, 27 Apr 2020 07:26:43 +0000
Message-ID: <DB6PR0802MB25334429B7DD333780E7BABBE9AF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1587966099-28139-1-git-send-email-hadar.gat@arm.com>
 <1587966099-28139-3-git-send-email-hadar.gat@arm.com>
 <CAMj1kXGwVZiGbsT2NwWTyka0FVZnQcmfMSeoBKD03PdC=fRZeA@mail.gmail.com>
In-Reply-To: <CAMj1kXGwVZiGbsT2NwWTyka0FVZnQcmfMSeoBKD03PdC=fRZeA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: eb895bf0-7312-4fb1-81c4-e0fef901dfea.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 475497e9-3b83-4fc2-1157-08d7ea7c5a6f
x-ms-traffictypediagnostic: DB6PR0802MB2247:|DB6PR0802MB2247:|AM6PR08MB4818:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB4818DEC6D3787A323A485402E9AF0@AM6PR08MB4818.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:5236;OLM:5236;
x-forefront-prvs: 0386B406AA
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(316002)(81156014)(54906003)(9686003)(8936002)(55016002)(33656002)(52536014)(6506007)(478600001)(8676002)(76116006)(2906002)(6916009)(66446008)(86362001)(4326008)(7696005)(66556008)(7416002)(66476007)(66946007)(5660300002)(186003)(64756008)(71200400001)(26005)(129723003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: gB5MN+cIsguEVvATJYCybIuN1dYHACmP566g9voRR47srC1/8gF5lheRSN1fMikq3MdD24Xt/8mus/o0RpJNG2SSj5aRa6GqwocjeetbQShfF3wHfBGdqDHQGKYn6Uc3P+8EyXJvbQB8wNY2oc09yh/nD199xYDAfY73DX7RTK+WGFWFiaBFfjwty/3r5VAMnoNj8I1Cu1xhcT4heF/2bS5ae6zf4MC+B4jjvfSOx3KaVid68P5gS4TPohPAf89+acNEH8HVI7TiF/hBRq9ewnBk6C2vpcscBnr/+SPI4jgolGJOo/++SgFDdyMEx/L8KccCXEtbEsOV+zyTUyKwfm5vH5fKI/+KX7qsPW0BaxNDe/oXzAIrMGjaHhbNd0Ygr6irBCHSeOXMUq6BL/kDS5WNQ0aAPlrlTIAoxMzO6HOUQZ5pJOVfcFHwjXDo+cPJuSpX/Ckkeh1CGcP5SfAAc0zBwTRC57ZvxiCnnA5O/EwjTu0gV1bBTUFgoOjOPqP6
x-ms-exchange-antispam-messagedata: r7d7zKJtYJPVA1OPDhkO6GTjazH3K58s8ieYsQc+bCN9R8pjVplyyk7f4fS1YsH0kGGJYFVQf53u4PnEnL1vG/rG6qfzaOOVx59L6RHKFIARP8DoPoOUZQxfFIxgZHJg1O0om1+llBRMy6Wf1gRIcMfmULBV5YqXbqNHo7z45W3y+muXd8W1tBAdaOq/LuovNrqY2OfXX76RxxpaNoG8gimR47eEOcNoB5B28rTMDw0wbiWU9XkrmwVdmWzd2EHC8dw2g6s8tY3kevhVjy8ztaFA/AC6pJLJsS7rYs5PApMrMK1kruqvqrGloq3E86EgV4bDjUQORKIWMWNTNSejQOwsTgTA8gP+XeLe5cTe6cHk9gzV1uouBtH/RIQc+n9dRrUYUzK39EOfC5kdjn1mYZeSYIijTb24FeMSo/rjti5GcTG82Zh7xC0DBnTWVt57dGav6TzZ1vK52MvweyILVEbRQ9kcbhod55r8Br3tM4YKkIcN3RmdQIteJKV7NXMCekk3kwEunQYI+EqZw5g5ev15R3a2AFnAAKZUzUa826XbY75YBkT9yRaVAF9QiDeDr8nMk86dHzXxqhobovu+gdwKBqSvhfHOw7zCfZLOG+yMDewr2ioImZBznyc7RnF+mF+G5INzDmaT7M5WAbdd7CWLKsxg0d327qPOUzHoCVcaM/Na9KvE5xHE1Xd7DBN9PV7vRyke4bqgkKz+A7x1LiSfuOd08tnNCESbIu5Ai0XQnNTX7GkEcoi/NVk/NxwDj+7+2sh7JgoG/I4YkIU4jTyLYor7eRuQOKTvAF7uwKI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2247
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT023.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(46966005)(36906005)(70206006)(5660300002)(7696005)(6506007)(26005)(2906002)(336012)(70586007)(186003)(9686003)(55016002)(8676002)(86362001)(450100002)(4326008)(81156014)(8936002)(33656002)(82740400003)(47076004)(478600001)(54906003)(52536014)(316002)(6862004)(82310400002)(356005)(81166007)(129723003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: c9a44599-5132-4602-141f-08d7ea7c5641
X-Forefront-PRVS: 0386B406AA
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVhkWyfBfUesJEqhvKqT9B741C7UKAw+ccdeRLpkyaTPtclQ/IgkWrsLVIC0ALiYcaz5HAqAdZFC7KO4NA0a5JnH0bKOi3nqQZ6l+NRKnrxS9fOIPlBV9Z5RhYq6mD2uNwPWrULixe87S+3zZMKpViMfY4dw+9bbi3GlHv3eMLXWXvJjyZpWbTZnIAuo0dKh7+H+jbMA2Mr+UyBTbv1nd7Zts7b5jLZ0WE9PADS607x0tN6V8HCG3Vl0yu2K138g2a12/Uncu5R7w6gqPoK/c73iI7OekuIlC4ft2pk+AKhn4SMy3rmGJYYPc77i9iinORG4MXYnvGD/fBWHtB3Ecq1Bl18jMwEGHHP5UvYYyg226cfoWyQmnBJAayjA7yw+V2fQdrZdc2D22EjAcTUoSK1X6LPdqCtO2ivJZf72PHFF9vOhkwhKR+v2INpuuQ7y8e+/zSdsGEGiS4aLcnMmjfeTDdrj4f6FUqOEgs0Kxnxrs0SC/mC2OZm53O7DhrfudmfnklGY6DrUzxcyncPcdekBskRgJHIvfFsnI4bA21Y=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 07:26:50.8697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 475497e9-3b83-4fc2-1157-08d7ea7c5a6f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4818
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFyZCBCaWVzaGV1dmVsIDxh
cmRiQGtlcm5lbC5vcmc+DQo+IA0KPiBPbiBNb24sIDI3IEFwciAyMDIwIGF0IDA3OjQyLCBIYWRh
ciBHYXQgPGhhZGFyLmdhdEBhcm0uY29tPiB3cm90ZToNCj4gPg0KPiA+IEZvciBtYW55IHVzZXJz
LCB0aGUgQXJtIENyeXB0b0NlbGwgSFcgaXMgbm90IGF2YWlsYWJsZSwgc28gdGhlIGRlZmF1bHQN
Cj4gPiBmb3IgSFdfUkFORE9NX0NDVFJORyBjaGFuZ2VkIHRvIG4uDQo+ID4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBIYWRhciBHYXQgPGhhZGFyLmdhdEBhcm0uY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2
ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWcgfCA0ICsrLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWcNCj4gPiBiL2RyaXZlcnMvY2hhci9od19yYW5k
b20vS2NvbmZpZyBpbmRleCBkZjJkMDAxLi4wOTM4ZDNkIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZl
cnMvY2hhci9od19yYW5kb20vS2NvbmZpZw0KPiA+ICsrKyBiL2RyaXZlcnMvY2hhci9od19yYW5k
b20vS2NvbmZpZw0KPiA+IEBAIC00NzYsOCArNDc2LDggQEAgY29uZmlnIEhXX1JBTkRPTV9LRVlT
VE9ORQ0KPiA+DQo+ID4gIGNvbmZpZyBIV19SQU5ET01fQ0NUUk5HDQo+ID4gICAgICAgICB0cmlz
dGF0ZSAiQXJtIENyeXB0b0NlbGwgVHJ1ZSBSYW5kb20gTnVtYmVyIEdlbmVyYXRvciBzdXBwb3J0
Ig0KPiA+IC0gICAgICAgZGVwZW5kcyBvbiBIQVNfSU9NRU0gJiBPRg0KPiA+IC0gICAgICAgZGVm
YXVsdCBIV19SQU5ET00NCj4gPiArICAgICAgIGRlcGVuZHMgb24gSFdfUkFORE9NICYgSEFTX0lP
TUVNICYgT0YNCj4gDQo+IFRoZSB3aG9sZSBibG9jayBpcyBndWFyZGVkIGJ5IGlmIEhXX1JBTkRP
TSwgc28gSSBkb24ndCB0aGluayB5b3UgbmVlZCB0aGUNCj4gZGVwZW5kZW5jeSBoZXJlLg0KPiAN
Cj4gPiArICAgICAgIGRlZmF1bHQgbg0KPiANCj4gJ2RlZmF1bHQgbicgaXMgdGhlIGRlZmF1bHQg
c28geW91IGNhbiBqdXN0IHJlbW92ZSB0aGUgbGluZQ0KDQpJcyB0aGlzIGEgZ3VpZGVsaW5lIG9y
IGp1c3Qgb3B0aW9uYWw/DQpQZXJzb25hbGx5IEkgbGlrZSB0aGluZ3MgdG8gYmUgZXhwbGljaXQg
YW5kIGlmIGFsbG93ZWQgSSBwcmVmZXIgdG8ga2VlcCB0aGlzIGxpbmUuDQoNCj4gDQo+ID4gICAg
ICAgICBoZWxwDQo+ID4gICAgICAgICAgIFRoaXMgZHJpdmVyIHByb3ZpZGVzIHN1cHBvcnQgZm9y
IHRoZSBUcnVlIFJhbmRvbSBOdW1iZXINCj4gPiAgICAgICAgICAgR2VuZXJhdG9yIGF2YWlsYWJs
ZSBpbiBBcm0gVHJ1c3Rab25lIENyeXB0b0NlbGwuDQo+ID4gLS0NCj4gPiAyLjcuNA0KPiA+DQo=
