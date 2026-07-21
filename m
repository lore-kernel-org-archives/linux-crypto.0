Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012052.outbound.protection.outlook.com [40.107.209.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601B84CA26E;
	Tue, 21 Jul 2026 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784646386; cv=fail; b=X30MIPdvAyUC4axC34kVe4RZp8H4CtJdJsnZkaJM6kc+7uftocZKR5UO7se1jOgLuQa3LvBjyQAm5AcY2dGkQBbe0VJN4KflRfg5D3ZJI9DBbblp6PJrytPcNFfyYNf+EFwwp+oi4kHKmPVfaBnVc4+dE6km5NCTHl2WTM+X0qQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784646386; c=relaxed/simple;
	bh=9ycTKKfXo2PFyAFvj1OxtplAErwIouh+0BjESTXmlps=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iDdL0jZL4cI7ncJPqpVrhHGqTU3BZA6l4j1I/fDqj5CVIyLqfBmRR5lAk/3fIVt6k09v+eYnkyAp0Yi+yfbI5uHaeDQGhP+yRITFJzdlDfypj+94DeOvJN+QH+NVowTatktp9IGELbFHLpzPbIrE9ncnkRwkNvuIXBGr3FFHtaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t/eQvIJL; arc=fail smtp.client-ip=40.107.209.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t/eQvIJL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VRE92RGhfbtxGt9LMK/XNOyvRP50llh53Mp36XK6D1BSUYcGCsDZjeh6pNp/MZjZdHzMQ6mpl5BqBWGav91+K+pzbfoyCQXALmnwbs5Iw6lJAEc+/z/8y1JP43KQbfNtd+iE97ihjh5sY/CgaM/6D69InKXu36VssQOlEurGhf2Xu87sfbzMmUTBHQDjLmC+ualUoT59XPqvOEEDUnZ6ILG2si6RVlb7ctwam8E8OwIClp1aasHlGpj2O1CoerjDE/b4S+0y6Y+LQCPnbxqvfQ1o6yfhZksiCBSxgkVHlm0DYT6Eq/U2rlNchnZ9aqQ36r/IY9i1Udskkx3qzE+FBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dB5lgC7s9wRwDpV9IYBgngs63FpPwlrZDgMZjPTyfl0=;
 b=GT5xCqvyBzouofv2i85tPWLoYEGM1KFx/i7PxRf+0JC4HDr7xzGVo9bA6T7Dv0A1JK7o4jin2TzQYtY2jaCBob8WGRwGB7iBal25u/nJuMnUjc0HRHsv4g5ZKIujCwezguGT86uKCxRv2cUwtR/1hPsLY4552fu9CW9e6mKX6PLFpQP+/zjyZVmt+UgLJbDOULsvGkf025NYCDUjhw6iHJdLBDvAso1Jr8p9Y6tfgOMiLuDdSVAqyCrN/yPntcmTSQt5u4FdskV2ouKnKciNmSmPAWPO9MPS7g5CuwN6NjmvSqHMkonNVpYSmdzlnRP4Gx0mSfZIdmPnIwmSLimAkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dB5lgC7s9wRwDpV9IYBgngs63FpPwlrZDgMZjPTyfl0=;
 b=t/eQvIJLIWIr8mRJns4mH4WRQG0NK/sXotIvVI8eigVR/eOJIFuvaPyLBzW4N3a4eLSMYO9EoVEMcmgAvNbcnEaidVJ3OYDh3Uke96yPO2TsEU61kBewpN42a26bYKM7cxY6HT3A1dI44CHEbn4i6vSRF4kw6FJEcbhtwYCk3lw=
Received: from CH5PR02CA0010.namprd02.prod.outlook.com (2603:10b6:610:1ed::22)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 15:06:19 +0000
Received: from CH2PEPF00000148.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::12) by CH5PR02CA0010.outlook.office365.com
 (2603:10b6:610:1ed::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Tue,
 21 Jul 2026 15:06:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH2PEPF00000148.mail.protection.outlook.com (10.167.244.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Tue, 21 Jul 2026 15:06:18 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 21 Jul
 2026 10:06:17 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 21 Jul
 2026 10:06:15 -0500
Received: from [172.31.184.125] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 21 Jul 2026 10:06:07 -0500
Message-ID: <e4aacc32-ac61-45cd-bf76-5442afc45082@amd.com>
Date: Tue, 21 Jul 2026 20:36:06 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 4/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
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
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <ada64cdc976b98a70687b3a347bca0c25c89eb09.1782841284.git.ashish.kalra@amd.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <ada64cdc976b98a70687b3a347bca0c25c89eb09.1782841284.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000148:EE_|SA0PR12MB4479:EE_
X-MS-Office365-Filtering-Correlation-Id: 8113594c-9af1-4fea-f87c-08dee7399e00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|7416014|376014|82310400026|36860700016|1800799024|23010399003|921020|22082099003|18002099003|6133799003|3023799007|56012099006|10067099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	3Qx7BEzq8aFJKJQrHMMSKYHTFMKZPYHrol4Ei49WQ0X7b0YCLedlKVbtoe/DOFU6pl0EwVVnSuFnLs/qIqqah9Z3r0Y0LV7nZgdvzyhjz0pJU6vS7BPRNzX/lTCw1bPImS4BvcQXUKVeOc9kuhRaHy30bWjNy+GRzMit3/aJF6VYLrODUyQTfsut68jI+i7mZ7vhIWr+PoqxPGz8rHaEKZrTLRY3NTYIGF3t5redDJHONxo+VQ8mVHBsgVXhqVHZRcjMoGnDlNMCHtxbmf0PREJeVorA1Y10jmPBpzr00IL7zvxN12tIlUR/FhptSxQQ/MQ1nLtEbRGr7N0DHDn+XXoob5nvauuzwz5xAkzWwrkUCGZRJ17s2cjnSk2QCPp8AhUeq56yOOYCInmz8/w1+WO1D8xqxw3qqzfab3WpZ553HdEAHPz10UxEVLkcOsn047peuN3+tNQjg1RYoBMkxKvkLc+X2GQ7TJk8OJ1KAQz9syvGYJ5jfm+t+7LR2GWbsCsY/ErhzNSlqhm+7LNOcHQOzrq/YT0Mc2eQrBeUxu91YYtU/0odq8gM3df1Kunng+Crhc69SvOhTngE2bPZlWmYR1OBiLjJB1DZUgs77N4Y7DeZFG7tfBSbOwY9yW9cIWUhgj/cdtyLfjGNoD5di5A69takW39TA8wpSCHzisFWatdgvKZeL/5cHaRgPGqtZS7lS/y+kacdOBYzjcHTprB0K2qr2wpuTFu2KGmlf8l30xAWSHAhivEGSkAjeMwK
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(30052699003)(7416014)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(921020)(22082099003)(18002099003)(6133799003)(3023799007)(56012099006)(10067099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PsBfAzW2fabDniEnjgzEn1F1fcd1mV3zq6X21CT5tFxnNtuCw1rk5Or8G8kX5r3/umzB7jbqrVgzSQotCzV94T5I30rY1mYrItzsw6jnBxH50hVZgRYc5gpgbLs2YlXQY7/S/OdKo+ncEYwUyi8tk7faQda4Zi6bKaoyjn9rZML8tkMmITDlhfkbw7bJxSrMxmliq3OWDoLSmdp6ukQXemCueE7EOPUcaCMW7r5BzsG0ltU0BbY6Rl0salFT084gfyEDLbSuDc56H01OGjgehkVAAK0QZlVa1Yn8IUqTdxp+eRpeg2sC9FYK3sE4fJL9eLL8wXsndEELBwOjG2PzA7Xls+ZuiuoHEt4FfxTXv+NQq7npqGw4aOeqpXr4uAyNDFHbXsVqsUYwZg02danLKUy5jN/42h0pP90EbG2zkGdArcnSYGOj8dSqSfY/8bqj
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 15:06:18.2605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8113594c-9af1-4fea-f87c-08dee7399e00
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000148.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479

Hello Ashish,

On 6/30/2026 11:41 PM, Ashish Kalra wrote:
> +	/*
> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
> +	 * reserved processor memory. The RMP scan is the most expensive
> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
> +	 * if they can see a cached result in the reserved processor memory.
> +	 *
> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
> +	 * on every other primary thread. Followers are "designed to"
> +	 * skip the scan if they see the "cached" scan results.
> +	 *
> +	 * Pin the worker to the current CPU for the leader loop so that
> +	 * this_cpu remains valid and the RMPOPT instruction executes on
> +	 * the correct CPU.  Use migrate_disable() rather than get_cpu() to
> +	 * prevent migration while still allowing preemption.
> +	 */
> +	migrate_disable();
> +	this_cpu = smp_processor_id();
> +
> +	cpumask_andnot(follower_mask, rmpopt_cpumask,
> +		       topology_sibling_cpumask(this_cpu));
> +
> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
> +		rmpopt(pa);
> +		cond_resched();
> +	}
> +	migrate_enable();
> +
> +	/*
> +	 * Followers: run RMPOPT on remaining cores.  CPUs cannot go offline
> +	 * while SNP is active, so the follower set stays valid across the
> +	 * scan and cpus_read_lock() is uncontended.
> +	 */
> +	scoped_guard(cpus_read_lock) {

We can only reach here after disabling hotplug. Do we still to hold the
cpus_read_lock?

> +		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
> +			on_each_cpu_mask(follower_mask, rmpopt_smp,
> +					 (void *)pa, true);
> +
> +			/* Give a chance for other threads to run */
> +			cond_resched();

Ever since commit 7dadeaa6e851 ("sched: Further restrict the preemption
modes"), one cannot select PREEMPT_VOLUNTARY on x86 and cond_resched()
is a nop with all the other preemption models (PREEMPT_NONE will not
preempt a kernel thread; PREEMPT_LAZY / PREEMPT / PREEMPT_RT all make
the kernel fully preemptible except for sections with
preempt_count != 0)

You can drop these cond_resched() calls in your respin.

> +		}
> +	}
> +
> +	free_cpumask_var(follower_mask);
> +}
> +

-- 
Thanks and Regards,
Prateek

