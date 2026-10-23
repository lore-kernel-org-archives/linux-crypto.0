Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.128
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792721591;
	b=Psd3DmkBi4w84W991V27defRpAJkFtudXNntXcGld9tbR5w9irMEk3+Wfpoi2p4bpglh
	 wsMYvSDtvF6tp8ABcTB60gIhTsBQvRJA5ToO420xU39b/MVRkzmC8heegT0/lP3rfiBPg
	 fnsjTfPn1cMfFYkKCVPhlJ8+TkUkPFD9tzNj2kmW9Lq9eK/MNnVO61S0WqmeouLLAFGz5
	 ccuCMC5TLrLxqhLkJKg1mPvn7EA/hETNrN9L7qYeTxY0XtosPl6kExeKSA3iTIuRdkTwm
	 7qy4JAJ8tdkZLqs8n/ZOmhKKmJMAur/9sURCjFoACPZ3HvXEoz/YXlMfPld5asYaLCA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792721591;
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
	bh=QsU4mr3Kv9r5bfuUP1A8XUJYkeK/qGgkK8UIRGgfLy0=;
	b=b+jZvf9nswG0EM4vPG6QbhyFjXkzqooBtnS72E+CyPf+Ffcooejf5zIUcm3vu4GzO4uE
	 DzwXXaQlLzCl7h6lsacff4/8PWZDmkUgW86n8lAaff7zIZuZA8dCdEjJZWhtYHZyzF9Al
	 ff14Dlr9RfvVjM4TCIPSF2m2O4djfkfdlBrV0qH9/6T+oinwkxt/Z9aEc+XHb269gBN9L
	 0Z4FIk/majNoU3ht3AjX3dhChlPTQnFJWsdInJ4p5c4SioiVXJGnpTpD4b7JtOut/lQjM
	 XQ/cTD1pbatM6EMnBTFja86/wcuexemvIjb2UYciYlIDYw4GnueVxf55lhFXlPLrMXw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.128
Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2128.outbound.protection.partner.outlook.cn [139.219.17.128])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5790C606A31E;
	Fri, 23 Oct 2026 02:13:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5790C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyX23C+31L/burfKA67WkatsNLD8JrGrT2aW+Kd2dPNvT/ZCFEsRfCU0pyGT3B0dQ3Aan2kX+eyBfrA6cRe9usqnewzZZhoPhld23A8gc9bO0MhMEuQ7QmcHhlqN/MApDGB3lvuR7XbmLVZY8eAlDhiho692O56NXUPr+VaXhbrP2/81czF4iN8M7aKXMtHDV7DE73X1ju60+Jr2nrnzYP1EVAXYXyvgHG8/hqGX/hZxNvpMLjKhcV3tlYTsIL55qJ643PW2t8qtDl128n/Vn1CZBqQ4U61Ik9BFTfVZ1TPIHSsdiOsMnmRMrppselnMINR4OMGXJExff05+OcV9sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QsU4mr3Kv9r5bfuUP1A8XUJYkeK/qGgkK8UIRGgfLy0=;
 b=WUoTEGwfo/kCXSOq675e+4LZcd4S0Z5yWG8IDR9e95nVV46rIYMGrcSoMnbI3iYnky0a7C90c7f12QMvRldKK5l5GDM/P7HzBVIk9BS41m95CUYNtJa9gpRFig39Z1nf/1mS5GKtsmKpp8vUSiMahs0jzDXKr0kusWLL1LmxcRxCsG3M2YMO+T9eVqvgU31zyP7SlVwA9AT3pdqPhQA8U2B3420jm5Cbo1XLuyInkM/BqVHJEFA2X/y1Yxn1rvxNgOoEDtiehn4iHQUhjtd1jlcg/HXjm1hyQyrXE68fxXbUvou4XnLgph/lmzyZ1jA279mEQtiOknnVKXwQ1iD15w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1303.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 02:12:58 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 02:12:57 +0000
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
Subject: [PATCH v10 2/6] hwrng: starfive - fix runtime PM and power teardown handling
Date: Fri, 23 Oct 2026 10:12:44 +0800
Message-Id: <20261023021248.3763-3-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261023021248.3763-1-lianfeng.ouyang@starfivetech.com>
References: <20261023021248.3763-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0008.CHNPR01.prod.partner.outlook.cn
 (10.43.109.84) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn (10.2.3.134)
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
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1303:EE_
X-MS-Office365-Filtering-Correlation-Id: d92d97de-e59c-4c8e-55e6-08df30ab278c
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|23010399003|261022105027099003|261022075727099003|38350700014|56012099006|261009223327099003|261021121427099003|261009221227099003|261009221727099003|261009220027099003|261021123027099003|261009223027099003|10067099003|18002099003|22082099003|261022113327099003;
X-Microsoft-Antispam-Message-Info:
	/0gnth8Luup8arbInOtuRgVjW+QlPM18lsBE44K3G7MZ3+g/kyfP4QxIiIu95B7NEzdCdIT87WM1e9dJ+83wt7wxVL8RDn4wozOeRNWHnFXcddzZqeKbWZhyhfQao5lwm0CCHxNNTw2h/ue8B+X4aUDjnITzsNhLBu0MyVlV76/7wCC/AYSV/4fqbvrM9qYwgh8JG8xeYcxgbbY+X1BYplD2VHuwPI0+hC1srDOonCDXC0/ZPHLDaGC5Nxo9LSngtnCfdAh+jbTUY2aJoYkcFglT6/D4lq98MS8tQy2q5/9na3cDGRlexe0gV4ZDeZpy9wJw8zrB6xlzq3+vijKAU6bAhdIoWk94/X4OwqFvLuzWuiCl9cq7gcRniwKb/jmj79q5aDZVp9DHWQrLmaIYmLcCvUNi7jE9/aUo9AwyH01bY4+DZxjNn+5CpSRaSW2yB8YeQKOr0dsS21dL9UGzJI3Q3HISuy5YUMDQ5SVvKPUioxdcjhhba4hwFEReoAjgQrxbbleuwvN9REl2jg6vKrLKbYIpdQnenv4Lmk5AQ/o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(23010399003)(261022105027099003)(261022075727099003)(38350700014)(56012099006)(261009223327099003)(261021121427099003)(261009221227099003)(261009221727099003)(261009220027099003)(261021123027099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(261022113327099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6dQ4paXqnWQiTbRpPrs0j515AyonYpLp2LOPCU6pZ9gZf9s2KJa5ymET+5rF?=
 =?us-ascii?Q?CJSjwvmDDC5Bw0F6qzucXRW0gbAdO7EyucdwdR/V7y+K72c/2ebGBVXXmhfk?=
 =?us-ascii?Q?+LuuCHSYoFXeo7tIDV94fKVnAYyHUKVLrMe4FG8GvYqHshHd6z8WlOLQRBwa?=
 =?us-ascii?Q?OVcpFLFYxxA09i5D+Pwa2idf930H8Q+4MBfXWQoQMsZm8dIarIjK9TRh3fbz?=
 =?us-ascii?Q?AWEvBpRiSdgQ8M2Txl3iZKtnqq0J2q83FRZ/fSGtudc2OX39QQbvGHR2gEg5?=
 =?us-ascii?Q?f0qAUEaUgJQUzrivaEhrelLwMHzV3tT6MNS4FlcYnlhhduQj/Lvfc+z//CaG?=
 =?us-ascii?Q?9nvtSdTo1gXI04WyE+qlvlDfawup6wy1zAMM+LraAvxn8kg/kbniUnDNdMob?=
 =?us-ascii?Q?4utltt/OyMdF6wOHGdU/Bu69VYImOncH8cjBZL3iQPlU9DHRJglRdboHBjTI?=
 =?us-ascii?Q?4lU0NqyEhznMcQifHD+jbExGqjwWPQla5PdpO6+Pc8ni3a9no18KHIsAQjhG?=
 =?us-ascii?Q?vK/p+9fRVQjyuRQBycUpDINF0vpRFbCg0+vinFTEQ1Bs4dElsi3JsJ5O1yq3?=
 =?us-ascii?Q?xh9Z1fpOGovS/w2PWD3izuXGyc9MuhJrAkst1hCkPHKCwCL2fpXIxN/Dfqe4?=
 =?us-ascii?Q?Tc5sard48Anf4t6b989CGFs6QH2hLtq1yuAJUtBBIk9IpmefM5hZNUy91QQa?=
 =?us-ascii?Q?bJgC39IILwcDlOzy7IJTPVAZpGwPIkf3VTUh/NCvfzym+pFc23WUIjrwRPW3?=
 =?us-ascii?Q?CLM6mhEIsi19fvMAqeRU7pzmrWX2kBwUzdRvFVnCvlKoKT6zQXsaoqKC40p4?=
 =?us-ascii?Q?c5s/VMKCtVJlikjXEy8R58hsYiu3DEFwuL3OLMKc/V9c8Gg8wWFUBdDxrZ2R?=
 =?us-ascii?Q?4aBgJnMeK8SczDAnGHJFlUtrYow+OZc06CmAdgKvi/PpxSSwnnTTAATyiwO8?=
 =?us-ascii?Q?hFoc6WIfgSUhYPM/NAuG1Pb4htyNdKxGpv+K54oQcYdKxSZM1eEqcG77G8/q?=
 =?us-ascii?Q?wLPyiQFiLXmGTJM7YQEuSJc2mTRsOE4Iq0XoEocl84qUtn6TfnMT5sEFHOvP?=
 =?us-ascii?Q?6X2vqtnoO+usBwZrrbJ6jxyPOuHLQxP899KY+BN+2HcD/9uhSwm+oBMLnq+L?=
 =?us-ascii?Q?2GjtdgX9L0P/+TVTgQhHcIGcHo/Z6DvrPDyNKmyxOqV5dBKAm7bz4j/mJkDB?=
 =?us-ascii?Q?g9kpc76lnu/XZN9OCi7/xsNglkwb9vNcgv+nN2IJI/8YmpKD5fpuAiEzvgMQ?=
 =?us-ascii?Q?Gy3CLivQsf21MzQRWJVzGheIiLbFWbFnlvM3jyULEU6p1rCAWBI0PuMP0lO5?=
 =?us-ascii?Q?kbHv+VFSF6bAowJ44gqti+hXZfhaVQQMlblO0XKSpcxZMtyABp/tUGPYTrmB?=
 =?us-ascii?Q?MWQSN/ZIfq+S3gnU++eIvrK8dvoMbwcuK3AvW4zY9ZLDbHGmEdqXzwq0+Khm?=
 =?us-ascii?Q?nQn5fR7Rj7X1lJ72PUuV4DY1S/hr8HPUWAtA0/vpjJEHvKvOrtJXCTIOe5x4?=
 =?us-ascii?Q?93cGgYkH1sCq9eMb+MFto0vXugu/CXYUGIW9k83roDMG69gsyHJNTPySTu3b?=
 =?us-ascii?Q?fn4c8Sg4i1zXrZE/3kWWHbY9jHCZZUpK0wA8BuFN33QsnME49I+fTz8LlUJV?=
 =?us-ascii?Q?mmnb/PfMt4QcumCu7RR6sGJgvZbvl3kffNVcqLJZwM9FcNZ7DcMKtp1N4xg3?=
 =?us-ascii?Q?Y4nbmBrC87JFzh5y9hH0xjVPexBLFLej2Hupcdulyqt1LgPZQ1/9W3IUF14c?=
 =?us-ascii?Q?wFJFSSv2AhjcwSSbcqIj1fNM5OT0ieNSo1lop98i4T3i4U8530rZ?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d92d97de-e59c-4c8e-55e6-08df30ab278c
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 02:12:57.1953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6lmMwjAvMuC6xtkosJ9LvDDNIy7yhbCgJGpLdnJuSodZDTxuF8FpbieozvtaUdkPNjyCwyYNkwzNR71c+MA8kAbvt6/AwJ/3AqiVKuRntyTsHvCBo+Niriz78TjLVSfK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1303

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

Fixes: 9b2b61126a06 ("hwrng: starfive - Add runtime pm ops")
Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
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

