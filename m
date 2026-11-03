Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.132
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793691192;
	b=FQ51vYVqU9HwsWddHvhGzYmxCJQyYgceqZ0nrAhjtuhA+oviWWam0sbsFIxVT8ApTT4L
	 A6ceNMYBBdfp+VY+BqYNRXQ2g551CMVpIbFkkyP0s+KvbmZqw/v9BUvQGr2dxoR+k8ABg
	 U862hdUbqq928v8UZxSc3SKT3OWRnSqFYLmxOy8Zp4Ic89RWYr6wt3g4Kz5Vdi+BAHswC
	 xZAhOhGmtllz945Puk7IS4dYwdD1NgSH7dYZQcha8JGy+YJUyEvi8wecOTivNC+cQHEoo
	 VOR4DDId4o85x+ND52M1MI6wCzoF98kuHXKKdRo8zCvdlzJCKnAQlMCP/gAztBk2oKQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793691192;
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
	bh=vF53YA0eV4p4K9eUtboKstRoy4OAMVy6d/4x95ye3m4=;
	b=FI5TyZdTDnnUukNK26W4E2D0hzBVH4EV+Gd3T5XhIUs9XlG67u484e44JNuwcNCYVO9U
	 n7guSdkqbWxnKmMKownUkcoWxE49Th8T8o39Bpg86uIFVnqBeo6w6CpfNNHymA5Y9pLxi
	 JE5PdmtMGc4ANDi1Q4Er0m4C1UuTsy4n7+qlqTJp5VzahNeI51cM+LoiN2wVw6L5tWyrQ
	 cHPD99LQiNFWjhL+gR04/+EJIRqCJDx+HYiqepbSDLb8pNacJj3glJOom8W4dfhJ09+o8
	 m9yvvIP1YRfx4k4JLWKZvLWDaNlvgfqE+iLjTJc2Hfo7tL5JmTWvHbToFnjuz6+PrAw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.132
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2132.outbound.protection.partner.outlook.cn [139.219.146.132])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55734606A324;
	Tue,  3 Nov 2026 07:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55734606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKXVi0WNvmyDh8fNNpFG7BD+rVkfbDRp9QHaU1ZpbXPbeYxLgSOPV3D1+knANG9Uxi+dpBeAwfOXf9nPLt38JF3DNiuXKRw9nXEb8bebD01fz09Y9YZw1a6njv1fnwjdc/1PWbzMk0F6mh0cuKqzjo7H03eFg/ZRG/5l+owNaI2V2kjMzim5ziqkbcZAlsdzlyTH4xsHsjSlxlGy6TSGr45t8tQe8A1JQgnI4jamMwIVec1n07yQQ0zQwOBnP/E0vuk4lhCI4bpPSxGQhrYoXa16c8g5xWjQmhd6ju2VHtr6gi1Ta8cfNgD4AY48yuM0GhsW+dMEHDpfNcCoBDaZ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vF53YA0eV4p4K9eUtboKstRoy4OAMVy6d/4x95ye3m4=;
 b=GLSVmgCA+9yEffBBOHH/FOvbSdrDYzxVpcF3bs2LmtsM6eEcaWXBZVUjEnuAPK4UPzZfVabaL0rqg7jFqbmI3CUs2Re8b+QBmJ7XNvOUzrzryh/hSeNBiVuuCvuSyrJ2eqJXPY1BhetBKhedY75IhofreErAGvDY9Y+Ya8ft+oUUrw5B424ZNF9lLZ+X+YBOMSv5aJbFfAy+2B4ZMGlh8Yz+hFoztg1+qYPuIc+xMl98vbTHRYfuao6AekiqzQcwP6bJNNzdTraScGDb5dALavDYZ7S68ZdvktWXJN+3KDyCalfiTodxHrgEcQV2A4gSdBB0uxyzMJRXTowSrv/8CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1032.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 07:32:59 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 07:32:59 +0000
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
Subject: [PATCH v11 0/6] hwrng: starfive - fixes and JHB100 support
Date: Tue,  3 Nov 2026 15:32:46 +0800
Message-Id: <20261103073252.3028-1-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1032:EE_
X-MS-Office365-Filtering-Correlation-Id: c780f198-5cce-465a-60df-08df397caf52
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|52116014|38350700014|261021123027099003|56012099006|261009223027099003|261028144727099003|261022075727099003|261026121527099003|261021121427099003|261026140227099003|261022105027099003|10067099003|18002099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	AzMB4Cvudn8iQx3r54ou+u161DANpxkAEbRv7KO0+G09oTeFdhm3c2VpGWCUZDc+vaZIRJnxFLZ04ppajaDmRndXF7kju7xVVtSDEc07m4RE2pkLhZQebuEAxsUSujC7qTnHMuQOou2ZsI5nY/I2iNQ1p9luLN0uZnJ4B15TuSpV2TFiKak+QtlcRb+02jDg2d7fNzhGwXzu5kGmfFUBnDw/jorsoIC4zYHPQZu5G8F1xRxbqzm9XIcjzFOPtHmUU/0NPItaFt/LoazgJhYNUmxcKj72NRV7p9BesNu+w7ilqbFjLZ+8Uc51Y7zP3hMptyGakV63terNFRVBiGjyP+J6yQe2fGvb2Xbz2l3bnlAAqLimgcQnK6zBT4UnOvlwJCbsuiBsvDH8SCa4z7JaUqRBONsf3FD8usf1ql/vTy7XMxGscrF3zzmE+c5yiRyo6Q+8iy3IDqk5WfeAAPtTo/w7cClhh3hoeuoVfoXQMVbqvp8gDAEr6MAFCZIwdTmTyZy4fVRkIgF+Bh0ZsXSwic5Rp9UmKPU2MD3rg+IX5KjjZhG/B2fdYkmXeiH0qFlg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(52116014)(38350700014)(261021123027099003)(56012099006)(261009223027099003)(261028144727099003)(261022075727099003)(261026121527099003)(261021121427099003)(261026140227099003)(261022105027099003)(10067099003)(18002099003)(261102123227099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0z7ef1OhoPLUilOCPta+bOMD+dVS6dPuttHxtOYZtt7WWOJC1tn3WQ+vXfqB?=
 =?us-ascii?Q?SJKZ2MhKqU+RgnTuqMM/QSe6+ci4mqrqwquW+Y67DQH2RAKJt58dCXhA7xa8?=
 =?us-ascii?Q?SqrRw1XLDtFY/FcN84F6E+BKpihvDH/dv+wRRZfamcQZqYIp0zg4pTtzleRl?=
 =?us-ascii?Q?nMWiR9wMgKaONferG4zxI3eaG+S+ZUy4MHmCZxN8VVSjoBVaNwJ14oH2+yKM?=
 =?us-ascii?Q?Ip1if4Ag4Y6gKs0H6ojofjsyFegWu5jKVkisSROQluNPkMVUdETpVSwI2Jo9?=
 =?us-ascii?Q?mCY13UNAvlFCe+TCetDGXvWH5RzXMBjB3DnlC9SimJuECWiCTwJCstkSibLb?=
 =?us-ascii?Q?uqzsClyjbN97crDH0mxo4qiJ/fUa7ssmLkH84fvTSNIj5wd63Rr/AeCipzpi?=
 =?us-ascii?Q?DMrTtYLLlz2EPnG/rQtEJzJOEi1KasnVEI7EhtoYmgzCGhi+pIVsP3OyY+w2?=
 =?us-ascii?Q?W9j96+A2E1fUhL51++f8apbiqgJGfgKnQswuNoPukxj6PONsiBt1gUF6e6Wt?=
 =?us-ascii?Q?oe3ZW3aEfzyZ9ON7wB/R3W3p8q0POmnVFVyBEO2Mw9YE+o8GfV2buG2gaRyw?=
 =?us-ascii?Q?7u1E7WCkXC7gGSJqK6uRJrsLa3iuRlsa2Jcvk2OCFMloHa3MVsjlYbasi+p8?=
 =?us-ascii?Q?lHwrslZmde7VPN0b9Yc4Ly+bmmGDhK7R0iUVUhoQgvNsuQcFPhcYiLg6TrNo?=
 =?us-ascii?Q?WKj589U/uPMhNDAMPNM2DCFiBqPtPJvkYCjIHxdIb6k2gmPcVkuhnW9RnBUr?=
 =?us-ascii?Q?ltlffQNlun2AHIUiEZ4eVecLlrXPouVh35OHH1ZTVii/M6pv6/QE3s51s1vj?=
 =?us-ascii?Q?q+cq2D+cz6PUCD0w/DaaGNoC7EeI4rcPyI38dnl2BeY9S8XDcfPUn/zSmC9t?=
 =?us-ascii?Q?vnvAzkMDP9k5hprbuelSCuo1ysyyrEdyHr4kjUiBNvWoFv7CkhDTu2nMHmzI?=
 =?us-ascii?Q?EXtRzo+Utke0KNuTANzpD7ya5SU0T6KebrZMRfhWvHnIYm9UvZAQqF16LTKH?=
 =?us-ascii?Q?8uT+IzmpAj1T+xuBUGY0nid5SZwF8aNcuYzN83Js8Cf4vG4sk9oUwv8Gtx5+?=
 =?us-ascii?Q?mSvNvGPkoU0YV3wVJLrphMuOO+96qQMSZQyordqA/YZywwbWV8Eu3fFFG3Sw?=
 =?us-ascii?Q?HSS5wdHUImxGoxnyDw/9RYm9zTrSpn220ednshvrB7GXH7IYYDAM5VE7jyrR?=
 =?us-ascii?Q?G1le6Z9Cdwd+Ua3L9XK8fhh7PGwerPT3/FgyPMuJKplr1Cucz+jACwuhZzgS?=
 =?us-ascii?Q?6X5dzjivZU/xEkOnTcdhuZXjvqSeVGUBkUJ0RRmmDwErUcVKOxHnQt92/Pga?=
 =?us-ascii?Q?aJAGVIeIw13SICsr+2ctyrDlwjYrpiBGtEq7I9d9cvcrCDz3hpNuZD8g522F?=
 =?us-ascii?Q?Koip3G8xt29nJjBf0mh4ljLQsPrvTlkb7nMWNDKuEYlUVMogrbpJ7irY2hDh?=
 =?us-ascii?Q?lZ41Maow7ANSlVciuXmEhw+IeUcsweaqkwu1REO85RYFub8RBIvk75xn6S9l?=
 =?us-ascii?Q?sqVlMcSB0JYXnZewuIYyMazxGGoDQQ6po9b+GqulxWm1CcPvscyCni67AC+p?=
 =?us-ascii?Q?HSgibRT58IA7skdf6fiyq74syUVI9/iRClqmOxpc3ne/ssIQ9vB4SaMwmp4h?=
 =?us-ascii?Q?SRwY4wkHlfRyOuMRKFBu97snZFojjnWQq+ji7++5Acx8vqH5ELHWqBKxuUzy?=
 =?us-ascii?Q?2kZpOPX0c4Qam4uJdoBfDAMEpvtjUaaOMmwO5D16OJuMBq44SwcJ8/42GGVe?=
 =?us-ascii?Q?jHcTKBO9btizLC8UGlMD2SsgoZnAVsIElCjaBw/7qoQ/0F4qu9un?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c780f198-5cce-465a-60df-08df397caf52
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 07:32:59.1153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hRIukP64wN29ykifnLLtaG9sUwIh8rXmdk3iOp7qj+s68kMjwoF9GNQEDR0GJbV8KBLmHLy5X4vfs0RIzIGVaEnYGl/ZRwfOOkTikCflB18JhH1uWVi77uidxfev1qRE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1032

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

This series adds support for the TRNG on the StarFive JHB100 SoC. The
JHB100 needs the clocks gated before the reset is asserted, so the
driver grows per-compatible match data describing the power-down
ordering.

Earlier versions of this series carried all of that in the JHB100
patch, which made it hard to review. Since v10 it is split up:

  1: dt-bindings for the new compatible (unchanged)
  2: runtime PM / power teardown fix
  3: SEU reseed moved out of the interrupt handler, command
     serialisation, IRQ lifecycle
  4: include and cleanup tidy-up, no functional change
  5: match data and the JHB100 compatible
  6: MAINTAINERS

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

Changes in v11:
 - starfive_trng_cmd() acks RAND_RDY/SEED_DONE in ISTAT and calls
   synchronize_irq() before re-arming its completion, so that the late
   completion interrupt of a command that timed out cannot complete
   the next command. The v10 commit log claimed this case was already
   covered; it was not.
 - starfive_trng_irq_clear() only queues the reseed work while the
   device is initialised, so the suspend run from ->cleanup() and from
   the runtime PM teardown on unbind can no longer queue the work after
   it has been cancelled.

Lianfeng Ouyang (6):
  dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
  hwrng: starfive - fix runtime PM and power teardown handling
  hwrng: starfive - move the SEU reseed out of the interrupt handler
  hwrng: starfive - tidy up includes and drop unused code
  hwrng: starfive - add JHB100 support
  MAINTAINERS: update the StarFive TRNG driver maintainer

 .../bindings/rng/starfive,jh7110-trng.yaml    |  10 +-
 MAINTAINERS                                   |   2 +-
 drivers/char/hw_random/jh7110-trng.c          | 587 +++++++++++++-----
 3 files changed, 434 insertions(+), 165 deletions(-)

--
2.43.0

