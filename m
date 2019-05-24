Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CA3C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 08:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52B1E20879
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 08:00:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="vUAEmK5T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388996AbfEXIAL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 04:00:11 -0400
Received: from mail-eopbgr60103.outbound.protection.outlook.com ([40.107.6.103]:8773
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389001AbfEXIAI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 04:00:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeSHmdsI6pmlqEqWydHbxkjUCnc8CG4FXYvsmoQtDbs=;
 b=vUAEmK5TqTfq7FAszOTPefnakynbNgPTy7802OAXb5i/honVLIyPqvwB+ORC0B8PNC3OjeHPfYWwD5P3glJ7IXUcK4kJpwPbYb5xCq8HzkvrZ68cosUvFfkS+btiKQPV4QofogZNsAYA8ABIEtjpMOaQiA4DMe820f9VfMvnqnw=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2712.eurprd09.prod.outlook.com (20.178.87.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Fri, 24 May 2019 08:00:04 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 08:00:04 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     "noloader@gmail.com" <noloader@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAKnugIAAGeyw
Date:   Fri, 24 May 2019 08:00:04 +0000
Message-ID: <AM6PR09MB35232EFA55A1CCE4EAB13930D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <CAH8yC8mFC82bUBTMObLAGZMff6teThW=XgQSv-SMYObir2ov=g@mail.gmail.com>
In-Reply-To: <CAH8yC8mFC82bUBTMObLAGZMff6teThW=XgQSv-SMYObir2ov=g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5942e28-8246-401b-5227-08d6e01dd483
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB2712;
x-ms-traffictypediagnostic: AM6PR09MB2712:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB2712CEDDE74D016EC5A70C0BD2020@AM6PR09MB2712.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(346002)(376002)(366004)(396003)(136003)(189003)(199004)(3480700005)(3846002)(229853002)(102836004)(6116002)(25786009)(2501003)(6436002)(6506007)(55016002)(11346002)(7116003)(4326008)(76176011)(486006)(7696005)(9686003)(110136005)(26005)(186003)(2906002)(6246003)(99286004)(316002)(15974865002)(86362001)(68736007)(71190400001)(66066001)(76116006)(66476007)(66556008)(64756008)(71200400001)(66446008)(73956011)(446003)(53936002)(66946007)(52536014)(305945005)(7736002)(476003)(81156014)(81166006)(14454004)(8676002)(14444005)(256004)(74316002)(5660300002)(478600001)(8936002)(33656002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2712;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: N1EwaYsx6JltnmMguXpSBfLj+E4gtJBv308uCyp91Y8d1ptBXeMnKSkwq5DfIm1gtPC2kMZeswmBtc0Ctqs1cz7bzcOlPQg4NeckXGUyaV2dCjGCMyukmEKHNmWqBJa/iP+of7GPwRZRfAFFcX1gG0wXB7GCevn6opdbygnpQu1pYfmFLfWbwtrdHWfDT3KZ/ZSqha2BWxXby+5T6zWZUQSTSYzK7kawSXfzOCpY23zsX7PhVRzJEYSFnKaKeAmYwt4v4RbuANoEBMKd/nNq0TvlvxUFNEJChYl5xFVRjdfC+zp8Vn23qCA3kG0tpqkRors/rM68fPLQfDa5Kfah764/q1PuqCkoAfNLRMnsgdD0ZFh7hHpjprGfUxBPJHnY1e90p9KKJSu0oXqjQ/5x2s+lrSGoo0VKvt50axCYCxY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5942e28-8246-401b-5227-08d6e01dd483
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 08:00:04.2224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2712
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+IHlvdSBjYW4gc2ltcGx5IGRvIHRoaXMgaW4gdGhlIGRyaXZlciBpbnN0ZWFkOg0KPiA+DQo+
ID4gICAgICAgICBpZiAocmVxLT5jcnlwdGxlbiA9PSAwKQ0KPiA+ICAgICAgICAgICAgICAgICBy
ZXR1cm4gMDsNCj4NCj4gKzEuIEl0IHNlZW1zIGxpa2UgYSBmaXJtd2FyZSB1cGRhdGUgaW4gdGhl
IGhhcmR3YXJlIG9yIGEgc29mdHdhcmUNCj4gdXBkYXRlIHRvIHRoZSBkcml2ZXIgYXJlIHRoZSB3
YXlzIHRvIHByb2NlZWQuDQo+DQoNCkhhcmR3YXJlIHR5cGljYWxseSBkb2VzIG5vdCBpbnZvbHZl
IGZpcm13YXJlIGZvciB0aGluZ3MgbGlrZSB0aGlzLg0KQW5kIHlvdSBjYW5ub3QgdXBkYXRlIHNp
bGljb24uDQoNCj4NCj4gV2h5IGlzbid0IHRoZSBkcml2ZXIgYWJsZSB0byB3b3JrIGFyb3VuZCB0
aGUgaGFyZHdhcmUgYnVncz8NCj4NCg0KMSkgSXQncyBOT1QgYSBidWcuIEEgYnVnIGlzIHNvbWV0
aGluZyB0aGF0IGlzIG5vdCBpbnRlbnRpb25hbCwgYnV0DQp0aGlzIGlzIHdlbGwgc3BlY2lmaWVk
IGJlaGF2aW9yIG9mIHRoZSBoYXJkd2FyZS4NCkhhcmR3YXJlIGFsd2F5cyBoYXMgbGltaXRhdGlv
bnMgZm9yIHRoZSBzaW1wbGUgcmVhc29uIHRoYXQgc29tZQ0KdGhpbmdzIGFyZSBzaW1wbHkgdG9v
IGNvbXBsZXgsIGNvc3RseSBvciByaXNreSB0byBpbXBsZW1lbnQgaW4gSFcuDQoNCjIpIE9mIGNv
dXJzZSB5b3UgY2FuIGFsd2F5cyB3b3JrYXJvdW5kIHRoaW5ncyBpbiB0aGUgZHJpdmVyLCBidXQN
CmJyZWFraW5nIG91dCBhbGwgdGhvc2UgZXhjZXB0aW9uIGNhc2VzIHNsb3dzIGRvd24gdGhlIG5v
cm1hbCBjYXNlcy4NClBsdXMgaXQgYWRkcyB0cmVtZW5kb3VzIGNvbXBsZXhpdHkgYW5kIGJsb2F0
IHRvIHRoZSBkcml2ZXIgaXRzZWxmLg0KDQpUaGVyZSBzaG91bGQgYmUgU09NRSBtYXJnaW4gZm9y
IG5vdCBoYXZpbmcgdG8gc3VwcG9ydCBldmVyeXRoaW5nDQpidXQgdGhlIGtpdGNoZW4gc2luay4g
QWxzbyBrZWVwaW5nIGluIG1pbmQgdGhhdCBtb3N0IG9mIHRoaXMgSFcNCmV4aXN0ZWQgbG9uZyBi
ZWZvcmUgdGhlIENyeXB0byBBUEkgd2FzIGV2ZW4gY29uY2VpdmVkLg0KDQo+IEkgZG9uJ3QgdGhp
bmsgaXQgaXMgd2lzZSB0byByZW1vdmUgdGVzdHMgZnJvbSB0aGUgVGVzdCBNYW5hZ2VyLg0KPg0K
V2VsbCwgaW4gdGhpcyBwYXJ0aWN1bGFyIGNhc2UgdGhleSBhcmUgdGVzdHMgaW50ZW5kZWQgZm9y
IGRldmVsb3BtZW50DQphbmQgbm90IGZvciBwcm9kdWN0aW9uIHVzZSwgc28gSSBndWVzcyBpdCdz
IE9LIHRvIGtlZXAgdGhlbSBmb3IgdGhhdC4NCkFsdGhvdWdoIEkgd291bGQgbGlrZSB0byBzZWUg
dGhlIHRlc3RpbmcgY29udGludWUgaWYgYSB0ZXN0IGZhaWxzLA0Kc3VjaCB0aGF0IEkgaGF2ZSB0
aGUgb3B0aW9uIHRvIGlnbm9yZSB0aGUgb25lcyBJIGRvbid0IGNhcmUgYWJvdXQgLi4uDQoNClJl
Z2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Q
cm90b2NvbCBFbmdpbmVzIEAgSW5zaWRlIFNlY3VyZQ0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg0K
