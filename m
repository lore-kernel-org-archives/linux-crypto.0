Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B78C7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 17:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EC142080A
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 17:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="iqnHWtUp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbfGORDP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 13:03:15 -0400
Received: from mail-eopbgr760042.outbound.protection.outlook.com ([40.107.76.42]:33002
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730253AbfGORDO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 13:03:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0ZaRqJipBZrDdWKZviLwRLm+IFa5Hk4CWx1w0DWZqdSLZlNqs8nYUWRQyrx0peXePX7JzoWCFW1i0TAinz9Lv8pKZ8jpr/vcwKSd4cmeSb2gRsge5wqBVuHUwcmpFaAFGgGu45PIkVUHD8nBqkJ7bQipdt3+Y3PuRQwWFWfo1x9L41f66sfrXcTwcAsI/7iYSETBqHFXu0mJLTei+fSK0x9gyUENwbR0oWDOU7Fj34EtJWCEsjB78bQrUkRp3eaLJ2z3s2J40+oYnifAgdnmXeyg8OSTy7U0A92Xt+u9ZnoSQgAN4mSm0cIdPQxOl9wpeBMUYuWtFJlHE/AiidDKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKNJ4FwZ+hnFGbWnye3wk1pecuwcekft+Agil7tdNH4=;
 b=SM0l8tc8JsHZG6A4b3FF69gOTRshEFAYZTwbssfjOgSAcK0DTcpUGARODY/h1BdtBXMscKw+vUESA4UcaN4o/zVP7J74qQxiZXaQq+mL48SoYmm4mUY5tNkERSB4OmhzvEcTSPeSdSygs4cY1CjQ3ZinOXhvnVpgjsHmMY/LO/2HSaBngIomOJmgfIJgQmhy7+v14LqFKYyeULs3+dW8GVSnVUWKcTH43ZjVh6hrZhOZOR0h+woFCfiuWqt9tKQqLRvRpoxYNGtNm1wPtAFu+r0DAnOsZ0VYoGEC007FE91fzjmHIPVE0Xr4d671Y56hs375/UquHOL0qM5Y/d2ong==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKNJ4FwZ+hnFGbWnye3wk1pecuwcekft+Agil7tdNH4=;
 b=iqnHWtUpIrL/O7guQFx0va0E5YoWCm9Ks7t80WGYX1nK0njuiycjgsHRzL08A+ro7YShGyg0eXb2ck7L9th1KSblV3mgchj/xUazKAxaC4JuMreDe1zw8YHldyfMgGW/rcXo+JkHhLLUShQ77IyMc6QxVQs9wD14KYXXV3UZBiQ=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB2922.namprd12.prod.outlook.com (20.179.104.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Mon, 15 Jul 2019 17:03:11 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9c3d:8593:906c:e4f7]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9c3d:8593:906c:e4f7%6]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 17:03:11 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     David Rientjes <rientjes@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Cfir Cohen <cfir@google.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch v2] crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL
Thread-Topic: [patch v2] crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL
Thread-Index: AQHVOPJCgE/OLTyD9EW7JQoqZHEThKbL7HaA
Date:   Mon, 15 Jul 2019 17:03:11 +0000
Message-ID: <b98e9be5-debc-2d75-033d-04247313a18a@amd.com>
References: <alpine.DEB.2.21.1907101426290.2777@chino.kir.corp.google.com>
 <e30eae0f-415b-842e-39c4-801227126367@amd.com>
 <alpine.DEB.2.21.1907121341210.37390@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.21.1907121341210.37390@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR0102CA0035.prod.exchangelabs.com (2603:10b6:805:1::48)
 To DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c1827dc-e325-42c3-251d-08d709465146
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2922;
x-ms-traffictypediagnostic: DM6PR12MB2922:
x-microsoft-antispam-prvs: <DM6PR12MB2922C0528DA888C1112A6B38ECCF0@DM6PR12MB2922.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(189003)(199004)(81166006)(14454004)(71200400001)(66446008)(64756008)(66556008)(2906002)(6436002)(229853002)(8936002)(316002)(86362001)(31696002)(6486002)(68736007)(110136005)(36756003)(54906003)(71190400001)(305945005)(52116002)(53936002)(476003)(2616005)(486006)(76176011)(6506007)(11346002)(3846002)(6116002)(26005)(102836004)(186003)(99286004)(25786009)(66066001)(66946007)(5660300002)(6246003)(478600001)(66476007)(4326008)(446003)(256004)(8676002)(14444005)(31686004)(6512007)(53546011)(7736002)(81156014)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2922;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WWG6QgBX9RE4C6pnZWvxl38/pUJQhK8FLtqY+z1032vdEZC7276Qh+Fb5k7NoqhTTBP3ogh2rGQCudVEP3FuWHxMjnZl10wyHF5rn0kv62UIgorRO0ZTCH35UcYEoGn/1VTmPOloU0OpoxrL6Qrm7cBPyttGx7iZCw1J2NqTFrMqJw7/FWks6d4qII0e164bZ0W6yWm2GKxlpfWedQSiUaarh0M6vQSESiJZzu88Vcpc/CFeHlrUh3JsyUrtIudm2o9JGnPLMDAxWR9O0RpMjuuYu4sXEy1le2v6T3UO3iJRPDlGTDDHWatej8CL0BaCHa8UUptfxdhPIKZE6D/e5Yb6lZaH7M08pschEvgRu/siL2nm+RSHXzv+mHpixDDMXKvYOlJEz9SkXVlHx1xv+wP+oGMQ0k77RYnF3qbNjpU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A09E880EA422E541A893DF9DEEF1204C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1827dc-e325-42c3-251d-08d709465146
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 17:03:11.3176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2922
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy8xMi8xOSAzOjQxIFBNLCBEYXZpZCBSaWVudGplcyB3cm90ZToNCj4gU0VWX1ZFUlNJT05f
R1JFQVRFUl9PUl9FUVVBTCgpIHdpbGwgZmFpbCBpZiB1cGdyYWRpbmcgZnJvbSAyLjIgdG8gMy4x
LCBmb3INCj4gZXhhbXBsZSwgYmVjYXVzZSB0aGUgbWlub3IgdmVyc2lvbiBpcyBub3QgZXF1YWwg
dG8gb3IgZ3JlYXRlciB0aGFuIHRoZQ0KPiBtYWpvci4NCj4gDQo+IEZpeCB0aGlzIGFuZCBtb3Zl
IHRvIGEgc3RhdGljIGlubGluZSBmdW5jdGlvbiBmb3IgYXBwcm9wcmlhdGUgdHlwZQ0KPiBjaGVj
a2luZy4NCj4gDQo+IEZpeGVzOiBlZGQzMDNmZjBlOWUgKCJjcnlwdG86IGNjcCAtIEFkZCBET1dO
TE9BRF9GSVJNV0FSRSBTRVYgY29tbWFuZCIpDQo+IFJlcG9ydGVkLWJ5OiBDZmlyIENvaGVuIDxj
ZmlyQGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IERhdmlkIFJpZW50amVzIDxyaWVudGpl
c0Bnb29nbGUuY29tPg0KDQpBY2tlZC1ieTogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lA
YW1kLmNvbT4NCg0KPiAtLS0NCj4gIHYyOiBubyBuZWVkIHRvIGNoZWNrIGFwaV9tYWpvciA+PSBt
YWogYWZ0ZXIgY2hlY2tpbmcgYXBpX21ham9yID4gbWFqDQo+ICAgICAgcGVyIFRob21hcw0KPiAN
Cj4gIGRyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2LmMgfCAxOSArKysrKysrKysrKystLS0tLS0t
DQo+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5jIGIvZHJpdmVycy9j
cnlwdG8vY2NwL3BzcC1kZXYuYw0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5j
DQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2LmMNCj4gQEAgLTI0LDEwICsyNCw2
IEBADQo+ICAjaW5jbHVkZSAic3AtZGV2LmgiDQo+ICAjaW5jbHVkZSAicHNwLWRldi5oIg0KPiAg
DQo+IC0jZGVmaW5lIFNFVl9WRVJTSU9OX0dSRUFURVJfT1JfRVFVQUwoX21haiwgX21pbikJXA0K
PiAtCQkoKHBzcF9tYXN0ZXItPmFwaV9tYWpvcikgPj0gX21haiAmJglcDQo+IC0JCSAocHNwX21h
c3Rlci0+YXBpX21pbm9yKSA+PSBfbWluKQ0KPiAtDQo+ICAjZGVmaW5lIERFVklDRV9OQU1FCQki
c2V2Ig0KPiAgI2RlZmluZSBTRVZfRldfRklMRQkJImFtZC9zZXYuZnciDQo+ICAjZGVmaW5lIFNF
Vl9GV19OQU1FX1NJWkUJNjQNCj4gQEAgLTQ3LDYgKzQzLDE1IEBAIE1PRFVMRV9QQVJNX0RFU0Mo
cHNwX3Byb2JlX3RpbWVvdXQsICIgZGVmYXVsdCB0aW1lb3V0IHZhbHVlLCBpbiBzZWNvbmRzLCBk
dXJpbmcNCj4gIHN0YXRpYyBib29sIHBzcF9kZWFkOw0KPiAgc3RhdGljIGludCBwc3BfdGltZW91
dDsNCj4gIA0KPiArc3RhdGljIGlubGluZSBib29sIHNldl92ZXJzaW9uX2dyZWF0ZXJfb3JfZXF1
YWwodTggbWFqLCB1OCBtaW4pDQo+ICt7DQo+ICsJaWYgKHBzcF9tYXN0ZXItPmFwaV9tYWpvciA+
IG1haikNCj4gKwkJcmV0dXJuIHRydWU7DQo+ICsJaWYgKHBzcF9tYXN0ZXItPmFwaV9tYWpvciA9
PSBtYWogJiYgcHNwX21hc3Rlci0+YXBpX21pbm9yID49IG1pbikNCj4gKwkJcmV0dXJuIHRydWU7
DQo+ICsJcmV0dXJuIGZhbHNlOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMgc3RydWN0IHBzcF9kZXZp
Y2UgKnBzcF9hbGxvY19zdHJ1Y3Qoc3RydWN0IHNwX2RldmljZSAqc3ApDQo+ICB7DQo+ICAJc3Ry
dWN0IGRldmljZSAqZGV2ID0gc3AtPmRldjsNCj4gQEAgLTU4OCw3ICs1OTMsNyBAQCBzdGF0aWMg
aW50IHNldl9pb2N0bF9kb19nZXRfaWQyKHN0cnVjdCBzZXZfaXNzdWVfY21kICphcmdwKQ0KPiAg
CWludCByZXQ7DQo+ICANCj4gIAkvKiBTRVYgR0VUX0lEIGlzIGF2YWlsYWJsZSBmcm9tIFNFViBB
UEkgdjAuMTYgYW5kIHVwICovDQo+IC0JaWYgKCFTRVZfVkVSU0lPTl9HUkVBVEVSX09SX0VRVUFM
KDAsIDE2KSkNCj4gKwlpZiAoIXNldl92ZXJzaW9uX2dyZWF0ZXJfb3JfZXF1YWwoMCwgMTYpKQ0K
PiAgCQlyZXR1cm4gLUVOT1RTVVBQOw0KPiAgDQo+ICAJaWYgKGNvcHlfZnJvbV91c2VyKCZpbnB1
dCwgKHZvaWQgX191c2VyICopYXJncC0+ZGF0YSwgc2l6ZW9mKGlucHV0KSkpDQo+IEBAIC02NTEs
NyArNjU2LDcgQEAgc3RhdGljIGludCBzZXZfaW9jdGxfZG9fZ2V0X2lkKHN0cnVjdCBzZXZfaXNz
dWVfY21kICphcmdwKQ0KPiAgCWludCByZXQ7DQo+ICANCj4gIAkvKiBTRVYgR0VUX0lEIGF2YWls
YWJsZSBmcm9tIFNFViBBUEkgdjAuMTYgYW5kIHVwICovDQo+IC0JaWYgKCFTRVZfVkVSU0lPTl9H
UkVBVEVSX09SX0VRVUFMKDAsIDE2KSkNCj4gKwlpZiAoIXNldl92ZXJzaW9uX2dyZWF0ZXJfb3Jf
ZXF1YWwoMCwgMTYpKQ0KPiAgCQlyZXR1cm4gLUVOT1RTVVBQOw0KPiAgDQo+ICAJLyogU0VWIEZX
IGV4cGVjdHMgdGhlIGJ1ZmZlciBpdCBmaWxscyB3aXRoIHRoZSBJRCB0byBiZQ0KPiBAQCAtMTA1
Myw3ICsxMDU4LDcgQEAgdm9pZCBwc3BfcGNpX2luaXQodm9pZCkNCj4gIAkJcHNwX21hc3Rlci0+
c2V2X3N0YXRlID0gU0VWX1NUQVRFX1VOSU5JVDsNCj4gIAl9DQo+ICANCj4gLQlpZiAoU0VWX1ZF
UlNJT05fR1JFQVRFUl9PUl9FUVVBTCgwLCAxNSkgJiYNCj4gKwlpZiAoc2V2X3ZlcnNpb25fZ3Jl
YXRlcl9vcl9lcXVhbCgwLCAxNSkgJiYNCj4gIAkgICAgc2V2X3VwZGF0ZV9maXJtd2FyZShwc3Bf
bWFzdGVyLT5kZXYpID09IDApDQo+ICAJCXNldl9nZXRfYXBpX3ZlcnNpb24oKTsNCj4gIA0KPiAN
Cg==
