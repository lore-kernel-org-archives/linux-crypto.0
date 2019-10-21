Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A94CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C4F20882
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="xhbhdn1S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfJUMkB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:40:01 -0400
Received: from mail-eopbgr780088.outbound.protection.outlook.com ([40.107.78.88]:18880
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbfJUMkB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 08:40:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz3+Paz6oP/Nd6yioabyQlb6CD2/J7Q64cj/eU8ztq8COzu8V5ucnMeEHXrXOd5CyQzBMcg8yuxo9SMjVxx2apP/Ari4+zICUJ1RzilzqZGdk1nvnaYm+9Tj0p0VTbrMChL5L9DMF7+5EBMtzXPJf4F10PpkGkL9TVNP5rWdPoq/Tr8Cd/Sqqs6okWPrGRfdu1mmPEa8e1DCG6Ib8lf7MnvynA5oVI6Uz8hHAS2WE1b3er8JmuYalV62cnwYQkQ9ix5l6sUVXV9+fZ7HhJuOV3L8EUvy+j5KzMFFHyyg7JjPydLYWaBVNenVmR4JaiNPDkxYkpvUJ4cFCXsWxT/2jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8maiez2CfalH9c9tM0zulZVaNNVZiaakbP4vKOIhQ4=;
 b=hFXuIAPoFS6Uyvr+8I19hFFmfK+kDuHUglpJFzxlkc6AvDMeGvmsaK1QtN994D/9b1HMFH34S/kV9pzPf+aQJHLXyLvkFT9tW5inS2+bMw9LfUkW17bllRfwRcaDRwr+J/gvmCbbCTSJQEIL6CC5OpdZCWn92tIRo8nONSo115DSnZu9TTnBBmNplnYFzvzBi08bQs/0BxS9+n6r1cPCH5KnPJ4idHlLkTPn2lzGR8rjH93ymW8rVnf9UvnKfMI19i04ig2GzZGCdZtngphfNl++AuiZtGHo3PeTWvqtmUjE6cTjqMYZ7nWFxuBKn9PWvL7QuQbtxx2g4VNjnlokoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8maiez2CfalH9c9tM0zulZVaNNVZiaakbP4vKOIhQ4=;
 b=xhbhdn1Sok4O0noEy9u8Vdi4IH9pnfB7GOurM8SnPnvz5q7yM4mvpjWKmSeLXpeOz0M9MZ2V6dJSPKjADS6o0htV5aC+e+uPMwR9xwtYFni6yeoOx23+buOo7ZIjVa0wfcgW7sJtmjbPP5IlE2blcg1O598qkJKSljWAkJ38QhM=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB3152.namprd20.prod.outlook.com (52.132.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Mon, 21 Oct 2019 12:39:58 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 12:39:58 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: RE: Key endianness?
Thread-Topic: Key endianness?
Thread-Index: AdWH7WiyGB6aVNy7SJOkTaAoiPGHOgADxdEgAAKexAAAAMmMEA==
Date:   Mon, 21 Oct 2019 12:39:57 +0000
Message-ID: <MN2PR20MB2973E221217FBDA1252804E4CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8CvoaTCBxWjd9f=CtcK8GkgJkhRgYGjUHy3MqRKhezEg@mail.gmail.com>
In-Reply-To: <CAKv+Gu8CvoaTCBxWjd9f=CtcK8GkgJkhRgYGjUHy3MqRKhezEg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a5451c3-3b5b-4b14-75e4-08d75623c859
x-ms-traffictypediagnostic: MN2PR20MB3152:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3152F583B52935F497123A19CA690@MN2PR20MB3152.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(39850400004)(376002)(396003)(13464003)(189003)(43544003)(199004)(26005)(256004)(2906002)(186003)(6506007)(102836004)(71190400001)(476003)(66446008)(64756008)(76116006)(66476007)(66556008)(99286004)(52536014)(7696005)(3480700005)(486006)(66946007)(71200400001)(5660300002)(15974865002)(6116002)(3846002)(11346002)(446003)(14444005)(76176011)(53546011)(8936002)(478600001)(7736002)(33656002)(54906003)(316002)(74316002)(305945005)(7116003)(55016002)(14454004)(6246003)(81166006)(8676002)(81156014)(229853002)(86362001)(4326008)(66066001)(6436002)(6916009)(25786009)(9686003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3152;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JdDVe1akeyPyI+DM9CuPgwwkfnzGBAkDWMVXYsJUhjCulahuDuYLABGpN7xthrtZKu/g/liwEe7/neX1WjQVghD0pmkVDdV+P3hDINTYnQ+yATQKJu/IDSXMHlq6LL/F9Ux3ONKeb2k1tfM4UibC9LK1Y+xP8v53F4OMNYGZ4jTbgxac2HQFX0DTJTYzvqwd2pJnyNnIWh+oQnj40q1LW9+f7hrl1CH2t6oa4zFVEyID1C/vQdrVcZRl5MwpThf86Yq15SDCKjlEyDZCAL+3ikQGPBzsMZnkFqhmxsEOSjSrZJmBmN7RhDTMAV06GxHiIWYaYrcB8Cgq3lVuxttKiloHj219/fIIXAJw4Tmq+I38VCyaVMABewyJtLID8JlMZsxAqNKyWZyRnwAjvQ6IL5FrPTsPy7B6XLsXcXatIFWNxqA7HX3i91of0bN6itYe
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5451c3-3b5b-4b14-75e4-08d75623c859
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 12:39:58.0175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /TayFEYxA17PKRr1VxutvGZ8bKm8rSUG4LZcACknRK4I0kYjcthf5jSrBaM/POjxcnmR/0NuhFtVH6ei6dUmSAhMGycs7EoGpYRoVph7PFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3152
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
LmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gU2VudDogTW9uZGF5LCBPY3RvYmVyIDIxLCAyMDE5
IDE6NTkgUE0NCj4gVG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJp
eC5jb20+DQo+IENjOiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBoZXJiZXJ0QGdvbmRv
ci5hcGFuYS5vcmcuYXUNCj4gU3ViamVjdDogUmU6IEtleSBlbmRpYW5uZXNzPw0KPiANCj4gT24g
TW9uLCAyMSBPY3QgMjAxOSBhdCAxMjo1NiwgUGFzY2FsIFZhbiBMZWV1d2VuDQo+IDxwdmFubGVl
dXdlbkB2ZXJpbWF0cml4LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBBbm90aGVyIGVuZGlhbm5lc3Mg
cXVlc3Rpb246DQo+ID4NCj4gPiBJIGhhdmUgc29tZSBkYXRhIHN0cnVjdHVyZSB0aGF0IGNhbiBi
ZSBlaXRoZXIgbGl0dGxlIG9yIGJpZyBlbmRpYW4sDQo+ID4gZGVwZW5kaW5nIG9uIHRoZSBleGFj
dCB1c2UgY2FzZS4gQ3VycmVudGx5LCBJIGhhdmUgaXQgZGVmaW5lZCBhcyB1MzIuDQo+ID4gVGhp
cyBjYXVzZXMgc3BhcnNlIGVycm9ycyB3aGVuIGFjY2Vzc2luZyBpdCB1c2luZyBjcHVfdG9fWGUz
MigpIGFuZA0KPiA+IFhlMzJfdG9fY3B1KCkuDQo+ID4NCj4gPiBOb3csIGZvciB0aGUgYmlnIGVu
ZGlhbiBjYXNlLCBJIGNvdWxkIHVzZSBodG9ubCgpL250b2hsKCkgaW5zdGVhZCwNCj4gPiBidXQg
dGhpcyBpcyBpbmNvbnNpc3RlbnQgd2l0aCBhbGwgb3RoZXIgZW5kaWFuIGNvbnZlcnNpb25zIGlu
IHRoZQ0KPiA+IGRyaXZlciAuLi4gYW5kIHRoZXJlJ3Mgbm8gbGl0dGxlIGVuZGlhbiBhbHRlcm5h
dGl2ZSBJJ20gYXdhcmUgb2YuDQo+ID4gU28gSSBkb24ndCByZWFsbHkgbGlrZSB0aGF0IGFwcHJv
YWNoLg0KPiA+DQo+ID4gQWx0ZXJuYXRpdmVseSwgSSBjb3VsZCBkZWZpbmUgYSB1bmlvbiBvZiBi
b3RoIGEgYmlnIGFuZCBsaXR0bGUNCj4gPiBlbmRpYW4gdmVyc2lvbiBvZiB0aGUgZGF0YSBidXQg
dGhhdCB3b3VsZCByZXF1aXJlIHRvdWNoaW5nIGEgbG90DQo+ID4gb2YgbGVnYWN5IGNvZGUgKHVu
bGVzcyBJIHVzZSBhIEMxMSBhbm9ueW1vdXMgdW5pb24gLi4uIG5vdCBzdXJlDQo+ID4gaWYgdGhh
dCB3b3VsZCBiZSBhbGxvd2VkPykgYW5kIElNSE8gaXMgYSBiaXQgc2lsbHkuDQo+ID4NCj4gPiBJ
cyB0aGVyZSBzb21lIHdheSBvZiB0ZWxsaW5nIHNwYXJzZSB0byBfbm90XyBjaGVjayBmb3IgImNv
cnJlY3QiDQo+ID4gdXNlIG9mIHRoZXNlIGZ1bmN0aW9ucyBmb3IgYSBjZXJ0YWluIHZhcmlhYmxl
Pw0KPiA+DQo+IA0KPiANCj4gSW4gdGhpcyBjYXNlLCBqdXN0IHVzZSAoX19mb3JjZSBfX1hlMzIq
KSB0byBjYXN0IGl0IHRvIHRoZSBjb3JyZWN0DQo+IHR5cGUuIFRoaXMgYW5ub3RhdGVzIHRoZSBj
YXN0IGFzIGJlaW5nIGludGVudGlvbmFsbHkgZW5kaWFuLXVuY2xlYW4sDQo+IGFuZCBzaHV0cyB1
cCBTcGFyc2UuDQo+IA0KVGhhbmtzIGZvciB0cnlpbmcgdG8gaGVscCBvdXQsIGJ1dCB0aGF0IGp1
c3QgZ2l2ZXMgbWUgYW4gDQoiZXJyb3I6IG5vdCBhbiBsdmFsdWUiIGZyb20gYm90aCBzcGFyc2Ug
YW5kIEdDQy4NCkJ1dCBJJ20gcHJvYmFibHkgZG9pbmcgaXQgd3Jvbmcgc29tZWhvdyAuLi4NCg0K
PiA+IFJlZ2FyZHMsDQo+ID4gUGFzY2FsIHZhbiBMZWV1d2VuDQo+ID4gU2lsaWNvbiBJUCBBcmNo
aXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMgQCBWZXJpbWF0cml4DQo+ID4gd3d3Lmluc2lk
ZXNlY3VyZS5jb20NCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+
IEZyb206IFBhc2NhbCBWYW4gTGVldXdlbg0KPiA+ID4gU2VudDogTW9uZGF5LCBPY3RvYmVyIDIx
LCAyMDE5IDExOjA0IEFNDQo+ID4gPiBUbzogbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsg
aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1DQo+ID4gPiBTdWJqZWN0OiBLZXkgZW5kaWFubmVz
cz8NCj4gPiA+DQo+ID4gPiBIZXJiZXJ0LA0KPiA+ID4NCj4gPiA+IEknbSBjdXJyZW50bHkgYnVz
eSBmaXhpbmcgc29tZSBlbmRpYW5uZXNzIHJlbGF0ZWQgc3BhcnNlIGVycm9ycyByZXBvcnRlZA0K
PiA+ID4gYnkgdGhpcyBrYnVpbGQgdGVzdCByb2JvdCBhbmQgdGhpcyB0cmlnZ2VyZWQgbXkgdG8g
cmV0aGluayBzb21lIGVuZGlhbg0KPiA+ID4gY29udmVyc2lvbiBiZWluZyBkb25lIGluIHRoZSBp
bnNpZGUtc2VjdXJlIGRyaXZlci4NCj4gPiA+DQo+ID4gPiBJIGFjdHVhbGx5IHdvbmRlciB3aGF0
IHRoZSBlbmRpYW5uZXNzIGlzIG9mIHRoZSBpbnB1dCBrZXkgZGF0YSwgZS5nLiB0aGUNCj4gPiA+
ICJ1OCAqa2V5IiBwYXJhbWV0ZXIgdG8gdGhlIHNldGtleSBmdW5jdGlvbi4NCj4gPiA+DQo+ID4g
PiBJIGFsc28gd29uZGVyIHdoYXQgdGhlIGVuZGlhbm5lc3MgaXMgb2YgdGhlIGtleSBkYXRhIGlu
IGEgc3RydWN0dXJlDQo+ID4gPiBsaWtlICJjcnlwdG9fYWVzX2N0eCIsIGFzIGZpbGxlZCBpbiBi
eSB0aGUgYWVzX2V4cGFuZGtleSBmdW5jdGlvbi4NCj4gPiA+DQo+IA0KPiBjcnlwdG9fYWVzX2N0
eCB1c2VzIENQVSBlbmRpYW5uZXNzIGZvciB0aGUgcm91bmQga2V5cy4NCj4gDQpTbyB0aGVzZSB3
aWxsIG5lZWQgdG8gYmUgY29uc2lzdGVudGx5IGhhbmRsZWQgdXNpbmcgY3B1X3RvX1hlMzIuDQoN
Cj4gSW4gZ2VuZXJhbCwgdGhvdWdoLCB0aGVyZSBpcyBubyBzdWNoIHRoaW5nIGFzIGVuZGlhbm5l
c3MgZm9yIGEga2V5DQo+IHRoYXQgaXMgZGVjbGFyZWQgYXMgdThbXSwgaXQgaXMgc2ltcGx5IGEg
c2VxdWVuY2Ugb2YgYnl0ZXMuDQo+DQpEZXBlbmRzIGEgYml0IG9uIHRoZSBhbGdvcml0aG0uIFNv
bWUga2V5cyBhcmUgaW5kZWVkIGRlZmluZWQgYXMgYnl0ZQ0Kc3RyZWFtcywgaW4gd2hpY2ggY2Fz
ZSB5b3UgaGF2ZSBhIHBvaW50LiBBc3N1bWluZyB5b3UgbWVhbiB0aGF0IHRoZSANCmNyeXB0byBB
UEkgZm9sbG93cyB0aGUgYnl0ZSBvcmRlciBhcyBkZWZpbmVkIGJ5IHRoZSBhbGdvcml0aG0gc3Bl
Yy4NCg0KQnV0IHNvbWV0aW1lcyB0aGUga2V5IGRhdGEgaXMgYWN0dWFsbHkgYSBzdHJlYW0gb2Yg
X3dvcmRzXyAoZXhhbXBsZToNCkNoYWNoYTIwKSBhbmQgdGhlbiBlbmRpYW5uZXNzIF9kb2VzXyBt
YXR0ZXIuIFNhbWUgdGhpbmcgYXBwbGllcyB0bw0KdGhpbmdzIGxpa2Ugbm9uY2VzIGFuZCBpbml0
aWFsIGNvdW50ZXIgdmFsdWVzIEJUVy4NCg0KPiBJZiB0aGUNCj4gaGFyZHdhcmUgY2hvb3NlcyB0
byByZW9yZGVyIHRob3NlIGJ5dGVzIGZvciBzb21lIHJlYXNvbiwgaXQgaXMgdGhlDQo+IHJlc3Bv
bnNpYmlsaXR5IG9mIHRoZSBkcml2ZXIgdG8gdGFrZSBjYXJlIG9mIHRoYXQgZnJvbSB0aGUgQ1BV
IHNpZGUuDQo+IA0KV2hpY2ggc3RpbGwgcmVxdWlyZXMgeW91IHRvIGtub3cgdGhlIGJ5dGUgb3Jk
ZXIgYXMgdXNlZCBieSB0aGUgQVBJLg0KDQo+IA0KPiA+ID4gU2luY2UgSSBrbm93IG15IGN1cnJl
bnQgZW5kaWFubmVzcyBjb252ZXJzaW9ucyB3b3JrIG9uIGEgbGl0dGxlIGVuZGlhbg0KPiA+ID4g
Q1BVLCBJIGd1ZXNzIHRoZSBiaWcgcXVlc3Rpb24gaXMgd2hldGhlciB0aGUgYnl0ZSBvcmRlciBv
ZiB0aGlzIGtleQ0KPiA+ID4gZGF0YSBpcyBfQ1BVIGJ5dGUgb3JkZXJfIG9yIGFsd2F5cyBzb21l
IF9maXhlZCBieXRlIG9yZGVyXyAoZS5nLiBhcyBwZXINCj4gPiA+IGFsZ29yaXRobSBzcGVjaWZp
Y2F0aW9uKS4NCj4gPiA+DQo+ID4gPiBJIGtub3cgSSBoYXZlIHNvbWUgY3VzdG9tZXJzIHVzaW5n
IGJpZy1lbmRpYW4gQ1BVJ3MsIHNvIEkgZG8gY2FyZSwgYnV0DQo+ID4gPiBJIHVuZm9ydHVuYXRl
bHkgZG9uJ3QgaGF2ZSBhbnkgcGxhdGZvcm0gYXZhaWxhYmxlIHRvIHRlc3QgdGhpcyB3aXRoLg0K
PiA+ID4NCj4gDQo+IFlvdSBjYW4gYm9vdCBiaWcgZW5kaWFuIGtlcm5lbHMgb24gTWFjY2hpYXRv
QmluLCBpbiBjYXNlIHRoYXQgaGVscHMNCj4gKHVzaW5nIHUtYm9vdCwgbm90IEVGSSkNCj4NCkkn
bSBzdXJlIF9zb21lb25lXyBjYW4sIEknbSBub3Qgc28gc3VyZSBfSV8gY2FuIDstKQ0KDQpSZWdh
cmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJv
dG9jb2wgRW5naW5lcyBAIFZlcmltYXRyaXgNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQo=
