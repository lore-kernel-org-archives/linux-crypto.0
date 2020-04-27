Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D446C5519A
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 08:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 408BC2080C
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 08:56:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="y/RAHKLi";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="y/RAHKLi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgD0I4u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 04:56:50 -0400
Received: from mail-eopbgr80040.outbound.protection.outlook.com ([40.107.8.40]:56034
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgD0I4u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 04:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/YZoOdwy5jCiN8Mt0R1TmvByv4dO8rZl0CoMDE4Bcc=;
 b=y/RAHKLisesysXnZFtHtERczXoMUFfS76+rd+cZJ/pQroiBIzVtbtU82P1tVzVu513B3YhxMFE3EJYLwzZXtmDFICcRARsVh2PleW3kBOmCpRbHeVjguDSCscuPhdgDxPH9X3NB8FbkGOwWHbLzgH+c1DBk6OaybcHBAulyc5fE=
Received: from AM6P193CA0065.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::42)
 by AM6PR08MB3318.eurprd08.prod.outlook.com (2603:10a6:209:45::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 08:56:46 +0000
Received: from AM5EUR03FT003.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8e:cafe::b0) by AM6P193CA0065.outlook.office365.com
 (2603:10a6:209:8e::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Mon, 27 Apr 2020 08:56:46 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT003.mail.protection.outlook.com (10.152.16.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.19 via Frontend Transport; Mon, 27 Apr 2020 08:56:46 +0000
Received: ("Tessian outbound ff098c684b24:v54"); Mon, 27 Apr 2020 08:56:45 +0000
X-CR-MTA-TID: 64aa7808
Received: from 5fa8be9958cd.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 76DC682B-A967-47A0-8B58-7A986A9C8E46.1;
        Mon, 27 Apr 2020 08:56:40 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 5fa8be9958cd.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 27 Apr 2020 08:56:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=USobUby+qeHNqSJEBLiPkxF58FOPthlCj4xnFBNY+v0feFXcgITk1mD7r63exGVou312twsPwILyEI+To90ws/j8N/WtDkkzQ1RJ8/4dVHkCQnRkmbmvZLe0BtTDabA/95OdugAgXyi8mMkvqMTEEabJafVR300C8m/S1qvYwexn2XTobLTCXcwqv6GnJhs0HBS1RWMAvrqhW4uIXHu3jg39H2KfseU1VWWjGCkODWIjaH3TYzxYRlDToulGjdYTLvuJjvJBweP+Dnbcro2dc+Fa9L/dJ96jXex0eHqWej2JHMUYeRSpSdK/nRIQWVeUnIDMRMlp+WNtMB7tOwG5mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/YZoOdwy5jCiN8Mt0R1TmvByv4dO8rZl0CoMDE4Bcc=;
 b=WpXIaj9KizzKVPlB/DcsEKPujP7epPCxSJetkxicblywTqd848h60DBfmAyQShur+3dDP+kuqSVwv9h46EHGlbP+i1dNZtUZO7+xzzTlrVicZZXUMR91+qED7rqwnYvHl4pvE7vj7rsSVrq1DJ2JX3VDo3aNRdBCyf7k3qNnujl7jP7v1/VbeLY8J9hPcVrvZ+rflk472v5krONWoXpM6NNQsGZIAL/hFtLekzOIvOTmvHdTFbdPFZvePwb1BWjN1Uz/+0gJOftV1qmiEP8uUQtU+HbJkTVo7BEqsWYTxigrYhc+WBAiKx5tUr5FFneO++uPal6V8JcsPBxWplHjgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/YZoOdwy5jCiN8Mt0R1TmvByv4dO8rZl0CoMDE4Bcc=;
 b=y/RAHKLisesysXnZFtHtERczXoMUFfS76+rd+cZJ/pQroiBIzVtbtU82P1tVzVu513B3YhxMFE3EJYLwzZXtmDFICcRARsVh2PleW3kBOmCpRbHeVjguDSCscuPhdgDxPH9X3NB8FbkGOwWHbLzgH+c1DBk6OaybcHBAulyc5fE=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2597.eurprd08.prod.outlook.com (2603:10a6:4:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 08:56:39 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 08:56:39 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Ard Biesheuvel <ardb@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
Thread-Index: AQHWHFaa2ILie1hr/Ua7OdXaSVzplaiMigqAgAAGr1CAAA+9AIAACb9A
Date:   Mon, 27 Apr 2020 08:56:38 +0000
Message-ID: <DB6PR0802MB253351027A5B3236E31D1E9AE9AF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1587966099-28139-1-git-send-email-hadar.gat@arm.com>
 <1587966099-28139-3-git-send-email-hadar.gat@arm.com>
 <CAMj1kXGwVZiGbsT2NwWTyka0FVZnQcmfMSeoBKD03PdC=fRZeA@mail.gmail.com>
 <DB6PR0802MB25334429B7DD333780E7BABBE9AF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <CAK8P3a1LYAESnePbwbn7x7x=2MCTWUNZVmmoiuv+_-J2ntFGmA@mail.gmail.com>
In-Reply-To: <CAK8P3a1LYAESnePbwbn7x7x=2MCTWUNZVmmoiuv+_-J2ntFGmA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 3f622335-76be-4668-a357-22837c7fece5.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f80681c-a13f-4905-9a43-08d7ea88ea34
x-ms-traffictypediagnostic: DB6PR0802MB2597:|DB6PR0802MB2597:|AM6PR08MB3318:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB33182685B0D1E45706007FA4E9AF0@AM6PR08MB3318.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:7219;OLM:7219;
x-forefront-prvs: 0386B406AA
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(316002)(2906002)(6506007)(4326008)(7696005)(81156014)(8676002)(8936002)(71200400001)(54906003)(33656002)(53546011)(9686003)(52536014)(66946007)(478600001)(186003)(64756008)(76116006)(66446008)(7416002)(55016002)(86362001)(4744005)(6916009)(26005)(66556008)(66476007)(5660300002)(129723003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: SinEI4uUlDiLO03NcVKprf0KcQGTc5f2FX/vR4dH4oZo6d+lMEn4YnG8MDK5ohpa1GwxeTkLmh7evsJQZerig+oU4x9ENAZSvKU4NTA7bjdjV/D27F3MpfSbIOBfQVUuETTsNdDVnmV2Vr9oEcU34Ot0pbbsJVtkPF4ILPJZN0EOU9fzejsYaUWD+QI2gTorPlMb6d7KA5+rPrAG36t1PDRmWiGweeVktIYvLtcCgPJJkbKNzYDVfU4o18FVP/rRra/h7Ccagkfh8ISiTzXlSMcnj62o27Ss6jEVFASFdbfr2LqWcsms2IhDcNPKrHOtnTJW7/7UbyIk+8C7dcNtM52JR47G34q0tsiTHKuza0WQYLodjFwWaGrU6FhXv1c94hs8QFXBy3y1czAgVDdZ9d3JqpyykWm85CqSmEULiFaureReu+1LH9zGnQAsmUyhagqFjqJ68yHsopr/BmyXEbqmw2EuCBlyD7Y54Y+CBfcGGm+DlN3d+yaTQlNIeGKh
x-ms-exchange-antispam-messagedata: 8th/Z0gJ4oIeHUh3pFo3YPwi3Icxf9V9L5YeVh8wDFjWdIm51Ofr3ANLzKtrasTVxCJ3SzznyXtqIxqFa3oplwpC/XYf1pTLy9tVZveB3814IVa7K7Qxoql86a7QGZP8/WncpfJyGWz1050Y6MPfIeUiJa8GMJrPXy+NxPMV2451RCOJIZtdjd1pVjcvpoSaFJQKwSjy3Xhm/TFcmE7cl9CRFGXd1mT28GklwuG4O1NqwFJw+sNztNNTMTW1Chm63nhA3E/yc4srmCUw7+k6hbDy/UcBGRmBiqIN019c5oMCXgod46tpCt9fdso7j8aOpTLaOOd1By4VLTYOqj7FDwwQ63hyIhywmj3eZQGMJaetAUGJkAusPH4vJEK25/Bg/1NHt3GIrN4Exn+eLjamkYYXiYu02Kp0cD5gHrDWT+k5toA15nh7am+Z+QjzVXxJDAKr+7nbTp6KyLUSPwi9uUj8G6cigdvVAB7oLOc8mnO0ljmfJRsD4lVR3iNxmF00dbCQMGhN/irX5RTX6QFjcCCI1ApiH7WLLSK8mlXnvbooCTVVr43Y0avRsHxsdaZlVg6TquvoWunOd3R/s/W8tbNqIws0s6ik83Pe69ZNRtW2zidB/I4qcYiIrkgXE2bIWT6aN+5DNuccJvFlWWBXaR15UhgzUkCxHLKM3jYeItu3cIjN//9QublbU8ibgxLjhVjHWWfJRnp04IDMQW46iVsHyo4aXT7EX3j02N7Vy0WMp5iUQbPS60san5PWD1pLLAtnz6nGucjWPtA2TOb4KUpLIsODCPtBurzUpC2ejgc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2597
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT003.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(46966005)(4326008)(450100002)(33656002)(2906002)(82740400003)(6862004)(47076004)(81156014)(8676002)(70586007)(8936002)(86362001)(6506007)(53546011)(316002)(36906005)(4744005)(70206006)(52536014)(55016002)(336012)(5660300002)(356005)(81166007)(82310400002)(186003)(9686003)(7696005)(54906003)(478600001)(26005)(129723003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 0fbf4a9b-1860-4e50-4a13-08d7ea88e606
X-Forefront-PRVS: 0386B406AA
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kEuHYoGCF5vNHRIGeiA5GsLG8V1VW5PyfuvzVwKqinHDNt0ELdq2lek4ylS5wXY0TIYi86+KBvJ2/IG9lD1XN5Axnu1K5pq23TVH3Sp1vlXJVch+ZK14DVy+n0/eH7P/zfstg/EG7GOHvYHWo9NpeV8sLss+mk/xFvhd0sw9Y+jxUNGZQNyyqp3QoLkY6aAiGtsYTzDpNk1E+yE9Y5MdrfRsfjWJCPFJHTB9ZgVlx7ASJSIsClOdlsQeiuRzpSSM9cJH97IfWl+hXnsr20FNqsj8Ok0ZmNDyjrPYOxerKjzXM+DiapbV7cvS41mDzgmPU26r23l8+Zl9NopAzYwHbaJY7kkCzWsmh/8kZvclIPJlZiwtDpXcz3mSPlKDq2UQbSD551pEqShknaH5itFpgWaSwlsMFYPN9+sXa/JVzt1r1u5pmDneUwOSKpfY+eU2wt+IZybdmOrtR2UDwYJAcdP6OGzTGAVZFNL4o/FJq8M4lddMJjRoQiIfgggGzStsvRhpeNAvVhJZJ6tF0emZJ9oZyT0P2z2KoiqwG9QLEVA=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 08:56:46.0902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f80681c-a13f-4905-9a43-08d7ea88ea34
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3318
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFybmQgQmVyZ21hbm4gPGFy
bmRAYXJuZGIuZGU+DQo+IA0KPiBPbiBNb24sIEFwciAyNywgMjAyMCBhdCA5OjI2IEFNIEhhZGFy
IEdhdCA8SGFkYXIuR2F0QGFybS5jb20+IHdyb3RlOg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gPiA+IEZyb206IEFyZCBCaWVzaGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+DQo+
ID4gPiA+ICsgICAgICAgZGVmYXVsdCBuDQo+ID4gPg0KPiA+ID4gJ2RlZmF1bHQgbicgaXMgdGhl
IGRlZmF1bHQgc28geW91IGNhbiBqdXN0IHJlbW92ZSB0aGUgbGluZQ0KPiA+DQo+ID4gSXMgdGhp
cyBhIGd1aWRlbGluZSBvciBqdXN0IG9wdGlvbmFsPw0KPiA+IFBlcnNvbmFsbHkgSSBsaWtlIHRo
aW5ncyB0byBiZSBleHBsaWNpdCBhbmQgaWYgYWxsb3dlZCBJIHByZWZlciB0byBrZWVwIHRoaXMg
bGluZS4NCj4gDQo+IEl0J3MgYSBjb21tb24gY29udmVudGlvbiwgYW5kIHdlIGhhdmUgaGFkIHBh
dGNoZXMgaW4gdGhlIHBhc3QgdGhhdCBtYXNzLQ0KPiByZW1vdmVkIHRob3NlIGxpbmVzLiBJJ2Qg
YWxzbyBqdXN0IGxlYXZlIGl0IG91dC4gSXQgaXMgZ2VuZXJhbGx5IHdlbGwgdW5kZXJzdG9vZA0K
PiB0aGF0IGFsbCBvcHRpb25zIGRlZmF1bHQgdG8gJ24nIHVubGVzcyBzcGVjaWZpZWQgb3RoZXJ3
aXNlLg0KDQpPaywgSSdsbCByZW1vdmUgaXQuDQpUaGFua3MgZm9yIHRoZSBleHBsYW5hdGlvbi4N
Cg0KPiANCj4gICAgICAgICBBcm5kDQo=
