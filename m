Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013031.outbound.protection.outlook.com [40.107.44.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08519305E38;
	Wed,  3 Sep 2025 13:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756905964; cv=fail; b=KKq61GPQuMYk2zLyS/L+vNwuTnWd3JbdAUpdO/BBeLlTK0CJ9z572y74IivnXkJ/hec/0fIs8Bk0VEcmfRAaY7VeFx4K5bNnpQOGyc6nBTpyGVje3iPpnNujmyCc5JLhmmxz3H7235bKjoBzOy9VHvBKYeieZL+SmBGiTdywFy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756905964; c=relaxed/simple;
	bh=+YtUKJ7V/3OHejqH/4HgIbnsh30rUERKy6j35iJYLMo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I5ia+As5A8lX3J2Slz2H0PpRWPbyBj3vTbpDn/CwLmWELLgPkQRWUY5BBTPh7Z8j0IIwqBrb/lK/dxRATFCNJwqyFiqDDEO905q4UuM5cVTOQ98Bt7vRcbrVhtCbpVWT3NDqwi7Itn8W3VN0wHDSyws5o8n0tQPgqKRq3XwlxHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=BDyxFlLb; arc=fail smtp.client-ip=40.107.44.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="BDyxFlLb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jx1ueJEVX66kmAZam8pSv95RPxNsm6TJJHP3BTD2ik3LEzP/psR4fdZhjqYwZeSRTjOywHyLALTO2L2sTqD939O3YMNANz6nid2zF9w6EQjMHVEpsYblyWN6h+7pHWx6T/QAUaDpg+YJ3kBkoMNu392j5cjZdF5Inw4e01IQes1J1sjSeje1jh7+SuJV3Ih4gxtjNHDAAxghPVb3yI0M5LYGY7CANinniAiirMlcqVe0R3U7nrqo6DqTPFNo6gSs5bVWGAiVW1UUqvfkuaAABnmCq0daqPNgQVRL0Gf5fpp5SLkljzDf9KLgDTSeWNI91SOfKLHsDDrGu9sqKhXWHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eS7zMCyxUn15H7LZsyMvThroupPp49+F4hQWLqOklmA=;
 b=J9OOqN0aHCsOG8A9dodcGESJiKKzyGXH2AIUqvyubMyCUSSmvtiRu95y5iUnAYi65zhxcp+oLh4777jTgpuSXdwjaMzU7hmcTVMpZRwTEOQkFbyqlj5FvpT3H+g+3JGLGfNOzAPSohoQ0pWkRbzQ377p7nKxrywCaQoSepf4fPwS2PzS5x6i1Pf6+GMRNTKv5AeQFHyVa8hmZXu5M71Z0dKNPIMAsRAjC9Xd+zcSLbFHOPrTme9CeiMP0FYVorpR5hAQq88B9QqW/bskw003a2l0qO85CwHpJ8ZJwkBQcoxzo8BA2eJgSW7ARlbciY/o/TFNhfgzpmbyCGenf5fnhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eS7zMCyxUn15H7LZsyMvThroupPp49+F4hQWLqOklmA=;
 b=BDyxFlLbZApbZXkS0PnqSTrNJLHSEnqHzemITlutOlt8JiVW2z8uddjRq6egFndgpVwMmMtSzCaem2OfK1/sOS0S2x6qucUoqsapQbcXPbOWdKaj4HdHtaHADOdD5BR1J9cxWm68VC+DJuFKRD7gvhkj4XuiXLqRuBsika1sSksWFWQpfo0T+UNLJ0yUm16gqjdYc+Ra2FiV2SGKaoywX8JANAwBGLyOw/4BtnE0T7g8e+DvVNZaUBtOURfwrwuLN7TxoPn5OtjqG0nBnHMTrkMyvpU7qC+oeF6Q260pSFLh0yBDsdBSe/WLj/iNat8wJFAbOBskAOVZOLGOs3C6/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 OSQPR06MB7229.apcprd06.prod.outlook.com (2603:1096:604:2a0::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Wed, 3 Sep 2025 13:25:58 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 13:25:58 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/3] crypto: hisilicon/sec - Use int type to store negative error codes
Date: Wed,  3 Sep 2025 21:25:36 +0800
Message-Id: <20250903132539.416439-3-rongqianfeng@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: d34a573a-62e7-4ef0-4475-08ddeaed6b19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?weKo5Q0O4UMA53wBfvpBUqWiFndsu0R2QiI8Y4C7WYG5FO3mghB/Mf0Vazh5?=
 =?us-ascii?Q?CQyrhlc3CVohqlO+Us7YJLr/HHHZhmumvz4X6PX+igimGjMiRL6YqcK594k5?=
 =?us-ascii?Q?mDzfCFuUHoSjZ8LH9GhE4YLaz3TaoyAK6poI0QEgHc0BiDj4FO6fOQpkTfm2?=
 =?us-ascii?Q?U4wYfQ2w57SQ1XxL1kcMCRPMSFNk/RQEB40MOOPqp252JTL4W89nKHAD3PuH?=
 =?us-ascii?Q?x4sd1WElftyBZooRZv9gu4bfXJpS76OjFWOBDOCsxgne1uif/75pGYQnrAHV?=
 =?us-ascii?Q?QeFfFP+rQZSDUQuRoIMu2SLrFmDYCLiuWxKxjRZXbBxIxGYXar3ZNiy8YHe+?=
 =?us-ascii?Q?7tMo8bzwkcHXz407i2P9aY0/9dDboRiqKRh0Az9aGYiW0y8XfV9zguWsL1rF?=
 =?us-ascii?Q?Fn8ExGiaVby9xYX7S3AS56EkGjcqKM5FaBpc5z569hatEGf8SF1aPFe0wnuD?=
 =?us-ascii?Q?OSop2GO1tp0V/2E2eB9b2LHqC8VpE8L86JZ1cuXX02W69ysIlDiBpre/lkey?=
 =?us-ascii?Q?no6EUbIHfMumu4HMe5kRM/MFdRwIuCpf8GldfsTqh4Rn6wH9mkxufpr2xdcy?=
 =?us-ascii?Q?CCaaRlxaZOZwa5lT6KaZFs3gGLHrq74M+Gt9Ic0ihvnyjouchA2qBXNIMcks?=
 =?us-ascii?Q?6H5xRio4aEc6KSECYMLNnJFlKWfU+ssvO4SLD1+ewv9+D1QHGrZR282SLIYP?=
 =?us-ascii?Q?jTgBUQDqTGXxwpgWvEoY/x0M1IuCle3EXvREwuzcRDnnij2Ig8BbYkcqojCh?=
 =?us-ascii?Q?ZiXVbdQfzJjJOJP+l3QNa0/eORQNKaQ4IP7SRXIXave7vIGtDOmLR5BmmlIU?=
 =?us-ascii?Q?QEOsDeP/VV6hJrwvWg8lZAaAvFct6UrNoTYICOs38J9k1WHkCaN2nTalv/sv?=
 =?us-ascii?Q?lSFmtq3eMMZSz+WL1j8dpUpaH6lXrlXo4UNT4PtO/A2v7/jBU2mcGPlCHpro?=
 =?us-ascii?Q?DdmyEVRjIFeg3HRwcae0MqxE89NwzGnzwfVJr0jFdMmDvw1yWrnRL0BzemTk?=
 =?us-ascii?Q?bZ4miWda1rQQFM3ipjsljJdSd3bVyQULPv2SSZY8wmhi9i/Hd0YjvPn3vEbM?=
 =?us-ascii?Q?rgEFa7MUgGYzm16vlKIxWxH56Ric95nJ0Fk3SxRuu1ddhFtOERHFkB4CDsCM?=
 =?us-ascii?Q?FpoLl+PLCY/QvUZP6g/MYF/A1FOWzlor9djAnhilJbLkZoOBxVWv8/6LW/st?=
 =?us-ascii?Q?XAm+Xk5loz3mr/r7NjK0/vBF6zmpU7us4VuRItQq4vT2l4mtYqO6vV2efA8X?=
 =?us-ascii?Q?oEe3gZ6TbNIecBcB2lUHzjDxQLpgKxpt9ArrrP8li6pYB/VjbOWk3mwaM7So?=
 =?us-ascii?Q?yn8vJTGWNSJ0Sc2kTfYodrsIsXnxq8te1QGUxw91bdVgZATqIGn0W/zuqtVh?=
 =?us-ascii?Q?qHX2/t8JjAUJt0K1WjtBXP5+f/N2YNecAwAgaHvzyPHrHL9eHi+q2EZo8rGk?=
 =?us-ascii?Q?QTybudXqpwxUkXmZtHKqISv5E0qJ/Iv+lccPsmnoiwgiiexSUeKM3Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1y9KIWajku2BJv3WQnDDcwgT/wZJP3NWxQi/Md0Y+8IuOjbYWkih7Zvz4AR9?=
 =?us-ascii?Q?hwRFgJRKJkOInc0mUXMjJNvr+FEaFztxUStvE0ErAjcfzGLlE7OTJlvDUqH8?=
 =?us-ascii?Q?f7xfk8+a/DMQHuXADAtXdTVJlkm/qBUhz5acaynkS40qKlklpjx0knvPjlCU?=
 =?us-ascii?Q?9lgpEYj/CzB6pnu0ImakOsz3At2nuAKNUNzMpGHKrN3ykvW7c3LqUKYr8F5g?=
 =?us-ascii?Q?PF12Fxri6dF9B0mAhBFjmcFZ1U4AVsqu58/h/UGIQCyPY7Q4JZCwlNgjqgee?=
 =?us-ascii?Q?+yMIvhIl0xjSKi2/paPUjRRabrR3ObzmsUPnQcQY824JO9SoTHftnTdbZizF?=
 =?us-ascii?Q?zJK27zIvzCG/uOpRFQP9F8w9KNlpYrb3QLpLmE+SWTV4UmqamC6WLbXjLVeL?=
 =?us-ascii?Q?obZaeDVx9ki5UV4z2r9R0n3kuRKt6O+mFt0zhYu45jKGm12f7+6vaIhIdREn?=
 =?us-ascii?Q?tevokr9HK8YKRMbKxhXev7rNLc0PtEniK6Sq76JAYS6ypGrUVVMQCy0WQDKv?=
 =?us-ascii?Q?+5AU7NrDjnTK2ZTUl/ZK7EPoiDwXk1QYFEMhPwmM3+GUvupt1nYKu75MP4Da?=
 =?us-ascii?Q?NxTXodgn42tdkgy9iOTKkK2fMzk3gtOb8e0o471ClfFaTdu6aBHSku7JaPva?=
 =?us-ascii?Q?DiI+xmQDeGdqfSCkaGrSYkZUO3Ikz0bEQyVadLTY6V+2Ejl67BXCIKCIOczm?=
 =?us-ascii?Q?RndHp8TymcRgsCuNTvZ5KQ8xIcRfneoTuKmm9/z5uYfyvdDdikN6rwQ5CuA3?=
 =?us-ascii?Q?h4isPO6wsaDNMBrvLef/nYW/qUUTFSsfMPZFDARJYeq1NW/cm9j+gEIKkr1V?=
 =?us-ascii?Q?BsFV/z2qk+jt+As60NIoSXNY5jZypUxAV4fGF7yEUSgvyoosGTZ6A2u3+4Co?=
 =?us-ascii?Q?uEOPBHCFsFFJpPWv8nUCr0V6MWi7q7cqiGOtCYLVLSDjde6Q4/+MvKMhwu4G?=
 =?us-ascii?Q?uHWP2Tcoo+VRWY39iLF4HgOAx/1tOz+s9A0/rSNs8bJMRnFWDHEI9wcM+2B3?=
 =?us-ascii?Q?8gNbarsRvkgI/2uMBBGWckix8ahTpCZE4lfHg5+FbFr/aYeCYVbx9C+5FZqu?=
 =?us-ascii?Q?dqSzNiaTwtFzkSyEel0H+5yeFAYAHWW1EC1zfV4J9UGfMTuE4Ko9CCzrvtCj?=
 =?us-ascii?Q?rLUhKm/51uf7qI0kXqkOG8Zp8Jmaa35J4khfy9rJkf19BPNsMJx1J3nIRU5m?=
 =?us-ascii?Q?pk5iCxJhPV89aDAlNcFuPs8CPzSoVKq4ApvVnjrOovWQrPqJGHIhSGqHstEk?=
 =?us-ascii?Q?JyiW/awsj8G1g7tXOY5QWLJ9g2zXHPtxYHW5cCwrQ1nYeG6G/R+N/g9J355m?=
 =?us-ascii?Q?Vzb9nnS1ndMWWx17/jh1xvlxY09ifmQdpy0M0ogOxq+/fufvA5QA5sndncKf?=
 =?us-ascii?Q?BA/tmQa5HmLMErOMiLmeQlUoM4T2LmydwckGjHCgiH1ArZiDSH3MthOP8v0W?=
 =?us-ascii?Q?qm27nnthj4lTIw4nv6AE5nvinQGN+OnvA/a/nuVPC3mlGw6TmcnXG7ovdep3?=
 =?us-ascii?Q?io4mvhZkXY+uHGH3AHNbUNm6zBctIFPtSOGX1MJ7qJPHtleJcWrV+IaxrfvS?=
 =?us-ascii?Q?7zmiZ8liqdwrAP6p4I6D43nmNQrkvqFbY4ovlvYs?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d34a573a-62e7-4ef0-4475-08ddeaed6b19
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 13:25:58.3565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nUWX9sfFkHTwJ+FF6jqHuCD7ZHyjt6d9a73ux8h3M2+hcAX9zw/7JI0SWhoymSOKaTWTLcFO0VekXhAw+wOADQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7229

Change the 'ret' variable in sec_hw_init() from u32 to int, as
it needs to store either negative error codes or zero returned by
sec_ipv4_hashmask().

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/crypto/hisilicon/sec/sec_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
index ef0cb733c92c..129cb6faa0b7 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.c
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -922,7 +922,8 @@ static int sec_hw_init(struct sec_dev_info *info)
 	struct iommu_domain *domain;
 	u32 sec_ipv4_mask = 0;
 	u32 sec_ipv6_mask[10] = {};
-	u32 i, ret;
+	int ret;
+	u32 i;
 
 	domain = iommu_get_domain_for_dev(info->dev);
 
-- 
2.34.1

