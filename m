Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023078.outbound.protection.outlook.com [40.107.159.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337AE2D060D;
	Thu, 12 Feb 2026 10:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770892788; cv=fail; b=hw+XcgESV/03FZvZUG2dzelkUbZvODuis9J307/mX1lfh/oA/a/QixTfBVIdyXmdvdt14v+z3ptLV/447PechqghLGrqGwQ5r998n1RfemE/W4zKqYPm2yy9Qw78n75n89dPRfKdbufCjxwn9FDuXjiwji5Wz3VskXp9NyWBgXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770892788; c=relaxed/simple;
	bh=TAwPN4wrO4artzP2upurDf/kUo/F+sUwpKGY143rzKw=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YBZCjUJxY6YHRXF6bJreaS3R4dKsNVqeQ7xP96h8mrF2zCPAhWjLPyrHdE1RavvfsFzCr8wq19XfiJnwts2K6BWYOKCBCiW70Ht9YR6xVQV9VqpjaWzE1UualinE6idvoDNoiUNDbKLDfO/mD+K7FHAshRnSFShfMlXhLm7X6tU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com; spf=pass smtp.mailfrom=ginzinger.com; dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b=U+OdMGTj; arc=fail smtp.client-ip=40.107.159.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b="U+OdMGTj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=knNDdNUtLy6Ut+yp8QsvM8p7HZOaM/xB1l9Fhvb3q6HIkgc6G/TQBxLf2pEjIErcwtOprO0ZWBn8Ldu+nOAoSSPpnh1LlAKV7QU1TORu3ngftnNEj6Wf1OlgRMYDSAzCzoWUZGpfBLaG+bJxzEA2JAIPUnosl15L65FUO62EX7gxC5c2ax2uQVvTSXIYdttJHiGepaXRGeOuf//13VG5DWQCuWwDCF1Uf0fD1DS9bPSNCYEYSNQc7fBTHOGefeZwiDKuxl5mU5IYz/OFfSDMxuA0q3qfCzmOGh6InQzftYhgSrSaMmUVFHQaz8a38OcbUNIUaEYnDNWRkPnpW6KoMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8e/LZANQPRg8V27MhR9FmsdCZhqrT6l7XIxZjCmMu8=;
 b=MYyLb9LfJp3yVML6pZaPv9YU28/CUloEBcnI3hQwgiriayw/ieaq6KgcpXsoS6SaS9GecPq5ZeZSeTufff2dlBCt3u3dRve0BvQb78PWwve587M0BGtHSI96Negm2wTaLoZS2OwsyxhVtTcQd0Md4NRewtDGxnfN5zwYSUC2ONpH65fdHz+s0qBQK0nbjdSJKmwWbcYkFaAuLeIbl49UH0Y/fXMUtmZG2A4WE5r67t9zo6GUMTCFNED5cznZodo9Toj9v4andp7euv7tvo+cudmlGelJfMU0iN8PRSlUVMbJV7Wib9Zo7mbdIoTX2o/UnDAhgsgCZn4QpfYKBOQpZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 20.93.157.195) smtp.rcpttodomain=google.com smtp.mailfrom=ginzinger.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=ginzinger.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ginzinger.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8e/LZANQPRg8V27MhR9FmsdCZhqrT6l7XIxZjCmMu8=;
 b=U+OdMGTjcWNcOuxa8ncEON1v0iCyBCEONUeu1W7cQ9YpVKjD2rOoxJQeSProjNJHcNEbsqDRFhfPDXw2ZILBWB7EZWqHgCyTzIv8liB9xGklZcw0QKknJRwq3OSTZJMcZrFiGOObwtzcpMpOvJNK+R7s20Dk6eRPGxGfnqpFWbI5t0eVITbtmrL69DfDygzILszFmmOBTJj47L4EBqVM5ko67raFw8G1dzmghjlDf2LpNzN/5Z17AQDXedeXCznvXEtgVM67+1EX+0K+GaJN4oVax0FzkRLwXzqrqyckpMDJ6imgVKerhK/Pdstlc4PYz5X+cq/BK3kJdZhsYsnXyA==
Received: from DU2PR04CA0261.eurprd04.prod.outlook.com (2603:10a6:10:28e::26)
 by AS8PR06MB7911.eurprd06.prod.outlook.com (2603:10a6:20b:3c0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 10:39:40 +0000
Received: from DU2PEPF00028CFE.eurprd03.prod.outlook.com
 (2603:10a6:10:28e:cafe::c5) by DU2PR04CA0261.outlook.office365.com
 (2603:10a6:10:28e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.11 via Frontend Transport; Thu,
 12 Feb 2026 10:39:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.93.157.195)
 smtp.mailfrom=ginzinger.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ginzinger.com;
Received-SPF: Pass (protection.outlook.com: domain of ginzinger.com designates
 20.93.157.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.93.157.195; helo=westeu11-emailsignatures-cloud.codetwo.com;
 pr=C
Received: from westeu11-emailsignatures-cloud.codetwo.com (20.93.157.195) by
 DU2PEPF00028CFE.mail.protection.outlook.com (10.167.242.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Thu, 12 Feb 2026 10:39:39 +0000
Received: from AM0PR07CU002.outbound.protection.outlook.com (40.93.65.67) by westeu11-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Thu, 12 Feb 2026 10:39:38 +0000
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ginzinger.com;
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com (2603:10a6:803:d6::26)
 by DB9PR06MB8979.eurprd06.prod.outlook.com (2603:10a6:10:4cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.12; Thu, 12 Feb
 2026 10:39:37 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25]) by VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25%4]) with mapi id 15.20.9587.010; Thu, 12 Feb 2026
 10:39:36 +0000
From: Martin Kepplinger-Novakovic <martin.kepplinger-novakovic@ginzinger.com>
To: ebiggers@google.com,
	lukas@wunner.de,
	ignat@cloudflare.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
CC: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: rsa: add debug message if leading zero byte is
 missing
Date: Thu, 12 Feb 2026 11:39:15 +0100
Message-ID: <20260212103915.2375576-1-martin.kepplinger-novakovic@ginzinger.com>
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0289.eurprd07.prod.outlook.com
 (2603:10a6:800:130::17) To VI1PR06MB5549.eurprd06.prod.outlook.com
 (2603:10a6:803:d6::26)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR06MB5549:EE_|DB9PR06MB8979:EE_|DU2PEPF00028CFE:EE_|AS8PR06MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bb32742-8c92-4bc5-3916-08de6a23067c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|52116014|7142099003|38350700014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?/7MJZt+Fy6/BT8TNooEKX09/B5gbftwBjoN+kndCSSC7RqXOGUbuppFQ/jSt?=
 =?us-ascii?Q?MKedmr621n4mtOYa8DqVpUaQOMPBTwPYLPCYnWs6RM7VTSGC+9NJjYBv7nm6?=
 =?us-ascii?Q?3cZwcd8aXCYeHEC/QcOh++mSv9dyeNoiz4n0N8NffYrSyQ0Y4l9hlIfJ6jjJ?=
 =?us-ascii?Q?ZJ78BadTXW+H4wd38+bVUI118PUA5+sjU1FDmvJLF3dZdCPoB86JGX5BtQhc?=
 =?us-ascii?Q?KBpY8a+GOQeSLSdj5d5hgVhOK/5KlcBag8pobrd1NcPysuY+BfsvhIibpRtA?=
 =?us-ascii?Q?mCHCXlPP8ktHbJqHFE/JbGWzXU0xGiZ8Y7VMX1bCInlU9NbaFFS1MLwRyCr+?=
 =?us-ascii?Q?xb1jPTeHQAZGCayxtiJ62o7f9kb0JcBrLhd6KWAEMlG1FbugP/h0s9U+F4Y7?=
 =?us-ascii?Q?JjhoOJtlMK4PFFs1a72UxP0mq0kn0iSqdH9rXpeZwe9P7e1BtFn65Q8LYJzl?=
 =?us-ascii?Q?NMypdNRSBj/jmxxFFVxET0WuI0+GBqayyHM04mHaZulqbVoibuxPZ4Hxb2VX?=
 =?us-ascii?Q?1saWioacl6ixZqfWnjl//yUz5sFhNn8I3TMyQrqL3CC5Yj/IGbrmVxsyDKJ3?=
 =?us-ascii?Q?MJUO9EvXOSjbhEGWSoXsfytvSbvWlJYDa6w5xJm3LtVKF0UBVDufCWY3kyWK?=
 =?us-ascii?Q?M4V/Z59sz5QdR6bbHf0LwyXANCxctlhZ6cFlqozkoqGLcg6272QhnqFg9Qju?=
 =?us-ascii?Q?yiwoNnnmJDf3zL+boHSUrCI4cAW/o7OBSFRyq0Sc0Lbxv/LKzJbvt2mvVjRN?=
 =?us-ascii?Q?U4PI5kV6Da6jBrsNBv8S80UqNufOj3M1syzDEuEPP2UpJ3yCsShJy7s+InRv?=
 =?us-ascii?Q?/srLOHmmgstbwjkII4sACHKDH5oOTPDp2Mco9MZhbI1BORfhalNNRsSUEMAE?=
 =?us-ascii?Q?jFqQEPGX/YTlAJdh0bj5ue1L7hwOelIlC5gwGDWz0U8oU98/XcX2eA3aE+Ay?=
 =?us-ascii?Q?CSebvUkXEmFZrGJMWU3Uygxl4w+4U8Ry/gYOSZeZs6JBzt3VS6X3VGF9gyK2?=
 =?us-ascii?Q?AX0fhQBnU8I8vROM8MpP7eVDd/UOmm0lcuw2pQY76NjJC4LzlTarp2iqz1Mr?=
 =?us-ascii?Q?tbynriel+Mwd6if8uEIBZ4MX6+b+wA5CEAcDDwmCHoc4k4JDM3sTlZmY+Dll?=
 =?us-ascii?Q?4b7DGCDVyoGCRdY+vA6lYsM91qgILlBnt//C40piq2nDH3DMVdspUUI8KLhm?=
 =?us-ascii?Q?f8wD7QQAWwKzk4b5+ZNFj+018gVhCPIb1fDRaz2Tz8k4rj7cMISfEKQo3l8u?=
 =?us-ascii?Q?vY4+74MY+36q5efnM5DEBRn9ArvCo1Mm4s/nvuloxfMf4LraKiSoI/OZ2tRY?=
 =?us-ascii?Q?edCmaXBZjiMhA4dlFSopelnjJkyCTsWM0aS1PmbMVmFf4vbz4I97vmzMQDck?=
 =?us-ascii?Q?5Ry4SKe6LdD7szXhju6yv9sz7oS9u9E4TyMnoF/heoos+LnUbZh7eVAH2r6m?=
 =?us-ascii?Q?9+5UDfhMcQlQt+af391fo53ni4fp2jUCgtY+ipfto29OT+w1gb/FViIZ0wWF?=
 =?us-ascii?Q?3AKATKVv5vd3RgrpR0Ok+kxfB9cV4AQjhA/zFWxGeL+WT4Fq926BWD/fjFPS?=
 =?us-ascii?Q?GLrfZ/wBXvFqEjbvm1NPkJY8afnrIpMKOI1CPi31T3rONHOsP9bYyrx/Rlck?=
 =?us-ascii?Q?zSQt5SNtkEDh1rwLS090DV0=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5549.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(7142099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR06MB8979
X-CodeTwo-MessageID: 42281d0b-0c5e-474f-a416-8c707b0fa5ca.20260212103938@westeu11-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028CFE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4973b52b-ba45-4ed1-7ecf-08de6a23047b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|14060799003|35042699022|376014|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IohxIVuAPyZCFlepB8suwM7kV90rbVvvL9gJVZa/NgOUOWb5yOfzj6M3Tea2?=
 =?us-ascii?Q?NDnq+maBBVg6crkH602tAq9Vpbuyj0GbFvJSdBNKweFeBB1AsTlkvgP+zbAj?=
 =?us-ascii?Q?Lkjby7dQZzvEY4M1VBDphbWUkoNCSrnqlG9mQqROqiqYjxr8a+3E5nXaGT+3?=
 =?us-ascii?Q?JaTtEpsZ1ND53CoOciWToXOVAKIovWyzM9kRh6/G52MCBpKqhf6EYjqEKZuT?=
 =?us-ascii?Q?93CMfRMIukd2iG4sjmBhGYMrdCitn8gFxyc8EBuXGawF4Cgh4XaLSavGp0DT?=
 =?us-ascii?Q?N+5JQm8k8Cn4nG9KkZv1vMc28MCpKXAF95ob+lUe5lzy6FETRjT7iyoFT7R5?=
 =?us-ascii?Q?2LLuRh/0yb4JBAjXJ1VVby1fBE3jp41vSaWA5Wm4Bjp75GRrX6MBizC8jiTx?=
 =?us-ascii?Q?1TbffZmU98LfFDFdJ9uqqVu6KRH2ZmflAzijCkJGc0thKwIxuU3Wi+RKc2gF?=
 =?us-ascii?Q?bTgsDFdhkMtaWfJMcY8qikhcbloKYzdF4I22eOcydKN8zTm+MIarmRL7Mo18?=
 =?us-ascii?Q?G46Qx9pZwLeyYsn4w4KSmGxCi+jWomfCcachKKKR2uz03qVvKUYwdNFyy1dZ?=
 =?us-ascii?Q?BLQxijjBwGs63qmaWEDGZrTHGyiCox4u2UR+NsPus+eWQETOrkMJ6fpWHM1V?=
 =?us-ascii?Q?ZMj1y9Sl4/ZrOVr8zM/fxFRJbUnt6xdgzp7UqRMdEWNEzhTU9wfXXJ6jEBk/?=
 =?us-ascii?Q?dRS7WTKv8AJkS6zRftB86PUHXzOHqP0vLYpcXUBpo03Nmi4V/bLn5RnXyGxa?=
 =?us-ascii?Q?WQqsyF2d4elRPrEh1RatZAtf9wg09pookIRiTUQEZ1a6htS3mRw5aa03EcH4?=
 =?us-ascii?Q?qY3aLo2yrFm5cJ+e3uqqJLvkIzPsI7XhLdAxDzzBoXN8SpScJTpBX/QhgJH+?=
 =?us-ascii?Q?176NnjIih0mFXu9f7FubTg5chvnH5R5AZgrDOi5mGn4b1lLRT8ktcDwU0hKM?=
 =?us-ascii?Q?OTl/02V6/zgA5E+xAoae6Xmey3ODnWux/ICl9BFfuV6bUANgMg6g2B2E2cWA?=
 =?us-ascii?Q?PEnu+JsT2PmPE39u0wLqrbMlDi3HLHmKti07z91erSnvd/Hn7+PQZ2eVoALI?=
 =?us-ascii?Q?eRzmrwLCVqk6icSi7aKcZHj85oRT8EiFUkvrxySbQkRIIJKbtMUI3xniCt0N?=
 =?us-ascii?Q?1V1m7+2oXb/vYdGwOMGZFIynEauHtIsqv9Zba9TTP/fHaMCdUg7kZSdUxbPZ?=
 =?us-ascii?Q?mOtRd9RzuNugC7L1b+ODgtsngd6iCdWu5w9PcfcG5yow70Ux7ox7BwBOSkiC?=
 =?us-ascii?Q?hUqgh7nLEE+VAd5KfCm4LkT2hG/r8FJTXHqSG/NQYyCWHBWXuhwJeNL/AZ+4?=
 =?us-ascii?Q?eDtHpmcg8+rOrg++PdF9KG82xUGKFVmc7369npo3V4T9F/dbBYVWzGQDioyj?=
 =?us-ascii?Q?53quVbLePfu45VJPR11iMWTAme+mbqpRT4iQoQ6wdowxx3Op+Ad2KHqRl/C9?=
 =?us-ascii?Q?7QLhnLb4wdbcmb6D0pBHrN46wRqCTUPUR51MXVdGVMBOyzwYX5w0kGzelvQ2?=
 =?us-ascii?Q?GZRX5glesreobDdVQ17WRGuVSWPygrLKbVzhthSyrp3F4qlI/6OvIr92sUTV?=
 =?us-ascii?Q?anbg9QK67B/4AexEVdTDWKihbNLnIE5xEhuSK0J9ibBrtH/Cf7OS3Pymq0bG?=
 =?us-ascii?Q?0vjCB3nBbY2hxsqXR55tS+tRwm5LRiZeurH9lG4JMH8/trQRiYErb30RA6oy?=
 =?us-ascii?Q?IkJSbQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:20.93.157.195;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu11-emailsignatures-cloud.codetwo.com;PTR:westeu11-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(14060799003)(35042699022)(376014)(7142099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JmrTXxMHiVPj3t5QWnQ3Num/Fw7+l4nHY7UWZLduO7zM1ERbFV9w5Vzg+KGl6yGnpyGRTFj2h4YljlQ1+vaechB8lJkV2ZrZ0aRAfiKkOzaP5Bm3R6Ha+42iPwcl/j2KDUPxoJTOvaCARcsGpNtXxCyAlcqQNDHfEWV7EDzE+JFyNHvpt48GaSnMTxMpzRQBnG8Ro3plklTRfGbpBm9BwMq4spRz2rafA8GArALS4x8V3lD+tefU0V/kakpjAch5KWsLjWsikgOtsF54L12/hZ5nAsThBOhn0Qlpj9e4mXh5ljkJt0eXJPmWo1pzK2mzVp71hBNO6UDIIGSSkTVOsLKQSIF7lAAMx1tN6eBR0v1nQLt1nWrFb8Ebg6oP3c1UqIeCut5cDfeqTTzcx+7rzCl7pmW45ZK4d8qscX4iTTTjAMa5E4xBBuujhGE1SbmM
X-OriginatorOrg: ginzinger.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 10:39:39.6631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb32742-8c92-4bc5-3916-08de6a23067c
X-MS-Exchange-CrossTenant-Id: 198354b3-f56d-4ad5-b1e4-7eb8b115ed44
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=198354b3-f56d-4ad5-b1e4-7eb8b115ed44;Ip=[20.93.157.195];Helo=[westeu11-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR06MB7911

When debugging RSA certificate validation it can be valuable to see
why the RSA verify() callback returns -EINVAL.

Signed-off-by: Martin Kepplinger-Novakovic <martin.kepplinger-novakovic@gin=
zinger.com>
---

hi,

my real issue is: When using a certificate based on an RSA-key,
I sometimes see signature-verify errors and (via dm-verity)
rootfs signature-verify errors, all triggered by "no leading 0 byte".

key/cert generation:
openssl req -x509 -newkey rsa:4096 -keyout ca_key.pem -out ca.pem -nodes -d=
ays 365 -set_serial 01 -subj /CN=3Dginzinger.com

and simply used as trusted built-in key and rootfs hash sign appended
to rootfs (squashfs).

I'm on imx6ul. The thing is: Using the same certificate/key, works on
old v5.4-based kernels, up to v6.6!

Starting with commit 2f1f34c1bf7b309 ("crypto: ahash - optimize performance
when wrapping shash") it starts to break. it is not a commit on it's own I
can revert and move on.

What happended since v6.6 ? On v6.7 I see
[    2.978722] caam_jr 2142000.jr: 40000013: DECO: desc idx 0: Header Error=
. Invalid length or parity, or certain other problems.

and later the above -EINVAL from the RSA verify callback, where I add
the debug printing I see.

What's the deal with this "leading 0 byte"?


thank you!

                                    martin



 crypto/rsa-pkcs1pad.c | 5 +++--
 crypto/rsassa-pkcs1.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 50bdb18e7b483..65a4821e9758b 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -191,9 +191,10 @@ static int pkcs1pad_decrypt_complete(struct akcipher_r=
equest *req, int err)
=20
 	out_buf =3D req_ctx->out_buf;
 	if (dst_len =3D=3D ctx->key_size) {
-		if (out_buf[0] !=3D 0x00)
-			/* Decrypted value had no leading 0 byte */
+		if (out_buf[0] !=3D 0x00) {
+			pr_debug("Decrypted value had no leading 0 byte\n");
 			goto done;
+		}
=20
 		dst_len--;
 		out_buf++;
diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 94fa5e9600e79..22919728ea1c8 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -263,9 +263,10 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 		return -EINVAL;
=20
 	if (dst_len =3D=3D ctx->key_size) {
-		if (out_buf[0] !=3D 0x00)
-			/* Encrypted value had no leading 0 byte */
+		if (out_buf[0] !=3D 0x00) {
+			pr_debug("Encrypted value had no leading 0 byte\n");
 			return -EINVAL;
+		}
=20
 		dst_len--;
 		out_buf++;
--=20
2.47.3

