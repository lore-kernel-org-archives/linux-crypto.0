Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B72C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 09:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C3F0207FA
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 09:02:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="TEu0InnZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbfKHJCe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 04:02:34 -0500
Received: from mail-eopbgr790052.outbound.protection.outlook.com ([40.107.79.52]:43058
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728513AbfKHJCe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 04:02:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=He5LD8KwLOYLC7tm2LBkA60SdjWnivSf4LuBAm7W0GpZqLvZ4KYQlyLwPW4Zd0QRXU8s13GJRrfBXrFUl71SZexlOhgO7deELoY1sbtf00qar3bbuP+dCMmXDh6m7hBorZzEqFUTEmGN1wqlViHFkkFwLctte44XDF6eFOaer0dyB8OgZkKwrEv7joN/4E1xG/oA9nPbuWxDyX1Eqm6miVBMoiI5M4c9axMkGpUHmBN3evjhzrU0FEwITDx9+oJpJwz9B9hk01bdfS4Fu/7GiOtLCl7ZNNN+rFXYo5Kj4g9r5VJi++RzgvSPvE9HLRSApAz9LxCZ2dSA3HFnh/INWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JR50DWQFnHf3j5LqfGDEJ+K+cskbyPaACS1iRr6aBbg=;
 b=HFVthD1DXK1uwVjy8VBkiA/wq52u2ZGvpJohGCBQ89CnZVBaGrMsthWU2bo014cooUdBzEN/DoolGOrhTFFHj+fOAkwi5RtHJtx/VfSa/vGvALuo97C51E3EjUAimSxSTugyp9+sjH9N8ylie9hOxVKu+4uhXMGBRG1qEi+EexvEoVtuw5BdCmwu1u1j5SLQVcRwUswrN1dWbcIN2DbjWSIKUndeo5Ss3yalrQjuO88PbOxZcy7ZwdbYfr911k8suP8ZFBUfIgGM4Ur6C7bM3+28sqOckbRpg6Q+fwc2X+m/I85YTcT7tDFtpcsYPtaakCqVKQVKuvTbnl2iDdQPcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JR50DWQFnHf3j5LqfGDEJ+K+cskbyPaACS1iRr6aBbg=;
 b=TEu0InnZXx9Ib0RE/0Dzp3dTYRjoY5+gi/BZM7xUYSJBeWJ8MCZX8P18x6Ku5ffhTYHqvzkF4bZh7rKMXtQ4+u1ZsJGTSMdm93oHtzskNTtF4hztb2lp3MFbfCf/hh9bMe4Q36GNXDTYKy3nE+0ne18vhvZIpwdnMt7+YW4I0e0=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2782.namprd20.prod.outlook.com (20.178.252.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 09:02:30 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::18b4:f48a:593b:eac9]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::18b4:f48a:593b:eac9%3]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 09:02:30 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCHv3] crypto: inside-secure - Fixed authenc w/ (3)DES fails
 on Macchiatobin
Thread-Topic: [PATCHv3] crypto: inside-secure - Fixed authenc w/ (3)DES fails
 on Macchiatobin
Thread-Index: AQHVlhKC2naCkqPq7kubgQ2BLcz+YKeA+QSAgAAAxMA=
Date:   Fri, 8 Nov 2019 09:02:30 +0000
Message-ID: <MN2PR20MB2973987E78F4A4F6A63C430ACA7B0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1573203234-8428-1-git-send-email-pvanleeuwen@verimatrix.com>
 <CAKv+Gu9SahVL815i+8_f_fQPM2JP=3rpz3GLFhxLaAUrhz3HWA@mail.gmail.com>
In-Reply-To: <CAKv+Gu9SahVL815i+8_f_fQPM2JP=3rpz3GLFhxLaAUrhz3HWA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93e62c43-5661-43b0-af6c-08d7642a629f
x-ms-traffictypediagnostic: MN2PR20MB2782:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2782AEA9E18F0F8A9F551D21CA7B0@MN2PR20MB2782.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:506;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(136003)(346002)(199004)(13464003)(54534003)(189003)(256004)(26005)(53546011)(508600001)(86362001)(54906003)(7696005)(15974865002)(3846002)(4326008)(6116002)(99286004)(9686003)(14454004)(6436002)(55016002)(2906002)(76176011)(71190400001)(71200400001)(6246003)(229853002)(102836004)(52536014)(8936002)(66946007)(186003)(8676002)(76116006)(74316002)(66066001)(5660300002)(25786009)(11346002)(110136005)(66446008)(33656002)(476003)(81166006)(305945005)(446003)(81156014)(6506007)(486006)(14444005)(64756008)(66476007)(7736002)(66556008)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2782;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1hMHaJlj2hqYkDfISRiX1iU9RKRjwrwaUFDaoAyyOs3RIJ4wiz8g0cXTxYZRwReiTHU9NN8d7n9fhvyclUUARHAwHVyuLtOogqnFR0hXFesnouOsHNveKYeXM6kjokCTKVMfurH6+kNdiF5BfzfEoRSAWM83QHsVMUs/3mGlGhfDMwsK5sqpk0RQZgE00eVWBCoFxhPxBz8uo87Bhp4aj1YH5qHqz9hT/UYK/gh+YvN6CTPlVayK+7ATX4SyGIOfQf21gL5Q1lHGQtGLspcmNlchsAb8Va98WRWfVW+8rvl4Jtmaf8tjI+BeuAJc4NfZdUum2aG7BooflxUJY2BlEOybjiHRBygdHv3VMy3gZ5yXRPG5wLzVjtDi7ODoyvvY9BcuLuX03ZmWPHh/heYidaCo7YucTjrXWvBih2+S8fnnoRiGAdhfZc9CtUiEhYojrTW1e+v88ZZnX4YteEQksu8DSk02Bo8BbgYnbQu/nes=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e62c43-5661-43b0-af6c-08d7642a629f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 09:02:30.0401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: avSSYRa4vZrdzloN2hChGK8P+JI/8AQXwNjynXZga/p8AfrXKMQeuV68ZEJN5FCQmpIlBgRl2gXy8P9/5CWnn/gwD43hToe2eGhguR8XHjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2782
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJkIEJpZXNoZXV2ZWwg
PGFyZC5iaWVzaGV1dmVsQGxpbmFyby5vcmc+DQo+IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgOCwg
MjAxOSA5OjU4IEFNDQo+IFRvOiBQYXNjYWwgdmFuIExlZXV3ZW4gPHBhc2NhbHZhbmxAZ21haWwu
Y29tPg0KPiBDYzogb3BlbiBsaXN0OkhBUkRXQVJFIFJBTkRPTSBOVU1CRVIgR0VORVJBVE9SIENP
UkUgPGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc+Ow0KPiBBbnRvaW5lIFRlbmFydCA8YW50
b2luZS50ZW5hcnRAYm9vdGxpbi5jb20+OyBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFu
YS5vcmcuYXU+Ow0KPiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBQYXNj
YWwgVmFuIExlZXV3ZW4gPHB2YW5sZWV1d2VuQHZlcmltYXRyaXguY29tPg0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIdjNdIGNyeXB0bzogaW5zaWRlLXNlY3VyZSAtIEZpeGVkIGF1dGhlbmMgdy8gKDMp
REVTIGZhaWxzIG9uDQo+IE1hY2NoaWF0b2Jpbg0KPiANCj4gT24gRnJpLCA4IE5vdiAyMDE5IGF0
IDA5OjU3LCBQYXNjYWwgdmFuIExlZXV3ZW4gPHBhc2NhbHZhbmxAZ21haWwuY29tPiB3cm90ZToN
Cj4gPg0KPiA+IEZpeGVkIDIgY29weS1wYXN0ZSBtaXN0YWtlcyBpbiB0aGUgY29tbWl0IG1lbnRp
b25lZCBiZWxvdyB0aGF0IGNhdXNlZA0KPiA+IGF1dGhlbmMgdy8gKDMpREVTIHRvIGNvbnNpc3Rl
bnRseSBmYWlsIG9uIE1hY2NoaWF0b2JpbiAoYnV0IHN0cmFuZ2VseQ0KPiA+IHdvcmsgZmluZSBv
biB4ODYrRlBHQT8/KS4NCj4gPiBOb3cgZnVsbHkgdGVzdGVkIG9uIGJvdGggcGxhdGZvcm1zLg0K
PiA+DQo+ID4gY2hhbmdlcyBzaW5jZSB2MToNCj4gPiAtIGFkZGVkIEZpeGVzOiB0YWcNCj4gPg0K
PiA+IGNoYW5nZXMgc2luY2UgdjI6DQo+ID4gLSBtb3ZlZCBGaXhlczogdGFnIGRvd24gbmVhciBv
dGhlciB0YWdzDQo+ID4NCj4gDQo+IFBsZWFzZSBwdXQgdGhlIGNoYW5nZWxvZyBiZWxvdyB0aGUg
LS0tDQo+IEl0IGRvZXMgbm90IGJlbG9uZyBpbiB0aGUgY29tbWl0IGxvZyBpdHNlbGYuDQo+IA0K
UmVhbGx5PyBJJ3ZlIGFsd2F5cyBkb25lIGl0IGxpa2UgdGhhdCAoanVzdCBjaGVja2VkIHNvbWUg
b2YgbXkgcHJldmlvdXMNCnBhdGNoZXMpIGFuZCB0aGlzIGlzIHRoZSBmaXJzdCB0aW1lIHNvbWVv
bmUgY29tcGxhaW5zIGFib3V0IGl0IC4uLg0KDQo+IA0KPiA+IEZpeGVzOiAxM2ExYmI5M2Y3YjFj
OSAoImNyeXB0bzogaW5zaWRlLXNlY3VyZSAtIEZpeGVkIHdhcm5pbmdzIG9uDQo+ID4gaW5jb25z
aXN0ZW50IGJ5dGUgb3JkZXIgaGFuZGxpbmciKQ0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogUGFz
Y2FsIHZhbiBMZWV1d2VuIDxwdmFubGVldXdlbkB2ZXJpbWF0cml4LmNvbT4NCj4gPiAtLS0NCj4g
PiAgZHJpdmVycy9jcnlwdG8vaW5zaWRlLXNlY3VyZS9zYWZleGNlbF9jaXBoZXIuYyB8IDUgKysr
LS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3NhZmV4
Y2VsX2NpcGhlci5jIGIvZHJpdmVycy9jcnlwdG8vaW5zaWRlLQ0KPiBzZWN1cmUvc2FmZXhjZWxf
Y2lwaGVyLmMNCj4gPiBpbmRleCA5OGY5ZmM2Li5jMDI5OTU2IDEwMDY0NA0KPiA+IC0tLSBhL2Ry
aXZlcnMvY3J5cHRvL2luc2lkZS1zZWN1cmUvc2FmZXhjZWxfY2lwaGVyLmMNCj4gPiArKysgYi9k
cml2ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3NhZmV4Y2VsX2NpcGhlci5jDQo+ID4gQEAgLTQw
NSw3ICs0MDUsOCBAQCBzdGF0aWMgaW50IHNhZmV4Y2VsX2FlYWRfc2V0a2V5KHN0cnVjdCBjcnlw
dG9fYWVhZCAqY3RmbSwgY29uc3QgdTgNCj4gKmtleSwNCj4gPg0KPiA+ICAgICAgICAgaWYgKHBy
aXYtPmZsYWdzICYgRUlQMTk3X1RSQ19DQUNIRSAmJiBjdHgtPmJhc2UuY3R4cl9kbWEpIHsNCj4g
PiAgICAgICAgICAgICAgICAgZm9yIChpID0gMDsgaSA8IGtleXMuZW5ja2V5bGVuIC8gc2l6ZW9m
KHUzMik7IGkrKykgew0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIGlmIChsZTMyX3RvX2Nw
dShjdHgtPmtleVtpXSkgIT0gYWVzLmtleV9lbmNbaV0pIHsNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICBpZiAobGUzMl90b19jcHUoY3R4LT5rZXlbaV0pICE9DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICgodTMyICopa2V5cy5lbmNrZXkpW2ldKSB7DQo+ID4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBjdHgtPmJhc2UubmVlZHNfaW52ID0gdHJ1ZTsNCj4gPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgIH0NCj4gPiBAQCAtNDU5LDcgKzQ2MCw3IEBAIHN0YXRpYyBpbnQgc2FmZXhjZWxf
YWVhZF9zZXRrZXkoc3RydWN0IGNyeXB0b19hZWFkICpjdGZtLCBjb25zdCB1OA0KPiAqa2V5LA0K
PiA+DQo+ID4gICAgICAgICAvKiBOb3cgY29weSB0aGUga2V5cyBpbnRvIHRoZSBjb250ZXh0ICov
DQo+ID4gICAgICAgICBmb3IgKGkgPSAwOyBpIDwga2V5cy5lbmNrZXlsZW4gLyBzaXplb2YodTMy
KTsgaSsrKQ0KPiA+IC0gICAgICAgICAgICAgICBjdHgtPmtleVtpXSA9IGNwdV90b19sZTMyKGFl
cy5rZXlfZW5jW2ldKTsNCj4gPiArICAgICAgICAgICAgICAgY3R4LT5rZXlbaV0gPSBjcHVfdG9f
bGUzMigoKHUzMiAqKWtleXMuZW5ja2V5KVtpXSk7DQo+ID4gICAgICAgICBjdHgtPmtleV9sZW4g
PSBrZXlzLmVuY2tleWxlbjsNCj4gPg0KPiA+ICAgICAgICAgbWVtY3B5KGN0eC0+aXBhZCwgJmlz
dGF0ZS5zdGF0ZSwgY3R4LT5zdGF0ZV9zeik7DQo+ID4gLS0NCj4gPiAxLjguMy4xDQo+ID4NCg0K
DQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVs
dGktUHJvdG9jb2wgRW5naW5lcyBAIFZlcmltYXRyaXgNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQo=
