Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7CA304BB6;
	Wed,  3 Sep 2025 13:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756905967; cv=fail; b=OqMIyoZ8n2oFBL5P03s1AOcc/D9dYO0WyiDw1xAO+xlcyb9xS7qctJ4eJm7U5MqwJScA6FO7i/fwU3bTAAeK/M/FNmd5+xduLl9ZVDnP3y/y/NDKIsWRrdlkynkoF4MNXGUaeWMti81yn8CnDtXxYAPGrCpyd56VY7L2G7LGki8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756905967; c=relaxed/simple;
	bh=6rCyzolJCsH7Az/nA7E0tRty8krRK8Y8G8OK+MuUHWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EuIG53FNbjoKZ6Ad/SH0XEkbr9+z/rArh5Klo3Z2W7R8Y2RkXoZch88rVe/nUa2KFnwthknx9/V/O05OJV6u6OoMznrma6uKfuu9qXGOf5fnAyfBtabJE50RDyfF178qT+lyFLwdOVGRslfhSL53QpM3CV4HoKl4zAafZnP0Ezc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=UWXYnGS5; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="UWXYnGS5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WtoukzahiCutg6VKT9wbyFzv24IH1Sw5v0Bvsnl99OuJJcn9/efpzv0/WyXvCMX0+isFWeOE/l/CE6naX+TZ+Y32lavJjUaevIWWrpKhTJVmWrEAPILzd7Iq/VmzvQYUOC0ADO+I7g6eWbtNUOkjc9B8mVuz7RBDM2XSpyfGa81Vlsr2t/ISdbkPHk/HARnvjYKiYvZ3Kgng0c04mEKrny7BEvFBKIq0Q50k6ZeRjG8XAV3h/J2a/wV4AnVRlf3NTlQM1eYWh6IYTHxXAKzvBxaQK4+GBLsXl753VHjJXl18mEZ7Uz6gsckkReR4KI+JHV5oDBPQLFnbbrWvk85G5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AERt4WXu8tB9v2MUapV/J+P3jUas8AX8piVM4eOoOEQ=;
 b=TpvZP+ycriL8d9qMDQ0gqEf2vCJ0N0rbtJ5VmDNsi/ubgQ40pXGcnXQQcvqDQtsEP/bU2BEtmJo2mZGZi4dGfgATVCTIH2ltlJD250fnrbaAkSzJqqMM6sXa7ONckaqQ45qY5euGgRhwStncWpre3NxcD/XESUMH4w7qnQNBlV76qobVVZi6ckTrtYe3R0g3JU+O7YpWf9ulU4B6mZevPQO5QxSCGsv5ZIO57vWZIuA0ucw9uiJaFPz9VkVQdaLZEDtXCwU3aJs1OAMYzWRfwQsBUlRhOgLMWW9Q2YF8mLKHVLooKkdqUjqtRLgNMrIS1bU1WVBYYSRs1wfOnSMJ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AERt4WXu8tB9v2MUapV/J+P3jUas8AX8piVM4eOoOEQ=;
 b=UWXYnGS5RYKmHEf764RLdmIxjMKdUyCFu5eyEDCr9lzp+AtnhaqF7CPHf3O/oNa/llCHA2T13TMKN1g1vxHrWBxQWhvLuccN4YYbY5URzZSFeMVc/O+JnjGh1g7Df+sZHlo00O5wpBBvPbn+9g7vrA6cxEPCvzyIk0EBVRg8SIMWIhY7FvoXHl3G0X26tWnX79skhe9rLTtXkWK6u6SAsnitbOaNBLJ21m4Fr7ELLGUiVClPNPwi8rrVmhpWGXv6r4Ka46HSmA11EvyUbij/GCzj5GEs1rY6FNqpYMDdNMbaz2e+paLV+YjBiNMmOwue8bvTg26sqj/OksEd/u1MNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 OSQPR06MB7229.apcprd06.prod.outlook.com (2603:1096:604:2a0::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Wed, 3 Sep 2025 13:26:01 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 13:26:01 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-tegra@vger.kernel.org (open list:TEGRA ARCHITECTURE SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 3/3] crypto: tegra - Use int type to store negative error codes
Date: Wed,  3 Sep 2025 21:25:37 +0800
Message-Id: <20250903132539.416439-4-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903132539.416439-1-rongqianfeng@vivo.com>
References: <20250903132539.416439-1-rongqianfeng@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 97dd34b6-c3b7-42e0-f0d3-08ddeaed6cbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KG4yU7sIQaxxFoACFhFUSLMvJ9qT0+Szo19w4CvhiKiGgUA93XpqEU8MayYe?=
 =?us-ascii?Q?9EYr1gskP3KnTny5e3VOVmZZ+R5ATPyuYdmh1EtxLGFVDM9IHTPVwhbk2j10?=
 =?us-ascii?Q?ZjTfCAXyoiwMHeIrIZpLLx1E8C9tmqNpfTY6TAw/gyGi+Ax2Oii3bnIgrh7o?=
 =?us-ascii?Q?7Op3oy+Kts845jtCn18Uect9pQwL6bLQp5BGHxO72cTpTLboorBw8P8Ajyn9?=
 =?us-ascii?Q?d5EcO/eLGEJ2avmm+1jz1brJ4vxCEiQdPAml5J8DWRGRK9mCdAz4eIwrllXx?=
 =?us-ascii?Q?olJasW41H9SkKFH9adbEtKNMuio19P9a98O3geuvFPPHssXnHDqBXZiUtjyH?=
 =?us-ascii?Q?w1hfvPJlifHJs+MjRRT0K0OXJJECWaAKqj8HLIjGKXFXcfQ6v00GTrWMqDxv?=
 =?us-ascii?Q?l4fmxruGQZHrGHiA6mYw6JTvsLm2GBW5+jFHwxY79Sa1mcDUgBOA0pQ5LyqC?=
 =?us-ascii?Q?IYNc9nX+8MqMnC9dNKLzqTFE0/rgxiBFCUPVOLXmVq7WLrRVAph/2uoB1T/E?=
 =?us-ascii?Q?dbnbN+oOhr0tVfQEWJrnnIMiP9TjPzDczCkj9YsYRItxk174mDMFjmgi4PfR?=
 =?us-ascii?Q?ROoEkGY/ewuQWa+FlZJ+uFz5Cg3lj9YOBLAo4VmXkYl8AJmL/3xVcmsHZzed?=
 =?us-ascii?Q?VMk6+P1BhfE57wp9nN+8TGLc/ZKXXO6mQfRCusYULx4Q3QnrK24KEUnf3qap?=
 =?us-ascii?Q?3Z3Zq0U2sOw6ZfvDJyr2c4wFraxkYU0vD2m8c/vWHjTv8gJpb1I5XzBAbKQh?=
 =?us-ascii?Q?eV1tLqQoEsvkoGZGx/yXz7uItSGKOlXk9VmZ+8q5rOPNVT99RHBVYaQz/08X?=
 =?us-ascii?Q?KJ4ggH0VLEjd73BhWRRmpwnVGteJtYAMNWaJNEDRKMkzd6gqA+CHQfqQ3nO9?=
 =?us-ascii?Q?Lnoah2t77SSQ3djT9BNbzquw/l6bxBvkQxexKkJr5Vo5CNgdWDSNCXM7CYw0?=
 =?us-ascii?Q?mi1pfbDCTyT+RPFtM0k86Hf3hlo1gso3b1H28mHYNmunJRDXRZD13YzRyRfv?=
 =?us-ascii?Q?hbm705mpq1jo509K9FKfXz4B666Ll/8rR9ViJ8rCQWkY8Eq2ytNXgmf1YeL0?=
 =?us-ascii?Q?e67+DNUKGObNQhjtgxy78wt6q20/mztPuAXLIGy/yp5Uzx2YrKXgmF+vwakH?=
 =?us-ascii?Q?MQQ4gIp4VHShttaMi3beoenahv0pLBrSPA+ZhORdn/NiM8KZCllMPVNGr0Wr?=
 =?us-ascii?Q?T9+RyqPPKMEaY/NTvnCjXML0G8fUBDtwaKgFkmhfoIRHSUsmZ53JnO4upkPQ?=
 =?us-ascii?Q?70cKVrbwkwH/z/C04j9219wX81BT7Q8D5lwU/O1weK+Cl7+McFNFFXsFSa71?=
 =?us-ascii?Q?8KvZyHFsWNBlGW1TLVUyrVSEwP5S8EKxmxFpuMOkOO6ssV1FUxgL/DxvJPR7?=
 =?us-ascii?Q?Y7LCwMs5PTFhi9KsUnN0TXfkDjbDZv3+6GlAHEYcAJN8BQ+dV6mK+IP7NrPb?=
 =?us-ascii?Q?n2ayevNNKsC0uHumC7AWdIn5GLXbyVW4m0nDwGGyRPzuUsC/zjVV1g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AXM4fdVcekVyCVX9qhNLD53Cx8TzQtQcJoT+q3qgsTXfW5YE3yJIMuEY9hxq?=
 =?us-ascii?Q?AjOECUOOng/hmR/U+GKkoGzWPRUDFuuywdqMkI2uLbhrHvcQDomGKlnBtXI/?=
 =?us-ascii?Q?AX4I3Gu3PBgk6EgJ2cUobb3+RZ3IdS4JZHT7O6thTdswJg09LNXn5DWAEoZ8?=
 =?us-ascii?Q?esVG5K/ApY7Sd+QPr64Jwud7Vtjbeg7z0Am5TEEsTQNrbZqb2GsIAg/XS34G?=
 =?us-ascii?Q?4poSmDzL6Vy45K/Ql0GVvVZlp80BZrE234mGDJwMy+j2FCuR12CvwD6U1knx?=
 =?us-ascii?Q?hsRz4Ynuwv4VHxgsBgXq50GU0x9PZ1jdsOaJqgc6QtscMs/WFsqu6ASnxfY2?=
 =?us-ascii?Q?4YAjoSOp8maL+2b7BUbADcVOxh9USFGHVBHJEUrSLIV6koow3dyXOeiiRBLY?=
 =?us-ascii?Q?oc6nCbmo6Qxknj0LqSM2O4EfoEgZ6J7F4LgdL2KSL4xOjzzWpZmyL0bIdF0j?=
 =?us-ascii?Q?wI4y/dczBGe6YzprM+4gANdp5VQZjYZOxtNzXMDtip2HA58NqQzpqhlxZo6B?=
 =?us-ascii?Q?/xgHHMflXuxI20TBANsbe4W0xXOqLR9z3oi1s8Jb+nWKKkAfqzofLMUoXnP8?=
 =?us-ascii?Q?F5vND8dq8k2BDaQlJi2lMhUJmhxaIXg3YLI+OcJWgVxLLIgZVRxsJnukMqPK?=
 =?us-ascii?Q?OqD2/wHSlA0lRB5ebqrjdCjP39v2BV/TLYyfMH5iprnRuWa9sPuSjLI+PLr8?=
 =?us-ascii?Q?RMd2RLBvAln16sVqAgYaphJ9IFtQvWzj9HP1yjJ4eBf7R5vBNYKw3FGQZc3w?=
 =?us-ascii?Q?ge+1P6chtNqyWZlVRjW5mN76FAPxqQIyiWwW0InSqsGYpD8P1r61HDiVv337?=
 =?us-ascii?Q?REkLhEgbhZJI9XcPDQiNc6fF6HZl9KgCehWS7gv6uF7VbbDSctcWPsLWaHF/?=
 =?us-ascii?Q?MJaTIAuK7KaRHKHfKGdcqj1KxvG9m5VqXElWbfX8YLEK8TbyElWXZ56/rrXX?=
 =?us-ascii?Q?9Tr3Pgv+C5GBJc19ZeLpp0LNOmv799I/eTti/2O3DnI68q0NXiAtLnv59tKn?=
 =?us-ascii?Q?LR31/MaCtZW0zFvFxUMiTssKe8cpQAvNqsU6ZgDHgUETHnISNTLm6G1n93sf?=
 =?us-ascii?Q?jNZYw4jEdIzJfL1LL3QEewXOC0ASJtzT6plPuJ8zIldsUiY3FiGBrdzqNoGW?=
 =?us-ascii?Q?2vBEbG2waqD1LpnRXA24JVNsn/bomXvKQ5ut+3gymQAjPYXh6AsaoDjMo9Lh?=
 =?us-ascii?Q?YZtfu8eAw1zZ4XyNThH+1fdG/H5D8Mw55pz6ObY1ib30NiWbf4WQjChsKgVa?=
 =?us-ascii?Q?iyfieyNjBtpF74WXXGHjcJoX2RCf9ZyqMKMfkIca1NakLSd+RC1NmQUmeR25?=
 =?us-ascii?Q?W3S8G6v2WepzhGJpcGsy+ll1nUcy2SJ2bttAchsfhJx1MqDh7IRM/3gcVk6/?=
 =?us-ascii?Q?H/tYM654XyROhb0YREwV+WMzCa14dtRbnQZZJNfL///FJL3vgJHnTolR8alb?=
 =?us-ascii?Q?O4C+tMHbcWHrr1h+G4q3yyZ5/qM27M4rOVPx1UnOMqys9SzZmnNOd54Ddmi3?=
 =?us-ascii?Q?g67Twco3ycIAXvH01ij+aj40FnpRvXYMlkkVYcidWABzBIp3WTlYAAWCgEIf?=
 =?us-ascii?Q?m0uhdbEP5UYM8X3p5gGBZ6+zcVAY/hCB/5dad13i?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97dd34b6-c3b7-42e0-f0d3-08ddeaed6cbc
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 13:26:01.1142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSpPnOIwb4+OxQm7U8fYGks9v3GVwDfCxt1NPN5CUvKLNuEEzFZKWpJgHABYUSouUv8gEvLNF+uMtq9RBpdIxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7229

Change the 'ret' variable in tegra_sha_do_update() from unsigned int to
int, as it needs to store either negative error codes or zero returned
by tegra_se_host1x_submit().

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/crypto/tegra/tegra-se-hash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index d09b4aaeecef..4a298ace6e9f 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -400,8 +400,9 @@ static int tegra_sha_do_update(struct ahash_request *req)
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
 	struct tegra_se *se = ctx->se;
-	unsigned int nblks, nresidue, size, ret;
+	unsigned int nblks, nresidue, size;
 	u32 *cpuvaddr = se->cmdbuf->addr;
+	int ret;
 
 	nresidue = (req->nbytes + rctx->residue.size) % rctx->blk_size;
 	nblks = (req->nbytes + rctx->residue.size) / rctx->blk_size;
-- 
2.34.1

