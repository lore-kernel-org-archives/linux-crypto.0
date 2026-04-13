Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010035.outbound.protection.outlook.com [52.101.85.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFA62E9757;
	Mon, 13 Apr 2026 19:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109479; cv=fail; b=c9oEt6BwogzXRxG/VtU48meosFyQxAJ++7+74OKDoluTXeIvwpQP8JlUcHDMjvlOOrcUYHauDIhXhnidRsgWtPx5LB4k8GsTqvkRLjg8iPzODqekB6pi0sO0RBak2yiF2S7es6/HDF6/KfeVrA7Oyo6bTgrCQAquoHji3aMNfEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109479; c=relaxed/simple;
	bh=uSi9wvd89fsEsDgtIPsuhlOmNfEwu8pjFE/P3lE8A+8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MknF+IzCCXZVhOYOHK5NQ+bk4xHRIu3GkF8i6WVx4Ia2uPsxan0r4iRF3pT0f5SsuZ1/238Ug5kkLL+qCXZMfx1SleA8QNQg74Fw5DoMtgTNx6SGlEoQ7SPR/f4iiZ9Eq0qdN+5LzZ0ACx0clu4suf2K3nTkx8av9/kD3th4elY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mEei9Hb0; arc=fail smtp.client-ip=52.101.85.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mEei9Hb0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eP2tIQphmvQzCR4eetHbIt7XdjJD318Lnp5/Cg5eMvBCOfiqDBBoJ6NZyZmTmxSg9o2iN8CPBiE0EM2cd1byouc3gki9ARO0eVsROGAr0pMQRsm9pReKQI0IGZ8QRvS8iV1TuiUY0/eqH1+LxYjkJ/rgLq5rDaMjTFJ/atm4S5hZbrEVimTCs7hqt2S7CjXeoqIphDt0mV2X70BbPJ4m68AJdyPjzYaMSKVinEjNt5nEsEKeEcuy/MIPoE2ijJgemUadnQTgGjyn/ZMitQMe7SVx+ZI7i/cksdpoEyZkRZKDMf3G5R8HWjnHzAq2TOlKq0vfPYihwW0ebalBdNX9xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihHy9nXVeIhPEv832LlPNLLGT1cGgnmYnN+exR8gG4s=;
 b=HrzcE4ScPeafXVlXc26js6QVjHqOo9VoAjIpscmi7LcZHfTsZcScMFm9pN1HMAFWiE5dLJzXwpwnq5aY712yAsFLqWoqmvF1HF94Rxzo5c/f9T8yWbSP5Ie8pkBeRt7VVdta2k4GkYw3vEW2nE5a3M9ULVBK13fMH9/7NyhfWNvgjmhzi/hwdPou5mOLyE/s/lC1OL37jCGINUSHRSefRyv3IibK5WktvOhQQViP9O6OyEfmEaPEl05VTPnSdY+4+qJXD3ch8bxlA7Qu8/uq6BYfEehdad+lSlriljJ75fpUOUcGjtS47FGPJGm7vDbl3ZDH3PhKPk8pz4aRdJMhEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihHy9nXVeIhPEv832LlPNLLGT1cGgnmYnN+exR8gG4s=;
 b=mEei9Hb01GP796S9o7PPBx2RN6fxK/7uKUe5rK5N1gbbYlyAr6K2WLgkhCrydufj9vLjgnH++q7a4YzQvfUoHueowrdOsfvY5gAUHFJi4lpUCsM3C5Kz1MoOklpZCHaMghPdOmtjYJhF76p+D5YH6AkciPIMvwOhJs9IA+UTweI=
Received: from BYAPR21CA0030.namprd21.prod.outlook.com (2603:10b6:a03:114::40)
 by DS0PR12MB8527.namprd12.prod.outlook.com (2603:10b6:8:161::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 19:44:32 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:114:cafe::12) by BYAPR21CA0030.outlook.office365.com
 (2603:10b6:a03:114::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9818.20 via Frontend Transport; Mon,
 13 Apr 2026 19:44:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Mon, 13 Apr 2026 19:44:31 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 13 Apr
 2026 14:44:29 -0500
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
Subject: [PATCH v4 6/7] KVM: SEV: Perform RMP optimizations on SNP guest shutdown
Date: Mon, 13 Apr 2026 19:44:19 +0000
Message-ID: <0c15142ecf6689ebe31a9c0f6f331398fc04f6d2.1775874970.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775874970.git.ashish.kalra@amd.com>
References: <cover.1775874970.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|DS0PR12MB8527:EE_
X-MS-Office365-Filtering-Correlation-Id: 8100fd78-c90d-47c5-68d1-08de99951530
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|1800799024|82310400026|921020|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yt3UWAJ7Ta8vGFBUkwdS3dSiUH5r43j41zk6W6HldCxjYOsPCsNXc8v9zNkdZoOpygUqDPMh04CSCmbjUF1WVNTh7DOm2z/fokh1BcadL65UlOa9WaNBISfyNmulVnjNOiTR9JmQSfpPsyuQEu284YuuR56oj2Iuj7tBbT10lraFEeij8G7tnW3FibAMj8fr1FTwVAVNLwkBvk3RSg3HwUk3lBIFhYkPRyJg54FqhOnW5ax9BES3BbFv4el6NeiGESYFRtjvZncCM5rEvL4asIQeoGKg7tZ7bDTEeU3nI5c7Me4OGxeXqfUSSYgFe1pQEWqGS++7GqgxjuoMiHzcgOgvly5qnwIwAImpiyEKWuC/OVwg0fKLw66vs8rLZ2NNFkd5dATphLtjILwRrtAPfVFY5E2Q4k60XnM4sM1rHynO1SuxdWN4O4CFhsh641mb46c/LvY3TIFTww0MUuOihwwAC4ZDj9pei1zedm18F/cqHf7ZfCsLje/SqRVOE2RseI0NkYeflseq16FLoYZyFuZyaaNeHXc34cD5ccyEL+jcxmfz5yKnn4CUDfqvAj3xTFejsPiVxjU+IZj6VcKW/qLKccEH7txgbFf5aSzdjJPOnOs5bFpy6EB0M1sx8kZk8b0ESufC0M9ON8KGcrWHChzz/rEqh7PKqYBe5MzcUmgrSLrqij3rVzveHNmFpGZM4Jhhe7kZnPjaG9aAvXeCIk9n/VYUUwc4CoB4QctAZr5UV5JOVl19vBUlyxuPCqmWrLgR6kaLCvEtQkuKKFvqaZdI3Hl/M/dZZxKvMcIa64xpOPYXjmr2+RZlZb7y+59c
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(1800799024)(82310400026)(921020)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KO0n63lrORhIvObfQm+oC7i4umE73TCQV+4tQf31vOIz5VFEmVNU6wSO11bCdSglcT+FOV2ZdOIQkzHJ15Xihu5QgrT5IYUVDIkOAwm2W7FSJRFEH7qhCe1JM5qts7qzSZcq31GHuQe6M6t8XZaKROmJZy5wic5ymAR3xJRu+78/WejmRTHW6Oj+ksaSiNnDq0i/e8xc+zOpWQ11j/Qubh1Pa/ZB5TUPYGeqTMC+r4caMRA/kibxD44l9mATOesuoE591ozeVsX1+NFIRWRzg9XMkkIdgX/XsAChGMOR3AjpihOwFELTnysB67Z21l4mmtLel8DJjTNs1TtW7ZAlU3aM/OK40puA79guMjkSzPWb1KiUNiW3r3kaNTKW1N/cD77UpR2vAf2Eu1UQsQALVA+hRZjPy7gzGKyc4rizQDr85F1L4iw6hlOACzG7rlKG
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:44:31.6402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8100fd78-c90d-47c5-68d1-08de99951530
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8527

From: Ashish Kalra <ashish.kalra@amd.com>

Pages are converted from shared to private as SNP guests are launched.
This destroys exisiting RMPOPT optimizations in the regions where
pages are converted.

Conversely, guest pages are converted back to shared during SNP guest
termination and their region may become eligible for RMPOPT
optimization.

To take advantage of this, perform RMPOPT after guest termination.
Do it after a delay so that a single RMPOPT pass can be done if
multiple guests terminate in a short period of time.

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3f9c1aa39a0a..e0f4f8ebef68 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2942,6 +2942,8 @@ void sev_vm_destroy(struct kvm *kvm)
 	if (sev_snp_guest(kvm)) {
 		snp_guest_req_cleanup(kvm);
 
+		snp_rmpopt_all_physmem();
+
 		/*
 		 * Decomission handles unbinding of the ASID. If it fails for
 		 * some unexpected reason, just leak the ASID.
-- 
2.43.0

