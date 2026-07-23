Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2121.outbound.protection.partner.outlook.cn [139.219.146.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4533546DE;
	Thu, 23 Jul 2026 07:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784793151; cv=fail; b=XKBvZoxLKx+Z7jL8e9SOIDf/F3fL00KwaUP+lJl8vLL/sWEKEELTutGix4uDLxuasZpZPiUHU++yePKS2UtSU+mp7l6da7wmPRh6WFn5d8KYsMwRhVna2Ns8zBd1YuW7Y4HvCsQYo0wR+sdCgCKBZKQ1O5yUAh/7Y2R02maW9UU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784793151; c=relaxed/simple;
	bh=gyE7+hWdxBponmfuuFXHch2O8tjR8RogLaIBhS6U1ZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=mVy8R2/ZJWGtT9VL5xmjVGw2qKLOU/YnQoU4Gu53KiAHXpTTEVYA94rNZ7LQJqDso6NQBeNqOiTUsyNgZKOJpbgkbl/wGoBLQoVj4jZBc18qMyuajl01b9wUT53EDQJf8eGxQQ8PQ+8PGSIU7ngWksb9wFVGEtcaWEpAsDpBb7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9sJxDep9odd/ab84ltn7aFynScT8MzbMaeS02THoCh9XMWPyJz2yXBb03WAQArwwHANbIfQLlOK09+OkjUK/Jxz1Gn3u36sPPK+16u0ESupx74y+tX3jsOFwBbl2i3tlj/q3F3d4BhTkZNlTHASGF6qgG+kwEhIExQYsKf0KezcOjJGT+IQvRdrQDjli6er1cEkyrkn39PuZKt10eJBNp1jq1pgSB/Tl6pTRdo/OVeRwIuxxdHftNb8Wg2qJZF0WPGDWaV6p/jbywELJ6iTq3gExH+nIb7jUnNlJXQG0BJpSYuYzh4zw/FcUJlRGaXabOL+Cx9fRsmyXjYNrsMZ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ieFEMQMpfUU/ThtXITYvPoiqv+rUnQeJkA+deVkLaBQ=;
 b=d/rNBM94ZoNO9+4bocz0G7GdLGxoa5XVbeXDuR34IOMGoFqjGWQ1zLMQw5rqFqu04tLI9OzduE3LLIDGfo4AKL4wAqV86tb6jfb8KpLjJJccvgz8qtJRZbKHTbsKmqv6M7aCw/gHf3j075nK6WOWrTcJtlE+MJ4DcA54A5Jd3SeIz6mCSdhig6SrkSQsJed4pfeHsGTDOyEwnw3gBe7SoC5oDJxbzgy0MIazIjAfebYkyvB+piojd37ZP7xZWp46t21qcPsiRemlNRlr09wQIUw0SAakIYuZk3Ruhd31tDEKOwaWg9/5KRFLxla6SlENu0bVwpEdPp0wcK6OIzNvBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1126.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 07:52:15 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 07:52:15 +0000
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
Subject: [PATCH v6 0/2] hwrng: starfive: updates for jh7110-trng DT binding and rework clk/reset teardown
Date: Thu, 23 Jul 2026 15:52:04 +0800
Message-Id: <20260723075206.3032-1-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0013.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:5::8) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1126:EE_
X-MS-Office365-Filtering-Correlation-Id: 98008131-4fd4-4409-cdc8-08dee88f4fc5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|23010399003|38350700014|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qA0wCloA2DvU7km9zb+EECJb1L/lLXLsd9Vj796lA02bJ0AaWGb+hhRaDeGOUY9bPCITkFMgdNcuc10PW49VLaPEYLsFGBCXFk4Dj60ws2jxJfy+Y9+qf+jJH6HZNoo+ss9omW89pUzZqh772tz0JRxuQ3crkI7N9MAko7FBGebF/LsPZRZfXf5vbvNT8RoUSkMDh23vhqHV5sOhAFem4jlhzBhXWQtBEXwH9YN3354v/ULxcaKIq5MVCn/+tIGUw/aEBy57hNf3s/JHlZ6zLJw4n2ZhRXGgaX03LaUuP0SHV31pQWFaRZ8kxcpRWPMDxnu2+9/murFb1PI5BCgaqEgNd9TsIlHQ4HsAz3E1SOeNhNfrF9XU3I6ecNUGrPPYPLTYWnA+rM/p1Zej/oP5nbYPhphNE0s5iBE6tY98ulE5NHdzaTP3iXcBQURpq/MKYM6PnhuqMbRJ0lOfUQuyDpZEhgAx2B2J12yAl9APchN5L4FzmvnL8vYNI5ieVO/YEkVibLp4/VjewnphNgN4+Mb05yz7HKDXYjhwpHezxS6dGXDXRvWkLqU5u13+4WpH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(23010399003)(38350700014)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CnCAEb1Fdp0f9pX7cI1hg9FNNhNkKwzp6bFkmUHKHYQq3ZFcm125GZZgkX6R?=
 =?us-ascii?Q?s2nTGwIyh3sWJ/TlTAgBkqRFJqLLYiCpky4CLb0XsdoZrXnnDSATjf8Gj3d3?=
 =?us-ascii?Q?VzhQW4LV90aDOBjleQ7m4DZ/ksk5BVLDyJE5VlrSeUi2BJ+jtEYb1r6j7v+0?=
 =?us-ascii?Q?EJVfPvadyXuYVj9tYD2S3olkJIXKEua24VhsAfBcy2b3EZK0hxrk0457iXVq?=
 =?us-ascii?Q?/oXfPcXjV/CepsgBSMrMpmTxN6MMcVnF3tJdEYTFodTqzIdbdJXAwW5DQKem?=
 =?us-ascii?Q?jD1CmOjW2c8TQAHo+7QuKKyD33ssVTLQuXvDaTR+DQwqkq0UG4NSKDr4eKSe?=
 =?us-ascii?Q?GP/0TLadU08ExD4mw5TldYbEXeyJyAYj2nPmHGpqM5/Hxl8qbxYkYacSbW/S?=
 =?us-ascii?Q?d6L/ixskTFDGiCJN8PayoHCrtGJfBkqQ9RSLtZNEfRAagZPMY54Px5DpBIz5?=
 =?us-ascii?Q?BH3nfzyBcrA7O+/oS2uR4GbWPYOeZZANNuEo6FLIP1FYm75yzRZ3p9qKdi5w?=
 =?us-ascii?Q?ATm2V/lvWUgTsiqjbjPS5GO2/F3Wct3XFHbbZ7wIrs8dECAmLh9qKjYUWs6h?=
 =?us-ascii?Q?9Scm2IclnlZ65nnWcjoBZIf2WWuJa9xj7ZmgZSzIN4XzksanrsijJ+OIzxHy?=
 =?us-ascii?Q?6XP+yd8JP7M2bDMJ9J/5eu2R1TeGg+KLGtD3/diBo7v3FbeWl/ux3D4sXAyx?=
 =?us-ascii?Q?pxioGutKk8VfLrs7+4wCPvkYuGvvbRZf2zQ/aMJlUkrLZJlHVjcPxqGPjzJr?=
 =?us-ascii?Q?eSzDBk18U4FgFcL0Yb3LF7UTE/kIXVFUvTLQmVCo7ktp69Iktl6sHNTPYHj3?=
 =?us-ascii?Q?zExfXtX3dNFQ+tDOYmvSvFzfoT2dbfcJsytYW+P6+63yiVplOt6yWohoTzGQ?=
 =?us-ascii?Q?nXVqL01/aKCDmf6610cxFj4qfe1Ysa/lnmEh7891aTJRvMoWgIlgdPkMod6Q?=
 =?us-ascii?Q?TKOjYR1fnDpEzrdbx59n/YIe4Rhe0TtAZIjoObIrsWtT+5K3YIWqi/qBdhYD?=
 =?us-ascii?Q?GyxzctVnk+1eaXby1E9y+f4CmwlpTCYYXYmKbotoSaEGnSs9pj5bjtcS6nZd?=
 =?us-ascii?Q?Ij/t6i90CewMhYZ60SZrRavldpVH68WGKWHJXQCApLLgXcE2fyektDdsWOl8?=
 =?us-ascii?Q?aD3EU+xO+yaIASH/Oa8ftWpJ2LCWzmz3f3SkxgO6bLEJEmW9hTL5pNt2Cxui?=
 =?us-ascii?Q?pF0vrieLDSSSRYf1xl8ONfJpwU67emWkwMUozNvpkzhApkP1hdPj2yfJ3QFd?=
 =?us-ascii?Q?kFo/1Z+CBTS7b0C7bDS/YTg59fdFPp1bEa1ebLKjGWYr8Z1GZBXbgsD8GE35?=
 =?us-ascii?Q?hdr2nttqliBSwnibnUU3N8yXUHnay0OT6jWaTbssH+ZdIhsyW56QxOOPq5Tc?=
 =?us-ascii?Q?KNLPvkPLgL8qK0bOvgErSGimBIiaOJXIr2rn0zhcYpIp64cGYiws7lQZTTiq?=
 =?us-ascii?Q?yWAwaEaiPLPL7cta9DZm4MEzvbOiq8Za9+MZovESMp50Pcp7EnBhI5vioTlU?=
 =?us-ascii?Q?H3MPZgXdNKJFagKWox53MX6S2zLzYdOLnHAOmn657qbfunmGmdm8M33EKSrW?=
 =?us-ascii?Q?s8CCElgyWaFhnHE/wTznKPcLSuvJMzf4b0464Z4sjpffC9dwMRq1aXITlMAZ?=
 =?us-ascii?Q?05UrgWRhgLww6tQGHMZq4aN/ZT2igKxgxcUhVszhwlOoPa9WCOMcJKdK86sl?=
 =?us-ascii?Q?0CiOWDICRMM7Sm0Aa8r9OfkcM0q15rUe0i1W2LkBrDSmZ9I0PnIAj1nCwSqf?=
 =?us-ascii?Q?XyBh8JSaqwTE5kYuOcP9KN1XEEI3T+Yvt6QVjmSRqmytzu1QJHeD?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98008131-4fd4-4409-cdc8-08dee88f4fc5
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 07:52:15.0143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KlPjr5+f4G5IOFwIRHjrPAc5NweodFrzqpjkaeIO2OZkqVshQLZ533oSWCsGyO3lq63enn8ZKHsTWU9uK2wghgB6gDC0OQ9BLYhAH+iWB02QMYBurslUoQmahx+bybat
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1126

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

Lianfeng Ouyang (2):
  dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
  hwrng: starfive: rework clk/reset teardown order for JHB100

 .../bindings/rng/starfive,jh7110-trng.yaml    |  10 +-
 MAINTAINERS                                   |   2 +-
 drivers/char/hw_random/jh7110-trng.c          | 293 ++++++++++++++----
 3 files changed, 241 insertions(+), 64 deletions(-)

--
2.43.0

