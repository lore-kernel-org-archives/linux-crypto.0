Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900D5C4646C
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 22:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63AC620665
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 22:41:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="wHVLMW+o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfFXWl1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 18:41:27 -0400
Received: from mail-eopbgr690073.outbound.protection.outlook.com ([40.107.69.73]:5088
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726397AbfFXWl0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 18:41:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=de1ZbnYmggR7u3DiSnf6YuGYsVMWr6r7hmhxSXcjFYY=;
 b=wHVLMW+oKrIqPmUQ7qtjoRIn9O7EModJfNFsioMUmoW47Li5CmDd4FIp89RHN2u7BUbghKcbaggXA0eqE5W8wWhzShdxD0yA1YlMGVsGk3yjcHvhw5TgvFcJTjKjO8+7c7OIKdE8DB2L4u5reEIL+SW5VNksPRcOF61DiQFNpq0=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3499.namprd12.prod.outlook.com (20.178.199.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 22:41:24 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 22:41:24 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 06/11] crypto: ccp - Specify a single CCP via PCI device
 ID
Thread-Topic: [PATCH 06/11] crypto: ccp - Specify a single CCP via PCI device
 ID
Thread-Index: AQHVKsMbZWer+vRI6EyFef4cWjV9/6arZl4A
Date:   Mon, 24 Jun 2019 22:41:24 +0000
Message-ID: <fc472e11-5414-a2a0-00a0-7b2741e08fc8@amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
 <156140455020.116890.2457308391471121920.stgit@sosrh3.amd.com>
In-Reply-To: <156140455020.116890.2457308391471121920.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0050.namprd12.prod.outlook.com
 (2603:10b6:802:20::21) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c81669d-d0d1-4315-34c0-08d6f8f51604
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3499;
x-ms-traffictypediagnostic: DM6PR12MB3499:
x-microsoft-antispam-prvs: <DM6PR12MB3499631F5A66961AA168508AECE00@DM6PR12MB3499.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(346002)(39860400002)(396003)(189003)(199004)(52116002)(6486002)(53546011)(68736007)(99286004)(31686004)(81156014)(6506007)(110136005)(386003)(54906003)(316002)(76176011)(2906002)(36756003)(66066001)(81166006)(186003)(102836004)(8936002)(7736002)(305945005)(26005)(8676002)(2501003)(256004)(72206003)(14444005)(6436002)(6246003)(4326008)(6512007)(25786009)(446003)(486006)(66446008)(64756008)(66556008)(14454004)(6116002)(71200400001)(229853002)(5660300002)(2616005)(11346002)(476003)(66476007)(3846002)(71190400001)(478600001)(53936002)(86362001)(73956011)(31696002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3499;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B/wsj9eXgypaTwiqjx9FqRunYXNdAayjWjBbtbfGZoxMsnQYXfyIy0M7MjZvnrJ+/0J2QMnPI4zM/zFNxVACvZ1Y+CGyeKLJUgF4Qrkq46rIpWC+bwsaS5szlbmX/1Oo44aB8UNQ4CbHf98kX075JGaUapB75WJ6QLSgx4V5aGp92ufTlxk3ZwB7WBw4CKV7/IOd3rhn33L7IGUaOT6vFg5bCUVP2fmPEo5KFVzRJj4gOcUNZ0TsmM7zMiwVp4N2RRgUSNt238UVwizRxjr8yLe1ePZOYRhw/jOpAaDT5+VXQ0cAvQmcrDwKd4UjxOKQ9lGETfJEmBRAKCnLUbf7ISkAvVIbLp92eNirZrwrm1Hn7P3VCd4UoPb1fs07B1yfAkZxzof7bn3D3fzAa1isbNuLIm1oS2W/7Y8z3gcDRVk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <751B97CB4B18BA4B9E07C6F3590E087F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c81669d-d0d1-4315-34c0-08d6f8f51604
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 22:41:24.2202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3499
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yNC8xOSAyOjI5IFBNLCBIb29rLCBHYXJ5IHdyb3RlOg0KPiBTb21lIHByb2Nlc3NvcnMg
Y29udGFpbiBtdWx0aXBsZSBDQ1BzIHdpdGggZGlmZmVyaW5nIGRldmljZSBJRHMuIEVuYWJsZQ0K
PiB0aGUgc2VsZWN0aW9uIG9mIHNwZWNpZmljIGRldmljZXMgYmFzZWQgb24gSUQuIFRoZSBwYXJh
bWV0ZXIgdmFsdWUgaXMNCj4gYSBzaW5nbGUgUENJIElELg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
R2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvY3J5cHRv
L2NjcC9zcC1wY2kuYyB8ICAgIDcgKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0
aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYyBi
L2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KPiBpbmRleCAyOTE3N2QxMTNjOTAuLmIwMjRi
OTJmYjc0OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQo+ICsr
KyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KPiBAQCAtMzYsNiArMzYsOSBAQA0KPiAg
LyoNCj4gICAqIExpbWl0IENDUCB1c2UgdG8gYSBzcGVjaWZlZCBudW1iZXIgb2YgcXVldWVzIHBl
ciBkZXZpY2UuDQo+ICAgKi8NCj4gK3N0YXRpYyB1bnNpZ25lZCBpbnQgcGNpZGV2Ow0KPiArbW9k
dWxlX3BhcmFtKHBjaWRldiwgdWludCwgMDQ0NCk7DQo+ICtNT0RVTEVfUEFSTV9ERVNDKHBjaWRl
diwgIkRldmljZSBudW1iZXIgZm9yIGEgc3BlY2lmaWMgQ0NQIik7DQo+ICANCj4gIHN0YXRpYyBz
dHJ1Y3QgbXV0ZXggZGV2Y291bnRfbXV0ZXggX19fX2NhY2hlbGluZV9hbGlnbmVkOw0KPiAgc3Rh
dGljIHVuc2lnbmVkIGludCBkZXZjb3VudCA9IDA7DQo+IEBAIC0yMDQsNiArMjA3LDEwIEBAIHN0
YXRpYyBpbnQgc3BfcGNpX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3Qg
cGNpX2RldmljZV9pZCAqaWQpDQo+ICAJaWYgKG1heGRldiAmJiAoZGV2Y291bnQgPj0gbWF4ZGV2
KSkgLyogVG9vIG1hbnkgZGV2aWNlcz8gKi8NCj4gIAkJcmV0dXJuIDA7DQo+ICANCj4gKwkvKiBJ
ZiBhIHNwZWNpZmljIGRldmljZSBJRCBoYXMgYmVlbiBzcGVjaWZpZWQsIGZpbHRlciBmb3IgaXQg
Ki8NCj4gKyAgICAgICAgaWYgKHBjaWRldiAmJiAocGRldi0+ZGV2aWNlICE9IHBjaWRldikpDQo+
ICsgICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gMDsNCj4gKw0KDQpBZ2FpbiwgdGhpcyBj
b3VsZCBpbnRlcmZlcmUgd2l0aCBkZXZpY2VzIHRoYXQgc3VwcG9ydCB0aGUgQ0NQIGFuZCBQU1As
IHNvDQphZGRpdGlvbmFsIGNoZWNraW5nLiBZb3UgY291bGQgZ2V0IGF3YXkgd2l0aCB0aGlzIGNo
ZWNrIGZvciB0aGUgY2NwdjViDQpkZXZpY2UsIGJ1dCBub3QgdGhlIGNjcHY1YSBkZXZpY2UuDQoN
ClRoYW5rcywNClRvbQ0KDQo+ICAJcmV0ID0gLUVOT01FTTsNCj4gIAlzcCA9IHNwX2FsbG9jX3N0
cnVjdChkZXYpOw0KPiAgCWlmICghc3ApDQo+IA0K
