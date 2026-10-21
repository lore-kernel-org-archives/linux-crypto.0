Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.113
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792571853;
	b=0/2hObiBjUHozctlhu/5PRw3lHQj+SI7MsT2hiQ2baKlxW10dEw9uYvl2E282hdDBx4k
	 rWvswSgD2oAjNbOpqtZ1Hp0i8CXMh53Ttbt44WvkRmQNiFQu6zfKxfEY7sY1yN+rHyHcx
	 ptgq+jukuH2QFZuoQ9chT3nwrpGNjmgBp+Ad69Q1PRhC52Y/wBecFWGUA5mapAhDzXfJR
	 7zqDiiBKpo6Kb7U2Unv8QwRQD4SPVdvVLfAvBKJWMVDTwyrLk41trukhn0Xu7c2fkJrl1
	 LWwx+cxR7xw3XtqNF5+ZXEvMfSGTEbo+nLenyimfBXk5dFIr+js90aO0aWjaAPoc6aw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571853;
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
	bh=ZWuQ77O2wQGEOHnC5WnvlgHGpBhL0RBfmdFtdxQzCOA=;
	b=B5L6N+UZcpQDZxml7QMd0YyBi+sl5Fro2Pam5GaXeqzLwwBaY0T3rCRZvZxpwNKW7jNe
	 Xw1ikzOc0hvf6D1TOq7M2219B5Oz2IP1NOApLkoWwmzVzb++lK0npJNYqqlVD0RmXiHXD
	 mpZAuDSgmQk++/4M3GHwEMSVS38oOHwBbGyTwpWcW0CRCXYNhEI0q8SrTyb3YI/SORqDa
	 MkM+nBAk4cF9EKN0vmH+4nlY1lFdlyKMOAMqgmYpZWfIFTLSLi1FaTAc+gVgYTvvv/60G
	 kDHA0YG96La+LOAU09qbTOJ1QTS/6xMnMNmWPyh4FMsuDJYWL5HbRBmk9nCWD6OdNWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.113
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2113.outbound.protection.partner.outlook.cn [139.219.146.113])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4AB606A319;
	Wed, 21 Oct 2026 08:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F4AB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSgSKZFM0oMxMVQOkXznQE/jziXkMPzonGlgrW+AZiaSvaDCjgQ/Xn9Sq+G9Z+s6valnOscHYJ6m2D8oHYyhMT96/t6y1waONZw/TXUc/BfsgkqWib+xmBtglIyA78PELfgI36D1OXtvxyzo7BAV24/tx/q6RRIt7rB7y36adFV4xHozYyV8+/d/uxpx/fhpQ3R7CF0cwd2SMDImaFFjcyHeYFd4tX7pgsnIlY4GPkBOvjF1qzUzYMuBvAEKraFBBNFN/OrpqKtOUI9zSMkfQaEzzXgjYjCl0ymgRnhfcrcn6fwLOv2Q4lwSqzyyFiPtVmRpDNoBHL+20jtOmePpQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWuQ77O2wQGEOHnC5WnvlgHGpBhL0RBfmdFtdxQzCOA=;
 b=DxivnJh02lmHjE5nCvvEIpIHGQbDyqu8sxlPkFqLYthMTFrmhjyLgcgDdLJBW3PQsYo8cZJ+T0UPgVA6OEQjj4EA+Xx8iHYSAPZmX4aMXSOUhJs6b227WXilmrJ424bokv/Q5lRPLe2uuDKO0dhqgN9hAf6Nuv1FO2TtCkxTNoJbbkQQ8L0PKQqDdhlocP8a1RdmoSl23F3FO8MslfkbAoj24l4rOeBT+DmI9eM72xILiJzYEODHNrCoiVRBhtv8FuSU2t7ZDXoVuyeVVFhA1HlIhzaKKpYI99JljK1r0Q7TvWWejdErr+rt7oR6FZaNNV3ff4lbYe6KDV6p5nUjyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1335.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 08:37:19 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 08:37:19 +0000
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
Subject: [PATCH v9 0/2] hwrng: starfive: add JHB100 support and fix clk/reset teardown
Date: Wed, 21 Oct 2026 16:37:10 +0800
Message-Id: <20261021083712.3032-1-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0008.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:5::13) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
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
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1335:EE_
X-MS-Office365-Filtering-Correlation-Id: bc84fb70-cf58-4fe3-419b-08df2f4e84fe
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|52116014|1800799024|376014|18002099003|10067099003|38350700014|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	NRMuE1O2zZZIQmzU45mtARBjZYc+qboYq/B5l5FjBcCNp1NrhWCkkAQ8M6v1N6B4Lsca2esuE8VEi5wEbT4FAslbnmJaUVwyfDUgDcm79FB+4JwRFi9LoZydCwHo5Ft2x6uyvDCkgt32oosS3VfAyAGqAcMBH/k+zBC6z3t9kLNgo7REUo6mSyk1xC/XDTA1ExP8ruhr3tVhhWuCNqWxZp4fp6G+HwsmmTjJgheDbn1hnTLGE9yV36K/1YNfLzei3gcahcV47x64GX3p/BrfHXF1dVw9a3ThJ5DCCkyA6axpeCGBgvIyGO9X9alEoi1otxW06F8HCq/1atTuCSOlYjm3pTiR6pj5BmS31gofXxXeQyF5vW7H2bTKOX+mFGPTT3D5qiwAOMymMqzlzOQMC8Z02ltocWyXakB+jgXgFR4TRToXScy1FFTZvkS3SQj/v5aWuwP1EJmkBkfHFnbM8NPRdF/DjOxGhmCdQnCR0GhsB6nDFybnWKK5uBmQTMhUzjNP38KHbVApC/hEatdtizYCNOdaIDHPyZVUI5gP5drZYodqgNfpOKftaukIf+z9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(52116014)(1800799024)(376014)(18002099003)(10067099003)(38350700014)(261009223027099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Bu+133ywmiAGzy3yA5bjOuH3A0hCFFvSkjT1aWTNgV7Urq31bgozjdoLthiB?=
 =?us-ascii?Q?Nw2MxbonFP/0++JrzhXAxwjzP7+zRrcUBRy6WL+TXgamcpPIzOhjzHTSd9Iy?=
 =?us-ascii?Q?f4CF98p5RbV5rhLmJ088ZidU72yzh3ARHqrWt3HktGkdhFF5UIqQi2njI2Qx?=
 =?us-ascii?Q?x4A+4CuEG4LuOJowLAy6k5uYPndxUPvbdCNT73YNNuKrwNdrc3zqDWu/KURQ?=
 =?us-ascii?Q?i1TY0/8ibBKSyFUXOYtYbdL50s8RCFy2uuOMdAhPfHVwwVRK70eQ1K+4gzkV?=
 =?us-ascii?Q?RBhNqFDCPLZKAoqVc1lhLy47P/waSoz7Vp9DZtxWP7wEU8fnhr8hzPF21hME?=
 =?us-ascii?Q?X2mlAsJay/rqWGmpwNipOCEvDAyjxkuTQCFS718Jh4eWGZ7D/ydUW1/Ne+am?=
 =?us-ascii?Q?HC/e2a5zA2/2ceQrhLknbeimKEHA4Db+IeMMnGO6vu1EoUOUrz4AaWGgYxSc?=
 =?us-ascii?Q?YuIw23hWMQq94ldRgshWBCLbjUsL27aB27cCFc3nMgASRrZ1mOk7ix5cSfrN?=
 =?us-ascii?Q?7rFd0nDwPQGqROw/S6kXg5NkhFH+t2wK8PP7mDleB85SvKx3lLIFFa0K/Q8m?=
 =?us-ascii?Q?wd0+xMFUBPd1PdPXnS60pU2Q5dj2E5h/CsCsRslXZOo5yHJHxC6ubQ0m5ETQ?=
 =?us-ascii?Q?OVpT3NuDGI3AfpC971RB0kCLj0h6GxLwEhY3/n14DbyQyGBa+oMrlqZ3W2Db?=
 =?us-ascii?Q?UzMnE0ZUNe8mkV5b9fY3DxNCrSsgp45LBTBqLsqlwUQ5noDCJ/cG0EbOSPhv?=
 =?us-ascii?Q?UPrjP4eN7IS0TAw/+kYVVHpZCc4iZPz7TWMw8mbS9ydgJBQaiGjmCHgcz8Cs?=
 =?us-ascii?Q?Q6YGZKwgifRae30Qt8rMHF8LKWp60RTHyW3K8SJxl+kcSnXakN1D8aDKBGqZ?=
 =?us-ascii?Q?iW1KKpSyiAjidy1xusFF8Wlg7RaftxHfseU0beUbFPM0Mja0K9xPOrNGOgQy?=
 =?us-ascii?Q?ihCLwtKZQFD1EN8ltvzNZPQiApFW6cDouTnZojy0MuzCs7BTba7Da89qZ1oM?=
 =?us-ascii?Q?H2k9D+RS3cZ4S77P+/v2QBof4eCWiohIw8j7ePhfcav8BNTcaTL+rYl5mdpl?=
 =?us-ascii?Q?4cCPS9JaZpQc0VFkVhm5VcIOhmG2xZmRB4YJmD81JURel9KYQLtGZOVxsDvX?=
 =?us-ascii?Q?c9nuJQ0iM8rhttXOMaN2zd+8/onCggItt4SgZMKRX2tRm9bTLwZvDjH0pPQj?=
 =?us-ascii?Q?VwX5LIMjrg9y5PXC17vLdODL1oxFtfIDFfBfshZD07lfq6AljI0UFva6FSuJ?=
 =?us-ascii?Q?zwaT2lDxnKyOMghssfWz60jAoqSQe4+l2ZPWtRCzg0BxYBgJcZ9yR7asW3zw?=
 =?us-ascii?Q?UyoQ8AhBrphjvwMJOn7f+ypS+DZJ4xdU6MdzS4Bg8U9Acly3AUQmlUf7sk38?=
 =?us-ascii?Q?7LC7OiwkNg/1WCVrtK2wNMTcjl9gIhCS04bZq/iJi2Gj22JTYFzTEX4wMNr9?=
 =?us-ascii?Q?b5i4+uWMF+kQiCm4DzAb0+aBNHvjagLWJDUE+VrnAA3DgLgq28/SEj+AGewG?=
 =?us-ascii?Q?2eRsTz7+OTFJMz69EfZL8Qtt5W3J8y4CotxTQCWFkH2dPVF24FbVBrrnlbXR?=
 =?us-ascii?Q?H6PtrFlRZsU3eP5PcQhoikpScmk/7qUK+/VTMSEM/mjLspJu0dEoB38ky2XV?=
 =?us-ascii?Q?MYBoW4CUAWVe2xwpWHfT9/aqyL4WoDH6at8G81CEaYAN5AehKhP/rnbhELPh?=
 =?us-ascii?Q?VSumNZsgcFMV+rv++aQM5JUeRL+S7QECdIHbhhEIFGYTI56OYhNPeIsH1S8o?=
 =?us-ascii?Q?wx+uABefU+6F82Jeepngf7JCZ+iovH0cHvz+J9IZea6vxy1MKBJB?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc84fb70-cf58-4fe3-419b-08df2f4e84fe
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 08:37:19.7043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRAn0ZMc5Frx5mRoAj9dtRyHOjgd12IA7Ii63K9Y8nLVOKXiP/cEin03wzZ+S+WYKHcDfg/E3CPByaZGu1NtGevXnMKjI2DUImG0Xmjn8GbwSZHvG2Pw72G5wu7ugjJj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1335

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

Lianfeng Ouyang (2):
  dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
  hwrng: starfive: rework clk/reset teardown order for JHB100

 .../bindings/rng/starfive,jh7110-trng.yaml    |  10 +-
 MAINTAINERS                                   |   2 +-
 drivers/char/hw_random/jh7110-trng.c          | 559 +++++++++++++-----
 3 files changed, 413 insertions(+), 158 deletions(-)

--
2.43.0

