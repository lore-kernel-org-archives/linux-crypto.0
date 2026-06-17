Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012030.outbound.protection.outlook.com [40.107.200.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798FF1946DA;
	Wed, 17 Jun 2026 04:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781670813; cv=fail; b=e36FDwa34hICi6+/2NrkK5dcRu+lOfuyeEmdGndsHTsDXisbvTJy9E/kbxVsQI0szyHtjgaDIcRkqYYiCF1en+HxH6XK+8bbTOtm0bbAwG2ux3qOFCEqTJB5njxYQY6CpdLtCnpA9NBqIPqEn1L6eT7Phtff5MaiJQ8YoGW1NIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781670813; c=relaxed/simple;
	bh=LSUd/2NuMPcM4dVgu96tCUZJLFjBHDTWFwWJDg4UWz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OrlGpS/i2P1n8auX0yO9UMm7F1nzWsKSH6661oMKoZJsG3aG7Ncg/FNFURmINynaGvIUaeql323gdrdrAf9JMMuzzRP59D5CTWJRsVROqO7x4AyaAf2357csNp/fSPoe9p+bfPWzopUCJsgI83MxOupJUPCAwIeXmFPzF+svSvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CFv01M43; arc=fail smtp.client-ip=40.107.200.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CFv01M43"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xL89WYXY7YewScxirDAk31PnWHrNS0GkmlzxT+K4h/48uQIbaj0VO6z0czAWCbdhgtXNzaTNQUrEsh/L5G9hLi3XZj9rzQX4nOUFbxF1e7yY1+ic3FAq37MzUxmU1NowXep9PqG0ctSReYPA/emWwpfZwZBDETHXF42EZ27s9TehHFgw3xanHJkojMT0kIQE8reT6yZuc/pFL+qsDANTPKhrtIB93rwbdLhsGHLc3JGQsGawNbcpfYgPZA66OukiSVFbIY7pMMrxJ7HKc1Eg5ySHFxRSxVxpPfF9hPZgtJWnZSRRKuoAjEPIYqrTdtX5dGzNIHLZF6dKqgWY7XlOXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RL2538o02zzrLVZJ+Qz2ESuMRK94/9HV7XCNZfXzQHw=;
 b=FkISoniHlQvz1tlvuVV57V+x2NdvnuzGAznLa6Z9tPqGcOKSOdLPJHwufatysSQX927D6N+WIALLVE7rG4on2jIJ5zzIaQv8sTH2QKLy/lZRGEL6/sqHReqw8FfN5w0FYcfd9gT0kHGqxRBnQvp86qSnq+W+t3TNUX9pdD78aD+S9Kk8lCPZUTvmeMW2qFMg0/uQyjyLd/MvUFXdzvVUhiqHIGinhOHoBVpJWQMjxfFeIBhsUBf42xcQg0OpNZA5L3zVwlOC1nr81m/bl8zHF8i9B+9ImBnzemSEWZncF39c7DzjQyeYDNoMXnEC86ADzgSXhyPvIn6OW4A4ppdPSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RL2538o02zzrLVZJ+Qz2ESuMRK94/9HV7XCNZfXzQHw=;
 b=CFv01M43ZdI3gFIHkPzdUVPrfI/v+cZ/puutLfWRAo1+uIKvE5qZs2B6chpQqB9hRI8CGucCQrrBcfvDoHtVN+unsxL9SrIdKbCXKFRE9HRBGojX1rdhv2bUVmUJ1qdNLEtg+s2GIFrq4HjgJvptw63rypt0SqRb8leC6Rlrr+Y=
Received: from CH2PR15CA0026.namprd15.prod.outlook.com (2603:10b6:610:51::36)
 by SA1PR12MB7246.namprd12.prod.outlook.com (2603:10b6:806:2bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 04:33:26 +0000
Received: from CH2PEPF0000009F.namprd02.prod.outlook.com
 (2603:10b6:610:51:cafe::29) by CH2PR15CA0026.outlook.office365.com
 (2603:10b6:610:51::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.11 via Frontend Transport; Wed,
 17 Jun 2026 04:33:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH2PEPF0000009F.mail.protection.outlook.com (10.167.244.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Wed, 17 Jun 2026 04:33:26 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 16 Jun
 2026 23:33:26 -0500
Received: from [10.136.46.240] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 16 Jun 2026 23:33:16 -0500
Message-ID: <763bff29-e737-4033-ab30-cec8fd3e7438@amd.com>
Date: Wed, 17 Jun 2026 10:03:15 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
To: Ashish Kalra <Ashish.Kalra@amd.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<Tycho.Andersen@amd.com>, <Nathan.Fontenot@amd.com>,
	<ackerleytng@google.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009F:EE_|SA1PR12MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: 50a1ed3f-a146-4c3d-ee70-08decc2992f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700016|23010399003|921020|18002099003|22082099003|3023799007|11063799006|56012099006|6133799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	RKhTh22ztBTeraTSVJI0IaUWf2VxyePaoycyWj3yK1PIYi1D6LWTUB2MEV74TdDMqz6+wepZH2x9Mr7gBz+MqPJY75pbGppSrAIWxMQBr0hfS91MsqkooI8i8uOOyo+9+e+TL84yKAMuExbLET8/5DxUYAaGuqps9KdjtZrBtCp2YhbVRPy0aYrD+tqoqE8fwqcluM9K9fBSgxBoLGCko8NKn0Q9il/44elekahDq0o1NW68uj2XavOOLiFqAaHyPZUUTUM3og6kpfmeNv7WpedGTm5kF6oONRLdtKnpiHJUSmgncHsP+3Lxw82pVA8l07EPGpidaYlGHdZcHZJBNGmOHuyaANIViDSPYXrfWYRG8YV9jZdsp8dicR03ER+A1p2aq8EBAXRaSEbR7YGtep7YdUYk0Ng/w3qUwXskfBqYBXWHN4UnaYlysHjLPbDwnk8cO/hP6PKQLtIfkvxce4sm89gDKzKjDUPIpOl9gnYNyxb3t5YA4Dul3w9lsH56+0H4sdhrgYkTAI3089h7Q9orl/ybtS8fN+ooOGLWzNpcuO75BQjW9jjzDP+q9cix5iuay9EpaG46ikiOpXXl94rPWQb6+ao1XAxqkqtLoSxeUE1smc3KbARI2BUsHmST0VFe6e1hnL86eLwGnVe5BNlbhofxG2TuU73BFgECTMfnbeK3iHsCGscTYAB/YgPaqSrZKk3GnmPVQIaHuxXFcVN+aoDMgKbdwuPLO4gqHaQ555AtOjFXLyBpOnIpy2Gcm8zFtAzkMEIOze8BKS+3ZA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700016)(23010399003)(921020)(18002099003)(22082099003)(3023799007)(11063799006)(56012099006)(6133799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Hc6lFka7qIYuCwMHIsAcda9ZipZ1aywLDY8Hah/J0AKjQBOJMAwpwwybAxbzQhJQIlRjWxjTj+QWEfnoksp7762vfPB2RuND/3j6Z3RXLesnoF/9sqkilr3rn7AoSHYFf+hpedqbn98POhMVjXiMBQurG7sYad5xaU8RDyFG3Xa8huDmme+T3HULtfLql3EM6E0u0YGOyBtsBg9w0Bpgd1IBJ022I1SKFjs9/IV10SqON3NLbQawHR2x5ZoChCyNazexv7wsEj43SNN2quCeKt8AC1j6AxWEGmjraHGvfqcxuF+8k+Kk574ZiAiBOK8Sj9Tlf75RtEU7vdMKcMX7v09JXBTF5CUDU7OgIUJoeQQ9f6II3dh8fLK7KjJTGVw7IRxLoMa6qgbVZTQy0a1Mh055NNyVloqA2INiSKtriAbMPuSl9H8rNj8SojUXxZwZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 04:33:26.4158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a1ed3f-a146-4c3d-ee70-08decc2992f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7246

Hello Ashish,

On 6/16/2026 1:19 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The SEV firmware enumerates the CPUs at SNP initialization and is not
> aware of the OS bringing CPUs online or offline afterwards, so OS CPU
> hotplug can diverge from the firmware's expectations and break SNP.
> Disable CPU hotplug while SNP is active.

Dumb question: Is this specific to RMPOPT? Otherwise ...

> 
> SNP is fully torn down only on the SNP_SHUTDOWN_EX x86_snp_shutdown
> path; the legacy path leaves SNP enabled in hardware while clearing
> snp_initialized, so __sev_snp_init_locked() can run again.  Track the
> disable with a flag so it is balanced by a matching enable rather than
> stacked, and re-enable hotplug only on the x86_snp_shutdown path, after
> snp_shutdown() has cleared the per-core RMPOPT_BASE MSRs with hotplug
> still disabled.
> 
> This also keeps the CPU set stable for the asynchronous RMPOPT scan
> added later in this series, and ensures cpus_read_lock() in the scan
> is uncontended.
> 
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 217b6b19802e..c8c3c577463c 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -106,6 +106,9 @@ struct snp_hv_fixed_pages_entry {
>  
>  static LIST_HEAD(snp_hv_fixed_pages);
>  
> +/* Set while SNP has CPU hotplug disabled. */
> +static bool snp_cpu_hotplug_disabled;
> +
>  /* Trusted Memory Region (TMR):
>   *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
>   *   to allocate the memory, which will return aligned memory for the specified
> @@ -1479,6 +1482,17 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  
>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>  
> +	/*
> +	 * Disable CPU hotplug while SNP is active.  Guard against stacking
> +	 * the disable count: the legacy SNP_SHUTDOWN_EX path clears
> +	 * snp_initialized without re-enabling hotplug, so this can run
> +	 * again while hotplug is already disabled.
> +	 */
> +	if (!snp_cpu_hotplug_disabled) {
> +		cpu_hotplug_disable();
> +		snp_cpu_hotplug_disabled = true;
> +	}
> +

... should this be done before __sev_do_cmd_locked(SEV_CMD_SNP_INIT_EX)
is issued?

I'm assuming that is when the firmware enumerates the CPUs during SNP
initialization and any hotplug after that should be disallowed?

>  	snp_setup_rmpopt();
>  
>  	sev->snp_initialized = true;
-- 
Thanks and Regards,
Prateek

