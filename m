Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010051.outbound.protection.outlook.com [52.101.201.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2F83ACEEB;
	Mon, 15 Jun 2026 19:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781552969; cv=fail; b=WwDBJWhTaFfPOOltVqRvKnIt76+WkTxi9Zvq04C4d711utjePzWAZ7IA+hiEdCbWj0l0ickVi71gbR1JVzF3etTKHOFN6zAcDi0mcdUIUrzk96B/OuKmh8ar2r5mH4wWcLldJM3AhK9rhBRtAvqedKTilPkCQWndL73V+sf4IqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781552969; c=relaxed/simple;
	bh=JPZyxMHq1d8PCN0ibGL2oUOc/6papOU+gWtHSx8FkSE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LkiW3ydGyeB+0JQpD3LvJinMpr1AnTtDpZlN1AwIcKLHeQe2xNeuYb5HyURk7jTNtuTOdEG0tCrogrgklGW0OYVH94j6xO3IM1FMLFF205qyuGSx0hOGit/7D0byCv9qytGsADHYGEXtjl7JQoutTcUPxuoUvqmEmaLb5FAagxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JDt4nELp; arc=fail smtp.client-ip=52.101.201.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JDt4nELp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lB3WR2K4Ka03CZ3C8HIHSz2c6qYgDSKjB2znJRzgkujoUy084pgD9nsLLMaGWhhaIjid+aEic78Fd38fKHnsrhSYVpykAxNyQULKAJg9EWDZN13plrP8IQnVXTpW2JHEFt6YDbSWNvZQwkkTLTWzJWn00S9G/cy21uDcr13b/P+qdBJ1fSNU3facz18fNDAfu9zwdd8C8omos5/aKTvqF7DxtY7BhVhy6J6pxlUFhgsQ9iheLsJLD7cfqG7LJMHXmTGmTcLv8NTlpitLu/C6sGt5cp4PfZ7BxZcYSHENYlJaw7EOxKGO80j+KhgFCBze4W2QFa6sR9GTQ6DOsazm/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uccaA//lvOAJyKmGfLPoYFMBvCaYbK2hYLQHQXq5JIw=;
 b=aoBFB12RUSzoURikQQccQpnFrDAp4CDVerla1LQ4GCS0JpJYW2Yneu+6TjvsBtI3e09+iCgpP96/Ecjf1UcN1Hl1J4j9aTK9pelhk9eF6KYfUzFNXbr6yS4BYBHuQkoiGZLY4G8yoFA9RpxitE5Y/Q88gTbFxKfX9/4ff0AQv+emjF2Mz03Tgic6+Q0c8bflrGaPWtk8L3O4YyCYivb8tB9fQx+dL02pgIPKNItYmD/XN3dle27wPdefgk6kV2NosM4LqLTO/Cr5AOa4mHjvslNdcyEGg+DBcL73X5uTr7nq2EJpf8jswF9Qc7Y1Hef+u4nbL00CMeae7i5MPpA4ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uccaA//lvOAJyKmGfLPoYFMBvCaYbK2hYLQHQXq5JIw=;
 b=JDt4nELpfvsCOS3KlVCr/BjT25uAOJD4p7RwUuqWLUF9VRgxXYWgx5x0mk+Cew0BTuV7UCTN1+5Ao0BrITME4XTk2DrATVlDvF6lCfcm1uXlobfXKWlElzvasMl0g0XKllAIgqJFDHWM7SwALURQjXGU3DfPZj53dyMO+2eE3oM=
Received: from MN0PR05CA0021.namprd05.prod.outlook.com (2603:10b6:208:52c::16)
 by MW6PR12MB8866.namprd12.prod.outlook.com (2603:10b6:303:24c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 19:49:23 +0000
Received: from BL6PEPF00020E61.namprd04.prod.outlook.com
 (2603:10b6:208:52c:cafe::51) by MN0PR05CA0021.outlook.office365.com
 (2603:10b6:208:52c::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.11 via Frontend Transport; Mon,
 15 Jun 2026 19:49:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E61.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Mon, 15 Jun 2026 19:49:22 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 15 Jun
 2026 14:49:21 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <ackerleytng@google.com>, <jackyli@google.com>,
	<pgonda@google.com>, <rientjes@google.com>, <jacobhxu@google.com>,
	<xin@zytor.com>, <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is active
Date: Mon, 15 Jun 2026 19:49:10 +0000
Message-ID: <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781419998.git.ashish.kalra@amd.com>
References: <cover.1781419998.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E61:EE_|MW6PR12MB8866:EE_
X-MS-Office365-Filtering-Correlation-Id: 83f1f107-4e5b-4d4c-c071-08decb1732b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|376014|82310400026|23010399003|1800799024|56012099006|11063799006|22082099003|18002099003|3023799007|921020|6133799003;
X-Microsoft-Antispam-Message-Info:
	iD2kPmVgRpavpFRQLNfzhLIlcI8SxFCP41mUnEbCqOmQS/q/gnxcYM8vYZ8ayP6H6f2eOhPn8V1EpdEk8wo7UdTUVlnoD0JiNCerjOZ+Km71JeG0shCsHqd55pXnpQDRGrbyPajhNhfEJBTKRCXnx7pSqM1wFWzHOlEWcXk/Avn1mcpsVDAp0tfKcHeQ7k/fm2MBmxYyVCZPeVJucXoo6N4yF8D1/QJOg7sI7Bvq5WkgnyE7dvTa4LpeLhHvsN07zbAdhyLkuEXwe4CyFkSHU1VrXVasCjJ0sAZYQ7ccKI6ZmJw0Gw2o8tlT5CJssHUc0AzJP7rcUGAqBadtTJpUO2wZn7F31KTG329NLe4FmK+U011L4tsaFqfzXn3YWWlpS920tM4LZEKK827F2W85mk4WH0zYS2RrGrvZlMZ0voUVE29BdHGYzahe8WkrLjqZgZyJj3KerGogGiJFTtsBN57egLv0PZtnWGnBfjEA/O+wSjc0wOureR5pCIPn55ICeR8OS7zZM5IEhMBTSCFSS4sSIu7aAo2QUlQ3CHLMlNS1OhLjZwVKBGAZ/LgT231Sx1V1Q35sESYn2DyCBSCgMZgZ+V5kQ43iT6IDQcb9Rhpl5vRqGsNsZqF0Q+8+wkfxduk8meWiwqJ9MvKTo5kuLt1XcaERkriV2AXFcXpBRkb6Pa2j+eUoQ2LrEUZNgoeD+p+1/VbvyBC4P3YphDdvYN7EXiOCQjpLEfYb03zjytTzRCZzwQfX+Ag2NvKYygL5qL+hrhw11HCM1XNZggewPw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(376014)(82310400026)(23010399003)(1800799024)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007)(921020)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vuhGzXmXCb0WHe2R8viFfcxthz+ZYoPAlKnIbnA03R9DF6VaIpNV36LTOx1aq6kRQmBFGfHaKcuREvC8QFDy8LRG7YF9tM2VsoaDM+u6wI7imJt14h3qkqvcRmp/c6Wz2hwlLPufSF48RvtXdf6/j0OyzEE2uuA+g9H2k3lzIBCfFHoxXbcMbzTcYuw4b9J190qnA5RnhuGhA6o4A3JyolXcm6b+grYsePS9XTA/YQXde0C0uKHAoiFD6BuSDkvM5MM0Xy1xUIeGDh/YqMnK7MyOd3DRVo+zh+RaclrNIN1lIfGizEVOscRJvVQg1MkfytlYfeP66McTQLplT6mLk/UBbd0bCJaYENtFG3opvwFx/XB8waftnfGee7vHcjTMUCajDzdWyi1ZTGGxDJqLpsOplIZufOzSj+bUrefyumDKnTcxWYjjhSVTk0t14NuI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 19:49:22.7870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f1f107-4e5b-4d4c-c071-08decb1732b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8866

From: Ashish Kalra <ashish.kalra@amd.com>

The SEV firmware enumerates the CPUs at SNP initialization and is not
aware of the OS bringing CPUs online or offline afterwards, so OS CPU
hotplug can diverge from the firmware's expectations and break SNP.
Disable CPU hotplug while SNP is active.

SNP is fully torn down only on the SNP_SHUTDOWN_EX x86_snp_shutdown
path; the legacy path leaves SNP enabled in hardware while clearing
snp_initialized, so __sev_snp_init_locked() can run again.  Track the
disable with a flag so it is balanced by a matching enable rather than
stacked, and re-enable hotplug only on the x86_snp_shutdown path, after
snp_shutdown() has cleared the per-core RMPOPT_BASE MSRs with hotplug
still disabled.

This also keeps the CPU set stable for the asynchronous RMPOPT scan
added later in this series, and ensures cpus_read_lock() in the scan
is uncontended.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 217b6b19802e..c8c3c577463c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -106,6 +106,9 @@ struct snp_hv_fixed_pages_entry {
 
 static LIST_HEAD(snp_hv_fixed_pages);
 
+/* Set while SNP has CPU hotplug disabled. */
+static bool snp_cpu_hotplug_disabled;
+
 /* Trusted Memory Region (TMR):
  *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
  *   to allocate the memory, which will return aligned memory for the specified
@@ -1479,6 +1482,17 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 
 	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
 
+	/*
+	 * Disable CPU hotplug while SNP is active.  Guard against stacking
+	 * the disable count: the legacy SNP_SHUTDOWN_EX path clears
+	 * snp_initialized without re-enabling hotplug, so this can run
+	 * again while hotplug is already disabled.
+	 */
+	if (!snp_cpu_hotplug_disabled) {
+		cpu_hotplug_disable();
+		snp_cpu_hotplug_disabled = true;
+	}
+
 	snp_setup_rmpopt();
 
 	sev->snp_initialized = true;
@@ -2083,8 +2097,21 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	}
 
 	if (data.x86_snp_shutdown) {
-		if (!panic)
+		if (!panic) {
 			snp_shutdown();
+			/*
+			 * snp_shutdown() fully tears SNP down (clear_rmp()) and
+			 * has already cleared the per-core RMPOPT_BASE MSRs via
+			 * rmpopt_cleanup() with hotplug still disabled.  Re-enable
+			 * CPU hotplug now.  On the legacy path SNP stays
+			 * enabled in hardware, so hotplug is correctly left
+			 * disabled.
+			 */
+			if (snp_cpu_hotplug_disabled) {
+				cpu_hotplug_enable();
+				snp_cpu_hotplug_disabled = false;
+			}
+		}
 		snp_hv_fixed_pages_state_update(sev, ALLOCATED);
 	} else {
 		/*
-- 
2.43.0

