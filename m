Return-Path: <SRS0=BVES=6E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91126C3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 12:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E14D206F6
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 12:27:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="qKQYurfS";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="qKQYurfS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgDTM1W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Apr 2020 08:27:22 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:26606
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726470AbgDTM1W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Apr 2020 08:27:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSwxTivOz3ZzwDKzxzynEd1RMTkTorShZny2PA3yAuA=;
 b=qKQYurfS/WM/uMjJ5IuC3XNwlShpveP5Vl/umGTjcOIfoFHXkUzFFWSmGkQCEejeFwB19WwGV3OOpGKz5s4d3S3pOlBTm1kKtYOKaj5M/Ik6nC9z1TRUntYkzRJKHaK18zTmUznd1atdZWIbd0OAIAxpJnnGOtuKeYrzWHPKbCk=
Received: from AM6P194CA0084.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:8f::25)
 by AM0PR08MB3012.eurprd08.prod.outlook.com (2603:10a6:208:5b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.28; Mon, 20 Apr
 2020 12:27:17 +0000
Received: from VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8f:cafe::76) by AM6P194CA0084.outlook.office365.com
 (2603:10a6:209:8f::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend
 Transport; Mon, 20 Apr 2020 12:27:17 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT015.mail.protection.outlook.com (10.152.18.176) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.18 via Frontend Transport; Mon, 20 Apr 2020 12:27:16 +0000
Received: ("Tessian outbound 7626dd1b3605:v53"); Mon, 20 Apr 2020 12:27:14 +0000
X-CR-MTA-TID: 64aa7808
Received: from c65254b46dfd.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 8649F0DC-B58D-4D15-B3D4-2EB63D145C59.1;
        Mon, 20 Apr 2020 12:27:09 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c65254b46dfd.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 20 Apr 2020 12:27:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GftDemT3M8Ore/7G4IJydF+riTyvZcZN83+JI/WVFjVevBVPNb17uLDJReLCb4NYqXs8T6fF6TvdoBCVjOnBDZ04vspnU9n+j9ecnHPWnCfYfBVZuFkrHRmKg6wYV+JQK9c7BhOGOuAphsOK2R/JUtiW/YTRoc/2yIERILrEe+gWQod2R5XS0o8qtlfNLcYBCRg7rGjvCfEk9eUoTERJ8IxJpFsIw1xAGT/aKWQnlFjxJ3Sp81Nsd3zZcmHYn79+HBJFp7XB9xKZx97tK1Iez2RWmxYEjAsAgTsXJG/951i+uZNGSqGz/u38hKOOs5iUEnQXis1XfMv0qFEliQOB7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSwxTivOz3ZzwDKzxzynEd1RMTkTorShZny2PA3yAuA=;
 b=VAHl69x8y647eViBYngjeidugUmOrSHti5wZ4iIMXA4rsghWlNXN97pZ8zJWXC89fLtvQ34MU9TNkmVLw2QmoW/nZ6O5CtSMP9hBJsH+94Fu/bjrQuoSkdLUhCSxpAqwWLCjaetu2rn4seIEPHcUff6IijsD2pzNwKjXo/epU1c4oNDctWb7K6QxRocWBR/YpwgKSG+q1CmzQKQdjQJFLxcePXQG9lidcOYMcnLELWiPq66qsQ+alXm202YqgBJ3MGtS0DuSnudv2+sGHhoBAX8SUKPK3oBod8YaYr0XceeWIJmfdtn0TQUDiblqXof1B0Cpmz8gqB4vjZqmKqS+YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSwxTivOz3ZzwDKzxzynEd1RMTkTorShZny2PA3yAuA=;
 b=qKQYurfS/WM/uMjJ5IuC3XNwlShpveP5Vl/umGTjcOIfoFHXkUzFFWSmGkQCEejeFwB19WwGV3OOpGKz5s4d3S3pOlBTm1kKtYOKaj5M/Ik6nC9z1TRUntYkzRJKHaK18zTmUznd1atdZWIbd0OAIAxpJnnGOtuKeYrzWHPKbCk=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2295.eurprd08.prod.outlook.com (2603:10a6:4:84::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 12:27:07 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 12:27:07 +0000
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
Subject: RE: [PATCH v7 0/3] hw_random: introduce Arm CryptoCell TRNG driver
Thread-Topic: [PATCH v7 0/3] hw_random: introduce Arm CryptoCell TRNG driver
Thread-Index: AQHWA/55FVE3P4G/jUCyx1dFw6sOc6iB5dAAgAAfijA=
Date:   Mon, 20 Apr 2020 12:27:07 +0000
Message-ID: <DB6PR0802MB25330E55914346B46288C712E9D40@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
 <CAMuHMdUUJATs+G-hvty=fgyrhyx1EafpFHoWfcm=V_tVLn3q2A@mail.gmail.com>
In-Reply-To: <CAMuHMdUUJATs+G-hvty=fgyrhyx1EafpFHoWfcm=V_tVLn3q2A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 6492758c-d5a0-40e4-8d7f-c9a9fb877380.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6690d13c-aa75-4c94-a54a-08d7e5262999
x-ms-traffictypediagnostic: DB6PR0802MB2295:|DB6PR0802MB2295:|AM0PR08MB3012:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB30128B0AF17FC95196362D11E9D40@AM0PR08MB3012.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:3383;OLM:3383;
x-forefront-prvs: 03793408BA
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(52536014)(71200400001)(2906002)(81156014)(8676002)(8936002)(33656002)(7696005)(66946007)(26005)(76116006)(53546011)(6506007)(66476007)(66556008)(64756008)(5660300002)(66446008)(4326008)(4744005)(6916009)(55016002)(9686003)(86362001)(7416002)(54906003)(478600001)(186003)(316002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: EH2zeLhugPh+T9pyWS+PohetbOffkPU+VurfIPHJAJ36uIzLtJddmbzaW/KLAUftkoxG6c15hwKwsAOX3EXGnfjapeNKK0T6ht5pSvOUMAx8hyCtDznRYYKIfa+bWE94yMBbp3/+ydeujRTwlWJRWMMnXnZhKPlilr1HM1hG6Bi/RRSnufalnnyCSRoo8xBDgz8YKM+Qhl5L7uBY8CWOkoUUqdYws6Br+v+1p+LVA2jNxXk9YDzMC6y/W0YbF9ELle50yI8cILszzmKo8auqdiwMIQWuIOqjYA21HZGZ5tgKcsK+8tJ85RXQ/OJrjejqsYFw+G/2n4YbAR9T/01PGJ6AKcNVW640g9avW7FffbOITphq0q45B9yZ2vIWTnKqGnVfONh5BPcXoRyebi9O4tf7CentJsWB1IoA/5t7CQmJKTVHOKE/EEFStd5FNMnP
x-ms-exchange-antispam-messagedata: 5TEwjZpSOAM2e3YzslX9woXy4KpDq/n/EzfS4IFztkRg2hfWt5FQsqum40CN8qtP0bPLkKxATae6YOo+qJiUjG99UCNG/4CqqkJiUx1t0Q4XYaQQADyJzdkhPOuOHYE0WN0qDP8sIEsrFocdUdOK4A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2295
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966005)(86362001)(8676002)(26005)(8936002)(53546011)(54906003)(52536014)(6506007)(81156014)(316002)(70206006)(70586007)(7696005)(55016002)(9686003)(356005)(47076004)(36906005)(82740400003)(336012)(81166007)(186003)(478600001)(6862004)(4326008)(450100002)(5660300002)(33656002)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 19bb039c-88ee-4b93-07f8-08d7e526241e
X-Forefront-PRVS: 03793408BA
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: auezNkayTlgR/KtIp3osWk7V/sdkUWWFhBkqlj8j5y7Vlcbl8mR+6FTYEyNU0eSt56Vks/tzT69Jiiz8hk5jlziJKj/MqSDvhHqS9nNJh+DBd+1tyuBPJA8s1L6YDtrWWnOD1EwzRNQPcZ6nb47epnTcLRP6VVxhPQ3yKf78Sbc5kXNOCC2Rw3XliByb2nSx8ZVqFM0Fj2OrRLuJiPg02sgFUsscyFqbSoMZYIrCZcJMeVizsl0YxdtN1CWRlMxT8ck+NUEPlwYx2lBckbOi0wpA9ZnDoD2w19sfhWczWIPREUCfltoSMgK4BWzPmvppOG43eYc7uFF+le4UCEoPNdka6V3GinZaeF0pAGd/81EQf1+yCZu4mc5+P1lgHk1WTA2uHXZrDCjEUZRtImSS9oW/Hhwp87eu0pdsDKD1DZfuU9orQ9SJvFvyT+OOd2h8+3SiDwsmy1y2mlHZilKU3pmY0hqrN6qnuok/WXY/Mw84yUKIEYeDyzdyD8Co+bH5veBFoRHk0x8tt0i7B/kXEA==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 12:27:16.3996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6690d13c-aa75-4c94-a54a-08d7e5262999
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3012
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQpIaSBHZWVydCwNCg0KPiBGcm9tOiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0QGxpbnV4LW02
OGsub3JnPg0KPiBTZW50OiBNb25kYXksIDIwIEFwcmlsIDIwMjAgMTI6MzUNCj4gDQo+IEhpIEhh
ZGFyLA0KPiANCj4gT24gRnJpLCBNYXIgMjcsIDIwMjAgYXQgNzoxMSBBTSBIYWRhciBHYXQgPGhh
ZGFyLmdhdEBhcm0uY29tPiB3cm90ZToNCj4gPiBUaGUgQXJtIENyeXB0b0NlbGwgaXMgYSBoYXJk
d2FyZSBzZWN1cml0eSBlbmdpbmUuDQo+ID4gVGhpcyBwYXRjaCBpbnRyb2R1Y2VzIGRyaXZlciBm
b3IgaXRzIFRSTkcgKFRydWUgUmFuZG9tIE51bWJlcg0KPiA+IEdlbmVyYXRvcikgZW5naW5lLg0K
PiANCj4gVGhhbmtzIGZvciB5b3VyIHNlcmllcyENCj4gDQo+IEkgYW0gd29uZGVyaW5nIHdoYXQg
aXMgdGhlIHJlbGF0aW9uIGJldHdlZW4gdGhpcyBhbmQNCj4gRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL2NyeXB0by9hcm0tY3J5cHRvY2VsbC50eHQ/DQoNCkFybSBUcnVzdFpvbmUg
Q3J5cHRvQ2VsbCBoYXJkd2FyZSBjb250YWlucyBib3RoIGNyeXB0b2dyYXBoaWMgZW5naW5lIChj
Y3JlZSkgYW5kIHRydWUgcmFuZG9tIG51bWJlciBnZW5lcmF0b3IgZW5naW5lIChjY3RybmcpLg0K
VGhlc2UgYXJlIHNlcGFyYXRlIGVuZ2luZXMgd2l0aCBzb21lIHNoYXJpbmcgaW4gbG9naWMgYW5k
IGludGVyZmFjZS4NCmNjdHJuZyBlbmdpbmUgbWF5IG5vdCBhbHdheXMgYmUgcHJlc2VudC4NClRo
ZSBkZXZpY2V0cmVlIGRvY3VtZW50YXRpb24gaXMgaW46DQpGb3IgY2NyZWUgLSBEb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvY3J5cHRvL2FybS1jcnlwdG9jZWxsLnR4dA0KRm9yIGNj
dHJuZyAtIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcvYXJtLWNjdHJuZy55
YW1sDQoNCj4gDQo+IEdye29ldGplLGVldGluZ31zLA0KPiANCj4gICAgICAgICAgICAgICAgICAg
ICAgICAgR2VlcnQNCg0KSGFkYXINCg==
