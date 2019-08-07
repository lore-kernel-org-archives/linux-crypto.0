Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB220C32751
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 11:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E49621BE6
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 11:27:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="k5jftT/4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbfHGL15 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 07:27:57 -0400
Received: from mail-eopbgr720072.outbound.protection.outlook.com ([40.107.72.72]:5184
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726418AbfHGL15 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 07:27:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFkw+m4QATggmLA5wKgEhuE1/p33AT+QfXN4aWaxMNFHCf3vKkK9fo0RroJlODpdZRzA85OEWdNaKhqJw7maSGTzC5kcJL86iPWH67NobqPnLn2lv9y8weDYD0G2inDjMrjaRLdiHxSOTDAYravNW75jTzu05+0H6S6fTRKSnvYrgSD6dpb/QdnLTG7oT4CRRt0vB4VJ8RwAFA1hDfZ7HDD7JHykvnVYBwmR9Wqu1nLpyS984JoWppD5SzYvHQ+KUDWLu3aL8uVEpmfb6bUQ/k7RhZmURGsRXRfxTu+k6zPiYR3BoFz9guZbyP3M/jUU6llL5HflB7yYe68Dib/iRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQAnpRLTF61rT7VrKiCNiNMvheQup7Ja606FuWADy8M=;
 b=MfDxWPFZrZwpPts1OuoepcJLRXNJhID115N8vI3sOX8vFMUnjgKkpA5yST1XfoXbsve1JDiz1K5IB8Rt3mkoapBMuactrwl4x20LIiKl4dAYn/CAUEOoENJxI0WCm3wioDBUqKWoM9fipmHEBchiyGL9e0K9rxEfSVE3N9ZkKXQ3C1cUG7B7GuSWKpjPkW9WbwOKhQmzjcf7CyFf+Eflf0Xp7MafsxsITMkv2qV/r1Wv2dMQhj2HAzoTvC82XaBnFLATbRqVPpOQ2/fFWuZlCjHBxkx++nzLK8LZpoUm7R65swedDawCvuCPgS2PkZaOlauaEUhVGSQt5PtPVPZ3rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQAnpRLTF61rT7VrKiCNiNMvheQup7Ja606FuWADy8M=;
 b=k5jftT/4fqhY0zE5ODyScqJAA8y8jpegLJWYkrKCRCdpvUiG5foBaXXv5tlXM7A21Sp6s50LV2JLU0aYJLmeQqzEKX042AzZn5ssqxSpwAOHODWStepFAdHYNm25Lr0rlhRPnI6bb8A0EzNowHlz6OnibLo9A84rQOAwuLH0K34=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2752.namprd20.prod.outlook.com (20.178.251.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.15; Wed, 7 Aug 2019 11:27:53 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 11:27:53 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Milan Broz <gmazyland@gmail.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "rsnel@cube.dyndns.org" <rsnel@cube.dyndns.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: xts - Add support for Cipher Text Stealing
Thread-Topic: [PATCH] crypto: xts - Add support for Cipher Text Stealing
Thread-Index: AQHVTCyrZ3LTVlRuCkCwUQoLONEbf6bucuQAgAAMd6CAANdjsIAANO6AgAABheA=
Date:   Wed, 7 Aug 2019 11:27:53 +0000
Message-ID: <MN2PR20MB297333F0024F94C647D71AA2CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
 <5bf9d0be-3ba4-8903-f1b9-93aa32106274@gmail.com>
 <MN2PR20MB29734CFE2795639436C3CC91CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973A38A300804281CA6A109CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <a0e3ce44-3e47-b8d9-2152-3fd8ba99f09a@gmail.com>
In-Reply-To: <a0e3ce44-3e47-b8d9-2152-3fd8ba99f09a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b61d329f-bf81-4937-5ef1-08d71b2a49c0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2752;
x-ms-traffictypediagnostic: MN2PR20MB2752:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2752AD82411FDB5A201A430BCAD40@MN2PR20MB2752.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(376002)(136003)(346002)(366004)(199004)(189003)(13464003)(102836004)(68736007)(53936002)(9686003)(446003)(11346002)(71200400001)(476003)(54906003)(186003)(66066001)(316002)(15974865002)(486006)(99286004)(110136005)(25786009)(55016002)(4326008)(256004)(7696005)(26005)(52536014)(6436002)(478600001)(5660300002)(71190400001)(76116006)(74316002)(6116002)(76176011)(66446008)(2906002)(229853002)(66946007)(33656002)(3846002)(66556008)(66476007)(86362001)(8936002)(6246003)(64756008)(8676002)(6506007)(14454004)(7736002)(53546011)(2501003)(81166006)(81156014)(305945005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2752;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gKrCx6ygGAD+aBNHMiJrVL75rqstafmlNj/3KK3trTdw6gZ6/CcUgV2wuPbhbuZDjBoJieLiEhvMlznlAD5yy3PxqY/82l7LmGsgYyWHbwy7QsyJfDwIjbgXTyi0daVHHskmtnyYag+xwVJR7F+93hQqH68pv/Feq80l+SkiPnhGXnNvu8ZyNDUG+jGhJeueNTLgHp1NBNQxMNQOBwWdRpyjoCkRniuh2IC52jn1RvCeb8+K4rvaMGLF9YE0jFtAoZldDUPKmfdXQXnrko0jzlswvGJwSqsmfqGGqOwvLU7kOjiyAUyo2tNHcDFwaQABSEk6IXJERfL0gEpo97fEo/tgdxv7o2smRPhFN/MyBAR25iiFXTX0CIWj9aN//c5hnfoMsjCf1M+C3CSp3j8nrOMcs1qBfFs+9eL9Na+hwVQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b61d329f-bf81-4937-5ef1-08d71b2a49c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 11:27:53.4305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2752
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

TWlsYW4sDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaWxhbiBC
cm96IDxnbWF6eWxhbmRAZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEF1Z3VzdCA3LCAy
MDE5IDE6MjAgUE0NCj4gVG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1h
dHJpeC5jb20+OyBQYXNjYWwgdmFuIExlZXV3ZW4NCj4gPHBhc2NhbHZhbmxAZ21haWwuY29tPjsg
bGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiBDYzogcnNuZWxAY3ViZS5keW5kbnMub3Jn
OyBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7IGRhdmVtQGRhdmVtbG9mdC5uZXQNCj4gU3Vi
amVjdDogUmU6IFtQQVRDSF0gY3J5cHRvOiB4dHMgLSBBZGQgc3VwcG9ydCBmb3IgQ2lwaGVyIFRl
eHQgU3RlYWxpbmcNCj4gDQo+IEhpLA0KPiANCj4gT24gMDcvMDgvMjAxOSAxMDoxNSwgUGFzY2Fs
IFZhbiBMZWV1d2VuIHdyb3RlOg0KPiA+IEkgd2VudCB0aHJvdWdoIHRoZSBjb2RlIGEgY291cGxl
IG9mIHRpbWVzLCBidXQgSSBjYW5ub3Qgc3BvdCBhbnkgbWlzdGFrZXMgaW4NCj4gPiB0aGUgbGVu
Z3RocyBJJ20gdXNpbmcuIElzIGl0IHBvc3NpYmxlIHRoYXQgeW91ciBhcHBsaWNhdGlvbiBpcyBz
dXBwbHlpbmcgYQ0KPiA+IGJ1ZmZlciB0aGF0IGlzIGp1c3Qgbm90IGxhcmdlIGVub3VnaD8NCj4g
DQo+IFNlZW1zIHRoZXJlIGlzIG5vIG1pc3Rha2UgaW4geW91ciBjb2RlLCBpdCBpcyBzb21lIGJ1
ZyBpbiBhZXNuaV9pbnRlbCBpbXBsZW1lbnRhdGlvbi4NCj4gSWYgSSBkaXNhYmxlIHRoaXMgbW9k
dWxlLCBpdCB3b3JrcyBhcyBleHBlY3RlZCAod2l0aCBhZXMgZ2VuZXJpYyBhbmQgYWVzX2k1ODYp
Lg0KPiANClRoYXQncyBvZGQgdGhvdWdoLCBjb25zaWRlcmluZyB0aGVyZSBpcyBhIGRlZGljYXRl
ZCB4dHMtYWVzLW5pIGltcGxlbWVudGF0aW9uLA0KaS5lLiBJIHdvdWxkIG5vdCBleHBlY3QgdGhh
dCB0byBlbmQgdXAgYXQgdGhlIGdlbmVyaWMgeHRzIHdyYXBwZXIgYXQgYWxsPw0KDQo+IFNlZW1z
IHNvbWV0aGluZyBpcyByZXdyaXR0ZW4gaW4gY2FsbA0KPiAgIGNyeXB0b19za2NpcGhlcl9lbmNy
eXB0KHN1YnJlcSk7DQo+IA0KPiAoYWZ0ZXIgdGhhdCBjYWxsLCBJIHNlZSByY3R4LT5yZW1fYnl0
ZXMgc2V0IHRvIDMyLCB0aGF0IGRvZXMgbm90IG1ha2Ugc2Vuc2UuLi4pDQo+IA0KRWggLi4uIG5v
LCBpdCBzaG91bGQgbmV2ZXIgYmVjb21lID4gMTUgLi4uIGlmIGl0IGdldHMgc2V0IHRvIDMyIHNv
bWVob3csDQp0aGVuIEkgY2FuIGF0IGxlYXN0IGV4cGxhaW4gd2h5IHRoYXQgd291bGQgcmVzdWx0
IGluIGEgYnVmZmVyIG92ZXJmbG93IDotKQ0KDQo+IEknbGwgY2hlY2sgdGhhdCwgYnV0IG5vdCBz
dXJlIHRoYXQgdW5kZXJzdGFuZCB0aGF0IG9wdGltaXplZCBjb2RlIDopDQo+IA0KPiBNaWxhbg0K
DQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVs
dGktUHJvdG9jb2wgRW5naW5lcyBAIFZlcmltYXRyaXgNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQoN
Cg==
