Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE14243964;
	Mon, 24 Feb 2025 09:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388739; cv=fail; b=RWJmS39Fl3X0396teN0ihyPou1HcAXVN1Q4mRu1d3UIl8zHavsVoaWpv/KomUr9RhpRTun6sctNsvksF21P0bA4zsBzYE6HzIuQ836t9FjeQrxHK9+E+ovdugfIP5mErDzCsXL5fX7IlfTN01C1+uQICoMXvKgOYmllPpn+PZGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388739; c=relaxed/simple;
	bh=h8EGX7YWOVRd8IsjeTyMQGPSBRM61jsMUjMFnuI5N50=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tsGC2eQuqPVAUEn368lpIkBJC+yL+okOVHCrk12NQiNBWN0xYWrybamsRU9uCUqAYtfMuLDFggoQdorV8845lso3D4ztu6iBasKO65RN78L5gbHQ4xe+CocC4IhvvVI2wfYK8k4x2eWglUdY9hWDE6Ab5346lqhQBaGLW/kfe5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DSM8a3Ge; arc=fail smtp.client-ip=40.107.236.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DSM8a3Ge"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c+LJjq0sTA8fBotYNUjiXyqmubgt9l/cuxslkUaIFMmtiS7cgNgNRuC7erx3nn0sglmObRdVernk6qfQUQWW04ysqxRJAc+N9Xie0mXLQAtU0d5EadgYx2DTY0pYdDBkXH1EmQNUNr18sfPYRlPyv79Zt0oI2acPSGBnCUHtfiPzbvF7WgUCSbNcKFZtW+2IV4zgoPhyz/ZeXO9k1p4RxrmMqNzQJfLZfq14j/+RxBz3em6QKly+8ghTTGYFjr8veonmbNu/PdrVCoKpzo1au6r3rYmTo05IgaJaUitNEYqkyXDWF5cd++lONYW37hpsf62myGH8DJm9azGHCs3EJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UfKD14AGkyUzraC+6bMfYk2iDMw+IekK5KxMa3On/UI=;
 b=cnXGGKhOOV8XaTTeL7VkEpH7kGytR7g3m+pus3y7+2WHIf/rsPAQRBGFZd7CR+6IV3PbayY4Q9/SULIJ7iQwiTe1icRoet+kTonbUU1Ytt+Ub8lUHilWLezsItXF49ps5oICLSnui1Ag7EfASrdWr6SCWX1KfRBFS6eC2p5gGjdQHHUvARazjg77shzvxNLhOFqS3Ta2UOs+5XKIP79FYdujGyLQSESJ+a63fbdptB8JFtOkhgIdZoHNidW2Mec+OsIKqPf/P+0jksbPfKmpudKLgIZXGoeVxwxrjJMYafNnejSub5BX0aTusPEvwppvaXWgf4W+FkdNR9SigN2Zgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UfKD14AGkyUzraC+6bMfYk2iDMw+IekK5KxMa3On/UI=;
 b=DSM8a3GeOuAaq02RTCfidfQ/xQxkM5yh806rdUu0t/PbL4d4plFpvP3xrWaZZYjZqRiAHCpqIfHyVeMim6kb0u3NrNlbktK7PDMPH/oqkXSG6pBd3fY79ih+LBzN+NrN+vr+ovK5TxPpsFBTNTUTLxreC70VZWZb4heLdIgblQdDphibQh/6LoW2dSObl+IU0hPNKV+l9pNwnjfXko0bcbj1W7GLnZqpBNghnmYA4tZMtL1pSztbzcTzXku0UmgSBKcJRpl+CkMfN8k65+ZFjw+Yhi7mxDYIlSOKM88TAsfOESoy49GDyHU4Iv7yd8S+Ug534W9P2OfoqIp+aFkvqg==
Received: from BL1PR13CA0129.namprd13.prod.outlook.com (2603:10b6:208:2bb::14)
 by LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Mon, 24 Feb
 2025 09:18:49 +0000
Received: from BL6PEPF0001AB59.namprd02.prod.outlook.com
 (2603:10b6:208:2bb:cafe::31) by BL1PR13CA0129.outlook.office365.com
 (2603:10b6:208:2bb::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.15 via Frontend Transport; Mon,
 24 Feb 2025 09:18:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB59.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Mon, 24 Feb 2025 09:18:48 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 01:18:34 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 01:18:33 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 01:18:31 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v3 08/10] crypto: tegra: Set IV to NULL explicitly for AES ECB
Date: Mon, 24 Feb 2025 14:46:08 +0530
Message-ID: <20250224091610.49683-9-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250224091610.49683-1-akhilrajeev@nvidia.com>
References: <20250224091610.49683-1-akhilrajeev@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB59:EE_|LV2PR12MB5797:EE_
X-MS-Office365-Filtering-Correlation-Id: 23980be5-eecf-4f0c-be73-08dd54b43f2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uAvpSxU4vqeA0FoYYHD42Ys3Vzgr77dr2vPvqCDjhQ/XQZfRoKIrOmowOqve?=
 =?us-ascii?Q?TOui5cROniOiBHUwidnwJi+VqTCc+8M8Jk5z+srincGsu5DgoktBzAbw7GqP?=
 =?us-ascii?Q?KKK1Wm76OyXLiUxg3Vs4NsesfiatwGnOh6ME0JpIqMNR6Vzuhf3vm+vrYqbH?=
 =?us-ascii?Q?+50j0ax6Cw+qxP+M0sCoCkNiWwBzPf//S9QJTPnG+tPjAn4rBKCSmVzKMqSN?=
 =?us-ascii?Q?gguElEzUN9dn0Ar4MSJejn1HpggX3F30uwSvJsH3EEasCTOtN6Lf4lIe0Nf3?=
 =?us-ascii?Q?r2DDwRvbAVtjTRzCoHNTSZ8MIj8+WnjkfImGdOeokk/RBBJKmaESyK650v1Q?=
 =?us-ascii?Q?t/+FfOUBD0EzEjMzqgij+xSK0wozp1YPEkl78UQ+QhIbE5Oh8Z6E42Be+k85?=
 =?us-ascii?Q?0TtSSXOLsObs3oH87q9Cz3E9yQK/ZDlhB0xMkO2yL+mH/jnuOOaCwHdiXUqV?=
 =?us-ascii?Q?sBiC65ZBtHvPC1YnAK8MkPPbPeLxSRSvDEyslTQ/oJ0ZyywHgp8V8B3Ky3ue?=
 =?us-ascii?Q?KZegFQzOCPZvT6UwmM1Zg54sEAGW+ihh/FETVnOnW7x8MtSjFe5qKbbcukUE?=
 =?us-ascii?Q?VO+1jHMipNb9s64gTZy/P+cm0TFZyTqXaFwmf3zyQN59X30gHzqW8g7xiwnY?=
 =?us-ascii?Q?gJY35wyHfDKdDUD5bQsmlAwiGI2iGSLqQm7h8ncZEU63X9stQbRYjjWjLglL?=
 =?us-ascii?Q?CJu6T7ITqikrqD74PsZ8YBAoT4Ws9IT106Et4NM1HYV0Q3oV7yVmuUNRS4mV?=
 =?us-ascii?Q?fBwpT3V8mLhp0ULEUBwFAKEGx6dsqXBCh4VIzTtkR/xUq1z3C0QD+/xFOQVx?=
 =?us-ascii?Q?AAft0J4b03ExcETrqg+bxjY7MMctiuf785xfOuAjkUcftNUqxqEPaSFSk7Fu?=
 =?us-ascii?Q?dthgLjT8GmUPFtJvtnUA9woNj8KhoX6GnApyORzcwhyJLEVFrPV5PhN3mLQu?=
 =?us-ascii?Q?9WjXPrROmN1B//VxGQWWjX9Xy9i0ReM7MU6JQila7PWEU54qVMCuR776Amnf?=
 =?us-ascii?Q?ROvDesz1isncVczQ7hwh/xuqfHQRu8SUYeR5feBD2x0t9kltS6sA3SuYJEDw?=
 =?us-ascii?Q?9pf3PIw/ohW53f5QkGvNIP6IHw/xRuRFFBPi0K1PpXuRyt49CZNSGT7pUKR+?=
 =?us-ascii?Q?4EWH8rv9YFsg+tTrzYadGLGZs2FmEKdwmNwpKhIK+GBHsjvzzjZYOgkBqm8h?=
 =?us-ascii?Q?tq7UYCRoMEYv/ozQsFpsmCAPo3a7ENFerMuXJmaPZmKhjA6299nBe32rLv8n?=
 =?us-ascii?Q?80o1TjfxHu5SesioE2j8DBp0UXZwDAruf3f0RR80GIv5Hv8fr0FuEL2t8np6?=
 =?us-ascii?Q?s5bZKboTzn4DrtInzeo+JbxOxyoFfuw53HlCZRtnluMCWSTup+iWASJjVVA0?=
 =?us-ascii?Q?EEvE806sN/P0J9URVa3eveAb6sXSUeG/Kve6a+m9MYkTKHqKxRdLyEo2mc0U?=
 =?us-ascii?Q?yTNvA9Jc6jCL/vppsYz/U30mRPZmLvUppW+o8ZCsLL2474F4E9REqIWHPlwW?=
 =?us-ascii?Q?2a3mjW83JSzYyTE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 09:18:48.5543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23980be5-eecf-4f0c-be73-08dd54b43f2f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB59.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797

It may happen that the variable req->iv may have stale values or
zero sized buffer by default and may end up getting used during
encryption/decryption. This inturn may corrupt the results or break the
operation. Set the req->iv variable to NULL explicitly for algorithms
like AES-ECB where IV is not used.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index c3afa8344e4a..a1b469c3a55b 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -446,6 +446,9 @@ static int tegra_aes_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
+	if (ctx->alg == SE_ALG_ECB)
+		req->iv = NULL;
+
 	rctx->encrypt = encrypt;
 	rctx->config = tegra234_aes_cfg(ctx->alg, encrypt);
 	rctx->crypto_config = tegra234_aes_crypto_cfg(ctx->alg, encrypt);
-- 
2.43.2

