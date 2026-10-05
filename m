Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010066.outbound.protection.outlook.com [40.93.198.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF044D2EDC;
	Mon,  5 Oct 2026 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791217016; cv=fail; b=kSW3FkXDV7cyZALT5aj5TwQ1x/+At8vs24GNZpilDXvZdiRlhm9Cb2jrztnYe4h8mNgbCGmI7Rlcjk5YrI2eOsNXs5Ezt4VKjE3DeO6/MUatr+cQlyNOUj20XiCN6aoT94y125TKBlTohutf3Dnbi2bLLN44oxV94CfFNSvv1Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791217016; c=relaxed/simple;
	bh=GTlLBdeLAgc6tq3dZWi/wBPVSeyahCHz4UI98GE9JqY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AaIhxgDE5TC1HoZStxAj/x9Z0IoOUtadcoR5c0s9+Y3GkvkiN6UQt8lIbRn+1oo1F2FmTzhm28xBmSJxgsgh09fsgxIaRQYhzqrsR1aoyZaY9jy8giuc0SqvJOi/Neu+HSTXSG/WkB5As02Pi/ZgCQ0yUvkrfr64Vv/M2jOA/YA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HZG3ZUBr; arc=fail smtp.client-ip=40.93.198.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HZG3ZUBr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M8s3M2t2SzLvlJR1gLAygKtNfYzhgvl1MVuA+rRQelUrsZb8QGdAYY+WlwWxD1bqAztsHhVyueqZfEr95IgQxfobS4z61AgvqmwIoENLubvyjJ5BypdxT5T6YoL6GaH0zVURd7lKwn3ExF4Qgjpr3ar+LRwoAKNzDw00VjsAX0dJ4tVqi74FIk80PKLVZajoivQHGb0YLA4satQBvY/Jlxp9XIidzcbhw717kzYF1d7v9zeqhQ/sF7kiT69udo476zLcyihD0s2HTNfBOI3cqKNoBsUUZPBZo/irTFAqFN4h1nvMBfvU1cFbIXYp6UALz/8rWswivy9AMcnhHA2Opg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSU/TK891p11aT2gEU2Zcn8LN3F1xITGAxP0LT/EZ+4=;
 b=RhzDXmjo9jew9a7N5OE5MDIB8fJfbdROLIrWStljsNu299qtXl9IDDka5eDUVZK3tXzIs2t2F2WCkIrjVPETz7la1ya/ouq0e2BkQG2CQqRpxoqppYoS8Jyx72tOI0F3pGSExC5qq54Hk8mddOeyJaMbpgLtXs6JR9Dn5UHSbNilzoCMDHx7AQt4w/fsF0eXBoqj7gQFGMhW6OkxxhcyKYumWGR73q2GiJOSNjFRWTnFJKrf+F4Lm9VpNmC2L4QLTqT36LACZCNqcTkPx7egA38FCZxnUMDG3hPPl1d1m+ZRcafxhq5+kCvyjsxa2galQoU6hKhpjOZBV69AmEUUeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSU/TK891p11aT2gEU2Zcn8LN3F1xITGAxP0LT/EZ+4=;
 b=HZG3ZUBr6yucASVFq8ek00wRxV61psprRvOzq5yvifBDo4SWxBqd+pg5FKxYa92fEK4ScH6Hk3Q33DSp9zagQXBA1MU9Di2OPOhVsact17UjN9hfAe/F4FGHQLUjLUnAG0Z37HjAEv1TSLBp0VbJH3o0ZzMlpz5pYxC5wwvClDU=
Received: from BN9PR03CA0969.namprd03.prod.outlook.com (2603:10b6:408:109::14)
 by SJ1PR12MB6196.namprd12.prod.outlook.com (2603:10b6:a03:456::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Mon, 5 Oct
 2026 16:16:47 +0000
Received: from BN2PEPF00004FC0.namprd04.prod.outlook.com
 (2603:10b6:408:109:cafe::7d) by BN9PR03CA0969.outlook.office365.com
 (2603:10b6:408:109::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.19 via Frontend Transport; Mon, 5
 Oct 2026 16:16:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FC0.mail.protection.outlook.com (10.167.243.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Mon, 5 Oct 2026 16:16:47 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 11:16:45 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v3 4/7] crypto: ccp - Factor out the release of the SEV firmware buffers
Date: Mon, 5 Oct 2026 16:15:38 +0000
Message-ID: <7fc1a46257b2b7c64b8246921842bb66356f4970.1791212077.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791212077.git.prsampat@amd.com>
References: <cover.1791212077.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC0:EE_|SJ1PR12MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: 1434e5a7-0a61-4e2c-e887-08df22fc0dfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|23010399003|7416014|1800799024|10067099003|5023799004|11063799006|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	HGQCbfsDBmAfvLm02IP8xBzVswwS4QqlXDLgv422eZkdfYUQPBkH7y79zGS9mzxOv3wHaJJH/6s3w4hOe1VskYSi0359tkl/Ib3Q4ohifpUCPmSgvNBeay62S3+83DZ5gWw7HHidTH7wa7cBDQfM1XmqD0VPXgQIj0w5CAuUzj4eUZkgdhAzr/3iX7CYa2gEK6oKT6UhPvjek0Hzzl+y1S0SsjMnTqKvf4MPIPR8yDisY7LEswtJ4Yd1xb5KnS+G39U/pbLIdvujhQmR2ESzVIpIyWa6KtPevsCcbBoe3YrqFvH/9paQKaeX/h6lWq4h+M+M9Wt7zn+YDOC2aQvJr1+jl2QrcBetemL4QCvTyKbbx10/9b5pW5lp0Z2o95EXW9cvZFVf/OHA963Wgq7MHXJ9rq19aV7nbxswYQO2BTbmEsWzRTVSpSdWtT/WVTJa5wTq9uMiXXsn6PNr4HoPjaLh5cbTjkjTBshXrZ4R4DJYwLyGiArGaw7KeCfKgsyw+VosClk0rs11q4LItDjG84Nxne0m364brj7+PgO2ZHPlw0mF1R7bIBbSgYOsOWqar6hNDC3RYnSGdU6V9oNpB8P5ymgQ9l+B7qUxvlG8zXhzzMEbJ2kyD3O46VHK5xJDAkIobsv3nnzxBTmEWuziDUmKv24O4kPL65RCI2hxYYcAfjpm0dUO3X+kqKcNmzRoKb6z8ghFjEJTspqeBvmS4Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(23010399003)(7416014)(1800799024)(10067099003)(5023799004)(11063799006)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yUHavzB4Q42/frip8JtdxmnIy+nCmBHS/c0Me9c812DH78wNmGln7IrxbT4DMXw5bMsaA9SzZNxQcH5DZohu86y2xPNDV2Iy/5PXafq2pbuvdkiizMej1+BxHJTZ9tzYbfn7fwFrCmCRIrakoWrgg3GNdno5bB7TYpw56TiYJlx0dhVBvw2S27TF6s5Mloc9h3Fw7kAbheKnX+YMAItuxLq3bvJmAMxKbJBuDR04LHI+jDyGglqdcuxamcvXtp1fysJPbftsj/Ok3LnYSbjaUwlHH2tsPavvgUHT792gOd2TFIlpr0P16WS7yMKu/g4dEakvtO3ughLV7MglpMB9d0tGQvhvHhraytVSo0O49CPrjWrZ1IhcL/TShL+oz211eB7ssNVSi5IUP/4oeRW2M2P4HWSiUfEtE0QyTXRRKqjCFQozK6ZRe3hO5x9jUNU8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 16:16:47.1109
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1434e5a7-0a61-4e2c-e887-08df22fc0dfa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6196

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

