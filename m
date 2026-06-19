Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02AD32B9A8;
	Fri, 19 Jun 2026 20:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781902291; cv=fail; b=aG/+aT1F73Rse2epenJA11/oY1NrsEP4Jhwu+eEUYZM+ZdETLoSsMKolnaDY1MSQM8ecY0BI4zNv+lmZ/1B56ygyptMMQ/isB7Fa9jgvoqRLdhCg7TPBhs7E46Qr6i7nUpdaYJbnqwbwcgFT21+xEGLPGyft+zshKUqT3lS1BOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781902291; c=relaxed/simple;
	bh=wd/ycAdpmm/42sKKVlJ6xL4oRKcQSU2wY+dRZT+b/eI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bzz93lL0YIaF91ggA/ItQJgv3O4ZSAo357FXATuhGiXofkQXUW354YgvBIOWcq/WLKbMRGF7TGHiWnJ3kj4QOIuyU74AntrnsivCuh1IeWKDofvQ+S4MUyj28/VocUV2Jck85SXnGvHU2q80BgQgqPX4nrFmT+Z7WBBR17b1da8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Wq4z/w0q; arc=fail smtp.client-ip=52.101.48.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Wq4z/w0q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t/x31REhVfZ9pquEj33EKvjx6hZyqFfQC47YNcs+ZcPy7iqtEwBfIDKIk4aTq0ecFHb/fpgJW5EVM/b83BtxT8SWyG1UiPxgEsxZFWiaGiBG7zB+5KrRviEdjuIkOTM1HIh5SPIfVmbH7LKG5W8z3X0Y8JzAMesuwZhMhg/0TWJwnjKfj8K4WO6LkXtOAiD+lFmX8m/qtHaR6grylJh4MTsa1kwHMA3yrNE+4aVYFcnd349C6iDWgNlXINNru61eR9jg3wnnvDlhH+CEhzNUbkWMDe6AUA/nXFLmltzypSsYJZHxByrIzS269lIST0W2pt9LjEX0WTpO2BOq5TtNkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pkj2Yxn+V5cw+6YEJ8HdqYzrTJHJ9G+brrYz4iPl0G8=;
 b=n/rPPYAiVJlak/uByasZ4iqJeSE5ZuWLSPDBWjSXsPfvXILoYIylcVWXr/7KfVnydiJk0LNP9XupO8mfYoCN2smgWwRvbptpuB/1VfogUR/YRU6pm+Znv1GACtO14Y/b2UwT39EqSqzVSQPiB7dxxFuVKlV2Auzp4OxKQsO2FfaEnSRUm3uGLWDx/G0kAIBnxtSdcDytKmcU5se1EKlclASETsPVq+7/pt1aggoWG8tcVhNWJ3DqH7E1NmSBFPFdLEub/XE6qvOOcaCWQVB6zZHB+z0RqU+mk7zCRg5DBSnuGzn4FdJ7M28n1YXar7XMPUgz4Pa1isSkZBDCtlRKUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pkj2Yxn+V5cw+6YEJ8HdqYzrTJHJ9G+brrYz4iPl0G8=;
 b=Wq4z/w0q00l7eoSNq6/rYsS+r7Fww1X20N5sO3B4KRsP6JQpFTAVrqYoxPvI+x/96hbOuJ4ICzuvaNRZP/+9diqXlQlstG0Kvn9IMBptxWzka/BmXA0Ugfwr2LIBHuzvJHpICde1okO6fNQF+jzLhipXbRfrk67zuB+z+NEXSF4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by CYYPR12MB8750.namprd12.prod.outlook.com (2603:10b6:930:be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 20:51:26 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%5]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 20:51:26 +0000
Message-ID: <bd2dc2e0-e975-40a9-8e0a-4403db858316@amd.com>
Date: Fri, 19 Jun 2026 15:51:20 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
 <49380c3e-c275-4211-876a-c51f644aeb17@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <49380c3e-c275-4211-876a-c51f644aeb17@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:610:e4::18) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|CYYPR12MB8750:EE_
X-MS-Office365-Filtering-Correlation-Id: 40d733c9-adc0-46ff-bd66-08dece448724
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|921020|18002099003|22082099003|11063799006|5023799004|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	D3yCJWzOKu6NLbyiM+HtSqzjk0mruXVPzvKeYYS1Y7oHSTKV1WaWHj3XY3kufXZtpTV8M+EbPJgfaCvcZmb54tbloEcFUH1YLD0IoHvBNoDEasB4QjCBj1oR4L308WnhvjCgg7/4mmYpUMjqufKDpKbASYs+Hj72tyR99/7m7lD3Umc3gPaPHvVsJ4rqtk1G7JcOT1UMbZ0pwSjAz8y2UPOSi75/gnvgotl0kfNa3riFL4fng1/9V0TcmhFxRcHRSqJY44MzKjUyiBWGroGpWzBeo5nj8x64u4qGZuwcYfmirFNFsmtf9/sloKU29xtTB/o4aEjv7y0H9rG3EcsRVT7yzWZjlvrRkJr3xWtdeHYt/wm1rfteIwkUlEaYwUODlqg9IyO1IX/BVNQdq1KldWg4wTnkDpoum/7O8Ke3NQKjCYoVpgS96lti7VkWhUB3YDYKNTt483q+WKYsTVnSoqRh2jF+iYLm782z1LokwPgGWFSsY+HuKg98Gz4mrsyBkMZugpvsKCpR6XADwdyk2vw5OjAUUexzzxLnOmxIbC66FMt4LVxutydNkIiJdx9fGf/WFLH3+25NI9cSOu0kqn487gT3iUqqilUwS/U265BwrgzA2CUeT8la13/xGK9G+o+jzQ9xJELtMFrCkNOW4y2kQPB+LRCKkMUi0bmjuvIMoE4DxmRg0LtK8di30jhqXJSlzCz4uknlRKor4FpXMg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(921020)(18002099003)(22082099003)(11063799006)(5023799004)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWs1YTFIKzBiRnRlNWsxUDJVYStBSUNud2w1OVVKTXRYdThxRHV1ZVpVMG5u?=
 =?utf-8?B?M3RJRFQ4NTJyYWF1K0xuZ1hwendTd2lhR09qZWIwdTFwbEtyc2pIS3dyZjNz?=
 =?utf-8?B?MGIwYm9hUWwvek5qVU45R2ZLd3ZKb2Q4WS9MbjkweW9pVWJNa1o0dzFTTTl2?=
 =?utf-8?B?aVRGL2pHRFZQaTlnVytldG9ZRnRHaTV5Slk0Y0kxa2hHRVVEMDlkVVZBM3BH?=
 =?utf-8?B?UzhQWWZIQ3ZVQ21vVU9zaURLb0pHWk5uam52MzF3YlhROGVMMlpLOTZIanFn?=
 =?utf-8?B?UFZHVGYzU25LVGgvNzZFSFg3eDhlTHY2bFB4TkRZa2pTbU9TaktkdFpzR2ZC?=
 =?utf-8?B?NDF6QjliRVdvMlk1ZXN5ZENHcm1qbFpHQlczcXdpZlN4VHdmaDRLOVppV1JI?=
 =?utf-8?B?V3U0U2x5Ni83RmN6SzViZ29hcWxvQTZwdDFjOFpQM3dKR3RjVVIzWkFZVEVL?=
 =?utf-8?B?NDJ4UkNKM2RhMjN6Mll4TmNQd3lHMUFmYVRMemxXL3djeUhPZlpyTWRpVUM3?=
 =?utf-8?B?N2dobldyclhpM2RzN2JLdUVvd1kwSjNSUnhKRDE3YURmRkV1SnVubThpSjVW?=
 =?utf-8?B?UFhXN3dWbFdCVW9Sb2tvWUw2eDVjaDkzT1lBdGdMbWUyemQvRU9Eem9Zb2xr?=
 =?utf-8?B?NC9jZFNWNk1uRTNqblc5aTZzYzJrN3dEZExHd2lHOUo1alJhVFJXcGtoTnZW?=
 =?utf-8?B?SmVZWUhjOEd6a1ZHbU8walZpRUxTQ0R5U2c1TThFSnRDNHdTaXJndTNXVHYx?=
 =?utf-8?B?LzFUN1VObkhlRUxUYW1FckdVSEV3QjBqZFJqbVlEbUdWVlpiOUxEN2x5SE5p?=
 =?utf-8?B?Y2pQNDVnMzE1eWFBQm5TbE5sald2QU5hVUlTeWZYRkRTcDJPYXg5YXZKTE51?=
 =?utf-8?B?RDFScS9kTGY0Mis5bmRVOERWMlhHTzJtbFlrZm5jWUlwN3NYNUhJN3kxcnJW?=
 =?utf-8?B?UzhyTldtd3RocjJlSHAyd1R6eEhhTUlQM2l0T2ZXdXVPMDdsSnQ2R3FKSU9k?=
 =?utf-8?B?VXNScTVQTDBrWVRTYmdoTTdCOU9xb0NwMFUwNFRIVGN2VUVpV1Z3WXFkeDlI?=
 =?utf-8?B?S3NuaEVzZkppY3l1U052MWRITFpvMkNLSFVXZ0pCU3hYallmRm1zNEU2S2dk?=
 =?utf-8?B?bzQydWFQZXg4azVDYXlCekljRGpDdjdJZVlOSDRObk5oM1FNVVBHZjEweXAr?=
 =?utf-8?B?dFhwNTZ5Q1VPVnJta01GMXcvRnhubHdUL2wyTUh2KzU5TnFNdnFRVXd6ZHJv?=
 =?utf-8?B?bVp2TDcwYlpqeXJiR2dLZjJML2M3RmE4aWZuMGFzUGVRWjNnVkVTaFBJTlNm?=
 =?utf-8?B?cGxyUFJxMG5SZzB5d0k1RytHK1RlczZDVnZ1THM2Sm5SYjFVbzIwTVlDaTI5?=
 =?utf-8?B?dm4wZUl6OGR2ZWZCOFUwVWtPUi9VV3lIUzRBYldsb2pLQ2RsSENNSXl5ODBB?=
 =?utf-8?B?MTQ1cy9CT21OcTJBbm4yVFFuU0x0U1JxbG5SV0NGWXAxc2I0NzBVVkFIMlZF?=
 =?utf-8?B?YUdqamR1YTV5ZEluTy9zblJhbk00alVJbGllQUsrUk1WbVNMbmlnMWd6azNW?=
 =?utf-8?B?dVQxcTl0TVhJVCs2ZGlURHUwWFcxWk1wUXlzYzZ5elN6TTVWZnpDTHljMjB6?=
 =?utf-8?B?cVJXWDFMU04wTVM4SW01S09rU0czd3hwV3dGWGZoN2VMZ290cUhBb084UzRT?=
 =?utf-8?B?YjFpL1dxMTJsREpqdzIwdzMrN2piOEZQRThEQllFRVdXKyswYWozWk9yQmRr?=
 =?utf-8?B?Zll0cGlRRFpCY1BnWHREOENMbTQyelZOY1BJUjRYSkx2ZnpWYzdGZXRyZHov?=
 =?utf-8?B?Y3dBcVBkTWR6UlM0d29zTHliRVB3Vngya3lnUElCVFpLellrUEJjWVFkbFNK?=
 =?utf-8?B?VDBqbVVVK0JaVFRDdHYyVUVNMlU4VVMwTVVWaENUQjVWang4WGtwSWdEMHpi?=
 =?utf-8?B?NGlnVGhRS3BWOVhabkMyUEVtQytZTXlDV0FVZDkvdWlSQTIrNUYrQStnUTFX?=
 =?utf-8?B?UldCOFBIcXhKYXVaanB0dFNsZVpjQWJzdUxFRnhZRmRqMjVJY3crWGxLNXZF?=
 =?utf-8?B?aGpUZyticXFtc0NSdVBobEtrVTY3QU52Z1JpdTRzV3RPRHlVTStQbkwyWXNq?=
 =?utf-8?B?TWRaNzZPazdsVkJVOEx3Z2ZkZWVNb2t6K09QWENIQzJQMmV6c01PSHBSbE84?=
 =?utf-8?B?eGt4T0l0KzBLZkROVTlySTdQRXF4cGhKc2ZEZFlnZElncDFqdUhLN3BwS2Jq?=
 =?utf-8?B?VXVNL0lwMm9VTWJtMUsydDFmMHJ0dmw2eDduZnN2Z3F5SkJ0YW81cUd6aU9F?=
 =?utf-8?Q?YAWBugeEKTa2VefLIS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d733c9-adc0-46ff-bd66-08dece448724
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 20:51:25.9145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKbVBoaAgQTc3dIk72Hvq0IiVFUlLa6gq3ciNqe7aTBI0bfeYHAXxCrkqQctMEkij8WDeTSFnXJ8Fw1Rm1bmvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8750


On 6/18/2026 4:35 PM, Dave Hansen wrote:
> On 6/15/26 12:49, Ashish Kalra wrote:
>> +	/*
>> +	 * Disable CPU hotplug while SNP is active.  Guard against stacking
>> +	 * the disable count: the legacy SNP_SHUTDOWN_EX path clears
>> +	 * snp_initialized without re-enabling hotplug, so this can run
>> +	 * again while hotplug is already disabled.
>> +	 */
>> +	if (!snp_cpu_hotplug_disabled) {
>> +		cpu_hotplug_disable();
>> +		snp_cpu_hotplug_disabled = true;
>> +	}
> 
> This seems like a hack, guys.
> 
> cpu_hotplug_disable() seems like more of a temporary lock than enforcing
> basically permanent system state.
> 
> This seems like it would be better implemented by registering a CPU
> hotplug callback and then refusing to offline if sev->snp_initialized is
> set.
> 
> snp_setup_rmpopt() can be run any time, right? It doesn't need to be
> after sev->snp_initialized=1.

Yes, snp_setup_rmpopt() doesn't depend on snp_initialized. Programming RMPOPT_BASE only needs
the CPU online and the system rmpopt_capable.

Based on Dave's feedback, i am going to drop this cpu_hotplug_disable()/cpu_hotplug_enable()
and instead implementing and registering the CPU hotplug callback and then refusing to go offline
if SNP is enabled, unless anyone else here has a different thought/suggestion.

Thanks,
Ashish
