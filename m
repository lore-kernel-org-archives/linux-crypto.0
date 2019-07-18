Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB2DC7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 21:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4260B208C0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 21:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="IT62zS5B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391428AbfGRVug (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 17:50:36 -0400
Received: from mail-eopbgr680084.outbound.protection.outlook.com ([40.107.68.84]:35298
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727685AbfGRVug (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 17:50:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQuGqhwP6/sV8JqVQ39AGBLBDsBkMtP+FX/HBi3ER2n+cVDfr6p+71NT0geEVOcpwHJ8y9fbieTy+DkU+6WeEtnPdz5FQqLQWOfrEdr9DA6GXo+M6USnGqXCpgpYjXadTUmkk2DFly0Pvch5DpZg4XvzZKbOWaw5CSdLAMDcrnzomsi2UGF/cQAaVW3FSnKFkeHhNrzSwblAAgs9iiqys/Av6lEWsO6Ac3ixfeNIigRqkmgs3J5SSnKTwIUQeCUgvBqkxeBq8VGWTN/Q836lULZUPliT0LK99wmY+C7+mzjuNP29Uh1NKs8YDPs4Rom2rey+fTg5Y7ykDJ7mywG8Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ml4QJQt6AsHKmiNwstugxARYL4BanhaEiYosIzoklw=;
 b=C8/TZNVkIN9DqE1Njgu+Zc7lWiLsIqLG30F6y2yogzu4SqvK85bzoPZECT751LjACUt2C4n2ULPNjijHMyK/p1a8bA11wMttFPcQONsIoMmjqdSwv5c34L3scLjBzwZb6kO/jJskBwstuQjY7hHHpDDYJaE/WFsWcxVyqoCvAZqe5RvQvuTK/NVRhUETUrzuC9RRVfXcRTMMDZ9QMPKjfD3bFOBQRjl9/EsxgBhYaNU0tGM2WBIymviiZbNLtuZcmeAOWMUh3DcL/m2hmXH3OZ25nRIo08eVe699AR+lp/tBw7TjOsWDM1OrE8ZESMMf1mGweKzXCKlXDUXDadZhnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ml4QJQt6AsHKmiNwstugxARYL4BanhaEiYosIzoklw=;
 b=IT62zS5Bz5AMA65hmZCidU77Gmb6Rvhu89Vt6VvfQ/ahBh5mtBJv2cI6a+PXdAHoLYqdKvteAUxNJKxmlVpW7lY6dcetF69Oxc7MEHVsk/6JN9NmKxsBeq+5YSce83kPgIjsOqKEP6U4vir9ykft64MAwZ/rCPUnT8IBuDp6SWk=
Received: from CY4PR12MB1448.namprd12.prod.outlook.com (10.172.71.140) by
 CY4PR12MB1159.namprd12.prod.outlook.com (10.168.163.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Thu, 18 Jul 2019 21:50:32 +0000
Received: from CY4PR12MB1448.namprd12.prod.outlook.com
 ([fe80::347c:e57d:856e:d567]) by CY4PR12MB1448.namprd12.prod.outlook.com
 ([fe80::347c:e57d:856e:d567%9]) with mapi id 15.20.2094.011; Thu, 18 Jul 2019
 21:50:32 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Chuhong Yuan <hslester96@gmail.com>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp - Replace dma_pool_alloc + memset with
 dma_pool_zalloc
Thread-Topic: [PATCH] crypto: ccp - Replace dma_pool_alloc + memset with
 dma_pool_zalloc
Thread-Index: AQHVPWsDtOPD9/LY2UmVglhxf2PvaabQ6swA
Date:   Thu, 18 Jul 2019 21:50:32 +0000
Message-ID: <96cc55c8-16d1-7c2e-1a7c-2b73c5cfa267@amd.com>
References: <20190718131609.10974-1-hslester96@gmail.com>
In-Reply-To: <20190718131609.10974-1-hslester96@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0091.namprd05.prod.outlook.com
 (2603:10b6:803:22::29) To CY4PR12MB1448.namprd12.prod.outlook.com
 (2603:10b6:910:f::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d10e8f67-c3aa-4e0f-1114-08d70bc9f4e6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:CY4PR12MB1159;
x-ms-traffictypediagnostic: CY4PR12MB1159:
x-microsoft-antispam-prvs: <CY4PR12MB115950E8A4107314000D9705FDC80@CY4PR12MB1159.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:409;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(189003)(199004)(2616005)(14454004)(102836004)(6506007)(26005)(53546011)(386003)(186003)(25786009)(446003)(76176011)(31686004)(11346002)(4326008)(66556008)(8676002)(7736002)(6436002)(476003)(66476007)(6486002)(64756008)(66946007)(6512007)(99286004)(316002)(6246003)(2906002)(6116002)(486006)(66066001)(71190400001)(6916009)(71200400001)(54906003)(66446008)(81166006)(68736007)(36756003)(8936002)(229853002)(31696002)(478600001)(3846002)(53936002)(1411001)(5660300002)(52116002)(256004)(305945005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1159;H:CY4PR12MB1448.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JETpTMaeWOosD/QfOTGGmt0HvR536bOE0bN8n1EqkOV453PlkE+8Cx6TF05opHAphhxj5ZOtnJSwk8bBk0RH3Kf9ZlkHPs2ozDOmTTpOL4CHOxJzpf1yocvLs4AfA+0eTWu1qVmM4z+ObsoWF49CXfYtBUgu8pIKN+h7Pv2500oFB7dWxuvGjcg9oDcRFpL8bBzbbPmofkVA7rwJimbccxxiE94RwDV+gcN/vvPh6xTETICkq8xiX6hQxrOLuW9DNZcXugbh9iqB9syDgJfyLbHclVupa3pbWACkzEdFOPDXlO8uORIWXY3I7nL/7pzztZkHGfblHRxzzlF1VCITl3MITi2pS/fpT8q2y4xOqscGIpVyiIdLAEyirrOj/eqsGJpubc2+Mw/mm5sHgalk1GikFEc7RBMdi8jkgwkLyhQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <30AAF94BC3181248921FE11258035F31@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d10e8f67-c3aa-4e0f-1114-08d70bc9f4e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 21:50:32.4443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1159
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy8xOC8xOSA4OjE2IEFNLCBDaHVob25nIFl1YW4gd3JvdGU6DQo+IFVzZSBkbWFfcG9vbF96
YWxsb2MgaW5zdGVhZCBvZiB1c2luZyBkbWFfcG9vbF9hbGxvYyB0byBhbGxvY2F0ZQ0KPiBtZW1v
cnkgYW5kIHRoZW4gemVyb2luZyBpdCB3aXRoIG1lbXNldCAwLg0KPiBUaGlzIHNpbXBsaWZpZXMg
dGhlIGNvZGUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHVob25nIFl1YW4gPGhzbGVzdGVyOTZA
Z21haWwuY29tPg0KDQpBY2tlZC1ieTogR2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29tPg0K
DQo+IC0tLQ0KPiAgIGRyaXZlcnMvY3J5cHRvL2NjcC9jY3Atb3BzLmMgfCAzICstLQ0KPiAgIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLW9wcy5jIGIvZHJpdmVycy9jcnlwdG8vY2Nw
L2NjcC1vcHMuYw0KPiBpbmRleCA4NjZiMmUwNWNhNzcuLjAzNzk3YzQyYjMzNiAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYw0KPiArKysgYi9kcml2ZXJzL2NyeXB0
by9jY3AvY2NwLW9wcy5jDQo+IEBAIC0xNTAsMTQgKzE1MCwxMyBAQCBzdGF0aWMgaW50IGNjcF9p
bml0X2RtX3dvcmthcmVhKHN0cnVjdCBjY3BfZG1fd29ya2FyZWEgKndhLA0KPiAgIAlpZiAobGVu
IDw9IENDUF9ETUFQT09MX01BWF9TSVpFKSB7DQo+ICAgCQl3YS0+ZG1hX3Bvb2wgPSBjbWRfcS0+
ZG1hX3Bvb2w7DQo+ICAgDQo+IC0JCXdhLT5hZGRyZXNzID0gZG1hX3Bvb2xfYWxsb2Mod2EtPmRt
YV9wb29sLCBHRlBfS0VSTkVMLA0KPiArCQl3YS0+YWRkcmVzcyA9IGRtYV9wb29sX3phbGxvYyh3
YS0+ZG1hX3Bvb2wsIEdGUF9LRVJORUwsDQo+ICAgCQkJCQkgICAgICZ3YS0+ZG1hLmFkZHJlc3Mp
Ow0KPiAgIAkJaWYgKCF3YS0+YWRkcmVzcykNCj4gICAJCQlyZXR1cm4gLUVOT01FTTsNCj4gICAN
Cj4gICAJCXdhLT5kbWEubGVuZ3RoID0gQ0NQX0RNQVBPT0xfTUFYX1NJWkU7DQo+ICAgDQo+IC0J
CW1lbXNldCh3YS0+YWRkcmVzcywgMCwgQ0NQX0RNQVBPT0xfTUFYX1NJWkUpOw0KPiAgIAl9IGVs
c2Ugew0KPiAgIAkJd2EtPmFkZHJlc3MgPSBremFsbG9jKGxlbiwgR0ZQX0tFUk5FTCk7DQo+ICAg
CQlpZiAoIXdhLT5hZGRyZXNzKQ0KPiANCg0K
