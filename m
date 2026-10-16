Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010009.outbound.protection.outlook.com [52.101.46.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9260333122D
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124136; cv=fail; b=oqHIXIeTq4qUUK+IR4i0yg6mHyEkD12jC1LoJwNq9Aj+iS6ZUuFM2Jqh22HNDeH2cX4FaEeKrBlY5VMKVOfVczkXi+T5XbyULUzKppd3FQ9jD27nnehSgsBJE5tzak/3qkoRO3eaI0WzVTywzkZwb3VV+B6AGbNr+1yCWeJAMJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124136; c=relaxed/simple;
	bh=2Ja8UQakLPkwVGH7+Tr4eK3HaWVXHuiFpuTXOt3qFkA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBbeSM+tIUIKJukOjk+BTeXZcuV9bOpNO22WDCaj+/qhG+eR8H5hYYr2CjdoS7qeTVYloZynCY3JUpfdVaur9hl9XVniRtQFnrCFSI4mjqFgRH/5N7EU24R6Ano88Ob5aCTMu4P0gGjtIrZK7YXwFhuqKU+K4TjoLgA2K6NlqOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yGyb4niC; arc=fail smtp.client-ip=52.101.46.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yGyb4niC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBcORGbVY+I0qaMtKrzLI4rSGwK0B8kH3C+429QT/3RiBQp8ryfc2QNUV1BY8/tMnuVzZPKBxS8qXx4j++FCGGDo5mxbfHqY8Cfn7bLXgrRI/0iM2PktaIo51DxzO2q0y9h2Ilu5PUyNzlyFcWgGmD0rv0tgsZikxzg15ImbgZOxt7fdbHHkpSLShP7HF8ZWK2Hr9pGmSQ8wBRpffuSsNlTpktjvAGenLr4J74ElS+b/SNRHLOo3813Tbe2G2S5m/uGZI23GDJtvYaCbLBLvlvS89hrjRYSbwlzLsSIqq3349kR+k6mOKnay9MSWzrkSO/oSml8tmWzJUAjsW1fgmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAU1v6vUNxuxVCgvIPot1bmJ13xWZH+Zb1OqbWxgZDA=;
 b=efHVba23AHaIqqQZcToSTABivgXHpLBbUmm0qKag5O+LlcJdLIl6zkTY1gPt0PE0U3RTvc8tx6Har9QI+FrB44/7B4wcU/OIIoTDL+TExXNlYeE1CWqoU4+tu00bvS8jLL018qVBeLrxufHxMkOUDhwGG4W+esJvFVhJDB7slc9ExthNwuP/XhGcGtGUUe+UL8IXXmM+0KZb6nubOXJN2B1LRvrpTCwMGOlLJt+ej0WNCLUOOitWxkhyz/3gEbaheKfLlAJF28BiDB6LQ7tMWVb5jAscUg58+a6uN8HEDEcoNWiFP1E17I+WFJKvtC+eX35nMvB9ufRvfFgjmBEp0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAU1v6vUNxuxVCgvIPot1bmJ13xWZH+Zb1OqbWxgZDA=;
 b=yGyb4niCmqg8w94GYxSlcvFroFT953yRLTRjRmh3PJ4i5kuPRtVpe++qAir/qGQiksPi72yNpbAE1h1/3RDPEB1cem12J0t5feIAJFOwVQsVeTxuY8t8e6DP/QjNFYNV4lL3M3+rlCPwXCJ2nxWO/YZWZ+gR3aSzgPVb9psuXhg=
Received: from DM6PR06CA0088.namprd06.prod.outlook.com (2603:10b6:5:336::21)
 by CY8PR12MB8242.namprd12.prod.outlook.com (2603:10b6:930:77::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Fri, 16 Oct
 2026 04:15:32 +0000
Received: from CY7PEPF000000F2.namprd05.prod.outlook.com
 (2603:10b6:5:336:cafe::92) by DM6PR06CA0088.outlook.office365.com
 (2603:10b6:5:336::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 04:15:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY7PEPF000000F2.mail.protection.outlook.com (10.167.247.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 04:15:31 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 15 Oct
 2026 23:15:24 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH v2 5/9] crypto: ccp - Use __free() handlers for sev_ioctl_do_pdh_export() allocations
Date: Thu, 15 Oct 2026 23:09:33 -0500
Message-ID: <20261016041109.1778673-6-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F2:EE_|CY8PR12MB8242:EE_
X-MS-Office365-Filtering-Correlation-Id: 74378eae-417f-40cf-3766-08df2b3c1dfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|1800799024|36860700016|22082099003|10067099003|18002099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	bfopq/+vVX+93W20aWqRsCBD6fBm/CWQOMC9jZrKw3+Pnr6vPzJP0geH9nh2l46wi08PASNyj0QI4LV1xTBLJecAWC9m97X9SScGK7fElGtRc0NsLzNUCkLEICCdaVSTtNxB2jvMNetsADnpCYWMpoMLIRyGOCfWO0LvON6b4wPDN7jY7d0dWn4NK4MB/QHh/QAcixbbBTB6QPt1YnQ0mbTIUASq88UVWUkUMJcT36XrpJSst2SroWHPQsewJLUycJJaaEUumQqFCwLuPVsKJ9bZhD59xtRV9kgxznqtIqYV6Wp1DWQZhUd22+0GYeA0YpuZSuVEDqoK/i4lY1ImJYXtA11fzMv9Qw6hZpDhniAxhbZ9+NIps2/qoqRhJFnt03kVa/Lgm3T0z910xEAxrwNY/c6rY3RIeV2LrRZGDFV/NxUABo8Xj4mDMIYhs12QqW17y/N1RB5bzrnMXf4C6Fp1agxtoaEdO5O8GnbxLFB5TPctD6+QPOoWi3acpE+J75yqgil6ZR2Lp61as3uU6EigPnIefiIFOn4rUFdKK5HdeQPpNlt7J06Pds66wnQ+S7zMB636CE6Fdxp4DJUUNecyr6/8nkv91StDT4JLx1aBK502aAdHMl+MipYMgNGSsqOI4VKTXiiRBCJj5Rmnxgr0p5C5+QDvAh5T6s2nQYT/NDQHPB1t+m7bS2zipg85LjqeIe8zIlMUUmSgWxUhzg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(1800799024)(36860700016)(22082099003)(10067099003)(18002099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mF1NvbW7pV/umEQs5aqfUuzAUUpH/T783Ea25EyqLhOiAHbivqAKdL/RB86ioktPc2vMnjTMTJ3Von26sN1t7F79e79zV9OWq3mAQ0QqducQAqAbvNW8tstRKXFt+F0K2omU4ZIsmdUlD3LkYo+OecrYPhpH8A5vuvrvhvWXdMBgdrZGf66E4/minweqE0aL9st0INR+T+Yr0krLHe+/GwSKw6pHvXVcYiMYfXOaQC/CWApmmWkhe0EDA2PSZ9Exspc0Gx6SKKT3wJa6TO44WMQ2a9uiumYy1EQBljWic4CNz6QTB2LRx4O68ZQn88VjPrIz8Cn/3ns34FL3/VjTzc4YUx6AD+/1nBzSgyApniz90p98xl08jh+FjAV6MzwOJkcZlS56aGclNZXIq/kuJRrqoId0ZlsEtDTDsiOHMlp84PS1yaFMxCY6P+H7XCyD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 04:15:31.0177
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74378eae-417f-40cf-3766-08df2b3c1dfd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8242

Make use of __free() handlers so that the related goto statements can be
dropped. This is in preparation for switching over to using mutex
guard()'s.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6b483bdf0f0f..bea3c30f00b0 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2434,9 +2434,9 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
 
 static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 {
+	void *pdh_blob __free(kfree) = NULL, *cert_blob __free(kfree) = NULL;
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pdh_cert_export input;
-	void *pdh_blob = NULL, *cert_blob = NULL;
 	struct sev_data_pdh_cert_export data;
 	void __user *input_cert_chain_address;
 	void __user *input_pdh_cert_address;
@@ -2474,10 +2474,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	data.pdh_cert_len = input.pdh_cert_len;
 
 	cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
-	if (!cert_blob) {
-		ret = -ENOMEM;
-		goto e_free_pdh;
-	}
+	if (!cert_blob)
+		return -ENOMEM;
 
 	data.cert_chain_address = __psp_pa(cert_blob);
 	data.cert_chain_len = input.cert_chain_len;
@@ -2486,12 +2484,11 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	/* If platform is not in INIT state then transition it to INIT. */
 	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
 		if (!writable) {
-			ret = -EPERM;
-			goto e_free_cert;
+			return -EPERM;
 		}
 		ret = sev_move_to_init_state(argp, &shutdown_required);
 		if (ret)
-			goto e_free_cert;
+			return ret;
 	}
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
@@ -2506,32 +2503,24 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	input.cert_chain_len = data.cert_chain_len;
 	input.pdh_cert_len = data.pdh_cert_len;
 
-	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
-		ret = -EFAULT;
-		goto e_free_cert;
-	}
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
+		return -EFAULT;
 
 	if (ret || WARN_ON_ONCE(argp->error))
-		goto e_free_cert;
+		return ret;
 
 	if (pdh_blob) {
 		if (copy_to_user(input_pdh_cert_address,
-				 pdh_blob, input.pdh_cert_len)) {
-			ret = -EFAULT;
-			goto e_free_cert;
-		}
+				 pdh_blob, input.pdh_cert_len))
+			return -EFAULT;
 	}
 
 	if (cert_blob) {
 		if (copy_to_user(input_cert_chain_address,
 				 cert_blob, input.cert_chain_len))
-			ret = -EFAULT;
+			return -EFAULT;
 	}
 
-e_free_cert:
-	kfree(cert_blob);
-e_free_pdh:
-	kfree(pdh_blob);
 	return ret;
 }
 
-- 
2.43.0

