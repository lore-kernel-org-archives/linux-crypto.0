Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013017.outbound.protection.outlook.com [52.101.127.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5172F0699;
	Thu, 21 Aug 2025 12:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755779760; cv=fail; b=WyGUQCKEbN868Rheqi7EOa73hO/jdLnoSu5aolyLbpcFPsVxhyk8kMmoRhw2mdi2iUmM/+ddCx6xaVdyQIDaZ0Uto3hvLiVoq3Q2uhqp9sokIchSDMlpRSUGSKyTag9+KFpalgETJGtHOcW+t09YzbJ7biicLx0qEwwOkx90fro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755779760; c=relaxed/simple;
	bh=BD7eILVAv2OxyXlyWt34IpBOnrUGzLR7SY0hEGI150U=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=I0qH99ILRkIG5bJrWEep1AWXqAJ9ecgtaDSyqI3t6ahzM+nPOQOwO9W81MSeZgp0ZZl8zTNYBz431mFGK7gmToBVd+zOsZOHcupxCSYvRUWiclfTQvcfkj2mOZaqK52O2qU7yi7rAxZVtV7AzTlT4HL6RT5yNtnMQcPu43b/qhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=GWvle3en; arc=fail smtp.client-ip=52.101.127.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="GWvle3en"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJfnre8r2h4/4AIgyNhzGVoDUJNBloBGDT0KbeYMXvU5ET6OXIYNRmjEgI6HDWyxIVTnTWg8JA70Az/w25ovbyosBn0N+ZjCTRZkN2dVoaQ3lxDtRFbjA9k9+4mUP2yLlbV1n6WwRQ1n82BT14QizlUL63fSNS30Og5Ijqhvaj6wBZWHIkbVO73BMLmjbXS/Nww8hvAOiV3hjid2oUopY9qx+340bYmhrn5+CCSzK5NfRbR7PTXrG7hguSxR1daSc1f2RwjL7LHc3gQySfUE6cFAaudoGrurUwa1c6iNIZGwpBtMK6ZTqzjiC40tO5kGeURH28daLin8HcIcwSqAnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEbGt3tS6mvdGVPO9gseOQjyQn8SRSBI70IA5CL5ohk=;
 b=U0mmYlvq1symAYXtwxRUswGiSaWcjtDPLBkIdnDjfGqlmJ6KZbOoB3+YtJb1DUqt0Uqr7KrIbWxQrVFOXWt2mQnaTGg5nqfPnmPGO2bUK1D03ez8pwX3ZX4AVqKEf1mT5D9TCwaX0z/ThFyUy9m9ebzpOCmlLW3IdSCjMhBTr7WPfEy45IpcHpWMKzKZPqj4wTna5Mi+yWa/wRH6cMZ4aW7WIba5n5RodRpf6L/mpBg2hBgOaSGETyaj5vxjqq7FNMuI0Z/YWK49467c0gp1UF1Jlm54ciNVcVSIU2WX0eGV5YN5/9INc1buQvUPSO8OGYEFQSf55YylydvwL3K+9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEbGt3tS6mvdGVPO9gseOQjyQn8SRSBI70IA5CL5ohk=;
 b=GWvle3enTitzrWhaKCFIeLFoGNI8AF9arWiOb1ewUf8uD9SDG0FRfRee+i9c4a6jCGRr7AbDAeGlFkXPIVVjo3E0nA7xz6fMHEPWKjP4tc4rsHp/zJypk0zPoPu87z/Qs1WTAs4FFMuhgiLZmmJWR6sY3SNBhfl/UOVQ05F51K8misyLqiVWwALMwQDqo+ZGS+Djhm45H6r/C0ODOU/iyyvN9QFKKrghKVJNU2N3d6E4KelUJkm2xP5/CG3079URpM3CfDT0tDKSNR0zkF64WZ1Wj3zUVFjPor5uAQQUeEz9XO5blvLQ5Ehv/lvtzR2UzrOv+F2iVdx3VXdMD7hYhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYSPR06MB6716.apcprd06.prod.outlook.com (2603:1096:400:470::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 12:35:54 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 12:35:54 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] crypto: qat - use kcalloc() in qat_uclo_map_objs_from_mof()
Date: Thu, 21 Aug 2025 20:35:42 +0800
Message-Id: <20250821123544.629821-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0104.apcprd02.prod.outlook.com
 (2603:1096:4:92::20) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYSPR06MB6716:EE_
X-MS-Office365-Filtering-Correlation-Id: 283fe011-4ada-448c-03bc-08dde0af4538
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|52116014|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?24ljyj5/ShkY73t3OF3w/iAaUcfTegB+p6UM/78rP88ACUyTSGIGH5EHQDn3?=
 =?us-ascii?Q?yrQO4cvN1obxzEU4lc/6bGL+2eVlOJ1lMLQ9s6nRonKE5+l4PfNwWMBpSdI1?=
 =?us-ascii?Q?uoz8P2x6g0J7Q416kPABZbaBCWR9XAePf6BoiwBfA0nimvbeEV0tgEKqYR29?=
 =?us-ascii?Q?H94yEf5n2I2GdgXPTf/fxT/xHMiNQBt814pV0rPYHQPHJpPeszJh+1JxKoLe?=
 =?us-ascii?Q?9pjYZYqb7flZjnpaS1MLpwBTCKjeOBHQjGKlpPUCvOKAfu3VP/DkeV6c6XqP?=
 =?us-ascii?Q?buWd85v71sAhpl7q0wtzfPDjzIgVNpyL0xSZyHw8Kk7FtNoJtInJrOQ8oTW6?=
 =?us-ascii?Q?zIJKvNMsMM8jLyc+fYKNKVMRbqayCI3CFLaayxvQl+vqstaOH2IxzCdmZ77a?=
 =?us-ascii?Q?uaq3ndu53WzDTRpcOXMK+xOIVV3owSR1bFg8/tffsPoXL7p7LUTKEgpCbU2t?=
 =?us-ascii?Q?pV+pLqkCRq4IueGJak5hpRHVXj/10j2h5m0mYauXoHmyo+7h7PVjoQ7UM9fK?=
 =?us-ascii?Q?kJ6C7N9fTj1/piw1dtW9I4OX2mKWL3WRcW4zjwr/hMKRJSncHDUGaeYnDIhP?=
 =?us-ascii?Q?hTbegipfyUyqKTVQdDPHZS4aF4/ScJUkjUTUzsv1cA1biImTa2EqXPhYWLi8?=
 =?us-ascii?Q?eVGD79UWRoWL84v9t1EgNisEq8gK9BcA8ZfUnO1XsLh2c7TKDUMx1SbzThfU?=
 =?us-ascii?Q?HtKiWO+RCjPh71C9hXEq6ST7HFDhHoJC6oU3GE/tZ5tA0qHbULdLvI4Qp6Qb?=
 =?us-ascii?Q?lgOFmDXmAuGZIB6rgUmOw9m3UNJ610TKwKHky10RhKAGIHkDnpeGUvOKKrNj?=
 =?us-ascii?Q?qHPUTDb2+Mv+HAa36TS/NKT/bJu/p17q7xAO/LEbOf7DHsNyrVGAC0UC7VyT?=
 =?us-ascii?Q?4Dowcx8uyeE8N4nwN+KqxcgoGoHnO8w71u6pOVAlP2hxEbCnj9GAUW6WVxjL?=
 =?us-ascii?Q?y/ncIMJMVkVB/U1EWg3v22JGsS7OdGUgWvU6pgbDswktCMeJs/kpCjbG3mx3?=
 =?us-ascii?Q?oBRI6dUGX5oilhLDXi5AQjdp0KPzRpYsTJIyMgjlqdcl0fgt/EpLWP164fac?=
 =?us-ascii?Q?3TSKS239jHBSBsBT8xfbf674d/IqLfIGe13EBgX/4EMt3YXTTKDXyssbZt/B?=
 =?us-ascii?Q?FBZsWae46bZPILeoMi3cVhDEh6vfjWwVJ0th8RzQZmVE6QVoI+352hOHQdkh?=
 =?us-ascii?Q?eYsO7jh3OqMklEXp0F9NmkJKXCA7Fe/unbHpKRZ6KzyXZOD0ungAJvhJBYlN?=
 =?us-ascii?Q?8ftraoW0SYBMAYAZ/3NXkQU3DtsJHbOfT7AmfUE8biZGSbYlavqHv1hA5BeX?=
 =?us-ascii?Q?4du65IDWg7230JNy1xgwlNo1Xy34GxiL6eq/iATDSgIV11qE4iTTs9cBUqdf?=
 =?us-ascii?Q?lpcpSp0lIWhv3ju6abqzqyg5qZySHOI4QzbksF31715GzsuUQITIAc9FioBR?=
 =?us-ascii?Q?rr/+39ll7xSvDINpYySDclo252fTPtVvG/gcoCMeOtg8dMDhFiUY9uf4kUDN?=
 =?us-ascii?Q?nD6WcnWg+h7LhvBv5iK/52URKESS4cXF3HmH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(52116014)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?juNqHcdxulnfD6v6Vf8+ru0SrRVm7p1g3o7YkHgObefntfoKzYfHWH4wrAa5?=
 =?us-ascii?Q?DW/Wj1qBY3InOCKlMtKWAVVccObfGfsSrVo8M7s64yptEOGsBHlEm9kT9MRt?=
 =?us-ascii?Q?/8+bCSx1ECy2ToYAliGJ4N40o1vxSu6HgUlHQyrj0IUdNl4CD1VgGMiWOuCA?=
 =?us-ascii?Q?7B87UaBXcS8seUM4l4dkBMTsJ7g0kiNtCy4fFRXo0DnP/IGrGlLwm8VsjN2g?=
 =?us-ascii?Q?9qFVoAD2jFAlI7tssWR9CK66Yb1QnMrdpFdMyo/7r/sWfYi2O6SwRsm32Fzc?=
 =?us-ascii?Q?h+q0bGpYQ34awEjK+W/RYjvQSrlHDU5KtfPWw8qf6Qw4qSmAYMy9FkXKRVeG?=
 =?us-ascii?Q?3u3U0EUDLXzAH3Cz7pZnI8wa/h0B5zMQO8g8CG1+r/m40xql0HUj+KjSOee2?=
 =?us-ascii?Q?FkdcP4id+yzpw4h8avx+GS6hzkOCMh2oBvtQXjlfTLwiSSvVEuD24wOxtnMz?=
 =?us-ascii?Q?LJnGQH9VABeIchpYGwlMHfkrbpRVepa4cOZpvIJwqp+rDRiyVfKI+kjj3+Jb?=
 =?us-ascii?Q?oSL0PPj1/3ZBfjQcF/Kh8kSCNl6aP4+yqZL02zzKGfzJ4wmsI3O3xPG+Hrh7?=
 =?us-ascii?Q?TFPql3DtdS4NQzu7veXGF3fcLifUXJbFm+1i5wWV2PM6dV+vFnxbnfjosrWB?=
 =?us-ascii?Q?OJYXSXlgS4pLhZZtt8eiVflhyToZ4bTHOzYqQPOwHSUxZBp4jgRmJdknufbI?=
 =?us-ascii?Q?rzHhBMzLdgUvwHEi5fjtRK7tTqJBZ0eGz1HV0arU10J3xoXK+7D5BzIwqOc5?=
 =?us-ascii?Q?jcSPy5LKGZmsrvWKMWKcUguUGRoDZwG/RcFJ2Fjr/0yzshjSpjgy27v9bEqT?=
 =?us-ascii?Q?82MTMXzv2wffgKiDVjzn72ec48nD+Xnh26dWHsjm7lEBuD1diQVPQHYDbvTN?=
 =?us-ascii?Q?sFqoNOXI8+uvewtIZG13exp+t2k5UpL7frIsLpr6GgrsooUE15tznfs+3BrG?=
 =?us-ascii?Q?OQS1NQpp3e4cBILvt0NxVSTzNVrofn0GmS8vsaNSUDAWobItScZfknNaQPwq?=
 =?us-ascii?Q?BPJe98o0kmYlL5bI411k3WOjMAaQkYA3EyFe/zPMHvwpf36pipX9pOP/pejn?=
 =?us-ascii?Q?ls6/AwQe0JkcQazWwOBJ1f4Z5OAsmEuUV9OXeJ08ZrxZV4hObGESdztKnyti?=
 =?us-ascii?Q?unfYG6ZWYKfQIUVHGUkBPbHtdvJVyOM1MimmkdG83SHKsZh5zpsiQCNDwrys?=
 =?us-ascii?Q?OZnyxcjcd2bVEATzO1ejwwdompwiJM+1C75WFG0ebyXzc0xuqrFt4JO27qNF?=
 =?us-ascii?Q?1bkq6Q4ajMrs+6PIrz4bL8Bth5QGeRi72ByqB78nLb1geZu0xN0ttfpdn/Ju?=
 =?us-ascii?Q?FkNUIynihZ/5mYC38yKi+Ido5BrZlHN1rPggvKEj9ouPoZc1yEnfcauP7cgU?=
 =?us-ascii?Q?zSAatU2xbGLe4fYXiGP3HPSx2c0cYt7ueWFJ4QMjL3AYgbpE84QAUhCtVh6t?=
 =?us-ascii?Q?SiuhPd2GREdDlzPyt13WTaScqitp55QFSSVLWD0z+IlG3eSO2j0k2T3MX3PS?=
 =?us-ascii?Q?DorDm4aFXpKFpXhaczrEkXiLMjlgS+XMyJ/Syzt6STMkObKpGy6wgkEw7SBm?=
 =?us-ascii?Q?0HwpltHQGh7FhLNfHBu6/hUs7jaMp2Cd6uGiEI+/?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 283fe011-4ada-448c-03bc-08dde0af4538
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 12:35:54.4168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hI3t69T4WHzn3HZr/gZVEMZXLqaqRottv134DGz7riYqluyBwJt5e9137tvPBOAae/egFMRtehQBtEwFyW4kEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB6716

As noted in the kernel documentation [1], open-coded multiplication in
allocator arguments is discouraged because it can lead to integer overflow.

Use kcalloc() to gain built-in overflow protection, making memory
allocation safer when calculating allocation size compared to explicit
multiplication.

[1]: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 21d652a1c8ef..23f6c2c659fc 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1900,7 +1900,7 @@ static int qat_uclo_map_objs_from_mof(struct icp_qat_mof_handle *mobj_handle)
 	if (sobj_hdr)
 		sobj_chunk_num = sobj_hdr->num_chunks;
 
-	mobj_hdr = kzalloc((uobj_chunk_num + sobj_chunk_num) *
+	mobj_hdr = kcalloc(uobj_chunk_num + sobj_chunk_num,
 			   sizeof(*mobj_hdr), GFP_KERNEL);
 	if (!mobj_hdr)
 		return -ENOMEM;
-- 
2.34.1

