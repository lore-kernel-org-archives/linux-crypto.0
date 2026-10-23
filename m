Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.128
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792721590;
	b=nh7/2HzbFBe6//WDvA+5Gml+HxfpuHXz8jpi7dBWOmkM5PLHF6EBzJMRuJn/y5NoJ+gU
	 uvmsF1q0SrdeCwcAV1rWDng562rW+H0avy73Oj877uqheEBUpHY1yAp45Z9GzExU5EJCQ
	 ef/zywRq9IyKUBxNnSwUAfLWIyVx7ERJkVpFlU6yRKsOTSm3aift25wYWijy0F8vAHwTV
	 2RSSRsx/CIcLrH+RMX/KBAV6/ruRcgaiV24e8ZAPhawRC5bWmF6eU+TyopKn2Wg77FwZO
	 Q2U8vCc0W6deLbNj9nW6Xw8nmhxUbN8vA31HkA7DiLGic9Sxg13w3zTb3pvmhx4w/kA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792721590;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=1LLaSsJ/NMlfvykRTb2Z15w4jd8ryB24H9bJe/HqqG4=;
	b=Z4MX2OItoCRlBUhOnJvgLPMQpHeiHFodCcHu71+f0LkelFE1bLwFW3X+VnuleykgWtkz
	 TQ1Av/dvPL9I0cDVWFWrbS6wKLZ7M3TrlU650vhqm5J1StnTxdiF6C4bOiIyY81p3MltI
	 S0f+iIwrIprLImZg++qJXuZNhgnOEKJUTr3xsO0S2XzN/2i+jWM8N5f5aOXubGwVtreWl
	 ArRIeOPNn0cjQstCO7x5bP6n6eI46C3ulSmWPuY/VgxaHZuMFmeL9QlssK5wSPpMgHEEJ
	 xDWIeMNLmza0qm4D3aDdBbpV29UiI0u0vs+lYxJZyl5RsFrNIJBYrdR9nIRAQoUUzgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.128
Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2128.outbound.protection.partner.outlook.cn [139.219.17.128])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D654A606A319;
	Fri, 23 Oct 2026 02:13:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D654A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaEggxSu9yTUjb5u+LLcZcGoOEFG//Pj1ng1EJFqHUnhvzMInpNr7ilMI1wN9Z2yAnNGu6KwxFycYpn55GMRU52//3xyULJQVaE5WIxzHRO2N+bJkrCzM5LO8cTQV7hZF86jIFBfI5cf7S/wWXQ7KWTGfOhYz3HGASJs4y1x27F993WGC2tzEC4SA+Lzka1oehw9saQpfdWEB6NS0zUf1IDNFvJFVtQ3uq7qHjuSO6S5T+ivgis1HkLgIggP7u3KdO1CCdSoo4Pl1VUSyZ6GDoF+ivOLCvXXpW6T2rsZNd7dmixjkqPeCx47wn8pWO1KHsjJaQrQqDe3Rkte8asxJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LLaSsJ/NMlfvykRTb2Z15w4jd8ryB24H9bJe/HqqG4=;
 b=h3zvGaQ5n58+rycEwlMFBBRWBQCx/G//Vnwr3HcO0HsQCjQpzAaIHMDY5X0KrqPFwjxg+wDGIW8Vf9Xan+VJndHYuqSzDjKJijlF0ZvLCI8a9yXc+7qV1FWT+53dGrU+LT1JkKxqiE7UnP6ZhMBeUqtyNXXzrSbItV51HI7/1I+9tiURB1SV/TxXuFjjRYncmk9NELkA1XPyaFf99Mh/LavRQ67fh1wKRrxgDAaTfc3rvHrLHeFnwFXqacVK+FXAoNGc2mCarhipw8MaoIwH3uJeyuUr4opcdifnlPXQ3AbSBWU7omJQzND1xcNyjVjIqQW4DtdLmLfjRqemGjMiZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1303.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 02:12:56 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 02:12:55 +0000
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
Subject: [PATCH v10 0/6] hwrng: starfive - fixes and JHB100 support
Date: Fri, 23 Oct 2026 10:12:42 +0800
Message-Id: <20261023021248.3763-1-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: 6bece97a-2ecf-4986-390e-08df30ab2674
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|23010399003|261022105027099003|261022075727099003|38350700014|56012099006|261021121427099003|261021123027099003|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JuU7CBHWiDbFqVn3RU1S9XpPQ2Y7o0zGJCUW574LRftyBwtoP4RVxo5r2lPaQX44bFGcRNvMVA51/m/ch9xtmLu1ERa5ejJBkOABRnYf5/ZDUME6Xo8olT6vPfIVYyPVYkZhTqbmspfeygoyXutwtAGTu/DjnvgKuB1qCkZ+Uvtnrd/W/FZZidg+mXAkB1Fc3OeIQSpyVlw9HbT54+sUbN1bxsdpuf6Ch4ouyJ5MO5rchOaao7tB3NUIYyXCPVdkkiFDpTyNGgCgE5bSi/76JeBpT7sF1vrU6ZhS8yQ0hK/Qx+8IqSvVEcjvhs/vFeCdHIS0nIplPYoYu3N+/Bn3fM0bHHeTDAMZ7qEciUaFYgwOLJ+AR6eYGnUApT0tagPBZWVcK18RvRSy1Vbd67igh/0OeCGxr4W5QzikMgpwVnIUpLn55i9FtIanZTEchvzbCYyMghLeynl2efGd23ps/cs2v4j4E3E2xLqhvtAVIXR/PZrm6N4E4zyWjnn4+55BYk11T6Svg6qjGP/rz9GYwNfNG9UhwCcSekp/2UH/QemT1YxsN39pt1v8oqm5/u1m
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(23010399003)(261022105027099003)(261022075727099003)(38350700014)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vhFXgoocMOCUMiTsC0rrTgYZ93V2VUHS61WC2Ec/6qLI7ifGS1fQh/izwibk?=
 =?us-ascii?Q?VWp1gi/kD1oJOun73Kkec2E5ZxEFafMzxNA/nmTlAzEYoB79gm6ZNS/m5ial?=
 =?us-ascii?Q?wezDxWyS1EeMFTnvT5EXjim3TzENCzvJ0gDecuAsNuN4UMJpwceLUpFNWbOq?=
 =?us-ascii?Q?M+2nvkxJJpZFofQpF1CfIoD3BhFxmhxzNMwI01O04JrfdM2eHlJHwI1va/n9?=
 =?us-ascii?Q?SSgkN0I/gNBff9Wv/FZRB3l/bnCdqdi1nkTjln9JLFoAKlyDHve2gYF7492C?=
 =?us-ascii?Q?P0/3S/FWfIKkcomQnuu+IunZm6G5W8rL3fwmPoI3lOwM6a/lykq6dU5LUG3r?=
 =?us-ascii?Q?FXu7WlLQs59ZGhXA/YevnebJOc4Ff+8bM1D5HJSxUSZPg4J2UcD4GeKFTBfj?=
 =?us-ascii?Q?1y+VahLNUOGKiRNiLlNmbRSWrLnpBTK31wAog+x9BYOpm2w4EjuHHIcbNPuV?=
 =?us-ascii?Q?jro4BjTjXj8pLtQjxexWoD+9hk1V73dgDT4Y7pJZc+LKjwR6xsIfZPoyvekV?=
 =?us-ascii?Q?CDjxiRJb3ht5AVu4yj3tLCeN3GqxtG9zoCIH+t3e0feWyuxb7tITGzf5OrTs?=
 =?us-ascii?Q?hJRTgdeAv7k8IlaYN3BZ4rhr3WneX9/8vUkWjhBQLuuZzHgqiXGzu6dQJt6G?=
 =?us-ascii?Q?W+Wpm3tvRfyLHemqJuacTKQ/wg4/QNcvf1PLmJujqrJtrbbX4gfvTW5UaWYl?=
 =?us-ascii?Q?ntNkFvQ7fYC7l5y8phVsrKTec0e9JcoiJPrH2ybx2IrdWir/kCx6mAW9iMY+?=
 =?us-ascii?Q?QKcGII+4RKLGiUkYwRitnqlBvbNVJ0L74iGgSXElvQP4HW7n7Ipz5+M74CU2?=
 =?us-ascii?Q?7ge1uMI1THiNcLkmW6A8/DBiut2544V/U/yNIvcEi/Z2TXq+SF5fiAVmV3DX?=
 =?us-ascii?Q?rCs9hqH9QpiOeXbmbIIIzOOlj3kmhSTSbL3Z8tAx1OPd6vlpXpUzzsQO7vMr?=
 =?us-ascii?Q?jZtk/gvL9ClZ08t5SHjZn2gK97roVJym0Or7l3OBfAel3RpRU3pZDTAp3YuN?=
 =?us-ascii?Q?cqGIE2pXQLF9GD8ZgMZvx10wukbBSjLYGr2abESBjprFWzwbxJLME8ZGH866?=
 =?us-ascii?Q?mj5H4Okq7/4Fj3WbjZsEO/CvWPNLtbtbmhIjO0CVW651rGEUpC2qVcqmGhZ8?=
 =?us-ascii?Q?A1BrriwDuIIkmpmog/5jouspI08X/vhxdJMnw4JadWR6Y2HtVRPu0tFqoD7x?=
 =?us-ascii?Q?KkAopcqqz018lqPY3opjUQj+5y74rJVPCFe8nk57Kzc7OM1hvsr6K4MpVGEH?=
 =?us-ascii?Q?FoayJhYAw5RsyvdBxTRW5LIHfw4Ogf+KalbqElI/8fSf9kWGtm44FJBulE28?=
 =?us-ascii?Q?AWzBxRhAg2D0+TqpvTdenYTsypBGKbewiONOWwPRHjKmS0lBcBGucESBfBpz?=
 =?us-ascii?Q?sKRxtvJNsQN7gjf7+ZdEOJkHwlLyT+7zYPd+I1+SpYo3FnFYVNeVSIX3XBXZ?=
 =?us-ascii?Q?faYbFSNU1k8HS6xUca7l9KhtW+ht1NFEB0zMfCNTWOUrbaRy/sVgVM8yja+x?=
 =?us-ascii?Q?vR50x3F6dnpbQ+8qksqZcYr6EbInk7jdDVIJAy/nMnPRtOQ48FEmjAJiXPQA?=
 =?us-ascii?Q?sHRIjnbmGceKO8K+fV11HDdjRZ6Zw27fMUuHmooFg4YinqYMRwcmAq1wQ7sG?=
 =?us-ascii?Q?zmgPRcJawtF671ktb01TPWotJ0CePH6+f6jY1cEGT2TszYcdCIR0Kg0WdsdK?=
 =?us-ascii?Q?+ISfXr4Op4IZccR/RPPOvFaGZlVUygKMlIk+EqKSqzuZdz0L8shFeQmwQput?=
 =?us-ascii?Q?gZkzUovfxG6CBxSu9L2x7RXH3CFT8QXxW3bLjUOkuiXow9hswDou?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bece97a-2ecf-4986-390e-08df30ab2674
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 02:12:55.4111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LLFhIvrT5k5n6iacKopkNbpLFH8iWJ4vApVE5l70cR1xs9vfPgQ8oLvDKqgJ4IR9oTbr1y3cigt44JL1+FzL8lUeyRKPYUCziHo9sFmvYOJlZ2lI9oWMEtmmKGix8JYu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1303

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

This series adds support for the TRNG on the StarFive JHB100 SoC. The
JHB100 needs the clocks gated before the reset is asserted, so the
driver grows per-compatible match data describing the power-down
ordering.

Earlier versions of this series carried all of that in the
JHB100 patch, which made it hard to review. v10 splits it up:

  1: dt-bindings for the new compatible (unchanged)
  2: runtime PM / power teardown fix (backportable)
  3: SEU reseed moved out of the interrupt handler, command
     serialisation, IRQ lifecycle (backportable)
  4: include and cleanup tidy-up, no functional change
  5: match data and the JHB100 compatible
  6: MAINTAINERS

This patch series adds support for the JHB100 SoC TRNG and fixes
  clock/reset teardown ordering issues.

The first patch updates the device tree bindings by removing the
  obsolete JH8100 compatible string and adding JHB100 support
  while updating the maintainer.

The second patch reworks the driver to ensure proper clock gating
  before reset assertion for JHB100 to avoid reset-domain crossing
  glitches, fixes RPM usage count handling, and improves error
  path cleanup through devm actions.

Changes in v1:
 - Remove jh8100-trng and Fix the compatible description in .yaml
 - add JHB100 and fix clk/reset teardown logic code

Changes in v2:
 - Balance the PM via pm_runtime_set_active() in ->probe
 - Add devm_add_action_or_reset() to register a resource rollback function

Changes in v3:
 - Supplement .yaml commit message
 - Add pm_runtime_get_if_active() to check PM in irq
 - Balances pm_runtime_get/put calls in init, read, and cleanup paths
 - Add per-compatible match data for the teardown order

Changes in v4:
 - Modify .yaml commit information to non point description
 - serialise the command sequences with a mutex.

Changes in v5:
 - Run the reseed from a workqueue instead of hard IRQ context.
 - Balance the probe reset_control_deassert() via a ->cleanup flag in the
   PM suspend/resume callbacks (was skipped when already suspended).
 - Use devm_pm_runtime_set_active_enabled() instead of manual PM enable.
 - Register the IRQ after clk/reset/PM setup; reuse
    starfive_trng_release() on request_irq() failure.
 - Check reset_control_deassert();
 - drop of_match_ptr() from the match table.

Changes in v6:
 - check lock in starfive_trng_read() using mutex_trylock when wait is 0

Changes in v7:
 - using mutex_trylock when wait is 0, otherwise use mutex_lock()

Changes in v8:
 - rebase patches against the latest tree

Changes in v9:
 - Fixed the PM runtime reference leak in starfive_trng_read()
 - Drop redundant pm_runtime_get/put calls from the interrupt
     handler (starfive_trng_irq).
 - Use DEFINE_RUNTIME_DEV_PM_OPS() and pm_ptr() for power
     management operations.
 - Split clock/reset control into starfive_trng_power_on/off()
 - Track power state with clk_on/rst_deassert/initialized/need_reseed
      instead of open-coded clk control.
 - IRQ now requested with IRQF_NO_AUTOEN and enabled only after init
      succeeds.
 - LFSR_LOCKUP no longer schedules work from hard IRQ: set need_reseed
      flag and let starfive_trng_reseed_work() handle reseed on a
      freezable workqueue.
 - starfive_trng_cmd() takes timeout + wait args; read path checks idle,
      reseeds on need_reseed, retries once on lockup, returns 0 for
      non-blocking.
 - Protect ctrl-cmd sequences with mutex + lockdep_assert_held.
 - Cleanup/suspend disables IE, clears ISTAT, synchronize_irq() before
      gating clocks/reset.

Changes in v10:
 - Split the driver change into fixes, cleanup and the JHB100 addition.
 - starfive_trng_init() only enables the interrupt line once and clears
   trng->initialized on failure; starfive_trng_cleanup() only disables
   the line if init left it enabled. Fixes the unbalanced enable_irq()
   when the device is deselected and quickly reselected, and the double
   disable_irq() after a failed init.
 - Non-blocking reads re-queue the reseed work instead of assuming it
   is pending, and starfive_trng_irq_clear() queues it when it clears a
   lockup. Fixes the stall of non-blocking reads after a lockup seen
   outside the interrupt handler or a failed reseed.
 - Do not include <linux/mod_devicetable.h>, <linux/platform_device.h>
   already provides struct of_device_id.
 - Describe the header rearrangement in the commit log.
 - Rebased on top of ace145efdd80.

Lianfeng Ouyang (6):
  dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
  hwrng: starfive - fix runtime PM and power teardown handling
  hwrng: starfive - move the SEU reseed out of the interrupt handler
  hwrng: starfive - tidy up includes and drop unused code
  hwrng: starfive - add JHB100 support
  MAINTAINERS: update the StarFive TRNG driver maintainer

 .../bindings/rng/starfive,jh7110-trng.yaml    |  10 +-
 MAINTAINERS                                   |   2 +-
 drivers/char/hw_random/jh7110-trng.c          | 578 +++++++++++++-----
 3 files changed, 425 insertions(+), 165 deletions(-)

--
2.43.0

