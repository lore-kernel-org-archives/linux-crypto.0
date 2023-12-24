Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274CF23AA
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="fhk4pcuC"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8B60q023677;
	Sun, 24 Dec 2023 00:21:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=B67l/lV7jGP0Iommy52sa0YXaMoLBhWnEK88lamRTBA=; b=
	fhk4pcuCRQw7Wb6d4WarfBq8qJKpVLVFJHRwqX5E+T6k7JNMC5HlowXe5RhQURvZ
	4VMrX+VumphYHAONFE9s7a/p8qgWZ/kE44h1K6/cKdDicGICQzDCsusZoH6Iqp12
	r/kupuxPuIDsZHxohZZhZuEXPElw4CMngQlTFkRpZ9hUawZzC3rA7Dni2fXiAgTL
	KjvHQLOBlABKSR45alg/z8RpHS593T2zQSEvPOXajYvFaro0WCsq4/6ew0H83tkx
	a+oSnX42itLve9QNxRJmTfaaFNsvXEiGMJrCMnWzIWo3l/GAM095xFujx3oc1Qv3
	9et+l0hKVaKLprilybDi8g==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5yxm0f8w-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 00:21:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c08WKLoNfrayqNnb6RJJFAFWi1d21nMMUVJdddFoQufAPQMM0m/OKhhAqAcFX5kLWpCzNFWG/de12KRxr4QiGm2GZP1afeMcwUuCw6vjhACPlhzLnpObyd+VhUsKZssArYX1kOIanY4RyrOrwcHWsELxMjryNYs+yAELJDJf53likIfYdgYfHotFBwlh/+VZ9rZa8zaTu9omAlC/kfe4v9z2SmqBNL72aJwW8hA0lcRI9RMwfFBKUKDyB3gsPz7WsRizq+dHspLO4SoDS5Z46hvpiXJmt40xToaPNIg/BxR1yUJc56CXnYWv2DlttGR65i35qn5LeeNZb015PRR8Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B67l/lV7jGP0Iommy52sa0YXaMoLBhWnEK88lamRTBA=;
 b=J5/4M1U5vcnNiKzjLp2u8JVKwgPcr5bTyOBZvK8g8z3Dwyxwgf10Dop7sSF4obGE0XuURXQT52SKfLjbSay4+0O7YhzQUJbEsIOvUXByNxQ4DvHTZkTCFDz+f9Hrw44LXC5grPXKEbU60khn7P4y2eDsPv90gr9nZ9vAngOrP9Yw8y0lKQmLBiWUqxMMTJxUKGxsCdtPL6oPPxICwBReijUH2lGHwA3YFRN0OSmuXGBqxVrcUzNvkzLCPCMXbxA3jYIhxS6j04Fc88PtXSnC/8c81OQsg5zes5LaEd/WWlh9srl7/gh89YQTsjhqs3zFWGH+84hQBSI6EYnGNWBlFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:10 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:10 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 07/14] crypto: sahara - clean up macro indentation
Date: Sun, 24 Dec 2023 10:21:37 +0200
Message-Id: <20231224082144.3894863-8-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
References: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0094.eurprd09.prod.outlook.com
 (2603:10a6:803:78::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|MN2PR11MB4693:EE_
X-MS-Office365-Filtering-Correlation-Id: c1007c68-ee9b-4fef-f88e-08dc045948fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	F2WUzwHuRmSAsEpMxsvn90GWmKVxa4e0KIRz0ShjlfwNmtbb9DEtI22mbkZlZykQX54mGxBcKYZAEI5zt7LVgaq8nwceFUYSt0lAKpFTWR9o/l5hMyH+3tErfInHyrxw9J63Oui6KtgCEp1BRRzCwHICjWgwoGsTf9RwjuxWghjfGmEojG71eq2aVmX82ZzahyIAguSS4s18G8EcImImmu3YC/p+DQ1yEYcZ+K4ZxNfJ24ZOVlUa4bYdpO3Xo9pOJwWu+hvpFn9kj1l7j2ZbJB6DRaRqaoXNGz3P/sPD5xefwSdQ2zxuO4FdMMjqYVU/ERxJfcwqrOgk0NGIxLZ72gsI/SbqZygTKS0RoQS9MULqj8OCMW0n6nh7KK7/VOh0f6cS2vFyN8CCxmZmH8o5P/Uk7w2xZXGSLxx5yCDoZiDR+w1AqO+l3eKvk3hLAp6gCTHci4KNNkz7++UQrjvtlFc1qGJUpnDuMIPq5cGaDTZD7gZPWfgpZPDdhrxn6TUpjkLRrVk6Nxkw/+KY/UF32rSJVllam/0zYObl4RZQET/6YhvdauIIGcwHEibaRHwydZwUFtMhIKJIlk/mkz4KsADaWAMaZIA9UUiuzYnssniYsPfrAE8+Zifj08E0GHaX
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39850400004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6486002)(478600001)(2906002)(8936002)(5660300002)(36756003)(52116002)(6916009)(66946007)(66476007)(66556008)(8676002)(38350700005)(9686003)(4326008)(6506007)(6512007)(316002)(83380400001)(86362001)(1076003)(26005)(2616005)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?PDHx0ok3heaBV1r8Tg+uQlsNAn+kzo3cGx4br2kaAqGtIIv0EAW3AVXmT46I?=
 =?us-ascii?Q?U8FJqGvZCHp8JjlJIYZVg5GBPpVnOjEoU3W88zZt9169oU240sMVYLHFfkkW?=
 =?us-ascii?Q?/OavmkBWDTyCN1mNV4LhUjpnUHuVARjpkwoWBcr/Oc+ZRJZjgfITtyuU5+Xz?=
 =?us-ascii?Q?eSMGzD09Sa4s85MuSsle1xeS8SCqLsjD3touQoD6EzEZZDO9IqWt0PTp7DDi?=
 =?us-ascii?Q?EQbRsNaBOgEBNmW5FDtV7oJ/ZDd9UGqbNp+2vavKK/HP8WM7/9kWGUfBskA7?=
 =?us-ascii?Q?0z1R03zanjPjAx0BNRFvjHgXMEI38Cp74OKN+dKzlm/MFrU0g0kgjiyDspVw?=
 =?us-ascii?Q?X0UZs4hwf+lrHHsnhO/C5Xv60RZLe9qiTAKwuRaFxacV0Bi6gS9XSlMh9pHp?=
 =?us-ascii?Q?ZR9IfKh/F6YS86DTERbb1G/MSa/SxLziGxlHNO1Of9Hm+7RPpmpSRn9+rdHt?=
 =?us-ascii?Q?ZG2OT4ErDt1b5MbVIY9sQowWyelk/vdVhXJwFX96zJ0qNsK8iu3/0LPe2qm+?=
 =?us-ascii?Q?64tVg8szwhKFm8k2yRXOfuorHcub1yJ1oC0+YI8J7Lj7bi06PHg5LnVGRMGt?=
 =?us-ascii?Q?gp3XNFx6uokNHv0/hhA2zF4dAoqFgxmao2+e/hw9R04/A9aBgvYRMqRIseVT?=
 =?us-ascii?Q?SJcTUk52lKP3g04YSHnK7+Zxd9bEx4QkONRmjlj/olRkB+YdIi3i1eEvcccD?=
 =?us-ascii?Q?6Oqj4OayJehfIkJoOKD2XBeepab+GJLQviqAZVfj19Axg50fBa7xQT68o3gW?=
 =?us-ascii?Q?lu9cktPW8wntWCKv+g+yc1gcc3EzPQgdPN0Gg9SlBII3ZufMicDS7B7/Ddyb?=
 =?us-ascii?Q?P35wlOcFg0kAqF6tPU+pUrNMCfbv64du1SvE8IXmCroL4Bo7xS9E03jXlJwz?=
 =?us-ascii?Q?TnPlgXNwmSbFXRhAdwG67kqMp5Y7INoJjfHvaufsSyTKZXFAnvVm/kX9ddUC?=
 =?us-ascii?Q?rPiZZthvDWcnx+F7sZOVSQ1dwgkIp/AEq08msqd4s8jtK9gXr2+8fQqm0CBQ?=
 =?us-ascii?Q?JDpYfHYVzBs+0stATmKUW0O8sRURyujxBD03+wtopGnM+98237K6k2wDjwU3?=
 =?us-ascii?Q?lYu7MieKf0BoMXfxaJB0qJS5ck1nb7T7vxy+m1hxGK6++6rzr83PrueTYw5d?=
 =?us-ascii?Q?HepuuIifWLGyIWIsd86mUKKjIZR80nQTepE5TmSnVnltyrM9f2TGAyBEm++2?=
 =?us-ascii?Q?trvVLXwvo4wUM6s+8M4K8wkfPmhVkUQIQ/TIto/LpnsSQhahZnnpHsa90Zri?=
 =?us-ascii?Q?d0mZ/X2424l/SvVjwVnxp5rEdGpS92ZOBBMH5ddymsuBgR9JlXPcbkmwyb14?=
 =?us-ascii?Q?kVvoiWz8hi7mPNOJyy3oC9pRzmin8iMWp6fMejlXn88dL3EcLCF+iVD20EhH?=
 =?us-ascii?Q?3r4uccyJBXRjMJU3uVvEo31rfk7P/QKnaE+E2ySM9X8w4wpCZu6NiRiY2Shq?=
 =?us-ascii?Q?fMqJgQk1BmS/6jSbGoMBe+aTYacmlQ1yHEEoevMzano49dw8gbL65k1aWdlY?=
 =?us-ascii?Q?n3eXDkgDMmIZ6zRERqlAVdoza2vAbd86suoCMCN0jdZTcvGHz9AL8qEHYbSN?=
 =?us-ascii?Q?Sf5l0jbiD25nTSXIfDHEDikM92KyJ+njpLp6pxnt7kwuRsWxsKP/2Og3R1lc?=
 =?us-ascii?Q?Bw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1007c68-ee9b-4fef-f88e-08dc045948fa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:10.4043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8n4C8mA6gfpQmyXoYfd37IB6zeM+DTfcWX/RdfFKaeOvl2gCcMRFkgQEEOZlngPSVTLiJkpz2zADM3dXvPa5SUA59gr6/6dmTT9CikooFUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-Proofpoint-GUID: -YPc1Ah8nJlKkOq5pwBMefAAgO24hcvr
X-Proofpoint-ORIG-GUID: -YPc1Ah8nJlKkOq5pwBMefAAgO24hcvr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

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

