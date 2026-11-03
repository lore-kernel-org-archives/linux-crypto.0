Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.95
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793691193;
	b=vI8omhhdbtF9HQLkl9foDfvFdoDq5sq92zEHT/zS9XvDn/3+NhE0k5TWuc4KIjqh+O5/
	 /N85S4tqZNGe8aQPgdyn7g2qCVRaJJJjFEIJhigHdZ/Ng6+eCYV6DWZsnUsHPSvc26wZn
	 k2ElcyUHsLA+EAdUNMLN8WMSLmtNNzdcGF7rn6J1ndt8TLVTek8kGgIR4MdQ97IdlqjG1
	 cXF/DchcOz7lCMbq8g0+szCi4QHHFbZ8mNHPfiYJS0d+XYOkt5YSEsDp27spu71A5hfUS
	 dA7s+yXV505LTNepx3+XWhrCxYH9sTlXhp6FeigFWjfFCKAeXu+9bVZ7aQi2vWQsNTg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793691193;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=2CmvpzdqzSmI+3ntVxbsLNEWyo0F1OsgQPY3STth+B8=;
	b=uWnSKtPsr+MSjHazQeMcOPW2PsccyFqvDKUOdRKlIw3hpMld6jPF1cnnZgU9HeMKFYlb
	 7JvIksDymODqrm+VEfM+LpH39gO8obT7VmMfa0zGoUdcnpOaQjDGd0SCl4lbxUS+9SCtJ
	 1uPtZ74ZKv2xYAUGGkOqSQ3UyJehJFue37qTDkIkblr+siQS3aD3fsr4mFfbiYucL1P+Q
	 G3jh0ktc2hTNKwPqBHc9R+IYtrfA3Yw5h8I6o/1ya5OfMaj3xez+0UN1KoZhJucP/Fv45
	 k7jj/pPrHjncqwV3U/8kG+cBBGfwrZgKuvcyHayyexsG66o31ZgCEM2cVL5MjbKr2DA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.95
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2095.outbound.protection.partner.outlook.cn [139.219.146.95])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E21606A32E;
	Tue,  3 Nov 2026 07:33:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98E21606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2T0/bqU49Ys1COYj53AafT1Kjht5KpM69zTUFKWx7guUgy81E5mqBoO+LZWEVsnw6jeiKtMGasigCWc4KN0hczgV8gJaQlMBhqF7mRxGviDiS1bVPzPPWBs6e1mVGuWzOzWg2VRdFCSmXNMIfao0cVla0/oGfs/QlCvCMfdRbEo+mBSE26XTWSNUBsWluAsuJWxF1PMC0/jwUKtDBUdF/cCa1MJObBJSmxUo0phJLnOcqhbz9W6hrMFgR0VovOV/5T051R7FcW67NXyxl/fA1R+wlzPd3TOqYU+GMB2YRo6GRZtYiELF8HJDzCkhPCOMBfGXkYZtlkCxwud9y3qtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CmvpzdqzSmI+3ntVxbsLNEWyo0F1OsgQPY3STth+B8=;
 b=LqJjZOk9TABzH7lDrwFLdW4oM378st7wkMI5LBhKppcKQl5C3l76CtLJpM8PFCwwewmskbq89j4Ar5M//dgFreB0L62BawFkM4st0ipCON3HMUVtAh8nbH3dWUNIAnF7h2d40Bl8/OF5O8/LYZAVGCDNRhPCU0wh2U//t/FI82TxHRzTHEN3QQsQFFmZR8LnX+rjbnIc9MKNuUPw35euJioSqdmeGL754FkibIuAHGje3tOfvwys0dGtKOEamePI+WwMKOnDjS2W30wE1/QXDGlXUw63r5mg9NVA7Liv5F5+tIIrGGr3WZqiHGRMDjBJiH5UADMyHTH1gbHCmUS9dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB0999.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 07:33:01 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 07:33:01 +0000
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
Subject: [PATCH v11 2/6] hwrng: starfive - fix runtime PM and power teardown handling
Date: Tue,  3 Nov 2026 15:32:48 +0800
Message-Id: <20261103073252.3028-3-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103073252.3028-1-lianfeng.ouyang@starfivetech.com>
References: <20261103073252.3028-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0008.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510::13) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB0999:EE_
X-MS-Office365-Filtering-Correlation-Id: 57981b65-92f9-4318-da60-08df397cb070
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|23010399003|366016|10067099003|18002099003|261102123227099003|22082099003|56012099006|261022113327099003|261026121527099003|261022105027099003|261026140227099003|261022075727099003|261009223327099003|261009223027099003|261009221227099003|261009220027099003|261009221727099003|261028144727099003|38350700014|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	qHF2aGrXVhs8zc4lIrfx0HffX3P7BxFzB2rCf+oCVqcec/VNYWyrHXdq6qfKA+lRHrh4XDQUghMk6q0eu6f58HAcCrT3ITr9A9DHA73Jg1XEoZzqwLSGCW3vaUpUN1/GAQpM+opm8/vopaQ9cdcYDQHKSmT0fvHF3kOaCCXV4o1zXn44HLVTXM8bqBmg0VgE5h6r/pqmnCK0YSsEJASsArrzpiS3f5KwgzFPg1Nssazb5VPIXw1dTKEC8vBElpVZ/cy5SSwQOopgCD5fZEOpJRM9YNtZO3OVOsgcJsHUGtlb0VSdAvEjl2lJyoiQbeHlzYAiTOjF3Vx7GCgn1MGWiDu2o1t2mafql11f03uffL4vNcwjTJqb5fBMTNUReMiaHkXADq4nvxsJBnYiUPYImXQDcuhq009A4iuJL3gubYkauSyEK/bMlE8GrvHz2iwSmfEt8DqzkFMGHGrKA4+G4r0ZzZpKq8SrmIvFKhvR/YmwDGur2KSqclYumwaIZpMPlBz0BwqiBFGLMpsxmHb2d67+HlDMA/z3yjoUH02JLjs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(23010399003)(366016)(10067099003)(18002099003)(261102123227099003)(22082099003)(56012099006)(261022113327099003)(261026121527099003)(261022105027099003)(261026140227099003)(261022075727099003)(261009223327099003)(261009223027099003)(261009221227099003)(261009220027099003)(261009221727099003)(261028144727099003)(38350700014)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YRp+qnrZUA4z4ny74/2Ju4PLCPXJAXmTTx0hyBwrbEuyEZgKzoBigskWqZeD?=
 =?us-ascii?Q?d7HMZrc/AIz2fPjhfXX91mKjVfmlIqYPWkGy/w2tNb5NV76cvt+7Gk+Oji2L?=
 =?us-ascii?Q?KlC9bpcP9kz8vaB7JS+5hL+ePgS0hvBaBSVWkIUQJp6v0xn+CbpjS7UVyImH?=
 =?us-ascii?Q?t2QXKZXa6d3KHh19EnNdRLPs1+dYehC5B6qihwN2jSSdikyQ6RPbdpE9KY4z?=
 =?us-ascii?Q?PtBx5EX/j01hDfGAbMZFGzeTaY5DDLIHcuhmvn+jZLWy3CZfAGBaZCjKkyHe?=
 =?us-ascii?Q?/SbaSmXtl5zFLdzX0IG7RNjFoynViWdsL/DltWsWWdLsNfB9kUUczYsOirzc?=
 =?us-ascii?Q?G5M1YPiKMs+tARY1JFMxJAF/Japn7Umq/zVVdW0GWvFieIzGyOeGEbMfOpB4?=
 =?us-ascii?Q?WRyzLzyXfp8oTQlccdb2BTkQ952EUeePuQjJHK7YSELTqm/rO4gAMVbUjVoR?=
 =?us-ascii?Q?cW+qcNJ/cyNGTzPly1CkjliuUS5ktfMckDTS+KM8B69ZZZAx2rX88K5FR68W?=
 =?us-ascii?Q?otWRcwy0zggARYZP8r0jQMoc/W/fem9Mr85+oGvyOXWzRZHD4pCK/3Rw5l5A?=
 =?us-ascii?Q?/rmnpi89QplnJNTle6yxjGYP6KwSwLcXd+KtQ5wFRhf1GZnFEn7/ZYhxlDWK?=
 =?us-ascii?Q?h1AHxgmNrzTihJKAbjhfQBw8AA4NLg/7zktlMJ0hZ2bpGPIy8OBrtMWCyaLX?=
 =?us-ascii?Q?FOaC/QMaspwt63oUcirziB1Z+sRYC+MuuFwLpkKxrXCUcO9WkIthKdzOu8vY?=
 =?us-ascii?Q?MiFxTPMxSISwm/s9364NALFVA7aM5UoGNE0s26ZHyEVikKSSkpOhKqwSH5XC?=
 =?us-ascii?Q?TDUY4xDexVAGM0qFupbFP0nXvN8pDvVSObVMgeJgi5VLkbI72Fem9o/iYsR7?=
 =?us-ascii?Q?iMLQyObajfRzmFjl/FVYfut0rv9bfzJgRAB0NU1gs8ilvcEM/3tryK6G8SRv?=
 =?us-ascii?Q?7v88Uv3omOr+5QPFiReEZFYpvNQ2wADLAE2os2q66c66QszQqSYshv3WIcD2?=
 =?us-ascii?Q?pDi9Pi1hp9EN2kPoy7OKGwKXJUY55wKCeJvdTQRgnYLcDzRNgkz+IUUFlSHa?=
 =?us-ascii?Q?xMTyOYqU7+kTCB4pKKtrcFkG6JqWFg4M+EsTbOiPMOtaaHFVYw1QA/MnWrIP?=
 =?us-ascii?Q?HaXtN1w8OIkvE7U3Bktl/QllBaBUBATamPsI0wCJnzBoZICgadO4AW0Yil7f?=
 =?us-ascii?Q?OBHL00EB0DHMn2NqKbBG7EGErc9Cs7x4EVih5EBKJ/q7DDsF0C9g33b/gR23?=
 =?us-ascii?Q?BrqISTkVK+isZNt3M11qiTzBkzWiSFAmMM2Pn8PBUSBkn+gGpMsn3WAHwGyA?=
 =?us-ascii?Q?zA6yirYnj1099QjXDJjBJh5oSlT2epkOwiHIdOR6w5slvITfpvTA6d6fX+wB?=
 =?us-ascii?Q?UtY9g7R9wD/u1h/CzOnj1JkJmJBNfSo7drH9qB+DlBenyQ4TFWPr7j1OKyOM?=
 =?us-ascii?Q?7srP89qMUtskgKwwP0yoZjTQ0vXdUZsDSwFeop5hWrQhwevGpbXqYlu8qqtO?=
 =?us-ascii?Q?/Vu/pZUR3lcds5B6G1N0cko48x98uUyyF/OI/LMqPSbs7ZpuQscs7+UXpsNQ?=
 =?us-ascii?Q?gkoA5OSlje2A9t4TqfWX1E35GyWKY2SMdcAt1o7/YK41CmTLX2JWIUsKAMjp?=
 =?us-ascii?Q?K7RXHIyxazJg/YeceWlrKGyazY8ozk2i7hIknaMFiWeeIGEMHzfTNh+UwvEZ?=
 =?us-ascii?Q?feRUCg3JDmZTci0H0NEz8sLcW21BOeCBhEY/NJtXYkPNWZBf4WwJVcKq7V1u?=
 =?us-ascii?Q?R5LBLVjLDplJNIjuXDJQJAMVEOvppOwTBX9chIAMBWapwg4BWMa7?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57981b65-92f9-4318-da60-08df397cb070
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 07:33:00.9539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B6DtMk6aUngbKV3AVW5QPg3EYMiXj/G6DQCwgJ1LiGYeiELOYbxy8ssS8/JpvnqMVj7z3ng9avuEdGXF/TL0IVD5XSnOr6bhiq2/vTLw91LBwov1spU0D0vYEz1HSeL2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0999

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

The runtime PM bookkeeping of the driver does not match the hardware
state it leaves behind:

 - probe enables the clocks and deasserts the reset, but then calls
   pm_runtime_enable() without marking the device active. The first
   pm_runtime_get_sync() in ->read() therefore runs the resume callback
   and enables the clocks a second time, and the autosuspend only ever
   drops that extra reference, so the clocks are never gated.

 - the system sleep ops point at the runtime callbacks. When the device
   is already runtime suspended, a system suspend gates the clocks a
   second time.

 - ->cleanup() asserts the reset and gates the clocks, but ->init()
   never undoes that. Deselecting and reselecting the device through
   rng_current reinitialises it with the clocks off. On remove, the
   clocks taken in probe are only dropped if ->cleanup() happened to
   run.

 - ->init() and ->cleanup() access the registers without holding a
   runtime PM reference.

Move the clock and reset handling into starfive_trng_power_on() and
starfive_trng_power_off(), which track what is currently enabled, and
tear the hardware down from a devm action so that every probe error
path and remove unwind it. Mark the device active before enabling
runtime PM with devm_pm_runtime_set_active_enabled() and let it
autosuspend from pm_runtime_idle(). Use DEFINE_RUNTIME_DEV_PM_OPS() so
that system sleep goes through pm_runtime_force_suspend() and
pm_runtime_force_resume(). Take a runtime PM reference in ->init() and
->cleanup(), and make ->cleanup() only quiesce the hardware; runtime PM
and the devm action take care of powering it down.

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 drivers/char/hw_random/jh7110-trng.c | 150 ++++++++++++++++++---------
 1 file changed, 103 insertions(+), 47 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 61eb4db7ac01..17932cc6d7aa 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -104,6 +104,8 @@ struct starfive_trng {
 	u32			mode;
 	u32			mission;
 	u32			reseed;
+	bool			clk_on;
+	bool			rst_deassert;
 	/* protects against concurrent write to ctrl register */
 	spinlock_t		write_lock;
 };
@@ -138,6 +140,60 @@ static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
 	writel(data, trng->base + STARFIVE_ISTAT);
 }
 
+static int starfive_trng_power_on(struct starfive_trng *trng)
+{
+	int ret;
+
+	if (!trng->clk_on) {
+		ret = clk_prepare_enable(trng->hclk);
+		if (ret)
+			goto err_hclk;
+
+		ret = clk_prepare_enable(trng->ahb);
+		if (ret)
+			goto err_ahb;
+
+		trng->clk_on = true;
+	}
+
+	if (!trng->rst_deassert) {
+		ret = reset_control_deassert(trng->rst);
+		if (ret)
+			goto err_rst;
+
+		trng->rst_deassert = true;
+	}
+
+	return 0;
+
+err_rst:
+	clk_disable_unprepare(trng->ahb);
+err_ahb:
+	clk_disable_unprepare(trng->hclk);
+	trng->clk_on = false;
+err_hclk:
+	return ret;
+}
+
+static void starfive_trng_power_off(struct starfive_trng *trng, bool assert_rst)
+{
+	if (assert_rst && trng->rst_deassert) {
+		reset_control_assert(trng->rst);
+		trng->rst_deassert = false;
+	}
+
+	if (trng->clk_on) {
+		clk_disable_unprepare(trng->ahb);
+		clk_disable_unprepare(trng->hclk);
+		trng->clk_on = false;
+	}
+}
+
+static void starfive_trng_power_off_action(void *data)
+{
+	starfive_trng_power_off(data, true);
+}
+
 static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, bool wait)
 {
 	int wait_time = 1000;
@@ -174,6 +230,13 @@ static int starfive_trng_init(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
 	u32 mode, intr = 0;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_err(trng->dev, "Failed to wake device for init: %d\n", ret);
+		return ret;
+	}
 
 	/* setup Auto Request/Age register */
 	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
@@ -201,7 +264,11 @@ static int starfive_trng_init(struct hwrng *rng)
 
 	writel(mode, trng->base + STARFIVE_MODE);
 
-	return starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+
+	pm_runtime_put_autosuspend(trng->dev);
+
+	return ret;
 }
 
 static irqreturn_t starfive_trng_irq(int irq, void *priv)
@@ -234,12 +301,17 @@ static irqreturn_t starfive_trng_irq(int irq, void *priv)
 static void starfive_trng_cleanup(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_err(trng->dev, "Failed to wake device for cleanup: %d\n", ret);
+		return;
+	}
 
-	writel(0, trng->base + STARFIVE_CTRL);
+	writel(STARFIVE_CTRL_EXEC_NOP, trng->base + STARFIVE_CTRL);
 
-	reset_control_assert(trng->rst);
-	clk_disable_unprepare(trng->hclk);
-	clk_disable_unprepare(trng->ahb);
+	pm_runtime_put_sync_suspend(trng->dev);
 }
 
 static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -247,7 +319,11 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	struct starfive_trng *trng = to_trng(rng);
 	int ret;
 
-	pm_runtime_get_sync(trng->dev);
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_warn_ratelimited(trng->dev, "Failed to wake device for read: %d\n", ret);
+		return ret;
+	}
 
 	if (trng->mode == PRNG_256BIT)
 		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
@@ -270,7 +346,7 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	ret = max;
 
 out_put:
-	pm_runtime_put_sync_autosuspend(trng->dev);
+	pm_runtime_put_autosuspend(trng->dev);
 	return ret;
 }
 
@@ -320,17 +396,13 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->rst),
 				     "Error getting hardware reset line\n");
 
-	ret = clk_prepare_enable(trng->hclk);
-	if (ret)
-		return ret;
-
-	ret = clk_prepare_enable(trng->ahb);
+	ret = starfive_trng_power_on(trng);
 	if (ret)
-		goto disable_hclk;
+		return dev_err_probe(&pdev->dev, ret, "Failed to power on\n");
 
-	ret = reset_control_deassert(trng->rst);
+	ret = devm_add_action_or_reset(&pdev->dev, starfive_trng_power_off_action, trng);
 	if (ret)
-		goto disable_ahb;
+		return ret;
 
 	trng->rng.name = dev_driver_string(&pdev->dev);
 	trng->rng.init = starfive_trng_init;
@@ -343,71 +415,55 @@ static int starfive_trng_probe(struct platform_device *pdev)
 
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
-	pm_runtime_enable(&pdev->dev);
+
+	ret = devm_pm_runtime_set_active_enabled(&pdev->dev);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "Failed to enable runtime PM\n");
 
 	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
-	if (ret) {
-		pm_runtime_disable(&pdev->dev);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
 
-		reset_control_assert(trng->rst);
-		ret = dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
-		goto disable_ahb;
-	}
+	pm_runtime_idle(&pdev->dev);
 
 	return 0;
-
-disable_ahb:
-	clk_disable_unprepare(trng->ahb);
-disable_hclk:
-	clk_disable_unprepare(trng->hclk);
-
-	return ret;
 }
 
-static int __maybe_unused starfive_trng_suspend(struct device *dev)
+static int starfive_trng_suspend(struct device *dev)
 {
 	struct starfive_trng *trng = dev_get_drvdata(dev);
 
-	clk_disable_unprepare(trng->hclk);
-	clk_disable_unprepare(trng->ahb);
+	starfive_trng_power_off(trng, false);
 
 	return 0;
 }
 
-static int __maybe_unused starfive_trng_resume(struct device *dev)
+static int starfive_trng_resume(struct device *dev)
 {
 	struct starfive_trng *trng = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(trng->hclk);
-	if (ret)
-		return ret;
-
-	ret = clk_prepare_enable(trng->ahb);
+	ret = starfive_trng_power_on(trng);
 	if (ret)
-		clk_disable_unprepare(trng->hclk);
+		dev_err(dev, "Failed to power on: %d\n", ret);
 
 	return ret;
 }
 
-static const struct dev_pm_ops starfive_trng_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(starfive_trng_suspend,
-				starfive_trng_resume)
-	SET_RUNTIME_PM_OPS(starfive_trng_suspend,
-			   starfive_trng_resume, NULL)
-};
-
 static const struct of_device_id trng_dt_ids[] __maybe_unused = {
 	{ .compatible = "starfive,jh7110-trng" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, trng_dt_ids);
 
+static DEFINE_RUNTIME_DEV_PM_OPS(starfive_trng_pm_ops,
+				 starfive_trng_suspend, starfive_trng_resume, NULL);
+
 static struct platform_driver starfive_trng_driver = {
 	.probe	= starfive_trng_probe,
 	.driver	= {
 		.name		= "jh7110-trng",
-		.pm		= &starfive_trng_pm_ops,
+		.pm		= pm_ptr(&starfive_trng_pm_ops),
 		.of_match_table	= of_match_ptr(trng_dt_ids),
 	},
 };
-- 
2.43.0

