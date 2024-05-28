Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2065.outbound.protection.outlook.com [40.107.101.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0096B17083D;
	Tue, 28 May 2024 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716910250; cv=fail; b=AWaD9wSIrUZmvsgTBFDvaeb8d949JFz+/LQghIQdPazZgwb2EpsDHUa03aIA01esUzumlGlQxfRFqTMvuZmeTU8zxx7+pdfYNtusEaJKb2RrazgHkZx3Df+E6pc0fmJ05L1QUvItreAe4DxbVO4XGz+rsHR0D3ovGSq6mkPzDck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716910250; c=relaxed/simple;
	bh=CB67sBJmLHLvY5Jl/zyrYmypeZPIAAZGubMg5sJYYQE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uysuGNU6HjbDKizeubMrBmn0s0mR+5BxhDCGKd9fUxx9SlgOUlwO3Kvslkcvq716HGPE9opSGC6NKT/9hneHcGTIBBR54mP1GNofxSQz+RaxY4W+A4mdqfpw8m/oqumQTsY4mJnJRBRkMSfOhbKEp8PwYVaJ/DY6VuAoBkcvzu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=B5lTfvcf; arc=fail smtp.client-ip=40.107.101.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="B5lTfvcf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDK4sTTYYjrl8s/XivAuS9xDSAtySUBzRbMwN8vNe0ooK0G0Ae3vvf6o7UZqL4pRrhaKfexGnShbcB73X1I/3Kc+NLH/uAJFtJoWytZZV/xRYrvauUNlUMr7pRbylyiqwxk9+5oiv0a5C/pDmLbOUgA32qdbuLZ6Chf9l70+w2D2wIVjiINBkNu8RbvwHZxZtO+v5XXgvEh+VuWZCH2OD4iZUd8HfUTffvE4TUsakILc/3XwRzhT6rAeidSWRsOy5XPdM/lZmVOeBaFoUmWnT9JT7ILN6tZrmksDeVvZzAM2J1m/REIX7iRGxOXwLpC4Dk9io3YMf81d4+A2uZ+K9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GRUjwS8cvErFI3ArA5FchZUH1I/ieJxXVR95YZHCY14=;
 b=kMV5QzgQZBwxD75qaQZ/HKkDphl5YeWhjjAYhCVNUFRTe7XD5etYwIGaphBxdaUymwDNE6Br8uHDYMCILBsG2mkp8TlUOM0Atlxlt+/++3sT52DGjvBg+UMXUx1cPcW07HhBIRI6NoWcYQxG1Ju1Qk4Dw+9AKzNvmp4wihcwoTtNplpD0YdpiRdnkFaZB98eTpxN7gMe1SwOlxkhc3n84MdOcbehATeaz9oZ6dwjHpCLda+DihlGvQ6eUYsW6FGvsbvoqrSLKVsIAQcx/BukT082ZfEaelOItb6cq4DoNQ25+T+0hlTOSn5796pj3Phww+ISfgIVy2f+R2Cl00q8CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRUjwS8cvErFI3ArA5FchZUH1I/ieJxXVR95YZHCY14=;
 b=B5lTfvcf8dzr5imNz3SBllo/uLF4bnvcK0UQD7GwjwuxjuxdRf/TdtbFZ5Sy9zENKoufBBlYB6oEgvQTwyjwSnw6s8w75+zWI4stf5cl1mzZgS36uT9BbjihNYtPSDRxlHHemsvyI84dE2BD5bW9Okgf0N/xYPUSc/y9KPahVcE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CYYPR12MB8749.namprd12.prod.outlook.com (2603:10b6:930:c6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 28 May
 2024 15:30:45 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 15:30:45 +0000
Message-ID: <546fba1d-37da-1ea6-f5fe-5f334615e2ba@amd.com>
Date: Tue, 28 May 2024 10:30:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 3/5] crypto: ccp: align psp_platform_access_msg
Content-Language: en-US
To: Mario Limonciello <mario.limonciello@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
 <linux-crypto@vger.kernel.org>, Richard Hughes <hughsient@gmail.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20240527152649.3722-1-mario.limonciello@amd.com>
 <20240527152649.3722-4-mario.limonciello@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240527152649.3722-4-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0115.namprd11.prod.outlook.com
 (2603:10b6:806:d1::30) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CYYPR12MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a9d62fa-7324-4ba1-1e8d-08dc7f2b248d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWZtbHlhb2xJR1RabWFrR2pVazZBRmZPMFkzcExVeGVsYWcrRjRoWEUxc1pt?=
 =?utf-8?B?R1dMR002cWkrRWowRGNwaEFYazh6T2YzR2tKYVBOREFOdzFTLzdveXFzcWll?=
 =?utf-8?B?NTBiY3JoRXp1WCtTYitwQ1VrRit1TnNodFdCZXJWMzdyVzEvQlh0YThJMWNM?=
 =?utf-8?B?S2ZaWWhiZkU0dmovZ0hwVEhUS3BVN2dDSitKNTdEQ3pkNko1MU9rK3JmWHRa?=
 =?utf-8?B?R01SY0NpdjRXOVNOMDlzOURpV0lTRVJEQU93Z2FUYXd1SUlJZHBZUWRYVi84?=
 =?utf-8?B?NGlCeFBlR2JlQ1JnV1BpMm9BbjEzcmI4UjV0YVh4WEpFNGIrbVZ1djQ4RHNM?=
 =?utf-8?B?bC9Qd1B1QXBhLzNWN2JZYkhFUysyb3h1WTdLM2xvLzU2UkNma3JSZFN1NVVu?=
 =?utf-8?B?aTc3OU1EaTFmUUVNWEFhQXNnWGxXMlZvWmFJMGtIcmNvY0EwdDhsNU4weWtr?=
 =?utf-8?B?NkcvdmJtRXc2aWZERWlwOEdxSG9vM0ZtYVRBMkVzUmpBenIvNkVIeE5GSVFN?=
 =?utf-8?B?a05JSyt5a2lBeGhhaFU2QVYrUC9OTFB6aCtTOG9XZXp5LzNWRHJyRlhteFpV?=
 =?utf-8?B?c2Fvd05kSE9pZjgxUUlFYXNGaDM1cmY1c09jOVFzSzZNYWIvbGFZay9NVVRZ?=
 =?utf-8?B?SG44MmcvYnNkUXNFcE8rNEVBeTVCaEhRYkNwRjlUNTZueE9OanFzYnBqem9U?=
 =?utf-8?B?VHNhZWhMU1hSem0zNDBNcE94cTBteW9JakpkcWRTZENRNjFraUJQREM4bFhS?=
 =?utf-8?B?WWE3N1duSllzcXRLcmlVOTRXcXBicG5mVkdvNGNTSVN2Z1dOenkvM2JCRURS?=
 =?utf-8?B?bC9mNis0bzNRYnlaREFReml4VVZqRjVBdFhiS3gvMmZLRndNWnlLenVzbnhE?=
 =?utf-8?B?RXhMU0FBdEFDYzltWXljdW5OSzN1WDZndnloVHdSZy9NcFVyQzAvcDFDOThu?=
 =?utf-8?B?ZlpJUEJZV3RYRjIweWFSUmRCeTN1cHJKWkJYdUFzc2tVRlVKOHFVVFRjbTFR?=
 =?utf-8?B?UEdaaExGWFRLOVhWaUpra21TOVpzbllJL0pWSnVXaURFclZ5b2tlcFNZRXJD?=
 =?utf-8?B?L2NuZU5wM01mNFMzZk14QUZySVJ0R0FXbm84SkVnVWJ4WGF0bWFxK1hsenBw?=
 =?utf-8?B?VG94alVRNG9DeGN2MHpqbGljUW9aNko4ZzNlNVBVOC9tU3pXZTZCVVNIQmds?=
 =?utf-8?B?TnNoY1VRUUY2WXFFYW01ZkpjRXQxOUcwL3Q5bTVTTE1MVTY4UURpU2VSRzRN?=
 =?utf-8?B?Q3crTUtmR1VReDhJaENnTkdFbGxaZENzVEtzOXNCMHdGMWd6WnA4dzJZcncy?=
 =?utf-8?B?cDIwcEZ3aXhGa01FN2JPWXpOSEQyekM3VjI5WTZCUGZqbkRMMzFNQmxpUExr?=
 =?utf-8?B?UWNRcjIwMURIdFQ5V3BxMkpMb25GVjF6S2xrazJqL2V5cDg3a0VWOU9EV09Z?=
 =?utf-8?B?bXYzR0oxUmxYbDkreUFHVmMzTU9tRThDUkxTSjVJbEY4NFRmSzJoQ0YzOEs5?=
 =?utf-8?B?eFoyTjFIYzEzUnpqTmFsNmR5cS9UZzdmZ3ZzZ0R4R3F3a2VFaTlKMXFwMzdW?=
 =?utf-8?B?YVdoUUt0Q1N6bzlQeUlFL3FEQjFmbVFiRHZ2ZGk5eEtjejkvVmo0aTRtSTcw?=
 =?utf-8?B?alRQOVNUbU95aTgxaWoyUFozZ3NaMmg4TzRNY0dlSmhBNGx5aGxNSllGS2Y0?=
 =?utf-8?B?K1VMOFZ0S1ZIT0JEQThGdnI2aVFZNGlWVUZ3cnNIa0wrb3BIUTlzTytBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkJ6SzJoajB5aktMWld0eitwMG9kWHdQeml2bmxWTzdZbnArK09EeFNNSkFw?=
 =?utf-8?B?SHlRQWl5dEJqWnkyNFoyci9OcVRzZXJwQ1doSlN6eUhxQ0xDc2xyQ0RlK09G?=
 =?utf-8?B?MDJCdlk0cGw2K2FDQVRHUnZZYW9sdWg5Z09CM3h1T3ZVbzROYlR2Y1hDM3JL?=
 =?utf-8?B?c0FEd3ZWNEhnWGQ1UmZVRWxEVElSRnJOOTdpeVpvZHZzWFRucHh1UHBZMWpy?=
 =?utf-8?B?VjNVMGtEUHZSY0l4T0M3U2Yrbm5qVjcvY3g1M1M2SjBuaGk0K3RGOFE0S1J3?=
 =?utf-8?B?V2dJOUFHZ0d5SkowTTEwOXVrR0ZZbmtQaVZLVWF1TVlSUjZRVGd4REZtYlUy?=
 =?utf-8?B?YTIwd3NUMXYyMlV6NWFtZDQ2OEZRL2FreERmNnlPM1VBT3BzNUU5bzZaekdQ?=
 =?utf-8?B?K1cyWWQ4Q3luS1pSM0Fabjg4UHR1NEFweUQ3RkxTQXJFUDhORXhpdVd3OUNy?=
 =?utf-8?B?VXR1M01PSE93QXlwSWJBc09iUEZJR05tTVFhc0ladnlMSGxiZW5mWTh5clgz?=
 =?utf-8?B?V0huS2l4ZDVSQ1duWmY4cEhBcG9CSlIyY1VRSmUyakJBbUcxTnBrQ1pJZkhj?=
 =?utf-8?B?azd1Nitsai9NU3ZqYlVkcytNNjBwVjFsVFlRVkhRdUFucmV6bzhCREprdFdK?=
 =?utf-8?B?VEpVeS9OMWxmMGx2QnFRK0hXNUUycHpyRURyOWRWVnVFcm1oZ2d6bjN3YmlP?=
 =?utf-8?B?cXhmaW5NK3JXcUluRjNJWng1WkI4dW1YcVJ5NTlVREVGZjllTEhteDB6TmtJ?=
 =?utf-8?B?Sk1ISU5rR0dZakU5VExNRFlDY2ZzUlZuQlhzNVhqNXpCWjNFL0NVRnpnYzVw?=
 =?utf-8?B?Lzd0b1pNN20zNFVCY294V0dlVU9RUDBFckxkRGxZY2VSTjlLN1c4aDF1UjY4?=
 =?utf-8?B?V00ybDl2dUdLK3NUbGF3Z1gxelZJY1JmeDZKWEpBTEFGVHZtVUhneUM1VlJG?=
 =?utf-8?B?cVVDOTVXVUVUdTVEbjFjaUVqcGVsa3VUYk5VMklySTYwUUNqR05vQytMZ1Rw?=
 =?utf-8?B?MlJvMGlKSmpmSGtZLzRoYmx4M2l5dTVPTjlzUlJzMUVNU0hteHhpbDE3TUly?=
 =?utf-8?B?VFlVWFl5QXdXUEp4TzJyOVpZOW9WQWRGUFdTMGVHWVg4MkhEa0xtV0wvMlR5?=
 =?utf-8?B?N1B2WkRFMHVMYkRQTWZVZjRwb2QzZjBoY3U1Z2ltTTdWUkkvVDJ4L3FtV2lF?=
 =?utf-8?B?TmgydERGZlZxOUpyZlFmZDA0eTJ5YkNtdkVvT052NngyRkVWSVdCWERibmJR?=
 =?utf-8?B?cE5uRkZrdFRDbkdvSXBudDA4dE01Qk1YZkwvbVJEMUpPN080M3FiKzQ3dm1C?=
 =?utf-8?B?VVBYazF4cXB5STdWdWxmeXc2c0hYNG5HRWN4cWx6Y0VGUHZkUjV4MkU5OXhh?=
 =?utf-8?B?UTZZYUYxcFluN1FwTmpkdlhNakhpbEhIMSt3cW95c2phbU5iOTN5aDVBSVBV?=
 =?utf-8?B?bXhVMlQ5WlN5bndtTWE1VFQzTitKS1BaZUJLUEtIcUNTV0JxVEdyNjZCbHB6?=
 =?utf-8?B?RGpwU3ErYlRoclBQMi9FbitIVzEweUNSdlpyb2R4cGZzbG4yUU9Eckk5dks2?=
 =?utf-8?B?dkowZTBob2xFN243VUw0UWUxazdhSWszeXVUNnl4M0RBNFpyWlVoRnF3WUF4?=
 =?utf-8?B?WE5ncmVFVTlNY2VFa1JrMVJlaHVnS1VuTUhrdmhSUlFFclBCa1Exam96dG9t?=
 =?utf-8?B?QVNra3g4dTgvZ1BEd3ZhOWF6NTNJSW8reWx3VzZWSzJSUEJZRXFYQ3J2SExK?=
 =?utf-8?B?S3piZWFSNHVNN2ZhcTVIdkxLWG41QkNxbjd3TnIrMjd2bVo0SExna3RESTM4?=
 =?utf-8?B?UWFjZnVrcnRFNmxzSmtjK2RUc3hEOExyVHVsQ1FYL3ZKdUk0RGhsMUVmVmVZ?=
 =?utf-8?B?TDBhakZBYk5vU0ZYbFFTbnZ1cm5IU05FUHk5ZU1UcGNkZzRacHZ2YlVPYWxn?=
 =?utf-8?B?dDNDYy84enNGRTk5a1hSWUJJRCtzalpiQTJjWGlmMS96OTBwNitBd3plWTVQ?=
 =?utf-8?B?NzN5NW8vY3RUQ05tZC8xOEdSbDg3QkdicFY5WlNHNk9BRjJXeUZ0ZmdUMjZh?=
 =?utf-8?B?M056R1FMUFJROGxKNVlJanhpNjMvRjNtQkUyRFp4UW5VcUdrcUY5b0Foc1Nq?=
 =?utf-8?Q?mKZHOszSJHK+LrYSkr2EyTbIJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9d62fa-7324-4ba1-1e8d-08dc7f2b248d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 15:30:45.5169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uj8gQvJIDXR9G89rdi2pgumwvy6ID8hO5ecBdpzsfpkpq6biVyWrQenP8NODRS0X32LV7ZhujLdOexbsLEkVAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8749

On 5/27/24 10:26, Mario Limonciello wrote:
> Align the whitespace so that future messages will also be better
> aligned.
> 
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
