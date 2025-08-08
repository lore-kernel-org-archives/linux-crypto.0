Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013005.outbound.protection.outlook.com [40.107.44.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F094623535A;
	Fri,  8 Aug 2025 07:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754639084; cv=fail; b=rxKDAr1igzgWWywaJaFUKTnd9p6pXXNbdxKKQ/tZT07ageDc6wCUYQMQEF4GgaY2QP0DMP9J18hlweEoXS7kCYbFfVE649Bmuw8uHjxq8WqJRcyxwOCXduvuMuLrsdIk0EsfBFoMRfdXpByAu80ZLIdmY4f9UtPQB20y4NWGVQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754639084; c=relaxed/simple;
	bh=Z+lBi37p8yNBg9PkEvSdQYD/4QSQ0wROMuRot39/zFY=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=I1wuutxACy6xCaYzPNvYIfMaVOsgdJet/SM1a6PeQ1Kv6+4A0Z+zgyOEFEKLIJ2r3On1xMMs+b5q91+0jFIkM8PEpudQpff3qgIGrFKEcT06nSGBbE4khNxSCquE9CAG2828WdA6SAKOhPSPFktqDNpU5gF6+8Q30HrgnNdzmzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=qI062VP4; arc=fail smtp.client-ip=40.107.44.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="qI062VP4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IYiQ33OvNtsE/KJajIgPYeuuDi8INdq3LOsc7lauuCEJrl3JlG88aKIBAVAGcj52hBu6ZoULk8t4HrJCx1IQb3LnPtu+4LHUDf+z8EdvlLU5LCfuA3jtTZDp8dQXHGw40pyfRpAobQ+VRPloKEd+02jsbZxAbn6Bazi3RgojimWpNoLsLTYaALxappjz9OMlmGOuCcj/eEjSpDYlz4Ul8Kl6xZWPXi5r7SZuAwVS516lVQaV0UDQNaDIac3QhcHmDUNSLgmqlRO3SAsbNKC3HGhNJT+uVWI+UZjrnwpP/7LQGJayYbda+gSLM3hspHZ7RWNficf4YXHUFUVmH261DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCTOPHWicUN+8Pmp/1HydmWWgQMonRb7E6VG8pthaLs=;
 b=BrMnOjhUaqL0jVdWK4JJjcO8SKFwK0FSlIOSIYBg8Zah4hwWrwYFhLTT+jpQvyqcrq5Q0DZrQ59iosZa+MKSU6jPVL65yuHegf0zPilShyUwl2M/MpOpA3CAnsY6bKBk4vbtjPkA5sPYGMfq/bIM5jhKViYJeW2n1RDwGHTVw9BzdFMyfyM7XMBhrVUkZN60gGa4zg92rquGbbTK+VFDEPwG44DlPEgZh+6uStCocetJVeeuDWwHZGFy0gBqZGcZrZ4UXOdsP10aPNytPAxa9D7V1z1dmML9yqBOjN9HfAVSrUbnENNyxntEyniLsb1wNtLRcXW4y9aFPA/KWFlXiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCTOPHWicUN+8Pmp/1HydmWWgQMonRb7E6VG8pthaLs=;
 b=qI062VP4QzhVYWjJaOIv/Iv2jdJBFIDw/yFjv35XD40Tls84fPU6wKfcQANrEhL26G8SL9kKLQxJ4gc5NVEbu2c4rrrYcZbCv429t8hcD+caNGcBtT4pbYEh3utTvwSlS5km+iiZxGaNeNPfTpFPf7NPZEHeOUMjggVxoTQw35sqKIKz0Ko7Zi41oOubhB6N3ha7awSI5ckTpJGs3AZfm+6AYQEe2YzP6WC7aZ6x6Q2qNj1jgSL1Z9RPtOQSy/7pEpLItpqfqIzS+nPNh6jqEL09LOcBGWcJRh2C/uPO3vsKiP6nyLJkyTx6BEoFxQ1JBj2oS7d1P9e7Fd2Gd+9qrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 PUZPR06MB5586.apcprd06.prod.outlook.com (2603:1096:301:e8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.18; Fri, 8 Aug 2025 07:44:37 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 07:44:36 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Mario Limonciello <mario.limonciello@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] crypto: ccp - Remove redundant __GFP_ZERO
Date: Fri,  8 Aug 2025 15:44:26 +0800
Message-Id: <20250808074426.214726-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::21) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|PUZPR06MB5586:EE_
X-MS-Office365-Filtering-Correlation-Id: d198c397-f318-462a-f1e4-08ddd64f6c3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M6rshcDeNGEL61IW34Mt+uKRwHY/RVxe3ZQKuCLLjPwWsAYuMi+QobdHzSfT?=
 =?us-ascii?Q?RQxX5/wOpBOjX5ftQ2mtCwyp5DP+KXIXDWzba900saBlLhwt7W+XoB0hDshH?=
 =?us-ascii?Q?TgzGSpz6KjlqCY78lzzYvfomtkBwaShVrK3ywirZJ9w6Wh8hLi0KV/ap5nBT?=
 =?us-ascii?Q?w0EkbNHdYqQUKgaEVzTYRtgSzpTCuLxYS81uf/NkAdtgjy2QcQ9mxq2mphWC?=
 =?us-ascii?Q?vjoaEfds0mWpN26/i1lneLk60KVHYdRPijRFKVzg9NWkusRiOQVm7wlWdBtd?=
 =?us-ascii?Q?ugyz+ST8ncDWZUB20Ve6Z/15hr5ZmN0ORAspH7ds5Q6Eh8Swpn/bM+1GAKqm?=
 =?us-ascii?Q?qTseHA+ek8tLiP+kJzZMTKE68jjke4dmynpHiW8qoyHoq0W0q7ZHZtL3M3wD?=
 =?us-ascii?Q?Tbx5ZuymnxEcMhROriyQ7HHxwKEuILDDDa4/PfhercGXA0G3aXh2vpoySjY3?=
 =?us-ascii?Q?CywtO/7loazvGEyl7U73UGphXJJ3GcQld5nvVIcZoYdBp4bpU0/uyUwSPm+W?=
 =?us-ascii?Q?SWf5Uelah3ZLUSus5f6GBAhM7QECi4kdc5aNhBlwhFCX0vVvnOvH/D1KlyUH?=
 =?us-ascii?Q?q/fb9Kz27uqAJhqCHTTDNHqr+WkHg54wOUb9KIKFJioz7Zs2MGoAbc9JesLX?=
 =?us-ascii?Q?LhfliVbi2doX9f0wa+OAK8rdHEF41OMu5UO4bIwWU+hWW50GrAnkoUh5G8f8?=
 =?us-ascii?Q?MMz+x27Rq2g7tIgMtKpuG6df57VxdgOcuRWN9CHEb6YF5qW0d9wNVe4eZXX+?=
 =?us-ascii?Q?kCqNz2azzcZhkFDucgpwhEraSXs5/FNKkz5S8BKDq2eMsyYrjoqA9E+lyIDI?=
 =?us-ascii?Q?h7WkCaF85tcq5Z7B8p8VC24QqErA3ua0WsYhC09GOUBQdCLdRmhTcaI899JT?=
 =?us-ascii?Q?NvaBUIugiRc8ZdAl8LXHVGyIovnAMCUZsWf3cKv/qfGDQHnjh+GJUeLFJJgq?=
 =?us-ascii?Q?0v9uzkbKckfl7n4sVDy15mUgEKyF0vI8gETVoIbqgK4sSgytiquTqHjDk8T9?=
 =?us-ascii?Q?9szn2DJvJLUo47+t0+xuSRzWCPMNf0/8dioN6Kum9RkOfdMPhgSOUV7qXt7v?=
 =?us-ascii?Q?4apPXSLoKLN0bE875WK/xhmODXBjdvc/DDiMAolPjw5XcPyavMo5ZyquyuIr?=
 =?us-ascii?Q?Nt/OkZBuFaC8pEY+jxK/pvSOh+IUlgzVNpVIWuDdFdonbgAr2h6/v9M3iXCy?=
 =?us-ascii?Q?aDl8hIFtX4v3TOD6xdJ5hA+nQqJzFKMXyNE2ndzCmsKQCaGWbl+IqWzCY99y?=
 =?us-ascii?Q?9BvdAtoFBvkh/l2x3+TI3NHRJ9SmIFxbJ7K1uB040f0jxOHQx6IM8b/RgdEZ?=
 =?us-ascii?Q?/g5cAh48ovv+2gdROdO/Yaf8GjZR/m3HxMRYBK08zH2JksmNHjYyUEBEltDE?=
 =?us-ascii?Q?cOWRpil5mtJKi4qnV0wIaFlKkCm8Ayg7qwcZqNcG/+VX/S9vcgS7uaoWR3p2?=
 =?us-ascii?Q?WV6lVw1PXo/wB8BEXmJtwMSRNy0DR+JZaX31o2FeJmlOAP3U4dsEZA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y0sF3Iutd9A936ZxpsKmubC4foQcRbLdyxpFeOMonNcsxUXGxI/dvu+Zmuxz?=
 =?us-ascii?Q?F46lqrODVQwHWL13ZQssCkpwAt1PRDGdSmbqrzWGZUOKSVfJdQduErMBwkG0?=
 =?us-ascii?Q?wNYucQEJWdXqL2/teCT80xFKAOoQsFuuFfYuHPTdagTM6VzTf478MaONIOA5?=
 =?us-ascii?Q?A7oea1Xy2/zDil/F92w1qo3Hv5hpXXEWGdmMD8v73zpcF/dBzU0qmXndTjs0?=
 =?us-ascii?Q?Ya7l0V7xF4qWZj6caNN6negJC1f7qyncZ3n2/yY4JNHUs+KXO0daTzavMlLI?=
 =?us-ascii?Q?TaO00donHnB+45Rsuvf9tZ+3KPUq7kyLP9p9acjYsTWhN9IFDKcBmFJ/OwzU?=
 =?us-ascii?Q?IDoLGDQz0OodXiWrSUt4Sn+h1nP2DztBEBBolEQGMq3TQcVOKe+t4Y18iOWZ?=
 =?us-ascii?Q?I9VkGJZnmd/IK7SIpLnXMBSdKeeDlsmKvv40wBlK5QFM+VHAtuNWgTTfSAXj?=
 =?us-ascii?Q?7FI7rngHETBvr28SutOjyLliPW94Lf+mrntD/JRKT7DvFNPlRymMFXFtkYw1?=
 =?us-ascii?Q?qqKjoyWA6NNzcyM+eqKz182YV5thrqPxMu1C6ClzfnvwwwZJfyCwM31dki6P?=
 =?us-ascii?Q?JdXQnzROkH6YUnZm/OnIOuXOySAgXVlx7GuZyH3IjzOE+Bl7QTmpu/+E0Ixh?=
 =?us-ascii?Q?Gn//J3HOWdziUNtnVwtwomWGXGla/l5zxObPIDNIQ37chHLOi6GOVhXXtIW2?=
 =?us-ascii?Q?Ub3lvJljLR82fPN/Q88n2CZW5AqV11Kj5knwqGEqXO7XBkAkafHw15ZS3JUW?=
 =?us-ascii?Q?VFn+tNFEZNnPFSBfpIJ+ogM3uj31gKxZWCGy0tLJO3Y3GZqwARchK0QGiJ83?=
 =?us-ascii?Q?B69SqSDPpGKD4BdjoeFRoPQRajs+myJJcU0fnw0FtLiniXk/5sTkmcql12my?=
 =?us-ascii?Q?o0yLruH4kASsDel2R80hRdscqd14c7CvG/BhjjdzX3LNZhqzHI2s+SvGCt/a?=
 =?us-ascii?Q?SCrhDXXzh8OuYd8DH5XY9LssxhFNRReKh2SQeOk6t5KrSRKYfkdv+Zl3rK4q?=
 =?us-ascii?Q?C2wyEDy5nDlq0/6bg/v4lzDjLd2LA4cQtfi6AcNFkobYtBf2y4zcXblaxnnj?=
 =?us-ascii?Q?wlJYTta1ioj3dDJrPOxRL17DCuVMc7i82mOtw7Ux+aqmKZr86uvpeVcmKwoO?=
 =?us-ascii?Q?hUXFCE3FLWFFJDpLW1Sk21PDAMYoOuusQyp1c7JKSUI+Afja+iLMR+xOzyjq?=
 =?us-ascii?Q?8sTrFU6g0rubA9rKuqtfcO2bMrMQj5ADdqbvirf5UoOTED3CPLqeDecvoPJm?=
 =?us-ascii?Q?bhMLXXKw+iL0+6ssMsocOxStViYsHpkso1kUTsJXD1xypA0QXehcRM1vy6DW?=
 =?us-ascii?Q?7hTgaTm4Oj+xv2AxHlEp9ysxhklXxWFP7tABjjEhbJCuscCw8Cx2SjsuzuAw?=
 =?us-ascii?Q?UaS3l6Mjb3/l/GPZjXP4vQyMS11CvKmFXFv65ZFPZhAm+rNoMsr80Qnew0yj?=
 =?us-ascii?Q?dyLbL4r1ygzeWPfqlO1e36b0JzxRqUwx6desDzquEAP5GDSSABk7/1/0HI61?=
 =?us-ascii?Q?VEqdFzdhQNam1EqAPVG81YcOU8wZzlmyXYuU7vrDkCOkIGkvlUtZZ2x3FEx4?=
 =?us-ascii?Q?MXBZ4kxmYZoDQ2G0DYPRqCiwwvVaJb7a/JuCuJ+Z?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d198c397-f318-462a-f1e4-08ddd64f6c3b
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 07:44:36.5583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QTvomBeLScGXg7qcDRT876B0LqVD6wTj/IftSDnyDOvSeiT8TbROYoTjIoWiAEqCp4aGlx+NoAg0Tc1FvRngvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5586

Remove the redundant __GFP_ZERO flag from kzalloc() since kzalloc()
inherently zeroes memory.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/crypto/ccp/hsti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
index 1b39a4fb55c0..0ab3708951af 100644
--- a/drivers/crypto/ccp/hsti.c
+++ b/drivers/crypto/ccp/hsti.c
@@ -84,7 +84,7 @@ static int psp_poulate_hsti(struct psp_device *psp)
 		return 0;
 
 	/* Allocate command-response buffer */
-	req = kzalloc(sizeof(*req), GFP_KERNEL | __GFP_ZERO);
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
-- 
2.34.1

