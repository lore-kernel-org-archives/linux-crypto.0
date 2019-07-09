Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39268C73C46
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 063E820844
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:07:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="P3LppQks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfGIPHS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:07:18 -0400
Received: from mail-eopbgr780080.outbound.protection.outlook.com ([40.107.78.80]:30276
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726377AbfGIPHS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 11:07:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBHajjN1CsU8Nq1Mr4VawJD5ACXuxr3ux18EVRtRTTI=;
 b=P3LppQksDaqOlglLmFch/6nVOvxXZLXTz25Qn8ae8964o08G92Qp8CR0m/6elId4v7IiJiDttVtW4pdbTVuhVWi9Zpp36xWtPmIX9F+sNHKfY5XP4gMWv1d2yoGD2RlzeRhzqO56VXjsExweA0u9/nhUXV+EJWYCcE3ejhUfL9I=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1420.namprd12.prod.outlook.com (10.168.239.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 15:07:08 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.019; Tue, 9 Jul 2019
 15:07:08 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2 0/4] Add module parameters to control CCP activation
Thread-Topic: [PATCH v2 0/4] Add module parameters to control CCP activation
Thread-Index: AQHVNmf6IpyoPEcnbUeu6AGkbBKDqQ==
Date:   Tue, 9 Jul 2019 15:07:08 +0000
Message-ID: <156268468861.18577.13211913750250195885.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN2PR01CA0002.prod.exchangelabs.com (2603:10b6:804:2::12)
 To DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ee6d2dd-2812-414b-5853-08d7047f1c9b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1420;
x-ms-traffictypediagnostic: DM5PR12MB1420:
x-microsoft-antispam-prvs: <DM5PR12MB1420782A2F02E2C4AE5BA12EFDF10@DM5PR12MB1420.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(199004)(189003)(71200400001)(66066001)(8936002)(102836004)(81156014)(26005)(8676002)(7736002)(71190400001)(256004)(81166006)(6512007)(186003)(72206003)(99286004)(305945005)(86362001)(386003)(52116002)(53936002)(6506007)(2351001)(6436002)(66476007)(66556008)(64756008)(66446008)(316002)(6916009)(25786009)(68736007)(478600001)(6486002)(6116002)(3846002)(5660300002)(4326008)(66946007)(5640700003)(2906002)(2501003)(103116003)(476003)(486006)(14444005)(14454004)(73956011)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1420;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SkBSPs/a3oMcLVLddbY/2ZT/87ni4dh10VUFMWki3i/63U/WXGNBw/OcBqhb+tqLm9+GJToj3TjNd742zCqS+NECzeSZSRgmTnyB1zLqKJ0iZ+4IgBIU7aFiHikN+8iGXcl+E4CwbGzjNiazZmPXDqoYqxWu38vbzACvO3FK0BH/rNDXoMV6Trf2H1aH2l5+oHVENw9AXOu3W6Ng6v4xHAfSha4iYezMvCCH4kaTsAA/Vn5RE1gHFVuKhnYrGWXBxsUleD4cb1qZUKf3LujijlkLXMWuko5dLk02MkkYeGZZlyuHeRd9/QRlBkOtFf25bb8w9QGkbIKx9mfMjlvUogeDJoLGNdQi4x5WcX952RTuKoKQ9hgDqBN6KAExnw6kg+0rFTrMUGCkFebiwYBjWCIHu6OkF/4h3GqHi7l2xAA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B085E15DD9C4E841B52E115A9F60F94A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee6d2dd-2812-414b-5853-08d7047f1c9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 15:07:08.5576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1420
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rmlyc3RseSwgYWRkIGEgc3dpdGNoIHRvIGFsbG93L2Rpc2FsbG93IGRlYnVnZnMgY29kZSB0byBi
ZSBidWlsdCBpbnRvDQp0aGUgQ0NQIGRyaXZlci4NCg0KVGhpcyByZXN0IG9mIHRoZSBwYXRjaCBz
ZXJpZXMgaW1wbGVtZW50cyBhIHNldCBvZiBtb2R1bGUgcGFyYW1ldGVycw0KdGhhdCBhbGxvd3Mg
Y29udHJvbCBvdmVyIHdoaWNoIENDUHMgb24gYSBzeXN0ZW0gYXJlIGVuYWJsZWQgYnkgdGhlDQpk
cml2ZXIsIGFuZCBob3cgbWFueSBxdWV1ZXMgb24gZWFjaCBkZXZpY2UgYXJlIGFjdGl2YXRlZC4N
Cg0KQSBzd2l0Y2ggdG8gZW5hYmxlL2Rpc2FibGUgRE1BIGVuZ2luZSByZWdpc3RyYXRpb24gaXMg
aW1wbGVtZW50ZWQuDQoNCkRldGFpbHM6DQpucXVldWVzIC0gY29uZmlndXJlIE4gcXVldWVzIHBl
ciBDQ1AgKGRlZmF1bHQ6IDAgLSBhbGwgcXVldWVzIGVuYWJsZWQpDQptYXhfZGV2cyAtIG1heGlt
dW0gbnVtYmVyIG9mIGRldmljZXMgdG8gZW5hYmxlIChkZWZhdWx0OiAwIC0gYWxsDQogICAgICAg
ICAgIGRldmljZXMgYWN0aXZhdGVkKQ0KZG1hZW5naW5lIC0gUmVnaXN0ZXIgc2VydmljZXMgd2l0
aCB0aGUgRE1BIHN1YnN5c3RlbSAoZGVmYXVsdDogdHJ1ZSkNCg0KT25seSBhY3RpdmF0ZWQgZGV2
aWNlcyB3aWxsIGhhdmUgdGhlaXIgRE1BIHNlcnZpY2VzIHJlZ2lzdGVyZWQsDQpjb21wcmVoZW5z
aXZlbHkgY29udHJvbGxlZCBieSB0aGUgZG1hZW5naW5lIHBhcmFtZXRlci4NCg0KQ2hhbmdlcyBz
aW5jZSB2MToNCiAtIFJlbW92ZSBkZWJ1Z2ZzIHBhdGNoZXMgdGhhdCBkdXBsaWNhdGVzIHN5c2Zz
IGZ1bmN0aW9uDQogLSBSZW1vdmUgcGF0Y2hlcyBmb3IgZmlsdGVyaW5nIGJ5IHBjaWJ1cyBhbmQg
cGNpIGRldmljZSBJRA0KIC0gVXRpbGl6ZSB1bmRlcnNjb3JlcyBmb3IgY29uc2lzdGVuY3kgaW4g
dmFyaWFibGUgbmFtZXMNCiAtIENvcnJlY3QgY29tbWl0IG1lc3NhZ2UgZm9yIG5xdWV1ZXMgcmVn
YXJkaW5nIGRlZmF1bHQgdmFsdWUNCiAtIEFsdGVyIHZlcmJhZ2Ugb2YgcGFyYW1ldGVyIGRlc2Ny
aXB0aW9uIChkbWFlbmdpbmUpDQogLSBIZWxwIHRleHQgaW4gS2NvbmZpZzogcmVtb3ZlIHJlZmVy
ZW5jZSB0byBwYXJhbWV0ZXJzIGluIGRlYnVnZnMNCg0KLS0tDQoNCkdhcnkgUiBIb29rICg0KToN
CiAgICAgIGNyeXB0bzogY2NwIC0gTWFrZSBDQ1AgZGVidWdmcyBzdXBwb3J0IG9wdGlvbmFsDQog
ICAgICBjcnlwdG86IGNjcCAtIEFkZCBhIG1vZHVsZSBwYXJhbWV0ZXIgdG8gc3BlY2lmeSBhIHF1
ZXVlIGNvdW50DQogICAgICBjcnlwdG86IGNjcCAtIG1vZHVsZSBwYXJhbWV0ZXIgdG8gbGltaXQg
dGhlIG51bWJlciBvZiBlbmFibGVkIENDUHMNCiAgICAgIGNyeXB0bzogY2NwIC0gQWRkIGEgbW9k
dWxlIHBhcmFtZXRlciB0byBjb250cm9sIHJlZ2lzdHJhdGlvbiBmb3IgRE1BDQoNCg0KIGRyaXZl
cnMvY3J5cHRvL2NjcC9LY29uZmlnICAgICAgICAgfCAgICA4ICsrKysrKysrDQogZHJpdmVycy9j
cnlwdG8vY2NwL01ha2VmaWxlICAgICAgICB8ICAgIDQgKystLQ0KIGRyaXZlcnMvY3J5cHRvL2Nj
cC9jY3AtZGV2LXYzLmMgICAgfCAgICAyICstDQogZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYt
djUuYyAgICB8ICAgMTEgKysrKysrLS0tLS0NCiBkcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5j
ICAgICAgIHwgICAyOSArKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KIGRyaXZlcnMvY3J5
cHRvL2NjcC9jY3AtZGV2LmggICAgICAgfCAgICAxICsNCiBkcml2ZXJzL2NyeXB0by9jY3AvY2Nw
LWRtYWVuZ2luZS5jIHwgICAxMiArKysrKysrKysrKy0NCiA3IGZpbGVzIGNoYW5nZWQsIDU3IGlu
c2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KDQotLQ0KU2lnbmF0dXJlDQo=
