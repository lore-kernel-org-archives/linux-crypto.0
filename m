Return-Path: <SRS0=wJ3R=TO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3575C04AB4
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 21:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CDFC20873
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 21:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="1NsL+8fh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfENVx2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 May 2019 17:53:28 -0400
Received: from mail-eopbgr680075.outbound.protection.outlook.com ([40.107.68.75]:24207
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbfENVx1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 May 2019 17:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhrVvPG3cbYjZWIxrZT8cU3JGBhstOo9x1QesHGy6rU=;
 b=1NsL+8fh9Uo144sUhP8mRt/5LogKDcuDe6h30pzPghlqDedNRR4yaF0uikekDOUTLEVQKIPFBiQEAgfJHsIrJjquB4qadc2GcqKR3v36cEcqYrsU9lBHF+XxyoFj37y2Rtkimlv3gVFPJROW6ovSss3sWONB0ay5DYwZ7xpYwPc=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2566.namprd12.prod.outlook.com (52.132.141.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.27; Tue, 14 May 2019 21:53:23 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::11db:1b41:d1e6:c6dc]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::11db:1b41:d1e6:c6dc%11]) with mapi id 15.20.1878.024; Tue, 14 May
 2019 21:53:23 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 2/3] crypto: ccp - fix AES CFB error exposed by new test
 vectors
Thread-Topic: [PATCH 2/3] crypto: ccp - fix AES CFB error exposed by new test
 vectors
Thread-Index: AQHVCp9zNLfGOoWOpk6u1cgJIdU0ow==
Date:   Tue, 14 May 2019 21:53:23 +0000
Message-ID: <155787080186.29723.9592711756895297498.stgit@taos>
References: <155787079494.29723.7921582980150013941.stgit@taos>
In-Reply-To: <155787079494.29723.7921582980150013941.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:802:21::14) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 827767f1-f9c8-483a-8e90-08d6d8b695ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2566;
x-ms-traffictypediagnostic: DM5PR12MB2566:
x-microsoft-antispam-prvs: <DM5PR12MB2566DFBF3F7F7DA8622415A9FD080@DM5PR12MB2566.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(366004)(136003)(39860400002)(346002)(376002)(199004)(189003)(6512007)(86362001)(52116002)(9686003)(99286004)(53936002)(6916009)(81156014)(76176011)(102836004)(72206003)(6116002)(3846002)(2906002)(6506007)(66556008)(66476007)(26005)(386003)(186003)(66946007)(73956011)(66446008)(64756008)(6486002)(6436002)(5640700003)(446003)(11346002)(476003)(71190400001)(71200400001)(486006)(4326008)(25786009)(14454004)(68736007)(256004)(14444005)(5660300002)(2501003)(8676002)(81166006)(103116003)(33716001)(54906003)(316002)(478600001)(7736002)(305945005)(66066001)(8936002)(2351001)(31153001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2566;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:3;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1wO9xOH+W8bJ1zrlKs/Ut9T27xFLUIyQbE16qm4SU3ykXxu+FV6I+TcDzPLosN5ZAlG6tNTS1tBk30yEbamp87sgzfxBFhJL6QhotQeEqDJaQOAkP2vcKFqCbxQYjwm5KYrBVjeJa54d5JEEMX8bYxv6yCGPWRjd4tCS1nEA15gIMBjX6/fIV/s0L/7msZdd3eoZ1akEbDaSsgxBA1dBMDLAUCCefQy9XTTPkIie3MQZ/O9IdyEAWcDcWfm/uQ0nmfoH5b0a4+ASWk243Hd6KzBmQFcTNJpMmJvXIw2QSUByQxSz1iIoZzlieORCV3jzLF9gnXuNjBlkPM5cM+o6AlK3Ztv2W/9RSxRSmR129kFd+pj+Nwl5QveROKnB45rjC6+7Ae9OdAygyrgbii85B5srC3XwPBqfRXCblcUyN20=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D16FE602A4AA1A4F8D17A927762093C6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 827767f1-f9c8-483a-8e90-08d6d8b695ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 21:53:23.4209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2566
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Updated testmgr will exhibit this error message when loading the
ccp-crypto module:

alg: skcipher: cfb-aes-ccp encryption failed with err -22 on test vector 3,=
 cfg=3D"in-place"

Update the CCP crypto driver to correctly treat CFB as a streaming mode
cipher (instead of block mode). Update the configuration for CFB to
specify the block size as a single byte;

Fixes: 2b789435d7f3 ('crypto: ccp - CCP AES crypto API support')

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-c=
rypto-aes.c
index 89291c15015c..3f768699332b 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -1,7 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * AMD Cryptographic Coprocessor (CCP) AES crypto API support
  *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013-2019 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  *
@@ -79,8 +80,7 @@ static int ccp_aes_crypt(struct ablkcipher_request *req, =
bool encrypt)
 		return -EINVAL;
=20
 	if (((ctx->u.aes.mode =3D=3D CCP_AES_MODE_ECB) ||
-	     (ctx->u.aes.mode =3D=3D CCP_AES_MODE_CBC) ||
-	     (ctx->u.aes.mode =3D=3D CCP_AES_MODE_CFB)) &&
+	     (ctx->u.aes.mode =3D=3D CCP_AES_MODE_CBC)) &&
 	    (req->nbytes & (AES_BLOCK_SIZE - 1)))
 		return -EINVAL;
=20
@@ -291,7 +291,7 @@ static struct ccp_aes_def aes_algs[] =3D {
 		.version	=3D CCP_VERSION(3, 0),
 		.name		=3D "cfb(aes)",
 		.driver_name	=3D "cfb-aes-ccp",
-		.blocksize	=3D AES_BLOCK_SIZE,
+		.blocksize	=3D 1,
 		.ivsize		=3D AES_BLOCK_SIZE,
 		.alg_defaults	=3D &ccp_aes_defaults,
 	},

