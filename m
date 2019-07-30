Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD01C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 18:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12AAB2064A
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 18:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="a4MU0BTj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfG3S2G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 14:28:06 -0400
Received: from mail-eopbgr780073.outbound.protection.outlook.com ([40.107.78.73]:41696
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726714AbfG3S2G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 14:28:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VRQYAsKuxq3HWbjRDVbgdAxpwd4+i70jAQSG6P0BcrLMXzjT2noQ5N6MFKGMZ6NP5AtHuq4SLmWKEXsMp3ALmoqFwRj3OZCkvHBDCxjBaZLA+3z33XJ69vaktSgV8c85ksLUz7eD7WudH6Y4chjEqKtz2CHdN4ABzk8aL0CJe3+pJ7kehS8+6q5LvSBTHhJS/76j5MSflshI7rsG4ALhRdGrqbZl8pLho3aMr/YM3AfphRjkli7NjV7Dj7MjE6I2shOawuqTgUltmxjnt+fusl/HjpzdMVh8mBYTt3Z9wZ0dBneZJnaNSiPohbM+SyWCS78yJcLNhyLoLX6XCCwagQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XuhPWIBBq54a4gNtZ1vkVPtxlJBJe5cgQaoE36181k=;
 b=ZQwwyJ/x3lcnbOIg1QYs/VtqGjR5r04YWud4iu0Jh2jVDOinCB/xHNuIuifqQtJvO44aIf9TsRU4zu2DBrfREGwkjvm+ylpwy0qbDvdZsA4Y2qbxB1/xQKO+kf+s8BQGyicJ8sOwp4s5aQmglokfUr88cv1Ri1oR5scygi2aySAzGanyiPpL8fFgZ6VvsPZtsm0o7MiLvF2eQo05ts06RycxuoWDgZC6oVYjVTc2ADJH2ePXUvgkUHNW3pV5Ak88SoUnsjDKPjuANcsEAcYyvipPqXgSnA8i41Z2xYDLjxMb3CLS5SJoPFKUi7+FfcEDerMfJPUzRHoTiQ3M29hcEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XuhPWIBBq54a4gNtZ1vkVPtxlJBJe5cgQaoE36181k=;
 b=a4MU0BTjQGfcfAzJljKGja+bs4g8kac+PlLRmxLb24r778wBgHaQDT7w1WROuZFUjpE5pVeRCPU5Vi47b5UCsMTRYjDYhiTooskNVxF8t2iUcvBlgrGsjkoavfgQqw6E5XB2GnkdxUv8DlQJckzesuIc+QPLLCZ3HV3ydBFH3fY=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1227.namprd12.prod.outlook.com (10.168.238.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 30 Jul 2019 18:28:04 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a%8]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 18:28:04 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH] crypto:ccp - Return from init on allocation failure
Thread-Topic: [PATCH] crypto:ccp - Return from init on allocation failure
Thread-Index: AQHVRwSGhlcRO50Wx0SjVeOg7NpBNQ==
Date:   Tue, 30 Jul 2019 18:28:03 +0000
Message-ID: <20190730182738.26432-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN2PR01CA0053.prod.exchangelabs.com (2603:10b6:800::21) To
 DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c86468e7-84d7-4f80-e8df-08d7151ba8a6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1227;
x-ms-traffictypediagnostic: DM5PR12MB1227:
x-microsoft-antispam-prvs: <DM5PR12MB1227D88FBA6F83C50423721EFDDC0@DM5PR12MB1227.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(199004)(189003)(2616005)(36756003)(81156014)(81166006)(86362001)(316002)(256004)(6916009)(5640700003)(4744005)(2906002)(53936002)(68736007)(1076003)(54906003)(478600001)(5660300002)(14454004)(2501003)(66476007)(3846002)(64756008)(6116002)(26005)(102836004)(386003)(71200400001)(66556008)(2351001)(476003)(7736002)(99286004)(186003)(66446008)(6506007)(8936002)(52116002)(4326008)(66946007)(8676002)(6486002)(6436002)(486006)(6512007)(50226002)(66066001)(25786009)(71190400001)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1227;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t9yXRGdkEnJwlWLDniCwWzFYlGAdBAaZAfPixL2IVhjAqvGd88IdHWfBN/57ZwOHSrgJ4rjnfLJVsTwU5n+ImSnuhBMGB8XwQTE/p1me5Uap5he4LAz38WCAUWKkHd+rNNs1O8ph0KGXUE61kKCS6PMYty5Nj2phEcEo2hXalm42na+KV7wttezBpmq1frN+gj31zIBu8FDmoR3e7xLNRWbTmUi9LADZUWHoi2FwIRjtUENSQNB2Bh+SxcdGCKrDu52CBuIcVjR/d8w4f+58JoV+6b9OE3Njg89wkIOXC7exJaUsMxwcxqJJU8ht10EWwGGGiXj1dUqt9zuxi27UZZrAQ6b1th1YzSpEwYHeqAaag8b0VRdwjUqHLS5bBOmPRJElCXzZGq5XfyERZ2pNhrDKBQ0ddUuhYaWwKGieCtI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <930ED247567A094CA8463F38DC378C85@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c86468e7-84d7-4f80-e8df-08d7151ba8a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 18:28:03.7608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1227
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Return and fail driver initialization if a DMA pool can't be
allocated.

Fixes: 4b394a232df7 ("crypto: ccp - Let a v5 CCP provide the same function =
as v3")

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v=
5.c
index f146b51a23a5..3c0f0d0c3153 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -803,6 +803,7 @@ static int ccp5_init(struct ccp_device *ccp)
 		if (!dma_pool) {
 			dev_err(dev, "unable to allocate dma pool\n");
 			ret =3D -ENOMEM;
+			goto e_pool;
 		}
=20
 		cmd_q =3D &ccp->cmd_q[ccp->cmd_q_count];
--=20
2.17.1

