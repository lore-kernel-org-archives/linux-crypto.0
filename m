Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A06DC433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EDC9208E4
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:58:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="CenHEHoD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfGaQ6n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 12:58:43 -0400
Received: from mail-eopbgr790073.outbound.protection.outlook.com ([40.107.79.73]:63032
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727487AbfGaQ6l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 12:58:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkY+0B+haW2M1KOIf1TOFUxEmLWb5S/Lr8k2oAyjMAdPHAjLEwVEd6IE2uH6fcrGFe/eNfqj/zx1ymrLcPOkcOCy4lJmK2JRZXxyk+OuK68h8wzp3wcgP6DQcf7icKG84QX5fPvmLD+ovroq27Zl2aJussnqsl+TLZov91fmqkbqg2xyhDhYeNkttWB8EOXH0/k4sG5lB6Kq3hz7/goz5Uwf41JMfQ8xekejmdtNTRoMNMhHUv4W0vVnWgX9MqxHzAUWq/ikJcNTgokv7kgBA2DvYG32Q7jSJmkJQvXKf6rJEc19tRTo75+zNvmYOSborqC0+cErH4rR/lj5qjPIPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlTj4l+fvXYkNZgnR0V8RlPa5NF1XJqLURSuDGiqrvc=;
 b=bJZcqoqQmLvm5mF0Jk0T2AaILPAxJT08xSPfWUc/F3h1jUB0Mivxrxq0zFGElGR+BfcP2nltz5B4VQHCpxBALWicrhadXv+nZfkCesaE3vxFJKif+dgFxg3oflxWA2O1KaXX4uByEf/tFMsaBK6ndBmk1XH+5RyMK5ZQwc8RJUXZIZIiB3rP9pSLfkR5C24UU6NNO+g6KBTqhv3qT/t0kgT0AwtzxUAF5lRfaIIAyGl6nk88Zc/vWIp1Lwjib4tVV6Ec8EnT3BH743ca6duPfN7eduow2roXCZt1RublVCTO6a6J4DIVnQta5be8NCEpTU4/ZzjexFWAo6N5OLmaJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlTj4l+fvXYkNZgnR0V8RlPa5NF1XJqLURSuDGiqrvc=;
 b=CenHEHoDk+vGQ6aJpoaB4zDVO4gzy8oM7yLjB1RANoqI20//wsM84wG4SdcMSb/zey+krTc+G+LjoQDqdgH9Ztx4mnKJoE8KQmv0gZm4I4706H7pDoha2dAIWeiUD5uXNEvmYLBwQux6Ssqol03rOVfvMsbPywc6uvNq4BWWyPQ=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1819.namprd12.prod.outlook.com (10.175.91.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Wed, 31 Jul 2019 16:58:39 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a%8]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 16:58:39 +0000
From:   Gary R Hook <ghook@amd.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH] crypto:ccp - Return from init on allocation failure
Thread-Topic: [PATCH] crypto:ccp - Return from init on allocation failure
Thread-Index: AQHVRwSGhlcRO50Wx0SjVeOg7NpBNabk9EkA
Date:   Wed, 31 Jul 2019 16:58:38 +0000
Message-ID: <eed04b52-6149-0654-96ca-682c26b808e8@amd.com>
References: <20190730182738.26432-1-gary.hook@amd.com>
In-Reply-To: <20190730182738.26432-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BM1PR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::13) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.159.242]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e3d2019-55a7-4762-d6e8-08d715d8556a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1819;
x-ms-traffictypediagnostic: DM5PR12MB1819:
x-microsoft-antispam-prvs: <DM5PR12MB1819C37AFF09308EC12676E7FDDF0@DM5PR12MB1819.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(199004)(189003)(6486002)(6116002)(2906002)(14454004)(53936002)(31696002)(2501003)(6436002)(53546011)(76176011)(52116002)(81156014)(99286004)(66066001)(5660300002)(102836004)(186003)(25786009)(476003)(26005)(446003)(11346002)(2616005)(4326008)(8676002)(6512007)(68736007)(81166006)(8936002)(229853002)(31686004)(486006)(6246003)(3846002)(386003)(6506007)(478600001)(54906003)(71200400001)(110136005)(316002)(66446008)(7736002)(256004)(305945005)(64756008)(71190400001)(4744005)(66556008)(66476007)(36756003)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1819;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Jyv17MME5RSWW+0QEsftcO9sG7LJF9DlFGl80SeNWBha59wqrRoH3F/QY+3DvKK5LB0C+JkKMgtBaJgOvLjGkvhu+EmG59EMqe9NOXJmMK2r5vvNrdBavhKCtMR4Nrv2oA7O/e1vAZEx2QFm26H8Hcl65LRYDmMI7cvkcgay07v5VnDVWhUwJ2jNKSO/hMTbYrRoFrFjiKW+XUiBzRnNXXa+eEpJRSmUArMc56YTNonkP7DBj6T1lJEQN3bMGLSZgX/UmcsUtPN9kM+hAD2ejHKZWBSsWkcLJWpPs9eds0KIwO/i5NIh2ngKMdAcr0PA0aWuzxE+ApiY3y/jHsclj3VshRCcreUlvCrvoPr5egCGwld4G10MsjWjRJ4p9+KH6kSDn8rKJusvAJTCABMyFrJym0rNRiG+t82CisT6RZI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C723ABB1A9497438D09B1078A6C6165@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e3d2019-55a7-4762-d6e8-08d715d8556a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 16:58:38.8270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1819
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy8zMC8xOSAxOjI4IFBNLCBIb29rLCBHYXJ5IHdyb3RlOg0KPiBSZXR1cm4gYW5kIGZhaWwg
ZHJpdmVyIGluaXRpYWxpemF0aW9uIGlmIGEgRE1BIHBvb2wgY2FuJ3QgYmUNCj4gYWxsb2NhdGVk
Lg0KPiANCj4gRml4ZXM6IDRiMzk0YTIzMmRmNyAoImNyeXB0bzogY2NwIC0gTGV0IGEgdjUgQ0NQ
IHByb3ZpZGUgdGhlIHNhbWUgZnVuY3Rpb24gYXMgdjMiKQ0KPiANCj4gU2lnbmVkLW9mZi1ieTog
R2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29tPg0KPiAtLS0NCj4gICBkcml2ZXJzL2NyeXB0
by9jY3AvY2NwLWRldi12NS5jIHwgMSArDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYyBi
L2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMNCj4gaW5kZXggZjE0NmI1MWEyM2E1Li4z
YzBmMGQwYzMxNTMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LXY1
LmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYw0KPiBAQCAtODAzLDYg
KzgwMyw3IEBAIHN0YXRpYyBpbnQgY2NwNV9pbml0KHN0cnVjdCBjY3BfZGV2aWNlICpjY3ApDQo+
ICAgCQlpZiAoIWRtYV9wb29sKSB7DQo+ICAgCQkJZGV2X2VycihkZXYsICJ1bmFibGUgdG8gYWxs
b2NhdGUgZG1hIHBvb2xcbiIpOw0KPiAgIAkJCXJldCA9IC1FTk9NRU07DQo+ICsJCQlnb3RvIGVf
cG9vbDsNCj4gICAJCX0NCj4gICANCj4gICAJCWNtZF9xID0gJmNjcC0+Y21kX3FbY2NwLT5jbWRf
cV9jb3VudF07DQo+IA0KDQpOQUsgdGhpcywgcGxlYXNlIGlnbm9yZS4gSSBjaGFuZ2VkIHRoZSBz
dWJqZWN0IGluIHRoZSB2MiBwb3N0OyBhcG9sb2dpZXMgDQpmb3IgdGhhdC4NCg==
