Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013066.outbound.protection.outlook.com [40.93.201.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDF8336EE2;
	Fri,  5 Dec 2025 14:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764945086; cv=fail; b=CXlhm39VH8k1JT0rIcmepzGzkurKJIAeHmwZ76NnpIRmUcjtJExvzyk69LyN9+Jt3wtZyoNV8sbzzPZdw+Gt8F1B3R3XIaLcUHzJVj/TIK+JBXMe/kSuwl5Ua/ZezY7COkSYP/x/SAHCR3zEcyK+w7D3ctV/Q8ghYIS5T9kRi9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764945086; c=relaxed/simple;
	bh=wixZ7VVxxZOKnORAxosEkcMdVNXGoeGlk1Q3YVnMmZc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IvFENP4ZZahuv8pv5YN6O143sJJ3elLNKUs56QJN26AO3ctTmRASsVCFdwNZ9TIJZ72r5CFX4e4//hEMSX3P2H+eiuuRuTNKSPy7Ht8bIkAHbmdtt4EHoBN0Z+vf+A9NSWt6vpsQTpkfX9Vyw6SDVR7G6zyeFdKXlMh6wxastWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u5/41ob5; arc=fail smtp.client-ip=40.93.201.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u5/41ob5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AJi9FeDVv3LBHlUx4/2ViEQzmwPoDkPkQ7uCuQPeypLKXQ5WEOUAZor6q8tOSmDUPWJs3Yu9xU2JYzQbLMrZMArhbe5EXyrPS9LHPsKWzVZCczB1NP1LNZloWbVhmybAwazsf3T8f1nx6tWL+KpSLEkI/eei2r5j5KhRYEubGSIsJ7whKxiKbijbLhWnj2ciJBo5+MkRl/aTD4+M1heKA2Agen9tXHiR/L/4GuGVQiVo4tcoww8D0MzoA/8m2IME80wtOo1/d179a3yG5kNd6QZ35lsMlsM0Cta1ncBx29/8AedjD/0jFNm7/SP2gs6MPsbpPw+kSKlLhkl8R+imYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxqx60qoPqupuRiA1RCwYEaKdRZ/R3Ay9tM9zAaud9k=;
 b=AcDNuP3rnhl5g4wl06wBiqIVoGBFysX8RkQYxBkNcYxrXg9vVQQ9bk+SySPcEpDL9Ug/cB/7IiA3kIdB8RSf3kj7o0hM76R7t/bEguMEN13V49fgSUtoavxOBTnH+pYqrWEnsGAIHy5Q1FxC/w7gh60/J5GcMezBbvfMmf6rNWoPOGIxlgW170XePb9+vYfU3EylU3ZXmoybO5zbh+1VgFy5aln4zo+OQGYlD5onNHsztAW8p8ceU3MDi4LPRQ8e8kqkFuoSKVmdJushJzLrLzfuW4zJoPt/QKlICUzv+CjSz6baLgOBtqu0yzqDu4CV8Qp5bB/tGlJmm6rSwkFoBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxqx60qoPqupuRiA1RCwYEaKdRZ/R3Ay9tM9zAaud9k=;
 b=u5/41ob5Bq5qCc+e2k3kGutifEbqMUqpyFQGp1rvR71Pl415OuQthC8RtWRI2NdMj4LRoncS9109Sntar4wMpv9yKy+3DuNlWly6vFjmiJ1W8QeOY4Iaop6lruWapC9zIw/f8JUJTYBs3PbASrBzLyllGnChd+Z3LNyM2VMbKak=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB6006.namprd12.prod.outlook.com (2603:10b6:8:7d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Fri, 5 Dec
 2025 14:31:17 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9388.011; Fri, 5 Dec 2025
 14:31:15 +0000
Message-ID: <3f1ec220-cb9b-49f6-a703-e92e4abb5f7f@amd.com>
Date: Fri, 5 Dec 2025 08:31:13 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto/ccp: Fix CONFIG_PCI=n build
To: Dan Williams <dan.j.williams@intel.com>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kernel test robot <lkp@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 John Allen <john.allen@amd.com>
References: <20251203031948.2471431-1-dan.j.williams@intel.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20251203031948.2471431-1-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR21CA0001.namprd21.prod.outlook.com
 (2603:10b6:5:174::11) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB6006:EE_
X-MS-Office365-Filtering-Correlation-Id: ce185981-5014-41b6-058b-08de340af229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zk9kcTNkM2c3UWFROEhlWUpsdlVRNitpenJQb3huakdQaG1QOXVoWVpMS0pU?=
 =?utf-8?B?dmZ1U1lvTHlPR1JIaWdQajlPSElJZDNRQ3ZUTm1ucVlRV3B5a2NvZi9GdWlD?=
 =?utf-8?B?V1UzNitHcUdTSTZ1Mlg3b1RvQVVEb0dvMys5cEZNU2ZteXI4MHpCelEvNm9k?=
 =?utf-8?B?bmw0TVBwbE1iZ3JXYmJkMGFLRXEzVTdjcmJpR2t4eVp5Q0Y3YTZHNDJjODJG?=
 =?utf-8?B?MXlHa1Q5OEp5QVNJMXhXdU1lQWdtMG82TTlwdlB3UGt3TC9DNVFaOVB5MEpX?=
 =?utf-8?B?Ri9KT1kzWUJ3UTVlN0Y2S3FQRGFXQXdZRjExdndhYlNKRGRBeTllQ3I5dHhF?=
 =?utf-8?B?M0gxdjVqN1pveVZRY2JRYTArSUkwaFZ0TUdCZUExREFwMmlhSWlPVWtqQndi?=
 =?utf-8?B?enVpdWFJeWJtMTJiOHdQNDZiK1pNZGg2UCtvZ2FEdW9FMUpqL3lub1Y5RGhP?=
 =?utf-8?B?VWtoNkZpSzZmZ0VQcDllbWhwMWhLWG5FdHhGNU5PRHZqUVhLbDNBQWpXcFZJ?=
 =?utf-8?B?dm5kbVlqQ0N6K1l1dTFaSTFaWFFBa3dnSUg1VDRlTzNmNzQ0eXcxaytvVjUy?=
 =?utf-8?B?bFJOWlNZdHJybUFlZ0ZRM1o5UjN5Q0RUZnliNHJLbWNud2NJUzFwYlVqT3pD?=
 =?utf-8?B?ajQ4V1E5VXdMVThNMHIvOCtWSm9FbTRnOC9WZ2w1czVyd3BxQVhZT2FnWjMv?=
 =?utf-8?B?RUFMQ05ORXMyQm53d3grVDNFek5UVy93RzBZNmVuVkl6L3p5NEROeTN5MHJH?=
 =?utf-8?B?ckZyNURMVkJDdzUvN0dSa0oxcWxzS1cxNVFYQVZWVWd0Sm5URUZGMnQxNTdq?=
 =?utf-8?B?QzljTFVieFBDRzRZYTVtNThVM0s1bGJRaXQyVDR6VlhqRXZXSm1lZklWYlpC?=
 =?utf-8?B?TTYxeDZEdXY5UU05Y2NQUzVneWQwOFBSdzlSUzRhZzJhVXQ5c1E1eW12bFMy?=
 =?utf-8?B?Zkc4ZUJJMTRzUHlRT1VnMmNybng5ai9pY0ZidjdvQjJNQzFHblptVmxscHRu?=
 =?utf-8?B?OTg0S0w1RWd0aFNpdjdDcjdiYmgvbnVXMzFpNHZjTDI4a0FVL3lLanVGSEY5?=
 =?utf-8?B?a3VpejZPSEVPUTRpRnhqZ0pBOXFRYjc3blRxUWdvamdWV2xRSUFRRVIwR0Jl?=
 =?utf-8?B?TmRELyt5dVc5ZmJvanlYWnR0cG1WQlFNS29lVk9yNFpSL2VYa1JnNTFLZGlo?=
 =?utf-8?B?c0dQMjdyZnplY29waExQMVVIT3RUUzZadHVycXZLM20wUVZoaUZtbVcyVFp2?=
 =?utf-8?B?OHBXMmhBQzNYclJkYXAwTVovZkVWcUNQNUhiQUFFLzd3ZnNBODdEZkVVcEky?=
 =?utf-8?B?UEN1K2xDcnQxOHZ5UUg1TGZxL1pZL2k3cDBmNDlkVkl1VkcwQ05QSmV5VVlu?=
 =?utf-8?B?Zzh3bWlhZ3p0OFVtNWhvOVJIbFBzem0vNXRQZk1KNGl3N2xVblJVMHlaZkFj?=
 =?utf-8?B?eEYyT0Rmazd5eUl0TXFaKzdNcFJNaXgweTFIaGhHUU5EWk9RQ2NsQ0pySWxV?=
 =?utf-8?B?UWNPOXhPQjliTndUQmFEeU1mR2h6bkpKQ1Y4dXNQZVplT1VXc2FtQnpXRkhT?=
 =?utf-8?B?b3hlOE4wTnFqcGRZRkpyK2dSam5pSXFJY1U2bWpXVEpWNkNxMGZ5bFM0cmNz?=
 =?utf-8?B?NkRTQ3JPNEc3bEZJR2gyQzIxQUpEeDRqYzVlcnFUYWFwYW5PYklhTmxIeHJr?=
 =?utf-8?B?R2E3ODJhUlBTblVIQ1VQNGxkWE5jZHVJOWRXUCtTK3ArNkExT29NaEpySEJm?=
 =?utf-8?B?dzdvYmttd250VFgvVmoxWFRyaEdrcThLWmZyVm1yQSsvZUcwT2k3MS9ZNUtH?=
 =?utf-8?B?ZzhCMzROQjM0T3NBeTBaSkI4bDBxSFNvV2dYMTBmOEZIa2FLbTlDaUlhYjVs?=
 =?utf-8?B?cFIyNHM3WW90M3hqSFJVcEppL1RrTm9uVzRkQnd6QkNCbXRKdmY0R0F0Rmg1?=
 =?utf-8?B?cytiVnl0QUNCdGMyejJ3VjNyZXlwVXdpeFF3OVJHUEp0WUdCdUhiTFFQalR2?=
 =?utf-8?B?azVLbUQ0SzhRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YS9OeWtRNVN3R29aZ2lucVZFWGt0WXFTSGRSMkpRaStmcllJaENRQ0hJM280?=
 =?utf-8?B?QTFOdExXM3NENGV4M1ovS205dWVqMFc4LzVMRW15eHY0SEkrUUFwQnljanNU?=
 =?utf-8?B?NjJvVXgybG5od2xRZFZDcktOVHVJMUc1TFhXOGtkTkNqY0s5aXJuN3BoUE9I?=
 =?utf-8?B?RFk4dFk3blFuWGpac2V4b0lpYiszdWhsL2tJdUdGeVU3SzFVSHB1UWxYRXNC?=
 =?utf-8?B?M1doTm03NDlZR0drdHY2L0ZGMmoybldrbmd2a3NjY3Brd2lzRllWakZ4bU9p?=
 =?utf-8?B?Z25UempOckZHWk1ja1dOajBmMUYzbXhybG4zeitQWThyUlVpc1NCRG5YS1JT?=
 =?utf-8?B?SGpwbGdmWENEWEtVRVNUeUNvUmxLM0VHNkhlVDBObmlaNEJmcXdMNGJUS2pX?=
 =?utf-8?B?N2RsSUtYZGhsd2pIaHNuMk1vWG1kTi82ZjhxR2Z3UWNUSU5VVGY3bFVmT2hz?=
 =?utf-8?B?OFcwUVVpbFJWZEl4M1JXU3JGbHhsVGNqSHNvbjVYbWJDMmpFMG95Zi9hREFs?=
 =?utf-8?B?eVFid1ozMzJrUmJmMUFnK0ZGL1JSbm8yRE16ajlwelFocU5uRituS1dKUEdT?=
 =?utf-8?B?YUF1U2gxb0k3YXgvdnl5RnhSckdhQW84UTFzeHBISDVLUG5wT0daWVQ1RTlS?=
 =?utf-8?B?SmdSaE9SMlM1RCs4SkxMNEdnYTg0OGNBaURMNXNWVDNrSVpWM3N3QVF6M2hq?=
 =?utf-8?B?MWdrQ1QwSWVpT1U2a3Y2NEZzRWM1MWJhWE5nN0VZQVRkYnQ0Zm1FR2hFWXZ1?=
 =?utf-8?B?MEZ4Smd6NTJXazhZZFJxRGs4d3RMQk54TEJLYnRNUVJkb0N6cFZXTGVlNmox?=
 =?utf-8?B?Y0dUVCtCcjFUNSsyT2lqQlJraFVpdXF5a0I0QS9tbW96bnRDSmszeVluUTNL?=
 =?utf-8?B?eDBLZE90bnVyVjl4OGxqYkR4RVZCcW5XYnRpRnZQY0xSUDhMNUU2M2VycmVm?=
 =?utf-8?B?OEtmblArU0g4QWFTR09hNGNjUWh3U3RpanlFa3ExVHdoODNqSkFCRnY1em41?=
 =?utf-8?B?dEJmS3A4L3dCY3VWZlNhbWdEcW01VmZrRWVtQWM5cWx0YndKWENNN2IzZ0Yy?=
 =?utf-8?B?V3RZN2NjS2NDODJzcER6eCtkNTRYUXNMaHB1NEd0aTd6eVBXdkRKd1VkS3Nn?=
 =?utf-8?B?a044VVpGOEF0WUYvWEdmWG83ZFhiUzBRRkxkc3d6azZKRXcxaXFQdUxHWVh0?=
 =?utf-8?B?WjNGclBsOUpIRVJNODBpZkY4SHgwOXJIME1lY3lIUnpHbDJqc3Rxd29pVkdC?=
 =?utf-8?B?SWJ6b2hZNUdZV3paUGdYS3hNaFRnVWdsQ0xrdkVTakhRVm9SeTJaQ1Rya2dx?=
 =?utf-8?B?cHhiZFl0cjRIVGk3dnkrWEdiVDJxdGpKWnpldGJNMGd4N1ZXd2ZoUlNHaCtJ?=
 =?utf-8?B?WWRnOVROOC9xTzJZd2ZJWFg0WlYxOUVxcE1sVkpaeXI2WjBneTlHeWs0dUlR?=
 =?utf-8?B?V05GNWRCU3dWd3ZOMUhIK081aHppUlRSUHhzM1pka1VPbklGSHdPMUZ4eWpT?=
 =?utf-8?B?UURXb0RpZ0MybHlGbnIwOWNsQlJxWlI2WnNRRXJIZ3pjTklaS0d2aWdQZEpa?=
 =?utf-8?B?UmdGUG42RXdTZHFkbXZvcTNOeVl2STFlalkwNEdYVGlBME5vUmtQMlhyV200?=
 =?utf-8?B?a05mMmkxVTBPSTNQTDc2YTBDVmxFRHhPSDJhaFpzdklxZkRQMXk2RmF2VG5Y?=
 =?utf-8?B?OTZVazJkd0UrVjlqaVRVaU5iM01nNURFWHVrb3Q5RXRkcFlLTjZ4UWhBOUZH?=
 =?utf-8?B?WlB5OFVNZUJPd1oyVVByYnF2cnc0Q3R4NlhQUlhRKy9KenZUTGdGK1VtS2NS?=
 =?utf-8?B?dlpadHA5c0d3bHRTRElTNzRuZnVpajR5MXlqZGF6R1p3NTB0c0xITmFGK3h3?=
 =?utf-8?B?d1NvMUU0WStDT0ozVjloeEJsVWFzeHo1SDhCOU52a3ZRMDZtL3Nvei9DL1JB?=
 =?utf-8?B?bWZkN29OZ0ZBaUZCNDI2cnJETzdkVHNiOVBFR1d6WkkzTkM1NGovRHo0Z3hH?=
 =?utf-8?B?Y0Exc0lkS1g3Ynh2VXJjQ3VkM2VHK2tqWnR5Q1ZKeDNWNDgzRDJzN0RTSlZO?=
 =?utf-8?B?eUd0N2hkTUZuTGNFb3VjNFY5UDdndmswNHppTlhzeldoRjlRRUx4YWRUejdJ?=
 =?utf-8?Q?vLnH5LYR9YZ3iFz6SLa0WQgl3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce185981-5014-41b6-058b-08de340af229
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 14:31:15.2717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7el0PhSMoWFfgMr25mzNQobVK6S44mBEXKN3rR4in4FEjtaPuVOiTNsDD5EnjLhK2Qh49r2Qv5U+u74wfFxS6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6006

On 12/2/25 21:19, Dan Williams wrote:
> It turns out that the PCI driver for ccp is unconditionally built into the
> kernel in the CONFIG_PCI=y case. This means that the new SEV-TIO support
> needs an explicit dependency on PCI to avoid build errors when
> CONFIG_CRYPTO_DEV_SP_PSP=y and CONFIG_PCI=n.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: http://lore.kernel.org/202512030743.6pVPA4sx-lkp@intel.com
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: John Allen <john.allen@amd.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index e2b127f0986b..f16a0f611317 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -39,7 +39,7 @@ config CRYPTO_DEV_SP_PSP
>  	bool "Platform Security Processor (PSP) device"
>  	default y
>  	depends on CRYPTO_DEV_CCP_DD && X86_64 && AMD_IOMMU
> -	select PCI_TSM
> +	select PCI_TSM if PCI
>  	help
>  	 Provide support for the AMD Platform Security Processor (PSP).
>  	 The PSP is a dedicated processor that provides support for key
> 
> base-commit: f7ae6d4ec6520a901787cbab273983e96d8516da
> prerequisite-patch-id: 085ed7fc143cfcfd0418527cfad03db88d4b64ec
> prerequisite-patch-id: c1d1a6d802b3b4bfffb9f45fc5ac6a9a1b5e361d
> prerequisite-patch-id: 44c6ea6fb683418ae67ff3efdb0c07fda013e6b2
> prerequisite-patch-id: 407daf59d54ecebcb7fefd22a5b5833e03c038e4

