Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013045.outbound.protection.outlook.com [40.93.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769383DB32D;
	Thu, 23 Jul 2026 07:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791049; cv=fail; b=sJnJr1jDcFqSJSq29l6OJXRMNreFtFtKOWDNoDHgRv7Cdunz6lVLpv7JVogWp1O0j/Yyqw0WsHTzFFMPdLuLIhtbtC7SziOtvzlYSchGCiyzxuNIPWrUSfRuWbCLW4sLFM/mfUXnrwgtMHTRxZ4gjs0QO/Gpqqp71pE6pi+DKO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791049; c=relaxed/simple;
	bh=saCU6ZZ1hgPfNrW46phjX8RKjVB/JZQD0VBHM77aAzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=oPA/pFa9lY7rlQ5WQp1pDFOiquoR3nj5XsmjGccs8POS1sZP1wbd718P4OQaOoPcXRPYW77R0j3uRQdgACoZQp9xbkATDaUI0HZMfW4voDcvRXlyLrsI9BZnavf4ruJYPQpbHqfnGqb3gDQ/dQhGwCQSjK63N0GpCncjw6Ygtnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=few5d0gb; arc=fail smtp.client-ip=40.93.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="few5d0gb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BpWMMc3qCwI8ejbUwtUYRsL84Yx2qEn/T1gHbN4ztvypLdQVmAs8gJc7zOOwBQNdgD7VMmyFVr9LZfUqPGxNxxJL3UoO5DSPbkZVtXMm0vS/rjkEpKA81mW/fKGsBDZFCZ+9JsUWMrPyUF1AznPTRlXHeP2hhuRSZ7rdn32lS8T9V/MGNz0zqq7PGKGMVXywqn6YWptHkapmJuVseEAVBF0i1O5LAjbVN4dTmjzg6v2F/bHSW7uB9uQZFzwb8UFJb0K9ALToFkVo7EKmzn3X+pn+/MjgEYnorfwdj3cJhtGNgR6h7lo1ziBh0EMX6tKQQJvnl3+mtLxqeNrl4fap3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4S5LB+Y3cmGfipXZT5+PXH0XAfQGeZ75wd4FRNg1nY=;
 b=bQFiDA1pl1hK4lVommz3sCGUoJMyJ6CQJMU6oVs9IebbxZc6FX1mtR1hZ6dSMc1bSUj1SNqudc6xmQlefV6GfwgGgUL7D0KJfopoi+Q4ACZzgnAxRV2zdyYmnjeXce/uWM7obGTkfhjCsgWXrX8rT3xljsRFG/aphPKu3bgsWSSNV1RpdaaAV+7mJdX6ETpfIEnjL8SSu1urJvzkC5kfInx6zBBMeSrnyUqRogHNf3OqYhKCBAQnDvvhMsoYmoR/VCZ5emGvL4h003RzU0i3Cuvz65n4krSInu7EjjYo6j9/JLGchbE17KGlJmL7X/E04l+DN15sR4lF2dTbaxgW+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4S5LB+Y3cmGfipXZT5+PXH0XAfQGeZ75wd4FRNg1nY=;
 b=few5d0gbvlN7Z8G/YW5VNxOjfx5vBd+8fCHISxBdxaIePau1pVlNyOLQVnPHgIg8VbNJ+T+paPiTqZ19+dtLT1zwnWslxIhLmy51neiuGNzO1Lqzt8q0PTEddz3yFneJan0ivOgcqIKURfacayQ++8vK9yKpymcXyo6NxfIvLzs=
Received: from SJ0PR13CA0189.namprd13.prod.outlook.com (2603:10b6:a03:2c3::14)
 by BY5PR12MB4097.namprd12.prod.outlook.com (2603:10b6:a03:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 07:17:15 +0000
Received: from MWH0EPF000C6186.namprd02.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::7e) by SJ0PR13CA0189.outlook.office365.com
 (2603:10b6:a03:2c3::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Thu,
 23 Jul 2026 07:17:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000C6186.mail.protection.outlook.com (10.167.249.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 07:17:14 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 23 Jul
 2026 02:17:14 -0500
Received: from [172.31.184.125] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Thu, 23 Jul 2026 02:17:04 -0500
Message-ID: <535c2a43-47b9-45ac-be9f-d0c53f9f01cc@amd.com>
Date: Thu, 23 Jul 2026 12:46:58 +0530
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
 <70580cfc-8625-4f35-a77b-7154a52e10a5@amd.com>
 <6b284f81-3551-471b-bdaa-5c5f8203bdab@amd.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <6b284f81-3551-471b-bdaa-5c5f8203bdab@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6186:EE_|BY5PR12MB4097:EE_
X-MS-Office365-Filtering-Correlation-Id: 411b9ccb-fb29-4c31-b602-08dee88a6c0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|7416014|1800799024|82310400026|10067099003|11063799006|4143699003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	J1Uqk77x0y+JCwP+HmZOSbpx2Ew0ABKmQ7smLfG2NX6sz6e3+LY2XpJ4oQgYkR85frDuJmp+0jrowtzzc3mOZKfcBV537CU17fdxPLXSE/yF8Sl5nFuFCq95ih7ctNn2AJVdGSErNKOYLKiNQN0Z7waonxI9I+mViJ04NslBqRxtGGepumMI6wasoVk9hzwCUXiySTAQ388+ILKtdWFTWO+NHcJi4lVgJnYmU22ZL/slc8x+02y/i3aZTid43wh3tBdqVphFXqvb4r4NqapoiGhqx4vYAeO5cX0EM85vNu1R9jGKyaaN82lwepumuNoz/M+UKqNG/GY5eX3z8EsnVO/DVDhaDXUp0LHxpLUsRBmrBX+/fJghVHGUtBG2WE2CwL+jadzbXVz4AQYQR+SjJZdeqsspC0NUxOHhOu9Ydh/Ubu0BBkbyVRuJxOFP8ElrZEuEYC1oceq9xn8NX2tDcq4mHibpDvZ4/dqoRFlFGQf8OAk/w5K5+nfftLCwA+ShbY3OoUs4DxxmXMBl/1Px1vOzn7rcQavCdIZZcelP+dAfZ2SpcSUAncqhTD0FptWCJTIZyQ7i3x0FAA68vuHxf9dVeWFX5nOMwdTEp/AVHvZdnF3kFxcxu4rcaAWYmWWRyMrafvvnwj6V1dEhAUt/oOfA1IUwKYtZpidA5Vx4ULA/JnwcBi9pXNbRmoQERmWgkDyftCOvv4HD+tO0kZeXpg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(7416014)(1800799024)(82310400026)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aQPL5kO8tb8yEBpQF/cu7sxSODD9TwzRiJ9vzGj7j5t2nTHXFiFRqGHkZ6HQazlwa1QPj4MRoyXD1DG19GP52/sqYvsF/ucfR/zcL+MUYEZDm+7ea0FfWibYOlVkD1cc1WkiNpA2lPvLaUCO+9XDqEg9cwnsT5hRz1CF3P7F1W38UuVOV0TLWyle1zXSHH6xeoHhhgM9X27QrUyFIEgMZ8rVggt2Dk7VvfXAonnaoegWBiDzRpV6/8f62hRQz6RANozFLEQGTufb0IyxPDijjBVhn+xecOhqqwbh4xl6VzXqzmVT69IBcSt7JgqzyJ1//WRHN9KfzIwHbAR/S1tHmvuv/P6gztFk/rdnAsGo7lDf2DGQKsSmSmfd1ENasmgLfk0JHfh5oJNmjOoAbsq56fT324eNkTtKw6Btrjz1GErZWoKaBC0JmG05giBdG0v8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 07:17:14.7620
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 411b9ccb-fb29-4c31-b602-08dee88a6c0a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6186.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4097

Hello Ashish,

On 7/23/2026 12:33 PM, Kalra, Ashish wrote:
> Hello Prateek,
> 
> On 7/23/2026 12:58 AM, K Prateek Nayak wrote:
>> Hello Boris,
>>
>> On 7/23/2026 10:44 AM, Borislav Petkov wrote:
>>> On Thu, Jul 23, 2026 at 10:23:56AM +0530, K Prateek Nayak wrote:
>>>> The offline cores will remain offline since hotplug is disabled. RMPOPT
>>>> is simply a performance optimization for RMP checks and leaving the
>>>> offline cores (that will never exit idle) unoptimized should be
>>>> acceptable.
>>>
>>> What happens if you boot with a subset of cores, the boot flow enables RMPOPT
>>> and then you online the rest?
>>
>> RMPOPT happens at __sev_snp_init_locked() for all online cores. Until
>> then, SnpEn is still 0 and we don't need RMPOPT because RMP checks
>> haven't been enabled yet.
>>
>>>
>>> Have we tried that?
>>
>> That said, Ashish, should snp_rmptable_init() do a
>> snp_rmpopt_all_physmem() (or something equivalent) when it finds SNP_EN
>> set in MSR_AMD64_SYSCFG after a kexec?
>>
> 
> It already happens, just later in the sequence. On kexec __sev_snp_init_locked() still runs: snp_prepare() returns early
> (SnpEn set), SNP_INIT re-initializes the firmware context, and then snp_setup_rmpopt() is called.

But that only happens when the first SNP guest is created right? Until
then RMP checks are enforced but no confidential guest is running and
the CPUs are paying price for those checks.

> On the fresh kexec kernel, rmpopt_wq is NULL, so snp_setup_rmpopt() does the full setup — programs the per-CPU RMPOPT_BASE MSRs and
> queues the initial all-physmem optimization pass. So RMPOPT is re-applied on kexec through the normal path.
> 
> Doing it in snp_rmptable_init() would be too early: the per-CPU RMPOPT_BASE MSRs aren't programmed until
> snp_setup_rmpopt(), so a pass there would have no base configured.

Ack! Which is why I mentioned something equivalent ;-)

-- 
Thanks and Regards,
Prateek

