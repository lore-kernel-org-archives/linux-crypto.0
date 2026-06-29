Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2090.outbound.protection.partner.outlook.cn [139.219.17.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D14F33D50F;
	Mon, 29 Jun 2026 08:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782722236; cv=fail; b=psJBdC1StRJEm+VCcDsxaKluMJSp3ThBsYKLICgWKqS8y5YJO1kqqfMKSoKuYUYftX6zPX13MORF9f8OTwFmXPsjXgN23xl9Sr4kQlYUcxjL+AI+khJJQr5enQQ/dGyf0TN4uiiYxpcjgQ6E6Y/CPjBluXTaB37MDCps+f6/eWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782722236; c=relaxed/simple;
	bh=x6jaeQRgtdNd9lXH658+sEasqLmKAklKnLn1XBsA6to=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=pG8owSNqmpXp9J2pXWLWAj1ZfZPH6lQq7a5u8PIB8V3IE1AHVF5w3ZXO2vsyaYEcyZozJZ4ucikyzezPnGusPQYNoB4Xbxw01scgziAaMWyP9yTzxjCtZpP1B2KOzHcQcmyAuG330lpN89stUVnh53o90u6L336PqHMHhaLwIOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/UQpvV/O2gvzJaX2s2jTYBWAxBM0L7opcU3j9SjyqZXrAMH9Nl35/xTGKiIry4ZHtYeTnLPy9RuLGWz8A3Qe4bVUq/9rRbZQXTVo6VIqtAVV5RzpVTQtQmtVXH2WL7Xjy2R4k952G+9Ms/bFqdw7GLmjMA+ukoaUP72QFEADUCvoLiwFi/Wj3p4Cc9zsxuIjNI/eD/s2ouF/c3HAtcYMvLWgYVER7MIxErGMqlkPQb8Qwvs8SLwsm+JAZeyuIidq+7rUEE8wy6HUH0QuhQM4IyyArNT9x9t8XppD7rdaJoSAKUshqM3G9e6FsIlGaZ8KMEu/lxWv3Qnr0JWw6eoSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VTpZ5KZchN2NJMZ+smx4G0v3QwoPMXmJfx5w7oSpYrY=;
 b=bxIGsAiAD9ZCtL5CTHaRSVsZUcTXCkCvIvjVz8MUYdoQQKqB4yqW0BrCdM0xyEQHybc93Vo060MDQ9gZDDnfeC0SQM7oNvlqQv0EQQEaJc6lvSNK0ijb5+y1IlULKb4J5dGOLgL9yL4Y6eEThngdo31/NBNqA+ewt9M2LbqMPCQHaut2CnL/F0SrW+ZsZt4QH3J6xY0h08WjKneQBVz4WvL+Y5ZfXO74bu6Ztx3Lps/VV4KFdtuu5hS9fJ0yuXx/0xOH2YIUW4Kf2SQXH3N5pn7rHejXTechoUFRiar10QKN+JTdW8nPuDFpXS+YCHI4Dx2oggUXtPlVYHdfXTgVjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1029.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.23; Mon, 29 Jun
 2026 08:37:05 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%5]) with mapi id 15.21.0113.021; Mon, 29 Jun 2026
 08:37:05 +0000
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
Subject: [PATCH v5 0/2] hwrng: starfive: add JHB100 support and fix clk/reset teardown
Date: Mon, 29 Jun 2026 16:36:56 +0800
Message-Id: <20260629083658.300191-1-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0022.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:5::34) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1029:EE_
X-MS-Office365-Filtering-Correlation-Id: fd7ab220-2543-4c32-2e83-08ded5b99959
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|23010399003|376014|366016|1800799024|38350700014|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	SPdwAr78wb6A3Wwa0Z4DpOWC4A3GAs4FItsCM/rkagQUDt4GgdUbC7T9LW3jNfrQx4szRU0gs5vHAzl+b7M+5odDLawvYSXbupkH16tTeU+4dvZ3vlvzjPuHl4+nUGtQOc9VNmRiLut2owYJ942CjB2XbdvZg0qcCigKoBZ442pIyYszdbn8ZqQ4dVWQSXZ3atPmGjgRcL1zVky2v0ePVRHrPr1hO5Xc7D+kiJgyjnXzdWeKfs62dQCdlQp7c82p3DDij24/Wzr46EE/q6CtGNyp5qQ1BRA+0ZqUdZdi+w/jLQEFabn5NkWvttvSlCaNVc7jNCVsa+3alEzs80IVq0bSP5W3FUUgVxh4YdAHzEDjIaDZ1Wl7HrlzRurnkTYBpLRpRWpklJUVmtRxovE1tnSQwXPvWj0lb5KMu5B9H5DJ/mlotqQi51nYU9qFCjdMHFox9/LWVAHNLJBmH99eKzOPXU0dmbUX6ByT4QtFqvMC1i4N2OitPUdvT0+VxeOhe7JrXzrgc13aR6YYwJe7FSJOde+qSMe0YooMCEjGZeInz/QAxKU9SUndl+x4uNjn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(52116014)(23010399003)(376014)(366016)(1800799024)(38350700014)(56012099006)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ogp/nel/BvdRNJNVOr2HcYJvTkEvDb5PcpkLQaownlw2kA2Srey2xxL+cnuc?=
 =?us-ascii?Q?bFPB/ljVd2XuknT9zd6HdBT9oZWZrZGrUUBH3Mswvq6v9jJFxPZlZIWnKpa9?=
 =?us-ascii?Q?tgC0NrN/Go8dyY7nKSHamXLor3O/J2yeHRrxbw7Sh/lIJ6MDT0OxJ3Y7bGAV?=
 =?us-ascii?Q?+B/aja0lGYO8ggujiUUZr9VBeZyQSmwG4roilHkX5MIitZW2L/3ogqyMVcou?=
 =?us-ascii?Q?wxCZRFTj8ZVG3pDxuHZzMEoEf1EV8YIKeiOq1Sns3XnOLIjcE3DgLZSZsmEe?=
 =?us-ascii?Q?UjdOE+vADqVYj5eFlXYs//QDA7nhcpcedyvUYLjxooq442hIfPfe63Y+bUrH?=
 =?us-ascii?Q?V7J/P2rMdYSfrHGzdl1/nB0hpmCcn7CALxq7rqT2dI0sQTKIT2p5+HcyocZH?=
 =?us-ascii?Q?Wb03N5WVC+Zm1RRS39k8OvVlhJ3HIYbeaq6Ynkehue4WkdFd1iVRAkVRLe4d?=
 =?us-ascii?Q?OXLmoMFkiIfunpP5RtcbNJWARfRqJqP8/AB22gRKN1gYDW3XeQnfqa+hQPQ3?=
 =?us-ascii?Q?CBe1DXgzp1d5k7xFPOS0p/HgjxDV1mwdKIUxfmcgHCyvyQorr7CpNMr03/Cf?=
 =?us-ascii?Q?+6Pmrkvz90vkLIv+yjCxH/DxKPoif/KIyrJ2xP0awtbfcgLhAmkeE9RhmQi4?=
 =?us-ascii?Q?Jlt2FcivCqeWuGu7gUWk9UbBgbaKFAEjIJmHaITbAjaL5etVAZ4Z4ptEJ+oJ?=
 =?us-ascii?Q?K3H3H7KoRpD3huFAzuQ/PrjGr+JKOArKwo+vJ/wJa6ZDdkccWEE5tWMMVhdV?=
 =?us-ascii?Q?iWloNwX4Vc+w0r3m0yOEVK2M4IEHdPRxTs9DsrfDXMyu5nepy9DZYAMILzTJ?=
 =?us-ascii?Q?Uk0TOw539XFa0HmXCz0Jvm7gKKgQ0RB8SGxdzD4VO7c37LxEybJnnarkKuCW?=
 =?us-ascii?Q?VBOvU3n9kh2ZLa/0ZB1MliXG9lO6yGKHbOsWuWUfu0BqOj3/9oT1PoEcFVFx?=
 =?us-ascii?Q?I8uu/4Zsy9r5t45k5PR//T0nWd8BjsQpOfS9JElLzeJu1xLdz7OwpcYIW5Wa?=
 =?us-ascii?Q?8hdEGTiOiJIerBuI9SLOsSPd+di76ZheQwbfemAb0f12aDG+Q+wF3bXfAx+i?=
 =?us-ascii?Q?mfoR0gTG9v74YNXxzfhSLQ6Y0EcQg1SjWTzcpdkfTymLq+DpOz3px/EPgHhm?=
 =?us-ascii?Q?JJXuYGJi4S/otrTbpDMLAs/f+nVDZfdMOSF8gCtl/z3kdxK0j/baRwGGPLA2?=
 =?us-ascii?Q?1DbwmEL5IitnjTALnr+U9wzNw/oeVpa0onGXPmSUJiw278S9tIPlf5Wq6DUU?=
 =?us-ascii?Q?fDOK43TxGmgGGFICESf0SQZgyAmC97Pm9/HRSebx/QP0d/HbEa3oTvmC29pX?=
 =?us-ascii?Q?vbzP8ZMXqTQac4YM6xPpgvvR4uSk5i5XrwKBmCqsvCayNGk09qIJUQeRx5/r?=
 =?us-ascii?Q?KQGe6RYH+Xpl0ILsnYtrhmPbfuaA1s1QdSV8W2y6umqu2AhJwzysGQT+Y5MV?=
 =?us-ascii?Q?5jWMc7O1ZXdDTK/5PnONpb08kAnK45BGVnGldzNuxt2wsWyxPuKFqHzZMV8+?=
 =?us-ascii?Q?oyLveS9/1+csfF70fCjTobQxdMR3ky4qSRMsNV0/b9byezyQl3KBBiAntFDO?=
 =?us-ascii?Q?TWZUe5JNgA1NTMY6hREHkAUgmCZtJQErhABTPdrNTXnSHfRGWUsxCQrj2o2o?=
 =?us-ascii?Q?1kenJBxQzQJG/Z6mrPbN8O1CHpNU+CE5WRpHlZEBzFVrtAJcHgqdn3xGODzL?=
 =?us-ascii?Q?GUP1pAtaHvjaAvvSgy6Mcb49/Qd2fkXLkJ/wl65k20fthhd1c3UQhiyzO8g3?=
 =?us-ascii?Q?AgOJ5vZYKJ+aq/m7doZJYzRlomn5AKgP1LdhDkGw5xrhRTzjmdrS?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd7ab220-2543-4c32-2e83-08ded5b99959
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 08:37:05.2683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IIY2GW73MEEHSMZ0bRT0veUo/6egHw3EG8AGf/POJI2H5CpdRuq2kZWeoWU1tWIEizH4Sl6E541RYVuj5r5FoUcaFZknaNvQg4IdZU7ojIT0BI+XG08yLG7+f9HsstRO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1029

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

Lianfeng Ouyang (2):
  dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
  hwrng: starfive: rework clk/reset teardown order for JHB100

 .../bindings/rng/starfive,jh7110-trng.yaml    |  10 +-
 MAINTAINERS                                   |   2 +-
 drivers/char/hw_random/jh7110-trng.c          | 312 ++++++++++++++----
 3 files changed, 249 insertions(+), 75 deletions(-)

--
2.43.0

