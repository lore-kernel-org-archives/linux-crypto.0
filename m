Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010029.outbound.protection.outlook.com [52.101.201.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F332F99B8;
	Wed, 29 Apr 2026 23:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777504086; cv=fail; b=sKZA4aYYm6nUhdbH6hFXMQr+Dg9hIW9fmSYmD2nDpy4JbkiOwuH/LpsMaripzO26+QRK/7NsXejjc8M2nN3ESwtaMSeUvE2eb1e3jpHhdkz6PDULY1h44Yu0OXEqOXN+7w2FXtOqcC8xC/F4/gx4sUZa6Bgs7+LpPxqcHuu7JWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777504086; c=relaxed/simple;
	bh=K3PRnNmhxz3nbu5YtzBR8GOpsFdClQTcrLVMBW1f7co=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AxKvWED8uJzSM59NUBIZHdRyjYagFdW2/E374+QhQTJLiGixq73LNF1m0eS3O5bk+Se9UNp3g7yygapne3AhEmpy2WsCNZYBqEvMZNydgKF+HCXP3iMCRm0jqhF/qlFHb8JnplRSzSWi3mn44m4tXuoihbEGwRMSr+f0ZqIUIcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OP9rwvlH; arc=fail smtp.client-ip=52.101.201.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OP9rwvlH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TxFoawJXLuxwWrspkGfwMYcHEJ8Sb4Y5Tc8qxKmsY99+AluKw04+fdpptAW5oiggbq4WNe4YE0pmpTjZVlwym78cm4hZXbNBwwuQ0wkCFGbNrhNyt2sBDsKsbvqk4Dw+0DGTMtN4kjJhAY6rUR3wi065oVPQ7qwUFPaq4Uvw7qG4IwMg6Pfibr26EpjqEaCKrE40vgi3TKRO0ZeECch1PnXhjlHYOpCMtIIYxqNmZFM6dm4Wk58/4XX68gK8vWn0rpKZhesB71k68A+Yomr5KLODWYXQV1L7GvHKj7FWJpr7KRZ93Eb+J3EA2A5P2rgH4WZLOben8mFlzIjx0sJ6yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ozRrtiBJoQOnMmU4yyrJ4g1J9Lw8Gaj9ZSLR3TSELw=;
 b=RYesUwTdf7mx8IGW2fsBw4cmiYQ/9ul9SwUdg11sWctDuGeGpz77cSIZxycSJAO9yhhH+OskfZFAhMJLwuUv+E4VKWoQQ1LF2ijhsxX3X4unYfRk7gIDnBA9zuRXQkokvICmVmhY1bnDN0YyM9ftnyqLrB28C4xmPD5iZg6QeyJGpLwA92oIxOJfzaSIgGhjAkhC3Q4czO9qUP1hUux2mL2N9yoU+NfXL2jWw4bDSfamrHKqv7cZ9TYaghqXMabEJnkQV0uBBRkCfIzObF0yU7pH3rY8/8kT30KhHqWIaI83Sy3fJ5tBUFQ+sC5Ju/qNc0v01i70hAgXa/q3Oy/dtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ozRrtiBJoQOnMmU4yyrJ4g1J9Lw8Gaj9ZSLR3TSELw=;
 b=OP9rwvlHR5Kjmc8a+zu9q0uVZfKxtLq7Vzl8iOpguFXS41iRTF/OY9PdIShqpC+b9vO30IJ+j7w0DbSXRihVQk6o7b5j7rBZdCFSMBsWJWM3aJxjqFYpANMUz4xgiaOpXQVMMtLhznhy1Uw5Z4h54NGeq94qcwIH3jkT4kq9o0I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH3PR12MB9454.namprd12.prod.outlook.com (2603:10b6:610:1c7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Wed, 29 Apr
 2026 23:07:45 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 23:07:45 +0000
Message-ID: <e8ceeb35-b300-4f7e-8b91-775b141a89c4@amd.com>
Date: Wed, 29 Apr 2026 18:07:41 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] Add RMPOPT support.
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1775874970.git.ashish.kalra@amd.com>
Content-Language: en-US
In-Reply-To: <cover.1775874970.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:610:20::32) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH3PR12MB9454:EE_
X-MS-Office365-Filtering-Correlation-Id: ac10eb7a-609f-4919-d30e-08dea6441f98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	N9NbJxb3WtWGdPyHS8x6txoAbeSd59iB/+vlrJAa1GETi1i8BmBf9TTiGjT9fYa7q3/RFboYXY007dTEkbEVQ9cpGDM3lrRXbdtmEqiw7LiFRKdwlNM26WdSbUKXSlBhBKt8dtzA2qaN50xbTF2o864VMT5poLnaGMnYODyiyOqnsrX6G/drDk9bQ449KqeMduHik4orE8CM75LKnIyKTkM8kJZJ5CprXhUSIKmwSHPOzfI2YfS9QkDRB6pkDvQkK8DIZA1uI7ZA/msg80YEwvE52EG84rcSaBMw4N94ZXXVpOVFY4pBZ3hxp9Z6c50FMQKYq9MwFaglu3opJPHr/knxMkPMFWpmTUKo+H8nwLhlgHtvagrZmzFEysJTkRT9ceZGVAYhILddsQ++yyUXRUuEeKCEARp35hF+NIx1awuKqakt5YPXdHAy9A9oWetjs8sSQPuwKX+2pKV6ar9qU+Fvbrkizt2HLcSQhZQI3fFHXTYV0XZN43sNyNUHYWT7T5o09DlQP6rOWQXrHtLWGFL9HczoD4pA8N5uaPikX9TciRetwOlv5UFCVhSukxYIxVfHcxFcHxd3Bvpg+16mBea9rkynYe3HbdWDA5C87kDrkqNhjK96m8FI3ue0Tlk5W0RYw3mJVx7HTDbbDUdwkCjUEYvnLh43clV3+jNHqk6rrUbFlULXAzvb7gtWn9Ghv47Qx49y92rltBOwKdWjk/kWceFrkL3YF5UxHUHNGmCGAR3Bll+JLLAGv6znfknZKo1MV55mqk76ueVhW4ikqg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWVUT3J4aHowL0lRZXpaZGpGV0pSZWVOQkw2b21HdHNHczR3SGdHUmlEajhh?=
 =?utf-8?B?TFNqNm81Slpjd3NuSjM5b0VJZVZmSnRCeVFqSzVQcGl2S2ZlbmRsNFBnQ0lX?=
 =?utf-8?B?VTVqQ0w5WERlWGRFdUVDZ0RmeVljMXR1V09CVkkvYXhQUW5SUlFKbmlWS1J0?=
 =?utf-8?B?cVB1UU0yRjA4bnh2VDRvWm1BSHdQdURveHZoNGxuVERXRGpIaDFHNlk1eXJ2?=
 =?utf-8?B?QWlmdUV1K29QR092b3VzYzlJTTJCWmxyQUdaQnllcUlaRXhmQVRNVlNnT0hM?=
 =?utf-8?B?WGlwaWxhTjc2Q3RoVzEwcGhsMWVTOVB5bUNodm1paGoydjV2ZkVNeVFtVnBO?=
 =?utf-8?B?THJxaWMzN21SL2FmaCtmeHpwUHE3OS9LUGczR3doNittRDV5RWJ0TmZQSFpj?=
 =?utf-8?B?dnMzby9GNE1mUkZtSURiaEdvY3R3ZkVVU2t2a1FYdmNkb2J6ckUya1VpajdS?=
 =?utf-8?B?UkZlSGhwK0JZeU1vS1YyREI2UnZQSFpOM3NRYkEwMDIxS2Fkd1MwTnZWSjhH?=
 =?utf-8?B?RTB4UHpjSDNOQ2xvOHllQStORU44M0p0TE8waWQybkdXdXBCMEhtUmEwajVN?=
 =?utf-8?B?K2hDNkwrYW5sdGhGa0FyalJHSjN4eVRwN1BibWZiczc1TUNjWm5XSHFzUEFj?=
 =?utf-8?B?aFdESktEL1Jydi8xNlQrY1R6WXNGZmJad1lVd0V1Zy94N0ZuUW1iQlVBUlA5?=
 =?utf-8?B?Nzcrdit6NDNWRVdhcTAyakt4dlUrK00xWGtXZHM3dS81b05ldUpzYlZpUGoy?=
 =?utf-8?B?ZGFmMFNWQUMvenZpbnRqMXQyb1g4Z1JCSllzaURIYU5XMEdvczFQOEJveklX?=
 =?utf-8?B?dmx4TVFLdTJrdnlTVERERGUyQXZtVURHR1JKczhvRndrMGhia21yTVhLcHh2?=
 =?utf-8?B?RWd4R1dBeW9YT1NGUTR2ekRYMXNnWFRRUXBTRWQrRVRkdE5FY2dKYjVLUEI3?=
 =?utf-8?B?QWtCT3llbmQ3Y1JDR2JSeWx2YTNkL1FseHJvNGxuWjZpWTE5ZU9HazlJZGNr?=
 =?utf-8?B?KzltOUhtSzE4Z1NJT3N1a2xYTERPb20yN0xudmE0OG5CTURlRXUzK0dWaWhG?=
 =?utf-8?B?aXgrd1pITDE4dW1uNFRMYzBjU0xrWm9sVXZHVEE2OXNOZnVlL241dXM2cXpE?=
 =?utf-8?B?L0JFNEFTcFBoTjQySXQ5YXkyallWN3NjdjdRcDdZOXJSZkl3NFdEMFdWc3Bp?=
 =?utf-8?B?b3duUldKUmVZNFBaSURWSjJHZk5hRWhDVmxDRG1YYUtOUzBmcFdqeHlnOFU4?=
 =?utf-8?B?YlNscG5HQXN2cFFiNWpyR0lJUStXNk1ON0d3Uys0RUdVY2RNenhkQjc4dmNV?=
 =?utf-8?B?emdjMktlcjdtYk1odU1CTFhyeDh6Y1BqOXpmcnJ0SUZrVTc3dTR5TFBRRTd1?=
 =?utf-8?B?TUlsRXBlUXE2MjdtNy83MForYnRLMlFSNDhKYUtwRnJ6UlY2cnVySFJNOXF3?=
 =?utf-8?B?bVIrenVTdCtBY2dMR29NSnFrTHF5eHorVENjRUJaT3JKUnpNL2h3MVNxSTFa?=
 =?utf-8?B?dlBGNnNFd3BOVnRTNVJnL1daVUptYit1MFVIbVQrRmM0OVd3RktTWDZlNFdI?=
 =?utf-8?B?MFJOOURTY0tveGdSY1JIdFRqSGRWY0pvay9ZMy9rNHpiU2E0K0EyTU9zc0to?=
 =?utf-8?B?YmwzUEZnZ3ZWYXoxaWxDVms5V1VaNDRRTFY4clg3TlJlYk83OWYwMUhNK3dt?=
 =?utf-8?B?YkRJbk9wcER1L0czekxVSzMvNjZkV2tRNEptQS8xZHVuK0VjM05GVEJoQW5J?=
 =?utf-8?B?OVhHZ0dJRytIRmZUdEJXSjd6L1VuMTNaQVlSVlR1a21UT3hJeXFyT0dXcWVt?=
 =?utf-8?B?NnY1VUFYL0dxbmhUVEpTVEtMbzQzRW1tdllIaE1tSkxwY2ZGUWVmNGM5bWhZ?=
 =?utf-8?B?TW10TFN6VTRxdDRTdWQ0ZGpva1NPWDZKaEdaSFVzbXhLZFR4SFZBeFAraEFG?=
 =?utf-8?B?VnFFajg5SWVuQ09VSm9Hay9JQS9JS2YyazhDdFp4MkJQQjFCczBpNklxaEJ0?=
 =?utf-8?B?c1pJRVlDRGp4M3NzTWkrR1U5ZkpIZjJ4VUMzUlIyaWphYisyMHA2WTN1d1Nx?=
 =?utf-8?B?WEt3V0pybUhPdjVHcjR6c3VKZS82NEhCYU8wRUJtUUhqVDUraEd5L1ZsK2hI?=
 =?utf-8?B?TkFXUmpFVHNybm9GZVBCMnNRQUcwOTZvamNJZlVhQll2VnNkeXBpb0M5cHJN?=
 =?utf-8?B?WGVDRVBKUGRnVkhrNEdDR1UzbVBTek9OZ1J1VEpITEJzZjgyM2tFNmxoUjBQ?=
 =?utf-8?B?WjdxNUNUbW5yVm05Rk5nYnVKS2dvTUwyaEFkZUw5bjlGQXNsbkNXUTd6anRZ?=
 =?utf-8?Q?oPb8DIf3YRDIAU0m5i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac10eb7a-609f-4919-d30e-08dea6441f98
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 23:07:45.3277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rC0hsWTtmw4/n0pN4Ql/Z9HWS7Jw5u9BA+aPca03AzVusTTJg9gGpU2YUB8bpQZlok+DNFwGyL9aVaZMrIFztQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9454

Hello Dave, Sean,

Looking forward to your feedback, comments, thoughts on RMPOPT v4 patch series.

Thanks,
Ashish

On 4/13/2026 2:42 PM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> In the SEV-SNP architecture, hypervisor and non-SNP guests are subject
> to RMP checks on writes to provide integrity of SEV-SNP guest memory.
> 
> The RMPOPT architecture enables optimizations whereby the RMP checks
> can be skipped if 1GB regions of memory are known to not contain any
> SNP guest memory.
> 
> RMPOPT is a new instruction designed to minimize the performance
> overhead of RMP checks for the hypervisor and non-SNP guests.
> 
> RMPOPT instruction currently supports two functions. In case of the
> verify and report status function the CPU will read the RMP contents,
> verify the entire 1GB region starting at the provided SPA is HV-owned.
> For the entire 1GB region it checks that all RMP entries in this region
> are HV-owned (i.e, not in assigned state) and then accordingly updates
> the RMPOPT table to indicate if optimization has been enabled and
> provide indication to software if the optimization was successful.
> 
> In case of report status function, the CPU returns the optimization
> status for the 1GB region.
> 
> The RMPOPT table is managed by a combination of software and hardware.
> Software uses the RMPOPT instruction to set bits in the table,
> indicating that regions of memory are entirely HV-owned.  Hardware
> automatically clears bits in the RMPOPT table when RMP contents are
> changed during RMPUPDATE instruction.
> 
> For more information on the RMPOPT instruction, see the AMD64 RMPOPT
> technical documentation.
> 
> As SNP is enabled by default the hypervisor and non-SNP guests are
> subject to RMP write checks to provide integrity of SNP guest memory.
> 
> This patch-series adds support to enable RMP optimizations for up to
> 2TB of system RAM across the system and allow RMPUPDATE to disable
> those optimizations as SNP guests are launched.
> 
> Support for RAM larger than 2 TB will be added in follow-on series.
> 
> This series also introduces support to re-enable RMP optimizations
> during SNP guest termination, after guest pages have been converted
> back to shared.
> 
> RMP optimizations are performed asynchronously by queuing work on a
> dedicated workqueue after a 10 second delay.
> 
> Delaying work allows batching of multiple SNP guest terminations.
> 
> Once 1GB hugetlb guest_memfd support is merged, support for
> re-enabling RMPOPT optimizations during 1GB page cleanup will be added
> in follow-on series.
> 
> Additionally add debugfs interface to report per-CPU RMPOPT status
> across all system RAM.
> 
> v4:
> - Add new wrmsrq_on_cpus() helper to write same u64 value to a
>   per-CPU MSR across a cpumask without per-cpu struct allocation
>   overhead. 
> - Rename configure_and_enable_rmpopt() to snp_setup_rmpopt().
> - Use wrmsrq_on_cpus() instead of wrmsrq_on_cpu() loop for
>   programming RMPOPT_BASE MSRs.
> - Add setup_clear_cpu_cap(X86_FEATURE_RMPOPT) if segmented RMP
>   setup fails or workqueue allocation fails.
> - Add X86_FEATURE_RMPOPT feature clear logic in amd_cc_platform_clear()
>   for CC_ATTR_HOST_SEV_SNP.
> - All of the above allow checking for only X86_FEATURE_RMPOPT for both
>   RMPOPT setup/enable and RMP re-optimizations.
> - Rename snp_perform_rmp_optimization() to snp_rmpopt_all_physmem().
> - Split rmpopt() into rmpopt() and rmpopt_smp() for SMP callback use.
> - Introduce separate rmpopt_report_cpumask for debugfs reporting,
>   distinct from rmpopt_cpumask used for primary thread tracking.
> - Remove snp_perform_rmp_optimization() call from __sev_snp_init_locked() 
>   and instead setup and enable RMPOPT after SNP is enabled and 
>   initialized.
> 
> v3:
> - Drop all RMPOPT kthread support and introduce adding custom and
>   dedicated workqueue to schedule delayed and asynchronous RMPOPT work.
> - Drop the guest_memfd inode cleanup interface and add support to
>   re-enable RMP optimizations during guest shutdown using the
>   asynchronous and delayed workqueue interface.
> - Introduce new __rmpopt() helper and rmpopt() and
>   rmpopt_report_status() wrappers on top which use rax and rcx
>   parameters to closely match RMPOPT specs.
> - Use new optimized RMPOPT loop to issue RMPOPT instructions on all
>   system RAM upto 2TB and all CPUs, by optimizing each range on one CPU
>   first, then let other CPUs execute RMPOPT in parallel so they can skip
>   most work as the range has already been optimized.
> - Also add support for running the optimized RMPOPT loop only on
>   one thread per core.
> - Replace all PUD_SIZE references with SZ_1G to conform to 1GB regions
>   as specified by RMPOPT specifications and not be dependent on PUD_SIZE
>   which makes the RMPOPT patch-set independent of x86 page table sizes.
> - Use wrmsrq_on_cpu() to program the RMPOPT_BASE MSR registers on
>   all CPUs that removes all ugly casting to use on_each_cpu_mask().
> - Fix inline commits and patch commit messages
> 
> 
> v2:
> - Drop all NUMA and Socket configuration and enablement support and
>   enable RMPOPT support for up to 2TB of system RAM.
> - Drop get_cpumask_of_primary_threads() and enable per-core RMPOPT
>   base MSRs and issue RMPOPT instruction on all CPUs.
> - Drop the configfs interface to manually re-enable RMP optimizations.
> - Add new guest_memfd cleanup interface to automatically re-enable
>   RMP optimizations during guest shutdown.
> - Include references to the public RMPOPT documentation.
> - Move debugfs directory for RMPOPT under architecuture specific
>   parent directory.
> 
> Ashish Kalra (7):
>   x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
>   x86/msr: add wrmsrq_on_cpus helper
>   x86/sev: Initialize RMPOPT configuration MSRs
>   x86/sev: Add support to perform RMP optimizations asynchronously
>   x86/sev: Add interface to re-enable RMP optimizations.
>   KVM: SEV: Perform RMP optimizations on SNP guest shutdown
>   x86/sev: Add debugfs support for RMPOPT
> 
>  arch/x86/coco/core.c               |   1 +
>  arch/x86/include/asm/cpufeatures.h |   2 +-
>  arch/x86/include/asm/msr-index.h   |   3 +
>  arch/x86/include/asm/msr.h         |   5 +
>  arch/x86/include/asm/sev.h         |   4 +
>  arch/x86/kernel/cpu/scattered.c    |   1 +
>  arch/x86/kvm/svm/sev.c             |   2 +
>  arch/x86/lib/msr-smp.c             |  20 +++
>  arch/x86/virt/svm/sev.c            | 271 ++++++++++++++++++++++++++++-
>  drivers/crypto/ccp/sev-dev.c       |   3 +
>  10 files changed, 310 insertions(+), 2 deletions(-)
> 
> --
> 2.43.0
> 
> 
