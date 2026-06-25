Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012045.outbound.protection.outlook.com [52.101.43.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2C6233704;
	Thu, 25 Jun 2026 03:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782359135; cv=fail; b=Z2tSYaWY4RuP0lGU33Pit2y5nqjgFQIKXMYxNSS+8r6qAaihIV+LYHol+xIyiyruev84i7iKwJZeVO5AO6+o2oLo6n3g9ReNjvbWYgbar789ogeXQzCu7dMkZ3/LClxq3V/59j1jFWWgRDauNXU+q3pH8IRCagIl3IcCczCdU34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782359135; c=relaxed/simple;
	bh=16UIrMKlW7kuhbDA3a/Af6VsrvccsRopV5TDci5A1Hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OH7XrTgqu1BoFZfUIPuSNbVMqbhJSqLIspgZ/xdctF2qWXSJEAuHzUCvCvO+McAuKq+oXBbBzB7HFTLahnZntXvWD9ZQ1fklJAyHFWMdWm/8h55r9jPVyQwFyqcJtoo8MFggemVvOS1HGMNGje/zsUdFN4+3AMJz9zN2XQ/Dzgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KLIty9cC; arc=fail smtp.client-ip=52.101.43.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KLIty9cC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=doUyJK7Qbiq17wgGcPE/FRHwAUtOm/NvKMlFcnN59GaX+Wzf84yBYv+VdgNK6S4N/Y0ylLrHgzJKJCbbcgmhasAuBMgB94KjuYg8/x9xfCuNTpLSDtb2PCagf57O0+xy2vQ3R+wtYK/dujHNRgdTfT9I+A/WaIUgVy3bpi+ZKc2Uf7gEvUNYEa9Rolsph73BNdxn8Q4DJ6ivBd+xJj+8vrDzKO1UXOmmjIK6zQFkQBxs11ZbGgf9FUYBEnxqIXfAPBKg1gHkgBDYzKiws35+Rwz012AV/7EXKkLj7hNqgMJywjGqkw/90GohcXEo8YoDSt6ZlDWhH2jwhHn3aui5ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VfN3eUSG2znRzzfTRHxAdqKHyd+c/JHdUhek4gynkE=;
 b=SdG8Z20RTn9MMJRVUDrEX/TNQCBOdykTBn3iYjPJkGc7yyYQff+qIGzyCvf//1Fblb5SNWAk3OYCDSkOH/Lmig54PCTBGsXg6BmtPtt+sHU6S+2qQddsWavNhCdUDC1o/a0+OTyDRE51hW1pIq9pH6AHgViZ2Q/iN5Af6LeecxfJqFlSXWNnjzxD57/YwR77GrjT1hKtCo7Pj+7+Ms5MLqJ/Z2dlJM4e4HygkLTT/hvrmtSSZEwLHlZY+tKgvFRKjyKrXAwyaYn8NibriFWRJ4wmYF9z7wVRMfVDPbAxxInzzPapx4mwMapxmHuyVX/eWObLfnIRIgR06+oY1B6/Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VfN3eUSG2znRzzfTRHxAdqKHyd+c/JHdUhek4gynkE=;
 b=KLIty9cCs8L/xdWU80qbco/pnz7HhJelIfxp40SyBdHsBDzE0ollu2+fYxVlhsMgZnHwAm8F7LP2hY4cRwBF2kywtnJmL/OtAglRBRW+mGzy+m4Uov3GgYEueShy1Lag+p5w80IAsaaUDxn5wADZ62n5SqOvKZOt8biu3q98IDc=
Received: from SJ0PR05CA0206.namprd05.prod.outlook.com (2603:10b6:a03:330::31)
 by SA5PPFCAFD069B8.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Thu, 25 Jun
 2026 03:45:30 +0000
Received: from SJ5PEPF000001F2.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::a2) by SJ0PR05CA0206.outlook.office365.com
 (2603:10b6:a03:330::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.11 via Frontend Transport; Thu,
 25 Jun 2026 03:45:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F2.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Thu, 25 Jun 2026 03:45:30 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 24 Jun
 2026 22:45:28 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 24 Jun
 2026 20:45:28 -0700
Received: from [10.136.35.225] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Wed, 24 Jun 2026 22:45:18 -0500
Message-ID: <fe9927ad-a06a-4a4b-8122-12644513ed14@amd.com>
Date: Thu, 25 Jun 2026 09:15:12 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
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
References: <cover.1782336473.git.ashish.kalra@amd.com>
 <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F2:EE_|SA5PPFCAFD069B8:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d5fda12-2cdf-43a6-8c2e-08ded26c33ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|7416014|23010399003|4143699003|3023799007|11063799006|56012099006|921020|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7hsn2ndu/gRlF70SupPeY2L975BgWMXWehRiSGy/QrQFwX1HRF+cv9fd8Zv5KAmx0CjQB9HWI9da1cWtY5zKJM8mpxzSt1DB2UKg6uZolhWJANpkxBLAEAloMt5J+b7SqnJI3WygnR4Ql6mKavFyFhGplxFcGFOOGPYZckOKHkzGaaXqIif2UJB7v+mwpG6vIkP5nUQwERmYGXKU2fIvMmMayWOC+Fx/mkkqbMu7kl8qazbZTF0vlDnBKGp5RF/syTmbcOYE9JPdgi823ouGJJAqOb1E/TpYE0Bb/hFnPzA6zjAPHYWrxFxZnQrJh+afvBzU8aCJaaWtNiyrE532Z1LFMa4lVyAHf59n2l4e6yYah+uOYRN7f5+ohFjPrBG9XSzvaLPeZoIiMX1RgKRqlbcYBNOCkQLJEFZPSOBYV34VH5TfmNv2Kf/m8q3NWNx3fEOVMJ2gjJavdwJYDZnPXdh8lYV2Lon0aeDUp1pzdokLpdhjKcoD7K/AFON41oOtMO7qRV/+pCNzYKtHJslTNumABn8RORNI799wga0zmfimGgmt1jthk07OKMphtw4cuxMA/ediqZJDS06WZ+oIO92tsCjR8sYRGMzyIR7fRllblR+FWDkhdTLnVo9cV43M9U4/9kC0npHKgxHofnXS6uUqHGLyoN4XIYlAo4Lf9Gyg5MgGwWxV1wYDvbudFfXRAal8QXU8TTZINPfw52foNmM9P/iRxi767NX3ndzEdWO/zxvFkdwxXoWlDLVa6zvA
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(7416014)(23010399003)(4143699003)(3023799007)(11063799006)(56012099006)(921020)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QYbELyHSP3QNLkiY4kquqVUV1EZ7ceW3QLSi8Hgtv8+8ie6j/8KjrQTScq3Gxe0FE3pLdzZKLP6TiztgWbWGXMysxtsdC9S1AMr/AEhSLJHHbk3Sy/nii6n3M/rBoKTI8h9kW96xxo16sAGIzOjd06/bX70F36N6bUNz1IivfGuXSHziuTZJNfjc8fUHAH/UH1rtNU+WOv7j3iUyLbl2g10gITX3q0sy5Q6HY7pd5dOPTHTM7hooZE+1G65q8XVn1O80RgiH4hdMdGr5pRM+05Z2z5Migj+8ZmepPBdA4FGGqTGnNmnz94oBoKOorv1gyxc8UEGhOqSw+SI237zBCp+WfObMmii3WY5YumKQfP0vn6cpfWQxcCcrChphoYRxVucP6Jtk0p4YBU7qpoHlYrRYQ/0vUL4mL/VbRo9baSxc0ZaChEQ8GzcMicPLEdhc
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 03:45:30.1908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d5fda12-2cdf-43a6-8c2e-08ded26c33ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFCAFD069B8

Hello Ashish,

On 6/25/2026 3:26 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> While SNP is active, every memory write is checked against the RMP to
> protect the integrity of SEV-SNP guest memory.  By the SNP architecture
> these checks cannot be disabled on a subset of CPUs: they are gated
> per-core by SYSCFG[SNP_EN], which the SEV firmware requires to be set on
> every present CPU before SNP initialization.  A CPU that does not have
> SNP_EN set and was not initialized via SNP_INIT performs no RMP checks at
> all, so there is no valid configuration with SNP active and any CPU exempt
> from RMP checks.
> 
> The firmware determines which CPUs are present from the processor and the
> BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates
> them at SNP init; it is not aware of the OS bringing CPUs online or
> offline afterwards.  A CPU brought online after SNP init was not
> enumerated at SNP_INIT and does not have SNP_EN set, so writes from it are
> not RMP-checked and could corrupt SEV-SNP guest memory, and there is no
> way to keep work off such a CPU once it is online.  OS CPU hotplug can thus
> diverge from the firmware's expectations and break SNP.

If this is true ...

[..snip..]

> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 217b6b19802e..66475145b3fa 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1479,6 +1479,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  
>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>  
> +	/* Disable CPU hotplug while SNP is active (see snp_disable_cpu_hotplug). */
> +	snp_disable_cpu_hotplug();

... then this should be done at snp_prepare() before
on_each_cpu(snp_enable) right?

If not, then any CPU hotplug between the cpus_read_unlock() there and
the snp_disable_cpu_hotplug() here will not have the SNP_EN set.

Isn't that a concern?

Also, this patch can probably go first since the FW assumptions on
hotplug exists independent of RMPOPT bits.

> +
>  	snp_setup_rmpopt();
>  
>  	sev->snp_initialized = true;

-- 
Thanks and Regards,
Prateek

