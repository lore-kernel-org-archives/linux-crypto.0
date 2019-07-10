Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755EAC73C65
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 00:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D4222081C
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 00:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="eEcaVrIR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfGJAJc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 20:09:32 -0400
Received: from mail-eopbgr820087.outbound.protection.outlook.com ([40.107.82.87]:60288
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726218AbfGJAJc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 20:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5a1K4TAi1Y+d4bV3QjM993xStEEqVv5OAd3MHCKkzE=;
 b=eEcaVrIRAAu8Vmwz0bETfUiQteiPYWMbkmcMecnJ8hN74z3E7LTbpFhh7ecyFdHGc+HQIyoPzKYVfwCK9ldZbG7JUFdGagK+nZrJMgUwcNAnshG9iBc8cSqlU92/9INN2x93coj2Ho2sl06pRI483jl8nMNegrXc2yk3pLUGoD8=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1402.namprd12.prod.outlook.com (10.168.236.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 10 Jul 2019 00:09:23 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.019; Wed, 10 Jul 2019
 00:09:23 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH v2] crypto: ccp - memset structure fields to zero before reuse
Thread-Topic: [PATCH v2] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Index: AQHVNrO6m+NQJFdJik6RYa0T/lhkoA==
Date:   Wed, 10 Jul 2019 00:09:22 +0000
Message-ID: <20190710000849.3131-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0080.namprd12.prod.outlook.com
 (2603:10b6:802:21::15) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56647ff3-4a2c-444f-a05a-08d704cadc7b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1402;
x-ms-traffictypediagnostic: DM5PR12MB1402:
x-microsoft-antispam-prvs: <DM5PR12MB1402CEE617B4DEE231409A37FDF00@DM5PR12MB1402.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:312;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(199004)(189003)(316002)(14444005)(1076003)(6512007)(6916009)(71200400001)(71190400001)(476003)(256004)(53936002)(25786009)(2501003)(6486002)(81156014)(14454004)(8676002)(478600001)(4326008)(50226002)(486006)(3846002)(6116002)(6436002)(99286004)(26005)(66066001)(305945005)(7736002)(386003)(2906002)(8936002)(52116002)(81166006)(66556008)(5660300002)(2351001)(6506007)(86362001)(102836004)(64756008)(186003)(54906003)(66476007)(36756003)(5640700003)(66446008)(68736007)(66946007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1402;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fpprE1iTTxrj1wfu0EvjBg6XPBRECp1HYYflmJO3DF26gTs9yepQbSnKD9LbaQpC341E/82tidlCGQO8B7XcMqx/YUeJtwxPFFAiOsBvEuaL/TrS11v7To2M49KXkuEPzX3f2SDwao1C64XK4hXojoxHL/3mmXSe5iNHHqCh/J5Ry+yrAj5iOK9Rw2cMvyHSZQ7C8KlBg35uKncnTLxzBqEmodxjW6R/+IOrfG7NmyNKfgGg94cSr1+PKYYDp1tCOIi2v45hzsVQcWY0+sv+B8eDyCjaQzrSv/ZyJSCtVhJPsQx9w1xHx5D853ifxoE0tosz0oUJa/NETI4gOHhjTzKLHqVg8uI8Y65m23bFDwNaiEoK8WRDlQZxGo6HCkSWOz2uf9+pliUUXFIHww/WYxFQMbRpdP24lDxpOQc6968=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56647ff3-4a2c-444f-a05a-08d704cadc7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 00:09:22.8201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1402
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AES GCM function reuses an 'op' data structure, which members
contain values that must be cleared for each (re)use.

This fix resolves a crypto self-test failure:
alg: aead: gcm-aes-ccp encryption test failed (wrong result) on test vector=
 2, cfg=3D"two even aligned splits"

Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---

Changes since v1:
 - Explain in the commit message that this fix resolves a failed test

 drivers/crypto/ccp/ccp-ops.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index a817f2755c58..9ecc1bb4b237 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -622,6 +622,7 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cm=
d_q,
=20
 	unsigned long long *final;
 	unsigned int dm_offset;
+	unsigned int jobid;
 	unsigned int ilen;
 	bool in_place =3D true; /* Default value */
 	int ret;
@@ -660,9 +661,11 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *c=
md_q,
 		p_tag =3D scatterwalk_ffwd(sg_tag, p_inp, ilen);
 	}
=20
+	jobid =3D CCP_NEW_JOBID(cmd_q->ccp);
+
 	memset(&op, 0, sizeof(op));
 	op.cmd_q =3D cmd_q;
-	op.jobid =3D CCP_NEW_JOBID(cmd_q->ccp);
+	op.jobid =3D jobid;
 	op.sb_key =3D cmd_q->sb_key; /* Pre-allocated */
 	op.sb_ctx =3D cmd_q->sb_ctx; /* Pre-allocated */
 	op.init =3D 1;
@@ -813,6 +816,13 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *c=
md_q,
 	final[0] =3D cpu_to_be64(aes->aad_len * 8);
 	final[1] =3D cpu_to_be64(ilen * 8);
=20
+	memset(&op, 0, sizeof(op));
+	op.cmd_q =3D cmd_q;
+	op.jobid =3D jobid;
+	op.sb_key =3D cmd_q->sb_key; /* Pre-allocated */
+	op.sb_ctx =3D cmd_q->sb_ctx; /* Pre-allocated */
+	op.init =3D 1;
+	op.u.aes.type =3D aes->type;
 	op.u.aes.mode =3D CCP_AES_MODE_GHASH;
 	op.u.aes.action =3D CCP_AES_GHASHFINAL;
 	op.src.type =3D CCP_MEMTYPE_SYSTEM;
--=20
2.17.1

