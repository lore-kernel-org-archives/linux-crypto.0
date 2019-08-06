Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619D6C433FF
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 16:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24768216B7
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 16:45:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="zPl+0Nwy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733096AbfHFQpl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 12:45:41 -0400
Received: from mail-eopbgr680084.outbound.protection.outlook.com ([40.107.68.84]:65444
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728927AbfHFQpl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 12:45:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BirbfGngHY08avGz/EtainoatoBzWCJLc7nn7Y32NkWC/qgGG/nNA86Y9o1B+rHZWgL1sKXbP+CEjFfkaf6WnUKIUmWfFWw6tdTCC+93vtJ3QMLhQ/TFBoFrtuKEu2eb0JrfrMEjy6VdXDw8uJ1tb77JGcicebnyAHCkdwsfxnfINg68utjPtPa0ikjnEHLz9yyQlqKZhB2Cqe1/DgNhS0mJuC2lrgHXJ9bCkJonui3AY67tk0Dx+CHi4MYkLNkB8HRd1UJjOz2VkYbNlc8wuwV8lVmBPBhFR/s6+iZsPtl7Cvz1lsmUten10yumiqeotqgR23rUx5itXRyVjKqVbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LzqV3JBi3dVeEJa4wSn7udYRVIrgLY/TjRWTqFby6rU=;
 b=JXoIIPxBVHsJag9g8UB3k9xA+5NjHVmWnCD5J30x65FZNouiRdbOa6eF6ekerHWyE2c9FIUp38J6+KIv/mNv9tHYqSNNWieLMe+fh/QurhUGbiBz1gL0oliXGTfyMYNorlPZBCeUgy7LhHIv4SUTV/BJziDKoj6gmZiOVvtTmoGSCwOJws0C5oya4TEBmfkjT6aH5HWruy6EqGpsM3+A9CL2GnZF6mkjdShN/I/kgBnsZH/CFWkIFn8uOXHHcdLzEEsEo15JRROaZKblSFoYKjQuYnJPDnnwqEbjonB+GR4+9M4l4rvy0bkSs/YtRLAHOs9/ii4Nd9QMKQjK86LZYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LzqV3JBi3dVeEJa4wSn7udYRVIrgLY/TjRWTqFby6rU=;
 b=zPl+0Nwypa6UGDhasw36oJ7C/QVdHh7cjfMReKr26agng45hiQEjjAClmX+iovkv7QnWYrXNdw3FfjXXypgXA+0Eq5irdVj74cfEs5Qm0oKTcb5DuX0PMI1PARku8dBwizfhcVkzvBeWnwJBKV24nx7ayHq3Jupwz/VYJFGFBLg=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2503.namprd12.prod.outlook.com (52.132.141.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Tue, 6 Aug 2019 16:44:58 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::f9ec:92b6:9a0f:30ca]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::f9ec:92b6:9a0f:30ca%6]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 16:44:58 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 1/2] crypto: ccp - Include DMA declarations explicitly
Thread-Topic: [PATCH 1/2] crypto: ccp - Include DMA declarations explicitly
Thread-Index: AQHVSYjr4ho/cEzArkKkrlZJQvK8r6buWXuA
Date:   Tue, 6 Aug 2019 16:44:57 +0000
Message-ID: <33e14857-a54f-1077-b9e4-c2945074a626@amd.com>
References: <20190802232013.15957-1-helgaas@kernel.org>
 <20190802232013.15957-2-helgaas@kernel.org>
In-Reply-To: <20190802232013.15957-2-helgaas@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:805:8e::20) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a9806f5-bf54-4a31-406a-08d71a8d6a78
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2503;
x-ms-traffictypediagnostic: DM5PR12MB2503:
x-microsoft-antispam-prvs: <DM5PR12MB25038068B7B30816198C21DDFDD50@DM5PR12MB2503.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(199004)(189003)(31686004)(6246003)(305945005)(476003)(7736002)(25786009)(229853002)(6636002)(11346002)(36756003)(8936002)(186003)(26005)(8676002)(4326008)(486006)(3846002)(6512007)(6116002)(2616005)(6486002)(66066001)(81166006)(81156014)(53936002)(6436002)(2906002)(68736007)(446003)(478600001)(54906003)(71190400001)(64756008)(110136005)(71200400001)(66446008)(6506007)(66556008)(66476007)(316002)(102836004)(76176011)(256004)(99286004)(31696002)(5660300002)(52116002)(386003)(53546011)(14454004)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2503;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: h9yW0HhJUuVo1qWGQF006/ti3AnN7N5uNNqQP9NpwItHivhgBe3PdKZ394tJXfy3fzIhzQmvxLPwz8d4AeIjhebtk+g/gWKFh+puRyVeXqAqY74QsmF2ASx15q1FGDWH/jmCLF06IPmVaifj9a5bJVKYhoWeRBcthI5XoRNDMPfiP0UEAs5oaUpX8aFEwhIazkWmUX2bj5uYoLY1mFgR0wjRZtUqOpN8Q+ctPpxqLZSfGE9m9eOSicZF5DJ8PCsmAvTca6yKc/dxgc9TWcx1Vg0gqZjxMUTIxFUEivkDlN6drYgOzoyDKSstSVR0jPbHwzQ4MOF4ASVerMW0ACrtleIvVuHh7Nzl2y5CY/Pl34qhbCOeTzTJwstjgFQV77ZtcgAGmOILLJiX58vd2flRucXVS+qdhz6Jb29uNSk3ptE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A9D5D002734CA40A32C0C1DB51C02DD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a9806f5-bf54-4a31-406a-08d71a8d6a78
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 16:44:58.1868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2503
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gOC8yLzE5IDY6MjAgUE0sIEJqb3JuIEhlbGdhYXMgd3JvdGU6DQo+IEZyb206IEJqb3JuIEhl
bGdhYXMgPGJoZWxnYWFzQGdvb2dsZS5jb20+DQo+IA0KPiBjY3AtZGV2LmggdXNlcyBkbWFfZGly
ZWN0aW9uLCB3aGljaCBpcyBkZWZpbmVkIGluIGxpbnV4L2RtYS1kaXJlY3Rpb24uaC4NCj4gSW5j
bHVkZSB0aGF0IGV4cGxpY2l0bHkgaW5zdGVhZCBvZiByZWx5aW5nIG9uIGl0IGJlaW5nIGluY2x1
ZGVkIHZpYQ0KPiBsaW51eC9wY2kuaCwgc2luY2UgY2NwLWRldi5oIHJlcXVpcmVzIG5vdGhpbmcg
ZWxzZSBmcm9tIGxpbnV4L3BjaS5oLg0KPiANCj4gU2ltaWxhcmx5LCBjY3AtZG1hZW5naW5lLmMg
dXNlcyBkbWFfZ2V0X21hc2soKSwgd2hpY2ggaXMgZGVmaW5lZCBpbg0KPiBsaW51eC9kbWEtbWFw
cGluZy5oLCBzbyBpbmNsdWRlIHRoYXQgZXhwbGljaXRseSBzaW5jZSBpdCByZXF1aXJlcyBub3Ro
aW5nDQo+IGVsc2UgZnJvbSBsaW51eC9wY2kuaC4NCj4gDQo+IEEgZnV0dXJlIHBhdGNoIHdpbGwg
cmVtb3ZlIHRoZSBpbmNsdWRlcyBvZiBsaW51eC9wY2kuaCB3aGVyZSBpdCBpcyBub3QNCj4gbmVl
ZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmpvcm4gSGVsZ2FhcyA8YmhlbGdhYXNAZ29vZ2xl
LmNvbT4NCg0KQWNrZWQtYnk6IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tAYW1kLmNvbT4NCg0KPiAt
LS0NCj4gICBkcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oICAgICAgIHwgMSArDQo+ICAgZHJp
dmVycy9jcnlwdG8vY2NwL2NjcC1kbWFlbmdpbmUuYyB8IDEgKw0KPiAgIDIgZmlsZXMgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2Nw
L2NjcC1kZXYuaCBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LmgNCj4gaW5kZXggNWU2MjQ5
MjBmZDk5Li44OWFlZTA5MDBhMDYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9j
Y3AtZGV2LmgNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYuaA0KPiBAQCAtMTcs
NiArMTcsNyBAQA0KPiAgICNpbmNsdWRlIDxsaW51eC9tdXRleC5oPg0KPiAgICNpbmNsdWRlIDxs
aW51eC9saXN0Lmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L3dhaXQuaD4NCj4gKyNpbmNsdWRlIDxs
aW51eC9kbWEtZGlyZWN0aW9uLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L2RtYXBvb2wuaD4NCj4g
ICAjaW5jbHVkZSA8bGludXgvaHdfcmFuZG9tLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L2JpdG9w
cy5oPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kbWFlbmdpbmUuYyBi
L2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZG1hZW5naW5lLmMNCj4gaW5kZXggN2YyMmE0NWJiYzEx
Li5mNjlkNDk1ODczZjAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZG1h
ZW5naW5lLmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kbWFlbmdpbmUuYw0KPiBA
QCAtOSw2ICs5LDcgQEANCj4gICANCj4gICAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQo+ICAg
I2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L2RtYS1tYXBwaW5n
Lmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L2RtYWVuZ2luZS5oPg0KPiAgICNpbmNsdWRlIDxsaW51
eC9zcGlubG9jay5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9tdXRleC5oPg0KPiANCg0K
