Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4110C54FD0
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 15:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F4CF206D9
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 15:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="8tNxBBDQ";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="8tNxBBDQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgDUPNX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:13:23 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:48513
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726018AbgDUPNW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 11:13:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NaHHaPPv+kMzq4SjDNdDMFt99lpNX8aI7217pXMWMjc=;
 b=8tNxBBDQwP1R+ddp5jgfYtVq0fh/qbxmbAd+gSmHCahknxKDcerk2zQi0J4e0sY1RbW2pbi9c7QwWTT5G1PESKLrc6mNq7cZDO6cOJeiJ5qU7ci1endVQujhoR/2KOWVaQMcNwa8h0avrKx12w5kwVADTrB840kA+5OSSHsglKw=
Received: from DB6PR0801CA0060.eurprd08.prod.outlook.com (2603:10a6:4:2b::28)
 by VI1PR0801MB1678.eurprd08.prod.outlook.com (2603:10a6:800:51::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Tue, 21 Apr
 2020 15:13:13 +0000
Received: from DB5EUR03FT043.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:2b:cafe::d7) by DB6PR0801CA0060.outlook.office365.com
 (2603:10a6:4:2b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend
 Transport; Tue, 21 Apr 2020 15:13:12 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT043.mail.protection.outlook.com (10.152.20.236) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.18 via Frontend Transport; Tue, 21 Apr 2020 15:13:12 +0000
Received: ("Tessian outbound 43fc5cd677c4:v53"); Tue, 21 Apr 2020 15:13:12 +0000
X-CR-MTA-TID: 64aa7808
Received: from c38189a6fac8.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E5A80E8B-DE16-4C77-B1F7-70499E2BF127.1;
        Tue, 21 Apr 2020 15:13:07 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c38189a6fac8.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 21 Apr 2020 15:13:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjyL/cUwJ+kIh/nDT5usdbkuPpOEcawSLXcV8PUb/69FB0HvxSl7yxM2pmodX1EiXbWD54M1r7yOxmYNGEDLNzm+5mrvRwXCfWb8n3tNsl/0bKe3qI+qk4JNJaG72LazURrlLp4gDe7CTXs7Gt70NbmC8n4CnTxZtGb6nBfpESbmFhLm+1WiKPF3LPRBicD3IxvM2rP9naRUoNx5xHYP+xBMXGpex3fAloqn0JsEGTrgWC5AXwRp9C2/UxKu0N7p3NqmDCFDMxuxHRMVN+SmpiSMYKwdfrfRoR9SDedTa/HnerXaI4zg3VB74ZFCH6sYFEM6opV/vuKLC3u7kTJZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NaHHaPPv+kMzq4SjDNdDMFt99lpNX8aI7217pXMWMjc=;
 b=Ccfl8iaQruOKv/Co/kY2KZJuIzFjvKoeIGov+nA5NsxtBKIIi1sE6xZ5jW0AZWXJkYwyWSP6ZnSI221fwJCSbFK4mFEv4h7Mku9PaV0D+vmpD2xqgLzdD1PYnHFPrT4M/218GrWLc1wen9+FUR5/+HAIwyEFWUi1hQ1im1vBwDt9u7gX0BFzP/9x3UO8kOI7RU0SzLh6V/ACebxZq/Nm6s/l8KNDQAqcQqL9kMz3vEm1rnEBVdHqrPw28m7frAkn75zgO5g/haACgiQ/KCtYW1EjDEPsnd8fH3663LKmbuGtB+OPtDYCNFwULNS3Jkpzcdir0pt81w5m5w4t/Glefg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NaHHaPPv+kMzq4SjDNdDMFt99lpNX8aI7217pXMWMjc=;
 b=8tNxBBDQwP1R+ddp5jgfYtVq0fh/qbxmbAd+gSmHCahknxKDcerk2zQi0J4e0sY1RbW2pbi9c7QwWTT5G1PESKLrc6mNq7cZDO6cOJeiJ5qU7ci1endVQujhoR/2KOWVaQMcNwa8h0avrKx12w5kwVADTrB840kA+5OSSHsglKw=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2376.eurprd08.prod.outlook.com (2603:10a6:4:86::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Tue, 21 Apr
 2020 15:13:06 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2921.027; Tue, 21 Apr 2020
 15:13:06 +0000
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
Thread-Index: AQHWA/5/37ByIllroUeQ0w3cVWDDJKiCK72AgABugaCAASDNgIAAFS7Q
Date:   Tue, 21 Apr 2020 15:13:05 +0000
Message-ID: <DB6PR0802MB2533347A35A466B99ADD4D23E9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
 <1585289423-18440-3-git-send-email-hadar.gat@arm.com>
 <CAMuHMdV6Uce79MPs7jfJfX3WOqAMH22vf2V_=Ui0zLHYqsJ+Xg@mail.gmail.com>
 <DB6PR0802MB25338BD19DD2F7E662BB1065E9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <CAMuHMdWujabV8dr=EojXFBVD0TcUuZ2kCGjjo93u=PE-AmzVHA@mail.gmail.com>
In-Reply-To: <CAMuHMdWujabV8dr=EojXFBVD0TcUuZ2kCGjjo93u=PE-AmzVHA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: d0d416ed-5fcb-4ae9-b9bc-0bf2aac0ca9d.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1906ffbc-4f05-40c8-f6f5-08d7e6068273
x-ms-traffictypediagnostic: DB6PR0802MB2376:|DB6PR0802MB2376:|VI1PR0801MB1678:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0801MB167843365DCB6464AF52EC2FE9D50@VI1PR0801MB1678.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:5236;OLM:5236;
x-forefront-prvs: 038002787A
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(54906003)(26005)(4326008)(7696005)(6916009)(71200400001)(52536014)(9686003)(55016002)(64756008)(66556008)(66476007)(66446008)(76116006)(66946007)(8676002)(7416002)(81156014)(316002)(33656002)(2906002)(186003)(5660300002)(6506007)(86362001)(478600001)(8936002)(53546011);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: KadrXoUaBSIOluUzocp+IeLBUolp42lqW2NSfHP3aUyytMhovlsiOdQO+EX0xDOMY0q5/4j4KnE/cz6zqukhfvinPy6aC1R8AiAgZGLvuTeV30hdAW74L0aGXB4F22tw5SsfmjbLr4YBRX5NPHO/CTJ7SvlXJ7F2lX3ardH2It9ohWy8kD9b2xKLxnBFphhMMJ8cykeIT1VeuZOPkqw1ZB0XLFehd4T7ao0T13t8GHH8GkbEOX5hg8m+GGnGomV/YwvvhsJccci+KkoARgjZG90Q+mGM0cJZ70p9kgXsLupWpSStGSF+rdaFdEXsv1nqPAYLlBayBTHviD/qPxhTl5X2tRQpsUplW6/HgJCbGO5p81ERPtB+yw7Aqg8+z2JRGghgddBLjkoD9dK479njFDHADs2YOROYopjLgHJjT3uf0J7qR/mDVoZeu8dzFj1D
x-ms-exchange-antispam-messagedata: niVE6ALTDIZTWSjHGvy0Q93uPgEVLV/DDyErvtT1Rpv5LPAA+VX4pqE+l8ZJoKipNhsxGH550xf9RgGwruTsE4fJvlHHz2WGnKISJErxWSTBYRJlAEUGFKIHYA8eQ2P4YkUQdUE0aH++dwwFixA3aA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2376
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT043.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(346002)(376002)(46966005)(6506007)(86362001)(26005)(82740400003)(70586007)(70206006)(7696005)(81166007)(8676002)(336012)(47076004)(186003)(2906002)(55016002)(53546011)(9686003)(478600001)(356005)(5660300002)(4326008)(8936002)(52536014)(316002)(81156014)(54906003)(33656002)(6862004)(450100002);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 81558274-2623-4682-0ca2-08d7e6067e9c
X-Forefront-PRVS: 038002787A
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bsHL7GhthTdxu1BOUc4gAnjnvvwUs/7cm7w4TZ5ePXqEUhNhyzhTLMC4jXWh4uogacXtXhECPQnJgtPBdE3dZYAzlbNWIbh/jH/llY4yNC+aGC+emXksrH7I+rP6SXmTPpHqbeUfnXaJaQaEY85Z0UvMsYuggt/kGnBCGLqKXioM53Xxs5rfog/crkd4yD2WO3hG+oxeBFiq+UBI4xOltFZOr1UY8CMmmp0NsWPVZxD9DJqyp8F/yhsu4GP52k3MX2Hp9gVS3yJynLwIbpmPoczz3NxgQyMvU6ISEGx4avVirpgqd9QQsKAQQAtB8aRDSJsYVAOiSZjiTjvMj4Quj6hLktK2ffnI0Qh6WsGErOsei86Ss/CcUyd/YzIlTbNF0QssB5pHvgfI3m5uyO2+rwdr8LK4cvpq4BtFdM+Nfw0Wxk1y599dm2q6QxsgdaNiRak4VQYaiV16Re/Mac1bdYsOuwBdxTU/dcdb0FLNkBbOY5GQZQc1tZyPaXXJrsHg7Wp3kEnfht4q8fHyik98/A==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 15:13:12.8714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1906ffbc-4f05-40c8-f6f5-08d7e6068273
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1678
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnRAbGludXgtbTY4ay5vcmc+DQo+IA0K
PiBIaSBIYWRhciwNCj4gDQo+IE9uIFR1ZSwgQXByIDIxLCAyMDIwIGF0IDM6MTYgUE0gSGFkYXIg
R2F0IDxIYWRhci5HYXRAYXJtLmNvbT4gd3JvdGU6DQo+ID4gPiBGcm9tOiBHZWVydCBVeXR0ZXJo
b2V2ZW4gPGdlZXJ0QGxpbnV4LW02OGsub3JnPg0KPiA+ID4gU2VudDogTW9uZGF5LCAyMCBBcHJp
bCAyMDIwIDE2OjQ1DQo+ID4gPg0KPiA+ID4gT24gRnJpLCBNYXIgMjcsIDIwMjAgYXQgNzoxMSBB
TSBIYWRhciBHYXQgPGhhZGFyLmdhdEBhcm0uY29tPiB3cm90ZToNCj4gPiA+ID4gSW50cm9kdWNl
IGxvdyBsZXZlbCBBcm0gQ3J5cHRvQ2VsbCBUUk5HIEhXIHN1cHBvcnQuDQo+ID4gPiA+DQo+ID4g
PiA+IFNpZ25lZC1vZmYtYnk6IEhhZGFyIEdhdCA8aGFkYXIuZ2F0QGFybS5jb20+DQo+ID4gPg0K
PiA+ID4gVGhhbmtzIGZvciB5b3VyIHBhdGNoIQ0KPiA+ID4NCj4gPiA+ID4gLS0tIC9kZXYvbnVs
bA0KPiA+ID4gPiArKysgYi9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2NjdHJuZy5jDQo+ID4gPg0K
PiA+ID4gPiArc3RhdGljIGludCBjY3RybmdfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAq
cGRldikgew0KPiA+ID4gPiArICAgICAgIHN0cnVjdCByZXNvdXJjZSAqcmVxX21lbV9jY19yZWdz
ID0gTlVMTDsNCj4gPiA+ID4gKyAgICAgICBzdHJ1Y3QgY2N0cm5nX2RydmRhdGEgKmRydmRhdGE7
DQo+ID4gPiA+ICsgICAgICAgc3RydWN0IGRldmljZSAqZGV2ID0gJnBkZXYtPmRldjsNCj4gPiA+
ID4gKyAgICAgICBpbnQgcmMgPSAwOw0KPiA+ID4gPiArICAgICAgIHUzMiB2YWw7DQo+ID4gPiA+
ICsgICAgICAgaW50IGlycTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICAgIGRydmRhdGEgPSBk
ZXZtX2t6YWxsb2MoZGV2LCBzaXplb2YoKmRydmRhdGEpLCBHRlBfS0VSTkVMKTsNCj4gPiA+ID4g
KyAgICAgICBpZiAoIWRydmRhdGEpDQo+ID4gPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVO
T01FTTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICAgIGRydmRhdGEtPnJuZy5uYW1lID0gZGV2
bV9rc3RyZHVwKGRldiwgZGV2X25hbWUoZGV2KSwNCj4gPiA+IEdGUF9LRVJORUwpOw0KPiA+ID4g
PiArICAgICAgIGlmICghZHJ2ZGF0YS0+cm5nLm5hbWUpDQo+ID4gPiA+ICsgICAgICAgICAgICAg
ICByZXR1cm4gLUVOT01FTTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICAgIGRydmRhdGEtPnJu
Zy5yZWFkID0gY2N0cm5nX3JlYWQ7DQo+ID4gPiA+ICsgICAgICAgZHJ2ZGF0YS0+cm5nLnByaXYg
PSAodW5zaWduZWQgbG9uZylkcnZkYXRhOw0KPiA+ID4gPiArICAgICAgIGRydmRhdGEtPnJuZy5x
dWFsaXR5ID0gQ0NfVFJOR19RVUFMSVRZOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICAgICAgcGxh
dGZvcm1fc2V0X2RydmRhdGEocGRldiwgZHJ2ZGF0YSk7DQo+ID4gPiA+ICsgICAgICAgZHJ2ZGF0
YS0+cGRldiA9IHBkZXY7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgICBkcnZkYXRhLT5jaXJj
LmJ1ZiA9IChjaGFyICopZHJ2ZGF0YS0+ZGF0YV9idWY7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAg
ICAgICAvKiBHZXQgZGV2aWNlIHJlc291cmNlcyAqLw0KPiA+ID4gPiArICAgICAgIC8qIEZpcnN0
IENDIHJlZ2lzdGVycyBzcGFjZSAqLw0KPiA+ID4gPiArICAgICAgIHJlcV9tZW1fY2NfcmVncyA9
IHBsYXRmb3JtX2dldF9yZXNvdXJjZShwZGV2LA0KPiA+ID4gSU9SRVNPVVJDRV9NRU0sIDApOw0K
PiA+ID4gPiArICAgICAgIC8qIE1hcCByZWdpc3RlcnMgc3BhY2UgKi8NCj4gPiA+ID4gKyAgICAg
ICBkcnZkYXRhLT5jY19iYXNlID0gZGV2bV9pb3JlbWFwX3Jlc291cmNlKGRldiwNCj4gPiA+IHJl
cV9tZW1fY2NfcmVncyk7DQo+ID4gPiA+ICsgICAgICAgaWYgKElTX0VSUihkcnZkYXRhLT5jY19i
YXNlKSkgew0KPiA+ID4gPiArICAgICAgICAgICAgICAgZGV2X2VycihkZXYsICJGYWlsZWQgdG8g
aW9yZW1hcCByZWdpc3RlcnMiKTsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBQVFJf
RVJSKGRydmRhdGEtPmNjX2Jhc2UpOw0KPiA+ID4gPiArICAgICAgIH0NCj4gPiA+ID4gKw0KPiA+
ID4gPiArICAgICAgIGRldl9kYmcoZGV2LCAiR290IE1FTSByZXNvdXJjZSAoJXMpOiAlcFJcbiIs
DQo+ID4gPiA+ICsgcmVxX21lbV9jY19yZWdzLQ0KPiA+ID4gPm5hbWUsDQo+ID4gPiA+ICsgICAg
ICAgICAgICAgICByZXFfbWVtX2NjX3JlZ3MpOw0KPiA+ID4gPiArICAgICAgIGRldl9kYmcoZGV2
LCAiQ0MgcmVnaXN0ZXJzIG1hcHBlZCBmcm9tICVwYSB0byAweCVwXG4iLA0KPiA+ID4gPiArICAg
ICAgICAgICAgICAgJnJlcV9tZW1fY2NfcmVncy0+c3RhcnQsIGRydmRhdGEtPmNjX2Jhc2UpOw0K
PiA+ID4gPiArDQo+ID4gPiA+ICsgICAgICAgLyogVGhlbiBJUlEgKi8NCj4gPiA+ID4gKyAgICAg
ICBpcnEgPSBwbGF0Zm9ybV9nZXRfaXJxKHBkZXYsIDApOw0KPiA+ID4gPiArICAgICAgIGlmIChp
cnEgPCAwKSB7DQo+ID4gPiA+ICsgICAgICAgICAgICAgICBkZXZfZXJyKGRldiwgIkZhaWxlZCBn
ZXR0aW5nIElSUSByZXNvdXJjZVxuIik7DQo+ID4gPiA+ICsgICAgICAgICAgICAgICByZXR1cm4g
aXJxOw0KPiA+ID4gPiArICAgICAgIH0NCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICAgIC8qIHBh
cnNlIHNhbXBsaW5nIHJhdGUgZnJvbSBkZXZpY2UgdHJlZSAqLw0KPiA+ID4gPiArICAgICAgIHJj
ID0gY2NfdHJuZ19wYXJzZV9zYW1wbGluZ19yYXRpbyhkcnZkYXRhKTsNCj4gPiA+ID4gKyAgICAg
ICBpZiAocmMpIHsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIGRldl9lcnIoZGV2LCAiRmFpbGVk
IHRvIGdldCBsZWdhbCBzYW1wbGluZyByYXRpbyBmb3Igcm9zY1xuIik7DQo+ID4gPiA+ICsgICAg
ICAgICAgICAgICByZXR1cm4gcmM7DQo+ID4gPiA+ICsgICAgICAgfQ0KPiA+ID4gPiArDQo+ID4g
PiA+ICsgICAgICAgcmMgPSBjY190cm5nX2Nsa19pbml0KGRydmRhdGEpOw0KPiA+ID4gPiArICAg
ICAgIGlmIChyYykgew0KPiA+ID4gPiArICAgICAgICAgICAgICAgZGV2X2VycihkZXYsICJjY190
cm5nX2Nsa19pbml0IGZhaWxlZFxuIik7DQo+ID4gPiA+ICsgICAgICAgICAgICAgICByZXR1cm4g
cmM7DQo+ID4gPiA+ICsgICAgICAgfQ0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICAgICAgSU5JVF9X
T1JLKCZkcnZkYXRhLT5jb21wd29yaywgY2NfdHJuZ19jb21wd29ya19oYW5kbGVyKTsNCj4gPiA+
ID4gKyAgICAgICBJTklUX1dPUksoJmRydmRhdGEtPnN0YXJ0d29yaywgY2NfdHJuZ19zdGFydHdv
cmtfaGFuZGxlcik7DQo+ID4gPiA+ICsgICAgICAgc3Bpbl9sb2NrX2luaXQoJmRydmRhdGEtPnJl
YWRfbG9jayk7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgICAvKiByZWdpc3RlciB0aGUgZHJp
dmVyIGlzciBmdW5jdGlvbiAqLw0KPiA+ID4gPiArICAgICAgIHJjID0gZGV2bV9yZXF1ZXN0X2ly
cShkZXYsIGlycSwgY2NfaXNyLCBJUlFGX1NIQVJFRCwNCj4gPiA+ID4gKyAiY2N0cm5nIiwgZHJ2
ZGF0YSk7DQo+ID4gPg0KPiA+ID4gU2hvdWRuJ3QgdGhpcyBiZSBkb25lIGFmdGVyIGNsZWFyaW5n
IHRoZSBwZW5kaW5nIGludGVycnVwdHMgYmVsb3c/DQo+ID4NCj4gPiBJJ20gbm90IHN1cmUgd2hh
dCBkbyB5b3UgbWVhbiBpbiB5b3VyIHF1ZXN0aW9uLi4uDQo+ID4gSSBhc3N1bWUgeW91J3JlIHN1
Z2dlc3RpbmcgdGhhdCB0aGUgcmVnaXN0cmF0aW9uIG9mIHRoZSBkcml2ZXIgSVNSIGZ1bmN0aW9u
DQo+IHNob3VsZCBiZSBkb25lIG9ubHkgYWZ0ZXIgY2xlYXJpbmcgdGhlIHBlbmRpbmcgaW50ZXJy
dXB0cz8hDQo+IA0KPiBJbmRlZWQuDQo+IA0KPiA+IEFueXdheSwgYW55IHBlbmRpbmcgaW50ZXJy
dXB0IHRoYXQgbWlnaHQgZXhpc3QgaXMgaXJyZWxldmFudCB0byB0aGUNCj4gPiBjdXJyZW50IGNj
dHJuZyBkcml2ZXIgd2hpY2gganVzdCBzdGFydGVkICh3ZSdyZSBpbiB0aGUgcHJvYmUgZnVuY3Rp
b24pDQo+IA0KPiBJZiB0aGVyZSBpcyBhIHBlbmRpbmcgaW50ZXJydXB0LCB5b3VyIGludGVycnVw
dCBoYW5kbGVyICh3aGljaCByZXR1cm5zDQo+IElSUV9OT05FIGluIHRoaXMgY2FzZSkgd2lsbCBi
ZSBjYWxsZWQgcmVwZWF0ZWRseSwgdW50aWwgdGhlIGRyaXZlciBnZXRzIHRvDQo+IGNsZWFyaW5n
IHRoZSBwZW5kaW5nIGludGVycnVwdHMgYmVsb3csIG9yIHVudGlsIHRoZSBpbnRlcnJ1cHQgY29y
ZSBkZWNpZGVzIHRvDQo+IGdpdmUgdXAsIGFuZCBkaXNhYmxlIGl0IGZvciBnb29kLg0KDQpPaywg
SSBnZXQgeW91ciBwb2ludCBub3cuDQpCdXQgbm90ZSB0aGF0IHdoZW4gdGhlIGNjdHJuZyBIVyBi
b290cywgdGhlIGRlZmF1bHQgaXMgdGhhdCBhbGwgaW50ZXJydXB0cyBhcmUgbWFza2VkLCBoZW5j
ZSB0aGUgaW50ZXJydXB0IGhhbmRsZXIgd2lsbCBub3QgYmUgY2FsbGVkLg0KVGhlIHVubWFzayBv
ZiB0aGUgUk5HIGludGVycnVwdHMgaXMgZG9uZSBhZnRlcndhcmRzIGFuZCBvbmx5IHRoZW4gSVNS
IG1heSBwb3RlbnRpYWxseSBiZSBjYWxsZWQuDQoNCj4gPiA+ID4gKyAgICAgICBpZiAocmMpIHsN
Cj4gPiA+ID4gKyAgICAgICAgICAgICAgIGRldl9lcnIoZGV2LCAiQ291bGQgbm90IHJlZ2lzdGVy
IHRvIGludGVycnVwdCAlZFxuIiwgaXJxKTsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIGdvdG8g
cG9zdF9jbGtfZXJyOw0KPiA+ID4gPiArICAgICAgIH0NCj4gPiA+ID4gKyAgICAgICBkZXZfZGJn
KGRldiwgIlJlZ2lzdGVyZWQgdG8gSVJROiAlZFxuIiwgaXJxKTsNCj4gPiA+ID4gKw0KPiA+ID4g
PiArICAgICAgIC8qIENsZWFyIGFsbCBwZW5kaW5nIGludGVycnVwdHMgKi8NCj4gPiA+ID4gKyAg
ICAgICB2YWwgPSBjY19pb3JlYWQoZHJ2ZGF0YSwgQ0NfSE9TVF9SR0ZfSVJSX1JFR19PRkZTRVQp
Ow0KPiA+ID4gPiArICAgICAgIGRldl9kYmcoZGV2LCAiSVJSPTB4JTA4WFxuIiwgdmFsKTsNCj4g
PiA+ID4gKyAgICAgICBjY19pb3dyaXRlKGRydmRhdGEsIENDX0hPU1RfUkdGX0lDUl9SRUdfT0ZG
U0VULCB2YWwpOw0KPiA+ID4NCj4gPiA+IFRoZSBhYm92ZSBhY2Nlc3NlcyB0aGUgZW5naW5lJ3Mg
cmVnaXN0ZXJzLi4uDQo+ID4NCj4gPiBUaGF0IGlzIHJpZ2h0Lg0KPiA+DQo+ID4gPiA+ICsNCj4g
PiA+ID4gKyAgICAgICAvKiB1bm1hc2sgSE9TVCBSTkcgaW50ZXJydXB0ICovDQo+ID4gPiA+ICsg
ICAgICAgY2NfaW93cml0ZShkcnZkYXRhLCBDQ19IT1NUX1JHRl9JTVJfUkVHX09GRlNFVCwNCj4g
PiA+ID4gKyAgICAgICAgICAgICAgICAgIGNjX2lvcmVhZChkcnZkYXRhLCBDQ19IT1NUX1JHRl9J
TVJfUkVHX09GRlNFVCkgJg0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgfkNDX0hPU1RfUk5H
X0lSUV9NQVNLKTsNCg0KVGhlIGFib3ZlIHVubWFzayB0aGUgUk5HIGludGVycnVwdC4NCg0KPiA+
ID4gPiArDQo+ID4gPiA+ICsgICAgICAgLyogaW5pdCBQTSAqLw0KPiA+ID4gPiArICAgICAgIHJj
ID0gY2NfdHJuZ19wbV9pbml0KGRydmRhdGEpOw0KPiA+ID4gPiArICAgICAgIGlmIChyYykgew0K
PiA+ID4gPiArICAgICAgICAgICAgICAgZGV2X2VycihkZXYsICJjY190cm5nX3BtX2luaXQgZmFp
bGVkXG4iKTsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIGdvdG8gcG9zdF9jbGtfZXJyOw0KPiA+
ID4gPiArICAgICAgIH0NCj4gPiA+DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgICAvKiBpbmNy
ZW1lbnQgZGV2aWNlJ3MgdXNhZ2UgY291bnRlciAqLw0KPiA+ID4gPiArICAgICAgIHJjID0gY2Nf
dHJuZ19wbV9nZXQoZGV2KTsNCj4gPiA+DQo+ID4gPiAuLi4gYnV0IG9ubHkgaGVyZSBpcyBSdW50
aW1lIFBNIGluaXRpYWxpemVkLCBhbmQgdGhlIGRldmljZQ0KPiA+ID4gZ3VhcmFudGVlZCB0byBi
ZSBwb3dlcmVkLiAgSWYgYSBkZXZpY2UgaXMgYWNjZXNzZWQgd2hpbGUgcG93ZXJlZA0KPiA+ID4g
ZG93biwgdGhpcyBtYXkgbGVhZCB0byBhbiBhc3luY2hyb25vdXMgZXh0ZXJuYWwgYWJvcnQsIG9y
IGEgcGxhaW4gbG9ja3VwLg0KPiA+DQo+ID4gSXQgaXMgYXNzdW1lZCB0aGF0IHdoZW4gdGhlIGRy
aXZlciBpcyBwcm9iZWQgaXQgaXMgYWxyZWFkeSBwb3dlcmVkLiBPbmx5DQo+IHRoZW4sIHRoZSBk
cml2ZXIgaW5pdGlhbGl6ZXMgYW5kIGVuYWJsZXMgdGhlIHJ1bnRpbWUgUE0gdG8gYWxsb3cgcG93
ZXIgZG93bg0KPiBvZiB0aGUgSFcgd2hlbiBpdCBpcyBub3QgaW4gdXNlLg0KPiANCj4gV2hvIGd1
YXJhbnRlZXMgaXQgaXMgcG93ZXJlZCB1cD8gWW91ciBkcml2ZXIgaGFzIGluZGVlZCBlbmFibGVk
IHRoZQ0KPiAob3B0aW9uYWwpIGNsb2NrIGFib3ZlLCBidXQgaWYgdGhlIGhhcmR3YXJlIGJsb2Nr
IGlzIHBhcnQgb2YgYSBwb3dlciBkb21haW4sIGl0DQo+IG1heSBzdGlsbCBiZSBwb3dlcmVkIGRv
d24uIFRoZSBvbmx5IHdheSB0byBtYWtlIHN1cmUgYSBoYXJkd2FyZSBibG9jayBpbiBhDQo+IHBv
d2VyIGRvbWFpbiBpcyBwb3dlcmVkLCBpcyBieSBlbmFibGluZyBSdW50aW1lIFBNIGFuZCBjYWxs
aW5nDQo+IHBtX3J1bnRpbWVfZ2V0X3N5bmMoKS4NCg0KR290IGl0IG5vdyBhbmQgaW5kZWVkIHRo
aXMgbmVlZCB0byBiZSBmaXhlZC4NCkkgcmV2aWV3ZWQgYSBzaW1pbGFyIGZpeCB0aGF0IHlvdSBk
aWQgaW4gY2NyZWUsIGNvbW1pdCA4Yzc4NDlhMzAyNTVjZmQ5YTliYTQxMmIxNTE3ZTIwYTg1NzI0
NDhiLg0KTm93IEkgdW5kZXJzdGFuZCB0aGF0IHRoZSBpbml0aWFsaXphdGlvbiBvZiBydW50aW1l
LVBNIHNob3VsZCBiZSBkb25lIGJlZm9yZSBhbnkgcmVnaXN0ZXIgYWNjZXNzLg0KSSB3aWxsIGZp
eCB0aGlzIGluIGFub3RoZXIgcGF0Y2guDQoNClRoYW5rcyBhIGxvdCBmb3IgeW91ciByZXZpZXcg
YW5kIHZhbHVhYmxlIGlucHV0cy4NCkhhZGFyDQoNCg==
