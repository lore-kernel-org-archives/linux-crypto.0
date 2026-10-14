Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012011.outbound.protection.outlook.com [40.107.200.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2D151A154
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 13:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984234; cv=fail; b=uJfupB5nSl1Z0lhOjkVJBMhXOA8Nf8wA9Tz+cOZEkG8CQaAz9gDBETsSdQ4lNJO3sGnlOx8mGYMC9kaCTJHM3Qitiu7tqk1kELa9CRKtKnxb4UNJOG2asgchokUFExPj9RFlutfMWEVSHN2qHj2G7OoI4CbuQMVvFBtn1WFQtZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984234; c=relaxed/simple;
	bh=56NW6Mfb+IijQCPRTrDcDyEt0ZYsFINqVc+jxeUsAuU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CSi0VrV3WDsg1FPwc1JOfAUeNhtmyxDmBK6xT/QydfO3oIzBBT7o2TNoJ+L7n5RYuPQU2WrA/jjSixPT3okP1fzEH4047hhFwumQd8ixCwSORBnL2NC/AlAkYFvac8NRuLeCAlpXHQnBIpLEEWjWFsVdgBJtZOrQNbsL3oWOnrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uhvJIkpd; arc=fail smtp.client-ip=40.107.200.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uhvJIkpd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hmY/1J24Kvp31vk3mC9DQFPDzTSCLQ73R8GY8jnMqqjgd9kFSUopTMFkBPyZmKpGAb4H2mpzDKJVFfA31eist3Mpx3NSUIZlG374nrxk9NBfTPjp+40LlCUJ38eFiu4aD/OH24FDlI5K5XJ+erc25UvlGvPoy0gsgYIzR4Si5w/uotzm9M8a2raxQco9oWkwsiupfD3aKQTaqJxytsHTEXl5byND+PSaAl5N+BIR/oLkKfNYj/Z3Qc5VtZLMYKFWI7YTXajDaGumpE4IWqQZqzTKl+a8UrcbjEKT2lCI5hxMmprLvAEUGWfrBrWnp3SGDYB9cGjew/II3xkexKgxYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGA2TN2oYYETbQjSzjpL7qr+28JefUrfBWoxjx/Amew=;
 b=ql0w38ql2iTZ2e/fjTMC1ww7uJab1SYsgxmFSr9ysN+xKRNTlvFpTTxYeesT6qrlUyNxPyQq1/AufzlrnOW8nS8wUhc7reXfmK6F+u6SQM+KRvwmCwKVnPdQ6EN79QMaRfWweNzS461QcINnCGX7wHCLkXyqW5rr6K8UHK4yOp/FAxRt5wJbrvNzxOB3EUn1MLGFI8KmE+W7T1nb2x6Mt8axytALGVn/XaS5T7mSyrq7H4yBguK0eNFn4vqK1CIJG7nz7Y61+nhCbr2yoQXVXUz1K2NuGzq6xxQfcnTqbjZnKc7gjY4koFwfqpC3QoAkBs8Ld8l03wUho6FXXSBwQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGA2TN2oYYETbQjSzjpL7qr+28JefUrfBWoxjx/Amew=;
 b=uhvJIkpd3SBOxI4SG0gxFCnWX2kxO1pm/owtxxOWxwCBUGglSgcItd8ps/cBMF0xjVgofKCKTf7MBwA1rLri6kHNkWjAxHts9ZwJGRVhCf4SNtMUtD+V6Eh5InJrm1Bvb6VgqKN4h7VCK6sn4KaM7O9oecLGrTteR4WOOK2s6Ik=
Received: from BY5PR04CA0021.namprd04.prod.outlook.com (2603:10b6:a03:1d0::31)
 by SJ0PR12MB7065.namprd12.prod.outlook.com (2603:10b6:a03:4ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 14 Oct
 2026 13:23:43 +0000
Received: from SJ1PEPF00002324.namprd03.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::6d) by BY5PR04CA0021.outlook.office365.com
 (2603:10b6:a03:1d0::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Wed,
 14 Oct 2026 13:23:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002324.mail.protection.outlook.com (10.167.242.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 13:23:43 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 08:23:36 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH 3/4] crypto: ccp - Make usage of sev_cmd_mutex more granular
Date: Wed, 14 Oct 2026 08:20:32 -0500
Message-ID: <20261014132145.1726322-4-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002324:EE_|SJ0PR12MB7065:EE_
X-MS-Office365-Filtering-Correlation-Id: 6adb8400-058c-4364-fbb4-08df29f65e5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|23010399003|56012099006|11063799006|18002099003|22082099003|10067099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	I6RMot053AQasEjYArOEjcGTil95b/bQ3k9fGgcosHK+IHvi8Wv5yIR9nyTHXUXdgY4Y65CUUujjw9QSIT3sOO2oeKYqWn/7tPQs5bCxn4at/eJNRqsLGDGPTu3NjrJDy0ZJL5mzoPD5fj+YurWcpFOvC64u74Z5nHzwBjc7aN4XAGUOaDfdQRDz8zEF5h0X71vyAcKYRkKgRA3Je/+GdFgvGMYRScJrvh3BdJwDHAjNE9otKhAXA/uRijHS7F9Lo8yv3HK+8rJWPfPOGMNOoeI76inQQsDbgB9PlwYB5WfydSP3XFS12+BahsOAsDvxanx48RU5HaIwC4x3IHYUlSjATezn5QJXTLRkRwTUADnYGVCl47Ul1Pc84A/dLwZDMrNzxfCOLymHjeMKkiKPliB1h0JvwS1ZVmeBUnOr5BuuhWr9LYdr4BUUaBa3M6SAMOLNS872Vs8E5zrnwxgE7/81YCpCvvxyxPSi2JR1vmLhE5GwBDxg7P+CKPQRV2dpVyiN1bM9qxxXrV3KC2ALes0Gp02zqefT+lwUOGHFkCoj7CY/suZ8/euK8Rm+JN8JDkI7Wc2vhfx9xM70lu7r8LTk6/GLHwQI8/Q20Aa7BAVEqs58eFHSnMT/GsNvJRqD2j8SyiJdRn7oFJqmH2rx3LWqPePi/VE4NSo/PLVYpP4RnjZ96I5Jsv3tTXQ+1vMQ
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(23010399003)(56012099006)(11063799006)(18002099003)(22082099003)(10067099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	p8sWlPxQvev4DPNJWrlpxyZAa9If6LrYuAIDbbjJXpJ2EXUolKNvrznS4xFrZt1uYW8lPx1zFbCwYI4qf3QZFTBq27EXMPDgnuWvbe5xGkJLhKDS6Uab7hHAcP6vl99Q2+csifRxwvk/XytA9QEzhH2BXny2Ju5CDCuqaIdGFGbeztkRymNgk76vsrs60FLly/etDy8VpzEr0YzHBb3ln4ZSjjEPiFLK6yeWwVDmAaPwiSZieaT7psW2eAcWS10pKWgjt5ikIKdHj9MaQWsXwoMSoI0IOEWbATR7JsmqJaU0RzkLHe5HPjOJLie7NeyRsZnK1cxHNjghZaf2UpjJUdoqX2eSUcH/Pg5X6mBCm9QQMJacLUBqEoKjMaUlBzXam8mApMgHwFkux1ZSRbyGNfqxDemFugz2d++rgm+pt1+7SC3g1JoEQh5LO4DwwkMf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:23:43.0405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6adb8400-058c-4364-fbb4-08df29f65e5b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002324.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7065

From: Ackerley Tng <ackerleytng@google.com>

The current code makes very coarse usage of the sev_cmd_mutex; for SEV
firmware ioctls, it is essentially taking upon entry, and ends up
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
target of said copy_from_user()/copy_to_user() scenarios.

There's no reason to hold the mutex across these problematic scenarios
however. Push sev_cmd_mutex down from the top-level sev_ioctl() into
each individual command handler, acquiring the mutex only around the
platform state transitions and firmware command execution.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
[mdr: rework commit message]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 98 ++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e42cf3aee50a..c8c229a6757c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1914,6 +1914,8 @@ static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
 	if (!writable)
 		return -EPERM;
 
+	guard(mutex)(&sev_cmd_mutex);
+
 	/*
 	 * The SEV spec requires that FACTORY_RESET must be issued in
 	 * UNINIT state. Before we go further lets check if any guest is
@@ -1946,7 +1948,7 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 
 	memset(&data, 0, sizeof(data));
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
 	if (ret)
 		return ret;
 
@@ -1965,6 +1967,8 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
 	if (!writable)
 		return -EPERM;
 
+	guard(mutex)(&sev_cmd_mutex);
+
 	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
 		rc = sev_move_to_init_state(argp, &shutdown_required);
 		if (rc)
@@ -2014,16 +2018,18 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	data.len = input.length;
 
 cmd:
-	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
-		ret = sev_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			goto e_free_blob;
-	}
+	scoped_guard(mutex, &sev_cmd_mutex) {
+		if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
+			ret = sev_move_to_init_state(argp, &shutdown_required);
+			if (ret)
+				goto e_free_blob;
+		}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
+		ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
 
-	if (shutdown_required)
-		__sev_firmware_shutdown(sev, false);
+		if (shutdown_required)
+			__sev_firmware_shutdown(sev, false);
+	}
 
 	/*
 	 * Firmware will returns the length of the CSR blob (either the minimum
@@ -2317,18 +2323,20 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	data.oca_cert_address = __psp_pa(oca_blob);
 	data.oca_cert_len = input.oca_cert_len;
 
-	/* If platform is not in INIT state then transition it to INIT */
-	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
-		ret = sev_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			goto e_free_oca;
-	}
+	scoped_guard(mutex, &sev_cmd_mutex) {
+		/* If platform is not in INIT state then transition it to INIT */
+		if (sev->sev_plat_status.state != SEV_STATE_INIT) {
+			ret = sev_move_to_init_state(argp, &shutdown_required);
+			if (ret)
+				goto e_free_oca;
+		}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
+		ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
 
 e_free_oca:
-	if (shutdown_required)
-		__sev_firmware_shutdown(sev, false);
+		if (shutdown_required)
+			__sev_firmware_shutdown(sev, false);
+	}
 
 	kfree(oca_blob);
 e_free_pek:
@@ -2372,7 +2380,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 		data.len = 0;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, &data, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_GET_ID, &data, &argp->error);
 
 	/*
 	 * Firmware will return the length of the ID value (either the minimum
@@ -2430,7 +2438,7 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
 	data->address = __psp_pa(id_blob);
 	data->len = user_size;
 
-	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_GET_ID, data, &argp->error);
 	if (!ret) {
 		if (copy_to_user((void __user *)argp->data, id_blob, data->len))
 			ret = -EFAULT;
@@ -2492,21 +2500,23 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	data.cert_chain_len = input.cert_chain_len;
 
 cmd:
-	/* If platform is not in INIT state then transition it to INIT. */
-	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
-		if (!writable) {
-			ret = -EPERM;
-			goto e_free_cert;
+	scoped_guard(mutex, &sev_cmd_mutex) {
+		/* If platform is not in INIT state then transition it to INIT. */
+		if (sev->sev_plat_status.state != SEV_STATE_INIT) {
+			if (!writable) {
+				ret = -EPERM;
+				goto e_free_cert;
+			}
+			ret = sev_move_to_init_state(argp, &shutdown_required);
+			if (ret)
+				goto e_free_cert;
 		}
-		ret = sev_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			goto e_free_cert;
-	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
+		ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
-	if (shutdown_required)
-		__sev_firmware_shutdown(sev, false);
+		if (shutdown_required)
+			__sev_firmware_shutdown(sev, false);
+	}
 
 	/*
 	 * Firmware will return the length of the blobs (either the minimum
@@ -2605,7 +2615,8 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	if (!argp->data)
 		return -EINVAL;
 
-	ret = __sev_do_snp_platform_status(&status, &argp->error);
+	scoped_guard(mutex, &sev_cmd_mutex)
+		ret = __sev_do_snp_platform_status(&status, &argp->error);
 	if (ret < 0)
 		return ret;
 
@@ -2623,7 +2634,7 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 
 	buf.len = sizeof(buf);
 
-	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
 
 	return ret;
 }
@@ -2642,6 +2653,8 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
 		return -EFAULT;
 
+	guard(mutex)(&sev_cmd_mutex);
+
 	if (!sev->snp_initialized)
 		return -ENODEV;
 
@@ -2674,10 +2687,12 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 
 	input.vlek_wrapped_address = __psp_pa(blob);
 
-	if (!sev->snp_initialized)
-		ret = -ENODEV;
-	else
-		ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
+	scoped_guard(mutex, &sev_cmd_mutex) {
+		if (!sev->snp_initialized)
+			ret = -ENODEV;
+		else
+			ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
+	}
 
 	kfree(blob);
 
@@ -2703,8 +2718,6 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	if (input.cmd > SEV_MAX)
 		return -EINVAL;
 
-	mutex_lock(&sev_cmd_mutex);
-
 	switch (input.cmd) {
 
 	case SEV_FACTORY_RESET:
@@ -2748,14 +2761,11 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_ioctl_do_snp_vlek_load(&input, writable);
 		break;
 	default:
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
 		ret = -EFAULT;
-out:
-	mutex_unlock(&sev_cmd_mutex);
 
 	return ret;
 }
-- 
2.43.0

