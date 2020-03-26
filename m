Return-Path: <SRS0=nygc=5L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448AAC43331
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 21:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 063A020722
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 21:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3saDCgCV";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3saDCgCV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgCZVFC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Mar 2020 17:05:02 -0400
Received: from mail-eopbgr50064.outbound.protection.outlook.com ([40.107.5.64]:38981
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726034AbgCZVFC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Mar 2020 17:05:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FP+2lS8bF0sHuDT4u5TzFWOYfFBJSsYuWj92bBVHG2I=;
 b=3saDCgCVG/b0Ci2jZZbmllpuMjeVBU1MFak2yMtQatWoUaoTMqWqrGTjBu4/yBPDcNR2cNcQc0RPpkorYDLjRAFmJqiCSWqtAUzaukVvSBMNyiXzmh3w1w51ogG2htCy8WU8xYW+1cenFsMcpxZwRjufuoIdu+UHbot7N0IXxlM=
Received: from AM6PR0502CA0041.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::18) by HE1PR08MB2922.eurprd08.prod.outlook.com
 (2603:10a6:7:2e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18; Thu, 26 Mar
 2020 21:04:56 +0000
Received: from VE1EUR03FT049.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:56:cafe::85) by AM6PR0502CA0041.outlook.office365.com
 (2603:10a6:20b:56::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend
 Transport; Thu, 26 Mar 2020 21:04:56 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT049.mail.protection.outlook.com (10.152.19.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.17 via Frontend Transport; Thu, 26 Mar 2020 21:04:55 +0000
Received: ("Tessian outbound 19f8d550f75c:v48"); Thu, 26 Mar 2020 21:04:54 +0000
X-CR-MTA-TID: 64aa7808
Received: from 0828dc4339ba.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2E8B5DF1-C45C-40C7-971F-75E6B1DB6F60.1;
        Thu, 26 Mar 2020 21:04:49 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0828dc4339ba.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 26 Mar 2020 21:04:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGwIWI2nYktu8e22FJG0Y2Jrgu18KC3GetXelU1o3F78i8I9VUvGnlikNWTJHc9m37hv2m/wFtndixFFQ0p49ZmQjRMk4AR7wh5gKyimTWGURoCjpDOLXfOVxIYDjG4ZDKa+fs6UnBNE5Kzj2sQ8ntr/9CP3lXxaRp0nf8nKsNyCexWJ9GPEmQFN9oHNc+wMdp+gsGFoM3AyJob/qa4VEqqw2//JB9TEqk0ZZqdL7LbZhoq1vMHYJbPFUVPf0yW6Ua/Xtjoj8cNLLpdk54ATAJVbHLQC73gwYOhMtbQG9aFZZpoC9IfT9OZFJBMLtzSsw6p0iRgvxl/NNUebDnW3Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FP+2lS8bF0sHuDT4u5TzFWOYfFBJSsYuWj92bBVHG2I=;
 b=bMZNgm/s2du6mVHxOt9owA6uqhfstHkTY701g+QBdmuIYOQBrtOYCuPCFYHTubmYF7fUpL+jNUKJYlo8cdXsS78y9hUIsuOdA5MYNVIA/PHucVqglOdvEYu+lvXu2ANh8k88rTOqFT7IjeJlp5FZiNOays1YEZlbEi/BrBM2cEcafydfxivSe+r2KphgzjLrS6qDCYiTrhYV8ynRMEqAjMQCMXtDAni49jBkFpnZQS0KByvQ/95j+9UlKQGhmjMpw73OIthyZOT8nI4ZiSWKq1GmHWEOQFmY3vRkuSz9YqJ0Z5lMtYyFPN38QrG0uDgvuzEqn1s6KpNvvleBCDyfgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FP+2lS8bF0sHuDT4u5TzFWOYfFBJSsYuWj92bBVHG2I=;
 b=3saDCgCVG/b0Ci2jZZbmllpuMjeVBU1MFak2yMtQatWoUaoTMqWqrGTjBu4/yBPDcNR2cNcQc0RPpkorYDLjRAFmJqiCSWqtAUzaukVvSBMNyiXzmh3w1w51ogG2htCy8WU8xYW+1cenFsMcpxZwRjufuoIdu+UHbot7N0IXxlM=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (10.172.251.12) by
 DB6PR0802MB2405.eurprd08.prod.outlook.com (10.172.250.146) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Thu, 26 Mar 2020 21:04:47 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 21:04:46 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Rob Herring <robh@kernel.org>
CC:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v6 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
Thread-Topic: [PATCH v6 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
Thread-Index: AQHWAmlNswbggjo5C0ax1OwFJnwkKqhbSCYAgAAVluA=
Date:   Thu, 26 Mar 2020 21:04:46 +0000
Message-ID: <DB6PR0802MB25334E308B8D4B10D2562460E9CF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1585114871-6912-1-git-send-email-hadar.gat@arm.com>
 <1585114871-6912-2-git-send-email-hadar.gat@arm.com>
 <20200326194104.GA4118@bogus>
In-Reply-To: <20200326194104.GA4118@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 79191cee-f11a-49dd-a654-4d9df06f7a87.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [217.140.99.251]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7abe1b99-e2c2-48af-0e7a-08d7d1c9563c
x-ms-traffictypediagnostic: DB6PR0802MB2405:|DB6PR0802MB2405:|HE1PR08MB2922:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <HE1PR08MB2922261068CE845E34293F29E9CF0@HE1PR08MB2922.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:7219;OLM:7219;
x-forefront-prvs: 0354B4BED2
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(5660300002)(6916009)(33656002)(26005)(86362001)(4326008)(54906003)(7696005)(186003)(52536014)(966005)(7416002)(2906002)(316002)(6506007)(71200400001)(8936002)(9686003)(66476007)(66946007)(81156014)(64756008)(81166006)(66556008)(478600001)(55016002)(8676002)(66446008)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0802MB2405;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: xg2kRP8YK7tGt4KbL4OeOJEv+NnjsLzkQC05Oa+nVMJP463Bb12ickhwvgUS4gog4+kbZxZDBzTsSmpycz+1xV6IXmmnOD448vXdlnirBYxy8jxOb/lijda8cM+04lGrEu4czIUgMFySPhEtyg+iMwdHvTlANE+knQMnXn9j9gPo2bE1GJxxtw+cZPpo1yn7+0gu3AXaunL9RaUf4N4sNfXqoOn8o505xGvmEzxMjNvdDyp2o/GbeQMZ9bo3+6VAjeoq6WHMzFUUKDAPKpctqtywXTpB0wJMA/Zr44L+/b4Sp/7+096N3QT/qLC/1QnRGPny7wIIlKgBdRK3piaoENRoGTlZO/AUKyedrNTVfLlWdUAEY8F/B6DJ+QCyfQvJNwC8FpNzuqVkS4rtIaCDLlsrLH+I9PLP42vILbxmZtFHh6uOvv7mdcgToOmzXPIlyO2antcaXYkBSN9kvueDi2OKgguVNYCYtgvXoM6xPYogsTmSA9i6/ngT5XgonTRxpw5j2WSmpMBYWbxEXEaETw==
x-ms-exchange-antispam-messagedata: WdryqnIrIu0vfVB2jpmYxELOsvZxiLggO3GC/n7IbmorM/8OGMZV5hCPmKfYgRaMpzzZJIi1TezMwImfDigpCJNZDtoyeD9W/1p9n9A9IcsMh57saokIKcf4KDQuOZhj8d2LmkStOFbgBcawH27vuA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2405
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT049.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(376002)(136003)(46966005)(356004)(6862004)(52536014)(4326008)(55016002)(186003)(81156014)(8676002)(8936002)(70586007)(5660300002)(86362001)(70206006)(336012)(81166006)(54906003)(26005)(2906002)(82740400003)(36906005)(450100002)(47076004)(9686003)(316002)(478600001)(966005)(26826003)(6506007)(7696005)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR08MB2922;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;
X-MS-Office365-Filtering-Correlation-Id-Prvs: eeae2c37-a5f5-4e3f-b38f-08d7d1c950b8
X-Forefront-PRVS: 0354B4BED2
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TO6edBTUjh8LMnbYY5KYCUdfPXW0CD/6YgtKBY1tjdmTmx/0GpcNe36Y9u+zMUAcQ2u49pyiII/5eQPG0TMYAZDzrj7cWSs4NnJWdj0CQ80Sen6it8kXFPaLWehN/YItYgAHkqvNGGLaBb/EBB5LRH/WFWGCynqtZ0OQGCLbQ2Y6FNzfDHe4saFd6YNkLE7UX/ZQt1UJBHvsFDHbrW4pdphTGqyNkOWvtmWmJJ0dncAiVMtHqcE2yyMw136S15ZPLfjs+8NOqXd4R544iGqfi9TxGjGrz+nMrboJ/xs6+njcFPuLwJk0Fv6lnfnCYZWylkltHsYkwD1cm3KuexLa+BpFenvhf7NJRrd4tEsmMvPz7VuDuBeIx4r17qKfC8vTRZe9GLxTBv63p5KbUW/9tQdfUbtIGFOD1RRkow2KNoxIRHcAQwWLJH8G3d1TTw2uxCQQFALUVSxmk0K9uVh2jyxnOA5kFmAU8PmPr5bGWdyz12wt4mJOBaCUGeUNHvs8sKkJWSvW89Q6W+rr1CrYq8vwPkZOudoQHGmwdaMgvsXHzsr0nRkyOEXcG81EdBjV6yR0/PD29yI14QkBoFymTw==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 21:04:55.9794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7abe1b99-e2c2-48af-0e7a-08d7d1c9563c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR08MB2922
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgUm9iLA0KDQo+IA0KPiBPbiBXZWQsIE1hciAyNSwgMjAyMCBhdCAwNzo0MTowOUFNICswMjAw
LCBIYWRhciBHYXQgd3JvdGU6DQo+ID4gVGhlIEFybSBDcnlwdG9DZWxsIGlzIGEgaGFyZHdhcmUg
c2VjdXJpdHkgZW5naW5lLiBUaGlzIHBhdGNoIGFkZHMgRFQNCj4gPiBiaW5kaW5ncyBmb3IgaXRz
IFRSTkcgKFRydWUgUmFuZG9tIE51bWJlciBHZW5lcmF0b3IpIGVuZ2luZS4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEhhZGFyIEdhdCA8aGFkYXIuZ2F0QGFybS5jb20+DQo+ID4gLS0tDQo+ID4g
IC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL3JuZy9hcm0tY2N0cm5nLnlhbWwgICAgICAgIHwgNTUN
Cj4gKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNTUgaW5zZXJ0
aW9ucygrKQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gPiBEb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3Mvcm5nL2FybS1jY3RybmcueWFtbA0KPiA+DQo+ID4gZGlmZiAtLWdpdCBh
L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcvYXJtLWNjdHJuZy55YW1sDQo+
ID4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mvcm5nL2FybS1jY3RybmcueWFt
bA0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMC4uN2Y3MGU0Yg0K
PiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3Mvcm5nL2FybS1jY3RybmcueWFtbA0KPiA+IEBAIC0wLDAgKzEsNTUgQEANCj4gPiArIyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogKEdQTC0yLjAgT1IgQlNELTItQ2xhdXNlKSAlWUFNTCAx
LjINCj4gPiArLS0tDQo+ID4gKyRpZDogaHR0cDovL2RldmljZXRyZWUub3JnL3NjaGVtYXMvcm5n
L2FybS1jY3RybmcueWFtbCMNCj4gPiArJHNjaGVtYTogaHR0cDovL2RldmljZXRyZWUub3JnL21l
dGEtc2NoZW1hcy9jb3JlLnlhbWwjDQo+ID4gKw0KPiA+ICt0aXRsZTogQXJtIFRydXN0Wm9uZSBD
cnlwdG9DZWxsIFRSTkcgZW5naW5lDQo+ID4gKw0KPiA+ICttYWludGFpbmVyczoNCj4gPiArICAt
IEhhZGFyIEdhdCA8aGFkYXIuZ2F0QGFybS5jb20+DQo+ID4gKw0KPiA+ICtkZXNjcmlwdGlvbjog
fCsNCj4gPiArICBBcm0gVHJ1c3Rab25lIENyeXB0b0NlbGwgVFJORyAoVHJ1ZSBSYW5kb20gTnVt
YmVyIEdlbmVyYXRvcikNCj4gZW5naW5lLg0KPiA+ICsNCj4gPiArcHJvcGVydGllczoNCj4gPiAr
ICBjb21wYXRpYmxlOg0KPiA+ICsgICAgZW51bToNCj4gPiArICAgICAgLSBhcm0sY3J5cHRvY2Vs
bC03MTMtdHJuZw0KPiA+ICsgICAgICAtIGFybSxjcnlwdG9jZWxsLTcwMy10cm5nDQo+ID4gKw0K
PiA+ICsgIGludGVycnVwdHM6DQo+ID4gKyAgICBtYXhJdGVtczogMQ0KPiA+ICsNCj4gPiArICBy
ZWc6DQo+ID4gKyAgICBtYXhJdGVtczogMQ0KPiA+ICsNCj4gPiArICBhcm0scm9zYy1yYXRpbzoN
Cj4gPiArICAgIGRlc2NyaXB0aW9uOg0KPiA+ICsgICAgICBBcm0gVHJ1c3Rab25lIENyeXB0b0Nl
bGwgVFJORyBlbmdpbmUgaGFzIDQgcmluZyBvc2NpbGxhdG9ycy4NCj4gPiArICAgICAgU2FtcGxp
bmcgcmF0aW8gdmFsdWVzIGZvciB0aGVzZSA0IHJpbmcgb3NjaWxsYXRvcnMuIChmcm9tIGNhbGli
cmF0aW9uKQ0KPiA+ICsgICAgYWxsT2Y6DQo+ID4gKyAgICAgIC0gJHJlZjogL3NjaGVtYXMvdHlw
ZXMueWFtbCMvZGVmaW5pdGlvbnMvdWludDMyLWFycmF5DQo+ID4gKyAgICAgIC0gaXRlbXM6DQo+
ID4gKyAgICAgICAgICBtaW5JdGVtczogNA0KPiA+ICsgICAgICAgICAgbWF4SXRlbXM6IDQNCj4g
DQo+IEFyZW4ndCB0aGVyZSBzb21lIGNvbnN0cmFpbnRzIG9uIHRoZSB2YWx1ZXM/DQo+IA0KPiBJ
ZiBub3QsIHRoZW4ganVzdCB0aGlzIGlzIGVub3VnaDoNCj4gDQo+IC0gbWF4SXRlbXM6IDQNCj4g
DQpUaGUgY29uc3RyYWludCBpcyBqdXN0IG9uIHRoZSBhcnJheSBzaXplIGFuZCBub3Qgb24gdGhl
IHZhbHVlcy4NClRoZSBhcnJheSBpcyBvZiA0IGVsZW1lbnRzIGZvciB0aGUgQ3J5cHRvQ2VsbCA0
IHJpbmcgb3NjaWxsYXRvcnMuDQpJc24ndCAnbWluaXRlbXM6JyBpcyBhYm91dCB0aGUgYXJyYXkg
bWluIHNpemU/IElzbid0IGl0IHRoZSB3YXkgdG8gYmxvY2sgbGVzcyB0aGFuIDQgaXRlbXM/IFRo
aXMgaXMgd2hhdCBJIHdhbnQgdG8gZG8uDQpJJ20gYSBiaXQgY29uZnVzZWQgaWYgaXQgaXMgcmVx
dWlyZWQgb3Igbm90Li4NCg0KPiA+ICsNCj4gPiArICBjbG9ja3M6DQo+ID4gKyAgICBtYXhJdGVt
czogMQ0KPiA+ICsNCj4gPiArcmVxdWlyZWQ6DQo+ID4gKyAgLSBjb21wYXRpYmxlDQo+ID4gKyAg
LSBpbnRlcnJ1cHRzDQo+ID4gKyAgLSByZWcNCj4gPiArICAtIGFybSxyb3NjLXJhdGlvDQo+ID4g
Kw0KPiA+ICthZGRpdGlvbmFsUHJvcGVydGllczogZmFsc2UNCj4gPiArDQo+ID4gK2V4YW1wbGVz
Og0KPiA+ICsgIC0gfA0KPiA+ICsgICAgYXJtX2NjdHJuZzogcm5nQDYwMDAwMDAwIHsNCj4gPiAr
ICAgICAgICBjb21wYXRpYmxlID0gImFybSxjcnlwdG9jZWxsLTcxMy10cm5nIjsNCj4gPiArICAg
ICAgICBpbnRlcnJ1cHRzID0gPDAgMjkgND47DQo+ID4gKyAgICAgICAgcmVnID0gPDB4NjAwMDAw
MDAgMHgxMDAwMD47DQo+ID4gKyAgICAgICAgYXJtLHJvc2MtcmF0aW8gPSA8NTAwMCAxMDAwIDUw
MCAwPjsNCj4gPiArICAgIH07DQo+ID4gLS0NCj4gPiAyLjcuNA0KPiA+DQoNClRoYW5rcywNCkhh
ZGFyDQo=
