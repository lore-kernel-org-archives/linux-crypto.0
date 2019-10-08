Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE3BC4360C
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0A46206BB
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="nWbIopII"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfJHIPt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Oct 2019 04:15:49 -0400
Received: from mail-eopbgr770047.outbound.protection.outlook.com ([40.107.77.47]:6785
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730292AbfJHIPt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Oct 2019 04:15:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9S2/SovGJS3TskxfJ8DRANyzDzWjcIbPRews8zgD/AZgSAAIkUIqL02OyHHuFn8+Fm5rupzKxIL8UIj9pGaz15SrPauZ/5G0dDTR+ERcTeVCnccresB1/dKMH5NNoOtwXFQ8o13Sem60mR/3RAOo9tC2zgbbUfY1fOJci4gboCcjvKu0zGMjT1TQDEqVkaPIAl0oo78GV0F+HmSZavXy3tXx4Hn26SXw/X/704mZwWNYx3Fku2+/sMlEjT1+Vgcqb7ZmORYvV2zj3qgM4K5Rb+tGornyUiyDQKbuUaoJaoKqhovKGiZuTVZ/embBC49nj6Q0K3dXJZTieImc4yKBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6UWWwsaNhC+Thhl/+3xwPIRn1z247/D5ha2oahwtV4=;
 b=m+3S6nzJA/9dICF6tDyqolLGzVssHepnw90+RN3JN2BNhbNQAm9O/yWzIVJDvW8GZHjjnE7+4PKRxOWSZRxSX9IspdFtg/BYa4JIF+9aQkvbVM6GNou3fzXojASEXe+HZOQbplARrJGvCZelcNu+ViIkgoJppavQmMAgrxsE9+9y3VK/FziJ+hPOt3t4NywH8eS1Ac1+NOAFAxfG39AzARRLdDqwHd/a8Ld88aYYnCkJJqKvkW0Uh0SJ2cMu3TKCnm1h/CA1g6plaDCXKWj4+cgsz2lgbwICnIlKdblCBNkeOrbi2qR2wpiSJa3XR1DIpGKg2UKlqyr/OP9r27QOsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6UWWwsaNhC+Thhl/+3xwPIRn1z247/D5ha2oahwtV4=;
 b=nWbIopIIK59KqCOYD3aUM08SZ5GtRCxK6fxLinbGHSG+ZYYkFd+9wFGNV85A1mIKR9GPz9y0q8URKM+7g1onFzrIdY9AYrP4uoHu0731s7pnZOsOpLaK+g60rFDc+lov1ohmhj11v2muSoFzF5tAHAK67V3MbgfP3mCasDpty+8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2336.namprd20.prod.outlook.com (20.179.147.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Tue, 8 Oct 2019 08:15:43 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 08:15:43 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Colin King <colin.king@canonical.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] crypto: inside-secure: fix spelling mistake
 "algorithmn" -> "algorithm"
Thread-Topic: [PATCH][next] crypto: inside-secure: fix spelling mistake
 "algorithmn" -> "algorithm"
Thread-Index: AQHVfbBiWkZb4mCzbk2SwbBbsORNa6dQZX5A
Date:   Tue, 8 Oct 2019 08:15:43 +0000
Message-ID: <MN2PR20MB29735A64971670E9CE56821ECA9A0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191008081410.18857-1-colin.king@canonical.com>
In-Reply-To: <20191008081410.18857-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e3c4ec2-0082-45c4-5ab7-08d74bc7b6c5
x-ms-traffictypediagnostic: MN2PR20MB2336:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB23368864C8D2A97FA916BB39CA9A0@MN2PR20MB2336.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39840400004)(366004)(396003)(199004)(13464003)(189003)(6246003)(229853002)(4326008)(25786009)(478600001)(5660300002)(14454004)(2501003)(55016002)(2906002)(52536014)(66066001)(6436002)(33656002)(15974865002)(9686003)(7736002)(71200400001)(7696005)(305945005)(102836004)(3846002)(53546011)(71190400001)(76176011)(6506007)(256004)(66476007)(64756008)(86362001)(26005)(316002)(8936002)(66556008)(186003)(66946007)(99286004)(74316002)(66446008)(76116006)(6116002)(486006)(446003)(8676002)(110136005)(81156014)(54906003)(81166006)(11346002)(476003)(14444005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2336;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z7QDvfqWgigPycnI0QmaHcK5yEqUdIAkexCcZ1+DRycQLn9m3aj6kY7BKRnIJ3kocqevsQlDcjeG7nGNJcSIroK5QmyLlvp6WmGV/JGlA43JGPuKc33nlUcjGXlXe3sswzli5ntXhJtzWhQXcdMZwg5Lq7WDVhgkrMwE3sG8XIbC1P11q933Ps0Ogqd9LN1W5pOZf+BlcD+Ra3eTDayeYW/2H4Fc9E4JhylHW5v5sLsz8k4JEGvdTjsJpTnOO/yOCKEHiHiueF/k6+a+txm6pmIjCWN84HakLBTb8lgPH3RpDtAklkitwn0JvX2GY+sPhOqBbp60WfPCe1B9/h0cRh5jfxV1LtHGq954SeuwvPq8BSYaB3hVKT00Kz0wjx7SB2PLN9e24DbbT2pGJzqeN5rTLD2YpE1GXq9pQ0lUOTA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3c4ec2-0082-45c4-5ab7-08d74bc7b6c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 08:15:43.1977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mr0ewIaY4sHtH58ll1VQM9LcwZ4TFwDgaYgsN+QaCbolVi6OyJo04PnV7hzXOOHYUZ+S8qL3dOFXxuBGqeFtBgvFaoxCdyqCuqilmN/tiWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2336
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8t
b3duZXJAdmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3Jn
PiBPbiBCZWhhbGYgT2YgQ29saW4NCj4gS2luZw0KPiBTZW50OiBUdWVzZGF5LCBPY3RvYmVyIDgs
IDIwMTkgMTA6MTQgQU0NCj4gVG86IEFudG9pbmUgVGVuYXJ0IDxhbnRvaW5lLnRlbmFydEBib290
bGluLmNvbT47IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IERhdmlk
DQo+IFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBsaW51eC1jcnlwdG9Admdlci5r
ZXJuZWwub3JnDQo+IENjOiBrZXJuZWwtamFuaXRvcnNAdmdlci5rZXJuZWwub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQQVRDSF1bbmV4dF0gY3J5cHRvOiBp
bnNpZGUtc2VjdXJlOiBmaXggc3BlbGxpbmcgbWlzdGFrZSAiYWxnb3JpdGhtbiIgLT4gImFsZ29y
aXRobSINCj4gDQo+IEZyb206IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5j
b20+DQo+IA0KPiBUaGVyZSBpcyBhIHNwZWxsaW5nIG1pc3Rha2UgaW4gYSBkZXZfZXJyIG1lc3Nh
Z2UuIEZpeCBpdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xpbi5r
aW5nQGNhbm9uaWNhbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vaW5zaWRlLXNlY3Vy
ZS9zYWZleGNlbF9jaXBoZXIuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2lu
c2lkZS1zZWN1cmUvc2FmZXhjZWxfY2lwaGVyLmMgYi9kcml2ZXJzL2NyeXB0by9pbnNpZGUtDQo+
IHNlY3VyZS9zYWZleGNlbF9jaXBoZXIuYw0KPiBpbmRleCBjZWNjNTYwNzMzMzcuLjhjY2M5YzU5
ZjM3NiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vaW5zaWRlLXNlY3VyZS9zYWZleGNl
bF9jaXBoZXIuYw0KPiArKysgYi9kcml2ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3NhZmV4Y2Vs
X2NpcGhlci5jDQo+IEBAIC00MzcsNyArNDM3LDcgQEAgc3RhdGljIGludCBzYWZleGNlbF9hZWFk
X3NldGtleShzdHJ1Y3QgY3J5cHRvX2FlYWQgKmN0Zm0sIGNvbnN0IHU4ICprZXksDQo+ICAJCQln
b3RvIGJhZGtleTsNCj4gIAkJYnJlYWs7DQo+ICAJZGVmYXVsdDoNCj4gLQkJZGV2X2Vycihwcml2
LT5kZXYsICJhZWFkOiB1bnN1cHBvcnRlZCBoYXNoIGFsZ29yaXRobW4iKTsNCj4gKwkJZGV2X2Vy
cihwcml2LT5kZXYsICJhZWFkOiB1bnN1cHBvcnRlZCBoYXNoIGFsZ29yaXRobSIpOw0KPiAgCQln
b3RvIGJhZGtleTsNCj4gIAl9DQo+IA0KPiAtLQ0KPiAyLjIwLjENCg0KQWN0dWFsbHksIHRoZSB0
eXBpbmcgZXJyb3IgaXMgd2VsbCBzcG90dGVkLCBidXQgdGhlIGZpeCBpcyBub3QgY29ycmVjdC4N
CldoYXQgYWN0dWFsbHkgaGFwcGVuZWQgaGVyZSBpcyB0aGF0IGEgXCBnb3QgYWNjaWRlbnRhbGx5
IGRlbGV0ZWQsDQp0aGVyZSBzaG91bGQgaGF2ZSBiZWVuIGEgIlxuIiBhdCB0aGUgZW5kIG9mIHRo
ZSBsaW5lIC4uLg0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFy
Y2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIFZlcmltYXRyaXgNCnd3dy5pbnNpZGVz
ZWN1cmUuY29tDQo=
