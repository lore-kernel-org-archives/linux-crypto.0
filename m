Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22CDDC3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 08:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3A9F22D6D
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 08:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="gA41sjOc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfHUIod (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 04:44:33 -0400
Received: from mail-eopbgr740087.outbound.protection.outlook.com ([40.107.74.87]:10654
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726330AbfHUIod (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 04:44:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPXI2gApxZikWSWBxd5FIIcxbUO+tKZVh1XlYV9gWOy7he92JP38tfFusv4Y7h0uc6NxxaJ9Hr3lhwAIcSySkqRXR6Mgd6ruN77i8RrInyB80QR6ccySAXZ+qhRhb4B8EBY46ID1yCiGjUjtcG5xCQyyOdSqEBxYnpVGbHA9aKKFLvDwbYlIQre5thmqHmA/sSYLGMaXhez5KAUbJdBnPxRHVqpS5474ADwy0+W4gRG8Ts1xpii7DDovpTXuaW+PFezcQQfkOXqn6f0sqUzTri/RUdUUabWZiLhwO3sxNOuRl8oMtiXAyvPbSHkD/r+1jZ1UNAIL0RJG0Cglb9a+yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXAjP9yJ+tyB7dr4Nf51Pssf+BxRm5XRNLN61WSMeTg=;
 b=QcZCD5stccNDx7USzV6HDtQ45ZO7Gsz++Q37pM1Or69zpc1AijPxn0myLEROQAt5/73ezU2uDWZX4/rQiHmy8vMBBIRL6z8ytCyh2PcXSnM300rTom7o3XzLLZjo+2OaWJ/CADugl/HtJv/INvK74WiIbP9I8xi8qno1aocV7CVnKnD96VLslBrCMDzWhRb1IWemBSgtoZcPqWmviApWr4PRQlXxYRjGw6KZ7X87QHXQ1vPUqF3WAZ0xFTEb8XDJu8zwSXbA131By+0ABYY/LsROrVq0QUBnD1OVVwAKlRNL/99U2HCNKkCk0DoUidu9Otdb2c2FStsq7YLp0lnZwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXAjP9yJ+tyB7dr4Nf51Pssf+BxRm5XRNLN61WSMeTg=;
 b=gA41sjOcWK9hm/OmAly5znGte7b14cnwYgmeddmTJiBzSRzh2cDkw7yfHW49JKIotEI3VJl98fr/M1gbHkzUGHX4/iNRgkXOrMfvdp7KK4rhtafsLEAa0A0yKfPtfMR/lco24shVraktjr7rbR/ij5MnGqsJWBcyTyLCElZX4JM=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3215.namprd20.prod.outlook.com (52.132.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Wed, 21 Aug 2019 08:44:29 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2178.018; Wed, 21 Aug 2019
 08:44:28 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Josh Boyer <jwboyer@kernel.org>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        Linux Firmware <linux-firmware@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [GIT PULL] inside-secure: add new GPLv2 "mini" firmware for the
 EIP197 driver
Thread-Topic: [GIT PULL] inside-secure: add new GPLv2 "mini" firmware for the
 EIP197 driver
Thread-Index: AQHVTFYdBTGcyhV0m0CpxLDQb9nj26b8IaoAgAfeoqCAABgpAIABRmEQ
Date:   Wed, 21 Aug 2019 08:44:28 +0000
Message-ID: <MN2PR20MB29733775B5469BC5CC725CD2CAAA0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <CAK9qPMA=-MnkdpkUE_CU5FRmZ6LSk2FzfBJNsB0XRiaYxy9UWA@mail.gmail.com>
 <CA+5PVA5BC7AtcJ4Ud33Ft9h_=kRcqeLoHtjRfvu_XBSvgej74g@mail.gmail.com>
 <MN2PR20MB297310E2E089219DF583E6E5CAAB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CA+5PVA49nn=H9PrbzYMu0QR1tswTk0gTNORobOMqRPpFgEsGTw@mail.gmail.com>
In-Reply-To: <CA+5PVA49nn=H9PrbzYMu0QR1tswTk0gTNORobOMqRPpFgEsGTw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c441be6b-f346-4598-2ee0-08d72613c782
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB3215;
x-ms-traffictypediagnostic: MN2PR20MB3215:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB32155F30E7D7B5ABE83515A1CAAA0@MN2PR20MB3215.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39850400004)(366004)(346002)(376002)(199004)(189003)(13464003)(55016002)(71190400001)(9686003)(8676002)(2906002)(25786009)(99286004)(33656002)(7696005)(14454004)(316002)(478600001)(76176011)(6246003)(15974865002)(54906003)(305945005)(4326008)(6116002)(86362001)(3846002)(7736002)(76116006)(74316002)(66446008)(66066001)(229853002)(66946007)(966005)(53936002)(102836004)(66476007)(64756008)(66556008)(6306002)(186003)(14444005)(256004)(81156014)(52536014)(6436002)(5024004)(476003)(446003)(8936002)(81166006)(26005)(486006)(6506007)(53546011)(6916009)(5660300002)(71200400001)(11346002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3215;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C8dKBnkc6CwD05yz4Qh79ZVPFMSxilG0BWpC6cSMXkD0/dQKTkR3hxHtTL5KPZg9/9tjW/k4Y1czwhhmZl0FOJGZLqeNLusGYVtzsJQ2fa4rKviVFq/piS4h1TG+b0SCr2uiICGc0bTE4j9KqdJ3cX0KzV1b70sA9BwzCC+vWowh/BfC4fple5++/mvZOuOymJ1oXHBaKGrb49O1XCdu9S/a1OPP4uoUOfOY6YlMoW43vHqspyLm+XVYPoGb1FcgQrK8yt+Y6Sw+f7Fv/qpQjYHtSwMgyjvdSs8H0CxBSdXGHk4p1e/28IP2ieOOatiCYzUx+zMnFCod9LwJXG53U0Jc4j0rlIPUFUDX2vAdf4nsgkiIXoA4uOKJp+Qo6FxY9/RO0FjTt+B7zm4rP3Au+fdH6Ltq/AnRSHWfJQxXi1M=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c441be6b-f346-4598-2ee0-08d72613c782
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 08:44:28.7277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ASdTZcqOWs/hh9BgCLqNXL+wuSOfSgqlRb6674y+zyKMVZF7dr7RNoOKkVDXbbZhF+tIh7sGSQyFaL3w0goR/lJcQGfWvHKi2rGAUM0fhWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3215
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYgT2YNCj4gSm9zaCBCb3llcg0KPiBTZW50OiBUdWVzZGF5LCBBdWd1c3QgMjAsIDIwMTkg
MzoxMCBQTQ0KPiBUbzogUGFzY2FsIFZhbiBMZWV1d2VuIDxwdmFubGVldXdlbkB2ZXJpbWF0cml4
LmNvbT4NCj4gQ2M6IFBhc2NhbCB2YW4gTGVldXdlbiA8cGFzY2FsdmFubEBnbWFpbC5jb20+OyBM
aW51eCBGaXJtd2FyZSA8bGludXgtZmlybXdhcmVAa2VybmVsLm9yZz47DQo+IGxpbnV4LWNyeXB0
b0B2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtHSVQgUFVMTF0gaW5zaWRlLXNlY3Vy
ZTogYWRkIG5ldyBHUEx2MiAibWluaSIgZmlybXdhcmUgZm9yIHRoZSBFSVAxOTcgZHJpdmVyDQo+
IA0KPiBPbiBUdWUsIEF1ZyAyMCwgMjAxOSBhdCA4OjAxIEFNIFBhc2NhbCBWYW4gTGVldXdlbg0K
PiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogbGludXgtY3J5cHRvLW93bmVyQHZnZXIu
a2VybmVsLm9yZyA8bGludXgtY3J5cHRvLW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24NCj4gQmVo
YWxmIE9mDQo+ID4gPiBKb3NoIEJveWVyDQo+ID4gPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDE1
LCAyMDE5IDE6MzMgUE0NCj4gPiA+IFRvOiBQYXNjYWwgdmFuIExlZXV3ZW4gPHBhc2NhbHZhbmxA
Z21haWwuY29tPg0KPiA+ID4gQ2M6IExpbnV4IEZpcm13YXJlIDxsaW51eC1maXJtd2FyZUBrZXJu
ZWwub3JnPjsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gU3ViamVjdDogUmU6
IFtHSVQgUFVMTF0gaW5zaWRlLXNlY3VyZTogYWRkIG5ldyBHUEx2MiAibWluaSIgZmlybXdhcmUg
Zm9yIHRoZSBFSVAxOTcNCj4gZHJpdmVyDQo+ID4gPg0KPiA+ID4gT24gVHVlLCBBdWcgNiwgMjAx
OSBhdCA4OjU0IEFNIFBhc2NhbCB2YW4gTGVldXdlbiA8cGFzY2FsdmFubEBnbWFpbC5jb20+IHdy
b3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBUaGUgZm9sbG93aW5nIGNoYW5nZXMgc2luY2UgY29tbWl0
IGRmZjk4YzZjNTczODNmZTM0MzQwN2JjYjdiNmU3NzVlMGI4NzI3NGY6DQo+ID4gPiA+DQo+ID4g
PiA+ICAgTWVyZ2UgYnJhbmNoICdtYXN0ZXInIG9mIGdpdDovL2dpdGh1Yi5jb20vc2tlZ2dzYi9s
aW51eC1maXJtd2FyZQ0KPiA+ID4gPiAoMjAxOS0wNy0yNiAwNzozMjozNyAtMDQwMCkNCj4gPiA+
ID4NCj4gPiA+ID4gYXJlIGF2YWlsYWJsZSBpbiB0aGUgZ2l0IHJlcG9zaXRvcnkgYXQ6DQo+ID4g
PiA+DQo+ID4gPiA+DQo+ID4gPiA+ICAgaHR0cHM6Ly9naXRodWIuY29tL3B2YW5sZWV1d2VuL2xp
bnV4LWZpcm13YXJlLWNsZWFuLmdpdCBpc19kcml2ZXJfZncNCj4gPiA+ID4NCj4gPiA+ID4gZm9y
IHlvdSB0byBmZXRjaCBjaGFuZ2VzIHVwIHRvIGZiZmU0MWY5MmY5NDFkMTliODQwZWMwZTI4MmY0
MjIzNzk5ODJjY2I6DQo+ID4gPiA+DQo+ID4gPiA+ICAgaW5zaWRlLXNlY3VyZTogYWRkIG5ldyBH
UEx2MiAibWluaSIgZmlybXdhcmUgZm9yIHRoZSBFSVAxOTcgZHJpdmVyDQo+ID4gPiA+ICgyMDE5
LTA4LTA2IDEzOjE5OjQ0ICswMjAwKQ0KPiA+ID4gPg0KPiA+ID4gPiAtLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gPiA+
IFBhc2NhbCB2YW4gTGVldXdlbiAoMSk6DQo+ID4gPiA+ICAgICAgIGluc2lkZS1zZWN1cmU6IGFk
ZCBuZXcgR1BMdjIgIm1pbmkiIGZpcm13YXJlIGZvciB0aGUgRUlQMTk3IGRyaXZlcg0KPiA+ID4g
Pg0KPiA+ID4gPiAgV0hFTkNFICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDEwICsr
KysrKysrKysNCj4gPiA+ID4gIGluc2lkZS1zZWN1cmUvZWlwMTk3X21pbmlmdy9pZnBwLmJpbiB8
IEJpbiAwIC0+IDEwMCBieXRlcw0KPiA+ID4gPiAgaW5zaWRlLXNlY3VyZS9laXAxOTdfbWluaWZ3
L2lwdWUuYmluIHwgQmluIDAgLT4gMTA4IGJ5dGVzDQo+ID4gPiA+ICAzIGZpbGVzIGNoYW5nZWQs
IDEwIGluc2VydGlvbnMoKykNCj4gPiA+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBpbnNpZGUtc2Vj
dXJlL2VpcDE5N19taW5pZncvaWZwcC5iaW4NCj4gPiA+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBp
bnNpZGUtc2VjdXJlL2VpcDE5N19taW5pZncvaXB1ZS5iaW4NCj4gPiA+DQo+ID4gPiBJZiB0aGlz
IGlzIEdQTHYyLCB3aGVyZSBpcyB0aGUgc291cmNlIGNvZGU/DQo+ID4gPg0KPiA+IE9rLCBJIGFt
IG5vdCBhIGxhd3llciBzbyBJIGRvbid0IGtub3cgYW55dGhpbmcgYWJvdXQgdGhpcyBsaWNlbnNl
IHN0dWZmLg0KPiA+IEkganVzdCBtZWFudCBpdCBpcyBmcmVlIHRvIHVzZSBhbmQgZG8gd2hhdGV2
ZXIgeW91IHdhbnQgd2l0aC4NCj4gPiBHUEx2MiB3YXMgYWdyZWVkIHdpdGggb3VyIGxhd3llcnMg
Zm9yIHRoZSBkcml2ZXIgc291cmNlIGNvZGUsIHNvIEkganVzdA0KPiA+IHN0dWNrIHRoYXQgb24g
dGhlIGZpcm13YXJlIGFzIHdlbGwgKG5vdCBsb29raW5nIGZvcndhcmQgdG8gYW5vdGhlciB0aW1l
DQo+ID4gY29uc3VtaW5nIHBhc3MgdGhyb3VnaCB0aGUgbGVnYWwgZGVwYXJ0bWVudCEpLg0KPiA+
DQo+ID4gSWYgR1BMdjIgaW1wbGllcyB0aGF0IHlvdSBoYXZlIHRvIHByb3ZpZGUgc291cmNlIGNv
ZGUsIHRoZW4gd2hhdCBvdGhlcg0KPiA+IGxpY2Vuc2Ugc2hvdWxkIEkgdXNlIHRoYXQgbWVhbnMg
ZnJlZWRvbSwgYnV0IG5vIHNvdXJjZSBjb2RlPw0KPiANCj4gSSB1bmRlcnN0YW5kIHRoYXQgY2Fu
IGJlIHRpbWUgY29uc3VtaW5nLCBidXQgSSBhbSBub3QgYSBsYXd5ZXIgYW5kIG5vdA0KPiBnb2lu
ZyB0byBnaXZlIHlvdSBsZWdhbCBhZHZpY2UsIHNvcnJ5LiAgSSBjZXJ0YWlubHkgY2FuJ3QgdGVs
bCB5b3UgaG93DQo+IHRvIGxpY2Vuc2UgeW91ciBvd24gY29kZS4NCj4gDQo+ID4gTm90ZSB0aGF0
Og0KPiA+DQo+ID4gYSkgSSBhY3R1YWxseSAqbG9zdCogdGhlIHNvdXJjZSBjb2RlIChubyBqb2tl
IG9yIGV4Y3VzZSEpDQo+ID4gYikgVGhpcyBpcyBmb3IgYSBwcm9wcmlldGFyeSBpbi1ob3VzZSBt
aWNybyBlbmdpbmUsIHNvIHdoaWxlIHdlIGRvbid0DQo+ID4gICAgbmVjZXNzYXJpbHkgbWluZCBw
cm92aWRpbmcgdGhlIHNvdXJjZSBjb2RlLCB3ZSBkb24ndCB3YW50IHRvIHByb3ZpZGUNCj4gPiAg
ICBhbnkgZG9jdW1lbnRhdGlvbiBvciBhc3NlbWJsZXIgZm9yIHRoYXQuIEFzIHdlIGRlZmluaXRl
bHkgZG9uJ3Qgd2FudA0KPiA+ICAgIHRvICpzdXBwb3J0KiBhbnkgb3RoZXIgcGVvcGxlIG1lc3Np
bmcgd2l0aCBpdC4gTWFraW5nIHRoZSBzb3VyY2UgY29kZQ0KPiA+ICAgIGVmZmVjdGl2ZWx5IHVz
ZWxlc3MgYW55d2F5Lg0KPiANCj4gVGhhdCBkb2Vzbid0IHNvdW5kIGxpa2UgeW91IHdhbnQgR1BM
IGF0IGFsbCwgd2hpY2ggaXMgYSBzdHJvbmcNCj4gY29weWxlZnQgbGljZW5zZSB0aGF0IHJlcXVp
cmVzIHNvdXJjZSBhbmQgYWxsb3dzIHBlb3BsZSB0byByZWJ1aWxkIGl0Lg0KPiBTdXBwb3J0IGlz
IGEgZGlmZmVyZW50IHN0b3J5IGFuZCBub3QgcmVhbGx5IHRpZWQgdG8gdGhlIGxpY2Vuc2UuDQo+
IA0KSW50ZXJlc3RpbmdseSB0aG91Z2gsIHRoZXJlIGFyZSBvdGhlciBmaXJtd2FyZXMgaW4gV0hF
TkNFIGFsbGVkZ2VkbHkNCmJlaW5nIEdQTHYyIHdpdGhvdXQgcHJvdmlkaW5nIHNvdXJjZXMsIGV2
ZW4gc3RhdGluZyAid2UgcHJlZmVyIHlvdSBub3QgdG8NCmFzayBmb3IgdGhlIHNvdXJjZSIuIFNv
IGl0J3MgY2VydGFpbmx5IG5vdCBlbmZvcmNlZCBjb25zaXN0ZW50bHkuDQooYWxzbywgR1BMdjIg
d2lzZSwgeW91IHdvdWxkIGJlIE9LIGlmIHlvdSBwcm92aWRlIGl0IG9uIHJlcXVlc3Qgb25seSkN
Cg0KSW4gYW55IGNhc2UsIEkgY2FuIG1vZGlmeSB0aGUgbGljZW5zZSB0byAiUmVkaXN0cmlidXRh
YmxlIiB3aXRoIHNvbWUNCmNvcHlyaWdodCBhdHRhY2hlZCwgdGhhdCBzZWVtcyB0byBiZSBjb21t
b24gcHJhY3RpY2UgYXMgd2VsbC4gU2luY2UgdGhhdA0KaXMgYWN0dWFsbHkgbW9yZSByZXN0cmlj
dGl2ZSB0aGFuIEdQTHYyLCBpdCBzaG91bGQgYmUgT0sgbGVnYWxseS4NCg0KPiBqb3NoDQo+IA0K
PiA+ID4gPiBkaWZmIC0tZ2l0IGEvV0hFTkNFIGIvV0hFTkNFDQo+ID4gPiA+IGluZGV4IDMxZWRi
ZDQuLmZjZTJlZjcgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL1dIRU5DRQ0KPiA+ID4gPiArKysgYi9X
SEVOQ0UNCj4gPiA+ID4gQEAgLTQ1MTQsMyArNDUxNCwxMyBAQCBGaWxlOiBtZXNvbi92ZGVjL2d4
bF9tcGVnNF81LmJpbg0KPiA+ID4gPiAgRmlsZTogbWVzb24vdmRlYy9neG1faDI2NC5iaW4NCj4g
PiA+ID4NCj4gPiA+ID4gIExpY2VuY2U6IFJlZGlzdHJpYnV0YWJsZS4gU2VlIExJQ0VOU0UuYW1s
b2dpY192ZGVjIGZvciBkZXRhaWxzLg0KPiA+ID4gPiArDQo+ID4gPiA+ICstLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPiA+ID4gPiArDQo+ID4gPiA+ICtEcml2ZXI6IGluc2lkZS1zZWN1cmUgLS0gSW5zaWRl
IFNlY3VyZSBFSVAxOTcgY3J5cHRvIGRyaXZlcg0KPiA+ID4gPiArDQo+ID4gPiA+ICtGaWxlOiBp
bnNpZGUtc2VjdXJlL2VpcDE5N19taW5pZncvaXB1ZS5iaW4NCj4gPiA+ID4gK0ZpbGU6IGluc2lk
ZS1zZWN1cmUvZWlwMTk3X21pbmlmdy9pZnBwLmJpbg0KPiA+ID4gPiArDQo+ID4gPiA+ICtMaWNl
bmNlOiBHUEx2Mi4gU2VlIEdQTC0yIGZvciBkZXRhaWxzLg0KPiA+ID4gPiArDQo+ID4gPiA+IGRp
ZmYgLS1naXQgYS9pbnNpZGUtc2VjdXJlL2VpcDE5N19taW5pZncvaWZwcC5iaW4NCj4gPiA+ID4g
Yi9pbnNpZGUtc2VjdXJlL2VpcDE5N19taW5pZncvaWZwcC5iaW4NCj4gPiA+ID4gbmV3IGZpbGUg
bW9kZSAxMDA2NDQNCj4gPiA+ID4gaW5kZXggMDAwMDAwMC4uYjRhODMyMg0KPiA+ID4gPiBCaW5h
cnkgZmlsZXMgL2Rldi9udWxsIGFuZCBiL2luc2lkZS1zZWN1cmUvZWlwMTk3X21pbmlmdy9pZnBw
LmJpbiBkaWZmZXINCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2luc2lkZS1zZWN1cmUvZWlwMTk3X21p
bmlmdy9pcHVlLmJpbg0KPiA+ID4gPiBiL2luc2lkZS1zZWN1cmUvZWlwMTk3X21pbmlmdy9pcHVl
LmJpbg0KPiA+ID4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+ID4gPiBpbmRleCAwMDAwMDAw
Li4yZjU0OTk5DQo+ID4gPiA+IEJpbmFyeSBmaWxlcyAvZGV2L251bGwgYW5kIGIvaW5zaWRlLXNl
Y3VyZS9laXAxOTdfbWluaWZ3L2lwdWUuYmluIGRpZmZlcg0KPiA+DQo+ID4gUmVnYXJkcywNCj4g
PiBQYXNjYWwgdmFuIExlZXV3ZW4NCj4gPiBTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJv
dG9jb2wgRW5naW5lcyBAIFZlcmltYXRyaXgNCj4gPiB3d3cuaW5zaWRlc2VjdXJlLmNvbQ0KDQoN
Cg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11
bHRpLVByb3RvY29sIEVuZ2luZXMgQCBWZXJpbWF0cml4DQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0K
DQo=
