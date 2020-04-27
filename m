Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589A2C54FD0
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 11:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27A5D206B6
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 11:14:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="5O4hl9w2";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="5O4hl9w2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD0LOe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 07:14:34 -0400
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:42465
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726504AbgD0LOd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 07:14:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubAUdnuYrjauSL0BCwJkN7gZnjAX7QPv4bwWUN64UqQ=;
 b=5O4hl9w2aciM7kH+zPzH1/2o/QwpitvLe7cXrbZ7mw6laPIWtJFvAhUZsruA6yuZI9cbGdHpzkXEhfHc2vy7kAUgaUK+k7+neA99o0/J8nWty7APIy4UbrLzyMpCt/Or5xdmrpjGXpaH1RHmYMAXRwLfOcq1RgW3cpB16bTNHtk=
Received: from DB6PR0501CA0027.eurprd05.prod.outlook.com (2603:10a6:4:67::13)
 by DB7PR08MB3274.eurprd08.prod.outlook.com (2603:10a6:5:1f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 11:14:28 +0000
Received: from DB5EUR03FT055.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:67:cafe::1c) by DB6PR0501CA0027.outlook.office365.com
 (2603:10a6:4:67::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Mon, 27 Apr 2020 11:14:28 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT055.mail.protection.outlook.com (10.152.21.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.19 via Frontend Transport; Mon, 27 Apr 2020 11:14:27 +0000
Received: ("Tessian outbound 567b75aed2b9:v54"); Mon, 27 Apr 2020 11:14:27 +0000
X-CR-MTA-TID: 64aa7808
Received: from bfe0bd490a74.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id CD8C8056-C4A9-445B-B212-A61C99981A30.1;
        Mon, 27 Apr 2020 11:14:22 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id bfe0bd490a74.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 27 Apr 2020 11:14:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjLdyYCNA0sgseRT1jVQAzgXNSWN9FCEvzDvlvPc6Z/0z9GZakBb1LtMSMB1NyB1wK+sk4nJDGqB4TnQY6tUhQswT2D3CZomeapkOCKvHJbWKlZF0BLga0AFqQZRP0kqJJYCH++K7ySZUMqFfyDDIjNjlxatymb9kYGTxxu8KpAlYbKI4T79xTL69WQ/TQei2eqD6jJkSVPwfQ1RDHWyBZeBD2DYUGg64YUnYmjdcUaXd9y4NFZfejaERza1164ifq7vt9uy5HKmwAwx9J6eT8ZM37U/PYI2NkOVlw33MIBugOflbJZK1Q2UwWHMDh4tOKt3tBzKvEmD+WDy33fexg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubAUdnuYrjauSL0BCwJkN7gZnjAX7QPv4bwWUN64UqQ=;
 b=aPQ1E7HpjwpQ5ovVZf0ttKsZQxLCQqO+dretS83czx/K1wUHavyUtiMfN4UK9XnqsnsgUhAaY4elMeoxnpAnfrgXlz3gPxx1hmiPWe0UpfCWIRKch9NVvf1BoIQEjBhrU6hIB5vvVpS0/tQ7flbIVyH95B/3qF89h+xQpiWj/b+XHJK+NImOMqW9X7+imFfkrouqVB+Ps43uQVlzp0oqygO4Ea083zIHCNqsOja5XXi8IaoPOfrxM3ZBC1PyZMuFW6ril+MyZDVVDc8nEOwjMZ1OpdYnXm3JblrGO6MVvWkHs2241DliiPF6EQOaBDaPGoFPeHY6f3OqpRETjTVu0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubAUdnuYrjauSL0BCwJkN7gZnjAX7QPv4bwWUN64UqQ=;
 b=5O4hl9w2aciM7kH+zPzH1/2o/QwpitvLe7cXrbZ7mw6laPIWtJFvAhUZsruA6yuZI9cbGdHpzkXEhfHc2vy7kAUgaUK+k7+neA99o0/J8nWty7APIy4UbrLzyMpCt/Or5xdmrpjGXpaH1RHmYMAXRwLfOcq1RgW3cpB16bTNHtk=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2440.eurprd08.prod.outlook.com (2603:10a6:4:a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 11:14:18 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 11:14:18 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v2 1/3] hwrng: cctrng - Add dependency on OF
Thread-Topic: [PATCH v2 1/3] hwrng: cctrng - Add dependency on OF
Thread-Index: AQHWHHkos4DrjSnAE0a9s7mTtOprGqiMxCeAgAAMlBA=
Date:   Mon, 27 Apr 2020 11:14:18 +0000
Message-ID: <DB6PR0802MB25330D75A0CA7D06D6BDF0BCE9AF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1587980946-363-1-git-send-email-hadar.gat@arm.com>
 <1587980946-363-2-git-send-email-hadar.gat@arm.com>
 <20200427102811.GA10473@gondor.apana.org.au>
In-Reply-To: <20200427102811.GA10473@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: a45a8d14-ee80-4af0-9fad-f5ecae68174a.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa4acd35-7734-4f51-9738-08d7ea9c2690
x-ms-traffictypediagnostic: DB6PR0802MB2440:|DB6PR0802MB2440:|DB7PR08MB3274:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB32746F4088188A5FCE11B941E9AF0@DB7PR08MB3274.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4303;OLM:4303;
x-forefront-prvs: 0386B406AA
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(71200400001)(66946007)(66476007)(66556008)(64756008)(66446008)(8676002)(2906002)(4326008)(33656002)(186003)(76116006)(8936002)(4744005)(86362001)(81156014)(5660300002)(7696005)(966005)(6506007)(83080400001)(26005)(52536014)(316002)(7416002)(6916009)(9686003)(54906003)(55016002)(478600001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: u3S2zNyIjKMrEYbcuuef5Wzi7TSk2L9OVt1DBaG97KwndNG+KiRmaCJSsTuz+F+HRn2/eA2YDoK1zL2VtXXul+mBUzIVpcsAy3FEMwt2dm56ocxf+w1tv1fB9O2Li2n5vYuv40lYgGp6/Z/H3mDNay6WUzt++g+DnltJHylfgygS0i+Nk4nQq02ItpUDM765Cd19FBbS3px32SDu2rMHx8T7C1vC4XfiiWEG3me+kYh3yeE9+2vhOZOeoUfGpsH0MlwCw4mjCJUucafkzgCl+DPlKqHighn99nWC44ocrVugWqkJ7+i1/Kda6U8jwoeJp19swhUcvqitE+vKn7Ohx+VjwmvTnFSnDIAbjs3JE7bBi2eVnNmCl4PRDQ3hXq4/FK1b5bXPfE2nN4RkpBeI0am1/LeW9ihLmLAhWPz1OVzua6Dc4puzuFuhzax0yNTOVgSBOXlgFTns2VgpJm1mACfs/loKLJAq5mfgfmPg5Xn7CZ6Gl/jvpJhi6VhXjIPXmGP+xTPFHcnfmzLq5CJXIA==
x-ms-exchange-antispam-messagedata: p/dNyo4C5wnj44qndTy81+7//R4zVxEVg7ZfDaWHY0CeeF2jZj/cUtttRWWs/W+3VbroI2J6ZlSioU7fqbxZxyV65tp3J068brmgIPdkvqa7di9pLXA0tIxR4ah0eCWCHcpW+orHI2PdfU3ug5TSFTu68s6jlYkd6lAK8HgaG/d/2R1Lr5gkPsZdjdBcuSOXkigjR36BEjGvrNFoucTha6IFp/ALcXckgrBgTNoabzmCB7uEJpez0OfYv4tE9iq8ld9ZCgx4fXzI1iLYfCMozp5uEinjL2sHn+XS2zkqiH3zF4Xiz8j0gHnGX5iFIPyYwZ0D5/H0fu3ANh4vQlDXK/tt1Z/jdxVQujIXMn1zW18UKXkRyd7MhEK+SCTrPokFnbuphbmJrykkEHm08YagHO9gVrq5i18NkcCdepmGPYVPqGkgqj/ZvWZDdUfx4Xkhc/lB1Ab5pRUayqckDQ3DqGeGAc5lZiFtA1BSclPsXweMwDY1kVQvJ79IVsRoJhWaSYLW4RSe+hi3snh3vdjdcZ5P2tMWVjVlRvm4BQ1o6rG9N/tPCcgvukT8NTWa8Rur9dNTjCP6s7YJoMHPYVD/ELLA+nm0NfReIPNzLNaaNgqZpIo5EEM2WAOr7Iy/5Rky5wU1BSuKzr6uMCAXBl3RhPNQZJlDER6fHkxoYqFiY2YaQlA1DQe7wcqzXknfNwNaY0kuRw/VlcstzX5/Q+kC2sM2YfkcoUuU3hvjdsw/jPK6daPXVSjH5tn04mBhTdnRpHsrdhgeYT033Gd26Y1edgYombM/Os5RM+hNUhxAUto=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2440
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT055.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(46966005)(70586007)(336012)(33656002)(9686003)(4326008)(5660300002)(316002)(4744005)(450100002)(6862004)(186003)(8676002)(7696005)(81156014)(478600001)(8936002)(26005)(86362001)(52536014)(70206006)(55016002)(54906003)(83080400001)(82740400003)(81166007)(6506007)(47076004)(2906002)(356005)(82310400002)(966005);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: bd14ce42-0750-4308-e49e-08d7ea9c2118
X-Forefront-PRVS: 0386B406AA
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EukCxq8CtJhFunfcNo6D0OnE9pzd2f2zy/CXTPuL+O2LhKJjp7CsjhWXZtvgwvDxm9Gaf/0PZbuP8BMI2+cXMGbaHPMvyQkelQKZgwDHELM5aMvYkReldyXlpS2d7o4P3kJihE6Sg7oL9cmmcrM8r0Wcuf77WC4j00KvDt6G7oPdrpxM9UmmriLtzaQdBYRGg4kLqti06VMTbwRzwYxBoSpDWAKHNKIh9H3T1boubrhx+9+D8vw+SlMNnacG21cNoubZmcx4iyLNatqACZNFDbnjtz668a55WeVPQE2lIL+rbOcEqnXkASA2HH/Z6U3k+gaB149/14EhZkToRhgQKsY+eSEoFBQLWB8q3pz2bvh7xCNqW8mgidr5KRj2f/K545N8HSEVQ778F7bDKSzWi/pnJHMX9B//yEfqH9evZrVS0HmWmpQ2OHqBupiK2JGNxKLYsCSHeUGpSt7T78Z8Yj0pfGqrCdAwugoeJpXNItBPYfP/wPxLkMkXiRAv8cCbf7QIK1LgvUjRz4ZPKbK52tTaQy9xmle04lVRD1bFl8YdeTu0fxMhcPzplqLTiR3fEmpmLDaFzMLwh+ymb45uYfQe3ZwGYCblJtsP50ITHsY=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 11:14:27.8922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4acd35-7734-4f51-9738-08d7ea9c2690
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3274
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LWNyeXB0by1vd25l
ckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNyeXB0by0NCj4gb3duZXJAdmdlci5rZXJuZWwub3Jn
PiBPbiBCZWhhbGYgT2YgSGVyYmVydCBYdQ0KPiANCj4gT24gTW9uLCBBcHIgMjcsIDIwMjAgYXQg
MTI6NDk6MDRQTSArMDMwMCwgSGFkYXIgR2F0IHdyb3RlOg0KPiA+IFRoZSBjY3RybmcgaXMgdW51
c2FibGUgb24gbm9uLURUIHN5c3RlbXMgc28gd2Ugc2hvdWxkIGRlcGVuZCBvbiBpdC4NCj4gPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IEhhZGFyIEdhdCA8aGFkYXIuZ2F0QGFybS5jb20+DQo+ID4gLS0t
DQo+ID4gIGRyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZyB8IDIgKy0NCj4gPiAgMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBUaGlzIGJyZWFr
cyBjb21waWxlIHRlc3RpbmcgZm9yIG1lIHNvIG5hY2suDQoNCk9vcHMuLiBGaXhlZCB0aGlzIGlu
IHYzLg0KDQpIYWRhcg0KDQo+IC0tDQo+IEVtYWlsOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRv
ci5hcGFuYS5vcmcuYXU+IEhvbWUgUGFnZToNCj4gaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUv
fmhlcmJlcnQvDQo+IFBHUCBLZXk6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1L35oZXJiZXJ0
L3B1YmtleS50eHQNCg==
