Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013001.outbound.protection.outlook.com [52.101.83.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D424C2FD7B9;
	Thu,  4 Sep 2025 11:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756985203; cv=fail; b=OKEbV0j+L30W+Q59xerekxSk+XN1U5wiyltIIVgVI0Lzx6Tal6Px2vKZo8GVztFnVuys6GO9IljInA6bwhS1fYpmixsYNt/o3dusRj/KEdFFynW1b+IeIzSctodk+alNmsGaLgBlG5SzMB/szJ/4ZRlCZBbe55dfdcxNy/elpq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756985203; c=relaxed/simple;
	bh=xF0meGtRNtgTz4PdWIodYwgfic75Sndc/npFTEwnmxY=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=EEcwtoH4mwEfGp+T5LMp9UxDxLTCiMwYEHLVlRpzHoIbZ0cuhHD04+qooGL+zke4SWy4uoC5OLVJElB7FWr0QHX0S+/sAtu+k+ND3yshMP3qs7XRJ91DzstbGpcu30weuZZytbIxvJnDdlXDQr6YT1kJqNHoJcx9JM6hyw1RLk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=L/d+X7Ev; arc=fail smtp.client-ip=52.101.83.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="L/d+X7Ev"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SN1mrJnipWvnai9IAdkvhSJTvV8IdBN4rtnEAX/ZquBkMJT0XhmFemJ4IxIxBREMwhkEdBiltk8ZXtOBpmRvCsjpCFjSd6ILV5qXOPzdCGJZ6bEgPcIx8WhcjYekVWg77VRcVSO61qu8LYJldBSE24MSUlaNS4lieMirwVHomBtxzbKmOa+CBy98uAO8Rd+OS2sVCYPRc4wovq8CSDDF3uw7oYeYMrmJc/rOWJLZFcHRYuYdKfn7E5RmyztgFwRNkkUJexjkhKI7z+MbPBdomJxf90S8vohA/NMczdXQI9VbYBHJu080Rvp13SkELc8rGwFm/0Ecf9vuNKic3Wd5eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNNE69yQqVEh2ibuRJBynjUEOc3ZeWpfjuoZmgG86IU=;
 b=oYL+f8/Q5umYE7coW6OTFrDdGKAI8IHcan9+OLwooByEsh5lcUAAYSdpzjNmMF+8VqmOZNw6U3cFlsGPpGDbSLhgGnIpLfQqJqHMOwlH1I+IbygKsRR9jyrbUz1S127dLsCgUL0t0JbDqRLoG58xjXLCNOQbfn2RwYbifg3l/hLDl/l5iutbOIzDOrqPBqxds49am1puLg5I946b/IvsUP1UFpKmxEfY25U4OGXRzNTQtacla/l/xg2s6gOrqcdYMH39tRdFiHtLCOSArtcZOZFatfcfQDATxiEV8T7USWIYUp4L69T+5sJt51YwyOJv9kzGPj6mCwrVgLg+3AqP3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNNE69yQqVEh2ibuRJBynjUEOc3ZeWpfjuoZmgG86IU=;
 b=L/d+X7EvwtDMfSQhLfEqA9BQMtMgwSWNyJ4VLWkCMKajXtBaWSKawmtuX/iGhmSBTdvadbWAy5pn54asvGMquc6Lr3XUZg7MuqcnttYBJ5VO6PKaPAPFxUiw1B1k+QNBSGcZx48+JhMURPbRyQumO1239Ym5DgY/YHOJIy7abYR24KE0WEUzQbyIcCYkRGII5FSO32DnlasiATgajckqQlV7ZKACAJZBUNeaEgUj10GuyXYLus0TxVdyqrHs+ZdRFHrRs76uUB82PBo44ofn35LJLaK58I/B6mEiBPTdPwSs4RCcxQEoOJ4s4lmDz27ooLbTkNXe+6gMrLRFRqJlYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com (2603:10a6:102:1c5::16)
 by DBBPR04MB7723.eurprd04.prod.outlook.com (2603:10a6:10:20a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Thu, 4 Sep
 2025 11:26:37 +0000
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833]) by PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833%4]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 11:26:37 +0000
From: meenakshi.aggarwal@nxp.com
To: horia.geanta@nxp.com,
	V.sethi@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Meenakshi Aggarwal <nxa07556@lsv05950.swis.nl-cdc01.nxp.com>
Subject: [PATCH] drivers: crypto: caam: Add CRYPTO_ALG_NO_FALLBACK
Date: Thu,  4 Sep 2025 13:26:15 +0200
Message-Id: <20250904112615.4050572-1-meenakshi.aggarwal@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0009.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::14) To PAXPR04MB8301.eurprd04.prod.outlook.com
 (2603:10a6:102:1c5::16)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8301:EE_|DBBPR04MB7723:EE_
X-MS-Office365-Filtering-Correlation-Id: 97faef85-d706-45f8-09ae-08ddeba5e925
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oDA48Be01hBx9Kk/joKBLTWmFCvFdpUGuSZnWo4T9jIlK9KLAEkxv/iBIqEl?=
 =?us-ascii?Q?sHMJetsEQ4j6KTdZQ5pyaVvoxo1ilxF4nuQ3wnDqEfuFDjmT4yGJz01aGSgF?=
 =?us-ascii?Q?YToATckDLg8m7etV10n9pAL53Bje2m3VD8EKz8B/1hheAMpWSTMkHev0PSB1?=
 =?us-ascii?Q?1endSFYDvjyEIQ71BDkGDdIr2kZ8yI+z0YYKKZ8p20L1vn78jgpdQDFxHBU6?=
 =?us-ascii?Q?09p5oA1UiZyjJfKLOgKaghgwGO3m7xY2zzQ9bwl9TcO9I5pKsZYoxGffxGaS?=
 =?us-ascii?Q?b1xrOyElz2F+NqGaXKD6RvLlOdbb9gjjbRtVbj7kZqsRppdJhxTP1Gw882Bo?=
 =?us-ascii?Q?Zm8pJXjiQfJC8+LQspwxpdBiJdy26nc1hXA2zOdaO5V42sB0sOZyUI+4arqA?=
 =?us-ascii?Q?1vigYFx6vuVJdPe75MXnESbh5PLjeDX7lYCxDAbdwcSwU/odkiZm4V1v0ntM?=
 =?us-ascii?Q?q2jxjpPtBWPl9UGbFvo4Z5yGFUSrNAfexLaDAkoVLR/4GmjrMe1t+0K1ycJQ?=
 =?us-ascii?Q?gkcKp7ZidILOc+N8OmQih1xKxRuNtUv/XZXtSF86bwAvfGXrvl7lpEuA2k1F?=
 =?us-ascii?Q?cIVU0K90R1T8kTn+G165qS3yxwHHrHIZC78knvs31n3Ak+8RdSGgOShWiq6E?=
 =?us-ascii?Q?vzzq4Ybd/0lwCKQ2nuY70mQzn5eHxAYWYnxdRcyxJerl4dwIoD1aZzHX6xhV?=
 =?us-ascii?Q?F2CXaKSQToxTDgz76Ad8Rd5OEpAQCRMO/Du+x9X5t9VHxCjkwGleLBzBMIZj?=
 =?us-ascii?Q?WwX+I1hLevmgghRLr77LrMdeX4bBx+MAYl9uwlkfQGXbCP1dgsEK6SyLJd6f?=
 =?us-ascii?Q?6CIqKbJuUMEvmgTQbbOtQ5AK7SBbrdlb1M/qKpWEME3V1tZ9O5F4zFkVKT31?=
 =?us-ascii?Q?St8vGVyh8LsQrkeHhTEm/UPv1TkS5iuggNYmn7yFBOH4Ay3KTCKSQx3egKPf?=
 =?us-ascii?Q?RAkimjycAMojGlBWoJuZV+07YhjokChQBD+qMdcXrWqSz0UBnAde545FRiJG?=
 =?us-ascii?Q?0CHykb5CS2MRl+hGhodjueQcPEH3yB9gYYQ2E7rPt6BsD0SzfOnYNz4gHs4G?=
 =?us-ascii?Q?fCRZKRT9vmEb4hh/ulSLz+L0Lk7pdgP2bdDcYM5zOuooqnvbleC/aa4/wxsB?=
 =?us-ascii?Q?0NZ6D5X+Rmu4Y6cBFpFQpbrHF+DB3/LUegN1koaCpfvvDDgAFnqwU8qAgOHP?=
 =?us-ascii?Q?Q9dj9Cxu5n54wplifuErm9Gr3gbh2lPe88U4Di2zp4q7vwPX703AGnylJWwV?=
 =?us-ascii?Q?jhOPs5tTLcx8QjJbRfTuPd7F1Dyaj8T8G+aY0vVChDllDyVDAxIFxATBe+c1?=
 =?us-ascii?Q?LxKsRgmZYaQkZvAg4fRaBEbTx20/SfNVFMZ5SLbrjFOr2iZsfhngSu+SG1UA?=
 =?us-ascii?Q?bf4tO1X2iTzHkiph+KpLFWERvEunGy9CiP+g9LpKBGQ8KSOxXoPnUoTGdof5?=
 =?us-ascii?Q?US2geYcEvJ0kEew5FXC6VA01Ru7Tlu2K2HbEKTKOz8LmO7rGLlkyig=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8301.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rCG5b6GNiZ05FewQvsoHmlNbjg8J3xXHFZaAy1GYbc3C6dpM/B+4TFN/lYI2?=
 =?us-ascii?Q?yusz8gFTqICufbWboZqTL4M34uPz9Nxs/vHQzWRoofkdov2QwazSaQD90e8f?=
 =?us-ascii?Q?Pku6YbwXhIODA0/nv1L2TynGtlDSOUksotTAi5b7oPsI5aiCfd5GH6QwjG6m?=
 =?us-ascii?Q?5sWYVV6qGvHiLAqypagFrgzabkRjKwaHZKwKOjycKWauGywczEYdwQOIFSB6?=
 =?us-ascii?Q?1ypc0HxuXFjCk9k3NaBqeZLZc1nfD+JcgrWT473Pw4g7LsUcPnLOvN3QZt9h?=
 =?us-ascii?Q?owkI2m3U3HczafP+oLW5lctKrX78cR2p0ZT3STpCIiBEkuNQqppPQANd4xyg?=
 =?us-ascii?Q?53VHCrRGFAfP0CSs07zjo2oNcvJR/qBw4XY6YkjR9kLUvaMCUKZXipjeoO5P?=
 =?us-ascii?Q?LPQ2ezsCsStqr5QVgQJ+myWRv1B6Ugz5GUB7Izelt3ekEUERhuPeNx2dEAsq?=
 =?us-ascii?Q?OtlCNEahUHm50tM1VWedVN5pamLVMJPqUeA7iKGh59QM87bOGuFPjHf+UJbG?=
 =?us-ascii?Q?oZrOwxVsz8RRD6HjErBa01koRvon3GZv2X7tmPf9zYaxs+rIlHWnrBdHungH?=
 =?us-ascii?Q?9F4e6ZYOtN97CJly1SqfK6CvZqQ0PDRwIdTgcOf6yAYigQZexYAmACceUpoD?=
 =?us-ascii?Q?Jj/S/xuf923odKozg6CPrGs5zVHg9C9zfweUfPaYIbUaoKNlwTXZSveSgroT?=
 =?us-ascii?Q?7qRYUcurypsniw/aiICb8RMH3SRVoLvbpWWMCGKw4gbgaCYpFKKDarnNIarB?=
 =?us-ascii?Q?vc5bGfcbC9I/pzqXX4xkJzeIOOXCujvVOcReisXjemgVM+EVg2PnN1b4c0sf?=
 =?us-ascii?Q?rcH514E9tUOUZn2sTJWvz27gnP+SoK/kYCa/LScTOXcvv/X7nJS3XTFptyyp?=
 =?us-ascii?Q?8prUe6JacWIL/XAGf9Ef+oz631OzDXSswjIyO0lTz1T/H7UlJg/rpbj4MiYp?=
 =?us-ascii?Q?kyzlfMDfS3V+CpFd3/R2rPe937w4FfQ/n/MCmkjS8MzojDWUkyjKOA1Lxc+9?=
 =?us-ascii?Q?f2tCTRyA8M5VWkR/ZYhJktyGG82PmN0tg3D7jgXM8Og2/1YZ9HHhxaQVusTU?=
 =?us-ascii?Q?Igk51X0IIWC2QZXELg2ZNfp1KihjV4IhPnwdezuh8NJe9ilLBCl5Zbe48URy?=
 =?us-ascii?Q?vftW3FQOyZZ1prdsSWJZiJnylTrbC+ufccnjeAwY8sKWRZKGbgr+ypU3IBfM?=
 =?us-ascii?Q?mu7dOAXJphIwkeBubThwFizJeAu+2MB7ppnppy2/v+jEda0H4SFKz5BlUtv5?=
 =?us-ascii?Q?r8COfr1RP3nIDaT11PBBTBky8ha9PvH885vwfkxcTJ9TsFMaIzxqaXG6ri83?=
 =?us-ascii?Q?w6gZ7biQB2QbzqQenN01TPGapdLPQJsw9zPW9CxPr6dEBAYCrT9f9DLfYFQH?=
 =?us-ascii?Q?dyWU0wSsiISYTZPURtVnsrOEy8uqZXaHj1P7gLNGm5S3trSHZ9+35x9ImiV+?=
 =?us-ascii?Q?8M+SP6oiLF/SqVWiAIlqK+OC/aqGQV27N8huHCFjy5usF2O9sMZdHtoUS3Uw?=
 =?us-ascii?Q?v3Y3wlR6W46lE9TOjZWCngp5c5Wx36YPWJHPIqOfATJIMZRX70fT1Anq/+uu?=
 =?us-ascii?Q?PlOJuzvq0ckBvOwPG//DauXCbEB9j6sUdHK//hkXZ2GyYNf5C9AZa0riP1CX?=
 =?us-ascii?Q?xQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97faef85-d706-45f8-09ae-08ddeba5e925
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8301.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 11:26:37.2057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xr+Amd/2KpyaL9TaQgo1R1VdeeuxkMuXfgfuw3vkzel/RrV5OlapdzZYQJn3joFRX71+VIefsHJq2mCIg1EqK7c2cpS+wHGEOfpeFpf86GU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7723

From: Meenakshi Aggarwal <nxa07556@lsv05950.swis.nl-cdc01.nxp.com>

Add CRYPTO_ALG_NO_FALLBACK cra_flag for hash algorithms.

Fixes: 4ccd065a69df ("crypto: ahash - Add support for drivers with no fallback")

Signed-off-by: Meenakshi Aggarwal <nxa07556@lsv05950.swis.nl-cdc01.nxp.com>
---
 drivers/crypto/caam/caamhash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 25c02e267258..90aecefdce01 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1933,7 +1933,8 @@ caam_hash_alloc(struct caam_hash_template *template,
 	alg->cra_priority = CAAM_CRA_PRIORITY;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			 CRYPTO_ALG_NO_FALLBACK;
 
 	t_alg->alg_type = template->alg_type;
 	t_alg->ahash_alg.op.do_one_request = ahash_do_one_req;
-- 
2.34.1

