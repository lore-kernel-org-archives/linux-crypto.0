Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1590C76191
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 22:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B06C220651
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 22:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="TKMf6QlD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731833AbfGOWiK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 18:38:10 -0400
Received: from mail-eopbgr800072.outbound.protection.outlook.com ([40.107.80.72]:26242
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730881AbfGOWiK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 18:38:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NA88akAKxnElZKesPN6GOlfkWNNr6rnMrdcLs3rzzJawG14IuCs+iwfWm0HMImrI8n380KCy18Wtk0KylycY2rMiyQyDBAyZXh5QNld66joJJ+TjYHFaJgqJsferxYAlVno2YBwa/xPIrZ0weHpAvTCGTjEdp+4R+frdgsA18CKId9+sR6SGOtKu8kcOH0lt94mFmgktRKjAUtGPWtz327054J6RRd3unXGmS5Qqj5FUls112oapt++z9Bfs4nwS+vtadO7lALLJ2sYglFGgmopCTBYpzib2qAOFrEMCY6WBZ3ek6d6wVjuDK1lEaFErwFpSMoMHJ5bsvoowRKX8sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUjKpN0m8sY99FYmet5RZyYJu5p0Rnviq/DV9qeTtDk=;
 b=iNd2uK/DD6nhqFmoze6/k84DUumBsyIZZmpc1LBK6mAm4F6cgde5LSLloJhzOMhbPvSJ/ux4wZdS+Xkqo00pTYi32sSBoJBrhIIfgm2aY1KbZraBAidBhEUWueg3nrDPNa+jkjCCPAa5QgUhFWow3ZnjC95sZHY9V5TZbtj6DzXImLiQQrZqFAOHh802ae4vqqgkh/61hj2gxeqoZkH7ySHAeWdbB2JMJRqXlrCC4TV+Sh1wo5JF6Vd8S0d95ORrnNDilTsFUgnf66MIsQ7DgeMCSIXQmjH4MxrC8f8TIMUHwQIUSmpLvxPN6719r2/Bzmo0398ESl0M1XfL8DYBwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUjKpN0m8sY99FYmet5RZyYJu5p0Rnviq/DV9qeTtDk=;
 b=TKMf6QlDtxvZ0LRInTX9RLu2+p1MNSOIn9y3CPZAHLHpXYGz59bTeXrqdIvh9M0IFIemmdfMB0veKYh7K/IJFg+GECojf8k+4rkyWANn8A/RBhJUQUxpDwFCrkVRsns/StjxCQbStcSYpUkZzFaQ7oLvEbyW1Qoff3+yKzBBGM8=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1340.namprd12.prod.outlook.com (10.168.238.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 15 Jul 2019 22:38:06 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 22:38:06 +0000
From:   Gary R Hook <ghook@amd.com>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Cfir Cohen <cfir@google.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch v2] crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL
Thread-Topic: [patch v2] crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL
Thread-Index: AQHVOPJDWffUz++qVUKJ+pK3+oHjfKbL7HiAgABdkIA=
Date:   Mon, 15 Jul 2019 22:38:05 +0000
Message-ID: <144dda9d-5184-abda-f3d5-e9d5e1fe2cc2@amd.com>
References: <alpine.DEB.2.21.1907101426290.2777@chino.kir.corp.google.com>
 <e30eae0f-415b-842e-39c4-801227126367@amd.com>
 <alpine.DEB.2.21.1907121341210.37390@chino.kir.corp.google.com>
 <b98e9be5-debc-2d75-033d-04247313a18a@amd.com>
In-Reply-To: <b98e9be5-debc-2d75-033d-04247313a18a@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0201CA0022.namprd02.prod.outlook.com
 (2603:10b6:803:2b::32) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7805b71e-00ce-4ce9-7262-08d709751a62
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM5PR12MB1340;
x-ms-traffictypediagnostic: DM5PR12MB1340:
x-microsoft-antispam-prvs: <DM5PR12MB1340AEA699592ABFF139A796FDCF0@DM5PR12MB1340.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(199004)(189003)(6486002)(66066001)(110136005)(66556008)(54906003)(36756003)(66476007)(316002)(64756008)(66446008)(53546011)(386003)(6506007)(53936002)(6512007)(2906002)(7736002)(305945005)(6246003)(66946007)(99286004)(31686004)(25786009)(31696002)(102836004)(68736007)(14454004)(486006)(81166006)(5660300002)(26005)(52116002)(14444005)(81156014)(71190400001)(186003)(8676002)(8936002)(2616005)(476003)(229853002)(11346002)(446003)(4326008)(256004)(6436002)(71200400001)(478600001)(6116002)(76176011)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1340;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MH0XpArxVjE8afvm2Kk3o1mOZ4bmgT/wzlPIFp2JZL7Ey6FAhTgmTFS16i4EwyyNRNXLEKz8oj8sNenarv0Vn6YoZ33lQq060H24uJ4hKTExGr8Q1D3Vm6gkwb5Hfi/7xnYpmN85GEEWgm6DcwBVWHLk3cy8kbYaCUmRF387Q3gvbifIfyYqyCBBAnLREjjnjvyP7HOXvnqEE5CX6kWifNnY7/9JUDYfInP6grwfUkm1GjiC/gFBqjcVQRc7Wts2kNf2breFRBNCHXECz3BeS0/cogDQfnADAbNZuWXjNb3Tjg+J4P8rxdeEERtmjCHv75Cvj0tk+itUMF+uX1nqEOYrxoClphCaJoDuwtuNNAN+Lq2L43ggbpI+qzUiSJqQhJm4Gtmrg0FPIXRZ5jrzyqK0F5b/CJ44cb+Nn2W8yuw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7B3FABFABBEDF47B1AC0A0246F8EDF2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7805b71e-00ce-4ce9-7262-08d709751a62
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 22:38:05.7339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1340
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy8xNS8xOSAxMjowMyBQTSwgTGVuZGFja3ksIFRob21hcyB3cm90ZToNCj4gT24gNy8xMi8x
OSAzOjQxIFBNLCBEYXZpZCBSaWVudGplcyB3cm90ZToNCj4+IFNFVl9WRVJTSU9OX0dSRUFURVJf
T1JfRVFVQUwoKSB3aWxsIGZhaWwgaWYgdXBncmFkaW5nIGZyb20gMi4yIHRvIDMuMSwgZm9yDQo+
PiBleGFtcGxlLCBiZWNhdXNlIHRoZSBtaW5vciB2ZXJzaW9uIGlzIG5vdCBlcXVhbCB0byBvciBn
cmVhdGVyIHRoYW4gdGhlDQo+PiBtYWpvci4NCj4+DQo+PiBGaXggdGhpcyBhbmQgbW92ZSB0byBh
IHN0YXRpYyBpbmxpbmUgZnVuY3Rpb24gZm9yIGFwcHJvcHJpYXRlIHR5cGUNCj4+IGNoZWNraW5n
Lg0KPj4NCj4+IEZpeGVzOiBlZGQzMDNmZjBlOWUgKCJjcnlwdG86IGNjcCAtIEFkZCBET1dOTE9B
RF9GSVJNV0FSRSBTRVYgY29tbWFuZCIpDQo+PiBSZXBvcnRlZC1ieTogQ2ZpciBDb2hlbiA8Y2Zp
ckBnb29nbGUuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgUmllbnRqZXMgPHJpZW50amVz
QGdvb2dsZS5jb20+DQo+IA0KPiBBY2tlZC1ieTogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFj
a3lAYW1kLmNvbT4NCg0KQWNrZWQtYnk6IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tAYW1kLmNvbT4N
Cg0KPiANCj4+IC0tLQ0KPj4gICB2Mjogbm8gbmVlZCB0byBjaGVjayBhcGlfbWFqb3IgPj0gbWFq
IGFmdGVyIGNoZWNraW5nIGFwaV9tYWpvciA+IG1hag0KPj4gICAgICAgcGVyIFRob21hcw0KPj4N
Cj4+ICAgZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuYyB8IDE5ICsrKysrKysrKysrKy0tLS0t
LS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0p
DQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2LmMgYi9kcml2
ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5jDQo+PiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvcHNw
LWRldi5jDQo+PiArKysgYi9kcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5jDQo+PiBAQCAtMjQs
MTAgKzI0LDYgQEANCj4+ICAgI2luY2x1ZGUgInNwLWRldi5oIg0KPj4gICAjaW5jbHVkZSAicHNw
LWRldi5oIg0KPj4gICANCj4+IC0jZGVmaW5lIFNFVl9WRVJTSU9OX0dSRUFURVJfT1JfRVFVQUwo
X21haiwgX21pbikJXA0KPj4gLQkJKChwc3BfbWFzdGVyLT5hcGlfbWFqb3IpID49IF9tYWogJiYJ
XA0KPj4gLQkJIChwc3BfbWFzdGVyLT5hcGlfbWlub3IpID49IF9taW4pDQo+PiAtDQo+PiAgICNk
ZWZpbmUgREVWSUNFX05BTUUJCSJzZXYiDQo+PiAgICNkZWZpbmUgU0VWX0ZXX0ZJTEUJCSJhbWQv
c2V2LmZ3Ig0KPj4gICAjZGVmaW5lIFNFVl9GV19OQU1FX1NJWkUJNjQNCj4+IEBAIC00Nyw2ICs0
MywxNSBAQCBNT0RVTEVfUEFSTV9ERVNDKHBzcF9wcm9iZV90aW1lb3V0LCAiIGRlZmF1bHQgdGlt
ZW91dCB2YWx1ZSwgaW4gc2Vjb25kcywgZHVyaW5nDQo+PiAgIHN0YXRpYyBib29sIHBzcF9kZWFk
Ow0KPj4gICBzdGF0aWMgaW50IHBzcF90aW1lb3V0Ow0KPj4gICANCj4+ICtzdGF0aWMgaW5saW5l
IGJvb2wgc2V2X3ZlcnNpb25fZ3JlYXRlcl9vcl9lcXVhbCh1OCBtYWosIHU4IG1pbikNCj4+ICt7
DQo+PiArCWlmIChwc3BfbWFzdGVyLT5hcGlfbWFqb3IgPiBtYWopDQo+PiArCQlyZXR1cm4gdHJ1
ZTsNCj4+ICsJaWYgKHBzcF9tYXN0ZXItPmFwaV9tYWpvciA9PSBtYWogJiYgcHNwX21hc3Rlci0+
YXBpX21pbm9yID49IG1pbikNCj4+ICsJCXJldHVybiB0cnVlOw0KPj4gKwlyZXR1cm4gZmFsc2U7
DQo+PiArfQ0KPj4gKw0KPj4gICBzdGF0aWMgc3RydWN0IHBzcF9kZXZpY2UgKnBzcF9hbGxvY19z
dHJ1Y3Qoc3RydWN0IHNwX2RldmljZSAqc3ApDQo+PiAgIHsNCj4+ICAgCXN0cnVjdCBkZXZpY2Ug
KmRldiA9IHNwLT5kZXY7DQo+PiBAQCAtNTg4LDcgKzU5Myw3IEBAIHN0YXRpYyBpbnQgc2V2X2lv
Y3RsX2RvX2dldF9pZDIoc3RydWN0IHNldl9pc3N1ZV9jbWQgKmFyZ3ApDQo+PiAgIAlpbnQgcmV0
Ow0KPj4gICANCj4+ICAgCS8qIFNFViBHRVRfSUQgaXMgYXZhaWxhYmxlIGZyb20gU0VWIEFQSSB2
MC4xNiBhbmQgdXAgKi8NCj4+IC0JaWYgKCFTRVZfVkVSU0lPTl9HUkVBVEVSX09SX0VRVUFMKDAs
IDE2KSkNCj4+ICsJaWYgKCFzZXZfdmVyc2lvbl9ncmVhdGVyX29yX2VxdWFsKDAsIDE2KSkNCj4+
ICAgCQlyZXR1cm4gLUVOT1RTVVBQOw0KPj4gICANCj4+ICAgCWlmIChjb3B5X2Zyb21fdXNlcigm
aW5wdXQsICh2b2lkIF9fdXNlciAqKWFyZ3AtPmRhdGEsIHNpemVvZihpbnB1dCkpKQ0KPj4gQEAg
LTY1MSw3ICs2NTYsNyBAQCBzdGF0aWMgaW50IHNldl9pb2N0bF9kb19nZXRfaWQoc3RydWN0IHNl
dl9pc3N1ZV9jbWQgKmFyZ3ApDQo+PiAgIAlpbnQgcmV0Ow0KPj4gICANCj4+ICAgCS8qIFNFViBH
RVRfSUQgYXZhaWxhYmxlIGZyb20gU0VWIEFQSSB2MC4xNiBhbmQgdXAgKi8NCj4+IC0JaWYgKCFT
RVZfVkVSU0lPTl9HUkVBVEVSX09SX0VRVUFMKDAsIDE2KSkNCj4+ICsJaWYgKCFzZXZfdmVyc2lv
bl9ncmVhdGVyX29yX2VxdWFsKDAsIDE2KSkNCj4+ICAgCQlyZXR1cm4gLUVOT1RTVVBQOw0KPj4g
ICANCj4+ICAgCS8qIFNFViBGVyBleHBlY3RzIHRoZSBidWZmZXIgaXQgZmlsbHMgd2l0aCB0aGUg
SUQgdG8gYmUNCj4+IEBAIC0xMDUzLDcgKzEwNTgsNyBAQCB2b2lkIHBzcF9wY2lfaW5pdCh2b2lk
KQ0KPj4gICAJCXBzcF9tYXN0ZXItPnNldl9zdGF0ZSA9IFNFVl9TVEFURV9VTklOSVQ7DQo+PiAg
IAl9DQo+PiAgIA0KPj4gLQlpZiAoU0VWX1ZFUlNJT05fR1JFQVRFUl9PUl9FUVVBTCgwLCAxNSkg
JiYNCj4+ICsJaWYgKHNldl92ZXJzaW9uX2dyZWF0ZXJfb3JfZXF1YWwoMCwgMTUpICYmDQo+PiAg
IAkgICAgc2V2X3VwZGF0ZV9maXJtd2FyZShwc3BfbWFzdGVyLT5kZXYpID09IDApDQo+PiAgIAkJ
c2V2X2dldF9hcGlfdmVyc2lvbigpOw0KPj4gICANCj4+DQoNCg==
