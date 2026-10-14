Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010027.outbound.protection.outlook.com [52.101.61.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79995226AC
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 13:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984222; cv=fail; b=ptoygNflrzKtUJ/81RkUT2cRxkUbQ9v6///8596GxO2YK8wM6G5lWOARVEoqSXu8oysyLHHckczpqPp1Gt1kNiGfkFrNuO6gCSDIN3SKtvxM5ngFTgZyzoWr7VHsqjgsem24frRph9x3VEjeZ1slKhCutq1TddeTH2nAlP2CbQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984222; c=relaxed/simple;
	bh=t1j/uxYGmv3q9nPx3aNmRKiC3Gefzei4oaxsAEjuIAI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bt9Fxj3Xh2JzgLRmGN9DF9lXXKew/K31Sm9MFj4cAkqw2hP7SOKEGi0AfKvu2e8+7DTioHnNiGZyFrlEa39g1ChZa5houi/6guLySUiKgbhvFm5j5GuIR5U1SFRJkyGj7763sL45ewJIPMfUjTTphtARWMyuBzvQqVMFhh6QI9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BbIF/0SD; arc=fail smtp.client-ip=52.101.61.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BbIF/0SD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CHhcdu8OM3/aSEzPjCuQJ27WgMJfxyKvqEM2AFtAZYwScm6Bp3d8DCuAwtbOXW6o12+XTbdzQJR0OhJSogbX9coaZtJhr6Kzxor+O3zlU+qXsZUpvI6mzfdguNaWNqOIaS4Sm26PyJnfCaKB+w9KLX1UPgE0qGfdbMRusgyCuS8EJL6h+bDymCL/nXQ9fQPqgLb7HHt1SFQlPjo3SHnjCt3AI+cJiGoR+2Omkdo1JrUiHOWoJag+itOLws6pJ71TNwsJfC2tnNcDm/G7Ad8EWkTGdg/SaQ60wvU7hJ5lCpfKmv1fQ/nwXsUzh51ikFpBhLM1GLc2QFALtuI8COzfyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9CdWRy51KTfZgM/dybcXlOj4lZda9U4lJCwR34pCwok=;
 b=xQhlwiVVjs8YDwCsDkmxdIjsXJ9IYkq/FZlVkCEVcfZTRjCaUsgWUa1MLrsB1E29wjXzFr7N8ZcAXbGgjuGK306Ld41AN7pDkbZWmcsjpY6TNXDSOeVSu/F9L7fyCWSjYzZqEUNz51wx72E5NVFZbFYe5Lps5dlq/AZlBPBTwkotCjkReVtnDh5pf8/cm5nRuimJUpciS33erozzO7J1vcEjhdN9QLlH/LdynamEQsGnAznxHKBiTJXyRrZhFzVr58Vc9e7902o+9iMV8e53Ug1FFsEyHCorIM28zGoR5xaN0jpUNPmBNER/ioogjenLetP40YB+kemPZdP2HhxAcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CdWRy51KTfZgM/dybcXlOj4lZda9U4lJCwR34pCwok=;
 b=BbIF/0SDIEd2Lrd3hPAUAkXHfbWJ6xAGS6TU5lNQf+0Bt/oSo1/Oewobi0/MkvQIqnOSdtWSuNnWx60nbs9kpVseG5AjHWXB9GVSxtVcZwQ8EEU9Hsm9GlTY0FtRnR8AM7ZDYQ2H7dmqJxEBDsovraaNZu5lOITPar7S6xAvd3c=
Received: from SJ0PR13CA0148.namprd13.prod.outlook.com (2603:10b6:a03:2c6::33)
 by PH7PR12MB6859.namprd12.prod.outlook.com (2603:10b6:510:1b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 13:23:05 +0000
Received: from SJ1PEPF00002321.namprd03.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::1f) by SJ0PR13CA0148.outlook.office365.com
 (2603:10b6:a03:2c6::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Wed, 14
 Oct 2026 13:23:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002321.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 13:23:04 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 08:22:55 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH 1/4] crypto: ccp - Shut down SEV firmware before copying to user
Date: Wed, 14 Oct 2026 08:20:30 -0500
Message-ID: <20261014132145.1726322-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014132145.1726322-1-michael.roth@amd.com>
References: <20261014132145.1726322-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002321:EE_|PH7PR12MB6859:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bd1c927-d872-4d81-94c1-08df29f64727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|376014|36860700016|56012099006|11063799006|261009223027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	1fNAAXaWpdsnYqWFtWqPKwghLDOhlFWDXa6vcrAbHMQ12ydwvGUpCMW0UAFxiaXRNKdcph06fPM8agr4QPnp6df+s4Kn6wB2hEb0QAbvbiIr7/YW2uyzfu9ytLsOUIEMe/AJna76wt+pcSsqZCUFttzaQsikLYCF21K/HK/tj+IgSxzaLSijdG8hk3NsCf+ZrNJnGvXxtVkBNUyNbgLl82gcWyFoGix/mjNQL5gSxcj8cvEvVo8o5VW5WwoE+BnN5NhjVnKTQ9dTZAKeOx49MKaCRQoVZ+Ia4EfXJ6oZisvsC6bqStbRUTyX041EqwWsRPpTN9qcjtMe3zXPVDnPe+6e4e+EsGvah1zYqwCd/6pfrQc8MWgKl8ql5cHqiguP30KUwukaLdYJrk1I36qpOOSMCSX2w8yTiuwj3wxyB1hi/PsmiM/YE21z4egcA31I+JOu8/XbTubOYXGO92M4x/W4eMMk+h1RgRY91nuyOOuPXDom16ipGYdjPLqvHcFEN1zHtWB1BjZ5bV4ko7zYiIBbxbtRvF+XbYGGo3Pup3XDn0I2mVQUKbnd2tftYYdBn/0Svn6h8nddprdADMBVhrzzpw0gtF6orD6uf/KVh6eSUAcVFnQs/RxVSWqPF+VJ1FYxxe4s2SPT/MVvb3dGSvZrvNGMNyQgshRpeS+79U4ChQP9bKazeB5RqvvC3KfV0gFL0LhYjMo2sNxhx5hmww==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(376014)(36860700016)(56012099006)(11063799006)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dxTyjfgTbMRfPuNFIuyoxdIjGefFkus+aYWB6XwMwcscMsgQ5vGS0iCqU90KI6fSWBeshOi0i3KM5nS1T6gCRzIevfJZlYO70QEz3UKzXOqxyUjbK53+1V7yWELPdifv7bjOggmVaPlo+xeKfoKC4YBFvwihpAR4CHGaX1KaszAZXbUtlKkJHjQRJp7Z9wrZvKS9jTn1V/Mg4LBFt8rn94I5ExPit8raHkuWF4gnyEeA05wdQ/VZn0+hj80L9NJi0K+n2mJMP5rah0bky/8oJGBCGGLkeja35Z2dxkAzCVmzm1QJsstJtBpTT4prgdxj3KiToPN8z+yRaoqdwq++4Et7x6ICGsYEh/vtnzWsitTtQ/mpBtMZFFTnVxjRHub3Kp8lMrDFNH5OMdfBu5Fn37T44+oHRFgzImuER0IQSP15WIsFH/Ehgyg6Ey+4/V8V
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:23:04.1371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bd1c927-d872-4d81-94c1-08df29f64727
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002321.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6859

From: Ackerley Tng <ackerleytng@google.com>

When servicing PEK CSR and PDH certificate export ioctl commands while
the SEV platform is in the uninitialized state, the driver temporarily
transitions the firmware to the initialized state, executes the
firmware command, and shuts the firmware back down.

Currently, the firmware shutdown is performed in the cleanup path
after copying the command results back to userspace. To allow
releasing the global SEV command mutex before copying results to
userspace in a subsequent change, the temporary firmware state
transition and shutdown must remain grouped with the firmware command
execution rather than spanning across userspace memory copies.

Move the conditional firmware shutdown immediately after executing the
firmware command, before copying the output buffers to userspace.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f833cb7e4da3..7de3b6bf71e1 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2022,6 +2022,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
 
+	if (shutdown_required)
+		__sev_firmware_shutdown(sev, false);
+
 	/*
 	 * Firmware will returns the length of the CSR blob (either the minimum
 	 * required length or the actual length written), return it to the user.
@@ -2042,9 +2045,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_blob:
-	if (shutdown_required)
-		__sev_firmware_shutdown(sev, false);
-
 	kfree(blob);
 	return ret;
 }
@@ -2505,6 +2505,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
+	if (shutdown_required)
+		__sev_firmware_shutdown(sev, false);
+
 	/*
 	 * Firmware will return the length of the blobs (either the minimum
 	 * required length or the actual length written), return 'em to the user.
@@ -2535,9 +2538,6 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_cert:
-	if (shutdown_required)
-		__sev_firmware_shutdown(sev, false);
-
 	kfree(cert_blob);
 e_free_pdh:
 	kfree(pdh_blob);
-- 
2.43.0

