Return-Path: <SRS0=DsWe=6K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D09C54FCB
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Apr 2020 12:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2200E2071C
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Apr 2020 12:50:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="14K+Teud";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="14K+Teud"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgDZMuK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Apr 2020 08:50:10 -0400
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:44842
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbgDZMuJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Apr 2020 08:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXcI1nSoJRjtBqdlAT2Bv/UFFVbuMV9E4LgTmWkaYSQ=;
 b=14K+TeudTAQaGCP+1eMf41cJBDMEz9633b3ErF0wr5Rzw3yFpgzlAob6h4noeAXwWtkD/HYTc0lokLOnacFr7KMJS4V0j5zMj4h6DXf08djW1tG7VT41iAPuy+LTP/teB/wLK9hWptq3CHg2p5cidUhgamczJwnWhNxvUGgoKKg=
Received: from DB6P192CA0001.EURP192.PROD.OUTLOOK.COM (2603:10a6:4:b8::11) by
 AM0PR08MB3140.eurprd08.prod.outlook.com (2603:10a6:208:61::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Sun, 26 Apr 2020 12:50:04 +0000
Received: from DB5EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:b8:cafe::cf) by DB6P192CA0001.outlook.office365.com
 (2603:10a6:4:b8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Sun, 26 Apr 2020 12:50:04 +0000
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
 15.20.2937.19 via Frontend Transport; Sun, 26 Apr 2020 12:50:04 +0000
Received: ("Tessian outbound 4cdf5642225a:v54"); Sun, 26 Apr 2020 12:50:04 +0000
X-CR-MTA-TID: 64aa7808
Received: from eed4c729b161.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 3E084F94-A1E4-4782-A208-A965467531EF.1;
        Sun, 26 Apr 2020 12:49:59 +0000
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id eed4c729b161.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Sun, 26 Apr 2020 12:49:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiUDExb++9H/swsvvPAaEgks5ouL+flXzTRXaefQ/y5eqNz01VmmCOqCy7k3xU3g/qdo69ggnVi/VtbUM/YpHmaFMexp56+Z1IxASGH8ecL8diVYk/dim06M5u0/Usgfh+fmdM+XKqunS9nOXENcazGdjbX0erupo+BeswmTKgbl+lIoyjcSG5637Eqr1gW71uJeZoaYC1vqzZYjIAe18zJAfVFa1dRpVlWWlaN5PHAnWKMR5QtXm7w4KKJt74B6I7e4P61tIdQL+1YVT8RLzUEP5LMRdUrVT4hhKn8eb977ev5NLtcRMEpt+572DSFPfh+YtFCgnz3DQIp3h7cM/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXcI1nSoJRjtBqdlAT2Bv/UFFVbuMV9E4LgTmWkaYSQ=;
 b=TLIjoWvdi7dCGrG/HWVB83b99NPUK1VwpTUawI//3cf8o65GekmOy0J/i+IxX9DJLJcSRSPmGN2spb3vfeNg5Ku0L3q3+/ZY98Sr62ptq0oBdCyp7tCLVYUJGNm2zAjMsA2wC73o3xQNAFApQW6Ozo5WXOHK8cTbZ/jygfU6/Lp/JffbUb56ZjXWsfZhyIR6UnkZVvMw/zuDMYx5na+hBsIK70K69Y3GIZMP7BWiuwmegZR46s1Vp+5u6+3YtA02bNrs9KJVRgImY8g5ogcAXVmTd7B2JbBEt2AZdp3e8d9VmYrES57GOrKIp4qvNyxx8Qi5exgNF5ETwjWeV/3R8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXcI1nSoJRjtBqdlAT2Bv/UFFVbuMV9E4LgTmWkaYSQ=;
 b=14K+TeudTAQaGCP+1eMf41cJBDMEz9633b3ErF0wr5Rzw3yFpgzlAob6h4noeAXwWtkD/HYTc0lokLOnacFr7KMJS4V0j5zMj4h6DXf08djW1tG7VT41iAPuy+LTP/teB/wLK9hWptq3CHg2p5cidUhgamczJwnWhNxvUGgoKKg=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6SPR00MB244.eurprd08.prod.outlook.com (2603:10a6:4:3c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Sun, 26 Apr
 2020 12:49:57 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2937.020; Sun, 26 Apr 2020
 12:49:57 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        nd <nd@arm.com>
Subject: RE: Fw: Arm CryptoCell driver -- default Y, even on machines where it
 is obviously useless
Thread-Topic: Fw: Arm CryptoCell driver -- default Y, even on machines where
 it is obviously useless
Thread-Index: AQHWFW48sqdeVFxZnkOUS/sdJEIQwah/VA9QgACqAwaAACd7AIALPwIA
Date:   Sun, 26 Apr 2020 12:49:57 +0000
Message-ID: <DB6PR0802MB25337F768E6B2DCF943AC11CE9AE0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <20200418104343.GA5132@amd>
 <DB6PR0802MB2533670AFC1473E5C5EDAD28E9D60@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <VI1PR08MB3584451F0B0B21E00ACF56A7FED70@VI1PR08MB3584.eurprd08.prod.outlook.com>
 <CAOtvUMfNgdYZF5VaqgF-51b0+KtxqgUFD6njXFX7evz1yAJc9A@mail.gmail.com>
 <CAMj1kXEGSAD2Kkjg56UhMGgjuLBSOAKJ7ZMHdzfP2szGncu-4Q@mail.gmail.com>
In-Reply-To: <CAMj1kXEGSAD2Kkjg56UhMGgjuLBSOAKJ7ZMHdzfP2szGncu-4Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: f31f464e-26dc-48b9-b3d4-f540dee485eb.0
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8cd0ffa4-7a27-49a2-c868-08d7e9e05790
x-ms-traffictypediagnostic: DB6SPR00MB244:|AM0PR08MB3140:
X-Microsoft-Antispam-PRVS: <AM0PR08MB3140F2EDFFB9DBC32F336D49E9AE0@AM0PR08MB3140.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 03853D523D
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(2906002)(478600001)(33656002)(6506007)(4326008)(86362001)(8936002)(81156014)(8676002)(26005)(55016002)(186003)(316002)(9686003)(110136005)(54906003)(52536014)(71200400001)(7696005)(5660300002)(76116006)(66446008)(64756008)(66476007)(66946007)(66556008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: esXvsptzRTmsOTnLbMeBjY/T9W8tGEDX/yaj6z27SSTqWlHCGbet3D3MiVNF6TqyuspLZItV4SDW4Rls8tfUCxOOirHIdwz0AM7jLgPbkW0IKENC8x1Wuv8bG8jaoGzMe7tY3jHpYTEkUI9ZK/mRATsZ8kMlZZIVO84gXIY5Cweg1UUEWHHL9K/bQQSgvIWNXzU65I8xbf2BfEqK7qfiZwZrGKbukQgzFarq93/hFetOLiw/sTmCN9xbFSqthTzmxRv3uDkyZf9eauuRWsL9twlvNI7nbRMBAGzCovPitcnQKPWGRStaAptHNCuMHtpL44njziumK0cCO1lBqDLAX58HKcvbCGO8C49LsGyHKoR17Ljm1Mmi6MxrT7NWAzv8BSIF8tP9l9g4Ljhei8kJu9rQv4g7yYOtyuL0j1ZUMSf8Xy1QFUv8nG5MC3iG2HMl
x-ms-exchange-antispam-messagedata: ZLW7juvki5fX3fKSuxFDXzK+okuWeWuEiRm33hOFLkvknbDJwn8Q9S3n4+20qrfOOtNeaNl86EYNJgnC99m3quF8TedosSh05OU35ai8kLRXpF3kIBC1LD1463do9APUFBbfkIOn0cTci96VN2V29qkzT7fkE1p0/3SnSEbvJNg9Ff/cJOazZKSNxq2DellJiNAfvXG+Eio9NhF82fs7jCZkQz0yoCQK2W/dgvhuDZnvPrA3eI2dn6XLObXCujfEXT7aMdWX4LuW3XgCOJ+sZ9QQa6crTccsZznYeW4fRFc2KlufKwSUgr97/dytVuIPf/p1Yzo/hHbxm84/+5uUNwObB+MEpZvj9Cgdg5o2+wAqKCaSnvTJwFqlwiqo8Zp4qOS/lv0/3x/omYRgbuyZe93fhImP6fhjPOG4K4cW7zzGlpNuVPih6YMfjmINRwJBgAawhXQF4hFZCJPoZmOfz//5vpK7uUKvoITnn2uW3vSdL7fLjGD287sxBlci1CQeEAqXoOmsJPH8QLuwTbNjzTYAV2G8ccGVHq4Pr6TZ8iOeYMf2vnjs78K0eBCwGa/e+4J8laaljCLk6JF2wQ81AKS2HQbHVbMsJbpSzTOTtikNMXLgU1t5uCge39qP6tcTBGvE3ZqIv1cS2XsOez2g3ScE+BP3+KhS/TeFyItRArU642fqvXSZO9eRMZ6DKppB52ewJS/wG1qIaZQEEsTsw6pXZU6sta07VBQDzVbsfZI5ynLoCq2Bt/4xAPF4Q3lR3iuboq8401vNX+KNGEFAfuDflvQXTiX1CmvX7kQI7UI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6SPR00MB244
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT048.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(46966005)(81166007)(110136005)(8936002)(70586007)(33656002)(81156014)(4326008)(86362001)(450100002)(2906002)(52536014)(70206006)(186003)(8676002)(9686003)(478600001)(336012)(7696005)(47076004)(5660300002)(82310400002)(82740400003)(316002)(26005)(356005)(6506007)(55016002)(54906003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: d022ecb2-c7e6-4902-c584-08d7e9e0530b
X-Forefront-PRVS: 03853D523D
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n2hUkeAfEB3yJRVUA1stu1v1K6+8/E2BL93GMCat4KL7xbtCSLFitD60Pu8ISgUHw4G/5lElaMVIOFx+xvZIpbNyRNw1hNi/FBJoFtJhLlijUGQi9PhPYuBIqpFD5p+e86rhuCiOkvVGzlgylgQzuHC5lWEtBaSUxtNuBy2ybHtXLe5fQhmXjgss5nGxKHaQ1eW8iWGIAtbP2WyBkgryQhwZ6Zi+DINdu536H01FULNUX1SoDuKsisy6R1UvHdC0ChMSXRqIPxujthY3e6XgLqlLu8fMKU0xg1pNqmPbkiDGIb2fEszjmeHySBIXVjzabXGkw0NMRMiKeB8b2Vgz1qWM9FyxA+6vfrmCd2q87bxqrXOCDOdSB+N3Bv5BAiSCVCxcNGbrMyd24cdQmOLvXXHAbjPfajM3jQHj4lCOF4u8i3dzq2ejIfoWgYqcRypHoxn4wn6wu+/NHQuuKOvaYwRLzo8YSHbW92mEyO8T8LNxjDwAMeQWSMuXszvY4/Y8REASBdFDZiSn1sH2g3FeTQ==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2020 12:50:04.7176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd0ffa4-7a27-49a2-c868-08d7e9e05790
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3140
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgQXJkLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFyZCBCaWVz
aGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFN1bmRheSwgMTkgQXByaWwgMjAyMCAx
MTo1NQ0KPiANCj4gPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+ID4gRnJv
bTogUGF2ZWwgTWFjaGVrIDxwYXZlbEB1Y3cuY3o+DQo+ID4gPiA+IFNlbnQ6IFNhdHVyZGF5LCAx
OCBBcHJpbCAyMDIwIDEzOjQ0DQo+ID4gPiA+DQo+ID4gPiA+IEhpIQ0KPiA+ID4gPg0KPiA+ID4g
PiBJJ20gY29uZmlndXJpbmcga2VybmVsIGZvciB4ODYsIGFuZCBJIGdldCBvZmZlcmVkDQo+IEhX
X1JBTkRPTV9DQ1RSTkcNCj4gPiA+ID4gd2l0aCBkZWZhdWx0PVksIGFuZCBoZWxwIHRleHQgc3Vn
Z2VzdGluZyBJIHNob3VsZCBlbmFibGUgaXQuDQo+ID4gPiA+DQo+ID4gPiA+IFRoYXQncy4uLiB0
d28gd3Jvbmcgc3VnZ2VzdGlvbnMsIHJpZ2h0Pw0KPiA+ID4gPg0KPiA+ID4gPiBCZXN0IHJlZ2Fy
ZHMsDQo+ID4gPiA+IFBhdmVsDQo+ID4gLi4uDQo+ID4gPiBfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fDQo+ID4gPiBGcm9tOiBIYWRhciBHYXQgPEhhZGFyLkdhdEBhcm0u
Y29tPg0KPiA+ID4gU2VudDogU2F0dXJkYXksIEFwcmlsIDE4LCAyMDIwIDExOjMxIFBNDQo+ID4g
Pg0KPiA+ID4gSGkgUGF2ZWwsDQo+ID4gPiBJIHRoaW5rIHlvdSBnb3QgaXQgcmlnaHQuLg0KPiA+
ID4gSW5kZWVkLCBBcm0gQ3J5cHRvQ2VsbCBDQ1RSTkcgZHJpdmVyIGNvdWxkbid0IGJlIHVzZWQg
YW5kIG9idmlvdXNseQ0KPiB1c2VsZXNzIGlmIHRoZSBBcm0gQ3J5cHRvQ2VsbCBIVyBkb2VzIG5v
dCBleGlzdCBpbiB0aGUgc3lzdGVtLg0KPiA+DQo+ID4gVGhlcmUncyBhIGRlbGljYXRlIHBvaW50
IGhlcmUgdGhvdWdoIC0gQ3J5cHRvQ2VsbCBpcyBhbiBpbmRlcGVuZGVudA0KPiA+IGhhcmR3YXJl
IGJsb2NrLCBpdCBpcyBub3QgdGllZCB0byBhIHBhcnRpY3VsYXIgQ1BVIGFyY2hpdGVjdHVyZS4N
Cj4gPiBUaGVyZSBhcmUgU29DcyB3aXRoIG5vbmUtQXJtIGFyY2hpdGVjdHVyZSBDUFUgdXNpbmcg
aXQuDQo+ID4NCj4gPiBTbyBJIHdvdWxkIHNheSB3aGF0ZXZlciB0aGUgYW5zd2VyIGlzLCBpdCBz
aG91bGQgYmUgdGhlIHNhbWUgZm9yIGFueQ0KPiA+IGdlbmVyaWMgZW1iZWRkZWQgc3R5bGUgSFcg
YmxvY2suDQo+ID4NCj4gPiBBbmQgdGhlIGhlbHAgdGV4dCBpcyBub3QgYXJjaGl0ZWN0dXJlIHNw
ZWNpZmljIGFueXdheSwgaXMgaXQgbm90Li4/DQo+ID4NCj4gDQo+IEJvdGggdGhlIGRlZmF1bHQg
eSBhbmQgYW5kIHRoZSBoZWxwIHRleHQgYXJlIGluZGVlZCBpbmNvcnJlY3QuIFRoaXMgc2hvdWxk
IGJlDQo+IGZpeGVkLiBXZSBkb24ndCBlbmFibGUgZGV2aWNlIGRyaXZlcnMgYnkgZGVmYXVsdCwg
YW5kIGRlZmluaXRlbHkgbm90IGFzIGFzDQo+IGJ1aWx0aW5zLiBBIGNvbmRpdGlvbmFsIGRlZmF1
bHQgbSBjb3VsZCBiZSBhY2NlcHRhYmxlIGlmIHRoZSBjb25kaXRpb24gaXMNCj4gc3VmZmljaWVu
dGx5IG5hcnJvdy4NCg0KT24gb25lIGhhbmQgSSB0b3RhbGx5IGFncmVlIHdpdGggdGhhdCBhbmQg
dGhpbmsgdGhlIGRlZmF1bHQgc2hvdWxkIGJlIE4uDQpPbiB0aGUgb3RoZXIgaGFuZCwgbW9zdCBv
ZiB0aGUgSFdfUkFORE9NIGRyaXZlcnMgc2V0IHRoZSBkZWZhdWx0IHRvIEhXX1JBTkRPTQ0KYW5k
IGl0IGRvZXNuJ3QgbWFrZSBzZW5zZSB0byBtZSB0byBkbyBzb21ldGhpbmcgZGlmZmVyZW50IHRo
YW4gYWxtb3N0IGV2ZXJ5IG90aGVyIEhXIFJBTkRPTSBkZXZpY2UuDQpEbyBJIG1pc3Mgc29tZXRo
aW5nIGhlcmU/DQoNCj4gDQo+IFdoaWxlIGF0IGl0LCBjb3VsZCB3ZSBhZGQgYSBkZXBlbmRzIG9u
IENPTkZJR19PRiBzaW5jZSB0aGlzIGNvZGUgaXMNCj4gZGVmaW5pdGVseSB1bnVzYWJsZSBvbiBu
b24tRFQgc3lzdGVtcy4NCg0K
