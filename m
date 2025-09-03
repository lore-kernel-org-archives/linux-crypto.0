Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013066.outbound.protection.outlook.com [52.101.127.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67612E54AA;
	Wed,  3 Sep 2025 13:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756905956; cv=fail; b=ocwju3dcf1yCvjdj4aEd15ivmu+I8p8xDzMVC3QLuRb1iQ5AzutSogFDSoYaVvryd7m5HVbGW5gcrharhGsf4J9s1UTuKla87h0MYTWXT0MwkNjc+3TKjdRrvfEtpA0QNTo4yB0ICJUCi6aPMAyzXdo/HJsot3X/8FyOGRfqLb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756905956; c=relaxed/simple;
	bh=TkzPxTkRKVjbN07CPs0hrq3uFfFflNe6ShlnDHByHtU=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=M0nu2vh46cVgI7+01E4TIHa7Xyz3EXADCgjlaIGeqBiet4bGEyC7Eq3mq3JlNAlHyN11Jp7HnhjzFPYTERHO8HG8DSC8fz06AdOeG8eKd347cGdbpTLMhGKpOtkSRZIG1Oo2i4Z2IdYD/LE3Jqe4FE2Eeq4QZxbonSTS4Id2MPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=c/Js65zx; arc=fail smtp.client-ip=52.101.127.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="c/Js65zx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SvXJlXkdKH06iYy/pNCegs3hunrVoHSDOrG6cXEwQFQEST2RbeuYpoO25DsnIha5WxQK5aq71ihWRH3PH5sKYqkmhRpK6aXuN4NhI48+WuaHihZDOysYsHXJlNTIJSLBv2+zODE2pEIe3QViIgPts/OcgY++vR3xllkOTdPVH4UTXXkFe7KvlAaxCNIcnyse6ftZ5+IVoguWVF1ZUViNsIhzS3TPloK741ewX48qpbBlIZn9TTZeS84y+Ci7gTDpx1mtMdr3sd6mIChwBZk78BJK0QflYxgPVl8J3gWmC8Yr2MoRZsMyfKbV1dDha5LRwRyABhbE5kCGYKk6e8n8jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04mNcTHBQJxaR2nUUeDy8QgoY5XZlDbGrchye7QfKu4=;
 b=cZV86zF96HpE9IoVcVIiZ43PWBVCYullAI0CQoahptK1CIdz7hfxvx4zhThtojLlFJAv45VNvdukEeBhxfvKvlbyzTXPO8MQmpwya9qoBRVcye917v5MR82iZ9wMLGr5GAdW4esbtCYTjjDM0+tWA9RYMMpJkxqDi8IssS12I4XgKXexDHiOVPQxgVA1l/F0p33hcVP8cfIjBZvkrZRpKj256CfkZO0z2MbA8WS920D7HjNVo6m69kRwOjdAsJ4vTFk6LyrnMT4ml8C/fxwZ2t6CGKttT+zVwKOeXRm6Sb+wRU+v52X3piUpU/9aOWPe4Jzt8KPmpU2Qg1dSOL6NsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04mNcTHBQJxaR2nUUeDy8QgoY5XZlDbGrchye7QfKu4=;
 b=c/Js65zxBfIxC/Et6fMSwWRmHBHBPdgD6ELVLF/kLsCX35tuCmmjZnWCoSsPGSOOIJfyqHqbt0j5z/HXvnw0jr6FbJH7Jp7X1KAbIqBIR6ChDCFeZnLFxu1VD+gUMntI3BFeKdHFNJQCPC5paKZ2FuZIgOPc0A1GJPtG34m5vniZ+cFAe2NcHnj/MgtRmLCCqnPys7Z9j6kMyUlCe8XQmWquvQaOkbOuas1JnTJtFGclAIJIkiKAoHKQqeaPgeKL6dJA+rL0YlPCkBPx1LaMaoML3LVUq1e0oRCCWOi8ncR/WNYTeNC15vuu9dke2qUr5jWfujMNie7RsFiKSBUrBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 OSQPR06MB7229.apcprd06.prod.outlook.com (2603:1096:604:2a0::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Wed, 3 Sep 2025 13:25:51 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 13:25:50 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE...),
	linux-kernel@vger.kernel.org (open list),
	linux-tegra@vger.kernel.org (open list:TEGRA ARCHITECTURE SUPPORT)
Subject: [PATCH 0/3] crypto: Use int type to store negative error codes
Date: Wed,  3 Sep 2025 21:25:34 +0800
Message-Id: <20250903132539.416439-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY4PR01CA0077.jpnprd01.prod.outlook.com
 (2603:1096:405:36c::6) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|OSQPR06MB7229:EE_
X-MS-Office365-Filtering-Correlation-Id: 8735f74c-a0d4-4ecb-7479-08ddeaed669d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|7416014|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4GJ4mKJEJIA9Z7pF86b6JGnNZBwy9whvV52tu+JmShs264PVrW1YxOdcIgcD?=
 =?us-ascii?Q?TmfOR17G1fOrCbmTfI0Th9d7kpeI497VlAiOLVKvK/ALGG129AuQu0OML4iS?=
 =?us-ascii?Q?ckzxtoWEYUA/IWtdycymGerj53aY03JkwVz5KDrUBAcx3Qv6HKoGHbIaV9o1?=
 =?us-ascii?Q?vHdqEZWxxZLqluviHfA9SzHYtfuo9Ql4tUQ3JeUGPEVoDNQ67W8JWwS/p5hW?=
 =?us-ascii?Q?MK0MwcFS1cPKAooAHnJQfXn1DyZuySp3NyNUkGu3Gcnwj0kSbTzx0QBgsJGa?=
 =?us-ascii?Q?iJojp4QOG4KZ2pW0B3COxRjkipGfu6ouqG2NPP6RBk0aKmKiaEwHjeuI2KGM?=
 =?us-ascii?Q?oisV9lxyy12ShxzlalkV6rixw+qYQhkC8G2ONTJ/oUif3PcBn2whgaN8dYXg?=
 =?us-ascii?Q?qV6T5ePz2n/f5Rm9rlHIblNt4sPq9yu6NaVq0k9aZylDI1kRzt91jqMKjbD5?=
 =?us-ascii?Q?hhc82OvC0l6c6M+HAj/NR9g2ZNczoyKW5a1HpvgqDjB8GULNBxYSPCbQRLVr?=
 =?us-ascii?Q?qc1VN1fMDobK+ZBzhRXj/VdnahRv6WkhL8VWsO48q3PEDm92H5tWd+tW6w3o?=
 =?us-ascii?Q?Ne7nFV9JqW2Uoj5M6xCz9FP9Eo+5ta9UEt4GRTu8hvkD0F1UBO51LM2sWocU?=
 =?us-ascii?Q?9lCNnDnoO6cuFDoivqB/xQHWLe2MbSN+ZgwAdw4DUfzmIMffbrRAwnvbncFs?=
 =?us-ascii?Q?fLDggpGjBAKQ4J8hceaJkjPU8lkXQ/uuwXQ6GZmaBi5NfpaHBORYOTF0FqvR?=
 =?us-ascii?Q?6GxlJSzm07z7jmkPgKT4vEJdHAX8VIiuMX6EGFXpNUFEd3qrDCQ2IbeO5t2G?=
 =?us-ascii?Q?gCnObWNL0NHkazcPjBMptPmtMYCP1PDqgOcqrqL3JPm+7Rk6hoVYYP/CTmyX?=
 =?us-ascii?Q?YmEW3n6vlru+lyWv+3zxhWzuocszR0IjAPICPDG5bIMGU7X8gCtDVFUQxcDQ?=
 =?us-ascii?Q?XO+TtRdVdOUJzkMY48RJybnhxcelpSMfI4bxbqs8dXZaLdNQji/ot37vjtE1?=
 =?us-ascii?Q?J0wn2zVP7m5P6IWp2Jn1uAXxC57cB8kx7wS3hTePpNipnHw3EtA0RNaY0C8+?=
 =?us-ascii?Q?HyzkgD+Zpanc8AArKsWUOxle9UbUVBZDkUSpW9Iq1gQZPqr3J8Bk9d16bgpm?=
 =?us-ascii?Q?eMalKHm+BY9n7QCXRO4kNTldp+M1ZS7fJtzUXTBMu665P8sKoxdbAXLy5TkC?=
 =?us-ascii?Q?rfFYhk1fsXyTT/HO3eZyhdd1Wa6uKntPablT/Z3C0623qmR74iMTGK4bXYwC?=
 =?us-ascii?Q?Ig0x+GwjYrzGOHlHJEVZYGwvLWgq2wnyun1bHj/i/CyKJh93R2ZwFqiQ+ojN?=
 =?us-ascii?Q?rLgc/q3Wk98LfKNL0eMcHBjCoLvmU/Wv1vPVroxYM5FLjUNWVkMtCthQs5j0?=
 =?us-ascii?Q?O/UEnW4qx+EXChwbfEMHVAG6la2yehiZXVPGXByYQQQSuu2ibpXXVdpbIbl8?=
 =?us-ascii?Q?EGlU2MEGAf4WjqXUQ8oNipiNH8QQeouX/FLa2HT0766N2nKkl+dF4QJC0qR1?=
 =?us-ascii?Q?WDF2GkdbkPzyDQ8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(7416014)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4/CeIokb1nbFvyhGWAhbHbQbYDbFuTx/bxhCfqr4e/F078UrgoKvjOWxaO/g?=
 =?us-ascii?Q?ILqmL3JzSXB2/Pz4hr+baODmcLCJuU3d+FKkJfloCtTgOeqyc1SRKx+pl8qn?=
 =?us-ascii?Q?W1DnCQ9aMABxxA58Rzgi5D3rzw+FlG7JhGt+CjX8/fwrXrrMPS5XuJk3KGAZ?=
 =?us-ascii?Q?G5h3DJGShsZMfLd9L64ow7iVYaaJ2OfqVXpMRVgQ19r+FXKVmodJYMF87jHC?=
 =?us-ascii?Q?PZoDE9D3Qn4lnSVBFyZVRn0W0GaUo19HnLEFhCaneG9rL2alkOwSKv9Nozur?=
 =?us-ascii?Q?JjfeeuA+/jOZuhDCO+E37W1fpcoWxyq6hyyO9+QPNpz6OCRIytmLinGhyjHX?=
 =?us-ascii?Q?i9gCwecB/d0e+Fe5UBRwenDq7aEzrfvaubqTCy/2jirtR+MmA78Ykf6w69Wl?=
 =?us-ascii?Q?SvyxeMJnauTxppgTuEbVKPMEEJC9fbkpeHsu0S4kZK8tv7E51Iv/T5talONP?=
 =?us-ascii?Q?IEmgHXD17EzTuNSqqbE93wN5bwVJiVjw1+T21weeoOnpp5eGMzn1zBXGzJk7?=
 =?us-ascii?Q?are7k6taAFubfYD424XMM4M0QZJx53ewZSslyeCfavjUssr2nHbQGNvZ0kEG?=
 =?us-ascii?Q?vYYLTFQOGbK20aZXIcSGNm8ogkrKzXM3NUV0AaLT0vegfw3iMTIn2d4G7TE+?=
 =?us-ascii?Q?oe4h0qnbP67cAErZUxttxGnNnqHJ9IYoRl0r5EEqzsL7LbeCrKd0X3dOM8N7?=
 =?us-ascii?Q?ldXCtsqBLfItYlgPO72LeVv8DZyq0T1m4T7/chOgiyZBJLtuSeXGb/SwrK+k?=
 =?us-ascii?Q?5USjjQqhpIas2YhQqYwLzmW5JnI0D4OSxELDakmpHvy35wwDiCViN1T4f3E7?=
 =?us-ascii?Q?79HS8cxGQVKrTRIxYBrc0rZMnFerO/GvbKqLnAdEZ1JB8dzefinn4H/G8i54?=
 =?us-ascii?Q?TwwinsqQP5kDyWX5ROdmlIzmhVWoljQfDJujAVtKzVK1u132GTIuHsuMZxYL?=
 =?us-ascii?Q?DL9Uz5C0p5jOcDwgO7XJ1tJCGarnbqaG5Oubn+2Sfuj+Fijj69xjoCnhwSpf?=
 =?us-ascii?Q?DTwFZXn7vd/RF2dKV100RAPJh1gFbffnbOu8pVrFOKWLGjrpJ6Wkzr5kcKxm?=
 =?us-ascii?Q?K7K6pg8pXNKlykE8upDS8bOqsm+vQu/UpM+bS3gSWb1OgT3PuiVu+Yb6JDiL?=
 =?us-ascii?Q?O/6WBeAd7vkkvsLFpOLviWEVK9xtHbOoPCW+9nwrQHoBXOJzEN+FHazapCtd?=
 =?us-ascii?Q?yU4v/1yC4wjfNWNWqCwuSF/eysccgTipHkz9qazkRsckGLBHN1V7iX0ZQZ18?=
 =?us-ascii?Q?m7b6bujRLpAheZSnGmV57EwbEcrIjXqYIGWKz2tSmWNtit0XoLL7Yy2tGlq+?=
 =?us-ascii?Q?JFcXdM/nnjp0op6gmm0cZ3eFV8UnQvt8IuTK0I1kUhjsNbo8uX0dhvVmnvID?=
 =?us-ascii?Q?LG0Xkdy8OK6v/6We5KcewGFvrgizV62Q+Y/n3qZIN67LlZsubO9BQy1ApETj?=
 =?us-ascii?Q?fRJMGFBybnCAyxeeAUT8VRxmGl7qlq0PlxWdw5dFuIbmHz1qpaWdx6nr1JSY?=
 =?us-ascii?Q?jXhEBr+2I7tYep3zKpjBBUWYHsgpGW4TLbn/KbEV1TbUbHxyTJVpGYD4i5bX?=
 =?us-ascii?Q?+seRbvuc3BgQFPfyyjqZrPcA/X7qCledvstAukcS?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8735f74c-a0d4-4ecb-7479-08ddeaed669d
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 13:25:50.9075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 68TOkdeEOwz5NT2QcgsYTlqHvbb9BSSb61LxKQWBkf3VTvpKS1D9PDPWIlW9LnAqpCiq2ZsV5Vr23yvRsI1Xpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7229

The 'ret' variable usually is used to store returns from some functions,
which return either zero on success or negative error codes on failure.

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but can be confusing.  Additionally, assigning negative error
codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
flag is enabled.

Change 'ret' from u32/unsigned int to int type.  No effect on runtime.

Qianfeng Rong (3):
  crypto: ccp - Use int type to store negative error codes
  crypto: hisilicon/sec - Use int type to store negative error codes
  crypto: tegra - Use int type to store negative error codes

 drivers/crypto/ccp/sev-dev.c           | 3 ++-
 drivers/crypto/hisilicon/sec/sec_drv.c | 3 ++-
 drivers/crypto/tegra/tegra-se-hash.c   | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

-- 
2.34.1

