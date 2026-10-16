Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011032.outbound.protection.outlook.com [52.101.62.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618C53148D2
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124180; cv=fail; b=Jc43TS4QkxJ4cNV8HzNCAw8tgaSoErMfg8XWiue4EBrvtLeq4E0q6JNYB7n1pn163gOGVCEfToqBeHwgNXPRV8YEiGJuKZhR1zGHq6HMSu7bZ0alTA//6lBqFm44AszB0wSMKMtRKxtv0jnG1Ps/oU6Z//nfP/NA4VBodtzaYMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124180; c=relaxed/simple;
	bh=AbOKTAEG5VVXE/gNHeAJQewIwP/dV3e6eF/1okh2zVk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j6tmMMejSKZ56s75xBefh4l/W4Oz8bwi5CcACyPhUJP9nUQH+kUQ6ID+e4k6+/S6jaI5xS80IX7Ip5yE9zkONVo9MiW+OnusCKiR8aJ74b5V5Np3IBcaYGdFVuGBLrtU5lLkDIG+jV/S/iV6zIhDTqUu2k5r7iY4ORY7qjYmgm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vAogxcxu; arc=fail smtp.client-ip=52.101.62.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vAogxcxu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQnGr107TKSm23K3pDot/fg9yBUtv8VkHy9CnNeuiO2Gs6eJsXN80V3TQz+PJxxzYgWnCp2RMZ8mbs8quvrAz/2xoGP+I1ZgRBxgWzzm2tdQ3lhaO1PNiJY/uLZAVJtk+5LIaKJ17oQyuYYNXwXiXgrWUTCZmrPP7lfzQ9HGhnFTbGj9/gu7bf82yiCli1EUInyDoMIN48m8ghQmA9Md3s5+NpIEw/kf+lgPP2Kx5CEEez4vz0CL3yEJGsRpFOA3QBpsEEosl1jRy1P3rpKG+uqhHBsa4H7WcqAdJGddRdRfuMbSPaTkyGRimoVq3s9p1z6iwtAxGv+xOU+QcPWe8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVYbSssA5+oaxFDfFh1UO9XaaCODSA6G0rp35XvsvcQ=;
 b=oEBfFmLgPXlqBvotBLJN6z4Wprv5OUbeWFQTHGod6eF0tb5RKi5wuNSK6gJkNDk1TpnwcqdW0F0UYHdxOCHhEHbBIkakvprYe2WEK6K4FKQcZa6xt5HWy1NogN4+UMi/aUhjvYj3RJJVC7onlrYk7zvSBYANSdMTx4gAnZY2TxbOrWYnMjXmpyhKojlv5ZBWBwL4ypzI6gGKdzcFS+5yl4GKeO2adFR+6SI576vzFek+hFUDiA1aEk4nz5gDF2OFcuK84ycVx5e772GlC8uhrIcf/Syq05+KdSVw98ZWUJ7Bt4ubMio8vcRiO0XxKLR5NquzSfPMvdnLTYVU00pIdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVYbSssA5+oaxFDfFh1UO9XaaCODSA6G0rp35XvsvcQ=;
 b=vAogxcxuSoJ3QlcNugiBedYLQSmRs0ox5EtMZ/YEt1mds3wow1w7yZBGGiqIklH4T4rJXFnlK1V2q3ADXlFwzY7g55q+SJ2BoYPGuAabjmp48QYOLxYHEJpsP8xabq/IwtV/5zliF2qN3i6tLjXCxDk0jjmqUnbk3yHsb9QESRw=
Received: from BN0PR08CA0003.namprd08.prod.outlook.com (2603:10b6:408:142::19)
 by CY8PR12MB7195.namprd12.prod.outlook.com (2603:10b6:930:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.24; Fri, 16 Oct
 2026 04:16:12 +0000
Received: from MN7PEPF0000014C.namprd04.prod.outlook.com
 (2603:10b6:408:142:cafe::9c) by BN0PR08CA0003.outlook.office365.com
 (2603:10b6:408:142::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 04:16:12 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN7PEPF0000014C.mail.protection.outlook.com (10.167.254.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 04:16:12 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 15 Oct
 2026 23:16:05 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH v2 7/9] crypto: ccp - Make usage of sev_cmd_mutex more granular
Date: Thu, 15 Oct 2026 23:09:35 -0500
Message-ID: <20261016041109.1778673-8-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN7PEPF0000014C:EE_|CY8PR12MB7195:EE_
X-MS-Office365-Filtering-Correlation-Id: bf91bd5e-4467-41ee-15a7-08df2b3c3690
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|23010399003|82310400026|11063799006|56012099006|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lyekLqIus0If9bDQDLOsjCFezM1WbtXUpSA70ue3mTd9fzNhu5g/kh/rul2z+MiC2CPkGvaTTio6ogLZ1O4OJxX4BOb27zFtYgqbbyATHIg9dkd5rQfcAX1Ra4N4rSc6sqUPqvqZ6hfu/u0CvRvmADE5mPltVGJFA6uXm4lHCNfk5zEJUct2fEQQX5kVL0xB737jDGXWkvS18QC68ptSYobo0o17Q8n0ydQtDw8GzcZSif0GyHxCwhFO669XToDgV7U0/836Kn5Ie/isSyy2VIiohRY5rfaosBgKZHsZ0OGHHbc6ekAo+jv/jNDZZmPVps6/PD2tU81eTrpwt5iB1ddVokS5Z1+yrQTslwu7BJcmdi4Iuap7QM1DL9MW8z/tfjeVGbp/3xdbROVRil5SpSzptt91poQrJ73s7TN3NKkrJZFz3gz5rMh6IId3ybLB0hvfoOBMeM3JK6Eei4ecF81HH8f3Av8uSHLNneUB7fiYDd9SWADYTUAgKEuWutm7TwTpmCnn+bTnCKYbEXe9BR/rwjyJ3udeSexIkxHNXAfAbWZ8OTkooWWFbPpCmrsYl8q8EL7DrKiEormdXGlDyLp0gchDimIYEqMmq/6FRS3YFDibb/1bdUT/h9lw8MvUgrDss4+3tms/GfxupvAbL10KLQ15jtN48BOYU/yQqdbCo0QUD7qZ2vbeOyn6W8eJragD9f4s7ZFttsN2fdm0gw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(23010399003)(82310400026)(11063799006)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RaB/+7WEkGvAbiytpm3dZsSmRb/dpGqUHKWWZxVlMBt+5yQ676bOSV1JhKld/BNUAp0pzCWSbUcwilqmL7xx25joOu5Wx/V7W3001eKXMkKAmoqV8yUpQSm4q7hXG2BtjbDAsdrzrg4Ho2fuD4RytkH2GhRb7MoMtmpwaER9Ho/vGzZSckk1j9s95ykvdneUEu1y+uyCDrhb4dlqeHVAWccc32UqXHtWpedT/g8mHMUI0/moweonPpfqVMZcZsj0fyFxmp6Sb05BjEBdLSfVzGCNbjzMXaxfX5JG2nVP/AtK/F9jBi89R7de94rqoaSaj5Rwl7qcJAbQnNHnlfKy8k7YU9ttVRUKbuNZm7hks7mBpQoD4nVTAkGTa+HUpz9j9lrKERLyCan5GJG6ugh28Anib+PqH1Xf5kLQvy0iSI3j2uv9KMWMThsFUa3/7alO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 04:16:12.2870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf91bd5e-4467-41ee-15a7-08df2b3c3690
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN7PEPF0000014C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7195

From: Ackerley Tng <ackerleytng@google.com>

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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
[mdr: rework commit message]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 98 ++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 4375c0480e81..aae0b15a10d9 100644
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
-			return ret;
-	}
+	scoped_guard(mutex, &sev_cmd_mutex) {
+		if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
+			ret = sev_move_to_init_state(argp, &shutdown_required);
+			if (ret)
+				return ret;
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
@@ -2312,17 +2318,20 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	data.oca_cert_address = __psp_pa(oca_blob);
 	data.oca_cert_len = input.oca_cert_len;
 
-	/* If platform is not in INIT state then transition it to INIT */
-	if (sev->sev_plat_status.state != SEV_STATE_INIT)
-		ret = sev_move_to_init_state(argp, &shutdown_required);
-	else
-		ret = 0;
+	scoped_guard(mutex, &sev_cmd_mutex) {
+		/* If platform is not in INIT state then transition it to INIT */
+		if (sev->sev_plat_status.state != SEV_STATE_INIT)
+			ret = sev_move_to_init_state(argp, &shutdown_required);
+		else
+			ret = 0;
 
-	if (!ret)
-		ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
+		if (!ret)
+			ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data,
+						  &argp->error);
 
-	if (shutdown_required)
-		__sev_firmware_shutdown(sev, false);
+		if (shutdown_required)
+			__sev_firmware_shutdown(sev, false);
+	}
 
 	return ret;
 }
@@ -2363,7 +2372,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 		data.len = 0;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, &data, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_GET_ID, &data, &argp->error);
 
 	/*
 	 * Firmware will return the length of the ID value (either the minimum
@@ -2421,7 +2430,7 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
 	data->address = __psp_pa(id_blob);
 	data->len = user_size;
 
-	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_GET_ID, data, &argp->error);
 	if (!ret) {
 		if (copy_to_user((void __user *)argp->data, id_blob, data->len))
 			ret = -EFAULT;
@@ -2479,19 +2488,21 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 		data.cert_chain_len = input.cert_chain_len;
 	}
 
-	/* If platform is not in INIT state then transition it to INIT. */
-	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
-		if (!writable)
-			return -EPERM;
-		ret = sev_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			return ret;
-	}
+	scoped_guard(mutex, &sev_cmd_mutex) {
+		/* If platform is not in INIT state then transition it to INIT. */
+		if (sev->sev_plat_status.state != SEV_STATE_INIT) {
+			if (!writable)
+				return -EPERM;
+			ret = sev_move_to_init_state(argp, &shutdown_required);
+			if (ret)
+				return ret;
+		}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
+		ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
-	if (shutdown_required)
-		__sev_firmware_shutdown(sev, false);
+		if (shutdown_required)
+			__sev_firmware_shutdown(sev, false);
+	}
 
 	/*
 	 * Firmware will return the length of the blobs (either the minimum
@@ -2582,7 +2593,8 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	if (!argp->data)
 		return -EINVAL;
 
-	ret = __sev_do_snp_platform_status(&status, &argp->error);
+	scoped_guard(mutex, &sev_cmd_mutex)
+		ret = __sev_do_snp_platform_status(&status, &argp->error);
 	if (ret < 0)
 		return ret;
 
@@ -2600,7 +2612,7 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 
 	buf.len = sizeof(buf);
 
-	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
 
 	return ret;
 }
@@ -2619,6 +2631,8 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
 		return -EFAULT;
 
+	guard(mutex)(&sev_cmd_mutex);
+
 	if (!sev->snp_initialized)
 		return -ENODEV;
 
@@ -2651,10 +2665,13 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 
 	input.vlek_wrapped_address = __psp_pa(blob);
 
-	if (sev->snp_initialized)
-		ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
-	else
-		ret = -ENODEV;
+	scoped_guard(mutex, &sev_cmd_mutex) {
+		if (sev->snp_initialized)
+			ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input,
+						  &argp->error);
+		else
+			ret = -ENODEV;
+	}
 
 	kfree(blob);
 
@@ -2680,8 +2697,6 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	if (input.cmd > SEV_MAX)
 		return -EINVAL;
 
-	mutex_lock(&sev_cmd_mutex);
-
 	switch (input.cmd) {
 
 	case SEV_FACTORY_RESET:
@@ -2725,14 +2740,11 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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

