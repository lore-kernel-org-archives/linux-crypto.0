Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012055.outbound.protection.outlook.com [52.101.48.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D481D88D7;
	Wed,  8 Apr 2026 05:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775626850; cv=fail; b=odvgwW9OKOhSYJtJjZxfbQ7s2SaD7+SCoxMAJeiYfIqQiFYgDeEoiO1GMNj9PDt1nUTRmc+TWUWRSaQQ1ffvEr3TxgcFLdhNCJiXCo6mr2u0gO4+VU0lMwE6oGr7trh7O3i+cAIlgrglYhwCtH+vQ/EP4Q+AYS+2HiGLPWV6U9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775626850; c=relaxed/simple;
	bh=wHOPo3lyebMOCiPKIs45isSQbuhA5tYgPzRzM2mMTrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KhVjbeJqo1IAE1PQMVxHqHz0AT+BHEACQP94hmuq31pt05dt/v37hztO1MmzjLsMDgFHsstjALiPilkPZHE515MDd/ZkcVYTTGeRakQ72xkLp4qJbJ20u3zFYAeuZ9GEG9jrdEaOA+61ldMnO8Eis1xm5LusoNajMgDE+3OPoYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qefKTcpy; arc=fail smtp.client-ip=52.101.48.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qefKTcpy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SnpgbOCIdqg9V9Wm2HV/OCUkmhFLNaKFYbVUVymNyLv1WHlREmmrCRitkPGxvl5ejQyTQWKSCcIQ2UXDjAFdj+5BZmZSpiTYGr7F5kEKIRYrby6xYeGsViGRR9ninS6evA5+JyB8Q9dBLFYQCgYRAk7TyPAyQdl7oHz0QXouBUIiQ4pxWS9qpjZm7RvafTIb5Ro/Fs8K6WvUEnW303WmVQRxmaIoDCjM08i/5sl+sKUfDjB8rAZbSXDOFoGsK95BEjhMnKrv/MMSbunonelbgDRHVQVCrnTJWbz5mq4rja7xH7+Mp88pD0Oz3TsWfhu9kMFdxqW8M5zI57Qdlpe+VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v8xXRAQ6XDKjbn7qumkTyRnlsSdbzLiw6/QBMZoH5h0=;
 b=eQkqZ1VvSAneKE3UIkHQS7rwoc2t3sluKH/eF+qtEOjZsxUL3+xt36FrtC6tQrxSNGY5sWvSQcbqdpbta0h8z2qhfiFjzdQZeX0CDtNPNX9oXh0AK/tJwdxtyJn+bqx0/ChNLfJ7FpdgM+Bjy3BpUgKBIy6KhDgZu9JeoGkm8ePqPb2NQiXEBbFrNL5QueoBGvce0GOChcjOXe/vgwUwl3GdOB3ATDd3vda6xeYDvnY2puMUxRUlBqwWQYAuHo5J0QhBDVaLtTXx4/OpaQjWa0PvM4B3QM72AAmQL5cIHZYB1qBP/LwPcFVmWBnYm0nkiNhnl5oNKCE4wWUOKlifAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8xXRAQ6XDKjbn7qumkTyRnlsSdbzLiw6/QBMZoH5h0=;
 b=qefKTcpyWA2s7ckY4ZE/MZ++GTzqRrdmamVbhG1y67Swv0Zc/5khykjSGa6IFQ7UQ1E1qw+SCHDopQ3PRmVkjdVEgnHgKUnm1gnAyDt6yQdofK7QTbmbz+3kMvlMecRxiyNpDE4XDkJlAA3tE/1y6iP+fDXji8A6AvfqRjfu73s=
Received: from BL1PR13CA0286.namprd13.prod.outlook.com (2603:10b6:208:2bc::21)
 by MN0PR12MB6001.namprd12.prod.outlook.com (2603:10b6:208:37d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Wed, 8 Apr
 2026 05:40:41 +0000
Received: from BL02EPF0001A100.namprd03.prod.outlook.com
 (2603:10b6:208:2bc:cafe::3a) by BL1PR13CA0286.outlook.office365.com
 (2603:10b6:208:2bc::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.33 via Frontend Transport; Wed,
 8 Apr 2026 05:40:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL02EPF0001A100.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 8 Apr 2026 05:40:41 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 00:40:40 -0500
Received: from [10.143.200.36] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 8 Apr 2026 00:40:34 -0500
Message-ID: <55164af0-f9b8-4440-836a-5e6b3c40380f@amd.com>
Date: Wed, 8 Apr 2026 11:10:33 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/sev: Do not initialize SNP if missing CPUs
To: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Ard
 Biesheuvel" <ardb@kernel.org>, Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>, Alexey Kardashevskiy
	<aik@amd.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Kim Phillips
	<kim.phillips@amd.com>, Sean Christopherson <seanjc@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
References: <20260407174713.439474-1-tycho@kernel.org>
 <20260407174713.439474-2-tycho@kernel.org>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20260407174713.439474-2-tycho@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A100:EE_|MN0PR12MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: c03ccf4f-71e9-4d55-15f7-08de95315ee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|36860700016|376014|921020|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GvyMBpkeipUcm6nR0fOLC3t2yX1afaJWMYyHgTZnK2SjqwmZeCDAr+d3aTB3lO0H4pUHDFY8tXvmDmHcq9lPzc1q2NhuGsp6z1HqC3+Jq5JD3rCpFZQMy6+UTf42eSSPUg8pq69z+lVjIZvpidxeoFlSlQZ2CWzW/Ao2vbgTTB20HVwGyT8HYd6l6bYEx0D2odaBRT9YANmf5wAS0HzSsVPYkJWcgvAJqqX85BrF0ld3tgmXWtZJ6lYa6N2FzlXS2J/7abX1FVQ0mFxFyfERYmGcs5bKlhYw4w8dnIQEN+bujRFUAMebx/hmtgN+9g4k8vXjkEVC1E6YsjvO6bI/73HVKpS1CO3HFfgxT5F/NMEJ3vYElGka17DHV3lbW4JfprqMw0iFS5+4+IyTH3Cc0pkN4gIf4JCtGKxVLeXf1TP/pN2vLvhPzH/2f1G5Cdrh0imO0b8zBQbTT1y00HlEjN4FCuD+2OOI5g1Iu0n74XiM8fwnC+84BsVjVFvY/vQpcK+Brhf2fU7aQSXmR4xzI9MtxWBzDRqwuasTcTkfFUqfA0wbV3WOO2o1glvFzDvgOYwWup2cpyeCT2OU9g1QQbrGhpfNpvQvEXHpALFIw8xth3cW4J9VnnBfbV/6SvXE25ZxH5sgm1VeD+msM2NmZ9rNRBwHcxq95tE+sRGlg2DZiPcZq9PnfrI3qiZkfJ88PMOiXJoa3aZuWZUxBk07Ppqjny+UH+o/wSILpNkOBbL57vw8XPcoyMYOV/pDI4R6gfXi/zHGPJBVBR+ofBoXeU/ml4q4O9ghleUO9BpReaPZiWfwfhTcPqJn3wqYq3yk
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(36860700016)(376014)(921020)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	z9xJo53C2hymnVYvvhV83q3NGJBpxZcQqV7tTTsUZtYKF/z/q6P1wEX/t3VwmIuW7Jr7L8+wVLPcsiDoR65XfubVaktkNrvp9iD9d95EsEhW+aypP0FILz+ixH4cZtHJyZqcdO6E7zbYhslB4IyYeiWhmiylxA0ICyfoWcY6rc97HZn8acGAiv2g7pR5ljV6fPR16arUJY/8b6xPbmY+ta9Oi08EHCiCuFOjF7G/p+bhY2fO7ynliUESWNUtqSCHaVasT7D9r8ggpiY6+9Nlpk+ZVu2hM5OWfevN6as6mAvrDgxspY6U7teoaaRE8GPeSc++RtpZwv3PycZ35TTEEKLpkO/3WSG2WWnZnwITLYOAANJDgwb8RlbgfgR3PONIPYKjduVEZ4fUrIGO0myZLXQCBJtZLgI0yTTWgDfxd/ihXKS1sobYhox7Pk32CzCJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 05:40:41.0701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c03ccf4f-71e9-4d55-15f7-08de95315ee4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A100.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6001



On 4/7/2026 11:17 PM, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> The SEV firmware checks that the SNP enable bit is set on each CPU during
> SNP initialization, and will fail if it is not. If there are some CPUs
> offline, they will not run the setup functions, so SNP initialization will
> always fail.
> 
> Skip the IPIs in this case and return an error so that the CCP driver can
> skip the SNP_INIT that will fail. Also print the CPU masks as a breadcrumb
> so people can figure out what happened.
> 
> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

LGTM

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/include/asm/sev.h |  4 ++--
>  arch/x86/virt/svm/sev.c    | 15 +++++++++++++--
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 09e605c85de4..594cfa19cbd4 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -661,7 +661,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>  {
>  	__snp_leak_pages(pfn, pages, true);
>  }
> -void snp_prepare(void);
> +int snp_prepare(void);
>  void snp_shutdown(void);
>  #else
>  static inline bool snp_probe_rmptable_info(void) { return false; }
> @@ -679,7 +679,7 @@ static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
>  static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>  static inline void kdump_sev_callback(void) { }
>  static inline void snp_fixup_e820_tables(void) {}
> -static inline void snp_prepare(void) {}
> +static inline int snp_prepare(void) { return -ENODEV; }
>  static inline void snp_shutdown(void) {}
>  #endif
>  
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 41f76f15caa1..160e60f5f3fb 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -511,8 +511,9 @@ static void clear_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> -void snp_prepare(void)
> +int snp_prepare(void)
>  {
> +	int ret = -EOPNOTSUPP;
>  	u64 val;
>  
>  	/*
> @@ -521,12 +522,19 @@ void snp_prepare(void)
>  	 */
>  	rdmsrq(MSR_AMD64_SYSCFG, val);
>  	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> -		return;
> +		return 0;
>  
>  	clear_rmp();
>  
>  	cpus_read_lock();
>  
> +	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
> +		pr_warn("Skipping SNP initialization. CPUs online %*pbl, present %*pbl\n",
> +			cpumask_pr_args(cpu_online_mask),
> +			cpumask_pr_args(cpu_present_mask));
> +		goto unlock;
> +	}
> +
>  	/*
>  	 * MtrrFixDramModEn is not shared between threads on a core,
>  	 * therefore it must be set on all CPUs prior to enabling SNP.
> @@ -537,7 +545,10 @@ void snp_prepare(void)
>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>  	on_each_cpu(clear_hsave_pa, NULL, 1);
>  
> +	ret = 0;
> +unlock:
>  	cpus_read_unlock();
> +	return ret;
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>  

