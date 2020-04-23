Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8D4C54FCB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 14:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0A0B2087E
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 14:00:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3ZIgSWJd";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3ZIgSWJd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgDWOA6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 10:00:58 -0400
Received: from mail-db8eur05on2054.outbound.protection.outlook.com ([40.107.20.54]:6222
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727053AbgDWOA5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 10:00:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MRb3gbTmtCQQK0j7veDIM4UdM9WBxhcJB8zbHGwiJA=;
 b=3ZIgSWJdfe44i/u+g4IGUTHpwQHq4AjO0MohAivZRaNjMX1XEr71UrQ56SWaQ29Gb4rog+U+Qq6Z2Mo8SIbC3C3wIO//G5vxUlpmmOBiJj9ZZRYnsI2Gk4DIkr2umxdOmwjJSGXwJteeauhKs/FBB7/AZRXtgeQmsm7CzwTWf34=
Received: from AM6PR10CA0024.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::37)
 by AM6PR08MB4850.eurprd08.prod.outlook.com (2603:10a6:20b:d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Thu, 23 Apr
 2020 14:00:53 +0000
Received: from AM5EUR03FT037.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:89:cafe::fc) by AM6PR10CA0024.outlook.office365.com
 (2603:10a6:209:89::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Thu, 23 Apr 2020 14:00:53 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT037.mail.protection.outlook.com (10.152.17.241) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.19 via Frontend Transport; Thu, 23 Apr 2020 14:00:51 +0000
Received: ("Tessian outbound ecb846ece464:v53"); Thu, 23 Apr 2020 14:00:51 +0000
X-CR-MTA-TID: 64aa7808
Received: from 96e461477285.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 4BD63D90-4310-46D5-87F0-FC38EC3E8929.1;
        Thu, 23 Apr 2020 14:00:46 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 96e461477285.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 23 Apr 2020 14:00:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0nBmDJwui8waPp08//dmraiRyWHdmAH4wwlXQpCYlOhHcdDC6KUstGJsZn2WWSNGFGEIn45jXCVhxjopEBBpdDzC+LuVMmMUyy7t4aFoU2b+J4yFbPLjcCzmOBX67iIXTz16eVZDTV+Wij+Fe07Nwy5gy2rLLDhsMp3xDTkfS50LBY3zU7f3G1qND7OjRfpkgF4p3WcGZT5rI63M2Ll/rZHQTNy3pTMz2F0cPdV512dMW4CoXxpMrJqklwXlBRuGTIvQ56biXZckcZiHywsOnAJPtE+IeiPQqV3QIvBw+VWs5PNt/UAdef6wacxhJYcX9+OghXTUAt9c49RWiI3QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MRb3gbTmtCQQK0j7veDIM4UdM9WBxhcJB8zbHGwiJA=;
 b=ZOnuQRcGFfs9F7G9bfoELTk6m2/yOnKrS+xu2hyz4ed71WXRTrLeJdjeN+mLnakGd22ePDbua8BK0himBWAYWgTTWs5CuJyKoSYvRWdnZeH2Qj2SUwEaSVlmKuE0pUV6I0ZlOctq6TiCHmkQkWk5nbLG2b0127/Bnt0Kjo+e/qTnUr96KTDOL7szjiO5OtxrXMxFopfcXvsRmhvCNuo8rXbU9X7qUfLyXJsMKg7B3udDOjeuHBt5CNEyfiEdEaoBu/+60TI/D5j7+5Apl+D2Kn9gy2Ajgcok7cPoYhq4f2o9p4Bdvqc0fRxR+GBKBusOUkmaqZFMkodp99K953pXzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MRb3gbTmtCQQK0j7veDIM4UdM9WBxhcJB8zbHGwiJA=;
 b=3ZIgSWJdfe44i/u+g4IGUTHpwQHq4AjO0MohAivZRaNjMX1XEr71UrQ56SWaQ29Gb4rog+U+Qq6Z2Mo8SIbC3C3wIO//G5vxUlpmmOBiJj9ZZRYnsI2Gk4DIkr2umxdOmwjJSGXwJteeauhKs/FBB7/AZRXtgeQmsm7CzwTWf34=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (2603:10a6:4:a0::12)
 by DB6SPR00MB2420.eurprd08.prod.outlook.com (2603:10a6:4:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Thu, 23 Apr
 2020 14:00:44 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::b959:1879:c050:3117%8]) with mapi id 15.20.2921.030; Thu, 23 Apr 2020
 14:00:44 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Zou Wei <zou_wei@huawei.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        nd <nd@arm.com>
Subject: RE: [PATCH -next] hwrng: cctrng - Make some symbols static
Thread-Topic: [PATCH -next] hwrng: cctrng - Make some symbols static
Thread-Index: AQHWGWjayJXlqMKiXkeFpuo52WhbG6iGu/cg
Date:   Thu, 23 Apr 2020 14:00:44 +0000
Message-ID: <DB6PR0802MB2533C82FFC907FDFF331C312E9D30@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1587644481-38192-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1587644481-38192-1-git-send-email-zou_wei@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: d7f83074-0ce2-4f4d-8b1c-6c4d721df6d8.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [31.154.167.229]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 690569e7-00b5-4097-b27c-08d7e78ebbae
x-ms-traffictypediagnostic: DB6SPR00MB2420:|AM6PR08MB4850:
X-Microsoft-Antispam-PRVS: <AM6PR08MB485041578B47E24E2E1C96E5E9D30@AM6PR08MB4850.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:1227;OLM:1227;
x-forefront-prvs: 03827AF76E
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(86362001)(55016002)(316002)(52536014)(8676002)(66476007)(66556008)(64756008)(66446008)(110136005)(478600001)(54906003)(8936002)(76116006)(66946007)(7696005)(4326008)(81156014)(71200400001)(186003)(5660300002)(33656002)(9686003)(26005)(2906002)(6506007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: o53DCDnfgtqbfQY9sHuUm00kd8bRvqn7QzvNx0VNaX6wHPSEI8PBB5IRDoaYNhYGgVj/9LjfP9t/xb7rDHq5YUfFg5stUf7S6o7TyxswFs1OI3HnqIGdJ4qiu2CZ902tYurCFBWVM7LnQl0Ziqk/YNy92laJf9sWueNZPTFM898sJjqK0KG8J+5YDmePa+vlmfz6BmL36MX535kmA3GD57knU+HvXoMay78Ptmd1tuFm+gwtwspileBSdJQSjbNW+unKU8zFRGrLIZnrljh8E85C3Q46hiqnyRoP6qUU7jy4+bY8YCZwxOb2A8wu6hNogtfAOWePi4Q8inv/krC74hfzBv/jgu70ZNN68w/JFhKzyeQ19AVJpG0ZlH/E5b94Na6x8jX8jYXNzoGlp+mM63QQME6yt8OPKine/vRLaVr4o51JzOfuhG7dl9iQfOmc
x-ms-exchange-antispam-messagedata: PA+T2Orl+zOHittARXY4OmKWY7C4YeeVpRSe3B9q5RB08xpS5yAhnIlOH+FR44aUr73AUZaVpADoHbf1afFSKqKbXvMRV1l0DxpANrlKgosaVybNjPA063aKk6F2q95L4343I2Nl0K8iMq5qeAQo6A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6SPR00MB2420
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT037.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(46966005)(47076004)(55016002)(316002)(36906005)(356005)(82740400003)(70206006)(8676002)(81156014)(478600001)(70586007)(52536014)(82310400002)(110136005)(54906003)(7696005)(8936002)(81166007)(450100002)(4326008)(186003)(86362001)(5660300002)(33656002)(6506007)(9686003)(336012)(26005)(2906002);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: b40bbd44-92d2-430b-8b46-08d7e78eb7ad
X-Forefront-PRVS: 03827AF76E
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kr8EJCC3yNLS7JhBuoK9/am3yyPdQh+MGcWNsWDsgeFJHziWsG0nRCyo2TYHK7I96qaRJS34dncS6rT4VRca2L75A1sSI9yfX/Hcdtx40+w3VqMjO9LWGJCMwPG/f6I6xp3StvWYtv7C0/Iwb+Tk1U/cNFgfVOjM8xWF9gtcsVKuNh63+qN8a4LRBY+HA89CkL3xYugawhtyLPxq0hiPANEC4RrTQBhdvOfThOIGYVP3paCHrUVrKgFdhOPEg/S2zZ1xfVijIKUO8NxJDoV0uvjR/7hyJkrV2BvRaaBIyBynzSu+xDwHxckaTJyLb9+lJUi9RvRGpUJ2qh3mlZOSIHOQxLOyceGZM0boNR8iP/a6kN2ljh6OHMw/Ce3GXRjS7zTNGo6J0JX9vndsWTI982eXggCUVTJs6wQtqLsoqmXtZFXBaWAPt8LYK1DBWEt04aNbjM8YG6ZalI15QffAnv3EqLanrrtN+KjOuimT/4zSMfysvOry3r/9QSZ34P1NugpWhn0wmQkFct4MqkOdiA==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2020 14:00:51.5505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 690569e7-00b5-4097-b27c-08d7e78ebbae
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4850
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFpvdSBXZWkgPHpvdV93ZWlA
aHVhd2VpLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIDIzIEFwcmlsIDIwMjAgMTU6MjENCj4gDQo+
IEZpeCB0aGUgZm9sbG93aW5nIHNwYXJzZSB3YXJuaW5nczoNCj4gDQo+IGRyaXZlcnMvY2hhci9o
d19yYW5kb20vY2N0cm5nLmM6MzE2OjY6IHdhcm5pbmc6IHN5bWJvbA0KPiAnY2NfdHJuZ19jb21w
d29ya19oYW5kbGVyJyB3YXMgbm90IGRlY2xhcmVkLiBTaG91bGQgaXQgYmUgc3RhdGljPw0KPiBk
cml2ZXJzL2NoYXIvaHdfcmFuZG9tL2NjdHJuZy5jOjQ1MTo2OiB3YXJuaW5nOiBzeW1ib2wNCj4g
J2NjX3Rybmdfc3RhcnR3b3JrX2hhbmRsZXInIHdhcyBub3QgZGVjbGFyZWQuIFNob3VsZCBpdCBi
ZSBzdGF0aWM/DQo+IA0KPiBSZXBvcnRlZC1ieTogSHVsayBSb2JvdCA8aHVsa2NpQGh1YXdlaS5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IFpvdSBXZWkgPHpvdV93ZWlAaHVhd2VpLmNvbT4NCj4gLS0t
DQo+ICBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2NjdHJuZy5jIHwgNCArKy0tDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvY2hhci9od19yYW5kb20vY2N0cm5nLmMNCj4gYi9kcml2ZXJzL2NoYXIvaHdf
cmFuZG9tL2NjdHJuZy5jIGluZGV4IGU4MjcxNmMuLjNmZjM3YTYgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvY2hhci9od19yYW5kb20vY2N0cm5nLmMNCj4gKysrIGIvZHJpdmVycy9jaGFyL2h3X3Jh
bmRvbS9jY3RybmcuYw0KPiBAQCAtMzEzLDcgKzMxMyw3IEBAIHN0YXRpYyB2b2lkIGNjX3Rybmdf
aHdfdHJpZ2dlcihzdHJ1Y3QgY2N0cm5nX2RydmRhdGENCj4gKmRydmRhdGEpDQo+ICAJY2NfdHJu
Z19lbmFibGVfcm5kX3NvdXJjZShkcnZkYXRhKTsNCj4gIH0NCj4gDQo+IC12b2lkIGNjX3Rybmdf
Y29tcHdvcmtfaGFuZGxlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKncpDQo+ICtzdGF0aWMgdm9pZCBj
Y190cm5nX2NvbXB3b3JrX2hhbmRsZXIoc3RydWN0IHdvcmtfc3RydWN0ICp3KQ0KPiAgew0KPiAg
CXUzMiBpc3IgPSAwOw0KPiAgCXUzMiBlaHJfdmFsaWQgPSAwOw0KPiBAQCAtNDQ4LDcgKzQ0OCw3
IEBAIHN0YXRpYyBpcnFyZXR1cm5fdCBjY19pc3IoaW50IGlycSwgdm9pZCAqZGV2X2lkKQ0KPiAg
CXJldHVybiBJUlFfSEFORExFRDsNCj4gIH0NCj4gDQo+IC12b2lkIGNjX3Rybmdfc3RhcnR3b3Jr
X2hhbmRsZXIoc3RydWN0IHdvcmtfc3RydWN0ICp3KQ0KPiArc3RhdGljIHZvaWQgY2NfdHJuZ19z
dGFydHdvcmtfaGFuZGxlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKncpDQo+ICB7DQo+ICAJc3RydWN0
IGNjdHJuZ19kcnZkYXRhICpkcnZkYXRhID0NCj4gIAkJCWNvbnRhaW5lcl9vZih3LCBzdHJ1Y3Qg
Y2N0cm5nX2RydmRhdGEsIHN0YXJ0d29yayk7DQo+IC0tDQo+IDIuNi4yDQoNCkFja2VkLWJ5OiBI
YWRhciBHYXQgPGhhZGFyLmdhdEBhcm0uY29tPg0KDQo=
