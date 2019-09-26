Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BD2C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 20:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C82AF21A4A
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 20:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="cyyGk0ii"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfIZUE1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 16:04:27 -0400
Received: from mail-eopbgr680089.outbound.protection.outlook.com ([40.107.68.89]:56131
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727764AbfIZUE0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 16:04:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFkhT+UHcgLNf/ZiY8XUvWO5ZKL2CLXhWaYk7spXBk++oy2ohOvM8dkZ7hweUv5LZKPDNgguqEPGXUYQOlM4Hf1xCJtrtwMAPIo96ME4wIkjxMIJD5geqWhk3DF8XkBT8pToEwQ4SYzKT09U4dlZw6A4Yaq6D/zXDzWeeenhGPmPzBVfvHeczWQvwQzkMhHWeyYQezGHt053BSOWICXtbVURsxzEIJqrkVctUhGceQs6Os6ffexRZw0binIQW/GgnziKuk8lcGlAuwaAXAxtBgg5ihXuDLyPasl1tN725Nvyv+6JqmRs4Y6t5Wovk9T+tqmpvAInquBQxVS2oVHzjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN7H4kF9fnFzUL7DYbDhV8hxDXUlAWxLIvhZxA5FAZ0=;
 b=XyGZU06RqG0Jb2hKUhJg1Dhko4ZoWK8dZ1le7IDKdFFdZRsChRMPTM/i3ZcJg+Zhxl7+9JrAWpsDUZjJ/S20cH/Vj1nv6QgcAK1Z99YQBguxgx3b6wDaOt3ewv9e66N2gvBWSKqCHVEO8V2hGCvOXvaH6U99Mt9x14GBhaclxRUdYf/CUbpFURHeg5g9DK9jHu7zqF9YvujcKmWRzeo8utCXD48+w1ArVyghY1suaT3qjw9bJ9S4uOfLg4MV6kdqHEC50TqKEc/qMSqGdeOUOqygcovjXGco6Ipk88JTJBgNK01CP3NjVbnqUPiZHYN5jakb604ujBBFhW5q2V8OZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN7H4kF9fnFzUL7DYbDhV8hxDXUlAWxLIvhZxA5FAZ0=;
 b=cyyGk0iieudjYyWSKcnpRMUH38APEc4qk0s5JOM8ZrmokXIpWJjg70RsftZob+PvzJKnMiRh0vvktRwsjjQZeb893rht2bh53nbDeTwCRsf52nLhSUXiY6kwUzGcHtTcM40FcfmephjYovZ461LB3wIqxGHSCfiqSaQK4bMatM8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3213.namprd20.prod.outlook.com (52.132.175.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Thu, 26 Sep 2019 20:04:22 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2305.017; Thu, 26 Sep 2019
 20:04:22 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: RE: Chacha-Poly performance on ARM64
Thread-Topic: Chacha-Poly performance on ARM64
Thread-Index: AdV0eUDF0FX1qai/QZmAhLVFbJDbJQAAboIAAAplBMA=
Date:   Thu, 26 Sep 2019 20:04:22 +0000
Message-ID: <MN2PR20MB2973BB95E110A30A314C59E3CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB2973C550AC7337ED85B874D8CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu86tW4hw7b3iMDt6U6HnUcf1BWRAcGK8O3xtSj_hdmdQQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu86tW4hw7b3iMDt6U6HnUcf1BWRAcGK8O3xtSj_hdmdQQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d8a84d9-8993-49a0-9a98-08d742bcb940
x-ms-traffictypediagnostic: MN2PR20MB3213:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3213D52B2D66C1C0FA5BE133CA860@MN2PR20MB3213.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39850400004)(366004)(376002)(396003)(136003)(13464003)(189003)(199004)(33656002)(14454004)(66066001)(86362001)(446003)(74316002)(11346002)(486006)(305945005)(71200400001)(71190400001)(99286004)(26005)(7696005)(102836004)(186003)(6116002)(6506007)(53546011)(2906002)(5660300002)(52536014)(7736002)(476003)(25786009)(6916009)(316002)(478600001)(66946007)(66476007)(66556008)(64756008)(8676002)(66446008)(76116006)(81166006)(81156014)(8936002)(76176011)(3846002)(15974865002)(9686003)(55016002)(6436002)(229853002)(256004)(4326008)(6246003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3213;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: No9Verx5lKDlMLZL19OgvtKdkCEARgPYBADBhyP7DAklcaJ3TnxjqmE1QGZlBpZ7T1ezT+CtcRPlr/0A7ZMFcBX5Hn5s3FDdXiprKOBSQXCbUPRC/8Gxb4kUSCZC+QYFXEe69KXYVAa2tEi9bSFwPKh6u3HYLxzPmepx5DuLmLdr/Hrf7OpT19QnUjB3ljsNqAqTjm4cJdAPGq6jS1roRAy5z9OteU7XmodVp/soCyZj3zImiVk9uyKqOr0jitN04SO6xI2LJVpCWkUTiATQhcZf7YhPd6wL+9WEmgCGQJ1Kr5NbgJ+djWj/2RqT8KD6LVYSK+9aqGWCpZKdKrOi3rSCU5bF/bSqaVV62oOIv01LjZMyFaLqEHr0g5QcHVADYJIToJYZBqUpv1yxAPRF/PBw75CWI1iZVHjMYB3GxXQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8a84d9-8993-49a0-9a98-08d742bcb940
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 20:04:22.1570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ok/XuK5293Fjun/4DOip+P5JU49keK5Q4oeHaKLW9X63nusM5qAIBEvLlCMaVhL2r15x77tD+imEvm+2ugymp7T3YFRsp9hKxLQjreL4MUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3213
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
LmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAyNiwg
MjAxOSA0OjU5IFBNDQo+IFRvOiBQYXNjYWwgVmFuIExlZXV3ZW4gPHB2YW5sZWV1d2VuQHZlcmlt
YXRyaXguY29tPg0KPiBDYzogTGludXggQ3J5cHRvIE1haWxpbmcgTGlzdCA8bGludXgtY3J5cHRv
QHZnZXIua2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IENoYWNoYS1Qb2x5IHBlcmZvcm1hbmNl
IG9uIEFSTTY0DQo+IA0KPiBPbiBUaHUsIDI2IFNlcCAyMDE5IGF0IDE2OjU1LCBQYXNjYWwgVmFu
IExlZXV3ZW4NCj4gPHB2YW5sZWV1d2VuQHZlcmltYXRyaXguY29tPiB3cm90ZToNCj4gPg0KPiA+
IEhpLA0KPiA+DQo+ID4gSSdtIGN1cnJlbnRseSBkb2luZyBzb21lIHBlcmZvcm1hbmNlIGJlbmNo
bWFya2luZyBvbiBhIHF1YWQgY29yZSBDb3J0ZXgNCj4gPiBBNzIgKE1hY2NoaWF0b2JpbiBkZXYg
Ym9hcmQpIGZvciByZmM3NTM5ZXNwIChDaGFjaGFQb2x5KSBhbmQgdGhlDQo+ID4gcmVsYXRpdmVs
eSBsb3cgcGVyZm9ybWFuY2Uga2luZCBvZiB0b29rIG1lIGJ5IHN1cnByaXNlLCBjb25zaWRlcmlu
ZyBob3cNCj4gPiBldmVyeW9uZSAga2VlcHMgc2hvdXRpbmcgaG93IGVmZmljaWVudCBDaGFjaGEt
UG9seSBpcyBpbiBzb2Z0d2FyZSBvbg0KPiA+IG1vZGVybiBDUFUncy4NCj4gPg0KPiA+IFRoZW4g
SSBub3RpY2VkIHRoYXQgaXQgd2FzIHVzaW5nIGNoYWNoYTIwLWdlbmVyaWMgZm9yIHRoZSBlbmNy
eXB0DQo+ID4gZGlyZWN0aW9uLCB3aGlsZSBhIGNoYWNoYTIwLW5lb24gaW1wbGVtZW50YXRpb24g
ZXhpc3RzIChpdCBhY3R1YWxseQ0KPiA+IERPRVMgdXNlIHRoYXQgb25lIGZvciBkZWNyeXB0aW9u
KS4gV2h5IHdvdWxkIHRoYXQgYmU/DQo+ID4NCj4gPiBBbHNvLCBpdCBhbHNvIHVzZXMgcG9seTEz
MDUtZ2VuZXJpYyBpbiBib3RoIGNhc2VzLiBJcyB0aGF0IHRoZSBiZXN0DQo+ID4gcG9zc2libGUg
b24gQVJNNjQ/IEkgZGlkIGEgcXVpY2sgc2VhcmNoIGluIHRoZSBjb2RlYmFzZSBidXQgY291bGRu
J3QNCj4gPiBmaW5kIGFueSBBUk02NCBvcHRpbWl6ZWQgdmVyc2lvbiAuLi4NCj4gPg0KPiANCj4g
VGhlIFBvbHkxMzA1IGltcGxlbWVudGF0aW9uIGlzIHBhcnQgb2YgdGhlIDE4IHBpZWNlIFdpcmVH
dWFyZCBzZXJpZXMgSQ0KPiBqdXN0IHNlbnQgb3V0IHllc3RlcmRheSAod2hpY2ggSSBrbm93IHlv
dSBoYXZlIHNlZW4gOi0pKQ0KPiANCkkndmUgc2VlbiB0aGUgc2VyaWVzIGJ1dCBJIG11c3QgaGF2
ZSBtaXNzZWQgdGhhdCBkZXRhaWwuIEkgaGFkIGh1bmNoIHlvdQ0Kd291bGQgYmUgdGhlIG9uZSB3
b3JraW5nIG9uIGl0IHRob3VnaCA6LSkgSSdsbCBsb29rIGl0IHVwIGFuZCB0cnkgaXQgDQp0b21v
cnJvdy4NCg0KPiBUaGUgQ2hhY2hhMjAgY29kZSBzaG91bGQgYmUgdXNlZCBpbiBwcmVmZXJlbmNl
IHRvIHRoZSBnZW5lcmljIGNvZGUsIHNvDQo+IGlmIHlvdSBlbmQgdXAgd2l0aCB0aGUgd3Jvbmcg
dmVyc2lvbiwgdGhlcmUncyBhIGJ1ZyBzb21ld2hlcmUgd2UgbmVlZA0KPiB0byBmaXguDQo+IA0K
WWVzLCBJIHRoaW5rIHNvIHRvby4gSW4gZmFjdCwgSSB0aGluayBpdCBtYXkgYmUgdGhlIHNhbWUg
YnVnIEkgcmVwb3J0ZWQNCmVhcmxpZXIgcmVnYXJkaW5nIHRoZSBzZWxmdGVzdHMsIHdoZXJlIGl0
IGFsc28gdW5leHBlY3RlZGx5IHBpY2tlZCB0aGUNCmdlbmVyaWMgaW1wbGVtZW50YXRpb24uIElJ
UkMgdGhlIHJlc3BvbnNlIEkgZ290IGJhY2sgd2FzIHRoYXQgdGhpcyB3YXMNCmEga25vd24gaXNz
dWUgd2hlcmUgZm9yIHRoZSB2ZXJ5IGZpcnN0IHVzZSBvZiBhIGNpcGhlciwgdGhlIGdlbmVyaWMg
DQppbXBsZW1lbnRhdGlvbiBnZXRzIGNob3NlbiBpbnN0ZWFkIG9mIHRoZSBvcHRpbWFsIG9uZS4g
SSBndWVzcyBubyBvbmUNCmhhcyBsb29rZWQgaW50byB0aGF0IHlldCAuLi4NCg0KPiBBbHNvLCBo
b3cgZG8geW91IGtub3cgd2hpY2ggZGlyZWN0aW9uIHVzZXMgd2hpY2ggdHJhbnNmb3JtPyANCj4N
CldlbGwsIHRjcnlwdCBqdXN0IGxvZ3MgdGhhdCB0byB0aGUgbWVzc2FnZSBsb2cuDQoNCj4gV2hh
dCBhcmUgdGhlIHJlZmNvdW50cyBmb3IgdGhlIHRyYW5zZm9ybXMgaW4gL3Byb2MvY3J5cHRvPw0K
Pg0KQWxsIHJlZmNudCdzIGluIC9wcm9jL2NyeXB0byBhcmUgMS4NCg0KUmVnYXJkcywNClBhc2Nh
bCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2lu
ZXMgQCBWZXJpbWF0cml4DQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0K
