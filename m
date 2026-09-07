Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2101.outbound.protection.partner.outlook.cn [139.219.17.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179C1326923;
	Mon,  7 Sep 2026 03:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788751847; cv=fail; b=KNyLFhH8eymL1dNMEa0OU6dyLAo0ca7/MthMg+KlLa+GvWHAW9k+aEP+SalKDNdKpdHe7cU9j8Nqf/ycyH1lEa6CO5vVpaRBLsg4D6XwSgUgsqAXrHZyBuSKQAolTIICdeR3u14UuC9xD2zuM7Eq7cfEYM1vHNVk6PUn11m3H1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788751847; c=relaxed/simple;
	bh=Fcn5xJZgJjuJTb7Rc2OJYUrYV3jD0B0eznvl5ooPuKo=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=dmf3gruhOX6Yfx/E+KoOPphoSeRrOYawNK0Cclr03wJ+YircgCqCkV6akUesY8SYblR1VxlzBQ71DDzrtGF+/mbDuUA+kKf43Y4CTjTiR5hAOpsQ+HJb/XaAvojip9V91eibbtFEpPmSb3mf06qtUGv3UWiTvq7Ok5+2lOuRaQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1xDdiOVwk9uP7PLJDbHk8iAoTaSe8SDEduWcKPzA0WKnLfVuUMEwllHRhTfc+v37cNSzeMeWlSf3r0FXwYfvHVyoQs/veOwGJSjk50Qa2To9Tu1bWhsbvtg4o/hSDvvmSfhEPBdIsfiamsosJZ+Ubb1bCb780qoEoFWu8fJgBMRZ/38s2jYwS/yAsWPM8DrahZ42AuK25ywgER2qGulVD9rnGl6xy2Ltid1JqUPiltvXUWjZBVnsqoaMp89XyzEsweQo/faEPPl587xsc/feF2X6zdOzxl35B2w5OduulxVIygjaPhQ09zaDuoAeROzCpmT2cxjHlwfmQcmDVoedg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vF0ZaF9VEbhjCf0Bp5rrQ7UrokKDUzk7tANg3iVuuRQ=;
 b=CVtBeTYlWNdLydsaD/ODD2+2tqnHpMjhXqJcVwtTV720jvQHV2OCQB8SjtxUpqJ59yFFTWf7Wc6HSH5IvKWYrgd8sqNXr8CyCmzoOKLzdbF7sXelRJOJJFn2xrAkDvozgeWRzjs8i3UbVVk/4HZ19Tm3X3P1deRzcaMqhABFAJ/rCgJd+i2mhheNQD0rUnZlDVtNAN+w+2j6lFNX14QqXMEruEbtL6u/b6IMlSA3tvKkCEEVmpQS4yle4IwZEZnjIiRBmz36dmLFSwulZp+jQ+IgEAiD/PxdPe4aH1SDNh/MXjcCKll0zPOVyz/+0w6cAV8J7/Z7EGkEVIex4+yoDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1320.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:19::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.18; Mon, 7 Sep
 2026 03:16:11 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0339.017; Mon, 7 Sep 2026
 03:16:11 +0000
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
Subject: [PATCH v8 0/2] hwrng: starfive: add JHB100 support and fix clk/reset teardown
Date: Mon,  7 Sep 2026 11:16:01 +0800
Message-Id: <20260907031603.188483-1-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0033.CHNPR01.prod.partner.outlook.cn (10.2.8.10)
 To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn (10.2.3.134)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1320:EE_
X-MS-Office365-Filtering-Correlation-Id: c1eeca70-e361-4a3f-892d-08df0c8e5df3
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|52116014|10067099003|18002099003|56012099006|38350700014;
X-Microsoft-Antispam-Message-Info:
	TtMJug0TbwtnU1XiYuLsGELhgvqBvpTxQeLMIQuszfNvl6HJlGzdurv6jxfFoMr5PBObAGr2CQJ6r2Rp17en6gtFbvvYiQ+VlUGsDwHKKt2CK8xwZnc5VwnwDS2MgvVgak0DOnkCiD6xUaqmg7JSZXmRbUQwlvzDwjC7NwVvSNCtTpr2jpmeI4uFhFngZAIJGA5LujNU1swU/2T//ZqCW6qvkvKB7rEKrJR+PvzbsK26Ov5rd1Gn7S1txV+orefUmO5kBpyQTEBHUIjLEnCGPT2AMvQiIXcKFunyrz2p+PMuRTtP7HarJNRyj6DrpIppCpV7kHKEed/e3wbmhNJFAxMirppiXIebBVQTMFCi87NnmPLwJ7aRpIOXgDPgfB/MWGnWZwODWdakl86jWe4ZU9108TL7ZXWHBfxSFbEw8A+vuILmR8BuQ+JuOdTyIbEI9wvQWQmT/C7eIC5f6Egr5G4pJ6XxzgFmgB8FYPjVMDsZID6jkXFeCflpC0yw0o6kILXnEN95AjkcIyjCE0WO0ooVcZgm+5LBA8zXCpLdVp/fb4QX3gOqdaH4U0oiPlHt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(52116014)(10067099003)(18002099003)(56012099006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZkEQ2iOXhVVUyE55cfy4WNGTWshQer6LXIWNniVC9UwR9+BGmFYrX9rUKHCD?=
 =?us-ascii?Q?R1XkvXl16903hZGPE9QPUpQNHU7+E6L/2bUHclMlFVR991739Ne15gQGwhVm?=
 =?us-ascii?Q?c/CwwGNy8cQaGH2EFrh0CMbESSeWZpPg/A49Wik81oBJHLavKCp/DSjeY0pM?=
 =?us-ascii?Q?T2wr4w4XXNB97QHOGmIbv7FJdZAzsE9a+kwnhbQWK2Y0XIy2+Lo88DMT7sJn?=
 =?us-ascii?Q?1PaQaQRcX1MRhBL0DlJjCwk/cCi5mGPWZZcIpBH/dgY6MMhrhP+BtCsLmFb5?=
 =?us-ascii?Q?1X0Qq3hMJiw2Dmf0LNB6pb0IhyW03HrXRYOKLTHK5alcl8FpZGmMz8lxkyQq?=
 =?us-ascii?Q?g2NDmmFuTmeReHv4c0UQNvFb3CwuAa+SwqL09ldBtZB1A2EqsqXvTK6QPuvC?=
 =?us-ascii?Q?6eu3mVN0wrXK6R6jjewbGwdqTiHvNFFJIzkwJktln5Qsh2x+dmVjARKYK6gd?=
 =?us-ascii?Q?lGJtdk171JLPdVPTMZpA8s0Q/s4Rs9KPYyoQfU9fFsjTfUBtdEdAUsd+1OoY?=
 =?us-ascii?Q?1BH182zGlLjNEwK4jgg8/dZZ29LXOe7WXgtNNoB/K6F2g12Dh4gawSp+ztkv?=
 =?us-ascii?Q?Mr3el1AtXDRQwbTUdskhDyvI9qQBRkRo6xNNnXT2kaGa0tsn2vNShCUVgtUF?=
 =?us-ascii?Q?bfrYA5k+Q8ApEtzBtZd/GfeAK6W2AvJwcQKXxEgqA+koxah0ApNtqRVwUaGt?=
 =?us-ascii?Q?ndM5X/J/gFSAV4QEjiaVB8UkgPPZPPwECxvXyejpiBjkPJENEr5ZRTY+Ffq1?=
 =?us-ascii?Q?Gzjj7XU/N6wBx64xHqVwv0GL6shSk2xbrk2wG+om7mcwZ429t/xfLiTJ9ZAZ?=
 =?us-ascii?Q?qDq530BjcE0RUrfoLvG96v6L3niXqIA5b4PwVcDlwcOgV0WTo7db39kKIcMH?=
 =?us-ascii?Q?swikWJXdtWjss6XP+cMmbEqjTLZ12JIR7HOOo6VCy/ckuZEU/fb8ccEorFqH?=
 =?us-ascii?Q?ARPX/Z4TBzu9LzCLh8SglU6FnQpbGPBx54/K+68g5KjwCDcVbTAfy29QSnCT?=
 =?us-ascii?Q?Jg7QDUEB64mIGnokxba22x4uW0y3LWHbdhiUHdvtRZPZG/AVeKFL8KmGj4bU?=
 =?us-ascii?Q?1XJARJRqWc7wZF+Wl8zARcpCoKQ5JFdFCQqTAqgPcZJfhs/5X2mM+FWjc4rd?=
 =?us-ascii?Q?3zE0ZhicV3nbFof08+wxsMrkEikgo0zI6HCjWKPUAGq7knUNPfatjP9m2tnb?=
 =?us-ascii?Q?QmwT3kvnXDqh8GsXw6sMkyAYpfLyC9R1WqNerqR3bu8paoPvs9G648obkKsl?=
 =?us-ascii?Q?kkQUOZqTzrZklN/rT9Yqvb0YKmT3Jozq4HZT1DlLv/sofE/qPwpRkni9jd6a?=
 =?us-ascii?Q?0EepwQkP+usBFURvmISCBg+/3fYRG5ZSWVYO5X0PC2XCViOyhEJagTqfRE+8?=
 =?us-ascii?Q?99WiCo7Fstr303LyPE8+6WeI26ouTtaokHKKQ73zSEaZ3Bi6Lo1UjPsrwIS+?=
 =?us-ascii?Q?LfUwKlVaBILX4xQR6OgvdSck4KTxqzekhBT4Ogs+8c0gSlGy6RbgaK/VFjzR?=
 =?us-ascii?Q?tRgB1Y/BvDd+CgK9eKyLzCP2w6Vp/f31foJM8ou+ETigmvtnGIcsbKTtM+u/?=
 =?us-ascii?Q?YeMnBhk3w2I81lk7kDVGZM78MTXoLZ5xSvbJ/1lWuXRI82rfNE92VWu9ccFI?=
 =?us-ascii?Q?jbYHTiE4aIL8TvveJrot6T85zhM37OK7OvIQoxGyTg0BpYZKF9GHispCZ9HJ?=
 =?us-ascii?Q?OsVQtaLKRVnp13d8ZVYBJAK1y2Whh9hHJS+QjPIUPeHHURzlFwWxMyf2RxbT?=
 =?us-ascii?Q?ZKMrWBHUquTXmBcQaX+uFPw5a+U/Czcdxvoi22Os7Zl7Sli7qPj5?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1eeca70-e361-4a3f-892d-08df0c8e5df3
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 03:16:11.2129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZdpZgsTt5osu95B5u/brQBuwZwvtN4j1aV0cS6hfTjHd/NGpVUHrg6PEdk7NMRkIUpt4IP+q3E84v9o8+YsV2UgG9/UOB+yOEOB7Gkyelg77o3igmZq7tlgDl5BdIfc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1320

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

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

Lianfeng Ouyang (2):
  dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
  hwrng: starfive: rework clk/reset teardown order for JHB100

 .../bindings/rng/starfive,jh7110-trng.yaml    |  10 +-
 MAINTAINERS                                   |   2 +-
 drivers/char/hw_random/jh7110-trng.c          | 297 ++++++++++++++----
 3 files changed, 243 insertions(+), 66 deletions(-)

--
2.43.0

