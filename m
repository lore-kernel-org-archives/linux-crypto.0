Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2050.outbound.protection.outlook.com [40.107.100.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DB0199E94;
	Mon, 25 Aug 2025 07:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756106233; cv=fail; b=UK3O/Stq62K+vMC8aTvtHOzCmCEUBEbmLQjaXCh1ie+z1j2/yl4e9t4YjV4zTM3ZpOWuEpQsMGyp//ELhTdQSCvBjjwGge0txlj7khqzJZVE7XwhjunnIpJw+3K37g1CveFE2dwf2zM1v8ZVsORhkGJt7CPceTYIDW5SntlLtdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756106233; c=relaxed/simple;
	bh=OH1gdbk/7mBJSJbTg4i+oMDt+yRM53BTsFIG+rIF5Vg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kBtm/dnh012WL5GDFOuZn8EPyNaS/eWzsROyvMdNNE2Euw8F9o8o6y1WWva9YCP7fIsALHC9/DVddKrSwf4A94Ax6dFMjCSdJG+TcFAHEJLp1xLfbJcPDNjhnP8wFEeQS6YwE6SyX8tmasFsq/bzLpJAOJlEy0/gxWCeE8MTRCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cNOIp6df; arc=fail smtp.client-ip=40.107.100.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cNOIp6df"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dcx60msnmz+xM1krzk/+QW9meL90zBgOqFvPuv4JRsqO/j1rlaH6cQqEUpBZi4av9KWrrWlF6f7LQ83q2PLwYkY7zZLN68vq1OaJksPdHQFwDvDEQx3BTe0t9E36BsxHu4ss5unBQZyLdt3x6P9DupltHGRRhE27iqRDfwnHzQPWzbpyTe/I+TkmU8j4dv4Jwu+e1hVAZfb/Vzzt5be+6tr6FAFu4l6LRlcsOz9UzV0ApeQlSzK34jjWAfNYUwv9FGySBvzm/q9//1CXUgqIdQVsNEZqXRlvEXMoz5FqXQQO0HP6eZjKzsxs5yHxNMUpbVPCphjsYvvddPCMv4VJew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtWg+xdOZqVhoAJps0u5DmMgQ4CcV+t6NLU9En0sjgs=;
 b=PL/iVu66USEZYe5gkYe30jOO8mqevn0mULuz932AWa0BudT5VKuqgoKO8FKg9OaAtpD2ZKcqZ4i6Cv2HljVeFQVhE8W0z2kqIP3CfWMqEZ4sYsecCcM8G3lpFjfJcEfk2/3Gpqr5zT5/P707WLlrpsHyePMjdhk5Qn32qbige3oAieGGYmEvc0rZo2her0iJdtTxjvjcQzhOM1dDj8bPM0kl1t9MD9XREVxCTjH0cuibanU+lgUU57F/rYwA/7ZnSCwjYl91uhofO1geQKL8PSN7ayyUAoajjI2qIPoOPVxZq9FZtY3vILc7LilfkThEV3wFIre6/+ZJCJfPhsUI3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtWg+xdOZqVhoAJps0u5DmMgQ4CcV+t6NLU9En0sjgs=;
 b=cNOIp6dfgWDQQTIx1oKvkGB78R2nt99ww3P4wC033xzJGgHrcI/lev9Wu/VAMCoWAiJbLvjI7J5jbTTee0zfh7Th44dsoOlJPYcbN1Ts7bKlOwu61XDusKrDqAKd/dhGYbs7ubv4PJ6l8xofDo/70eqy3bTtLh8Jsbd6JMLULYw=
Received: from SA0PR11CA0156.namprd11.prod.outlook.com (2603:10b6:806:1bb::11)
 by DS2PR12MB9711.namprd12.prod.outlook.com (2603:10b6:8:275::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 07:17:09 +0000
Received: from SA2PEPF00003AE5.namprd02.prod.outlook.com
 (2603:10b6:806:1bb:cafe::33) by SA0PR11CA0156.outlook.office365.com
 (2603:10b6:806:1bb::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 07:17:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003AE5.mail.protection.outlook.com (10.167.248.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 25 Aug 2025 07:17:08 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 02:17:06 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 02:17:05 -0500
Received: from xhdharshj40x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Mon, 25 Aug 2025 02:17:02 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>, <smueller@chronox.de>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH V6 0/3] crypto: Add Versal TRNG driver
Date: Mon, 25 Aug 2025 12:46:57 +0530
Message-ID: <20250825071700.819759-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE5:EE_|DS2PR12MB9711:EE_
X-MS-Office365-Filtering-Correlation-Id: 18918965-40e3-4ce9-d66c-08dde3a7670a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wuT2/EA3z50h2BDkf3mn3T1CMSUIiFB/BRc4PeqCxs3NG3tNS/PHsG2Guw8w?=
 =?us-ascii?Q?X6JJJcZhiGW+ohyKD+4C/RrTkH6BUPnxicmqNyvfGr0Rnj+xaeWVGloyK0iw?=
 =?us-ascii?Q?IDaDKQy7+S1Dozho1rB9C293hocVCko7OoIGqP6t6Xb3MjlrwShNAO75TAQ+?=
 =?us-ascii?Q?lmH01efAVu90yRQRoYHcfK8cWiN7BnnWBze2aUANLQTfkb5oJ5jacNu1qZKQ?=
 =?us-ascii?Q?95djRTukY9HCVW+RXOeH/EtHIsEgYOgZICBwJyl+iPsAiUJR/bRu5hWW2gHY?=
 =?us-ascii?Q?Ri+eC7ZcrsDCOf4u9nrzmG3WtDt9h2VJki3BVXmDQYCLihcFTKG/bkjcQMyr?=
 =?us-ascii?Q?e/y/h6sAjdiQrLMHR6uW6o5XRj+630ESwWMjbPuc6xuCEO1trDjgTPn63+0M?=
 =?us-ascii?Q?QLSblcfjI6uKIN5Y1qRLL/o6Wpnw8SYJ0642L1/lrlS5maNcY98mY++6JUZX?=
 =?us-ascii?Q?byGNLuwXHd1jRfo9z5wG3mzZYVvw3REwH6Shj5MtBGtCZOAG+uf2hk5EuDRd?=
 =?us-ascii?Q?RwBD56Pso8Bu+RsaZ/sb03P7O7OV3wUX55vJviG8OAeaRnf4wpP/j0iRIP+Q?=
 =?us-ascii?Q?hrhxf89xpb0zTGVGxG+YN1ysu2gxXerS5XgKT8VYfHSdUYYho4qKJIo3pOE1?=
 =?us-ascii?Q?x2AAseqkQ9Iu+bOw1fMiRpxso6UAMaSvgcgbo8rvaBuEqZVVrLbxXG6RQ3lJ?=
 =?us-ascii?Q?siTZGuchUGIn3XE2O4rG7mNh6+r61RGCDkyyDZec7iIzx1kxygENx8nVGxdQ?=
 =?us-ascii?Q?ts+y4exSC4ZWbu8x7o/6ds7Mq4l+jSGAgSXrRjAVcx3MS7OmsDv1SbIWxcyq?=
 =?us-ascii?Q?tGmEKWxacHNZnzb1SWsb5EE6dHG0NRHMb2G4Wkjo6beFpSFyxmHhnDyNWSGS?=
 =?us-ascii?Q?uxOp3JwBWBvdgGb6tUY3yxCpPZua6qMzWwwbVgSenO8C7MS6aMtojJw7COV4?=
 =?us-ascii?Q?5rsyA1xRbFdAu/gCz52vedtlxmKlt5z+Y2uRaAzzfo3ieCgdDI/oGC8IU6M9?=
 =?us-ascii?Q?ci6CBF0lPP5So8SFolPjGxawlt8Ofnlha/MS1spdiiw6M2l54OLiDkMMg2v0?=
 =?us-ascii?Q?oSMIzUCRtRaDSFmd9NaFzZFMidEGNkmdCi/IjE2nC7KfrZ/zQy5mmX/cwGUQ?=
 =?us-ascii?Q?VMFX71xS5cr9qe1Fm3olCtDmkBR8dMmTV7rNd/KxVv12pESvQQxG0Y9ngqI/?=
 =?us-ascii?Q?PcqRhiw9vaE5tW7la0iJWEJ8Wb62c8F8905hKkJOlMHDWIVJke1BGaEfM5+z?=
 =?us-ascii?Q?czmgT0jidMBUgualnBUm0w0Erp5G0SXVgm5N/lKiBPCl8Bs+dsidMPzzuMls?=
 =?us-ascii?Q?aAAqzMFDeObmQ327ApSf41Jf4gUwxm11VGBFWg1qIQ4WirEPBXpB+0ADwVCD?=
 =?us-ascii?Q?gyLEQGMhzwpxeRHP0aOvC01Lw2u+YbpCbvxkqLVtBpg0NpaD55r/MLMtwYGi?=
 =?us-ascii?Q?jSGzT1MusGZD+6WqEV4bIn7qhDGjb7IhzXL7kR+HKWtQpUzecVVfiDVtf4Bh?=
 =?us-ascii?Q?3z6/0dteudcuCZQ98ntr25RaKERG23ZPuAoWZjeOFxQNfz9H1ZJhBJ+NJg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 07:17:08.3621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18918965-40e3-4ce9-d66c-08dde3a7670a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9711

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
- Direct include header file in df_sp80090a.c
- Add internal/drbg.h

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
 crypto/df_sp80090a.c                          | 247 ++++++++++
 crypto/drbg.c                                 | 244 +---------
 drivers/crypto/Kconfig                        |  13 +
 drivers/crypto/xilinx/Makefile                |   1 +
 drivers/crypto/xilinx/xilinx-trng.c           | 435 ++++++++++++++++++
 include/crypto/df_sp80090a.h                  |  27 ++
 include/crypto/drbg.h                         |  25 +-
 include/crypto/internal/drbg.h                |  54 +++
 12 files changed, 833 insertions(+), 265 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
 create mode 100644 crypto/df_sp80090a.c
 create mode 100644 drivers/crypto/xilinx/xilinx-trng.c
 create mode 100644 include/crypto/df_sp80090a.h
 create mode 100644 include/crypto/internal/drbg.h

-- 
2.34.1

