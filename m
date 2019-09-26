Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A12AC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 15:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 041D6206E0
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 15:06:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="RJuBv2QT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfIZPGn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 11:06:43 -0400
Received: from mail-eopbgr700076.outbound.protection.outlook.com ([40.107.70.76]:64256
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726029AbfIZPGm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 11:06:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHEGdwuOGDhJvmXPqlcdSMI3pSaO2sH/D5sOaPdiztXTEhMEOD20vqPlvJDPziWi32OL3ovTZWXVh9bQNCmumAOHbuSlO++vDBdCxst1cA2vvTawxzuwsWqh2+iVCXttMayRdfhB0bcRVt5q1VA+YTVxsa4VbUeqGVch+aLX5efP+tBrof7cWY8f6THVjsoqdPmsHwSZetULv1ea6ApVuw8TOc5dJFC0l7KrSXkj3uGXn5LOGXF3POjMgUXlF8ZRSy+mlNCiG9GEcf+1rOjtdzFzinXYfpNuhgbDopRmm8ITIdHso1xT0dFZDX8Bzh/FdLoaGa8DNSH5ceg/0GqOJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4/cO8Ml9Ih68xKH6jmGh9YTHqRZ/3q7N3JEAqC2zxU=;
 b=gFE2KNqudmFDpf5wDM+yr1IWB12TOge36X/dpDSEM2EyH3hJTLf7KxyafNIX42fDgGTEsrYF6GK6OzQMyn3g/SabddpwR8LaJ5Ob/d54XqKA9CDLf4h/il/ETbTsghXl8/D76w7YG7fUQBsVLVB5OUi+QXvMQh5RiPK1TkCDYyrcydWqP4qwbmc9H3d8bNHG2VWc+EpZNIHjMCWcU4jDzlTaAK0NDqOQfITy4jfDFwA+SN/H2xvpuBAmMX+Q2004Y0dDxuD3Ekk5s7pihE6tA78vINEBGwBJxDERhNDaMgyJDW0ame6MO5glb67sV7gazhcUa6eiZXjoNyZAw5zWmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4/cO8Ml9Ih68xKH6jmGh9YTHqRZ/3q7N3JEAqC2zxU=;
 b=RJuBv2QTA2VGmO02CEwD7awZ6Y30pUwxiZzj2X+gwJColkbrROvKkVs1Pd15sDzbmOagkIdsTnlePRqvaX+C+2MiYtce1uBFLPnowAjbKVtRqAA7xG18TbkXZTPITeF5PkVhdcnBk6gzB/hMIq58BbAjqKr6GV+GE/Zihi1Z7F8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2416.namprd20.prod.outlook.com (20.179.148.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Thu, 26 Sep 2019 15:04:59 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2305.017; Thu, 26 Sep 2019
 15:04:59 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: RE: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
Thread-Topic: [RFC PATCH 00/18] crypto: wireguard using the existing crypto
 API
Thread-Index: AQHVc7w6foOeRxVj+U6Yc++T56fqIac9qd4AgAA0kYCAAAbroIAADDgAgAAKvfCAABBXgIAAAPbg
Date:   Thu, 26 Sep 2019 15:04:59 +0000
Message-ID: <MN2PR20MB297301F34F3F69DADEC051C0CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
 <CAKv+Gu-RLRhwDahgvfvr2J9R+3GPM6vh4mjO73VcekusdzbuMA@mail.gmail.com>
 <MN2PR20MB29731267C4670FBD46D6C743CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_eNK1HFxTY379kpCpF8FQQFHEdC1Th=s5f7Fy3bebOjQ@mail.gmail.com>
 <MN2PR20MB297313B598D8EBBE06477B1CCA860@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-P58Uar2jUNdN5VvG1g45=V_+3FMXCD+0sFY7y2RPeag@mail.gmail.com>
In-Reply-To: <CAKv+Gu-P58Uar2jUNdN5VvG1g45=V_+3FMXCD+0sFY7y2RPeag@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f909802f-8196-4755-34f2-08d74292e684
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2416;
x-ms-traffictypediagnostic: MN2PR20MB2416:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB24167D0035124B37B2BB1364CA860@MN2PR20MB2416.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(13464003)(2906002)(11346002)(3846002)(81166006)(81156014)(99286004)(14444005)(478600001)(316002)(6506007)(6116002)(74316002)(54906003)(8676002)(186003)(6246003)(8936002)(256004)(102836004)(229853002)(66066001)(53546011)(305945005)(7736002)(14454004)(71200400001)(476003)(6916009)(9686003)(486006)(6436002)(76116006)(26005)(86362001)(66476007)(64756008)(66946007)(25786009)(66556008)(7416002)(76176011)(5660300002)(33656002)(7696005)(66446008)(446003)(4326008)(71190400001)(15974865002)(55016002)(52536014)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2416;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MLg/j3U/X1cqYz7Hvc3z5OiYQhOxTSVSAsH0QnWq7mg4kG56eWg5xUoBJP8q3D3Tw5ucFxac9kBZfj4f4G3AXCOhX/pTolt486v0qkcRw0cpa0biHWJD1svvmgB1P+x0XJ0rCSxncUzosVyN4YXgRNmZKfd6vEb7YTWi2n8g3S9EJN1npCaVsHtZpHucAcRe4mJ5MGAc9oLvYtE8Fq+rD4NQx3gXj+F06tVsrDoNm+xWquxOA6mheSgAb9vOk2oHVOihlzAc2iMjMHgmBQybacJ95BeBJDTn6CqtqTqkvvz3KQycdGWLkYrOH/2gqxhNG0gt2IVm4BsoXR2t0TCD18iNjk1qLrxZ6LyeX1lHCAhGKBEllD8PQUC2JUOnnuhMP4TQ3bk9Isz5fyV7SKSFU3lja6CeQD3TLoUIVvU3++E=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f909802f-8196-4755-34f2-08d74292e684
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 15:04:59.3718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 80Z402VxDLcehUJ6/rSs7Fk0wbl4t/Khu3Ze36BqYvkKp8eFNm47XOCaWR2iW4JlKKuc1AwJi3CtEmDU/nrD6lxQ7nbEF9uoNMjD8THuYck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2416
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYNCj4gT2YgQXJkIEJpZXNoZXV2ZWwNCj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAy
NiwgMjAxOSA0OjUzIFBNDQo+IFRvOiBQYXNjYWwgVmFuIExlZXV3ZW4gPHB2YW5sZWV1d2VuQHZl
cmltYXRyaXguY29tPg0KPiBDYzogSmFzb24gQS4gRG9uZW5mZWxkIDxKYXNvbkB6eDJjNC5jb20+
OyBMaW51eCBDcnlwdG8gTWFpbGluZyBMaXN0IDxsaW51eC0NCj4gY3J5cHRvQHZnZXIua2VybmVs
Lm9yZz47IGxpbnV4LWFybS1rZXJuZWwgPGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFk
Lm9yZz47DQo+IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IERhdmlk
IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEdyZWcgS0gNCj4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPjsgTGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24u
b3JnPjsgU2FtdWVsDQo+IE5ldmVzIDxzbmV2ZXNAZGVpLnVjLnB0PjsgRGFuIENhcnBlbnRlciA8
ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPjsgQXJuZCBCZXJnbWFubg0KPiA8YXJuZEBhcm5kYi5k
ZT47IEVyaWMgQmlnZ2VycyA8ZWJpZ2dlcnNAZ29vZ2xlLmNvbT47IEFuZHkgTHV0b21pcnNraSA8
bHV0b0BrZXJuZWwub3JnPjsNCj4gV2lsbCBEZWFjb24gPHdpbGxAa2VybmVsLm9yZz47IE1hcmMg
WnluZ2llciA8bWF6QGtlcm5lbC5vcmc+OyBDYXRhbGluIE1hcmluYXMNCj4gPGNhdGFsaW4ubWFy
aW5hc0Bhcm0uY29tPg0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCAwMC8xOF0gY3J5cHRvOiB3
aXJlZ3VhcmQgdXNpbmcgdGhlIGV4aXN0aW5nIGNyeXB0byBBUEkNCj4gDQo+IE9uIFRodSwgMjYg
U2VwIDIwMTkgYXQgMTY6MDMsIFBhc2NhbCBWYW4gTGVldXdlbg0KPiA8cHZhbmxlZXV3ZW5AdmVy
aW1hdHJpeC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiA+ID4gRnJvbTogQXJkIEJpZXNoZXV2ZWwgPGFyZC5iaWVzaGV1dmVsQGxpbmFyby5vcmc+
DQo+ID4gPiBTZW50OiBUaHVyc2RheSwgU2VwdGVtYmVyIDI2LCAyMDE5IDM6MTYgUE0NCj4gPiA+
IFRvOiBQYXNjYWwgVmFuIExlZXV3ZW4gPHB2YW5sZWV1d2VuQHZlcmltYXRyaXguY29tPg0KPiA+
ID4gQ2M6IEphc29uIEEuIERvbmVuZmVsZCA8SmFzb25AengyYzQuY29tPjsgTGludXggQ3J5cHRv
IE1haWxpbmcgTGlzdCA8bGludXgtDQo+ID4gPiBjcnlwdG9Admdlci5rZXJuZWwub3JnPjsgbGlu
dXgtYXJtLWtlcm5lbCA8bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnPjsNCj4g
PiA+IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IERhdmlkIE1pbGxl
ciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEdyZWcNCj4gS0gNCj4gPiA+IDxncmVna2hAbGludXhm
b3VuZGF0aW9uLm9yZz47IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9u
Lm9yZz47IFNhbXVlbA0KPiA+ID4gTmV2ZXMgPHNuZXZlc0BkZWkudWMucHQ+OyBEYW4gQ2FycGVu
dGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+OyBBcm5kIEJlcmdtYW5uDQo+ID4gPiA8YXJu
ZEBhcm5kYi5kZT47IEVyaWMgQmlnZ2VycyA8ZWJpZ2dlcnNAZ29vZ2xlLmNvbT47IEFuZHkgTHV0
b21pcnNraQ0KPiA8bHV0b0BrZXJuZWwub3JnPjsNCj4gPiA+IFdpbGwgRGVhY29uIDx3aWxsQGtl
cm5lbC5vcmc+OyBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPjsgQ2F0YWxpbiBNYXJpbmFz
DQo+ID4gPiA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTogW1JG
QyBQQVRDSCAwMC8xOF0gY3J5cHRvOiB3aXJlZ3VhcmQgdXNpbmcgdGhlIGV4aXN0aW5nIGNyeXB0
byBBUEkNCj4gPiA+DQo+ID4gPiBPbiBUaHUsIDI2IFNlcCAyMDE5IGF0IDE1OjA2LCBQYXNjYWwg
VmFuIExlZXV3ZW4NCj4gPiA+IDxwdmFubGVldXdlbkB2ZXJpbWF0cml4LmNvbT4gd3JvdGU6DQo+
ID4gPiAuLi4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IE15IHByZWZlcmVuY2Ugd291bGQgYmUgdG8g
YWRkcmVzcyB0aGlzIGJ5IHBlcm1pdHRpbmcgcGVyLXJlcXVlc3Qga2V5cw0KPiA+ID4gPiA+IGlu
IHRoZSBBRUFEIGxheWVyLiBUaGF0IHdheSwgd2UgY2FuIGluc3RhbnRpYXRlIHRoZSB0cmFuc2Zv
cm0gb25seQ0KPiA+ID4gPiA+IG9uY2UsIGFuZCBqdXN0IGludm9rZSBpdCB3aXRoIHRoZSBhcHBy
b3ByaWF0ZSBrZXkgb24gdGhlIGhvdCBwYXRoIChhbmQNCj4gPiA+ID4gPiBhdm9pZCBhbnkgcGVy
LWtleXBhaXIgYWxsb2NhdGlvbnMpDQo+ID4gPiA+ID4NCj4gPiA+ID4gVGhpcyBwYXJ0IEkgZG8g
bm90IHJlYWxseSB1bmRlcnN0YW5kLiBXaHkgd291bGQgeW91IG5lZWQgdG8gYWxsb2NhdGUgYQ0K
PiA+ID4gPiBuZXcgdHJhbnNmb3JtIGlmIHlvdSBjaGFuZ2UgdGhlIGtleT8gV2h5IGNhbid0IHlv
dSBqdXN0IGNhbGwgc2V0a2V5KCkNCj4gPiA+ID4gb24gdGhlIGFscmVhZHkgYWxsb2NhdGVkIHRy
YW5zZm9ybT8NCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBCZWNhdXNlIHRoZSBzaW5nbGUgdHJhbnNm
b3JtIHdpbGwgYmUgc2hhcmVkIGJldHdlZW4gYWxsIHVzZXJzIHJ1bm5pbmcNCj4gPiA+IG9uIGRp
ZmZlcmVudCBDUFVzIGV0YywgYW5kIHNvIHRoZSBrZXkgc2hvdWxkIG5vdCBiZSBwYXJ0IG9mIHRo
ZSBURk0NCj4gPiA+IHN0YXRlIGJ1dCBvZiB0aGUgcmVxdWVzdCBzdGF0ZS4NCj4gPiA+DQo+ID4g
U28geW91IG5lZWQgYSB0cmFuc2Zvcm0gcGVyIHVzZXIsIHN1Y2ggdGhhdCBlYWNoIHVzZXIgY2Fu
IGhhdmUgaGlzIG93bg0KPiA+IGtleS4gQnV0IHlvdSBzaG91bGRuJ3QgbmVlZCB0byByZWFsbG9j
YXRlIGl0IHdoZW4gdGhlIHVzZXIgY2hhbmdlcyBoaXMNCj4gPiBrZXkuIEkgYWxzbyBkb24ndCBz
ZWUgaG93IHRoZSAiZGlmZmVyZW50IENQVXMiIGlzIHJlbGV2YW50IGhlcmU/IEkgY2FuDQo+ID4g
c2hhcmUgYSBzaW5nbGUga2V5IGFjcm9zcyBtdWx0aXBsZSBDUFVzIGhlcmUganVzdCBmaW5lIC4u
Lg0KPiA+DQo+IA0KPiBXZSBuZWVkIHR3byB0cmFuc2Zvcm1zIHBlciBjb25uZWN0aW9uLCBvbmUg
Zm9yIGVhY2ggZGlyZWN0aW9uLiBUaGF0IGlzDQo+IGhvdyBJIGN1cnJlbnRseSBpbXBsZW1lbnRl
ZCBpdCwgYW5kIGl0IHNlZW1zIHRvIG1lIHRoYXQsIGlmDQo+IGFsbG9jYXRpbmcvZnJlZWluZyB0
aG9zZSBvbiB0aGUgc2FtZSBwYXRoIGFzIHdoZXJlIHRoZSBrZXlwYWlyIG9iamVjdA0KPiBpdHNl
bGYgaXMgYWxsb2NhdGVkIGlzIHRvbyBjb3N0bHksIEkgd29uZGVyIHdoeSBhbGxvY2F0aW5nIHRo
ZSBrZXlwYWlyDQo+IG9iamVjdCBpdHNlbGYgaXMgZmluZS4NCj4gDQoNCkkgZ3Vlc3MgdGhhdCBr
ZXlwYWlyIG9iamVjdCBpcyBhIFdpcmVndWFyZCBzcGVjaWZpYyB0aGluZz8NCkluIHRoYXQgY2Fz
ZSBpdCBtYXkgbm90IG1ha2UgYSBkaWZmZXJlbmNlIHBlcmZvcm1hbmNlIHdpc2UuDQpJIGp1c3Qg
d291bGQgbm90IGV4cGVjdCBhIG5ldyAocGFpciBvZikgdHJhbnNmb3JtcyB0byBiZSBhbGxvY2F0
ZWQNCmp1c3QgZm9yIGEgcmVrZXksIG9ubHkgd2hlbiBhIG5ldyBjb25uZWN0aW9uIGlzIG1hZGUu
IA0KDQpUaGlua2luZyBhYm91dCB0aGlzIHNvbWUgbW9yZToNCkFsbG9jYXRpbmcgYSB0cmFuc2Zv
cm0gaXMgYWJvdXQgbW9yZSB0aGFuIGp1c3QgYWxsb2NhdGluZyB0aGUgDQpvYmplY3QsIHRoZXJl
IG1heSBiZSBhbGwga2luZHMgb2Ygc2lkZS1lZmZlY3RzIGxpa2UgZmFsbGJhY2sNCmNpcGhlcnMg
YmVpbmcgYWxsb2NhdGVkLCBzcGVjaWZpYyBIVyBpbml0aWFsaXphdGlvbiBiZWluZyBkb25lLCBl
dGMuIA0KSSBqdXN0IGZlZWwgdGhhdCBpZiB5b3Ugb25seSBuZWVkIHRvIGNoYW5nZSB0aGUga2V5
LCB5b3Ugc2hvdWxkDQpvbmx5IGNoYW5nZSB0aGUga2V5LiBBcyB0aGF0J3Mgd2hhdCB0aGUgZHJp
dmVyIHdvdWxkIGJlIG9wdGltaXplZA0KZm9yLg0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1
d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIFZlcmlt
YXRyaXgNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQoNCg0K
