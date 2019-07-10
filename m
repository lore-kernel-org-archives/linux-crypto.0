Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CED4C74A35
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 21:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 306B120838
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 21:45:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="CkZtPgXC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfGJVpp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 17:45:45 -0400
Received: from mail-eopbgr700056.outbound.protection.outlook.com ([40.107.70.56]:40421
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727188AbfGJVpp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 17:45:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cedYW+pyQKokb5vEkvQ/8bnSDvk7hVM1qk9cLe/q9sg=;
 b=CkZtPgXCoyl4JZJkRrV7H/eijhoGLt4y66rwDvkA11GpFfw+39JbNLqzTToqwzYnycLfdSqCYQWSbO2otTKUlvzXLrZkcTV/IgONZDhjQviMgg6AGfT2PXO2pJnhovbxUgx968VoRw5eKaIjersJ9BMbY2YOkLztHTv91enrU5Y=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1338.namprd12.prod.outlook.com (10.168.235.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Wed, 10 Jul 2019 21:45:39 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 21:45:39 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH 2/2] crypto: ccp - Log an error message when ccp-crypto fails
 to load
Thread-Topic: [PATCH 2/2] crypto: ccp - Log an error message when ccp-crypto
 fails to load
Thread-Index: AQHVN2jQwttvC61Yq0WbCSh/OEN7tA==
Date:   Wed, 10 Jul 2019 21:45:38 +0000
Message-ID: <20190710214504.3420-3-gary.hook@amd.com>
References: <20190710214504.3420-1-gary.hook@amd.com>
In-Reply-To: <20190710214504.3420-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR06CA0017.namprd06.prod.outlook.com
 (2603:10b6:805:8e::30) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34dfc445-dd49-47a1-fb24-08d7057ff2b7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1338;
x-ms-traffictypediagnostic: DM5PR12MB1338:
x-microsoft-antispam-prvs: <DM5PR12MB13380BCBF78B95BBA762583CFDF00@DM5PR12MB1338.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(189003)(199004)(186003)(478600001)(14454004)(54906003)(316002)(25786009)(14444005)(102836004)(6506007)(4326008)(386003)(71190400001)(26005)(256004)(3846002)(76176011)(1076003)(5640700003)(52116002)(99286004)(6116002)(66066001)(305945005)(2906002)(2501003)(6436002)(7736002)(6486002)(8676002)(81166006)(53936002)(86362001)(50226002)(6512007)(6916009)(66446008)(11346002)(15650500001)(446003)(66946007)(66556008)(64756008)(2351001)(36756003)(68736007)(66476007)(476003)(2616005)(4744005)(5660300002)(71200400001)(81156014)(486006)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1338;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zrYdEMQNXIhqwkmALH1/hvF8X+sVO95gAFPvquaxroNcD7mZNyHSZrTcWxk3KGRBwaO1Kc0bMqR9K576+BJ4NroyBvzYH0AJdncC2W1CFeN4csx/WSGg3dTHf/erbWSiJIVVEA8bE8ete3i/K44K0gkF2CgQ3geGztdwH54Dzxfl7f7WmelngFGHYM3/l5lq5IC8/5bm1dS+UY7yJ7oDzwnQi+YE5AhRSPUW3b+7F0BLUzG5pf336Yq/U4OoE0jZmxdMQBd+pfej44ZGPVmlOwD/bakf779s3DZ5fRwzJBaIWVAAdm3xaux/7A/rstoyezDS97tbpctIQ2285Rndo/8sIN7PieE0otMa134ZhKJZPWEHb29tncRDnCyqo39TGiEsL19dV2n2YnTMUs6uY4OV3G6h50GsaRhUGPNY7XE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34dfc445-dd49-47a1-fb24-08d7057ff2b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 21:45:38.9695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1338
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If there are no CCP devices on the system, ccp-crypto will not load.
Write a message to the system log clarifying the reason for the failure
of the modprobe operation
---
 drivers/crypto/ccp/ccp-crypto-main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-=
crypto-main.c
index 44a9917a4a6a..5b61c440dff0 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -405,8 +405,10 @@ static int ccp_crypto_init(void)
 	int ret;
=20
 	ret =3D ccp_present();
-	if (ret)
+	if (ret) {
+		pr_err("Cannot load: there are no available CCPs\n");
 		return ret;
+	}
=20
 	spin_lock_init(&req_queue_lock);
 	INIT_LIST_HEAD(&req_queue.cmds);
--=20
2.17.1

