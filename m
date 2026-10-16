Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013007.outbound.protection.outlook.com [40.93.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0AF396B6F
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124116; cv=fail; b=m5QTblyJN/hRO053F5gIKKEJPoJ/06BA5+y5psdlS6MjQHcbvhxTvYxEKGE+eVBwYGRL6dnMeYg6mAbvD399WPrT1G6UuGsTa4pwNiJICV+5Kj5FYD5WPFNaLJaRKBVTG5zHAtGTilUsNjgol6lW7Yvi+HhoNuW7WTnVOAT01Nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124116; c=relaxed/simple;
	bh=DB2o/qRmCSYko/poxaSYPubs5zMWMRpFYQ8Kb6Ua/fA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YcoemV5a4cwSuHUj9AHRyqcfojbZBpkhzJf0CKV6R6yuwAukqRPikcht6XwsHd2uFA/3kM+IvM3uIzOwAwCEu+b8S+GKJrSYkIcUnRM5dNQdpu9+y3gIrlVHff9ZA9esBZ5n9wSQDOAPeIfnUqfrxF10Lq7VFGv/ZFTyDddCFiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LU512fVj; arc=fail smtp.client-ip=40.93.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LU512fVj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NNbd7grPJ2saAB+uwAgMrJ8yjdTvyyieieVs23td3QmbVVKhRPU+/idQ8fBQXpCqRN5eJtm0H5dE6r4DTQXXP8It3OpTj4FZG9DdPlySBxYQmVzSWpR4S1z4qJE3mtF12J8Rlk7mL4jgdHahqv0jgMGpHrmDYpbBjEdHsAS6KlmP/h6gEyoPoaU77ykLxR3Ox5ak54Fs65llVuMSz0pIWYPtPAYCT9Bm/DYdd+b+lIxTsdV4Yj/4kirTSnrZwPJdLXtAJQm1yab04D1QF2ic6rCmD2MB26zZ1JnJCHxtHCQbjzojf91cACtwEFADKB/6bnaC5qnLg+2UrUlMeYzmMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQX/7vmLFrP5Kt5ICLvQPOfSSulHfOtqcMU/8+1Y8Gc=;
 b=XX630CmHmz9XIEgFdMWtWeZxQFv1JgygDNKnx3dRodwLiSFRZT3Bm42wW2K5wvJY32zvVqmbRLXrq15oPCqI94TpVOOAezMte/ZW0jRDZxdV6mZhQfEr7SRqGHr/iN5HtBe3THCfXf7KX8Xlj/5rGerex6mh6vie+2+AerS8eNPdncU5iSxhGt0TqFN3dBDyIwYKC92ynlX2zuSNEP3nFQB0FQDbAyNAlexZtxc6GOSmqkZmCGhMlXwoQr25dgUd8TjM9XQLTmZRizrIEWf546fl7SsuiIWZyg7UDVr+sjH9kXmvr0rWmT65/r7Y+tEmhLFxhPPz6a8t/C4I47zn6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQX/7vmLFrP5Kt5ICLvQPOfSSulHfOtqcMU/8+1Y8Gc=;
 b=LU512fVjaS8CZMTve4xZIBqGBEEwoIFR4Rxh1YnkNahqZrWYk86dh8IV4Q9Y+L3j7Ni7ECu3J7VIVHhl1mTOOSdHnPMY8QfIq2130O2MH1puL2aKYLKAeLDXbqMTuPQiG3zVXDZ9jm/DluHn9F836eIuSfy88CTOGwwuzqB66z4=
Received: from PH7PR17CA0034.namprd17.prod.outlook.com (2603:10b6:510:323::12)
 by PH8PR12MB7028.namprd12.prod.outlook.com (2603:10b6:510:1bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Fri, 16 Oct
 2026 04:15:10 +0000
Received: from CY7PEPF000000F1.namprd05.prod.outlook.com
 (2603:10b6:510:323:cafe::58) by PH7PR17CA0034.outlook.office365.com
 (2603:10b6:510:323::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Fri,
 16 Oct 2026 04:15:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY7PEPF000000F1.mail.protection.outlook.com (10.167.247.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 04:15:09 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 15 Oct
 2026 23:15:03 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH v2 4/9] crypto: ccp - Use __free() handlers for sev_ioctl_do_pek_import() allocations
Date: Thu, 15 Oct 2026 23:09:32 -0500
Message-ID: <20261016041109.1778673-5-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F1:EE_|PH8PR12MB7028:EE_
X-MS-Office365-Filtering-Correlation-Id: 8762795b-6315-4845-e48f-08df2b3c116e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|23010399003|36860700016|56012099006|11063799006|261009223027099003|18002099003|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YlCwP0RPUnOVBSt5Q46UPUpgY0AQEJKzUHty5OUcD2FJ925ySnLsDNDIWDaGeaW6WvF1616pKDTgj7y7LJRmavteZ0jGzmbnsIrLGZwXz5G6OAY95v+NDF94iKrf0rOJ0yysUIwPzVWcV7lVLwrrpZOsv0zAgURHOAOfuc1C1961rj0Uu7d4w6H7wVpogQhCeBlDXfKhI6x3UL2e92tmFJiXLj7uU2p0l+3AHbTtnFy3JWOqyM4wz85Zv3ckGrQjT3tyQSy3i/lCyyrvY5DOeVg0HNZZGxmqBe4K+uExGaRro5pKgFfgh121CvqCasTcA5c89g6jIk6N9tpp9p/vYv2EUDMhIKZ/DTK4Cw2DFBYEo++UrrGF3DGt51D3D8PoQLGsHepYmYX6r/4c9fvYa0WKY2+UvAPNwGOw5MMPcAHMLV100h6HyWS+w8sNwIX8AWkhcdWeFcKmbPdCtORlw4bssrZnBW0WcQ/E42lBGFrisP8jpUzpp2N7my1CkVwaBcVM8d7twavnF0nmNBpVd6vi9O0Pl/ENjtiP5Uyoot004xhdpBfNfKA6xGqMO9fIVIP6C4j+37ERrN1Jo8VGyjlS4zSA1IlcjLFjPE5QMz+4EqlhL4H96hReT3qcwk698ogrXRXWOKTuPdVlbi9ue7AgXDfTAle/VYDb+GxxnK2X3HEwxArxVB3kIKrXGc/kPSJLcob/Kw5Xuk25EHMNDQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(56012099006)(11063799006)(261009223027099003)(18002099003)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0yybMetbksnH3kHg0YPjfFKcR0R9oYtQYwc7oPoJmpBnWFTUhboTkbwFbI22vXXKajoOF5OY5PXysKop/FhU/OLxyCskBMl2DoR4kEzpv2LEHctFSzCXXqTdlHu9fV2VT7no8pOhjEtE/XG3G1Non3yDGuWNFMs7c9/GtfCEF6seZOiAMaX5czpHoMtwn2piOFBe0/QHOx3SJpWZQZBri7MY3fINJ0aH80BxAr6iuTIWFnUZvY1XndPdPzXJI/JqBJzzSOaSk6DteCM8Rj172rl8MW1adF+8IBUEXJiiwJ8oNj9dF2Wc0cbvMZt73QenuzQ7eImtEXotPmXcFyrN3hxdMoEnaWb7x0cxQ0gC8Uq9+P18xRJFH3I1ja6lkqGlXb8l1ff1au6QkOIIlHOD4thhQTeMG6Ly/pwxIVL53MEQ2NttBPxN9IZMlb8QfEtI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 04:15:09.9577
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8762795b-6315-4845-e48f-08df2b3c116e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7028

Make use of __free() handlers so that the related goto statements can be
dropped. This is in preparation for switching over to using mutex
guard()'s.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f6d06242184e..6b483bdf0f0f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2284,8 +2284,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_cert_import input;
 	struct sev_data_pek_cert_import data;
+	void *pek_blob __free(kfree) = NULL;
+	void *oca_blob __free(kfree) = NULL;
 	bool shutdown_required = false;
-	void *pek_blob, *oca_blob;
 	int ret;
 
 	if (!writable)
@@ -2305,30 +2306,24 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 
 	/* copy PEK certificate blobs from userspace */
 	oca_blob = psp_copy_user_blob(input.oca_cert_address, input.oca_cert_len);
-	if (IS_ERR(oca_blob)) {
-		ret = PTR_ERR(oca_blob);
-		goto e_free_pek;
-	}
+	if (IS_ERR(oca_blob))
+		return PTR_ERR(oca_blob);
 
 	data.oca_cert_address = __psp_pa(oca_blob);
 	data.oca_cert_len = input.oca_cert_len;
 
 	/* If platform is not in INIT state then transition it to INIT */
-	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
+	if (sev->sev_plat_status.state != SEV_STATE_INIT)
 		ret = sev_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			goto e_free_oca;
-	}
+	else
+		ret = 0;
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
+	if (!ret)
+		ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
 
-e_free_oca:
 	if (shutdown_required)
 		__sev_firmware_shutdown(sev, false);
 
-	kfree(oca_blob);
-e_free_pek:
-	kfree(pek_blob);
 	return ret;
 }
 
-- 
2.43.0

