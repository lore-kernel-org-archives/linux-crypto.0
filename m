Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012048.outbound.protection.outlook.com [52.101.43.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF913D9686;
	Tue, 26 May 2026 09:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779788693; cv=fail; b=B5dvNbzpsuzX5UIzv/yQyiq/6I2tYaaLQEYX2CsBxkXYm0xnkZCbhP5IA5ki90zn7J0ulFB94sDxec97pnPtJTzU65ZOzRL0OhzEfFZuOHD9d748KDQ5shzcEFY7JENBHWvJvOh/xakLUpxDNVVzfuJ0SMoSbxdwLoixgnYfJC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779788693; c=relaxed/simple;
	bh=rF4HJBM3uFsnRK0Cpq2YSTBFXXbsuaaf2PipKmvF/ig=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UEvOcrSDTHzHj1klKFkdLsMqA2n3vNrRUUR1ZgPpwV9o11TB3huGAh775dUf2WfJT3erdf2Za58t2traTDXggaCjbteALtudVUjWHu7Bj12C+cPQJ2dIyiBlPkK0hjiDNU4rlYiSqwmYI95cN0nnlfEmTOiqO+1gqr0b8IhW6WE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=pkudfjsL; arc=fail smtp.client-ip=52.101.43.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="pkudfjsL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Up+ML+/Ufr14eSqyG/3vKEvgbCamyKfG7fuE1Llzk4++tvqkGXeqvZBhrVzbGXIGeqYKw0dVnhMn1id0mNLauvOTJ64yd0lEIz32dFBxaNfLdx1m7Fdv68nqiAKgw0vFKz5bVYRZbk9Rfu6ypi4Olq9oodeYkNG3LxXCsvOT9yRYBeC18//1h+c/VjVvrXKU78KmCi9YdITTrmDDuWG5wZLXzRn8CZKIixTyP6ky7Pu1rZ7Q4DI5jWg8Qo+DNQzWBkNvrB9G3pr7RE1MX1Mf3lSzc4MnBF5W/h49XVXn33FnNmCCfyemOI9zSh69YOD80vyGmoNoiNgfWbaNJS5RxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vGPFkwSEMfiSQ+hflfiN6LKVu4gZKO5Tox3sY5bEvU=;
 b=sYEPWBva5r3nEopif8Vhs8C3uCUD7o7hbTg/TdRte0CeMzurp+3NzP2gEJiXyNIvPDjvqFjtbZxtCnNAaO9BnwwqatJJ4k/6teQxETwD/DUeeUoGjywJWFU97PD4gBmeEwovceB/bNMInPSEM9Kd5kggL+ytcLbeAq8CTzv92uPFlLhyAVPVocCAkQ2mrTs9w69nugvj+Y3cPMfdaIQJTJAvbxl1kAkUchhypubwVgRdC8/7r2aaZHG9JtGgbzEr0l8MMGEjIZ+uTjA1dfaTNvqgatA11iUgJRBBwMpCRRFtIu4SVrVKrpwqqi8XHnZITE5LL0dVfrN9e0RzFtooSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vGPFkwSEMfiSQ+hflfiN6LKVu4gZKO5Tox3sY5bEvU=;
 b=pkudfjsLDcM4g8WqB4dM4Cmr3kPsRv3FV5ChIanx7WBJ+dleSk1Oh47rkoL/1MAPA5KChfPlokrprCLzQlOE6V+GW+aR5ef/oJpTWvo2lqqH/2c0g+N/1c3c4nJ6/kswwIYwV7TGX11Cmui1aS+MCcmcOZvNCfvHkfkwIztwW2U=
Received: from CY5PR13CA0022.namprd13.prod.outlook.com (2603:10b6:930::32) by
 IA4PR10MB8375.namprd10.prod.outlook.com (2603:10b6:208:560::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Tue, 26 May
 2026 09:44:49 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:930:0:cafe::15) by CY5PR13CA0022.outlook.office365.com
 (2603:10b6:930::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.12 via Frontend Transport; Tue, 26
 May 2026 09:44:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.71.7 via Frontend Transport; Tue, 26 May 2026 09:44:47 +0000
Received: from DFLE203.ent.ti.com (10.64.6.61) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 26 May
 2026 04:44:46 -0500
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 26 May
 2026 04:44:46 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37 via Frontend
 Transport; Tue, 26 May 2026 04:44:46 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 64Q9iiB6629773;
	Tue, 26 May 2026 04:44:45 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
	"Kamlesh Gurudasani" <kamlesh@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>,
	"Kavitha Malarvizhi" <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	"Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v4 0/3] Add support for hashing algorithms in TI DTHE V2
Date: Tue, 26 May 2026 15:13:50 +0530
Message-ID: <20260526094355.555712-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|IA4PR10MB8375:EE_
X-MS-Office365-Filtering-Correlation-Id: e66209ca-a249-4ce7-b8fd-08debb0b6c68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|1800799024|18002099003|3023799007|56012099003;
X-Microsoft-Antispam-Message-Info:
	bVUrq3Z2dJ1e42rbXSx4o9S4uuoX9VnVL3guDAE+G11vJHKUI2WuWF+4ZZh8OU8rpdGvN0ZfZ2bw36E5u5rCsPgxUp539LFe9tsPwUFp6/uAxjvDGYcs566yh8Z5ubcVaO+pxOcehm3H+ZL5nXlUMjwB4uLZScd2AgqmoTaMEmHK3Rt2ZlkupQ9zK4frMLvTRhRxnbkC8JEr7lAUNUD/QF+GSU4EZrKGfFAFtHA3MAYnDWhmomWJqRog1JJftwkUrRddH3LJ2LaWfPt2xdKlp5Xop0JDqhvldY7Lt9fYByte5Bjuajrdv3tjp+GBYDFm2ETX93ndCvAMPS+2kLWhPnqIjUZslYD6hHKWCAEfnqTTxcBYDszjakCROuI0A9598KCxxSDalWyWGQm1U3fNmSly2ON56liwUgiNj4YWZYyXURxC3emb9ifH2kdKXcMXQRZrgQs7U/mi4SpFS7l+kpDOOralIyv7S0Vb2c6WpZ9V9yfMyb6PK7MS/stwfiihzzjpBtxRZEuhCZgP/WS7hURj6GJKnh870oSbPIfpvAfFSGUCMHT8btE2eloHZcFD/Ux5UyrDNeuBs6j/iLJZVtkWY0hwGvKDBLJH5F2MEED+xWHJD3xcFQvEPCG2rnfA2qrkTmLh7sySuRdKRlFJ8ldoEOYTC3Fq3n4XquKiXjx0VMD0Upyq7Ru+cuIEzBvQFmPOcU+g4AOOSAinLEFGcpBAYi4LUwBH6IyUJ7dkzUc=
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(1800799024)(18002099003)(3023799007)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	06UCyLy/kBTj1tjBGsCmSuTDSDvk0uKFPMoD30hP2lLK61XmT7i3gK7D6LWEFz5GqtTz8hRcqjJMAZwyI10nND5IpDIBucjanlmogSVJx04Gyjf5TOTlqZyKNuJySJhDh0+aZhMX0uXZRj5SWXndpfng/0PVqJDQcX7LuwFxPwVSq7Cb+sYQ87DB6V7CVai/fGCw9gInvUufA5RLVlr7IEClfofupRYZ5Zu+P0LeIXXT6NZIbEBWaXXPw17UNbBI1TyUUpIpra2Atjdtyj/cL3oodnwDENfZh6wEGJHjRBZgEqEjNa4pX0l8YT3IRz1TW6uWFe5VZBIwkGDjjNI82zOZg34dTIh5I3r9OsW/yMQ11yvS4+n/aTohDQxScAqCAWznx58i3DyVqQ3viJOlisRzPNAKIh9nvtVLc01h4nlM/btDNkMHTsxZVX0WHbUv
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2026 09:44:47.0156
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e66209ca-a249-4ce7-b8fd-08debb0b6c68
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8375

DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
features of DTHEv2 were detailed in [1]. Additional hardware details
available in SoC TRM [2]. DTHEv2 includes, among its various
sub-components, a hashing engine which is compliant with various IETF
and NIST standards, including FIPS 180-3 and FIPS PUB 198.

This patch series adds support for the hashing algorithms
SHA224/256/384/512 and MD5 as well as their HMAC counnterparts for the
hashing engine of Texas Instruments DTHE V2 crypto driver.

The driver is tested using full kernel crypto selftests
(CRYPTO_SELFTESTS_FULL) which all pass successfully [3].

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: DTHEv2 kernel self-tests logs
Link: https://gist.github.com/Pratham-T/fd15b8e0ee815bcb420a60d451a0cf18

Changelog:
v4:
 - Export initial state when phash_available = 0
v3:
 - Check for error in registration individualy for hash and aes driver
   algos.
 - Fixed comment style in dthev2-common.c
v2:
 - Completely revamped the driver to use the new CRYPTO_AHASH_BLOCK_ONLY
   framework for handling partial blocks and crypto_engine for queueing.
 - Added HMAC as well.

Link to previous versions:
v3: https://lore.kernel.org/all/20260226131103.3560884-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20260121132408.743777-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250218104943.2304730-1-t-pratham@ti.com/
---

T Pratham (3):
  crypto: ti - Add support for SHA224/256/384/512 in DTHEv2 driver
  crypto: ti - Add support for MD5 in DTHEv2 Hashing Engine driver
  crypto: ti - Add support for HMAC in DTHEv2 Hashing Engine driver

 drivers/crypto/ti/Kconfig         |    4 +
 drivers/crypto/ti/Makefile        |    2 +-
 drivers/crypto/ti/dthev2-aes.c    |    6 +-
 drivers/crypto/ti/dthev2-common.c |   43 +-
 drivers/crypto/ti/dthev2-common.h |   58 +-
 drivers/crypto/ti/dthev2-hash.c   | 1022 +++++++++++++++++++++++++++++
 6 files changed, 1117 insertions(+), 18 deletions(-)
 create mode 100644 drivers/crypto/ti/dthev2-hash.c

-- 
2.34.1

