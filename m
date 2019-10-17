Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA6EFA372A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 16:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 162142089C
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 16:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="rk+8YShq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730526AbfJQQRU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 12:17:20 -0400
Received: from mail-eopbgr770077.outbound.protection.outlook.com ([40.107.77.77]:20963
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390456AbfJQQRU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 12:17:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hf3UX/fb2ouH2flX6U8nRhCJabuWfyksupWA0qZm3m4L+vxwNNLvAzffL2Uw22kIOXTLo/c4565j1VGDE5xTWBI7/xmGb1n+sjQyugeOUyoK+ZGK+ORAOYt3o6pCZbE8cl/+A2poRc8Zj6zBbUfly5MJIDroruzKhBLQnrlF7SlG/ATrEDsg7zH9LFjIxHnbjv/bYr5nGIEBPu9ixIF+Yn5q4YtPbwatxbBFWfpk/+6r3JOJ7ccrEhLaDfL0NgQGj97Q29K7Ml34hcrvc6SWQNgKXjCkfe2h2aqL9GTcsyRkYUD6RtsHgEiZFTUbOOvpdmxpM0yKQYfnM1eOkCRkXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sl0i1vw0RlnDS189he8rlmhDMj+gdSws32s9AkryLa4=;
 b=WND5q5tM9vsMIdYYLEk9gQ3KCOW5nVMGPC21Tmh7NLML4zgdHqk6OsbkGuNa9cQ+imBHZRYRIDjWGrRUuzP8Vf3TVtaS3d8jSFCCdWVGsFXbNoMFP+OSVFtwX6yZElV9qn6kD/ETiwagZghvwmTDxFKON7kixXqJ8JwBM5AE083+UXPR/IvEDru0V6Me6SocGHF+po/q8l8oHncN7zZrzAFu7QbQkw5txGnRm7MaeY7nuSguhm5oK4rBwSMaXdD0ugYeUO7WH9x/gcN3263gILamGrnDwV98Hiwap0f2S2tkTQNoI/yykkOuMTGGWomXavNfnAeQEc3+Wb099nA6AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sl0i1vw0RlnDS189he8rlmhDMj+gdSws32s9AkryLa4=;
 b=rk+8YShq0OGUlB2gCJI+MnuCHNmp8gNSg9bpNlnFtIejuWwhu5vsjl0dXizRTvKbBiQqvSQOvFLPuZ+2xHVYJD5FU9ZWHvSdMQKYLslpugEvz6dS2FIlJBVdFgOCKUzaGysa+v06S3g8LqN5xUkhRTusywvudZetC6uJ4Jx6f5A=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2735.namprd20.prod.outlook.com (20.178.253.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Thu, 17 Oct 2019 16:16:36 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 16:16:36 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
CC:     Antoine Tenart <antoine.tenart@free-electrons.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
Subject: RE: [PATCH -next] crypto: inside-secure: fix build error for
 safexcel_hash.c
Thread-Topic: [PATCH -next] crypto: inside-secure: fix build error for
 safexcel_hash.c
Thread-Index: AQHVfrlDlb0ASmLnBEKYeB44g9rLg6dfDtnA
Date:   Thu, 17 Oct 2019 16:16:36 +0000
Message-ID: <MN2PR20MB29735D9F670B9C8C13B0FA00CA6D0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <6670b7d4-224c-cfd8-2cba-96a60ea98d1c@infradead.org>
In-Reply-To: <6670b7d4-224c-cfd8-2cba-96a60ea98d1c@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47b14270-c851-456b-e691-08d7531d6281
x-ms-traffictypediagnostic: MN2PR20MB2735:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB27353BFAB22AA74351A6BF3ECA6D0@MN2PR20MB2735.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(396003)(39850400004)(346002)(199004)(189003)(13464003)(71200400001)(11346002)(76116006)(71190400001)(74316002)(66476007)(66556008)(8676002)(66446008)(7736002)(305945005)(66946007)(64756008)(256004)(8936002)(6116002)(3846002)(446003)(486006)(81156014)(81166006)(476003)(2906002)(186003)(229853002)(5660300002)(86362001)(4326008)(54906003)(33656002)(55016002)(6436002)(14454004)(99286004)(9686003)(25786009)(102836004)(26005)(478600001)(7696005)(76176011)(15974865002)(316002)(6506007)(53546011)(110136005)(52536014)(66066001)(6246003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2735;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5X++m26RTp1nWIcBTF1mz2la8eGsTEXlFf0XHp3FEZO/SfzvSBuMyuQspkjOZeRZ+gKKGoVWaJ95H61mIQdfMlb+j0cIr8SiYt58MNrTG2Ely6yCh690XRA+QtKp1mtFQfLj4vjaC095XcWoa9M4giyTEXFWnTZBNOwIBzX3724fOngAYHwfY35V1bKk6fSL+Z4B91c/i0+tjxILS4w2AFeFOpw7yVKNoUO+DZya2Ixowpz4UyZUPY6PfsxKb7fyXt9HiC4Iiqi/vSdxmFWwuzyfcmBqBTH4+1xyvuSA8mmBCQrFAC6Ia/AgiGm8LpWWLYSXemd6/+KvITYTHAD9FWvFv7q1pxHQm1ZlXsO2EAPmk7sgRuASwrSpbv4rzj6DedY+72z5xxDsF46scHrwwPdlbyuU4feAKd3fe+dg7Vk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b14270-c851-456b-e691-08d7531d6281
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 16:16:36.6952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PZsfhBjgFkNO2nwlBzeCsd0cz2jHjPU5tJt57sf5oELBKYkMrnZeBiAz8fnc+v1DIs64oBKWNW42hMEKx7n9YAU5m3O9Ryy8mg3//IWVpbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2735
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYgT2YNCj4gUmFuZHkgRHVubGFwDQo+IFNlbnQ6IFdlZG5lc2RheSwgT2N0b2JlciA5LCAy
MDE5IDU6NTAgUE0NCj4gVG86IExLTUwgPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBM
aW51eCBDcnlwdG8gTWFpbGluZyBMaXN0IDxsaW51eC0NCj4gY3J5cHRvQHZnZXIua2VybmVsLm9y
Zz4NCj4gQ2M6IEFudG9pbmUgVGVuYXJ0IDxhbnRvaW5lLnRlbmFydEBmcmVlLWVsZWN0cm9ucy5j
b20+OyBIZXJiZXJ0IFh1DQo+IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBEYXZpZCBN
aWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IFN1YmplY3Q6IFtQQVRDSCAtbmV4dF0gY3J5
cHRvOiBpbnNpZGUtc2VjdXJlOiBmaXggYnVpbGQgZXJyb3IgZm9yIHNhZmV4Y2VsX2hhc2guYw0K
PiANCj4gRnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+DQo+IA0KPiBz
YWZleGNlbF9oYXNoLmMgKENSWVBUT19ERVZfU0FGRVhDRUwpIG5lZWRzIHRvIHNlbGVjdCBDUllQ
VE9fU00zLg0KPiANCj4gRml4ZXMgdGhpcyBidWlsZCBlcnJvcjoNCj4gDQo+IHNhZmV4Y2VsX2hh
c2guYzooLnRleHQrMHgxYjE3KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgc20zX3plcm9fbWVz
c2FnZV9oYXNoJw0KPiANCj4gRml4ZXM6IDFiNDRjNWE2MGMxMyAoImNyeXB0bzogaW5zaWRlLXNl
Y3VyZSAtIGFkZCBTYWZlWGNlbCBFSVAxOTcgY3J5cHRvIGVuZ2luZSBkcml2ZXIiKQ0KPiBTaWdu
ZWQtb2ZmLWJ5OiBSYW5keSBEdW5sYXAgPHJkdW5sYXBAaW5mcmFkZWFkLm9yZz4NCj4gQ2M6IEFu
dG9pbmUgVGVuYXJ0IDxhbnRvaW5lLnRlbmFydEBmcmVlLWVsZWN0cm9ucy5jb20+DQo+IENjOiBI
ZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+IENjOiAiRGF2aWQgUy4g
TWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gQ2M6IGxpbnV4LWNyeXB0b0B2Z2VyLmtl
cm5lbC5vcmcNCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9LY29uZmlnIHwgICAgMSArDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IC0tLSBsaW51eC1uZXh0LTIwMTkx
MDA5Lm9yaWcvZHJpdmVycy9jcnlwdG8vS2NvbmZpZw0KPiArKysgbGludXgtbmV4dC0yMDE5MTAw
OS9kcml2ZXJzL2NyeXB0by9LY29uZmlnDQo+IEBAIC03NTEsNiArNzUxLDcgQEAgY29uZmlnIENS
WVBUT19ERVZfU0FGRVhDRUwNCj4gIAlzZWxlY3QgQ1JZUFRPX1NIQTUxMg0KPiAgCXNlbGVjdCBD
UllQVE9fQ0hBQ0hBMjBQT0xZMTMwNQ0KPiAgCXNlbGVjdCBDUllQVE9fU0hBMw0KPiArCXNlbGVj
dCBDUllQVE9fU00zDQo+ICAJaGVscA0KPiAgCSAgVGhpcyBkcml2ZXIgaW50ZXJmYWNlcyB3aXRo
IHRoZSBTYWZlWGNlbCBFSVAtOTcgYW5kIEVJUC0xOTcgY3J5cHRvZ3JhcGhpYw0KPiAgCSAgZW5n
aW5lcyBkZXNpZ25lZCBieSBJbnNpZGUgU2VjdXJlLiBJdCBjdXJyZW50bHkgYWNjZWxlcmF0ZXMg
REVTLCAzREVTIGFuZA0KPiANCg0KSSdtIHNwaW5uaW5nIGEgcGF0Y2ggdG8gZml4IHRoaXMgd2l0
aG91dCBoYXZpbmcgdG8NCmFjdHVhbGx5IGJ1aWxkIGluIHRoZSBTTTMgbW9kdWxlLiBTbyBOQUNL
IG9uIHRoaXMgcGF0Y2guDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24g
SVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAgVmVyaW1hdHJpeA0Kd3d3Lmlu
c2lkZXNlY3VyZS5jb20NCg==
