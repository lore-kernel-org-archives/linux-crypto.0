Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2102.outbound.protection.partner.outlook.cn [139.219.146.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DCE3F39E9;
	Tue,  9 Jun 2026 10:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780999928; cv=fail; b=sW0otfp5qL6FHy6QsTQaBE8j4ogwIF3CHrk2iEl8VnJEzesqn/zexuxb2dM48njwbmaVyjTfrKhEGkjbKpIxtFFilZIoF4E3mQbpacePh1nG5N2VmawVq5WsaI4iviw6OL63sdty+ACDuE/MV/Wr5eahuYJDBEC1iI2T+QMr810=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780999928; c=relaxed/simple;
	bh=cXbfIzta4lp8w6EsbD8bPxA81wAZldhOnbfd9SQhigA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XDb1qHBWmLBPHhfN/4qKobZyCmNwA8bTbdGtVka4mw4hgVIbFRQMEac0jtTojgj5BLmvy1xDWkNFDyVpBYqWgXeRwvOKl4toV5mNG5WzRQU9mKNqzPnO9CrENiHZtFoaBvFVhYu8UZmxWNQM6jBPPeEwNsuGQIKRwEAZ3YATuio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7X1cTXGjWtTPmyIB6FrZcevp6G2+m+jUDzSMaVxDE2e/QPtIl0NlRXqjHZg7h4fsjRZCr1pSrQfinivdn4JEiyY3114N2QQ4OXdWFbGMv2XHFkMtkcRDrPlr7t3/OXYdbtGHT/eNHOQG5uKv4sP8fTvRgRlsFMFAuWo8oADcywzoQcnzu3UxF0ycR3JRHJdYP7Bm9/Dk0aM2AxcucvgIBEfyGv7hd7dJhmb1EdVw2N+VkQ1qG0yqWxY999Ff5StBJ+DdsGQkftxP13r4owujcJKRE3P16PAN03Xl8rCEJzMY8kymmyUaFAj6euwm3GTEHG8igjOYfAO8RE+Q4VLbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8VD1PBgL3wqcPGBd1YukmA0lKuru5hzdZfqBxc9JIWk=;
 b=ChSjxl2nTcKCU/MWJypTt+MyOKTrobGnKyRuesm1L4jZhZNqk/a5H3Bg+zpmzUZoJIwVuCUsmXb1I1Hn4PFm4EDo6350ZtEBHV9+GpHva+cNMDcEiM8N0c4ThDPbpxFqWgMvbF+hgxxG0K3+qek9tviV+FIzgbaOR46SgkWB/0R+dHyRV38LKOlHJ2WECcUN+yphPc2gx3/3DD0jsHeQUP/41c1CUCqs67NA+d/Hkhrhi/SIYwIZLF1hTt+tnGQHitYi9/nHV2K8MdV6LzUCQHmgAHUMUK7tylfbQQInxm9mQuxwDIs60lS1EVd1V7SJfPNnlKB2WhAQ4RXvhVW58g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1094.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.15; Tue, 9 Jun 2026
 09:57:35 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.21.0092.014; Tue, 9 Jun 2026
 09:57:35 +0000
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
Subject: [PATCH v4 2/2] hwrng: starfive: rework clk/reset teardown order for JHB100
Date: Tue,  9 Jun 2026 17:57:26 +0800
Message-Id: <20260609095726.160559-3-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260609095726.160559-1-lianfeng.ouyang@starfivetech.com>
References: <20260609095726.160559-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0013.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:5::25) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1094:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f96bcce-744a-4eb5-a215-08dec60d8827
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|18002099003|22082099003|6133799003|56012099006|38350700014;
X-Microsoft-Antispam-Message-Info:
	gus17kgDc42xhYVkpIe6fsaOzzXGoUODffEnFG1nb5LodHpctb/o/LvamBFXT11rDnljIyFC7TQ++D8bdawRorizfaMLSKXPd4XhMfwkd18zUrjeAszOz3OnIoBCV3YrPTSxZaQh0RUKUCo9yDRIYlGwkBiuWJ6pYQYhO+eB7CP+UfTv7tr4hF44TeKb8wEY/pXiexCvsFGOH5f6tLJbeYRWsETUcrulDI/hmK2A9fvjPyzAoMV47/RkM1MuqCeadca33ynqb0VPVtALQaab7sc4yOlrhzi1kxWl0gidMKQoiCooJVZI8Kz56bBdcHdt4lWrjUiv3EQfQ8hhULJHqL7nKeXuJHgsKYLJzmouHFf03U+sBdKYY8epxxREMlxr9vMMSt6SNILkqjbdROVikezd0M3z2mQATid2IYKsVzX72V+hLHlEVT1u1KMcwYkHzJYJ9Dxs62GL4xGfX9jenUOyNCgHRv6uIl2iVuWRf+WLLdXUhcLOt2dRlEN0yC7OgEBc0zt4VmreHukHDoCv1nyZMZ1o5WjAxC5bbYGngFj6F1MbFmcm5EiFoKyHoBIj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(18002099003)(22082099003)(6133799003)(56012099006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HZbiEPBe+VVe/TPsgOLrig7DZ4J6JoWCBbVp4iEqsQw7LxHCBwyUqjFPmN06?=
 =?us-ascii?Q?yTUZTEvt/uVkecXNCYt8rox5seXCMGKaBWwiiu6NiuXjIiqFMm3p/Vv9DKnf?=
 =?us-ascii?Q?IZfkEbnFsxLT2VnJbVxSTLXoN+J23wLB9BTPgLvRCZXlygAVE2Ee9L81+tCy?=
 =?us-ascii?Q?pfrDuEgNREGFXNlkJUIgCNN6ZjmeetdJ75lEqD9mWrLVS8A/Euf9TZMPh2Qp?=
 =?us-ascii?Q?zUQlm1FlsM3z8x6RpY99GywSj4z05T9dP69cQm/WqIGv+ZMQEod99eXvGGbI?=
 =?us-ascii?Q?LcqGJ2phQ1zVN+euQo5sHgQggqFzXkh7q07cSbKYG2NpFngpetTU6VxnjoqL?=
 =?us-ascii?Q?LU0BA5x8dhNqJqfg1RTJPhC/mmW5AEyeFpk/o34IdLC8ca1v8lS+YBmwiyOy?=
 =?us-ascii?Q?qH0ttd9RRMAt4vI0gu+f0j7/MImbvNWB6YlsvH0PVuQKTLp33h3pF9sI6xj3?=
 =?us-ascii?Q?DozOhU02J+IjpqP9h3KB74NlcbvTH4aIMqxVGmztT3yUiB3yPstXq4BIjSw3?=
 =?us-ascii?Q?MlpZcfZY7LBictHc8ucErQmMYVcG9XqJZTu2ruDSrVvNXuyxrX4HtDYhg1+3?=
 =?us-ascii?Q?CG+WboCgS8sKQQmjUB+a3x67oud4NXFa/gXGi9a9ED1wQc7OGN4scuqgLYxu?=
 =?us-ascii?Q?AHF9dJbEOxcv/WxOjJyU3qm/TqAGfOll2t+QlAzKXxhy/l2XnAUK/Qc+dKuh?=
 =?us-ascii?Q?VwaDRsIJQmtdnEoFw+esyLc7wYYNjkqM6fi9NspCQC1EBxmKZlri/MnCBdRw?=
 =?us-ascii?Q?/b1FlEcE9kCXb5YgNtMtN1LtG4wAgTT9csMfOsxLMksQPKSXUA8mffX4bHbY?=
 =?us-ascii?Q?NTMZY1vHs6TLZAlFs8qAwfD4AIVohKGMwdWC9sNn+9K1qc1aVB6BcBMSJTZ1?=
 =?us-ascii?Q?JbgBnFss4GkcdCmBdqdFD+PZgOtQFaaHTqC0XqL1CkqM4kfYMYCpOeBxqaov?=
 =?us-ascii?Q?ZfG4/wRexE+9DdRuQJDy7TUrjBafHchzqwN5Ysc8ooVdh5ccheI009tfUU/q?=
 =?us-ascii?Q?ZcWJZ8+/VJQk/ku532b1z5oM92gx+9bxRY5X8Um+v3F9I4JCah2vbYqJKVo+?=
 =?us-ascii?Q?wSzZpTonXJmJamZPOWqDKvEPMk+GnMvzmXoNwqwq3NHUmTo66Dbfk2/tS3QZ?=
 =?us-ascii?Q?cdAlpWaL11dAJwqRIDhaYhtZ6+EsAS6/zl/BitZ3kg/iXqi/lmsI9vpdELes?=
 =?us-ascii?Q?3arGzIKBFVzQoDx12FP49v81zE7ObHrDSPmES0LkAVUiWTvnQETUgZ+SuYa+?=
 =?us-ascii?Q?c9+KnJQE0+pZF2tXZV/PxzywEAsEqquYnRWifgOCA97BzXQ528NksPFrCSR4?=
 =?us-ascii?Q?WNfwFiEdEyB5deGcXmM9NS+xgu7gZaWosWWFDbKy1YN+IWDc7IJVZnVlYpPD?=
 =?us-ascii?Q?Sl7dDtCwJIqJ/mCHuDdsFajZEtkIEFtCernX9Jvob6Mu5W+JMK+6OB3MXdVI?=
 =?us-ascii?Q?m95Ngf6qEV9R5ZbP19HwgZCFR1eCprdnQDeE5ISl2Nrgl5Lhu2KFvXYj5Lz7?=
 =?us-ascii?Q?om0PZeyb1hlUqGYA4bPUhnQlklBG2wkwxM/2Swwi1vAC81/mW44ZkkxiIuzW?=
 =?us-ascii?Q?+kfM9uExfz67RLF+5qtSUdHc4mwwxsLHbHyLDWOkh5XADa35tZowio7qed7B?=
 =?us-ascii?Q?XpTEUSWneWAumBduOf80srWp9eMz/XEl0ZvApBq3rlLtgMJHg1LqB8/Wjwhn?=
 =?us-ascii?Q?8lmjdugDoch0Hom/RKmJ9BT8R0k5IsS0H3nUfMI0Th+LdDLKOJFNkyToAvjC?=
 =?us-ascii?Q?7qHzhaupORYaZoqGxW8u4yTmpupCBZbr6oXRfeNeqyHmWyPTFdDQ?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f96bcce-744a-4eb5-a215-08dec60d8827
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 09:57:35.6049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 31dqYecDVOeFOGKtOl5T94bpvprLyHGgvTENrGS8X4Rimmio3+t5paoGDURK0m2MZEzmFPfJ9yiMBKw7n47/JwszMfk3Ixe08KtXHoRevCkIbFsYB7S0hG22IK6gHlLV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1094

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

Rework the StarFive TRNG driver to address hardware-specific requirements
  for JHB100 SoC. To avoid reset-domain crossing glitches, the driver now
  ensures clocks are gated before asserting reset during teardown for
  JHB100, while JH7110 retains the original reset-first sequence.

Fixes RPM handling by marking the device as RPM_ACTIVE after clocks and
  reset are deasserted but before pm_runtime_enable(), allowing the usage
  count to drop to zero and enabling autosuspend.

Balances pm_runtime_get/put calls in init, read, and cleanup paths,
  and moves low-level disable/reset operations into a devm
  action (starfive_trng_release()) for correct error-path unwind
  ordering.

Improvements include proper mutex protection for TRNG command sequences,
  enhanced clock enable error handling.

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 MAINTAINERS                          |   2 +-
 drivers/char/hw_random/jh7110-trng.c | 223 +++++++++++++++++++++------
 2 files changed, 176 insertions(+), 49 deletions(-)

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
index 9776f4daa044..cafc873b9ebf 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -92,20 +92,36 @@ enum mode {
 	PRNG_256BIT,
 };
 
+/*
+ * For JHB100, assert reset after disabling clocks to avoid
+ * reset-domain crossing (RDC) induced glitches that can affect
+ * downstream IPs.
+ */
+enum seq_rst_clk {
+	SEQ_RST_FIRST,
+	SEQ_CLK_FIRST,
+};
+
+struct starfive_trng_data {
+	enum seq_rst_clk	seq_rst_clk;
+};
+
 struct starfive_trng {
-	struct device		*dev;
-	void __iomem		*base;
-	struct clk		*hclk;
-	struct clk		*ahb;
-	struct reset_control	*rst;
-	struct hwrng		rng;
-	struct completion	random_done;
-	struct completion	reseed_done;
-	u32			mode;
-	u32			mission;
-	u32			reseed;
-	/* protects against concurrent write to ctrl register */
-	spinlock_t		write_lock;
+	struct device			*dev;
+	void __iomem			*base;
+	int				irq;
+	struct clk			*hclk;
+	struct clk			*ahb;
+	struct reset_control		*rst;
+	struct hwrng			rng;
+	struct completion		random_done;
+	struct completion		reseed_done;
+	const struct starfive_trng_data *data;
+	u32				mode;
+	u32				mission;
+	u32				reseed;
+	struct mutex			lock; /* protect trng cmd seq */
+	spinlock_t			write_lock; /* protects register access seq */
 };
 
 static u16 autoreq;
@@ -130,7 +146,7 @@ static inline int starfive_trng_wait_idle(struct starfive_trng *trng)
 					  10, 100000);
 }
 
-static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
+static inline void starfive_trng_irq_clear(struct starfive_trng *trng)
 {
 	/* clear register: ISTAT */
 	u32 data = readl(trng->base + STARFIVE_ISTAT);
@@ -138,6 +154,31 @@ static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
 	writel(data, trng->base + STARFIVE_ISTAT);
 }
 
+static void starfive_trng_release(void *data)
+{
+	struct starfive_trng *trng = data;
+
+	if (!pm_runtime_status_suspended(trng->dev)) {
+		writel(0, trng->base + STARFIVE_IE);
+		starfive_trng_irq_clear(trng);
+
+		if (trng->irq >= 0)
+			synchronize_irq(trng->irq);
+
+		if (trng->data->seq_rst_clk == SEQ_RST_FIRST)
+			reset_control_assert(trng->rst);
+
+		clk_disable_unprepare(trng->ahb);
+		clk_disable_unprepare(trng->hclk);
+
+		if (trng->data->seq_rst_clk == SEQ_CLK_FIRST)
+			reset_control_assert(trng->rst);
+	}
+
+	pm_runtime_dont_use_autosuspend(trng->dev);
+	pm_runtime_disable(trng->dev);
+}
+
 static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, bool wait)
 {
 	int wait_time = 1000;
@@ -174,13 +215,22 @@ static int starfive_trng_init(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
 	u32 mode, intr = 0;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_warn(trng->dev, "Failed to wake device for init: %d\n", ret);
+		return ret;
+	}
+
+	mutex_lock(&trng->lock);
 
 	/* setup Auto Request/Age register */
 	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
 	writel(autoreq, trng->base + STARFIVE_AUTO_RQSTS);
 
 	/* clear register: ISTAT */
-	starfive_trng_irq_mask_clear(trng);
+	starfive_trng_irq_clear(trng);
 
 	intr |= STARFIVE_IE_ALL;
 	writel(intr, trng->base + STARFIVE_IE);
@@ -201,24 +251,33 @@ static int starfive_trng_init(struct hwrng *rng)
 
 	writel(mode, trng->base + STARFIVE_MODE);
 
-	return starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_autosuspend(trng->dev);
+
+	return ret;
 }
 
 static irqreturn_t starfive_trng_irq(int irq, void *priv)
 {
+	int ret;
 	u32 status;
 	struct starfive_trng *trng = (struct starfive_trng *)priv;
 
+	ret = pm_runtime_get_if_active(trng->dev);
+	if (ret <= 0) {
+		dev_err_ratelimited(trng->dev, "pm is inactive in irq\n");
+		return IRQ_NONE;
+	}
+
 	status = readl(trng->base + STARFIVE_ISTAT);
-	if (status & STARFIVE_ISTAT_RAND_RDY) {
+	if (status & STARFIVE_ISTAT_RAND_RDY)
 		writel(STARFIVE_ISTAT_RAND_RDY, trng->base + STARFIVE_ISTAT);
-		complete(&trng->random_done);
-	}
 
-	if (status & STARFIVE_ISTAT_SEED_DONE) {
+	if (status & STARFIVE_ISTAT_SEED_DONE)
 		writel(STARFIVE_ISTAT_SEED_DONE, trng->base + STARFIVE_ISTAT);
-		complete(&trng->reseed_done);
-	}
 
 	if (status & STARFIVE_ISTAT_LFSR_LOCKUP) {
 		writel(STARFIVE_ISTAT_LFSR_LOCKUP, trng->base + STARFIVE_ISTAT);
@@ -228,18 +287,37 @@ static irqreturn_t starfive_trng_irq(int irq, void *priv)
 		spin_unlock(&trng->write_lock);
 	}
 
+	if (status & STARFIVE_ISTAT_RAND_RDY)
+		complete(&trng->random_done);
+
+	if (status & STARFIVE_ISTAT_SEED_DONE)
+		complete(&trng->reseed_done);
+
+	pm_runtime_put_noidle(trng->dev);
+
 	return IRQ_HANDLED;
 }
 
 static void starfive_trng_cleanup(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_warn(trng->dev, "Failed to wake device for cleanup: %d\n", ret);
+		return;
+	}
+
+	writel(0, trng->base + STARFIVE_IE);
+	starfive_trng_irq_clear(trng);
+
+	if (trng->irq >= 0)
+		synchronize_irq(trng->irq);
 
 	writel(0, trng->base + STARFIVE_CTRL);
 
-	reset_control_assert(trng->rst);
-	clk_disable_unprepare(trng->hclk);
-	clk_disable_unprepare(trng->ahb);
+	pm_runtime_put_sync(trng->dev);
 }
 
 static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -247,7 +325,13 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	struct starfive_trng *trng = to_trng(rng);
 	int ret;
 
-	pm_runtime_get_sync(trng->dev);
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_warn(trng->dev, "Failed to wake device for read: %d\n", ret);
+		return ret;
+	}
+
+	mutex_lock(&trng->lock);
 
 	if (trng->mode == PRNG_256BIT)
 		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
@@ -257,24 +341,28 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
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
 
-	pm_runtime_put_sync_autosuspend(trng->dev);
+	ret = max;
+
+end:
+	mutex_unlock(&trng->lock);
 
-	return max;
+	pm_runtime_put_autosuspend(trng->dev);
+
+	return ret;
 }
 
 static int starfive_trng_probe(struct platform_device *pdev)
 {
 	int ret;
-	int irq;
 	struct starfive_trng *trng;
 
 	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
@@ -282,22 +370,32 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, trng);
+
 	trng->dev = &pdev->dev;
+	trng->data = of_device_get_match_data(&pdev->dev);
+	if (!trng->data)
+		return -EINVAL;
+
+	if (trng->data->seq_rst_clk != SEQ_RST_FIRST && trng->data->seq_rst_clk != SEQ_CLK_FIRST) {
+		dev_err(&pdev->dev, "Unknown seq_rst_clk value\n");
+		return -EINVAL;
+	}
 
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
+	mutex_init(&trng->lock);
 	spin_lock_init(&trng->write_lock);
 
-	ret = devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->name,
+	ret = devm_request_irq(&pdev->dev, trng->irq, starfive_trng_irq, 0, pdev->name,
 			       (void *)trng);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,
@@ -318,8 +416,19 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->rst),
 				     "Error getting hardware reset line\n");
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret) {
+		dev_err(&pdev->dev, "hclk clk_enable failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(trng->ahb);
+	if (ret) {
+		clk_disable_unprepare(trng->hclk);
+		dev_err(&pdev->dev, "ahb clk_enable failed: %d\n", ret);
+		return ret;
+	}
+
 	reset_control_deassert(trng->rst);
 
 	trng->rng.name = dev_driver_string(&pdev->dev);
@@ -333,18 +442,16 @@ static int starfive_trng_probe(struct platform_device *pdev)
 
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
@@ -361,10 +468,21 @@ static int __maybe_unused starfive_trng_suspend(struct device *dev)
 
 static int __maybe_unused starfive_trng_resume(struct device *dev)
 {
+	int ret;
 	struct starfive_trng *trng = dev_get_drvdata(dev);
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret) {
+		dev_err(trng->dev, "hclk clk_enable failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(trng->ahb);
+	if (ret) {
+		clk_disable_unprepare(trng->hclk);
+		dev_err(trng->dev, "ahb clk_enable failed: %d\n", ret);
+		return ret;
+	}
 
 	return 0;
 }
@@ -376,8 +494,17 @@ static const struct dev_pm_ops starfive_trng_pm_ops = {
 			   starfive_trng_resume, NULL)
 };
 
+static const struct starfive_trng_data jh7110_data = {
+	.seq_rst_clk = SEQ_RST_FIRST,
+};
+
+static const struct starfive_trng_data jhb100_data = {
+	.seq_rst_clk = SEQ_CLK_FIRST,
+};
+
 static const struct of_device_id trng_dt_ids[] __maybe_unused = {
-	{ .compatible = "starfive,jh7110-trng" },
+	{ .compatible = "starfive,jh7110-trng", .data = &jh7110_data },
+	{ .compatible = "starfive,jhb100-trng", .data = &jhb100_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, trng_dt_ids);
-- 
2.43.0

