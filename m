Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB01C43381
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 08:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2BF2652AB
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 08:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhCIIM2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 03:12:28 -0500
Received: from mail-co1nam11on2072.outbound.protection.outlook.com ([40.107.220.72]:56608
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229481AbhCIILx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 03:11:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0+7jaKSzW0yyDe5vzpINpJUd/PkYcvDSjQMX9X9xY9qDp7LBlN8mfdXhRXtsZZwNNWPwZ1s6oYemM/a7wHT5T01sbO/y0M5tjQYrqNvyBfisvZIU+twCt4BKv927wrRM5hSKQ3Tl1pzVZa2eA3YvQsaEBT3MgQZVKrFVAcH3EyH6/KCkgGbOvNPsyCAbVVTqHYF8fMyvbEJe2Sr+PmWZqqzFJKMaz/Tz+MwiIc9NaqH/ZcFdk1ruh28tuNk1/LWOkNYX3IYLHXebF0SRvVCa+xraRDO4naxvPYfyTQzty3N9jnWX/ojLJ6/LzVDoFAPedjczT/wqVjyY+dUV6XyrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvjwnCt2abTdauRa/uML1N1ktrM1KajkJKGSQnq0ZoI=;
 b=HGZmmakeL5wsx5jR18CbxJt87cBTNNbwoh2L0l1GHPDTE21fmToyO08iRwMCXa7WJ6iHvdkdRhVsqvfzUNDBEP9YChP2Xm04A4qhnKXj9KfPi29NCKYDR1ifVhoMeNr/+gaoxHUIy5JpjknOQ0499A5joZFHU3LVKuqo2PuZH5hD3S413rPjT104sneDpfp/k1NIcIFzA9UF521lPCB5k2wBEQfGQQAxccj8bTbUnEz4U5rXGUky0j6C7unVth4KKib9usSt1qVFFxnMLk5Tc2j2+pv6eWZ1JpUK3dQifEblIiuaPEhXo3dmitsDPCgbTuL2b3BZzSSuc1ERPpARDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvjwnCt2abTdauRa/uML1N1ktrM1KajkJKGSQnq0ZoI=;
 b=f/FvGjDjB9b+YuTffnfOv/CDJxjDVkOSIbnDuYDfV2GW9s7ZD8G58nNF/NISP7C8q/VQi8gH30nGbuBwO2+JS5Bhj4XcpG/V5D/2QExTj9QveKGSVMoD8AE9SdkiUDQeBlt1ZmdvdTkntrk3l1PL+RMLaaCZb2C3/sxn8Puc9Vo=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SA0PR12MB4397.namprd12.prod.outlook.com (2603:10b6:806:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Tue, 9 Mar
 2021 08:11:49 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 08:11:49 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Mythri Pandeshwara krishna <mythri.pandeshwarakrishna@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/3] crypto: ccp - reduce tee command status polling interval from 5ms to 1ms
Date:   Tue,  9 Mar 2021 13:41:11 +0530
Message-Id: <5cc883bc9bf3ed88056f87ecae1a4e28a52adfe8.1615276206.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615276206.git.Rijo-john.Thomas@amd.com>
References: <cover.1615276206.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MA1PR0101CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::30) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from andbang6.amd.com (165.204.156.251) by MA1PR0101CA0068.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:11:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2fe53886-7949-47eb-f5d4-08d8e2d2fd2b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4397:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43974917377B2D01F7B39AB4CF929@SA0PR12MB4397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VVJCv2xYTtFxZk8mK5TGyWWTe8KdYvTpFP8U4rTtF4oWx8Sjr6/VK+wlAVXU2VyB3a/HqnEvAsE2NYA2ZKGqbZAzF79hULzGjS4ReB/0kebEvKyjUh/ZfEmbbbPUNCKSRzcogNzfmsQUTE5mlcFr3jr04o6xLzMUJxq5m2V3HPmEVEJfIErjuRd/VC0kYak5GYK69b6lOVlOTfBahun8ixbZOePs9DCDYM67TZOATr7n59jF8vrXhnHMLnD98aqkOuPtOmOY7i2GKBKOUVZZFO38UtxEUogGDk67+eA7QH5gf2d80s10VqbUYyr6Z+PpBe8NmdKW3hGJIoz9g+cjh5gQAIOqeUnLwdj//oBK33j+mexIoER+SVMPbYFA7/mTYAPVUn97VBQU54KMkpV3mhghKqHM8lYH+3LR1APKU+rsk+ItPYafcjsIB0Cc+VL2+t5Pgas+g9rsrH69SAsXCSTnZ8a6Go2HgVENczLhvDM2kyZcEw6R2yJUdLaMm1TbuXCCHwo8byXdSM4LwlFwfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(66476007)(8936002)(5660300002)(4326008)(66556008)(2616005)(956004)(316002)(54906003)(26005)(2906002)(6666004)(8676002)(110136005)(6486002)(83380400001)(66946007)(36756003)(86362001)(186003)(478600001)(16526019)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ddR1vlnRUmgkLYEfPIGSu3l6MdjRaXGJmTEBDAjPOhQk4EpqkqnmvdQLIsXv?=
 =?us-ascii?Q?BjFpD6vIZvmduW5JoBujUeh8jtXHThyGRcNAAUVo58tfWBzJTsUaKuO/7Hld?=
 =?us-ascii?Q?B+fkbM2OqPWQPJNXzkT1snQCsY4SxTuk0Wx0EhlQpq1yeuviRGvrA+fpTvhh?=
 =?us-ascii?Q?2QVIk7Xfcje8nz9Uo1Y9qlIUQvxAdKmEs7qEWXvGxojD5QSTI/VG20aYgfC8?=
 =?us-ascii?Q?oqa4k8Oyg0ZBMUN6pC8dxMOJFlYhhQnbYLShmlQjgIWofRdT+pB6yIloajCt?=
 =?us-ascii?Q?OLEmFvGulzUL9d2Y/HOfTxn7YIWxaT9VLydKPujmtKiqdlQpRDN68LmANDjp?=
 =?us-ascii?Q?uP3NKT9jaNbtbLZyqxt0djpVYutjDNB4mc7wb4UTT6LlSi5qqAMUakc3Ne9V?=
 =?us-ascii?Q?mAZ4B932frb0B31/grrkICWuIw/q1wiuai5B6nBRKN/7XcJIE5nGUK8iQKjv?=
 =?us-ascii?Q?1840Iy2zG5sgeM/E5Jmyp+/BAj93DfoOy77slIEsC0TOJnQ7XozjTsT6FIex?=
 =?us-ascii?Q?YifJViT7MW3okicVcROGfyDCyLoxo7Yp5oAaiDAU5/LB4VekmCnSHbnkA5Vn?=
 =?us-ascii?Q?R4wnB90VMJPwSpztCmBsvjx5CWPkN2c8JGr6iKuRFoBnfi6TTQ46Gml2UTz+?=
 =?us-ascii?Q?D5sOAaZ6waeGOnkbiRbztnAiqYcLX+crY7/zmISmcFcwYJsKc/7Ea99XOVoz?=
 =?us-ascii?Q?8b84dVLhqN7tv1ACme6z4qKOZHh8z9J8a40klYcYxJ77OJ2yLg9uOrKxKmYx?=
 =?us-ascii?Q?W9dGST+VVSsf70ZhcM0mNL02VUZsvGqPBiCjn6ITwaEwPwMXW/rLg9BMVxqv?=
 =?us-ascii?Q?9vySJTmLrn6K2no/v/ztTxBiwhDhCnqcpHF6YKnjJx+821Gfs+Dmx0idrOaL?=
 =?us-ascii?Q?B0U/4vN8x1medoDdiONgz79smmiEQZg3duy86kkbOJppCx7yFQHy/j0dcXaZ?=
 =?us-ascii?Q?S3r6dTzb/y6L38wohfyXS0LS29i1BXu4R59LhpSkw+FBi1zjRmFSKDR2yhiV?=
 =?us-ascii?Q?GxSLfHFkghvwd2DVJBYqalNXDbk4Ue7i4XJkEFXY/4/LUUurhdxyvdvT5bfn?=
 =?us-ascii?Q?W+u5IlZujGSRVOMZI6pHt42dpwUwbGZu8xIir9cxosw1HVkUiWxZKWlbK1LZ?=
 =?us-ascii?Q?IKCHmbK/g3YFAJe8Vfo2HfP5Vn+pqN4LwI/s2LnK1EYKurxBxRU9RnmfZgY8?=
 =?us-ascii?Q?ogDNE0r2EkZ4Aj4qIAD4Vp8b+rjD4J191D79EvwfEvh4sRQE1qsFTu87m499?=
 =?us-ascii?Q?6ChOqH0r3DWJAyH5fe8dVntBGN4kDLCyR8HX4QlwfEpWh0nq6/4xIoDL4rZd?=
 =?us-ascii?Q?KMcI8265M5CIT6l6ZodYcIEw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe53886-7949-47eb-f5d4-08d8e2d2fd2b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:11:49.5798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DgRIndQ+mHjAskdyxqPYGPBRKSue61NVCeyBq2QGkvAG02xbkSUSg00ckcjFZMRYuI2R9hnetVjhXqEWpdnscQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4397
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The PSP TEE device driver polls the command status variable every
5ms to check for command completion. Reduce this time to 1ms so that
there is an improvement in driver response time to clients which submit
TEE commands.

Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/crypto/ccp/tee-dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5e697a90ea7f..fe18a92d51ad 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -309,14 +309,14 @@ static int tee_wait_cmd_completion(struct psp_tee_device *tee,
 				   struct tee_ring_cmd *resp,
 				   unsigned int timeout)
 {
-	/* ~5ms sleep per loop => nloop = timeout * 200 */
-	int nloop = timeout * 200;
+	/* ~1ms sleep per loop => nloop = timeout * 1000 */
+	int nloop = timeout * 1000;
 
 	while (--nloop) {
 		if (resp->cmd_state == TEE_CMD_STATE_COMPLETED)
 			return 0;
 
-		usleep_range(5000, 5100);
+		usleep_range(1000, 1100);
 	}
 
 	dev_err(tee->dev, "tee: command 0x%x timed out, disabling PSP\n",
-- 
2.17.1

