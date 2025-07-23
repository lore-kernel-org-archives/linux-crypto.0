Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2067.outbound.protection.outlook.com [40.107.95.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C3A218584;
	Wed, 23 Jul 2025 18:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753294951; cv=fail; b=J0/BCo6MbAriBBDc9fhmpZSuDMAYpLliFVEmsnr+zrR+YWrX1uxRfiuoAfa5azwid83RCIsMBoXq/00iiHV1LplfP+pWERepySxmSuYHDqyRG5HBPEpzLT7wgqJKsqnjjW59PMTkU8rQ583La8LJ7WCPmiDiN1tY3ekM+REWrOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753294951; c=relaxed/simple;
	bh=m8aa+PYtZsc2I5eWnUK8Kn2fu+j50PWfuvjK0wU43oY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jUVazAO3Y2tMf8Wrw5XCeW2xQiouyOqsTFcjsMn0kEldwfdKU/WngFC6WkEpreMVclyDRknAojx4wUAvF76yc78jZkDwk7AwV4V96F2km+7SM0uMUSjWXgJkZqGlFHcodoS4qi6rcDn6RmFOHiOb/OlB7GPUi8ym63NU6U58gKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5R3P2ia+; arc=fail smtp.client-ip=40.107.95.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5R3P2ia+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IMy9nIOxhPxM2XILvgmZB54M3x61OfPOsIhXVJ9VpVflNLhsQYCRTJaVvmsefhOPQs2SLoH8UGFq/4FufJ6qsnR8IZ5rEUEJ20L/GcCfD3+OyfwryT4571T5ovyfNcNWPIGFMW+L2uuUvMXCavTUQI8Y0Wk0gCAhbH4HJZOEa9jujrw/IWb/yeAG9DvK6psPhFlhVBkEQjW4RyFd0IAKi4iZ7MfM8oxU+9CjhuU6LUzwXDHvjZqUKTo1AoHJEpaL8yBdO9VBxEFlCL4fVyJ0bK0jfXubV4E2q+kc0HBJWPNnlr//JLbz0HZvOC3kFhsdcXdU6Rs+/SSmcF9gbVVCJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLbury/vB5VlQA6pEFP+IX1hNzzyYB46wn8iLatq7Ww=;
 b=KMjCOpRtuFKHdsGGnQ/UbwhNw79gT29ROCQpMZuHrRecXttcd0K5nLfboEHCsyZTOaqbaXH8X+gPrAPpdUHjStsoTSZEphenNTOA1yoqIIyDtleiHwApsemm2QCQ/rSWwBXNBXz6zF8xtaO4sebnGGzfq1cwoNLkkCCYToHngN+idcoQjJ0A46diAxXLPBhwprmYatwzVkSX9R1IpknS9d8/jvW00UGd/DcHbHSme49e8zmfzDZRnMm98vU+mHlVDBJ8a46fE2jN873j8KRfoloPQzqGI/8O0ZnVaK7Oyl3Q65qYffTitZL2AHUrBYeA3Gjrubyyx8Mt9BjC2/+b3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLbury/vB5VlQA6pEFP+IX1hNzzyYB46wn8iLatq7Ww=;
 b=5R3P2ia+E504pL+ql92SPKr36bMpaiT9C+C0CKPxp2Wn1hJb76KiN6sVxpXbQqJyFQQEIYTZeMhyXQwjNO3A/qXOWhkrccEoC/LZZe4KvyFt8q2tRnLVu1R4frjlYW+MhfWYYE7BxvRrQu4MEEz3A9q71wR3cvJknAI+Pj/uD14=
Received: from PH0PR07CA0082.namprd07.prod.outlook.com (2603:10b6:510:f::27)
 by DS7PR12MB5791.namprd12.prod.outlook.com (2603:10b6:8:76::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Wed, 23 Jul
 2025 18:22:23 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:510:f:cafe::cc) by PH0PR07CA0082.outlook.office365.com
 (2603:10b6:510:f::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.21 via Frontend Transport; Wed,
 23 Jul 2025 18:22:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Wed, 23 Jul 2025 18:22:22 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 23 Jul
 2025 13:22:22 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 23 Jul
 2025 13:22:21 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 23 Jul 2025 13:22:18 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>, <smueller@chronox.de>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v4 0/3] crypto: Add Versal TRNG driver
Date: Wed, 23 Jul 2025 23:51:07 +0530
Message-ID: <20250723182110.249547-1-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|DS7PR12MB5791:EE_
X-MS-Office365-Filtering-Correlation-Id: b5249771-1855-4b67-fef9-08ddca15ddfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QD+e465f/RY1mRH/Z1eqNlwYu5H5NvacQZgVoGuuuUEakJI0+fvQNr8u3YC+?=
 =?us-ascii?Q?jfDX2sbciL7g9IyBlPWxxVXuXW/PIdHtKlpeGcw/PyLeLSqrnNDwOw/bxK8T?=
 =?us-ascii?Q?2FZSJwvRfPjV3oTYRNQ/uYWDpFOJ+2WpyMvTwiIN3YvVC0z1pg5VYGGVmhNi?=
 =?us-ascii?Q?EslZfcysbKKK5w15diqoaT28zy0STIOKYbGllTqmweeKUdod1WbWwZVxVxRI?=
 =?us-ascii?Q?8+HkoxvA3/tBmDqtlAsogL9zupUpnHQZu8DmoeWedYuStMvTyfhAza2O9M0U?=
 =?us-ascii?Q?IZQdWPD9Ie/9Y+WJ2uRI/PTgEg55nGtjkelFBzFtDaVzOQRUQhJHxiAUXvaU?=
 =?us-ascii?Q?VFsnq8g1c/L0aqe2JiwA/jbndY/ppFQpadD2AGYaJm5998UU+7dhv+GyI6oF?=
 =?us-ascii?Q?p+yyXfuCuO8ASQ6HICZhY2d/jA8PRZrlzWpxzC1MEPvKUFOYYEDj/zz2Basf?=
 =?us-ascii?Q?tZSuVvNhNr/OHs/TAgfTnEjO3u7KZ3vuirUMhUQB4S3yM1uOMsH2lKq22BkY?=
 =?us-ascii?Q?L2CD1NhEhNoLMMNj6c4PkhtWV0vJDV/sKIuWFtlJ02Srh93R7bqd+zSORgnS?=
 =?us-ascii?Q?qvs46GxXZRN1vB/jebTBlLxpiXpBiCrUMosdPsmnnzE4zMpWuKIdQ5ig63l8?=
 =?us-ascii?Q?r8mFNfIefYnyrxYpPk8EHz8KkuqRxhYcWsOI8Y0gqL5fL8nxxWW1KFrRDD8w?=
 =?us-ascii?Q?oDOz6xuOHBe11exqBA6Xrkmz/VULteMlHv1exDutACKrMd9/d4PkDGzwkvwz?=
 =?us-ascii?Q?hrClUTcJf8deCmLZpHwBU+G+A+7iF//ffOZYbNiK/OgwhPYsdfX84V1Byr0I?=
 =?us-ascii?Q?ix6QcVE33wr46dh6T1IDbeqYUf/EwhRImkdBYmIHwCRdPgqOzpBGfzn6Ldkh?=
 =?us-ascii?Q?vt1KzoCA6A8mfoRxX3MHu7zoBhoSGB5oCIegEoaWGmhUld4sbt0wUWP4j6XU?=
 =?us-ascii?Q?2panu8Ymhvl7IiRmFuRxEr/1qc6jSSL+OWsM56RmpfhQCR/oKJyGZgYyACX7?=
 =?us-ascii?Q?pGsJRQCtTgcAWF4Cb7QkN7l+2gKxnvf2VEmvdNLPrDsFfPBTf8VAt4yUTXTa?=
 =?us-ascii?Q?aBEb3zQ14MIV91Fq6R+zc/eaIVHMi5lv3rv4ZgHz9RFLipdX0tx5Pk1MGTOO?=
 =?us-ascii?Q?uED8nyDtFGuEHR39+TFdjtzqTeUhxFX/Owqqwhma7vmUhe+hPeiOvyZYgmJE?=
 =?us-ascii?Q?AKu6PREbaUjgGqWKAgKNIAwWrlmuUN/llks38FzKE5nix6QKLnjEbLS5fvAl?=
 =?us-ascii?Q?hu3w+HjcdHL6GHxNde0R42fbVg1L0GD1rewjf55V7qlaGv910rppX5f/Wb8N?=
 =?us-ascii?Q?LwIWP5ESB3p+DHGhZv6Ng9Rwd1TWanOFKucutDTtLTsM2wlke1PNKS5hBY7u?=
 =?us-ascii?Q?yFz5xD0DwbEDrutvYeWXcvFbmBvtKWLzekHQJMAyrA2zG/zZaMBP9KoQMiWO?=
 =?us-ascii?Q?jtisspJZH9eZkw+uSsT9WCFV07zHKRDZhmTbA1sMRuMz4BF8bSCSmHfZbfio?=
 =?us-ascii?Q?68fKheB+g5JInji+orn0ZWgHwCwdX5DXwC+k2kmzgdy3B/pGFGf4ll5FKg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 18:22:22.3139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5249771-1855-4b67-fef9-08ddca15ddfd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5791

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
 drivers/crypto/xilinx/xilinx-trng.c           | 434 ++++++++++++++++++
 include/crypto/df_sp80090a.h                  |  27 ++
 include/crypto/drbg.h                         |  18 +
 11 files changed, 791 insertions(+), 241 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
 create mode 100644 crypto/df_sp80090a.c
 create mode 100644 drivers/crypto/xilinx/xilinx-trng.c
 create mode 100644 include/crypto/df_sp80090a.h

-- 
2.34.1

