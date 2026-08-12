Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2136.outbound.protection.partner.outlook.cn [139.219.146.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396A2374E60;
	Wed, 12 Aug 2026 02:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786502058; cv=fail; b=TB+SqGN9aEvSVySU3MY23WWckeDTSZFnKNgFqVuHPICldPYPg8zyc4Kr7sSdlJiDN+1PCBAmmqSfA0e49w46t/Tofd95LeroCJCyaxrwdAACfN5aEHded7f7cQUvI34wpuJQYzrmkucb9Y+dwGrsw0AVckscEHK68B3md1PTNHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786502058; c=relaxed/simple;
	bh=hy6HksxenT/0eJB7eMo6On4h0c0h8Jpdb7MkSNxc/4k=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=WkSugmVj/pQl7YjcUwWbDivxQFFXPs5g0/63Se5U0EyBBCzon/2KTxHgqwDY293k/EIxaR+gJYs0kVRvmHM9g193xAyspoWCFNIS69l+acLWKURDm5CvCHgBjWvy19T3pC2/TIEbBaUzxdU/1n2y+F4X8G6TuqwuRITUzI/5Uhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4wOmNla0rWyBgyyrEJqhqnAUFOGaAJ9hQ9RMYOWmyW73tHUBX8jkKMUBA23am6nYn76x+4pnChs1XMvp/eCDUlIgimaa6wFGhKReJcAGzur4yaE+LTiyLhK5hIWEE8F9eKIbnv7F3KkF/ElFlJKmkeV9CODSi8dEcxNve2IGKRy1E4h+oPWfVZplMVRHQxaexOHnGpVj53VvJIZevopTP4gYF0Y3mhQaeVsdzpNuYLClGN0xE0cZ5ZHKeTIahdkQ0ThXPL5fN6k+CoBZCw4KQCR7CsndrZS2jpdt7FZd3aLsm4Cu3n99FSSanMTOfAt515iFcVGZS/FsPZwZV56Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fz45kGDDVkNTRrZM85SrsidNrVHu92wDa0C4fCysXPw=;
 b=AvFgVSCZRgKMZTaokIQbksYs/KpKWTapYLy9edI/8f0Ze9jHgmbHhG+bclq+dVUQC22dO1gHS8lThNz+ez9g6nG64tiBlAaqFzDRhZtCRUcn8bXBhSTfF6W5AuzRjhNT0tV0sFO+Nr56FoGmPklKVaSjM6oFBqpkYgPU+Ilo1iaa9echR5b+p/BWGviGNXmn6rk6+O0u41oIAZM9U76L4yW02NKNWoFej8Qr2YMenbiCTOV1HuHnRSch9YfjgQL51F+SWfIjN73Ipa9QELkf1Zq8r1ZIiRzSxp/MGMHbAFFVhxFZqTEg6VnUuy0xe+rs1JSH/cowyZHh7+MWBlg9LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB0998.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 12 Aug
 2026 02:34:09 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0292.024; Wed, 12 Aug 2026
 02:34:09 +0000
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
Subject: [PATCH v7 0/2] hwrng: starfive: add JHB100 support and fix clk/reset teardown
Date: Wed, 12 Aug 2026 10:33:59 +0800
Message-Id: <20260812023401.44149-1-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0011.CHNPR01.prod.partner.outlook.cn
 (10.43.109.87) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn (10.2.3.134)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB0998:EE_
X-MS-Office365-Filtering-Correlation-Id: dbb10932-0dfd-4276-3374-08def81a2fe7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|52116014|1800799024|366016|38350700014|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	1hRLlgBthd6bLldSnqnScMUmwfm4uKNI4l5TXHcuWb9xksj/LwfM0qLDWN/rnkmIeyIr8uqfK0GaZaDDaO+Rkw9LT+x9TWX2ESlMZe6+ZwKrSabUnaclY1addjJc0s8F2AhDY70mzIL0aLOKbEloAXBvyxDu27iXO3q7mc7fKe1P8PZkOI14+erCQHaonXqQ0YpdxST8wnyGE9w1tWG2OeEqcV9vhKmrYMVhuZIcRZGKxRRgyD7/1skjyZzhfIbmOQsQQpZHJXlGTRmsJtHKKyMCMqmDp5T3ra3P3SDCx2I5GM82YPqwywdvEJFvq6RKaky1TNce2P/9KOXYe5faETei8EckHvPJQSb9MAI8BiaVCZ7koAByMs8/c09l1J7BVhHMP4OdWSR1/moZXfwLtvKs9aX6Oy0BqXmReoXbqS3ezNFuLOs3+CbJw9NQnd7JmUHWYFyh7YS9EFU1dOwiyvPmFKoDQ8mz59YfEHNYtzhk33LY06awHBlkkM+KaY5JY09lXz3HNt2V0WcdMeEZAugmJVswHd0MYE7b96ei0KIqnvDrQXEP0qxzGCrPnoz0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(52116014)(1800799024)(366016)(38350700014)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8tUHK3ASN1amzSZS3DoENW8dpEJ8ZPUeFYyccgLzuBBv3o/JPFgeY2wc6Pa7?=
 =?us-ascii?Q?iY8FNDRH5dkisdBaTNEYSoGouuFRb2vop9WA1nykH/LZQ4KXZ8qglHBE+A3u?=
 =?us-ascii?Q?LoSpDzabeqOJ/Cj+1U3OLM+HntL6N4UK6CfURTV1JUmPH/Fd+VbK9AfDMSOi?=
 =?us-ascii?Q?HIYuQQXvwgOqP2aanbwXmfeYhgonMApIPY5ZIEdJuMl1WmIYfSLK3Woe6vjF?=
 =?us-ascii?Q?YQou6nxcFc/4vq/rwk8zS65WbtzEsh13OAJ9fblTMKIoUqgUrjIp2ETaLU3z?=
 =?us-ascii?Q?/WYeOl6XyhKYpSNOrbhyFhxNjY/LREVIjP+mXO5E8g4ozknJYwEdI11PFV5c?=
 =?us-ascii?Q?sAIFxNVEKSfxRZ4ykGJ64ZMIUOigSKtQNBZuvJ62MUzEL4AEK8cCpec71d68?=
 =?us-ascii?Q?fWMZ0zeNN1S0rCab5yCa5QSMLlMAOWKHtZFNtrXxcvf1ZNiOGlHhVX4+RZTk?=
 =?us-ascii?Q?JmbeEw1DYbb5BwawDRBDdGascRHrP+2Ewn/mPrUwMyM8uBQbVnwZKcdU/6i8?=
 =?us-ascii?Q?9EU0lMel4rawc7GBocIrt5dtcDAU4+NLsb40kJqFbHoU8wjKEzrKZfsBGjTI?=
 =?us-ascii?Q?X+pT/d34ilTIX1jmVoPiDVueoWcWfnAwak4SZkEczd2zYuLLEtZZrnpWA5mu?=
 =?us-ascii?Q?tHEmBVp7UR5vocWcxLPxHp1LIAcq5qS7c6WMdlbLIVmQmx7+Qx+PahU6PZq4?=
 =?us-ascii?Q?JOyubu7tvvlGrVAFITHWMSVlbavH4vByPcmCqPXfavBGpwU0v91ie70GMZgX?=
 =?us-ascii?Q?nRVFlQXR6XZnhi9js+SHfB3QpGYbNgOfCUM3f7TJNl5AH4JzpD/xALFsHaQw?=
 =?us-ascii?Q?CqqLQFiem1XldpP/pYrAhbWokX6EhI67wNOOMz47zRCgYWsqRDoJvirzwPkJ?=
 =?us-ascii?Q?WSFj7mu6GjmieOcRLKcz3XLRIitGqc0xBVAPMUSFK6xLr/oM499u1WNYJASq?=
 =?us-ascii?Q?NRUDG2Dqjo23Of1Jq0f5rjCdNlTnfw1FbgEPh6KV0YXhyKA3+41eGUJsBZDB?=
 =?us-ascii?Q?O4b1sKV9YWInehdtA1UTIcsLAwkYheUp8YeQu7qiZRZJbiDl++o0qyzRLKl1?=
 =?us-ascii?Q?VX8Bq8iaDhy8okz4Fo/FBVErqTQEmT/PKFYiBqaQONUs4486IBsHdxQ+Lbwr?=
 =?us-ascii?Q?Ge/xVk6X6P9LYwkygL8s0Tmc8KFDV8GKZdRJQU9Y7VtPKR3IOWW5RyK20DST?=
 =?us-ascii?Q?0U0GY+pqUxP+vGeee1dl1nxckDV7sODlqAQQE2hpXWbfVqrS/j5vo0xQap8f?=
 =?us-ascii?Q?oHblIyYOqhdyYCxX/46z3tYpWsI7pmkb77jDwCOY6MszbXj3Jic0JNCq3cT/?=
 =?us-ascii?Q?F6FVz0PG0nifFRNewcLQYg68gdrSux2Z3eWOz62mo8cgHFeKDtmruj64Ld/f?=
 =?us-ascii?Q?fMpqOMjNXckyiTyQcLbQe944jKJg4Qr2ItYkVuuSjWoCtfPyTNOitHSz9bCy?=
 =?us-ascii?Q?SGN4A1sfEmF/df8w+aHf0gWfOj2SZtiOaU38HT4zifQWLO92FodAL01H1cvN?=
 =?us-ascii?Q?qGktFSoMIbc8d5ehsITStnKIME822eg8sRxadaShaLzfOkoK8wNRSQFfHh6q?=
 =?us-ascii?Q?7ApRT11Y/P4fnqj9mg6TRI4irwNm5gpIctMbJzxRwoxawtgjjE4e2rigv63S?=
 =?us-ascii?Q?0eOjrED15PbQtGj0vgICgAE/4C9czjhagTa838APsWmIHrcE5qU2L+ve/iA8?=
 =?us-ascii?Q?uagBF8j/FSqFkrjW0iJq3UczZ4Ob4byl84/pqX7cqFdddP19gQ5W1OO/kHxF?=
 =?us-ascii?Q?bXZAM/MK6kMBxdn8PUa+CfGIT5T3GM65Vrn5gpM8n6c6HWZ3gKmI?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb10932-0dfd-4276-3374-08def81a2fe7
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 02:34:09.1541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvU5Zhj5KWpQyac4HyKsZzyCHsy4GxlGFlm+qt2mbFq4FwR7fPDNvuy9IXH+lYHbyhQmbxGfOMUX7q1O8Z39+3UFtCNhFwgLIo44fwJDjC6PZ+pV7D+FDCf2vtrwWSnU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0998

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

Lianfeng Ouyang (2):
  dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
  hwrng: starfive: rework clk/reset teardown order for JHB100

 .../bindings/rng/starfive,jh7110-trng.yaml    |  10 +-
 MAINTAINERS                                   |   2 +-
 drivers/char/hw_random/jh7110-trng.c          | 295 ++++++++++++++----
 3 files changed, 243 insertions(+), 64 deletions(-)

--
2.43.0

