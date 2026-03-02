Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011054.outbound.protection.outlook.com [40.107.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1994438644B;
	Mon,  2 Mar 2026 21:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772487449; cv=fail; b=WbYm9UCYbTAFn1EaQQW1a8hndDtNMUrNheRP6/e6DOviKQxJ2/0ENqGRHLEC+d/4QvfxcY2Yw/7HhV2bUD006909j/Bt18qCOY55/G6eT6vKKgsQjvF7FxeVjwPybe1IeptOHxv0V3bTL5xrIFjYXwA3MkalcsVr9fD5+vn3JPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772487449; c=relaxed/simple;
	bh=Si+twPrre6YurAg23KNmjyuiw5GZjpJGDRjXFMGUtKM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OG/BTPIHDTKXx+qhrkfJ/DqmKvaC8IzTipnQAhxqJwPx7uJHD74DD8jkT+iR4rWv2ybgchrkdSNZWt97uo6zoX4alV7NB4wI5k0NYgedWZVyRWPQ8f9n84JaXL67YZprXWvZeFw5WzpEHJPZWDEo/tqILAJ0S3f6rwE6gpOUjEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iGkrW1w/; arc=fail smtp.client-ip=40.107.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iGkrW1w/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L2utOTupTHncaQ5M+blHzkNXNxCaGELbmRh1bLDqfFwiZUI7eH3BNc5keP3BC734IbURwFepfa9F8vgUx3FXbKHBur95ua9b35gRnUzTLswumDqxN0RF8x4dwwZcrYqZj98kUqHS8zENrbJekGqNUVpYeRStYSPlMosF9hE6XanysK38LN/C0jAq7ODCEIBF+IrKFRFOr7e5mK3ZlNkdKCR9Khvu67BoqYXj159gvGEqm/on4ZZGd5JT72IxThzFcITcqsTwKOoAUcsrOkbpTv1h1UjAe0NmtjPnHPj0NJv/WcpPmVXc5Y19agNRFNspWjgeiYyxWjHR7YFu1LaE/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycGcrxcAPFYhZRmBOLuQ6TnA+d8bTt5/j6eBtCtCA8I=;
 b=hmp5IYfvU4/H70f64rDNqVXAwYrH4pJQcpsMOlzC+z27u6TDyCNfXq2/TOO1iwtILt/Y4MM+Ppmkkv55owmGMOtAnF74UjbFZ4bps2MFNUpH6fvl5VveOABHF5cIbFiRtEqmk9BeztB6MtWYXQ7ypWWGTaLyhA+d/N52j8UUOSZWPIn8nTtQd4kUBdVdf36gciAnTOFupEgk2Y60oxH2jfxtMnERFkvlN6PQIPzdjAZGJkJ7pzEW/CpLKXiT/OiG90+0FhOD//kYGXTjOhxiLppW+LTqtYyfmh8SXmuVyh7T8VvYEGpm0aB5EdRwE1bE4FxHCGZQqEWXU94cE1RQFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycGcrxcAPFYhZRmBOLuQ6TnA+d8bTt5/j6eBtCtCA8I=;
 b=iGkrW1w/OrVmhID9tQlOqx5tyVc9FPH6I+Yz5fOaL8mTKHhLHQLhn17uAus12DyZRgLEOqUMrKUSVAiIyorCyusZxO5kVAEGcZ3fjQKiFbdhcSJd8l89x3paAmqZtk/pT9jSRTAQMOd25b7Up2PINLKPggSA6UN/VEsdCDL6bMo=
Received: from CH0PR07CA0010.namprd07.prod.outlook.com (2603:10b6:610:32::15)
 by DS7PR12MB8370.namprd12.prod.outlook.com (2603:10b6:8:eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 21:37:20 +0000
Received: from DS2PEPF000061C5.namprd02.prod.outlook.com
 (2603:10b6:610:32:cafe::8a) by CH0PR07CA0010.outlook.office365.com
 (2603:10b6:610:32::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 21:37:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF000061C5.mail.protection.outlook.com (10.167.23.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 21:37:19 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 2 Mar
 2026 15:37:18 -0600
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
Subject: [PATCH v2 6/7] KVM: SEV: Implement SEV-SNP specific guest cleanup
Date: Mon, 2 Mar 2026 21:37:08 +0000
Message-ID: <f36cb47197ccdc97acaaf7450ca31c116ba1f1f9.1772486459.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1772486459.git.ashish.kalra@amd.com>
References: <cover.1772486459.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C5:EE_|DS7PR12MB8370:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ba7852f-d16b-43a8-1abc-08de78a3e1f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	hFzwyeKTuzqFFMVQocjLrPPg/UvIb1sknPRJnzVozuYXMwsNlid64yYYI9tGJdJb15Rm+QZuGqitjXpuWz4ez77hpvkXHAo9wC6uKDKwPRtPmL2SEAn8BsfERjfCT1DhsJeMl7c/2KRAC7KrCfEQFpJgEfhjIs9bKsLOSp/4WCQoczrtF1qI/6/fbwrBo5Wohk2L97YwCNbO1DlJPyH1yH17I8MctGjuRcGiQxfW9UdIBOxqjLTxylfy8NTbTSH/oP8D/NPGQyU2OUgxOYZN7yFYCT92WXDrc3h7sEHKozMVNjmIdZBNz9N9AwFcnF4Sz2F0FJSW22bNXR7TkMCkx7ZQq3bGqoFJ1/hrztcI91OBCDcnOnyTF18/ejYCI0ha7iZKojP9SydQ+CfzQkCOhgtt8Sj3VvGh2BxyGi7myv2jWBgYSUEcl5IU5zBy9ntYehRi91kbQzjxrUnQx85ZKzBvX7ZDnytcOQZR4qmrdioxyEbprEnRdqLbVHRBwxWVu1VdvmpRdmKIygmpmfw2+9L9Rez9A839aywW+zgkbDQuvsTt7O0DGDKMTFO9VJh1zvHmk582oJeJm0Yu8x/gg122gow0/zt78Ahg6cFu1Wpazdlskut9TNKiXEM/WipLwG8OONK+O4ha6XYTaz6fT7AUc+42scfw8su4ueYr7otz/xC50vEPMLX0+L4azXqLNDV+v/N/FJgt9g47MR/VBOJg6mJgP4jOTRIwwFB/ZLrwZ3Wr/vmVHam6wAGC2M4IbJoht+FTDYyy4SdtxhZPr1PSZmJxU2ZHbfVpkukoS3NwRPnQLYfobzQKLd+H6kpmcILNY0i3wxk5KUogWrIKtT0J6+lG5gjymuQOo5j/ocE=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1PYeOqu+baRepGTNbo2N9HxEvTjb2MZ5OnYM/AsAHgIeUweOkkgd4yL7b5Dlkj4bv9ugd9R7kpBVqQ7xmpygmSQGARjj+6HMxOGuw18TsFuAFnL/wW8LKYWribQnPyUz4PjFdZY3WjMtMHLCz9ZRbRBOtREmayqJlO3T3HB3JYsIAFoBRDEJ99k9oVOJ1gXyBDXgP/WfzoNQxAX6ZoY9WX/PBGrnRM8Nk1rD6yiUAFU4IU1fDKO3JlCAE0wrYS+IpZN32g70zc8wBv8e1tI+imlJF8f7j0o7I3bzXYZDgbon0yjoQ84LHUOhdbGdqIJX6fqJJX5bSYEbvvbaIlt8Ez4h3NC4QgkcNT3FbVTJSXAJ+EpsKxewAirhzrnseAxXwLQHZHpr1mBGRXzEn6nS7te1euhHQIar/vq+5ofo00s/AVEscy8J/k36DamMhqKZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 21:37:19.8826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba7852f-d16b-43a8-1abc-08de78a3e1f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8370

From: Ashish Kalra <ashish.kalra@amd.com>

Implement the arch-specific cleanup for SEV-SNP via the
kvm_gmem_cleanup() hook. Use this interface to re-enable RMP
optimizations during guest shutdown.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/Kconfig   | 1 +
 arch/x86/kvm/svm/sev.c | 9 +++++++++
 arch/x86/kvm/svm/svm.c | 1 +
 arch/x86/kvm/svm/svm.h | 2 ++
 4 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d916bd766c94..fdfdb7ac6a45 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -164,6 +164,7 @@ config KVM_AMD_SEV
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
+	select HAVE_KVM_ARCH_GMEM_CLEANUP
 	help
 	  Provides support for launching encrypted VMs which use Secure
 	  Encrypted Virtualization (SEV), Secure Encrypted Virtualization with
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3f9c1aa39a0a..4c206e9f70cd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5109,6 +5109,15 @@ int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 	return level;
 }
 
+void sev_gmem_cleanup(void)
+{
+	/*
+	 * Re-enable RMP optimizations once all guest pages are
+	 * converted back to shared following guest shutdown.
+	 */
+	snp_perform_rmp_optimization();
+}
+
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8bc863e214..46526ab9ab92 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5260,6 +5260,7 @@ struct kvm_x86_ops svm_x86_ops __initdata = {
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
 	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
+	.gmem_cleanup = sev_gmem_cleanup,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ebd7b36b1ceb..443c29c23a6a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -896,6 +896,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
+void sev_gmem_cleanup(void);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
 #else
@@ -928,6 +929,7 @@ static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, boo
 {
 	return 0;
 }
+static inline void sev_gmem_cleanup(void) {}
 
 static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 {
-- 
2.43.0

