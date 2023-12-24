Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D8E23D3
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="diE3S9f+"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8B60r023677;
	Sun, 24 Dec 2023 00:21:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=Qd5FwCSRW9I4sGkPPEAWfQlItC9oCmS/YZeNwV/FZzA=; b=
	diE3S9f+SEFTrYmMQT7NbLuyJ6bLqbkraUvIYAJlM6Lmjs8DS83dPu/h+URp9uZJ
	kH+zv+fiEOEY4p/T6vx1jTgSSZy46pumoXioJLCEgSi+LvDD578aYSgyC755baGJ
	ugLodfqswzhsHomtJEBC1dmZgDiLYgiHRtenxSpY3p7Z8ARVQQBqvKIh8IQh+Hyy
	pYDYf4hqha7jfU8xTJWLlhlVZ1fxCVLmRwynQphVOxvRBKRFWeIIGkQV4houORt7
	3oXFf7hO7Q1AgT0J83QYkFOVIOz5rSEoyBWQuUAalrSa43fac5oXXebndYjnlHji
	mWjKCqMdC0y4MG02qIJG8w==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5yxm0f8w-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 00:21:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUzS1z0vTMgLxgiOMcWip332cA8fYSgfo42/BcaeplJTWOyfZ8FAYvir7/RwGTU8QBdwQ6Q47+9tURrwcdPGuoQpORSEnmlbmOdmSlEWf6K0nIU7eAVIhPisOZgKtTnxIp3Om1lWQadhTzF3dmg3NpgmWPCCqKa4PHGxT0fpfiFYkPscyW+LC4v7XKfPnms1tvP2IIZzDQWABNWzgpk/XwJ1iX/OKVxt1CkHWfN5foU1R3e6J6QRzvIi/eRhMJvRECouGnfxR4aKvp859NzCP3WdexkhvuSHH5+qqNCgp4WUM7oD+/ltTTzclRP2c9OyWyFglhW5tV1FwkQ1JGnLQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qd5FwCSRW9I4sGkPPEAWfQlItC9oCmS/YZeNwV/FZzA=;
 b=ck7/79ZXfGTTtRL1U0YV2n9GCPiKAPEIAcpnMHGnFNnIf7Yyg5G2Eb1Zd8vvda5MrxOPzFGgkrp+uUw/oD36LO6wCHjoU1oOARCIatBkFVvNyG7FUQ8A2Mg65WeVQxIrcpDMo4KSy2bjkO4I0EmndPhRcf4vy/4B+utXVx8U5XhKyujRzlmecGLUEjI5kzwzE3P/V79f9RWdWB6fU7VHN/qjP+7L+fmXUcreeGj1EpWyHd8icYTmzD0XhwZkgeq8ps1gTRVjbLd4ZnbSr2ssC+cmbrCiiFgXadjvZMvWufMZ5mEnmEHW/cIkOWtWR8ubCQIOXDrrtWRYaaydDpj6JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:11 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:11 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 08/14] crypto: sahara - use BIT() macro
Date: Sun, 24 Dec 2023 10:21:38 +0200
Message-Id: <20231224082144.3894863-9-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: c1e03894-59da-4c84-c85a-08dc045949cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	yXEt9R811N6Z+Czh4j5GC/Xz1Arvf2wCEQffvFnjU4Hu2GVSYpONZnI74DKw4KTkE+SsqwfCLNNR40UOrNljo2sMoRnEJ1PtJB55UOEJuknK7T5DgchlovBxTvM6Lll88npmZJhxhpVh/SVsqIJMTdm/cl351Pw2YltDl+bEn1VkFBIrCiKcVLIPFxET8m4KqJPpL2k70vAbuPWx5P+Mwp5FLk2IiIQwQ+dYWurk4ZFXRvK+dfLUn/g1IuJfz9029eic72asCSRn8pGLpqfQ4LFKALUxnJ3tlQ+7hECwRfDWpk+48UckGiJ9yAT/whyB5Fcj4eVd1bkZGqEDVERGh0h1nm9e2t3Njq4NbRI1gup8+8O8egExz+l/ZP4S9v0IFNxBJ4SGSqKR86P1Fy4iAy+v/Ph3WtETw7MT4wr3VqbOuK6PizelHmJ0Vva9tT7m3ZtxxBmQkkMrTWZ1P4K93kety7KFg6VeacBFlvwhFCP9c+ZC4qVWsB66641s2NZ88qBZjXLsQyWPATPNqEjwozKYkzSCpejKZmu2+/0FVmPq42X5SrF/Pr/3fex0QSrbHvqPdXCyrvDwi5CmDLHEBTcRAJsD4t8HXO9hedC5EmlnSmQjj7+IVsGwYVxK+uxS
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39850400004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6486002)(478600001)(2906002)(8936002)(5660300002)(36756003)(52116002)(6916009)(66946007)(66476007)(66556008)(8676002)(38350700005)(9686003)(4326008)(6506007)(6512007)(316002)(83380400001)(86362001)(1076003)(26005)(2616005)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?x2E12EmDIvHwS7mgiEqhKNzSIueg1UnrMKbDmrUAZgKb1q5wZ96OZ8kY2Cxx?=
 =?us-ascii?Q?v1HO0oTUCosCfc6jlKQnJuJs053HhPYeSDSpjtja3/20j9i7VGKSdPvijaz7?=
 =?us-ascii?Q?NOrPUYjQeWq3z7fNjJV5o2xVMY7iZz7FW88llDqHNR1rP39EAvK6qX+JNuOd?=
 =?us-ascii?Q?PZ0SUpUNYBehL1wYjhDreRD3yM6DpZQ4FI87H2A5FNyMdkW5T9WakwHl9VJU?=
 =?us-ascii?Q?zrTl4G2SpDvqpxjfRGKRdHwdhvrW/Uz0OFCxyAa2kUfeDCYWo16+dkvcZIQh?=
 =?us-ascii?Q?V8w3tJpyxk2ShSew1ilwzpUh5+isa4b6ncCRyK2EAZpmVwX9sVbp45pkBwPu?=
 =?us-ascii?Q?5hQsxxCa8X985+IMQanP9xE9kD8zvr0SnhnP6DGGg7wES8IZ30iZeYIH7NIX?=
 =?us-ascii?Q?dadsF/KGSuPirUcy5TmWs39cc6dififgollnfHQ6fpkCf+0dovSe++i3yhHF?=
 =?us-ascii?Q?prK8qbNjWp2qiuJw2Iq+/WrvBAMUNSizdtbDWZpkaU2GJpVfoaNq08YJSzbp?=
 =?us-ascii?Q?m0BuAz6hyQmIkKbi3AMH3He0u4zLYGPPbAdenk4x7tqHG0j+lsttjkEzdgm0?=
 =?us-ascii?Q?HwGcnJU3tjsYM6Xbc1eF3nE0af4CN0lBeWO3WxUlTf7D2Cd35m2qOU3WjSYI?=
 =?us-ascii?Q?NAagReiOItw0j+UoYQaMSlE3XhpcGH2ReHWLHzMVgmBhHqxzHOhabRo/nKSK?=
 =?us-ascii?Q?25uwS84uUsEPZFrLvKDH1b9rRigF9TYnSzsWedBevK1+SziruQ365JiXLzKC?=
 =?us-ascii?Q?Fu4y4WKgVP2sZSoQSK3kJgWYhbUymXGp3YirqkgqoENzC6J2FCVWucZfd04F?=
 =?us-ascii?Q?vGFkZMqGWCyEsZBhkWHmYB+LnJcfRz69+FlHZlKsCyfhDmRwkYqBx1Wxfn7A?=
 =?us-ascii?Q?IxaUBiqL8xgo7oETS3PX5gImUpqCQHb/qkjEhVUHHfMQp6id7lWK7J68Bg31?=
 =?us-ascii?Q?cFONtYX9tMpIO2M+XU22UHQe6Icc1xBWp489By3OXqpI7LpgCDcpRYL3viG8?=
 =?us-ascii?Q?c/OBTJWnn8NghExlsQ0I9fNiMUiBn8zPcQkcU9k3qTfM0C3c7Sdm+9S/0tXM?=
 =?us-ascii?Q?ueLct3bmg9UfYX7vU9u+GVuC9H7GryR4B/trqHZLQ61ooRxr5MlksLlqj9BL?=
 =?us-ascii?Q?bZVwhsq8ztr1ukxOFOb1YjtpQiC0/T30FkxP17dNA5Qv8/Ais4y3g5IXBptl?=
 =?us-ascii?Q?uAdk944lSqNwe/Rueq9T5mRISclE0UH4cuYH5JQHx+JY8LX21Q2TPwWjKpCS?=
 =?us-ascii?Q?vXlW1CsVNQ9YuxcLFLVclF12kTFT/z3BNiidwptmBy6ddWQaoqVifaTWRG5P?=
 =?us-ascii?Q?yuvxsw1r28gTR3JTbJwNqfhKkPNsXsNmbrRfpd/wySVXsWseEzSgu7SloT4q?=
 =?us-ascii?Q?C/hXCAs1M7sJYoIFi5xE9tS08MIYLNjxcQQjY07+ZeBvCysX2KoezX6D2FMU?=
 =?us-ascii?Q?lf0i1wFLun8y4jBRja1jqGR/tEvlQp2kG5rUngpvOYP6rSyAgt1F2iz+z0fz?=
 =?us-ascii?Q?3/TLZl5uWsJpn/OP8OLlX2vN5jfVXgM+DNURvEM6sayy83LzGC6bvCrb3tiD?=
 =?us-ascii?Q?hjII0tv6eVFPDNjPRBavZPBm2J56fTI21NywAX6AJ73KCg7lfTNX8bvw8ljc?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e03894-59da-4c84-c85a-08dc045949cc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:11.8051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWdK8SAnWn5fEHD90feq6PNbDWvgRB80QfVKyqkNYl+4sBOJrn/dcjqhpEY78eBKEMkOKdkOnOaMRXRrMr4O/i2hIJ6gJw9osD2TacJjuU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-Proofpoint-GUID: YWB--ADfV95FVeVTIYIxjN4AV6VdRAop
X-Proofpoint-ORIG-GUID: YWB--ADfV95FVeVTIYIxjN4AV6VdRAop
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=913
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Where applicable, use BIT() macro instead of shift operation to improve
readability. No functional change.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 76 ++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index b024935f9d85..ba7d3a917101 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -46,15 +46,15 @@
 
 #define SAHARA_HDR_BASE				0x00800000
 #define SAHARA_HDR_SKHA_ALG_AES			0
-#define SAHARA_HDR_SKHA_OP_ENC			(1 << 2)
-#define SAHARA_HDR_SKHA_MODE_ECB		(0 << 3)
-#define SAHARA_HDR_SKHA_MODE_CBC		(1 << 3)
+#define SAHARA_HDR_SKHA_MODE_ECB		0
+#define SAHARA_HDR_SKHA_OP_ENC			BIT(2)
+#define SAHARA_HDR_SKHA_MODE_CBC		BIT(3)
 #define SAHARA_HDR_FORM_DATA			(5 << 16)
-#define SAHARA_HDR_FORM_KEY			(8 << 16)
-#define SAHARA_HDR_LLO				(1 << 24)
-#define SAHARA_HDR_CHA_SKHA			(1 << 28)
-#define SAHARA_HDR_CHA_MDHA			(2 << 28)
-#define SAHARA_HDR_PARITY_BIT			(1 << 31)
+#define SAHARA_HDR_FORM_KEY			BIT(19)
+#define SAHARA_HDR_LLO				BIT(24)
+#define SAHARA_HDR_CHA_SKHA			BIT(28)
+#define SAHARA_HDR_CHA_MDHA			BIT(29)
+#define SAHARA_HDR_PARITY_BIT			BIT(31)
 
 #define SAHARA_HDR_MDHA_SET_MODE_MD_KEY		0x20880000
 #define SAHARA_HDR_MDHA_SET_MODE_HASH		0x208D0000
@@ -64,14 +64,14 @@
 #define SAHARA_HDR_MDHA_ALG_MD5			1
 #define SAHARA_HDR_MDHA_ALG_SHA256		2
 #define SAHARA_HDR_MDHA_ALG_SHA224		3
-#define SAHARA_HDR_MDHA_PDATA			(1 << 2)
-#define SAHARA_HDR_MDHA_HMAC			(1 << 3)
-#define SAHARA_HDR_MDHA_INIT			(1 << 5)
-#define SAHARA_HDR_MDHA_IPAD			(1 << 6)
-#define SAHARA_HDR_MDHA_OPAD			(1 << 7)
-#define SAHARA_HDR_MDHA_SWAP			(1 << 8)
-#define SAHARA_HDR_MDHA_MAC_FULL		(1 << 9)
-#define SAHARA_HDR_MDHA_SSL			(1 << 10)
+#define SAHARA_HDR_MDHA_PDATA			BIT(2)
+#define SAHARA_HDR_MDHA_HMAC			BIT(3)
+#define SAHARA_HDR_MDHA_INIT			BIT(5)
+#define SAHARA_HDR_MDHA_IPAD			BIT(6)
+#define SAHARA_HDR_MDHA_OPAD			BIT(7)
+#define SAHARA_HDR_MDHA_SWAP			BIT(8)
+#define SAHARA_HDR_MDHA_MAC_FULL		BIT(9)
+#define SAHARA_HDR_MDHA_SSL			BIT(10)
 
 /* SAHARA can only process one request at a time */
 #define SAHARA_QUEUE_LENGTH			1
@@ -81,15 +81,15 @@
 #define SAHARA_REG_CONTROL			0x08
 #define SAHARA_CONTROL_SET_THROTTLE(x)		(((x) & 0xff) << 24)
 #define SAHARA_CONTROL_SET_MAXBURST(x)		(((x) & 0xff) << 16)
-#define SAHARA_CONTROL_RNG_AUTORSD		(1 << 7)
-#define SAHARA_CONTROL_ENABLE_INT		(1 << 4)
+#define SAHARA_CONTROL_RNG_AUTORSD		BIT(7)
+#define SAHARA_CONTROL_ENABLE_INT		BIT(4)
 #define SAHARA_REG_CMD				0x0C
-#define SAHARA_CMD_RESET			(1 << 0)
-#define SAHARA_CMD_CLEAR_INT			(1 << 8)
-#define SAHARA_CMD_CLEAR_ERR			(1 << 9)
-#define SAHARA_CMD_SINGLE_STEP			(1 << 10)
-#define SAHARA_CMD_MODE_BATCH			(1 << 16)
-#define SAHARA_CMD_MODE_DEBUG			(1 << 18)
+#define SAHARA_CMD_RESET			BIT(0)
+#define SAHARA_CMD_CLEAR_INT			BIT(8)
+#define SAHARA_CMD_CLEAR_ERR			BIT(9)
+#define SAHARA_CMD_SINGLE_STEP			BIT(10)
+#define SAHARA_CMD_MODE_BATCH			BIT(16)
+#define SAHARA_CMD_MODE_DEBUG			BIT(18)
 #define SAHARA_REG_STATUS			0x10
 #define SAHARA_STATUS_GET_STATE(x)		((x) & 0x7)
 #define SAHARA_STATE_IDLE			0
@@ -97,25 +97,25 @@
 #define SAHARA_STATE_ERR			2
 #define SAHARA_STATE_FAULT			3
 #define SAHARA_STATE_COMPLETE			4
-#define SAHARA_STATE_COMP_FLAG			(1 << 2)
-#define SAHARA_STATUS_DAR_FULL			(1 << 3)
-#define SAHARA_STATUS_ERROR			(1 << 4)
-#define SAHARA_STATUS_SECURE			(1 << 5)
-#define SAHARA_STATUS_FAIL			(1 << 6)
-#define SAHARA_STATUS_INIT			(1 << 7)
-#define SAHARA_STATUS_RNG_RESEED		(1 << 8)
-#define SAHARA_STATUS_ACTIVE_RNG		(1 << 9)
-#define SAHARA_STATUS_ACTIVE_MDHA		(1 << 10)
-#define SAHARA_STATUS_ACTIVE_SKHA		(1 << 11)
-#define SAHARA_STATUS_MODE_BATCH		(1 << 16)
-#define SAHARA_STATUS_MODE_DEDICATED		(1 << 17)
-#define SAHARA_STATUS_MODE_DEBUG		(1 << 18)
+#define SAHARA_STATE_COMP_FLAG			BIT(2)
+#define SAHARA_STATUS_DAR_FULL			BIT(3)
+#define SAHARA_STATUS_ERROR			BIT(4)
+#define SAHARA_STATUS_SECURE			BIT(5)
+#define SAHARA_STATUS_FAIL			BIT(6)
+#define SAHARA_STATUS_INIT			BIT(7)
+#define SAHARA_STATUS_RNG_RESEED		BIT(8)
+#define SAHARA_STATUS_ACTIVE_RNG		BIT(9)
+#define SAHARA_STATUS_ACTIVE_MDHA		BIT(10)
+#define SAHARA_STATUS_ACTIVE_SKHA		BIT(11)
+#define SAHARA_STATUS_MODE_BATCH		BIT(16)
+#define SAHARA_STATUS_MODE_DEDICATED		BIT(17)
+#define SAHARA_STATUS_MODE_DEBUG		BIT(18)
 #define SAHARA_STATUS_GET_ISTATE(x)		(((x) >> 24) & 0xff)
 #define SAHARA_REG_ERRSTATUS			0x14
 #define SAHARA_ERRSTATUS_GET_SOURCE(x)		((x) & 0xf)
 #define SAHARA_ERRSOURCE_CHA			14
 #define SAHARA_ERRSOURCE_DMA			15
-#define SAHARA_ERRSTATUS_DMA_DIR		(1 << 8)
+#define SAHARA_ERRSTATUS_DMA_DIR		BIT(8)
 #define SAHARA_ERRSTATUS_GET_DMASZ(x)		(((x) >> 9) & 0x3)
 #define SAHARA_ERRSTATUS_GET_DMASRC(x)		(((x) >> 13) & 0x7)
 #define SAHARA_ERRSTATUS_GET_CHASRC(x)		(((x) >> 16) & 0xfff)
-- 
2.34.1

