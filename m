Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F200C433FF
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 20:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C782521901
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 20:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="D/XMT/ML"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfHGU0M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 16:26:12 -0400
Received: from mail-eopbgr700069.outbound.protection.outlook.com ([40.107.70.69]:37089
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729804AbfHGU0M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 16:26:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIXyGI5W5g4KggPG52mteJhspySMLqgvTDt+1OnA0vKI1G9WxeiqDkqqmbEnjnQdaJ0lPMztPnxcMHNQvu724RXKItsIPN/+Hz1fnya2C7l6hmpbrykoi/ZCXG5FhX1z8q41FfSlCVegj9Ru9yNp9wJ02cKrOXQ3d2RsmHAfZsY2baTV9UKqGWozEr5jSb0ZcPkljm24n113hzsqI+BQheGLaw9RqQGnsIpOU5oMzpNTrmM516WieqldLs8bemU5ZPLzWio9PDfOHz+M9fNoVZLxCts9Fp/8rFVnDgeEsawf8vlxMoBEDhdlC+rRTYN95m4dQsLr2XoBbljkGljgnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4Cp7ailmsFYB9esR9e33qjjHnJFNHpN8DnHQigi45M=;
 b=Z+jnR0d31Ywm7lcW1kFbvWBOI/FNVlmGBSccl5j5MSrgHIPVwJZrswMh2em5o2oMrJIPKpalI9IfucprYWhj5epMgdgyIUg1An3fdSzuMm9XE03ylZUkUeSuKQuQ2dqVair3EAxEiQAtes3bD6gX0VCuFg48gAbZWpK38KtbZzj+rYFb+K9nHBoc4JnKdZKmU2Wq55joQUMG5HBWsYwFuWhNW3n0KK0gsMo53Z++EaKOMMeaBdrb29iBMsZYDdnX/64uQ3ZowuGfi+RwR9AEdt4y2bGjanoA2oKC+t5pS6Fq6B3Yg8ykid0+p5mm2gbnwFyy2T57iirCSYc1PE790A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4Cp7ailmsFYB9esR9e33qjjHnJFNHpN8DnHQigi45M=;
 b=D/XMT/MLX189dNSRWRAchvz9ePKpUOQOGOnid4tDmPyNT1gAioMcs04bR37OgRDOc+tjDVmNJ5VLiqMymmOpMc+ltUt2vExNHFYNxlwk9TqqeajoxTfgZTTpxlMFThUqag03HZZywsvdxLhvLyNwpsyyvgUQmtM2wVrgQ00MgHE=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2750.namprd20.prod.outlook.com (20.178.253.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Wed, 7 Aug 2019 20:26:09 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 20:26:09 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Milan Broz <gmazyland@gmail.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "rsnel@cube.dyndns.org" <rsnel@cube.dyndns.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: xts - Add support for Cipher Text Stealing
Thread-Topic: [PATCH] crypto: xts - Add support for Cipher Text Stealing
Thread-Index: AQHVTCyrZ3LTVlRuCkCwUQoLONEbf6bucuQAgAAMd6CAANdjsIAANO6AgAABheCAAASpAIAAODmggAAng4CAADIBsA==
Date:   Wed, 7 Aug 2019 20:26:08 +0000
Message-ID: <MN2PR20MB297332EBE274E016AB90D58ACAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
 <5bf9d0be-3ba4-8903-f1b9-93aa32106274@gmail.com>
 <MN2PR20MB29734CFE2795639436C3CC91CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973A38A300804281CA6A109CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <a0e3ce44-3e47-b8d9-2152-3fd8ba99f09a@gmail.com>
 <MN2PR20MB297333F0024F94C647D71AA2CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <52a11506-0047-a7e7-4fa0-ba8d465b843c@gmail.com>
 <MN2PR20MB2973C4EAF89D158B779CDBDACAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <46f76b06-004e-c08a-3ef3-4ba9fdc61d91@gmail.com>
In-Reply-To: <46f76b06-004e-c08a-3ef3-4ba9fdc61d91@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa2a76fc-a4ce-4c37-ea07-08d71b757b4e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2750;
x-ms-traffictypediagnostic: MN2PR20MB2750:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2750FF62E465002F8405F514CAD40@MN2PR20MB2750.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(39850400004)(396003)(189003)(199004)(13464003)(4326008)(486006)(8676002)(54906003)(316002)(33656002)(6246003)(66946007)(229853002)(66446008)(478600001)(476003)(110136005)(14454004)(446003)(66556008)(7736002)(25786009)(81166006)(305945005)(2906002)(81156014)(256004)(11346002)(99286004)(6116002)(14444005)(66476007)(3846002)(8936002)(64756008)(76176011)(6506007)(102836004)(53546011)(76116006)(74316002)(86362001)(71200400001)(5660300002)(71190400001)(26005)(53936002)(7696005)(186003)(2501003)(66066001)(55016002)(15974865002)(52536014)(9686003)(6436002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2750;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mzKlNTSmGBZvcAAThG5f/VsDZ/H1AH7+RDJfWmEy2cMI0ODPCK07OWQc7Xu5wjWHhF0ZyJPZbT9h4S2kEbdCePopeR9TiwQjMrlvl6hMjgIogf9HMx3Sm5kWaFsPFryYEplhmvSBghUMPmktvLi7g+cxvkVcArOaQVxiHm2+tC1Nc1Asia6i1d70YkGtMX48CQVJuSQgI2MYX3MGCR5E9xdNNu6FBvnr9rC98IinO8GpCUCWDLHHKUE/Hh+npsYmiAl6oVyuQ1wVHO+g1+Oefu5a26B0Q2SIzAow7c0hrc7/B1RVqcbIwXu3uvdDct+ksVWON52ZZhi8YWLneTzQRIY8a9I9uxQGrKzAMnNAI0NccS/rwthlKRt6LdHnkRFsroXqgvapRtauIvBTp+K8Q2/nKBXq2nik+ZGpV9yROgw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2a76fc-a4ce-4c37-ea07-08d71b757b4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 20:26:08.8468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2750
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaWxhbiBCcm96IDxnbWF6eWxh
bmRAZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEF1Z3VzdCA3LCAyMDE5IDc6MjQgUE0N
Cj4gVG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5jb20+OyBQ
YXNjYWwgdmFuIExlZXV3ZW4NCj4gPHBhc2NhbHZhbmxAZ21haWwuY29tPjsgbGludXgtY3J5cHRv
QHZnZXIua2VybmVsLm9yZw0KPiBDYzogcnNuZWxAY3ViZS5keW5kbnMub3JnOyBoZXJiZXJ0QGdv
bmRvci5hcGFuYS5vcmcuYXU7IGRhdmVtQGRhdmVtbG9mdC5uZXQNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSF0gY3J5cHRvOiB4dHMgLSBBZGQgc3VwcG9ydCBmb3IgQ2lwaGVyIFRleHQgU3RlYWxpbmcN
Cj4gDQo+IE9uIDA3LzA4LzIwMTkgMTc6MTMsIFBhc2NhbCBWYW4gTGVldXdlbiB3cm90ZToNCj4g
Pj4+PiBTZWVtcyB0aGVyZSBpcyBubyBtaXN0YWtlIGluIHlvdXIgY29kZSwgaXQgaXMgc29tZSBi
dWcgaW4gYWVzbmlfaW50ZWwgaW1wbGVtZW50YXRpb24uDQo+ID4+Pj4gSWYgSSBkaXNhYmxlIHRo
aXMgbW9kdWxlLCBpdCB3b3JrcyBhcyBleHBlY3RlZCAod2l0aCBhZXMgZ2VuZXJpYyBhbmQgYWVz
X2k1ODYpLg0KPiA+Pj4+DQo+ID4+PiBUaGF0J3Mgb2RkIHRob3VnaCwgY29uc2lkZXJpbmcgdGhl
cmUgaXMgYSBkZWRpY2F0ZWQgeHRzLWFlcy1uaSBpbXBsZW1lbnRhdGlvbiwNCj4gPj4+IGkuZS4g
SSB3b3VsZCBub3QgZXhwZWN0IHRoYXQgdG8gZW5kIHVwIGF0IHRoZSBnZW5lcmljIHh0cyB3cmFw
cGVyIGF0IGFsbD8NCj4gPj4NCj4gPj4gTm90ZSBpdCBpcyAzMmJpdCBzeXN0ZW0sIEFFU05JIFhU
UyBpcyB1bmRlciAjaWZkZWYgQ09ORklHX1g4Nl82NCBzbyBpdCBpcyBub3QgdXNlZC4NCj4gPj4N
Cj4gPiBPaywgc28gSSBndWVzcyBubyBvbmUgYm90aGVyZWQgdG8gbWFrZSBhbiBvcHRpbWl6ZWQg
WFRTIHZlcnNpb24gZm9yIGkzODYuDQo+ID4gSSBxdWlja2x5IGJyb3dzZWQgdGhyb3VnaCB0aGUg
Y29kZSAtIHRvb2sgbWUgYSB3aGlsZSB0byByZWFsaXNlIHRoZSBhc3NlbWJseSBpcw0KPiA+ICJi
YWNrd2FyZHMiIGNvbXBhcmVkIHRvIHRoZSBvcmlnaW5hbCBJbnRlbCBkZWZpbml0aW9uIDotKSAt
IGJ1dCBJIGRpZCBub3Qgc3BvdA0KPiA+IGFueXRoaW5nIG9idmlvdXMgOi0oDQo+ID4NCj4gPj4g
SSBndWVzcyBpdCBvbmx5IEVDQiBwYXJ0IC4uLg0KPiANCj4gTXlzdGVyeSBzb2x2ZWQsIHRoZSBz
a2NpcGhlciBzdWJyZXEgbXVzdCBiZSB0ZSBsYXN0IG1lbWJlciBpbiB0aGUgc3RydWN0Lg0KPiAo
U29tZSBjb21tZW50cyBpbiBBZGlhbnR1bSBjb2RlIG1lbnRpb25zIGl0IHRvbywgc28gSSBkbyBu
b3QgdGhpbmsgaXQNCj4ganVzdCBoaWRlcyB0aGUgY29ycnVwdGlvbiBhZnRlciB0aGUgc3RydWN0
LiBTZWVtcyBsaWtlIGFub3RoZXIgbWFnaWMgcmVxdWlyZW1lbnQNCj4gaW4gY3J5cHRvIEFQSSA6
LSkNCj4gDQo+IFRoaXMgY2h1bmsgaXMgZW5vdWdoIHRvIGZpeCBpdCBmb3IgbWU6DQo+IA0KPiAt
LS0gYS9jcnlwdG8veHRzLmMNCj4gKysrIGIvY3J5cHRvL3h0cy5jDQo+IEBAIC0zMyw4ICszMyw4
IEBAIHN0cnVjdCB4dHNfaW5zdGFuY2VfY3R4IHsNCj4gDQo+ICBzdHJ1Y3QgcmN0eCB7DQo+ICAg
ICAgICAgbGUxMjggdCwgdGN1cjsNCj4gLSAgICAgICBzdHJ1Y3Qgc2tjaXBoZXJfcmVxdWVzdCBz
dWJyZXE7DQo+ICAgICAgICAgaW50IHJlbV9ieXRlcywgaXNfZW5jcnlwdDsNCj4gKyAgICAgICBz
dHJ1Y3Qgc2tjaXBoZXJfcmVxdWVzdCBzdWJyZXE7DQo+ICB9Ow0KPiANCj4gV2hpbGUgYXQgaXQs
IHNob3VsZG4ndCBiZSBpc19lbmNyeXB0IGJvb2w/DQo+IA0KPiBUaGFua3MsDQo+IE1pbGFuDQpX
aGlsZSBJIGRvIHVuZGVyc3RhbmQgaG93IHRoYXQgcHJldmVudHMgY29ycnVwdGlvbiBvZiByZW1f
Ynl0ZXMgYW5kIA0KaXNfZW5jcnlwdCwgZG9lc24ndCB0aGF0IGp1c3QgKmhpZGUqIHRoZSBpc3N1
ZT8NCg0KVGhlIG1lbW9yeSBiZXlvbmQgdGhlIGVuZCBvZiB0aGUgcmN0eCBzdHJ1Y3QgaXMgbm90
IGFsbG9jYXRlZCBhcyBmYXINCmFzIEkgY2FuIHRlbGwsIHNvIGhvdyBjYW4geW91IGxlZ2FsbHkg
d3JpdGUgdGhlcmU/DQoNCkkgaG9wZSBzb21lb25lIGNhbiBleHBsYWluIHRoaXMgdG8gbWUuDQoN
ClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0
aS1Qcm90b2NvbCBFbmdpbmVzIEAgVmVyaW1hdHJpeA0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg==
