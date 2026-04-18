Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012042.outbound.protection.outlook.com [40.107.209.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B828361DB5;
	Sat, 18 Apr 2026 13:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776520534; cv=fail; b=OGLS9Kcx6ePKk4ZE7UL01GP0PfPfQ9O0YAYn3Ml+Zb2dIFxqnpB4/8pYQcj4tEvUNYJUtVmF/RjGYa6jDSpY2n1bxkjPQEaDxTOb32TCWB2ScFjwWCOdr4U8Lsh1e9DGr6yJkZfhyKLe2UYf+1ASSW343MSWragR06CNivqAtnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776520534; c=relaxed/simple;
	bh=/P8v8XCZ6w90BdoAAvYwaxptxYIYleS4ZJmAypFihmw=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AqIVjGbov3fCqRyuEu5HP4sVx4zu4keoFgn2w4yJO+foySlZl/5O6IbD936C7sL9xijMmJIZZSUlNU3Qa3xHpACr7SO0/6qWtSvf7VM3Qsx+z0+ckDplSm9VkCwznzHEpdEqppPDvOLS2+NjC8l55pJFfTXIHaspzIIMjCbl0Ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xi7pv8b/; arc=fail smtp.client-ip=40.107.209.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xi7pv8b/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G2hNNzLzmAHNfG6Eu0xKlTV/i7dmhAw/4/Qmku2EQ6xuhLO2uTf3pKF7WlU5SVhhig7XsNodmZHJ2L570Ng3z9Cr48ahsO8bciru2pDdbqwGR1G1vVDrVZsaN0kvg3dXIbJS/c+PjqDpFv009pYZFQ9GUGtUimtvR9+kh9q5O0udb7Nswoj/Bd/soIGambrIu9SdgOcSRjb8wKybsOQSSQDDlPhisuQNR3ekj+HA4/+b8/mLwlfElx4LD2TsImkiE4QCyJES8Fq8+rQCwqiz7A4fItftvikfkZdnhASKVAb+oCvaJmeEn0VTSE/YQ9cTv7KY446hYn2gNdsIUBO3/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Nlub7KhJf5IgWvVHOal/fhkrJGPRuTlTBdUArysozM=;
 b=jr/0O30zYy6MKcNe9P8cJ+gXON5ctEfDADJZWGhakSGy8HysHUIATuhdSjzYtS6duypP8HlLCG+oJpT+yVtdclSdnq2zZkAQzGwJTPl73Epuv7g07P+HL5VKrx+RpRn8GdY88eZ3siT0nw+DTbpS9EDMwd5uDnejnk5YCahlFqQAzhbHkJ53tvJZZHrzjcmGDt0GNXag3iz1Dwl2pXksGlG9eEfikcD6jXqpuPUoPg1rMuR9nMOH8HZm0YSKg6f88PZ6MNCMGcrVf6cP4DEgoKkrpfQnazTItmGSeGpq5Inyev4AHGfSW+tXc7pZvlGiUEdPFeeJ7kMsWhYNY4A+Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Nlub7KhJf5IgWvVHOal/fhkrJGPRuTlTBdUArysozM=;
 b=Xi7pv8b/l8Xi/Qmw3QmtMefaXj/ZlGhoDEMibJBi99HAk/FTK39nvsrS4KvIfhF/dPVilgSk8ER8uLEGOBRCqsr2NpMaYaFACaxp5TDIMa6pVDc4To4g0NC2h8uCqe4LOqLMZ2grM9w7JTTztro94nUx99REIfe+QJ3gmjd9plg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB8275.namprd12.prod.outlook.com (2603:10b6:8:ec::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.8; Sat, 18 Apr
 2026 13:55:30 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 13:55:30 +0000
Message-ID: <63535447-37a9-446b-961b-52f284479e8a@amd.com>
Date: Sat, 18 Apr 2026 08:55:26 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/sev: Do not initialize SNP if missing CPUs
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Kishon Vijay Abraham I <kvijayab@amd.com>, Alexey Kardashevskiy
 <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Kim Phillips <kim.phillips@amd.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260407174713.439474-1-tycho@kernel.org>
 <20260407174713.439474-2-tycho@kernel.org>
 <c88d7a24-1806-4ceb-9e0b-1a07ecf955ce@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <c88d7a24-1806-4ceb-9e0b-1a07ecf955ce@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB8275:EE_
X-MS-Office365-Filtering-Correlation-Id: 7185eb67-d290-4b41-b070-08de9d5226df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	S8RBmpWvYbWcTPQ2rOO0iFlHH7Hg33utaQhw8xGiZou+40BNEieoVBMJ2NsJVEyHYD8UwK/VsL5wigvLBCOAhaQ2xCLxGIFA6+pRs/ewdhXu7WDGVmBL0LH7djzh2bA+jb2D2ZmSFlJIFpt1M+QgvaU5K5CrmIhSOf9xMdOZHZDzimgQdj++9mtLPGT3+R12k5l3AlWFmdc65w5I68haT0zV4tzG/EMYPGHASu0y9lwVN4huMwWXSO9E8s66Yt7iBTxBKreJGUAR4vlHk58xK27mnrffB7dVMrbNGymgiZOk72IBKkcwimtRugW7BrIOk3HPlAaFBaE2ejfL6I0jsY5U6zGKXQfGUQdvv3hAfz3hTOfs6cEtuZpBWF2ukMYYwuzKiKkHBm9drcySDtcs/ITn1IqQg7D/E4ovnsLYAsF+k2PdyjZHNoRa2xBPa1Duc3kHS/90n12N1B/aQFhU1q2SgEAKXAl/4fmMVcAdjAS5LYdO1yNixNr8seJOmC8UDp15YAxIrg47EBjt9dZPxf6CXHLvekgea1OZe337cpOuSMdh9CpFu4qMI0T9CX+oJgjv5SYXfTtURCF5zaqefMd6PwjiWp7tKQWcRfDkQ2ntz+eCWrLxL7M12iRP0IbkrHHaOHA3tHv0303unJqpxVsj56yS5VxzHD3Ih270FN9McfClggblyg2iqUZofO3+Gyp4IdwgeLcidR1JA8jtpMGlXVUKFWYAcD7jqMWy+eOuHULKU4LFBJ8lOy+TaPAnKol0CAeiLkhvqQ78Dai36A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGdFOFlNMFBVdVFLV1k3ZFNFTEgvUVEwaytBVHRnTDd4QUtEbnhIM1BLZlkv?=
 =?utf-8?B?K3JOVGlNSjc4Ui9SYnJ4Q045cXJMUXo0dEFkTGE5aW5OTks0REhvYTBNZG5u?=
 =?utf-8?B?L3FHditRaDdiM0M1bkR0N2l6MW5oOHpEcytHYUphdnJCNXRobDJzSkFYNm5y?=
 =?utf-8?B?KzhrcU0waWhaK3ZZS3lUNEFOSGRtcU1UcmlVZ1FieHVRbGsrelJ6NG02eWdX?=
 =?utf-8?B?YkM2d05XL3lndExWYTBYR3g2eS9jYmpieElRbktNYStwWTZSdUY4OXpJd3BP?=
 =?utf-8?B?S1p5eXAzZGF0RFVuZU10dmxaV3BmeDBYdWliMGZVd08vV3ZXUGVyUDlGZU9H?=
 =?utf-8?B?VjJmQlhmbktXVmlSUDlwZis0R3dmNnhuNVhUek5TL0FyRGxQbXFsU1NvajRK?=
 =?utf-8?B?ZU9UV1BtWGxOWStmcEJMdTRVRlZaYzJaWG0wNUlRSTdnclJ3SnQ1elNqUUZ4?=
 =?utf-8?B?ZnRJYWwwdFlEZzFnNERmWk0vUTI2eXhxTnFTSU1XMVRZVkFYLzQyTFdDUm9E?=
 =?utf-8?B?VzBQZmxaUTQ3T1ZIR0VBUDlsSlp4MnFudjR4bitGeGY0bXlwVFFrbUFlbUpC?=
 =?utf-8?B?MjFyeVF2dE1QZGxBbXdJUWhYSVNEQlZrV0d1MHBGaFV0TENBYm05NW51alAv?=
 =?utf-8?B?VWRjQmFrWDBKOGRoUS9qZkUvMWxLT0JZS1JtZ0N6eWFFQUU5eGJKM3B6ZC95?=
 =?utf-8?B?dEF3N001VHBJaGMrNmszR1JaWDhicXVWYk9UWU1FZU1hTTBhZ05WMU1GSWtR?=
 =?utf-8?B?Skc3VjhscWtRYjMzQjR3aDBlOWZDeUNXT0g2UWlrd1BHZGFFR0tmaTNvczlF?=
 =?utf-8?B?STl0amMwRGI5aktuaXZacjRnRlZjZytPaEVZVjI3Q1pKVUEyNlA4c1pDTnE0?=
 =?utf-8?B?bUV1OTJ6UFEvRmNPRXlzRExORmxONWpBTWgrOWNUU2kvZWhUNVVJNVNhT2oy?=
 =?utf-8?B?WXVXejlWTHlPM2I4bUpMMm93a1lPUlBZUVdXM1NMYTBQOGVmZHZpKzRYZGhi?=
 =?utf-8?B?eW84LzZDbjRjR0NJcHRCdHBmeG1oYldvVUxuOVdDd3gwaTlRc0I3cmorRW1x?=
 =?utf-8?B?UUdvVUUxU0MveTRDcWtad0QrdUZHbGl3S3JqMVBxSmZaT0ZpVDNxRnhFcjdy?=
 =?utf-8?B?di8wMy9mdTNNSjUrZGlrTkp4b2EzQUMzN1ozdCs4bGNpT1pLZ0J2cUFEWGt5?=
 =?utf-8?B?L0gwMEF2K2c0aG5WVjlLMEJpWjM5Nnh1T25LMW5LUytFSUgyVldGeDJCNURB?=
 =?utf-8?B?TndZWmoxSUpiNmM2OVFXaWY5ejNvaGI1ZWxuQWtQWFUwUVBpOGJaend0ODRw?=
 =?utf-8?B?WTh1Lzh4bUR5Q1F1MVRKZTZwSGdUSTNLQ2NhaktmLzJSV3lnMUtickxXMFky?=
 =?utf-8?B?WkxlNGZOd3hYQTc0TGlrYVZNUnl0dHZ4YlZZdU05V3libTFKVk1zRjdRelZ2?=
 =?utf-8?B?Q1BpS2Q0TlpJT3BzekkwUWMzSmtqa0RDeTc0dFR1Y0hBaHdrSDVjVE5vSy82?=
 =?utf-8?B?dVduQ1JNdmpXN2xtSFR3VDZVMUZtWk1aeUtySEJGcGlWSVh3Ri9kbmRma0gw?=
 =?utf-8?B?K3d1TTlvTlZMZlUwaklMWFprTUdheDBxdG8xVVN0WUY4MWV1RklrTFJGUUdN?=
 =?utf-8?B?YWFrRWpRbDE3UXVzZGRyMXJFbHNsYTdJT1dWR0h2bUxOVDRLY0ZSeXRxT0Uw?=
 =?utf-8?B?aTlKK2g4ak9oS25rWE5vNVM1QmdyTjFyNkJCMitkd3ZqN2R6RXpGN2YxMXly?=
 =?utf-8?B?NTFiRzFLRE1wc2xKUU54YkRNRGhWOGFWSkJBZ3JZWHlmM1NhbGUyTUMrMjds?=
 =?utf-8?B?dGtqSUVXTXdhNkF0WC9zQ0tlQjYxNi93SUhpdTk4NDNvVGJXSldqa0ZOZlVs?=
 =?utf-8?B?Unk2RzJ5N1lBdFFYa3NhaHNseHYyNEVjUG5PZHl3YTYrNnlpOURYZlpSQlM4?=
 =?utf-8?B?S0xQQ2sxdHZEMDdQcjJUM0xPeXV5Z29wU2tlbUxVMXA0Q01IalFFbU1rRU1a?=
 =?utf-8?B?WkpZMGREcWhCRFlGT2IySEhFWjRNTC9XaHozdXBRT1llZWRDdGRVaHZMS2lN?=
 =?utf-8?B?UlZRbjlrWWtCSVcwTFkzaWVsM1NWRGo5MWV3TWlhRTd6RkZnQ2RhenVOQUg4?=
 =?utf-8?B?OGRRdlF5MWMvV3lXbGlBYzFFMitxY2ZyTng0bE14ejI3WUM5a2hlRmJkR0FI?=
 =?utf-8?B?aUJnaGFKWkt3ZHk1bU5rZUhrUGtBTW1ZNFBrOGxMNXJUeWtjS0xwTG44dmEw?=
 =?utf-8?B?NmM2dkU5TG9PR3Z5c3prTWtheFhFUjZqUStyNitNQmt5VHBXV2UrbkxSVnJq?=
 =?utf-8?B?TUE4STJNNFVNUFZiSVFKaG9QakhvNWlCaW5uY2RJKzRNYnFYTjJaQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7185eb67-d290-4b41-b070-08de9d5226df
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 13:55:30.1306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+0uXBgR4qZDiCYy+8E53dxMwcehmVW9bAW/QXbgMOkijA42Pw2opQ70TN6/WvWDw2tibip2vdOLp8VDtYK58A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8275

On 4/8/26 08:10, Tom Lendacky wrote:
> On 4/7/26 12:47, Tycho Andersen wrote:
>> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
>>
>> The SEV firmware checks that the SNP enable bit is set on each CPU during
>> SNP initialization, and will fail if it is not. If there are some CPUs
>> offline, they will not run the setup functions, so SNP initialization will
>> always fail.
>>
>> Skip the IPIs in this case and return an error so that the CCP driver can
>> skip the SNP_INIT that will fail. Also print the CPU masks as a breadcrumb
>> so people can figure out what happened.
>>
>> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
>> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
>> ---

> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@gmail.com>

Ugh, that's not the right email address:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

At least I spelled my name right...

> 
>> +	return ret;
>>  }
>>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>>  
> 

