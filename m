Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792610782;
	b=IsLT3RH9gtYopPpCp54KNdQbKnlH+e8RcFoD2dUGAIc/OKs6xFzJ5FG9AnUZAF/8MxiI
	 191c4FCVxRF01CA2I/pEZgQlO8KvPPppz7fAP26S/M3dLyVEQ+GwhvUkt8oIDTyeCDqMh
	 OcLZVl4eyR2Fgn7lPPozWguCHHHbz0ahM7cI1RdxuFKSCB3sGAoWcBC7rKOFAY9Tjxwck
	 VuF8JkiSel4KLgIfBembsQLihAO8LmbKsxhEifmWdl6HWb3aSexjIVrLKWTksIouQoekK
	 hSnXA4rHTwBBcHPA3HI9OunBS7ebJy1xOEMieBvfo5ViC1qsXnO4hwNV7c22I5bp6LA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792610782;
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
	bh=mcKaZdg+gBbjlm94S0O5OMl/R0yup7Viy+iVgIn9Xzk=;
	b=sfH6KT18VFtWehWddEz1yrk7yOBxvELK5V4G7uMQazyUW5v6ACJcIVauD26AhF8h7hid
	 9i0ELCmKOQ9lBuyKjDWU323vlfFV5oiQ2KrkeUU/pAlKdWafrkPT+MrgIV6By55XHO3sN
	 dYZRmk29PWnk1VUomy+taORX4eAoqKoGmujVJGOWbX6g8k5AaMW/QdM2Hr3Tk9ZSE/wzA
	 DuB91IUZ4I1Q4CQkqJb7wPGaA99juq82k7qHopPe5moV4L8kLiXJA/eLXwDXXvwPGM5HS
	 VuNm7U567szrAcydd1TLjjIvEvf5YJysnpcdfKsx4VtiPbxsKUZjyTVsdqj/9B7rSdg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Rk3GUzxy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.19
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010019.outbound.protection.outlook.com [52.101.56.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADC3606A319
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 19:26:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ADC3606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Rk3GUzxy
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ShulJbjq8srNKbyMBb1RECk1Td0w3T3sq7okpozSod3Wmo4uK+XomtEGNblroesUML7JgPISTdAGdi6VFq+kp9lW4/UsPc+yuBYE8KJSZa/gjx2/8TWndrX7zH1WTvhmvyaiO1DrDgLh88x/8VZxLh6crvCoZabM1DxfNFuV7uuzYly/Up34w0oK2n9jOvuxJQr5ypwCPsXVxsq9tHpOvS+nIrGy5uW7U4jf4W7xyesbbIyQeFwvbLErPgPtNGe/AInMyKF5DccAhHYlQ2e/x5mkUZ/gYaoUTNadCm1uB6lvMG4/zeDqTZl+4dAWuaibyDw64jwz3V+gtfvVf+cXkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mcKaZdg+gBbjlm94S0O5OMl/R0yup7Viy+iVgIn9Xzk=;
 b=vdNdOCeDS5r4cx4yxAvgnFhTfUWogOiXcQZCwG9yr5tDfNAEGSVB2Sli1xaRlGQfns+FMz89HRK0CYt8KS/JUOvOL4iC+wmhKeMcuUN44IC+EAM20kPdYWV4S1Hni5VOJlcq6nz+DhgVlhBPH2hn1gjNameLhs3+Z+ghtUAivsTpUzOeEP44zUDfSJryPy2thGmLg2OJpZeIAaRN660p6EaRElB/gnYhxZk4WVzZpT2yu9taaNyxqRiJXPejs1/FqFQ2gKiVeVy3znoLwlqHv0pNmaNGgeR02XRBa7mbRn1s3c+IOj1oOhLKhbnqAs6bARujKKQK0w7Lvct0Wa6Tow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcKaZdg+gBbjlm94S0O5OMl/R0yup7Viy+iVgIn9Xzk=;
 b=Rk3GUzxyDB2+r4XEBvO/F9ajGA57JxAVOnVMmbO+x4hSifvwCM59TdiYZlVOp6bjZwCfOIJliIVCLlUU5NfSznHRNYYlE8Bhd5xUx4h2sc0gvn26WDtQ3hSGABxBR+CKQNKs508xYQJTyvLPbwqSCrXRIoEYuLBSLwu7ZPJnk+I=
Received: from CH0PR03CA0411.namprd03.prod.outlook.com (2603:10b6:610:11b::27)
 by SN7PR12MB7934.namprd12.prod.outlook.com (2603:10b6:806:346::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Wed, 21 Oct
 2026 19:26:13 +0000
Received: from CH1PEPF0005BD62.namprd02.prod.outlook.com
 (2603:10b6:610:11b:cafe::35) by CH0PR03CA0411.outlook.office365.com
 (2603:10b6:610:11b::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.15 via Frontend Transport; Wed,
 21 Oct 2026 19:26:12 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0005BD62.mail.protection.outlook.com (10.167.244.251) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 19:26:12 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 21 Oct
 2026 14:26:09 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>, <pbonzini@redhat.com>
Subject: [PATCH v3 1/1] crypto: ccp - Make usage of sev_cmd_mutex more granular
Date: Wed, 21 Oct 2026 14:15:17 -0500
Message-ID: <20261021192434.1924950-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021192434.1924950-1-michael.roth@amd.com>
References: <20261021192434.1924950-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD62:EE_|SN7PR12MB7934:EE_
X-MS-Office365-Filtering-Correlation-Id: 170add75-c2df-4c9e-7381-08df2fa92b0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|23010399003|376014|36860700016|10067099003|261021121427099003|56012099006|11063799006|261009223027099003|261021123027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	+wRAxhuOvKcqBeKTctg/7s7wIPfLNfTOjqXdm5ZrSmtPqA8zpZOA5pIppblzJrCTUxjmX3yfAR4dPDC2wIC8EGuQG0gJjYnRSv5M+4zJvQZ8dMAKFFgEqnTu3r6GTgjHqyjdAJysS9HVXTSeOxIU9tMASFeHjCq21yEE+9BIWFltMP/o8RwKYPztRTsxJ480K/ETb/kK0GpMCaP3GzsGKR7xR2l1Tdg3Tkosu1C89BT8A6zBmZnoo/FjTc8uNdA3KQ4p5kBAaHiCLlGfxwc5KQ6G/kjvAUcJLKc0CEbsgylGf2fhRAVFdES0z6D/MIZnjuecH5PupuRlX00ClYD32lKWlD2W3JpKW3lFU4MVkSf+mX7jUkIhZxt8XDFWt0WbIDrAQEfHOdtqL8YMGqkX9w2H7/WLHgWuiBS0EBY+V6hRp+tG/gk1Mxait9G2KUqoWCL2AZhcq9LteTnuvjIvyTSNza/TaDRjl3FKy/FUgY7OcVxErNZvibvjC5u4HsF2TtfVoLVDvoYIE9d9TdVQScG+tQjltuBWFpY2cZmTWlF6e7DUHhGO2zv5NE2r20fDwYzHkaYFBKY6/kTwJFnunkKgIUlRrW3CsGtDxK5CrvQ5UTvCS2+xqfYycNYshHSTr9a4wDDMubebUvRV4Met4uyNvfgroB59slPPhtAU96IFpNguz3bh3PWQe37yCioM
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(23010399003)(376014)(36860700016)(10067099003)(261021121427099003)(56012099006)(11063799006)(261009223027099003)(261021123027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BJ0810XJJHilQgf2RZwbMO02PzDzm06M/iM/+BrhyMuKEgqdEehUA7fJBioGtIjYZfNZLIfWwC7Jib0quopfxfu2PPAfOxmRLMGTk7dmBJfvNedP7L8QUESSDRchCXTA3CaXEbzBTfyvFbBusvqEEpFlH0Dk4o8C6jioScFPXfH8JaqeVpF5G+y8OHlOHdioEWkWML8RisdzIZS2HSBg53wzmGEuuyTbqWE+ZBZnu1dE1ACL+imUaYYicQqXY8BNZFgdApWoCJTnjpM4xu08vQVRKQNT/22DueVO8L9w84rvNhkrMkD0Fxnwt08sxWmtATTNlh5CUWfTkZL6lwmXwWByIFaifFZupJxC8apeV+8wzvqD6PkSw+a9AQ2FK7ADbtepbBdxWxe9q6AdZiuMA3NyDdpcYl124TL1JRtKcx0qZiyRSlvmyL78+JJto2MD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 19:26:12.7547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 170add75-c2df-4c9e-7381-08df2fa92b0c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD62.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7934

The current code makes very coarse usage of the sev_cmd_mutex; for SEV
firmware ioctls, it is essentially taken upon entry, and ends up
wrapping a lot of potentially time-consuming prep work that may need to
be done before issuing the actual firmware call, which is the main thing
the mutex is meant to protect.

Additionally, some of that prep work involves
copy_from_user()/copy_to_user() calls which can generate page faults and
unecessarily lead to potential deadlock scenarios. No known case exists
in current upstream, but with the upcoming KVM/guest_memfd support for
in-place conversion of the same PFN between shared/private state, a
special fault handler is needed that could theoretically deadlock if a
malicious user tries to use guest_memfd pages as the source/target of
previously mentioned copy_from_user()/copy_to_user() scenarios.

There's no reason to hold the mutex across these problematic scenarios
however. Push sev_cmd_mutex down from the top-level sev_ioctl() into
each individual command handler, acquiring the mutex mainly around the
platform state transitions and firmware command execution.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 101 ++++++++++++++++++++++++++---------
 1 file changed, 76 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f833cb7e4da3..32610677b905 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1914,6 +1914,8 @@ static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
 	if (!writable)
 		return -EPERM;
 
+	mutex_lock(&sev_cmd_mutex);
+
 	/*
 	 * The SEV spec requires that FACTORY_RESET must be issued in
 	 * UNINIT state. Before we go further lets check if any guest is
@@ -1925,18 +1927,24 @@ static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
 	 */
 	rc = sev_get_platform_state(&state, &argp->error);
 	if (rc)
-		return rc;
+		goto out_unlock;
 
-	if (state == SEV_STATE_WORKING)
-		return -EBUSY;
+	if (state == SEV_STATE_WORKING) {
+		rc = -EBUSY;
+		goto out_unlock;
+	}
 
 	if (state == SEV_STATE_INIT) {
 		rc = __sev_platform_shutdown_locked(&argp->error);
 		if (rc)
-			return rc;
+			goto out_unlock;
 	}
 
-	return __sev_do_cmd_locked(SEV_CMD_FACTORY_RESET, NULL, &argp->error);
+	rc = __sev_do_cmd_locked(SEV_CMD_FACTORY_RESET, NULL, &argp->error);
+
+out_unlock:
+	mutex_unlock(&sev_cmd_mutex);
+	return rc;
 }
 
 static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
@@ -1946,7 +1954,9 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 
 	memset(&data, 0, sizeof(data));
 
+	mutex_lock(&sev_cmd_mutex);
 	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
+	mutex_unlock(&sev_cmd_mutex);
 	if (ret)
 		return ret;
 
@@ -1965,10 +1975,12 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
 	if (!writable)
 		return -EPERM;
 
+	mutex_lock(&sev_cmd_mutex);
+
 	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
 		rc = sev_move_to_init_state(argp, &shutdown_required);
 		if (rc)
-			return rc;
+			goto out_unlock;
 	}
 
 	rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
@@ -1976,6 +1988,9 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
 	if (shutdown_required)
 		__sev_firmware_shutdown(sev, false);
 
+out_unlock:
+	mutex_unlock(&sev_cmd_mutex);
+
 	return rc;
 }
 
@@ -2014,14 +2029,24 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	data.len = input.length;
 
 cmd:
+	mutex_lock(&sev_cmd_mutex);
+
 	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
 		ret = sev_move_to_init_state(argp, &shutdown_required);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&sev_cmd_mutex);
+			/* No shutdown is needed if init fails */
 			goto e_free_blob;
+		}
 	}
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
 
+	if (shutdown_required)
+		__sev_firmware_shutdown(sev, false);
+
+	mutex_unlock(&sev_cmd_mutex);
+
 	/*
 	 * Firmware will returns the length of the CSR blob (either the minimum
 	 * required length or the actual length written), return it to the user.
@@ -2042,9 +2067,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_blob:
-	if (shutdown_required)
-		__sev_firmware_shutdown(sev, false);
-
 	kfree(blob);
 	return ret;
 }
@@ -2317,19 +2339,26 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	data.oca_cert_address = __psp_pa(oca_blob);
 	data.oca_cert_len = input.oca_cert_len;
 
+	mutex_lock(&sev_cmd_mutex);
+
 	/* If platform is not in INIT state then transition it to INIT */
 	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
 		ret = sev_move_to_init_state(argp, &shutdown_required);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&sev_cmd_mutex);
+			/* No shutdown is needed if init fails */
 			goto e_free_oca;
+		}
 	}
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
 
-e_free_oca:
 	if (shutdown_required)
 		__sev_firmware_shutdown(sev, false);
 
+	mutex_unlock(&sev_cmd_mutex);
+
+e_free_oca:
 	kfree(oca_blob);
 e_free_pek:
 	kfree(pek_blob);
@@ -2372,7 +2401,9 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 		data.len = 0;
 	}
 
+	mutex_lock(&sev_cmd_mutex);
 	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, &data, &argp->error);
+	mutex_unlock(&sev_cmd_mutex);
 
 	/*
 	 * Firmware will return the length of the ID value (either the minimum
@@ -2430,7 +2461,9 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
 	data->address = __psp_pa(id_blob);
 	data->len = user_size;
 
+	mutex_lock(&sev_cmd_mutex);
 	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
+	mutex_unlock(&sev_cmd_mutex);
 	if (!ret) {
 		if (copy_to_user((void __user *)argp->data, id_blob, data->len))
 			ret = -EFAULT;
@@ -2492,19 +2525,30 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	data.cert_chain_len = input.cert_chain_len;
 
 cmd:
+	mutex_lock(&sev_cmd_mutex);
+
 	/* If platform is not in INIT state then transition it to INIT. */
 	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
 		if (!writable) {
 			ret = -EPERM;
+			mutex_unlock(&sev_cmd_mutex);
 			goto e_free_cert;
 		}
 		ret = sev_move_to_init_state(argp, &shutdown_required);
-		if (ret)
+		if (ret) {
+			/* No shutdown is needed if init fails */
+			mutex_unlock(&sev_cmd_mutex);
 			goto e_free_cert;
+		}
 	}
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
+	if (shutdown_required)
+		__sev_firmware_shutdown(sev, false);
+
+	mutex_unlock(&sev_cmd_mutex);
+
 	/*
 	 * Firmware will return the length of the blobs (either the minimum
 	 * required length or the actual length written), return 'em to the user.
@@ -2535,9 +2579,6 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_cert:
-	if (shutdown_required)
-		__sev_firmware_shutdown(sev, false);
-
 	kfree(cert_blob);
 e_free_pdh:
 	kfree(pdh_blob);
@@ -2559,6 +2600,8 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
 
 	data = page_address(status_page);
 
+	mutex_lock(&sev_cmd_mutex);
+
 	/*
 	 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
 	 * when SNP has been initialized, the status page must be firmware-owned.
@@ -2570,6 +2613,7 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
 		 */
 		if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
 			ret = -EFAULT;
+			mutex_unlock(&sev_cmd_mutex);
 			goto cleanup;
 		}
 	}
@@ -2583,10 +2627,14 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
 		 * in Firmware state on failure. Use snp_reclaim_pages() to
 		 * transition either case back to Hypervisor-owned state.
 		 */
-		if (snp_reclaim_pages(__pa(data), 1, true))
+		if (snp_reclaim_pages(__pa(data), 1, true)) {
+			mutex_unlock(&sev_cmd_mutex);
 			return -EFAULT;
+		}
 	}
 
+	mutex_unlock(&sev_cmd_mutex);
+
 	if (ret)
 		goto cleanup;
 
@@ -2623,7 +2671,9 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 
 	buf.len = sizeof(buf);
 
+	mutex_lock(&sev_cmd_mutex);
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
+	mutex_unlock(&sev_cmd_mutex);
 
 	return ret;
 }
@@ -2632,6 +2682,7 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_snp_config config;
+	int ret;
 
 	if (!argp->data)
 		return -EINVAL;
@@ -2645,7 +2696,11 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
 		return -EFAULT;
 
-	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
+	mutex_lock(&sev_cmd_mutex);
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return ret;
 }
 
 static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
@@ -2677,7 +2732,10 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 
 	input.vlek_wrapped_address = __psp_pa(blob);
 
+	mutex_lock(&sev_cmd_mutex);
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
+	mutex_unlock(&sev_cmd_mutex);
+
 	kfree(blob);
 
 	return ret;
@@ -2702,8 +2760,6 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	if (input.cmd > SEV_MAX)
 		return -EINVAL;
 
-	mutex_lock(&sev_cmd_mutex);
-
 	switch (input.cmd) {
 
 	case SEV_FACTORY_RESET:
@@ -2754,7 +2810,6 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
 		ret = -EFAULT;
 out:
-	mutex_unlock(&sev_cmd_mutex);
 
 	return ret;
 }
@@ -3103,9 +3158,7 @@ static int get_v1_svn(struct sev_device *sev)
 	struct sev_user_data_snp_status status;
 	int ret, error = 0;
 
-	mutex_lock(&sev_cmd_mutex);
 	ret = __sev_do_snp_platform_status(&status, &error);
-	mutex_unlock(&sev_cmd_mutex);
 	if (ret < 0)
 		return ret;
 
@@ -3120,9 +3173,7 @@ static int get_v2_svn(struct sev_device *sev)
 	struct sev_snp_tcb_version_turin *tcb;
 	int ret, error = 0;
 
-	mutex_lock(&sev_cmd_mutex);
 	ret = __sev_do_snp_platform_status(&status, &error);
-	mutex_unlock(&sev_cmd_mutex);
 	if (ret < 0)
 		return ret;
 
-- 
2.43.0

