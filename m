Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB6286337;
	Sun, 17 Aug 2025 10:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755428052; cv=fail; b=X2YDqp+yu5abifPT+XjsArJfVY5B80nVBq/IoSHYZqs3h21NYrwooHELuO/lwgydfSuNZzYRtlc718dN8hNgEFICKw1sZQQfm8Y2OHAcGsL6t/MU6N2z2waRxNmwCN9S8IqPLV6yKw0tmEQN9bsaNn6GJfIl/UZ6a8jtfDb5rpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755428052; c=relaxed/simple;
	bh=y8PcRaa9X93jNQsalPHOiD244JAjcgcIAcpnRJtv8PA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cZG0XJgJiGaQtLp4gLDTRUvqW/FDEyfMmPbXrZSXZKnPt65SS7HRsW658XaX4GzdgsozjPcJDCPJh6oKQRkPtT7+VJYQdEwiZV8XetRpVYR/8iljOmgfh0s75PeUeIPqJ/C4xfdtRVyc/v0qiIoIIW7Of7JdDtya7kncy+Jg6UQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=re27tA+F; arc=fail smtp.client-ip=40.107.92.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="re27tA+F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wZEgQNJjImf8J/V5MZf9LtEle5D+OqB3UZb2Q02MTLxGPBsDrX/E0d8YGstRMucgm9yDo3H2WFQWSH6PcsyJZ111Rq9NVY39Ospjwy2mLk3lq8QCl3l/9KL3W3B9ttCU/JBEx1EbrSf9QnVPAnqPa6SFD1gFgvXrTIfY9CrTCYxqmfhIwELaEcCQIpgzvREUlUEkUrYLY4h8A7d0Z9Bvpq7tOk1jwNY/S+/NanKuqyCkov0cYL9093hwpK0jpByS2y/2xa4kMX3QUNkePhC1tKZNkPGaMggEZsThGODVU9FPRTwAutuhHrMJFdez7/3PQlQkjB1LW45N85mzstPi5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XyXyU7ezUOjwz0XQBz7rXukXlfpIGAdNZDNQO5z61n4=;
 b=PbBtZuzMLWuL5T0lNvbzdNVTDIRoG6tz0fI+0xyFeiv1kBlOm5RTyY76cOFhW6iBzjaTm5OtIL1V3zMld58ckWpLrVSzN+deossU6mF/SICattVTB69LNJkS5NaoQE6JxoQq0+iAdznj15BEa5+2QCAx2CQ78o3VfaD2ZHwyl8XPQb4LDHvKQQp7ezjYD0G8eeqV7grtlQcLeDqW3BUadc0Np1V7VN1G13iDR86+v0ocYDfEXHDm1VGKPF6nBQlUAwW9hv5w3Ynkv4YFD4H+/lMxI4kkgcGleE54QIc1iSxIBfFOuhKNTmO7JFiEaQiYdjpMOH8k94AC++8LtKuqaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XyXyU7ezUOjwz0XQBz7rXukXlfpIGAdNZDNQO5z61n4=;
 b=re27tA+FrxztDbxXImiSy4Ju/Q+TAcnZnOHCx1RIDalj/4NLcUN6Xy/uRlwxMjNPZXcg9DkzpbogNGYZtq20OzU45Z8sgM+PNzzc8mRL9/ZlHtCAGJnh3o7Vfp6HFC1kXv+4onbwmHZ9Bb9Fabt2pbxRvG3Wp/92EmKtQyJRzKY=
Received: from DS7PR05CA0020.namprd05.prod.outlook.com (2603:10b6:5:3b9::25)
 by IA0PPF12042BF6F.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Sun, 17 Aug
 2025 10:54:06 +0000
Received: from DS1PEPF00017090.namprd03.prod.outlook.com
 (2603:10b6:5:3b9:cafe::7b) by DS7PR05CA0020.outlook.office365.com
 (2603:10b6:5:3b9::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.11 via Frontend Transport; Sun,
 17 Aug 2025 10:54:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF00017090.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Sun, 17 Aug 2025 10:54:04 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 17 Aug
 2025 05:54:02 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 17 Aug
 2025 03:54:03 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 17 Aug 2025 05:53:59 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>, <smueller@chronox.de>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH V5 0/3] crypto: Add Versal TRNG driver
Date: Sun, 17 Aug 2025 16:23:46 +0530
Message-ID: <20250817105349.1113807-1-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017090:EE_|IA0PPF12042BF6F:EE_
X-MS-Office365-Filtering-Correlation-Id: c187b12e-d240-4a0a-88d8-08dddd7c623f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6exb9Bh7oPxS//4JXvA+AZ73RYOkema3ZZfzztuwdXnFxO/GUyCpWdPngSGa?=
 =?us-ascii?Q?AmfcDBpBt2z2XKRbfhSMzSUs6ryDPLsyuccWQp5RsApzjXmX2cOegBI587Os?=
 =?us-ascii?Q?fqwMhkxhosHByp9Jw+NQSZXmuuuJ7blKLGer3GdNm3HPaTb++0LcsGp+jfgM?=
 =?us-ascii?Q?BNqDmejqsuEzb5shhkNAi+M5udvb8TSoHv51vj87EZqdYlBGJ/roGD7k855k?=
 =?us-ascii?Q?WNeCQeVIrcgh0oAfYFkpC+NsGoudHKRt44d7NFGm9k8bsiFYR5pUykMkkJG4?=
 =?us-ascii?Q?A/I4qQ603E7M6P6ykii//LqmmdyzBrEBtd4rPykkUWo5qS92FADGaAmWW/8g?=
 =?us-ascii?Q?hgMB5IqZau4WgFie0tpKcTy4jVGuLkIzRYXuhc5veWxOYyDJQSEAUYvvxgbQ?=
 =?us-ascii?Q?BccsTRPRJsO6QJzhSN84d0muShxdv1bsIt1cdeMn8zwdh3gYabzQRnh3pib2?=
 =?us-ascii?Q?aZLb047UwzZEyiEKjs+3002OoMqp5p9oIWXDVtsM4DP6IkLBNtsVGfTHOixk?=
 =?us-ascii?Q?xZ1ehC4+BU49ErChsmH9fPeI8cJ8qgeisre32gEoshaJSc8x9IdzdO6Q38f8?=
 =?us-ascii?Q?eSyCsSjXGm+pjsl8+v+YhVm9tGVv5/OCyUQMM8ZZakr0t32G/BYkIUmn+255?=
 =?us-ascii?Q?kLSTgGGnvrGbUT/792lAWJ8irICioHLUwPHFgobTR9RG07aw7MnSMXoGWxkN?=
 =?us-ascii?Q?ypB6KEMuBHHOC5FgRCdW417w/7IuStQ3oB3u1AsvSeusHUbM77DzyN+O3TWf?=
 =?us-ascii?Q?uod2TxJjsj9e2sBuvVaYB8+3nu6WiFsYBAoD2fp48cKHmWztBRoi0Ab4yQRz?=
 =?us-ascii?Q?KbZc3LVRDcFqvco9Bsc/xSw6O3ih4xGOumbRudJF02Qc9r6Aa1BlhyRtH8mO?=
 =?us-ascii?Q?RmbO5rIaEQmRRAHqU9lN5qfw9fNmdaFeosQnkXRpeIxrObjY50b23mnNEUoe?=
 =?us-ascii?Q?cS7yfAe2NaAU3zxGO6eexdd0hiXUa32ywD2nvc1eD0Z3ru+xZ1RzVl5WHShJ?=
 =?us-ascii?Q?+GKffURsHeQMSwhwRkfqz3K5VLBI0wWHRA4wgUiReZkSzTfGxuCBv1GRNe3i?=
 =?us-ascii?Q?vV9MDa9xETdf56I+78rGtCMl9wkrZIaP/FZpdCZJhODdzwcIQxg+x15iTskL?=
 =?us-ascii?Q?3Ja5BbB0KnRdznT0avLYpWeAKFhlIjPrlkv+Lahha36Jm9p13aOz9pCY+2DW?=
 =?us-ascii?Q?UVkWWWhMaZTAEMfVeP3MUWJRfCVZMm7QwZFbGYhtoX6TkCvuYVMG/mhRLqwL?=
 =?us-ascii?Q?JbMGzR7/5bU52XwlA5Sfcyq0yrt56gOD3Yi24UQpLgWQTNfLwcuTgqu+V+2Q?=
 =?us-ascii?Q?QB9qekEXd/vnJO77xpTzbOD5Fw/SKQeTnIa3f4LnWs/HU0MmEOuF5XnT3dMi?=
 =?us-ascii?Q?S9VVAZszBsB1PvO0pNN+XB6nRGZ+rnZRIQzzRwpDn2jwSe6cQAJxocTAR6Hd?=
 =?us-ascii?Q?B0agWAQokvSGqYaH9RzMOfaADgI5J/7/QtVb7b7iW/4YWZZsXH4p+JaZKo2w?=
 =?us-ascii?Q?MNk+9GVWvZX0m2gs4FDKlXqW+9wdzWdM0RZEHgB5yuqJpQGyGTVmkcYOWw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2025 10:54:04.9668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c187b12e-d240-4a0a-88d8-08dddd7c623f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017090.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF12042BF6F

Versal TRNG module consist of array of Ring Oscillators as entropy source
and a deterministic CTR_DRBG random bit generator (DRBG). Add driver to
registers entropy source to hwrng and CTR_DRBG generator to crypto subsystem.
Derivation Function (DF) defined in NIST SP-800-90A for CTR_DRBG is not
supported in current TRNG IP. For DF processing, Update drbg module to
export CTR_DRBG derivation function in df_sp80090a module.

Testing

Following compile tests done

* CONFIG_CRYPTO_DRBG_CTR = n and CONFIG_CRYPTO_DEV_XILINX_TRNG = n
* CONFIG_CRYPTO_DRBG_CTR = y and CONFIG_CRYPTO_DEV_XILINX_TRNG = n
* CONFIG_CRYPTO_DRBG_CTR = n and CONFIG_CRYPTO_DEV_XILINX_TRNG = m
* CONFIG_CRYPTO_DRBG_CTR = y and CONFIG_CRYPTO_DEV_XILINX_TRNG = m

Changes in v5
- Direct include header file
- Fix review-by tag position

Changes in v4
- Add df_sp80090a module to export CTR_DRBG DF function

Changes in v3
- Fix yaml warning introduced in v2.
- Squash fix patches

Changes in v2
- Fixed signoff chain
- Added 3 patch to fix Kernel test robot bugs

Harsh Jain (2):
  crypto: xilinx: Add TRNG driver for Versal
  crypto: drbg: Export CTR DRBG DF functions

Mounika Botcha (1):
  dt-bindings: crypto: Add node for True Random Number Generator

 .../bindings/crypto/xlnx,versal-trng.yaml     |  36 ++
 MAINTAINERS                                   |   6 +
 crypto/Kconfig                                |   8 +-
 crypto/Makefile                               |   2 +
 crypto/df_sp80090a.c                          | 243 ++++++++++
 crypto/drbg.c                                 | 244 +---------
 drivers/crypto/Kconfig                        |  13 +
 drivers/crypto/xilinx/Makefile                |   1 +
 drivers/crypto/xilinx/xilinx-trng.c           | 437 ++++++++++++++++++
 include/crypto/df_sp80090a.h                  |  27 ++
 include/crypto/drbg.h                         |  18 +
 11 files changed, 794 insertions(+), 241 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
 create mode 100644 crypto/df_sp80090a.c
 create mode 100644 drivers/crypto/xilinx/xilinx-trng.c
 create mode 100644 include/crypto/df_sp80090a.h

-- 
2.34.1

