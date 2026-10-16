Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012007.outbound.protection.outlook.com [52.101.48.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBBA296BAF
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124073; cv=fail; b=BXUtJ7e3Hk2I8yxXVeTxm1xPQYKPzcziVQHj7ICI6VM0XiNQ1qL31phFFqvYogG8JjE28nKDY5ugw7hAlZ23aC4B7/FgrLdCUsso/1yWrnI5A+OczUQvx9miB9do9hwMHIS1HeAznOj6OzvSXye03SO7Dh9pGtFaWCXt3lr9N60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124073; c=relaxed/simple;
	bh=k3u8MviTU5qUvy6ra+LhshlNY1ZN+ZhXp4Ym+ZoTMPI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s/k+JluaR1Bo1YllTf225ZPnOnuZagJgueQ3kjSZ9PZWk1bEvYnNl6b6DkYdEHKTgZkU6caowRPshR3cDMRxTCyiOR915dUMTUH0r+jJyRelr1FP7qE5j18txy0VWsRt23cpTNxHiIu246ofEcx7OgzbvZX6vN2zneLbmgAuwwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V+BB1QSe; arc=fail smtp.client-ip=52.101.48.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V+BB1QSe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YEvLUkJls4qmVXOgfmBbn+hZpuNwyrl7XcIXZg5Gn4vFnDL/vrFxs8LmYkcerFGeSnjq7uxF78e6QnWqEzWQlMzTQHAR/gD3kVigTcvd2pESce5jvzBUp9HQSChFzSG/Pd4JjtoyAgmqIPeFPG8ah4VmraIffPZHuu1Lsify1Ttdzma3P2uCsJyknJmeNzvxrRrXwKwUOUZzA8Li/wn+rumEaTJRJxQzmNCj3VcFFfI7S7FcwmLD8WKcqckqOxuE6sNPvo5+vNeR8IEBAKDvOLOBy/jFNUpHhiicUpBybLPnDk59EctvaR5OkjHGvpoRgYerLY5GMRACTYfiL+XwZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmklxhDmWxRfvyRQyIYwf/QuTIVDxuDisUq3S+hlExs=;
 b=QzRVDDfN6IOSB7WrS4/tHQqtP7VYiT/qw+y/rZFU+FesiE12+PaM00vUO7te9N5DABhQ198KaW4T9CU8UEHv5mCs8ycbnIJZlfPmlphRmbGWK6pSOI0aWi+D9k75iQcPDkFkOZY21rvIvrVnnolGeb98wR+wvQ4Fdtk3MqqO8I+qq9JSQPOJXpRPyjUju7qHGJUxs+xDhfA92Fj2m7ER5FgD97fMoPgeCjFvyiSymjP2JaYv1+1VSLAgf5fCIkymmAq5Un2D3ET7RkK+w89ZKRdP2Jisf9yqqQG9I0Z0IRXPHzZeuaK2FOWsUAVWy4tSUFo6246TLGsNJdz/liDLrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmklxhDmWxRfvyRQyIYwf/QuTIVDxuDisUq3S+hlExs=;
 b=V+BB1QSe5LWUOdKxIdSvVzC8jjqSn+IUWWVvstgH4CfgcUnSMH0xk2s97ivQQt4CBHAn3dBFWVMrnZpK9n6ngn06nIacV7sYfqSOVGPfUPS8ZTc4QBfZEjPCNKHb4ExpNa41wBiuZYUPmzI7+MPXnV9jssxgKP8taoiCzEz2jj4=
Received: from CY8PR02CA0017.namprd02.prod.outlook.com (2603:10b6:930:4d::17)
 by MW6PR12MB8959.namprd12.prod.outlook.com (2603:10b6:303:23c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.18; Fri, 16 Oct
 2026 04:14:29 +0000
Received: from CY7PEPF000000F4.namprd05.prod.outlook.com
 (2603:10b6:930:4d:cafe::2e) by CY8PR02CA0017.outlook.office365.com
 (2603:10b6:930:4d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Fri,
 16 Oct 2026 04:14:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY7PEPF000000F4.mail.protection.outlook.com (10.167.247.152) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 04:14:28 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 15 Oct
 2026 23:14:21 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH v2 2/9] crypto: ccp - Check SNP initialization state after copying user inputs
Date: Thu, 15 Oct 2026 23:09:30 -0500
Message-ID: <20261016041109.1778673-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F4:EE_|MW6PR12MB8959:EE_
X-MS-Office365-Filtering-Correlation-Id: f46f138e-49e8-4e49-3522-08df2b3bf8f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|82310400026|36860700016|11063799006|56012099006|261009223027099003|22082099003|18002099003|6133799003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Xat9EiaUAE4HdVVK8qX/znogsWrN36Mf80XALC4CtVwsWL5MWT8jNbJ7vrbAWcQgY/DYO4nCtZupuHHwe0NMQNkdj1lWvluEzwpTPBI0EMVZuYB9g08NAjrlQHveSIuiiUBSudmVOSM3HiaX1QSQ03ng65MkkDRUTZGc+RJayEx+XbFKaThBrhMTjUC/9GbXHARL7fuTSq8etT4JG2NDbOVOY00yLSKNAC8GSgmzCT1aLyOG33KeTqGZmSAqhhbXsxTV+XFcpeib8F1MMB0wbfvQEtMOeDj8v/of7IETZtGcdt/CXodnMP/Y/GrC3XI7Y9Ng/LsbxblB4doNX26ZMva1t1uhza656iZr7x42jyafp5sIDsP+Y5PD27JTRKNMG4AvvAYznA7PQmwaDW+sBCp/qyasEU6Nuz3OQF9XIaWLnkkmDu1cKVD1R1W6pUpuIakS74RhCI0nqczCwrmcPY0wmJ+S/p3vGdmMf+V08OucBeV/hdgjbUl1IxYOEiJzmqOIHdLXKl2fbq0Z5hUPIo4mTgTPKECappgxJPXoPa1GMyDNSIP6HEHFUP9LJhkKh2KA06vgzg8Y8URNT0HmKywWAB2w4FrV0JCZPpVJFDTkXGq6bQWvHzG/agsM0xgKMUZirl0AjhValP9/F2d7FMV0UaBYoIwfmCbQYZl8OOSoSJb/2oK2ON2Nyd+gLngpxq9fEg0PykELJ5VzaUrwHg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(82310400026)(36860700016)(11063799006)(56012099006)(261009223027099003)(22082099003)(18002099003)(6133799003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7KacmOVQ4cdsEzqEfjJ9e8KGQguKUM2t1OzJoTQs0zlUlceXNBo0bcKtE/F1uikpnmbVIKy9RePUZf0/SswG0MtQ8921bh5l+bJo/nA20MmuT5moHS0mjK4GwR9EIVJsg4SAcvpj1PbM4N3upSoIbA3ImgUUiWKl+WpDn7mRC77UxHECXo1zAzsuZyPox/sfskpv+zLKG4PN8Kf3obCqbwRPwaBV03x0nINkpDtBVb0C4iAr/srBAGIWCWSUcx9V1eGsj9N5mXYuo+EEIuxyHPZzrZgXThFWSJbxT5avFERfTKDNqI/BDYaa87RIvsHjd/1Tk8VSU+PiXNdGHX2uvXWEeDfl6GtdW4kKgubiawEXqNmm59O/v4ZiEigoGjWbG2OnUxlZdkqznShOz6lHY4n2RZTZmemQOdsPxFddVSyTBoVzymvEv0Yi7zjmexwb
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 04:14:28.8576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f46f138e-49e8-4e49-3522-08df2b3bf8f0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8959

From: Ackerley Tng <ackerleytng@google.com>

When servicing SNP configuration and VLEK load ioctl commands, the
driver checks whether SNP is initialized before copying command inputs
from userspace.

The SNP initialization state is protected by the global SEV command
mutex. To prepare for acquiring the global SEV command mutex only
around firmware command execution rather than across userspace memory
copies, move the SNP initialization check after the userspace copies
and buffer allocations, right before issuing the firmware command.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 7de3b6bf71e1..ed60f3db391c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2639,12 +2639,12 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 	if (!writable)
 		return -EPERM;
 
-	if (!sev->snp_initialized)
-		return -ENODEV;
-
 	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
 		return -EFAULT;
 
+	if (!sev->snp_initialized)
+		return -ENODEV;
+
 	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
 }
 
@@ -2661,9 +2661,6 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 	if (!writable)
 		return -EPERM;
 
-	if (!sev->snp_initialized)
-		return -ENODEV;
-
 	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
 		return -EFAULT;
 
@@ -2677,7 +2674,11 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 
 	input.vlek_wrapped_address = __psp_pa(blob);
 
-	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
+	if (sev->snp_initialized)
+		ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
+	else
+		ret = -ENODEV;
+
 	kfree(blob);
 
 	return ret;
-- 
2.43.0

