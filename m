Return-Path: <SRS0=wJ3R=TO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F1BC46470
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 21:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A22BD20873
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 21:53:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="yJFI+YN2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfENVxZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 May 2019 17:53:25 -0400
Received: from mail-eopbgr730042.outbound.protection.outlook.com ([40.107.73.42]:37024
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbfENVxZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 May 2019 17:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1C0YuYwulnin0xUQwSoM8/2OwcjJ9GJ/npgXWcKxxbY=;
 b=yJFI+YN2sNK4HXJAbMxlrCzHTvloBdobE+bB0CTXZ+95yIy9ZN2nFJVU3Ua1kGcC1Q+H4I8u9sBBYMr7nOLZx6IRRunmjcJxPUYwzr0Ncd8pT3tZnV/VKsKI7FSFcCMwTc8PdyaSwHS9WNqrmOkANdB+ibCcpJARcxGEX4xHUEU=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1659.namprd12.prod.outlook.com (10.172.40.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.24; Tue, 14 May 2019 21:53:17 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::11db:1b41:d1e6:c6dc]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::11db:1b41:d1e6:c6dc%11]) with mapi id 15.20.1878.024; Tue, 14 May
 2019 21:53:16 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 1/3] crypto: ccp - AES CFB mode is a stream cipher
Thread-Topic: [PATCH 1/3] crypto: ccp - AES CFB mode is a stream cipher
Thread-Index: AQHVCp9vP3X3FAGv00iGOz/WeHJs8Q==
Date:   Tue, 14 May 2019 21:53:16 +0000
Message-ID: <155787079494.29723.7921582980150013941.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0098.namprd12.prod.outlook.com
 (2603:10b6:802:21::33) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e05955c2-85f4-4da5-eea8-08d6d8b691ca
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1659;
x-ms-traffictypediagnostic: DM5PR12MB1659:
x-microsoft-antispam-prvs: <DM5PR12MB16592541457390A02AC57F40FD080@DM5PR12MB1659.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(346002)(376002)(366004)(39860400002)(136003)(189003)(199004)(4326008)(9686003)(305945005)(25786009)(6486002)(5640700003)(6436002)(6512007)(73956011)(66446008)(66476007)(66556008)(64756008)(66946007)(186003)(7736002)(476003)(8936002)(72206003)(26005)(81166006)(8676002)(14454004)(81156014)(103116003)(486006)(478600001)(6916009)(66066001)(53936002)(86362001)(316002)(2351001)(2906002)(68736007)(33716001)(71190400001)(3846002)(6116002)(99286004)(71200400001)(2501003)(5660300002)(386003)(52116002)(6506007)(256004)(54906003)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1659;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MDWoPevmGfFZ5d+LSKKBugQXR5HeJnO5SRE3FTWAlgZoEkAksZiQiYwuklOJ8nn7cYU/h5XU/vez+U3PrRZhj9rtK+TioAlk0PBn94Bqczm8s739uJ2MiuSqLEiOAlh4aIvdQtQVOlYtvFtkBtCyKogQJ1/PuvTBjIcr9AdQw98jFYL7/H+mGIyEjSVbHh25vEMvfQBRtWAkh3J1U58/TXXpv9/P/IRQxrSDxfGYmZGjaijuO736BWuExvJCbVXjyZvOLX2k0jNNTKjP5imz+TPqo+ZSoGKJdbzxzwdxR/CwSKQFTX8SFESZ4P8h5jGPTZOBw3TVOBSssRq6GdF+RxrSEGc2YTQI2f8uHc19FSzRhdwJa1e1a9bjTBnonkxLAC4TYBs7PKEwwWSKZOkMMg9s9YAK15+5au8wTLyAtJY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D97BDD69F988AB43BF904AE837783F81@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e05955c2-85f4-4da5-eea8-08d6d8b691ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 21:53:16.7272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1659
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CFB mode should be treated as a stream cipher, not block.

Fixes: 63b945091a07 ('crypto: ccp - CCP device driver and interface support=
')

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-ops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 267a367bd076..3ecadeab919c 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1,7 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * AMD Cryptographic Coprocessor (CCP) driver
  *
- * Copyright (C) 2013,2018 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013-2019 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  * Author: Gary R Hook <gary.hook@amd.com>
@@ -893,8 +894,7 @@ static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q,=
 struct ccp_cmd *cmd)
 		return -EINVAL;
=20
 	if (((aes->mode =3D=3D CCP_AES_MODE_ECB) ||
-	     (aes->mode =3D=3D CCP_AES_MODE_CBC) ||
-	     (aes->mode =3D=3D CCP_AES_MODE_CFB)) &&
+	     (aes->mode =3D=3D CCP_AES_MODE_CBC)) &&
 	    (aes->src_len & (AES_BLOCK_SIZE - 1)))
 		return -EINVAL;
=20

