Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=40.107.209.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793599941;
	b=JXaiJNquxK6fFUf4a1LyiYku9n8SlDOUB4OZWeA7rteZL5GNLQ0kpJS9Q+GQBhg4bJj4
	 /Fr0xxV5ftSAHu6TpfxOWSI+EBVDkNgwOOuRv9zj1Tp2qjhNJ8c/kZdEgVjElryBpxjtE
	 joVaoZhuJ70iOikiwhMOg3nvn18fNYmikVJOHzzgm+nduQdaYrjBJ+vtnHJUWNSks1X8Q
	 BeMh4q51USSBDUaF9o8JODGTn8OTdR0I603HttO5Yd0hOj5Xz5S1lnClx5YiZNOX21Ssp
	 mnuEF3nwaoEYtEVPXbh2do81zBc57IJNt20QLAJ8Yqa+Ok31hyfZl3plKR+1HZWE7qw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793599941;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=2BkXiysxqpfAtecds8Nir9eSmmd2A//cnazFZ3HDBwA=;
	b=poE0lWg9u1j34Fv3Qf3d9XqWShQsg/+tFZbTFZr7PJWsLT2eD44ix5xOhZ9KWPumifEu
	 W2jzGWivhRAq5UmVURgAiNI1hAFLHA94PuzyDNcC9WuLJeEi/3ywcAy1wqGRfoCm3NE6b
	 I262aRemYw58hJv4wpri1u7Z6tB+RxHtRL4tCnLUv3Xbc07l5LRUa7eDIBEbbJepJW1Li
	 13RWI7mq3q0Dla+OTyUTDWu8T5ab9qM2PuuaClYIaWlg/taRDBa49OLmuzYYTARCgyn+k
	 40T23Ya+zmi/9qRbmzxSGCkthcSu1fob+bi6QFzIdn5a8yQqfc67SuwmHXlqFDv+8Lg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ArrFIUSq;
	arc=fail smtp.remote-ip=40.107.209.59
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB49A606A326;
	Mon,  2 Nov 2026 06:12:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB49A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ArrFIUSq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PHy8sxJVWGy5qlCWGJR/hjGtiZDmXmzECR4Tz8CikL7AGW2fh5xWomM8RBk2QZc2Dqma2mtjpxOrF7d4CZsl+maU6z+Y5027V3K8dIDWuU3yAQGgil51wwHnaxh0FtVt+niHOkQhBZiLLKzQZuU5A5J9NO6dNy6ICFD55X5+TLWJFx0NeuPCtZjZ3Lt67UN4+ZidfkSouNhSOI6LMeYFfzlarz8dtisZbHp92pEfeIA3H6+VnmVUA8DvtqQnZ4wxCEwfxK1SHpFhp8pPZ1lz5l5bK7UCXHG2ZiRu9LDLYBQ0NaSqu3FbkQ9aCBNXK9XkMOmjO/GxgKCB6n2r/tlOew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BkXiysxqpfAtecds8Nir9eSmmd2A//cnazFZ3HDBwA=;
 b=R9jbGZktRxVmzPs6HVNkrG8YArkMXtfMywGKeBmQATnA0VcXavj+T6sjcqWL/Je/oZPp4XrTalsDwPk24BOnha832DqPOQ6NDhG7yNn9QBtBB8wvFapTnO3Ccy7S+8b3vm6VmsnIBSKBlyIFF8h1pQwV/YuRP2/mrH2dLS+U2jkLbMeruOtp0nmr2PLMetHOSqkN5EK2AuG0cTBLNyYsGAcxanmDBmijPWOgdPxSaKgILTLHsK5g7OQdN2KAcMVgvNTg4WLIB5u49Bjss773OH11ukK0rAB5THYBYb0NCiaEvO6sLp6oK9ge2KLk/sxht6W5Fg+NlYEN2v+ooYhUoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BkXiysxqpfAtecds8Nir9eSmmd2A//cnazFZ3HDBwA=;
 b=ArrFIUSqy8FvTyDAxSYdqj/PvxN9UIHqSxRg6/UNh1pP+BPXy9/jPjfibr9YpGXke3p0JysgCbDBmCxFZxBYj7apKo7fSxqeBisM01YiQlR7QAQoPxZlqf6XLkKzAheZ1WTZLeLwwY6XSduGSGtSlAVgEJJSvTKFtkOdsbClNO8=
Received: from PH0PR07CA0024.namprd07.prod.outlook.com (2603:10b6:510:5::29)
 by DSSPR12MB999235.namprd12.prod.outlook.com (2603:10b6:8:377::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Mon, 2 Nov
 2026 06:12:17 +0000
Received: from PH4PEPF0000B60C.namprd21.prod.outlook.com
 (2603:10b6:510:5:cafe::42) by PH0PR07CA0024.outlook.office365.com
 (2603:10b6:510:5::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Mon, 2
 Nov 2026 06:12:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 PH4PEPF0000B60C.mail.protection.outlook.com (10.167.243.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.0 via Frontend Transport; Mon, 2 Nov 2026 06:12:17 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 2 Nov
 2026 00:12:16 -0600
Received: from [10.136.33.166] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Mon, 2 Nov 2026 00:12:06 -0600
Message-ID: <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
Date: Mon, 2 Nov 2026 11:42:05 +0530
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
To: Borislav Petkov <bp@alien8.de>, Ashish Kalra <Ashish.Kalra@amd.com>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<Tycho.Andersen@amd.com>, <Nathan.Fontenot@amd.com>,
	<ackerleytng@google.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <darwi@linutronix.de>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60C:EE_|DSSPR12MB999235:EE_
X-MS-Office365-Filtering-Correlation-Id: d928838a-aeeb-48ee-366c-08df38a83ef7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|7416014|1800799024|6133799003|10067099003|22082099003|18002099003|13003099007|11063799006|4143699003|261021121427099003|261026121527099003|261026140227099003|261022075727099003|261022105027099003|261009223027099003|261028144727099003|261021123027099003|56012099006|260925022911599003|260925021311599003|260925021911599003;
X-Microsoft-Antispam-Message-Info:
	lK2LFxPIeN+thkPQjpA8xUgZGq8QW4naMfBspou7JPYLrwa1mxdR2CxpALFuOdt7MejDpKKCyg6Q0Z9RGhnGUcXhZAxgiyItjVgcl8Fs36EGMcm3B2sZSrnhbLMh0c23bbksSyVKK6DZUSLpRYZTPWOi1RuKQ20TLOTrLZozKxZxu1YRNSeZEMRykzNf0o+Ar7MHVMFgGKr8+9a6I97l/eAdF1JASN7EPzJECBw5EdnzFewZ3ePFxKvbGwxQamjfGnzkNXjPAVpH4eQb6VOu8dzIYhH+p40p9A7ou8aZJtzMGnRIsfvElXuAABkLUl04knPrJ5YjFVlPmkizBxI41xf8ssU7JcofkycX+UeND4+DksLfP0p3EhL835/6w8zi0wHI0/KPXdOZw4Px5hYf6ouIXEuojyZOEbrwoJVN5rQc9LLJYzS/Zlbe3SDMxPFRCBsI3B/cacKFzDwfftksN6BtonOqV8Q5oo4wv28zvWd6YSmjL980kwcP1mODeepSReeutPAML6vsIZY5GtZlGyPjm2htY5RTovGJV/bPHFLBOtRHh2lTw8Z7nLAXFBhStSOUqk8K8/Bp3P2e/NkK7U1A9lDr9YNUHO3RiUPutoFNekiK7eOI346fWN7nLoxgiUpAWW3J7zUGtPI08z/jtmUw++JhZfLA6GacVIOcImI=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(7416014)(1800799024)(6133799003)(10067099003)(22082099003)(18002099003)(13003099007)(11063799006)(4143699003)(261021121427099003)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(261009223027099003)(261028144727099003)(261021123027099003)(56012099006)(260925022911599003)(260925021311599003)(260925021911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XXKlp3xhjY7QcrYwhZVHn04RnH9Z8LyMHGKs5EtKCagxxa3lFe4Bo6mfOH58Yuf/7gw9jDippSBaEPDyk+An2mpXVtlXRiztOi6A7l0KaX569SSb2VY8IXin86Xv/JxoVQNPdvFGpAVfwevhalI0ITjXfbsm+OR4qsLlis3xiNyDFL9FZd56EqfehnyHGEr+4KQZtyBQPegABF+iOr7V/tprGcKB/2tnRFR2dY/9LRYnETAP9UFf7Kmw5kS/C75sKplzD+G7kow0hq/x8xMFYer5LX55lN67NcbS8qxr/XQxKgM1C5EXNIG3m1K6VjuOOmIpi3K0JB+r7TdEIptfWcQERdck/tINghxSawF2Dyusj1mnouhMkzwylwFiKuPG3boJcFv12UPgFcBegP7SbOKCrabe6KPop7XocnK+RdiZlSWSOAD2Ot7voPJdh7g2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 06:12:17.0821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d928838a-aeeb-48ee-366c-08df38a83ef7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSSPR12MB999235

Hello Boris,

On 11/2/2026 10:58 AM, Borislav Petkov wrote:
> Segmented RMP support is advertised via X86_FEATURE_SEGMENTED_RMP, and the
> firmware enables it via MSR_AMD64_RMP_CFG[SEG_RMP_ENABLED]. The latter can be
> cleared in platform BIOS by the user, in which case the system runs in
> contiguous RMP setting.

nit. In the latter case, SNP is disabled entirely in bsp_determine_snp and
the system won't continue with contiguous RMP.

> snp_probe_rmptable_info() does not clear X86_FEATURE_RMPOPT in the
> advertised-but-firmware-disabled case.
> 
> As a result, this does not prevent snp_enable_rmpopt() from trying to program
> MSR_AMD64_RMPOPT_BASE, which raises a #GP on the MSR access.
> 
> Make sure X86_FEATURE_RMPOPT is cleared in all cases where segmented RMP is
> not enabled.
> 
>   [ bp:
>    - Put the commit message on Ozempic
>    - Flip the logic in the function so that the segmented RMP disabled
>      case goes first and the flow gets simpler this way. ]
> 
> Fixes: 15d974be0a3b ("x86/sev: Initialize RMPOPT configuration MSRs")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Link: https://patch.msgid.link/56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com

Feel free to include:

Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>

> ---
>  arch/x86/virt/svm/sev.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index bd70c4d0b774..ff6d17795054 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -817,21 +817,20 @@ static bool probe_segmented_rmptable_info(void)
>  
>  bool snp_probe_rmptable_info(void)
>  {
> -	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
> -		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
> +	if (!cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
> +		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>  
> -		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
> -			if (probe_segmented_rmptable_info())
> -				return true;
> +		return probe_contiguous_rmptable_info();
> +	}
>  
> -			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> -			return false;
> -		}
> -	} else {
> -		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> +	rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
> +	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
> +		if (probe_segmented_rmptable_info())
> +			return true;
>  	}
>  
> -	return probe_contiguous_rmptable_info();
> +	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> +	return false;
>  }
>  
>  /*

-- 
Thanks and Regards,
Prateek

