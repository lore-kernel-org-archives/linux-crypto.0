Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6461AC32751
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 13:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2346C21E6E
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 13:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="UeRHzf2I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbfHGNwt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 09:52:49 -0400
Received: from mail-eopbgr780088.outbound.protection.outlook.com ([40.107.78.88]:57671
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729602AbfHGNwt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 09:52:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNDwYBOteB4e6k0YDrUAu7MWGesPGMRlvPV9UJR4yj6vP/5d8j70QZVKPOiidUqSjB/PNnkcp8SDpgkF8IDddv0AGf84ihuzQlyz2YrpfLcj0S930K49CxpM+yc38Aq1F7rVx6E7nge6U5v8+ghXR6ainMXs4YElgEfS81fjJg8O/8YxzbkXh3aSNVnqqV8/6ZHAAQICBVYZKIbj6scsUzcwKisgfG7+ca+dFomLGEVx7tfumJkG+DrIplten+HrbunJUGz6eQ/w2WbwGQy0Wr3wZ1lSfPyb8uQphfrU6UQttOdVSLPWt9tS3HUOiUWyOwU0uqYkPjBy0f8UKr0RKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1d+DM83AxOiEQ07AthC7xxaYb5FHkUwt8sQKn5Ifv1Q=;
 b=EBC6zk25T74m+wwzNo79DbESxFUr8+zBGjayzlixt1+QBVJx7/9yJl53v9e2pqsXVVD9fDEX8fWWTWjTc1HryOqMkC24gLixOtSzezP36zI6gATmmoCz4MqLs5clEkvIWlDR1AhIsUhZb43yssYlFhXJSAvjH8IcSaO+wjyIBCvhlkqqKTjz3IZBeXWOb7pModKEYi+rcJdPjpVPYr5+bg8HbWl//ejaSqZ2ukrjjAJYUN4VBwYV1Ugv/Jg6o4i7hhF2eAnvm90VdsfBDmERwdblrePberi1TZdCsAv/f1QDHsRB8IHLaBhzuPsTbgUXGlugPIwkfgEpbgVE+IA4DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1d+DM83AxOiEQ07AthC7xxaYb5FHkUwt8sQKn5Ifv1Q=;
 b=UeRHzf2I3ngujLgG/jBAO3hpdD2Zb36+dQ0RP87JDNJXT6ziNMB1jfNpUe8qd+qr/3ARU4rLKzthRpPmZoJmTySxSN37MpX0/7y4FuJO0zBdqFkpSesqVk0Y36lbig8lNHlDEVeSIsy/XKgpXmPIvOCETk344vfs2wq3b5oWTDg=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2559.namprd20.prod.outlook.com (20.179.145.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Wed, 7 Aug 2019 13:52:43 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 13:52:43 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "gmazyland@gmail.com" <gmazyland@gmail.com>
Subject: RE: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Topic: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Index: AQHVTOQKWnTPkdATo0i/D1XZtRSIkqbvRQ3wgABmBgCAAAHhUA==
Date:   Wed, 7 Aug 2019 13:52:43 +0000
Message-ID: <MN2PR20MB2973A02FC4D6F1D11BA80792CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
 <MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
In-Reply-To: <CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48205cef-6597-4a34-15e0-08d71b3e8542
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2559;
x-ms-traffictypediagnostic: MN2PR20MB2559:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB255996547A77079A3CECB3C7CAD40@MN2PR20MB2559.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(136003)(396003)(366004)(376002)(346002)(13464003)(199004)(189003)(316002)(15974865002)(71200400001)(71190400001)(2906002)(3846002)(6116002)(6246003)(256004)(25786009)(4326008)(76116006)(5660300002)(14444005)(7696005)(54906003)(68736007)(99286004)(86362001)(52536014)(8676002)(81156014)(66066001)(476003)(26005)(6916009)(229853002)(76176011)(53546011)(81166006)(6506007)(33656002)(53936002)(74316002)(11346002)(305945005)(478600001)(55016002)(14454004)(446003)(8936002)(66946007)(66446008)(64756008)(486006)(66476007)(66556008)(186003)(7736002)(6436002)(9686003)(102836004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2559;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Sa5zjxPV3PlYDJF9jEISAqcPPry3lRe/d7RFCjLivClhBfby11tbfjQBvRJXJW8VWg+XK+F1imiVWIp33NZwjP8frOPmKgtw99236ZZg8+rgWDo9acODGzD6xcMrP4iE1Txk7DA16XfdqhKbISSSO6dgjMljVJCeiyMHxdzNW7NrLJa84BRP2WrdY867cLKaW4r0Aavni3uVsTg0XRW8oHO8grnJkA1AKv0yM+r0Yg2lJYZwDIr+Wzo6jHZnW2uIYHIRnyy/WE/iWOQ7TtCwlkeMqBuLsTFv/MLxhbaREw6VKDuQUNBq94sij3I7ur+8oCORJj4ua0xDp5zfLq8PZ/Xi8c/ejA73oIlMu0sh2lgHHpEEerrs4KjiND2NtOPckPxWc1hm27SdksrlfXLIt0Dr2iL6SIxBxC9dR1X6PrM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48205cef-6597-4a34-15e0-08d71b3e8542
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 13:52:43.2308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2559
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

QXJkLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFyZCBCaWVzaGV1
dmVsIDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIEF1Z3Vz
dCA3LCAyMDE5IDM6MTcgUE0NCj4gVG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5A
dmVyaW1hdHJpeC5jb20+DQo+IENjOiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBoZXJi
ZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7IGViaWdnZXJzQGtlcm5lbC5vcmc7DQo+IGFna0ByZWRo
YXQuY29tOyBzbml0emVyQHJlZGhhdC5jb207IGRtLWRldmVsQHJlZGhhdC5jb207IGdtYXp5bGFu
ZEBnbWFpbC5jb20NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjJdIG1kL2RtLWNyeXB0IC0g
cmV1c2UgZWJvaXYgc2tjaXBoZXIgZm9yIElWIGdlbmVyYXRpb24NCj4gDQo+IE9uIFdlZCwgNyBB
dWcgMjAxOSBhdCAxMDoyOCwgUGFzY2FsIFZhbiBMZWV1d2VuDQo+IDxwdmFubGVldXdlbkB2ZXJp
bWF0cml4LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBBcmQsDQo+ID4NCj4gPiBJJ3ZlIGFjdHVhbGx5
IGJlZW4gZm9sbG93aW5nIHRoaXMgZGlzY3Vzc2lvbiB3aXRoIHNvbWUgaW50ZXJlc3QsIGFzIGl0
IGhhcw0KPiA+IHNvbWUgcmVsZXZhbmNlIGZvciBzb21lIG9mIHRoZSB0aGluZ3MgSSBhbSBkb2lu
ZyBhdCB0aGUgbW9tZW50IGFzIHdlbGwuDQo+ID4NCj4gPiBGb3IgZXhhbXBsZSwgZm9yIG15IENU
UyBpbXBsZW1lbnRhdGlvbiBJIG5lZWQgdG8gY3J5cHQgb25lIG9yIHR3bw0KPiA+IHNlcGVyYXRl
IGJsb2NrcyBhbmQgZm9yIHRoZSBpbnNpZGUtc2VjdXJlIGRyaXZlciBJIHNvbWV0aW1lcyBuZWVk
IHRvIGRvDQo+ID4gc29tZSBzaW5nbGUgY3J5cHRvIGJsb2NrIHByZWNvbXB1dGVzLiAodGhlIFhU
UyBkcml2ZXIgYWRkaXRpb25hbGx5DQo+ID4gYWxzbyBhbHJlYWR5IGRpZCBzdWNoIGEgc2luZ2xl
IGJsb2NrIGVuY3J5cHQgZm9yIHRoZSB0d2VhaywgYWxzbyB1c2luZw0KPiA+IGEgc2VwZXJhdGUg
KG5vbi1zayljaXBoZXIgaW5zdGFuY2UgLSB2ZXJ5IHNpbWlsYXIgdG8geW91ciBJViBjYXNlKQ0K
PiA+DQo+ID4gTG9uZyBzdG9yeSBzaG9ydCwgdGhlIGN1cnJlbnQgYXBwcm9hY2ggaXMgdG8gYWxs
b2NhdGUgYSBzZXBlcmF0ZQ0KPiA+IGNpcGhlciBpbnN0YW5jZSBzbyB5b3UgY2FuIGNvbnZlbmll
bnRseSBkbyBjcnlwdG9fY2lwaGVyX2VuL2RlY3J5cHRfb25lLg0KPiA+IChpdCB3b3VsZCBiZSBu
aWNlIHRvIGhhdmUgYSBtYXRjaGluZyBjcnlwdG9fc2tjaXBoZXJfZW4vZGVjcnlwdF9vbmUNCj4g
PiBmdW5jdGlvbiBhdmFpbGFibGUgZnJvbSB0aGUgY3J5cHRvIEFQSSBmb3IgdGhlc2UgcHVycG9z
ZXM/KQ0KPiA+IEJ1dCBpZiBJIHVuZGVyc3RhbmQgeW91IGNvcnJlY3RseSwgeW91IG1heSBlbmQg
dXAgd2l0aCBhbiBpbnNlY3VyZQ0KPiA+IHRhYmxlLWJhc2VkIGltcGxlbWVudGF0aW9uIGlmIHlv
dSBkbyB0aGF0LiBOb3Qgd2hhdCBJIHdhbnQgOi0oDQo+ID4NCj4gDQo+IFRhYmxlIGJhc2VkIEFF
UyBpcyBrbm93biB0byBiZSB2dWxuZXJhYmxlIHRvIHBsYWludGV4dCBhdHRhY2tzIG9uIHRoZQ0K
PiBrZXksIHNpbmNlIGVhY2ggYnl0ZSBvZiB0aGUgaW5wdXQgeG9yJ2VkIHdpdGggdGhlIGtleSBp
cyB1c2VkIGFzIGFuDQo+IGluZGV4IGZvciBkb2luZyBTYm94IGxvb2t1cHMsIGFuZCBzbyB3aXRo
IGVub3VnaCBzYW1wbGVzLCB0aGVyZSBpcyBhbg0KPiBleHBsb2l0YWJsZSBzdGF0aXN0aWNhbCBj
b3JyZWxhdGlvbiBiZXR3ZWVuIHRoZSByZXNwb25zZSB0aW1lIGFuZCB0aGUNCj4ga2V5Lg0KPiAN
Cj4gU28gaW4gdGhlIGNvbnRleHQgb2YgRUJPSVYsIHdoZXJlIHRoZSB1c2VyIG1pZ2h0IHNwZWNp
ZnkgYSBTSU1EIGJhc2VkDQo+IHRpbWUgaW52YXJpYW50IHNrY2lwaGVyLCBpdCB3b3VsZCBiZSBy
ZWFsbHkgYmFkIGlmIHRoZSBrbm93biBwbGFpbnRleHQNCj4gZW5jcnlwdGlvbnMgb2YgdGhlIGJ5
dGUgb2Zmc2V0cyB0aGF0IG9jY3VyIHdpdGggdGhlICpzYW1lKiBrZXkgd291bGQNCj4gaGFwcGVu
IHdpdGggYSBkaWZmZXJlbnQgY2lwaGVyIHRoYXQgaXMgYWxsb2NhdGVkIGltcGxpY2l0bHkgYW5k
IGVuZHMNCj4gdXAgYmVpbmcgZnVsZmlsbGVkIGJ5LCBlLmcuLCBhZXMtZ2VuZXJpYywgc2luY2Ug
aW4gdGhhdCBjYXNlLCBlYWNoDQo+IGJsb2NrIGVuL2RlY3J5cHRpb24gaXMgcHJlY2VkZWQgYnkg
YSBzaW5nbGUsIHRpbWUtdmFyaWFudCBBRVMNCj4gaW52b2NhdGlvbiB3aXRoIGFuIGVhc2lseSBn
dWVzc2FibGUgaW5wdXQuDQo+IA0KTm8gbmVlZCB0byB0ZWxsIG1lLCBkb2luZyBjcnlwdG8gaGFz
IGJlZW4gbXkgZGF5am9iIGZvciBuZWFybHkgMTguNSB5ZWFycw0Kbm93IDotKQ0KDQo+IEluIHlv
dXIgY2FzZSwgd2UgYXJlIG5vdCBkZWFsaW5nIHdpdGgga25vd24gcGxhaW50ZXh0IGF0dGFja3Ms
DQo+DQpTaW5jZSB0aGlzIGlzIFhUUywgd2hpY2ggaXMgdXNlZCBmb3IgZGlzayBlbmNyeXB0aW9u
LCBJIHdvdWxkIGFyZ3VlDQp3ZSBkbyEgRm9yIHRoZSB0d2VhayBlbmNyeXB0aW9uLCB0aGUgc2Vj
dG9yIG51bWJlciBpcyBrbm93biBwbGFpbnRleHQsDQpzYW1lIGFzIGZvciBFQk9JVi4gQWxzbywg
eW91IG1heSBiZSBhYmxlIHRvIGNvbnRyb2wgZGF0YSBiZWluZyB3cml0dGVuIA0KdG8gdGhlIGRp
c2sgZW5jcnlwdGVkLCBlaXRoZXIgZGlyZWN0bHkgb3IgaW5kaXJlY3RseS4NCk9LLCBwYXJ0IG9m
IHRoZSBkYXRhIGludG8gdGhlIENUUyBlbmNyeXB0aW9uIHdpbGwgYmUgcHJldmlvdXMgY2lwaGVy
dGV4dCwNCmJ1dCB0aGF0IG1heSBiZSBqdXN0IDEgYnl0ZSB3aXRoIHRoZSByZXN0IGJlaW5nIHRo
ZSBrbm93biBwbGFpbnRleHQuDQoNCj4gYW5kIHRoZQ0KPiBoaWdoZXIgbGF0ZW5jeSBvZiBoL3cg
YWNjZWxlcmF0ZWQgY3J5cHRvIG1ha2VzIG1lIGxlc3Mgd29ycmllZCB0aGF0DQo+IHRoZSBmaW5h
bCwgdXNlciBvYnNlcnZhYmxlIGxhdGVuY3kgd291bGQgc3Ryb25nbHkgY29ycmVsYXRlIHRoZSB3
YXkNCj4gYWVzLWdlbmVyaWMgaW4gaXNvbGF0aW9uIGRvZXMuDQo+DQpJZiB0aGF0IGxhdGVuY3kg
aXMgY29uc3RhbnQgLSB3aGljaCBpdCB1c3VhbGx5IGlzIC0gdGhlbiBpdCBkb2Vzbid0IA0KcmVh
bGx5IG1hdHRlciBmb3IgY29ycmVsYXRpb24sIGl0IGp1c3QgZmlsdGVycyBvdXQuDQoNCj4gPiBI
b3dldmVyLCBpbiBtYW55IGNhc2VzIHRoZXJlIHdvdWxkIGFjdHVhbGx5IGJlIGEgdmVyeSBnb29k
IHJlYXNvbg0KPiA+IE5PVCB0byB3YW50IHRvIHVzZSB0aGUgbWFpbiBza2NpcGhlciBmb3IgdGhp
cy4gQXMgdGhhdCBpcyBzb21lDQo+ID4gaGFyZHdhcmUgYWNjZWxlcmF0b3Igd2l0aCB0ZXJyaWJs
ZSBsYXRlbmN5IHRoYXQgeW91IHdvdWxkbid0IHdhbnQNCj4gPiB0byB1c2UgdG8gcHJvY2VzcyBq
dXN0IG9uZSBjaXBoZXIgYmxvY2suIEZvciB0aGF0LCB5b3Ugd2FudCB0byBoYXZlDQo+ID4gc29t
ZSBTVyBpbXBsZW1lbnRhdGlvbiB0aGF0IGlzIGVmZmljaWVudCBvbiBhIHNpbmdsZSBibG9jayBp
bnN0ZWFkLg0KPiA+DQo+IA0KPiBJbmRlZWQuIE5vdGUgdGhhdCBmb3IgRUJPSVYsIHN1Y2ggcGVy
Zm9ybWFuY2UgY29uY2VybnMgYXJlIGRlZW1lZA0KPiBpcnJlbGV2YW50LCBidXQgaXQgaXMgYW4g
aXNzdWUgaW4gdGhlIGdlbmVyYWwgY2FzZS4NCj4gDQpZZXMsIG15IGludGVyZXN0IHdhcyBwdXJl
bHkgaW4gdGhlIGdlbmVyaWMgY2FzZS4NCg0KPiA+IEluIG15IGh1bWJsZSBvcGluaW9uLCBzdWNo
IGluc2VjdXJlIHRhYmxlIGJhc2VkIGltcGxlbWVudGF0aW9ucyBqdXN0DQo+ID4gc2hvdWxkbid0
IGV4aXN0IGF0IGFsbCAtIHlvdSBjYW4gYWx3YXlzIGRvIGJldHRlciwgcG9zc2libHkgYXQgdGhl
DQo+ID4gZXhwZW5zZSBvZiBzb21lIHBlcmZvcm1hbmNlIGRlZ3JhZGF0aW9uLiBPciB5b3Ugc2hv
dWxkIGF0IGxlYXN0IGhhdmUNCj4gPiBzb21lIGZsYWcgIGF2YWlsYWJsZSB0byBzcGVjaWZ5IHlv
dSBoYXZlIHNvbWUgc2VjdXJpdHkgcmVxdWlyZW1lbnRzDQo+ID4gYW5kIHN1Y2ggYW4gaW1wbGVt
ZW50YXRpb24gaXMgbm90IGFuIGFjY2VwdGFibGUgcmVzcG9uc2UuDQo+ID4NCj4gDQo+IFdlIGRp
ZCBzb21lIHdvcmsgdG8gcmVkdWNlIHRoZSB0aW1lIHZhcmlhbmNlIG9mIEFFUzogdGhlcmUgaXMg
dGhlDQo+IGFlcy10aSBkcml2ZXIsIGFuZCB0aGVyZSBpcyBub3cgYWxzbyB0aGUgQUVTIGxpYnJh
cnksIHdoaWNoIGlzIGtub3duDQo+IHRvIGJlIHNsb3dlciB0aGFuIGFlcy1nZW5lcmljLCBidXQg
ZG9lcyBpbmNsdWRlIHNvbWUgbWl0aWdhdGlvbnMgZm9yDQo+IGNhY2hlIHRpbWluZyBhdHRhY2tz
Lg0KPiANCj4gT3RoZXIgdGhhbiB0aGF0LCBJIGhhdmUgbGl0dGxlIHRvIG9mZmVyLCBnaXZlbiB0
aGF0IHRoZSBwZXJmb3JtYW5jZSB2cw0KPiBzZWN1cml0eSB0cmFkZW9mZnMgd2VyZSBkZWNpZGVk
IGxvbmcgYmVmb3JlIHNlY3VyaXR5IGJlY2FtZSBhIHRoaW5nDQo+IGxpa2UgaXQgaXMgdG9kYXks
IGFuZCBzbyByZW1vdmluZyBhZXMtZ2VuZXJpYyBpcyBub3QgYW4gb3B0aW9uLA0KPiBlc3BlY2lh
bGx5IHNpbmNlIHRoZSBzY2FsYXIgYWx0ZXJuYXRpdmVzIHdlIGhhdmUgYXJlIG5vdCB0cnVseSB0
aW1lDQo+IGludmFyaWFudCBlaXRoZXIuDQo+IA0KUmVwbGFjaW5nIGFlcy1nZW5lcmljIHdpdGgg
YSB0cnVseSB0aW1lLWludmFyaWFudCBpbXBsZW1lbnRhdGlvbiBjb3VsZA0KYmUgYW4gb3B0aW9u
LiBPciBzZWxlY3RpbmcgYWVzLWdlbmVyaWMgb25seSBpZiBzb21lIChuZXcpICJhbGxvd19pbnNl
Y3VyZSINCmZsYWcgaXMgc2V0IG9uIHRoZSBjaXBoZXIgcmVxdWVzdC4gKE9idmlvdXNseSwgeW91
IHdhbnQgdG8gZGVmYXVsdCB0bw0Kc2VjdXJlLCBub3QgaW5zZWN1cmUuIFNwZWFraW5nIGFzIHNv
bWVvbmUgd2hvIGVhcm5zIGhpcyBsaXZpbmcgZG9pbmcNCnNlY3VyaXR5IDotKQ0KDQooRGlzY2xh
aW1lcjogSSBkbyBub3Qga25vdyBhbnl0aGluZyBhYm91dCB0aGUgYWVzLWdlbmVyaWMgaW1wbGVt
ZW50YXRpb24sIA0KSSdtIGp1c3QgdGFraW5nIHlvdXIgd29yZCBmb3IgaXQgdGhhdCBpdCBpcyBu
b3Qgc2VjdXJlIChlbm91Z2gpIC4uLikNCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0K
U2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMgQCBWZXJpbWF0cml4
DQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0KDQo=
