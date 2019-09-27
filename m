Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93536C4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 11:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CDEA207FF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 11:08:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="mHkbPQvh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfI0LIU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Sep 2019 07:08:20 -0400
Received: from mail-eopbgr820047.outbound.protection.outlook.com ([40.107.82.47]:45248
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725882AbfI0LIU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Sep 2019 07:08:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZW75Iw10ybSW70HaqXd5Vt/CCnNifL7HVcjPiuJbYMV3p6jak8ipGR2BN/tiK5GlyaNj7ocFumz6bcAqgLo4wQgvw/L03pXmQ7KZ6Y4wBxzc6vjNgm57ippGBe74/Hsim6WFK2N6TedU74XumY+ePKxCegVhpTV2HZ1Lm6FHrte+mdnLoI/hycfnHhTRe7cczbHWD4R3K1wm9a1qV/c44rl0xBCI7cnNtuhP7nJqWZLZNXu16l+tLySSZtVd8nwIt/o7zBIIJ7CIxk5GldF1H57TpsKjboU9tyzbYFde8Cm25U0FSA6ycJm86AZUwy09BX6gyt7cxcCvGs2TTCf1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PWybqYW4D7hGUox6qt/uil9HXGGVN/J0t84D1Hbjnfc=;
 b=aIuTn3+S4GMrKu9r0nDneF/vGkSO+bulcHL93ExESDBNFpl0vIVkSfe9MFS1cqQQTJuPLvsI3noAXPz/pnJqSdaehDRKieG576n8DKcmE0rTcXhM+qeEWt9EFCXwQyY56BRmQHdmWzzkWGBb89sthFDBHS/HfzG+4T7RpQnJVwpLU7dmVrZHZNWhgDwjj0bXkv3gsuvVhtAUjXZq6V5QWBEXIVvJnoLy4QbUxYjUqXuEdkNGl/tFeOU0RxmgeLQTRbWvHw6iAPvbIXbXXUKEPs5zndog9SfldXicZj1QdNatwqtv5tUOlLiwW4TV38WEyO1SiXJ0QaaYJB6qeDu1Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PWybqYW4D7hGUox6qt/uil9HXGGVN/J0t84D1Hbjnfc=;
 b=mHkbPQvhsgAS1ZZqWNZwQWWgXdKuyzeFGlRSbaNH3vU0/4Lp4nti5LQxoe1cKZCHsX/VgcqcizAxTiqhWn6KEkoe0yLzpbnOzN3i5O52QgVmqTXD+eLhL3LIq6TQUJDyR9EOP5O32nq+6oX9/3eEEN/+UEqK6uMXkLr9MgouDgE=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2976.namprd20.prod.outlook.com (52.132.172.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Fri, 27 Sep 2019 11:08:12 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2305.017; Fri, 27 Sep 2019
 11:08:12 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
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
Thread-Index: AQHVc7xLFDyOijy/PkCX/N7Gn7qoy6c89gcAgACj7jCAAI9SgIAAOyfwgABabYCAABdQgIAAe1XQgAANsoA=
Date:   Fri, 27 Sep 2019 11:08:12 +0000
Message-ID: <MN2PR20MB29734A5CD174DDA696E720F8CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org>
 <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
 <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
 <CAHk-=whqWh8ebZ7ryEv5tKKtO5VpOj2rWVy7wV+aHWGO7m9gAw@mail.gmail.com>
 <MN2PR20MB297359DCCE92EB1A1F13CE03CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB297359DCCE92EB1A1F13CE03CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 612d15e5-b999-411c-ace3-08d7433afcf2
x-ms-traffictypediagnostic: MN2PR20MB2976:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR20MB29761914FAD10A6445835E23CA810@MN2PR20MB2976.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39850400004)(346002)(366004)(136003)(13464003)(189003)(199004)(66066001)(64756008)(3846002)(110136005)(6116002)(54906003)(33656002)(8676002)(6436002)(2906002)(9686003)(55016002)(229853002)(6246003)(2940100002)(81156014)(81166006)(4326008)(316002)(26005)(15974865002)(5660300002)(14454004)(256004)(478600001)(6506007)(99286004)(186003)(71200400001)(486006)(86362001)(7416002)(7696005)(71190400001)(305945005)(66946007)(476003)(76116006)(8936002)(11346002)(74316002)(52536014)(25786009)(76176011)(446003)(7736002)(53546011)(66476007)(66556008)(102836004)(66446008)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2976;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: keYHGQf1ky1iZOYK7jgUAppK/A2APktw9FHv8aoQ5F0Ir05IPepBZReorIp9gZaALOQCupNqLEx9rAKEtrtIJWQHzbqkYWIpIDDbEoi/tUal527cPl4jc7Tb/kCsNGyNUKhE7a5MgIxGO6TAMpdL2oO/KYyfAeL5WejR66kp5wclByNpiUa9aAOhqmuKyB2c98wb9MAEXoLIvOh7SPsBKf5XC83yuGmwe1xW4b8voSpvfh42f4j1bxsjs5g+1u/ISlPZHLlgdGt7Yi3d8mKWVRfSjRPqAKmszzX0beJAp/uFjvDYqVNaGHJbbo25g0dqqmRL4r/CU+Jyjzp118IU8ekttel9VqZ12FxPHAu/AcpsFa6Qpo+BoQ3rKoe2eUjQprKJbMkobfypql19dmm4pG/BSwIwiIdhBLoTEdrbZuk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 612d15e5-b999-411c-ace3-08d7433afcf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 11:08:12.5192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QUhpqScV2vSScxqLJJ4ID25jheugXmtfB0n/u6EdLksyWCqNvhJr4FpSTZ0ih1mWwLMoMxgby5oDxLmKwk+NVfry1Nmf+yz9f5xrZusvXpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2976
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYNCj4gT2YgUGFzY2FsIFZhbiBMZWV1d2VuDQo+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVy
IDI3LCAyMDE5IDEyOjQ0IFBNDQo+IFRvOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgt
Zm91bmRhdGlvbi5vcmc+DQo+IENjOiBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGlu
YXJvLm9yZz47IExpbnV4IENyeXB0byBNYWlsaW5nIExpc3QgPGxpbnV4LQ0KPiBjcnlwdG9Admdl
ci5rZXJuZWwub3JnPjsgTGludXggQVJNIDxsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVh
ZC5vcmc+OyBIZXJiZXJ0IFh1DQo+IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBEYXZp
ZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBHcmVnIEtIDQo+IDxncmVna2hAbGludXhm
b3VuZGF0aW9uLm9yZz47IEphc29uIEEgLiBEb25lbmZlbGQgPEphc29uQHp4MmM0LmNvbT47IFNh
bXVlbCBOZXZlcw0KPiA8c25ldmVzQGRlaS51Yy5wdD47IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJw
ZW50ZXJAb3JhY2xlLmNvbT47IEFybmQgQmVyZ21hbm4NCj4gPGFybmRAYXJuZGIuZGU+OyBFcmlj
IEJpZ2dlcnMgPGViaWdnZXJzQGdvb2dsZS5jb20+OyBBbmR5IEx1dG9taXJza2kgPGx1dG9Aa2Vy
bmVsLm9yZz47DQo+IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+OyBNYXJjIFp5bmdpZXIg
PG1hekBrZXJuZWwub3JnPjsgQ2F0YWxpbiBNYXJpbmFzDQo+IDxjYXRhbGluLm1hcmluYXNAYXJt
LmNvbT4NCj4gU3ViamVjdDogUkU6IFtSRkMgUEFUQ0ggMTgvMThdIG5ldDogd2lyZWd1YXJkIC0g
c3dpdGNoIHRvIGNyeXB0byBBUEkgZm9yIHBhY2tldA0KPiBlbmNyeXB0aW9uDQo+IA0KPiA+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogTGludXMgVG9ydmFsZHMgPHRvcnZh
bGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KPiA+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDI3
LCAyMDE5IDQ6NTQgQU0NCj4gPiBUbzogUGFzY2FsIFZhbiBMZWV1d2VuIDxwdmFubGVldXdlbkB2
ZXJpbWF0cml4LmNvbT4NCj4gPiBDYzogQXJkIEJpZXNoZXV2ZWwgPGFyZC5iaWVzaGV1dmVsQGxp
bmFyby5vcmc+OyBMaW51eCBDcnlwdG8gTWFpbGluZyBMaXN0IDxsaW51eC0NCj4gPiBjcnlwdG9A
dmdlci5rZXJuZWwub3JnPjsgTGludXggQVJNIDxsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJh
ZGVhZC5vcmc+OyBIZXJiZXJ0IFh1DQo+ID4gPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47
IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEdyZWcgS0gNCj4gPiA8Z3JlZ2to
QGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBKYXNvbiBBIC4gRG9uZW5mZWxkIDxKYXNvbkB6eDJjNC5j
b20+OyBTYW11ZWwgTmV2ZXMNCj4gPiA8c25ldmVzQGRlaS51Yy5wdD47IERhbiBDYXJwZW50ZXIg
PGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT47IEFybmQgQmVyZ21hbm4NCj4gPiA8YXJuZEBhcm5k
Yi5kZT47IEVyaWMgQmlnZ2VycyA8ZWJpZ2dlcnNAZ29vZ2xlLmNvbT47IEFuZHkgTHV0b21pcnNr
aQ0KPiA8bHV0b0BrZXJuZWwub3JnPjsNCj4gPiBXaWxsIERlYWNvbiA8d2lsbEBrZXJuZWwub3Jn
PjsgTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz47IENhdGFsaW4gTWFyaW5hcw0KPiA+IDxj
YXRhbGluLm1hcmluYXNAYXJtLmNvbT4NCj4gPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCAxOC8x
OF0gbmV0OiB3aXJlZ3VhcmQgLSBzd2l0Y2ggdG8gY3J5cHRvIEFQSSBmb3IgcGFja2V0DQo+ID4g
ZW5jcnlwdGlvbg0KPiA+DQo+ID4gT24gVGh1LCBTZXAgMjYsIDIwMTkgYXQgNjozMCBQTSBMaW51
cyBUb3J2YWxkcw0KPiA+IDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4gd3JvdGU6DQo+
ID4gPg0KPiA+ID4gQW5kIG9uY2UgeW91IGhhdmUgdGhhdCBjb29raWUsIGFuZCB5b3Ugc2VlICJv
aywgSSBkaWRuJ3QgZ2V0IHRoZQ0KPiA+ID4gYW5zd2VyIGltbWVkaWF0ZWx5IiBvbmx5IFRIRU4g
ZG8geW91IHN0YXJ0IGZpbGxpbmcgaW4gdGhpbmdzIGxpa2UNCj4gPiA+IGNhbGxiYWNrIHN0dWZm
LCBvciBtYXliZSB5b3Ugc2V0IHVwIGEgd2FpdC1xdWV1ZSBhbmQgc3RhcnQgd2FpdGluZyBmb3IN
Cj4gPiA+IGl0LCBvciB3aGF0ZXZlciIuDQo+ID4NCj4gPiBTaWRlIG5vdGU6IGFsbW9zdCBub2Jv
ZHkgZG9lcyB0aGlzLg0KPiA+DQo+ID4gQWxtb3N0IGV2ZXJ5IHNpbmdsZSBhc3luYyBpbnRlcmZh
Y2UgSSd2ZSBldmVyIHNlZW4gZW5kcyB1cCBiZWluZyAib25seQ0KPiA+IGRlc2lnbmVkIGZvciBh
c3luYyIuDQo+ID4NCj4gPiBBbmQgSSB0aGluayB0aGUgcmVhc29uIGlzIHRoYXQgZXZlcnlib2R5
IGZpcnN0IGRvZXMgdGhlIHNpbXBseQ0KPiA+IHN5bmNocm9ub3VzIGludGVyZmFjZXMsIGFuZCBw
ZW9wbGUgc3RhcnQgdXNpbmcgdGhvc2UsIGFuZCBhIGxvdCBvZg0KPiA+IHBlb3BsZSBhcmUgcGVy
ZmVjdGx5IGhhcHB5IHdpdGggdGhlbS4gVGhleSBhcmUgc2ltcGxlLCBhbmQgdGhleSB3b3JrDQo+
ID4gZmluZSBmb3IgdGhlIGh1Z2UgbWFqb3JpdHkgb2YgdXNlcnMuDQo+ID4NCj4gPiBBbmQgdGhl
biBzb21lYm9keSBjb21lcyBhbG9uZyBhbmQgc2F5cyAibm8sIF93ZV8gbmVlZCB0byBkbyB0aGlz
DQo+ID4gYXN5bmNocm9ub3VzbHkiLCBhbmQgYnkgZGVmaW5pdGlvbiB0aGF0IHBlcnNvbiBkb2Vz
ICpub3QqIGNhcmUgZm9yIHRoZQ0KPiA+IHN5bmNocm9ub3VzIGNhc2UsIHNpbmNlIHRoYXQgaW50
ZXJmYWNlIGFscmVhZHkgZXhpc3RlZCBhbmQgd2FzIHNpbXBsZXINCj4gPiBhbmQgYWxyZWFkeSB3
YXMgbW9zdGx5IHN1ZmZpY2llbnQgZm9yIHRoZSBwZW9wbGUgd2hvIHVzZWQgaXQsIGFuZCBzbw0K
PiA+IHRoZSBhc3luYyBpbnRlcmZhY2UgZW5kcyB1cCBiZWluZyBfb25seV8gZGVzaWduZWQgZm9y
IHRoZSBuZXcgYXN5bmMNCj4gPiB3b3JrZmxvdy4gQmVjYXVzZSB0aGF0IHdob2xlIG5ldyB3b3Js
ZCB3YXMgd3JpdHRlbiB3aXRoIGp1c3QgdGhhdCBjYXNlDQo+ID4gaXMgbWluZCwgYW5kIHRoZSBz
eW5jaHJvbm91cyBjYXNlIGNsZWFybHkgZGlkbid0IG1hdHRlci4NCj4gPg0KPiA+IFNvIHRoZW4g
eW91IGVuZCB1cCB3aXRoIHRoYXQga2luZCBvZiBkaWNob3RvbW91cyBzaXR1YXRpb24sIHdoZXJl
IHlvdQ0KPiA+IGhhdmUgYSBzdHJpY3QgYmxhY2stYW5kLXdoaXRlIGVpdGhlci1zeW5jaHJvbm91
cy1vci1hc3luYyBtb2RlbC4NCj4gPg0KPiA+IEFuZCB0aGVuIHNvbWUgcGVvcGxlIC0gcXVpdGUg
cmVhc29uYWJseSAtIGp1c3Qgd2FudCB0aGUgc2ltcGxpY2l0eSBvZg0KPiA+IHRoZSBzeW5jaHJv
bm91cyBjb2RlIGFuZCBpdCBwZXJmb3JtcyBiZXR0ZXIgZm9yIHRoZW0gYmVjYXVzZSB0aGUNCj4g
PiBpbnRlcmZhY2VzIGFyZSBzaW1wbGVyIGFuZCBiZXR0ZXIgc3VpdGVkIHRvIHRoZWlyIGxhY2sg
b2YgZXh0cmEgd29yay4NCj4gPg0KPiA+IEFuZCBvdGhlciBwZW9wbGUgZmVlbCB0aGV5IG5lZWQg
dGhlIGFzeW5jIGNvZGUsIGJlY2F1c2UgdGhleSBjYW4gdGFrZQ0KPiA+IGFkdmFudGFnZSBvZiBp
dC4NCj4gPg0KPiA+IEFuZCBuZXZlciB0aGUgdHdhaW4gc2hhbGwgbWVldCwgYmVjYXVzZSB0aGUg
YXN5bmMgaW50ZXJmYWNlIGlzDQo+ID4gYWN0aXZlbHkgX2JhZF8gZm9yIHRoZSBwZW9wbGUgd2hv
IGhhdmUgc3luYyB3b3JrbG9hZHMgYW5kIHRoZSBzeW5jDQo+ID4gaW50ZXJmYWNlIGRvZXNuJ3Qg
d29yayBmb3IgdGhlIGFzeW5jIHBlb3BsZS4NCj4gPg0KPiA+IE5vbi1jcnlwdG8gZXhhbXBsZTog
W3BdcmVhZCgpIHZzIGFpb19yZWFkKCkuIFRoZXkgZG8gdGhlIHNhbWUgdGhpbmcNCj4gPiAob24g
YSBoaWdoIGxldmVsKSBhcGFydCBmcm9tIHRoYXQgc3luYy9hc3luYyBpc3N1ZS4gQW5kIHRoZXJl
J3Mgbm8gd2F5DQo+ID4gdG8gZ2V0IHRoZSBiZXN0IG9mIGJvdGggd29ybGRzLg0KPiA+DQo+ID4g
RG9pbmcgYWlvX3JlYWQoKSBvbiBzb21ldGhpbmcgdGhhdCBpcyBhbHJlYWR5IGNhY2hlZCBpcyBh
Y3RpdmVseSBtdWNoDQo+ID4gd29yc2UgdGhhbiBqdXN0IGRvaW5nIGEgc3luY2hyb25vdXMgcmVh
ZCgpIG9mIGNhY2hlZCBkYXRhLg0KPiA+DQo+ID4gQnV0IGFpb19yZWFkKCkgX2Nhbl8gYmUgbXVj
aCBiZXR0ZXIgaWYgeW91IGtub3cgeW91ciB3b3JrbG9hZCBkb2Vzbid0DQo+ID4gY2FjaGUgd2Vs
bCBhbmQgcmVhZCgpIGJsb2NrcyB0b28gbXVjaCBmb3IgeW91Lg0KPiA+DQo+ID4gVGhlcmUncyBu
byAicmVhZF9wb3RlbnRpYWxseV9hc3luYygpIiBpbnRlcmZhY2UgdGhhdCBqdXN0IGRvZXMgdGhl
DQo+ID4gc3luY2hyb25vdXMgcmVhZCBmb3IgYW55IGNhY2hlZCBwb3J0aW9uIG9mIHRoZSBkYXRh
LCBhbmQgdGhlbiBkZWxheXMNCj4gPiBqdXN0IHRoZSBJTyBwYXJ0cyBhbmQgcmV0dXJucyBhICJo
ZXJlLCBJIGdhdmUgeW91IFggYnl0ZXMgcmlnaHQgbm93LA0KPiA+IHVzZSB0aGlzIGNvb2tpZSB0
byB3YWl0IGZvciB0aGUgcmVzdCIuDQo+ID4NCj4gPiBNYXliZSBub2JvZHkgd291bGQgdXNlIGl0
LiBCdXQgaXQgcmVhbGx5IHNob3VsZCBiZSBwb3NzaWJseSB0byBoYXZlDQo+ID4gaW50ZXJmYWNl
cyB3aGVyZSBhIGdvb2Qgc3luY2hyb25vdXMgaW1wbGVtZW50YXRpb24gaXMgX3Bvc3NpYmxlXw0K
PiA+IHdpdGhvdXQgdGhlIGV4dHJhIG92ZXJoZWFkLCB3aGlsZSBhbHNvIGFsbG93aW5nIGFzeW5j
IGltcGxlbWVudGF0aW9ucy4NCj4gPg0KPiBUaGF0J3MgdGhlIHF1ZXN0aW9uLiBJJ3ZlIG5ldmVy
IHNlZW4gc3VjaCBhbiBBUEkgeWV0IC4uLg0KPiANCj4gWW91IGNvdWxkIGFsc28ganVzdCBhY2Nl
cHQgdGhhdCB0aG9zZSBhcmUgdHdvIHdpbGRseSBkaWZmZXJlbnQgdXNlDQo+IGNhc2VzIHdpdGgg
d2lsZGx5IGRpZmZlcmVudCByZXF1aXJlbWVudHMgYW5kIGFsbG93IHRoZW0gdG8gY29leGlzdCwN
Cj4gd2hpbGUgIHNoYXJpbmcgYXMgbXVjaCBvZiB0aGUgbG93LWxldmVsIFNXIGltcGxlbWVudGF0
aW9uIGNvZGUgYXMNCj4gcG9zc2libGUgdW5kZXJuZWF0aC4gV2l0aCB0aGUgYXN5bmMgQVBJIG9u
bHkgdXNlZCBmb3IgdGhvc2UgY2FzZXMNCj4gd2hlcmUgSFcgYWNjZWxlcmF0aW9uIGNhbiBtYWtl
IHRoZSBkaWZmZXJlbmNlLg0KPiANCj4gSSBiZWxpZXZlIGZvciBoYXNoZXMsIHRoZSBDcnlwdG8g
QVBJIHN0aWxsIG1haW50YWlucyBhbiBzaGFzaCBhbmQNCj4gYW4gYWhhc2ggQVBJLiBJdCB3b3Jr
cyB0aGUgb3RoZXIgd2F5IGFyb3VuZCBmcm9tIGhvdyB5b3Ugd291bGQNCj4gbGlrZSAgdG8gc2Vl
IHRob3VnaCwgd2l0aCBhaGFzaCB3cmFwcGluZyB0aGUgc2hhc2ggaW4gY2FzZSBvZiBTVw0KPiBp
bXBsZW1lbnRhdGlvbnMuIFN0aWxsLCBpZiB5b3UncmUgc3VyZSB5b3UgY2FuJ3QgYmVuZWZpdCBm
cm9tIEhXDQo+IGFjY2VsZXJhdGlvbiB5b3UgaGF2ZSB0aGUgb3B0aW9uIG9mIHVzaW5nIHRoZSBz
aGFzaCBkaXJlY3RseS4NCj4gDQo+IEkgZG9uJ3Qga25vdyB3aHkgdGhlIHN5bmNocm9ub3VzIGJs
a2NpcGhlciBBUEkgd2FzIGRlcHJlY2F0ZWQsDQo+IHRoYXQgaGFwcGVuZWQgYmVmb3JlIEkgam9p
bmVkLiBJTUhPIGl0IHdvdWxkIG1ha2Ugc2Vuc2UgdG8gaGF2ZSwNCj4gc28gdXNlcnMgbm90IGlu
dGVyZXN0ZWQgaW4gSFcgY3J5cHRvIGFyZSBub3QgYnVyZGVuZWQgYnkgaXQuDQo+IA0KPiANCk5l
dmVyIG1pbmQuIEZyb20gd2hhdCBJIGp1c3QgbGVhcm5lZCwgeW91IGNhbiBhY2hpZXZlIHRoZSBz
YW1lIA0KdGhpbmcgd2l0aCB0aGUgc2tjaXBoZXIgQVBJIGJ5IGp1c3QgcmVxdWVzdGluZyBhIHN5
bmMgaW1wbGVtZW50YXRpb24uDQpXaGljaCB3b3VsZCBhbGxvdyB5b3UgdG8gcHV0IHlvdXIgc3Ry
dWN0cyBvbiB0aGUgc3RhY2sgYW5kIHdvdWxkDQpub3QgcmV0dXJuIGZyb20gdGhlIGVuY3J5cHQo
KS9kZWNyeXB0KCkgY2FsbCB1bnRpbCBhY3R1YWxseSBkb25lLg0KDQpSZWdhcmRzLA0KUGFzY2Fs
IHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5l
cyBAIFZlcmltYXRyaXgNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQoNCg==
