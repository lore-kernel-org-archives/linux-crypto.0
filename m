Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36804C4646C
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 22:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0196E20820
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 22:45:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="QPmvI03Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfFXWpE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 18:45:04 -0400
Received: from mail-eopbgr710067.outbound.protection.outlook.com ([40.107.71.67]:18432
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726397AbfFXWpE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 18:45:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boI2jyzBIXd2Ff3/NQqrHrABjGlvvFgEJvUfySUGiNs=;
 b=QPmvI03ZRGt8tH7nrg45HnWtCeuDytzr8r6TwCtR/WiT2iMW8e/9dcrI332JhPVay0LVRj9qYDKTTbM7epOT7j7aM+/rswUEE+vWfCjLkl8CYnHtNwpKij/nmquIAnQnKolgUO9DDSN/DkSpeh2GoxLZOnKjdKFiqKUhLT7XKWM=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3499.namprd12.prod.outlook.com (20.178.199.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 22:45:01 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 22:45:01 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 10/11] crypto: ccp - Add a module parameter to control
 registration for DMA
Thread-Topic: [PATCH 10/11] crypto: ccp - Add a module parameter to control
 registration for DMA
Thread-Index: AQHVKsMrwoV0mzu7PUWfsCpihtfZJKarZ18A
Date:   Mon, 24 Jun 2019 22:45:00 +0000
Message-ID: <b8c3fb43-a426-31e4-e8de-29d3aea087c2@amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
 <156140457814.116890.11773936937983757340.stgit@sosrh3.amd.com>
In-Reply-To: <156140457814.116890.11773936937983757340.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN2PR01CA0042.prod.exchangelabs.com (2603:10b6:804:2::52)
 To DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34a75fc4-ae75-44d4-f6c1-08d6f8f5972f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3499;
x-ms-traffictypediagnostic: DM6PR12MB3499:
x-microsoft-antispam-prvs: <DM6PR12MB349945557E9A9927ACDFF064ECE00@DM6PR12MB3499.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(346002)(39860400002)(396003)(189003)(199004)(52116002)(6486002)(53546011)(68736007)(99286004)(31686004)(81156014)(6506007)(110136005)(386003)(54906003)(316002)(76176011)(2906002)(36756003)(66066001)(81166006)(186003)(102836004)(8936002)(7736002)(305945005)(26005)(8676002)(2501003)(256004)(72206003)(14444005)(6436002)(6246003)(4326008)(6512007)(25786009)(446003)(486006)(66446008)(64756008)(66556008)(14454004)(6116002)(71200400001)(229853002)(5660300002)(2616005)(11346002)(476003)(66476007)(3846002)(71190400001)(478600001)(53936002)(86362001)(73956011)(31696002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3499;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PDeDGi+s4FdECg4Kh44R8MxGZ+hHJagRUokHb+3KKc4V97UdKvm9z2TNpBi9Th+HoT0tkaMIuklsBFd/wzkncG8KV7UwyEzUf9zFgC8u1E36VHLSqcvRHdJ0lFNp5LpzjFVFio/V21n0kWPBo/UUZHcOUEAyj4E1P3psF+OGiXVlPyRj2bLg+DVkcv0TL5xf8obmijOj3F8qfztD09m+CCwhSXvOZQKN1+X8798Dj0o5T7KIJToc10CLAcwTpYQA9gnJwDrwrjZhxeUdP4GejEnyzvt8LizypsNEAGCrkrx83dmqk6iA81W0BoVGxHCaLg3F/OLs5/+U2tHwAMgHLR7AsD6uIUZwkQFkv6gdsJKZg+i5L9PBQHwNTRelbBbN0DpmtBpoY/ml+TtSfnycHcTt/zsK0DygKqSYR7uNkBQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6819672DCC9D28408F0F1D75B49BFF3A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a75fc4-ae75-44d4-f6c1-08d6f8f5972f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 22:45:00.8551
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

T24gNi8yNC8xOSAyOjI5IFBNLCBIb29rLCBHYXJ5IHdyb3RlOg0KPiBUaGUgQ0NQIGRyaXZlciBp
cyBhYmxlIHRvIGFjdCBhcyBhIERNQSBlbmdpbmUuIEFkZCBhIG1vZHVsZSBwYXJhbWV0ZXIgdGhh
dA0KPiBhbGxvd3MgdGhpcyBmZWF0dXJlIHRvIGJlIGVuYWJsZWQvZGlzYWJsZWQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBHYXJ5IFIgSG9vayA8Z2FyeS5ob29rQGFtZC5jb20+DQo+IC0tLQ0KPiAg
ZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYyB8ICAgMTEgKysrKysrKy0tLS0NCj4gIGRy
aXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LmggICAgfCAgICAxICsNCj4gIGRyaXZlcnMvY3J5cHRv
L2NjcC9zcC1wY2kuYyAgICAgfCAgICA4ICsrKysrKysrDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDE2
IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LXY1
LmMNCj4gaW5kZXggZmZkNTQ2Yjk1MWI2Li5kZmQ4MDNmNmZiNTUgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2Nw
L2NjcC1kZXYtdjUuYw0KPiBAQCAtOTc2LDkgKzk3NiwxMSBAQCBzdGF0aWMgaW50IGNjcDVfaW5p
dChzdHJ1Y3QgY2NwX2RldmljZSAqY2NwKQ0KPiAgCQlnb3RvIGVfa3RocmVhZDsNCj4gIA0KPiAg
CS8qIFJlZ2lzdGVyIHRoZSBETUEgZW5naW5lIHN1cHBvcnQgKi8NCj4gLQlyZXQgPSBjY3BfZG1h
ZW5naW5lX3JlZ2lzdGVyKGNjcCk7DQo+IC0JaWYgKHJldCkNCj4gLQkJZ290byBlX2h3cm5nOw0K
PiArCWlmIChjY3BfcmVnaXN0ZXJfZG1hKCkpIHsNCj4gKwkJcmV0ID0gY2NwX2RtYWVuZ2luZV9y
ZWdpc3RlcihjY3ApOw0KPiArCQlpZiAocmV0KQ0KPiArCQkJZ290byBlX2h3cm5nOw0KPiArCX0N
Cj4gIA0KPiAgI2lmZGVmIENPTkZJR19DUllQVE9fREVWX0NDUF9ERUJVR0ZTDQo+ICAJLyogU2V0
IHVwIGRlYnVnZnMgZW50cmllcyAqLw0KPiBAQCAtMTAxMyw3ICsxMDE1LDggQEAgc3RhdGljIHZv
aWQgY2NwNV9kZXN0cm95KHN0cnVjdCBjY3BfZGV2aWNlICpjY3ApDQo+ICAJdW5zaWduZWQgaW50
IGk7DQo+ICANCj4gIAkvKiBVbnJlZ2lzdGVyIHRoZSBETUEgZW5naW5lICovDQo+IC0JY2NwX2Rt
YWVuZ2luZV91bnJlZ2lzdGVyKGNjcCk7DQo+ICsJaWYgKGNjcF9yZWdpc3Rlcl9kbWEoKSkNCj4g
KwkJY2NwX2RtYWVuZ2luZV91bnJlZ2lzdGVyKGNjcCk7DQo+ICANCj4gIAkvKiBVbnJlZ2lzdGVy
IHRoZSBSTkcgKi8NCj4gIAljY3BfdW5yZWdpc3Rlcl9ybmcoY2NwKTsNCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LmggYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRl
di5oDQo+IGluZGV4IGNkMWJkNzhkOTVjYy4uMzIzZjdkOGNlNDU0IDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9j
Y3AtZGV2LmgNCj4gQEAgLTY0Nyw2ICs2NDcsNyBAQCBpbnQgY2NwX3JlZ2lzdGVyX3JuZyhzdHJ1
Y3QgY2NwX2RldmljZSAqY2NwKTsNCj4gIHZvaWQgY2NwX3VucmVnaXN0ZXJfcm5nKHN0cnVjdCBj
Y3BfZGV2aWNlICpjY3ApOw0KPiAgaW50IGNjcF9kbWFlbmdpbmVfcmVnaXN0ZXIoc3RydWN0IGNj
cF9kZXZpY2UgKmNjcCk7DQo+ICB2b2lkIGNjcF9kbWFlbmdpbmVfdW5yZWdpc3RlcihzdHJ1Y3Qg
Y2NwX2RldmljZSAqY2NwKTsNCj4gK3Vuc2lnbmVkIGludCBjY3BfcmVnaXN0ZXJfZG1hKHZvaWQp
Ow0KPiAgDQo+ICB2b2lkIGNjcDVfZGVidWdmc19zZXR1cChzdHJ1Y3QgY2NwX2RldmljZSAqY2Nw
KTsNCj4gIHZvaWQgY2NwNV9kZWJ1Z2ZzX2Rlc3Ryb3kodm9pZCk7DQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMgYi9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMN
Cj4gaW5kZXggODZkZWUyYTY2ZjAwLi41YjBhOWMxNDVjNWEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KPiArKysgYi9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNp
LmMNCj4gQEAgLTU3LDYgKzU3LDEwIEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgbnF1ZXVlcyA9IE1B
WF9IV19RVUVVRVM7DQo+ICBtb2R1bGVfcGFyYW0obnF1ZXVlcywgdWludCwgMDQ0NCk7DQo+ICBN
T0RVTEVfUEFSTV9ERVNDKG5xdWV1ZXMsICJOdW1iZXIgb2YgcXVldWVzIHBlciBDQ1AgKGRlZmF1
bHQ6IDUpIik7DQo+ICANCj4gK3N0YXRpYyB1bnNpZ25lZCBpbnQgcmVnaXN0ZXJkbWEgPSAxOw0K
PiArbW9kdWxlX3BhcmFtKHJlZ2lzdGVyZG1hLCB1aW50LCAwNDQ0KTsNCj4gK01PRFVMRV9QQVJN
X0RFU0MocmVnaXN0ZXJkbWEsICJSZWdpc3RlciBzZXJ2aWNlcyB3aXRoIHRoZSBETUEgZW5naW5l
IChkZWZhdWx0OiAxKSIpOw0KDQpTYW1lIGNvbW1lbnQgYXMgZWFybGllciwgdGhpcyBjYW4gbGl2
ZSBpbiB0aGUgQ0NQIHJlbGF0ZWQgZmlsZXMuIEFsc28sDQpvbmx5IGRvaW5nIHRoaXMgZm9yIHY1
LCBub3QgdjMgdG9vPw0KDQpUaGFua3MsDQpUb20NCg0KPiArDQo+ICAjZGVmaW5lIENPTU1BICAg
JywnDQo+ICBzdGF0aWMgdm9pZCBjY3BfcGFyc2VfcGNpX2J1c2VzKHZvaWQpDQo+ICB7DQo+IEBA
IC0xNTQsNiArMTU4LDEwIEBAIHVuc2lnbmVkIGludCBjY3BfZ2V0X25xdWV1ZXNfcGFyYW0odm9p
ZCkgew0KPiAgCXJldHVybiBucXVldWVzOw0KPiAgfQ0KPiAgDQo+ICt1bnNpZ25lZCBpbnQgY2Nw
X3JlZ2lzdGVyX2RtYSh2b2lkKSB7DQo+ICsJcmV0dXJuIHJlZ2lzdGVyZG1hOw0KPiArfQ0KPiAr
DQo+ICAjZGVmaW5lIE1TSVhfVkVDVE9SUwkJCTINCj4gIA0KPiAgc3RydWN0IHNwX3BjaSB7DQo+
IA0K
