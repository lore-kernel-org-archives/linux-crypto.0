Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012035.outbound.protection.outlook.com [40.107.209.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD933E3DAF;
	Mon, 30 Mar 2026 22:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774909667; cv=fail; b=D7LeKsi9kIC4H5LELOwRe4JRrF/Ggb9DrmY4MEQ4U7zN84HYW1REDQtOob3HLe8/F6EkZudbWUMefmN0Ztk3spJ2NGLBJwKotblJFXX234hr9jq6yJ/olnnqYpfVnsgWCl01E2IH/CIN+n5D7VPTi1uGqhigN9RTH4k4rFS8T7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774909667; c=relaxed/simple;
	bh=WGCAr0cUAo5qbosj6aW4u5DB8VMz/aHu5h+piDlY2nM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QmfRtMyx8Bx8vULAC7d4hr04Ghe/h+8rGzQ7opirsgxIXRc0QcoNVylUlileSxDqh7O3svCVhyDcoxOksiMEmsmNxyKBjs5PQbb8MtJnq1MASE+0azpIZdwHJbVPTNUJsU7DHDTPlI1cNHAqK9+bq2H9BT/+Xg/WyANy0e3UTjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ECpwMiC+; arc=fail smtp.client-ip=40.107.209.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ECpwMiC+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dvyus3rB2sgqbex/R2YqCxiWlZ9TjOKb4lp4B8hJjmhLhNL0/RFNfs6EBQZ/1tVmsS2BfVnVKx5jOlZ/A3NGh9e96tBFzGdXx5GQdcb4C4qSaZTpJiixLAqWkhA5hXM8p/JZh4G5j5gqwJF2T0HFCVH9znlTS58VjiBEsrC67VVg3aBzx5ZS4H5U8qE7cv9n4FQKgCmmnvbaz/OLZL0chkVgd3YrUkE7NkWJogAV7abve9OTVOcR50+YtqoprqX4xUV81T0hflEIDSANh44SkXabbR1no1ga/0klmOQq45/DJBCdqg6GtJFNdh+QL2cXJw/rDwAWa/68kOOrsv9Erw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L++AwIDYl0OA/7Nn8BW8wpXNP7cgPvRKNQcYJSJ+R9k=;
 b=j1ord76Qpz3APT4a2xsPkRFJJE3VibK/Y4BYGVcp3s8Spy8yq74N6jpOcpDDaEgGYDDVZ8NZbJKvp75Y6+vBKCFoYrg402pGJAn1+4sleyYxthvhCOh7v/sT+NZNY8oBMEmF2rZhZJTMUmjWGzlYsFdLSmnHrbEGGAvGiwcDfKQzqSH+vuAlBBBeXRi2sNEAskZU/1V1huzRqWenf9HVGcOrsbtNqKZs+G5HrCt1s4DpVXYuEaLCmkgd+qTrjv0X00yjJHuRupJGp42xBZOyuKYSCZNUfC7A2cVo1k/0hdtmLKOOybiXIPN0gpco1siJfA/BP9qUitk8JUwL/gufoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L++AwIDYl0OA/7Nn8BW8wpXNP7cgPvRKNQcYJSJ+R9k=;
 b=ECpwMiC+jYdrDMTnrMT6VThP/F1uDpg1QmyYY46/dy+FmapDTspJ4G2KuJzG/vbcgdSNIfJi6tK3JH/fYFOnAcKMD+3/Albd27IOKXChnyCibC7Y/5SdvrV/lZmjbhfLsMrR/csXdQKfCcol4ehYtSLZsVFiB1rwTmPH5F3Xjqw=
Received: from BN9PR03CA0536.namprd03.prod.outlook.com (2603:10b6:408:131::31)
 by DM6PR12MB4123.namprd12.prod.outlook.com (2603:10b6:5:21f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 22:27:29 +0000
Received: from BN1PEPF00004680.namprd03.prod.outlook.com
 (2603:10b6:408:131:cafe::56) by BN9PR03CA0536.outlook.office365.com
 (2603:10b6:408:131::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Mon,
 30 Mar 2026 22:27:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00004680.mail.protection.outlook.com (10.167.243.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Mon, 30 Mar 2026 22:27:28 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 30 Mar
 2026 17:27:16 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 5/6] KVM: SEV: Perform RMP optimizations on SNP guest shutdown
Date: Mon, 30 Mar 2026 22:27:07 +0000
Message-ID: <b3566eb53194f1262dd74c930e0ee2f835733a38.1774755884.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1774755884.git.ashish.kalra@amd.com>
References: <cover.1774755884.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004680:EE_|DM6PR12MB4123:EE_
X-MS-Office365-Filtering-Correlation-Id: 2277fe20-bae9-4bd2-bbae-08de8eab86d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700016|376014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	VkYlGKvh/vUXfLFHd+Ygf+Hms9myfsLBqn4GP3WPcQir5HwvPYo/gkzMguqzxMd5p3EUnC5jCX4FPKnVSaePA3M1nTYgchaDFCb6M22D2LQs2Md0QDYvzSDd8CGcsRXf8wmZTXlpXC2RI41ELzICzga5iXbAQ1fQYeWJ7SRulG5HrXdT7yxh5/stsRah/f9cOUnrrpIHIvO9J9RlLYZbJFUzPYRWZj4wCVuKJOWUKY4G1Pxmi4FraGlzpMtADSbjMnJP4vfSyfL0Ma8Dk96+oLiZVRb0T3FIClXxfgx3SltwFbm8ZKBFcalZludc0OXQxfuHISqcvp0UQpsTWw6Bvn54hMKg0+/QrU4bGzFLEv71dCEyk6WtwiHc/z3TMziFPsYALe1VoaKBVm+Ul+8E4L0/oyTfQLwHePiCZC92oLDL+/G1QIgwkdjbPtETrR4e2KyzBGi59WK91+6xqvEllztoYmoKaVcqzUOT73NdA5bewWONK8QSqa07XzxeX3U+qUtcKcm9+XdpKYqR0RjnpvQ2sOd1UdwUtzHVnXsD8STNZFcLHk6gQNr6jxfXiuNaMWvgde0i7VCXd7XxYKKJxHdQWkS7Ic5MPVtV8vOoMar4DZkviWxNGlyo87mUnGytp+Nv2MVmPrRvRsLMD3M0WhuqjigcJ+EdJl/P/a/8Pp47nYH7G33aCcBZjMff0acbGI3kVlxAz7vjNq+exwUAKRxZy/xlR83lq+FyqC/9RVy+DekwSACOfSZa6a4Fc+x4wRDf/uGQWH0beq8MKZ96zSIsnx/YOlrJdqqAismKfE4oovAg/zC29+5bjTzqgZbI
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700016)(376014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1E4mJ4dwcjY7H70SmCYWXqw09N7MW3B0FIeFRlko5qwONwU7EeGyy7lHnOqZluCIWzgDeJfjQLrS4fDIanJfgwNLV7wFHtPPNuEqZAe0FhC/DjI8wDNwQqY8vmFuh1q5awFIZB+lA5EjXXOK0WPUP+YTkLgWbwkGhww3R5QkIf9cBslSzMynABYncP77n/xzCJe0JGQbi8b7eVpv3IN+4VhV5a7gU0dR2nN/xoKaYnmDG3IGiwz7VZGMt8BOezc+mtfr5JS8gsaansPXVVYD9LayzgZPAJJMMLHQ7noEb4MoNbCxpxufs0xHHV9pXx+z4YsGfAgMGl4zuBbqs2Q+Ies8WolmkNzX1wt0HMaLDeN2ZyfJDYBAxSYqXrUNfZqr+8l52k2L+G2kuyl1XAUxCA6e8iSWd0wmOmns0xGvo7EUFXC3yljTzje9JrHeYdtm
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:27:28.5268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2277fe20-bae9-4bd2-bbae-08de8eab86d2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004680.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4123

From: Ashish Kalra <ashish.kalra@amd.com>

As SNP guests are launched, pages converted to private cause RMPUPDATE
to disable the corresponding RMPOPT optimizations.

Conversely, during SNP guest termination, when guest pages are
converted back to shared and are not assigned, RMPOPT will be used
to re-enable RMP optimizations.

RMP optimizations are performed asynchronously by queuing work on a
dedicated workqueue with a delay.

Delaying work allows batching of multiple SNP guest terminations.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3f9c1aa39a0a..2ad4727c4177 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2942,6 +2942,8 @@ void sev_vm_destroy(struct kvm *kvm)
 	if (sev_snp_guest(kvm)) {
 		snp_guest_req_cleanup(kvm);
 
+		snp_perform_rmp_optimization();
+
 		/*
 		 * Decomission handles unbinding of the ASID. If it fails for
 		 * some unexpected reason, just leak the ASID.
-- 
2.43.0

