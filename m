Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010037.outbound.protection.outlook.com [52.101.46.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B8737CD37;
	Thu, 25 Jun 2026 22:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782425792; cv=fail; b=uOofq8BTx8t0RdlfdKgGchFfXGG8rZ6JuyJK2oHBOaC+1xPS9qk8uKjQ4y7a5ZWuGiC89embc9qli15fIVeF4EsyRLLpVTlxD4uKjbJqtSkcL6h5x+ZElUdMbYdOg4ZF3BWLF6O3J/r092qf0ajcY8WD6uB9g2+euL/2hWxxkgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782425792; c=relaxed/simple;
	bh=pnZgpY9JSTt1y12weju0XJYPWmQbq9CfKh9lrjyHQ/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=moJxUTMzMk5kLL+Qc1elyCXBAZjooawW4ripNyoaezMvJmLsSWd9zsq7PQMwte7HmjOdO3BNIR7e8eRlJe4mfbj1gU4Z2aY3GEgLhFxCsctNoZ0/E5qMHXnITls8381RRL802S/20bc4VK3erGBKiHjccqc6WUSCnTSq4Ao4Lec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2e0EJT4p; arc=fail smtp.client-ip=52.101.46.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2e0EJT4p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=evCkHriiYV5nDlSIFC8JLkjnqzWoytV6ARAhC6+VOJUIpWiueCDxg6c3HAJSwp2xwIP/3bV6GUw42X4miLQ5tTg8qFjIQf7sq957VbAJPThgEF1CcIjlk0/OkGRFnVroEntX56oJE3KNv30EEnLcAI8SKJASNcxeFQUvto6o/r9bDsik40cXxp9Dc3JvA9ff1tUdBxaHTZva7Fod/cvfvvj0JwjFmSuOfosfWaC96au+GobqUbkgGkUkfpxxxtJGhBVcCBfU+IZ1PuqlpWlThfuRjVmEdyyPsL1dHkerMs8Eww64W72Wi7IU/kgHfTrsK3fa8Las5pxyJVYfcZFuNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XY6v4ff5fR6nZrP3+BFcd2C4XpfWZ/79ce8CyCKy++g=;
 b=Ejp2oBs8WOptIiKL8GywN3pKLg3qYr5uwh2YryIKIBGFMmPG7jK8f8nYITajGndzQDW+iX3CBfWK63Tp/y3kFFBSzXVBp20MEdGo3Il9EpUA/jDtiwhyhBDvxplFh92clcKEEhUiPS4Bv2uYrWX/w95KliTu9Gyy7IQeBlcqgEHSfMFTzONjT3r8Rx1MwaoypnKfFh/MjuDFZ73jdPhczfHO4keikKS1AL7mwiHB58RAXdbZqmPJG/lEFhrVCuCHyKgmPVAgEwQzQzHFNiyHPUqBBvuN8ckhG0s1h1Qvi6g010vHurdiSLiWRkyS93wEKwUHgocFbdqrUcMLOu9Ypw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XY6v4ff5fR6nZrP3+BFcd2C4XpfWZ/79ce8CyCKy++g=;
 b=2e0EJT4pIBXNvaxCHl6MtVnj9gxLRHkXHA/Run0Kib8+tZ3DflKcl7TdhveAbqlmY2NF7smESrusdrgjlgaUzMIMRaUVDMTPuubXjyaWgh0Hqm9JPuV5Ak77iySwQIef2COjRhDWrVDDhW5pFN0KuF/X7DN8vG7kvNk9jaTqiRc=
Received: from SJ0PR13CA0071.namprd13.prod.outlook.com (2603:10b6:a03:2c4::16)
 by DM4PR12MB8451.namprd12.prod.outlook.com (2603:10b6:8:182::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Thu, 25 Jun
 2026 22:16:23 +0000
Received: from SJ5PEPF00000203.namprd05.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::55) by SJ0PR13CA0071.outlook.office365.com
 (2603:10b6:a03:2c4::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6 via Frontend Transport; Thu, 25
 Jun 2026 22:16:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF00000203.mail.protection.outlook.com (10.167.244.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Thu, 25 Jun 2026 22:16:22 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 25 Jun
 2026 17:16:21 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 25 Jun
 2026 17:16:21 -0500
Received: from [172.31.184.125] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Thu, 25 Jun 2026 17:16:13 -0500
Message-ID: <898e378a-cf7c-4310-b439-e28ec0a71338@amd.com>
Date: Fri, 26 Jun 2026 03:46:14 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Borislav Petkov <bp@alien8.de>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<Tycho.Andersen@amd.com>, <Nathan.Fontenot@amd.com>,
	<ackerleytng@google.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
References: <cover.1782336473.git.ashish.kalra@amd.com>
 <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
 <20260625150253.GAaj1DHZC8ULg6PzbI@fat_crate.local>
 <7c64d96f-f932-4db9-8119-b9e40d5b7fd9@amd.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <7c64d96f-f932-4db9-8119-b9e40d5b7fd9@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000203:EE_|DM4PR12MB8451:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f61571a-eff1-4e9b-6b42-08ded30763ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|1800799024|82310400026|23010399003|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Fpx/nTZ2jAfC/zcyysUHDGOajydz1LRE9N2EEyHU3VyetTr3Uutu4E9GPyHvp6m5ubFcle5Ln2fHW6eBugk72+/ACT48aUdIsA743COcRDVeWKVs/CQ3PBYQTX/QNwcxpwCJB1OpkviidHF2w7O25xEIoHCPOmApH1kIgJ2CQH60h2oG2ak8Bn6LcNh3IBUQ89luFNlFTiprf/w7O3zQ031oevHvZPRGBAT4/rtIllAnwF/aA/0N9X7nRmxIzR8QgeDu/ELIN9IvQfoMpa3G9HUPjIIlW2z6/Z0E/zg6uzQ4dPn1NfBYfrJdZO/VBF9f7Q0wz2V5n2U9mPdNWKXA8COddKcDPyWpHE49tb19S0ajTOGrwPuz1M/gBdNMaehbcwD2LSy52mOPxq74ZOvmjUvLdGw9LOthpgM4QXVVhRn7Bu3jCQLS5ccFWK7aJjhPvkGzScanLmqgjQdbr0MSR+98JEhZUJhrTehhDefPuklbGXRqBYFq1c26eUNaYRsP6zWTSPA3LPcJJIBA7BAragmJyyW/AbX6BtWVUjm7dV7XWsY9V7exKtTRH/IeLAntwXth5gVQ/EaMvgFEKobVyGAo2Uev0xR8eHszAvOe6+iHjN+NrkS+Jrv/D9GSDc04AhFz9FbQImpHW9C5MoB538Hxj656fNTx++uwyK5D3+KlJWLuK/kpJG/oCDf8tgwj6pPQED5pTugfZxCNE9nz7g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(1800799024)(82310400026)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ec49LKsBinFYz5VXFx24rwUfcWnMDzErPHZ99BGB7g9Cg83XxjRStfyUq6kiqnYR/43XDYV9EPfh+h1RgAhFCOImiA3AT1LSFa5lcIthUwVLI4zH67HcZO4MHVi5f4Ti9uOuzEvYcOxn0ah+UyDYL2xG1tuS4mequKVnf+Krzz4/k4kAG7vriuAy++CcfwFaBvkovg0ibV6/9RXYtrFacGgl7VECtQZwBJRat5zoApFdXYKA1kbREY/WgbTtSC7h5e9EQDMnReSD+YSd9xKS2hpuwh+Q85um9xZLsh2T18SNeuAgzYTFUnA1LuSrWtuRylAS07xsPuGKAgXptknDxjQ/boPTVxXah2VQtSRGLhbWPVoIKah/LDA64aquEV2xWNHVKx+G1Uk9+oQO9CR7Z0IQIiSEg1de0+QxxE+Iv9c8E6f5vU5ljw6SMAYC4Y9i
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 22:16:22.7138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f61571a-eff1-4e9b-6b42-08ded30763ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000203.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8451

Hello Ashish,

On 6/26/2026 1:12 AM, Kalra, Ashish wrote:
> Hello Boris,
> 
> On 6/25/2026 10:02 AM, Borislav Petkov wrote:
>> On Wed, Jun 24, 2026 at 09:56:49PM +0000, Ashish Kalra wrote:
>>> +/* Set while SNP has CPU hotplug disabled (kernel-lifetime; survives ccp reload). */
>>> +static bool snp_cpu_hotplug_disabled;
>>
>> Do you really need this?
>>
> 
> Yes.
> 
> cpu_hotplug_disable()/cpu_hotplug_enable() are refcounted (cpu_hotplug_disabled++/--,
> with a WARN on underflow), so they have to be balanced. This flag collapses them to
> exactly one outstanding disable per SNP-active window, because the disable and enable
> sites are not reached a symmetric number of times:
> >   - On firmware without SNP_X86_SHUTDOWN_SUPPORTED, __sev_snp_shutdown_locked() does not
>   call snp_shutdown() (it's gated on data.x86_snp_shutdown), so SNP stays enabled in
>   hardware — SNP_EN stays set and hotplug stays disabled — while sev->snp_initialized is
>   cleared. Re-init after that is routine, the SNP ioctls self-bracket init and shutdown
>   (e.g. SNP_COMMIT, SNP_SET_CONFIG, SNP_VLEK_LOAD):
> 
>   if (!sev->snp_initialized)
>           snp_move_to_init_state(...);   /* -> __sev_snp_init_locked -> snp_prepare() */
>   ... SNP_CMD ...
>   if (shutdown_required)
>           __sev_snp_shutdown_locked(...);
>   - So whenever SNP isn't already initialized (psp_init_on_probe off, or after a prior
>   legacy shutdown), every such ioctl does init -> command -> legacy shutdown. Each init
>   reaches snp_prepare() with SNP_EN already set, and the disable now sits at the top of
>   snp_prepare(), so it fires on every cycle. Without this flag that keeps bumping
>   cpu_hotplug_disabled while the legacy shutdown never re-enables — hotplug ends up stuck
>   disabled. This flag makes all but the first disable a no-op.
>  
>   - Also, importantly, kvm-amd module reload on legacy firmware is the same pattern: 
>   unload leaves SNP_EN set, reload re-inits.)

Looking at snp_prepare(), we have an early-bailout for

    rdmsrq(MSR_AMD64_SYSCFG, val);
    if (val & MSR_AMD64_SYSCFG_SNP_EN)
         return;

Does executing SHUTDOWN command lead to the firmware clearing SNP_EN in
SYSCFG on all CPUS?

If SNP_EN remains set (and Linux can't clear it since it is
"Write-1-only" bit), then a subsequent snp_prepare() will skip setting
SYSCFG if it sees SNP_EN on local CPU.

It can so happen that we enable hotlpug at shutdown, CPUs come online
without setting SNP_EN in SYSCFG, subsequent snp_prepare() runs on a CPU
where SNP_EN is still set and skips configuring it for the CPUs that
don't have it set, and we'll be in a pickle still.

The comment above that bailout saying "this can happen in case of kexec
boot" makes me believe that SNP_EN remains set until a full system
reset.

The only safe way to do this is to ensure all possible CPUs are online
during snp_prepare() and do snp_enable() regardless of whether local CPU
has SNP_EN or not.

Am I missing something?

> 
>   - On the enable side it avoids an unbalanced cpu_hotplug_enable() when the teardown/failure
>   paths run without an outstanding disable (e.g. shutdown of a never-fully-initialized SNP).
> 
> So it's not redundant with cpu_hotplug_disabled — it tracks whether the outstanding disable
> belongs to this SNP-active window in this kernel, which keeps the single disable/enable
> balanced across the asymmetric legacy-vs-full SNP teardown paths and re-init.
-- 
Thanks and Regards,
Prateek

