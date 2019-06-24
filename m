Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AA7C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30ACE20657
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:28:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="OVbQUJMF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfFXT2d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:28:33 -0400
Received: from mail-eopbgr800089.outbound.protection.outlook.com ([40.107.80.89]:22208
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfFXT2c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HzROVuo+Ed4kCzlmA9a1CBvYSbkvXUb3KAjeHCUTZA=;
 b=OVbQUJMFE21Yznx176yj92BN/7YVC2h12Zj1LsTQoTO4r2wKqoAfYJOU5Soj7T907Gh3QQ1I157uXDqRmn+sFf/94/6fyvu2P1vPSSSwR9WuMLfM60EnW4H5EvHQuuXUqko53Nm93nIVmD8UUpfBHQfX8HePm3vq2LXY6BN4kN0=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1786.namprd12.prod.outlook.com (10.175.91.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 19:28:30 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:28:30 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 00/11] Add module parameters to control CCP activation
Thread-Topic: [PATCH 00/11] Add module parameters to control CCP activation
Thread-Index: AQHVKsMBfYnvpmduqEKapWk+5yLilg==
Date:   Mon, 24 Jun 2019 19:28:30 +0000
Message-ID: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0060.namprd12.prod.outlook.com
 (2603:10b6:802:20::31) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e48c304a-5986-42ce-11b4-08d6f8da23a0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1786;
x-ms-traffictypediagnostic: DM5PR12MB1786:
x-microsoft-antispam-prvs: <DM5PR12MB1786A6AD584F5A0D155B7B3AFDE00@DM5PR12MB1786.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(346002)(136003)(376002)(189003)(199004)(2906002)(103116003)(7736002)(26005)(6506007)(6916009)(53936002)(86362001)(6512007)(316002)(256004)(73956011)(2351001)(5660300002)(64756008)(66476007)(66556008)(66066001)(6436002)(66446008)(102836004)(4326008)(66946007)(25786009)(6486002)(186003)(305945005)(5640700003)(52116002)(386003)(14444005)(8936002)(68736007)(478600001)(2501003)(3846002)(71190400001)(6116002)(476003)(81166006)(54906003)(72206003)(81156014)(71200400001)(8676002)(99286004)(486006)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1786;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: W13n2rh6PzJo8IWdaNlsKbBi2TdKU7O1nDhwgIEX3fNH0WJXHkJsJ0bMny0ncDPkd1jcG6k1X6ZnYX5mW12BJ/6tbXhITQYkFk3ZbbspO0n9kmNeK69hlhqfyuP2C+LwuI7L0hWHvtCIirwarcpYpKj0GEo8Hc0X12cJTkoIVvs8ve+aT6HOk/x/HNWAcLb9VquxHggRiEfh3n1mpa+UFdy4kiQ/xcyTRjbcHRIWZSNcURI0K4cvhpfi3cwCfygT1bANrWs2YQMtRbETq9p6m4+b7rDDY753jxwtt63JasKT5FSmo8Mm+ZjPx1/kk71N6++FWYtRJhq42Yk/gksiigNLMqBR5s4mRY03HQh3lrfXMoMWcQNAIfXS4OI/eTxepkU70zHM1FlrZlmAwXEXl3HzILEHuq+yCYiWvf7O3rg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA2034D5A9FF574D8A21A652DFE19D3F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e48c304a-5986-42ce-11b4-08d6f8da23a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:28:30.6558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1786
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rmlyc3RseSwgYWRkIGEgc3dpdGNoIHRvIGFsbG93L2Rpc2FsbG93IGRlYnVnZnMgY29kZSB0byBi
ZSBidWlsdA0KaW50byB0aGUgQ0NQIGRyaXZlci4NCg0KVGhpcyByZXN0IG9mIHRoZSBwYXRjaCBz
ZXJpZXMgaW1wbGVtZW50cyBhIHNldCBvZiBtb2R1bGUgcGFyYW1ldGVycw0KdGhhdCBhbGxvdyBm
aW5lLXR1bmVkIGNvbnRyb2wgb3ZlciB3aGljaCBDQ1BzIG9uIGEgc3lzdGVtIGFyZSBlbmFibGVk
DQpieSB0aGUgZHJpdmVyLCBhbmQgaG93IG1hbnkgcXVldWVzIG9uIGVhY2ggZGV2aWNlIGFyZSBh
Y3RpdmF0ZWQuDQoNCkxhc3RseSwgYSBzd2l0Y2ggdG8gZW5hYmxlL2Rpc2FibGUgRE1BIGVuZ2lu
ZSByZWdpc3RyYXRpb24gaXMgaW1wbGVtZW50ZWQuDQoNClRoZSBuZXcgcGFyYW1ldGVycyBhcmUg
YWxzbyBleHBvc2VkIGluIERlYnVnRlMgKHdoZW4gZW5hYmxlZCkuDQoNCkRldGFpbHM6DQpucXVl
dWVzOiBjb25maWd1cmUgTiBxdWV1ZXMgcGVyIENDUCAoZGVmYXVsdDogMCAtIGFsbCBxdWV1ZXMg
ZW5hYmxlZCkNCm1heGRldjogbWF4aW11bSBudW1iZXIgb2YgZGV2aWNlcyB0byBlbmFibGUgKGRl
ZmF1bHQ6IDAgLSBhbGwgZGV2aWNlcyBhY3RpdmF0ZWQpDQpwY2lkZXY6IE9ubHkgY29uc2lkZXIg
YWN0aXZhdGluZyBkZXZpY2VzIHdpdGggdGhlIHNwZWNpZmllZCBQQ0kgSUQgKGRlZmF1bHQ6IHVu
c2V0IC0gYWxsIGRldmljZXMgYWN0aXZhdGVkKQ0KYnVzZXM6IE9ubHkgY29uc2lkZXIgYWN0aXZh
dGluZyBkZXZpY2VzIG9uIHRoZSBzcGVjaWZpZWQgUENJIGJ1c2VzIChkZWZhdWx0OiB1bnNldCAt
IGFsbCBkZXZpY2VzIGFjdGl2YXRlZCkNCmRtYXJlZzogUmVnaXN0ZXIgc2VydmljZXMgd2l0aCB0
aGUgRE1BIHN1YnN5c3RlbSAoZGVmYXVsdDogdHJ1ZSkNCg0KVGhlIG1heGRldiwgcGNpZGV2IGFu
ZCBidXNlcyBwYXJhbWV0ZXJzIGFnZ3JlZ2F0ZS4gDQoNCk9ubHkgYWN0aXZhdGVkIGRldmljZXMg
d2lsbCBoYXZlIHRoZWlyIERNQSBzZXJ2aWNlcyByZWdpc3RlcmVkLg0KDQotLS0NCg0KR2FyeSBS
IEhvb2sgKDExKToNCiAgICAgIGNyeXB0bzogY2NwIC0gTWFrZSBDQ1AgZGVidWdmcyBzdXBwb3J0
IG9wdGlvbmFsDQogICAgICBjcnlwdG86IGNjcCAtIEFkZCBhIG1vZHVsZSBwYXJhbWV0ZXIgdG8g
c3BlY2lmeSBhIHF1ZXVlIGNvdW50DQogICAgICBjcnlwdG86IGNjcCAtIEV4cG9zZSB0aGUgdmFs
dWUgb2YgbnF1ZXVlcyBpbiBEZWJ1Z0ZTDQogICAgICBjcnlwdG86IGNjcCAtIG1vZHVsZSBwYXJh
bWV0ZXIgdG8gbGltaXQgdGhlIG51bWJlciBvZiBlbmFibGVkIENDUHMNCiAgICAgIGNyeXB0bzog
Y2NwIC0gRXhwb3NlIG1heGRldiB0aHJvdWdoIERlYnVnRlMNCiAgICAgIGNyeXB0bzogY2NwIC0g
U3BlY2lmeSBhIHNpbmdsZSBDQ1AgdmlhIFBDSSBkZXZpY2UgSUQNCiAgICAgIGNyeXB0bzogY2Nw
IC0gZXhwb3NlIHRoZSBwY2lkZXYgbW9kdWxlIHBhcmFtZXRlciBpbiBkZWJ1Z2ZzDQogICAgICBj
cnlwdG86IGNjcCAtIG1vZHVsZSBwYXJhbWV0ZXIgdG8gYWxsb3cgQ0NQIHNlbGVjdGlvbiBieSBQ
Q0kgYnVzDQogICAgICBjcnlwdG86IGNjcCAtIGV4cG9zZSBwY2lidXMgbW9kdWxlIHBhcmFtZXRl
ciBpbiBkZWJ1Z2ZzDQogICAgICBjcnlwdG86IGNjcCAtIEFkZCBhIG1vZHVsZSBwYXJhbWV0ZXIg
dG8gY29udHJvbCByZWdpc3RyYXRpb24gZm9yIERNQQ0KICAgICAgY3J5cHRvOiBjY3AgLSBFeHBv
c2UgdGhlIHJlZ2lzdGVyZG1hIG1vZHVsZSBwYXJhbWV0ZXIgaW4gREZTDQoNCg0KIGRyaXZlcnMv
Y3J5cHRvL2NjcC9LY29uZmlnICAgICAgIHwgICAgOSArKw0KIGRyaXZlcnMvY3J5cHRvL2NjcC9N
YWtlZmlsZSAgICAgIHwgICAgNCAtDQogZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZWJ1Z2ZzLmMg
fCAgICAzICsNCiBkcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi12NS5jICB8ICAgMjQgKysrKy0N
CiBkcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oICAgICB8ICAgMTcgKysrKw0KIGRyaXZlcnMv
Y3J5cHRvL2NjcC9zcC1wY2kuYyAgICAgIHwgIDE3MiArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KIDYgZmlsZXMgY2hhbmdlZCwgMjIxIGluc2VydGlvbnMoKyksIDggZGVs
ZXRpb25zKC0pDQoNCi0tDQo=
