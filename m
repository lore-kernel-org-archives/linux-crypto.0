Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD4DC282DA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 11:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A99A206BA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 11:17:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hNk8654g";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="ojjdhiCk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbfDQLRy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 07:17:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59492 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731108AbfDQLRx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 07:17:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3HBFK9a016365;
        Wed, 17 Apr 2019 04:15:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=xutHkC9rmvRNWAymcQZxVGPhajg7YcYk8ZX59U+l3xM=;
 b=hNk8654ggxhLeF6TFu4HnYYdKfBf8JiGEDFY/b4x6okHj7FThJvv+TpU9fJH7hPczen0
 qJ9saeOoIY9X2OmFkKGR5OedNLLQKcrN8B/DOoeUNmYM9I4lJbD5gBusG6mfd++E55GP
 NGcM9trwpbhznAjDqpC9BY7LM6EvmvTN2PK702p7mxzjVO66lx5OsQfzfEGD88ADliWR
 YYSaAI0wmV2wTRDXoZmmPP/gzi+TlBKMID3KPX6LXqduMj0oN9gPk88DJyLxZUd9K5z5
 RsvVPTkTCNRVCrrtS+uvJK+sEcsQVeaR2AKk7s3KQAiBqAmJma3/gjWKuJDhNYyRy/BT tQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2rwyuf0n93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Apr 2019 04:15:39 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 17 Apr
 2019 04:15:38 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (104.47.34.55) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 17 Apr 2019 04:15:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xutHkC9rmvRNWAymcQZxVGPhajg7YcYk8ZX59U+l3xM=;
 b=ojjdhiCkpY1kVPywyP+HpuRoJSBJLFGkqQhjRsFXeDrcODaaeJZ7EBaFQOJCvImr1xDixOMLGhVE5lBvdZ50fS6jdeO6Bp+yxjhfyEckJCfrxjR0ryUJdMzEaxd83KnouBv6Lw6bPY5S1DKLqgTaLkwgXMRZPj9TjydXrQFA4Kw=
Received: from MN2PR18MB2797.namprd18.prod.outlook.com (20.179.22.16) by
 MN2PR18MB2686.namprd18.prod.outlook.com (20.179.81.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.19; Wed, 17 Apr 2019 11:15:33 +0000
Received: from MN2PR18MB2797.namprd18.prod.outlook.com
 ([fe80::b044:72d8:78:7c02]) by MN2PR18MB2797.namprd18.prod.outlook.com
 ([fe80::b044:72d8:78:7c02%2]) with mapi id 15.20.1813.011; Wed, 17 Apr 2019
 11:15:33 +0000
From:   Nagadheeraj Rottela <rnagadheeraj@marvell.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Srikanth Jampala" <jsrikanth@marvell.com>,
        Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Subject: [PATCH] crypto: cavium/nitrox - Fix HW family part name format
Thread-Topic: [PATCH] crypto: cavium/nitrox - Fix HW family part name format
Thread-Index: AQHU9Q7fqhqTzsK8q0iLLC/zvoPvKw==
Date:   Wed, 17 Apr 2019 11:15:33 +0000
Message-ID: <20190417111503.16618-1-rnagadheeraj@marvell.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0070.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::34) To MN2PR18MB2797.namprd18.prod.outlook.com
 (2603:10b6:208:a0::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [115.113.156.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c136fdf5-8b59-42aa-75b5-08d6c326020e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600140)(711020)(4605104)(2017052603328)(7193020);SRVR:MN2PR18MB2686;
x-ms-traffictypediagnostic: MN2PR18MB2686:
x-microsoft-antispam-prvs: <MN2PR18MB268651AF7F4572E69CF8574BD6250@MN2PR18MB2686.namprd18.prod.outlook.com>
x-forefront-prvs: 0010D93EFE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(366004)(39860400002)(136003)(189003)(199004)(106356001)(305945005)(102836004)(26005)(53936002)(6512007)(7736002)(107886003)(105586002)(4326008)(71200400001)(71190400001)(186003)(99286004)(256004)(2616005)(476003)(1076003)(486006)(6436002)(6486002)(110136005)(54906003)(316002)(66066001)(55236004)(2906002)(5660300002)(25786009)(97736004)(14454004)(478600001)(3846002)(6116002)(2501003)(36756003)(8936002)(81166006)(52116002)(68736007)(86362001)(386003)(6506007)(50226002)(81156014)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2686;H:MN2PR18MB2797.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hVXz5mLCWs4r+JrEpkgRVfq7+GXHPSOcRatyhEuZJakFI5ydK8ZSHcCYK02xUF0YQ7DT1FEO6oHIuU6/tzTMMcMbFUjEOzJusFJkL9fL9mioP/hPNvvdIFw4nmP7fc1j7p8QtQ/7AEI668qilc99uQXgMvcPFHzIr04Hy8JmcnGCkpgJwFbKb7AHY0I4MqikbEAq4nrfr0kdX9dkk9OXFpy37kSK9KoNHn+0l+VSGYGNQ+OqfgwlP/moKgEyk+oZM6YeIUZbwMmG16DxK1i0OxM9zUlkJ7j3FZ+1+TvcM2/K302cWxBub4Hwlu++4mSOMa+eZFLbSDCfoXbtn76MckNKn6jlpRcoEp2gPjqGQ2rDiTIFSPpZeuvhup2wCUnhjdk7Leg0eYe8ZZr5+7UH9GHovtX0O8VIWZqkiM6QQ8k=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c136fdf5-8b59-42aa-75b5-08d6c326020e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2019 11:15:33.2741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2686
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-17_05:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhpcyBwYXRjaCBmaXhlcyB0aGUgTklUUk9YLVYgZmFtaWx5IHBhcnQgbmFtZSBmb3JtYXQuIFRo
ZSBmaXggaW5jbHVkZXMNClpJUCBjb3JlIHBlcmZvcm1hbmNlIChmZWF0dXJlIG9wdGlvbikgaW4g
dGhlIHBhcnQgbmFtZSB0byBkaWZmZXJlbnRpYXRlDQp2YXJpb3VzIEhXIGRldmljZXMuIFRoZSBj
b21wbGV0ZSBIVyBwYXJ0IG5hbWUgZm9ybWF0IGlzIG1lbnRpb25lZCBiZWxvdw0KDQpQYXJ0IG5h
bWU6IENOTjU1PGNvcmUgb3B0aW9uPi08ZnJlcT5CRzY3Ni08ZmVhdHVyZSBvcHRpb24+LTxyZXY+
DQoNClNpZ25lZC1vZmYtYnk6IE5hZ2FkaGVlcmFqIFJvdHRlbGEgPHJuYWdhZGhlZXJhakBtYXJ2
ZWxsLmNvbT4NClJldmlld2VkLWJ5OiBTcmlrYW50aCBKYW1wYWxhIDxqc3Jpa2FudGhAbWFydmVs
bC5jb20+DQotLS0NCiBkcml2ZXJzL2NyeXB0by9jYXZpdW0vbml0cm94L25pdHJveF9oYWwuYyB8
IDY1ICsrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgNDcg
aW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Ny
eXB0by9jYXZpdW0vbml0cm94L25pdHJveF9oYWwuYyBiL2RyaXZlcnMvY3J5cHRvL2Nhdml1bS9u
aXRyb3gvbml0cm94X2hhbC5jDQppbmRleCBjMDhkOWYzM2EzYjEuLjNmMGRmNjAyNjdhOSAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvY3J5cHRvL2Nhdml1bS9uaXRyb3gvbml0cm94X2hhbC5jDQorKysg
Yi9kcml2ZXJzL2NyeXB0by9jYXZpdW0vbml0cm94L25pdHJveF9oYWwuYw0KQEAgLTQzNyw2ICs0
MzcsNDUgQEAgdm9pZCBjb25maWdfbnBzX2NvcmVfdmZjZmdfbW9kZShzdHJ1Y3Qgbml0cm94X2Rl
dmljZSAqbmRldiwgZW51bSB2Zl9tb2RlIG1vZGUpDQogCW5pdHJveF93cml0ZV9jc3IobmRldiwg
TlBTX0NPUkVfR0JMX1ZGQ0ZHLCB2ZmNmZy52YWx1ZSk7DQogfQ0KIA0KK3N0YXRpYyBjb25zdCBj
aGFyICpnZXRfY29yZV9vcHRpb24odTggc2VfY29yZXMsIHU4IGFlX2NvcmVzKQ0KK3sNCisJY29u
c3QgY2hhciAqb3B0aW9uID0gIiI7DQorDQorCWlmIChhZV9jb3JlcyA9PSBBRV9NQVhfQ09SRVMp
IHsNCisJCXN3aXRjaCAoc2VfY29yZXMpIHsNCisJCWNhc2UgU0VfTUFYX0NPUkVTOg0KKwkJCW9w
dGlvbiA9ICI2MCI7DQorCQkJYnJlYWs7DQorCQljYXNlIDQwOg0KKwkJCW9wdGlvbiA9ICI2MHMi
Ow0KKwkJCWJyZWFrOw0KKwkJfQ0KKwl9IGVsc2UgaWYgKGFlX2NvcmVzID09IChBRV9NQVhfQ09S
RVMgLyAyKSkgew0KKwkJb3B0aW9uID0gIjMwIjsNCisJfSBlbHNlIHsNCisJCW9wdGlvbiA9ICI2
MGkiOw0KKwl9DQorDQorCXJldHVybiBvcHRpb247DQorfQ0KKw0KK3N0YXRpYyBjb25zdCBjaGFy
ICpnZXRfZmVhdHVyZV9vcHRpb24odTggemlwX2NvcmVzLCBpbnQgY29yZV9mcmVxKQ0KK3sNCisJ
aWYgKHppcF9jb3JlcyA9PSAwKQ0KKwkJcmV0dXJuICIiOw0KKwllbHNlIGlmICh6aXBfY29yZXMg
PCBaSVBfTUFYX0NPUkVTKQ0KKwkJcmV0dXJuICItQzE1IjsNCisNCisJaWYgKGNvcmVfZnJlcSA+
PSA4NTApDQorCQlyZXR1cm4gIi1DNDUiOw0KKwllbHNlIGlmIChjb3JlX2ZyZXEgPj0gNzUwKQ0K
KwkJcmV0dXJuICItQzM1IjsNCisJZWxzZSBpZiAoY29yZV9mcmVxID49IDU1MCkNCisJCXJldHVy
biAiLUMyNSI7DQorDQorCXJldHVybiAiIjsNCit9DQorDQogdm9pZCBuaXRyb3hfZ2V0X2h3aW5m
byhzdHJ1Y3Qgbml0cm94X2RldmljZSAqbmRldikNCiB7DQogCXVuaW9uIGVtdV9mdXNlX21hcCBl
bXVfZnVzZTsNCkBAIC00NjksMjQgKzUwOCwxNCBAQCB2b2lkIG5pdHJveF9nZXRfaHdpbmZvKHN0
cnVjdCBuaXRyb3hfZGV2aWNlICpuZGV2KQ0KIAkJbmRldi0+aHcuemlwX2NvcmVzID0gWklQX01B
WF9DT1JFUyAtIGRlYWRfY29yZXM7DQogCX0NCiANCi0JLyogZGV0ZXJtaW5lIHRoZSBwYXJ0bmFt
ZSBDTk41NTxjb3Jlcz4tPGZyZXE+PHBpbmNvdW50Pi08cmV2PiovDQotCWlmIChuZGV2LT5ody5h
ZV9jb3JlcyA9PSBBRV9NQVhfQ09SRVMpIHsNCi0JCXN3aXRjaCAobmRldi0+aHcuc2VfY29yZXMp
IHsNCi0JCWNhc2UgU0VfTUFYX0NPUkVTOg0KLQkJCWkgPSBzbnByaW50ZihuYW1lLCBzaXplb2Yo
bmFtZSksICJDTk41NTYwIik7DQotCQkJYnJlYWs7DQotCQljYXNlIDQwOg0KLQkJCWkgPSBzbnBy
aW50ZihuYW1lLCBzaXplb2YobmFtZSksICJDTk41NTYwcyIpOw0KLQkJCWJyZWFrOw0KLQkJfQ0K
LQl9IGVsc2UgaWYgKG5kZXYtPmh3LmFlX2NvcmVzID09IChBRV9NQVhfQ09SRVMgLyAyKSkgew0K
LQkJaSA9IHNucHJpbnRmKG5hbWUsIHNpemVvZihuYW1lKSwgIkNOTjU1MzAiKTsNCi0JfSBlbHNl
IHsNCi0JCWkgPSBzbnByaW50ZihuYW1lLCBzaXplb2YobmFtZSksICJDTk41NTYwaSIpOw0KLQl9
DQotDQotCXNucHJpbnRmKG5hbWUgKyBpLCBzaXplb2YobmFtZSkgLSBpLCAiLSUzZEJHNjc2LTEu
JXUiLA0KLQkJIG5kZXYtPmh3LmZyZXEsIG5kZXYtPmh3LnJldmlzaW9uX2lkKTsNCisJLyogZGV0
ZXJtaW5lIHRoZSBwYXJ0bmFtZQ0KKwkgKiBDTk41NTxjb3JlIG9wdGlvbj4tPGZyZXE+PHBpbmNv
dW50Pi08ZmVhdHVyZSBvcHRpb24+LTxyZXY+DQorCSAqLw0KKwlzbnByaW50ZihuYW1lLCBzaXpl
b2YobmFtZSksICJDTk41NSVzLSUzZEJHNjc2JXMtMS4ldSIsDQorCQkgZ2V0X2NvcmVfb3B0aW9u
KG5kZXYtPmh3LnNlX2NvcmVzLCBuZGV2LT5ody5hZV9jb3JlcyksDQorCQkgbmRldi0+aHcuZnJl
cSwNCisJCSBnZXRfZmVhdHVyZV9vcHRpb24obmRldi0+aHcuemlwX2NvcmVzLCBuZGV2LT5ody5m
cmVxKSwNCisJCSBuZGV2LT5ody5yZXZpc2lvbl9pZCk7DQogDQogCS8qIGNvcHkgcGFydG5hbWUg
Ki8NCiAJc3RybmNweShuZGV2LT5ody5wYXJ0bmFtZSwgbmFtZSwgc2l6ZW9mKG5kZXYtPmh3LnBh
cnRuYW1lKSk7DQotLSANCjIuMTMuNg0KDQo=
