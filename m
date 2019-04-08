Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFEAC10F14
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 20:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBBA520880
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 20:42:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="xlvvcoZj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfDHUm6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 16:42:58 -0400
Received: from mail-eopbgr790052.outbound.protection.outlook.com ([40.107.79.52]:49376
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726902AbfDHUm6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 16:42:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YV7vB5fMAUMbmcsBFCWnFbhdf+uorkhZ5Q4Y+a9NfPk=;
 b=xlvvcoZjKp/hB37MkRFqP/NEzzf+lKwrDu/iatAyyNdd/8/nrXaz14buLq9MwncDk2kTz53cLM66BIIjWyx7fYdn11YkzofVAJdK/SVCg37VyT/sFNNvTBbQzMLiJLQ4GNSbqjOtJxmKZ/NWkzTmyf2dRVa3QlkFI+M6LSQVWjs=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3450.namprd12.prod.outlook.com (20.178.198.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.16; Mon, 8 Apr 2019 20:42:55 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::9d54:69c5:d057:80de]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::9d54:69c5:d057:80de%3]) with mapi id 15.20.1771.021; Mon, 8 Apr 2019
 20:42:55 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] crypto: ccp: Do not free psp_master when PLATFORM_INIT fails
Thread-Topic: [PATCH] crypto: ccp: Do not free psp_master when PLATFORM_INIT
 fails
Thread-Index: AQHU7kukjm/4V2FGDEiSE08yTBq3gw==
Date:   Mon, 8 Apr 2019 20:42:55 +0000
Message-ID: <20190408204241.20393-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0801CA0018.namprd08.prod.outlook.com
 (2603:10b6:803:29::28) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47974031-1ddd-487a-4dc1-08d6bc62c70a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3450;
x-ms-traffictypediagnostic: DM6PR12MB3450:
x-microsoft-antispam-prvs: <DM6PR12MB34508A364E2BA345DBADB433E52C0@DM6PR12MB3450.namprd12.prod.outlook.com>
x-forefront-prvs: 0001227049
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(366004)(346002)(199004)(189003)(86362001)(256004)(14444005)(14454004)(478600001)(25786009)(6506007)(6512007)(26005)(386003)(6486002)(6916009)(102836004)(81156014)(68736007)(106356001)(54906003)(1076003)(2351001)(8676002)(2906002)(71190400001)(4326008)(5640700003)(105586002)(2501003)(71200400001)(50226002)(81166006)(53936002)(476003)(305945005)(3846002)(186003)(52116002)(66066001)(316002)(7736002)(6116002)(36756003)(2616005)(97736004)(486006)(5660300002)(6436002)(99286004)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3450;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NoNu4lzsFOQlcb0bLmTxFCzIzEXbgY0swlvk8tB+xazPpMuWpsPDIG7WJYxM+t9neHa0945UXa3Atcif0H03lcOUacXJfKNoAbX7tNdHgpoIsuKyzy7JniYQNMgPUZpaUKplvlbaoDlnCujZ1tgORBB1+EBwec7SxgzCJWi7yzXkRayMPLWalDhzcwSzkCTKb7d13aONVNBtMMsE/xm1NNPWyMyrzhhh5MEmgDfkwxuiA2Jy/E2N2QGWTeb7h7U2OSZdayvDnZlh0byNdV6jZ+h8MJ9/IbXkTxF78yvPJ/4dlcuwEeF4/wrrUbLVetVpOOJFcGUBgNMIou2e0tjBV4TdP/tqbt92xRb+R9I/d1gBkTHlnY+sJ9M2/LTVcc2EOL5ZxUAu4+FKJE+Aj/yU9rlOyDBKhTouWd/gFlzKWeU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47974031-1ddd-487a-4dc1-08d6bc62c70a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2019 20:42:55.5614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3450
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Q3VycmVudGx5LCB3ZSBmcmVlIHRoZSBwc3BfbWFzdGVyIGlmIHRoZSBQTEFURk9STV9JTklUIGZh
aWxzIGR1cmluZyB0aGUNClNFViBGVyBwcm9iZS4gSWYgcHNwX21hc3RlciBpcyBmcmVlZCB0aGVu
IGRyaXZlciBkb2VzIG5vdCBpbnZva2UgdGhlIFBTUA0KRlcuIEFzIHBlciBTRVYgRlcgc3BlYywg
dGhlcmUgYXJlIHNldmVyYWwgY29tbWFuZHMgKFBMQVRGT1JNX1JFU0VULA0KUExBVEZPUk1fU1RB
VFVTLCBHRVRfSUQgZXRjKSB3aGljaCBjYW4gYmUgZXhlY3V0ZWQgaW4gdGhlIFVOSU5JVCBzdGF0
ZQ0KV2Ugc2hvdWxkIG5vdCBmcmVlIHRoZSBwc3BfbWFzdGVyIHdoZW4gUExBVEZPUk1fSU5JVCBm
YWlscy4NCg0KRml4ZXM6IDIwMDY2NGQ1MjM3ZiAoImNyeXB0bzogY2NwOiBBZGQgU0VWIHN1cHBv
cnQiKQ0KQ2M6IFRvbSBMZW5kYWNreSA8dGhvbWFzLmxlbmRhY2t5QGFtZC5jb20+DQpDYzogSGVy
YmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KQ2M6IEdhcnkgSG9vayA8Z2Fy
eS5ob29rQGFtZC5jb20+DQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIDQuMTkueQ0KU2ln
bmVkLW9mZi1ieTogQnJpamVzaCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPg0KLS0tDQog
ZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRv
L2NjcC9wc3AtZGV2LmMgYi9kcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5jDQppbmRleCA4MGE1
OWJlOWM4MGQuLjY1NjgzODQzM2YyZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9w
c3AtZGV2LmMNCisrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2LmMNCkBAIC0xMDY0LDcg
KzEwNjQsNyBAQCB2b2lkIHBzcF9wY2lfaW5pdCh2b2lkKQ0KIAlyYyA9IHNldl9wbGF0Zm9ybV9p
bml0KCZlcnJvcik7DQogCWlmIChyYykgew0KIAkJZGV2X2VycihzcC0+ZGV2LCAiU0VWOiBmYWls
ZWQgdG8gSU5JVCBlcnJvciAlI3hcbiIsIGVycm9yKTsNCi0JCWdvdG8gZXJyOw0KKwkJcmV0dXJu
Ow0KIAl9DQogDQogCWRldl9pbmZvKHNwLT5kZXYsICJTRVYgQVBJOiVkLiVkIGJ1aWxkOiVkXG4i
LCBwc3BfbWFzdGVyLT5hcGlfbWFqb3IsDQotLSANCjIuMTcuMQ0KDQo=
