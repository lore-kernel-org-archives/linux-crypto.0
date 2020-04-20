Return-Path: <SRS0=BVES=6E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A3BC3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 08:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3929206F6
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 08:36:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="TVX8vxb6";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="TVX8vxb6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgDTIgP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Apr 2020 04:36:15 -0400
Received: from mail-eopbgr40056.outbound.protection.outlook.com ([40.107.4.56]:54558
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbgDTIgP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Apr 2020 04:36:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKUny08rULfaqJ2AxLIr0+m7ab6+iAsWbuHw21TypBU=;
 b=TVX8vxb631dv89eFE9XusE+sYTrbgB0/f6mOyDnOWhNwXvaK+tb7XTlOgJzcALQ8SAyopqplHxrWfFoMEDaHCXo6Sdejvefp0Zj3fDngHDg/57dt1dFyWQGcYQvz+XOVBNFNKQ30U1fIq44pSReaeybSfxwQbKNlYDDcp30KjIc=
Received: from AM0PR10CA0003.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::13)
 by DB8PR08MB4137.eurprd08.prod.outlook.com (2603:10a6:10:a5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 08:36:10 +0000
Received: from AM5EUR03FT013.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:208:17c:cafe::d4) by AM0PR10CA0003.outlook.office365.com
 (2603:10a6:208:17c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend
 Transport; Mon, 20 Apr 2020 08:36:10 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT013.mail.protection.outlook.com (10.152.16.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.18 via Frontend Transport; Mon, 20 Apr 2020 08:36:09 +0000
Received: ("Tessian outbound 7626dd1b3605:v53"); Mon, 20 Apr 2020 08:36:08 +0000
X-CR-MTA-TID: 64aa7808
Received: from 3da6ffa57ef2.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 19296927-0A15-4D87-9F3D-836708647E5C.1;
        Mon, 20 Apr 2020 08:36:03 +0000
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 3da6ffa57ef2.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 20 Apr 2020 08:36:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IuenYH+7DEJjgqiqiAbW7LcnAOKmxU78MIXuCSU7S77VnvGsW1e6VVEyF7yu1UzEQc55XWBUw1wiimTHw8NoJqCXewvEHDrS6QpYG1uXg0c/8pRblYF1Vm8prwnpYxL0wtAYTTzmdp41Kg8m6LkXC8Ny0bY+hAej9xqob6vSUh5Ftk7UQfW4YlwLNgrY1EbpY0m1Jew2vOioh0tqvj2dIltIavCCwOWRFAmFn4xQJsGjszFDXXoYFwR8Lqp11UEFJpsoQP4XevtXEIudLRrxKvmXxso4LTIKknSdjK5wgr1wHpqoChaz2xkTOjoejDUjoleNH/awSGLkao7K8rGZHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKUny08rULfaqJ2AxLIr0+m7ab6+iAsWbuHw21TypBU=;
 b=FagiOZib1/Cs9N5cQ7dFvTpW2G1/3JiVXKjNqdoyuabzMqGV6bMn/UReJ0EBDUhaFgvqGR3DZyZCnPIw57UqTJJFW2hrOP0NAy5R0Dm1VTomfagrN5tzr5RRY8on76evv5pofPGtsH3rBakuBlBIWkSHAH2QiL8zWX0Cawj1aPXn1wtQyiZY5YL6EZzYljybZvmUHSN/MGf7tgVTrWwN1MDFPD5UxFyUi1CzaVC1MMGqdnGh/rpWmKhwgj73h0g7ghCFOu2P2BCmGCyAedAMqklDERxDOR9BI/bmAY9G6xCMg7r5kCajJ4S2Nk/yPA854a6MN9zCQ2Ob2Abz2nMGBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKUny08rULfaqJ2AxLIr0+m7ab6+iAsWbuHw21TypBU=;
 b=TVX8vxb631dv89eFE9XusE+sYTrbgB0/f6mOyDnOWhNwXvaK+tb7XTlOgJzcALQ8SAyopqplHxrWfFoMEDaHCXo6Sdejvefp0Zj3fDngHDg/57dt1dFyWQGcYQvz+XOVBNFNKQ30U1fIq44pSReaeybSfxwQbKNlYDDcp30KjIc=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2295.eurprd08.prod.outlook.com (2603:10a6:4:84::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 08:36:01 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 08:36:01 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        nd <nd@arm.com>
Subject: RE: hwrng: cctrng - Remove unnecessary FIPS ifdef
Thread-Topic: hwrng: cctrng - Remove unnecessary FIPS ifdef
Thread-Index: AQHWFu24VTjJ/WWCbEGa+L6KYtPxv6iBrsIw
Date:   Mon, 20 Apr 2020 08:36:01 +0000
Message-ID: <DB6PR0802MB2533B88B20AC4BDEF5955818E9D40@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1587155926-32663-1-git-send-email-hadar.gat@arm.com>
 <20200420082819.GA23022@gondor.apana.org.au>
In-Reply-To: <20200420082819.GA23022@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 99d0c58d-639d-4f0a-ab44-60e474717119.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4fc7a2f0-46df-4531-76ed-08d7e505e006
x-ms-traffictypediagnostic: DB6PR0802MB2295:|DB6PR0802MB2295:|DB8PR08MB4137:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB413747994A0796C8B728E9B1E9D40@DB8PR08MB4137.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:580;OLM:580;
x-forefront-prvs: 03793408BA
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(52536014)(71200400001)(2906002)(81156014)(8676002)(8936002)(33656002)(66946007)(7696005)(966005)(26005)(76116006)(6506007)(53546011)(83080400001)(66476007)(66556008)(64756008)(5660300002)(66446008)(4326008)(6916009)(55016002)(86362001)(9686003)(54906003)(478600001)(186003)(316002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: FXVLE4VNKYqSUbGKcxd47AzdUfOfyAImqYCNFzqZoopkN0+mHrqw8hysDCMHo3wAUuC5Z35xeD9UlIqJkSv3M5+Zuz7CjiYhd9V0Duh9S9LQY+8XJefVp4QFKwSCIpndaFRuXpgY6vMKGmn8j3dXxvwyTb9ybQq1XQghjOry7oQz2y9Yfory7F5MQqs/aZRVNe8TtJARjdhcB5otkGk6+6myfy0h0Rm+f9thvYZQz7kgzS4mDxdr/nIqMBlULOYZtBokc3G0LC38rogzEjVkjREq4O8gJ8e0cmsTaxe9qDNbysp/hAegdf3Y91AehaTvE7lRw7Q49MxiOjaGfBxQJG1e+wNj9Kiixm26J29p4IxKxWWZzHd70nxvTmsfcu3Pf8PVixsubwtikkIqq+meeNV+NR0RX7YJHUHD2F+hgK5D3fhyw4f/Bn8UvDtJttdTv2FIcMOhm6FQB/8DRi2jvHcUaRS4xAWJZMh6XKbv6sqfuptxEH1EbRNUuEuE1dW20vsOINqZruOIuZ3JsIbmRA==
x-ms-exchange-antispam-messagedata: c5/nr+a78DkCHGr/+OHtXd5+Td4zGUqjP+JmLp/IZbSDZnuzVoBvm9TOoKsu5ChpycLmiUoLmVoYdXeTmwVQtq3rGUAKZbf3F0gqaOv+A7sfL1dlnlevZYs5rHqzVzCJsXEeT4Yj00CimW/CbpJv9g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2295
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(346002)(46966005)(70206006)(70586007)(5660300002)(336012)(9686003)(83080400001)(47076004)(81166007)(356005)(52536014)(33656002)(54906003)(7696005)(2906002)(4326008)(450100002)(478600001)(6862004)(8936002)(36906005)(26005)(8676002)(81156014)(86362001)(316002)(82740400003)(966005)(6506007)(53546011)(186003)(55016002);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: a48e8821-f752-48bb-54b4-08d7e505db82
X-Forefront-PRVS: 03793408BA
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SgyA2CC/3j0L4fVmHQ6cfDKpmALzlaoXg9iOypQzqtLQZeocNCWvs8SuS0a9d202ILp04laGVDhtq/0fF+XzYy/pZxFqNw1KZLtVTTWtNyLTFAlSIuwgFnW5dmOSYJYJB2LS/GdvnZVO4c790AYl0p+i+Y7uNBxBpUuJvJk0gZhtplQ0pf9jGbpLbPa1M7NhJTEQ0jjdBEBk1JtrKi1zpgtHbtCjetYnKcMB+o+iL4GCOFUvITbZDdyR2Zl5bDESh/EmkROIIsCcQPCGf1euO8KYHnLzrHI8irJ4IgI8qJRawx24iVQVrYDge/me1C/dRLWw45/j9HY2Bd+JssyG1WuJwMzZV5SfTocgrLwJPQzXxlXyavhJuMQFKecQXqip3x30ojFxwo7lEKehNYZ/ZdgpcZtfuPZ3RazKoVeGxdUrw6ek4MQAgHuJ5YVUlDYg9xUknxmI6CFln6uT9SYKF2zQc1JcC55/gG7hRJwg44DdJC3Nl9OItg3Kvw6uUe6MOF9VvKBNmjHIioQ8E2xVmejL6YTrMWuioPk3DvYj2xGdh7rGLv4YUoO1KTFS/lTwaR5K779WAAxtmcgktZaUEt6DsWl83fBS3Cr6ZZNk+gw=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 08:36:09.1360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc7a2f0-46df-4531-76ed-08d7e505e006
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4137
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhlcmJlcnQgWHUgPGhlcmJl
cnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4gU2VudDogTW9uZGF5LCAyMCBBcHJpbCAyMDIwIDEx
OjI4DQo+IFRvOiBIYWRhciBHYXQgPEhhZGFyLkdhdEBhcm0uY29tPg0KPiBDYzogTWF0dCBNYWNr
YWxsIDxtcG1Ac2VsZW5pYy5jb20+OyBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPjsNCj4g
R3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47IEdpbGFkIEJl
bi1Zb3NzZWYNCj4gPGdpbGFkQGJlbnlvc3NlZi5jb20+OyBPZmlyIERyYW5nIDxPZmlyLkRyYW5n
QGFybS5jb20+OyBsaW51eC0NCj4gY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBod3JuZzogY2N0cm5nIC0gUmVtb3ZlIHVubmVj
ZXNzYXJ5IEZJUFMgaWZkZWYNCj4gDQo+IFRoaXMgcGF0Y2ggcmVtb3ZlcyB0aGUgdW5uZWNlc3Nh
cnkgRklQUyBpZmRlZiBpbiBjY3RybmcuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIZXJiZXJ0IFh1
IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+IA0KDQpBY2tlZC1ieTogSGFkYXIgR2F0
IDxoYWRhci5nYXRAYXJtLmNvbT4NCg0KDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NoYXIvaHdf
cmFuZG9tL2NjdHJuZy5jDQo+IGIvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9jY3RybmcuYyBpbmRl
eCBlODI3MTZjMTJjM2EuLjQ5ZmI2NWEyMjFmMw0KPiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9j
aGFyL2h3X3JhbmRvbS9jY3RybmcuYw0KPiArKysgYi9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2Nj
dHJuZy5jDQo+IEBAIC0zMzEsMTMgKzMzMSwxMSBAQCB2b2lkIGNjX3RybmdfY29tcHdvcmtfaGFu
ZGxlcihzdHJ1Y3QNCj4gd29ya19zdHJ1Y3QgKncpDQo+ICAJZWhyX3ZhbGlkID0gQ0NfUkVHX0ZM
RF9HRVQoUk5HX0lTUiwgRUhSX1ZBTElELCBpc3IpOw0KPiAgCWRldl9kYmcoZGV2LCAiR290IFJO
R19JU1I9MHglMDhYIChFSFJfVkFMSUQ9JXUpXG4iLCBpc3IsDQo+IGVocl92YWxpZCk7DQo+IA0K
PiAtI2lmZGVmIENPTkZJR19DUllQVE9fRklQUw0KPiAtCWlmIChDQ19SRUdfRkxEX0dFVChSTkdf
SVNSLCBDUk5HVF9FUlIsIGlzcikgJiYgZmlwc19lbmFibGVkKSB7DQo+ICsJaWYgKGZpcHNfZW5h
YmxlZCAmJiBDQ19SRUdfRkxEX0dFVChSTkdfSVNSLCBDUk5HVF9FUlIsIGlzcikpIHsNCj4gIAkJ
Zmlwc19mYWlsX25vdGlmeSgpOw0KPiAgCQkvKiBGSVBTIGVycm9yIGlzIGZhdGFsICovDQo+ICAJ
CXBhbmljKCJHb3QgSFcgQ1JOR1QgZXJyb3Igd2hpbGUgZmlwcyBpcyBlbmFibGVkIVxuIik7DQo+
ICAJfQ0KPiAtI2VuZGlmDQo+IA0KPiAgCS8qIENsZWFyIGFsbCBwZW5kaW5nIFJORyBpbnRlcnJ1
cHRzICovDQo+ICAJY2NfaW93cml0ZShkcnZkYXRhLCBDQ19STkdfSUNSX1JFR19PRkZTRVQsIGlz
cik7DQo+IC0tDQo+IEVtYWlsOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcu
YXU+IEhvbWUgUGFnZToNCj4gaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUvfmhlcmJlcnQvDQo+
IFBHUCBLZXk6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1L35oZXJiZXJ0L3B1YmtleS50eHQN
Cg==
