Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B39B12E79
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="C1E8I9nv"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNI0MfL004538;
	Sat, 23 Dec 2023 10:10:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=B67l/lV7jGP0Iommy52sa0YXaMoLBhWnEK88lamRTBA=; b=
	C1E8I9nv9dLFLTfk8lSUE+Kpjw3QQQ+LUE/uXsLx6mfj9yABsURxHblYNjWfL05N
	eoyVGprp5WBe1Jr8aWJgQHHhNAzTvLL07xxd4C93RD5n4PEVSaVwYUGKDYn47PTM
	O5V9jU5vGTVk4Cpcf694gh/6TY5Z+NbiEFCzZkyp7W2QMJad9isdtRZXbMiqWCVW
	8UN7hjHusuvK4zQP+IU/jkZUfs2ViIp1SCZnB0W1NwAbFpR98nfuw5xQhRMfJTeE
	bMB1Ix0K0PhZmh1vOytrVeJPUH3LtW++sitvD2G+7q2VFJFoYoVdkbSseN6voKUN
	jdNV9tmStWTeIwQRLvMkww==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5yxm04ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 10:10:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9gzcTVIkh/RLThPIqpxEIf5ObsJ5Ru7B24xilGtnzvZUiYnCVpczvBJZ6DUG4eM8Mrpsdm+7SIq9Y9f+PaNyNx7WJX07dV+ZztHXzokiritbeyOhT39o3Zv3Nnr9S0ovU4xB8y5Yh5/pZMC+/TGTgatWHTgTW7KXeAWeM2ounhtQnKkhbKMD2C+vCIDurXFXqhhgEkuzavMGS67P1nrCYUsqM0xKaDyK9FYfBOzjem3ZWd1f05AxYgX6Q5eY5CVqDtz4Pgtd2qrWcn0bsF7ei09dK83EYHxLSTNuImeOgWnpYpQ/4HwGHgg9P9xk+ZJNZO7/X/JgH1a8/vlStO4vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B67l/lV7jGP0Iommy52sa0YXaMoLBhWnEK88lamRTBA=;
 b=gAsNHzc1unP5K9H2jUPEKubm+dgcDez1uZgkm9RH8ARyJuUSa/9ZYUbOQ0D6S0ZFwITha2ZPRsn+vh1Zqja8v6D0Od1m6tmslYTZr0PJ0VhdeWInuwcs7CqkgIJEXJr/JXDloH4rahTfLxLiI0ccCbXyJZQbiHuziZUbMs0/LVnUUU8WPLH5N4eoeXcRxm5/k0diToE2oOdXkLBFA/06fG9kuDV7mNJVDsIZivlHA1c3XZRKaIq2D1N5cxs2dZbw6CTTzRXRQzbq54WYKwoB24jNqkvi7BaGpMIzGD/vASLj9iBlAUvCAnt0T1HY8VvTglxKW7lPHtvAUf+WRqswGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:44 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:44 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 07/14] crypto: sahara - clean up macro indentation
Date: Sat, 23 Dec 2023 20:11:01 +0200
Message-Id: <20231223181108.3819741-7-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
References: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0053.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SA0PR11MB4589:EE_
X-MS-Office365-Filtering-Correlation-Id: f79f8d7b-d233-48c2-d19f-08dc03e27af4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8XmNxn8HRlH9tfzpNOZrCMwzyUwhj7K/GimMYXTtQ8xsh8l5pCEAieEtQ65vt5zHekM5Rd0fZPiN7aN0l6CGhqkMrkjmpz8HiwSKwyJMJiAGmCDLB2lqYinDoyBv/w8FXbncYbQkUSYfoGTdC46L8FD3tn4EPdu//Fp6d9QdKirEHqAZT74pRnWI8na8TiLnadU91TwLpHANL+ewtzmD7s1T825cROSowoXvtkp42sR3OGS5hJsImbZlVelMqL/lmlaqS5OFyxtmcOJ0XrJcQTc/0SaGN81YaroHnt6Iq5IxMICSL3tbIRPW5U/jZTdIZccRGQxEnr/cdoFPh5B8VAGrzXWvjdkcDaYjX2JlCYCxZsE52pyVZmUGEphayk54+r3gXX3C9Ait9mQuIA8dbOWz+EY7KR3fJYdyNEV/GKt5FF9hDX80lxsy0V4QalpZm2mqvqYALC4pvza00vc2SmKCLFaZbGsQ1c7RNaix4V65YVrsbCmAzJYSns7DY6Qlw6930ZdvbK+WPLnusFcGgZfU4e6rsMLtCzUrN0aow/H+aQffwlkDkXREfYlkhHGCGu3fkvI6Ak4vyvUsMrKw3qx9cG9m8erRdK0Zx8HEg5kPnqxLO3HFAbETLp45qE/i
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?kpGcQmVgPzol2pca0AL55Aa023bj7kfvn6DmvjaS6q2rVpvct2Ycn6SLrJxA?=
 =?us-ascii?Q?hIk0Emd8GNq1/fzOBbgXXi0TapY0ssGvBaTIthWbN7Lyk/yYyUZHkqGcT36d?=
 =?us-ascii?Q?XGi/G+yuvsrr6MEuUg2CUqAP2x8DoYl+MOSfX3Ty71EdrOovWTw84Fenfrkl?=
 =?us-ascii?Q?aKsItqZ9xtBw260wUSwc7Tw7XVRMolxZcuaK+88NsoaYT+TXhGK29H2Da85s?=
 =?us-ascii?Q?9kAtUj44KfHNFDGDxF8xSLeHRp6Dt9bBxXn/osR/g0JnYUgFVm3/6o9OkXev?=
 =?us-ascii?Q?zKJ4rRPkPsv2XVCc1biGzLZJAg5L30VFVeu1tYF6FlhaOAUbvD5ceBIx8p3z?=
 =?us-ascii?Q?Mj414Em7U0wsthxYuYjAtrv+zJm7qWc9wh0Y1YFt1gJo0OX5xUSSSJG5DrwL?=
 =?us-ascii?Q?MWFKcfkzpzwBZnqCWKUucPlTOM6IojAecLeItBoDZhuq/eU6nUT3Fd1Boxq2?=
 =?us-ascii?Q?O9v5aJORoDbZQwTFYmjLgZ/7IkE03gO19U+GoeNz53WUA4xNehLrfNbTqR/f?=
 =?us-ascii?Q?nkSmoMTLiIhT+CzpEp7zqOK4Ho7eVA6YFDHjPj/qtKdc2JJWhlqOovxIhn3x?=
 =?us-ascii?Q?gxDQifZT2GNG8gilIDNWIfdn4InRlSX23lSj0JY28xHCrdQLjEYB/3XFXCzV?=
 =?us-ascii?Q?0kuZs9YuFrY+H9A6YTzPpe+75ikv9O5N0dOaBPriwi/84vOTlqO9EM1Zg/4R?=
 =?us-ascii?Q?1XO6CQp0VYmmAEKtNbFSr1XbBRC0KL+faym5tntdmRjsfihrHZEYG+JjBDuQ?=
 =?us-ascii?Q?8r3vnsMM1LwdUv9lKZztSCUWz7XNyrvOyA3wHscgqhSb5FGxBm2sOhqTg8hq?=
 =?us-ascii?Q?xpOXR1ffYKnAOozxlFNNe478VlEkDvFMyAVCGpPgRyxzRvsIgMOv5OaKTQl0?=
 =?us-ascii?Q?mmsjtj5Qpm/3/Nsi8IMTojeoJEKgjTHy5Ow90KiiQU4S1TaxQlPKeeO6KDKV?=
 =?us-ascii?Q?5rE6fEmiUVN7Q38Puxlxrlkcn/iltLu7Vr1eLVIbjaCWVdPONLf2QXb35OOI?=
 =?us-ascii?Q?7ozQRCZ0xRf0id5Ua809Jhk3FrJ7EFIlCSxiSTqZesbIY1KMismksBqUFN2J?=
 =?us-ascii?Q?dC7Au7QWtYpFqi46G253nzqngi1jKzIb+FDn1D2gtH31V++TbgGDODMhyfsb?=
 =?us-ascii?Q?Qd1x5hSCElA29QjCgoUTmOyFFHsOHfX9C5N1S/spkPW70DAKEq8QeaG0vwSv?=
 =?us-ascii?Q?hrodGiqzhYvPMEIK5aMQOTbP/dJ+yX/SjZEpG5oeIuavEd6HxYgvfasTE7RU?=
 =?us-ascii?Q?d+ELlbv4Vl/4eQzFz5fqjrZTx2WdP1ZBbcreZOJj6qjxJfXpq8j7pRY9Fti+?=
 =?us-ascii?Q?w1aplXpJ6b1BqQBvhJjiqZp1Bk43ELxpZ/vmBIhzlmk0zEl0Ua1advnKLy/w?=
 =?us-ascii?Q?iz9fb678gsd9mVLg12hS97ygZfbeAAJFBs024LiAt4csMRhIymloWNq9FRib?=
 =?us-ascii?Q?ZjrzpWEZnA5uIB989Q6Z5aoWARrAMSjIGTOX1vFxqtejBLkfOZ1Hec93suQx?=
 =?us-ascii?Q?c0d6vCKv9+axjT95NbkcQe8RXQt2YzgY84xw5NbX49m2eCdrTo3vPCuqIiOt?=
 =?us-ascii?Q?3Jd9vduAuGej3FN1msM6UkwZ4APTOcnpG09VZICtLnhRDyHeBbuSnmNOpRTJ?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79f8d7b-d233-48c2-d19f-08dc03e27af4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:44.1379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: exu1wU8mqvQwNwhKVUiv1Q8EFYs6E1l6rVvwGJrYZvZHeW/z31uvalSm+RaQUQO20k8iV0bzNLA4wxP3E1uHBnG9zqHxmPWBcSzynSjygoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-GUID: VOvrEfJFQCotzGn7D_7igLEdgMed14yK
X-Proofpoint-ORIG-GUID: VOvrEfJFQCotzGn7D_7igLEdgMed14yK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Use the same indentation style for all macros.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 182 ++++++++++++++++++++--------------------
 1 file changed, 91 insertions(+), 91 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index f045591e8889..b024935f9d85 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -30,99 +30,99 @@
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
 
-#define SHA_BUFFER_LEN		PAGE_SIZE
-#define SAHARA_MAX_SHA_BLOCK_SIZE	SHA256_BLOCK_SIZE
-
-#define SAHARA_NAME "sahara"
-#define SAHARA_VERSION_3	3
-#define SAHARA_VERSION_4	4
-#define SAHARA_TIMEOUT_MS	1000
-#define SAHARA_MAX_HW_DESC	2
-#define SAHARA_MAX_HW_LINK	20
-
-#define FLAGS_MODE_MASK		0x000f
-#define FLAGS_ENCRYPT		BIT(0)
-#define FLAGS_CBC		BIT(1)
-
-#define SAHARA_HDR_BASE			0x00800000
-#define SAHARA_HDR_SKHA_ALG_AES	0
-#define SAHARA_HDR_SKHA_OP_ENC		(1 << 2)
-#define SAHARA_HDR_SKHA_MODE_ECB	(0 << 3)
-#define SAHARA_HDR_SKHA_MODE_CBC	(1 << 3)
-#define SAHARA_HDR_FORM_DATA		(5 << 16)
-#define SAHARA_HDR_FORM_KEY		(8 << 16)
-#define SAHARA_HDR_LLO			(1 << 24)
-#define SAHARA_HDR_CHA_SKHA		(1 << 28)
-#define SAHARA_HDR_CHA_MDHA		(2 << 28)
-#define SAHARA_HDR_PARITY_BIT		(1 << 31)
-
-#define SAHARA_HDR_MDHA_SET_MODE_MD_KEY	0x20880000
-#define SAHARA_HDR_MDHA_SET_MODE_HASH	0x208D0000
-#define SAHARA_HDR_MDHA_HASH		0xA0850000
-#define SAHARA_HDR_MDHA_STORE_DIGEST	0x20820000
-#define SAHARA_HDR_MDHA_ALG_SHA1	0
-#define SAHARA_HDR_MDHA_ALG_MD5		1
-#define SAHARA_HDR_MDHA_ALG_SHA256	2
-#define SAHARA_HDR_MDHA_ALG_SHA224	3
-#define SAHARA_HDR_MDHA_PDATA		(1 << 2)
-#define SAHARA_HDR_MDHA_HMAC		(1 << 3)
-#define SAHARA_HDR_MDHA_INIT		(1 << 5)
-#define SAHARA_HDR_MDHA_IPAD		(1 << 6)
-#define SAHARA_HDR_MDHA_OPAD		(1 << 7)
-#define SAHARA_HDR_MDHA_SWAP		(1 << 8)
-#define SAHARA_HDR_MDHA_MAC_FULL	(1 << 9)
-#define SAHARA_HDR_MDHA_SSL		(1 << 10)
+#define SHA_BUFFER_LEN				PAGE_SIZE
+#define SAHARA_MAX_SHA_BLOCK_SIZE		SHA256_BLOCK_SIZE
+
+#define SAHARA_NAME				"sahara"
+#define SAHARA_VERSION_3			3
+#define SAHARA_VERSION_4			4
+#define SAHARA_TIMEOUT_MS			1000
+#define SAHARA_MAX_HW_DESC			2
+#define SAHARA_MAX_HW_LINK			20
+
+#define FLAGS_MODE_MASK				0x000f
+#define FLAGS_ENCRYPT				BIT(0)
+#define FLAGS_CBC				BIT(1)
+
+#define SAHARA_HDR_BASE				0x00800000
+#define SAHARA_HDR_SKHA_ALG_AES			0
+#define SAHARA_HDR_SKHA_OP_ENC			(1 << 2)
+#define SAHARA_HDR_SKHA_MODE_ECB		(0 << 3)
+#define SAHARA_HDR_SKHA_MODE_CBC		(1 << 3)
+#define SAHARA_HDR_FORM_DATA			(5 << 16)
+#define SAHARA_HDR_FORM_KEY			(8 << 16)
+#define SAHARA_HDR_LLO				(1 << 24)
+#define SAHARA_HDR_CHA_SKHA			(1 << 28)
+#define SAHARA_HDR_CHA_MDHA			(2 << 28)
+#define SAHARA_HDR_PARITY_BIT			(1 << 31)
+
+#define SAHARA_HDR_MDHA_SET_MODE_MD_KEY		0x20880000
+#define SAHARA_HDR_MDHA_SET_MODE_HASH		0x208D0000
+#define SAHARA_HDR_MDHA_HASH			0xA0850000
+#define SAHARA_HDR_MDHA_STORE_DIGEST		0x20820000
+#define SAHARA_HDR_MDHA_ALG_SHA1		0
+#define SAHARA_HDR_MDHA_ALG_MD5			1
+#define SAHARA_HDR_MDHA_ALG_SHA256		2
+#define SAHARA_HDR_MDHA_ALG_SHA224		3
+#define SAHARA_HDR_MDHA_PDATA			(1 << 2)
+#define SAHARA_HDR_MDHA_HMAC			(1 << 3)
+#define SAHARA_HDR_MDHA_INIT			(1 << 5)
+#define SAHARA_HDR_MDHA_IPAD			(1 << 6)
+#define SAHARA_HDR_MDHA_OPAD			(1 << 7)
+#define SAHARA_HDR_MDHA_SWAP			(1 << 8)
+#define SAHARA_HDR_MDHA_MAC_FULL		(1 << 9)
+#define SAHARA_HDR_MDHA_SSL			(1 << 10)
 
 /* SAHARA can only process one request at a time */
-#define SAHARA_QUEUE_LENGTH	1
-
-#define SAHARA_REG_VERSION	0x00
-#define SAHARA_REG_DAR		0x04
-#define SAHARA_REG_CONTROL	0x08
-#define		SAHARA_CONTROL_SET_THROTTLE(x)	(((x) & 0xff) << 24)
-#define		SAHARA_CONTROL_SET_MAXBURST(x)	(((x) & 0xff) << 16)
-#define		SAHARA_CONTROL_RNG_AUTORSD	(1 << 7)
-#define		SAHARA_CONTROL_ENABLE_INT	(1 << 4)
-#define SAHARA_REG_CMD		0x0C
-#define		SAHARA_CMD_RESET		(1 << 0)
-#define		SAHARA_CMD_CLEAR_INT		(1 << 8)
-#define		SAHARA_CMD_CLEAR_ERR		(1 << 9)
-#define		SAHARA_CMD_SINGLE_STEP		(1 << 10)
-#define		SAHARA_CMD_MODE_BATCH		(1 << 16)
-#define		SAHARA_CMD_MODE_DEBUG		(1 << 18)
-#define	SAHARA_REG_STATUS	0x10
-#define		SAHARA_STATUS_GET_STATE(x)	((x) & 0x7)
-#define			SAHARA_STATE_IDLE	0
-#define			SAHARA_STATE_BUSY	1
-#define			SAHARA_STATE_ERR	2
-#define			SAHARA_STATE_FAULT	3
-#define			SAHARA_STATE_COMPLETE	4
-#define			SAHARA_STATE_COMP_FLAG	(1 << 2)
-#define		SAHARA_STATUS_DAR_FULL		(1 << 3)
-#define		SAHARA_STATUS_ERROR		(1 << 4)
-#define		SAHARA_STATUS_SECURE		(1 << 5)
-#define		SAHARA_STATUS_FAIL		(1 << 6)
-#define		SAHARA_STATUS_INIT		(1 << 7)
-#define		SAHARA_STATUS_RNG_RESEED	(1 << 8)
-#define		SAHARA_STATUS_ACTIVE_RNG	(1 << 9)
-#define		SAHARA_STATUS_ACTIVE_MDHA	(1 << 10)
-#define		SAHARA_STATUS_ACTIVE_SKHA	(1 << 11)
-#define		SAHARA_STATUS_MODE_BATCH	(1 << 16)
-#define		SAHARA_STATUS_MODE_DEDICATED	(1 << 17)
-#define		SAHARA_STATUS_MODE_DEBUG	(1 << 18)
-#define		SAHARA_STATUS_GET_ISTATE(x)	(((x) >> 24) & 0xff)
-#define SAHARA_REG_ERRSTATUS	0x14
-#define		SAHARA_ERRSTATUS_GET_SOURCE(x)	((x) & 0xf)
-#define			SAHARA_ERRSOURCE_CHA	14
-#define			SAHARA_ERRSOURCE_DMA	15
-#define		SAHARA_ERRSTATUS_DMA_DIR	(1 << 8)
-#define		SAHARA_ERRSTATUS_GET_DMASZ(x)(((x) >> 9) & 0x3)
-#define		SAHARA_ERRSTATUS_GET_DMASRC(x) (((x) >> 13) & 0x7)
-#define		SAHARA_ERRSTATUS_GET_CHASRC(x)	(((x) >> 16) & 0xfff)
-#define		SAHARA_ERRSTATUS_GET_CHAERR(x)	(((x) >> 28) & 0x3)
-#define SAHARA_REG_FADDR	0x18
-#define SAHARA_REG_CDAR		0x1C
-#define SAHARA_REG_IDAR		0x20
+#define SAHARA_QUEUE_LENGTH			1
+
+#define SAHARA_REG_VERSION			0x00
+#define SAHARA_REG_DAR				0x04
+#define SAHARA_REG_CONTROL			0x08
+#define SAHARA_CONTROL_SET_THROTTLE(x)		(((x) & 0xff) << 24)
+#define SAHARA_CONTROL_SET_MAXBURST(x)		(((x) & 0xff) << 16)
+#define SAHARA_CONTROL_RNG_AUTORSD		(1 << 7)
+#define SAHARA_CONTROL_ENABLE_INT		(1 << 4)
+#define SAHARA_REG_CMD				0x0C
+#define SAHARA_CMD_RESET			(1 << 0)
+#define SAHARA_CMD_CLEAR_INT			(1 << 8)
+#define SAHARA_CMD_CLEAR_ERR			(1 << 9)
+#define SAHARA_CMD_SINGLE_STEP			(1 << 10)
+#define SAHARA_CMD_MODE_BATCH			(1 << 16)
+#define SAHARA_CMD_MODE_DEBUG			(1 << 18)
+#define SAHARA_REG_STATUS			0x10
+#define SAHARA_STATUS_GET_STATE(x)		((x) & 0x7)
+#define SAHARA_STATE_IDLE			0
+#define SAHARA_STATE_BUSY			1
+#define SAHARA_STATE_ERR			2
+#define SAHARA_STATE_FAULT			3
+#define SAHARA_STATE_COMPLETE			4
+#define SAHARA_STATE_COMP_FLAG			(1 << 2)
+#define SAHARA_STATUS_DAR_FULL			(1 << 3)
+#define SAHARA_STATUS_ERROR			(1 << 4)
+#define SAHARA_STATUS_SECURE			(1 << 5)
+#define SAHARA_STATUS_FAIL			(1 << 6)
+#define SAHARA_STATUS_INIT			(1 << 7)
+#define SAHARA_STATUS_RNG_RESEED		(1 << 8)
+#define SAHARA_STATUS_ACTIVE_RNG		(1 << 9)
+#define SAHARA_STATUS_ACTIVE_MDHA		(1 << 10)
+#define SAHARA_STATUS_ACTIVE_SKHA		(1 << 11)
+#define SAHARA_STATUS_MODE_BATCH		(1 << 16)
+#define SAHARA_STATUS_MODE_DEDICATED		(1 << 17)
+#define SAHARA_STATUS_MODE_DEBUG		(1 << 18)
+#define SAHARA_STATUS_GET_ISTATE(x)		(((x) >> 24) & 0xff)
+#define SAHARA_REG_ERRSTATUS			0x14
+#define SAHARA_ERRSTATUS_GET_SOURCE(x)		((x) & 0xf)
+#define SAHARA_ERRSOURCE_CHA			14
+#define SAHARA_ERRSOURCE_DMA			15
+#define SAHARA_ERRSTATUS_DMA_DIR		(1 << 8)
+#define SAHARA_ERRSTATUS_GET_DMASZ(x)		(((x) >> 9) & 0x3)
+#define SAHARA_ERRSTATUS_GET_DMASRC(x)		(((x) >> 13) & 0x7)
+#define SAHARA_ERRSTATUS_GET_CHASRC(x)		(((x) >> 16) & 0xfff)
+#define SAHARA_ERRSTATUS_GET_CHAERR(x)		(((x) >> 28) & 0x3)
+#define SAHARA_REG_FADDR			0x18
+#define SAHARA_REG_CDAR				0x1C
+#define SAHARA_REG_IDAR				0x20
 
 struct sahara_hw_desc {
 	u32	hdr;
-- 
2.34.1

