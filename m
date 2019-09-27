Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B9FC4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 10:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAFE7217D7
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 10:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="GWad5J0z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfI0Kp4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Sep 2019 06:45:56 -0400
Received: from mail-eopbgr680081.outbound.protection.outlook.com ([40.107.68.81]:41225
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726676AbfI0Kp4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Sep 2019 06:45:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvHRCvHOig8aJAldUmCKWlSxTxXf9ErgvXYVfaRhgefQC7Il4zqHQJT/uuQCyC9NvFDgVizT8ws/sw1pOhPDrYrCVfV1pLOogR3p3C4jX+yyYHrqjygnErLnwzaY/+klyvhUWGrgVi2eCkkXkIJh1U1w4X8QR5JDtgyJE27f+e6qrfrq+CK4cJC0uqQqWBT93FtFJ40kRq5TariDZImQeQhamjxuWyRuedqh554k2BY/XyAJg7MwfsJPtruZf+zAkYeP0wdPenIxbsDNi7ynI6vKzFaHbC2WkeUeznk81zm0X3aHIdCHgLpBrAQIdJWD3XtGo+XPZydnrsqK01euig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2UTggwzqJB8OvVWogrWiyBJ2MtVNGwY03Eyl4Vvyv0=;
 b=UoSoEnOPTHM64QToJajq/YgE9HrEg7+/xD+VR2DnNSVyBpECz9U+oyQljcyLugRflPDF7dJR795zxc1xN7B+jOWMMOtJJSGNiv6L+oK062EgeOkIMMckXUPsAsH3+7yfYtFJTLlJMeg2y3YfJjtZLqSsrXnH4NZWxeCKDTEl+Y6s6IM3ex92q0gdZRT4YZYo4/mSR46H//sYVvs8HElNUdEZZj9mEaYbxconxVEMpOYa+BdD7TVAv8Q7/9rb4SCeD5Yokr7c1x7XQxopNznnGqm80pF4xkjALFoBEEhbvFpOALVeLtRjiu4FJf/GH4QxP92zJFqvs7Hvlg6YcUIB4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2UTggwzqJB8OvVWogrWiyBJ2MtVNGwY03Eyl4Vvyv0=;
 b=GWad5J0zYeyDY/TrDfkei3qfHJDUTQV9xKkG8TILX625Afpyy5E6P3HzuNwcQnK4nYlRApLtR0ymtf59Q7cH23j+jyGV08TRQQp32Ifa/In+DCz7vwGq5BvKDJQ/42nkv1/kPU7AeCpBEwIwfcTlc7sSK6Pa/6CYzVHQXSNp3ds=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3085.namprd20.prod.outlook.com (52.132.174.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.18; Fri, 27 Sep 2019 10:44:13 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2305.017; Fri, 27 Sep 2019
 10:44:13 +0000
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
Thread-Index: AQHVc7xLFDyOijy/PkCX/N7Gn7qoy6c89gcAgACj7jCAAI9SgIAAOyfwgABabYCAABdQgIAAe1XQ
Date:   Fri, 27 Sep 2019 10:44:13 +0000
Message-ID: <MN2PR20MB297359DCCE92EB1A1F13CE03CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org>
 <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
 <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
 <CAHk-=whqWh8ebZ7ryEv5tKKtO5VpOj2rWVy7wV+aHWGO7m9gAw@mail.gmail.com>
In-Reply-To: <CAHk-=whqWh8ebZ7ryEv5tKKtO5VpOj2rWVy7wV+aHWGO7m9gAw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45faf786-20bc-40c9-a3d4-08d74337a331
x-ms-traffictypediagnostic: MN2PR20MB3085:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3085F41CB1B05D7CD0DC50C1CA810@MN2PR20MB3085.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39850400004)(396003)(376002)(346002)(13464003)(199004)(189003)(71190400001)(71200400001)(6436002)(7416002)(229853002)(76116006)(74316002)(33656002)(305945005)(55016002)(4326008)(66446008)(66556008)(66476007)(26005)(7696005)(64756008)(66946007)(54906003)(9686003)(316002)(11346002)(15974865002)(476003)(99286004)(102836004)(6506007)(6246003)(7736002)(486006)(53546011)(2906002)(76176011)(186003)(3846002)(6116002)(446003)(5660300002)(52536014)(256004)(25786009)(14454004)(8936002)(81156014)(86362001)(8676002)(6916009)(478600001)(81166006)(66066001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3085;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7X+UHD9Zk7Ef/HcK+4KuYezc/Cin7IE9qJHOXxxTOAXFuOQ5Ib4npe/F7rrlCI5UFTWDiqxA+p8snnguYNiGUB1PCpwjDz1LqpppSpACbp7faveuw3xN18l3TrUnVIk7hKgK0le6Bb2mmXD0XHeiV8F6iKKW+y1O4IkAOpMuJ27CIvcGevOLEdS4BxHfOVVn3i2s5HlAnlbjOAdmZqaBXdVd8yltnQADonS+/q7kHIv80qZErXgNkXjAwoUL6FS9ydsRf8xRJmurjuC5ieyn+3Oe+BGB4OewQqEl1ItcGUJqD86ixA7Zqwuc9crymr+A4PabUW35NtsRTtxMb7dCGS6HBM1uA+IntA5/dqERPnr3b39ivSk4xvEl5iFkl/gB04rKV62xg3gCLC4O3jbbktSf+Lb3STcZyziYFlcP9cs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45faf786-20bc-40c9-a3d4-08d74337a331
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 10:44:13.3138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uNwBfOTn2uDvCMn0Pu/vQE63rjZOI5MuGrHFiucgxgmFGZIboHN1XA81cZWoAC6dXtR/o9Y4O2/NEklMb7cUPw+ULyT2fwY+3R4JPJ1pkfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3085
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9y
dmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+DQo+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDI3
LCAyMDE5IDQ6NTQgQU0NCj4gVG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVy
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
IFNlcCAyNiwgMjAxOSBhdCA2OjMwIFBNIExpbnVzIFRvcnZhbGRzDQo+IDx0b3J2YWxkc0BsaW51
eC1mb3VuZGF0aW9uLm9yZz4gd3JvdGU6DQo+ID4NCj4gPiBBbmQgb25jZSB5b3UgaGF2ZSB0aGF0
IGNvb2tpZSwgYW5kIHlvdSBzZWUgIm9rLCBJIGRpZG4ndCBnZXQgdGhlDQo+ID4gYW5zd2VyIGlt
bWVkaWF0ZWx5IiBvbmx5IFRIRU4gZG8geW91IHN0YXJ0IGZpbGxpbmcgaW4gdGhpbmdzIGxpa2UN
Cj4gPiBjYWxsYmFjayBzdHVmZiwgb3IgbWF5YmUgeW91IHNldCB1cCBhIHdhaXQtcXVldWUgYW5k
IHN0YXJ0IHdhaXRpbmcgZm9yDQo+ID4gaXQsIG9yIHdoYXRldmVyIi4NCj4gDQo+IFNpZGUgbm90
ZTogYWxtb3N0IG5vYm9keSBkb2VzIHRoaXMuDQo+IA0KPiBBbG1vc3QgZXZlcnkgc2luZ2xlIGFz
eW5jIGludGVyZmFjZSBJJ3ZlIGV2ZXIgc2VlbiBlbmRzIHVwIGJlaW5nICJvbmx5DQo+IGRlc2ln
bmVkIGZvciBhc3luYyIuDQo+IA0KPiBBbmQgSSB0aGluayB0aGUgcmVhc29uIGlzIHRoYXQgZXZl
cnlib2R5IGZpcnN0IGRvZXMgdGhlIHNpbXBseQ0KPiBzeW5jaHJvbm91cyBpbnRlcmZhY2VzLCBh
bmQgcGVvcGxlIHN0YXJ0IHVzaW5nIHRob3NlLCBhbmQgYSBsb3Qgb2YNCj4gcGVvcGxlIGFyZSBw
ZXJmZWN0bHkgaGFwcHkgd2l0aCB0aGVtLiBUaGV5IGFyZSBzaW1wbGUsIGFuZCB0aGV5IHdvcmsN
Cj4gZmluZSBmb3IgdGhlIGh1Z2UgbWFqb3JpdHkgb2YgdXNlcnMuDQo+IA0KPiBBbmQgdGhlbiBz
b21lYm9keSBjb21lcyBhbG9uZyBhbmQgc2F5cyAibm8sIF93ZV8gbmVlZCB0byBkbyB0aGlzDQo+
IGFzeW5jaHJvbm91c2x5IiwgYW5kIGJ5IGRlZmluaXRpb24gdGhhdCBwZXJzb24gZG9lcyAqbm90
KiBjYXJlIGZvciB0aGUNCj4gc3luY2hyb25vdXMgY2FzZSwgc2luY2UgdGhhdCBpbnRlcmZhY2Ug
YWxyZWFkeSBleGlzdGVkIGFuZCB3YXMgc2ltcGxlcg0KPiBhbmQgYWxyZWFkeSB3YXMgbW9zdGx5
IHN1ZmZpY2llbnQgZm9yIHRoZSBwZW9wbGUgd2hvIHVzZWQgaXQsIGFuZCBzbw0KPiB0aGUgYXN5
bmMgaW50ZXJmYWNlIGVuZHMgdXAgYmVpbmcgX29ubHlfIGRlc2lnbmVkIGZvciB0aGUgbmV3IGFz
eW5jDQo+IHdvcmtmbG93LiBCZWNhdXNlIHRoYXQgd2hvbGUgbmV3IHdvcmxkIHdhcyB3cml0dGVu
IHdpdGgganVzdCB0aGF0IGNhc2UNCj4gaXMgbWluZCwgYW5kIHRoZSBzeW5jaHJvbm91cyBjYXNl
IGNsZWFybHkgZGlkbid0IG1hdHRlci4NCj4gDQo+IFNvIHRoZW4geW91IGVuZCB1cCB3aXRoIHRo
YXQga2luZCBvZiBkaWNob3RvbW91cyBzaXR1YXRpb24sIHdoZXJlIHlvdQ0KPiBoYXZlIGEgc3Ry
aWN0IGJsYWNrLWFuZC13aGl0ZSBlaXRoZXItc3luY2hyb25vdXMtb3ItYXN5bmMgbW9kZWwuDQo+
IA0KPiBBbmQgdGhlbiBzb21lIHBlb3BsZSAtIHF1aXRlIHJlYXNvbmFibHkgLSBqdXN0IHdhbnQg
dGhlIHNpbXBsaWNpdHkgb2YNCj4gdGhlIHN5bmNocm9ub3VzIGNvZGUgYW5kIGl0IHBlcmZvcm1z
IGJldHRlciBmb3IgdGhlbSBiZWNhdXNlIHRoZQ0KPiBpbnRlcmZhY2VzIGFyZSBzaW1wbGVyIGFu
ZCBiZXR0ZXIgc3VpdGVkIHRvIHRoZWlyIGxhY2sgb2YgZXh0cmEgd29yay4NCj4gDQo+IEFuZCBv
dGhlciBwZW9wbGUgZmVlbCB0aGV5IG5lZWQgdGhlIGFzeW5jIGNvZGUsIGJlY2F1c2UgdGhleSBj
YW4gdGFrZQ0KPiBhZHZhbnRhZ2Ugb2YgaXQuDQo+IA0KPiBBbmQgbmV2ZXIgdGhlIHR3YWluIHNo
YWxsIG1lZXQsIGJlY2F1c2UgdGhlIGFzeW5jIGludGVyZmFjZSBpcw0KPiBhY3RpdmVseSBfYmFk
XyBmb3IgdGhlIHBlb3BsZSB3aG8gaGF2ZSBzeW5jIHdvcmtsb2FkcyBhbmQgdGhlIHN5bmMNCj4g
aW50ZXJmYWNlIGRvZXNuJ3Qgd29yayBmb3IgdGhlIGFzeW5jIHBlb3BsZS4NCj4gDQo+IE5vbi1j
cnlwdG8gZXhhbXBsZTogW3BdcmVhZCgpIHZzIGFpb19yZWFkKCkuIFRoZXkgZG8gdGhlIHNhbWUg
dGhpbmcNCj4gKG9uIGEgaGlnaCBsZXZlbCkgYXBhcnQgZnJvbSB0aGF0IHN5bmMvYXN5bmMgaXNz
dWUuIEFuZCB0aGVyZSdzIG5vIHdheQ0KPiB0byBnZXQgdGhlIGJlc3Qgb2YgYm90aCB3b3JsZHMu
DQo+IA0KPiBEb2luZyBhaW9fcmVhZCgpIG9uIHNvbWV0aGluZyB0aGF0IGlzIGFscmVhZHkgY2Fj
aGVkIGlzIGFjdGl2ZWx5IG11Y2gNCj4gd29yc2UgdGhhbiBqdXN0IGRvaW5nIGEgc3luY2hyb25v
dXMgcmVhZCgpIG9mIGNhY2hlZCBkYXRhLg0KPiANCj4gQnV0IGFpb19yZWFkKCkgX2Nhbl8gYmUg
bXVjaCBiZXR0ZXIgaWYgeW91IGtub3cgeW91ciB3b3JrbG9hZCBkb2Vzbid0DQo+IGNhY2hlIHdl
bGwgYW5kIHJlYWQoKSBibG9ja3MgdG9vIG11Y2ggZm9yIHlvdS4NCj4gDQo+IFRoZXJlJ3Mgbm8g
InJlYWRfcG90ZW50aWFsbHlfYXN5bmMoKSIgaW50ZXJmYWNlIHRoYXQganVzdCBkb2VzIHRoZQ0K
PiBzeW5jaHJvbm91cyByZWFkIGZvciBhbnkgY2FjaGVkIHBvcnRpb24gb2YgdGhlIGRhdGEsIGFu
ZCB0aGVuIGRlbGF5cw0KPiBqdXN0IHRoZSBJTyBwYXJ0cyBhbmQgcmV0dXJucyBhICJoZXJlLCBJ
IGdhdmUgeW91IFggYnl0ZXMgcmlnaHQgbm93LA0KPiB1c2UgdGhpcyBjb29raWUgdG8gd2FpdCBm
b3IgdGhlIHJlc3QiLg0KPiANCj4gTWF5YmUgbm9ib2R5IHdvdWxkIHVzZSBpdC4gQnV0IGl0IHJl
YWxseSBzaG91bGQgYmUgcG9zc2libHkgdG8gaGF2ZQ0KPiBpbnRlcmZhY2VzIHdoZXJlIGEgZ29v
ZCBzeW5jaHJvbm91cyBpbXBsZW1lbnRhdGlvbiBpcyBfcG9zc2libGVfDQo+IHdpdGhvdXQgdGhl
IGV4dHJhIG92ZXJoZWFkLCB3aGlsZSBhbHNvIGFsbG93aW5nIGFzeW5jIGltcGxlbWVudGF0aW9u
cy4NCj4gDQpUaGF0J3MgdGhlIHF1ZXN0aW9uLiBJJ3ZlIG5ldmVyIHNlZW4gc3VjaCBhbiBBUEkg
eWV0IC4uLg0KDQpZb3UgY291bGQgYWxzbyBqdXN0IGFjY2VwdCB0aGF0IHRob3NlIGFyZSB0d28g
d2lsZGx5IGRpZmZlcmVudCB1c2UgDQpjYXNlcyB3aXRoIHdpbGRseSBkaWZmZXJlbnQgcmVxdWly
ZW1lbnRzIGFuZCBhbGxvdyB0aGVtIHRvIGNvZXhpc3QsDQp3aGlsZSAgc2hhcmluZyBhcyBtdWNo
IG9mIHRoZSBsb3ctbGV2ZWwgU1cgaW1wbGVtZW50YXRpb24gY29kZSBhcw0KcG9zc2libGUgdW5k
ZXJuZWF0aC4gV2l0aCB0aGUgYXN5bmMgQVBJIG9ubHkgdXNlZCBmb3IgdGhvc2UgY2FzZXMNCndo
ZXJlIEhXIGFjY2VsZXJhdGlvbiBjYW4gbWFrZSB0aGUgZGlmZmVyZW5jZS4NCg0KSSBiZWxpZXZl
IGZvciBoYXNoZXMsIHRoZSBDcnlwdG8gQVBJIHN0aWxsIG1haW50YWlucyBhbiBzaGFzaCBhbmQN
CmFuIGFoYXNoIEFQSS4gSXQgd29ya3MgdGhlIG90aGVyIHdheSBhcm91bmQgZnJvbSBob3cgeW91
IHdvdWxkDQpsaWtlICB0byBzZWUgdGhvdWdoLCB3aXRoIGFoYXNoIHdyYXBwaW5nIHRoZSBzaGFz
aCBpbiBjYXNlIG9mIFNXIA0KaW1wbGVtZW50YXRpb25zLiBTdGlsbCwgaWYgeW91J3JlIHN1cmUg
eW91IGNhbid0IGJlbmVmaXQgZnJvbSBIVyANCmFjY2VsZXJhdGlvbiB5b3UgaGF2ZSB0aGUgb3B0
aW9uIG9mIHVzaW5nIHRoZSBzaGFzaCBkaXJlY3RseS4NCg0KSSBkb24ndCBrbm93IHdoeSB0aGUg
c3luY2hyb25vdXMgYmxrY2lwaGVyIEFQSSB3YXMgZGVwcmVjYXRlZCwNCnRoYXQgaGFwcGVuZWQg
YmVmb3JlIEkgam9pbmVkLiBJTUhPIGl0IHdvdWxkIG1ha2Ugc2Vuc2UgdG8gaGF2ZSwNCnNvIHVz
ZXJzIG5vdCBpbnRlcmVzdGVkIGluIEhXIGNyeXB0byBhcmUgbm90IGJ1cmRlbmVkIGJ5IGl0Lg0K
DQoNCj4gICAgICAgICAgICAgICAgIExpbnVzDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3
ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAgVmVyaW1h
dHJpeA0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg0K
