Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013007.outbound.protection.outlook.com [40.107.44.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFC22EC549;
	Thu, 21 Aug 2025 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786070; cv=fail; b=l5O8ZT7mKaJlowzsxNQ6+Jk3ZyupWE2dccep4p18ovze/wT8M+9IriwpQOOm1HqTLYJhgFBmUq+m9b+BVpAxZ4qCGZR4ZHkCJjlcru/OTT4kKVX+1almIJRgW5lsETskr7093MO5CdsCVqX+p/dE1QDTg93DYtSblTNwk11h2Mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786070; c=relaxed/simple;
	bh=ZY9lFXlN7cnSph7H8Cd538cOO965Y2hAvby77rPRtb4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=AeeKDkmCwcIamANT7KCtYFw0O3JT2l3iMlp4p71qxVXBho/qIr7nQwT5VrWVuiXKmjU6BUYITbUwNqv4GSIvCZlWK6meUkAy8kHO3716dRXCYFS/sEcU/NHDA2j4RdlylafIvRkSJM3ADqbB7Wm/EbaV+2bbyKocguBItsTs08s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=omSVVYzR; arc=fail smtp.client-ip=40.107.44.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="omSVVYzR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nUkzoxmI9zfC7+lnFSjWkA0euXzPjWUrL+kCl78ldWbE8V7rXw6t5d8ibD/CxWJdHzq0xXD1rY3/tG+W3uD7y2DvSI31AmKrF6SRxhLvadbYgbo4XSH/f96CtpviAeTWRjJ8LVZHM97T7S0MyOD5cE7V949D2cDhUaOOCH1DJ5taS1dApfl70BMJeZ52mofk9s9+3AXvF5I8HDXL2oIyKDvcZG8ixIvKXrHTtXdIO4BbArb5VMQDFKd/MzyAH+m/o5JLdy6PUa/JkJ5X35SDoIRWq6YJCWj0lwNlXbaavF5kj7J4nuOlK+LR+w4e4nGKpGO6j/OjfQL2h54UsdG9gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZXvUjy3U71Tr2aCcEWpsiVs9lZHD3IASNQvYaDy8po=;
 b=k9aQ+9LauJeAZsYvtPjkaiM43QQzOkpQGqnxucklYbjH9/GaMr8i02zPXDUe9AhZUBULkyXmsL+ntAjJQAXW9YG0r0WS1SnX991M8iZJA8SjWl7d9iq0nLuC6wLS7pl/d7ml17Jfa5YrC3brPpQiAb9yJ33iGQV/WeMeGZ9zrY9egS/m3EkILrgLnOY9DOb6MEWQxuiuZMWBexE0n908ScudKuBhTo8F/lDGuzpN5vfWZcWoH4pNvSzcJCK3Gn1l0EnSMwvh7NtkLDe4csnvOb4LbLQVmJPR8ZYNL2LgF3gNHqaOsFcfRDf/jjEQ0Oo1J7W7nU3J3/zLgTOM84SGMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZXvUjy3U71Tr2aCcEWpsiVs9lZHD3IASNQvYaDy8po=;
 b=omSVVYzRvkT9GgtUTgD9XOe3IIuKnqybigPBvaP47Tk7CfLSn5MK8fuKMF0EzVzevOgNkt7+peSWXT9Y8qCwBXDYDiSicsiI9SoJ1l67ueRze8KOWzYBPtbDiNucH+4/WNvvgnWf6nrA+BrkrR8o5t4Vl8mt2R0ow8lHWri01Gd2f66wv9NyonlcKCs+Grh1ykTdd99zuU09UxS6mRt1xtVHj9PHQPhhKSBWreKyQAfPV6EwZCkeRVs0yfwBYqMQf6TJFp4B1ZcrvW/n2NJYvVWeHq8qF5v0hgC3iYNS7nvRtn5PumbpVDhUgTyS/0vrB8xR8QOL79lXHM2cnRlVOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEYPR06MB6011.apcprd06.prod.outlook.com (2603:1096:101:dd::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.13; Thu, 21 Aug 2025 14:21:01 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 14:21:01 +0000
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
Subject: [PATCH v3] crypto: qat - use kcalloc() in qat_uclo_map_objs_from_mof()
Date: Thu, 21 Aug 2025 22:20:26 +0800
Message-Id: <20250821142028.33256-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:3:18::36) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SEYPR06MB6011:EE_
X-MS-Office365-Filtering-Correlation-Id: 64dc0c95-e9d4-44fa-e3f3-08dde0bdf45e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|7416014|1800799024|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?buMrYaYK4yaJU4UMmZLhny+3FfdBrKUd26fz0ypYBpmqiEf6LI1y/sAJaCpM?=
 =?us-ascii?Q?CIUgzIgEbTRbm8H6L7yg4CnZYftV2Tc0VS3D4kBvujxUU//zGwaesxo888by?=
 =?us-ascii?Q?VDeYtymT11su4uSn8qO+rcBKdQupSSb0NAZo8Jfeu0dTKri3m+jJ3M1qMEhV?=
 =?us-ascii?Q?0hp/34jNSUm8hiQ4M+o9vm+6YVpbMZIyc3nV5Fg1RsHDHiUbaJ28VLK0Oz1J?=
 =?us-ascii?Q?ExohGAgsTP1qIfGOBqh0hC+jQq0pRdzGNzCYhVrI8sT5lwDt6u04FpEfV6wk?=
 =?us-ascii?Q?zOkWFRh12fra0Q6jypNaZX1LaoKGh4ZlBVc5z09xE8CdpuCCLmggSxLBKbXz?=
 =?us-ascii?Q?Js7+9K61i+6dsjV3F+yVZq7ckmQXVp38CUlikiTvg5xkE8Y7ZdzjSulGEGc8?=
 =?us-ascii?Q?SwbmqikHMlEGQAWd65PnVQoMZKxVtwZX+BqJoc46OWVM4MH8j/+POJUW/NIP?=
 =?us-ascii?Q?b80sLNv3vjzkHaYHwPvwBIAPN/enPGWrjNvSa596WhTQvvzrKTeUmFtc6Xzk?=
 =?us-ascii?Q?uQaEi18xAllLCxFfYxyw5QY/KHdSifsbm1aB/9209AXHmljCM3uWL0iniXte?=
 =?us-ascii?Q?u4GHGTr7OoH3l0k/lTEEd1FuC73YK61R08nWyYAeMTpHCLEf/QPqiaWFy7db?=
 =?us-ascii?Q?rPkQjggkjydJa9aUxVaTUDAvvBsvYHLNbWOPQPkMF/yT0zcgWVS8osuRhkCQ?=
 =?us-ascii?Q?JrGkLpjvOaAvUNVaFZyBWbcA9ZBqCKckcwTpC1iS9LSBpQscw0f3dzxNJ6aX?=
 =?us-ascii?Q?53GyCm4Uzpv1GQGtw0FCSpLlUppWk1+/Jt5teqcEjGHPU5UUBTugk2JZcUGN?=
 =?us-ascii?Q?Jm0zu+1Ta9AREkmgIRMOrZ5txIxL8kNQ+Fge2dqLYZHF5qNKYDkzqMafjsr9?=
 =?us-ascii?Q?6WeCBpnDjYoGhDjlgAG6oOkGYk/j5q+bQDPbLfdeCT8ZlYmqJyAan/kvChgu?=
 =?us-ascii?Q?RntJmXkBdxVjXYVlmYSam75pPiYFmGi6Gez2jbbGQf9vx5tA5anCDo5a46I8?=
 =?us-ascii?Q?vUG6gw4Q0HYDFo2QLmC2ACaYEFN/v5PMmFU3a+aqfZYrmNhnKsn81+XKi7vz?=
 =?us-ascii?Q?fddg0McvqO17abDOdMyiB8bCUG21uq4IYE7VASo+y/Sfo1kyjIbxZfvBTEcS?=
 =?us-ascii?Q?KYY/zVxb+hR7LYy9uxcdX683lebH9oyqFW5gWAlYj2A9OhSOnufbJF8n/OqF?=
 =?us-ascii?Q?7NJkQcxLGl13s2k2DJPrLWZYm4KKOtI8BRUm0bNOIzNn95SMdyggYyxiaFDj?=
 =?us-ascii?Q?ftnIH/ZOZyxtuS++iEjtTf1UDddWTajU8i5jcWawkPgAllQzvL07JGB19WDn?=
 =?us-ascii?Q?09TmwQlOVhbuhMhTAEHVl92uyQW9Bpn997s/nWcF7o4gHptrvtB7twh2Q25R?=
 =?us-ascii?Q?mGml8AiJS4Zt0mrGtPbtZAI/weQlFZtjlfBz9UfYLnmSDX0G2lvMFcXSVPzg?=
 =?us-ascii?Q?+QoRSZTzqcU4Q2g0nBFLSJNAn5BePN9GtmmwJ86+4JbOgs8uzhfL3SNPxeX4?=
 =?us-ascii?Q?rjMRBr7a2NrQHN5fpEE1p+yi2Zf4NWIAsnVH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(7416014)(1800799024)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?688CA9pjxqclF5rahVrJQdLLQ+231+YCnHrNmY1rI7FZg6YlhX2Kig8e0gBd?=
 =?us-ascii?Q?tkCC2MXmHuip9etO0HwY6ZJpqlRwhYGBY79X9TjRK4A8TW0IMxEILQM1660C?=
 =?us-ascii?Q?TvqcCQRuoHZLFRjFI2d2T3axtDTCjQRWmTsbyaPbcjknIc3h4dfMkS78vI6v?=
 =?us-ascii?Q?W9nOGzTQsg9mIcPWsWVLgbAoAaN47v6vOflw4OUc7azGA5gUoN6mzjQayQDn?=
 =?us-ascii?Q?hwsaN24MPPbFg0EiZxZre2lEyR8N52V+78m1+91R7wwD3ezb47FUm3oQs31I?=
 =?us-ascii?Q?/Gnh8WS9v8G7rt4fgpqTQIzKa0Ve3S3GtfhczA87Xc3HhMA4QCywGhWNJhO1?=
 =?us-ascii?Q?GGb715fk9WzchA8ngQ8TCIhU4lxtO3gUcki0sG0aDLnAbH1c4CVU8gRbO8su?=
 =?us-ascii?Q?ipJzXDvyQ7kETqvlNqlH21PCXcPLbSloPb5U/frm/ffjoJtYNaa/T0YjHNuj?=
 =?us-ascii?Q?tZaSoBJcVkbqosYu34hIoua1e4khbtCeHQeTAXH1wKF29yfePizJ/WYJnkXe?=
 =?us-ascii?Q?2xmaEfputf+mBsdt1UKpvWZIJbWbzhGN1jMJ/NY3ypw/nHXNFg9BkFDWy6nC?=
 =?us-ascii?Q?TeyAL2qWPIL5GNZw1A0lebLbjKbweFhW2PqIrPJcnHGo2c3wwYQHnPx8ydFK?=
 =?us-ascii?Q?ad6ga94aKRdmJAGXorM9usyFGB9DthcjtXl1t/kfgs6z2niWqZsnNmYBRjvN?=
 =?us-ascii?Q?4diVyf9+XO6U5luaLS1bwEvbtTNDaFD+TGT7bKxOAJrlfejTggdWTJ+oZy5a?=
 =?us-ascii?Q?2aGk86uWWF4AVpIQ61k2jXRxeVztL81sMdJNKjicKPjbeQWliUo3REypSezW?=
 =?us-ascii?Q?0YBZkNbZR7sbo8IdUX0zXByXzUWvUrxjIdBV4WZ82cz0MvjWB2QXkl0MjTe1?=
 =?us-ascii?Q?GI0R18HqqxeMW+Jlmc8tiTWxsOgWCycECIvXGVyNH6e94vdiH+yOs+bniB96?=
 =?us-ascii?Q?IahaWT0NdfTBZFhnmllMzZ1GFAy9RiCk9R4QGaH1JmTkN3Yla39gG+zxeU9g?=
 =?us-ascii?Q?GSXk4XlJ8Oc+tQ/QGUkx5SkovKsoCQ8D60VUKXvyYT7WwjTGNqrP9e31bzuR?=
 =?us-ascii?Q?Q0bmpZ8BIxyaGEut5693URjhj/TJd4m/EcASEa0AFUw3fJ6TKJsf2i4DPoXo?=
 =?us-ascii?Q?oQg35C+CHR2PlDc1a4ogY205tkZi+hA/QSzLkIWgFhr+uqaXYcpGqAJlXI60?=
 =?us-ascii?Q?oGtBHkrOkj4cJgoa9qTEWj13YMxmDK1NHyIyZiFCUpe/RWrAqdZCUv6QavBL?=
 =?us-ascii?Q?/hg6pS8R7lH9IRj2+7CmKzdZdyKkJjdiojUA+TNHJrhwMxS4Ar+oVlPc8a7m?=
 =?us-ascii?Q?JMr3qYEmwCNHpwX3PlLNjjGN86rhndN3QJnSa9H0gc+SkbXD1v3+ZM5hoXMQ?=
 =?us-ascii?Q?o1xFFNuCOk2aD8Ce2oA2Ztqu4SfpsD79UdqhpbrN1kSzKs9dHM6qqLAm2pG6?=
 =?us-ascii?Q?9c3DTrchbRxetULS/xzytarTNzyaWyqGJP8VFMFN/O/1JCMrCai7Vz8PTFn4?=
 =?us-ascii?Q?33fmZrOkynxphpf2NTXnzPNb9eYIIsId27OSlldEc4ZLQNUcIzePZlItaieV?=
 =?us-ascii?Q?cHu6lzLwWxiD9hB39FsJLdpJtsu5BMI36b6KZnB/?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64dc0c95-e9d4-44fa-e3f3-08dde0bdf45e
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 14:21:01.2390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZpIReEybUnMQuMTkWdBLuw9yDhx93jJLQciMcbD2VJwUUgLftmEzIyX39zDgm8rWebUEdFwDnF9zLKgg0Y5XFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6011

As noted in the kernel documentation [1], open-coded multiplication in
allocator arguments is discouraged because it can lead to integer overflow.

Use kcalloc() to gain built-in overflow protection, making memory
allocation safer when calculating allocation size compared to explicit
multiplication.  Similarly, use size_add() instead of explicit addition
for 'uobj_chunk_num + sobj_chunk_num'.

Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
v2: Changed explicit addition 'uobj_chunk_num + sobj_chunk_num' to use
    size_add().
v3: Revise the version description to keep it consistent with the changes.
---
 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 21d652a1c8ef..18c3e4416dc5 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1900,7 +1900,7 @@ static int qat_uclo_map_objs_from_mof(struct icp_qat_mof_handle *mobj_handle)
 	if (sobj_hdr)
 		sobj_chunk_num = sobj_hdr->num_chunks;
 
-	mobj_hdr = kzalloc((uobj_chunk_num + sobj_chunk_num) *
+	mobj_hdr = kcalloc(size_add(uobj_chunk_num, sobj_chunk_num),
 			   sizeof(*mobj_hdr), GFP_KERNEL);
 	if (!mobj_hdr)
 		return -ENOMEM;
-- 
2.34.1

