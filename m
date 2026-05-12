Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2115.outbound.protection.partner.outlook.cn [139.219.17.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5A44DD6F9;
	Tue, 12 May 2026 06:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778567108; cv=fail; b=ID08o3YgvnX2O7dbSO0eiNknmTL6I30HOUd1KsoqFBmbeXC+Ow3lntrmV9Ielw8PouMrGHB/sSLHxEQvyOFrwW/zsCrofLvVKwQWHUoFYMbdjx/e71oiHlNhI7wX3ZqWyWaSHonQqBGeNu/b8K62jGkY0zw4C5G3Q6XE2kekogw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778567108; c=relaxed/simple;
	bh=yZS2eclfp5wvzQcKo9HotidqI7141vLkHrAHMaf8fWc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rgTX8T4UuYxNIjIYfvVU16wC0Th0IFQ8rnG5j23wRmxy83JPZ1SEuFZTJUSgHCbFGkDepm7FgGT/4v07mw4XfvOgN9wrfwsGHvbhRIiIFVZGOeeiLpyPiB+k3ly6vd+XuhxL9pOpTN6ds/pfn4XjH/zygt3sKUKmgWinVye/UjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ai//4D0W3dE5xfk5s/s0ZM+Npi7nIE4ngmCs6jahm95Bb+GdedC2KY0iQq8P3ELof9frooqFbanmTr6KzqPrILpP8aECnCB2GGtmoXx5g8zyAyz6SBRa2E0ElsMCPEuVMJvXfwl1eE8lcTz8usmyjbL6oHht5+Eln222t8KS6tq+ar6QUZb1ShbY/JelZkzJYS3HEXB7EG2jWICjygQHzh9+otWuY0h+n98r6FSh1vEUXx697IWOp2T4CqtxsrIhgAbSUYivlV2gX0QxaKKLpVavtcc/R0Tm3pAfXb/dUuOR2JIfjZ4CM/maS/To2LdCvyej3S0ARURERmE52idmvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FEL8c26woTzEo3WQXNshz+AHlm7ybJwJDUxHnjpaamA=;
 b=P+COtwuk6+ShJ/6Ge2QqjLbnycUR6obB8VF7gA3yG8oBFteLHPFFkHqIzqKO7YmuSCErneqGgVW8k4nICIqmceiAbSMFVkoRJKz5mE25GCausIr5Sy12uDfFVoEm2XRH0BYFyZVU/cH5UfDgHD/mAvbvDjdS0/jHJvcaamOaZpUOTWWUtD51pdzTfTYsI/bH5CPYTn2No4Ajq8D0mZQdYfQ8CxY9dlMo8lOT7y4Xx5HL8WNXQ+Lp6hw2ZTMkkQKlBMGVE0vT/SlbvWiTjFGO9P5zUXrn15DPj2SuNf1bCz1nOhbd3uwGZyhV8P1z97RUEVqoRusgV1dMD/Yf8p9i4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1302.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 06:24:13 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 06:24:13 +0000
From: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] hwrng: starfive: Update clk and reset sequence
Date: Tue, 12 May 2026 14:24:04 +0800
Message-Id: <20260512062404.4540-3-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260512062404.4540-1-lianfeng.ouyang@starfivetech.com>
References: <20260512062404.4540-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SHXPR01CA0007.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:1b::16) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1302:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d67d387-e725-46a6-0107-08deafef15a3
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|18002099003|22082099003|38350700014|56012099003;
X-Microsoft-Antispam-Message-Info:
	t7/E53i2tDGDvd1M+zFIz/YtELIdgb5XQVM1zKqEmPNdUsr0p3Mj0fwcqw4JzEJQTk9qan02hI831LyCgWn9FJ7e88MX9N+E/41VJ6zwbBGBOgkZLo2jO+kV6LOc9+7hw8VnegZldYnqNzfKutQ9uUNOYpxA6ueFaCBnXgN2N0U2WUl0rEqNQ6qgi3ALzIV0whrSYMcxMIFsQgfpCojdou98jok601ID8F/TtUojyjaz+7l74Ze+Ou0iajfRyLMU3nlaMlwhUWsOnG3noyJGvUKvYg8RA3O+gMlNVUjDxgXbnZcoRc214F0o1d0c+TNkx1rPUSFA3eyGDSsZrANoLfNCcNyzBgf5NbcWYh2Hn71h7s37CfFlHP6dlG9L99zp0CxmrA4wcHxYS4p518eUpx/HSjIjtH4aeYCPcRU67cTCg6TRWvPfPxYh0It9n60wS3Q6WOeF1dMmVSdx42uXlfG//tSyNHbzHxmff6mexTAp184Jq4RVnXkkK5Bcu1xD084mDi5B2SKzrDokbgVeVbV1jMRfK2hOjEf9mVhYOC7Qt3ZhFE35tPSJA7XxKK2M
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(18002099003)(22082099003)(38350700014)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/8BXJmeT3LWaWZ2UPnDTdmkfoJlth6mUI9B6ycjcII6FJG1vaWtQScpoOgmq?=
 =?us-ascii?Q?j83NZS287YzwfdB1cHM/XeukL+y9VCugEhb/UYLudNLp953MIPLVCthhUKT4?=
 =?us-ascii?Q?3bCWe1wQmSBIevm3KCLn+sfIsxj+eJjc4WoP5YvfROXgZRSXexp0VKAdQCmE?=
 =?us-ascii?Q?o+IW8hH9TG1zG48u5TPbYgbDd/tU7xCOWYDl7xIqm37iXZ6OowOxY0OiylYS?=
 =?us-ascii?Q?XSRPmHRA5NDgu1mzFXiNfmXG130m8xmTSwVdx1DoCxNsjNWW8CAfm8zhDBJc?=
 =?us-ascii?Q?s9NX+3GvoyqZ/5J6iUbk53sMS7TDfzG5DDNdQW9XV7P22x5tc1YpC6Yg6n5B?=
 =?us-ascii?Q?BA1q6dZW5pdDrf23LSLnt7oJAeJqlzY6N/bu1RpjQB44lK7C+hm0s28VD0xD?=
 =?us-ascii?Q?BPcvzW1/Mc3pfiHq4KlJssuCNv4SOfVv7o0J726ARZKZ1YYXVzKeiJPDXuq/?=
 =?us-ascii?Q?BQyYjWa+Gmy4Phom5lbBTxNhR9yHmwiJi96nGXsoqebII/1bSKT3TBpIjSfU?=
 =?us-ascii?Q?QXPRrlos6OnaKGa+zc+QWWapVP6lRVAyZdi88ValV6NTVXfuK1SNDG7eO120?=
 =?us-ascii?Q?XX98GrR2zVPx0MYTIVuHuVOOpnzRu/QZT5ogKHbjp2pdDOQ4MXZS25RmU7bK?=
 =?us-ascii?Q?fW2ds8ONEIhXgxaoGiYAaBSwdpqLu3viLa/Ur5LxzMqA7IYdCclhSggEzcdA?=
 =?us-ascii?Q?0tXi60O1AH8JtTgbgni1h184hF9P2jSYr+9MurLz3grUVTz+QZg5ct56PoF+?=
 =?us-ascii?Q?DH9YCU/4HKWDIKI+kVqHaJxKDjW1FRJ6BVK+0dXgE5IR/F9/Vk979OI90h5B?=
 =?us-ascii?Q?TNA5rbvh04aC5geLmAfcIkbEAwEvOnmbmM36/M6fgCJf7Hpoqi0SVj1okb2M?=
 =?us-ascii?Q?z7s9rqJLnlTksveWizw41aVN1LRrCaNqZ7uzoZaSM+CIzyCs7wTiR+dougUX?=
 =?us-ascii?Q?D2l9qc69TxVqUt6g3GiSbjBkLbT3jkYFEZQrIY2gFwm+bhMpXWc1gn5KFDhz?=
 =?us-ascii?Q?uJFtbx1Hhn0wT+sJeC+u9M6D+0bonPeWmasFppm8SKHSbNRZYzdq2oGsn3KN?=
 =?us-ascii?Q?KT8yOVUfjnCbq40tf52/zvZX1pHRbdGwoAqqzZERNDz8dbhCR65Y6Kr2AWHk?=
 =?us-ascii?Q?/kBX+7Hy7+bxiPZIUPet+vGiNAI4SSo/I7zzbsKdrMdiVXHznZS75TATfNaU?=
 =?us-ascii?Q?pMapb/8xqHOX+w/z2brLHMyg7MAdzE6bXEn4ofOo+XF8Cm/JpKit10XOBgym?=
 =?us-ascii?Q?9OuYBrxsWLq5D7BI1R5HG1Cwa9qVYSt9fw1jcTfOtFuWmK9lnZqKhovzYNqi?=
 =?us-ascii?Q?9hZuBdbgmqBMH5a7hpqSnQGwY5izqP+We38cF1GQLKROinx3cgPlgbxclMzd?=
 =?us-ascii?Q?xrrxYJsogtMwRkVdAV7EgLxgzl9BTF7IG8wmB4M4j775WeJBJbXZ3xwLULFU?=
 =?us-ascii?Q?OP+SCwFlrB7bj/Do8OgWk4+2hJepw24jaN9PtymXW1Wd3qmTpRj4QLIyCeHf?=
 =?us-ascii?Q?KV9irFCFYFEClQQwnQ0a2R+MKB8U386x3/Uy77F8W7W+RKY5Rv+U5/XHTSe6?=
 =?us-ascii?Q?zldzTiR/5VYiQgZRvLYAHwOkDbvRELDrS7I4Ey0VCJEctUqYiGlmXTTfMjUd?=
 =?us-ascii?Q?MGjKDvAlVdM8nMtX6iZiI4HZvyPa+sneapsxs013/AtDBjafOSf2n/L93lmi?=
 =?us-ascii?Q?8RQKMxYNIc3hQ1MDWhbj4c2TEQIl1rb8hiV4Irnw2HJZg3vemFJcxrQ/Rf1g?=
 =?us-ascii?Q?Zse90ugrTUzZABWklXgNqK6n5RI74ySfSCV9n+hNfsF4aE1yLT/Z?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d67d387-e725-46a6-0107-08deafef15a3
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 06:24:12.9100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yW27BOblaMFxkqiRwfJoCWOr7erm/psrRaU2QgDm/7TbV1KYjsaf6ISDF2hSyLVlISLbT6KNmcJkykG1X/c/u6O0jTs1mncLPSpI47HxjuBhNSa9AfBXey402OtCFxXT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1302

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

for jhb100, While IP assert async reset, it may generate glitch
and propagate to downstream IP. In order to solve RDC issue,
conduct clock gating before asserting reset to prevent generating glitch.

Jia Jie Ho has resigned

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 MAINTAINERS                          |  2 +-
 drivers/char/hw_random/jh7110-trng.c | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d3a6b3f6b6a0..729b20ecc697 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25280,7 +25280,7 @@ F:	Documentation/devicetree/bindings/perf/starfive,jh8100-starlink-pmu.yaml
 F:	drivers/perf/starfive_starlink_pmu.c

 STARFIVE TRNG DRIVER
-M:	Jia Jie Ho <jiajie.ho@starfivetech.com>
+M:	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/rng/starfive*
 F:	drivers/char/hw_random/jh7110-trng.c
diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 9776f4daa044..f5eb434c94f5 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -234,12 +234,18 @@ static irqreturn_t starfive_trng_irq(int irq, void *priv)
 static void starfive_trng_cleanup(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
+	bool is_jhb100 = device_is_compatible(trng->dev, "starfive,jhb100-trng");

 	writel(0, trng->base + STARFIVE_CTRL);

-	reset_control_assert(trng->rst);
+	if (!is_jhb100)
+		reset_control_assert(trng->rst);
+
 	clk_disable_unprepare(trng->hclk);
 	clk_disable_unprepare(trng->ahb);
+
+	if (is_jhb100)
+		reset_control_assert(trng->rst);
 }

 static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -337,12 +343,19 @@ static int starfive_trng_probe(struct platform_device *pdev)

 	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
 	if (ret) {
+		bool is_jhb100 = device_is_compatible(trng->dev, "starfive,jhb100-trng");
+
 		pm_runtime_disable(&pdev->dev);

-		reset_control_assert(trng->rst);
+		if (!is_jhb100)
+			reset_control_assert(trng->rst);
+
 		clk_disable_unprepare(trng->ahb);
 		clk_disable_unprepare(trng->hclk);

+		if (is_jhb100)
+			reset_control_assert(trng->rst);
+
 		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
 	}

@@ -378,6 +391,7 @@ static const struct dev_pm_ops starfive_trng_pm_ops = {

 static const struct of_device_id trng_dt_ids[] __maybe_unused = {
 	{ .compatible = "starfive,jh7110-trng" },
+	{ .compatible = "starfive,jhb100-trng" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, trng_dt_ids);
--
2.43.0

