Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012050.outbound.protection.outlook.com [52.101.48.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602E2384CE4;
	Fri, 26 Jun 2026 04:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782446543; cv=fail; b=anPh/nnBUrFRbmLO6zkjJ4iw+g/rozggMN75xmDrEAF7aQQ7RO/gTvNbCz81m8Q57DP7OQWHQyYdOL0qkFIorkskjlMFLAe+uTlNDJ4weRpuiqMi+OSQYxUHuzhvryUiMYI9PODaw7gCgNACxGSCz5FALfcB7ldVO27n4GY+rHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782446543; c=relaxed/simple;
	bh=z18ssLQZE9EEsk/V7PEyYPTr9V+y0Q4lMo8VbSEfY/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=udtJzitnT7YZWIpvzlh0JqOAcSuqqP1QnMF58xJHr1sSArTbxcfNqdlqHN//KwHe28RRiWSkAnxvSz9vjarMxtJNwexd7qUzSTglbJCrfj0sD86DhFPxeoCKpAje8mOzk4XxVp8w27pnIioEfJWpJYrNOweIjaImKcKsPJeBm4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SR+kC4AO; arc=fail smtp.client-ip=52.101.48.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SR+kC4AO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UkYV0d1Vqu075aU2krJ7xFiUwdSYk8Tc5Q4Rb8SFiitRyXwzEeegrsRPNkPsQGxktldk5Dp1V833JsJHztAHEpuZI0Fh6Z/oGOKSbqefsvR6xRerg+/TykCv9HfRhX9FmMgcbjeDn1DeohTSiY4QVncnIBn7AbQ6neKR5oU7NGRrnSL017BGxaT+epDjcnWlcRzUYdPuqduKkK2WizYyRX9eWCDInmT/uXFzAOge41oZo320akAt/fZE3Mcb01QaUAlKPjuuzoW6YJ4hXqTdGiZh7AcKqOS5rtqhNDNYQHtzq/3KFi97W29F9rMnvVG3rw0rzXx7PgL/IPMYj26SqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIJjdo66gTpFAxChpohtVwLy18XSAQ1c0E9x3CezJNA=;
 b=kYnCosewXTh9iCIzNl7n0mmmYcYjn6+kbDeLka0+1acaW3tK/PLCb+4az9aQ1kPTnoP+zxkpsYYRes3hdGk1QPLi4aSZsekLbGNW/ItHFFSCnq9/wWv4JmHNfC0+0Y8Z3KVRpCczc79GdP8a9xwgG3PPTyYslBD7HFMe2kRuSLC6wtAeMoDUqUUNPZk8RajVGi2W6NdNYo4QJKQVumLaJ0NxwO4ZUYWVUqoukDL/iwwjrJhxVDklwioixLVROn9+AwEcXin2uNWzC7mzepFdJD5NoN1LFVo0LVDydwBQ22bAEhS/C5ROySYlhHzbsuxuy0YOFv3LlRSLZKsfQZMMUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIJjdo66gTpFAxChpohtVwLy18XSAQ1c0E9x3CezJNA=;
 b=SR+kC4AOfPoyZ4ggyMVGjWhbgOEoFTD5rRgjm6AdV24YxkDln9RFLYytpEEsKJ7pPXr7jecrmSGk8K2rCwVgkCGTHFfXHOlq7oxNOmuVxCdohGLfd6aocH+bg15dSorIzNUyklIzqn7cHDuUehyiJeVHsTSZF2APHnuyzl+Lcxk=
Received: from MN0P220CA0006.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::30)
 by PH0PR12MB7929.namprd12.prod.outlook.com (2603:10b6:510:284::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 04:02:16 +0000
Received: from BN3PEPF0000B371.namprd21.prod.outlook.com
 (2603:10b6:208:52e:cafe::44) by MN0P220CA0006.outlook.office365.com
 (2603:10b6:208:52e::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.17 via Frontend Transport; Fri,
 26 Jun 2026 04:02:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B371.mail.protection.outlook.com (10.167.243.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.0 via Frontend Transport; Fri, 26 Jun 2026 04:02:15 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 25 Jun
 2026 23:02:05 -0500
Received: from [10.136.35.225] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Thu, 25 Jun 2026 23:01:56 -0500
Message-ID: <24aef42a-86da-42d4-92d1-9a6d2d329592@amd.com>
Date: Fri, 26 Jun 2026 09:31:55 +0530
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
 <898e378a-cf7c-4310-b439-e28ec0a71338@amd.com>
 <b9777de5-a6fa-418c-92d2-89c095e91837@amd.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <b9777de5-a6fa-418c-92d2-89c095e91837@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B371:EE_|PH0PR12MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: 406b6ccb-4f98-467c-c448-08ded337b5a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|82310400026|1800799024|23010399003|18002099003|22082099003|5023799004|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Fsuec6Dm8rPFNHL0EmyIJFtHihd+PYjcxjrEwarf5VKiG8a5/dkjE49eo/D39gKK9zI3MZDWnT+IxEQAetfVoXM6pnoLOdUEOclBrFSDcw8F9ucsjPEJL8+hrWh7LLTx4DNudVj0JVy0a284zyd1zenCcFTHxS9h8CszM3GsnNcLacfwn6peMJGGfZQRjeOJjVnu/gx869xsl2VytSmgHJ5wWbD1sFwPXaD65vxc1SIdMF6xP6PLz+wHMXUjBXlw+Jae+IL10/tUuLqyWTH23o2gXcutIMzDP6pDv+h0FH3kVpoKtGWDJBCHedL7WJfhBJm/GkNSvzZCjvkS5htcATE5vSs1/qe4nCgdIooY6I2SePb2pTT+K0arRu+fPH2QeuKzIEVpiBZpJO60yheCjd3yCHAy7Qnb9aMxHHRKbTJOOjvKsyI9JZB5sKkKr7I221+Oah/gLCrvFfnTo6OvmgyWaGNRJa4Mjt9usU/C3aYIVjHKTBTNYjFE9gblN7tCakoXx1PEAMEb/Pm9u2Ye5co7bNXyNLdTsjoBX9JtCAhBim0xlH8WEgMJo9CLgr2BsJOCN9nISXzz+mAndYSc2mn1fwhZr0SOzRiwlRZaw/FhMtc95DPn7PWIzImD4JCyXS0m8k47VK3/pE3h9wvAeswExPYSFEn1281vq36mBRgmVt4uFCB5seB28iZq3qWY432XK9Al5mAouOqRrEoYEw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(82310400026)(1800799024)(23010399003)(18002099003)(22082099003)(5023799004)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dQnBnqnoLcFaB666q8c7O7l81Ez0noK5+QqwooasIuXJJ52GiaV7PxjpmzOCV0MhpWmaSg+eLvLryW+jSe3eHtV7RBteFD23gEX9/9vi3Wbd8yPotEK5t+a1KVy1/Mhoxf1Q3mPFRF0gWX7M30ogamV2LHRD9twLKuj9H7umFjm79EmTs/CftIJU2vHH13Q2SKwTxN0u76ds5VUHeFyj6YZwH3/L8Lu2w7q7rIT2IU2jpocyce/a+c8r3g1nj+2xCnoGKyu9bdfzKY1nDXa/c6aG9xRf7Deig12Dyy7wT7GG/UrLeHtyYSPLI5FEjWdV/oF1txYcoKc8Lj7xlumhyHHpfadMdzw4wHEiO9yEIDwFLKO8NOC0tlrIkui3CANT8HRwfzxT15t4cJqOhAh6oPyb0DQEB2eaCDa0qtmwHO/huUvFUU6NNc+WfbScGby0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 04:02:15.7191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 406b6ccb-4f98-467c-c448-08ded337b5a6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B371.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7929

Hello Ashish,

On 6/26/2026 8:08 AM, Kalra, Ashish wrote:
>> Looking at snp_prepare(), we have an early-bailout for
>>
>>     rdmsrq(MSR_AMD64_SYSCFG, val);
>>     if (val & MSR_AMD64_SYSCFG_SNP_EN)
>>          return;
>>
>> Does executing SHUTDOWN command lead to the firmware clearing SNP_EN in
>> SYSCFG on all CPUS?
> 
> Yes, in case of X86_SNP_SHUTDOWN (available if firmware supports X86SnpShutdown feature)
> SNP is disabled on all cores by clearing SYSCFG[SNPEn] bit.
> 
> If X86_SNP_SHUTDOWN is set to 1, the firmware clears the SYSCFG[SNPEn] bit in each core. 
> 
> But, in case of legacy SNP shutdown, SNP_EN bit is not cleared and so SNP remains enabled.

Ah! That was the bit I was missing. Thanks a ton for clarifying.

> 
>>
>> If SNP_EN remains set (and Linux can't clear it since it is
>> "Write-1-only" bit), then a subsequent snp_prepare() will skip setting
>> SYSCFG if it sees SNP_EN on local CPU.
>>
>> It can so happen that we enable hotlpug at shutdown, CPUs come online
>> without setting SNP_EN in SYSCFG, subsequent snp_prepare() runs on a CPU
>> where SNP_EN is still set and skips configuring it for the CPUs that
>> don't have it set, and we'll be in a pickle still.
>>
>> The comment above that bailout saying "this can happen in case of kexec
>> boot" makes me believe that SNP_EN remains set until a full system
>> reset.
>>
>> The only safe way to do this is to ensure all possible CPUs are online
>> during snp_prepare() and do snp_enable() regardless of whether local CPU
>> has SNP_EN or not.
>>
>> Am I missing something?
>>
> 
> The piece that makes the early bailout safe is the disable this patch adds:
> hotplug is disabled while SNP is active, so the online set can't change under an
> active SNP. snp_prepare() already requires online == present, so at a successful
> init every present CPU gets SNP_EN,

How is this enforced? AFAICT, on_each_cpu(snp_enable) will only covers
the online CPUs and there could be CPUs that have been offlined before
that right?

> and because hotplug is then disabled none
> can leave or rejoin without it. So whenever the bailout is hit with SNP active,
> every online CPU already has SNP_EN:
> 
>   - kexec: SNP_EN is already set on all CPUs by the previous kernel.

There is a catch here: you can have offline CPUs during the previous boot
(say you have maxcpus=8 in your cmdline), and then you kexec with a different
kernel / cmdline that brings online a bunch more CPUs.

SNP_EN will only be set for a subset of then with the legacy SNP_INIT and
if snp_prepare() runs on those legacy CPUs, you still skip setting it for
the ones that don't have SNP_EN set.

Is that case covered somehow or is it a non-issue?

>   - re-init while SNP is still active (e.g. after a legacy SNP_SHUTDOWN that
>   leaves SNP_EN set): hotplug was disabled the whole time, so the online set is
>   unchanged and all of them still have SNP_EN.
> 
> The only way a CPU can be online without SNP_EN is when SNP is not active --
> i.e. after an SNP_INIT failure, where this patch re-enables hotplug. That is
> deliberately the same as the behavior before this support existed (hotplug was
> never disabled then), and it is benign: SNP_EN only gates RMP checks, the RMP
> itself is initialized by SNP_INIT, so on a failed init the RMP is all-zeroes --
> every entry is in the default HV-owned state, no page is assigned, no check ever blocks
> and snp_initialized stays false, so no SNP guest can be created.
> Nothing is enforced and nothing is protected.
> 
> So I've kept snp_prepare()'s existing bailout / snp_enable() behavior unchanged;
> what this patch adds is disabling hotplug while SNP is active, which is what
> actually closes the window (a CPU coming online without SNP_EN while SNP is
> live). That window -- and the SNP_EN-stays-set-on-failure situation -- already
> exist in today's code, this patch constrains the dangerous (active) case and
> otherwise matches current behavior.

Ack! Just that one small bit up above bothers me but other than that,
doing it in snp_prepare() should be good.

This is all new to me so thanks a ton for answering my queries.

> 
> (On the v9 placement specifically: I'm moving the disable into snp_prepare()
> ahead of SNP_EN in the next version; in v9 it sits after SNP_INIT, which leaves
> the window you originally pointed out.)
-- 
Thanks and Regards,
Prateek

