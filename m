Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010002.outbound.protection.outlook.com [52.101.56.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9543C282F14
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124156; cv=fail; b=M1Bq6FIKizojJ753Jma7j44qdvAN14TK2YhlHZsMOB7MedByXLc9oV3xiO1hJRFIxLDCcvOvaIrNcushut2fQhRQFn1PXmnHS29LIed4kfwwSreFcgWPatgR6tl2vgOxkJfVKIg7Siv2TyPST/QZTFN5L23VZt0GXSYDxPZdfG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124156; c=relaxed/simple;
	bh=Mv2nxFQ7bnSjr8cO5pvKUbAQRu4mzS+fDup7HlY8KVM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W0QOi/xbbJ9x1JHNv7SQv7WDUKvg3M3j5qnUFRaa/ABbw5Ar8aReXrKB27J2YI+x2N6wYpLvBWKf4YqXMxMATc1EF4qhf1fht5RGFBeOTSRzNwVgEHNiheV+gPHjyj7coaeynt837VGj3A2hhBx6Kh3r/vB4nruM39Gi2wY3nfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yAaGqzQv; arc=fail smtp.client-ip=52.101.56.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yAaGqzQv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WgcijF6IPXqhrgLxF93zJ1yEE+PpKWhtCk5LimLGXRdqUCpfj8lBETJelgs0AC9M65D4iZ6G9DbQR+qN6cpgmsosgr5u+viV+JBfl6KBDEqEAPC4vreBbA8gQzfUOOaFaWc2AUzx9msYGbK7MUW06UdKkpLSKSFGAAikMXeSjwimVuho6KXWnv8sCOs0YF7dlbeRg0FPp5lql+K1nGG2Zx6VVa+0PRXniS7stuk/tI8H7molezkyZJsVXeCYf/74rVcLGCiBYFEYJ8PtQrUykeMUXTgaWNlidNJF36dmWTKIWlu6/t8vcCUw0kKSBFykaCiBIALOATu6BG5daIqH9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SYJkqqhr3f9EnL/HM0IcUjGp7SrYmvUmWXDEMykK+Sg=;
 b=KkyV4uYE/NcLhnqgb7LMd2Hz6lvLLM90lzED3urt/QVVuWlcb8s0kmj09A8Bg5dOnNb5/TuspUXIdAlotNpl+vULe2oTDZNG/f1iVXcGoFvMu3Ju/p04GIlIelf2gILuxvmcgqBAnl8e4+XY63JkzGt+QBxFYbK8T0DG3YogiaPuErmi6rSubE60AugN7ppw76FUrQS2PezhL4nMkdqYvgcIazas58hjD3WyfKBJXxdqTi8Lx3lH6atyQo4Bw4vQs/kxL8vuOu/Og/zGCHgDCjyHmY5rmJVSGnokS1TsxCLOkuY0SoyOuq3Jp84+/LTZ8HyzxdyHNdS/az3eSJi1Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYJkqqhr3f9EnL/HM0IcUjGp7SrYmvUmWXDEMykK+Sg=;
 b=yAaGqzQvUg92QxKsEnV716zb5k0vufRPY5Dl+WtuUs027hqxgx1tDUKQNSDK056euH/iMWOPlMNJfnGjyZnu/3dXVvntV8Ky5huPDXltOWUJtGmf6aQueivqaO1/dyY/M9y2Sf9MfmyioGtyi1nWiBEFLiG63N2lE7WfngtVWrg=
Received: from MN0PR02CA0028.namprd02.prod.outlook.com (2603:10b6:208:530::22)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Fri, 16 Oct
 2026 04:15:51 +0000
Received: from MN7PEPF00000151.namprd04.prod.outlook.com
 (2603:10b6:208:530:cafe::4d) by MN0PR02CA0028.outlook.office365.com
 (2603:10b6:208:530::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Fri,
 16 Oct 2026 04:15:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN7PEPF00000151.mail.protection.outlook.com (10.167.254.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 04:15:51 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 15 Oct
 2026 23:15:44 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH v2 6/9] crypto: ccp: - Rework sev_ioctl_do_pdh_export() to avoid goto usage
Date: Thu, 15 Oct 2026 23:09:34 -0500
Message-ID: <20261016041109.1778673-7-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN7PEPF00000151:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: f2068b76-111c-4ee2-0544-08df2b3c2a34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|18002099003|10067099003|22082099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	veSdsg62opM/JDc/6vFPFH3TD3qFojA7+78yPCrqM10yesMZ0t6t9DwcZd7TWVvoEkpKM57745grHCnapNO+O6UJ756YtgvHWbnLRQxeejJwCZhxyoOlf+jW43/FbOfcPjxTpy1mx5YP9Y5TntKNoiBvebtJYv6xnbfdOOZrEFkyvcmYaBqa/x2oRUINzDL1a/4rEd784HHLq7mcbrGPJAV/34eS19pGoZsyzFAtEwCtEGNXU6+CFqwJUDu/arRSegi2UOeXQWt1tA/c76OKyd6IuU3mHbrPOlj8FnquRwdx+9XrQf4cqJeNHWcltcMiILfO/ZLZi0JdawE22uTDSFiK/S6BrKqC0aGD9hYuLGB7+FQOTzikOREOuBrJj5N4Ydd03dnLJ9Y8d8GxKPlMriKwOfTQeSjkHMSK6kmf66YFmPSRPOeQ832od95x7eCpiUhg2/v+lMKnUqmrBw39DMqJZkOeIsSrFp9vjyCNuYpsY/ZHU1AKtWt8IQ8BhcaA7P4bVdvI7LhWQGxTiBkdcpR4nIaOlF1h4gTadi4XQKW+uvuECKw6f6XQ5rpnIoTAfIoiq8jaw9VKI+dEYMcdCmdG2Ts9+aOvdIUBkSwr0xf4TLsQfU7Dcd9W5xMD5oLuqmW2MMBop1/YYp9bjVewwO8xvAxbhgVZC7o1wl6yxDocJOaXR68B1I13LeXNdR5gKP+Ei1RUCV2e1siA0qTk1w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(18002099003)(10067099003)(22082099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	P/RFs85+QlAk5mrvpu4k9r9Bi3uB9z+9oR9es5PZh0oPRF1yNsfyepdjrokQlAfA1kwkjDOuTbLKrNEu8m5xh++/zqXZrBynaxmxV6fpjHnoIPzn6UenPRt9+wEqNkZAza9H9jzqHPkN8QiP1Eahyzn/j/yXNDBD9Tr5ZJHTqTNOlCaNqiXpmH3fQ/PjAvHyuuT9mjFDjSwGA/caYrEy3gCXCqiZmZsBMy+SqzypnAjIw0kcOMgp8EWGNgBZSM2Gpr7wo2UHNk8BrpTNb2KZ+4PNsEgPQnJnqlbVhNx4PhFApxcYyqIMhNJe6PfcHXl5cZGcJhajnS4CUVXF62D71oWTsxrLnQ0G8AJWYMtdO01Vk8UsP6r3ljGkN6gycgerqKAlqn/UpyGqlEGD32Ks/NqLOVD2QAwQJKnIdkhAgq37AQhXl4eRmE42RxhIr4Qu
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 04:15:51.5540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2068b76-111c-4ee2-0544-08df2b3c2a34
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN7PEPF00000151.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566

In preparation for switching the function to use mutex guard()'s, drop
the goto by relying on an if block instead.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 49 +++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index bea3c30f00b0..4375c0480e81 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2451,41 +2451,38 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	input_pdh_cert_address = (void __user *)input.pdh_cert_address;
 	input_cert_chain_address = (void __user *)input.cert_chain_address;
 
-	/* Userspace wants to query the certificate length. */
-	if (!input.pdh_cert_address ||
-	    !input.pdh_cert_len ||
-	    !input.cert_chain_address ||
-	    !input.cert_chain_len)
-		goto cmd;
-
-	/* Allocate a physically contiguous buffer to store the PDH blob. */
-	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)
-		return -EFAULT;
+	/* Otherwise, userspace just wants to query the certificate length. */
+	if (input.pdh_cert_address &&
+	    input.pdh_cert_len &&
+	    input.cert_chain_address &&
+	    input.cert_chain_len) {
+		/* Allocate a physically contiguous buffer to store the PDH blob. */
+		if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)
+			return -EFAULT;
 
-	/* Allocate a physically contiguous buffer to store the cert chain blob. */
-	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
-		return -EFAULT;
+		/* Allocate a physically contiguous buffer to store the cert chain blob. */
+		if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
+			return -EFAULT;
 
-	pdh_blob = kzalloc(input.pdh_cert_len, GFP_KERNEL);
-	if (!pdh_blob)
-		return -ENOMEM;
+		pdh_blob = kzalloc(input.pdh_cert_len, GFP_KERNEL);
+		if (!pdh_blob)
+			return -ENOMEM;
 
-	data.pdh_cert_address = __psp_pa(pdh_blob);
-	data.pdh_cert_len = input.pdh_cert_len;
+		data.pdh_cert_address = __psp_pa(pdh_blob);
+		data.pdh_cert_len = input.pdh_cert_len;
 
-	cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
-	if (!cert_blob)
-		return -ENOMEM;
+		cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
+		if (!cert_blob)
+			return -ENOMEM;
 
-	data.cert_chain_address = __psp_pa(cert_blob);
-	data.cert_chain_len = input.cert_chain_len;
+		data.cert_chain_address = __psp_pa(cert_blob);
+		data.cert_chain_len = input.cert_chain_len;
+	}
 
-cmd:
 	/* If platform is not in INIT state then transition it to INIT. */
 	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
-		if (!writable) {
+		if (!writable)
 			return -EPERM;
-		}
 		ret = sev_move_to_init_state(argp, &shutdown_required);
 		if (ret)
 			return ret;
-- 
2.43.0

