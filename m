Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B44E34EEF9;
	Wed, 11 Mar 2026 21:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773264265; cv=fail; b=PvkYqKjN/6rNffu7v43iFx847CFO59h3z4qekJ6tMy59F+bdJXLKt5/SQlznYFCMlXu0nJiwP7/MbP779Ujc8Gh2XKHv5R9ZtBs50GJBqTBpNffW/w3FbeYpX4gSh7Wv/qIbcUrNXHlIMqLyZ2wmMBCgDq0HdRruNi1KdzaHxy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773264265; c=relaxed/simple;
	bh=YrFPUqez4vVnlGyyBY8PyrcbNOyAMJj/R1xqqvw84E0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tjbXvyqWjg64+ez3K36lIeB259SOEzYSfBx9uPVYXfFU1AgSOWeujL0onD0L0ZYaMlHr+dZOuJL59wMVOe8Tp3uHr23ovkfM8MLnHmpkX8cz4j5SHseVrRObnWvzcePaiNEQh240g1kBcGfKphN74pQqj8joaXS34bMvYNPGUdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3O7ad9le; arc=fail smtp.client-ip=40.93.194.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3O7ad9le"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pilnxI0xyXyBPnj5FlzrO0+EBMyrVTnfvATD1b0cM8wzykjWnXm1zQRWQLbu8Q1kTP4tyNJU5mZcgYUoFZoDv27bqW1gOYxwEOgNNtmXcpzptPE2IgPAluIffLaKKPx6m/vx+XfJmZMa7LOeJ5B28WJTt3hPZuLGu6UIoYADS4EsHtiKrNWgLOsOzzma9kZjYMdXytGp9XyNCgFlOBPjCS08P94BGtrbqetlqhQCOZZDOqnn/8s4NpLkIA+0zr52KU6RgpP5ufdwNu8p70ynTU+Yo9bMwkdbFjQx1qSIpLxdPhhRQpqbw8+cs1H/N77r6w3RmUD/WHjJ8L5S9q3i9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PoyfhvpDewm16oH7wkr6RpybaiowlW4yLn5feACPwIo=;
 b=w+YGXK1jnXqJBjwx5XXPXcU8NAsLiYCvjnR3AD4vWyvxDI7Z34Gfd0ShK+V2klrBT1i34HPPSijPVdX5rP9XJGnT3n73jO7f44h3VevMjat97zZKff69teinoX1H8TTzFX7BCXyeHG8nUXcTFDIr4gp44jPkNmwT+4exU+CJi/nve56Nb79A08y8bLjPeg2QXZOYyXp/HZ3ILfHvtUaiU4Jt9XfWgVEDasqxUsdC35QscJ3RM+wy/IvCM4SaqzPuwu118USsZ+HonzHglRvvmb+BCDih3HDkTBHx7AF/aaBpDde/XjRdMEO88yDX9PD56+WrquKYAa3QJijVRZe12A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PoyfhvpDewm16oH7wkr6RpybaiowlW4yLn5feACPwIo=;
 b=3O7ad9lehLWGRPfmlKbLBThidHzj/hPPMkb8a7YCC/B6Kx7IGyvZ2w278Vqph2JPRSZXay8LElzW+i/T6VX67Y5FiUyfs4q4dcc92m7YdAG1PPWGZjfiISnEy2jKEdJGth34ZmQHa7+OAzIUk6jC/wOHJuaEYPR+xwmBwH60rMQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MW4PR12MB7468.namprd12.prod.outlook.com (2603:10b6:303:212::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Wed, 11 Mar
 2026 21:24:19 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 21:24:19 +0000
Message-ID: <cc9bf918-a14b-4619-a084-3f424fa16ea1@amd.com>
Date: Wed, 11 Mar 2026 16:24:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
To: Dave Hansen <dave.hansen@intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com, aik@amd.com,
 Michael.Roth@amd.com, KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
 Nathan.Fontenot@amd.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <8dc0198f1261f5ae4b16388fc1ffad5ddb3895f9.1772486459.git.ashish.kalra@amd.com>
 <aahH4XARlftClMrQ@google.com>
 <7ab8d3af-b4f5-481c-ab2e-059ddd7e718e@intel.com>
 <0fbb94ad-bfcf-4fbe-bf40-d79051d67ad8@amd.com>
 <6a4f4ecf-ffc0-43a9-98d4-06235b42063e@amd.com>
 <d7ba3790-a959-4150-87e0-c87dea4d09c5@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <d7ba3790-a959-4150-87e0-c87dea4d09c5@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:610:5a::11) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MW4PR12MB7468:EE_
X-MS-Office365-Filtering-Correlation-Id: 13f178c4-2102-4363-5eb3-08de7fb48e04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JJCwx/HNJCd5NwX6vsE+kxBvS58UK1BaAxXxcqQk3/KbjUJPXaZeBZOgjc1oY+QrAlzwUBrWVFjLgw+SC98UWhS3GYCMaKmW5ePdOSL4pIGUcl4bVNE/ThXvcWIKNi09Bqorn1NWZAsFfetKtGXXju/5YkF7h6fJN0bAxsQ1PVS7YYDdsrcyPluydMjJ0QgZoVGwG1lUijBAmCHVe3qQlfqtGdE3YI4P7Kff8QIenb3MnLSr5C9BHF9ILy5yGdUEg7vSQi7zxN13upkh+ZjE0Z0gY9T/hCSljBON2V63TWoQXOjZjxKwibqyuwLMzpsRQCgO7g4SqULKY4DyMN0YAtvtBsz3v7SrpWDJYntEudjm42z2j91n4EZgNWBDJ3z3Azh76ad+Hja1wOoXq6UsSeXTETGaTdaE46r3/of+4hF7PxwbqcnjSUEi6EvVMF5dKKzEOO0IeFkUm1MWFdk47dWS/FIm4gBggRLKz2I8ol4FzXyC3XJtzrKldie3Am5uncf0fumqcTNG1t3ndlNSLd3o27hk0xZHbKBe5GE1g1gnCZGWWbxGbpAFYJti/OHe18qlHDo3HS5sFrd1huZNVOvQxBpKt3chTrndaVginVQLcZBP575X7z+yhjaLP2EzRMcBdgS9t70YwEoQD85K6309BLazh0u8g7d4VW1dr6J49Uv6f1OoSj7Vs2hDIZPRJHGEO93/QP6rCkVzJB+koiQ10LZrhyKREMkcWhRS4Ng=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGNlanJZaEU0eEFqZXFCM3RLbUpML1EwYkpwcEQxNTdSSDROejdnOWdFM0pF?=
 =?utf-8?B?WGNldVFCVzczSVNTaTFFM3ZydStLaHVlWVpOZHNscEFLcko0YVVITUlHR3pl?=
 =?utf-8?B?ejNTelV2YWNRRDUrN2VQVGdMN2J0dll1Z0k4eFZLclc2WENBQVgzU1k4eW9M?=
 =?utf-8?B?T29UdW5tdEc4ZFBsWjcvWVpDTVBVSjBINW5hem0xM05jNmZFOUpKZzdCaTBu?=
 =?utf-8?B?WTlxZ0xjSDBJaU1SV0FKVU1nZlNUM3A3TEFRVHpUTFBhM0hBSGJwSEdSMlhp?=
 =?utf-8?B?ZUNPRFpMMXBIWGNHeHY0T0NIVkNsd09xSnF1Sy9oQjhueDluSlNKd0h4eFk1?=
 =?utf-8?B?N2prbi8rNFFmdXlKeFlFRDlrenJlTWhUbHc2RUxZNERhUklzTE5YUzBDaDFt?=
 =?utf-8?B?ckRJOXczK1p6MnpOM3kvd2cvcW56azh0TXZKbnVIb3VRNk9ZdmFobHZrd1Ru?=
 =?utf-8?B?aVhmY1RKa1c3bHlNTUErQ1NubUFiK1QrMUk1RTBsRnpqQjRaUUpVbkRMTkFU?=
 =?utf-8?B?eW1OWC84N2dJRWVMcDhUMHNQM3RtY1hULzZXSzFUSzJ4TmprWFo5dUJHajFW?=
 =?utf-8?B?UDQxUjhwL2lmZ1ZldFNQdjlsaXNCcjhVeThWTE9nYUdBQzhxbUQwc0lTTlY5?=
 =?utf-8?B?VGZrVm1GV04ycVI4cTVlRGdBOEZ0cTZsUE51VHp1QnhrbGloUGRTaFM5QWJl?=
 =?utf-8?B?U1JoMEJpMCsrTFdrZDlDb2xoRC81cm13bXJBcy90dG8rQzZZa1ZQNnF6ZTRx?=
 =?utf-8?B?Sk9KRWFMYnNyZ1dkcEZ2ZTNEaTA4SmhyaC9nS25OZVV4UFRNd0xoa2RlK1FH?=
 =?utf-8?B?NEpaVWZocXd4Nlc4Mnc0M0xtYUlGOVEvZWUwOFdqeXMvYlN0UkJpckY5NGNF?=
 =?utf-8?B?bjJ0c2EyazNOdytlQjhiWklmdUNUaUF2bzBmajMwbWFrNXV1L2JHZVFLWllu?=
 =?utf-8?B?bzhOVVlUWmluM3pjMlBJRkRzSGd2aWVLQXRkZVRRS0FaekF4aGZkalZLTENx?=
 =?utf-8?B?Wno3VTdUZm1hanlERzNXblZnVGNGZ3Y4b0lpZmVEYjRrK1FyOWtuSVNjU3N6?=
 =?utf-8?B?QWx3NDlqWmdibEtPMmxqOHdEa2FNOVFKRGVrVUNHd0RaY0NjeGNZdVJQNWla?=
 =?utf-8?B?WmttYzdqdTZXcDdudndDd2htaGpvQjBaemdpdVJNWHczclk2SWhMN25GUlk3?=
 =?utf-8?B?c2hlNVFXWmZBTFB5MjhnWWhLRmtQWVhLVzZzYU40d283U25NU29QY1hrSzVP?=
 =?utf-8?B?Q1JEdk1OaVFQaDBpRElid0NMMER0VHF3NCtjUklsbTZBUG9QeXBiT2k3UEhK?=
 =?utf-8?B?d25EdjVuVGljTTFITGxRazFUcEFMSXVCK0s4Q2ZLSjdaZTB2UFJIUytTcFg1?=
 =?utf-8?B?OUpFUnBrL2pydmdYQUpKMzBOWkdvcDRGK3RLNVhROXBoRlpBVlA4eFFBalk1?=
 =?utf-8?B?Z1JRUzdIcFppbE9xVVlHRVVHV0l1eFJ1c0M4RGJzNHBFQy9JOS9QNkNHdXlk?=
 =?utf-8?B?ZEwvRFBndG41cXU5V09INVVrdzhJTUZQdVlaQUt1elZreWlDK3ZFbW1ZaXBP?=
 =?utf-8?B?TVFFUjV1Q1Yxajl3RGFJTXlzem9kMmU5WEcwL1hnMHFZRHo3Ni9tTHoxQk5L?=
 =?utf-8?B?RmQrLzdaTHZvejJYeExDSVBKc3VDQ2JYdnp2MklwWDVBWks4OTRSUWxwN3c5?=
 =?utf-8?B?ZDNQZld2Q1c1Vm1ZSmhXNnYvYk9qaGRxZVRDa0pucFcxM2N4MXg2cWNqYmor?=
 =?utf-8?B?N0RTcHh3b2Z4OUxKUlhwWEhTeXF2UlFkcExLWHRhZ0pXYkRVZ0NmMXZlSG9K?=
 =?utf-8?B?bzNjaDVhZ2NsZENra2NrQ1RXTDRONHF3c2ZnbkVsRjk5cFZpOTVHcDlzVjg2?=
 =?utf-8?B?R1o1MTFCN1RYRDVqTVA2Si9hSUU4NzJUSk9IU3ZFRDdTUk82cEtFRVFhMVRw?=
 =?utf-8?B?SGV2VnB4N21lK3djNnBvSDZLbWtVYXlqdUcxekdLWnpXUlBjVzMwVDg2amd4?=
 =?utf-8?B?d0dFMHVpSG1Lby9zSTE2YWJJZFMwbHBWblM1cFlETzhDTTBlYWJQaG5RZk5X?=
 =?utf-8?B?Sk5zaTlOdjBOZXVucVpQamtVZFRPdnMrNjZUZXI4akg1eEYxVXN0cGVSVXB6?=
 =?utf-8?B?ellFemhUU1pTeGdhclEwRm1hZUtBR2J6c2VsZm9sQVlIUnJ6NTRTSXVvejlL?=
 =?utf-8?B?UWZSZ0FUUGFDNkhianRIRkw0cmxKcHNMakh0MkpYNXNRRm1aWFErODM2b0tK?=
 =?utf-8?B?TVdSYjgyUHhRMmxnZjZIUmN0TGZ2UXVVZkgzYjEyMkwxeTgvN29WdGc4Wkkx?=
 =?utf-8?B?VmtxMU1kMXBEclo4aUsrU3BDVDg4Y284SzFhUTBzWHdYOHRUbEZaZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f178c4-2102-4363-5eb3-08de7fb48e04
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 21:24:18.9510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npQMIM05R8WlnYzEZ2asPLrirPpjT+i8rNqPUmO/kj7uUXvoVmF/dio3aZGnUwQxb+nMoap2oRhbbof7tBsqsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7468

Hello Dave and Sean,

On 3/5/2026 1:40 PM, Dave Hansen wrote:
> On 3/5/26 11:22, Kalra, Ashish wrote:
>> But, these are the performance numbers you should be considering : 
>>
>> RMPOPT during boot: 
>>
>> [   49.913402] SEV-SNP: RMPOPT largest cycles 1143020
>> [   49.913407] SEV-SNP: RMPOPT smallest cycles 60
>> [   49.913408] SEV-SNP: RMPOPT average cycles 5226
>>
>> RMPOPT after SNP guest shutdown: 
>>
>> [  276.435091] SEV-SNP: RMPOPT largest cycles 83680
>> [  276.435096] SEV-SNP: RMPOPT smallest cycles 60
>> [  276.435097] SEV-SNP: RMPOPT average cycles 5658
> 
> First of all, I'd really appreciate wall clock measurements on these.
> It's just less math and guesswork. Cycles are easy to measure but hard
> to read. Please make these easier to read. Also, the per-RMPOPT numbers
> don't mean much. You have to scale it by the number of CPUs and memory
> (or 2TB) to get to a real, useful number.
> 
> The thing that matters is how long this loop takes:
> 
> 	for (pa = pa_start; pa < pa_end; pa += PUD_SIZE)
> 
> and *especially* how long it takes per-cpu and when the system has a
> full 2TB load of memory.
> 
> That will tell us how many resources this RMPOPT thing is going to take,
> which is the _real_ thing we need to know.
> 
> Also, to some degree, the thing we care about here the *most* is the
> worst case scenario. I think the worst possible case is that there's one
> 4k private page in each 1GB of memory, and that it's the last 4k page.
> I'd like to see numbers for something close to *that*, not when there
> are no private pages.
> 
> The two things you measured above are interesting, but they're only part
> of the story.
> 

Here is the concerned performance data:

All these measurements are done with 2TB RAM installed on the server:

$ free -h
               total        used        free      shared  buff/cache   available
Mem:           2.0Ti        13Gi       1.9Ti       8.8Mi       1.6Gi       1.9Ti
Swap:          2.0Gi          0B       2.0Gi


For the loop executing RMPOPT on up-to 2TB of RAM on all CPUs: 

                ..
                start = ktime_get();
               
                for (pa = pa_start; pa < pa_end; pa += PUD_SIZE) {
                        /* Bit zero passes the function to the RMPOPT instruction. */
                        on_each_cpu_mask(cpu_online_mask, rmpopt,
                                         (void *)(pa | RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS),
                                         true);
                }
                end = ktime_get();

                elapsed_ns = ktime_to_ns(ktime_sub(end, start));
		...

There are 2 active SNP VMs here, with one SNP VM being terminated, the other SNP VM is still running, both VMs are configured with 100GB guest RAM: 

When this loop is executed when the SNP guest terminates:

[  232.789187] SEV-SNP: RMPOPT execution time 391609638 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~391 ms

[  234.647462] SEV-SNP: RMPOPT execution time 457933019 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~457 ms


Now, there are a couple of additional RMPOPT optimizations which can be applied to this loop : 

1). RMPOPT can skip the bulk of its work if another CPU has already optimized that region.
The optimal thing may be to optimize all memory on one CPU first, and then let all the others
run RMPOPT in parallel.

2). The other optimization being applied here is only executing RMPOPT on only thread per
core.

The code sequence being used here:

	...
        /* Only one thread per core needs to issue RMPOPT instruction */
        for_each_online_cpu(cpu) {
                if (!topology_is_primary_thread(cpu))
                        continue;

                cpumask_set_cpu(cpu, cpus);
        }

         while (!kthread_should_stop()) {
         	...
                start = ktime_get();
               
                /*
                 * RMPOPT is optimized to skip the bulk of its work if another CPU has already
                 * optimized that region. Optimize all memory on one CPU first, and then let all
                 * the others run RMPOPT in parallel.
                 */
                cpumask_clear_cpu(smp_processor_id(), cpus);

                /* current CPU */
                for (pa = pa_start; pa < pa_end; pa += PUD_SIZE)
                        rmpopt((void *)(pa | RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS));

                for (pa = pa_start; pa < pa_end; pa += PUD_SIZE) {
                        /* Bit zero passes the function to the RMPOPT instruction. */
                        on_each_cpu_mask(cpus, rmpopt,
                                         (void *)(pa | RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS),
                                         true);                       
                }
                end = ktime_get();

                elapsed_ns = ktime_to_ns(ktime_sub(end, start));
		...

With these optimizations applied:

When this loop is executed when an SNP guest terminates, again with 2 active SNP VMs with 100GB guest RAM:

[  363.926595] SEV-SNP: RMPOPT execution time 317016656 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~317 ms

[  365.415243] SEV-SNP: RMPOPT execution time 369659769 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~369 ms.

So, with these two optimizations applied, there is like a ~16-20% performance improvement (when SNP guest terminates) in the execution of this loop
which is executing RMPOPT on upto 2TB of RAM on all CPUs.

Any thoughts, feedback on the performance numbers ? 

Ideally we should be issuing RMPOPTs to only optimize the 1G regions that contained memory associated with that guest and that should be 
significantly less than the whole 2TB RAM range. 

But that is something we planned for 1GB hugetlb guest_memfd support getting merged and which i believe has dependency on:
1). in-place conversion for guest_memfd, 
2). 2M hugepage support for guest_memfd and finally 
3). 1GB hugeTLB support for guest_memfd.

The other alternative probably will be to use Dave's suggestions to loosely mirror the RMPOPT bitmap and
keep our own bitmap of 1GB regions that _need_ RMPOPT run on them and probably this bitmap lives in
guest_memfd and we track when they are being freed and then issue RMPOPT on those 1GB regions
(and this will be independent of the 1GB hugeTLB support for guest_memfd).

Thanks,
Ashish
