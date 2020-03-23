Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42E1C54FD0
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 19:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C91820753
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 19:51:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3BO7a3Hs";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3BO7a3Hs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgCWTvL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 15:51:11 -0400
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:20353
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgCWTvL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 15:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHKlV+OkdAT/15fztBjNX6qwXLiFQ0tLV6LIOMOFA4Q=;
 b=3BO7a3HsFAb4SnK0yOGmJ+2klfvFQAzmaiM1EFKf2DjBGaYEvsSAkES51ik+WHxSuSHkHREvlgfrOnDO8KAupqV3+cpDSvty+/DAt4WLJSRsDQ06f0pOYZ8dQtYGoMU9B7o90R7sSqkYqaYK4ChmE+D4eWFEuQRws83jOPYWiP8=
Received: from DBBPR09CA0032.eurprd09.prod.outlook.com (2603:10a6:10:d4::20)
 by DBBPR08MB4427.eurprd08.prod.outlook.com (2603:10a6:10:c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Mon, 23 Mar
 2020 19:51:04 +0000
Received: from DB5EUR03FT056.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:d4:cafe::8) by DBBPR09CA0032.outlook.office365.com
 (2603:10a6:10:d4::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend
 Transport; Mon, 23 Mar 2020 19:51:04 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT056.mail.protection.outlook.com (10.152.21.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Mon, 23 Mar 2020 19:51:04 +0000
Received: ("Tessian outbound f88013e987c7:v48"); Mon, 23 Mar 2020 19:51:03 +0000
X-CR-MTA-TID: 64aa7808
Received: from 98cc22680b92.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 0E5D89BB-D330-409E-ADA3-3745E0178F6E.1;
        Mon, 23 Mar 2020 19:50:58 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 98cc22680b92.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 23 Mar 2020 19:50:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFIRfk78eq4kcYejgre2KsvAETtVh2i+kxOtimvBhRgh8qvFrcKbhcFYHcXpFGIUkwqYx0l7mGNiXbev4Jy4cNty/iXKw3lBdpcCDN/kWrR4Vl6ePk1sMa1cpF2Zze83OW5hDvfehihP1OxtrAhm8gMjP7k7ljx9EI/g4ObVBemL7cq0B8+XufIp/Uw07yeTs7/+VhBxz9uda+o9UF9HFIUsAVsX0wFZsi9Dlgg63ybe21USEFOq7fjzR1Ynur6HLXnwUTvG+tRp6YNHf15hB8KXDk4d9JKKbalUYudYUhVFZs8NJoULi8BI+lZeHsZByrqOi9ShheXiXS3CPeEthw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHKlV+OkdAT/15fztBjNX6qwXLiFQ0tLV6LIOMOFA4Q=;
 b=QphtvKcRHOxnR0mT2wXdn42Y8EwqNhOW8xvxBVQ+/cw/ov+aEFi6csKFtAByx6ilvh37y8KumcbxbzYd1oDZDMQo7qLEM8T5ZASC1ZhcXQor36nNuqPeF/DAVwvboD4jZ78oO0rJ7yHV2EZ2KW2Uoa1wscn/aHtwTqD6603XjNbMy++7jIFWvSnA/u6JNJuzogh4VMknqDHwFXI4cGkLppfni/IUCR6UMdvTtA3c2Ic7L5lwOT2OtqxXKSDrg0UTT+OrGCvFZROj5apmNBnl+2ojb4kF8CgtzOjA53opiWqOE1vyPeIU48ygmXLmmyt0ZWMDgYORe+EwXPQuznhnvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHKlV+OkdAT/15fztBjNX6qwXLiFQ0tLV6LIOMOFA4Q=;
 b=3BO7a3HsFAb4SnK0yOGmJ+2klfvFQAzmaiM1EFKf2DjBGaYEvsSAkES51ik+WHxSuSHkHREvlgfrOnDO8KAupqV3+cpDSvty+/DAt4WLJSRsDQ06f0pOYZ8dQtYGoMU9B7o90R7sSqkYqaYK4ChmE+D4eWFEuQRws83jOPYWiP8=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (10.172.251.12) by
 DB6PR0802MB2149.eurprd08.prod.outlook.com (10.172.226.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Mon, 23 Mar 2020 19:50:55 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 19:50:54 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Rouven Czerwinski <r.czerwinski@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
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
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v5 2/3] hw_random: cctrng: introduce Arm CryptoCell driver
Thread-Topic: [PATCH v5 2/3] hw_random: cctrng: introduce Arm CryptoCell
 driver
Thread-Index: AQHWAGCh1qh+T7jvaUGctSth1l5aRKhWRaqAgABQ4gA=
Date:   Mon, 23 Mar 2020 19:50:54 +0000
Message-ID: <DB6PR0802MB25332C489D7165C8BAC2232FE9F00@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1584891085-8963-1-git-send-email-hadar.gat@arm.com>
         <1584891085-8963-3-git-send-email-hadar.gat@arm.com>
 <412a4da61063b8c8a72729f03c06480c5f1374fb.camel@pengutronix.de>
In-Reply-To: <412a4da61063b8c8a72729f03c06480c5f1374fb.camel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: bd76418f-2dd2-4615-b114-f70c91a6a087.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [185.175.35.134]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2e43844f-c931-420c-0382-08d7cf63855d
x-ms-traffictypediagnostic: DB6PR0802MB2149:|DB6PR0802MB2149:|DBBPR08MB4427:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB44275BE0549B9209EE7B05F5E9F00@DBBPR08MB4427.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;OLM:8273;
x-forefront-prvs: 0351D213B3
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(199004)(7416002)(52536014)(66946007)(8676002)(81166006)(81156014)(8936002)(33656002)(55016002)(6506007)(316002)(7696005)(2906002)(71200400001)(110136005)(54906003)(26005)(86362001)(186003)(4326008)(76116006)(66476007)(66446008)(66556008)(9686003)(478600001)(5660300002)(64756008)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0802MB2149;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: OTqPLAIlbu5Klcqizr65aA0GjxON/qng7NsJZBhp71bOxDN2Dpi27vdHc8pCuzgDsmRIik+9GC4UDRUQLivF3v+ZFFY74db5y8G/9tVOknwWQIb/h/7bXxpGfoN0BtMq/fLLNUQZsWXareaiphyWO4W1uoQnq1pyRyPQcabclMUNnjRIsv1ZSQCma9G5UbEz7+eTyFzGsBoJ5fZ0cpwD1eAwrDaf3x9q2/b9pbIgIC/AXUeB1cTNq8loKhN+8JyqlIYIQQZW9uFN5m10IKxirCi/NZEVmmuIuIdkSpGwylCDD60Kfn68cMproRMgGvXj1jT0BxLH+O3hMGIzZhgnaC7oOf91coNci9cFwVPUXklLQZBU0ry1D96rGEd7Hlz19Jz15pMptjttErCMHQQPYrBKYuqFxr3cUQM1FgZnAJ+ULDCVXB5G8g/3k2YHJHG9v2tyJAmdTFZ/LkdjDeDsxeo3nzvdftcgw9ePy70LXGm+v0MQ4ohdEoDpMqw/8Vch
x-ms-exchange-antispam-messagedata: JTKxYSagsNzR0JSkKXW7FT1x/442/sJmbWr3gmML3uX77m4//m4BG4pYQFI0C8PPUM7HhvM5aJqtKaMcceT0j+uXKwo8bzAKzgpqhk5cTfTCpi8iUhD8T/z4xtWM2w2dAO2SnxNaXY93zrdbSh29Vw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2149
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT056.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(396003)(136003)(199004)(46966005)(8676002)(81166006)(81156014)(6506007)(7696005)(8936002)(26005)(186003)(86362001)(316002)(70206006)(70586007)(54906003)(356004)(478600001)(26826003)(47076004)(450100002)(110136005)(2906002)(9686003)(336012)(55016002)(5660300002)(33656002)(52536014)(4326008)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR08MB4427;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 07223caf-38a9-4f33-4f57-08d7cf637fd3
X-Forefront-PRVS: 0351D213B3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Skj85i5p4YH2FF27WhKekqgKnCJLY5kmvAJRB6qtC7QVP/k/c7+rbhxoku9TCVp0aE3mjezGYA5MIg1BY3hPZ7n6MTmypy+8suFWG4nf8/zGPmpSafpMpjkz0+pYU3Z0oG6ZadfhgTFdlOAQQY/ZqS0iChwFck7raiehCWpbMkm2wUth5WFnVD2NMXNSVmMtg6zI884gyPfAyh8OIcHb/P9eH6JeUbc+zGQ+qOLG7fGo5CWnBhF585X1ClbmqGXTdYP1y7OTPaMxL454v3FPDHAtgDHP7tm4Q3looAureZq6gPGukLQUshaBIoBKIvd5xtp4Cs+Epq8VGvYMGecK3CEiSmFhmufh72mgZH1hB8SLtTtwPutImOZpixdwjV0DL+w/Ml/Qn0tkqOYz0zsLfzaLBROpalGy+w0SMcSw8jvw+56hyd4375I3MW+2u21bzpOReLeXCdFAOny5SsJ/mzuq+AkV9hn8nAYAsgHMz88BWbykn797Nto922O2MWCU238zEGBGFkvsSS3A0XxGXB1/Mh1JaopaTuiN1FEZWVMIoAEptdycZXoi8wOGd8VP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 19:51:04.2281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e43844f-c931-420c-0382-08d7cf63855d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4427
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgUm91dmVuLA0KDQo+IA0KPiBIZWxsbyBIYWRhciwNCj4gDQo+IE9uIFN1biwgMjAyMC0wMy0y
MiBhdCAxNzozMSArMDIwMCwgSGFkYXIgR2F0IHdyb3RlOg0KPiA+IEludHJvZHVjZSBsb3cgbGV2
ZWwgQXJtIENyeXB0b0NlbGwgVFJORyBIVyBzdXBwb3J0Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogSGFkYXIgR2F0IDxoYWRhci5nYXRAYXJtLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9j
aGFyL2h3X3JhbmRvbS9LY29uZmlnICB8ICAxMiArDQo+ID4gIGRyaXZlcnMvY2hhci9od19yYW5k
b20vTWFrZWZpbGUgfCAgIDEgKw0KPiA+ICBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2NjdHJuZy5j
IHwgNzM1DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+
ICBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2NjdHJuZy5oIHwgIDY5ICsrKysNCj4gPiAgNCBmaWxl
cyBjaGFuZ2VkLCA4MTcgaW5zZXJ0aW9ucygrKQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJp
dmVycy9jaGFyL2h3X3JhbmRvbS9jY3RybmcuYyAgY3JlYXRlIG1vZGUNCj4gPiAxMDA2NDQgZHJp
dmVycy9jaGFyL2h3X3JhbmRvbS9jY3RybmcuaA0KPiA+DQo+ID4gWy4uLl0NCj4gPiArc3RhdGlj
IGludCBjY3RybmdfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikgew0KPiA+ICsJ
c3RydWN0IHJlc291cmNlICpyZXFfbWVtX2NjX3JlZ3MgPSBOVUxMOw0KPiA+ICsJc3RydWN0IGNj
dHJuZ19kcnZkYXRhICpkcnZkYXRhOw0KPiA+ICsJc3RydWN0IGRldmljZSAqZGV2ID0gJnBkZXYt
PmRldjsNCj4gPiArCWludCByYyA9IDA7DQo+ID4gKwl1MzIgdmFsOw0KPiA+ICsJaW50IGlycTsN
Cj4gPiArDQo+ID4gKwlkcnZkYXRhID0gZGV2bV9remFsbG9jKGRldiwgc2l6ZW9mKCpkcnZkYXRh
KSwgR0ZQX0tFUk5FTCk7DQo+ID4gKwlpZiAoIWRydmRhdGEpDQo+ID4gKwkJcmV0dXJuIC1FTk9N
RU07DQo+ID4gKw0KPiA+ICsJZHJ2ZGF0YS0+cm5nLm5hbWUgPSBkZXZtX2tzdHJkdXAoZGV2LCBk
ZXZfbmFtZShkZXYpLA0KPiA+IEdGUF9LRVJORUwpOw0KPiA+ICsJaWYgKCFkcnZkYXRhLT5ybmcu
bmFtZSkNCj4gPiArCQlyZXR1cm4gLUVOT01FTTsNCj4gPiArDQo+ID4gKwlkcnZkYXRhLT5ybmcu
cmVhZCA9IGNjdHJuZ19yZWFkOw0KPiA+ICsJZHJ2ZGF0YS0+cm5nLnByaXYgPSAodW5zaWduZWQg
bG9uZylkcnZkYXRhOw0KPiANCj4gWW91IGFyZSBub3QgaW5pdGlhbGl6aW5nIGRydmRhdGEtPnJu
Zy5xdWFsaXR5IHRvIGEgZGVmYXVsdCB2YWx1ZSwgd2hpY2ggcmVzdWx0cyBpbg0KPiB0aGUgVFJO
RyBub3QgYmVpbmcgdXNlZCBieSB0aGUga2VybmVsIGJ5IGRlZmF1bHQuIElmIGl0cyBhIHBlcmZl
Y3QgVFJORyB0aGlzDQo+IHNob3VsZCBiZSBzZXQgdG8gMTAyNCwgaS5lLiAxMDI0IGJpdHMgb2Yg
ZW50cm9weSBwZXINCj4gMTAyNCBiaXRzIG9mIGlucHV0Lg0KDQpUaGFua3MgZm9yIG5vdGljaW5n
LiBJJ2xsIGZpeCB0aGF0Lg0KDQo+IA0KPiBSZWdhcmRzLA0KPiBSb3V2ZW4gQ3plcndpbnNraQ0K
DQpUaGFua3MsDQpIYWRhcg0K
