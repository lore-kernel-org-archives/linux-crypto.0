Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792602389;
	b=poxIVNvUt29JDxV7dn9ulfeBH1BKLXdzawZgrUz+6flH5Bq3k5eFOTwT0pcLjNQ5Spz2
	 VY7SbcWMJDDoGGxfcBOmnQYKKiB5g3Vt5B7kehbqY9l3cmyqRX3sHmXM9uY2Q4Bdd46n8
	 ljwCIjXZ4nD24ylqO9p4+QSHIjwPaI8jv9Gvidpr0tzFYB0igjR+VG6vsQ6+l476XUDB9
	 O90SaDAfQqft30sxDhv0B2vAh0LLutgN3Bp/jlM2d0WXEkUcEb2RlZps1D6Y8snanvOIG
	 FJbKXXn0Yhdwm5SnZkV+2tyVVL0GxZLSZYznF3ihBKuo8pF/tMu1TKOeRABwYo1F9ig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602389;
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
	bh=6g34E0kndyo7+g6dqXkTSIgL7SYJue/L3piZeF1/FJI=;
	b=khK1iGmBMS5NQoljw43ttgiOHkcPDBHO0uJhcL6zPjCXv46RgQ/XLYHmjLH1qDKRen4n
	 cWgkVYx4XFSKGB735A7OaJGqi+N22PoakeCU9/DCIKoiQ3I+7C4YcPsD6nNWqtSVPEvSa
	 jnoyFnpLUpHpNC9nQikW36YVCZw4W8xwC3JDKNCboKpe5adRnutCobFUN0bpVp5+/Dx5R
	 ykTnyTBwTNauaSX6l/tGqmyocyIkDjiRWkTplJ6LtHsjFyOscwubesCU5wNXiDUy4sjAO
	 rHlxwt6GWpoo2yhmXziz+mNPbuZkoHUQNd6xBqT3uXefYzrD3lvB7JorNiiXu0TXN4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=bNVdZZat;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.40
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ACC606A31D;
	Wed, 21 Oct 2026 17:06:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46ACC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=bNVdZZat
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZNpEWPeIG0/SQvR7fLwQAOjNRbe+Msj570Y4ixK3Ot+U1AALC/Wvi38Aapk1W3UFnb6B+0U7qZFOtfCwWemCNlVzySVmFSDF9n9tMiwLYYbwYFcEIm6vu/1/T7Zpo8dJDIksg7E3VOd5CH03qLERxFfUrHNSlFDdWn48oqYff+HPFQmRtYWHij/bFG4ZPIbAv4h07Mvh6vX3GDHH9zcHpO0wQSeN/4p8CsaKpoViz78mTIqF6s6Tiqdctbo+fiCrlb3nuBHYrpVkec/S2UNoon96IBAOn/JIQqpRgCmxLOXs7jPk1iM2TQY4Rc2EebmVvHHdOLaYCuK0VPrHQF0geQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6g34E0kndyo7+g6dqXkTSIgL7SYJue/L3piZeF1/FJI=;
 b=mlwCP/6uJtGlAfmIvo+/sMyYfnuwTy+Jm9OrVudXajpwbkOBHPt2Hj+px0pTW0hEgCaB4EqGGHCO8eo79r/o4pTYgF5+aN0f7riMKQUCbxoVEHJCysNfxCGznnH+yQpRBw8YPWnyi4E1rkd3P6L/4vI76ePoBPSKdAZNfXj/1OLHs1C0/ZUThuJ6RIbMHfoB/So7ONRYSHrUvmh17+SFJWSefgiMqgr7M2FNPDDhd0aQuFbYGQNO0rjZ4jouALXnxyOyJKbZhmBnb0cDS7Kz4OIpLHmKrxhw1PqDEQe5X5jgErt+ror3iQKHSiXRJRKnKuu/wYgAGNtJkWeYtfJzLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6g34E0kndyo7+g6dqXkTSIgL7SYJue/L3piZeF1/FJI=;
 b=bNVdZZat3S2ccyDLT8rvYA/cv5+WDghsoGLpEIt8nWJW/l8nMSfKEf6WCgTpiPD+AEEmZe4iPAmCXSCDGKVA6fCJay1YI2zvQ+oo7gHYYXr7eol4tHM3aT+zaoT8asPxs1sCs1feOb+tYPMMEnD4BeWQ9Bie0Y6rPF5Jpk3K698=
Received: from CH0PR04CA0112.namprd04.prod.outlook.com (2603:10b6:610:75::27)
 by SA0PR12MB7464.namprd12.prod.outlook.com (2603:10b6:806:24b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 17:06:18 +0000
Received: from CH01EPF000BE94F.namprd02.prod.outlook.com
 (2603:10b6:610:75:cafe::47) by CH0PR04CA0112.outlook.office365.com
 (2603:10b6:610:75::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.15 via Frontend Transport; Wed,
 21 Oct 2026 17:06:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94F.mail.protection.outlook.com (10.167.244.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 17:06:16 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 21 Oct
 2026 12:06:15 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v5 4/7] crypto: ccp - Factor out the release of the SEV firmware buffers
Date: Wed, 21 Oct 2026 17:05:00 +0000
Message-ID: <be72e0b1015156f8613fc2c360fa73d59108dcc6.1792599491.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1792599491.git.prsampat@amd.com>
References: <cover.1792599491.git.prsampat@amd.com>
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
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94F:EE_|SA0PR12MB7464:EE_
X-MS-Office365-Filtering-Correlation-Id: 899e661c-96dc-4941-c6cc-08df2f959e77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|7416014|376014|1800799024|6133799003|22082099003|18002099003|10067099003|261021123027099002|261021121427099002|11063799006|5023799004|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	WaRAQ6gdCV1KaOj8Up7ERrvYO/E0oTRmiDHjy6Sl29yTXnOob93GFdCVOyPesk4U0J34rtRmAZtskxFhpyT8qI/W20GIteiDIKSYWQr1jRJFkiXW4GPrAaJrKZi2zZvAzsOqkxHezhCQiP/q8msNk4Hbhy5CJ1PwW3RQhaugEqPucZmhjrcH8/g2XOqKmlrBNBbUkWReZVUwmweQMJXR//KYJq5qrsPJkKx5e6iEhIZDv5zq73E12g72HOi2c3e362pKr1HBO/Cd+1D2skj7ykOvXCytWNHEYWQh3G6znnPDbCmaaSdbZ0ryQvwNAmx6ElEmeqm9lMDP3/04n10ZPKsRlq8RDji5+aADMtoWIIWjk0N7OscJL6gyynboIYyC/CcV9IAhHNvwMrLNjl1seWoRjCx1Wiu0k/X6yg138gt5snXzp75PrnRM5m6wmQ7RbzjgC3Laq/PaGI6mYkn8iZvJ4CttJniMRewiSrSmIMyF9cbyI09/PGCTp7+P2S/9YMETW/bPIHDUT08maKsiikBcBJu0i0L+mazJALMp1biBl6Lrg5yag+J6RxRZN90UIHNmG6LtluDRDakK2K8Cc7AO2usvHed2wpSmhebZEDvK65QtnS+QuH6Gn/8AFpcIv/hmvDXlD6hvEBFikWFAxhYp8VtocMenDMJYni91+9Sw6iwchlMfpXqa4Kg8HWvhDz/7qYpeX8tRj0PIAEoAnw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(7416014)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(10067099003)(261021123027099002)(261021121427099002)(11063799006)(5023799004)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/eB6bNC9WIqwZvxFmhPf3o4pAiE1AGaapwq4REKwKPH2BO14aCaPKzKcEYRKMtr9wPfd5I5EEzSYrNJj7ESwuEZzKk4c5pg2WkdKYaojQYiy8/qOi1MhoDmbXqIxr4+0NKP2Dd9/hlywdZwWPjSkdXSD6japAU1wvhGXOOfAPMiJIbJLk1f+pZjdgrPBZcuxzp3iOmc5tRWv59YiBdlCNqgCnfRVpFmR2xBM48wjHWyvgNCKJn3xoSzcmdsKeeuD49LB+1pMnSTYktVrn1kfX2qpC6/K8YnmZxDCDV3kUZ6jeoce5AvHU7EbhVXrifV9gYiceq/wvi3se6eNjQL5QZCYw2xspBdsk2i6CmTRr2REkOPaB5hRY3tMvPUxus3lxOZq2oop3tD4HkU7YOMlVe7nPwoiAVga6wr0VPr0pzld0o7UX1ExylRmXmD2tULE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 17:06:16.4628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 899e661c-96dc-4941-c6cc-08df2f959e77
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7464

__sev_firmware_shutdown() reclaims and frees the TMR and the INIT_EX NV
area once the platform has been taken down. Move that into a helper so
that other paths which de-initialize the platform can reuse the same
path.

No functional change intended.

Suggested-by: Shantanu Sinha <shansinha@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v4..v5:
* Collected Reviewed-by from Tom
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

