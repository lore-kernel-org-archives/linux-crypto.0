Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A94C4360C
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 08:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB4E0206C2
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 08:33:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="A1k07O2G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbfJHIdb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Oct 2019 04:33:31 -0400
Received: from mail-eopbgr810071.outbound.protection.outlook.com ([40.107.81.71]:45312
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728866AbfJHIdb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Oct 2019 04:33:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDr+rJqdm2SkRGjFxfrZM3bMud+X9W9ZTjzssEIDu9Ose+1R9J4TYyzMtm8BYsEGf9kyqq5moPjgkjhWh7j8l6ePnD4vsJ0SYRUpiO8v3HLg7qKbqSns1l3q9+Zhy82kkdR/WQdTdp+KH8nnyXfMsGYkhissm1wOpVV8dDjfhfnmBaVZdyrYhwF5bFg6sw5xbFPNWkrs/1fIoXzc/tI4I6hZZFquJx/Ey8Ra2uxYYqblJ3fC/7au8+BngY0BG2NSSA4lk7EwebLrRxTI22XQ92usgkXfl9zG4zDrAtvgh4/kW3+anY/m55WQ/aOY9mGRhIV/xchQZcjBmUqCtnZ26Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9eTxaPjMbJ+Rp0kh/yaQUUbKcA0lTRXOy0bxGooVg8=;
 b=EOAdFgRwaB7DHyxs5IAKeo8AKVrv+eRRWG/99+gBT6daSZHQGbf2w0MqFe/nQfAO0qMxzVmRcRaEUMOV3mr0yb4cS/WlxFMub+et0mHpe2JRWwBn7cV8JzHx2f+wluBMCdlhCotakgQ+qJe9J159CozO+fJu0UfwToBX/uBV/Fxmn2I0kff5ROh9Dm+kCGM8rW74T0JYfot3fGfhak6djeUqGQWw5Go2CzMgiEpwt5Kslasvp1jc2VQ8lCOiSAZJtPas5F+i3P8HDGonNjbKSvXUXSETVCOOIUrisimtMbnNSXjdqVebe1DZlCByzSYXZAHpRKpR47okfupOAo9OHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9eTxaPjMbJ+Rp0kh/yaQUUbKcA0lTRXOy0bxGooVg8=;
 b=A1k07O2GeZrGKghTG0iVjVW53SirsuCibvt9de5HAsuc1oj2PPCDuvCdClIfUyM0B5wPeuGfkmNohhdpWqA35tHErGW6AsjkEK4KxPK6nvygrMSnx9WqlvwO1Uu5mejw/2K/FAJ91CPjxuWIXuXq6r4lvRMo4WBuGbsGz8xdQxk=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB3136.namprd20.prod.outlook.com (52.132.175.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Tue, 8 Oct 2019 08:33:28 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 08:33:28 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Colin King <colin.king@canonical.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][V2][next] crypto: inside-secure: fix spelling mistake
 "algorithmn" -> "algorithm"
Thread-Topic: [PATCH][V2][next] crypto: inside-secure: fix spelling mistake
 "algorithmn" -> "algorithm"
Thread-Index: AQHVfbHSdQvJAe1cl0uPSyzLD/7AAKdQamVg
Date:   Tue, 8 Oct 2019 08:33:28 +0000
Message-ID: <MN2PR20MB29736C4AC72870F42C142AC6CA9A0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191008082428.19839-1-colin.king@canonical.com>
In-Reply-To: <20191008082428.19839-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3004ab2e-c444-4f7d-afaa-08d74bca319e
x-ms-traffictypediagnostic: MN2PR20MB3136:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB31367BCB1B7D533E3BF4567ACA9A0@MN2PR20MB3136.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:813;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39850400004)(366004)(189003)(199004)(13464003)(7736002)(33656002)(305945005)(76176011)(15974865002)(8936002)(99286004)(25786009)(110136005)(74316002)(316002)(7696005)(5660300002)(81166006)(2501003)(478600001)(14454004)(8676002)(54906003)(81156014)(71190400001)(52536014)(71200400001)(11346002)(446003)(66556008)(3846002)(14444005)(66476007)(256004)(6246003)(64756008)(66946007)(486006)(102836004)(9686003)(76116006)(66446008)(476003)(229853002)(66066001)(186003)(26005)(6506007)(53546011)(55016002)(6436002)(2906002)(86362001)(6116002)(4326008)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3136;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vuekE+qlG2yQRu3cKHpofc02bm1PZi42vQCy2XXp2vFGbhfzIprqpbCOAf/+zhBFeCBdS7aNR32UY3W3xQj/jm9h4ZTp52A4qJApzjLTG0BWWuYxdxgcNKig+DRcoIU1xPiWv3cDhDiq372RACHDXb9+saUweWj8eXXXczi3yDXNKrMl0GX84my4FB/KX0NeUYxAVN9fCbzjbKPjcJoTQl7f3djAylEFT9WhSpEbRUAFdd6nHFVrnMqB7/V65eWuz+MhWaPquwyYGfsRsDZOE+osUlfB91UaiR4C20/k7yFU66G3IHie2Y4JDPUffCKObuAY1vm+LZwIdz78pGZatr6M77j6/6MvqXCCiglIA6jX8+744pvF7UTnzdA6Q9lemAxEwoH9MTqFgCa4coG/UqNu0YG5+jX5AwbbRib0IWk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3004ab2e-c444-4f7d-afaa-08d74bca319e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 08:33:28.2885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: npnkEC60UL6KwUmD5ykxTYAbgHjQ8xr7wSxLgrasEY3rOuwaEt6OIzn0cXHWiWk62ChZZeJzyQUvyvIjbjB3JAj0HijY9xCVmw+D07XFz0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3136
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYgT2YgQ29saW4NCj4gS2luZw0KPiBTZW50OiBUdWVzZGF5LCBPY3RvYmVyIDgsIDIwMTkg
MTA6MjQgQU0NCj4gVG86IEFudG9pbmUgVGVuYXJ0IDxhbnRvaW5lLnRlbmFydEBib290bGluLmNv
bT47IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IERhdmlkDQo+IFMg
LiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwu
b3JnDQo+IENjOiBrZXJuZWwtamFuaXRvcnNAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQQVRDSF1bVjJdW25leHRdIGNyeXB0bzogaW5z
aWRlLXNlY3VyZTogZml4IHNwZWxsaW5nIG1pc3Rha2UgImFsZ29yaXRobW4iIC0+DQo+ICJhbGdv
cml0aG0iDQo+IA0KPiBGcm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwu
Y29tPg0KPiANCj4gVGhlcmUgaXMgYSBzcGVsbGluZyBtaXN0YWtlIGluIGEgZGV2X2VyciBtZXNz
YWdlLiBGaXggaXQuIEFkZCBpbiBtaXNzaW5nDQo+IG5ld2xpbmUuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiAtLS0NCj4g
DQo+IFYyOiBBZGQgaW4gbmV3bGluZSBcbg0KPiANCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9p
bnNpZGUtc2VjdXJlL3NhZmV4Y2VsX2NpcGhlci5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9jcnlwdG8vaW5zaWRlLXNlY3VyZS9zYWZleGNlbF9jaXBoZXIuYyBiL2RyaXZlcnMvY3J5cHRv
L2luc2lkZS0NCj4gc2VjdXJlL3NhZmV4Y2VsX2NpcGhlci5jDQo+IGluZGV4IGNlY2M1NjA3MzMz
Ny4uOGNjYzljNTlmMzc2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9pbnNpZGUtc2Vj
dXJlL3NhZmV4Y2VsX2NpcGhlci5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2luc2lkZS1zZWN1
cmUvc2FmZXhjZWxfY2lwaGVyLmMNCj4gQEAgLTQzNyw3ICs0MzcsNyBAQCBzdGF0aWMgaW50IHNh
ZmV4Y2VsX2FlYWRfc2V0a2V5KHN0cnVjdCBjcnlwdG9fYWVhZCAqY3RmbSwgY29uc3QgdTggKmtl
eSwNCj4gIAkJCWdvdG8gYmFka2V5Ow0KPiAgCQlicmVhazsNCj4gIAlkZWZhdWx0Og0KPiAtCQlk
ZXZfZXJyKHByaXYtPmRldiwgImFlYWQ6IHVuc3VwcG9ydGVkIGhhc2ggYWxnb3JpdGhtbiIpOw0K
PiArCQlkZXZfZXJyKHByaXYtPmRldiwgImFlYWQ6IHVuc3VwcG9ydGVkIGhhc2ggYWxnb3JpdGht
XG4iKTsNCj4gIAkJZ290byBiYWRrZXk7DQo+ICAJfQ0KPiANCj4gLS0NCj4gMi4yMC4xDQpCZXR0
ZXIgOi0pIEFuZCB0aGFua3MgZm9yIGZpeGluZyB0aGF0LCBCVFcuDQoNCkFja2VkLWJ5OiBQYXNj
YWwgdmFuIExlZXV3ZW4gPHB2YW5sZWV1d2VuQHZlcmltYXRyaXguY29tPg0KDQpSZWdhcmRzLA0K
UGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wg
RW5naW5lcyBAIFZlcmltYXRyaXgNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQoNCg==
