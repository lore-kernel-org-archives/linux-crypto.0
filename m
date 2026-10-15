Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012021.outbound.protection.outlook.com [52.101.43.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B7C3B83F9;
	Thu, 15 Oct 2026 02:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030521; cv=fail; b=q5QCt3DzxQYQRZgz1WLLnW3KPadTZLl0VZuP7gij9h9obBs76XpMqVenZx2uKW+QFR7/Clf1sdzfINoXTuWpMIzSr5U2MXYfQwjajHkvjouQ0eCsbX/5LNOT0oA2Woeuq26F7tBwofr9Yi6dMe2DJbgOW4pIohlMsialq57IqIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030521; c=relaxed/simple;
	bh=UsrZ9MSLab9gHIDZGiixBGdTcT5ZZRFsKjWm0msXIu4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ArXDApg3Dgn0ZdrecrBDqUEDo0V9TmogtsKn8tAehgHkWEUe++gEV/r0rRyD/cP87vABxwyXdt62n/BJ67F4Y8EiMSZ/xlomEXupHt1p9sqKN8CM7TM/fYOf8FQjT5Y5UfP/9u3uMUUZgTc0ZldOjxBOtG+uGoI+TulxtFuorzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lUyV1r7e; arc=fail smtp.client-ip=52.101.43.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lUyV1r7e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I4MVQnP9uTE65TkM2Aa2VMlVtLxtX5EBNbOe9ngcbxhiB+SqoYT67B2ygpHrQR0jOcgPuZwsvJEz/vTq8txJBuli2G68TzOBznZmHBBzUlykctEsKRNqCIkFP3Ba3a3kT2Eqt2dTSPjP6hcRHUsK4NNMuazQR4YwZz3pF1DzSyV6DGVzMPgXYACWy9eeoMqDY1Slc9hUXwcs6fziPYJBB/tEIorziDfukphTOYMxibDG5ZcKpd0kc7yWAmswm/nad1UBSH3MWU7oFUenAKSmN70BIM1DzAiuAfQgUO8E5NgKgPB7NIaWarYGNoqBcQmHvDBlfrTi5K59SWUTP0+6oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DU2QQhYoYZykFAadCMSSKtBENEp4cMa3Zdln7whxUY4=;
 b=nGotLhnA+P2J1r3WWIZmE1Kk61i8Jlmh9dCfoVvZeS2YWHGaEEIJkwCCjSROGUvmx/ay0R9ZbmPhqOpjti4qi4rLdAsBpm1bGEDn0E4kgfLv9Z4qZekMo4Enxc7tmu/bvQK4ZpHNcWTXC++Yc03ClQOlw48kvB1QIZ303/xNTO3w5iro10Sfm+OIcZEYmVyFcrBe3n+H7TKJd7TpdZNUeuB00JtU2AIVwh83kRHwV8eVRj5ydzmitLl/4dk7z3bEuJz2Qkwjsh0RD51FYP6XpwWe4NQs9qU4oWO8eW4q4ozG4xuc0Z+a/Fo6yIZd8ZiByzJlmIld9q2ybKvT1/R+zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DU2QQhYoYZykFAadCMSSKtBENEp4cMa3Zdln7whxUY4=;
 b=lUyV1r7ez4lDzQAeOTmMjQ+GcthLoM1zOoKYqi59cquTpPm6r7A7wgsynFAivfkpkt7ttkQRamJBcwI+xDmpaeC6dmsJ5GezfIbuwHlu8+EWbrvSh4QfJJ+O+znVjxwywZxJkb9vs1rlV2otRUETZ6tNjGK//wja2BHGme+Fns0=
Received: from BN9PR03CA0892.namprd03.prod.outlook.com (2603:10b6:408:13c::27)
 by DSVPR12MB999261.namprd12.prod.outlook.com (2603:10b6:8:41b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 02:15:16 +0000
Received: from LV8PEPF00000068.namprd03.prod.outlook.com
 (2603:10b6:408:13c:cafe::30) by BN9PR03CA0892.outlook.office365.com
 (2603:10b6:408:13c::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Thu, 15
 Oct 2026 02:15:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 LV8PEPF00000068.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 02:15:16 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 21:15:08 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v4 4/7] crypto: ccp - Factor out the release of the SEV firmware buffers
Date: Thu, 15 Oct 2026 02:14:06 +0000
Message-ID: <d7eb100a9d91641e24f3a03a01f746d20204983f.1792014060.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1792014060.git.prsampat@amd.com>
References: <cover.1792014060.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000068:EE_|DSVPR12MB999261:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ddc7784-0c00-406b-f908-08df2a622786
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700016|376014|1800799024|23010399003|6133799003|22082099003|18002099003|10067099003|5023799004|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	cPpSP9HjaeeFgz4lPyL+kvRtKuKNF9pukSHwGEIMiH+ZYxGvN5fkjW+sRgwkV5NgF4riUNZrvvi7Ye4BaDk9f/GAyZTdEIzxjkcE+jkhXzcpxME9UP4sUHnjaGC61rEdVt8NhqN9y4Y7T7o1FlTpAIafSYuNwjs8p4rmr1vndxHh8MfcUPw/JrETWlHUtCylHtzJugqz+bBxSKaz7Kp+BS0JU9SXPtZRbEcfqCyoS2PF8He7vKktb4jyWtOMyBLsS7UFV70LtaYb22ivXwWWj4oRp/+CDUN/H0mbKMNrEZV9bU5Gbk5PL3/8evHVlh4Ti/r+iMvTIb1GSwenHb9T1g5bd+K9qHvOUJ7qRFHINWAfHNXYDW9qTgpZ7xhoQLKrLUqSkukcHhI9DzTpRc07BslD9PebQ+XGIInSaI+ZyBjhefKEC46qS4T9l/i1ZRsezv+VCIm3BCunK+2phaalEp712uDImFuTR1EVqU8BR4J4QncCl/ScdHVSVrV+SarPOe2wZhJhMFUE2kgOaDaXEvhRNSI8Fs+ZIYGokDyORyQvynPH2jb6hTMPVpja50rJEZkkyt5NGoW0FfqXqOPsDu/eQbWv+20zfL9ehQrRcXE0FmQzeYvjb4RXyevO+cWhgv2gnTlN1PvjC+wVaKda2ztS0/J4tEHpOnU22iLuLqgEUBi9wtowQ+ZZFIaUzvQXP4tOq25Y2dKtLFULYaQF2A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700016)(376014)(1800799024)(23010399003)(6133799003)(22082099003)(18002099003)(10067099003)(5023799004)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	P8uKnImz2gK80aD7RP+8i0MNfiOSWAFD6if4QCFPB/4i9ytxN7xjA9k3dWcAQdzRdbWvbWBfgH6WY8ZIr0+FdmABlPdtS+CctRTpVcnXgYuVhyNZXeHf8gX+cvhL22JlY2I/PiH0mYs784KjvRgf7o4MQW3PB6F/miTyBKmCcoAy+dWsZXV1L16mWLBbeU9tf5BbTGx78hEAXb+msdrOGdKIRlI/Rh8TnSXie8G4cGVYqYet9BSi/I3ZA1pwX8uu4eNtSOngLTBcCa1YRgbFkxPcGDqrXVTL7NcfMWscp7a8bApYhHqgHE0cvCMsIDaeps38CCcKNOK1Yd7tDjcnbxdc5VY8UFvpkEcyju5q+/2Kw0qHhgVPKqOKgW9YdRBQhFXr+lwxQum37dKhhWryu+LHgD1pInaYeyry8MmbQvyNd5IaguRia467QAToHmzZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 02:15:16.7818
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ddc7784-0c00-406b-f908-08df2a622786
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000068.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999261

__sev_firmware_shutdown() reclaims and frees the TMR and the INIT_EX NV
area once the platform has been taken down. Move that into a helper so
that other paths which de-initialize the platform can reuse the same
path.

No functional change intended.

Suggested-by: Shantanu Sinha <shansinha@google.com>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v3..v4:
No change
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

