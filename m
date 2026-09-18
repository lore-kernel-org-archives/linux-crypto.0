Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C2A51A13A;
	Fri, 18 Sep 2026 16:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789749731; cv=fail; b=TaWneTtb8j2ZfDDHu9kNSfpraIHWtmzk8WAwlpk+8UVTR0taheKGm9rYORO4v2iWdsejKNb50jxQKQKjHOKVlvCR7QCc82xMENEIYt5Z2Ws2CEw0qY7ESi6ABAeYfE89IHFIjsR/Rd2bD40EUnYhBdv5Oc+HQkOhpVypfWZ24YY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789749731; c=relaxed/simple;
	bh=GTlLBdeLAgc6tq3dZWi/wBPVSeyahCHz4UI98GE9JqY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+VmFtJwAdHka8co8WC4D35qn9d+FQng2nFs9p+c9kgOdESKHr7AJMGoxzogSndPEXNgcQJxTQlN+s2oE5EKow7CEAhhfqPbA/eLiwWsB3mG0InMff8x4kLYSz4l47I8Q8wVbKmfE753P1TtXM7A1lCsLEGm2F4DQbe6TBuewBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Gq5d0Y+N; arc=fail smtp.client-ip=40.93.201.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Gq5d0Y+N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XXdwHf4SEk6Ic587aaOnjLE0A8ELvaSA22+nROxgxZJq98VsvY+akyxr0uXzb4+wHcTLxwA0kC3A0n8S9vVunRK67S9H6gx5VLfbZWs23Kk86gCEyuh3/jqqd+rq8TfWhpLwq/icfjEG7OUD6/+g1vqtMAk2+ompogSfn/HFmJDdZItJMa6TgjSpLZpmJLE/N3rmOanR7lClppxlSezNf3yXy8Wvkhxlvrw0d07Pb/ypmGCQ+IjltfCjzeCfFmMVbYN6f8xRawQqt9wbo6xEbhsNlgR+PgYU+i430oMrr/nrfcEYER7TuhgA9OdcTrsxtRfce3TsgGbD6eC9cwwjLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSU/TK891p11aT2gEU2Zcn8LN3F1xITGAxP0LT/EZ+4=;
 b=w6OhIFnPZspwoGctruUgZinJ5PtuCSKF0IIjZh7u76fitlJLKue4911ek2wR3M8jf6sCtlnLmerLgvDZFvtAeL3N/+jc+Y0ayJs9IVMpW3fePwnjLTn83G1qS8g9zlzpIzqwJJVun1KwIr6kTPHirCreTwUZO2eNGvPL3nbJHu1ew3rWoyyrtizgEhuba8t0pLOMWtHNJQfBu+ihdmghEZAX/T92XHcV64o+wObW+jx4xreO3OgZ6aJI9QWwIIxR05Y/4RFnROkNqMhoZ3f7OtL+t/+SiWQ/LMwq99F8abNdQoOp6c+j15Q4uBGaOVNCJT9SCrDiq9b50hd27dQkQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSU/TK891p11aT2gEU2Zcn8LN3F1xITGAxP0LT/EZ+4=;
 b=Gq5d0Y+NgO9NDavX5J92dDB5R8itwpLUW9810ywwunT3TMpsn2LZrjsgr/icQ/S9Jm9jEaoOYPYW3AH141vly+jnKqLgjJlvAjTOU0AQSC1tFv5W1eer6USMWIRBFImqoXN7lXkmAl0yNbEQnpLTYFvDlwgULPGwl8X8krldcmc=
Received: from SJ0PR03CA0078.namprd03.prod.outlook.com (2603:10b6:a03:331::23)
 by PH0PR12MB7815.namprd12.prod.outlook.com (2603:10b6:510:28a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Fri, 18 Sep
 2026 16:42:02 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::5a) by SJ0PR03CA0078.outlook.office365.com
 (2603:10b6:a03:331::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Fri,
 18 Sep 2026 16:42:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 16:42:02 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 18 Sep
 2026 11:42:00 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v2 4/7] crypto: ccp - Factor out the release of the SEV firmware buffers
Date: Fri, 18 Sep 2026 16:40:58 +0000
Message-ID: <fb9920e37b5c06fe841099331e6abe4c671a754f.1789749016.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789749016.git.prsampat@amd.com>
References: <cover.1789749016.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|PH0PR12MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d5492d6-51a7-4b6e-72c1-08df15a3c40c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|23010399003|36860700016|6133799003|10067099003|56012099006|5023799004|18002099003|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	n88VyRZILIimgBi2q8Ds/m+hRFVmAf9MvGkFrffIdtRmWGDyrgD6d0n4/63n2gzw/1MXtujhK3if0nAE7AqINCOfvpYVW0El6vOPq76RRa7SLDsC5TiVzjvHcNaCQobn3r2R929t+0ZZ+TwxZiUgTGIJXNNc982b77wyLyrQ7AOiSmEstQIsDDRdpAU9t2RxouNB4dHOP6XoqBoGTYoPnwpOGq1IEKjYoRA4Tcgym0TeUizpW4s7rwrRfkW4JnT+05kIyp5v6tUMKz34MS9o6MAqdmLxmRkokyi+HUSHe5tGcK47zAhNd5OyCeKMRoddubrFxe5UhwJsyY36C+UxbGarKZQ/ij2fXqO1ocV3uwmRrZ2XreSBV9OZt9d6Yt86hMM2wEX/6YlwiMLKd0IjdaJEyNK327vefk/bGvzSllQhvnNObKnmSQlbgVWP00CtDxOPeS/aenYMEKlcCaMC4o334KMFohNXR3lOhWblTYH26PqblZDHhA8ls71P1K57MMdd9tM3aokTBaXu5xli1ujt3dpzIPZu3jREoABYR+dS4IX5ntxbfm2mOY9Sa0xS83jjPBM3iTsSPoUXrAFzhsv+3Y8AljCH+JjvLZLA+ufMgFc3EOT/beYR+FkRH4HI4LssaGX0HPqIYtsKqI4p2dcyj3WSJQRlmT8SBrIWh5jQAvgkFXclw3s5Lztt+eUWsU9qv0IaFUlaliYyPd6CXg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(23010399003)(36860700016)(6133799003)(10067099003)(56012099006)(5023799004)(18002099003)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4TL94N6ZmGMEChKo40vvwM2ks8z6xv+r7hy4iF+ro9SDl5WX6mQ5nOJYQ+3JIhXyivmvudodyrObT+HjLJhXTZ4yCa+omsdrxHxRI9aDEibWuvvBMuGdKtmE7QVz8oL7Ip64yvFIqjaKE4qnjZBIKK2L7LlQQyaCktQyHUUFq3SinRG1zerUbGbvIY7KZpMFT/OM5wM2z9fDGivWNSxYT6iXpbtxXRUPAhablDkN9sh0RdnnSProlF9y/rFrUFvgbPnYEkZsx2oF/WU97EjGUdBKASYj6DN9yHETWIfsD8unQKBJP88dQKeCBTVqWps2jFLu2UiqZFZPRw6a0NTwUIa58Numh6kLgPe0jHIhP0IC5LoXzORuqvxkdvKknyBZULmkOnwZ8ODSnSMAf8qw5fw0lvoyxa/LSCXxHZ4rsSxCKPwsdLem+TMYD4WZ2p35
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 16:42:02.1641
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d5492d6-51a7-4b6e-72c1-08df15a3c40c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7815

__sev_firmware_shutdown() reclaims and frees the TMR and the INIT_EX NV
area once the platform has been taken down. Move that into a helper so
that other paths which de-initialize the platform can reuse the same
path.

No functional change intended.

Suggested-by: Shantanu Sinha <shansinha@google.com>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 55 ++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f833cb7e4da3..1ed9e61a95cc 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1881,6 +1881,35 @@ static int __sev_platform_shutdown_locked(int *error)
 	return ret;
 }
 
+static void __sev_release_firmware_buffers(bool panic)
+{
+	if (sev_es_tmr) {
+		/*
+		 * The TMR area was encrypted, flush it from the cache.
+		 *
+		 * If invoked during panic handling, local interrupts are
+		 * disabled and all CPUs are stopped, so wbinvd_on_all_cpus()
+		 * can't be used. In that case, wbinvd() is done on remote CPUs
+		 * via the NMI callback, and done for this CPU later during
+		 * SNP shutdown, so wbinvd_on_all_cpus() can be skipped.
+		 */
+		if (!panic)
+			wbinvd_on_all_cpus();
+
+		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
+					  get_order(sev_es_tmr_size),
+					  true);
+		sev_es_tmr = NULL;
+	}
+
+	if (sev_init_ex_buffer) {
+		__snp_free_firmware_pages(virt_to_page(sev_init_ex_buffer),
+					  get_order(NV_LENGTH),
+					  true);
+		sev_init_ex_buffer = NULL;
+	}
+}
+
 static int sev_get_platform_state(int *state, int *error)
 {
 	struct sev_user_data_status data;
@@ -2906,31 +2935,7 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 
 	__sev_platform_shutdown_locked(&error);
 
-	if (sev_es_tmr) {
-		/*
-		 * The TMR area was encrypted, flush it from the cache.
-		 *
-		 * If invoked during panic handling, local interrupts are
-		 * disabled and all CPUs are stopped, so wbinvd_on_all_cpus()
-		 * can't be used. In that case, wbinvd() is done on remote CPUs
-		 * via the NMI callback, and done for this CPU later during
-		 * SNP shutdown, so wbinvd_on_all_cpus() can be skipped.
-		 */
-		if (!panic)
-			wbinvd_on_all_cpus();
-
-		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
-					  get_order(sev_es_tmr_size),
-					  true);
-		sev_es_tmr = NULL;
-	}
-
-	if (sev_init_ex_buffer) {
-		__snp_free_firmware_pages(virt_to_page(sev_init_ex_buffer),
-					  get_order(NV_LENGTH),
-					  true);
-		sev_init_ex_buffer = NULL;
-	}
+	__sev_release_firmware_buffers(panic);
 
 	__sev_snp_shutdown_locked(&error, panic);
 }
-- 
2.43.0

