Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2103.outbound.protection.partner.outlook.cn [139.219.17.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89B33DDDCE;
	Mon, 18 May 2026 06:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779087194; cv=fail; b=lh78MyXEVC5F9JU9g9n9jh0IAeboL8d0WhBXrYc2EWHJF0ue4QC33c+9vav8HSWb4XU6hqWOigyRfn62sb1oMhPTOCGYx+6x7R/XraiSzXkh3rAJukDxmwA0/A9apSZFpo3HOP/B3VgNFq37e1MlpVgeB5Q/mMVXODJfprik1fU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779087194; c=relaxed/simple;
	bh=5D++ja4pkBBGz8QZFHOplrVsy7vEPImfohRbmqin72o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SL+aAcjl4QDqE3aNGR4ASM+w2DHX3IQtdC7Yhs1YzmjrT26ylYGN+PM8PFOWL9u7w5PjbV3/IY9n7LpSyJ/aFsXBG75AHIOHlW/LofLRdUP9dKwKBeBnzIPcEqBMJp8fZ3HD42SjfU/k1pKMHnIrtwytOtkqTrO5qeNj97EL31c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gL/T8fDoDUgxGGvvFdo/CAj4WEu4S1eE8DvFmw21gvSxIGhDaVrxELA9aP+UzGhEIPtqyIHNQXXPyoIkgTFbn8x5eWfXV0ti9IaCEckVwAzqU2qP15zBZtlJLM0NEbnumfVTELH9jZaZ/a0ZsgFB59hnzGQQOHrH6iX7umqBBU2qceZfSWv46aJihET1EGs458ylikNxY2iQaVf66MsGbrTjxhxGoIcrVPU164nkvLizqhzxx3u2InFYRDyeMtXchw0pDpHk/mQFr6oJh78zoj8ngv5xbCSE9u9uDb2fN7twHvRj19DRuBnjzwdbUAtoxNhhtEHPqtuNWnYbk5vIDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gO1pZeYpfmQ07gFN8YSYIvwbRUMLWLoXjjBlFA5ymsE=;
 b=XcyvP2/ZbHV3lCvDvGbyauH2dvpjWcwU+S0XtsVhRnGy5ai6NsvaSqRPkAjYrb01TOgbhU9uH/kGY11EvZd34q7ZYjarW2VM/EJZOdRJiSE3Z0PowaCsxuofyBRno6WxNIFR3sZ61FH5AM9wKtmiHr/42IZ0FuwGQ03FRYs7slE9yvhTiJszRBVSo9ZfoZtXtzpDNzPpCfoBd/4n/Wx0bz4UdjHrGfXtucUYcN0VWmXOvtZXIj+dAPt3+aUBshCh9c7iPPmmMsXDbqsHchf2kcRUL+Mj0PEjP0DjUoRm0LDd1gdFTZA82600IASchjDAFc6RGZoST8wzXp7hcCu9CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1015.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.16; Mon, 18 May
 2026 06:52:52 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.20.9913.017; Mon, 18 May 2026
 06:52:52 +0000
From: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
Subject: [PATCH v2 2/2] hwrng: starfive: Update clk and reset sequence
Date: Mon, 18 May 2026 14:52:43 +0800
Message-Id: <20260518065243.20865-3-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518065243.20865-1-lianfeng.ouyang@starfivetech.com>
References: <20260518065243.20865-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0036.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:c::13) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1015:EE_
X-MS-Office365-Filtering-Correlation-Id: caee0642-48fa-4869-94dc-08deb4aa14de
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TGECP221HlW81Jc4ZQTJhZRp5MRfR796l3lD0SgRvvxcK5TyqWDW8gLLS2TBC0ThJPvaoIRp+8mifhXT0k1I9TDuxX6m+xsRBIMgHYSG3VzvpKsKw6uespybAYnLVfQVyvHukvp/1YaGHgxCYrQogN1Z+nDma+qO6FOJGwCyH0ft6Jiym0elcXgQxBepiEVPaa/76fAylyL7E40eJV1V+VWSqAStpjobb69CQNBlpqUWTJyvcf5iV6sAXusWdYIjJxL8/Ele6tgZ+krxCO1HlCNhbHUy9i59Vj26jBG+k3wxFDr7j7xw4EwueB21c1dQLkNZ4IXv3w1sjTsL3hX2eNnyCci6Mcy9x1vItcQEmxCgBgrlrCdz4Fn0KZY2IrwutSh2FWgllcdjKkfWiQD374/wz6x7uuATVWT0ySZqSL4O9kRTGhJxTib+9+hMxStbVTFC9sxndLXkmfnP4eVa8Q0qgqQajPUThOnbu8Q7DyBbaFmU78uF7xOtLmBjv0dOzhFtSURXTC+tGPHDsWGaRIXjkZ3Xl7x+YSf+FyrhaaVPLFpM4gCBRaMsV00ZyvUL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Latn36JTLgwEwKxXJRr1lJuTRydDG+ecFQEalrcu2HnWnftufumF1mmK503X?=
 =?us-ascii?Q?HPXJz9o/8aQoYHqoTHrmuvZBHw7F1R1hw7fa7OffMB/vjRLjK9Gf4A+rg0zv?=
 =?us-ascii?Q?kh9RK6SnhAr0ndtyeou1WrbvJ9fbqC/S1W+Z87Te35KscUTkMZ0AuSh4opVj?=
 =?us-ascii?Q?+nwQx1plv/2jXvTeBheL6hxz6YzIk+EdwZbO0JuXBhMTZiHErpLalOTWzcJY?=
 =?us-ascii?Q?r6w1DVSSIld70co5S5BHJziARndBg7KFzQswxO53Y2ihCOH5w/MGH6vgfwHD?=
 =?us-ascii?Q?gfnHf9HO5752totxWY+m+dSD1DHDS1lSPAwe3np3mqS+VzszVspuxHrvr3Ih?=
 =?us-ascii?Q?1sA277cigGn2wZJnus0a2ZOx2/JDAKpSp+JZHCNlEjo5Hh3khABg+OoaJDJu?=
 =?us-ascii?Q?9oE0pLEvDACkP6QBXotQC9/EO1s/13lIJEpVo8F1HNUMp52rrIRS5SsBUV8k?=
 =?us-ascii?Q?25YBia14XWOgqGR/FCO6+TIhDMODdxFKGqc/yrke1ygYRs4DwWlPEHLQQgCy?=
 =?us-ascii?Q?6YWElfYPQq0ASgiQbFqYNYkxfhQ8/6ZM7teCjS/b5Lb0HNWyr6HPgSzPsE0f?=
 =?us-ascii?Q?C6sZEHB59LVg0gcqhZyczt0Aoh35oNIShKr1WrHIpc5qNmLa5+QwJTpHmFPs?=
 =?us-ascii?Q?jitMmBWv+mAm4tv5cLCu10lPy5F0BFtkD7aTVqN+ngQQZpIwL1UvxYx5Kv9L?=
 =?us-ascii?Q?6EVkrqpvNkOQOOrKOL1RPk6G2rhAzExFRqiNSobemJKTQmdhTNYj7ugIaiN6?=
 =?us-ascii?Q?56PUeLS6VhyplgHrVcXUvfJcd00X4uK9S6quolS1woSpWjgrTQD5E9NK372q?=
 =?us-ascii?Q?qj9cFnbHNMu2RQqIESZ1xWxeTqYr3pDosDlPyqNPMOK/5gGap5Nw2Pd3g6pz?=
 =?us-ascii?Q?8PqEI7s6cfiEFzueShSbgA3QkBkzQXK3f7LTfhfWAD1zwyQz4Bp9GMyf+wN/?=
 =?us-ascii?Q?a16iNOLL9kbNZj1gLfRELSoZC1kmlKR27Tk30egErrOhXZY5OvegjmbU/bcU?=
 =?us-ascii?Q?Em9T0I88u0K6nLhHXlYnK4vmWTpTWj9BUfoPp4BUEsr7pDkt6sq35aS2nRoQ?=
 =?us-ascii?Q?bJ+4HYTL+r6yWM0itu4eEejlDuSAtgpc6eYErgQ8ZTNTewTc4lPmawDiLePi?=
 =?us-ascii?Q?X8l9uP123lw1sPfO1rN5bT2LzKD1uZcUNPQ7rGOSQs28geJ9JMtNGzkbeQAv?=
 =?us-ascii?Q?w/tTQXK1i/qv3KodaZhtn4ul+M2k5oXUQu7X+L0A/N9dlkeu7btkXBeGXVHU?=
 =?us-ascii?Q?LTAJDUB2LXIfHTMgICGMtBW8NmT/rFgyoC/URrbbalNgmjUFUPHqN6xWFsyy?=
 =?us-ascii?Q?5/5uHdW3lFBpG1xVx/Tpey0jDwuq8InfWNhWynm8N9TOHMnU6TafcwdfLr+f?=
 =?us-ascii?Q?ibqY7MaGsULuB/dmjhj92+jtwfdoc3NXREKZ2o9VReDHNr1pSX38/7iqwZWT?=
 =?us-ascii?Q?+6fYHti5Cckhed6iYprWcLKgs+9Ss3phrS0Uc+EyLCQHBGUFp9HLeUBXjJ1N?=
 =?us-ascii?Q?8FSHmZsKh6VRuG3hvbcXIqB9T/+p6qD5IkWlhes04REoyLI4DK29CYLyryJx?=
 =?us-ascii?Q?gEaJuD2UAP58RaovS2gshRK2l2zsCnOztwY254apQGvVPWQvL8v/Ip3PqAaj?=
 =?us-ascii?Q?zOiPC9Rk0h0OSW8bnk3Zwn2zE1UAyMUUecZ8HibYETLMw80S1u4z/mf2Hj4T?=
 =?us-ascii?Q?ox9X9B3AO8ncagj8OwC2LBg/RqVEUJMaanhMWdncoi0rXXn6QdcpsYpIZ6PM?=
 =?us-ascii?Q?aN02ioRweSpNo1gUPumTjMJt1xbuxz+xR7K3MrTj9AyJr4PZzNTU?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caee0642-48fa-4869-94dc-08deb4aa14de
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 06:52:52.1664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pCBAOiYWppWdUnZF46l0C+w+vMBAVYNwQcMt4nVV/DxDBv+4WVGHHSugN9P0L6E+oCdAQH5ZK7L/YCThojPIK3KPbZg/pJnqY+0eQIzbgSCNvhwyMWzWvmrzWQqo5SaF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1015

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

for jhb100, While IP assert async reset, it may generate glitch
and propagate to downstream IP. In order to solve RDC issue,
conduct clock gating before asserting reset to prevent generating glitch.

Jia Jie Ho has resigned

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 MAINTAINERS                          |  2 +-
 drivers/char/hw_random/jh7110-trng.c | 83 ++++++++++++++++++++--------
 2 files changed, 61 insertions(+), 24 deletions(-)

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
index 9776f4daa044..2265d856d593 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -78,6 +78,9 @@
 #define STARFIVE_ISTAT_SEED_DONE	BIT(1)
 #define STARFIVE_ISTAT_LFSR_LOCKUP	BIT(4)

+#define HW_SEQ_RESET_FIRST_THEN_CLK	0
+#define HW_SEQ_CLK_FIRST_THEN_RESET	1
+
 #define STARFIVE_RAND_LEN		sizeof(u32)

 #define to_trng(p)			container_of(p, struct starfive_trng, rng)
@@ -95,12 +98,14 @@ enum mode {
 struct starfive_trng {
 	struct device		*dev;
 	void __iomem		*base;
+	int			irq;
 	struct clk		*hclk;
 	struct clk		*ahb;
 	struct reset_control	*rst;
 	struct hwrng		rng;
 	struct completion	random_done;
 	struct completion	reseed_done;
+	u32			hw_seq;
 	u32			mode;
 	u32			mission;
 	u32			reseed;
@@ -130,7 +135,7 @@ static inline int starfive_trng_wait_idle(struct starfive_trng *trng)
 					  10, 100000);
 }

-static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
+static inline void starfive_trng_irq_clear(struct starfive_trng *trng)
 {
 	/* clear register: ISTAT */
 	u32 data = readl(trng->base + STARFIVE_ISTAT);
@@ -138,6 +143,23 @@ static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
 	writel(data, trng->base + STARFIVE_ISTAT);
 }

+static void starfive_trng_release(void *data)
+{
+	struct starfive_trng *trng = data;
+
+	pm_runtime_disable(trng->dev);
+	pm_runtime_dont_use_autosuspend(trng->dev);
+
+	if (trng->hw_seq == HW_SEQ_RESET_FIRST_THEN_CLK)
+		reset_control_assert(trng->rst);
+
+	clk_disable_unprepare(trng->ahb);
+	clk_disable_unprepare(trng->hclk);
+
+	if (trng->hw_seq == HW_SEQ_CLK_FIRST_THEN_RESET)
+		reset_control_assert(trng->rst);
+}
+
 static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, bool wait)
 {
 	int wait_time = 1000;
@@ -174,13 +196,16 @@ static int starfive_trng_init(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
 	u32 mode, intr = 0;
+	int ret;
+
+	pm_runtime_get_sync(trng->dev);

 	/* setup Auto Request/Age register */
 	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
 	writel(autoreq, trng->base + STARFIVE_AUTO_RQSTS);

 	/* clear register: ISTAT */
-	starfive_trng_irq_mask_clear(trng);
+	starfive_trng_irq_clear(trng);

 	intr |= STARFIVE_IE_ALL;
 	writel(intr, trng->base + STARFIVE_IE);
@@ -201,7 +226,11 @@ static int starfive_trng_init(struct hwrng *rng)

 	writel(mode, trng->base + STARFIVE_MODE);

-	return starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+
+	pm_runtime_put_sync_autosuspend(trng->dev);
+
+	return ret;
 }

 static irqreturn_t starfive_trng_irq(int irq, void *priv)
@@ -235,11 +264,17 @@ static void starfive_trng_cleanup(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);

+	pm_runtime_get_sync(trng->dev);
+
+	writel(0, trng->base + STARFIVE_IE);
+	starfive_trng_irq_clear(trng);
+
+	if (trng->irq >= 0)
+		synchronize_irq(trng->irq);
+
 	writel(0, trng->base + STARFIVE_CTRL);

-	reset_control_assert(trng->rst);
-	clk_disable_unprepare(trng->hclk);
-	clk_disable_unprepare(trng->ahb);
+	pm_runtime_put_sync(trng->dev);
 }

 static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -257,24 +292,26 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	if (wait) {
 		ret = starfive_trng_wait_idle(trng);
 		if (ret)
-			return -ETIMEDOUT;
+			goto end;
 	}

 	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, wait);
 	if (ret)
-		return ret;
+		goto end;

 	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);

+	ret = max;
+
+end:
 	pm_runtime_put_sync_autosuspend(trng->dev);

-	return max;
+	return ret;
 }

 static int starfive_trng_probe(struct platform_device *pdev)
 {
 	int ret;
-	int irq;
 	struct starfive_trng *trng;

 	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
@@ -283,21 +320,22 @@ static int starfive_trng_probe(struct platform_device *pdev)

 	platform_set_drvdata(pdev, trng);
 	trng->dev = &pdev->dev;
+	trng->hw_seq = (kernel_ulong_t)of_device_get_match_data(&pdev->dev);

 	trng->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(trng->base))
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->base),
 				     "Error remapping memory for platform device.\n");

-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
+	trng->irq = platform_get_irq(pdev, 0);
+	if (trng->irq < 0)
+		return trng->irq;

 	init_completion(&trng->random_done);
 	init_completion(&trng->reseed_done);
 	spin_lock_init(&trng->write_lock);

-	ret = devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->name,
+	ret = devm_request_irq(&pdev->dev, trng->irq, starfive_trng_irq, 0, pdev->name,
 			       (void *)trng);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,
@@ -333,18 +371,16 @@ static int starfive_trng_probe(struct platform_device *pdev)

 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
+	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);

-	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
-	if (ret) {
-		pm_runtime_disable(&pdev->dev);
-
-		reset_control_assert(trng->rst);
-		clk_disable_unprepare(trng->ahb);
-		clk_disable_unprepare(trng->hclk);
+	ret = devm_add_action_or_reset(&pdev->dev, starfive_trng_release, trng);
+	if (ret)
+		return ret;

+	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
+	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
-	}

 	return 0;
 }
@@ -377,7 +413,8 @@ static const struct dev_pm_ops starfive_trng_pm_ops = {
 };

 static const struct of_device_id trng_dt_ids[] __maybe_unused = {
-	{ .compatible = "starfive,jh7110-trng" },
+	{ .compatible = "starfive,jh7110-trng", .data = (void *)HW_SEQ_RESET_FIRST_THEN_CLK },
+	{ .compatible = "starfive,jhb100-trng", .data = (void *)HW_SEQ_CLK_FIRST_THEN_RESET },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, trng_dt_ids);
--
2.43.0

