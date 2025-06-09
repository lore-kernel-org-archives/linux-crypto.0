Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB37233F6;
	Mon,  9 Jun 2025 04:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749444688; cv=fail; b=nMmNCGtPY9Enj3knaTg22m3SzluJOLiCVROzM9eenFnilreK4o6FM3F9gf8AqAZXTR0ois98kcIU+340zw5sH5J60IrTJH2uuI9supnNfJXhGZSUCHe4KMrCVWvdSmi08zgD6v/Bk1GtoUj4OSzP6lCSdB4vpES/DIW3wZ1FGGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749444688; c=relaxed/simple;
	bh=Z1Krg7raPQ33DIxLQ2FQhuHuk0lFjsSUoEobkYUtRqA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HoDjQDag/JQxmEesdhgXMMmSM3fmw0cDHkGg3urAZmOnDSojkpG6fjvH7toZua8H9pT58aZrs487kaci/GID5UxSCazvQGvq/u0bsrLw3RD/TlqFZJ9Yn2zOfNmg7PV3vZLNivuV7piYXf/G3v2M/IQ9//3NXUrbxp9F0KVdODk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jv9lY8pW; arc=fail smtp.client-ip=40.107.220.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jv9lY8pW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOmsW2JfmU3Ijo0NOFT10QnTSzwG5UtvoMHvkWmRYZehtAAQnpszbzbFpFrYNyqNIaDCN4k62YKojX8mbQgyc+RgQ9r+pOmdCeVSRNSCn624OmRGpa0RivmlMmKwId7kFR2z4s+3AHmGiSICuCCVMPW/757KxdIiSvBfa+BaFHRehAnDR7EixYv9bbdVYdAs/4gAAX3OnyIZaj1amdiAnC/ncBqUaYMZCOzWLbOHr7E5Gs/y3tA+pJqcv5WEMR36fYx6jueFl+F1MM1XxbdrPoiQt7771wy7PWyklmhKYqX/Fxa1TxPaEVjOVA057nQXrGij5NRFpNB1Clabv0otDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bE3B9hFCdA0G/97F+u267Ch+9/Td2enP9ufIwBTj5PY=;
 b=XTiYGfvWky7SCcjdSzKIYwf7JE5qDaZbRhEFZLdoogiJv361ZsA1Udq4pyFrfiYvnbcQjYhL9IHdUGVOHS3tD132tNFe8SldQaPpwhrXwEt0i1j7lCsQT+RkHkL50pgZcd/6aTOxQDglWlvdKVAfCR7mulENXWOOUdn+pwwYFoHE68d2OOkb2v7VXvi5nc5XD1CRQBL4vfn+qOwoUG3z+mHf5z8bpWwlLX9UtEM0aDpdfsT4EZAxEomepcUD/27PqAbvfYKDDDoU/3iJxcvSChJsIq7azJ4OHeqJwp/aiVecEJxNbgDP85XMxBc/HBJfolqNp8yCGXSlS78B5l2ndQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bE3B9hFCdA0G/97F+u267Ch+9/Td2enP9ufIwBTj5PY=;
 b=Jv9lY8pW9rySfjgkLsHgHk1qpuBvr18RmNvrJPdh2/ckMYXNqdIrIxqqKUt/xvZAaxXfe9wQacaEpgLrd3iYBFKutfe++P63t+E5vabKsHgiq8z5y0xd4mUaYmjzxk0LU1IBiFme4JwCbWjaBTdKjs2lF/QzO+o53tVo9ExUEug=
Received: from CY5PR16CA0001.namprd16.prod.outlook.com (2603:10b6:930:10::31)
 by DS0PR12MB7851.namprd12.prod.outlook.com (2603:10b6:8:14a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.40; Mon, 9 Jun
 2025 04:51:23 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:930:10:cafe::1b) by CY5PR16CA0001.outlook.office365.com
 (2603:10b6:930:10::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.21 via Frontend Transport; Mon,
 9 Jun 2025 04:51:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 04:51:22 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:21 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 8 Jun 2025 23:51:19 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 0/6] Add Versal TRNG driver
Date: Mon, 9 Jun 2025 10:21:04 +0530
Message-ID: <20250609045110.1786634-1-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB03.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|DS0PR12MB7851:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e636b09-ad40-4adc-738f-08dda7114851
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RUVgthsHe/SP0g0Xo0NK5SrW1GiEuwimVjWNBo7JQcfW2ahHDbukxzVCgsNE?=
 =?us-ascii?Q?WhpJw2GpRqwJYgHXTmKMLIofM05upaoOL46F61IU5vzneqHKdpnA13fDRJiF?=
 =?us-ascii?Q?cEEyFi7Er8PNdmxf4iHcVR1J7DHMBd7z2aORMEDIiQgLxy9OVg6+3TTQzyhU?=
 =?us-ascii?Q?N1RuFVb8i1POSfIk9b94RTwM0feOU96y8idKCXnLvkTYfz7zvJ42J/nZo15s?=
 =?us-ascii?Q?b4ges+Lnd8f/1V3IBkoKbmPBgy9pna+Upig1Shq5OIcw//W5VuS64QzaoE7h?=
 =?us-ascii?Q?b/7xAUj45azvX9F2NYbBtOFJ8HAYS5FumSpIYyXLGyRBuC6hmS+0l9+tZhIS?=
 =?us-ascii?Q?elAjmo3oepj5vMfUHcJ3KhDF6SGPHxaXnUpW6FSYLgq8CPzUndwgUkBW3HWJ?=
 =?us-ascii?Q?dJr5Di3m03OA4bOQWhThMye+KlkS/9rITrNN1PbiM1CyWSwD7fPB0tHmrJ/y?=
 =?us-ascii?Q?7OzVT2Pb2xG+MR7G0Ca2E1apbVtX09WGVNFcBYhuAE0jNDjT0mznIWQOZgEL?=
 =?us-ascii?Q?RVRqNd0R9wIXrAcqnDPQNKarBbo/gK0BLlXiPudZ4Je7KUt3v8BTpvqpdLif?=
 =?us-ascii?Q?eHfwjPMfSiB308RHCziN0f38rB7OIdXP2x+oNNvUcpNtfKaDAEeQQVC1qBHs?=
 =?us-ascii?Q?PZhLA4iywwImNLw2bpAN4FF47XU4d6WHy1aa6cEiRfeiz8v3XXbkUpwcgTMv?=
 =?us-ascii?Q?pb86+Eqqg+Xy9J4x4j7BzMKiyoAddd+ow8hwPO8t2AdvfnEbiMfZGyNliE87?=
 =?us-ascii?Q?w2LnNg5/RGM+99vviPbQKRAUA6VaO+5UfC/2RPIpUJGPpP2+XGx32pYm97u7?=
 =?us-ascii?Q?OuDUb9iSKsfCH6hC6sM6tzA1c9dN/AM/ju2p3M3SQNUkpWNJQ780Xx1ULLxP?=
 =?us-ascii?Q?jG9nKkFWMc9ooHD/8bmh797zEOrXn6a1NT6/oZYnOa12dMamQG+EWNVEHXpW?=
 =?us-ascii?Q?E6hNqVCUHMnC+FfMUEpMIzPnaaqXYg8JOY+qyouHJsTVfgIW22lAQMqL6FYf?=
 =?us-ascii?Q?NwOUZ6hkbQFriDx9+y6thEplzYKaNUjzQp20MFcfyjNgivHet8a2JyMYn2Nj?=
 =?us-ascii?Q?fkcI9NlBn5KtJrECCJPs6+irNLwuGn9VFGuR1dGr5ttYpzaC3FNJZu1AK+zM?=
 =?us-ascii?Q?GdF0rg75QVdxPgIkfW2Mj13LWOiwq5GdzdHSPAbngYixRPqS9Ds7KehoEegN?=
 =?us-ascii?Q?CtHIqahITHJquDAQusZEaFxJVlDO45psuxMI8OwXp1jhRjWvpBdkt5KN3pOR?=
 =?us-ascii?Q?TthTGIpE54EpREbSVIh8uPhsJ9pwAHOOmtkADyjORn1EzOZkexLe5WN8GMp3?=
 =?us-ascii?Q?J0K9k97jYgc6kkKDRIiwTIf1d6ENnWZ5+70uiPyaddcUpZ+4lLoHlqknDjoi?=
 =?us-ascii?Q?5Mm0Oa83qdtldHs9NLnQ4jkCWqHwigvdqLJqs9gDS/tyY+8OmL0IzzxGjvlu?=
 =?us-ascii?Q?Hvesmqa/Pu4PsSE0tg1axwtPGZlTLakWub65tj2/t61SgkpgiH16MEIol6QZ?=
 =?us-ascii?Q?4sRA4vq5WwG3QjmKH2Iteqp3ZiKFne7ZiHDi?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 04:51:22.5044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e636b09-ad40-4adc-738f-08dda7114851
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7851

Versal TRNG module consist of array of Ring Oscillators as entropy source
and a deterministic CTR_DRBG random bit generator (DRBG). Add driver to
registers entropy source to hwrng and CTR_DRBG generator to crypto subsystem.
Derivation Function (DF) defined in NIST SP-800-90A for CTR_DRBG is not
supported in current TRNG IP. For DF processing, Update drbg module to
export CTR_DRBG derivation function.

Changes in v2
- Fixed signoff chain
- Added 3 patch to fix Kernel test robot bugs

Harsh Jain (5):
  crypto: xilinx: Add TRNG driver for Versal
  crypto: drbg: Export CTR DRBG DF functions
  crypto: xilinx: Select dependant Kconfig option for CRYPTO_DRBG_CTR
  crypto: xilinx: Fix missing goto in probe
  crypto: xilinx: Use min_t macro to compare value

Mounika Botcha (1):
  dt-bindings: crypto: Add node for True Random Number Generator

 .../bindings/crypto/xlnx,versal-trng.yaml     |  36 ++
 MAINTAINERS                                   |   6 +
 crypto/drbg.c                                 | 108 +++--
 drivers/crypto/Kconfig                        |  14 +
 drivers/crypto/xilinx/Makefile                |   1 +
 drivers/crypto/xilinx/xilinx-trng.c           | 434 ++++++++++++++++++
 include/crypto/drbg.h                         |  15 +
 7 files changed, 563 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
 create mode 100644 drivers/crypto/xilinx/xilinx-trng.c

-- 
2.34.1

