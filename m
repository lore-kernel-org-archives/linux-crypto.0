Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524B7C54FCC
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 13:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21D762076A
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 13:13:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="1fVG6V0v";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="1fVG6V0v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgDUNNJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 09:13:09 -0400
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:49663
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728720AbgDUNNI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 09:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+97hXmnKliAGSTkxFUBXTXyzWU8DhspDxggPzo7KMo=;
 b=1fVG6V0vsqi3QI1dOfEFuBO0aDV0o4dEw8kk1Saggfi8zoBGT970DrcvZ3yMP7ysHmi+c4zZcSKXSiirDsolhEALz8rwRL5vZVXVhV3QLfeSf26WZvxwKMo9T0rPm+AdPwOoPFzuZ+OJpYsFFEByRcIfsAfcBzW0DcK9gE596WA=
Received: from DB6P193CA0017.EURP193.PROD.OUTLOOK.COM (2603:10a6:6:29::27) by
 AM0PR08MB5332.eurprd08.prod.outlook.com (2603:10a6:208:17e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.25; Tue, 21 Apr 2020 13:13:02 +0000
Received: from DB5EUR03FT039.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:29:cafe::4b) by DB6P193CA0017.outlook.office365.com
 (2603:10a6:6:29::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Tue, 21 Apr 2020 13:13:02 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT039.mail.protection.outlook.com (10.152.21.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.18 via Frontend Transport; Tue, 21 Apr 2020 13:13:01 +0000
Received: ("Tessian outbound cbb03e3a1db0:v53"); Tue, 21 Apr 2020 13:13:01 +0000
X-CR-MTA-TID: 64aa7808
Received: from e7e03c1999a5.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6E3AD4A7-78E1-461C-A1D2-2B04198C22B1.1;
        Tue, 21 Apr 2020 13:12:56 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id e7e03c1999a5.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 21 Apr 2020 13:12:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECuTN2FJICM5qXbO7mgcX52XBuFZdhLAfWOiW4SQn5CEQzEsZ1rOHvTYqOlWnjf1udI2p9ORXoQ0gZm7pb9CEvuQS7f5o9XJgTBoDE0XE91uIA+SKLNBgxl/pOVMKH9pjqCSfPMTOofMiPkrNEVIg6N+LpONHEDYqoPSgs9PjwF7BiLHmUI4c8mSERndnLt8RCX/Tr1GD2eHhF1duRTAFumnj9h8YxOK4O8ogwNZSZS/Uhg35RmPJuLVRf1/Et8Q3Y5GQaShrT3nWnYhdjTl9//tZF3SU3L9MWFNUK3lYaynCfFP3+kcr7NOrJzNLMR9UE9JVC735kmG4H/T4AOYJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+97hXmnKliAGSTkxFUBXTXyzWU8DhspDxggPzo7KMo=;
 b=BHk2qJJ3r1g06J9Oall/Bpa8nc9r2mDXn8EG2XP1forAY6Hq+FSjFWcvd5gDYuweGUddNjzU/JZpp6z/IwojXyjvGwJ7xtToB2uJe9RyyTkskCVMvOTr6qre/BJH+TrOMoHVTZK2h10gJFDHD1bzhG+7AtLRg0ZLB/cQHyrAjPeoQAnzFSHd0EnKlAwllv4uw5Oo4YS8VGjCioLbfu9j9lhOshxU2PS4AQXvUGQfGTpKK0DVUutwHP9ZjORDVQCAhyI5oQw1t955qWjZwTT28aIx3yRswNvLP7YKpZByil3D0duAkRBpqWZkSsqeNsRNLuo5Ou+k1PdOgki3vqdOIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+97hXmnKliAGSTkxFUBXTXyzWU8DhspDxggPzo7KMo=;
 b=1fVG6V0vsqi3QI1dOfEFuBO0aDV0o4dEw8kk1Saggfi8zoBGT970DrcvZ3yMP7ysHmi+c4zZcSKXSiirDsolhEALz8rwRL5vZVXVhV3QLfeSf26WZvxwKMo9T0rPm+AdPwOoPFzuZ+OJpYsFFEByRcIfsAfcBzW0DcK9gE596WA=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2472.eurprd08.prod.outlook.com (2603:10a6:4:a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Tue, 21 Apr
 2020 13:12:54 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2921.027; Tue, 21 Apr 2020
 13:12:54 +0000
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
Thread-Index: AQHWA/55FVE3P4G/jUCyx1dFw6sOc6iB5dAAgAAfijCAACaPAIABiIAQ
Date:   Tue, 21 Apr 2020 13:12:54 +0000
Message-ID: <DB6PR0802MB25330B64ABAE083E31B427DDE9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
 <CAMuHMdUUJATs+G-hvty=fgyrhyx1EafpFHoWfcm=V_tVLn3q2A@mail.gmail.com>
 <DB6PR0802MB25330E55914346B46288C712E9D40@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <CAMuHMdV1Lp0uEOm_KtUA-nF7-6y1kfyvArcunrLipp6h5A_GMw@mail.gmail.com>
In-Reply-To: <CAMuHMdV1Lp0uEOm_KtUA-nF7-6y1kfyvArcunrLipp6h5A_GMw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 2ecacf09-bf86-4b65-8faa-75235829444c.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1f73fd6a-76bc-413c-9a64-08d7e5f5b866
x-ms-traffictypediagnostic: DB6PR0802MB2472:|DB6PR0802MB2472:|AM0PR08MB5332:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB53324BCBF0F48ED1366A57B3E9D50@AM0PR08MB5332.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 038002787A
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(53546011)(6506007)(54906003)(66946007)(316002)(26005)(7696005)(71200400001)(9686003)(55016002)(52536014)(5660300002)(66446008)(64756008)(66556008)(66476007)(7416002)(186003)(2906002)(8676002)(8936002)(81156014)(76116006)(6916009)(86362001)(4326008)(478600001)(33656002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: d6r9mDdhR596k42uFXDpPMoN/mnWZ84CIXr0Wxfoc7opmZkH98Cj0hlqV91WJfb/H5jZrva+SRjTle1sDLSKxFwgsmZzYYCQ6aUVaskrkySv/Jg6b93C1j+HL40iimSlJrOC2K4FivMZTLbWMTFiQhvuN2QygsxHfEeQedDM9YWfzGj6GxFbKnQzEbmOxw459DC5quiF15Flo2fVAw4PgHJiBRJOuPgG4PNYrRYiwcH87pYdi1PZ9Hp/DyU4Zfn5e9J8bfwCFDDT+3GApVk8x0RCCgEYc5VkcU7eoHzoHScOJcfrplJfehN5xVPNT372Fo2qb2mM8BGBIOnidZaQMecud0CtUoSEk5CxLzXHUiaVK2CBuKTa//6SNO1pypSb+Y5ZNPDIDUsY3V5n2IkR14gubi2CY27SB5iT7qeL2a3uDbKlK3aEBBh99QvjPiBT
x-ms-exchange-antispam-messagedata: vGN885KL0W1STO23GIU7dgy8BA2N87FYRMDAxIdKQKwpGn2FWx2HVhfZYSDeqyjUdCqyILDeAHsiGO2RVb0tCdo9fxvDn38l3xAJPF5dpxpRapKlKot4zB2xw19JOBWLPWGkvxr6UtFbdC2vwDvi1w==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2472
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT039.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(396003)(346002)(46966005)(6862004)(4326008)(478600001)(450100002)(55016002)(70206006)(70586007)(9686003)(5660300002)(52536014)(186003)(336012)(316002)(82740400003)(47076004)(26005)(2906002)(33656002)(54906003)(86362001)(8936002)(7696005)(6506007)(356005)(81166007)(81156014)(53546011)(8676002);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 96d2b82e-25f0-42d7-5a9f-08d7e5f5b3ba
X-Forefront-PRVS: 038002787A
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BhBhTxpLvbTZJ9tpA2DI6cmh/65XpzsU+WlP2fKNcCa9H9+FDuW1zlPKYFNkUvKyB7httqvaRxvZdaOlNk/n+w1MhU9/E7gofzV6E4ZCictLDdV4y0n03WLXx5LFDQBF2U89981u+Gxu6SRpR7x5mCT/LykLh/rxQ4WZNZNNGpL/wHRfymNDj/mstwpnDMRkvizt1l71NiPLN2cQ4IL78kN7BeraSdg0oZoSxvKlC5cdu8Tx8eGNe+CuOIjM8SIIOyUQDrQ6uSD8Q8Qt/I0fkc9f7DmYv6Xeq/sjNJ2sLFC8/xMK/JXZj254lE5Cof6Tqf7tBp+e3qGVy36RvsgwfHZRaxcahnsBNHeEpNyM841kxsn9lSU+KyKd56M/ydz4sMIccXD7LrNhrlf481OldYEIMcQs9QVzGxK23HXYxDgeah8DRljltpv7xE0y9cIl/aDKReA9mL7PCM8ZijUaQcqlEZ8vUFLRAmWR1y5xkjLRq+aea+YAo++FTwwvb5wnBp4jVijc8b3Z+Tc4jnbCrA==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 13:13:01.9574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f73fd6a-76bc-413c-9a64-08d7e5f5b866
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5332
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgR2VlcnQsDQoNClRvIGJldHRlciBleHBsYWluIHRoZSByZWxhdGlvbnNoaXAgYmV0d2VlbiBj
Y3JlZSBhbmQgY2N0cm5nIGRyaXZlcnMsIGhlcmUgYW4gZGVzY3JpcHRpb24gb2YgdGhlIHVuZGVy
bHlpbmcgaGFyZHdhcmUgYW5kIHRoZSByZWxhdGlvbnNoaXAgdG8gdGhlIHR3byBkcml2ZXJzOg0K
DQpBcm0gVHJ1c3Rab25lIENyeXB0b0NlbGwgaXMgYSBoYXJkd2FyZSBibG9jayB0aGF0IGltcGxl
bWVudHMgdHdvIHNlcGFyYXRlIGFuZCBkaXNjcmVldCwgYWx0aG91Z2ggcmVsYXRlZCwgaW50ZXJm
YWNlczogb25lIGZvciB0aGUgUmljaCBFeGVjdXRpb24gRW52aXJvbm1lbnQgIChyZWFkOiBMaW51
eCkgYW5kIHRoZSBvdGhlciBmb3IgdGhlIFRydXN0ZWQgRXhlY3V0aW9uIEVudmlyb25tZW50IChl
LmcuIFRydXN0eSwgT3AtVEVFKS4NCg0KVGhlIGNjcmVlIGRyaXZlciBleHBvc2VzIHRoZSBSRUUg
aW50ZXJmYWNlIG9mIENyeXB0b0NlbGwgdG8gTGludXguIFdoZXJlIGEgU29DIHZlbmRvciBpbXBs
ZW1lbnRzIGJvdGggUkVFIGFuZCBURUUgaW4gdGhlaXIgZGVzaWduLCB0aGF0IGlzIGFsbCB0aGF0
IGlzIG5lZWRlZC4NCg0KSG93ZXZlciwgd2UgaGF2ZSBzb21lIGN1c3RvbWVycyB0aGF0IG1ha2Ug
dXNlIENyeXB0b0NlbGwgYnV0IG5ldmVyIGltcGxlbWVudCBhIFRydXN0ZWQgRXhlY3V0aW9uIEVu
dmlyb25tZW50LiBUaGlzIGlzIGEgZGVzaWduIGRlY2lzaW9uIHRha2VuIHdoZW4gdGhlIFNvQyBo
YXJkd2FyZSBpcyBiZWluZyBkZXNpZ25lZCBhbmQgbm90IGEgc29mdHdhcmUgY29udHJvbGxlZCBj
b25maWd1cmF0aW9uLCBhcyBpdCBpbnZvbHZlcyBob3cgdGhlIGJ1c2VzIGFyZSBsYWlkIG91dC4g
U29tZSBvZiB0aGVzZSBjdXN0b21lcnMgaGF2ZSByZXF1ZXN0ZWQgZnJvbSB1cyB0byBhbGxvdyBt
YWtpbmcgdXNlIGluIExpbnV4IG9mIHRoZSBUUk5HIHJlc291cmNlcyB3aGljaCBhcmUgbm9ybWFs
bHkgYXNzb2NpYXRlZCB3aXRoIHRoZSBURUUgc2lkZSB3aGVuIGl0IGlzIG5vdCBpbiB1c2UuIEZv
ciB0aGVzZSBjdXN0b21lcnMsIHRoZSBjY3RybmcgZHJpdmVyIGFsbG93cyBtYWtpbmcgdXNlIGlu
IExpbnV4IHRoZSBUUk5HIHdoaWNoIGlzIG5vcm1hbGx5IHBhcnQgb2YgdGhlIFRFRSBzaWRlIG9m
IENyeXB0b0NlbGwuDQoNCkkgYW0gZ3Vlc3NpbmcgYmFzZWQgb24gbWFya2V0IHNlZ21lbnQgdGhh
dCB0aGlzIGlzIE5PVCB0aGUgY2FzZSB3aXRoIHRoZSBSZW5lc2FzIGJvYXJkcyB5b3UgYXJlIG1h
aW50YWluLg0KDQpOZXZlcnRoZWxlc3MsIHdlIG9mIGNvdXJzZSB2ZXJ5IG11Y2ggd2VsY29tZSB5
b3VyIHJldmlldywgaW5wdXQgIGFuZCBjb250cmlidXRpb24gdGhhdCBoYXMgcHJvdmVkIGV4dHJl
bWVseSB2YWx1YWJsZSB3aXRoIHRoZSBjY3JlZSBkcml2ZXIuIPCfmYINCg0KQlIsDQpIYWRhciAm
IEdpbGFkDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR2VlcnQgVXl0
dGVyaG9ldmVuIDxnZWVydEBsaW51eC1tNjhrLm9yZz4NCj4gDQo+IEhpIEhhZGFyLA0KPiANCj4g
T24gTW9uLCBBcHIgMjAsIDIwMjAgYXQgMjoyNyBQTSBIYWRhciBHYXQgPEhhZGFyLkdhdEBhcm0u
Y29tPiB3cm90ZToNCj4gPiA+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnRAbGludXgt
bTY4ay5vcmc+DQo+ID4gPiBTZW50OiBNb25kYXksIDIwIEFwcmlsIDIwMjAgMTI6MzUNCj4gPiA+
DQo+ID4gPiBPbiBGcmksIE1hciAyNywgMjAyMCBhdCA3OjExIEFNIEhhZGFyIEdhdCA8aGFkYXIu
Z2F0QGFybS5jb20+IHdyb3RlOg0KPiA+ID4gPiBUaGUgQXJtIENyeXB0b0NlbGwgaXMgYSBoYXJk
d2FyZSBzZWN1cml0eSBlbmdpbmUuDQo+ID4gPiA+IFRoaXMgcGF0Y2ggaW50cm9kdWNlcyBkcml2
ZXIgZm9yIGl0cyBUUk5HIChUcnVlIFJhbmRvbSBOdW1iZXINCj4gPiA+ID4gR2VuZXJhdG9yKSBl
bmdpbmUuDQo+ID4gPg0KPiA+ID4gVGhhbmtzIGZvciB5b3VyIHNlcmllcyENCj4gPiA+DQo+ID4g
PiBJIGFtIHdvbmRlcmluZyB3aGF0IGlzIHRoZSByZWxhdGlvbiBiZXR3ZWVuIHRoaXMgYW5kDQo+
ID4gPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvY3J5cHRvL2FybS1jcnlwdG9j
ZWxsLnR4dD8NCj4gPg0KPiA+IEFybSBUcnVzdFpvbmUgQ3J5cHRvQ2VsbCBoYXJkd2FyZSBjb250
YWlucyBib3RoIGNyeXB0b2dyYXBoaWMgZW5naW5lDQo+IChjY3JlZSkgYW5kIHRydWUgcmFuZG9t
IG51bWJlciBnZW5lcmF0b3IgZW5naW5lIChjY3RybmcpLg0KPiANCj4gT0suDQo+IA0KPiA+IFRo
ZXNlIGFyZSBzZXBhcmF0ZSBlbmdpbmVzIHdpdGggc29tZSBzaGFyaW5nIGluIGxvZ2ljIGFuZCBp
bnRlcmZhY2UuDQo+IA0KPiBEbyB0aGV5IHNoYXJlIHRoZSBzYW1lIHJlZ2lzdGVyIGJsb2NrPw0K
PiANCj4gPiBjY3RybmcgZW5naW5lIG1heSBub3QgYWx3YXlzIGJlIHByZXNlbnQuDQo+IA0KPiBJ
IGFzc3VtZSB0aGF0IGFwcGxpZXMgdG8gZS5nLiB0aGUgb2xkZXIgNjMwcD8NCj4gDQo+ID4gVGhl
IGRldmljZXRyZWUgZG9jdW1lbnRhdGlvbiBpcyBpbjoNCj4gPiBGb3IgY2NyZWUgLQ0KPiA+IERv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9jcnlwdG8vYXJtLWNyeXB0b2NlbGwudHh0
DQo+ID4gRm9yIGNjdHJuZyAtIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcv
YXJtLWNjdHJuZy55YW1sDQo+IA0KPiBUaGFuayB5b3UsIEkgaGFkIGFscmVhZHkgcmVhZCBib3Ro
IGRvY3VtZW50cy4NCj4gDQo+IA0KPiBHcntvZXRqZSxlZXRpbmd9cywNCj4gDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgIEdlZXJ0DQo+IA0KPiAtLQ0KPiBHZWVydCBVeXR0ZXJob2V2ZW4gLS0g
VGhlcmUncyBsb3RzIG9mIExpbnV4IGJleW9uZCBpYTMyIC0tIGdlZXJ0QGxpbnV4LQ0KPiBtNjhr
Lm9yZw0KPiANCj4gSW4gcGVyc29uYWwgY29udmVyc2F0aW9ucyB3aXRoIHRlY2huaWNhbCBwZW9w
bGUsIEkgY2FsbCBteXNlbGYgYSBoYWNrZXIuIEJ1dA0KPiB3aGVuIEknbSB0YWxraW5nIHRvIGpv
dXJuYWxpc3RzIEkganVzdCBzYXkgInByb2dyYW1tZXIiIG9yIHNvbWV0aGluZyBsaWtlIHRoYXQu
DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLS0gTGludXMgVG9ydmFsZHMNCg==
