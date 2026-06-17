Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012070.outbound.protection.outlook.com [52.101.53.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9A42EEE68;
	Wed, 17 Jun 2026 04:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781670029; cv=fail; b=RspwtTKHtntpJbz8rmJVIsGUMwSPUrrzqVDuze2AbhxJXVvBZf/ic561ghYPoo6+lI7IOYFBdNkUbIlYDY4gUqzLdIdkx7In3chsZ7SyYe7tFEq9EyqgKjLdDu/unxUMLui6WE8sfvAfM74S3+iSEvPXRdtHf+8zXoezijKLvJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781670029; c=relaxed/simple;
	bh=ZqiaueTARpD3m9ChhGdcNuLB/5sA3buHT8TA4s7Xmjg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YFOoJvLmPOtlp3TW7FKTxxW8OvfJT+qk8uJCbxd+4yt5wIgwxWmkUlRYuSJxYAxDRYs0NupPTx8Z/ieHbmwp6b0sJ8pW/oM1GCyZlqWfwKUCukYkel+wr1GXXxRBLVYC60lUoQqvHKPqtinzTZYqDtkftZuEDLPcVLupU57vQ+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Rd8/cYn0; arc=fail smtp.client-ip=52.101.53.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Rd8/cYn0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MdollAPNkR8rWxjXp5JAMyMahDgOm6jPyKSlyQeOfvXQ/QM9HRuevCp43ni8akLLT30yTUAETZIgBITLt13FqYNkNwq7BfcGUXpJH1MrbFdiZ66lFZkTnwf9aySSyuXXpeCDTVNwgS5n/0QawnGrGRuQVkfPp9lseMpTglJtDft4MqNzIH5rldOVZHm4UYRzTCXGoOD2yT16n+1M0M5kHFjEe/5s9lotC6dJ2gtXSifgKq4YV/qkskbH3cD+RJKHxEOTCm+Sw4ag2lxh4JOKBBuH2+pKCNffOUFvgrV++GCTYxR7zxEu2I9OjyPQh4ejiUCPbE5WAvZNv2joW+MBvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lY5QJTlhUavwuEBsfGWMh4S8E3D5zTkQs0EuswLZ5D0=;
 b=fdhcxhnp3ZLn6Nnuwat/AvNcFQrxjFrjXV6VLzJEQg+Ejcme9hAjXhQO6vjYtqrqMuGYyQ8et7t71cB6M64j0BrIzny3t5c1NdoVq48v7+rRRo6Lk2Z3DWlscEqFdnaXEfW40GoA0txd0Tgv/ceNNh9UBi9HkLngAXMVP+GVHDVdYpR1rvqfooQBAXXZMxXx4DXF+H8Ib/UvjZdrZ3r8ArfPnvd3sFZt5T7l8CgNbM66sd8Df5CjXojQxtAb2r9AZxVjYF/HiCodAXJfiKEhV4pl3ySNG0iZ/hLbcyallosN+PYXCz1+hRexoMya59bVw60u5eRBFBaGXVBV+KtRsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lY5QJTlhUavwuEBsfGWMh4S8E3D5zTkQs0EuswLZ5D0=;
 b=Rd8/cYn0DmS8HPziz+60qLuHV76dZa0T1VT+l6g0EOCkbEM2ojxhCKuNW/3q/aKV6/x4Do4GzBf/CoQN1dr18CFfHiX5HEXqItDFPWxr5NURm8yGLf3pLbw25pnZYk6tUcfN/kGwvq3hs3howbNIQL2SKcWnEkP6vDlEm0HSEyc=
Received: from PH7P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::31)
 by SN7PR12MB8789.namprd12.prod.outlook.com (2603:10b6:806:34b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 04:20:19 +0000
Received: from MW1PEPF0001615B.namprd21.prod.outlook.com
 (2603:10b6:510:326:cafe::af) by PH7P220CA0026.outlook.office365.com
 (2603:10b6:510:326::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.18 via Frontend Transport; Wed,
 17 Jun 2026 04:20:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MW1PEPF0001615B.mail.protection.outlook.com (10.167.249.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.0 via Frontend Transport; Wed, 17 Jun 2026 04:20:18 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 16 Jun
 2026 23:20:16 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 16 Jun
 2026 23:20:16 -0500
Received: from [10.136.46.240] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 16 Jun 2026 23:20:07 -0500
Message-ID: <75cf11f1-51fc-4f1a-a9a7-4b9403d2bb8b@amd.com>
Date: Wed, 17 Jun 2026 09:50:06 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/7] x86/sev: Add support to perform RMP optimizations
 asynchronously
To: "Kalra, Ashish" <ashish.kalra@amd.com>, <tglx@kernel.org>,
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
 <0fa0bc95-ff31-40c5-b083-3c885d09d0ab@amd.com>
 <8c5f4082-e3a5-4f65-b058-33938a7ee324@amd.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <8c5f4082-e3a5-4f65-b058-33938a7ee324@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF0001615B:EE_|SN7PR12MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 255862f4-1ade-4991-d563-08decc27bd64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|23010399003|1800799024|11063799006|921020|3023799007|6133799003|4143699003|56012099006|10063799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oVegOAddkqIewoTY1W+rNHXrUS1a2GOETvEJtOyjyOCqPeUQlMSDt0TEXTY/V9ERBmJG4kwYdt4Kvc/nZAH2XYmY4R9SWRNv2PB42A2oLdDqCDwf1pTqTLCoujDyNHIjDy3dWyDQivzU/hq98f3mrX3qwmnPkDydGR2vC17KZIw4vJzg6UuirrRxtTyKf2kjSNSO5VQa/bb5DOc6OFNSx/c0lZU7nWJM1HyHMo3BmLUfVSebzhRtt9V1ZIZaAk05Z5STTtzh+p2e2BGgKiEp55ZVwuBopXi43rQZz1/lqtEG4H6P69Owh6jUkZ6SI3sJK3iFKVJzqeAtOmPlrooaAVCJPKRTp+NZ6GnB+IuoKKhdr6uamchFKW8+oUd+ZCeIYwi4ssm0T2YFsYg3uo+dqKhW1ZbllvX1WpQ2VXyL6GltiwmDdwUcK9DZn1b+db0zVMdzlQfuT9bef8EkocgoYHKPsMXKYYKDbIVTgcdyKCTVpKbUIGqIn9MIJWEsnbOO6uyn8RvIPYd1VGMGMlA53denqE4JGHDvUHAOCEr5R/rgiTpcAx+yDsr8g+E1g9JYN9V9CGz5mV0bM4pbWgg5Dtp9hub/viHSXtvV/8QR9l/ZOaJIT34LGOzSe79k2+8Ew00dnDfMqsFGn+kXxl8B3+kh4k7uIaupxQE0+Y1V8TjrhlCMeW2/FhiJwthX5PoKyytTTaLec+tJaT7IBY0n0gOEEI9t/CAwoQc6uYLU9ZUVQincG3qZV4hyo3bMEwDIVRPvfOa2SwaSjIUDiNHVzA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(23010399003)(1800799024)(11063799006)(921020)(3023799007)(6133799003)(4143699003)(56012099006)(10063799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LbtmoSN1NCcbRBiw7UvojXlLNdRxzx9smCpdZ8ezIs8fKmGwOAYX0KtXY0nSfX3ocheApN1mn49wuCjaHVaKgLxB+n9Kq0HKCAhxTjTTPjFv6i5Zb9lUpr9ZF0N+N4r3wIKL0ecM/pMrGXS7Hi+dq4i7U44v5kurCDV2UuW20HkWKzv0NuUFh00QMr10cubG1sSZlPNJsXoTPbkKcOeU7jvHqrvJXwR7nE9+FUehw31ubJWVjvkOdMhqBZ6XkwnJLZVz8eTmco4/SBMUawg6wC0h9fYQ9NKMntbWEoN+HBzquBtHQu1wpHU3tGmhgz7QNGEU398TeVxR4kMT5EB+JRziIPuLs2vkVVGogsFCEr3/n/3xRrRxtDGxeJv9O0FAgBA4JDQvrQoc/8Twb9B0h1ijMvcRy84558yZX2MdpmsBp9Z2yNX8AxRD25jHo3YM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 04:20:18.5766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 255862f4-1ade-4991-d563-08decc27bd64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF0001615B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8789

Hello Ashish,

On 6/17/2026 1:26 AM, Kalra, Ashish wrote:
> Hello Prateek,
> 
> On 6/16/2026 2:27 AM, K Prateek Nayak wrote:
>> Hello Ashish,
>>
>> On 6/16/2026 1:19 AM, Ashish Kalra wrote:
>>> +	/*
>>> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
>>> +	 * reserved processor memory. The RMP scan is the most expensive
>>> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
>>> +	 * if they can see a cached result in the reserved processor memory.
>>> +	 *
>>> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
>>> +	 * on every other primary thread. Followers are "designed to"
>>> +	 * skip the scan if they see the "cached" scan results.
>>> +	 */
>>> +	cpumask_copy(follower_mask, &rmpopt_cpumask);
>>
>> rmpopt_cpumask is constructed after hotplug is disabled but ...
>>
>>> +
>>> +	/*
>>> +	 * Pin the worker to the current CPU for the leader loop so that
>>> +	 * this_cpu remains valid and the RMPOPT instruction executes on
>>> +	 * the correct CPU.
>>> +	 *
>>> +	 * Use migrate_disable() rather than get_cpu() to prevent
>>> +	 * migration while still allowing preemption.
>>> +	 */
>>> +	migrate_disable();
>>> +	this_cpu = smp_processor_id();
>>> +
>>> +	if (cpumask_test_cpu(this_cpu, follower_mask)) {
>>> +		/*
>>> +		 * Current CPU is a primary thread in rmpopt_cpumask.
>>> +		 * Run leader locally and remove from follower mask.
>>> +		 */
>>> +		cpumask_clear_cpu(this_cpu, follower_mask);
>>> +
>>> +		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>>> +			rmpopt(pa);
>>> +			cond_resched();
>>> +		}
>>> +	} else if (cpumask_intersects(topology_sibling_cpumask(this_cpu),
>>> +				      follower_mask)) {
>>> +		/*
>>> +		 * Current CPU is a sibling thread whose primary is in
>>> +		 * rmpopt_cpumask.  RMPOPT_BASE MSR is per-core, so it
>>> +		 * is safe to run the leader locally.  Remove the sibling's
>>> +		 * primary from the follower mask as this core is already
>>> +		 * covered by the leader.
>>> +		 */
>>> +		cpumask_andnot(follower_mask, follower_mask,
>>> +			       topology_sibling_cpumask(this_cpu));
>>> +
>>> +		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>>> +			rmpopt(pa);
>>> +			cond_resched();
>>> +		}
>>> +	} else {
>>> +		/*
>>> +		 * Current CPU does not have RMPOPT_BASE MSR programmed.
>>> +		 * Pick an explicit leader from the cpumask to avoid #UD.
>>> +		 * Use work_on_cpu() to run in process context on the leader,
>>> +		 * avoiding IPI latency.
>>> +		 */
>>
>> ... this_cpu is neither in the "rmpopt_cpumask", nor is any of its
>> siblings on "rmpopt_cpumask".
>>
>> How does that happen?
> 
> Actually, this was the implementation before the CPU hotplug disable enforcement code was implemented and added in v8,
> and i should have fixed this rmpopt_work_handler() accordingly for v8.
> 
> With the enforced cpu hotplug disable support, case #3 here (above) is now dead code, and removing it lets
> cases #1 and #2 collapse too.
> 
> snp_prepare() requires cpu_online_mask == cpu_present_mask before SNP init — so when snp_setup_rmpopt() programs the MSRs, every
> core's primary is online -> every core is in rmpopt_cpumask.
>   
> So now the work handler always runs on a CPU whose core is programmed. topology_sibling_cpumask(this_cpu) therefore always intersects
> rmpopt_cpumask -> case #1 or #2 always matches.
> 
> So i should actually drop case #3 here - which is: "this_cpu is neither in the "rmpopt_cpumask", nor is any of its
> siblings on rmpopt_cpumask"

Ack.

Also the fact that cpu_mark_primary_thread() uses LSBs of APICID and if
you have some insanely weird configuration - like boot with maxcpus=1,
online all the secondary threads (CPUs 256-511 on a 256C/512T system),
launch an SNP guest - it can actually leave everything except CORE0 out
of the "rmpopt_cpumask".

> 
> 
>>
>>> +		int leader_cpu = cpumask_first(follower_mask);
>>> +
>>> +		if (WARN_ON_ONCE(leader_cpu >= nr_cpu_ids)) {
>>> +			migrate_enable();
>>> +			goto out;
>>> +		}
>>> +
>>> +		cpumask_clear_cpu(leader_cpu, follower_mask);
>>> +
>>> +		/* Release migration pin before work_on_cpu(). */
>>> +		migrate_enable();
>>> +
>>> +		work_on_cpu(leader_cpu, rmpopt_leader_fn, NULL);
>>
>> This creates a delayed work and also waits for it to finish execution
>> which will add more latency than a simple IPI if the comment about IPI
>> latency above is accurate.
>>
>> I think there is some corner case in construction of the
>> "rmpopt_cpumask" that requires this not-so-pretty else block. Can you
>> elaborate why this is required?
>>
>> Perhaps the "rmpopt_cpumask" construction needs:
>>
>>     for_each_online_cpu(cpu) {
>>         /* Nominate the first CPU on the sibling mask for RMPOPT */
>>         if (cpu != cpumask_first(topology_sibling_cpumask(cpu)))
>>             continue;
>>         cpumask_set_cpu(cpu, &rmpopt_cpumask);
>>     }
>>
>>
>> and all you need here is:
>>
>>     /* Do RMPOPt for local core */
>>     for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>>         rmpopt(pa);
>>
>>     /* Skip this core from concurrent RMPOPT */
>>     cpumask_and_not(follower_mask, &rmpopt_cpumask, topology_sibling_cpumask(cpu));
>>
>> No?
>>
> 
> Yes, a simpler implementation will be like this: 
> ...
> 
>  	if (!alloc_cpumask_var(&follower_mask, GFP_KERNEL))
>                 return;
> 

If you move the migrate_disable() here, you can simply do an andnot
without needing to copy the rmpopt_cpumask beforehand and save on one
cpumask iteration.

>  	cpumask_copy(follower_mask, &rmpopt_cpumask);
> 
>         /*
>          * The current CPU's core always has RMPOPT_BASE programmed
>          * (snp_prepare() required all CPUs online at setup and CPU hotplug
>          * is disabled while SNP is active), so it can always be the leader.
>          * RMPOPT_BASE is per-core; exclude this core from the followers.
>          */
>         migrate_disable();
>         cpumask_andnot(follower_mask, follower_mask,
>                        topology_sibling_cpumask(smp_processor_id()));
> 
>         for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>                 rmpopt(pa);
>                 cond_resched();
>         }
>         migrate_enable();
> 
>         cpus_read_lock();

I think you can even skip the cpus_read_lock() since we know for a
fact that hotplug is disabled when we are here.

Perhaps we can have a lockdep_assert_cpu_hotplug_disabled() which
ensures we'll get a splat if that assumption ever changes when
running with LOCKDEP?

I'll let others comment if that is a good idea or not.

>         for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>                 on_each_cpu_mask(follower_mask, rmpopt_smp, (void *)pa, true);
>                 cond_resched();
>         }
>         cpus_read_unlock();
> 
>         free_cpumask_var(follower_mask);
> 
> 
>  Here, the leader exclusion must use the sibling mask, not clear_cpu(this_cpu). That's why my collapsed version uses:
> 
>         cpumask_andnot(follower_mask, follower_mask,
>                        topology_sibling_cpumask(smp_processor_id()));
> 
>   - If this_cpu is a primary: its sibling mask contains itself (the primary) -> andnot removes this core's primary from the followers.
>   
>   - If this_cpu is a secondary: it isn't in follower_mask at all, but its sibling mask contains its primary, which is in
>   follower_mask -> andnot still removes this core's primary. 
> 
>   So either way the current core is dropped from the followers. (The old code needed two branches because case #1 used
>   clear_cpu(this_cpu) — only correct when this_cpu is the primary — while case #2 used the sibling andnot. The single andnot works for
>   both cases).

Ack! And I think this looks much cleaner (to my eyes at least ;-)

-- 
Thanks and Regards,
Prateek

