Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34B7C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 14:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFBB625BC1
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 14:54:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="Lr2Jg3kU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbfE3OyA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 10:54:00 -0400
Received: from mail-eopbgr30124.outbound.protection.outlook.com ([40.107.3.124]:45771
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727532AbfE3OyA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 10:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ghuhcCq9PH9Pe/HujctKC0Qm3qBIrl6+xaLwSbM7iI=;
 b=Lr2Jg3kUa6o6/Mv8hwo24lCe3pFiSmlvS+prNMK3KHUm6Iw4rkgiE8q2gyjEjFxjHf0fwXUdFrMNMycLi2ufl10h+hjR6fMK5zM0zMiMTr44bcKLALPah3OOdmxTku2h+ZNIFGgo/V48rLejntnDsWXcL9+vt4T4atNQqhMeQY8=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2376.eurprd09.prod.outlook.com (20.177.113.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Thu, 30 May 2019 14:53:56 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 14:53:56 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVFkGC+Z078hijGEOmhwjdTCZ6EaaDsZ8AgAAAcYCAAAkRAIAAAGAAgAAAoYCAAANzkA==
Date:   Thu, 30 May 2019 14:53:56 +0000
Message-ID: <AM6PR09MB3523A665C9D9334659F05F90D2180@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com>
 <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au>
 <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <CAKv+Gu-jTWQP0Zp=QpuzX41v8Eb5Bvd0O9ajwSnFkDO-ijBf_A@mail.gmail.com>
 <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
 <20190530142734.qlhgzeal22zxfhk5@gondor.apana.org.au>
 <CAKv+Gu8jJQCZwiHFORUJUzRaAizWzBQ95EAgYe36sFrcvzb6vg@mail.gmail.com>
 <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com>
In-Reply-To: <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 696cdddd-8a93-40bb-7245-08d6e50ea3f4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB2376;
x-ms-traffictypediagnostic: AM6PR09MB2376:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB237635EDCAD716C043934E14D2180@AM6PR09MB2376.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(396003)(376002)(136003)(346002)(366004)(189003)(199004)(476003)(446003)(76116006)(11346002)(6116002)(86362001)(68736007)(4326008)(6246003)(5660300002)(229853002)(8676002)(55016002)(71190400001)(81156014)(8936002)(74316002)(52536014)(7416002)(3846002)(81166006)(25786009)(66446008)(486006)(6506007)(33656002)(66066001)(316002)(71200400001)(54906003)(110136005)(102836004)(14444005)(2906002)(305945005)(186003)(66946007)(66556008)(73956011)(64756008)(7696005)(6436002)(66476007)(9686003)(26005)(15974865002)(7736002)(76176011)(14454004)(99286004)(478600001)(256004)(53936002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2376;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: W1WM/8KdXhKZ32+z97+dUoFmZUqd0dQ6kngPEEQou4RK1PkrEyhSHh3mseQIbT6x9YmhZCNUmvF8//xdq8Kgr006dCkz70Y2wFPQdnBeigchBFD07TWif2tzlg/6kvBx6FhqiZKEB/2opYHd8QUhcCsFDdxfZXNb8/jYc9XSRtrpuVQhM/FBycIov3Zm3UxCSOJ0r00/8ibvtxJgNPWS7wlQOPYuF6xck3IO/mcVbSUH51Kp1Pk7J6mVud4f41JRsWG145l9l56G+6sx/4QPu4rbzjpdIdzauMBivzPirxiUqU0M2T/JIDM6FSTa41dIBByDsAgX23cXDmqA7UZ/W0JdhxSCuueDYb008X/1Ox9y5gFHpAN6SJlVbD1p65DWxBlOJigmePNtwEMiANVkGQenfJrqwET16P1WLDAncpY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 696cdddd-8a93-40bb-7245-08d6e50ea3f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 14:53:56.0763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2376
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiANCj4gVGhpcyBtaWdodCB3b3JrOg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRv
L2NhYW0vY2FhbWFsZy5jIGIvZHJpdmVycy9jcnlwdG8vY2FhbS9jYWFtYWxnLmMNCj4gaW5kZXgg
YzBlY2U0NGYzMDNiLi4zZDMxM2QyYTI3OWEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRv
L2NhYW0vY2FhbWFsZy5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NhYW0vY2FhbWFsZy5jDQo+
IEBAIC0xNjYxLDcgKzE2NjEsOCBAQCBzdGF0aWMgaW50IGFlYWRfZGVjcnlwdChzdHJ1Y3QgYWVh
ZF9yZXF1ZXN0ICpyZXEpDQo+ICAgKiBhbGxvY2F0ZSBhbmQgbWFwIHRoZSBza2NpcGhlciBleHRl
bmRlZCBkZXNjcmlwdG9yIGZvciBza2NpcGhlcg0KPiAgICovDQo+ICBzdGF0aWMgc3RydWN0IHNr
Y2lwaGVyX2VkZXNjICpza2NpcGhlcl9lZGVzY19hbGxvYyhzdHJ1Y3QNCj4gc2tjaXBoZXJfcmVx
dWVzdCAqcmVxLA0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBpbnQgZGVzY19ieXRlcykNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgaW50IGRlc2NfYnl0ZXMsDQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHU4IGNvbnN0ICppbnB1dF9pdikNCj4g
IHsNCj4gICAgICAgICBzdHJ1Y3QgY3J5cHRvX3NrY2lwaGVyICpza2NpcGhlciA9IGNyeXB0b19z
a2NpcGhlcl9yZXF0Zm0ocmVxKTsNCj4gICAgICAgICBzdHJ1Y3QgY2FhbV9jdHggKmN0eCA9IGNy
eXB0b19za2NpcGhlcl9jdHgoc2tjaXBoZXIpOw0KPiBAQCAtMTc0NSw3ICsxNzQ2LDcgQEAgc3Rh
dGljIHN0cnVjdCBza2NpcGhlcl9lZGVzYw0KPiAqc2tjaXBoZXJfZWRlc2NfYWxsb2Moc3RydWN0
IHNrY2lwaGVyX3JlcXVlc3QgKnJlcSwNCj4gICAgICAgICAvKiBNYWtlIHN1cmUgSVYgaXMgbG9j
YXRlZCBpbiBhIERNQWFibGUgYXJlYSAqLw0KPiAgICAgICAgIGlmIChpdnNpemUpIHsNCj4gICAg
ICAgICAgICAgICAgIGl2ID0gKHU4ICopZWRlc2MtPmh3X2Rlc2MgKyBkZXNjX2J5dGVzICsgc2Vj
NF9zZ19ieXRlczsNCj4gLSAgICAgICAgICAgICAgIG1lbWNweShpdiwgcmVxLT5pdiwgaXZzaXpl
KTsNCj4gKyAgICAgICAgICAgICAgIG1lbWNweShpdiwgaW5wdXRfaXYsIGl2c2l6ZSk7DQo+IA0K
PiAgICAgICAgICAgICAgICAgaXZfZG1hID0gZG1hX21hcF9zaW5nbGUoanJkZXYsIGl2LCBpdnNp
emUsIERNQV9UT19ERVZJQ0UpOw0KPiAgICAgICAgICAgICAgICAgaWYgKGRtYV9tYXBwaW5nX2Vy
cm9yKGpyZGV2LCBpdl9kbWEpKSB7DQo+IEBAIC0xODAxLDcgKzE4MDIsOCBAQCBzdGF0aWMgaW50
IHNrY2lwaGVyX2VuY3J5cHQoc3RydWN0IHNrY2lwaGVyX3JlcXVlc3QNCj4gKnJlcSkNCj4gICAg
ICAgICBpbnQgcmV0ID0gMDsNCj4gDQo+ICAgICAgICAgLyogYWxsb2NhdGUgZXh0ZW5kZWQgZGVz
Y3JpcHRvciAqLw0KPiAtICAgICAgIGVkZXNjID0gc2tjaXBoZXJfZWRlc2NfYWxsb2MocmVxLCBE
RVNDX0pPQl9JT19MRU4gKiBDQUFNX0NNRF9TWik7DQo+ICsgICAgICAgZWRlc2MgPSBza2NpcGhl
cl9lZGVzY19hbGxvYyhyZXEsIERFU0NfSk9CX0lPX0xFTiAqIENBQU1fQ01EX1NaLA0KPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmVxLT5pdik7DQo+ICAgICAgICAgaWYg
KElTX0VSUihlZGVzYykpDQo+ICAgICAgICAgICAgICAgICByZXR1cm4gUFRSX0VSUihlZGVzYyk7
DQo+IA0KPiBAQCAtMTgzMiwxMyArMTgzNCwxMSBAQCBzdGF0aWMgaW50IHNrY2lwaGVyX2RlY3J5
cHQoc3RydWN0DQo+IHNrY2lwaGVyX3JlcXVlc3QgKnJlcSkNCj4gICAgICAgICBzdHJ1Y3QgY2Fh
bV9jdHggKmN0eCA9IGNyeXB0b19za2NpcGhlcl9jdHgoc2tjaXBoZXIpOw0KPiAgICAgICAgIGlu
dCBpdnNpemUgPSBjcnlwdG9fc2tjaXBoZXJfaXZzaXplKHNrY2lwaGVyKTsNCj4gICAgICAgICBz
dHJ1Y3QgZGV2aWNlICpqcmRldiA9IGN0eC0+anJkZXY7DQo+ICsgICAgICAgdTggaW5faXZbQUVT
X0JMT0NLX1NJWkVdOw0KPiAgICAgICAgIHUzMiAqZGVzYzsNCj4gICAgICAgICBpbnQgcmV0ID0g
MDsNCj4gDQo+IC0gICAgICAgLyogYWxsb2NhdGUgZXh0ZW5kZWQgZGVzY3JpcHRvciAqLw0KPiAt
ICAgICAgIGVkZXNjID0gc2tjaXBoZXJfZWRlc2NfYWxsb2MocmVxLCBERVNDX0pPQl9JT19MRU4g
KiBDQUFNX0NNRF9TWik7DQo+IC0gICAgICAgaWYgKElTX0VSUihlZGVzYykpDQo+IC0gICAgICAg
ICAgICAgICByZXR1cm4gUFRSX0VSUihlZGVzYyk7DQo+ICsgICAgICAgbWVtY3B5KGluX2l2LCBy
ZXEtPml2LCBpdnNpemUpOw0KPiANCj4gICAgICAgICAvKg0KPiAgICAgICAgICAqIFRoZSBjcnlw
dG8gQVBJIGV4cGVjdHMgdXMgdG8gc2V0IHRoZSBJViAocmVxLT5pdikgdG8gdGhlIGxhc3QNCj4g
QEAgLTE4NDgsNiArMTg0OCwxMSBAQCBzdGF0aWMgaW50IHNrY2lwaGVyX2RlY3J5cHQoc3RydWN0
IHNrY2lwaGVyX3JlcXVlc3QNCj4gKnJlcSkNCj4gICAgICAgICAgICAgICAgIHNjYXR0ZXJ3YWxr
X21hcF9hbmRfY29weShyZXEtPml2LCByZXEtPnNyYywgcmVxLT5jcnlwdGxlbg0KPiAtDQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaXZzaXplLCBpdnNpemUsIDAp
Ow0KPiANCj4gKyAgICAgICAvKiBhbGxvY2F0ZSBleHRlbmRlZCBkZXNjcmlwdG9yICovDQo+ICsg
ICAgICAgZWRlc2MgPSBza2NpcGhlcl9lZGVzY19hbGxvYyhyZXEsIERFU0NfSk9CX0lPX0xFTiAq
IENBQU1fQ01EX1NaLA0KPiBpbl9pdik7DQo+ICsgICAgICAgaWYgKElTX0VSUihlZGVzYykpDQo+
ICsgICAgICAgICAgICAgICByZXR1cm4gUFRSX0VSUihlZGVzYyk7DQo+ICsNCj4gICAgICAgICAv
KiBDcmVhdGUgYW5kIHN1Ym1pdCBqb2IgZGVzY3JpcHRvciovDQo+ICAgICAgICAgaW5pdF9za2Np
cGhlcl9qb2IocmVxLCBlZGVzYywgZmFsc2UpOw0KPiAgICAgICAgIGRlc2MgPSBlZGVzYy0+aHdf
ZGVzYzsNCg0KSW50ZXJlc3RpbmcuIFRoaXMgZGlzY3Vzc2lvbiBtYWRlIG1lIHJlZXZhbHVhdGUg
bXkgb3duIGltcGxlbWVudGF0aW9uLg0KDQpGaXJzdCB0aGluZyBJIHJlYWxpc2VkIGlzIHRoYXQg
SSAqYW0qIGN1cnJlbnRseSBkb2luZyB0aGUgSVYgY29weWluZyB3aXRoDQp0aGUgZGF0YSBidWZm
ZXIgbWFwcGVkIGZvciBETUEgLi4uIElmIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHkgdGhhdCBtYXkg
YmUgYQ0KYmFkIGlkZWEgb24gc29tZSBzeXN0ZW1zPyBJIHdoaWNoIGNhc2UgSSB3aWxsIG5lZWQg
dG8gZG8gbXkgY29weSBlYXJsaWVyLg0KDQpTZWNvbmQgdGhpbmcgaXMgdGhlIGFib3ZlIGltcGxl
bWVudGF0aW9uIG1hZGUgbWUgcmVhbGlzZSBJIGRvbid0IG5lZWQgdG8NCmJ1ZmZlciB0aGUgSVYg
YXMgcGFydCBvZiB0aGUgc2tjaXBoZXJfcmVxdWVzdF9jdHgsIEkgY2FuIGp1c3QgY29weSB0aGUN
Cm9yaWdpbmFsIHJlcS0+aXYgdG8gc29tZSBsb2NhbCB2YXJpYWJsZSwgcGFzcyBhIHBvaW50ZXIg
dG8gdGhhdCBhbG9uZyBhbmQNCnRoZW4gb3ZlcndyaXRlIHJlcS0+aXYgZGlyZWN0bHkuIE1vcmUg
ZWxlZ2FudCBhbmQgaG9wZWZ1bGx5IGFsc28gbW9yZQ0KZWZmaWNpZW50IC4uLg0KDQpSZWdhcmRz
LA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9j
b2wgRW5naW5lcw0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg0KDQo=
