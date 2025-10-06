Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011061.outbound.protection.outlook.com [52.101.70.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF9D25785F;
	Mon,  6 Oct 2025 07:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759735116; cv=fail; b=RvkpoTlmhkQVUY5p5uqGpFZ9Z9oKe2WMB6RFH7Wzq1vRoV2Cq3vaFBaErZ+uBHTloZ2BqV2cMR4WFPzO+FMng1UHe8Dw4m+R3Watfoa2YiphfmWkn8wIgLgoJdVNbXnPyjbihex5je98vuMmSN3c+nz7SPKgL4Hy8qnl9/IWKZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759735116; c=relaxed/simple;
	bh=Kg86Vqdl6kYrb39+BwDsvzpRGjWiGz8krIfTH3vMKlI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o3VXoPBEESjubqqP0yLVTXUFmMX5hOwM6KeTEQcZ3I7SovFghYIU+c7LJ9JyTXw+MMNkqpRp4+iYM+Y3msApnNLfmme+Hls5RF6VYZeYAGh4ChZ/fX+IjuiE0vFWWLgRrw0vVWioZhSFn3E8cT2jwjNw3vtHy3M2ULUG1HlYcXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=fYLVcrkA; arc=fail smtp.client-ip=52.101.70.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="fYLVcrkA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVKQ3N06llyex3fJDSCUQASn6jOrO0e1cbz5oMAgincoMhmahcUqlAeQ880QDB0bLnpqBHnvLJtruUZgq7hEZSRktWayvm0OC/TiPCiwHiSgSaORVMgKDO0q1CdJ+XgznsZZh5SG3oYb9S7VNiHgLUNP+iBKLIgcosS7BNwrUTQnBGF8XkZVTq7l5Bk8qqyCTiGPm3liL/D5c811gFbzEyTUARy54ZU6jEaSqI5D6F+zG0WogxFVYV7UF6rv+K/UhujOeJoQNGpDZDG1BemWU3imGH0KOCYnoIUoGWqVSRUOXhgtrhTRUx5raA2uYfzVujO5CFhSL2rXq+pgw6RFMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rKLvF/MUxyLh4qUG3DduGoLVBvzYyOYQB3xUltHHHQc=;
 b=GOygnv7g8Bowhzq9N76RIiJ8b2v1Elffjy0m4N0FmMlhnVjhY18U6mL2CrF7ipY+sPzxKxRl6RG5pjpJWti90Zo7l0lZGowKbT3/n5Dh2k/UxSgXU7WByMIf4BksZ7knrJE/Q5jL38VIHbFZwGpE0nN5viBxdldHr+bMOkBoUyvADsT4LFeLNDYgusiLiYus8yzWGi/0RI9LNFgOk4lf6SVh4jGyO+vFtTGJqMcA4zntwfFz6VOdnTBTJfGm0+yVRCjZFBDr58lPhLnIlo4APOoRDKHi0Q1ElGjUYfpBEIaAJnIjSWqSMzqPXkpdVs/5WGTQ3vHlEqJRxHSBCVOIOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKLvF/MUxyLh4qUG3DduGoLVBvzYyOYQB3xUltHHHQc=;
 b=fYLVcrkAjIUZyy6KbtZb5ksMfm1osdj7kAw5AK7TiQp2vqAt9nShiqSbCWQDQUNJT8v6pUS69/uwV4qcAVSmW2ZeMbpv3jE/YW8Ae5EYBykXLrkoFU5rQZuXFKx6p+wLkpSRBNaQu3ZRLqlEv+w89P2xXzTA1kJ+IwbSRYBVDfz/bypddkNaq53UdbdqXcHqf4cEHgbqzKHWFwZEl2s7jqTCrf/LWX5irftgT0XTmHLjdN6+JpxI8y8mUrBnOyyYzntZaKbIhlgJscNVT+xtd5CizXnoUnpWH0RQoJo0bACL3mpoogb+po/w6VPst6WVfwGeYeR5UreZibp4Ap2a8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com (2603:10a6:102:1c5::16)
 by DU4PR04MB10864.eurprd04.prod.outlook.com (2603:10a6:10:589::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 07:18:24 +0000
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833]) by PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833%4]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 07:18:24 +0000
From: meenakshi.aggarwal@nxp.com
To: horia.geanta@nxp.com,
	V.sethi@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Subject: [PATCH 3/3] crypto:caam: Add support of paes algorithm
Date: Mon,  6 Oct 2025 09:17:53 +0200
Message-Id: <20251006071753.3073538-4-meenakshi.aggarwal@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251006071753.3073538-1-meenakshi.aggarwal@nxp.com>
References: <20251006071753.3073538-1-meenakshi.aggarwal@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0003.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::13) To PAXPR04MB8301.eurprd04.prod.outlook.com
 (2603:10a6:102:1c5::16)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8301:EE_|DU4PR04MB10864:EE_
X-MS-Office365-Filtering-Correlation-Id: 995ad126-f817-4ce7-5055-08de04a88975
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6VmLz2d5w+eAkuLQ50HNKtiNik524CIy31n49HEbozRdU9K4Br5sMekYbJcv?=
 =?us-ascii?Q?DY6DzrLtkJs7IB9Fxn9aHJPZmqop8b9zdOCDbDQw2eZhe5Eh2JOb/m8rMXnz?=
 =?us-ascii?Q?1vmqZ62ZJ946qs62yQeKPY8IK+y/mZaEK6cedk4i6VzgY3mWxVm+iqA1SFtN?=
 =?us-ascii?Q?ZowkOkYK8FN1MX30jz8HEpth1FRR1LmlvqxL6GxAEBph5tTNUGnfplvH9HlM?=
 =?us-ascii?Q?FjBwKVcq2TD5DUqQioBtR0vbqy2gOkxmFMrmCgCx+2le2bi5zfsaz33zUVtN?=
 =?us-ascii?Q?QH59rvlmm9bN2dOE2550eOVeTYOnQqH195LKOZPBoD9bVV28Nm9AhKdNeoI3?=
 =?us-ascii?Q?1Mz+0gotUl9GLMIq6xKiyUkDbI6gD0Voe1yiT1cGOdvlY0V4EMx0mhf9D1dt?=
 =?us-ascii?Q?ShJaoikd2rvF9kjOGqGrtJGQR8fBcWvkLnhCK4PRhL7oPAeRauQ+w03jiDSP?=
 =?us-ascii?Q?o76x1fPvcnP83hbncXaY/392EDy55jycEGm9qVUDkrAAKvCHeN1UC4rjZXT3?=
 =?us-ascii?Q?K1QDUUWWDBckXkSnnI2NFeHz6GO8/EDGSzrYMTI72lupQIu1GcN/Q6Nlh2j/?=
 =?us-ascii?Q?Ew5i0Ic1nRwJUnOupCmBDBGQ38P8oNT1ct6BK79B89OaO6ZG6lvjaGLhyrad?=
 =?us-ascii?Q?FNAcFGZkim0b9S3HsJEjCV2zIhfFl/R3rSFrceuop+uS3zqZYV+bv/LfC+EY?=
 =?us-ascii?Q?CN2C3ZKo3AN2sWIY3dK2yzXAYOkoR1u1ji9m5oXwec8QQVhV5eiPD2f6RDRx?=
 =?us-ascii?Q?Gxo1ALPSDr1BiOwDgksN/0hS1NVJiAWnsXlgKTlIiiKJ9pWmH4gXbeF5Lag5?=
 =?us-ascii?Q?jltAdkcJy61574sxEKmX1wVgWxq48GBna3pDSmZuvVKBKJeQE8+Yq/7S/tjH?=
 =?us-ascii?Q?yiVNCykl2tb9SIi5kice3nG7+wmw/IMovgh0kdsdXJspwciUXjKv4zJGQh22?=
 =?us-ascii?Q?O222q4WM++xveiKy5U2xSjMj5Sx15ohcy7cwIjLyZFFgQu09gaj307Ny9NQf?=
 =?us-ascii?Q?ExUFiAyo8Kvz+J3K+B/Xbev5Z0KTPvD5l6M9VFuN8mEpSaO+4VbJ48PgWn93?=
 =?us-ascii?Q?zWt75AQtmGpFzjlwA/DWKVkSWnhylTkv6TCfazhIxjshjtiTUVrQOUXtvLaN?=
 =?us-ascii?Q?cW9AznC2d+bZEArlYLrrQsc/BmbNilpczO7OkxdW4iPLE5ThusZBXXMmgSUm?=
 =?us-ascii?Q?PsOFqXaIkvIHbEjv+3AqFdartrM9NgOO9+OkkMAShk/zkTejlxq+xbrz2Q4z?=
 =?us-ascii?Q?a/5TMDEe9HKY7U82DPkmvfl0dnqZGJiqOXyBxdcQjNXue5LkmCMrOaa0qsNG?=
 =?us-ascii?Q?ISJ0PnEj+OaplQYPMuqO/DuSxkaldgEID5QLPhcLXQBKaaCeoxSbzfFHvR3t?=
 =?us-ascii?Q?c7oK3jk/l/IbcImW7Baoyzj7/16gysUo33uwJLnsRH4Xhk8+nQxo/jtnG5LB?=
 =?us-ascii?Q?lOyvSi5WJ5qZtBOhP1Kz1L7dlPI/G3CcUwJ3wYYoSf3HKvchSdzmWXVfWR3n?=
 =?us-ascii?Q?jwufohHrA8qdM87dZX1bvjkjJBEGwmarGwKu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8301.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q6aW1Aikbg3vXd1OFuXJ6lBPfdg7qT+ccp7F0fDtsQ6mKnTa/XTRLfiby+zT?=
 =?us-ascii?Q?13PwgNUEwexlafwx7CM8+TBri9DlWipJEB+c4fYiQGpWj0/PIBmFwcLj+B5w?=
 =?us-ascii?Q?X8uwQjlmsVm84g9LZQOE219fz3QwlzJ5ePfSGbJAW++ZuG6XB08UhbJteIqJ?=
 =?us-ascii?Q?tAqfhKYXVCSPpRuacJnzQbVxRLpVl9XrvErsRFpOYBQFWknVPdpnrnIWTrcl?=
 =?us-ascii?Q?24iwM/aC7RoIuGiGUVw2gtMoYxFuY0+GJyZ4+P5OcQEFyjSUq7CC7f6Nmf6k?=
 =?us-ascii?Q?IJOmx1lhLh6Y4Y9N8gnbz4rOchF9W1y/Qbrt6THorA2aX2AsNHgGmvIsr7L6?=
 =?us-ascii?Q?K1p46EvpSf/memMKdQ+GnjmAqjEdqx4zGtNKY6kDjsW1M+XtBcuVcrNXfETs?=
 =?us-ascii?Q?xUwoVcGJ3viX/dQ91fwGzB/JpobaU9uLeLN7QA16guiMEeEK1AagMMJK5GPv?=
 =?us-ascii?Q?6MXilWdzOGgbLdSGJRGCFQBxGQEBQjObQAExd0cOIxC7AHILAi9ZD1TUxvZ1?=
 =?us-ascii?Q?p7JZUDUL+bN5uo5Mrcs0j1QXyt/YcmFPVIoHXPSWlgRMMkuxRpCCfEXiq1vQ?=
 =?us-ascii?Q?32+LLfaV/l0ANYjg2NU6/3HQBD0DV+4DAgQFPTCTWmWA7K7DZRQckW826N/H?=
 =?us-ascii?Q?bLf+kZjVz4n9ZjJIioW6PIHsiSSy7muI+BD2cgs1SOiyxuwdiTYfZqqsZCIo?=
 =?us-ascii?Q?S9kexztlKlakcWmLECRWmpe3DY0v5a0P5bBmoXw25BxTN6l6D5g676hVuum4?=
 =?us-ascii?Q?aVM695fzGARFK4uyP2Tww42BSkIusuN1iXhrfNnjWVnKW91nkvi/zGAymcDt?=
 =?us-ascii?Q?h8hMotrPBoRjJy4whOze4ivpOxymwmx3/kq6LE89joDYbatvTv/48Tv0bH8Z?=
 =?us-ascii?Q?ddDf2Ed3PzQ3BQ2H1f9C/aj3Bpx1qhjhcvs4Zx23mkrdgzKNl4CazOExgG0O?=
 =?us-ascii?Q?raUW7v+Xlagd0ybsw6VU8KuOluFvWLt7dYmIclen35TNh91Dt0UofyZ/lIcQ?=
 =?us-ascii?Q?jAyoFSGOz1gbad3yesRF7DKQxxNoHtAcw55j31id9LoIA1OvfYPeHz00H5qv?=
 =?us-ascii?Q?ArZSXG+URWcy1nF2mkeRGSgdrU+3j6lhCMC8tLoadbpJy7ucDfyp0h6oMSsW?=
 =?us-ascii?Q?mZSHnkCACs0KkNBdZGRYJ7kdS6F1fQv4QLVV9n4e5JNKfJS3lTIgxpb8EtMw?=
 =?us-ascii?Q?9bpuJFU+ox2+byXdQNrJ1dJJ2FPnko/yzwDs+ePZdAjxBRnq8ROb7Fm8ErbS?=
 =?us-ascii?Q?4dBLNsHLIxEgm9x6+1tI0XazzoDZCpgESdEmG9mgjWkv+D9/ZX65GLi/WLM/?=
 =?us-ascii?Q?XPaNqeoqWRlrQpSiYgkap3zLiQsUbxTAG7Lm1eEXHevdHXy2urxnkrhbNImQ?=
 =?us-ascii?Q?ii1N4rd97XNfXBcjc9VBdWwplBO+ejNtS+aAudJof21cvQX0U1cf6YyGG1y6?=
 =?us-ascii?Q?d6iyA91C+QwC/J13OFT2dWzfeNaVmf+76Rm5pwpNAS7jhuJWBVGiOuJL2boT?=
 =?us-ascii?Q?8y7K05r9REMMeVP08HKLZi23V7HNN0Kn/UH9RDvb4fUf1o/dmKS/TzOvB61Q?=
 =?us-ascii?Q?szwm+/bJqwMJkHtXMjAq0NOBLUd2pvZQxsuNvCf8PXWrYrVcZ044lLBvnZuu?=
 =?us-ascii?Q?yg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 995ad126-f817-4ce7-5055-08de04a88975
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8301.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 07:18:24.1836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xinverPyyLYFIHExeD8SY4gOt3kU2dNxj4U3l8/39Kkz7RXCOpryKy/qHeisG211O7VVll35E1BCG4lJ1puapelIrLexj7UtAtJN5/fKeU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10864

From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>

PAES algorithm uses protected key for encryption/decryption operations.

Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
Signed-off-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
---
 drivers/crypto/caam/caamalg.c      | 128 ++++++++++++++++++++++++++---
 drivers/crypto/caam/caamalg_desc.c |  87 +++++++++++++++++++-
 drivers/crypto/caam/caamalg_desc.h |  13 ++-
 drivers/crypto/caam/desc_constr.h  |   8 +-
 4 files changed, 220 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 2cfb1b8d8c7c..32a6e6e15ee2 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3,7 +3,7 @@
  * caam - Freescale FSL CAAM support for crypto API
  *
  * Copyright 2008-2011 Freescale Semiconductor, Inc.
- * Copyright 2016-2019, 2023 NXP
+ * Copyright 2016-2019, 2023, 2025 NXP
  *
  * Based on talitos crypto API driver.
  *
@@ -61,13 +61,16 @@
 #include <crypto/internal/engine.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
+#include <keys/trusted-type.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/key-type.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <soc/fsl/caam-blob.h>
 
 /*
  * crypto alg
@@ -119,12 +122,15 @@ struct caam_ctx {
 	dma_addr_t sh_desc_enc_dma;
 	dma_addr_t sh_desc_dec_dma;
 	dma_addr_t key_dma;
+	u8 protected_key[CAAM_MAX_KEY_SIZE];
+	dma_addr_t protected_key_dma;
 	enum dma_data_direction dir;
 	struct device *jrdev;
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
 	bool xts_key_fallback;
+	bool is_blob;
 	struct crypto_skcipher *fallback;
 };
 
@@ -751,9 +757,14 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
+	/* Here keylen is actual key length */
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
+	/* Here protected key len is plain key length */
+	ctx->cdata.plain_keylen = keylen;
+	ctx->cdata.key_cmd_opt = 0;
+
 
 	/* skcipher_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
@@ -772,6 +783,62 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	return 0;
 }
 
+static int paes_skcipher_setkey(struct crypto_skcipher *skcipher,
+				const u8 *key,
+				unsigned int keylen)
+{
+	struct caam_pkey_info *pkey_info = (struct caam_pkey_info *)key;
+	struct caam_ctx *ctx = crypto_skcipher_ctx_dma(skcipher);
+	struct device *jrdev = ctx->jrdev;
+	int err;
+
+	ctx->cdata.key_inline = false;
+
+	keylen = keylen - CAAM_PKEY_HEADER;
+
+	/* Retrieve the length of key */
+	ctx->cdata.plain_keylen = pkey_info->plain_key_sz;
+
+	/* Retrieve the length of blob*/
+	ctx->cdata.keylen = keylen;
+
+	/* Retrieve the address of the blob */
+	ctx->cdata.key_virt = pkey_info->key_buf;
+
+	/* Validate key length for AES algorithms */
+	err = aes_check_keylen(ctx->cdata.plain_keylen);
+	if (err) {
+		dev_err(jrdev, "bad key length\n");
+		return err;
+	}
+
+	/* set command option */
+	ctx->cdata.key_cmd_opt |= KEY_ENC;
+
+	/* check if the Protected-Key is CCM key */
+	if (pkey_info->key_enc_algo == CAAM_ENC_ALGO_CCM)
+		ctx->cdata.key_cmd_opt |= KEY_EKT;
+
+	memcpy(ctx->key, ctx->cdata.key_virt, keylen);
+	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
+	ctx->cdata.key_dma = ctx->key_dma;
+
+	if (pkey_info->key_enc_algo == CAAM_ENC_ALGO_CCM)
+		ctx->protected_key_dma = dma_map_single(jrdev, ctx->protected_key,
+							ctx->cdata.plain_keylen +
+							CAAM_CCM_OVERHEAD,
+							DMA_FROM_DEVICE);
+	else
+		ctx->protected_key_dma = dma_map_single(jrdev, ctx->protected_key,
+							ctx->cdata.plain_keylen,
+							DMA_FROM_DEVICE);
+
+	ctx->cdata.protected_key_dma = ctx->protected_key_dma;
+	ctx->is_blob = true;
+
+	return 0;
+}
+
 static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
@@ -1254,7 +1321,9 @@ static void init_skcipher_job(struct skcipher_request *req,
 	struct caam_ctx *ctx = crypto_skcipher_ctx_dma(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	int ivsize = crypto_skcipher_ivsize(skcipher);
-	u32 *desc = edesc->hw_desc;
+	u32 *desc = !ctx->is_blob ? edesc->hw_desc :
+		    (u32 *)((u8 *)edesc->hw_desc + CAAM_DESC_BYTES_MAX);
+	dma_addr_t desc_dma;
 	u32 *sh_desc;
 	u32 in_options = 0, out_options = 0;
 	dma_addr_t src_dma, dst_dma, ptr;
@@ -1269,11 +1338,6 @@ static void init_skcipher_job(struct skcipher_request *req,
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->src,
 		     edesc->src_nents > 1 ? 100 : req->cryptlen, 1);
 
-	sh_desc = encrypt ? ctx->sh_desc_enc : ctx->sh_desc_dec;
-	ptr = encrypt ? ctx->sh_desc_enc_dma : ctx->sh_desc_dec_dma;
-
-	len = desc_len(sh_desc);
-	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	if (ivsize || edesc->mapped_src_nents > 1) {
 		src_dma = edesc->sec4_sg_dma;
@@ -1283,8 +1347,6 @@ static void init_skcipher_job(struct skcipher_request *req,
 		src_dma = sg_dma_address(req->src);
 	}
 
-	append_seq_in_ptr(desc, src_dma, req->cryptlen + ivsize, in_options);
-
 	if (likely(req->src == req->dst)) {
 		dst_dma = src_dma + !!ivsize * sizeof(struct sec4_sg_entry);
 		out_options = in_options;
@@ -1296,7 +1358,25 @@ static void init_skcipher_job(struct skcipher_request *req,
 		out_options = LDST_SGF;
 	}
 
-	append_seq_out_ptr(desc, dst_dma, req->cryptlen + ivsize, out_options);
+	if (ctx->is_blob) {
+		cnstr_desc_skcipher_enc_dec(desc, &ctx->cdata,
+					    src_dma, dst_dma, req->cryptlen + ivsize,
+					    in_options, out_options,
+					    ivsize, encrypt);
+
+		desc_dma = dma_map_single(jrdev, desc, desc_bytes(desc), DMA_TO_DEVICE);
+
+		cnstr_desc_protected_blob_decap(edesc->hw_desc, &ctx->cdata, desc_dma);
+	} else {
+		sh_desc = encrypt ? ctx->sh_desc_enc : ctx->sh_desc_dec;
+		ptr = encrypt ? ctx->sh_desc_enc_dma : ctx->sh_desc_dec_dma;
+
+		len = desc_len(sh_desc);
+		init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
+		append_seq_in_ptr(desc, src_dma, req->cryptlen + ivsize, in_options);
+
+		append_seq_out_ptr(desc, dst_dma, req->cryptlen + ivsize, out_options);
+	}
 }
 
 /*
@@ -1817,6 +1897,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	u32 *desc;
 	int ret = 0;
+	int len;
 
 	/*
 	 * XTS is expected to return an error even for input length = 0
@@ -1842,8 +1923,12 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 				 crypto_skcipher_decrypt(&rctx->fallback_req);
 	}
 
+	len = DESC_JOB_IO_LEN * CAAM_CMD_SZ;
+	if (ctx->is_blob)
+		len += CAAM_DESC_BYTES_MAX;
+
 	/* allocate extended descriptor */
-	edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
+	edesc = skcipher_edesc_alloc(req, len);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1885,6 +1970,27 @@ static int skcipher_decrypt(struct skcipher_request *req)
 }
 
 static struct caam_skcipher_alg driver_algs[] = {
+	{
+		.skcipher.base = {
+			.base = {
+				.cra_name = "cbc(paes)",
+				.cra_driver_name = "cbc-paes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
+			.setkey = paes_skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE + CAAM_BLOB_OVERHEAD +
+				       CAAM_PKEY_HEADER,
+			.max_keysize = AES_MAX_KEY_SIZE + CAAM_BLOB_OVERHEAD +
+				       CAAM_PKEY_HEADER,
+			.ivsize = AES_BLOCK_SIZE,
+		},
+		.skcipher.op = {
+			.do_one_request = skcipher_do_one_req,
+		},
+		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+	},
 	{
 		.skcipher.base = {
 			.base = {
diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 7571e1ac913b..04c1105eb1f5 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -2,12 +2,13 @@
 /*
  * Shared descriptors for aead, skcipher algorithms
  *
- * Copyright 2016-2019 NXP
+ * Copyright 2016-2019, 2025 NXP
  */
 
 #include "compat.h"
 #include "desc_constr.h"
 #include "caamalg_desc.h"
+#include <soc/fsl/caam-blob.h>
 
 /*
  * For aead functions, read payload and write payload,
@@ -1364,6 +1365,84 @@ static inline void skcipher_append_src_dst(u32 *desc)
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF);
 }
 
+void cnstr_desc_skcipher_enc_dec(u32 * const desc, struct alginfo *cdata,
+				 dma_addr_t src, dma_addr_t dst, unsigned int data_sz,
+				 unsigned int in_options, unsigned int out_options,
+				 unsigned int ivsize, const bool encrypt)
+{
+	u32 options = cdata->algtype | OP_ALG_AS_INIT;
+
+	if (encrypt)
+		options |= OP_ALG_ENCRYPT;
+	else
+		options |= OP_ALG_DECRYPT;
+
+	init_job_desc(desc, 0);
+
+	append_jump(desc, JUMP_JSL | JUMP_TYPE_LOCAL |
+			       JUMP_COND_NOP | JUMP_TEST_ALL | 1);
+
+	append_key(desc, cdata->protected_key_dma, cdata->plain_keylen,
+		   CLASS_1 | KEY_DEST_CLASS_REG | cdata->key_cmd_opt);
+
+	append_seq_in_ptr(desc, src, data_sz, in_options);
+
+	append_seq_out_ptr(desc, dst, data_sz, out_options);
+
+	/* Load IV, if there is one */
+	if (ivsize)
+		append_seq_load(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
+				LDST_CLASS_1_CCB);
+
+	append_operation(desc, options);
+
+	skcipher_append_src_dst(desc);
+
+	/* Store IV */
+	if (ivsize)
+		append_seq_store(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
+				 LDST_CLASS_1_CCB);
+
+	print_hex_dump_debug("skcipher_enc_dec job desc@" __stringify(__LINE__)": ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
+			     1);
+}
+EXPORT_SYMBOL(cnstr_desc_skcipher_enc_dec);
+
+void cnstr_desc_protected_blob_decap(u32 * const desc, struct alginfo *cdata,
+				     dma_addr_t next_desc_addr)
+{
+	u32 protected_store;
+
+	init_job_desc(desc, 0);
+
+	/* Load key modifier */
+	append_load_as_imm(desc, KEYMOD, sizeof(KEYMOD) - 1,
+			   LDST_CLASS_2_CCB | LDST_SRCDST_BYTE_KEY);
+
+	append_seq_in_ptr_intlen(desc, cdata->key_dma,
+				 cdata->plain_keylen + CAAM_BLOB_OVERHEAD, 0);
+
+	append_seq_out_ptr_intlen(desc, cdata->protected_key_dma,
+				  cdata->plain_keylen, 0);
+
+	protected_store = OP_PCLID_BLOB | OP_PCL_BLOB_BLACK;
+	if ((cdata->key_cmd_opt >> KEY_EKT_OFFSET) & 1)
+		protected_store |= OP_PCL_BLOB_EKT;
+
+	append_operation(desc, OP_TYPE_DECAP_PROTOCOL | protected_store);
+
+	if (next_desc_addr) {
+		append_jump(desc, JUMP_TYPE_NONLOCAL | JUMP_TEST_ALL);
+		append_ptr(desc, next_desc_addr);
+	}
+
+	print_hex_dump_debug("protected blob decap job desc@" __stringify(__LINE__) ":",
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc,
+			     desc_bytes(desc), 1);
+}
+EXPORT_SYMBOL(cnstr_desc_protected_blob_decap);
+
 /**
  * cnstr_shdsc_skcipher_encap - skcipher encapsulation shared descriptor
  * @desc: pointer to buffer used for descriptor construction
@@ -1391,7 +1470,8 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
 
 	/* Load class1 key only */
 	append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
-			  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
+			  cdata->plain_keylen, CLASS_1 | KEY_DEST_CLASS_REG
+					       | cdata->key_cmd_opt);
 
 	/* Load nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
@@ -1466,7 +1546,8 @@ void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
 
 	/* Load class1 key only */
 	append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
-			  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
+			  cdata->plain_keylen, CLASS_1 | KEY_DEST_CLASS_REG
+					       | cdata->key_cmd_opt);
 
 	/* Load nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
diff --git a/drivers/crypto/caam/caamalg_desc.h b/drivers/crypto/caam/caamalg_desc.h
index f2893393ba5e..323490a4a756 100644
--- a/drivers/crypto/caam/caamalg_desc.h
+++ b/drivers/crypto/caam/caamalg_desc.h
@@ -2,7 +2,7 @@
 /*
  * Shared descriptors for aead, skcipher algorithms
  *
- * Copyright 2016 NXP
+ * Copyright 2016, 2025 NXP
  */
 
 #ifndef _CAAMALG_DESC_H_
@@ -48,6 +48,9 @@
 #define DESC_SKCIPHER_DEC_LEN		(DESC_SKCIPHER_BASE + \
 					 16 * CAAM_CMD_SZ)
 
+/* Key modifier for CAAM Protected blobs */
+#define KEYMOD "SECURE_KEY"
+
 void cnstr_shdsc_aead_null_encap(u32 * const desc, struct alginfo *adata,
 				 unsigned int icvsize, int era);
 
@@ -113,4 +116,12 @@ void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cdata);
 
 void cnstr_shdsc_xts_skcipher_decap(u32 * const desc, struct alginfo *cdata);
 
+void cnstr_desc_protected_blob_decap(u32 * const desc, struct alginfo *cdata,
+				     dma_addr_t next_desc);
+
+void cnstr_desc_skcipher_enc_dec(u32 * const desc, struct alginfo *cdata,
+				 dma_addr_t src, dma_addr_t dst, unsigned int data_sz,
+				 unsigned int in_options, unsigned int out_options,
+				 unsigned int ivsize, const bool encrypt);
+
 #endif /* _CAAMALG_DESC_H_ */
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 824c94d44f94..2a29dd2c9c8a 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -3,7 +3,7 @@
  * caam descriptor construction helper functions
  *
  * Copyright 2008-2012 Freescale Semiconductor, Inc.
- * Copyright 2019 NXP
+ * Copyright 2019, 2025 NXP
  */
 
 #ifndef DESC_CONSTR_H
@@ -498,17 +498,23 @@ do { \
  * @keylen: length of the provided algorithm key, in bytes
  * @keylen_pad: padded length of the provided algorithm key, in bytes
  * @key_dma: dma (bus) address where algorithm key resides
+ * @protected_key_dma: dma (bus) address where protected key resides
  * @key_virt: virtual address where algorithm key resides
  * @key_inline: true - key can be inlined in the descriptor; false - key is
  *              referenced by the descriptor
+ * @plain_keylen: size of the key to be loaded by the CAAM
+ * @key_cmd_opt: optional parameters for KEY command
  */
 struct alginfo {
 	u32 algtype;
 	unsigned int keylen;
 	unsigned int keylen_pad;
 	dma_addr_t key_dma;
+	dma_addr_t protected_key_dma;
 	const void *key_virt;
 	bool key_inline;
+	u32 plain_keylen;
+	u32 key_cmd_opt;
 };
 
 /**
-- 
2.25.1

