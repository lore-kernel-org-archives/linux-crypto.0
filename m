Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2103.outbound.protection.partner.outlook.cn [139.219.17.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B313CDBAA;
	Mon, 18 May 2026 06:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779087188; cv=fail; b=qgZAcejlRAtc3LGNwefJghLkISph0SKCwfP3n/cnSZKnEOY/zMCzwsLSZMXo3OYMwY6JCyGaKADKSruvRBPKYsZCQNo+BzhrfPrgW1SM8BN1asdesFVHUZvHxLBfuts992JWlLhVpFGlXxrMrn4W3SQRyqNhzfq3ZdABbk573MA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779087188; c=relaxed/simple;
	bh=FzXWd/5mKSYD5wKpE4x23/swePndwstJz8+R1Z5PAxA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=WEQArt2fCEt6VDygEKqk9GpP3vlCjTCqINvsS2ePknPw+78eSqXz+X76moIZeFIj5Jlp0nURjigq4OjPu/cKCDDUM5h9nNcF2rAr3Mrs4HKDkm4sPutJTFiK1w/Hll328AQPuzibBDwdo0j9+pmV1vNALNYJ5sodboi+vF73Kxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5WIkWuPpKzwNHA2Jv5Zi31wMfrIVYE9FNCGXa8GFidX7dJuMDv48ptn0zu0JL5fFs9rSE0fj3Y2twrKykI6pk5UTXYnCfMxn9xNBULrTs++Ht0Zy7hm+44YgJNQ4F23fjRMGIkDWCdtq+oY3Yf0F74v9yggyfFeJNmJgVPix7++OunLhxB6uMm25eiLxoYx1RnhzSZWMfZaE5R/eMulJb5cg7o3KdAlXVqexl1MHrb1H2lqLEI4uzYG6OVn17jq2xuPOWY5zUPFu39Te6x9GPYzYTCpLu4Pw0C4X04ApadZixKSv4ZvkOIm0x8y1a2jCR0SEIyFrDUQvWk4qWB+jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pvl9qDLqi/9a7JKIUkmFcOlrJVzmHrCO6yQpQHZ/c84=;
 b=GfJpIfiZ5iuFGkzcl28YBHOV2OBX1vFjbstz6g92W6bzs948CGt6cq5mY0LbdIfwC7X1o8uJr1bUX/h6Zwc8gC01y5tGBOOSNh9rK37o1WosCFaJGqfTR0ZzOaBkijABg7dRAxMNfR+T5yWxZMvZXM637xydbpl8QXQzrJo+Bcv4rACX4I26sQLtkd50Q2k0Z1DpmiPnPX60tPn/RSWMNkpPGsh+Ze+dGhxOX1G0ASLPBFI54J2ijEcIp4ZRO6v59lK9vLdhHGC6niEQQ09sypXc8AGy3zDZ/GYLjSS98p8KdTvUFADY+5tTMY9ciMQCHVZIY2KeU1PzEY6Pqk1B5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1015.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.16; Mon, 18 May
 2026 06:52:50 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.20.9913.017; Mon, 18 May 2026
 06:52:50 +0000
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
Subject: [PATCH v2 0/2] Add trng driver to JHB100
Date: Mon, 18 May 2026 14:52:41 +0800
Message-Id: <20260518065243.20865-1-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0036.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:c::13) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1015:EE_
X-MS-Office365-Filtering-Correlation-Id: 38cd39f0-14d9-4fb1-13b0-08deb4aa13cc
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gjwniKMKQ6NydyQRDMcMzQkD725Ha/GIrA8CQkPiwgqGrDnUR1fSlMbqSZknApzzYVzk84jY6cF+0EEAjF4ekw0WakkXq4lLsOh/5FfIF2op880JH7N/HAmjR/assbzoXJsY/vSnwr1RBIwgDVrJzblqMogqDER/xlwwdBA2tMx16Ojb8JQDRKLeO4S2519z6LWyA1utwYYq9lmBCq297pWG+wREmBrOPRwCR0Mbffcs6FmX7cBxSFwDduwvN++o22Aj7qlUdsGYODBH9FNuUASfDLF2KhiW2iTmvyog9upGdI+7b+By0v6T9sdXeN46gZ1uW+4FsE12jImVssT5p60gezwuqTbKaOrJRq5vfLvYZGDjoPbF0FDryfL7RkPgnau1ytsmNulQUTVRubIrQw6gMYHXMowYql/2EkrQATrya0vjDa+oATLRn2v7dgeBbtU6WmMLGbHwnB1oNvH/A2lx3at0fmp8XZMmnJ/VlwsB758W2dICRGYwkiKljVpOFZe8gxtfLSIHTjnUzIk7H2F7cQ+PtDb4mxetKrNfSpzv/xz/0cFYbyaoFSqdAm5C
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?16S+FLVrxULesSDbVle9XB+QWuJL+MyJ6bn/L43pMkkwXtC5KYIkt7AJOBJN?=
 =?us-ascii?Q?m6BTIgKWaA78fu1xj5PH4EeM5KemK7+pFfyIEQLI9infLv5lOOn+2yc3aCtK?=
 =?us-ascii?Q?2T2XJCyJHOrNu1KcfMlxnhgQeAYiV0yEXfSZT6ZsQ/myDMKVXK1D4Ol/fFUI?=
 =?us-ascii?Q?ZIvGzlY5KMYjo/RzxD/09lK7im5xLkGZbkY6SF6YqIrUxFwI+4RApovF7ek1?=
 =?us-ascii?Q?vBK1TthpB3fqgeKfhqnEHCblgC32Nvw+1xYGIVfzQ/RKI+fYSe79Lo05n8FM?=
 =?us-ascii?Q?puVnFFa6ueSCn6olh+YbpbMVtfKMLkjxwzsSJpox15U80xAz9mKiqCxiqWUe?=
 =?us-ascii?Q?IwroMpGqs5PZSmQZaPFa2dkE9bfPB75gc/oD2aAYGqq5Axb1S8cgqqQEmVed?=
 =?us-ascii?Q?crblnkcF1H3jNB5ZSY5PQglBc7kjOemWFTXk+OvsL+WPsJFGFoP5N2rFE41J?=
 =?us-ascii?Q?Wgo4KePBFJcKyK8AaTmSFSzPAvlZBvqKduN3je9AcrhbibtNu2AOyu5lX/Dy?=
 =?us-ascii?Q?/pcDu4BYJCAnhl/Lcj+N/+Cvw98vhsdC5HW5I5uM3/QpD+MrXYMjbkPrEadG?=
 =?us-ascii?Q?S3PHebuV/ng9OymmSoeH0wcywMYj3AxBqX3illnu/6gfxpBu/atZIw4BAf+/?=
 =?us-ascii?Q?OutPIPE5u6g6fMmE40NVUpd+95C/SRX1BH/TdEFMbTMWnQENnTDZepuuCiK8?=
 =?us-ascii?Q?3JACIPhtfP/iUjG+YQg/ZrhR3h22A58svTKmIk7nEUDp2OPO/wwa839kruL2?=
 =?us-ascii?Q?y1byBhDj+V7TeVvUIfLcThVvwkxox/mizVvQY/eRjBK+lCwiVxradqzlGpFd?=
 =?us-ascii?Q?7mdVa0FRwlxRXzjY6jpoEs9AjELHTbixadR+P3yEAsk4CEOrKSEyT7VRZOO3?=
 =?us-ascii?Q?NRj/TjHugKRaBG8TqTN9aJ5b061g+DAqSLRsCSzIk2GzmvlDgs3NlmIHnjh0?=
 =?us-ascii?Q?7TleQtU6VGH7n3AkfvF6E4079w/EaApn/bg54bDZ62Td86SY/DSDumbY1yfM?=
 =?us-ascii?Q?ULx5oW+oI0C+aeUI5DKqnk8BOwkqGVCH8GdShClymBWZKzuykh/7PCLFPv0Y?=
 =?us-ascii?Q?u/ygmszlylz4sk2du0+c/FOQkO1Hvhw+iB+Lwjx4jtl6fIR4A8H32VPQvgcR?=
 =?us-ascii?Q?CN0mcsdTanIk27NToeloJq+YF25CBqsJ0isqZbx5lj1yWNXczenCxUQ/xc0b?=
 =?us-ascii?Q?gCq+9o3ZM1Lgb+9m+qPeS8tlN3fEiNeP0kg1IqKZNiHCQYZtxlPehZq+0RoL?=
 =?us-ascii?Q?S2eqoG1D4WIAurXJDND1vrE4QTnB/+MOeJuyxdlD4DZfexpw5XSI9xPXHQS6?=
 =?us-ascii?Q?0cAs6nzjwQm9xZQhTg5gJ5docNwtXogw9tvhxNWWxqSWKNPKuO+nVJlzWrC+?=
 =?us-ascii?Q?qTGN3ef23ZbC20IHxZuqM1kso98PGo4vtbCKDLS3IKwVdPSe0kPw2Kx0C7h5?=
 =?us-ascii?Q?XO5xIsBNNunTF5dLztVMd7EYc3LPIx4PsIiOOLXLt3C/59dq/Fj7QsJ9xLhI?=
 =?us-ascii?Q?+ReCwOqjoBmSXhFbKzVOuUyfxeTJtssRE5qi51eJ+Gz3dAM/3vuTAuv6BIuB?=
 =?us-ascii?Q?4UPB9juKcfLMxmDOUQ7YW9OEGFlmpwEQgkdzXUPeDbsN2RfQVqb7lcJsiWTt?=
 =?us-ascii?Q?QCennjkPzxtYm02ilPqtoSxJ+OXWZX07eMfTkEdnbuwhpUoKaqNostl4Xklm?=
 =?us-ascii?Q?nsAcOQmsLmoOwUvgkT4G6bfMhYfkMWY7v8kkOptZF7O3yrqaFfjJEpHV8PTo?=
 =?us-ascii?Q?Z6NYF7svhxkJ+3tzQtIZYXrmAXrCqabxhEN6StwRiSW4OBtd6Fof?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38cd39f0-14d9-4fb1-13b0-08deb4aa13cc
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 06:52:50.4211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynmqFwvFbe9o782ok0yHaii/52wX3F6dDrpR5tfxHQ6FLMU5nqdyiTSDkUr4mN/9CBZvBu1hPnZjtHp8ZIl+dpaFEk7DfjkerBBtW/On4CyjW06bZ8jlZs4nhD1uXDLs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1015

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

for jhb100, While IP assert async reset, it may generate glitch
and propagate to downstream IP. In order to solve RDC issue,
conduct clock gating before asserting reset to prevent generating glitch.

Optimization-driven PM logic. The original driver did not declare PM as
active in the probe, resulting in the count not being able to drop to 0

Lianfeng Ouyang (2):
  dt-bindings: Add bindings for StarFive JHB100 SoC trng controller
  hwrng: starfive: Update clk and reset sequence

 .../bindings/rng/starfive,jh7110-trng.yaml    | 10 +--
 MAINTAINERS                                   |  2 +-
 drivers/char/hw_random/jh7110-trng.c          | 83 ++++++++++++++-----
 3 files changed, 65 insertions(+), 30 deletions(-)

--
2.43.0

