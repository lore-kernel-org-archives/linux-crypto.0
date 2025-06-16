Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B555383;
	Mon, 16 Jun 2025 21:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750110663; cv=fail; b=njkxtaJ1z7CuocN6uLpsXZAd8cQPDa2OKreXm3SJN36JGWSS7EdaAy3Vh+tCuZXkve0+2eJMVRGHidhR1ly2hNyDmDorKFzzgIabfd7fuordkfI4/8laUDf4he2YFvLx6LEhM88Ys+XosmCmUwHnSxSbHG2DluDZtsolXj8N0mY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750110663; c=relaxed/simple;
	bh=he3OyxiBjC3Vn0gi2AVj3z8c9PfQerR07/CirYU5jM0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=R1cPAcI56ZCDk8tK9fZlsaIZi/NlzOCRtBkTtBvRQaXTsKxl14JS14ybYcVVMh9kp7CGYvuJr8um2P2UVl9iNrsOxX6KS1Ph2k0xblevmFdQdyt9zgnb/owP4S8ZuPPsu4mYm+UXbQX+Rit7Jc1shH/OdEYl8qGQB1BkpmFqdwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LbS+ePmw; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LbS+ePmw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=annZ9QHYI7yWLY4qRdLmkWwoZQC10C2Llx/CUorGZmmYJ42MQESOQEPlbJ0AE9gDMgMs2QQ/18hVJFE5i1GG0mPkxvoHSAzoUOzdvNg9E+kUro7Pis1bGAo1LfselbMLYSWVA6Uz/N62LIJ3ErApVu+4owrMjfoNObWy45okuGVxy9kSfiBilpNQJZwE0VtHugnf4S2F4hROx5mH4T8E4HZPqyP1d4Ohcq8wOTNQzAoGy8BY+yui6rtZuQwfz4xrSwHIu32Bo8OKrQNHKcCjC1V8aYvrUR6RR9aRLvJdP59UY01CHa1G5mL+CZKGWBANVsyIkLohXQ+Ju46erRSu2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xJLt1qnW3D8r2S5TxL5ehkEX6NMByn66ChfX/Jl0vQ=;
 b=JIjB75VIDBh49ngHThrze7sKmGAfL1oOBIB99DCeRa5eg7TFUUCxsLNJXRrhGyz1C13YsPIMVf1hMZwp7jQYSIowD3pJoEOnja51RqTevEEMfWF0WOcRL8OWrnE0hXk/3fJd07WSpCPECR9AlkL69I3GqSlnWuGJJl7BXeZxtGgP4Pe5O+vJRcPLJXCvjuSWjziKXz00h11NzPBhHj/X6b6huFk/LOb65PEmmwc2lzYZH+0aLZsmyJMVGvGfYYOwAQKuwAeO14OrkrIKvCdzAx9sau8wPSzK+JBsRkA0J1gDoKffin/topQeqBuCkWETexZpGWBjBKHD9AOk8ipLSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xJLt1qnW3D8r2S5TxL5ehkEX6NMByn66ChfX/Jl0vQ=;
 b=LbS+ePmwS1SxM0Uo623p5gBIAuCP3etoNiRwa/PIbpcK9Fjd2z+TSxLdYCFqLQiM5zUvBEtERqGWnMUBV0pEFASzDQ2SXwr2KBOBdcyeKiAt+fh7DDnxy/IHpgdr0Wbu8n8vaBvhlp+E6cbV3ZzMvLIk+OsHyPazgwJfttJRxak=
Received: from MW4PR03CA0192.namprd03.prod.outlook.com (2603:10b6:303:b8::17)
 by BL4PR12MB9721.namprd12.prod.outlook.com (2603:10b6:208:4ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 16 Jun
 2025 21:50:55 +0000
Received: from SJ5PEPF00000208.namprd05.prod.outlook.com
 (2603:10b6:303:b8:cafe::34) by MW4PR03CA0192.outlook.office365.com
 (2603:10b6:303:b8::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Mon,
 16 Jun 2025 21:50:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000208.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Mon, 16 Jun 2025 21:50:54 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Jun
 2025 16:50:53 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <aik@amd.com>, <dionnaglaze@google.com>, <michael.roth@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: [RESEND PATCH v3] crypto: ccp: Fix SNP panic notifier unregistration
Date: Mon, 16 Jun 2025 21:50:27 +0000
Message-ID: <20250616215027.68768-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000208:EE_|BL4PR12MB9721:EE_
X-MS-Office365-Filtering-Correlation-Id: 974e4f8d-96b1-4126-745b-08ddad1fdeba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TxZZPdljW7cAaR7z/Xj0UI7qSzLZc8Z9Heww3zIcyAGDMvV5eOyFGtoIP6nx?=
 =?us-ascii?Q?PQZ16dIYJmfI7pGFMYhQjVJPsto3TY5hvaHsG5TxIQSXOl/+rF1fh3sM2iiR?=
 =?us-ascii?Q?Uf7YcwLtmx/eRAugCQui5DQow9BmssltzJoFlpEfdS+cz28zz3YOv53HGQsR?=
 =?us-ascii?Q?dG7Xum5NZg28mSA8f26VmR1HNoedKKOy+2SvCRlCb/JvMZIsSoPC0yTv4RPC?=
 =?us-ascii?Q?hopvhuociNyYDRZXB6DcfR+b7w7PGSYt+68wIb5dEDXdrRFsjnCZ8zktHkaN?=
 =?us-ascii?Q?7EvYkIkzrSu0hfQT8dzW7hBOt3XZhmeg6rI1Le+MDH0wB80eDebnHOxNA/YC?=
 =?us-ascii?Q?aGmh2xfYowXvrYaG+EsJUNY+6KOg6SgNyVUAr1aeCwV+TupkxIuqMyD/18oo?=
 =?us-ascii?Q?fV3BZsFcgxtFODOtZXX7xlnK5eXH4RZgGI4jqyG/S7DWVD+Er0KluziQ58bF?=
 =?us-ascii?Q?LRjB2SaVVGOiFu9CVww7ng4wnyx7aEuqBGQsHMiaTNuqBYxtD6REDd0KLogz?=
 =?us-ascii?Q?42k2Ll0EuPF7XphyV24ydY1m6tWXtwhkVcD6OeNhM/os/1k3/gmV/bUOJlQV?=
 =?us-ascii?Q?zJCxVMan3rzahGtV5/IAdmlKcdLAa+uL/2gDv7KqPp8iWtACx+Q0inTMm//b?=
 =?us-ascii?Q?McawPxYjULQkn/k6DP3/GXw/OVmgIdIRqn4YQTLCIb8XkeWQXCPou7KUxBmS?=
 =?us-ascii?Q?usT41AO4BPg+Kru2hxqg0viOf3JqlTayZug/0KDyMWgF+/dJjtxaFDORxHo+?=
 =?us-ascii?Q?4mAvvLmBOsDNShZEmWb1JETLRVBv2crQnsYwIl+M3unboS8dSjqr2MjxiDcm?=
 =?us-ascii?Q?2ZA67FYixzzLSqhxbD0bG7y0peONhlCTLLj2JJNhlRQUZV7HLO9vlJqhd0k7?=
 =?us-ascii?Q?WvFa4cLmylDZecFf6D95M4Eq1olybLphiZ/vxPFvbgAXu2Q8tXsGceZkhpC/?=
 =?us-ascii?Q?1H+XyUp1YEeLmVfD8oMxpgl/n3FROF6SE9pkl4VvSSJnGhBLPco1pOAsn3B1?=
 =?us-ascii?Q?GtWbfLbe3hVf3TBRwZLD6WS/4bGgJSuidKxA+3MtTwLXMF8vaWOWQJBPFs7U?=
 =?us-ascii?Q?m/4fSxFdQ6YR4qn3kHvre2SouMcziSwCn8BvN5WkIX0FW6iqhBNxUMzEzIXg?=
 =?us-ascii?Q?wz+gYQ8Dshsg+xkliVS4KOTnow8VJwSUWn80iLaOaYzW7pgDr6OyHIhXIKEw?=
 =?us-ascii?Q?k7RIKhcNDWvoKZnzwMNMprbGjMRm78MYvMQhCcGTTaWqG3qVoScyn9sqYKVD?=
 =?us-ascii?Q?iel5Oj+yrsakYEjqEGHXXbS82qv/BSCieW6rtdX9uL0X8wgl2CK994aRiSuX?=
 =?us-ascii?Q?qcZokOxHeiXKktTSXoFxDwZfU2cYsWA4KB6dhqUGuhLPcfK+D6ECEIU5s1Rb?=
 =?us-ascii?Q?OgAoJSTgt10hMEhRjk/YnLsvpCEXzz/sSY5rnlR+XkBGTOWEvXxoBklgsMsw?=
 =?us-ascii?Q?p/q2+V1seGkl1XdHcgmW/bZraE8rq3ouas1lf4+2Pa5LXWtcDiUaiLTAO4OJ?=
 =?us-ascii?Q?rW1dU/jh4yiueRMXylCpR7xbXnqwq4dRaOex?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 21:50:54.7381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 974e4f8d-96b1-4126-745b-08ddad1fdeba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9721

From: Ashish Kalra <ashish.kalra@amd.com>

Panic notifiers are invoked with RCU read lock held and when the
SNP panic notifier tries to unregister itself from the panic
notifier callback itself it causes a deadlock as notifier
unregistration does RCU synchronization.

Code flow for SNP panic notifier:
snp_shutdown_on_panic() ->
__sev_firmware_shutdown() ->
__sev_snp_shutdown_locked() ->
atomic_notifier_chain_unregister(.., &snp_panic_notifier)

Fix SNP panic notifier to unregister itself during SNP shutdown
only if panic is not in progress.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Fixes: 19860c3274fb ("crypto: ccp - Register SNP panic notifier only if SNP is enabled")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8fb94c5f006a..17edc6bf5622 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1787,8 +1787,14 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
+	/*
+	 * __sev_snp_shutdown_locked() deadlocks when it tries to unregister
+	 * itself during panic as the panic notifier is called with RCU read
+	 * lock held and notifier unregistration does RCU synchronization.
+	 */
+	if (!panic)
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+						 &snp_panic_notifier);
 
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
-- 
2.34.1

