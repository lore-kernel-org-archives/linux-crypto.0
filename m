Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D1EC433FF
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 15:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52C9E218FE
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 15:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="BFtQBVdd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbfHGPNO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 11:13:14 -0400
Received: from mail-eopbgr710054.outbound.protection.outlook.com ([40.107.71.54]:55699
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726773AbfHGPNO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 11:13:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1jBU4PCaIdgVZHXbzICVDLD7qe8ticaIlIVkjUFd3xJsBZQsgd5cxnOPUl6iR/NtkEL8LhCa087ldwkTfNcyhp0akfkHQM/HOfu6wWXYeokbidzenDaB87J31O+uPH+x04IQ/EiG9RJN1d+QvYpYM48KQ0u+39HsV9xNY2CZjqKBkMI5iSsMysR4tqxd41wQci2j4d8H/Lo6PE0Fi/B/NPT1VaWA5iYTpyJDEeIt7K0KAC+3y6xFgIVvd3jYu6M+E0wtr4qio/rcwkvxxuDaQZGEba3O3NYrG9q9w46yPCqNh7QoXw0YVlRfBes8VLGa9fK9uGXQt2MmyVVqN4eTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWoWQbT0Hr7V2Csvg7MzYRBoQnddBAx6A+RW8YJYFYM=;
 b=ToY9UaYV7Y54mNnvPVJbgAdku/DVqW34u+Ov9gUs3bhiHIm1k+Nd/u3mq/crkxNoWUPPnS1FYe9XGTJEwUSUocf6KKxOxfrFwhf9Y/WN3U7NnH7DVbK3Pdtyrl8jGW6N3j+VjyHglDztpyRNKDa58Dwaid9fbl2L0dF0mgdp6oYWi74cybwZl4ZnCVjckwXxYcwBwNKw5KUSpUj8KrCtBVMnUvqfJS+yeS+iDKhgKKTQvlyqjF4jcJSg0D2IDLjLVtCht6ue1Xrax7G2NtIE4xqe1fle2ksF+FaEh9pXqFSRW98lTJdyhhgjtgUEoG62ACaBcQmrAovBBd5eHg0PrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWoWQbT0Hr7V2Csvg7MzYRBoQnddBAx6A+RW8YJYFYM=;
 b=BFtQBVdd7We2VoOuOfPRxwxd5DlH2BRzNuZntFhP9BhhSVFQZjnf4pU2Ooy3pIgeBR+hP3M5v2ik/Dsc5Pfwx9rul1hdZXzhruUqrTRZqn8q5gvBwrYCu9S0qpX7SOh59KtzgvgfOl9Xy73C+SErOkLXBjjh6ykL8lwpeTSAc6c=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2365.namprd20.prod.outlook.com (20.179.146.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 7 Aug 2019 15:13:09 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 15:13:09 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Milan Broz <gmazyland@gmail.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "rsnel@cube.dyndns.org" <rsnel@cube.dyndns.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: xts - Add support for Cipher Text Stealing
Thread-Topic: [PATCH] crypto: xts - Add support for Cipher Text Stealing
Thread-Index: AQHVTCyrZ3LTVlRuCkCwUQoLONEbf6bucuQAgAAMd6CAANdjsIAANO6AgAABheCAAASpAIAAODmg
Date:   Wed, 7 Aug 2019 15:13:09 +0000
Message-ID: <MN2PR20MB2973C4EAF89D158B779CDBDACAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
 <5bf9d0be-3ba4-8903-f1b9-93aa32106274@gmail.com>
 <MN2PR20MB29734CFE2795639436C3CC91CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973A38A300804281CA6A109CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <a0e3ce44-3e47-b8d9-2152-3fd8ba99f09a@gmail.com>
 <MN2PR20MB297333F0024F94C647D71AA2CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <52a11506-0047-a7e7-4fa0-ba8d465b843c@gmail.com>
In-Reply-To: <52a11506-0047-a7e7-4fa0-ba8d465b843c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9fce779e-5167-495f-520f-08d71b49c20c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2365;
x-ms-traffictypediagnostic: MN2PR20MB2365:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB23659A83DC6F5EB5896A8B70CAD40@MN2PR20MB2365.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(376002)(39850400004)(346002)(199004)(189003)(13464003)(25786009)(229853002)(6436002)(14454004)(53936002)(6246003)(4326008)(71200400001)(71190400001)(33656002)(55016002)(9686003)(81166006)(8936002)(68736007)(26005)(81156014)(446003)(186003)(486006)(476003)(11346002)(102836004)(478600001)(316002)(54906003)(110136005)(2906002)(66066001)(7696005)(6506007)(76176011)(256004)(14444005)(99286004)(53546011)(5660300002)(8676002)(3846002)(6116002)(76116006)(66446008)(66476007)(64756008)(66946007)(86362001)(2501003)(66556008)(52536014)(7736002)(74316002)(305945005)(15974865002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2365;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9jpLmhA+qKN4hRYnyBOq734L98dKjH20lJEMyyU1kZwvBx/2pFEfIhn2rV9sX1HhmyQA9NjRGtZ+U9Bl6QXBKn/5WBbH9pQhgDBeYWJ1Q13pjNIapXIAB34oNf/nZs5ItGMHVbEwrleelCv3h0JVTaJYwHDJtxU4FIUGFquoc5I+bVLz6BrCPIYFKU4irvBFPFaj+TK4XIkCHfXEt20mUlN4p7IUU6LPN0dujPjHmI8Y2ASzTwvC/ZsQEy3f+mCHStOO+/ViPKA3NsThEW4QAzN+HT6HCQJK0ThEwFlXKdBCeRym7v9qSDih77r0VeDqBO8H/a5pELg95gGcwEk8bY5HQiddQdtjCNRDlNDB4+MaE5CVE4YTDErOjU5vPiaRN/1GdnsPB3sQAIKw7qcSBOG8btBE5fEHsky22d64ICk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fce779e-5167-495f-520f-08d71b49c20c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 15:13:09.6595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2365
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaWxhbiBCcm96IDxnbWF6eWxh
bmRAZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEF1Z3VzdCA3LCAyMDE5IDE6NDIgUE0N
Cj4gVG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5jb20+OyBQ
YXNjYWwgdmFuIExlZXV3ZW4NCj4gPHBhc2NhbHZhbmxAZ21haWwuY29tPjsgbGludXgtY3J5cHRv
QHZnZXIua2VybmVsLm9yZw0KPiBDYzogcnNuZWxAY3ViZS5keW5kbnMub3JnOyBoZXJiZXJ0QGdv
bmRvci5hcGFuYS5vcmcuYXU7IGRhdmVtQGRhdmVtbG9mdC5uZXQNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSF0gY3J5cHRvOiB4dHMgLSBBZGQgc3VwcG9ydCBmb3IgQ2lwaGVyIFRleHQgU3RlYWxpbmcN
Cj4gDQo+IE9uIDA3LzA4LzIwMTkgMTM6MjcsIFBhc2NhbCBWYW4gTGVldXdlbiB3cm90ZToNCj4g
Pj4gT24gMDcvMDgvMjAxOSAxMDoxNSwgUGFzY2FsIFZhbiBMZWV1d2VuIHdyb3RlOg0KPiA+Pj4g
SSB3ZW50IHRocm91Z2ggdGhlIGNvZGUgYSBjb3VwbGUgb2YgdGltZXMsIGJ1dCBJIGNhbm5vdCBz
cG90IGFueSBtaXN0YWtlcyBpbg0KPiA+Pj4gdGhlIGxlbmd0aHMgSSdtIHVzaW5nLiBJcyBpdCBw
b3NzaWJsZSB0aGF0IHlvdXIgYXBwbGljYXRpb24gaXMgc3VwcGx5aW5nIGENCj4gPj4+IGJ1ZmZl
ciB0aGF0IGlzIGp1c3Qgbm90IGxhcmdlIGVub3VnaD8NCj4gPj4NCj4gPj4gU2VlbXMgdGhlcmUg
aXMgbm8gbWlzdGFrZSBpbiB5b3VyIGNvZGUsIGl0IGlzIHNvbWUgYnVnIGluIGFlc25pX2ludGVs
IGltcGxlbWVudGF0aW9uLg0KPiA+PiBJZiBJIGRpc2FibGUgdGhpcyBtb2R1bGUsIGl0IHdvcmtz
IGFzIGV4cGVjdGVkICh3aXRoIGFlcyBnZW5lcmljIGFuZCBhZXNfaTU4NikuDQo+ID4+DQo+ID4g
VGhhdCdzIG9kZCB0aG91Z2gsIGNvbnNpZGVyaW5nIHRoZXJlIGlzIGEgZGVkaWNhdGVkIHh0cy1h
ZXMtbmkgaW1wbGVtZW50YXRpb24sDQo+ID4gaS5lLiBJIHdvdWxkIG5vdCBleHBlY3QgdGhhdCB0
byBlbmQgdXAgYXQgdGhlIGdlbmVyaWMgeHRzIHdyYXBwZXIgYXQgYWxsPw0KPiANCj4gTm90ZSBp
dCBpcyAzMmJpdCBzeXN0ZW0sIEFFU05JIFhUUyBpcyB1bmRlciAjaWZkZWYgQ09ORklHX1g4Nl82
NCBzbyBpdCBpcyBub3QgdXNlZC4NCj4gDQpPaywgc28gSSBndWVzcyBubyBvbmUgYm90aGVyZWQg
dG8gbWFrZSBhbiBvcHRpbWl6ZWQgWFRTIHZlcnNpb24gZm9yIGkzODYuDQpJIHF1aWNrbHkgYnJv
d3NlZCB0aHJvdWdoIHRoZSBjb2RlIC0gdG9vayBtZSBhIHdoaWxlIHRvIHJlYWxpc2UgdGhlIGFz
c2VtYmx5IGlzDQoiYmFja3dhcmRzIiBjb21wYXJlZCB0byB0aGUgb3JpZ2luYWwgSW50ZWwgZGVm
aW5pdGlvbiA6LSkgLSBidXQgSSBkaWQgbm90IHNwb3QNCmFueXRoaW5nIG9idmlvdXMgOi0oDQoN
Cj4gSSBndWVzcyBpdCBvbmx5IEVDQiBwYXJ0IC4uLg0KPiANCj4gPj4gU2VlbXMgc29tZXRoaW5n
IGlzIHJld3JpdHRlbiBpbiBjYWxsDQo+ID4+ICAgY3J5cHRvX3NrY2lwaGVyX2VuY3J5cHQoc3Vi
cmVxKTsNCj4gPj4NCj4gPj4gKGFmdGVyIHRoYXQgY2FsbCwgSSBzZWUgcmN0eC0+cmVtX2J5dGVz
IHNldCB0byAzMiwgdGhhdCBkb2VzIG5vdCBtYWtlIHNlbnNlLi4uKQ0KPiA+Pg0KRGVwZW5kaW5n
IG9uIHdoYXQgeW91IGhhdmUgb2JzZXJ2ZWQgc28gZmFyLCBpdCBjb3VsZCBhbHNvIGJlIGNvcnJ1
cHRlZCBlYXJsaWVyLA0KaS5lLiBkdXJpbmcgb25lIG9mIHRoZSBza2NpcGhlcl9yZXF1ZXN0KiBj
YWxscyBpbnNpZGUgaW5pdF9jcnlwdD8NCg0KTm90YWJseSwgdGhlIHJlbV9ieXRlcyB2YXJpYWJs
ZSBpcyBpbW1lZGlhdGVseSBiZWhpbmQgdGhlIHN1YnJlcSBzdHJ1Y3QgaW5zaWRlDQpyY3R4LCBi
dXQgb2J2aW91c2x5IHRoZXNlIGNhbGxzIHNob3VsZCBub3Qgd3JpdGUgYmV5b25kIHRoZSBlbmQg
b2YgdGhhdCBzdHJ1Y3QNCihhcyB3aXRob3V0IHRob3NlIGFkZGVkIHZhcmlhYmxlcywgdGhvc2Ug
d3JpdGVzIHdvdWxkIGVuZCB1cCBvdXRzaWRlIG9mIHRoZQ0KYWxsb2NhdGVkIHJjdHggc3RydWN0
KQ0KDQo+ID4gRWggLi4uIG5vLCBpdCBzaG91bGQgbmV2ZXIgYmVjb21lID4gMTUgLi4uIGlmIGl0
IGdldHMgc2V0IHRvIDMyIHNvbWVob3csDQo+ID4gdGhlbiBJIGNhbiBhdCBsZWFzdCBleHBsYWlu
IHdoeSB0aGF0IHdvdWxkIHJlc3VsdCBpbiBhIGJ1ZmZlciBvdmVyZmxvdyA6LSkNCj4gDQo+IFll
cywgdGhhdCBleHBsYWlucyBpdC4NCj4gDQo+IChBbmQgcmV3cml0aW5nIHRoaXMgdmFsdWUgYmFj
ayBkb2VzIG5vdCBoZWxwLCBJIGdvdCBkaWZmZXJlbnQgdGVzdCB2ZWN0b3Igb3V0cHV0LCBidXQg
bm8NCj4gY3Jhc2guKQ0KPiANCldlbGwsIHRoZXJlJ3MgYWxzbyBhbiBpc19lbmNyeXB0IGZsYWcg
aW1tZWRpYXRlbHkgYmVoaW5kIHJlbV9ieXRlcyB0aGF0DQpsaWtlbHkgYWxzbyBnZXRzIGNvcnJ1
cHRlZD8NCg0KPiBNaWxhbg0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29u
IElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIFZlcmltYXRyaXgNCnd3dy5p
bnNpZGVzZWN1cmUuY29tDQo=
