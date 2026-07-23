Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013028.outbound.protection.outlook.com [40.93.201.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3643BB9F4;
	Thu, 23 Jul 2026 05:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784786355; cv=fail; b=SQkoyyUpE5ZyzLe5Wcw8TeDPOlLhTu5zgnTsurACedCRs8ONUZnewa2NZ9A2tb8PoFYGnvDpuJCpXCqU4fgz0gGEIDZx7fgVxmm0DNPPtYyQQcGTOH27USNg89jImI2CStxQI5pKeT6KJJX0f5BYv6wiAcqYRbu/5+Iibofz3ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784786355; c=relaxed/simple;
	bh=7UDuZZ+n2Xny17MWEa0hcAg2AQQD7WCDKBxGQF1I43Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qdfxb9z7Y5POb8vgZJzW1gFa7y9jZw9B+TXR68pbI6ndjmmK9d3aABxPkjEh6cOC7Ffx1TcdtRVY7hxc0bh19rLlkAMuKaSGknYP8fSJAgUaQc2Wu1misAG0qU6RQ/ntHQWhyjXOhC7AqX4bb9N1tRLpzTY6DAx3mUq4pFxs65U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UZndAlKs; arc=fail smtp.client-ip=40.93.201.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UZndAlKs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uN2gB0ucjTSZkGz8b6MYXExzd/dHBT+tFG3LRMHF0A/YSj2Jp91tUi8Mg0rpKKM+h6hdeZm4kF2j5V5vLqUUr/QdJXTflquT3Aq19EJCU1bOFOjvA2sw5F9pK+mwAxqIHVunb3mxEgMt4gHdvs3PxpfZ/qnmtIBpAeyoNh7sx16mH1y+lmNGdLiq8XQuAkr4EbfMSoSND6XU/B3qlwi9luqpU0EQeuBwerrkbuWQ18PnjmyFMk5SAkr+vtBnfay5ZJgGlEiYWbfuILf6LsY1mxxfGu4Z4xvq0+A5JCZW2hkCRd7TkmArMHdY9j/dtSHrzeBKUW6gNcADw1va1e6+Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HWhA9nR0K2i3FG7wORrUp4Fol+ryPrkPKYBXXd9lZI=;
 b=SmA1B0fDNUrkwT9ErkOL5BOq1z9prRb/pWuME0Lxbrejg5XjhkH5Sh2/hvUGgYXCEP2Tq/6GqDbS4uF1FmUgP2UYXzaLA1opdiFkbai3cAZLPsMNMk1FHPcuM+j62N5bp2eM7yQyE0gLK4agOu6ZlyRge7VOO7IkMzT9gmfEKuOw94nnKqf2Xk1xo9T3kxgm2AyU6TP4UIYkPy83HH2d5Ge2F8bhPlU7zpX4cGZK16jyO4JCEY9ERprQgFqWC9AE+kGW68WG/oEDX7WDcLDw5IC42Sp2ylczc2RyRHNLSLNEgF7z9hiQmA50IYrTKB4Z7vdj0esjz7LYlqOopOj3sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HWhA9nR0K2i3FG7wORrUp4Fol+ryPrkPKYBXXd9lZI=;
 b=UZndAlKsSpdM4DoSMyLm5Rg2gpyKB28J2yBY8Kk4bP+fyJ32p/1rxvvwrJtEEIGiJ+lDQB8Y7bGDqbz9NpaXxVasBIT5ZX0mTIKV3Y2uE3xdtqbYBHm1gwwUENc6XxOZywucMd+wCfqY97QfsnT/AZP7RZplckV6uILOH/iBgx8=
Received: from MW4PR04CA0225.namprd04.prod.outlook.com (2603:10b6:303:87::20)
 by SJ2PR12MB8717.namprd12.prod.outlook.com (2603:10b6:a03:53d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 05:59:07 +0000
Received: from SJ1PEPF00002312.namprd03.prod.outlook.com
 (2603:10b6:303:87:cafe::61) by MW4PR04CA0225.outlook.office365.com
 (2603:10b6:303:87::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Thu,
 23 Jul 2026 05:59:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002312.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 05:59:07 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 23 Jul
 2026 00:59:03 -0500
Received: from [172.31.184.125] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Thu, 23 Jul 2026 00:58:53 -0500
Message-ID: <70580cfc-8625-4f35-a77b-7154a52e10a5@amd.com>
Date: Thu, 23 Jul 2026 11:28:47 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
To: Borislav Petkov <bp@alien8.de>
CC: Ashish Kalra <Ashish.Kalra@amd.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <seanjc@google.com>, <peterz@infradead.org>,
	<thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <ardb@kernel.org>, <pbonzini@redhat.com>,
	<aik@amd.com>, <Michael.Roth@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <ackerleytng@google.com>, <jackyli@google.com>,
	<pgonda@google.com>, <rientjes@google.com>, <jacobhxu@google.com>,
	<xin@zytor.com>, <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260723011031.GGamFqB1i4zt4Zlsx6@fat_crate.local>
 <9cfe76f4-8e16-4b21-a414-126a06859489@amd.com>
 <20260723051422.GGamGjLhlTqRDcFlee@fat_crate.local>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20260723051422.GGamGjLhlTqRDcFlee@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002312:EE_|SJ2PR12MB8717:EE_
X-MS-Office365-Filtering-Correlation-Id: b9913147-35b1-4cda-62b3-08dee87f820b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|1800799024|23010399003|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	HR7uTfLoh/LrkGJkftX+qolxkKWth8b4v4HLy/sMakKULfuTNRbLegUtF+pvz6XIG58ux2RXeO9jEdmTt+W6kzyjIxWeZejxCwgR++OLnGuMyHkliWPO/ebILGB4Gloq5qS5AjjDO9avtiNjDQksAaR0w8i1J5c/ReoA/7f9bhA8JdD2RJhBccCXY37n0M+mjCroUmj9BLNF7SOFqfJV4SU96tbEsVciHeaIa+GScDG4eQydmtkN6JNAMr/L7NLkyqE7c9uTLRbjbPgHo2RdFbDhsKtBAdq9JT7TcC5wI3UYuK4lMDjenhwt5ejTdalPtRtBQ7HGP7qYblAzkRUC5yMw/ZN1rtFAWdCE3bs/tu8umnjx5aRh4oFnJbLWkzgP8E8uEBHROmB0iY7L0UpdjQP622JeGumuxZL8TCiBNNhlejKjjY3mYQ1xnig2qSZkvvfIwuXkxBNF1h3haRi4ZGiMjeTtBhPLcBd641IPUDKhdO2ASukh33oxPCSwyNNzq35bIrxXEcJbYSGccB6OSlLo4wtmyLpdkMwpLybplmbRr3F4rclEhD3PySyX1tql/35jHyL/do3lVEurhABN64yVLSBI6uohKGs6I1Gt0xw3Flh/9GNpZCkzkeyXuKUArdtG4OPyXCGPZlNHmRVtjZM3QG4DphZcM98yLJPmx5oNdmwQ63xfMui6Q9q+jx32+/DZld5a8cWECI0B9jCZJw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(1800799024)(23010399003)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eRJVf0Ixcc4gR0rTZejdQEThRVArvBCqqT3bjzEsOGHgxhRnMThsKd9D73AZmOtO3/cpwQqMN/ggdR7mZtgnwNFWL7zJhc08ZmPDmDJXCsE225Wlsn0KxibI669qoXdHy+AWtwfhX2RWyS8/xAvKnyJoo8tlMCbbUQYI5NcSEdjTvQUNkQna6Ma6jgSgApMXVD5hAVXDLzaGhiMHGsX321NUPSP11rydRwfbO5SQnBJE6pGOvSnVbqH1UsvX69R2vvoFo0a0lTyxrP6YNJw2EPzd2fRIov4B6kLH6E54k5nA42GGLg+cv1NW3SmuQbJL6oVPXZhNKdQlwhbKPUyHMey28RYNxzmGt9zlH3AV9kxZ/FarOnXDSnDdR4/dhS/RMGEd/BXhp1l0ViA6Zq1VgpdnjW6TpICe6F89mlKik/VP78sKyUDPcGvP5NF3lgk0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 05:59:07.2739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9913147-35b1-4cda-62b3-08dee87f820b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002312.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8717

Hello Boris,

On 7/23/2026 10:44 AM, Borislav Petkov wrote:
> On Thu, Jul 23, 2026 at 10:23:56AM +0530, K Prateek Nayak wrote:
>> The offline cores will remain offline since hotplug is disabled. RMPOPT
>> is simply a performance optimization for RMP checks and leaving the
>> offline cores (that will never exit idle) unoptimized should be
>> acceptable.
> 
> What happens if you boot with a subset of cores, the boot flow enables RMPOPT
> and then you online the rest?

RMPOPT happens at __sev_snp_init_locked() for all online cores. Until
then, SnpEn is still 0 and we don't need RMPOPT because RMP checks
haven't been enabled yet.

> 
> Have we tried that?

That said, Ashish, should snp_rmptable_init() do a
snp_rmpopt_all_physmem() (or something equivalent) when it finds SNP_EN
set in MSR_AMD64_SYSCFG after a kexec?

-- 
Thanks and Regards,
Prateek

