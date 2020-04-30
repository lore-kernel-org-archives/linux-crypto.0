Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B46C83001
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 08:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34DFA2073E
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 08:26:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="ahnocUsD";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="ahnocUsD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgD3I0S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 04:26:18 -0400
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:5984
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726489AbgD3I0R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 04:26:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tb+i9wu0TS1gl1qo0tc2jROz2bGaHmSTlw1IBnRi0o=;
 b=ahnocUsDYWMcbqBnthqpoe+WqO6VVS1aTQXkGcRg5A8bZaM1HlzHLUdxHOO6t8ntSE0EIy/li/ucXB2Y4eTtYA/un8kzRL3Y4sFXbuXVWX6IoO2GHmVwfzKcaVD4PX0yO6vXqcBsj4c4ABQ/TBwMOJU39HWsGXOZtRr3xvXJEWk=
Received: from MR2P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:32::16)
 by AM5PR0802MB2386.eurprd08.prod.outlook.com (2603:10a6:203:9b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 08:26:12 +0000
Received: from VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:32:cafe::d4) by MR2P264CA0076.outlook.office365.com
 (2603:10a6:500:32::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend
 Transport; Thu, 30 Apr 2020 08:26:12 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT041.mail.protection.outlook.com (10.152.19.163) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:26:12 +0000
Received: ("Tessian outbound b3a67fbfbb1f:v54"); Thu, 30 Apr 2020 08:26:10 +0000
X-CR-MTA-TID: 64aa7808
Received: from 47ec3989bcf6.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 95D81D35-B945-4BD3-9366-302A3FA1B570.1;
        Thu, 30 Apr 2020 08:26:05 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 47ec3989bcf6.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 30 Apr 2020 08:26:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWfcC2NMLho+VGzH1HqKVOXmjTeWOD40U85KwCuzbvxQ1WLPEHbvhtaunZiDXoBxJvbvqUxq9TRczjobcN7Wzjw6JGM8MVdcZGgvmj5FKOZ8oOCY3yBAwG2UArTlAdCHawQzt4lsMvCM4DTsBynRh1opwhFQKQch9ZdCYfF+NdBU28k40PPO2Y4meIuf5G86rIoItXHQwanNky4ewg5opMWq4AMQB3xVHyMaJlye0j9HvjoY1YyOv8ZGsb47QBRzE47/UoXoToXtOgKK9/CLAu95tex9rFz+p4EyMC9brHKc9MAlgunWKGecqMlWyX9flqzMenrfx58At+RjYGXtcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tb+i9wu0TS1gl1qo0tc2jROz2bGaHmSTlw1IBnRi0o=;
 b=iFt4cZYkWZYG/3LmlnmGP1/DqAWkPkmQSh6F24G5dKsokL1dy3wFEoUHlXjKnefa6raqqVNdkdyqpB27Tnn2x2WuXuhKk0OXcBab4rsPyMcl5HaOz+2kLmHL4vMLeU0mntVpF8vA4U63QNiSNogMdKGc7l1wdLfxPh5IqvaHVD4wDNq7diHBQzi/cbekKjX8ED7ZC70tGJq6/vyQ3wMES929OkxlgdPnIHBmEZWPsNhtty3Dyirznwy3ykBRs0nnRUn/Gu0/3bXsEE9ZzpkQzBsEnYIk0cGxU7XqYsydDjpr536lA61OHivDWWTJ6oPI/fnvsZLoBnCxIb2BHyjqmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tb+i9wu0TS1gl1qo0tc2jROz2bGaHmSTlw1IBnRi0o=;
 b=ahnocUsDYWMcbqBnthqpoe+WqO6VVS1aTQXkGcRg5A8bZaM1HlzHLUdxHOO6t8ntSE0EIy/li/ucXB2Y4eTtYA/un8kzRL3Y4sFXbuXVWX6IoO2GHmVwfzKcaVD4PX0yO6vXqcBsj4c4ABQ/TBwMOJU39HWsGXOZtRr3xvXJEWk=
Received: from AM6PR08MB2999.eurprd08.prod.outlook.com (2603:10a6:209:44::28)
 by AM6PR08MB4168.eurprd08.prod.outlook.com (2603:10a6:20b:aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 08:26:01 +0000
Received: from AM6PR08MB2999.eurprd08.prod.outlook.com
 ([fe80::889a:5795:8fec:3bf1]) by AM6PR08MB2999.eurprd08.prod.outlook.com
 ([fe80::889a:5795:8fec:3bf1%3]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 08:26:00 +0000
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
Subject: RE: [PATCH v3 1/3] hwrng: cctrng - Add dependency on OF
Thread-Topic: [PATCH v3 1/3] hwrng: cctrng - Add dependency on OF
Thread-Index: AQHWHIgZN7YKol1Tq02g1xaDTWU+daiNEe0AgAFkcMCAAAISgIAC0ikggAAEJ4CAAAQ74A==
Date:   Thu, 30 Apr 2020 08:26:00 +0000
Message-ID: <AM6PR08MB29990D46BD6C974ACE1914F0E9AA0@AM6PR08MB2999.eurprd08.prod.outlook.com>
References: <1587987364-4566-1-git-send-email-hadar.gat@arm.com>
 <1587987364-4566-2-git-send-email-hadar.gat@arm.com>
 <20200427150658.GA26305@gondor.apana.org.au>
 <DB7PR08MB3003E1459755B853B41490D6E9AC0@DB7PR08MB3003.eurprd08.prod.outlook.com>
 <20200428123007.GA3969@gondor.apana.org.au>
 <AM6PR08MB2999F52B99066C321837144DE9AA0@AM6PR08MB2999.eurprd08.prod.outlook.com>
 <20200430074941.GA12529@gondor.apana.org.au>
In-Reply-To: <20200430074941.GA12529@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 9b64d07b-9683-4563-826c-b2270e40a0d1.0
x-checkrecipientchecked: true
Authentication-Results-Original: gondor.apana.org.au; dkim=none (message not
 signed) header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=arm.com;
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b01a4c40-27fd-44a1-ae27-08d7ece02448
x-ms-traffictypediagnostic: AM6PR08MB4168:|AM6PR08MB4168:|AM5PR0802MB2386:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0802MB2386152F669193A265F9EBA0E9AA0@AM5PR0802MB2386.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4502;OLM:4502;
x-forefront-prvs: 0389EDA07F
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB2999.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(66476007)(6506007)(66556008)(5660300002)(8676002)(478600001)(76116006)(66946007)(9686003)(55016002)(66446008)(7696005)(33656002)(64756008)(186003)(86362001)(2906002)(52536014)(26005)(8936002)(54906003)(71200400001)(316002)(6916009)(7416002)(4744005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: wdQoYF4MGTj2gB55r8li1luiYITq8yxU1S+NyoMVMCUXA0VVXnl946d5Qz31jnL+YFikrYFvfvWMkfdm1p2pS7AqmjFOwTaP6u/TT/R7jJQbPrPcvqr62MGP4dXoPYVDGf1Q1keGsirMgnZRlvuuLjJJJjwjS46LARKiGBsC0jCnFNmGR/eDnZHLb9BosI5z16BXmVoDtnUIuxVrKPdk+t8FSST+Ie8GnNevDjBYgDcsgqkVu77eTnmgZskKnfMqFofcPdO2TvlZe+Bgom9iFLo5fZXPip/iPTA7s3xL+aE9XqJad+ezvht+GmV1gPgYe6V/EsHcKzilgsM7aG5UDgSXJPUJNuPEGs72jbEvpmEqI6oq9ZxQT7Dy+tJ4ExmbSCD+rswBl0R58BUoD5hLuTvWTkJtby5Svhk1hryG08x9uHuMPBFNHkQcsrsXskq4
x-ms-exchange-antispam-messagedata: EHrrK5q1j4KTEKymMX7IGzkG0WtDcgfiRIVoWxNpdXQVZ1SUR2m1wbvI1SgSx9ZcWHGe4GEPsQ4mZJP6UxsuL9A8Pr/ozjicjNM1HEmntVPa87Oidrn828pfvXwrF1R/ZjsriVO7+hm72IJw+lhT/BA0cnapOcEHUdZmVmGUMVHBiEV4Klidh9dkGpaMebjGpPYW2EVvXQRwBye7d+sXmZJa5UQJ3L14KGDt5HtxE9k9wmMvnjBimb21guunt5lSH2F6/f0+eX8VP1VAuwXprBHDXCylojeoLR+yXQk7a0BOrfolE1DMqnnjL5AE2Qgq5heWBxvR/F++7BZGGSmEYf7OOMOSzmM+F1THV6xUXFnCZtQoL8fYuPZHv12GUCwg/zhD7+kBnc6rIhui2qJzCEValGDTfGl8U1AjfmMnWewRSZ/MUeHJjh0rr7Fnx15Dkw6EUWsKyIEdAfbdrDemL9hn6fmyNhSt3asTsNAhZc8h3Yhdn9ffJfE+hEtmp+JUfocKFqVocPGf2yricxZpY7wnLMPxaQUmk5C9JrZ5+rNBz4+MjDtk7dMmqnjOeKd7KawixVCFOc9/czrk9EItalYB+rYMXekAuWdAaO2/eYtEO2THneMIrYs6Jc/Lyw+PqerfD0etybzTbKH+BV2jEa3dU7IsWhqTVmenr+X2jX8fRD6nfIx/4oxM/XbAIG19bHU3GgfyYsNq68kTuyohkkF8w87tdyV6AykJZM4jbPnXzLYpAwMi9obpwfu3Zfuvp5lQD0Te/OT5uidxivzCA132zuC+146lXQQs0nOaV4k=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4168
Original-Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(46966005)(336012)(54906003)(26005)(186003)(36906005)(86362001)(52536014)(9686003)(55016002)(70586007)(70206006)(33656002)(7696005)(450100002)(4326008)(47076004)(8676002)(6506007)(82310400002)(5660300002)(2906002)(81166007)(316002)(8936002)(82740400003)(356005)(478600001)(4744005)(6862004);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 7c7e9ade-6c4b-4d93-86b4-08d7ece01d92
X-Forefront-PRVS: 0389EDA07F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ViWqPpPCCReMQ9/RJQSkMe6iEVbWLnXMSKwGs+RATKR/82PPfBOwE1icGtZLqOP0IDiguAZZAqL0bLx1qu+ZF5YYHCAexy9IV7AAz3aEVVVUXIHnxpWykftEJTtT03a1PWtsMA7oYJt4utwWm116PrlO5cBWtlFrMbw6AnVGuxMIYCpcJNg9dejXqEwPeOxub8ResfqGZkvEq3av2wCo2t0nC3EbgZDIptGUxAu4m/rLkHSVEKCou/lqCa/WrD8aG6+gUvyCaPZ9grwjHjTEBXTTj8+uPXO+8f7wDWtBjqN8NqDsKCB5zGxwTprBpjAAQZ8kGPoxQ/fdwcn/6k8ggX8lynRqh5cpsKWTNmwxpZLP2jSUZeMLhHJvkiNtlpHxHJ+gy1DPNoQ3rg1f+9etiv0E+bGxUWXi+PYjMev9CVV5EXOzcy0+rBFk63lmdzVi+77EkOoGJMwkveaLyppvRmQvniotSlvnoXiGI058wO6Yzx6WH8vntBVg6fSwk5a3KJ/A9UONT+XYe3SsAAPlhw==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:26:12.0387
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b01a4c40-27fd-44a1-ae27-08d7ece02448
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0802MB2386
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IEZyb206IGxpbnV4LWNyeXB0by1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNyeXB0
by0NCj4gb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YgSGVyYmVydCBYdQ0KPiAN
Cj4gT24gVGh1LCBBcHIgMzAsIDIwMjAgYXQgMDc6Mzk6MTRBTSArMDAwMCwgSGFkYXIgR2F0IHdy
b3RlOg0KPiA+DQo+ID4gWWVzLCBpdCBidWlsZHMsIGJ1dCBpdCBpcyB1c2VsZXNzLg0KPiANCj4g
QnV0IHRoYXQncyB0aGUgd2hvbGUgcG9pbnQgb2YgQ09NUElMRV9URVNULg0KDQpIZXJiZXJ0LA0K
SSBkb24ndCB1bmRlcnN0YW5kIGlmIGFueXRoaW5nIG5lZWQgdG8gYmUgZml4ZWQgYmVmb3JlIHRo
aXMgcGF0Y2ggY2FuIGJlIGFwcGxpZWQuDQpUaGUgcGF0Y2ggYWRkcyBkZXBlbmRlbmN5IG9uIE9G
LCB3aGljaCB3YXMgbWlzc2luZyBhbmQgaXMgcmVxdWlyZWQgZm9yIHRoZSBjY3RybmcgZHJpdmVy
Lg0KKEluZGVlZCBjY3RybmcgY29tcGlsYXRpb24gcGFzc2VkIGFsc28gd2l0aG91dCBDT05GSUdf
T0YgYmVjYXVzZSBvZiB0aGUgZW1wdHkgaW1wbGVtZW50YXRpb24gb2Ygb2ZfcHJvcGVydHlfcmVh
ZCooKSBmdW5jdGlvbnMgdGhhdCBzaW1wbHkgcmV0dXJucyAtRU5PU1lTLikNCg0KSGFkYXINCg==
