Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F79C48BD4
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 13:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 889D22085A
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 13:06:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="Wq9+g6Te"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbfFYNG1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 09:06:27 -0400
Received: from mail-eopbgr800084.outbound.protection.outlook.com ([40.107.80.84]:56984
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728580AbfFYNG0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 09:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGTMK3mvsttZTkOCx8yA3H74/7+s8ssxcPAhKm2K4o8=;
 b=Wq9+g6TeidNld8mX49Q7T/lbShMNVcx9p7yHk7rYezUsPYQkyVBlPFdxdZkYtQC7ig9jInAydG1SpNR5nrABUlXvq891kxxtNHB4ZHCW01vQercZPkJWuCV7RCOKOkyLdW2wNN3iXxvrIp1bAI7kSRZzRc7epplMmhDgfmN5Ajw=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1850.namprd12.prod.outlook.com (10.175.86.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 13:06:24 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.017; Tue, 25 Jun
 2019 13:06:24 +0000
From:   Gary R Hook <ghook@amd.com>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 03/11] crypto: ccp - Expose the value of nqueues in
 DebugFS
Thread-Topic: [PATCH 03/11] crypto: ccp - Expose the value of nqueues in
 DebugFS
Thread-Index: AQHVKsMNjbQp7GUaYUqZRM2Nz4oxPKarWsCAgAD9TAA=
Date:   Tue, 25 Jun 2019 13:06:24 +0000
Message-ID: <4f3baf7b-38c8-a1ce-3b87-30c6663e1412@amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
 <156140452950.116890.8616947153652273997.stgit@sosrh3.amd.com>
 <6867970b-265b-1273-90a6-5a94ecdd445c@amd.com>
In-Reply-To: <6867970b-265b-1273-90a6-5a94ecdd445c@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN2PR01CA0057.prod.exchangelabs.com (2603:10b6:800::25) To
 DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 045d0ae8-e90e-4888-b93f-08d6f96dece0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1850;
x-ms-traffictypediagnostic: DM5PR12MB1850:
x-microsoft-antispam-prvs: <DM5PR12MB1850BE51140458547019E520FDE30@DM5PR12MB1850.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(366004)(346002)(189003)(199004)(54906003)(25786009)(2906002)(229853002)(14454004)(31686004)(72206003)(7736002)(305945005)(6436002)(73956011)(66446008)(71200400001)(6512007)(66946007)(14444005)(256004)(66476007)(64756008)(53936002)(66556008)(2501003)(186003)(316002)(110136005)(6486002)(76176011)(99286004)(36756003)(6246003)(81166006)(446003)(81156014)(8676002)(8936002)(52116002)(53546011)(26005)(71190400001)(6506007)(102836004)(386003)(11346002)(31696002)(4326008)(66066001)(68736007)(478600001)(3846002)(6116002)(5660300002)(486006)(476003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1850;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TodPPZJy8BIuIp773fOaX5GE5hJMjqUqKRESGjudgbWMmbUnFDzqc119j5WsUFPFWMNiU0e9CpbqWZiybYhIULAlbJ1NLkqA3kYu7eNfXzOlvrDHneM4aSxiqb3HhBE5itHFJbwJf681E7jGU0Zmw2igvhQsamVgVhUQ6w+cFqHZFSyia7dqDBw3mnsVYjzgXpPeEOcSnwwMh3k3gudso2SpX0GX3ar88T2SQb1odRjiTBp4HP96yI55hBte1sTG0RBvmjd467BEB+F++tko8YGVkP0FwsX3agqe3BoRznVEMfOWkJujyy5bPNy/9SG2fm8nO7DqVSuLx/YNg07ayCmOze4LLc0Gm86NQmv0Cpf65vOljKEPLVuMeDUljySQ/d02MSWaUgakLhBdt3/pxZp5pI9/dUCp5FUO3dAq4UE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F364459507598540BE590F6A4CB72907@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 045d0ae8-e90e-4888-b93f-08d6f96dece0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 13:06:24.3178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1850
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yNC8xOSA0OjU5IFBNLCBMZW5kYWNreSwgVGhvbWFzIHdyb3RlOg0KPiBPbiA2LzI0LzE5
IDI6MjggUE0sIEhvb2ssIEdhcnkgd3JvdGU6DQo+PiBNYWtlIG1vZHVsZSBwYXJhbWV0ZXJzIHJl
YWRhYmxlIGluIERlYnVnRlMuDQo+IA0KPiBOb3Qgc3VyZSB3aHkgeW91IGhhdmUgdGhpcy4uLiAg
eW91IGNhbiBhY2Nlc3MgdGhlIG1vZHVsZSBwYXJhbWV0ZXJzIGluDQo+IC9zeXMvbW9kdWxlL2Nj
cC9wYXJhbWV0ZXJzLiBZb3UgY2FuIHRoZW4gZ2V0L3NldCB0aGVtIGJhc2VkIG9uIHRoZQ0KPiB2
YWx1ZSBpbiB0aGUgbW9kdWxlX3BhcmFtKCkgZGVmaW5pdGlvbi4NCg0KSSdsbCB0YWtlICJ3aG8n
cyBhbiBpZGlvdCIgZm9yICQyMDAsIEFsZXguDQoNClRoZXJlJ2xsIGJlIHYyIHBhdGNoc2V0IGEt
Y29taW4nLg0KDQpncmgNCg0KDQo+IA0KPiBUaGFua3MsDQo+IFRvbQ0KPiANCj4+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBHYXJ5IFIgSG9vayA8Z2FyeS5ob29rQGFtZC5jb20+DQo+PiAtLS0NCj4+ICAg
ZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZWJ1Z2ZzLmMgfCAgICAyICsrDQo+PiAgIGRyaXZlcnMv
Y3J5cHRvL2NjcC9zcC1wY2kuYyAgICAgIHwgICAyMiArKysrKysrKysrKysrKysrKysrKysrDQo+
PiAgIDIgZmlsZXMgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRlYnVnZnMuYyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9j
Y3AtZGVidWdmcy5jDQo+PiBpbmRleCA0YmQyNmFmNzA5OGQuLmM0Y2MwZTYwZmQ1MCAxMDA2NDQN
Cj4+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGVidWdmcy5jDQo+PiArKysgYi9kcml2
ZXJzL2NyeXB0by9jY3AvY2NwLWRlYnVnZnMuYw0KPj4gQEAgLTMxNyw2ICszMTcsOCBAQCB2b2lk
IGNjcDVfZGVidWdmc19zZXR1cChzdHJ1Y3QgY2NwX2RldmljZSAqY2NwKQ0KPj4gICAJCQkJICAg
ICZjY3BfZGVidWdmc19xdWV1ZV9vcHMpOw0KPj4gICAJfQ0KPj4gICANCj4+ICsJY2NwX2RlYnVn
ZnNfcmVnaXN0ZXJfbW9kcGFyYW1zKGNjcF9kZWJ1Z2ZzX2Rpcik7DQo+PiArDQo+PiAgIAlyZXR1
cm47DQo+PiAgIH0NCj4+ICAgDQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL3Nw
LXBjaS5jIGIvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQo+PiBpbmRleCAzZmFiNzk1ODVm
NzIuLmMxNjdjNDY3MWY0NSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1w
Y2kuYw0KPj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQo+PiBAQCAtMjYsNiAr
MjYsMTAgQEANCj4+ICAgI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+DQo+PiAgICNpbmNsdWRlIDxs
aW51eC9jY3AuaD4NCj4+ICAgDQo+PiArI2lmZGVmIENPTkZJR19DUllQVE9fREVWX0NDUF9ERUJV
R0ZTDQo+PiArI2luY2x1ZGUgPGxpbnV4L2RlYnVnZnMuaD4NCj4+ICsjZW5kaWYNCj4+ICsNCj4+
ICAgI2luY2x1ZGUgImNjcC1kZXYuaCINCj4+ICAgI2luY2x1ZGUgInBzcC1kZXYuaCINCj4+ICAg
DQo+PiBAQCAtMzYsNiArNDAsMjQgQEAgc3RhdGljIHVuc2lnbmVkIGludCBucXVldWVzID0gTUFY
X0hXX1FVRVVFUzsNCj4+ICAgbW9kdWxlX3BhcmFtKG5xdWV1ZXMsIHVpbnQsIDA0NDQpOw0KPj4g
ICBNT0RVTEVfUEFSTV9ERVNDKG5xdWV1ZXMsICJOdW1iZXIgb2YgcXVldWVzIHBlciBDQ1AgKGRl
ZmF1bHQ6IDUpIik7DQo+PiAgIA0KPj4gKyNpZmRlZiBDT05GSUdfQ1JZUFRPX0RFVl9DQ1BfREVC
VUdGUw0KPj4gK21vZHBhcmFtX3QgICAgICBtb2R1bGVwYXJhbWV0ZXJzW10gPSB7DQo+PiArCXsi
bnF1ZXVlcyIsICZucXVldWVzLCBTX0lSVVNSfSwNCj4+ICsJe05VTEwsIE5VTEwsIDB9LA0KPj4g
K307DQo+PiArDQo+PiArdm9pZCBjY3BfZGVidWdmc19yZWdpc3Rlcl9tb2RwYXJhbXMoc3RydWN0
IGRlbnRyeSAqcGFyZW50ZGlyKQ0KPj4gK3sNCj4+ICsJaW50IGo7DQo+PiArDQo+PiArCWZvciAo
aiA9IDA7IG1vZHVsZXBhcmFtZXRlcnNbal0ucGFyYW1uYW1lOyBqKyspDQo+PiArCQlkZWJ1Z2Zz
X2NyZWF0ZV91MzIobW9kdWxlcGFyYW1ldGVyc1tqXS5wYXJhbW5hbWUsDQo+PiArCQkJCSAgIG1v
ZHVsZXBhcmFtZXRlcnNbal0ucGFyYW1tb2RlLCBwYXJlbnRkaXIsDQo+PiArCQkJCSAgIG1vZHVs
ZXBhcmFtZXRlcnNbal0ucGFyYW0pOw0KPj4gK30NCj4+ICsNCj4+ICsjZW5kaWYNCj4+ICsNCj4+
ICAgdW5zaWduZWQgaW50IGNjcF9nZXRfbnF1ZXVlc19wYXJhbSh2b2lkKSB7DQo+PiAgIAlyZXR1
cm4gbnF1ZXVlczsNCj4+ICAgfQ0KPj4NCg0K
