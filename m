Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794592085;
	b=UVFKvkN9noKKmgUhtUADl6AGDht4wzgtPSwklgxwq/Re36wUihGnNbHmlIZx8ftSpvs0
	 E+PKprcBIjOiwI2+csbvdZoYREUaGcQmMmrDoMO9gV6GflF2yrO92RedCKKrJmDfEMtN/
	 nFWE7ITx3jZQBibtgMr4nBtbROjFUfLxSkrtpyOcKToebQ5bCKtIUTpWohhIqDr9hKZMy
	 eIypDf+oJtPb2VZT47WmlG8L1atkN4WvRH+TSeB3bjPRR1w4ACvbhY/1aqsFWUkg/R3rP
	 Yw3TytAoC+nGEKdmzGtwMdMNrXqko+W6PX3TLgQIvE3dc5HrLb/KMzuCKI9nUqG492A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794592085;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=1kLJVV3X2nlbaKv1uANjtZyxdyHLSWITt3RX4g3yxJE=;
	b=BgnfWqEcUWvRvzDxRaJn6WTU3OrcpAJtSr55DnHGA/188ScTlbJAHi/AgM7QExfDSBgX
	 pneeZwgCHlQMJ/WVK/RihkNUxNHAo6HJedZynw7rJE02ZSKk706Md+63QlLlFbga2OLqC
	 gzTcIc4Nm1aDg/mANkSSG+Jzi4aM+BTnAMOVRiQ4OsBuZjXHJrvOZHLbdEmtvKZ7z1mp8
	 fA/qFrvoi7XTfx/BfCesgS91QP379j/BAyWgIKHBQfo5o8+11h4Mq2vtHDzx0mR1n4O08
	 WW45bDFKYyoTnXathAY7amM/EbwgO57AxQRdZB/BQIh3Q6I0E40f7L5GrKHjXfFL3sw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="N/aaBrWs";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.7
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010007.outbound.protection.outlook.com [52.101.61.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B55F606CEE2;
	Fri, 13 Nov 2026 17:48:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B55F606CEE2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=N/aaBrWs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vO22eek7CHKrljLGfOxjTvUFTRO9EBuPDF4ynRcFIF7sFlP5J2Nk9hD0zixdqAE3xfx+Brs0gmO64ImoRbdeSVzGWUNMKM5BhcqrQDySfF86eFzDpuk5LUY8dxAyTSD120uiF1bmGEffKN6qlDsyvCZe9oo7S5rH9EjoXhmsRv1OBs5DTDm0fXoD+iXLaQmR156b0wXnlgta6eadcD5bPc+QiIXhVe39zb1y1zEo2cOItC34bvlj9pzkjVkh/odhhiMNIbaSacOZxmkNGabHurckCz4bQh5rDyYnJUJfivNRMzar47fXa4IaOyhf7Cvxnb3kGLVSFTehSFa02skd3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kLJVV3X2nlbaKv1uANjtZyxdyHLSWITt3RX4g3yxJE=;
 b=O9c9ZWGotc6gtfja0+CFyGtn+9BQdz23ZKuREZ4Tzyq/13TU3AlEuyiTABbNuHiVAB2IFOObbnqkats1odWZEEhEuwrv4Ddj07JCYTLePGRUo9F/9FKOhmzHCbMwGAVOplTWzQUYobX7nXuvZ9/L4319KvD9ZZZqiGq9pD8zqVc2GcCBzycXbUjY0E04axZ6VXqZQ0XgoQPnj8pqoobqXyFrXIqL/hML7S60UCIXOaLK2mF5tSbk23OWeaM3+szXHYky7sKJy6wGh0ZaQyzMM+K+eiC0NGpTg5ankjl7V8rKNyXo6S/Z4tyIdFrbt+no3c4ImHGvpf0V2cmKW9ZXTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kLJVV3X2nlbaKv1uANjtZyxdyHLSWITt3RX4g3yxJE=;
 b=N/aaBrWsjHqLiAHPspMCXcgD+gC3rSgTIQs1A+fKzl2e9bQ4Cw8G1HQFlmUZxtBfZMitnLrXEld9zAiRjXe6WTerQuYzvo41AYF0QvQ0Ub6fwsquhtMpLvMs28m2U7TbGdXqXeznIy596gJDLvyzuJ/gSqpGJa/YavnVd6yojPk=
Received: from CH5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:610:1f1::24)
 by PH0PR12MB8051.namprd12.prod.outlook.com (2603:10b6:510:26d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 17:32:56 +0000
Received: from BL2PEPF000352D3.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::88) by CH5PR03CA0005.outlook.office365.com
 (2603:10b6:610:1f1::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Fri, 13
 Nov 2026 17:32:56 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL2PEPF000352D3.mail.protection.outlook.com (10.167.254.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 17:32:56 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 13 Nov
 2026 11:32:55 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v6 4/7] crypto: ccp - Factor out the release of the SEV firmware buffers
Date: Fri, 13 Nov 2026 17:31:57 +0000
Message-ID: <c435561308c8723cf4ede0994fedc14b8979f202.1794531772.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1794531772.git.prsampat@amd.com>
References: <cover.1794531772.git.prsampat@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D3:EE_|PH0PR12MB8051:EE_
X-MS-Office365-Filtering-Correlation-Id: 04f2f77f-77a4-4fd5-24cc-08df41ac2787
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|7416014|23010399003|18002099003|22082099003|6133799003|5023799004|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261021123027099003|261022075727099003|261021135927099003|261021121427099003|261022105027099003|261009223027099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	lW3bv6H0GnXXM7o2X8CYI970lk724gQzL282AvqOXamyi2dqIbRnDHoK9KRUUBqcfjxBLYaHzFjqDy/kOXtsdwGRobmxEr4zLF99WYJshAaViLMvC0FahLRaHWFRN4RnNoaQxfzT4Y6b/UgxAE0d9BuS2gFm3G4CQzN+xvlu3U3UTtFRwb0Gix7qkjhHwn3gyjmRXUS7tTC5RWrK2hz2q5CXv6QJLR6ebywVh8iin8c6oCYvqWBLTp3i5peLnQMXk+qE7/jxky7Ccewx6unv1vHFxLVjWj1OuY5WhAkEklsKiZaXawt/tMoecqSq3Nm/T4lPok1IOAxLHwUnrzXuMevML13SRv0SoI2k1t7VhLpi6Mo1BGej2cENYwsIJOrU7qCX9wt6dwgsYb8KnlmLtF2r5nU6TilQrrxEa815MCb2SZUp7puBouchH3pMuPRvhMyr9vaQt3incBMYr2WolhhF32EiviobbFmiJCPt3px8i71f1XgWAPue5phGvWDudFjvaCwZUGPzJSl1oCITQC+Cs7MTV6+s9s+16HqNoRHXLZISY4FGgKRjcI6uFnE/FTBHAo7zVbbjGF/Z7vpykMMwQqbx6ZpXxukEW8SIr66xPADHTnPj1ebywiugIYaO8bQfE8flrALWdIp9Ph+W/J5K7eVtPGwjAkaYNKg4ZnaaVmptPgI9s0JWc45bAG/ZUqi3tDBdJd0QFcUsdcvG+g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(7416014)(23010399003)(18002099003)(22082099003)(6133799003)(5023799004)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261021123027099003)(261022075727099003)(261021135927099003)(261021121427099003)(261022105027099003)(261009223027099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5hpIXzFTnuanj0kaBxU3gy6oGdR/uJtljIjIXPsZI/XeYLf9TNcm0X2H9hheWAHXQXwN/P3BQ9bR/2MhKYgDdo33aPe6Z0m++qwsXlSYAh6Jtq6j1em5FQNwMhSesVwTeE6N4c64yD+1Eggv6k/9xePfcmEnNr2pXr203ZAEFtdBfowhbUVdBUDVs+Byn6pADDz1c8DCgrNw0BQvCi4khvFvDTrBAMWtxWSOG3Oen/MbGMGNUo2JGftUbgrdwAgxYb1d+U7LfAQmS1eSyiUWlqR9WJfcY6T7YKY9cPKz7xxHitnG/WdMhvx6YUPrO4G9FhRR/PBNfAH7rzWTahSoGHgFxlYSTO4FjDBGxa1t0/UukRGl8CpXKXSdi0fMuOhxtBbXpxxjMz1SM35GVRQ7ZuktIWe40JJAcJak47kVbLeqsqArLAfTtTDU9Jpml6eu
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 17:32:56.2791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f2f77f-77a4-4fd5-24cc-08df41ac2787
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8051

__sev_firmware_shutdown() reclaims and frees the TMR and the INIT_EX NV
area once the platform has been taken down. Move that into a helper so
that other paths which de-initialize the platform can reuse the same
path.

No functional change intended.

Suggested-by: Shantanu Sinha <shansinha@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v5..v6:
No change
---
 drivers/crypto/ccp/sev-dev.c | 55 ++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b980dfc7f3a3..888d960f68a9 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1883,6 +1883,35 @@ static int __sev_platform_shutdown_locked(int *error)
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
@@ -2963,31 +2992,7 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 
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

