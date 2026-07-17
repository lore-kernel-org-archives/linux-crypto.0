Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013016.outbound.protection.outlook.com [52.101.127.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEAE3DCDBF;
	Fri, 17 Jul 2026 08:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275330; cv=fail; b=iEXHHRMQYfIKRoah2jkTyheFfBjOxB9zl/kXF109HZUz8kOPu4sKbDSRFe2pAyZr3JuRtDL/b3td/ic8w2Ty6AgSdyONYv/aXN0Z5o7uiytass81/zSph7/3AmNttnXQGlHLsJ8onYsnW/cuyGm59+UOWTHfc8mNImoq6zl2zUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275330; c=relaxed/simple;
	bh=+rE/dJvEpsyJA3WJdK1wyPh4kucp+axkTYhrkAIFsVQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LppGz9lOdhxSv5MDThG9b7Onl/pYhKRXStbYuNJZ0BdzcUSK/cfiuKoL+mHmBfV/OpE8r9PU+4jlptCmE3nzkTTrIuNJzkBnc3wFPGwJoQi9ovC3nayLyRb0vb+vNP5QYcF+12/gp3dJiPEhluF4DgeR5zl7Hc383b3+ma5t4Sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=HPpFsdTE; arc=fail smtp.client-ip=52.101.127.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="HPpFsdTE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h03D9rV95B5H8rwuYoEqDYYy1KE7O9n35qXG6UgtMx03QKVP3RWVH4oHqy3ym20Is17AjCr4Gqp3qz1m32wdnnHfRJy+4q2RZb6nnO3eipjZhkYTewAsmwZtmtaKEko7o+NcVKPl4Cly9rfa4AoICAXdUpg1Ed9xz0Mtq+75IhFpMkwDg3gy8tGga9uySRnJG1gca+p2Axs7X1kR9fcVDxkh+6qbpu3YxoMSrHe+pzzVM/6iIM5AKU2EWshq9fFgjRXKB6JnLIqQLtgrbGemUruMKWDxO5UbLNPMxOIFd3t6g9OBvjK68D2cDEbiyenS0hPgLHqjbLa8TsKsoGHEoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q09TeAepP3AeFTMHfnhUGpcWGUrt7eJz6dLPfLeuXlw=;
 b=PhXRHXC5YM394dL+lDA4dbXWYXm2tcyB4epXhRj9Z/q45kjImvZns0Otu3c4VLMn8fy6404e20lty6iis1OFURIZx0ZUEtxFROsFlsg0FV0ypxUkslwQJk2psLXIZ0LUgVipy7yZANFwp/KfqfCYq0918TrGgRCkXIhSTK+GskLuyZqYyJNZKifZW4o1+Z5noCZq2WTNIVEX8fTkquWtYyJ9sY1UNZC9p3zw2bErkDSM+IhrsYQqelciN4riCyt9rX2/BuaNogNfvLYOdzALuWiIYB+3zXbS7L05qfK1ueof3tq21Sd8hKot1srH0VbmxA4NQI8i9j5ERalYgzquog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q09TeAepP3AeFTMHfnhUGpcWGUrt7eJz6dLPfLeuXlw=;
 b=HPpFsdTEbpFOYGyn3PInguq1gkWnfHJ0W8RwDcOqlcGD9Js7bStVIfBxTZLoavXIEX02m8r6feiy4Hs1VbR/LDNyMz7oWpWSvBAogYzH/+I/gG2xU5HoA9kDWbja4qfZ4f8mJLktndBa9pQB3+InpjziOEbmh6rqdevqkeMWDTrFb9F6pZbv8nznyODzq4N3UBGrYs/Ra0oQO4r8bC8Ludx15N/MJDUIwvrc3DC6CQEI4LpadK33AZbdHyESJLkgft9bz4fMvhaXd5Axylb5737XDOqeSNCzqSG6bRLsu6KNSr3uPyBb4zZA/ZTFDaIqQjVs8hKWLJ0IN62cWioCFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by PUZPR06MB5620.apcprd06.prod.outlook.com (2603:1096:301:ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 08:02:03 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 08:02:02 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org (open list:INSIDE SECURE CRYPTO DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Pan Chuang <panchuang@vivo.com>
Subject: [PATCH 08/12] crypto: safexcel - Remove redundant dev_err()
Date: Fri, 17 Jul 2026 16:00:22 +0800
Message-Id: <20260717080045.191538-9-panchuang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717080045.191538-1-panchuang@vivo.com>
References: <20260717080045.191538-1-panchuang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0054.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::18) To SEZPR06MB5832.apcprd06.prod.outlook.com
 (2603:1096:101:c8::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5832:EE_|PUZPR06MB5620:EE_
X-MS-Office365-Filtering-Correlation-Id: 08ab6b64-7d06-48c3-630a-08dee3d9af76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|52116014|376014|366016|10067099003|38350700014|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	W5SuzATqvY7nDaAp8B0lURcII+6sAromdUkVd77xoptV05bKDffgtcfYLUnWMNuYCyMUerStJv9dSCh59Pp6/KnX7AeXyPrf8HYOm4TKZ00WygG/sB/3tu4WO04Nm75913DlR/rd8/P9GxWB0hObJKFG2yighWUXHCAQTDT3BWrYZapopAHgty5Z4520eU16l2Si3yM2NsgJ69R90BzwwxesnmdsJsao1Xy5xBko1B7TqWktOUFvUKBp48IvAxE1qf1Uib02yt9PeGLVNp7DbdaU++EU1bC0HGDwkId0+sbCu8p871nR7HVdcoGAm66MMH1ERN8aI9SSmBRdJuqZ1MbNnWND6Np+Gq2pCHhRqR504CofAqrb6CwExRwMKJJh1+4a7W+kXPIgdjD9iNrgacl4CSxbxtVtcAhj1bLOJj/M7naAxvi5fJ+xiFwdgALoutCx+IIWiHZpIOW5kHqxb0b7WsgdKPW4YnW65yoo9EvoWMAkQa4HTeQurGsWVX/nSArCSDGrfaxgiu24kzDaAey4Xbw5Ur3IzXsZ6jWvY6i2duVWG7q0v+GUx0IwMG3S7utpWVuFWWwsx7G/0I7EPHt2dQS5LEG0gH15g3m4sVPSbcTTm/1Ee/wCzRPRs62wF0BgRB48YWcHqUmxYq1AkMOOXTDd/V+BqiqNUvG6kRWJ05IOxNZVtmtXIoCW4CAdTlQz6tjp9nvBGNaNJgPZAaUuOepD55IEAALNZup7C4Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(52116014)(376014)(366016)(10067099003)(38350700014)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?44gg5Ve+5twA2IVMOLtez8t3FkcaiV6FX9R+SN58XBrfS93OoHxQY6CYr+AO?=
 =?us-ascii?Q?hpEt/DzI5CTxA3i8sR8SeCc48tHOk9BVwNbp4/fe17lHvpwKmpEtoJWuyRVj?=
 =?us-ascii?Q?ZvLlwv6oovPoaKb/jkBW/Cr+fjFuH0jnO2BHEXAWCoccROwd4gCooA6SKPu1?=
 =?us-ascii?Q?xd3YSHZKeU/QOM/AaggV/KQ81nNAWT4t+Q9McjvQ/y+am3vlVoVYwvmRwQZx?=
 =?us-ascii?Q?D1/wsGWNYHRtk/RL1AypVBkRftgWitrb/wG51M16WMx7MBxszfB5s+BJU0QJ?=
 =?us-ascii?Q?LaY5UBG0mBE/iDS87FEmVuyhaygcv1SS9cMPftDUbxKW4iVKcMc3eFMFzhah?=
 =?us-ascii?Q?y3ycXUMtToKzxaGH8YmahbumEheewAh21wtOpkHi3rJi4V29W2D3l14LBCQK?=
 =?us-ascii?Q?WmbXOef3F4xRtGFLyjd6gtQAoiCY6H4u3ymvfXl+0Z3ghommRMQcfE9ljWAv?=
 =?us-ascii?Q?fvXPTS4tMlcYypj5jYgt2HGTkfO8t1xPeqIZiArX5lOl0QbjpZaTfI2WN0no?=
 =?us-ascii?Q?sneGhN+UER1eE8RLm3saM1xMtgeaQ5VEGv5i9V0NCjvJRGX5bply7R7Pl+FH?=
 =?us-ascii?Q?Dk79CgPx4ZeWoodtZ39b3vyFl4MCIaKqkqHsWrsZwsiZHia5FTDlNCG8tos0?=
 =?us-ascii?Q?nTM33SGJgppRW+dccs376e+AaiR5EfuQLzE8rxmpI364SCs+ihLUCg0FleYF?=
 =?us-ascii?Q?B66XbDeXwsh9Rp/HlEYCNoR66nYDtome49ENouK0w4x+CegovKOc72FQU0S+?=
 =?us-ascii?Q?XvWDzhHHKVNduQUGX94q7cwFL0qX/wFGYhezeGZqoZRT3ex8Ao9foBbMcI49?=
 =?us-ascii?Q?+MF1yw5iWz3bQp1QcYOkVtVzjc0/U1c25kB16RVwV2vdAYhwZgCYGWFAk6WV?=
 =?us-ascii?Q?GJG1J4ZT6LzjVAriM0b8IA/jg7BzU6aqUM8JLuQcMHaBNn6qdcUvNOGGur1p?=
 =?us-ascii?Q?LFxXse1hhG1NfTg5E+u+52c766Ns14z0oWBBxywvFfXa2RaPBUXPu0A2IoQI?=
 =?us-ascii?Q?HpO8jU9Wr5zYl7Y5i2ugo3UcqYDBsHQaP8Oxc64OZ/J0Ko8TebCbITzNhEwY?=
 =?us-ascii?Q?h1Audw6lVK1OptVvdVZAJqaV+/KQ5DYFjHFudOx15LEARjlzzc/E5n9ElIGx?=
 =?us-ascii?Q?p2uBngnmExtpKHNMbmzvtl+YoidV11tOhCWHYnBGZRQPbj0LqIRmz4AZMERp?=
 =?us-ascii?Q?8o76vZ3EORm/xI6+3EL3iyy/5Q/w/BWaNgmAKrS1pN45p84c9zl0hrgfzmnw?=
 =?us-ascii?Q?z+TdsTyvJFrQfFR9H8z+ZZfQ+iJjnK3qyCw85s2OkHKjbSiidsMvZH+ckKOQ?=
 =?us-ascii?Q?w7pKGWW2li+walfRy0RGvPOsym8cplF3nEcbQictn04AlSgCl88z3dCMvAcy?=
 =?us-ascii?Q?9lQ2MSAECakP4KeluCH3MmiUomshhsP7JLtq93KR2RK8kjACAZlbXQ+SNvrQ?=
 =?us-ascii?Q?K79DSsOuhqz/MjJuiIrRVT2JmFl1WOumYCA8QBon6TRuoqol2zi1rufZ39O4?=
 =?us-ascii?Q?weMsdC9leNsQjK0y0NCUYf8rRl1d84Y/VZno4jUuJy7sRNMbP+FhIm+BNKGV?=
 =?us-ascii?Q?5UEEym5n8LSPqZPX9T3prGrtRsGC7Dwq9Qcs2xq6yL19UwpIq/ZudnZBTYBr?=
 =?us-ascii?Q?EHQjS+uzsYXh6EZVgrfRndonPrvqlyaB0l1PspWXxXbvXlHwVzeWBexF6ms0?=
 =?us-ascii?Q?G3oU7SfhQjz+umfZmDaD76fzVTe4OBCFpHB7U1CDDyy7mI4accqNH5sed7dU?=
 =?us-ascii?Q?VeqU1dCCvw=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ab6b64-7d06-48c3-630a-08dee3d9af76
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 08:02:02.6261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ahsKfCYj7FplIJZv0KcIuUGuW1xtfAVC9ImaHEOja46UvtsKF8iLGN2ezdPXr+hHk4fdHp4VDqlwYJgXaIa5rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5620

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_threaded_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/crypto/inside-secure/safexcel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 52809e57361a..71b920e17e98 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1172,10 +1172,8 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	ret = devm_request_threaded_irq(dev, irq, handler,
 					threaded_handler, IRQF_ONESHOT,
 					dev_name(dev), ring_irq_priv);
-	if (ret) {
-		dev_err(dev, "unable to request IRQ %d\n", irq);
+	if (ret)
 		return ret;
-	}
 
 	/* Set affinity */
 	cpu = cpumask_local_spread(ring_id, NUMA_NO_NODE);
-- 
2.34.1

