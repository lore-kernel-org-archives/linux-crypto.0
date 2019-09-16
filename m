Return-Path: <SRS0=68iz=XL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 462CEC49ED7
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 13:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01B94214D9
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 13:22:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="YtZCqSOb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733043AbfIPNWH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Sep 2019 09:22:07 -0400
Received: from mail-eopbgr730082.outbound.protection.outlook.com ([40.107.73.82]:9408
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732852AbfIPNWG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Sep 2019 09:22:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZrLxokzWZMcj8zHnAgKgwV/A2BL+HIXZJ67MlKho0BJuEuQfv49LIdknlH8zNz2Iwv42BGyywaPCi0xPx6S0ChDEW9B084TzEkfiQO9NVci7lLaqtbWqEvv90YVLl5PMmUxEvGxBEQEaiAjZzVpCW7zNlT0y1VQvxOI+22pCfO2LpSRrvRw+RVkJ9yTIHIKVvNCgJ/t+mD8s7jhwVqnJH92QnPbRObn7FXbhFQXbPda5BTv6SeEqRTszm+Y6u45Lj+eJ+5dG2s/Uv31iO2fwPe7Ggdrd4U+sP6tXr6EeqIsz/t0k+SrgUPKsels71zavPBZPCm6L9oiK3PdyeduAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cd3/DPI6hrkzwPvDUvTLPtY8zftq7vmQz4zO5SUuIA=;
 b=do7S5i3k4fhAd/gtDA5o5uQiwPw5u+IQmSxIzU7PEyM4f1s8zJEc6E+xke7r2jVXCkcVjmlGF8QEZYFv7UbO3OKO0+saNUfdItZMYuFsHljd4RH79vZbaRtJ8TuEAEwK1ge0q0JvWIxzenSdU6OIhPFTaJlqYQ2vJcPlTP08za1LbS+cMKD8p8PZVPbbu4BA1/v6lGzcFOK9WP0dNwQnQUbwjo2dpPxt2uFO3B2hR264JSR4oUfmRsho33FkHf1rIMVj+jWRutZoZT8B18Z7NumxtzinGsl7PYxb0uBTY/gxLI3D0/0VZCWYMm9IpTk4ZvHGVlxhoMlNF4cXOU3T7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cd3/DPI6hrkzwPvDUvTLPtY8zftq7vmQz4zO5SUuIA=;
 b=YtZCqSObE+ROQ3LzX962FPv/5SotVdKA2p4Op4wfRjCfuWPeIhaMsTEMJKi0hgMLQz6d9iQtTPLrm6PkIRDHIcyK3S1plPYDijR/QI2PZWREqw6ujOAL5TrszhX9j3DirX0BwwKOotToO79UiX2saRudDiWP3+UC7Fr7vvznRSk=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3500.namprd12.prod.outlook.com (20.178.199.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Mon, 16 Sep 2019 13:22:03 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::585:2d27:6e06:f9b0]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::585:2d27:6e06:f9b0%7]) with mapi id 15.20.2263.023; Mon, 16 Sep 2019
 13:22:03 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
CC:     "emamd001@umn.edu" <emamd001@umn.edu>,
        "smccaman@umn.edu" <smccaman@umn.edu>,
        "kjlu@umn.edu" <kjlu@umn.edu>, "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp - release hmac_buf if ccp_run_sha_cmd fails
Thread-Topic: [PATCH] crypto: ccp - release hmac_buf if ccp_run_sha_cmd fails
Thread-Index: AQHVao3EzfE4/kcfXE+oWWZiVoCZ7qcuTlaA
Date:   Mon, 16 Sep 2019 13:22:03 +0000
Message-ID: <3550c7a3-2932-c222-c1b3-957def794150@amd.com>
References: <20190913234824.8521-1-navid.emamdoost@gmail.com>
In-Reply-To: <20190913234824.8521-1-navid.emamdoost@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR2101CA0001.namprd21.prod.outlook.com
 (2603:10b6:805:106::11) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2daf14bb-e35d-4b45-c825-08d73aa8dd1b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3500;
x-ms-traffictypediagnostic: DM6PR12MB3500:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB35006780A3F88C59CD8E8219EC8C0@DM6PR12MB3500.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(199004)(189003)(5660300002)(6246003)(6486002)(6436002)(71200400001)(71190400001)(86362001)(3846002)(6116002)(7736002)(229853002)(26005)(14454004)(53936002)(6512007)(305945005)(102836004)(386003)(2906002)(6506007)(53546011)(4326008)(446003)(66066001)(76176011)(186003)(66476007)(478600001)(31696002)(8936002)(25786009)(64756008)(54906003)(66446008)(66946007)(66556008)(256004)(31686004)(99286004)(6916009)(316002)(8676002)(81166006)(11346002)(52116002)(476003)(2616005)(36756003)(81156014)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3500;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GrxsfcES6/9QHQAVxxEJro6UZbaH6Qef58bxEEn2c44QcrbFnbKp42QkVlKeNk2tk21Nhecpe2QBIkXxzm+k7mfynMtG4KU3UaReAXg8y0xtGySCDTYexH5hfG341dhUubEjWTGQVg/lDM5Skn8mXKSULb+Z5e7EE3opqtB1l7qxD+wSNAmeBhb++Xz2BimjrWetUSPkevtDPMF7BKA7wCvNl0NptLJv/9waNDEvRVJkNjC//yIZC+NFlyvGbxRpDQV5uRG/Crt5e0e+MsrpgCG5zB1VH6qj4Uwl6nxMgeB2k1ND/54H4LxbYRXi0CPmz9MMwwJYA7ttXC4iQlJc+pIrZhSoxnX0VVJFGnctnHGTUmJXG5QKJwd9byD2hGAoD6rPDPputuE9TT1yFWMK4cb5sw8R6JPqZZaS8D4FRxE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB45EEC321D9C244B95C8D1AF95B6AB4@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2daf14bb-e35d-4b45-c825-08d73aa8dd1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 13:22:03.6935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wiCGHGCwsz934XVlp5KJzLUjO6xs117RxyB8+bGmIS3qI8vZylIoHhQpVyDaqqR8UEe6CJf+bEsezKSb0eMotQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3500
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gOS8xMy8xOSA2OjQ4IFBNLCBOYXZpZCBFbWFtZG9vc3Qgd3JvdGU6DQo+IEluIGNjcF9ydW5f
c2hhX2NtZCwgaWYgdGhlIHR5cGUgb2Ygc2hhIGlzIGludmFsaWQsIHRoZSBhbGxvY2F0ZWQNCj4g
aG1hY19idWYgc2hvdWxkIGJlIHJlbGVhc2VkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTmF2aWQg
RW1hbWRvb3N0IDxuYXZpZC5lbWFtZG9vc3RAZ21haWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMv
Y3J5cHRvL2NjcC9jY3Atb3BzLmMgfCAxICsNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3Atb3BzLmMgYi9k
cml2ZXJzL2NyeXB0by9jY3AvY2NwLW9wcy5jDQo+IGluZGV4IDliYzNjNjIxNTdkNy4uY2ZmMTZm
MGNjMTViIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLW9wcy5jDQo+ICsr
KyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3Atb3BzLmMNCj4gQEAgLTE3ODIsNiArMTc4Miw3IEBA
IHN0YXRpYyBpbnQgY2NwX3J1bl9zaGFfY21kKHN0cnVjdCBjY3BfY21kX3F1ZXVlICpjbWRfcSwg
c3RydWN0IGNjcF9jbWQgKmNtZCkNCj4gIAkJCSAgICAgICBMU0JfSVRFTV9TSVpFKTsNCj4gIAkJ
CWJyZWFrOw0KPiAgCQlkZWZhdWx0Og0KPiArCQkJa2ZyZWUoaG1hY19idWYpOw0KDQpXZWxsLCB0
aGVvcmV0aWNhbGx5IHdlIGNhbiBuZXZlciByZWFjaCB0aGlzIHNlY3Rpb24gc2luY2UgdGhlIHJv
dXRpbmUNCndvdWxkIGhhdmUgbmV2ZXIgcHJvY2VlZGVkIHBhc3QgdGhlIGZpcnN0IHN3aXRjaCBz
dGF0ZW1lbnQgYXQgdGhlDQpiZWdpbm5pbmcgb2YgdGhlIGZ1bmN0aW9uLiBCdXQsIGlmIHRoZSBj
b2RlIGlzIGV2ZXIgbW9kaWZpZWQgYW5kIHNvbWUgb2YNCnRoZSBzd2l0Y2ggc3RhdGVtZW50cyBt
aXNzZWQgdGhlbiBpdCdzIHBvc3NpYmxlLi4uDQoNCj4gIAkJCXJldCA9IC1FSU5WQUw7DQo+ICAJ
CQlnb3RvIGVfY3R4Ow0KDQpJIGtub3cgaXQncyBub3QgcGFydCBvZiB5b3VyIGNoYW5nZSwgYnV0
IHRoaXMgbG9va3MgbGlrZSBpdCBzaG91bGQgYmUNCmdvdG8gZV9kYXRhIGluc3RlYWQgb2YgZV9j
dHgsIHRvby4NCg0KVGhhbmtzLA0KVG9tDQoNCj4gIAkJfQ0KPiANCg==
