Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0099C32751
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 21:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EBCA217D9
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 21:13:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="XqGellv3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbfHGVNS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 17:13:18 -0400
Received: from mail-eopbgr700079.outbound.protection.outlook.com ([40.107.70.79]:51589
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730231AbfHGVNS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 17:13:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPE1fx//QfOxCFMAuUYVUvbufCBFVvqiZLeCAqlk0YL/JC+eTw/b+uW2Gy1caEE9S2rnHjbEG7p7NANcarqQS+U817N17wKsaTY6tARJ5akUr+1tLT8XVyV7byRNZxeUBspYP0wG9n3HdbmyJmhgpk3ZY/56K0ZnaPFE1QxkccT0DKyM5DlubYhDCDdTmwHit/gviKQZuDB+byECbn0K57Y0L70CgkMzcBT09NOhIpNek6x6aTClb6J1yRvqJZ1PhGSauwSjp1ej+3XpQROb9jjzSHVcCtDBd3HbhAl9ew5l0GbcGhDxmJlb7BaZny01aWczAXMz2lgwS/p4GPW7zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj2w2X14VODnKI4Vw6TklvGVniHIATrPlOkzf0FYZ9Q=;
 b=QYgNcjpoe2nz2S/d8AS4HZZaeD/sA4sbnLD/kTvN3rcRQJmjQsNZcEOABNnlEu0bOHepG1f1/lTwY7SCssFOpE0jbYietEzDyv9FucIjECc+T6AtcXi95u3ARlBCS2tpXdCMwTZbCjmrQCElUg17kap/Vxj/AZg4wKlPhglL0K9ngZINs6HaMdYa3xjwBTBdGsfzWCQlhgefjndfuYeJkWkVYN+cM1JVctx5AtWS+VsRgz+hpn4/O1PWsz5h+5z9CcCIQLWF8uwXXnIXdeQza7BSGZNDmcfn9TRh+uUz3LiUljuob6fyaAGNAYCxsGDdhRKEMQHm9pkUUjc7nEg8WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj2w2X14VODnKI4Vw6TklvGVniHIATrPlOkzf0FYZ9Q=;
 b=XqGellv3H93gVy58Syz8ShhFY+g4oZbIMNiKbCTL6pNUEP4EsmxDfL4wTmGSiI4VgDtvZ4lCcfdxnmaK5oPtDPidWLSeR5KNluDeYdtm9DxFbDzwaZnIfPm4MRqYkr/dhx4ZFi3H97wYeajIMQz56llWYAy7sAK/vx13NXFppig=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2541.namprd20.prod.outlook.com (20.179.148.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 7 Aug 2019 21:13:14 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 21:13:14 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     =?utf-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
        Milan Broz <gmazyland@gmail.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "rsnel@cube.dyndns.org" <rsnel@cube.dyndns.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: xts - Add support for Cipher Text Stealing
Thread-Topic: [PATCH] crypto: xts - Add support for Cipher Text Stealing
Thread-Index: AQHVTCyrZ3LTVlRuCkCwUQoLONEbf6bucuQAgAAMd6CAANdjsIAANO6AgAABheCAAASpAIAAODmggAAng4CAADSOgIAACQ6w
Date:   Wed, 7 Aug 2019 21:13:13 +0000
Message-ID: <MN2PR20MB297367EE650DBA3308ADD134CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
 <5bf9d0be-3ba4-8903-f1b9-93aa32106274@gmail.com>
 <MN2PR20MB29734CFE2795639436C3CC91CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973A38A300804281CA6A109CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <a0e3ce44-3e47-b8d9-2152-3fd8ba99f09a@gmail.com>
 <MN2PR20MB297333F0024F94C647D71AA2CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <52a11506-0047-a7e7-4fa0-ba8d465b843c@gmail.com>
 <MN2PR20MB2973C4EAF89D158B779CDBDACAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <46f76b06-004e-c08a-3ef3-4ba9fdc61d91@gmail.com>
 <CAAUqJDuMUHqd4J7TNRbMiEDNeb_GCJPhJUQJoOJo5zXKmL72nQ@mail.gmail.com>
In-Reply-To: <CAAUqJDuMUHqd4J7TNRbMiEDNeb_GCJPhJUQJoOJo5zXKmL72nQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 510ed5a0-63bd-4ff3-5141-08d71b7c0f3d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2541;
x-ms-traffictypediagnostic: MN2PR20MB2541:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB254145D97166814A468030B8CAD40@MN2PR20MB2541.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(396003)(39850400004)(366004)(199004)(189003)(13464003)(74316002)(33656002)(14454004)(110136005)(54906003)(316002)(6436002)(478600001)(2906002)(4326008)(6246003)(25786009)(229853002)(15974865002)(53936002)(14444005)(256004)(9686003)(7736002)(55016002)(8676002)(305945005)(52536014)(6116002)(3846002)(66574012)(66446008)(5660300002)(81166006)(8936002)(81156014)(76116006)(66946007)(66476007)(102836004)(446003)(7696005)(76176011)(86362001)(71200400001)(66066001)(71190400001)(26005)(476003)(11346002)(53546011)(66556008)(64756008)(6506007)(99286004)(486006)(186003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2541;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fB23gNlIuUkwplN0cwZDMKC307uOSnEUHmehJBC0R4yexWcDDTP7p5SuB7aJnCXF6J3Ytlz4OBAWTzu1hroU/qMBWPYOmxXrGIT4OTAaCCNnxi87bTkiddlL8CHQSRHBlDPUmOVrI8Clm+QqCV7C/WMcatJUBK0KqSEIM5EqvKLlXeFbTJoXDg9Nm6nhbYQJ0UqUWKHmA5kjz0dTDXx4k5dRlKlZNDToHCiHUv/nXFUWTuJ6hz6gzEB8/jNzusPOQiS2wRU+MDOtcj+VCzW9XCkbvYFYVclZ1tNklc0xvHxfCEUvQJw+t+/iWyjwDfaIHAKuNRL/zmxlCFJejdwUPwxfyGLD+YJ00I61ZWr3e3AbAzsX2ecyYyvYiXIuGtnfjBfMdjhsi9mFDxkerKtDhwBCAUouxmdT32M5r1O51xM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 510ed5a0-63bd-4ff3-5141-08d71b7c0f3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 21:13:13.9337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2541
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBPbmRyZWogTW9zbsOhxI1layA8
b21vc25hY2VrQGdtYWlsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3QgNywgMjAxOSAx
MDozMyBQTQ0KPiBUbzogTWlsYW4gQnJveiA8Z21henlsYW5kQGdtYWlsLmNvbT4NCj4gQ2M6IFBh
c2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5jb20+OyBQYXNjYWwgdmFu
IExlZXV3ZW4NCj4gPHBhc2NhbHZhbmxAZ21haWwuY29tPjsgbGludXgtY3J5cHRvQHZnZXIua2Vy
bmVsLm9yZzsgcnNuZWxAY3ViZS5keW5kbnMub3JnOw0KPiBoZXJiZXJ0QGdvbmRvci5hcGFuYS5v
cmcuYXU7IGRhdmVtQGRhdmVtbG9mdC5uZXQNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gY3J5cHRv
OiB4dHMgLSBBZGQgc3VwcG9ydCBmb3IgQ2lwaGVyIFRleHQgU3RlYWxpbmcNCj4gDQo+IHN0IDcu
IDguIDIwMTkgbyAxOTo0NCBNaWxhbiBCcm96IDxnbWF6eWxhbmRAZ21haWwuY29tPiBuYXDDrXNh
bChhKToNCj4gPiBPbiAwNy8wOC8yMDE5IDE3OjEzLCBQYXNjYWwgVmFuIExlZXV3ZW4gd3JvdGU6
DQo+ID4gPj4+PiBTZWVtcyB0aGVyZSBpcyBubyBtaXN0YWtlIGluIHlvdXIgY29kZSwgaXQgaXMg
c29tZSBidWcgaW4gYWVzbmlfaW50ZWwgaW1wbGVtZW50YXRpb24uDQo+ID4gPj4+PiBJZiBJIGRp
c2FibGUgdGhpcyBtb2R1bGUsIGl0IHdvcmtzIGFzIGV4cGVjdGVkICh3aXRoIGFlcyBnZW5lcmlj
IGFuZCBhZXNfaTU4NikuDQo+ID4gPj4+Pg0KPiA+ID4+PiBUaGF0J3Mgb2RkIHRob3VnaCwgY29u
c2lkZXJpbmcgdGhlcmUgaXMgYSBkZWRpY2F0ZWQgeHRzLWFlcy1uaSBpbXBsZW1lbnRhdGlvbiwN
Cj4gPiA+Pj4gaS5lLiBJIHdvdWxkIG5vdCBleHBlY3QgdGhhdCB0byBlbmQgdXAgYXQgdGhlIGdl
bmVyaWMgeHRzIHdyYXBwZXIgYXQgYWxsPw0KPiA+ID4+DQo+ID4gPj4gTm90ZSBpdCBpcyAzMmJp
dCBzeXN0ZW0sIEFFU05JIFhUUyBpcyB1bmRlciAjaWZkZWYgQ09ORklHX1g4Nl82NCBzbyBpdCBp
cyBub3QgdXNlZC4NCj4gPiA+Pg0KPiA+ID4gT2ssIHNvIEkgZ3Vlc3Mgbm8gb25lIGJvdGhlcmVk
IHRvIG1ha2UgYW4gb3B0aW1pemVkIFhUUyB2ZXJzaW9uIGZvciBpMzg2Lg0KPiA+ID4gSSBxdWlj
a2x5IGJyb3dzZWQgdGhyb3VnaCB0aGUgY29kZSAtIHRvb2sgbWUgYSB3aGlsZSB0byByZWFsaXNl
IHRoZSBhc3NlbWJseSBpcw0KPiA+ID4gImJhY2t3YXJkcyIgY29tcGFyZWQgdG8gdGhlIG9yaWdp
bmFsIEludGVsIGRlZmluaXRpb24gOi0pIC0gYnV0IEkgZGlkIG5vdCBzcG90DQo+ID4gPiBhbnl0
aGluZyBvYnZpb3VzIDotKA0KPiA+ID4NCj4gPiA+PiBJIGd1ZXNzIGl0IG9ubHkgRUNCIHBhcnQg
Li4uDQo+ID4NCj4gPiBNeXN0ZXJ5IHNvbHZlZCwgdGhlIHNrY2lwaGVyIHN1YnJlcSBtdXN0IGJl
IHRlIGxhc3QgbWVtYmVyIGluIHRoZSBzdHJ1Y3QuDQo+ID4gKFNvbWUgY29tbWVudHMgaW4gQWRp
YW50dW0gY29kZSBtZW50aW9ucyBpdCB0b28sIHNvIEkgZG8gbm90IHRoaW5rIGl0DQo+ID4ganVz
dCBoaWRlcyB0aGUgY29ycnVwdGlvbiBhZnRlciB0aGUgc3RydWN0LiBTZWVtcyBsaWtlIGFub3Ro
ZXIgbWFnaWMgcmVxdWlyZW1lbnQNCj4gPiBpbiBjcnlwdG8gQVBJIDotKQ0KPiANCj4gT2gsIHll
cywgdGhpcyBtYWtlcyBzZW5zZSEgSSB3b3VsZCBoYXZlIG5vdGljZWQgdGhpcyBpbW1lZGlhdGVs
eSBpZiBJDQo+IGhhZCBsb29rZWQgY2FyZWZ1bGx5IGF0IHRoZSBzdHJ1Y3QgZGVmaW5pdGlvbiA6
KSBUaGUgcmVhc29uIGlzIHRoYXQNCj4gdGhlIHNrY2lwaGVyX3JlcXVlc3Qgc3RydWN0IGlzIGZv
bGxvd2VkIGJ5IGEgdmFyaWFibGUtbGVuZ3RoIHJlcXVlc3QNCj4gY29udGV4dC4gU28gd2hlbiB5
b3Ugd2FudCB0byBuZXN0IHJlcXVlc3RzLCB5b3UgbmVlZCB0byBtYWtlIHRoZQ0KPiBzdWJyZXF1
ZXN0IHRoZSBsYXN0IG1lbWJlciBhbmQgZGVjbGFyZSB5b3VyIHJlcXVlc3QgY29udGV4dCBzaXpl
IGFzOg0KPiBzaXplIG9mIHlvdXIgcmVxdWVzdCBjb250ZXh0IHN0cnVjdCArIHNpemUgb2YgdGhl
IHN1Yi1hbGdvcml0aG0ncw0KPiByZXF1ZXN0IGNvbnRleHQuDQo+IA0KPiBJdCBpcyBhIGJpdCBj
b25mdXNpbmcsIGJ1dCBpdCBpcyB0aGUgb25seSByZWFzb25hYmxlIHdheSB0byBzdXBwb3J0DQo+
IHZhcmlhYmx5IHNpemVkIGNvbnRleHQgYW5kIGF0IHRoZSBzYW1lIHRpbWUga2VlcCB0aGUgd2hv
bGUgcmVxdWVzdCBpbg0KPiBhIHNpbmdsZSBhbGxvY2F0aW9uLg0KPiANCkFoLCBvaywgSSBkaWQg
bm90IGtub3cgYW55dGhpbmcgYWJvdXQgdGhhdCAuLi4gc28gdGhlcmUncyByZWFsbHkgbm8gd2F5
DQpJIGNvdWxkJ3ZlIGRvbmUgdGhpcyBjb3JyZWN0bHkgb3IgdG8gaGF2ZSBmb3VuZCB0aGUgcHJv
YmxlbSBteXNlbGYgcmVhbGx5Lg0KR29vZCB0aGF0IGl0J3MgcmVzb2x2ZWQgbm93LCB0aG91Z2gu
DQoNCkkgZml4ZWQgYSBjb3VwbGUgb2Ygb3RoZXIgbWlub3IgdGhpbmdzIGFscmVhZHksIGlzIGl0
IE9LIGlmIEkgcm9sbCB0aGlzDQppbnRvIGFuIHVwZGF0ZSB0byBteSBvcmlnaW5hbCBwYXRjaD8N
Cg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11
bHRpLVByb3RvY29sIEVuZ2luZXMgQCBWZXJpbWF0cml4DQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0K
DQo=
