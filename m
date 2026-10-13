Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012054.outbound.protection.outlook.com [40.93.195.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF74552759F;
	Tue, 13 Oct 2026 15:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791906261; cv=fail; b=TdspNy1xPeQzV9ffbnbgSWdArfv/k+v4fyxd7etYbHpO8NZMORMVs5Ahy60HPCHoxLWefM0rEDesWc1q4LteguJt065LnINI308Z96QW0NG9h7B1HMhlCGR3wAchiOxmdT6QPu0A3Mt3onpfmrDgUOKL347G+bWRKRAqkwDM9cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791906261; c=relaxed/simple;
	bh=5tPxbyKpDFkZguuPz4xfzO6I89Ifaq0C3zwCaGrQpoM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fOqXpqtv2JNxrs6Nb7fVUE6eg87ATj95gJBkxvfcpAxArt9IHOiIVRJOLNG3ZR2vy3tAqdHJ4AyWdtwiC8U8ixQtt7aHO9dP5aNVcM5wnjWDuIP7N+4JKlpUw6En3o8hiiqB6ZS7uG5WUnCr6K6ebbK3sHgo4K9/uWRuLq1/pg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YvcFZdTI; arc=fail smtp.client-ip=40.93.195.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YvcFZdTI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mR4BGrdw39pqqL2jXDcM+MhIqsjpmrCy6hgv91Lta4mL23wJFOlJ1cF5MZAXeQ0o0iGiefF3hfgd6UsGS2OxeXUml+/psqyT36EnVcQeLoYarX1hQKko3QFpgCpuX5iJ1J9N0hlwyNA1TpJtcTwA11hSP6GUl8Pi4X8UiZ/NGdQbxgm0QnesED2QrCgKrl6V/9wmWcMitp2PIKJRkGEyOID2vw11st0rjgeb5rUFRVoYfM3iMFXwS5VE7UnaGrdX9MotdFlN7QFgWA30AWTZ+lIoyOpw9WJiQaNueZrEosFf4YXVI2mLaIM1EiDXNUHyKfkRP8960+WxB11dt/ti5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G26C7JNcbKtbki1fte4Xtc8Pkhvwq78k4vDcGMFnWBc=;
 b=EuN6QQnK4vQf6bxSX71Oz56YlRhaHYVzNcg2km9YSq2g1e+A2o9OlGFh257Oay8cQq6suPAxhBvXpMU8yzbW0RktL1H5Qs0O9v/ffi6oUPYzIlz8vDUF+RQEhs/8ob6BhSK+70bbiaVVO5PD0q2CZiiag0cGWXRGjNqRbnAmaW/w6OXE1ZOPnOqUdVAB6knXBEhk+l3ne0fcaobcq/CPq1f4GJFcQ98yHe8i3v3O3wPadMv96txkeGlWxvpTMz7Nh8wS4lJvu2l85/cSA+N5z7plQPwQySluTn6Rxoe6/r3kf3awA/jDx6C+nLng5+Uf6grHw/105+Hp4R30jiyV0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G26C7JNcbKtbki1fte4Xtc8Pkhvwq78k4vDcGMFnWBc=;
 b=YvcFZdTIcNbf0HYAOwASu+PmE+U0iupHgVWQzyaDdMLMiwzh2E0lNPfvWz6UbGpQ1Pyv7x0o2ABo/O/LKgNTwENE/laEATb5/OynRCcTzSSJ9vl90lgiISYU940PD1n8c9A+3qUIVCJuJhwofdfssqZoaKyA8vk7soOSL/hoHBc=
Received: from CH2PR12CA0002.namprd12.prod.outlook.com (2603:10b6:610:57::12)
 by DS0PR12MB6534.namprd12.prod.outlook.com (2603:10b6:8:c1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.24; Tue, 13 Oct
 2026 15:44:14 +0000
Received: from DS8PEPF000000E2.namprd05.prod.outlook.com
 (2603:10b6:610:57:cafe::3b) by CH2PR12CA0002.outlook.office365.com
 (2603:10b6:610:57::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Tue, 13
 Oct 2026 15:44:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS8PEPF000000E2.mail.protection.outlook.com (10.167.23.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Tue, 13 Oct 2026 15:44:13 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 13 Oct
 2026 10:44:06 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <ackerleytng@google.com>, <jackyli@google.com>,
	<pgonda@google.com>, <rientjes@google.com>, <jacobhxu@google.com>,
	<xin@zytor.com>, <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <darwi@linutronix.de>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH 0/2] x86/sev: Fix RMPOPT enablement on non-RMPOPT configs
Date: Tue, 13 Oct 2026 15:44:00 +0000
Message-ID: <cover.1791905953.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: DS8PEPF000000E2:EE_|DS0PR12MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 0afaae3e-9bb1-4851-d6b0-08df2940d521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700016|23010399003|6133799003|10067099003|18002099003|11063799006|261009223027099003|921020|56012099006;
X-Microsoft-Antispam-Message-Info:
	0MUEUwa7yXoO/3wo+o+H61j/J3WH97WjaAShexg5kF0BpDhDw8l4L+yFkLaagXxHvqhQ3WM94oolIyt7wH6TbL1wnE9Rb0eyBFK7IJbbswZqsNWwgyyjGVnagqympFVvFG4IHI1qroUUNAJDFIodeJPAbY+L/R49zXJZgAdTEWMgCnFPzQKv5KDvFGKi42TaksmkoaFOLAb/hQV3pLfYHXhijinQXcvvy46D/5HBckQyU9zPgeB1u4HOhtNkFdR158zpQAeYo5gZDVx+22HMVmr2vlejyaW+W2qVBojW/Ug3wKCkQOXlzws1iyLSmai/Wta8TRh2ofvHe3uZdMMe2XWb2TT574FTCkV/+8HW02Z0Gen9AlhgrpPoOiTDdCLLDC12YAL6bfLklmjGHqmWPNFNcswN/xHJfn9EJiuKTKDHxhxBkDkyih9ebsfslXhyj4hi+CdnNcecH4xGNuH8eMst6LfL1muiYuXBiUdeXABoQpNole9YXwWNJujPi4MtIsh2TFcg+64Kv+hyIY55Bq+F0Ku/3JueGZIxQsfoDXItJkBrtP7VR9cfnCyBbW2VN7KsDfxiH3EVJqlXkinwcLB7g11dnh/ZGjg402UvRQ51zFue81qrw2ti/UNPWxkS2uP6EBb9YM/dlUj/8jXrZOe7p+9YI+AWfQR4i62+9zdtJ/38rJw5uQDB9Pl/ETAHSM6ZR0H2JV7+IbxAgztLKBWS2fDIGw5+meomuJQmXWGK6MiYcGvjvZpvPbm4nFlF
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700016)(23010399003)(6133799003)(10067099003)(18002099003)(11063799006)(261009223027099003)(921020)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AB13Tb4mQeZdnky+oyVXtzh5/BkAQseSiRVTlMD11MYVCU7Qr25ufkIamTc82pKvExExKXmqlBSRpIxG4rmtxUi+018BCKIN2tf+VJVvmU7dR2xnfL7S76GHtvvDfH0tAkUdB0LAXnr2ppFqQpNtW45bmhLGjPkwfG1iI8HP6xUk2scLqzQZlPQ/Zhb1QcBEJccu/cfbCZSuurSAM/vCW/ysbephUMjS92G/rchpRHBR7BATqx9JlRUVSgFmOc7UWZWJ7Ti358m9+GEL5hqDfjALxWXZkbcS5su9Rt+8pasTonHa8X1mk76JrABe2Z+I6nmrtDOYn4QC0+8dnVpGM1bXXzo/++Ia1NQd5R3EMDCAxiyk/eP4UCbVQIVj0x8jsbqkcRjZbYqfuyfCf1EYlaUoxIFknt5gBoHRr1dr1p1OcEBEvHQXBr1OBln0WJDz
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 15:44:13.9495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0afaae3e-9bb1-4851-d6b0-08df2940d521
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS8PEPF000000E2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6534

From: Ashish Kalra <ashish.kalra@amd.com>

Two fixes for the RMPOPT series, both for configurations where the
RMPOPT CPUID bit is advertised but RMPOPT is not actually usable:

Patch 1 clears X86_FEATURE_RMPOPT when the platform advertises segmented
RMP but the firmware has it disabled (contiguous RMP) - otherwise the
RMPOPT initcall programs RMPOPT_BASE and issues RMPOPT, which #GP.

Patch 2 moves the "RMPOPT optimizations enabled" message out of the
feature-only-gated initcall and into the SNP-gated enable path, so it is
not printed when SNP is disabled in the BIOS.

Both restore the behaviour of the posted series; the issues were
introduced when the series was applied (see the per-patch notes). Each
carries a Fixes: tag.

Ashish Kalra (2):
  x86/sev: Clear RMPOPT when segmented RMP is disabled by firmware
  x86/sev: Only announce RMPOPT optimizations when SNP is enabled

 arch/x86/virt/svm/sev.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


base-commit: 250ee734115bca1c1f7a38d838909aa83cce87ae
-- 
2.43.0

