Return-Path: <SRS0=09LE=QH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A4BC169C4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 15:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E0B218AF
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 15:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="LIUpEk64"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfAaPIG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Jan 2019 10:08:06 -0500
Received: from mail-eopbgr780089.outbound.protection.outlook.com ([40.107.78.89]:21220
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbfAaPIG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Jan 2019 10:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSsgRyWwB/P9sDLxt6kcG57ykNYCQhi+UfJMYlFP54M=;
 b=LIUpEk64perq/HfOpsB38xbB1HryS3gEUY8O7nqP2WRt+ULFo4YmB1J6uTqF7oNtU0Kb6Om7+DfebkesurjjiR+noQc0g08KeOGzjIU7W6T4shEbgii+oc+LV1ciy/QXjXoQAdslRM162g/9ofscYU44D/ZNjo0GDCZzoZ+LvFg=
Received: from MN2PR12MB3631.namprd12.prod.outlook.com (20.178.243.19) by
 MN2PR12MB3278.namprd12.prod.outlook.com (20.179.83.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.17; Thu, 31 Jan 2019 15:08:01 +0000
Received: from MN2PR12MB3631.namprd12.prod.outlook.com
 ([fe80::a861:43c0:476d:e044]) by MN2PR12MB3631.namprd12.prod.outlook.com
 ([fe80::a861:43c0:476d:e044%5]) with mapi id 15.20.1580.017; Thu, 31 Jan 2019
 15:08:01 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: Re: [PATCH] crypto: ccp: fix the SEV probe in kexec boot path
Thread-Topic: [PATCH] crypto: ccp: fix the SEV probe in kexec boot path
Thread-Index: AQHUuN53GxbsT9pk+UaDAUjTznR126XJe8SA
Date:   Thu, 31 Jan 2019 15:08:01 +0000
Message-ID: <d2cec2a1-25ef-6fde-bca4-22a72fed8d96@amd.com>
References: <20190130205710.14268-1-brijesh.singh@amd.com>
In-Reply-To: <20190130205710.14268-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0072.namprd12.prod.outlook.com
 (2603:10b6:802:20::43) To MN2PR12MB3631.namprd12.prod.outlook.com
 (2603:10b6:208:cc::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MN2PR12MB3278;20:ZTFaO0fANIvRFWL+adZ2CCjOjOtr7GpZnwP/z5FkL2IRNPxZywrIyVRY5iv4B25VdVR+pXzzfG1u+uyVLGCo0p6REH4CM8r763SqJzinuEqkqWK4uxV+n1qwxzg3ztBBdx9cQlYy1kq6S/5GHQE6yIRcn/+VW+wyncB01ebvaqEBZTNgTujH4ipHdsW0hvs6egTiumeBbM+nAMjg7JfwN9LbisghTJB459GJl81g1fYklY/AIA8HXJXImzaxbxk+
x-ms-office365-filtering-correlation-id: 27b7533c-8ad4-4099-a150-08d6878de46e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:MN2PR12MB3278;
x-ms-traffictypediagnostic: MN2PR12MB3278:
x-microsoft-antispam-prvs: <MN2PR12MB327830A5078DA74EC3AB35E7EC910@MN2PR12MB3278.namprd12.prod.outlook.com>
x-forefront-prvs: 09347618C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(39860400002)(346002)(376002)(396003)(136003)(366004)(199004)(189003)(106356001)(25786009)(105586002)(4326008)(450100002)(2906002)(2501003)(81156014)(81166006)(86362001)(31696002)(31686004)(8676002)(229853002)(14454004)(97736004)(71190400001)(71200400001)(8936002)(478600001)(72206003)(256004)(53936002)(14444005)(6246003)(6436002)(6116002)(6486002)(6512007)(486006)(66066001)(110136005)(54906003)(68736007)(76176011)(3846002)(2616005)(6506007)(36756003)(7736002)(26005)(386003)(99286004)(316002)(102836004)(53546011)(52116002)(476003)(11346002)(446003)(305945005)(186003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3278;H:MN2PR12MB3631.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dXPgbx2Pusi2zbRkIUpYHfEKi5eiSHKmoxQ5wZbkiNP95zuFK47RxjLH9nM1ZTXXjPlcJSbtcOgl1gAYtxigvVDs0azikyzpM0og5695jLHteP5KNcnMHw/AaY/zFxfnYXrK2YBp1UHHt5jVav/KRVq4rcyPSBIn8+gDm2D9xNDUlLMX+ZZdV0CpKbwMk4PWjlmm4Iu7tz5xFP/tApsR6zfkr2HCGTaR8UdMr658dEbo13jcTvvYRM0MOPfaXmm15gj5951l5n6TJpI4l9TGvp60+UAC6EkMNBSTUHwgX13XUUonFpts3Kpx7yboOFyHo6MiEDhesbW8dvGPftaFrxLA7DDk7j3PkFZiOISK5pei7L4pRM4EkST65qxt8GjT6UmZLH3YUNGwhc5zfak52CsKtEE7430V6PLnYZ3akCY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EE5576060482B4390EF50D59C2314BF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27b7533c-8ad4-4099-a150-08d6878de46e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2019 15:08:00.8825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3278
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMS8zMC8xOSAyOjU3IFBNLCBTaW5naCwgQnJpamVzaCB3cm90ZToNCj4gQSBrZXhlYyByZWJv
b3QgbWF5IGxlYXZlIHRoZSBmaXJtd2FyZSBpbiBJTklUIG9yIFdPUktJTkcgc3RhdGUuDQo+IEN1
cnJlbnRseSwgd2UgaXNzdWUgUExBVEZPUk1fSU5JVCBjb21tYW5kIGR1cmluZyB0aGUgcHJvYmUg
d2l0aG91dA0KPiBjaGVja2luZyB0aGUgY3VycmVudCBzdGF0ZS4gVGhlIFBMQVRGT1JNX0lOSVQg
Y29tbWFuZCBmYWlscyBpZiB0aGUNCj4gRlcgaXMgYWxyZWFkeSBpbiBJTklUIHN0YXRlLiBMZXRz
IGNoZWNrIHRoZSBjdXJyZW50IHN0YXRlLCBpZiBGVw0KPiBpcyBub3QgaW4gVU5JTklUIHN0YXRl
IHRoZW4gdHJhbnNpdGlvbiBpdCB0byBVTklOSVQgYmVmb3JlDQo+IGluaXRpYWxpemluZyBvciB1
cGdyYWRpbmcgdGhlIEZXLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQnJpamVzaCBTaW5naCA8YnJp
amVzaC5zaW5naEBhbWQuY29tPg0KPiBDYzogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lA
YW1kLmNvbT4NCj4gQ2M6IEdhcnkgSG9vayA8Z2FyeS5ob29rQGFtZC5jb20+DQo+IC0tLQ0KPiAg
ZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuYyB8IDE2ICsrKysrKysrKysrKysrKysNCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspDQoNClJldmlld2VkLWJ5OiBUb20gTGVuZGFj
a3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPg0KDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9jcnlwdG8vY2NwL3BzcC1kZXYuYyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2LmMNCj4g
aW5kZXggYjE2YmU4YTExZDkyLi45NjZjYTZmOWNmNzkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
Y3J5cHRvL2NjcC9wc3AtZGV2LmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYu
Yw0KPiBAQCAtNDM3LDYgKzQzNyw3IEBAIHN0YXRpYyBpbnQgc2V2X2dldF9hcGlfdmVyc2lvbih2
b2lkKQ0KPiAgCXBzcF9tYXN0ZXItPmFwaV9tYWpvciA9IHN0YXR1cy0+YXBpX21ham9yOw0KPiAg
CXBzcF9tYXN0ZXItPmFwaV9taW5vciA9IHN0YXR1cy0+YXBpX21pbm9yOw0KPiAgCXBzcF9tYXN0
ZXItPmJ1aWxkID0gc3RhdHVzLT5idWlsZDsNCj4gKwlwc3BfbWFzdGVyLT5zZXZfc3RhdGUgPSBz
dGF0dXMtPnN0YXRlOw0KPiAgDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+IEBAIC05NjQsNiArOTY1
LDIxIEBAIHZvaWQgcHNwX3BjaV9pbml0KHZvaWQpDQo+ICAJaWYgKHNldl9nZXRfYXBpX3ZlcnNp
b24oKSkNCj4gIAkJZ290byBlcnI7DQo+ICANCj4gKwkvKg0KPiArCSAqIElmIHBsYXRmb3JtIGlz
IG5vdCBpbiBVTklOSVQgc3RhdGUgdGhlbiBmaXJtd2FyZSB1cGdyYWRlIGFuZC9vcg0KPiArCSAq
IHBsYXRmb3JtIElOSVQgY29tbWFuZCB3aWxsIGZhaWwuIFRoZXNlIGNvbW1hbmQgcmVxdWlyZSBV
TklOSVQgc3RhdGUuDQo+ICsJICoNCj4gKwkgKiBJbiBhIG5vcm1hbCBib290IHdlIHNob3VsZCBu
ZXZlciBydW4gaW50byBjYXNlIHdoZXJlIHRoZSBmaXJtd2FyZQ0KPiArCSAqIGlzIG5vdCBpbiBV
TklOSVQgc3RhdGUgb24gYm9vdC4gQnV0IGluIGNhc2Ugb2Yga2V4ZWMgYm9vdCwgYSByZWJvb3QN
Cj4gKwkgKiBtYXkgbm90IGdvIHRocm91Z2ggYSB0eXBpY2FsIHNodXRkb3duIHNlcXVlbmNlIGFu
ZCBtYXkgbGVhdmUgdGhlDQo+ICsJICogZmlybXdhcmUgaW4gSU5JVCBvciBXT1JLSU5HIHN0YXRl
Lg0KPiArCSAqLw0KPiArDQo+ICsJaWYgKHBzcF9tYXN0ZXItPnNldl9zdGF0ZSAhPSBTRVZfU1RB
VEVfVU5JTklUKSB7DQo+ICsJCXNldl9wbGF0Zm9ybV9zaHV0ZG93bihOVUxMKTsNCj4gKwkJcHNw
X21hc3Rlci0+c2V2X3N0YXRlID0gU0VWX1NUQVRFX1VOSU5JVDsNCj4gKwl9DQo+ICsNCj4gIAlp
ZiAoU0VWX1ZFUlNJT05fR1JFQVRFUl9PUl9FUVVBTCgwLCAxNSkgJiYNCj4gIAkgICAgc2V2X3Vw
ZGF0ZV9maXJtd2FyZShwc3BfbWFzdGVyLT5kZXYpID09IDApDQo+ICAJCXNldl9nZXRfYXBpX3Zl
cnNpb24oKTsNCj4gDQo=
