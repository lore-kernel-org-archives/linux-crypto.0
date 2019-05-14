Return-Path: <SRS0=wJ3R=TO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA592C04AB4
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 21:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA95E20873
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 21:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="x5bUxAHF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbfENVxg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 May 2019 17:53:36 -0400
Received: from mail-eopbgr730042.outbound.protection.outlook.com ([40.107.73.42]:28208
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbfENVxg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 May 2019 17:53:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8zIiscsNW/l6vUizBLG26l67LIgELNCWYIvq7S8Ff0=;
 b=x5bUxAHFvGiRy3Qp5RGzYsXWzaO7QSmGdOVHGgfODo5MrfK1fKfSKMn33SymK71/MunV28ovWbqYNz75oShND5KZztSueajH2RfGEPHlz//fbtAHzZ4Xhbq5eh3Lke7WK9QUsN3jw5hUpLfll2btld6ayjtCvKZSZHgy1YaoGaM=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1659.namprd12.prod.outlook.com (10.172.40.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.24; Tue, 14 May 2019 21:53:30 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::11db:1b41:d1e6:c6dc]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::11db:1b41:d1e6:c6dc%11]) with mapi id 15.20.1878.024; Tue, 14 May
 2019 21:53:30 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 3/3] crypto: ccp - Fix 3DES complaint from ccp-crypto module
Thread-Topic: [PATCH 3/3] crypto: ccp - Fix 3DES complaint from ccp-crypto
 module
Thread-Index: AQHVCp93X8zbRVwZX0udVbmBLT+j3g==
Date:   Tue, 14 May 2019 21:53:30 +0000
Message-ID: <155787080856.29723.18218380163821644624.stgit@taos>
References: <155787079494.29723.7921582980150013941.stgit@taos>
In-Reply-To: <155787079494.29723.7921582980150013941.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0110.namprd12.prod.outlook.com
 (2603:10b6:802:21::45) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b6dbe61-eb6d-4f13-a472-08d6d8b699ea
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1659;
x-ms-traffictypediagnostic: DM5PR12MB1659:
x-microsoft-antispam-prvs: <DM5PR12MB16591055FDC0866A8717A8D0FD080@DM5PR12MB1659.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(346002)(376002)(366004)(39860400002)(136003)(189003)(199004)(4326008)(9686003)(305945005)(25786009)(6486002)(5640700003)(6436002)(6512007)(11346002)(73956011)(66446008)(66476007)(66556008)(64756008)(66946007)(186003)(7736002)(476003)(8936002)(72206003)(26005)(81166006)(8676002)(14454004)(81156014)(103116003)(486006)(478600001)(446003)(6916009)(66066001)(53936002)(86362001)(316002)(2351001)(2906002)(68736007)(33716001)(71190400001)(3846002)(6116002)(99286004)(71200400001)(76176011)(2501003)(5660300002)(386003)(52116002)(6506007)(256004)(54906003)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1659;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: O5xV5ylYkAeuzdNb1Io5ou3yVJbJrw3eW9zabprkmYnGRv94FEwz77nvyB/Z9pbjZ39u1Gkd6EUhxWeSRqw7jl1iQotx/zAyn3UWAijYGZtRLz92m367eqsz9pFjFJQFV1c29sENw6KX8n9tXj33r+kF4N5fp7sbm2+YSRK8bKAAEayT0ognN+yQvhQncXm1n2IqUwa4ElogUdi8MeJVLj7C2ue0arlWjVpwLwJI0t3t3UX8zl+SGZpktb7K1tK4mcsa+V5NMrheXIqskLeDDRUqrGid1T51ABBomfrMbRTgxxNtC7HHO3sIYu+GFG328l8szpfscXiRIh+/97nX9/wucE4kHk69YA87RyXTkwtBF0yW3wNETGJDM/PTayw9yv2pnORTH31GNtNhFGb9YznIATOE7DN2J7qsZYW6sSY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5DBB0773084CDF4DAAB44796365EA5D2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b6dbe61-eb6d-4f13-a472-08d6d8b699ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 21:53:30.1916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1659
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Crypto self-tests reveal an error:

alg: skcipher: cbc-des3-ccp encryption test failed (wrong output IV) on tes=
t vector 0, cfg=3D"in-place"

The offset value should not be recomputed when retrieving the context.
Also, a code path exists which makes decisions based on older (version 3)
hardware; a v3 device deosn't support 3DES so remove this check.

Fixes: 990672d48515 ('crypto: ccp - Enable 3DES function on v5 CCPs')

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-ops.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 3ecadeab919c..b116d62991c6 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1267,6 +1267,9 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue *cmd=
_q, struct ccp_cmd *cmd)
 	int ret;
=20
 	/* Error checks */
+	if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0))
+		return -EINVAL;
+
 	if (!cmd_q->ccp->vdata->perform->des3)
 		return -EINVAL;
=20
@@ -1349,8 +1352,6 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue *cmd=
_q, struct ccp_cmd *cmd)
 	 * passthru option to convert from big endian to little endian.
 	 */
 	if (des3->mode !=3D CCP_DES3_MODE_ECB) {
-		u32 load_mode;
-
 		op.sb_ctx =3D cmd_q->sb_ctx;
=20
 		ret =3D ccp_init_dm_workarea(&ctx, cmd_q,
@@ -1366,12 +1367,8 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue *cm=
d_q, struct ccp_cmd *cmd)
 		if (ret)
 			goto e_ctx;
=20
-		if (cmd_q->ccp->vdata->version =3D=3D CCP_VERSION(3, 0))
-			load_mode =3D CCP_PASSTHRU_BYTESWAP_NOOP;
-		else
-			load_mode =3D CCP_PASSTHRU_BYTESWAP_256BIT;
 		ret =3D ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
-				     load_mode);
+				     CCP_PASSTHRU_BYTESWAP_256BIT);
 		if (ret) {
 			cmd->engine_error =3D cmd_q->cmd_error;
 			goto e_ctx;
@@ -1433,10 +1430,6 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue *cm=
d_q, struct ccp_cmd *cmd)
 		}
=20
 		/* ...but we only need the last DES3_EDE_BLOCK_SIZE bytes */
-		if (cmd_q->ccp->vdata->version =3D=3D CCP_VERSION(3, 0))
-			dm_offset =3D CCP_SB_BYTES - des3->iv_len;
-		else
-			dm_offset =3D 0;
 		ccp_get_dm_area(&ctx, dm_offset, des3->iv, 0,
 				DES3_EDE_BLOCK_SIZE);
 	}

