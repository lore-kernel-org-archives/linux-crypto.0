Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793216983;
	b=Y7PFWgM8Z40U7D52TTsLBzN4tcM51NqNuTZOVyDwHWuRYUjfehrULXbxA9q8nrsqJE15
	 dEYKKpZrf1zXqCT4LWUU5kKrlz54j1Ls9uraOPihxnudNxj3aI6RrSfc4Ewfs9Q/sZH6A
	 sY/LLxMJ+wl6S0ynAp+uDiBBpt6d3bz3gEfdIh2JjolUPT+GVJVAYXdbqUNnPXZSUwg1k
	 OMmR0w+GYP4LV+cDKuaEJMQqZv3oNF0nbZosnr7lEs73B6aRdfgoeZIRwKPqbOqafXFoL
	 Fz1fopReUmOvWx+w5SJ7HbJqg2QsISKAoHnclPRsi0Pgyb9MLk/Nr7t48b7pX87bg9Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216983;
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
	bh=OW8L/IoIg4FORQkXa/ausDpAFseLH6LMu3WsOCDFixs=;
	b=zEoLbYPiDZwf6KxPs3NA/Xntt9VEmgoU8P4aLjux6/yGPwv99P/PtnxM6V77ewhct2qj
	 ahz/JY02PMhOi3auaaxov7mPADc7gBM1RqZcLm43o1+io6zph89742jNzrn7eNwfziRga
	 wOEh2qPW9ok7M8qPGbqhJkqjHe7Fy25AcdBow6ryzrW17GDfTfRR72M/luFV427Mfqw1Z
	 6zvxBWOBkMVa+9+vA7lUwWhM/ryHAUArdDq/oBjenR1tvbRvJjwwPgicq/Mw217UbNxvv
	 CZ6G0SksFFIQ+2RMxMej25Eu9KVY3WFNBOJyGVGvjj2EoF5ibTIwG8hxFJr9rXy0zJQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Vn9yMq7E;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.66
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011066.outbound.protection.outlook.com [52.101.57.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5364606A31A;
	Wed, 28 Oct 2026 19:49:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5364606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Vn9yMq7E
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kFEFfRy4eqWjrsIH4N2C3NC6DlpM6YT1S3CAsk0um1aL45iBWjyoe2eC3entQosCg1BriW2Pao9qrF21ADih2y4UcmRTNyaaR3k6G3vDafK0g32siAVwj0yHpPo3Sg8HrsVKqsdjnksChi/hAPtYjzk36RsknCwH/b0GbeuIzsco2W6Gngn8lS5Kw6yr974vzJsJ48vf+e8X0y0awfx65DdeGlRA++KzdNh2+t3Xt6KsWLVeZ/yxwXC74IMzGy1alq1NOfDcSnAdvjhinPgitvaaX2XQ/dLoQfTRjqfHY8UKBlCZMFHVbYUANRdHkFnhQLrmMFV8gCG5aXfWrW4oTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OW8L/IoIg4FORQkXa/ausDpAFseLH6LMu3WsOCDFixs=;
 b=Qz1nnOTNci7c+ZJht4L8wFcbNICihoDMciykufLs06ITjP4A9cfxAfpOz8R/ZknaYzgIAvmC2esJFa1sp3sHcmz9Sk9SWnFCfGlJE5nwZmEmUeE2TckakIYq0qQeyk9Q5SJty4fngnQ/a9KcVvuf3AE+I9QTRwHq7nKspiL40AzQdAvjZJeXYmgBv385Qx/wG3a9C4Yi149n/jmdzLECTIjnDLVhA92gG+o0eGZ/ZhmiyC3rnYVa0PcxZOhFhucdYLZZmmxQw+cwHf1BlGw0NSfiY24xQiAvEhM9wJgKGhIYoXDcVmCCa3Bd6VUzP4CfFpfj29yYJ7gsN5nUv1/pGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OW8L/IoIg4FORQkXa/ausDpAFseLH6LMu3WsOCDFixs=;
 b=Vn9yMq7EMDqhhOWDkCyxbTvT+7UDv/+wUcibw1eP8Wyk4o93Npv/gPomIIPCzKvQZZfO5/a4u/SYCfbqcsa5aHqO485ZrKYJRcVv/IS8DXqq4iWhOWfr8XKDpMHeHXPxg3mUSZRJPi9zMdN+JkVCb2xT13732yqMTUJofYfncTw=
Received: from CH0PR03CA0329.namprd03.prod.outlook.com (2603:10b6:610:118::19)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 19:49:34 +0000
Received: from CH3PEPF0002457E.namprd04.prod.outlook.com
 (2603:10b6:610:118:cafe::39) by CH0PR03CA0329.outlook.office365.com
 (2603:10b6:610:118::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.22 via Frontend Transport; Wed,
 28 Oct 2026 19:49:34 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF0002457E.mail.protection.outlook.com (10.167.252.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Wed, 28 Oct 2026 19:49:34 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 28 Oct
 2026 14:49:31 -0500
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
Subject: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is disabled by firmware
Date: Wed, 28 Oct 2026 19:49:22 +0000
Message-ID: <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1793216372.git.ashish.kalra@amd.com>
References: <cover.1793216372.git.ashish.kalra@amd.com>
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
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0002457E:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: c5e3c9c0-eea5-4bd8-559e-08df352c9773
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|82310400026|36860700016|921020|261028144727099003|11063799006|56012099006|261009223027099003|261026121527099003|261026140227099003|261022105027099003|261022075727099003|261021121427099003|261021123027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	tbDqF01YMA5hUyBkDY8uZ2aRgSugOMAn17kIo+9P580Gn+EoOxOiI0e96QgI5QaHH826d4MGGXPk1yfAaaTRTZWAxGARATtGrNS6HCoiIbK7/OqkXJl9dVH5PkwEzcpr8wpzHnq4TlJ2h52XtIJufgQaIeGQrshypj4W6lydUvGRMWcB8FfwCBf25jHRUVhgzNglegsQM/U2eS54AdJ8myle1idmCOt5TVgCxxoyJBlMxOrE2rdlR8n8VwCNEI8GsdcJLzkkpJ3QxAryllwj7WgpOdqjr89QcERZ4QNbnrkMjhKCbarDcPVfBDzN+7rGI/OL1HEwrhV4lAxY2VPCQjPEovhX0QEnvykrEa9/9JFEABqJoWJVDJqV3UO3aT1xv85s/JiOqrTjxxkeGbtEQg9HRuOX8yBy1AhrAVILo4C303LleILEQk3MkHNiApI2rU1mFBWIKrTe1G+EMXBSdrfLrux+9WXsia9/PlKGIIu+Y8+SW0nS3mvF51WwcTiDkwrdpesqfMArMm5bX8EYkWF+U97MQ4h17LF4m0YirncbuwRBOCGwhPT0VrVgjWongeaLdlWB5A5go8fK5BuEyAHS08dm60SrotD+FmJ3DFDnL3gQB4i/kGRP5iRvTSQlhNK4h3OZvq6utqr0A5v9gArftbr8Nk6XL+6tWCDI0xDAt5M/iC3HQl60Cig7Ac8qv51XK7SwKcPeJ8cvf8r92Kg+Ct6PnPer8Blmkkh1fHY/YEgrqC2s1jLBLcdoHAGP
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(82310400026)(36860700016)(921020)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261026140227099003)(261022105027099003)(261022075727099003)(261021121427099003)(261021123027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cjoFmQr5DCsrnJ9QNrry9JZ/z7y6M1iP7SHvIniLVGzpCFlyaG41yym9PqwyEd1xnLnn21DR4nAiIJJgDYd23T/hiqMyC/31IhXjU7Op9n4j+26RViG6wV456mUYcFpAkvNz5uEaoeG4FeSbrfAVMtD5w5aTEGo9AhXUu968307H8VOVL4cCTxJSUKM3HrVVfNu72Uw9/SOvpXl3Fsft2fn9QWxDBjEUpGRjkUwDvpZxAge6WpLiWpSebhZnAOwxuh30fTq1Gd0/hG9Ud+o7ZFgu81q5r3OiQ8mAGA6TyzRt3nNGdawByQieXh7tZ+WhWKZTDhI9asq9KisOTjkOGMwYZnm0FDAK/c7+WY14+bn2A8j/vGPBkfkHZSz1qEUR9woADbgCC4CoIt9ILr85S3H2v6PGz4w0xfkhxaV8dE04qrgfG90CrkPXfniQa4p4
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 19:49:34.5086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e3c9c0-eea5-4bd8-559e-08df352c9773
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0002457E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

From: Ashish Kalra <ashish.kalra@amd.com>

Segmented RMP has two independent states: the CPU *advertises* support via
the X86_FEATURE_SEGMENTED_RMP CPUID bit, and the firmware *enables* it via
MSR_AMD64_RMP_CFG[SEG_RMP_ENABLED].  A platform can advertise segmented RMP
(CPUID bit set) while the firmware leaves it disabled (SEG_RMP_ENABLED
clear) -- e.g. through a BIOS option to disable Segmented RMP -- in which
case the system runs with a contiguous RMP.

snp_probe_rmptable_info() clears X86_FEATURE_RMPOPT only when the CPU does
not advertise segmented RMP, or when the segmented RMP table probe fails.
It misses the advertised-but-firmware-disabled case: that path falls
through to the contiguous probe with X86_FEATURE_RMPOPT still set.

X86_FEATURE_RMPOPT is a CPUID bit advertised independently of whether
segmented RMP is enabled, but RMPOPT requires an enabled segmented RMP.
With the capability left set, RMPOPT_BASE is programmed and the RMPOPT
instruction issued, both of which #GP on a contiguous RMP:

  unchecked MSR access error: WRMSR to 0xc0010139 ...
  general protection fault ... snp_enable_rmpopt

Clear X86_FEATURE_RMPOPT on the common contiguous fall-through so it covers
both "segmented RMP not supported" and "segmented RMP supported but
disabled by firmware".

Fixes: 15d974be0a3b ("x86/sev: Initialize RMPOPT configuration MSRs")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/virt/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index bd70c4d0b774..cd0412b9d251 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -827,10 +827,10 @@ bool snp_probe_rmptable_info(void)
 			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 			return false;
 		}
-	} else {
-		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 	}
 
+	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
+
 	return probe_contiguous_rmptable_info();
 }
 
-- 
2.43.0

