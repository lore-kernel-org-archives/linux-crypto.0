Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010009.outbound.protection.outlook.com [52.101.201.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C22442AFA9;
	Thu, 23 Jul 2026 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816965; cv=fail; b=HzPVANb7cBcTFQgtbXBLaThUwcQwMZQ4Kbd+pDOn3oPyujRPOBS8/33Vownm79QwCDoauje8uYK/IcmZmylgR6IWHiwuXHOv84zR56kmc6bhJbD2x9TKyAKZT7IuwFMBiPyv/7Q8oN8R5m1uymBV5B3JcEp2srnjAUKnKs2T15s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816965; c=relaxed/simple;
	bh=CvbTMbrdGJ0HiRIHl+soP8/VPjvGn+yYLSSGT/27s+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=G12z2ygTwmRSIE7n5ywHrS9PwclzmYwYNQ1cTrvD2KXaZIyiXDIKe6m89H6xSLh3rFY3ktY0jmLHKbOyl2+c+5jQM4Uqu/K/nJvDeuK6IRMc3avD//Sx6dUcJKWkIXLr25FgCbEaKNg2B+SKH/ro4xVKZ0ytrop+WDVMGUG6Rno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HnPWuAM9; arc=fail smtp.client-ip=52.101.201.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HnPWuAM9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NU10SxLu0Y2pALfbZr6qqkiLjKUadJFhOKPq+M9Mmt/+OU1sQFxrCHnyOyLpbi4VUDXvhQiqpjhVKYjSFiMqcKxXQjwCwZG3YTcev8IyATcU2xKRra4PqzwnU3l4CTmfTGXM0RCGPoC3iE6HfkQCZ88rhbZXY94yc24eU+qgwJ4ZD8OoGtUKUy9OTwk18D1PNTgkbLvR+hkJL+db+1Rxkx/l2goZNz/55vrHfHIlu1aIPqvUolI1wKGVs6APZO8SYfr8DZuwNNB4RQOCQcwCeOqMEHcJY78GtQrbky6q0a54BBHzSdaBXUJdlx83TKI2UOpe500jzPq+xfi9SkT/cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AatbAmX4wYe+c6XLd2Sbb0+pzdW2CFrKV5uheDWo7VI=;
 b=d99jwXb/L9G8h6PwSk+HHRr515+T4jYOmRqu6qVeUzOpkn8KgBtJdJYtfHPncBg/g6kV8VtTOnHq8wWH5ct3LX/Gmd+9nM2j76Yb/Tjvy4MSEFQdJfg8pkjyFFm+/EjHtkzrsroOozkkTVtf0pbybbdq6i+J8IxqM+Rsv8L9sBfPMCy9Llu6Zgk8ZK6X7nXPXw12QrTL7s0XmgAtFj4qAjmb0W+AlBxjBn5SCk34t8XRSpRxJYoYOaFVWn+j0uO6Bu8MxBuyaxCHx/8q3Ro9IxlcCKx3co5aXFjMLeabVAs9lGiTvcu3fwVDWIl86Ey+0XxMZw5vwLP8TKWVMSjSVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AatbAmX4wYe+c6XLd2Sbb0+pzdW2CFrKV5uheDWo7VI=;
 b=HnPWuAM9MaGAjb9R5sDooyNyISqvzRVARxDyVIwYLMFg2SuhEuIF/rDG2bHfZu/7Wu/3aXhIwK1X0sGwVTRGbbSuNnSpvnQweoxDUjFPMuMYJpLC6M+U7hJLJCMjGu1OmVpGj5EGaai9fO9rYf4Y4rMBVMs3AOeX21Vdteym9Ww=
Received: from SJ0PR03CA0120.namprd03.prod.outlook.com (2603:10b6:a03:333::35)
 by DS4PR12MB999100.namprd12.prod.outlook.com (2603:10b6:8:2f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 14:29:18 +0000
Received: from SJ1PEPF00002325.namprd03.prod.outlook.com
 (2603:10b6:a03:333:cafe::64) by SJ0PR03CA0120.outlook.office365.com
 (2603:10b6:a03:333::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Thu,
 23 Jul 2026 14:29:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF00002325.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 14:29:17 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 23 Jul
 2026 09:29:12 -0500
Received: from [172.31.184.125] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Thu, 23 Jul 2026 09:29:04 -0500
Message-ID: <f7bfaa21-a572-428b-9de0-51fb06b5f44a@amd.com>
Date: Thu, 23 Jul 2026 19:59:03 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
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
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260723011031.GGamFqB1i4zt4Zlsx6@fat_crate.local>
 <9cfe76f4-8e16-4b21-a414-126a06859489@amd.com>
 <20260723051422.GGamGjLhlTqRDcFlee@fat_crate.local>
 <5460b946-b511-4060-8951-264d17a2b21b@amd.com>
 <0b471f38-8c96-4d6b-869a-44a3684ebdd7@amd.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <0b471f38-8c96-4d6b-869a-44a3684ebdd7@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002325:EE_|DS4PR12MB999100:EE_
X-MS-Office365-Filtering-Correlation-Id: a0e59956-e51e-4d93-a7b5-08dee8c6c765
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|82310400026|36860700016|1800799024|56012099006|10067099003|5023799004|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NE2MgY6lVpqR/90pw8O8c+o1pdtUTVKBxXhwbUNE2/r4HVnrPUi9lfgBVXRfFyLn8GyBULJS4goDaLL6iIbWIgvH7k3kvugNKWtsxGJgGqwwwS06sS0FPfYXzLcM4Byo0+0olzGDL49c63TCcLShU6rJCM5fTgZ1Kaq5XWdApf8Ga+Hdb+cWPNy18cwXk1bLMsHuGed+q+Heh9wssfINxIU2GZ65Q4loSVUNtTraQHAPO3mbxZEbXmnJEvAh8ma9BcJnGXv4grWuhbFrUcqDPHd5CZ9Rigp6gYufYIRsScZgLybd6Z5INH3Al+hNVm4jHQv0r8hQRRmAygvVPou26LdXINosOS+MGljLpa3grvkv2SpBwKi9tZYG9T6lFWUOL3gxIueQIiV1F5QITYflvIjuaD3kX5bXi3F+jNrcjQzwdTC2pOnKaesIYoLh6wnUOa2fbZ2puanuEz0G6lvT5V+dGMIqvA7IaY+5rINGrAbWZm3GxiVEn705eGfw2/q66F4IatqNkSejqcRggFatTJgysJNs3+ya6SHIdwnnrO0jA4VKJb1XgFHs2eII48YuZmaf53AHnczrkZReHvE1iW21HCbLTmAvECKqT+RfeSmFeif2a1ow0v06JDd0AokxLPaLMLCwL1/pxO5GE3i1nMWe98KpVxikmXoVisTd1FWhYcZSmD4/WA+u9e/r4LCStCYAdHzhNYdyonSNm04yBw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(82310400026)(36860700016)(1800799024)(56012099006)(10067099003)(5023799004)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oIUAnuyquT48SrISl6y4sxXCQH3M+/G2opQn5HePRHc/URGrsPYSv5rm0i8kiBleibu2Glpdgj+3Q7lLGUuiq5kvnEhcwJ5ptscSNF4P6LZ/YIisSAF9L06z9IlejOR4BVVIXulY0WQei4ajHl8FhXsiAtkwyA0s/TY14fneZ3puuY6LKAI2jJAzt3MLAdoTLREAkuW1JsPlZLJr+CMGZTnpTjPYKIz6fjLyiiyHDw6GOZy1Zbc+nvghT/2wezjpkoEzAR8Z7nCFibJWfr/8hLTM49K8Wz3vzb63JJn5FwE7vCCGgmATlHcA128xXcDMK+bdV71kzLwae5Sg70oLx3+DAAirGhazv24IU/QfHjYYN7CaMMz7PAspYToaltW3YKfMJe8knDzJe0iW2d8m038QOgRcpObJNW+RT3i9m5vPXfqb8L2aSKYa4JRnaVKJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 14:29:17.8308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e59956-e51e-4d93-a7b5-08dee8c6c765
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002325.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB999100

Hello Ashish,

On 7/23/2026 6:54 PM, Kalra, Ashish wrote:
> 
> On 7/23/2026 1:50 AM, Kalra, Ashish wrote:
>> Hello Boris,
>>
>> On 7/23/2026 12:14 AM, Borislav Petkov wrote:
>>> On Thu, Jul 23, 2026 at 10:23:56AM +0530, K Prateek Nayak wrote:
>>>> The offline cores will remain offline since hotplug is disabled. RMPOPT
>>>> is simply a performance optimization for RMP checks and leaving the
>>>> offline cores (that will never exit idle) unoptimized should be
>>>> acceptable.
>>>
>>> What happens if you boot with a subset of cores, the boot flow enables RMPOPT
>>> and then you online the rest?
>>>
>>> Have we tried that?
>>>
>>
>>  It can't happen here. snp_prepare() does the following, in order:
>>
>>   1. cpu_hotplug_disable() — freeze the CPU set.
>>   2. fail SNP init (-EOPNOTSUPP) unless every present CPU is online (cpumask_equal(cpu_online_mask, cpu_present_mask).
>>   3. enable SNP.
>>
>>   snp_setup_rmpopt() runs only after snp_prepare() succeeds, so all present CPUs are online and stay online (hotplug is
>>   disabled). No core's primary thread can be offline at this point.
>>
>>   (The kexec path is the one exception — snp_prepare() returns early there — which I'm handling in the other thread.)
>>
>>   Thanks,
>>   Ashish
>>
> 
> Additionally for kexec considerations: on RMPOPT-capable platforms kexec clears SnpEn (full SNP_SHUTDOWN_EX, x86_snp_shutdown=1),
> so snp_prepare() re-runs its cpumask_equal() all-online check on the kexec boot exactly as on a normal boot.
> 
> So no kexec-specific case where RMPOPT gets set up with a partial CPU set.

Thank you for clarifying! Much appreciated _/\_

-- 
Thanks and Regards,
Prateek

