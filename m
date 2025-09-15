Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC942E7194
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 13:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943045; cv=fail; b=VGeKgjwiGiZAyQHODzbi5O2VzmSQFOnBlV8vfB0qiXWeQZbgN9G3kXgF+cUkJjJi/MITZFfhpq4xV4hlsDWQUEghuwvb78DvjKXjdqy6Heq4upqhs65ysmzKqR/HxOXlKk6x4sMGvUIrgdo6UqQq/GYmWQYTlsJnNVMH7Lc8+Iw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943045; c=relaxed/simple;
	bh=swmggYG4zNQ/jfrbztwP9APe9iMpXAOUsjSvY5OPfJQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MjnWUa0Vy2VDwyPOw1qliRvRO9WFPpPukS+WpYZcMGOugThwGaORMwCbHOR4NCGPTzRBXLA4p8zzGCChtKif1UN9rtjVRCGedQY+ggppi9qh6ynes/CWUeQb2ZA5vwpZB5qqJS+nX+PaFyGjRS7IahlLnUusRGRIH5dmIsHHBik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wXMMS3RT; arc=fail smtp.client-ip=40.93.201.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wXMMS3RT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JXVLRafaJmNFNs7+/2VSTbQ4Uu3b/jxjOVgokOv/oKxDXhkLkdUfEFrylvMIfvqvDaLjRVyHFxbs2/qpBBFI3+IEHRFYhqz4neeFsnWh2ZwT6TiBhN/hAoqk4Au9wmyz0Sl5J2DsvUsFb9x8dtKGZCSIhTTsWUABqiYXsyIfQq2qTKVZR+NN82/qJ5Fbn7g0K06LAgyliFv0ktsYnkRBDW/psXqSwysdsCjJs0jdrLakzWgkOS+Ihk6/D3vXVQj3/eSTjH/bJOGtYfxpEGPEqeiFO4qFsg93+FvZcPOuEM9/DHIOYLDoaYEkdqYLRFFBafAsa1gLJjt2iVjb0t5CZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g44C3/i9Lf2+rgIkPYdOVq//mNTLpAE2qkzhls3v5PU=;
 b=jTmWGYG0mzbMSvVw18e/p6kresrFYnjhaPSqSsh6geaeX3Q1HOOJKDSqEnYozuojgUCpyJESZH4SpHN7lGMsFra/Xg3p/8/NxGWU/bCYBUQaoTznxZIy3H1gBH8LbzT7UU2Gj0H01IlLOgAUzVwcgUmyFIJvYjPzuptUYfcbLfc13RdHkeU/M9ZCGoJXoYJmDHhrrHRGPRkstb97keUWklccuRbvUYysnJa5sI0JbDaNHT6QdowH05TQxvIdzbqRdFHeho20jYrDUIB1Jyrss7QR7piLtG07/ESgjP/dCJuk9qbyW/4WKGnx0n+V0c9OgYIEXvheJc+xaGFVqouWNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g44C3/i9Lf2+rgIkPYdOVq//mNTLpAE2qkzhls3v5PU=;
 b=wXMMS3RTOSCXeSBxdK4BZuaDlbFD9RDS7l0y1MPyrjn6CXh3OZ7jFQl9rGRxoZSQ/AYComsBFTCTVD88cRkuh0TQ4daHW0UE/0D2rYLEWq+BdjLlfn+KBbiDLfR4OpTygc4huGj73YtzFJz7sA4Pdn0eQydwkjqDIPBZJ/YCddM=
Received: from BN8PR04CA0040.namprd04.prod.outlook.com (2603:10b6:408:d4::14)
 by DS7PR12MB5934.namprd12.prod.outlook.com (2603:10b6:8:7d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 13:30:39 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:408:d4:cafe::5e) by BN8PR04CA0040.outlook.office365.com
 (2603:10b6:408:d4::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.20 via Frontend Transport; Mon,
 15 Sep 2025 13:30:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Mon, 15 Sep 2025 13:30:37 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Sep
 2025 06:30:37 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 15 Sep 2025 06:30:34 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 0/3]  crypto: Use drbg CTR DF function in xilinx-trng
Date: Mon, 15 Sep 2025 19:00:24 +0530
Message-ID: <20250915133027.2100914-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|DS7PR12MB5934:EE_
X-MS-Office365-Filtering-Correlation-Id: 2855a1de-fa47-4fc2-6168-08ddf45c0ed7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sOpOlDfx88w8ajp/4aEpIvP9vZLfdaFicxbbkL/UDt68hqNOlcWiHhLPn5ta?=
 =?us-ascii?Q?0k+GI0P9qAUpI2Lld8xwfzumncYE6iiAqN33M/cAoHsMrx9zyeVWU4NZ/dtJ?=
 =?us-ascii?Q?nz+mEXaU+SSOkuVZp1f6KDapAKtmide+qwEXDPXxShi/dUv3DvZdlImN/Uvu?=
 =?us-ascii?Q?UYtrPvZDIcsUTzC4d2lm7+CPHE7xkQsZjHi8QV81Mx1T00FWALEOvPnX4f6r?=
 =?us-ascii?Q?6JHBMraANx+AnNMCujjEKDFWw+mMGuyCNmnPR3L2MlKiW6trXV/fHzFVZzJB?=
 =?us-ascii?Q?uR2R/2LPlMcMa08sEL7xknVh79m0eLq37PhTMfdwKxXnQWi1yPyXBJCrgvAU?=
 =?us-ascii?Q?/OVOxW0uYpos6L9yaD4o7GGVQ07KTlfcKqQ27rarHH5j1CVGF6XXPVDvsJdz?=
 =?us-ascii?Q?AQazD9/B9yZiIAMKMm/Tf8FS5kSHVotOMHZylo8ZXGgg9j8BwNBdbWCP5UF+?=
 =?us-ascii?Q?mkE5sWvoHDHwqLd0QnJ5lcY5GeNOEL9XC3KEk7E0DSWJLl/K1IfqEg/GSfCI?=
 =?us-ascii?Q?SoR5X8dZnThsptYfnonob44xdn+JFTaUZJLYDys8kttT9NELAgIq5TAQnAEW?=
 =?us-ascii?Q?KZWsUpfTawrBoPUKZbnTBbD459lo4vPpvRUKnpUXiFwsYtt8Wd64jF/DrcGk?=
 =?us-ascii?Q?t5hNCcAFDn510UWC2hYlcJoiLWGx3/8J8HbUok1Fs8nykOzMAx4VM02IGWqZ?=
 =?us-ascii?Q?D2HQbLM2cTTcnewBsCSKu4oIn8s4lp1l40RpM5AS9fFaI8sWo+n0YjYuEFvm?=
 =?us-ascii?Q?ixvjcuPqGhcfrjzb++fYEg0yAPBd7XbUzxB70DBq1UwrcnU0H1h72HzLhJRi?=
 =?us-ascii?Q?x12e5YdR182Zn1ejRcG1k1aweLFbyiB/QgF/WqP3ec7i75dOHv59+GpVL3Sr?=
 =?us-ascii?Q?0pUoiYUfq9uatZs6wj7MCZSJPa1a2rkkdXL6fIrbPHaUZu/oytabT7VXXl4V?=
 =?us-ascii?Q?+i/t6gNP4HUiqZ8RTaHlkWn24O/QNxpZLJGcUMbprHJNZuCFQbR3XOh2NjRU?=
 =?us-ascii?Q?kcm+/oX+oGpPkyMAmlsTcHB3Ip5spMKOEwNZlGrzS+CwBwVuc6972cTs8fdT?=
 =?us-ascii?Q?PjebcEo32VLOX9B9BhZX1zAN4RXpDUVAKBBn1Gf15EF0BKaGU4oIp2aMd8hc?=
 =?us-ascii?Q?Q++QkiStCX3b+KHyOkTIUnCy+cPONGaSOYEyiwaAanjYymABQBeKe3bVM1rW?=
 =?us-ascii?Q?Gpeu/FoaptnDTNbdiu8pk/rMIRA23EFNg+vZTbqDrPHT+Elq4JW+/BLSXzD2?=
 =?us-ascii?Q?tRG4Q3h9tvEtXWDt56ZJgF/Ij6Sq+LZf++TqJB0XaLYf13uknDO5MqrnzFbH?=
 =?us-ascii?Q?1BYUfAlfQ1T1nX4XqlW83qCw/LZnbVxtG4MDdpG4jE0eVK9JItGRtQieQ7wR?=
 =?us-ascii?Q?w0MPhJLH35WSKcX/sIdd6IJWOYzF/itKFW4lilqJVOj/UBV0VvjRsm3LiETg?=
 =?us-ascii?Q?qTauhZIf4ryYIJoF0YlijIWq1qX8Z8ELVw2WeYxu5HbDgW3LiKA4nxZAyngT?=
 =?us-ascii?Q?rRJbrFHr498vPD0P9VftFy+vpBkPRFhurHRi?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 13:30:37.9217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2855a1de-fa47-4fc2-6168-08ddf45c0ed7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5934

Export CTR DRBG DF function available in drbg module to use
it in xilinx-trng driver.

Testing

Compile tests done

* CONFIG_CRYPTO_DRBG_CTR = n and CONFIG_CRYPTO_DEV_XILINX_TRNG = n
* CONFIG_CRYPTO_DRBG_CTR = y and CONFIG_CRYPTO_DEV_XILINX_TRNG = n
* CONFIG_CRYPTO_DRBG_CTR = n and CONFIG_CRYPTO_DEV_XILINX_TRNG = m
* CONFIG_CRYPTO_DRBG_CTR = y and CONFIG_CRYPTO_DEV_XILINX_TRNG = m

Runtime testing
* Boot with CONFIG_CRYPTO_USER_API_RNG_CAVP and CONFIG_CRYPTO_DRBG_CTR enabled.
* Run kcapi-rng -b <15, 16, 17, 31, 32, 33> --hex

Harsh Jain (3):
  crypto: drbg: Export CTR DRBG DF functions
  crypto: drbg: Replace AES cipher calls with library calls
  crypto: xilinx-trng: Add CTR_DRBG DF processing of seed

 crypto/Kconfig                      |   8 +-
 crypto/Makefile                     |   2 +
 crypto/df_sp80090a.c                | 248 ++++++++++++++++++++++++++
 crypto/drbg.c                       | 265 ++--------------------------
 drivers/crypto/Kconfig              |   1 +
 drivers/crypto/xilinx/xilinx-trng.c |  37 +++-
 include/crypto/df_sp80090a.h        |  28 +++
 include/crypto/drbg.h               |  25 +--
 include/crypto/internal/drbg.h      |  54 ++++++
 9 files changed, 384 insertions(+), 284 deletions(-)
 create mode 100644 crypto/df_sp80090a.c
 create mode 100644 include/crypto/df_sp80090a.h
 create mode 100644 include/crypto/internal/drbg.h

-- 
2.34.1

