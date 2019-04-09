Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E737DC10F0E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 06:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B83122082A
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 06:38:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="uqfjGq5c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfDIGiM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 02:38:12 -0400
Received: from mail-eopbgr40052.outbound.protection.outlook.com ([40.107.4.52]:8773
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726062AbfDIGiM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 02:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7E1Ax5z/e9QWrM7+JFbMLt6KnH7o6tBTqxLBOEnH3a8=;
 b=uqfjGq5c4VzckrpM74GjBw3E1WIfkwLKnU0KO2wZILIUrkA7CHsZjT18GCeM9rScTgViP8oWe/Y85WtZqb2XweLuQ5TTvLo8K/wN5F36BCEwQsvUnYwnvAiA9yVRrKiSCsZnMJ5rXSR318ZIicj6iYpnV0TH26AwBiQ9z2N672w=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB3993.eurprd04.prod.outlook.com (52.134.107.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.19; Tue, 9 Apr 2019 06:38:08 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::7df2:64d:6c26:9bef]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::7df2:64d:6c26:9bef%5]) with mapi id 15.20.1771.019; Tue, 9 Apr 2019
 06:38:08 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH] crypto: caam/jr - Remove extra memory barrier during job ring
 dequeue
Thread-Topic: [PATCH] crypto: caam/jr - Remove extra memory barrier during job
 ring dequeue
Thread-Index: AQHU7p7L1WWMt7PWPkWjXZuiG4N0VQ==
Date:   Tue, 9 Apr 2019 06:38:08 +0000
Message-ID: <20190409063505.16664-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BM1PR01CA0131.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:40::25) To DB7PR04MB4252.eurprd04.prod.outlook.com
 (2603:10a6:5:27::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85c7bc08-0c91-48c0-8cad-08d6bcb5ed91
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB3993;
x-ms-traffictypediagnostic: DB7PR04MB3993:
x-microsoft-antispam-prvs: <DB7PR04MB399397A484F60E60C8DD606F8B2D0@DB7PR04MB3993.eurprd04.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(39860400002)(396003)(376002)(136003)(189003)(199004)(97736004)(53936002)(2616005)(2906002)(25786009)(3846002)(478600001)(386003)(6506007)(5640700003)(6116002)(14444005)(99286004)(486006)(186003)(66066001)(2501003)(256004)(86362001)(6436002)(44832011)(5660300002)(4326008)(476003)(6512007)(6916009)(2351001)(316002)(54906003)(106356001)(81156014)(26005)(105586002)(7736002)(1076003)(71190400001)(71200400001)(102836004)(50226002)(81166006)(6486002)(52116002)(68736007)(8936002)(14454004)(8676002)(305945005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB3993;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XcGyGh8qjbWuSGU2/3l9xu9moQ1OFXPiK6j6650llDxfaY1+/4eIVSq+TRGggO4o6FIaMOtX1XbdHiHdg6/ztHRSCJ4U7zLqek6s6PVkXj92469HX7OFrNYr0Y1vTWwZwzcFvZIMDB2Aq+RS4GX4Avrki80aebfA27sH6ieURHf39Jxk2d175UcGuVtwaYpmftkwVeZTIbivWxh7Y7ZK0kqoOaxzzsmPgg6MANjOQw1KY/QHixWx/pwLxZV8tZOZGEd5J7GxKc7ahMHLKv4gmumqfXlkOTGHda81jqLwgWRASumxB6SrLoMNceHHPBkiAd6A38HQo+SXgqRchPJz+GULsusWsC03atJXHRprDbWcvWzq9SQfJAaeOrIFaPOYmgkyNi0CybLvhwooHAmNWIjj9vhHEJKKuPakF0H4eP4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c7bc08-0c91-48c0-8cad-08d6bcb5ed91
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 06:38:08.3947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3993
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SW4gZnVuY3Rpb24gY2FhbV9qcl9kZXF1ZXVlKCksIGEgZnVsbCBtZW1vcnkgYmFycmllciBpcyB1
c2VkIGJlZm9yZQ0Kd3JpdGluZyByZXNwb25zZSBqb2IgcmluZydzIHJlZ2lzdGVyIHRvIHNpZ25h
bCByZW1vdmFsIG9mIHRoZSBjb21wbGV0ZWQNCmpvYi4gVGhlcmVmb3JlIGZvciB3cml0aW5nIHRo
ZSByZWdpc3Rlciwgd2UgZG8gbm90IG5lZWQgYW5vdGhlciB3cml0ZQ0KbWVtb3J5IGJhcnJpZXIu
IEhlbmNlIGl0IGlzIHJlbW92ZWQgYnkgcmVwbGFjaW5nIHRoZSBjYWxsIHRvIHdyX3JlZzMyKCkN
CndpdGggYSBuZXdseSBkZWZpbmVkIGZ1bmN0aW9uIHdyX3JlZzMyX3JlbGF4ZWQoKS4NCg0KU2ln
bmVkLW9mZi1ieTogVmFrdWwgR2FyZyA8dmFrdWwuZ2FyZ0BueHAuY29tPg0KLS0tDQogZHJpdmVy
cy9jcnlwdG8vY2FhbS9qci5jICAgfCAyICstDQogZHJpdmVycy9jcnlwdG8vY2FhbS9yZWdzLmgg
fCA4ICsrKysrKysrDQogMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NhYW0vanIuYyBiL2RyaXZlcnMv
Y3J5cHRvL2NhYW0vanIuYw0KaW5kZXggNGU5YjNmY2E1NjI3Li4yY2U2ZDdkMmFkNzIgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL2NyeXB0by9jYWFtL2pyLmMNCisrKyBiL2RyaXZlcnMvY3J5cHRvL2Nh
YW0vanIuYw0KQEAgLTI2Niw3ICsyNjYsNyBAQCBzdGF0aWMgdm9pZCBjYWFtX2pyX2RlcXVldWUo
dW5zaWduZWQgbG9uZyBkZXZhcmcpDQogCQltYigpOw0KIA0KIAkJLyogc2V0IGRvbmUgKi8NCi0J
CXdyX3JlZzMyKCZqcnAtPnJyZWdzLT5vdXRyaW5nX3JtdmQsIDEpOw0KKwkJd3JfcmVnMzJfcmVs
YXhlZCgmanJwLT5ycmVncy0+b3V0cmluZ19ybXZkLCAxKTsNCiANCiAJCWpycC0+b3V0X3Jpbmdf
cmVhZF9pbmRleCA9IChqcnAtPm91dF9yaW5nX3JlYWRfaW5kZXggKyAxKSAmDQogCQkJCQkgICAo
Sk9CUl9ERVBUSCAtIDEpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NhYW0vcmVncy5o
IGIvZHJpdmVycy9jcnlwdG8vY2FhbS9yZWdzLmgNCmluZGV4IDNjZDA4MjJlYTgxOS4uOWU5MTJj
NzIyZTMzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jcnlwdG8vY2FhbS9yZWdzLmgNCisrKyBiL2Ry
aXZlcnMvY3J5cHRvL2NhYW0vcmVncy5oDQpAQCAtOTYsNiArOTYsMTQgQEAgY3B1X3RvX2NhYW0o
MTYpDQogY3B1X3RvX2NhYW0oMzIpDQogY3B1X3RvX2NhYW0oNjQpDQogDQorc3RhdGljIGlubGlu
ZSB2b2lkIHdyX3JlZzMyX3JlbGF4ZWQodm9pZCBfX2lvbWVtICpyZWcsIHUzMiBkYXRhKQ0KK3sN
CisJaWYgKGNhYW1fbGl0dGxlX2VuZCkNCisJCXdyaXRlbF9yZWxheGVkKGRhdGEsIHJlZyk7DQor
CWVsc2UNCisJCXdyaXRlbF9yZWxheGVkKGNwdV90b19iZTMyKGRhdGEpLCByZWcpOw0KK30NCisN
CiBzdGF0aWMgaW5saW5lIHZvaWQgd3JfcmVnMzIodm9pZCBfX2lvbWVtICpyZWcsIHUzMiBkYXRh
KQ0KIHsNCiAJaWYgKGNhYW1fbGl0dGxlX2VuZCkNCi0tIA0KMi4xMy42DQoNCg==
