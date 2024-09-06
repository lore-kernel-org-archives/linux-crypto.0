Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011025.outbound.protection.outlook.com [52.101.129.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0713F1C8FAD;
	Fri,  6 Sep 2024 10:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725619491; cv=fail; b=Ck29axKcIt5W+LRdfqj1PXYq7VVJArkUT/G3YDxsCswrDcJ8icqsKlYkLHLZ4ZV/WGctDF5I2NN8xyxy5cM9FJhCcGrPd8aBH5LfF08D/B0Q1KB7XjkvaEjX/hID0i/bgCG4PN536WaKDmj8uLNUQjhMwnuoThylNFb0cjSP3yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725619491; c=relaxed/simple;
	bh=CuWtT+PUMJlj9GKQe8N+d/lL+iEV4vfpsCijB/J5ORU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=FU2oFPEDeN45HC3CW2UgLqBv6O22257uBS8YC4isWmlKugbqNTyTObrPIWHLhA63O/EbwE6UVr0SgnUB08k1Izv4199pbS8bAboJYwF4szAax+FEkdFvZf4oxaLsD/FGXr0buDFgk1M2VjzFfw0mVgH7cwP6qfuMpuD2y+nDUVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=XdFHDQii; arc=fail smtp.client-ip=52.101.129.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="XdFHDQii"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GJoiCU5kC61es9Hutu7aGb+PSydGmluZJZ0blAmelRWc6QVs/SLvOq+Gt1A57LR5/3iQ1GskyDqdP2fgUWF5n6+sAbh41/hm4C8S3/UKTTUSO5z993JmG2i7sXDJQJjeK9amsKG8U440Xo0A8ZUuu45RYV1/ykQnKaK2vdBa0sUeh77eWRWom3npI6ou7yf2/d8IJdf/5VlgoAOjr1N8fyRmlbn1dUJQp5y9Y2zp1Fja1Q3hFykb8KKBABztaeMpelpsjf5hs2EawIMD0wDkKa2ih4OeHxl8b8X05NzRGQcvwTD6PQM58r0fuABHwIQ0FZImIoiROS5SmS3G9loZ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nn5kJybRhNcgtICvULpOQehWH3H3qnMv5GmQ0Vcv4D8=;
 b=yk8DhIkXD9ptZSfyVB7l3WqY/W2hv3JeSI57gkVkxVt2dMoEi2v0vJeBUqotmoP5XEEwSDvRVp0My2DokNd+HM370JyHm1yLTD12AlMDeuOQOV1jOOB+vdMCqkcWMuVyl5yRAI8QReZIb0T+yTKLGkLUeIUuGnvpHJOqhR3gIH5EjBOeVVAbbuoLQ7Yj5bEGJvlgmn41R1/dRTZYFuNgeNqZbrOBDMI+y9ScsgmGIo0Og7lPiRarKm4ldBDCP+7aIr0GcoNfxymB1dVnxfiYSiipYEGEzR3RxpsWUu4QnTrtpXz0hW8Jhiba7CCEvB60u9yETFDSc2MF6rj8sf1HXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nn5kJybRhNcgtICvULpOQehWH3H3qnMv5GmQ0Vcv4D8=;
 b=XdFHDQiiJiFAn8hYHqMTnbeW/fd7akERLp5q8TASC5xKjuM3mfWxikSYZ5LeqXZyqPyp03VjCcUydd4lHlUhJxfnlo8N7LhckVJjvUB19MCbQ/W+btQNY99QmziP4CLbkHHqZMcwpqcw5W4kLP0D3vz5dZes/8XIHQqJv2NXCvD7HSpVjpdgbg2DZ9qLDh6k3rjMhzT/Nm/jXEZ+GW/+m0I7vGP1rxENcFHO5rLDu45ZHrzhQgKRpiZP9oV5svnHBGat6HQVHCvc2X8bWc8QIO5iQx7VijKF0bQ9zDlYmwRs/YsMEhMDxt6mkkweRQW+S2XO4u1yB2WZ4GGp5uDgJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 (2603:1096:820:bf::14) by SEZPR06MB6302.apcprd06.prod.outlook.com
 (2603:1096:101:133::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Fri, 6 Sep
 2024 10:44:42 +0000
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f]) by KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f%7]) with mapi id 15.20.7939.017; Fri, 6 Sep 2024
 10:44:41 +0000
From: Chen Yufan <chenyufan@vivo.com>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Chen Yufan <chenyufan@vivo.com>
Subject: [PATCH v1] crypto: camm/qi - Use ERR_CAST() to return error-valued pointer
Date: Fri,  6 Sep 2024 18:43:24 +0800
Message-Id: <20240906104327.72221-1-chenyufan@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0059.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:384::19) To KL1PR0601MB5487.apcprd06.prod.outlook.com
 (2603:1096:820:bf::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR0601MB5487:EE_|SEZPR06MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: f89e3f1c-8aa0-4175-4128-08dcce60e9a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W6lWBa+cYzVMCEItuZsNV/j6v11a8W+YmNMcqwAkgYwFieHsY+ZOgAsHFYNA?=
 =?us-ascii?Q?Nuj7H8Rri2gZ2ncT92A5+RcvEtfPut7Rxm+tceaJ+ev6lef1cVRQsHcsuS8y?=
 =?us-ascii?Q?8clJQ+GrMn1fF1VtOvgNDs108p6kgXmc0t3/8YdJT+dkDotVPJbcY2PLHjNJ?=
 =?us-ascii?Q?i4VTKyr04zRQ2SevLpPV5J5j0TmazQSKwpZiplGJXho5bx7BTr1N5bhznLuY?=
 =?us-ascii?Q?/waJ6vtZmkKc35tA9CDTD68LGhgpEOBNLhGhOcdAsf60wWTtdhCUYRuDtuGH?=
 =?us-ascii?Q?1dqlxXeM50pTOqbEnQp4wfBXcqjvz8TBK7WR2pGqSMaClRZocenwtMeqLAcu?=
 =?us-ascii?Q?FJIkMGYn3XxIW4e6O09nYSmmDEZWlJyuSvNZDpg6LDn/nSZcfDJHZvK6gEfh?=
 =?us-ascii?Q?cv8l1cO2B0zKb3z6CJg6N7I0zKy0hhPa/Iijgo42uZ9gTfKBo5NuOxECpJxr?=
 =?us-ascii?Q?nMPge7LLtURYGS1TwagJ+s9zTLbbL2SZMPeSu5l2nTynpPL9n84CQTW63uVd?=
 =?us-ascii?Q?sT5y0lMTPbUPNAMVoesGE09xSFXvP1jHCCr03ZKFYg1ZKYJnofgB2rJ8lsOT?=
 =?us-ascii?Q?ek0ZEWx5PFwll9QyB1Fj/5MaQQaw0tPHhQY5SqCXjJqs2DwmlEBpzKQPGT1+?=
 =?us-ascii?Q?bKTVRIh/pWDZ1fZ8XoPs8Or8b+O2o/l39uytRIYVHYQi/4SD/4R+Xb6NqIG2?=
 =?us-ascii?Q?UMgMapLJlRQdcnEaXs2xP2JJwYzxWZLX6ZD4wdo13Tes1GZ27NpWPO/GP8Dz?=
 =?us-ascii?Q?r8S1WImwldNLnFtf6kkqp+l2oc3q9VieNaln6t8R9vj/TEF6I1Tyk1BgcUeJ?=
 =?us-ascii?Q?wpKSGGih1ksSQSvHjDQFGHityS2/zC9aDVZkZ8ss6slI68bYNHd9+j+MB+Ia?=
 =?us-ascii?Q?gEA/5BPJSj2iH+hAKLwQ5aJqsqD3ZpBYrjSCG9fln1LWa3ynS3QYdwKuqn8J?=
 =?us-ascii?Q?kjQPp6uWCtlW/2mFUpblEr/coqupdIu7/bK6v2jNt7buzTQLMHqV9TL6o2vE?=
 =?us-ascii?Q?14VXrcjZtzr84L7p5vW77d8Qm/t/H+9/dlkJAy+NWqvXe/dTNpBfVxl30zvg?=
 =?us-ascii?Q?VKatln1JzMxCayqnF1g3A8aGjzAUpI2d5SqeHWXNaCRNJAHA55JA0Uyxnbd+?=
 =?us-ascii?Q?1xoItksYgJtSAN/BxYWRtEBLIufAe7gOAplr/AKhvewqLhBVXpTWz3sEMX63?=
 =?us-ascii?Q?6H3eww/zyapyAkmK8+8OX2bLV++Dy/CSHxWs8FhR4OaXTaII7itV8j2DUyhz?=
 =?us-ascii?Q?R/z97B2PP5aYc+a1c7aA3zcVhMOnQi1hZHEKlS5Q575H1NiPalnqFzmqFbZF?=
 =?us-ascii?Q?Z0hUBmlRzvS3z7rP+u7lGnmQMEcmWPs+rq0XzGXj0TgM6X6USLOMXnQLcOgw?=
 =?us-ascii?Q?3TDil9FAIfsfaSGynTeEuo8PVS7kCzOVOxAAED7PwKrwiDqDQA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB5487.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wS5doz007qmjH82IE7PJTkBOtDK7XyCazFHb5qTr5mgq2nxB08beMVPWnqCr?=
 =?us-ascii?Q?YbUTtclz8ORZ3k8Gqfi74KFWx+c5gWn0GN06VvB2CiYTbsnYmwuoczp1FjIE?=
 =?us-ascii?Q?j3gSt4UYuKNcVEkz7XGtI+l+ZtnODelqZD/1qwGZJeKbs0JkiR6T6h1ALlAO?=
 =?us-ascii?Q?e7kfjdSmQArnLwqPEU8N3HfjDXKjzfATqau+BFsFO/8sQ1oRnErzPTWN2WOS?=
 =?us-ascii?Q?Qe6LLOOihhmuNZ8EomXETS5F8iqAxRL8DPvKls88AiwITH8c7ntBUDrfgd4s?=
 =?us-ascii?Q?XLqzhNNbxi+EXicXuJ8/P0zQLc030H1/P0D0zScqS18friST7y9UrnvqvtCN?=
 =?us-ascii?Q?IzvOWmeVcnI63lKJ1xpaNt9cAZ21bqZJVlxZzNONAalbJipuYj+Yes2h16yc?=
 =?us-ascii?Q?wSIouHhBUxHbLX/1JjC1Lg3fOhWL5mGNHhwzUHLeh2jVYWoW1q6jbCFOsy3F?=
 =?us-ascii?Q?fRSSsZ2xT9CARykugT2+D6VUd2VtC5oKJ4kgEI4yxlU4AspvpThRo32EaRWv?=
 =?us-ascii?Q?lILgBezCpjJTnIaMZWXUv2+NWVjH1kKXnpfHcFm1B3Z9jrfjEJDgjKzBCRtY?=
 =?us-ascii?Q?9e07kAivgJpJzhDt+2bRoBCUycg7zwRQQLEGvfNtUcBTLCp7Cr1se+PV3/Kk?=
 =?us-ascii?Q?MPMZdEb/LsaFBs/L1LNxohB2XYyFxIu5jHA8oId1HkaSZc6HS9oK3l2QMH2q?=
 =?us-ascii?Q?JpLHRehsVBbwSFt2NQ2bI6tNULDrTizGw6Qjh6hwB82mQ4qrFYpdp1Iks1uk?=
 =?us-ascii?Q?0Lx9hB6V6vbkhTG/Kj/VRVY26bbga3ZFLymm0uNTQr28VdkUq9zRgQS9JfdB?=
 =?us-ascii?Q?3X7LV6N/QpJKMtC3NUQxgIlQC3kichF72mtfUvTCJEMgKmJMmnDZSbyQ22i9?=
 =?us-ascii?Q?mlNYnqPhjQk751xLTh0fj3IjsOAUmtKul6615CAbN6PK6TZWtH8i+SHXxTft?=
 =?us-ascii?Q?+z7W5kypk6bng5NKG8NbrISoJnlz3bhl5JhtSs8OEF9z0/rwM74jY4X8rOR/?=
 =?us-ascii?Q?go4epWuo6ztSyw8WUikKsK3JNMBbw5K0VHY/ZSx1p5X3ED6nXbNhwHEUiINB?=
 =?us-ascii?Q?8qrS5ewNxlLrlMm2URmbpziwdK9OBO0fdjIKZjyDS7M06qdM8hv9gvnBiq5+?=
 =?us-ascii?Q?at7pd4z5glsbo5Gf5l9KBLK0CFZjAgSgUPrtdm2CF03zKShkKlPaEj/Jx70X?=
 =?us-ascii?Q?LUKixapQh+HVKue5HMuAg84OW9hkx9ctp13qcmIEigUWUFzMca+8FHzJXNwN?=
 =?us-ascii?Q?zELGbJ1JFYYu7hEr8oLeYLXS7x+LKhIESACL2UuS1Pdc4zWkfZQFoaBWiFqE?=
 =?us-ascii?Q?Ux0fNzaaxSQsvSGNO1erKdoDiwco/DCRQK/7ZmSjZ5CBtul9K/Ry8u9YZchT?=
 =?us-ascii?Q?siSXKeBjXeteAHyUFlWZkLmg0ds0aF0vf4UWlZmBGaA15YC9rg3Z4GB9lIp0?=
 =?us-ascii?Q?+oJb3L4uO4nyO5r8uIhE9JMce0LPIARI2sEW4Pc9YUReYUfkOfALdjnsWapK?=
 =?us-ascii?Q?GP1B+ic9h8VOVvnMJbB3Stkg4AmUACc856U3xA1HxskxnVpOQ1HMseOzLLwY?=
 =?us-ascii?Q?jCANSE2yjWqlEFJVY+WDr6KO3cUz2BA5t8wrIUB7?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f89e3f1c-8aa0-4175-4128-08dcce60e9a1
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB5487.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 10:44:41.3438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6cMbkPLkVLwhfRiqXbLFG4pIJ6imsUmj36PLNg8LrsyIWAHmNqj4TTRgQ8NUhDc8m3PNUVuEJGB9rOPtc5ozA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6302

Instead of directly casting and returning (void *) pointer, use ERR_CAST
to explicitly return an error-valued pointer. This makes the error handling
more explicit and improves code clarity.

Signed-off-by: Chen Yufan <chenyufan@vivo.com>
---
 drivers/crypto/caam/caamalg_qi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 743ce50c14f2..13347dfecf7a 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -961,7 +961,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 	drv_ctx = get_drv_ctx(ctx, encrypt ? ENCRYPT : DECRYPT);
 	if (IS_ERR(drv_ctx))
-		return (struct aead_edesc *)drv_ctx;
+		return ERR_CAST(drv_ctx);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = qi_cache_alloc(flags);
@@ -1271,7 +1271,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 
 	drv_ctx = get_drv_ctx(ctx, encrypt ? ENCRYPT : DECRYPT);
 	if (IS_ERR(drv_ctx))
-		return (struct skcipher_edesc *)drv_ctx;
+		return ERR_CAST(drv_ctx);
 
 	src_nents = sg_nents_for_len(req->src, req->cryptlen);
 	if (unlikely(src_nents < 0)) {
-- 
2.39.0

