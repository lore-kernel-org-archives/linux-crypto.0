Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012071.outbound.protection.outlook.com [40.107.200.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025FA314D18;
	Tue, 16 Jun 2026 07:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781594866; cv=fail; b=HYq7BAQXwtMQZROKoRFvlBHsjHrlbmdGidAOwKLL+3TdVTuy780Wf29VPyU+3Uo/DOYIEmkBG3qes16ZaGa830affz7kFr9AVtgbPAxuoK7K3CMOGkuvXquHdBMGKxvVC0gI254WaUZ5ygfbM/TB6EK2eFr75cWj4tsxGg+9u+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781594866; c=relaxed/simple;
	bh=+CiPN4Obibz/RZpw3paXXUpMOoEqnwFZkRl/EYt3LlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=do0oVUi++7tLMwUlt4WGqRpzg1mbOvd2XX1M41rNZq76H+9ZSKzbXMoWulRgZAi3f1+GNgeWbDGK1kZRVPvPaif4ygxwWd/8nHt1K7RkHRxu5qKEjr1KMg7w/ZnB4gM8xeYPdnUOGrDBj3Rb8vXAU0cEtmn9jfU6lDtQWbtWFGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wwbgqmlV; arc=fail smtp.client-ip=40.107.200.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wwbgqmlV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SpoZ2a1mzfWzeBc9PgSmj23UX+sOAJEMq1kxj8DU9FQuysRAhoImZweOaElqcGMfYzxQYr7Xtd/zSmgWKMXPzbS8li6MifencVqIEwFCjl3HJa9w2IPBUxXbpWwdlYe3UZ7I1J+eNvWqSyLyri9dQPJ8IZmQTid9sq98+B8FaKKevAgIP4A9fe8ejlzh69wej4b9s48sQuYxIdciDv82/AA3w2wkx5gDTMmTQNDLtbv6rEUc5BcFQa+/svFRm7zPVTCZGok39ecZhTsWLNM9r6vhjQUaXCoGteHxP0vHqImXfKSP12o8uiAjMeXiJSawpSZ5+y67SUNqIYWdrLYOug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMbrZN8ZiJRa9iRFbMfdyl36iGIaHFvtXokcqC+WZvE=;
 b=amJrSEpwar3nv5PWC/0qJCSxdfdYOajmM3Vn1QjbgJq6pwd/4lxquU7zOhPRFZsoOBEcaw6rbI+Aadbe/+/uysZNypL+snH1Fe+mhb6DrIsFgQuqGLqrnUSfzAFVdH0Pa+bV2lD9OaxMJmylJCvExm668vG1EvuUazm7fKVjG6DQj6CZTinIim20Je5ChcMbG5HFOGBvrYsWdP86nrIk9DD2G+zCxlzjBXzCMS5Focm7ZKAh0fOcmuW9MSmN4xlHVR/JxZJC2SHyV4n8DoAzOod531MmgpWQDHO26pfzUd7b7Dk8TWRAKwPDYYAWczg697FUsqUuKWvnRqATvT58+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMbrZN8ZiJRa9iRFbMfdyl36iGIaHFvtXokcqC+WZvE=;
 b=wwbgqmlVUDHR0J2I+n/T2nVaLDDV29wFe2iXI8AtG/QSTucZUFui/IBxZ32ypyJIGryvBnHN2puZ4Fk2O+NMhnG64knwe5K+Nd8da6LeVJzvn8fcnJSH5DwlHSbCqeDjvZUQV9jEXiw9ZYemFZyq8kpnPc8K2rvr1c9DYC6iT/I=
Received: from SJ0PR13CA0160.namprd13.prod.outlook.com (2603:10b6:a03:2c7::15)
 by SJ2PR12MB8717.namprd12.prod.outlook.com (2603:10b6:a03:53d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 07:27:40 +0000
Received: from MWH0EPF000C6190.namprd02.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::5e) by SJ0PR13CA0160.outlook.office365.com
 (2603:10b6:a03:2c7::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.11 via Frontend Transport; Tue,
 16 Jun 2026 07:27:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000C6190.mail.protection.outlook.com (10.167.249.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Tue, 16 Jun 2026 07:27:40 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 16 Jun
 2026 02:27:39 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 16 Jun
 2026 02:27:39 -0500
Received: from [10.136.46.240] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 16 Jun 2026 02:27:29 -0500
Message-ID: <0fa0bc95-ff31-40c5-b083-3c885d09d0ab@amd.com>
Date: Tue, 16 Jun 2026 12:57:28 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/7] x86/sev: Add support to perform RMP optimizations
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
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <de274c2fb3f794ff1f19f0c96184ee50d04d1282.1781419998.git.ashish.kalra@amd.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <de274c2fb3f794ff1f19f0c96184ee50d04d1282.1781419998.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6190:EE_|SJ2PR12MB8717:EE_
X-MS-Office365-Filtering-Correlation-Id: 1552474e-54f9-42fb-69b7-08decb78bf9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|23010399003|1800799024|36860700016|921020|22082099003|18002099003|10063799003|3023799007|11063799006|56012099006|6133799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	PNF5UsrWbNDrGagnZ/ljZx2OMI2y6uXitgUKsWwQZtoMIq6PbxCVzq7/HNsJ9EcIhot+Eg7eYuFW2Gaen5NE7ArvubGU8EIRadfAFrH09/9QRV/c5q0liHEFowYfDYkzXD7CIwoy+itnUqrGQ1cvQLMf+4ZwZ8JukNJix77z1Bg6t8bA8FQWjiFnR6K/NSk4DW9+4NqjzcIznRmp7kaQVVnWe99WnKi7/IOIbEHXlAS/wW6GZyp8e52J1KllzBPEUguuWxmMiwU+R64+mSw3+j3A4zU6dVnV2sfaMoTVtm1OgAg/AH+HBd6yJ5jSck/F/4VKo9TKH6N917TMlbplg2IXKPl3YDx89cG+Hi5vM7jl7uWD1K4q67AZG0tnAQWdNf6sqofD281diO3z8Sw3MnydwREjRj3DrmcvEAeayWxO+jF5FdBn+8qghG7t6xofaS+z9CFHWXg6e8p1qYgZIMYPFx0HwLD0oSFALLFMVR3Ebf5caDrmVudrFodUv5CZcH9E8QmvjvQdXrSjk+Eg446/2ydRvuZyorMhbMIBexTnUbH0eSlvtcU2xdKqWE/6c7AGa7XuTWR8/M4L4lyks9ZNP8Iuug9Wt1vpU8oM4tMe0ztwzkDXxcOhDJnwicxx45NGlWEjs/JvpFDRcD6r3da+ysmDPFqe83rj+4wOwOCy50CvjB6kytyO+vt/XIS5ZFIFah1gcVG7h+s7Z8vW4/S7Hqa+Tog5cQk5HiobEAOTysOP7NTcLIeM1w5SqAZbYw1iCd8Xn76F4+YeuZ4x3w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(23010399003)(1800799024)(36860700016)(921020)(22082099003)(18002099003)(10063799003)(3023799007)(11063799006)(56012099006)(6133799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fE9Wpz1dzC2LcwIX9//szHpRnL1U88O1xZYLKF34UppBS6WVkpfwvyFxGu8qEPj3DNOvC8twWzysJqb5wzyD/B6R6pD/0ILK7aCWL96FeAxViOh2RgozYH5uRa7tyTXyxD3n7Pxk00TQf2g9HZWYexdF+iArKXIhjfC3TVF/OZ7tQG+HdB3ecjeswuEoP+n1na7KBrWi3Ga1rzGf5wTXRdqZoNCMCM/RL1g1TeDylvxEsUwFZnGhaJeBbIFSQkULfncr0XFKz1Hj206Gp0fZUIgW1VsZzwNAVCmupy6aK2S9uP0UiSWeQJXIUzm3Q495JmzvjdFDqMJQBk1Nlz6gnhho/FxZTOxwLTmcujMBpI3AT1Aj4bPwMyeXz14MAdwnIEmzSz/9ZFm/xxTyFOvQOEoqfyyOiManYLgmU/ePJSjujb4DoJ2D8piSRtp+35fs
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 07:27:40.3547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1552474e-54f9-42fb-69b7-08decb78bf9a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6190.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8717

Hello Ashish,

On 6/16/2026 1:19 AM, Ashish Kalra wrote:
> +	/*
> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
> +	 * reserved processor memory. The RMP scan is the most expensive
> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
> +	 * if they can see a cached result in the reserved processor memory.
> +	 *
> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
> +	 * on every other primary thread. Followers are "designed to"
> +	 * skip the scan if they see the "cached" scan results.
> +	 */
> +	cpumask_copy(follower_mask, &rmpopt_cpumask);

rmpopt_cpumask is constructed after hotplug is disabled but ...

> +
> +	/*
> +	 * Pin the worker to the current CPU for the leader loop so that
> +	 * this_cpu remains valid and the RMPOPT instruction executes on
> +	 * the correct CPU.
> +	 *
> +	 * Use migrate_disable() rather than get_cpu() to prevent
> +	 * migration while still allowing preemption.
> +	 */
> +	migrate_disable();
> +	this_cpu = smp_processor_id();
> +
> +	if (cpumask_test_cpu(this_cpu, follower_mask)) {
> +		/*
> +		 * Current CPU is a primary thread in rmpopt_cpumask.
> +		 * Run leader locally and remove from follower mask.
> +		 */
> +		cpumask_clear_cpu(this_cpu, follower_mask);
> +
> +		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
> +			rmpopt(pa);
> +			cond_resched();
> +		}
> +	} else if (cpumask_intersects(topology_sibling_cpumask(this_cpu),
> +				      follower_mask)) {
> +		/*
> +		 * Current CPU is a sibling thread whose primary is in
> +		 * rmpopt_cpumask.  RMPOPT_BASE MSR is per-core, so it
> +		 * is safe to run the leader locally.  Remove the sibling's
> +		 * primary from the follower mask as this core is already
> +		 * covered by the leader.
> +		 */
> +		cpumask_andnot(follower_mask, follower_mask,
> +			       topology_sibling_cpumask(this_cpu));
> +
> +		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
> +			rmpopt(pa);
> +			cond_resched();
> +		}
> +	} else {
> +		/*
> +		 * Current CPU does not have RMPOPT_BASE MSR programmed.
> +		 * Pick an explicit leader from the cpumask to avoid #UD.
> +		 * Use work_on_cpu() to run in process context on the leader,
> +		 * avoiding IPI latency.
> +		 */

... this_cpu is neither in the "rmpopt_cpumask", nor is any of its
siblings on "rmpopt_cpumask".

How does that happen?

> +		int leader_cpu = cpumask_first(follower_mask);
> +
> +		if (WARN_ON_ONCE(leader_cpu >= nr_cpu_ids)) {
> +			migrate_enable();
> +			goto out;
> +		}
> +
> +		cpumask_clear_cpu(leader_cpu, follower_mask);
> +
> +		/* Release migration pin before work_on_cpu(). */
> +		migrate_enable();
> +
> +		work_on_cpu(leader_cpu, rmpopt_leader_fn, NULL);

This creates a delayed work and also waits for it to finish execution
which will add more latency than a simple IPI if the comment about IPI
latency above is accurate.

I think there is some corner case in construction of the
"rmpopt_cpumask" that requires this not-so-pretty else block. Can you
elaborate why this is required?

Perhaps the "rmpopt_cpumask" construction needs:

    for_each_online_cpu(cpu) {
        /* Nominate the first CPU on the sibling mask for RMPOPT */
        if (cpu != cpumask_first(topology_sibling_cpumask(cpu)))
            continue;
        cpumask_set_cpu(cpu, &rmpopt_cpumask);
    }


and all you need here is:

    /* Do RMPOPt for local core */
    for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
        rmpopt(pa);

    /* Skip this core from concurrent RMPOPT */
    cpumask_and_not(follower_mask, &rmpopt_cpumask, topology_sibling_cpumask(cpu));

No?

> +
> +		goto followers;
> +	}
> +
> +	migrate_enable();
> +
-- 
Thanks and Regards,
Prateek

