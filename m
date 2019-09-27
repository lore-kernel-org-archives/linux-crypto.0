Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0458C4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 10:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78856217F4
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 10:12:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="sUFngvep"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfI0KMB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Sep 2019 06:12:01 -0400
Received: from mail-eopbgr740080.outbound.protection.outlook.com ([40.107.74.80]:48032
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725946AbfI0KMA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Sep 2019 06:12:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiE7SV5vKt1D/b1mn063gDT/lCBdU+PyHhpbkwVzlNDNbOAqnyp6xtOk3KkeHHXbsHHJh9bBTKpsSPNlaAI4R39J3BO3M5n4kfbHpHbT24Z8eD3l877Fo58+LZ093h4NKkdA9Yv8e2kBUU815mLb6ij8+VI7paRdh7P5Z1pJKFZIB6znOf+AkorxCPFkuU8OrdlbpUmeEeML2WyAH0g7DZd/eeo/59mWoQlgxuKCe9HXefCr55SJwfVLkLs6vWQHKTEN50YbPCwjF1E0nwUg/EaeEYehSSBAeqLgKT6V+BMaPwu2343I0bTroPRxSdeXKFtDoPdeG93Od6sRitNGcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhJe61zs1Qta3jx5Lwrt1diUJCzAA8UvaWpDnwvzCvs=;
 b=j6tLR54p7waJ5asTLK1lHlfYyRBMEGtfLQHWaMZhf5uE67Q5lHbw0M+j5sXuSOgKAmS0yIxw3S3/++YEeTYRmUnyLjVpeQcDBuhCMbfoe+dGSbxZ6VVy5LRALMWBd4rlSGadd7fk5RKNkFr4+ydHlqM8p9d6Qpsn6SBwUPfYaO8660XeHTzJ6kw4h0KajQELtNE/jd4aU0lXbRdMebXPwCWvBYn7lGO5kSDcbrW/hJs3jGgyZ5wFR1S/Sg+gVoAOmcppYbgDYj1BprpkbKa4O435jQoySCOCdPx7a/eCKuTimEGI1fzbe5ZQnrRHG3xJQfEIKmXpMm11HyD9xjyZ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhJe61zs1Qta3jx5Lwrt1diUJCzAA8UvaWpDnwvzCvs=;
 b=sUFngvepZKS1pqy3jLWKQ10qwiQPQwyo9JIxoKJ3nSn5x/3wp52sWpZQ41rPJSlCScaaQ8+HDWUOcESBtvJv27sC7n3h2dGO/M9qw8ItfQ8JwOHT4fKZG6huxMkHSeOWWKnMwftEgQwPVYZKFmJAKYnIIRYQtDeC2Wtyp2+44uI=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2653.namprd20.prod.outlook.com (20.178.250.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Fri, 27 Sep 2019 10:11:55 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2305.017; Fri, 27 Sep 2019
 10:11:55 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: RE: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
Thread-Topic: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
Thread-Index: AQHVc7xLFDyOijy/PkCX/N7Gn7qoy6c89gcAgACj7jCAAI9SgIAAOyfwgABkWQCAAIUxcA==
Date:   Fri, 27 Sep 2019 10:11:55 +0000
Message-ID: <MN2PR20MB2973403A964F0D00440EFB15CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org>
 <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
 <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wgu5-Wj=UY+iU+x=RcKN_ceUsKdfhsv2-E5TNocELU8Ag@mail.gmail.com>
In-Reply-To: <CAHk-=wgu5-Wj=UY+iU+x=RcKN_ceUsKdfhsv2-E5TNocELU8Ag@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab138294-3a5a-443c-600f-08d743331ff4
x-ms-traffictypediagnostic: MN2PR20MB2653:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB265336FDD3960E23FB2236C1CA810@MN2PR20MB2653.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(39850400004)(366004)(346002)(199004)(189003)(52314003)(13464003)(486006)(14454004)(15974865002)(2906002)(99286004)(7416002)(6436002)(66066001)(186003)(476003)(6506007)(446003)(55016002)(54906003)(316002)(33656002)(5660300002)(9686003)(11346002)(478600001)(305945005)(6246003)(7736002)(8936002)(102836004)(3846002)(6116002)(71200400001)(53546011)(71190400001)(26005)(81166006)(25786009)(8676002)(76116006)(52536014)(81156014)(6916009)(66556008)(64756008)(4326008)(66476007)(66946007)(74316002)(7696005)(66446008)(229853002)(76176011)(86362001)(256004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2653;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3e+xTZf9B45ivOlhWTWQPWJGBQ283rNs4+zcSAO4b1507MNbSvEpsjdzWta56WHCge/0lMdH6aUgTaY9bnWxwcbqRtqRBfTYQTGYYohHNHMhiL0r6nTObMKAeAcFz6EKi77Q3cMR9v2VzuFRS1OkNJJ5sqB6O5HZIVjmfbIFfGUvO28v6QlU/ir02N98C2udCaOEvFx5hpGSlEzFDLCgyAbJ/GZ9UTFJthA56NqleI+02HpWEAVZDVPScsnnVopidSPKHO1bgTUWRRrVUiZP9aifqlvis2H0QHZk+Tb8OYZVEjbBLPN6FZYXxivxNtSnudWLle/oyl2Rh49kAKxjkeWf82m4I8yJ+LwfkwTOwgCSHgbInvIu7HjzD5AvkZPalAsmdnii9a/8ArQUsuz3M3blHDgWmD9LanKqWhi9Upc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab138294-3a5a-443c-600f-08d743331ff4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 10:11:55.2777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qoegnrtu6S6tYVrSJyEIYItCn3uFgJ0xd/lLZJuyTesfJp+lu9ugh19mJ7V5tSqqpAKkf+SI+uqIO67N1WG3wL1ul3I7qVQL3n6qBAi/DEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2653
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9y
dmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+DQo+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDI3
LCAyMDE5IDQ6MDYgQU0NCj4gVG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVy
aW1hdHJpeC5jb20+DQo+IENjOiBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJv
Lm9yZz47IExpbnV4IENyeXB0byBNYWlsaW5nIExpc3QgPGxpbnV4LQ0KPiBjcnlwdG9Admdlci5r
ZXJuZWwub3JnPjsgTGludXggQVJNIDxsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5v
cmc+OyBIZXJiZXJ0IFh1DQo+IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBEYXZpZCBN
aWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBHcmVnIEtIDQo+IDxncmVna2hAbGludXhmb3Vu
ZGF0aW9uLm9yZz47IEphc29uIEEgLiBEb25lbmZlbGQgPEphc29uQHp4MmM0LmNvbT47IFNhbXVl
bCBOZXZlcw0KPiA8c25ldmVzQGRlaS51Yy5wdD47IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50
ZXJAb3JhY2xlLmNvbT47IEFybmQgQmVyZ21hbm4NCj4gPGFybmRAYXJuZGIuZGU+OyBFcmljIEJp
Z2dlcnMgPGViaWdnZXJzQGdvb2dsZS5jb20+OyBBbmR5IEx1dG9taXJza2kgPGx1dG9Aa2VybmVs
Lm9yZz47DQo+IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+OyBNYXJjIFp5bmdpZXIgPG1h
ekBrZXJuZWwub3JnPjsgQ2F0YWxpbiBNYXJpbmFzDQo+IDxjYXRhbGluLm1hcmluYXNAYXJtLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggMTgvMThdIG5ldDogd2lyZWd1YXJkIC0gc3dp
dGNoIHRvIGNyeXB0byBBUEkgZm9yIHBhY2tldA0KPiBlbmNyeXB0aW9uDQo+IA0KPiBPbiBUaHUs
IFNlcCAyNiwgMjAxOSBhdCA1OjE1IFBNIFBhc2NhbCBWYW4gTGVldXdlbg0KPiA8cHZhbmxlZXV3
ZW5AdmVyaW1hdHJpeC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gQnV0IGV2ZW4gdGhlIENQVSBvbmx5
IHRoaW5nIG1heSBoYXZlIHNldmVyYWwgaW1wbGVtZW50YXRpb25zLCBvZiB3aGljaA0KPiA+IHlv
dSB3YW50IHRvIHNlbGVjdCB0aGUgZmFzdGVzdCBvbmUgc3VwcG9ydGVkIGJ5IHRoZSBfZGV0ZWN0
ZWRfIENQVQ0KPiA+IGZlYXR1cmVzIChpLmUuIFNTRSwgQUVTLU5JLCBBVlgsIEFWWDUxMiwgTkVP
TiwgZXRjLiBldGMuKQ0KPiA+IERvIHlvdSB0aGluayB0aGlzIHdvdWxkIHN0aWxsIGJlIGVmZmlj
aWVudCBpZiB0aGF0IHdvdWxkIGJlIHNvbWUNCj4gPiBsYXJnZSBpZi1lbHNlIHRyZWU/IEFsc28s
IHN1Y2ggYSBmaXhlZCBpbXBsZW1lbnRhdGlvbiB3b3VsZG4ndCBzY2FsZS4NCj4gDQo+IEp1c3Qg
YSBub3RlIG9uIHRoaXMgcGFydC4NCj4gDQo+IFllcywgd2l0aCByZXRwb2xpbmUgYSBsYXJnZSBp
Zi1lbHNlIHRyZWUgaXMgYWN0dWFsbHkgKndheSogYmV0dGVyIGZvcg0KPiBwZXJmb3JtYW5jZSB0
aGVzZSBkYXlzIHRoYW4gZXZlbiBqdXN0IG9uZSBzaW5nbGUgaW5kaXJlY3QgY2FsbC4gSQ0KPiB0
aGluayB0aGUgY3Jvc3Mtb3ZlciBwb2ludCBpcyBzb21ld2hlcmUgYXJvdW5kIDIwIGlmLXN0YXRl
bWVudHMuDQo+IA0KWWlrZXMsIHRoYXQgaXMganVzdCBfaG9ycmlibGVfIDotKA0KDQpfSG93ZXZl
cl8gdGhlcmUncyBtYW55IENQVSBhcmNoaXRlY3R1cmVzIG91dCB0aGVyZSB0aGF0IF9kb24ndF8g
bmVlZA0KdGhlIHJldHBvbGluZSBtaXRpZ2F0aW9uIGFuZCB3b3VsZCBiZSB1bmZhaXJseSBwZW5h
bGl6ZWQgYnkgdGhlIGRlZXANCmlmLWVsc2UgdHJlZSAoYXMgb3Bwb3NlZCB0byB0aGUgaW5kaXJl
Y3QgYnJhbmNoKSBmb3IgYSBwcm9ibGVtIHRoZXkNCmRpZCBub3QgY2F1c2UgaW4gdGhlIGZpcnN0
IHBsYWNlLg0KDQpXb3VsZG4ndCBpdCBiZSBtb3JlIGZhaXIgdG8gaW1wb3NlIHRoZSBwZW5hbHR5
IG9uIHRoZSBDUFUncyBhY3R1YWxseQ0KX2NhdXNpbmdfIHRoaXMgcHJvYmxlbT8gQWxzbyBiZWNh
dXNlIHRob3NlIGFyZSBnZW5lcmFsbHkgdGhlIG1vcmUgDQpwb3dlcmZ1bCBDUFUncyBhbnl3YXks
IHRoYXQgd291bGQgc3VmZmVyIHRoZSBsZWFzdCBmcm9tIHRoZSBvdmVyaGVhZD8NCg0KPiBCdXQg
dGhvc2Uga2luZHMgb2YgdGhpbmdzIGFsc28gYXJlIHRoaW5ncyB0aGF0IHdlIGFscmVhZHkgaGFu
ZGxlIHdlbGwNCj4gd2l0aCBpbnN0cnVjdGlvbiByZXdyaXRpbmcsIHNvIHRoZXkgY2FuIGFjdHVh
bGx5IGhhdmUgZXZlbiBsZXNzIG9mIGFuDQo+IG92ZXJoZWFkIHRoYW4gYSBjb25kaXRpb25hbCBi
cmFuY2guIFVzaW5nIGNvZGUgbGlrZQ0KPiANCj4gICBpZiAoc3RhdGljX2NwdV9oYXMoWDg2X0ZF
QVRVUkVfQVZYMikpDQo+IA0KPiBhY3R1YWxseSBlbmRzIHVwIHBhdGNoaW5nIHRoZSBjb2RlIGF0
IHJ1bi10aW1lLCBzbyB5b3UgZW5kIHVwIGhhdmluZw0KPiBqdXN0IGFuIHVuY29uZGl0aW9uYWwg
YnJhbmNoLiBFeGFjdGx5IGJlY2F1c2UgQ1BVIGZlYXR1cmUgY2hvaWNlcw0KPiBvZnRlbiBlbmQg
dXAgYmVpbmcgaW4gY3JpdGljYWwgY29kZS1wYXRocyB3aGVyZSB5b3UgaGF2ZQ0KPiBvbmUtb3It
dGhlLW90aGVyIGtpbmQgb2Ygc2V0dXAuDQo+IA0KPiBBbmQgeWVzLCBvbmUgb2YgdGhlIGJpZyB1
c2VycyBvZiB0aGlzIGlzIHZlcnkgbXVjaCB0aGUgY3J5cHRvIGxpYnJhcnkgY29kZS4NCj4gDQpP
aywgSSBkaWRuJ3Qga25vdyBhYm91dCB0aGF0LiBTbyBJIHN1cHBvc2Ugd2UgY291bGQgaGF2ZSBz
b21ldGhpbmcNCmxpa2UgaWYgKHN0YXRpY19zb2NfaGFzKEhXX0NSWVBUT19BQ0NFTEVSQVRPUl9Y
WVopKSAuLi4gSG1tbSAuLi4NCg0KPiBUaGUgY29kZSB0byBkbyB0aGUgYWJvdmUgaXMgZGlzZ3Vz
dGluZywgYW5kIHdoZW4geW91IGxvb2sgYXQgdGhlDQo+IGdlbmVyYXRlZCBjb2RlIHlvdSBzZWUg
b2RkIHVucmVhY2hhYmxlIGp1bXBzIGFuZCB3aGF0IGxvb2tzIGxpa2UgYQ0KPiBzbG93ICJidHMi
IGluc3RydWN0aW9uIHRoYXQgZG9lcyB0aGUgdGVzdGluZyBkeW5hbWljYWxseS4NCj4gDQo+IEFu
ZCB0aGVuIHRoZSBrZXJuZWwgaW5zdHJ1Y3Rpb24gc3RyZWFtIGdldHMgcmV3cml0dGVuIGZhaXJs
eSBlYXJseQ0KPiBkdXJpbmcgdGhlIGJvb3QgZGVwZW5kaW5nIG9uIHRoZSBhY3R1YWwgQ1BVIGNh
cGFiaWxpdGllcywgYW5kIHRoZQ0KPiBkeW5hbWljIHRlc3RzIGdldCBvdmVyd3JpdHRlbiBieSBh
IGRpcmVjdCBqdW1wLg0KPiANCj4gQWRtaXR0ZWRseSBJIGRvbid0IHRoaW5rIHRoZSBhcm02NCBw
ZW9wbGUgZ28gdG8gcXVpdGUgdGhvc2UgbGVuZ3RocywNCj4gYnV0IGl0IGNlcnRhaW5seSB3b3Vs
ZG4ndCBiZSBpbXBvc3NpYmxlIHRoZXJlIGVpdGhlci4gIEl0IGp1c3QgdGFrZXMgYQ0KPiBiaXQg
b2YgYXJjaGl0ZWN0dXJlIGtub3dsZWRnZSBhbmQgYSBzdHJvbmcgc3RvbWFjaCA7KQ0KPiANCj4g
ICAgICAgICAgICAgICAgICBMaW51cw0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpT
aWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIFZlcmltYXRyaXgN
Cnd3dy5pbnNpZGVzZWN1cmUuY29tDQo=
