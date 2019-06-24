Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B631FC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88B8D20657
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="CgP2MeDB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbfFXT3H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:29:07 -0400
Received: from mail-eopbgr810073.outbound.protection.outlook.com ([40.107.81.73]:50963
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfFXT3H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:29:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TATTw6hqReIZYZKE6XSe+YQ0uV63ynA0MZs11ojWOg=;
 b=CgP2MeDBnjPbGkFO3hifSfAx0BEn1a4KN8o9MPG9PlsnkNXm/UOGZBdgcI7V/ka0MHQJnS3ZCFo5TFdZaaMQ+TojCdN5lADQysRIkJTgeNezNPU8adxq+odweahDKdzme41ZF6/UYYlBjljghveAfOaH8el04nfDUOfw37ZYdW4=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2358.namprd12.prod.outlook.com (52.132.141.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:29:05 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:29:05 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 05/11] crypto: ccp - Expose maxdev through DebugFS
Thread-Topic: [PATCH 05/11] crypto: ccp - Expose maxdev through DebugFS
Thread-Index: AQHVKsMV+SmVIH1h10C0RW24+vy+jQ==
Date:   Mon, 24 Jun 2019 19:29:04 +0000
Message-ID: <156140454321.116890.4463726436811997138.stgit@sosrh3.amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
In-Reply-To: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0054.namprd12.prod.outlook.com
 (2603:10b6:802:20::25) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb8fd39d-bf46-47d4-2212-08d6f8da3812
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2358;
x-ms-traffictypediagnostic: DM5PR12MB2358:
x-microsoft-antispam-prvs: <DM5PR12MB23586DCAF4E99F6B432FDAC1FDE00@DM5PR12MB2358.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(366004)(199004)(189003)(7736002)(5660300002)(26005)(2906002)(68736007)(8936002)(305945005)(186003)(386003)(66476007)(76176011)(8676002)(6506007)(4744005)(64756008)(102836004)(81156014)(53936002)(52116002)(4326008)(66556008)(6486002)(66446008)(66946007)(73956011)(316002)(5640700003)(6916009)(25786009)(6436002)(81166006)(2501003)(6512007)(3846002)(2351001)(71200400001)(71190400001)(99286004)(103116003)(54906003)(6116002)(256004)(476003)(72206003)(66066001)(14454004)(446003)(478600001)(486006)(11346002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2358;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +Lk1DR7j0bUCBxEv+OYitxChp0dmJwtSuPDdL1qiRqRcOscw+LFx0TfEBuAYHXKd85pU/FxXysG2Nuptc+lj/FAU2/2ZwHWU4mnHN6fbIc/n+u1Nbf/CgnzgZ6GqGJOz3ZD/GkzOP7xKOtyUrfYn7A4pxuQK6B5K/l4DN/PjKVqxDi9lH4MfXRsDqp8LatRlNXD5K95LJ8tX0yrycQ6cXj37+Eo+bS4OQKPAkkvLgcz+ZPoJEmhQh/wKlKfAVPTsRwlM9xOzE3SjTmOAfzljTgLWlUftlvJsTpwIuvby8OYNhAYplW8kb2SHS942bhd+JIlwZ8oCVicbqQRLhCvbVgAk/ByqhAPHcI2sfEHvanAm3rKnahDDiUEknRY4uLt4LwcuSA0hW9q8LTWDkpnRvmYpjQ1u47jHASOswqkYAgs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0526F230ECD75D42B6697A95D88DAE40@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb8fd39d-bf46-47d4-2212-08d6f8da3812
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:29:04.9867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2358
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

QWRkIGEgcmVhZC1vbmx5IGRlYnVnZnMgZW50cnkgZm9yIHRoZSBtb2R1bGUgcGFyYW1ldGVyICdt
YXhkZXYnLg0KDQpTaWduZWQtb2ZmLWJ5OiBHYXJ5IFIgSG9vayA8Z2FyeS5ob29rQGFtZC5jb20+
DQotLS0NCiBkcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMgfCAgICAxICsNCiAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9z
cC1wY2kuYyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KaW5kZXggYjgxNDkzODEwNjg5
Li4yOTE3N2QxMTNjOTAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMN
CisrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KQEAgLTQ5LDYgKzQ5LDcgQEAgTU9E
VUxFX1BBUk1fREVTQyhucXVldWVzLCAiTnVtYmVyIG9mIHF1ZXVlcyBwZXIgQ0NQIChkZWZhdWx0
OiA1KSIpOw0KIA0KICNpZmRlZiBDT05GSUdfQ1JZUFRPX0RFVl9DQ1BfREVCVUdGUw0KIG1vZHBh
cmFtX3QgICAgICBtb2R1bGVwYXJhbWV0ZXJzW10gPSB7DQorCXsibWF4ZGV2IiwgJm1heGRldiwg
U19JUlVTUn0sDQogCXsibnF1ZXVlcyIsICZucXVldWVzLCBTX0lSVVNSfSwNCiAJe05VTEwsIE5V
TEwsIDB9LA0KIH07DQoNCg==
