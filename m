Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742C9C3A5A6
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 13:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3464A21D79
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 13:29:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="PclmeN69"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389845AbfISN3X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 09:29:23 -0400
Received: from mail-eopbgr730054.outbound.protection.outlook.com ([40.107.73.54]:27264
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389844AbfISN3X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 09:29:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RByA/1X4RXvLEVaY8+uP5JURx4bdbJ8YbsE9kCcVhX8Wz6t90IF5k2/jWAIv0K6o8i0aXXnFEy9csr/t5VVdPBiXw/kLwlemgBrKAFiuX0wdhaQZgj412HYIS44z2f45M6SvHi5wbFtQ/ojho6bT+rV0YI/UpkxhMlSAysP6c/kb3qI/KNza5PNP/gsM1a4F+cA5Hxki+CyFzm6cS/tbWWGiYTlXLQHSAivdMDL67RsrkfuIxCc8E3jvFTLGpEcKPWDQHW1tUwOn9CGc5seOrPD+xzIPkX6SGc9PLrvxt8bbm1J/XGXXESxXXq1a0RyXoMTUKOebysx1VYxS9vkaHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iy1t/yNf8wTN/Zn2NhDq6kaq61fjVw2pcIVKIV6DxQ8=;
 b=EXp//hVsluwWsofnO5QVEIh6FRR5pEsTN9UFQbJGIALKeS8+6RbtuaDoPhU9vjY3RcreeJjzrLNVYj7Qx1ewUogDbLgV1nlfozVoF8FJ/KOE1n/HOIc7EbHhciv+nABh2Z6CYUNlXU2iBLyMpTcDQGysYg5QpH99pekRy0dMqPaFFO95eIcBzdzZqy8n9wGJgicO0rZLAUXo6Fv1O+ECSLRaPDVuZ81jp/Aw3J8MY8b9V1ZexqpI/LlR6T0PXWFO6xDDsajO6WGlfvG2J53fcFJxXecLoIYPitXgKqnQM+ptROLYXfzpdLhtTBOSxMk4ug1AIq6A+ytUJ55ONnHrIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iy1t/yNf8wTN/Zn2NhDq6kaq61fjVw2pcIVKIV6DxQ8=;
 b=PclmeN69kyZcveP25jRw+9dLpidmg9DJ7ul7mWlwNvFBR2+H+wos/YK/zAt3FzCPG1mYtr4e5iY3X6qCp+TSHaDYN9xPTDI6ys7dNR42ZGiiuD1XghsywGfI0CLLAWkPvDKgJdbP9lPrFPxezv05XImvXVBa5hWXtkP70dlu0yU=
Received: from MWHPR12MB1455.namprd12.prod.outlook.com (10.172.56.18) by
 MWHPR12MB1934.namprd12.prod.outlook.com (10.175.50.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.22; Thu, 19 Sep 2019 13:29:17 +0000
Received: from MWHPR12MB1455.namprd12.prod.outlook.com
 ([fe80::a872:70bf:908d:cfe4]) by MWHPR12MB1455.namprd12.prod.outlook.com
 ([fe80::a872:70bf:908d:cfe4%10]) with mapi id 15.20.2263.023; Thu, 19 Sep
 2019 13:29:17 +0000
From:   Gary R Hook <ghook@amd.com>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Navid Emamdoost <navid.emamdoost@gmail.com>
CC:     "emamd001@umn.edu" <emamd001@umn.edu>,
        "smccaman@umn.edu" <smccaman@umn.edu>,
        "kjlu@umn.edu" <kjlu@umn.edu>, "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp - release hmac_buf if ccp_run_sha_cmd fails
Thread-Topic: [PATCH] crypto: ccp - release hmac_buf if ccp_run_sha_cmd fails
Thread-Index: AQHVao3EuoZXtKbW6ku3QkZQMVvFD6cuTlmAgAS5AAA=
Date:   Thu, 19 Sep 2019 13:29:17 +0000
Message-ID: <7ffc6a77-f4e3-7db9-4ec6-53d6e01d881d@amd.com>
References: <20190913234824.8521-1-navid.emamdoost@gmail.com>
 <3550c7a3-2932-c222-c1b3-957def794150@amd.com>
In-Reply-To: <3550c7a3-2932-c222-c1b3-957def794150@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR0102CA0035.prod.exchangelabs.com (2603:10b6:805:1::48)
 To MWHPR12MB1455.namprd12.prod.outlook.com (2603:10b6:301:10::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d47b0faa-81d9-4b3d-387c-08d73d055edb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MWHPR12MB1934;
x-ms-traffictypediagnostic: MWHPR12MB1934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR12MB193426BCF27F5ED72B06EE7DFD890@MWHPR12MB1934.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(189003)(199004)(53546011)(6506007)(386003)(52116002)(76176011)(316002)(102836004)(26005)(186003)(31686004)(8936002)(81156014)(81166006)(5660300002)(99286004)(14454004)(66556008)(54906003)(110136005)(64756008)(66946007)(446003)(476003)(11346002)(486006)(2616005)(66476007)(66446008)(36756003)(8676002)(6116002)(3846002)(31696002)(71190400001)(25786009)(71200400001)(4326008)(6512007)(6246003)(229853002)(6436002)(6486002)(66066001)(478600001)(7736002)(305945005)(256004)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR12MB1934;H:MWHPR12MB1455.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IXQKnoq/ovnJusTyNY1GX+sNN7eD+cs+AR/FS+ZKYVLKglokwyuj+cgssd+U6y+n6eqQSMJNPAhzfq4abGB1VDk9fcZSQVmDd9+3jxFoIy5HDASBmNT4SsJiOtm+egVSxi4B0dkgNqkyXud1SIq4yEI9crX9zk8AgBiw++jisNSmmbo5l7BsEKmbW4goMo5eAEWZQ1O8mshWsabAdoZpxwX8LKRlPCSPkDLT5pOpy6CBHXi363muVQFuhV8u7+ZCDpt4Q12bvX99LPVBe2HCgoXgoPoh6PzdKLAydXHC2vo5TIOBZlQSTtwhIAkNply09WBNE2WlylqFV+jr6/xQST2gZHPbiDZ1YAQei6CbK6owK6DvDMjU60dOeNy3+AzhF2nBiIE1bFvx4nNDFMDQiff6cCwjVyqKI8Uq0s1SMYg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <863B982D545FF64BB2831692FEF4C574@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d47b0faa-81d9-4b3d-387c-08d73d055edb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 13:29:17.7178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4i47fKIsY/ykbovlHylKrM2d8Xo8i3QUTk1/aaI43Ryp5uCGkAAq3mwFam7NE93x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1934
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gOS8xNi8xOSA4OjIyIEFNLCBMZW5kYWNreSwgVGhvbWFzIHdyb3RlOg0KPiBPbiA5LzEzLzE5
IDY6NDggUE0sIE5hdmlkIEVtYW1kb29zdCB3cm90ZToNCj4+IEluIGNjcF9ydW5fc2hhX2NtZCwg
aWYgdGhlIHR5cGUgb2Ygc2hhIGlzIGludmFsaWQsIHRoZSBhbGxvY2F0ZWQNCj4+IGhtYWNfYnVm
IHNob3VsZCBiZSByZWxlYXNlZC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBOYXZpZCBFbWFtZG9v
c3QgPG5hdmlkLmVtYW1kb29zdEBnbWFpbC5jb20+DQo+PiAtLS0NCj4+ICAgZHJpdmVycy9jcnlw
dG8vY2NwL2NjcC1vcHMuYyB8IDEgKw0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYyBiL2Ry
aXZlcnMvY3J5cHRvL2NjcC9jY3Atb3BzLmMNCj4+IGluZGV4IDliYzNjNjIxNTdkNy4uY2ZmMTZm
MGNjMTViIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYw0KPj4g
KysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYw0KPj4gQEAgLTE3ODIsNiArMTc4Miw3
IEBAIHN0YXRpYyBpbnQgY2NwX3J1bl9zaGFfY21kKHN0cnVjdCBjY3BfY21kX3F1ZXVlICpjbWRf
cSwgc3RydWN0IGNjcF9jbWQgKmNtZCkNCj4+ICAgCQkJICAgICAgIExTQl9JVEVNX1NJWkUpOw0K
Pj4gICAJCQlicmVhazsNCj4+ICAgCQlkZWZhdWx0Og0KPj4gKwkJCWtmcmVlKGhtYWNfYnVmKTsN
Cj4gV2VsbCwgdGhlb3JldGljYWxseSB3ZSBjYW4gbmV2ZXIgcmVhY2ggdGhpcyBzZWN0aW9uIHNp
bmNlIHRoZSByb3V0aW5lDQo+IHdvdWxkIGhhdmUgbmV2ZXIgcHJvY2VlZGVkIHBhc3QgdGhlIGZp
cnN0IHN3aXRjaCBzdGF0ZW1lbnQgYXQgdGhlDQo+IGJlZ2lubmluZyBvZiB0aGUgZnVuY3Rpb24u
IEJ1dCwgaWYgdGhlIGNvZGUgaXMgZXZlciBtb2RpZmllZCBhbmQgc29tZSBvZg0KPiB0aGUgc3dp
dGNoIHN0YXRlbWVudHMgbWlzc2VkIHRoZW4gaXQncyBwb3NzaWJsZS4uLg0KPg0KPj4gICAJCQly
ZXQgPSAtRUlOVkFMOw0KPj4gICAJCQlnb3RvIGVfY3R4Ow0KPiBJIGtub3cgaXQncyBub3QgcGFy
dCBvZiB5b3VyIGNoYW5nZSwgYnV0IHRoaXMgbG9va3MgbGlrZSBpdCBzaG91bGQgYmUNCj4gZ290
byBlX2RhdGEgaW5zdGVhZCBvZiBlX2N0eCwgdG9vLg0KSSBhZ3JlZSB3aXRoIHRoaXMuIFBsZWFz
ZSByZXN1Ym1pdCB3aXRoIHRoZSBzdWdnZXN0ZWQgY2hhbmdlLCBhbmQgdXNlIGEgDQpjb21taXQg
bWVzc2FnZSBhbG9uZyB0aGUgdGhlIGxpbmVzIG9mDQoNCmNyeXB0bzogY2NwIC0gUmVsZWFzZSBh
bGwgYWxsb2NhdGVkIG1lbW9yeSBpZiBzaGEgdHlwZSBpcyBpbnZhbGlkDQoNCg0KR2FyeQ0K
