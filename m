Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC1B14A9C
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="VzVjLeYw"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNI0MfM004538;
	Sat, 23 Dec 2023 10:10:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=Qd5FwCSRW9I4sGkPPEAWfQlItC9oCmS/YZeNwV/FZzA=; b=
	VzVjLeYw1FGnm6zqEy14bLS+qb9oCZBCMuVWfO+AuNiaiX7VMdxaTFBP+P1qeSBg
	9uJC92NfHB7tJiIiwz3MIXrLgpnZd8rMj3/czcJiHy2GJFLNdcX92BnSsHTDXoL9
	UX2QJCgHiJJxOLYp9XtQW8ffXT7FavlG+8ypENqqwsX+4x6si5EcK/S9drnHAAYF
	7ZU2X8SZitx9fq/FV5jmBZxFgaqZDyFMsi4+Id1xUE9kUx+NZnxEmHaD/QUibCb+
	h9qwq7ONnWlMU0zzBtBUwqEyF4mLIyGUDu1fBW7BpdMZTQlLJ+DIRpFxaT/memFq
	vAA9crV4ZLMOXte/hzvhSQ==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5yxm04ce-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 10:10:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhBaufQC51shyr25YaPVh3ZxxdkLSleYbvHjaGu6E7ChJnGhJ108ecy9xVxmYq+wIsd2bPjOClSrYcB/4OkQ9P+uvUaJn1mM4CqKh4FaFGsj1o/nnP8iiOD+fPFBD8I+Gbp/w1IWHOU9riCNczujDY/7K/PfjMJc4RS56qp7gOccV9gnT6A+I4QD2WeGI5HZLWvQPeIM5S8Eg9jg+xEdGGTKBb4sev2eidWZPEKej2ydwwTnZayoVyBDNmWSurUkWctzZ+vCqH+/+L8/EDG3+pIrmoaPj9pq5kHGqQhRgfvYD6sWrqH7H8D8KCZjCLq8nUtuFwlnnHbF4pZshhmUQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qd5FwCSRW9I4sGkPPEAWfQlItC9oCmS/YZeNwV/FZzA=;
 b=bYLd6NvYE4yICUJBqFyl6jctGdA45mF8V/ohmkK2/1g2EN2J43B/mkfC+CknTcUNqW3wVUv8GzKVaDsFExENFVYxsaJ9fPM7EIiPsZqFDQ5UZTZ47M/kCtxS9MTC9rW3XkPPdda0Y0C3bfj6v9A++aEzXk4rEFrBzjqeSs4V6GsjA+z4qseNi35c0X2TQWrJ+4sk9rDtENsoUoCNMYU+ZLtxyywA2yj36gH7LTCGa+YpPTE29W/KEJ1asBE+36VjQRZcdb1JtFtPIfCcrV9ktu6y1pgA1IFst78CqhSi8Eyg0CuDTa4cBF1S//NbOjBn71bdOHJ5cZZUfYHLMI6gMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:45 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:45 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 08/14] crypto: sahara - use BIT() macro
Date: Sat, 23 Dec 2023 20:11:02 +0200
Message-Id: <20231223181108.3819741-8-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: feb0f089-f67b-4d30-034e-08dc03e27bc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0VGE2nqOELQMkjlH5tvjkxbQ0gs1jmk1hfWGet9TUPcy0tNqktRtkI6a94+MvOnGY+xNCaXvZnvkmBgFKidubmKOcmNCgyqFOTBJX/IdIo6Wme1Q+SwhyzfBZSrY6vvkgSyJA4P4ou7/7r1q8vIvHYBtge3AyBJ2DZbA07dxSQnE8IIgVXTOUJJ99EGWfTgL6bnMJG0G09zTqAtukaDU8htAFbkUnkV/MykRZK6kaGDjx3NUq2fZNrTZrqisVwdjJysJsmWqCL7EX9m9Dac5S7anULtF6KMewpZnFRvZ0a8I3As0ywHatM82+08ZtRQg4gM0imh1nAqQhVQIVjYxClyKy6VY/oFhEb53ymKorFgy1aKucMf90h0a1r7hRCYZEjUelfzNOsynWLcOwETg4fTr2dhKEhItspE2V/TxXoMWq4qGvMWxSWzYDsO63Vyigw//dr4iluwwUXmNISAHFEMl6yb5g2Ph3aWzcj7Xas7FdD3s6bpWh3TuIVe/0THqUINDR8h9LzeDvenkcUQ1DIzW1oyUo0ta8Tw/OEflpyV9/iVZwZ1XWtNaimTKiwuZJsohIxmA7XF173peIkVqQVMn5mv95p4u1PVEMV1LoHKtP8xFCBbqukm0DVl/DHXV
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?iIGGi4bjpedjy/ulQ0RUN0nrFHC/vUIvrhcG0QQhgGP98XEh4zbMbAAUb+gM?=
 =?us-ascii?Q?614xJB3OLYDCAQajemGMgPYNsVipLSBPFN3rmakCGC1JLIVWKRfMY3uC9LR6?=
 =?us-ascii?Q?yYbw6NxbGmD7fXlHHiLaCUdItgCs8ruiT3iKaGHg2TMtvLd7Elyo/vn9UZJr?=
 =?us-ascii?Q?poADyWw/lkyZFhiEaanhhR+DtLH7VyPJM4GwFEJkSTBfNwXcykoqsCRteJ/R?=
 =?us-ascii?Q?TB9u10dEUwmo8mJtPOvuBzwC4TxDz8+vrwsvs9HxLTdyJrHfAc5lwZUdXmSp?=
 =?us-ascii?Q?/LPgjNCXIaYT2pGPDNwhdJ/ZYSyUEGIjrD2JQHpkUCnr+mKjyMTjlXXtYqr8?=
 =?us-ascii?Q?15w2hKF1MO31aGsNZbHCw6zClLlHMdIarN4J1+OykWkgQCOJjj41Bkcq8iWr?=
 =?us-ascii?Q?2GeLRNL6vkjU8E54Hx9QEBUjz89lV0NC30fE3cEiqjL5fP9qH7L28x8XZxQ8?=
 =?us-ascii?Q?ePPILj0NgXCRuSgcr74wbmUm6tcGb6/iZq9urKnAVgRjq+p07wiOcyRVm5kE?=
 =?us-ascii?Q?3SKxopLIMkIqi7IirUll2go+N5Lr1+3DQ/uAXMXoasOMEW2uQqG/IlXLJXzR?=
 =?us-ascii?Q?0oERt9mTGmhKLpL+eZ22s7qCM17oG0QDKWF6rnBGNKvQmhzMnEyPwRGAM3v7?=
 =?us-ascii?Q?wx7hc1nYYEUb9BxFHHuRoP/N3Z7UlWClBsZXMwfZ1xTRNVzoo2dXU8qxatV3?=
 =?us-ascii?Q?mN1RO+GrsceaNosv2BZASj6QF9GkKkd9q5mtebaj4FN21XQGxHO+6YJOo3Ee?=
 =?us-ascii?Q?EKItRlFzaOxbLDMIRbSMR410+/EqpxEroE4PR0C1knDk/7rkdxzlVtZ9mDR1?=
 =?us-ascii?Q?cKkIVf+Dm032kLl9nm1yZKzGkNU3PhwR9Cc5HxPidscFzdlpTCFU1+XtPztQ?=
 =?us-ascii?Q?HV6koLXmSHUtYlMXc9nAnf8n2zBUMoVdZqYSBsG725ke3VJxjCqmz03RVJkM?=
 =?us-ascii?Q?Q3MtHSFNQGYNjKmvbZkYKEVMmiouCOsuGPBJrHUCGebSSAkyXjPzRYkpv69t?=
 =?us-ascii?Q?3yIYH+mbRdcuEDwa9ojgLSsImv7zOLoKtyUjtED/evaSQ2hFz2ZO/sjRSa2z?=
 =?us-ascii?Q?4VIAekbnjGESu63vb7Rae/gDVVU3J0AkA4i2GeBykFyaxmqOF8uko5iaAzWk?=
 =?us-ascii?Q?K28A+FvxxFrdqsdMNgHsv1M04wq6+9DevWXSk6azwM8VGLz9swEZTiViSsnr?=
 =?us-ascii?Q?LIhZlp2Sf3RQqzXOtU96r2AKOteUSCXMYWTYt4ZH9T/pYvZmJ+plzLWNX++j?=
 =?us-ascii?Q?yBT6Sb3h3LvP5SCwyExYWwKfDshQk9jqeZXIUH4znuV+m/8OCxkuYqBnaU23?=
 =?us-ascii?Q?huLKM8w9ar+E89AS9Tr/W9tOwB8GaR7736XyEn53xKYPslwsPWu2j/5fkNcz?=
 =?us-ascii?Q?jQ1ljJcnev2zqMwoW6mYCsaNsWo3/er5JfC9WIURDbs90/+qRUi5ig/edMdL?=
 =?us-ascii?Q?bZUnIHJfOn48gxeIizCu7o7o9xS2SrwKR09N+naREkiJYSMM6WPxber62IEN?=
 =?us-ascii?Q?gWIMmq7MzyZgREaJ2s3ndoYU3XNuSYSRcr1AJ55FFyeI5000mj000pkmdUgY?=
 =?us-ascii?Q?qsSbuSuOIEecRXnaYKko5CPpqErW44Zp/ITx6sgjRkES2yEJXaZ5X0hS4XZC?=
 =?us-ascii?Q?fw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feb0f089-f67b-4d30-034e-08dc03e27bc9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:45.5281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HoY7PCRaNqesfI/OOZjISX3UNpZ8XVHSxy81jJPYWsrGDjs/FKAqmbHhH05p4ANs6PqrVH8surekO5n21CdfqmiNQhHjY1zTi34Lq6zwotk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-GUID: fHYDQqSBHRmSZ5x5MHGjKIjXB3NpsxHW
X-Proofpoint-ORIG-GUID: fHYDQqSBHRmSZ5x5MHGjKIjXB3NpsxHW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=913
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

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

