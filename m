Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2115.outbound.protection.partner.outlook.cn [139.219.17.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A63E4DD6E1;
	Tue, 12 May 2026 06:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778567084; cv=fail; b=Upe1z380f+qF6h+jdJ4JvPCJF9ayBCe1yyIZXg4/IBkFCugIjqiWXwlmBlpj+6K6VVLuDTmpeYjIgcNTLMIIFGgCFRXUlIpVdgXr0T0cqXBLTOrJzMVygktNb8pjNBFej6bmTYfPAmfXTeEqVK6FsvYlN0Q2MieeDqwD3kt8LSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778567084; c=relaxed/simple;
	bh=BHlFLFbaSW/ZHY3Mi86xCz7eZnL+l5vjYYn9Lruqjz8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=TYDEkO1dpHSpCklZ2FSpqsZocoRabg3+pTEZ5NgD9OSHBtrpj7z8kj3pnK9ZGyH2UM7jLP+e4g4uVzgtEEQeWnJUItXGj7SSSS6Klo6LJO7RhA8vTzY7MWwBxK4vANjHB9UKW+uioilIdl+k38Plek/e2A7gugehwMH0Uj8yyf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WK2+QhGUS05C5CaPET5M4IYXzv3BfPuCSgh7+orweSivTNdf6rbNDTJuSDYVH6EKhH4QPnZHTYjoA0JkGiP2dUZyIJSd0Nun62nGxTWfK5NuYE4QaSJBVscYQBjBn3V1OGV0vkxPecqmsPE0QfPKzb+Iy5oaOp/5nUI4gh82ZNHed9FTE0iT2acymkkO8BxdAyhszAEW5rQUAlHJQCJfTI8U7XjsovDwmRfmMWH4PKh1M2BbhtQ8DareSMoFUbT2+UEhkr8wav01oO1+lxbi4ME9OpJ6UcJYuOySgDWrSC3iG0Ea5ZuiT5J7MPY8OjePfc6G0Rj0vJm7mOj+I3iMeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVqXbAqFFPRJTDEjQ+x+wQaGagzYnyIR3XpIIb8FNVw=;
 b=iXbiCaEPdc4kfXk3FSDRThUWBzcWfoRJD3H+/zpWINroHueCjHcvmxZoLbL9auBRtZ7ekYz6kqa7d/NAkTd76qlnlmLj3gVSuPKWUwZXfOSzTLQhhVKoUYsKnQVJAF1wos3XO7OLKpFqf5+cHueQkrS09d0salqbsu+89RzLGdn2Y3oUnYLnJywQTcfplFRNNJtPsox1CCdpB0ChDAYoVqmoV8VMvswTUIcMjcZzfOCH+7uWa1Jo37Hc7lLrrajDeSKoU/MItYUKYjac3PPMoLgx/x9eNYE4d0jqrJmtP37T0RQDRn+Err4VuNI+JGOTpnvrVzAPpkQbCA4ZIy6Zkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1302.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 06:24:11 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 06:24:11 +0000
From: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] Add trng driver to JHB100
Date: Tue, 12 May 2026 14:24:02 +0800
Message-Id: <20260512062404.4540-1-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SHXPR01CA0007.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:1b::16) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1302:EE_
X-MS-Office365-Filtering-Correlation-Id: 051f897a-6a2a-46f6-c610-08deafef14a2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|18002099003|38350700014|56012099003;
X-Microsoft-Antispam-Message-Info:
	AWwrjGKLQC+JQlafRrEXHU5ua55PtYlCDjmCzQsOElEldgEPk7b1XA9M9A7B4sd61OW1kkTMCahKL1RCUul/9LPVsPUBVW3q/AyPSpnqWWsVxA0Va1L6ws+KdfzcEvsYqD6koUxfvyDsaRl6vJJ9ewsqM/C+lZQSliz5dNL0hYQX7Q8wIfX3bWU7yb0FFzlPHLA+KcAcEcFvhrDGFs3ekNIN98lmvKfN+KK4kElp9BlVzR552tggkjGbt1TP6bvKiC15Q6MDZpoqgozHpz7CeL92eRrsmaqX/lIS+CgXwBtAI1ui7AyY6UQ3/szOkDLum9jGUvWZfL07sLkNRuOx5+/wTMNkhixFmbDstzzlg2as3EvMGAnFwDqz4uPxd2Yc1e1Q+daxknSTxz6aDj6r+x5QuWQBHsZ/7ErSr+AjiWsfx5kFW4qporVu/tHxDXGF4mg5FXfXrLGz70ZYAf4rB2AIWVDCjStAZscxJPCOJCaQuiD/akLev4T2gOd64HTcZn/jqyNYavWPQixxhJZfxopDKPqKH4uapscsVtccZ+Qc0P4p5n7e6pAWrpxSKlFl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(18002099003)(38350700014)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JjGEePC5vdHeq1yP1SUPBwvz8RpSDZd9c8I08++A8yQbOch/U5+IMfwU3unV?=
 =?us-ascii?Q?FPI/Slop64GTrS9buC9Tg/pFuc9XKso/kA3IeFFk42KGgr2nQq+KjSxnFiYi?=
 =?us-ascii?Q?ObpkwTaFEltVlbhkbOJC1QJqLM85Y4Q9hSMS1IEmA2JqtBvPAEfP2wGGEFYQ?=
 =?us-ascii?Q?YanlPG6v+geVmR6ksxl4M1t6Z8nbyOHWZ/knK5cX1knhpD4dgjFy9J/xifWw?=
 =?us-ascii?Q?jxA0vEN7uwyTAk0dWC81hkwq0lAf4L1e97jLznl6lGM1InQQUh1AvsO9mEoq?=
 =?us-ascii?Q?wM1dWKHBviithqqidBG/Czlp66A546FHbHIDzHxbXNp9FFWqxisAoNIdR7VD?=
 =?us-ascii?Q?HuI9U/FAQShK9esNvGK7JAaBGjOf7opCwmz+vAm3hU8JJkhOLV0LiaZYJxxP?=
 =?us-ascii?Q?RKfQZUzXdIQ1Trr5id06yCa2+NYjEKxig3ERgI8n+HBA32Ab+T97lVdkrdmI?=
 =?us-ascii?Q?oB16SsLFGR5oO8PSmnVUPMI6phHpfoCUiA4DBjg2gpMAYMAZha/7hP6CcQuj?=
 =?us-ascii?Q?6mslHNmbId/9r8GeK/dK9lWGMUrIFePatpumTMMh/73Un7G3LJVFK2NcxXxR?=
 =?us-ascii?Q?utSXrYgQAg+S/L8hFHwfKvRsaqRoYbjBgKczMvK0pZYAYtffSyn8RMP50v+/?=
 =?us-ascii?Q?xTVJ8VYPVLVnom40cLYHJI6Vfx44ZOV7/518L6r2E759VI1cT5pjTy1AASai?=
 =?us-ascii?Q?r9GlZHI1FeOMfBaQiJ3ztjyfr3+YbfLUs41ZhQpyIj48khSDZAoojAcZD27A?=
 =?us-ascii?Q?bEB6XIXrRFfYh64awXbqYmEBpnwZvqPxmLhSo2gqZvNQDme1G2fAy0/qi/0D?=
 =?us-ascii?Q?nScEHVePd0ehodjg73gqlpqY7AEdPndok4SE97KVJPSW8zi66MAUNd0zWMXn?=
 =?us-ascii?Q?n15FKDu+mQjMcGO9CRdvjCNlCyAsR7ukdJ9KGGk1dEcl8GLJFquBWrTtB2Ln?=
 =?us-ascii?Q?PaftFupgonPNNmOf0uCSxV8iFuv0EvgW/fKTQAsHG0aCSqR1VTGHhN55Qew3?=
 =?us-ascii?Q?2qGwvWehyzeEMBCSnnRci/jzICmrF15ztsvvtCiqZyAj+Uj8xV4t7tlTXGle?=
 =?us-ascii?Q?tZb/LbKlHjchznYYQv0L9lu4WASb/UbSW9M5ctjeISnoHOPWZYBNTcg/qjK3?=
 =?us-ascii?Q?cA7s08JnKZ6fVZujuZJfm0EnGwWN7KGdcsTupyqLOO9tBW3NJiYfwKYQN6uW?=
 =?us-ascii?Q?GIzQYOCt+NTIKTf059czukuBfrcCIFcRGUe2PA7aPHWhOrYwdA6icS35PaMt?=
 =?us-ascii?Q?dHG5qAE4bChdVvBTPgC06jEHvU2BQSofuefxBH2pqj1PExo6JK/BGNV5l5ZC?=
 =?us-ascii?Q?dY9pOX08Xwr53eQfr+x9UaZ4vm6fYphUmZ/cmBt1mHx66AfCKBKMO94P3abu?=
 =?us-ascii?Q?1LVYgRLcwlea977gVLtxoLHejg/j84YQVRjrfXH1fHJMhLsiFUanpeRZG6EN?=
 =?us-ascii?Q?WaEKloCdhNIB5eV0nidgwRtgKSJAo4hiVCcivalJW/Ku0UI2s+Tv6eboq0I4?=
 =?us-ascii?Q?d3+IXEqDcSadcKUZUXuOTnUWJCoSdFsHIzOov+CvaNzs2B3RJuoo5AjiZeiB?=
 =?us-ascii?Q?jcY28iFjckR04JxZhHaDPDQNaD7IKQWH5EtSRm0K1TLGOv9mEE/G6SHXu9a0?=
 =?us-ascii?Q?pqUPSAxa1PpjDQky/VBvkGeoS0XQdHUovVncxD030LM6ZD0TcYQS6sIxSOF1?=
 =?us-ascii?Q?8K9FWKIxNIeAnyYelA00l4RaCCSj4xuXXHTVk5znij1HLioT9xQgBgRkL7tz?=
 =?us-ascii?Q?5awAZDDySj7zkKLqFVIN4Z6bhYsyA04fUhizfQdV3MURiOIfHnqX?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 051f897a-6a2a-46f6-c610-08deafef14a2
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 06:24:11.2696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DJpn4WHaXunl4oG5aCfqdIWG2pDoigYr7l7qs/vHCUt95QkOYQeGbZpjniB8mBOfCshakvVib3SHMS7SmjLxtg/4Ho/ElAg/rodcZrXFC+uFUn16TqTiA0IBD2sxl0jZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1302

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

for jhb100, While IP assert async reset, it may generate glitch
and propagate to downstream IP. In order to solve RDC issue,
conduct clock gating before asserting reset to prevent generating glitch.

Lianfeng Ouyang (2):
  dt-bindings: Add bindings for StarFive JHB100 SoC trng controller.
  hwrng: starfive: Update clk and reset sequence

 .../bindings/rng/starfive,jh7110-trng.yaml     |  2 +-
 MAINTAINERS                                    |  2 +-
 drivers/char/hw_random/jh7110-trng.c           | 18 ++++++++++++++++--
 3 files changed, 18 insertions(+), 4 deletions(-)

--
2.43.0

