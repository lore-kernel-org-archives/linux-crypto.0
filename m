Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DFBFC54FCC
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 13:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A0582075E
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 13:16:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="jORgDXet";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="jORgDXet"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgDUNQb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 09:16:31 -0400
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:2838
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728337AbgDUNQa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 09:16:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQ6zXwZctmCuVWr4GhWfbMZhrN+6SvTKPgbc7knxnWY=;
 b=jORgDXetuFx0OH4ypVWgn7O+a3/bFlSdlMtqp33RWCUP/dsfgeuO/PJyEMf6JRy17Gl3+gOhHL3YJoSYTP4CtgIh5BJfrTDfa74p2KGCAQZdxFiBQCitABXc2CAcDg3YudHapo4Z04GsYjnzc8hnfoUkMsswccIjuaZe2/V+VIk=
Received: from DB8P191CA0023.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::33)
 by DB7PR08MB2987.eurprd08.prod.outlook.com (2603:10a6:5:1c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26; Tue, 21 Apr
 2020 13:16:24 +0000
Received: from DB5EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:130:cafe::ff) by DB8P191CA0023.outlook.office365.com
 (2603:10a6:10:130::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend
 Transport; Tue, 21 Apr 2020 13:16:24 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT048.mail.protection.outlook.com (10.152.21.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.18 via Frontend Transport; Tue, 21 Apr 2020 13:16:24 +0000
Received: ("Tessian outbound 43fc5cd677c4:v53"); Tue, 21 Apr 2020 13:16:24 +0000
X-CR-MTA-TID: 64aa7808
Received: from 7d3044218e8e.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 5599B1C7-39D0-4F44-B25E-11D98320A4C2.1;
        Tue, 21 Apr 2020 13:16:19 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 7d3044218e8e.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 21 Apr 2020 13:16:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCd8VsAnU34VuKVCrYf4esvpXRAZ/oJzmwWEoSgvvePkDWdSweRM8QbtwVBMhSWivG9bpngQ0Dvgt51dY0z9RRNh8t+aB3kAaf1ms0GDHpu8eWB896sogoeuw29u5Mwb+X+7CU81mDsvuCqA+qCR/cG5m9Zk2gQk4IibB1B1Gd69zKnby5XqmETwt0k/BALo2R8lwPrpVFjJUxA/TDZeMh/Vvo08Dn1rux4OIIpRpyIJiNTTmCGrNb8JecdOGLKoDso418T9KqFHuYM0OjgBv7lCvfm5w1xkHNetZlkfjhr+qk9R8sFaDgyKPTNKgqte0aymNZ7MottcgtTtzYAScw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQ6zXwZctmCuVWr4GhWfbMZhrN+6SvTKPgbc7knxnWY=;
 b=VYgOsJk2JVkda5LUbA7Oaah66JiUWzBaD2KJvyj4elRiqypujWWD9sG0qB+icOALlYVweBh4kAZv4zk44v13rsKj+w7SIGjBBig+AO+i4OS6oj8XHD/z/WTlGekLebCxG+szOYoHoqwi/sHNQwkkXQ60RTdDqDypsJiMGRYqwlaQccB8kvdK2iMYKttfczmGvAc9LGV79Xr3xcVfYjyy2DiKtf2jVzz8r2wyN+/KfGNxGZJZ418yHrRTPcpcwvbD5BvM6Dp854EPylaXKlDVEFF5K3KpQVweYsYKlJwC5loq/0sMfBmWV15XMtGj2P4CKZdbhcXxlTH34KRDKqDPsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQ6zXwZctmCuVWr4GhWfbMZhrN+6SvTKPgbc7knxnWY=;
 b=jORgDXetuFx0OH4ypVWgn7O+a3/bFlSdlMtqp33RWCUP/dsfgeuO/PJyEMf6JRy17Gl3+gOhHL3YJoSYTP4CtgIh5BJfrTDfa74p2KGCAQZdxFiBQCitABXc2CAcDg3YudHapo4Z04GsYjnzc8hnfoUkMsswccIjuaZe2/V+VIk=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2472.eurprd08.prod.outlook.com (2603:10a6:4:a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Tue, 21 Apr
 2020 13:16:17 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2921.027; Tue, 21 Apr 2020
 13:16:17 +0000
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
Thread-Index: AQHWA/5/37ByIllroUeQ0w3cVWDDJKiCK72AgABugaA=
Date:   Tue, 21 Apr 2020 13:16:16 +0000
Message-ID: <DB6PR0802MB25338BD19DD2F7E662BB1065E9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
 <1585289423-18440-3-git-send-email-hadar.gat@arm.com>
 <CAMuHMdV6Uce79MPs7jfJfX3WOqAMH22vf2V_=Ui0zLHYqsJ+Xg@mail.gmail.com>
In-Reply-To: <CAMuHMdV6Uce79MPs7jfJfX3WOqAMH22vf2V_=Ui0zLHYqsJ+Xg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: fe0a6d42-fb56-4200-9ea8-0d29ca66e855.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1278e2f-b62f-4d50-f6f0-08d7e5f63155
x-ms-traffictypediagnostic: DB6PR0802MB2472:|DB6PR0802MB2472:|DB7PR08MB2987:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB298759D3185E37CF40DC1D72E9D50@DB7PR08MB2987.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:1002;OLM:1002;
x-forefront-prvs: 038002787A
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(53546011)(6506007)(54906003)(66946007)(316002)(26005)(7696005)(71200400001)(9686003)(55016002)(52536014)(5660300002)(66446008)(64756008)(66556008)(66476007)(7416002)(186003)(2906002)(8676002)(8936002)(81156014)(76116006)(6916009)(86362001)(4326008)(478600001)(33656002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: cqd6Gj6FngkvJx2j5DGu/NSWid8xrTJ238mc3apV16q/JYqdEzZ/iZMtBt8m4BT9mvr5fPVORgck/c2nTZEHZowSLJ5Y0I6+IzHskGQKQV8Ft7H3iuzfp57HN55TyheICQcCcTMx7huaPf4VCF2+XULB3zPHNRc9k2Cq1LNWeR5EiA0fE+FQ6IKTezUomiJIBj0euvNO55VCMC+Tj5JcvjJNbCrzxOJWONd2C/ijmvUyBZ6xJxQnVkJ+BptWfNuYGfRZgmoC+u3xLt67mJtBS6nAN60kNu6kHqkjblbVCM+NyddNMq0MREY34i+UH6lP5CnyUrkBKSTfN5WTdWHaEu3yMgv4gSW0YuPbm4gAqMIIx7dm+MqDuF5casW2EzgQLE7IqLlEzM9xjpu72xQ9ANl8TU9fhLa7CmydnqZBb0ln+n/5GqKXnJM5DFD6wSMd
x-ms-exchange-antispam-messagedata: pYb5RtdQdhZ/0aI5sHW3s9dyfo7eGvSA1yG9eMWceyWY7i8RfVY3g06pOyJ/pGLnPpzfw2qhEtmdgloM/1hSU8Gi5FN7zWNG7OG0+CH4gTKYEUUdV+YzQZet+8Y3WCCcLA06+rsuJK6yw2wpfuoBnw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2472
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT048.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(136003)(346002)(39860400002)(46966005)(81156014)(26005)(316002)(336012)(2906002)(55016002)(6862004)(6506007)(53546011)(356005)(82740400003)(8676002)(81166007)(86362001)(70586007)(4326008)(47076004)(7696005)(8936002)(5660300002)(54906003)(9686003)(33656002)(70206006)(450100002)(52536014)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 1e499314-9619-42d0-d2a3-08d7e5f62cb0
X-Forefront-PRVS: 038002787A
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V5oCKWa2fcT2VMXMR8scHLVZIu3TW3cFwJU1UBOC/V00+qd7ddGOjTvMU+DSrY8lU1cMXaYgIO4IdcM42MqaMqwOOqQWhcCJdX4QokYitAXD1/SnUOesrk1o7SqOmDWreLAXCQ85p5WFGB7xsCsjHEE5n6cIup/Lri/2rWhxuxUOAb0gQrWyTPY/3pvnD1dyWDwnOJ+6OSS6aU4q6sOartXSe2qZvs/kYIESMlV2VmOeJWLwaTPD0xto8GxXcdvQsyXFk9WYViTlmeXk5I7gnmC3qu5BI7+Bxmlc1qDxhpRPcFnyWzYt9DsKImBywUV+u83lwsVxOPzdAGv6/qy+8CGIRZTox0h8Y1ZybxDlgBrvAwTGc4o9HV9SA95sqHRYtokHExrtD2AeELyrY/EWZpwh0ppPjCNGxRor6UsAg94fo+kuvMUgurHlo/CMjEBHKoMAmsbthX0Btj7orkYXC+KVwTfeHsa5Xwpwynq+jkpfQ5Ca9GL7vqbEW0JfTCTsuuJ/izaveym34JOZeetxBA==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 13:16:24.8517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1278e2f-b62f-4d50-f6f0-08d7e5f63155
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB2987
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhhbmsgeW91IEdlZXJ0IGZvciByZXZpZXdpbmcgdGhlIGNjdHJuZyBjb2RlLg0KDQo+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnRA
bGludXgtbTY4ay5vcmc+DQo+IFNlbnQ6IE1vbmRheSwgMjAgQXByaWwgMjAyMCAxNjo0NQ0KPiAN
Cj4gSGkgSGFkYXIsDQo+IA0KPiBPbiBGcmksIE1hciAyNywgMjAyMCBhdCA3OjExIEFNIEhhZGFy
IEdhdCA8aGFkYXIuZ2F0QGFybS5jb20+IHdyb3RlOg0KPiA+IEludHJvZHVjZSBsb3cgbGV2ZWwg
QXJtIENyeXB0b0NlbGwgVFJORyBIVyBzdXBwb3J0Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTog
SGFkYXIgR2F0IDxoYWRhci5nYXRAYXJtLmNvbT4NCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBwYXRj
aCENCj4gDQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL2RyaXZlcnMvY2hhci9od19yYW5k
b20vY2N0cm5nLmMNCj4gDQo+ID4gK3N0YXRpYyBpbnQgY2N0cm5nX3Byb2JlKHN0cnVjdCBwbGF0
Zm9ybV9kZXZpY2UgKnBkZXYpIHsNCj4gPiArICAgICAgIHN0cnVjdCByZXNvdXJjZSAqcmVxX21l
bV9jY19yZWdzID0gTlVMTDsNCj4gPiArICAgICAgIHN0cnVjdCBjY3RybmdfZHJ2ZGF0YSAqZHJ2
ZGF0YTsNCj4gPiArICAgICAgIHN0cnVjdCBkZXZpY2UgKmRldiA9ICZwZGV2LT5kZXY7DQo+ID4g
KyAgICAgICBpbnQgcmMgPSAwOw0KPiA+ICsgICAgICAgdTMyIHZhbDsNCj4gPiArICAgICAgIGlu
dCBpcnE7DQo+ID4gKw0KPiA+ICsgICAgICAgZHJ2ZGF0YSA9IGRldm1fa3phbGxvYyhkZXYsIHNp
emVvZigqZHJ2ZGF0YSksIEdGUF9LRVJORUwpOw0KPiA+ICsgICAgICAgaWYgKCFkcnZkYXRhKQ0K
PiA+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVOT01FTTsNCj4gPiArDQo+ID4gKyAgICAgICBk
cnZkYXRhLT5ybmcubmFtZSA9IGRldm1fa3N0cmR1cChkZXYsIGRldl9uYW1lKGRldiksDQo+IEdG
UF9LRVJORUwpOw0KPiA+ICsgICAgICAgaWYgKCFkcnZkYXRhLT5ybmcubmFtZSkNCj4gPiArICAg
ICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07DQo+ID4gKw0KPiA+ICsgICAgICAgZHJ2ZGF0YS0+
cm5nLnJlYWQgPSBjY3RybmdfcmVhZDsNCj4gPiArICAgICAgIGRydmRhdGEtPnJuZy5wcml2ID0g
KHVuc2lnbmVkIGxvbmcpZHJ2ZGF0YTsNCj4gPiArICAgICAgIGRydmRhdGEtPnJuZy5xdWFsaXR5
ID0gQ0NfVFJOR19RVUFMSVRZOw0KPiA+ICsNCj4gPiArICAgICAgIHBsYXRmb3JtX3NldF9kcnZk
YXRhKHBkZXYsIGRydmRhdGEpOw0KPiA+ICsgICAgICAgZHJ2ZGF0YS0+cGRldiA9IHBkZXY7DQo+
ID4gKw0KPiA+ICsgICAgICAgZHJ2ZGF0YS0+Y2lyYy5idWYgPSAoY2hhciAqKWRydmRhdGEtPmRh
dGFfYnVmOw0KPiA+ICsNCj4gPiArICAgICAgIC8qIEdldCBkZXZpY2UgcmVzb3VyY2VzICovDQo+
ID4gKyAgICAgICAvKiBGaXJzdCBDQyByZWdpc3RlcnMgc3BhY2UgKi8NCj4gPiArICAgICAgIHJl
cV9tZW1fY2NfcmVncyA9IHBsYXRmb3JtX2dldF9yZXNvdXJjZShwZGV2LA0KPiBJT1JFU09VUkNF
X01FTSwgMCk7DQo+ID4gKyAgICAgICAvKiBNYXAgcmVnaXN0ZXJzIHNwYWNlICovDQo+ID4gKyAg
ICAgICBkcnZkYXRhLT5jY19iYXNlID0gZGV2bV9pb3JlbWFwX3Jlc291cmNlKGRldiwNCj4gcmVx
X21lbV9jY19yZWdzKTsNCj4gPiArICAgICAgIGlmIChJU19FUlIoZHJ2ZGF0YS0+Y2NfYmFzZSkp
IHsNCj4gPiArICAgICAgICAgICAgICAgZGV2X2VycihkZXYsICJGYWlsZWQgdG8gaW9yZW1hcCBy
ZWdpc3RlcnMiKTsNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIFBUUl9FUlIoZHJ2ZGF0YS0+
Y2NfYmFzZSk7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgZGV2X2RiZyhkZXYs
ICJHb3QgTUVNIHJlc291cmNlICglcyk6ICVwUlxuIiwgcmVxX21lbV9jY19yZWdzLQ0KPiA+bmFt
ZSwNCj4gPiArICAgICAgICAgICAgICAgcmVxX21lbV9jY19yZWdzKTsNCj4gPiArICAgICAgIGRl
dl9kYmcoZGV2LCAiQ0MgcmVnaXN0ZXJzIG1hcHBlZCBmcm9tICVwYSB0byAweCVwXG4iLA0KPiA+
ICsgICAgICAgICAgICAgICAmcmVxX21lbV9jY19yZWdzLT5zdGFydCwgZHJ2ZGF0YS0+Y2NfYmFz
ZSk7DQo+ID4gKw0KPiA+ICsgICAgICAgLyogVGhlbiBJUlEgKi8NCj4gPiArICAgICAgIGlycSA9
IHBsYXRmb3JtX2dldF9pcnEocGRldiwgMCk7DQo+ID4gKyAgICAgICBpZiAoaXJxIDwgMCkgew0K
PiA+ICsgICAgICAgICAgICAgICBkZXZfZXJyKGRldiwgIkZhaWxlZCBnZXR0aW5nIElSUSByZXNv
dXJjZVxuIik7DQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBpcnE7DQo+ID4gKyAgICAgICB9
DQo+ID4gKw0KPiA+ICsgICAgICAgLyogcGFyc2Ugc2FtcGxpbmcgcmF0ZSBmcm9tIGRldmljZSB0
cmVlICovDQo+ID4gKyAgICAgICByYyA9IGNjX3RybmdfcGFyc2Vfc2FtcGxpbmdfcmF0aW8oZHJ2
ZGF0YSk7DQo+ID4gKyAgICAgICBpZiAocmMpIHsNCj4gPiArICAgICAgICAgICAgICAgZGV2X2Vy
cihkZXYsICJGYWlsZWQgdG8gZ2V0IGxlZ2FsIHNhbXBsaW5nIHJhdGlvIGZvciByb3NjXG4iKTsN
Cj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIHJjOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsNCj4g
PiArICAgICAgIHJjID0gY2NfdHJuZ19jbGtfaW5pdChkcnZkYXRhKTsNCj4gPiArICAgICAgIGlm
IChyYykgew0KPiA+ICsgICAgICAgICAgICAgICBkZXZfZXJyKGRldiwgImNjX3RybmdfY2xrX2lu
aXQgZmFpbGVkXG4iKTsNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIHJjOw0KPiA+ICsgICAg
ICAgfQ0KPiA+ICsNCj4gPiArICAgICAgIElOSVRfV09SSygmZHJ2ZGF0YS0+Y29tcHdvcmssIGNj
X3RybmdfY29tcHdvcmtfaGFuZGxlcik7DQo+ID4gKyAgICAgICBJTklUX1dPUksoJmRydmRhdGEt
PnN0YXJ0d29yaywgY2NfdHJuZ19zdGFydHdvcmtfaGFuZGxlcik7DQo+ID4gKyAgICAgICBzcGlu
X2xvY2tfaW5pdCgmZHJ2ZGF0YS0+cmVhZF9sb2NrKTsNCj4gPiArDQo+ID4gKyAgICAgICAvKiBy
ZWdpc3RlciB0aGUgZHJpdmVyIGlzciBmdW5jdGlvbiAqLw0KPiA+ICsgICAgICAgcmMgPSBkZXZt
X3JlcXVlc3RfaXJxKGRldiwgaXJxLCBjY19pc3IsIElSUUZfU0hBUkVELCAiY2N0cm5nIiwNCj4g
PiArIGRydmRhdGEpOw0KPiANCj4gU2hvdWRuJ3QgdGhpcyBiZSBkb25lIGFmdGVyIGNsZWFyaW5n
IHRoZSBwZW5kaW5nIGludGVycnVwdHMgYmVsb3c/DQoNCkknbSBub3Qgc3VyZSB3aGF0IGRvIHlv
dSBtZWFuIGluIHlvdXIgcXVlc3Rpb24uLi4NCkkgYXNzdW1lIHlvdSdyZSBzdWdnZXN0aW5nIHRo
YXQgdGhlIHJlZ2lzdHJhdGlvbiBvZiB0aGUgZHJpdmVyIElTUiBmdW5jdGlvbiBzaG91bGQgYmUg
ZG9uZSBvbmx5IGFmdGVyIGNsZWFyaW5nIHRoZSBwZW5kaW5nIGludGVycnVwdHM/IQ0KQW55d2F5
LCBhbnkgcGVuZGluZyBpbnRlcnJ1cHQgdGhhdCBtaWdodCBleGlzdCBpcyBpcnJlbGV2YW50IHRv
IHRoZSBjdXJyZW50IGNjdHJuZyBkcml2ZXIgd2hpY2gganVzdCBzdGFydGVkICh3ZSdyZSBpbiB0
aGUgcHJvYmUgZnVuY3Rpb24pDQoNCj4gPiArICAgICAgIGlmIChyYykgew0KPiA+ICsgICAgICAg
ICAgICAgICBkZXZfZXJyKGRldiwgIkNvdWxkIG5vdCByZWdpc3RlciB0byBpbnRlcnJ1cHQgJWRc
biIsIGlycSk7DQo+ID4gKyAgICAgICAgICAgICAgIGdvdG8gcG9zdF9jbGtfZXJyOw0KPiA+ICsg
ICAgICAgfQ0KPiA+ICsgICAgICAgZGV2X2RiZyhkZXYsICJSZWdpc3RlcmVkIHRvIElSUTogJWRc
biIsIGlycSk7DQo+ID4gKw0KPiA+ICsgICAgICAgLyogQ2xlYXIgYWxsIHBlbmRpbmcgaW50ZXJy
dXB0cyAqLw0KPiA+ICsgICAgICAgdmFsID0gY2NfaW9yZWFkKGRydmRhdGEsIENDX0hPU1RfUkdG
X0lSUl9SRUdfT0ZGU0VUKTsNCj4gPiArICAgICAgIGRldl9kYmcoZGV2LCAiSVJSPTB4JTA4WFxu
IiwgdmFsKTsNCj4gPiArICAgICAgIGNjX2lvd3JpdGUoZHJ2ZGF0YSwgQ0NfSE9TVF9SR0ZfSUNS
X1JFR19PRkZTRVQsIHZhbCk7DQo+IA0KPiBUaGUgYWJvdmUgYWNjZXNzZXMgdGhlIGVuZ2luZSdz
IHJlZ2lzdGVycy4uLg0KDQpUaGF0IGlzIHJpZ2h0Lg0KDQo+ID4gKw0KPiA+ICsgICAgICAgLyog
dW5tYXNrIEhPU1QgUk5HIGludGVycnVwdCAqLw0KPiA+ICsgICAgICAgY2NfaW93cml0ZShkcnZk
YXRhLCBDQ19IT1NUX1JHRl9JTVJfUkVHX09GRlNFVCwNCj4gPiArICAgICAgICAgICAgICAgICAg
Y2NfaW9yZWFkKGRydmRhdGEsIENDX0hPU1RfUkdGX0lNUl9SRUdfT0ZGU0VUKSAmDQo+ID4gKyAg
ICAgICAgICAgICAgICAgIH5DQ19IT1NUX1JOR19JUlFfTUFTSyk7DQo+ID4gKw0KPiA+ICsgICAg
ICAgLyogaW5pdCBQTSAqLw0KPiA+ICsgICAgICAgcmMgPSBjY190cm5nX3BtX2luaXQoZHJ2ZGF0
YSk7DQo+ID4gKyAgICAgICBpZiAocmMpIHsNCj4gPiArICAgICAgICAgICAgICAgZGV2X2Vycihk
ZXYsICJjY190cm5nX3BtX2luaXQgZmFpbGVkXG4iKTsNCj4gPiArICAgICAgICAgICAgICAgZ290
byBwb3N0X2Nsa19lcnI7DQo+ID4gKyAgICAgICB9DQo+IA0KPiA+ICsNCj4gPiArICAgICAgIC8q
IGluY3JlbWVudCBkZXZpY2UncyB1c2FnZSBjb3VudGVyICovDQo+ID4gKyAgICAgICByYyA9IGNj
X3RybmdfcG1fZ2V0KGRldik7DQo+IA0KPiAuLi4gYnV0IG9ubHkgaGVyZSBpcyBSdW50aW1lIFBN
IGluaXRpYWxpemVkLCBhbmQgdGhlIGRldmljZSBndWFyYW50ZWVkIHRvIGJlDQo+IHBvd2VyZWQu
ICBJZiBhIGRldmljZSBpcyBhY2Nlc3NlZCB3aGlsZSBwb3dlcmVkIGRvd24sIHRoaXMgbWF5IGxl
YWQgdG8gYW4NCj4gYXN5bmNocm9ub3VzIGV4dGVybmFsIGFib3J0LCBvciBhIHBsYWluIGxvY2t1
cC4NCg0KSXQgaXMgYXNzdW1lZCB0aGF0IHdoZW4gdGhlIGRyaXZlciBpcyBwcm9iZWQgaXQgaXMg
YWxyZWFkeSBwb3dlcmVkLiBPbmx5IHRoZW4sIHRoZSBkcml2ZXIgaW5pdGlhbGl6ZXMgYW5kIGVu
YWJsZXMgdGhlIHJ1bnRpbWUgUE0gdG8gYWxsb3cgcG93ZXIgZG93biBvZiB0aGUgSFcgd2hlbiBp
dCBpcyBub3QgaW4gdXNlLg0KDQo+IA0KPiBHcntvZXRqZSxlZXRpbmd9cywNCj4gDQo+ICAgICAg
ICAgICAgICAgICAgICAgICAgIEdlZXJ0DQo+IA0KPiAtLQ0KPiBHZWVydCBVeXR0ZXJob2V2ZW4g
LS0gVGhlcmUncyBsb3RzIG9mIExpbnV4IGJleW9uZCBpYTMyIC0tIGdlZXJ0QGxpbnV4LQ0KPiBt
NjhrLm9yZw0KPiANCj4gSW4gcGVyc29uYWwgY29udmVyc2F0aW9ucyB3aXRoIHRlY2huaWNhbCBw
ZW9wbGUsIEkgY2FsbCBteXNlbGYgYSBoYWNrZXIuIEJ1dA0KPiB3aGVuIEknbSB0YWxraW5nIHRv
IGpvdXJuYWxpc3RzIEkganVzdCBzYXkgInByb2dyYW1tZXIiIG9yIHNvbWV0aGluZyBsaWtlIHRo
YXQuDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLS0gTGludXMgVG9ydmFsZHMN
Cg==
