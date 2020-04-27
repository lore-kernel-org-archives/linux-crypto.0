Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2C3C54FD0
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 07:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F33C2072D
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 07:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="jmltXYpP";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="jmltXYpP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgD0HXS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 03:23:18 -0400
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:41777
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbgD0HXS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 03:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LQdyZoHpm7poo4XNpu0X4JUvlXXUdtJCkf5tARi0Lg=;
 b=jmltXYpP2+ALE3g0U5MSQuVwZLR3Q4Jw3xxrw0tFb9xbA5WqGzG2vxz3J6nFCjNbqId7krIz1z88VMfphKQo0LtNFwXOR5X+Qe9oa7jnY5H3dOc7kEMMuJrTuwcTLJCb36U/fgjfeiTcjDZwYsb1xbLiKEsD1oajHk2zwmf4EK8=
Received: from AM6PR0502CA0072.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::49) by DB8PR08MB4571.eurprd08.prod.outlook.com
 (2603:10a6:10:ac::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 07:23:14 +0000
Received: from VE1EUR03FT010.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:56:cafe::be) by AM6PR0502CA0072.outlook.office365.com
 (2603:10a6:20b:56::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Mon, 27 Apr 2020 07:23:14 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT010.mail.protection.outlook.com (10.152.18.113) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.19 via Frontend Transport; Mon, 27 Apr 2020 07:23:13 +0000
Received: ("Tessian outbound 4cdf5642225a:v54"); Mon, 27 Apr 2020 07:23:13 +0000
X-CR-MTA-TID: 64aa7808
Received: from 2f5ac5b1c8d7.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id CD906879-B7AE-4824-8E7C-183F32AFB447.1;
        Mon, 27 Apr 2020 07:23:07 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 2f5ac5b1c8d7.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 27 Apr 2020 07:23:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVFxiYMub72ZYy+Vn0tXtpgvusQXDIALlnnh2qiuHMO60B+MW3pfpR+224Pi7E6SIYuwTOe/94CYi/y+eQ3VdD0JePKIhM0u0q4tz1nFyu2/kekbZpKKYustzJO9UEZMLdky2GzeQcEMY4FAuAl86gJ7OSNFqOEEjbioF/xOGZTRaBFfz0samaoAlp8hbHkffZKH+cCnq8qBKJ3YonnOWdUib7f4tAKemEGsChKc80yEmBnuZddgva6yVVadpacGffipCEnyHHCrJlQ9qoSoB7ayhtg+iSxm9gCswCQNVXX7TQckthLQv7ipVebGr53INos0xQCHRQsn22evdhTVow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LQdyZoHpm7poo4XNpu0X4JUvlXXUdtJCkf5tARi0Lg=;
 b=E1U1MVEONignQYdy/m+QwekZxJcdmXYuJOcOHaGB2KFhttNL2OZWRl4a1M3QnLV2Dr74qOcd6h1ShxiDwOfTIqZ5n5DwM+IKhrtN064FvadMX9fLZnz1L3W4k/GKvbjo1901quI5eVSue7PVjGfCMmKwFjHyZaLmvi71Wis3CqrkOv2BRZXX2u5LV0dY0DChVAz+Xtp0ymi6PbJ1AsHihGcoebfhYkwnjNaSYRJh4Vyx5iRruboNYmZugxgZ9512NTz6ms/xqpoke0aG2q4AGHmdQwiSYzxBvYbw7x9P2ADhV04IPw3TsuPKNHCJdMwa9rgwyIEra4mPztN28uA1zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LQdyZoHpm7poo4XNpu0X4JUvlXXUdtJCkf5tARi0Lg=;
 b=jmltXYpP2+ALE3g0U5MSQuVwZLR3Q4Jw3xxrw0tFb9xbA5WqGzG2vxz3J6nFCjNbqId7krIz1z88VMfphKQo0LtNFwXOR5X+Qe9oa7jnY5H3dOc7kEMMuJrTuwcTLJCb36U/fgjfeiTcjDZwYsb1xbLiKEsD1oajHk2zwmf4EK8=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6PR0802MB2373.eurprd08.prod.outlook.com (2603:10a6:4:88::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 07:23:04 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 07:23:04 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
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
Subject: RE: [PATCH 1/3] hwrng: cctrng - Add dependency on OF
Thread-Topic: [PATCH 1/3] hwrng: cctrng - Add dependency on OF
Thread-Index: AQHWHFaWhTKzOlU64kmA6IpAntfc36iMicgAgAAF69A=
Date:   Mon, 27 Apr 2020 07:23:04 +0000
Message-ID: <DB6PR0802MB253304D0FE37A3C99C1A1E4CE9AF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1587966099-28139-1-git-send-email-hadar.gat@arm.com>
 <1587966099-28139-2-git-send-email-hadar.gat@arm.com>
 <CAMj1kXHN1qzoP9YNmrFcTJRncJE88Jyp_MS_9XrdAiY9v6DAyw@mail.gmail.com>
In-Reply-To: <CAMj1kXHN1qzoP9YNmrFcTJRncJE88Jyp_MS_9XrdAiY9v6DAyw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 9be49a40-ab53-4594-ad5f-13fe75f0003f.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1fed8a69-6238-4fe8-a54a-08d7ea7bd8d1
x-ms-traffictypediagnostic: DB6PR0802MB2373:|DB6PR0802MB2373:|DB8PR08MB4571:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB45718B6FC4F84D20C2661FE8E9AF0@DB8PR08MB4571.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:2331;OLM:2331;
x-forefront-prvs: 0386B406AA
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(55016002)(71200400001)(4744005)(2906002)(6916009)(7416002)(478600001)(33656002)(8676002)(86362001)(5660300002)(8936002)(81156014)(6506007)(64756008)(66476007)(26005)(186003)(4326008)(9686003)(66446008)(52536014)(66556008)(66946007)(316002)(7696005)(76116006)(54906003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: hX/q5bPY2g81HUO7/g4SL2Ws1C4LO/qkeT34+hlkMI5bExQxZNwFLYHFnn50E6Jm8+8/MQksA0yP1xGx1YqCXcJzmyhYsaOhuAVLgLVJzrQqM/kD11190jpLMwvAPmam3X/0Dpm5FwstRpBHui285GD9cfB0jXTeR16CioRRN44LNMK3S2KLyn61/q0tGlWkns2OyuVEzu2AjBVEbvziMMRuj5h8LWej8H55Uf9A62ZoTCwfU1tUbKwVB1QtFzQsDwno56157WG2YOZjnJdcmop3QOEPx9xHqD/CRd+bRfR36uVUh3SzIbIGitiE+jHrgbnLvu/m4ThfuxdHsLqhYXcNK5Vkc+52wtU3Cx9C+4URgt+ge7hK8wy/t/ZqqtdWj14youd5sxqgx2UjbBif2I0slD1HEbmVMOVzsQGXrSR3MYMTEmaKcyBdmkthdmxP
x-ms-exchange-antispam-messagedata: +B9uOc4hPrhSvsrGoqK+hrOQgoZaYa1Rf6y7GSe3Y6HR8GrjDUR2+8ZqbvARnuvsUU2tWQZP6h4xM1UfqtP5+bPJbTi+Pxyb+lCgViHIZeRKTeR52CHZPTNT8TQv1OXOZfHULxR3vFfw8U1QO48qMQ0Irp/0PFRD9fhQOYJMTK52uu4fLS+Pi+DxBcf8NrrbvnPbSd2xOWRj2uURdFfvtSJDYyWYxabmEKbgCWu6pFNndtqChfW7FtjP3HEX6hFIBzn07m4ns8nIgxSGYgFOys29FPUjG1KCqE+GzufJ2khVjGJMDUNHhQ9GQlbJDlkMhuEohnyP0MJoFqpe8hF93AbVUSZICVeVE0nLd5vQXSR59LmC3x0o2zndOduVIldBjrvVqO7h8QF6b+Ep9wVvzifIhJeN9mXt1VRF/e2MOtzWjNnXu+C21zphttnx9O3EMk6c3dn0VrMS0s/7qA9+VBI2b/Vu2/jWGUTedDv0YbxjOT69l2KcMmkYQeJHXZWUPB/kssSyDl2z/+qWCdbwrV/ds7MNh6oK6KhJNv0WUTyaNpPUGJVji/JPYfwiSzQseZjpMadQyYjtC9X7yMxhJph+/vNJkyQcRekiN5PAeguSQQsGaRrWyiUzhVytGCAT1pK9M0FFlKOFTCRVt61DuET2oSKMvLxl6eMBxXH35bRxyK724/NvSb/ZmEigj9Ug97R/RsSjUIx2vEf8B5f2rZD3NQ+MxbLDJ5dClVG11ziqUEyVYyK1+CYAySOesx77ernB8KXG7oP708bKKAzLLH1C8Ni5vT4pH+9HgSgJWWY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2373
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT010.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(46966005)(54906003)(8676002)(7696005)(26005)(82310400002)(81166007)(8936002)(5660300002)(6506007)(33656002)(81156014)(70586007)(36906005)(316002)(70206006)(186003)(336012)(2906002)(55016002)(356005)(52536014)(9686003)(478600001)(6862004)(86362001)(82740400003)(47076004)(450100002)(4326008);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 95b1adee-03cd-4f0f-14a6-08d7ea7bd33c
X-Forefront-PRVS: 0386B406AA
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t2B36J1rNGvCYatuDjvWI2Pu7MURvOHtgLb/ZyIw12vucZDAHTBFwNy7YKvMOEQ0iREGnPbOi8aQ8M25wyknN86LdjxaAGyBSz/42SBk6Lri/fHEEWyXvZcma8WXULTBnHeFEC5/6zvKStGLpOB3xzJHuy2FBrobOsuhfXEExB4tT2P91+TZjLSe7GxKmXx46WRlsDYv9g9NAlQhF//MmMlKzja/zZ/FWvBwkrAwhZQldOkSjAkocxe44+r+QgOrmbda6ReSc0LHwqXA5oKLEa/zn6VfOzsKcpJQaYKBRoJUTxPpKNrGERVfWeu6LXTllFI92h1QWhKE04ACMgkSYccZh3xjIa1FGZqfteTJ930NR/2fkWGyEeavKNYAIxoWJUt59yfgI/MRkd3oqIS3OmIGAEQjIpOrU0OPBGezPmBOu4zzuSrFDIkxzo2r+RQmwNreggeN4ERS/QpDCaWwRF6FBwFHdSmdbUUWaACHrLzt0CURqYzau2YrjLBFEyom1JKelEr9DdSv174UUoAEjg==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 07:23:13.3960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fed8a69-6238-4fe8-a54a-08d7ea7bd8d1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4571
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFyZCBCaWVzaGV1dmVsIDxh
cmRiQGtlcm5lbC5vcmc+DQo+IA0KPiBPbiBNb24sIDI3IEFwciAyMDIwIGF0IDA3OjQyLCBIYWRh
ciBHYXQgPGhhZGFyLmdhdEBhcm0uY29tPiB3cm90ZToNCj4gPg0KPiA+IFRoZSBjY3RybmcgaXMg
dW51c2FibGUgb24gbm9uLURUIHN5c3RlbXMgc28gd2Ugc2hvdWxkIGRlcGVuZCBvbiBpdC4NCj4g
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IEhhZGFyIEdhdCA8aGFkYXIuZ2F0QGFybS5jb20+DQo+ID4g
LS0tDQo+ID4gIGRyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZyB8IDIgKy0NCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmlnDQo+ID4gYi9kcml2ZXJzL2No
YXIvaHdfcmFuZG9tL0tjb25maWcgaW5kZXggMGM5OTczNS4uZGYyZDAwMSAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL0tjb25maWcNCj4gPiArKysgYi9kcml2ZXJzL2No
YXIvaHdfcmFuZG9tL0tjb25maWcNCj4gPiBAQCAtNDc2LDcgKzQ3Niw3IEBAIGNvbmZpZyBIV19S
QU5ET01fS0VZU1RPTkUNCj4gPg0KPiA+ICBjb25maWcgSFdfUkFORE9NX0NDVFJORw0KPiA+ICAg
ICAgICAgdHJpc3RhdGUgIkFybSBDcnlwdG9DZWxsIFRydWUgUmFuZG9tIE51bWJlciBHZW5lcmF0
b3Igc3VwcG9ydCINCj4gPiAtICAgICAgIGRlcGVuZHMgb24gSEFTX0lPTUVNDQo+ID4gKyAgICAg
ICBkZXBlbmRzIG9uIEhBU19JT01FTSAmIE9GDQo+IA0KPiBEb2VzIHlvdXIgZHJpdmVyIGluIGZh
Y3QgZGVwZW5kIG9uIENPTkZJR19IQVNfSU9NRU0gPw0KDQpZZXMsIGl0IHVzZXMgZGV2bV9pb3Jl
bWFwX3Jlc291cmNlKCkgZm9yIHJlZ2lzdGVycyBtYXBwaW5nLg0KDQo+IA0KPiA+ICAgICAgICAg
ZGVmYXVsdCBIV19SQU5ET00NCj4gPiAgICAgICAgIGhlbHANCj4gPiAgICAgICAgICAgVGhpcyBk
cml2ZXIgcHJvdmlkZXMgc3VwcG9ydCBmb3IgdGhlIFRydWUgUmFuZG9tIE51bWJlcg0KPiA+IC0t
DQo+ID4gMi43LjQNCj4gPg0K
