Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010008.outbound.protection.outlook.com [52.101.193.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B05C30FC0F
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124061; cv=fail; b=vCpWlLxnx0CJ21861bcJw7R4EKLp1+kDAw9/5rJjfhuQKlPTSdbqKtMJlu//va9MM0UfNO1soqNrjDeZaemfR8ut4ymeIDMpYcfZMCES6Zn4qZncdLLz3nMJrbpWWZXVrmLDs95wRU1nv9sLQfzNgq9ULzVxKNSOa//uD5NNhTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124061; c=relaxed/simple;
	bh=b5sYm2jXtQO8OEoI4UEI1rpyKuPOZGUYEOanhkslb/k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ae5IvKkwdhzndhG1zrPCckQsvfeudN0XeVTE4Ft370tcpG4mHCT/tww2n9pMpr5PWsM5rvGjBcp7ZzhFKMqrE7+Y4eoEO+qt1hOq9dfVp9LOD/Z5suxmG2MsUqQOTYLadR4eAk6S06XtNe9CSu1aVa/iCkPTFSOnUOjeBFjQP6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SF8HNOV4; arc=fail smtp.client-ip=52.101.193.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SF8HNOV4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ByNGY+WQMSXTS2ntgYg9bkfXaUhBjPWiIZqe1BkZvDnMII7q8rCgPiMC4ZRFpo/g3J+98HK26o6a/yE0cG3JwLoRF2EYRogprbdptlC+k9KP6BvtOsWLB2hgiEJaCjMqcwMNiCOXdSkQTvaG6/ZK0bSE7GIW5cQJF6QEjdP1pH7RWuMVdE2KgJKAr0q/mh1p0s2foDvY2jjb2Dkmft6ZBlGECvMxovA9GZ66khrGRgJPwIRwFDqEDkWhEDDy8M9b5Uno9dRuiVQ6e3FXyGoedE00wLhaUZ024jT55vY/GZ23Lf9818noNLQ8HjFIlMMZloTvz23T98rgqQTCasKsiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlyWMPGB29zlXNb1+ukX/AfNHWmGzGVcc1X3dlvPx6Q=;
 b=MmcTD4VJuzIzEXjFnHWW1mGpwS6egxEuBiBP2J0DLmO4P6pMEK9x0okpEY7IbKEzgjCckoXDpVhtB0gxTHgUUohChWC23xK3s56x+nGL/Ls10OJnW2dQpDCTXDnU7WK+hQl6JtjuyAUqQO0stDG7DYDp+gQPhfzugc51qErrVXBXVAZUtLUk2B6tTbFNJxGDTke2uQNyAfe0nHApDZG6+xPvLMLHBgBrbIsAtcmJY0W1lW1rT6Op1M3Xncl+9dchV89wzBBRnv8HSIh6vUFZtLnqCeDjR1Xq0FLnlp+Y1BMwLg47zz3kpL+cDsjX6nXAaetM+g3JXiSxGai++JXdig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlyWMPGB29zlXNb1+ukX/AfNHWmGzGVcc1X3dlvPx6Q=;
 b=SF8HNOV4cpnYVYSoJTnTtgBxoivB5I34U1XAlbWb58aUMAyzXbsDZVHcCU7+zPr+opJc6t0D1u2wm97i0gOsx9oYfV1pdU1xuLHANzkSmn08P/J+QaZZrI69lJKMIqSTcr+otl61EeebgUjmVPiT+5wkR6uoq3CTxzFJh7qc7rA=
Received: from CY8PR02CA0017.namprd02.prod.outlook.com (2603:10b6:930:4d::17)
 by SJ2PR12MB7919.namprd12.prod.outlook.com (2603:10b6:a03:4cc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Fri, 16 Oct
 2026 04:14:16 +0000
Received: from CY7PEPF000000F4.namprd05.prod.outlook.com
 (2603:10b6:930:4d:cafe::80) by CY8PR02CA0017.outlook.office365.com
 (2603:10b6:930:4d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Fri,
 16 Oct 2026 04:14:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY7PEPF000000F4.mail.protection.outlook.com (10.167.247.152) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 04:14:16 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 15 Oct
 2026 23:14:01 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH v2 1/9] crypto: ccp - Shut down SEV firmware before copying to user
Date: Thu, 15 Oct 2026 23:09:29 -0500
Message-ID: <20261016041109.1778673-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016041109.1778673-1-michael.roth@amd.com>
References: <20261016041109.1778673-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F4:EE_|SJ2PR12MB7919:EE_
X-MS-Office365-Filtering-Correlation-Id: 81e47fb3-4c98-4a4f-4c59-08df2b3bf174
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|1800799024|23010399003|10067099003|6133799003|18002099003|22082099003|3023799007|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	TWmWywLp599LLRBuu5gQkalQ6MR39IjORxv+TMsVhqjklvDu2/lbz0GycSeFLk08iPbhUlIMVNCqYqg92yrE0SrjV7x1etVwZkAGd3NcNx4TzxWU4s3pXW0XZM3JlZjvQCnj8MS8DXNaXRyKmLkQN4VKmls4UTV0v+fNHdqlmTXAxR6pQa48TgUjTX8ZUKJHeGfG6XLlXffo7xFZQLqMoN/eK0ZNrvei7sLiXd69Z/EVx8S1RIKdPOl1A9TG2/v9Wn5y2tVJOeAqjSbfak82SB/yC2x1PT4yNwmCXjsHGHcD+Oh+o/0hDxFVKEshjdl98JcuV0LVH4vceh64YjCyhLhstNUu9zWhskDYGzaZhdNkaL4srYdQwjI3kM+g2Qjh/fq8lwzSs6hkXgXOCzhKZYwsi5WNmroFNHndBMARmS232ZOuQGqsVa5mEPBWH52Mhr/bUxQNhoYZErigWsNmVs7SZQBBArUZC0nDemBVHX0Xvkiict1Zo89Z/5nbbQXr8p+dy0LcxDQHJXgGsPD2JQi/WS4nYjM/v6+BX77Fh3UQM/XvvgKQ78gsFdo4bWvME9emlpD+rgFA2x6WtNrFtilIPcbO2aF4DCXoGd72cYmEamdZIO2CFUxx2SNM3vyNb0kGKmi5ubnEY5NbkiQoRfXRfCTPaSt4+3PC0xtSj7D2Wf+AZMneulzY5rRWx1+LmcLBEq6xDflBZAZ9NurLHA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(1800799024)(23010399003)(10067099003)(6133799003)(18002099003)(22082099003)(3023799007)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vhBED/a95Qfp2JryjqupMvkpN844SVkUvnsPlv7a8yXZheQ7tMjboiu+hGdIK8yKVBddr9J8eRBYZipqV2vvQH1FvAm5ZVnjvMaBpdiikOwTn2qzBeFTp7EtkHnofR44cUs6MeJU8pbm4Y/2Xx739V1Y+63zRYKeuuW3YfLL/24G5CKLcmhiAz7H6TW+IMa0oCRWXRZ9BYzDJ+yKqkvn/hXF0g/jKhSConP0L/KIQfwBWtK0hfKW7UYzJPW7Vt/2GE6r5+NSD+R60ZNeD5uziCvDYVtBZAPoEedNobWuoh0wU65RIZ02oVM7tqtr5iVVYRWsGFYano28qRoLPVqQKti62Vfu5r7OF/2MT8q/50zhUN0DJbQy0c6UqLUpA/Ao76Rm5pXnGCo2zPG5i0+31rMoXUfk0OR5uan24T2y0BEkDVpv16agVHUJ0bjsBBPy
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 04:14:16.3008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e47fb3-4c98-4a4f-4c59-08df2b3bf174
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7919

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
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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

