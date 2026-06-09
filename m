Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2097.outbound.protection.partner.outlook.cn [139.219.146.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2567D3D34B3;
	Tue,  9 Jun 2026 10:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780999988; cv=fail; b=n3cjJ15WqggwbjKN979iuNukErK4tofGB8e64rXeIxzWKlphTjHmRpN5yUBvEiGtWiOk8X6vVP3g24KHzmnmzecNGoNbWsVSAYT3t6raJ2S+SNIuScH305UknuRbEi6Fn2a4rBBmRIiQxnqxmNaE/VJ97BTwKlgGfRQ2O6SRXCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780999988; c=relaxed/simple;
	bh=xF07jeNebCJEZUy2oGMZ7sYZcMqrHYCG4SgCw1eUxvs=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=mX/oK7jbr95nG9PkOFvT75YxAXdiX+WrF1hl13pJy85Ge05AjMGbJjh1rRQdlv20mhD70OPgRMrcOB6bYRDhmIky7AXemI1SpG+XOoZW+DiVGLg+yIY7tq7ZfDtRnH/NVJRyPCV/eg+pkMuTJkYgbVO1UQXlFGaKplkmKIfOz78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcCSTfCULhcMJzcL89G/PnZpZV8fA4QKKN8U+HNz93fCP3lQl037sFLbuR3Fg49b3wNZNnG0Y6Syl8TbMt1Myk5dtxN93Xl2zoWW8aArh59/q95hf7lC58vZpAlXk4t98Mo5AuaoEXQEmGh3GNFMbIUqXJMtF5yqubiEePIS3Ou49yrbWW/Gx7928hdvC0Ag29ef1lAWktjvnblVPUEPJ/NOvtYnwqCpjzBXOK/lS3Q+eOI+IhWyZSwOjvVIIWKfijb//hPmUz2r+PeHXf0gvu1HU83pRrEvIahrvFkB/IhWGjDQyLDZpyzsUBjz16b/ZrgjYfP0QZAudQl7tV6BKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSGSMT09PfgtyHv0ddX0RpKxf/S5NNfRRaN0bFMmUlQ=;
 b=EyZwyff/IQv2fqIxu4OWbqBF+hK9zG9bWHfaOrj4o9Hj8Dzbkk2lb7yHz45nYoqQlEKliZrwqu0xVUp55hSr+A52jmdVJet27a24XEZce1I88CrWNyKnMxq9I98u0WQef+rV9LxEiJtGDnFJdiOPBCeWojSrEsQxdtOSv11nvRUL9cFfKSgvOdA5MtUM6CzhCbZafGA4jDuqzdo97Jlni4/OS4dT71wWnD010Xok6LmIyAfJpBJYgoTcmx/3Xpq7agid6GqGK9FjovpPNFNyt+ZV8P/+rzShVKJ+jwqzHQsFeIFJ5/tQKBVxBqZ/pMfos29fUJlAB1eCoNhA+YQnRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1094.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.15; Tue, 9 Jun 2026
 09:57:33 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.21.0092.014; Tue, 9 Jun 2026
 09:57:33 +0000
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
Subject: [PATCH v4 0/2] hwrng: starfive: updates for jh7110-trng DT binding and rework clk/reset teardown
Date: Tue,  9 Jun 2026 17:57:24 +0800
Message-Id: <20260609095726.160559-1-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: 7c94b933-f345-439e-87fe-08dec60d86e3
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|18002099003|56012099006|38350700014;
X-Microsoft-Antispam-Message-Info:
	5xvDsKEa5uHgf8dHA61IxIcnIleUXRWe0WWs3vXfIarjHS67ITys33Uw4FFYVCriLM1zPZjA7hJ5Sak8ymDZNkfkRHK3ZmVo6izU+ClrJlZE0uaBIRviARJUIrIT8K75mHz2K8hkrkeLilrofbQh8dAubmSmeUyWtwdBRnIo1begsH6kAB0f22cBhNIxEKoeriV5k6CFNj9PI8pNSwjmRtytVthEtw/kwgy1bf9coMWzjJgSWnrQdEqwXK2AC1SXZRb/cTytf4CsN93KhldpjyJNYVTncepgwLUClIrCSrw9F373qCzXQpZU6Zu7YRueHm/FwpavaVQ05cSmOmMTrYKTKPHYbCRLievIclYa+1waloiqs44sG9phSy7Mb259d1A1ENwfTtxulZpLsJ2f8m5ffDF3J4ZqApT9YNJW36Z8KnZuDjqubATB9rCfcWaAtB1qx2r5fCnbtVAXTimAfcf4qVhDqOq1XA9utUMsV9nKvUd7wVFFc6SFFxqQrWtrWvHqXGuhM+lI6MfAVT3FOQVO3evMAC1Z0aZ8sFY1HxuMQEgimuu6m9G6772ox/a0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(18002099003)(56012099006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CPJZmElHDgS/ofHsgAU4641z2jaPezwpvE8avDJDlis/uGykTt8nC5OTPLaB?=
 =?us-ascii?Q?OuTyp1svWcqMzNpVJfEXd6iMBpF7vjlyd0GKjnzJ5SS6f48ppJktodqCEy/Q?=
 =?us-ascii?Q?iDPq5DV+fA1rRc/Q8Mu5c1JxteoBK1Nu4DJDHG92m8Np7vdJoLOYeB2nwSoK?=
 =?us-ascii?Q?B5fjekomrepa+m7Ak9VcNbqKzRquNv5oNHUEU0P7Z5A1MvaPCg4HPw/JhmwD?=
 =?us-ascii?Q?niA6oVscz9jsHcTIq3d/6G3dF91uO7RK4W4++WeiNx2lClpFytIvHo7DURiG?=
 =?us-ascii?Q?4L2a/q5BPQLZ82z09SYhGbuI8BRvQdSO789uVsVpV64AKPIuwYZLcgGIntjA?=
 =?us-ascii?Q?MZSrAPt5j1R0txk5sn1h/i00tr7P12gAU5u715AwWVw9sk8jJM02zrEb2Rsf?=
 =?us-ascii?Q?VdypI418o+n8EbQDpTKB8LIk2szfx4bM9FSa59kUaQQJYaEKUINCl1EeoNLK?=
 =?us-ascii?Q?QirgcxXom3IpYovC2Cmr515kkU6vFNO5dJR93bI1Rk/Yz9ADDPoVb0QaE17y?=
 =?us-ascii?Q?C7pyie9/YbJWj9Sj3mtkCq+ovxiKewVXGRN0Ao4GNy4xpR+qr4t1eGh1t8j7?=
 =?us-ascii?Q?KNkSUVMYEHqIxTrROYw9vXFiolRlH5MK8ZV/CxVacFdk0spwXtTxjm+P32C3?=
 =?us-ascii?Q?opmhql15/Oa2Q2h4iHahM3rYb5nFwhFQt8rzu5gKHB1li/6RhznJMrB1YyJo?=
 =?us-ascii?Q?EJKgtEEvcuIv/tLwyiJr2xZied5nCZVXIRkH+T4RPzpqLvKJZm5taNVbwCoL?=
 =?us-ascii?Q?EprmFFpdDdNmNyyvk4qw8jCXs0UwAXEtQWu8QCPWGMVPIY//az4baLrsmQAR?=
 =?us-ascii?Q?rlNrlTTGtKgw2ESoNAg8SHQAmFOfomJEU6zfw5i1H7ur7u6fCZl+1iywvvEZ?=
 =?us-ascii?Q?iFu/Wr+45YiZWKLfMcgjfKzGrlY2GF087BWZnGWySOCwVItN/i6rTXfI+Lom?=
 =?us-ascii?Q?7gVznFRgHodkRP7mxztAcox3Emhp3yyGKSDiPx+nuMtVG7nuAz0VbcDW5J7q?=
 =?us-ascii?Q?9lys6nTDVddX4EndfJyCYvwtrficlHHmEPhDoFRFYiXU8u8nKCWEqerKmrJn?=
 =?us-ascii?Q?yF862gfRJ76GBZDAqrQdxswg79c458qgIPhpILyAIseUOzlmejJHoAta3N4k?=
 =?us-ascii?Q?2rBmq9sl6eK+YF04y+DuAVu6r+pQdpcTO03BvJPLlmShhTYeByACpJZuYDxs?=
 =?us-ascii?Q?S+KOg/FYLQtQnZlN8DrMbK1I8SmcrBXx002C0P1pUlb1ksDdxgTz0lS9o1gw?=
 =?us-ascii?Q?RBL7+NPhJ+ANY0uD8ku606GgQRh0LFssFyrlyNaTHwnq3zEQ+rFFGhCGi1Z8?=
 =?us-ascii?Q?lYOkDxjEa8xcjNJLZzn6BB6ck7++v0honvOLCRK8LBQrP9SrwNep2lF4Jj4q?=
 =?us-ascii?Q?aDVsfiCbpHsqeCGJXxB7oKIkW/+Z84s980uphv9SitO3iHLQF3kNwTua7A/F?=
 =?us-ascii?Q?rW5Qw1czR/wrvTzc0MLpURs7h1JxLLjSBPNsHlzX48QEVHpmMQi7Fyfjw+/i?=
 =?us-ascii?Q?tWBneCyowCx/V2QMW8inGUv5x/ZYJMwnCTux6BZSXXvCduhQZPCQEJMQk1kD?=
 =?us-ascii?Q?+WZOPej41fjHymvHQPwpP0ufdH8jAmTE0NagRpuwx2vf532FhhADYGgTNFQm?=
 =?us-ascii?Q?JYYiGJsrA8LXRn52RYTp6InUGVgY4eXu3am+53aJ0nugBssGq0I54GCTAHq6?=
 =?us-ascii?Q?Z1BClKLeXqgyu0i3t/o79px6patkulXbQ0KEWrBII2yfl0+NPArfglv2wyAU?=
 =?us-ascii?Q?FzCUJr5PGhDrlJsU1kABt5et7DIgbYnVpX9XCbUcQXMZV+IWNNaY?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c94b933-f345-439e-87fe-08dec60d86e3
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 09:57:33.4911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rb37TecWsLUqA0wEbKMYoFV8QRuC8ECkYWR9SjgZ21QKefyqNiW0NM55tPwPWODPoUYJy0vUhHPetU9HB5/7uXKSRtQTyHNflMjdq03ZsuD2afVZoHaO6JovIih4h5bF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1094

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

Lianfeng Ouyang (2):
  dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
  hwrng: starfive: rework clk/reset teardown order for JHB100

 .../bindings/rng/starfive,jh7110-trng.yaml    |  10 +-
 MAINTAINERS                                   |   2 +-
 drivers/char/hw_random/jh7110-trng.c          | 223 ++++++++++++++----
 3 files changed, 180 insertions(+), 55 deletions(-)

--
2.43.0

