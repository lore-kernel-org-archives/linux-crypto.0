Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793288013;
	b=LlnyvMNmjr8kLwXl7Y8Zaw+VJBFIDcpXlJd8R7Gccolo5K6nqpRDJ5rjOefaPRCIhi1h
	 4XPKBrTtpyaCNDSvMFcLR1nzlRp4sB0OHX2Eer4gaXlQAT8JkENYAjicoK+7NVP60SkAc
	 2HnbNvYANRQQRhX/41vKhNTCqyRn05IbNB12+MmIbn7WosytA5p5gHwnhNb80dHpypfNC
	 6MYHtVp1PUdaxZ3cdsSr147nQKj2uWoyzyf9glbjZ/vpzYD1g1ZMgWwgf1r2282dPw/O3
	 t7gKlfW3T64vIo4OzwHrPH72+pOUm0/TTd/AdB53GJS5sRcGeuiRzVU3rwwuZQ6FbFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793288013;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=JjG+zp4lmBM2ynS4sA8trmdABzNwBT9TGM57029ZnpQ=;
	b=WZRojmAy74rqPLBITVcANnPtezTqBDLbqDK3IPQ7WyveYuexddVMyB6oI4Lzz/2t4UGQ
	 bC3jp6i0qAqYJYi99787G0oUcMgbdFVasvzz1yCNo3gJYbGcQJdtfEpflbP52XnOynKmi
	 c0KEi3ZU0/zkAs1kmr1W5Ma3405jmSeYqG0iL/FU26FkFjxQnA0eyfnLnXI+HFQvaR7p1
	 RRoV2kjF2rCZbykuTVL8bkzBsg4UcnGUlj6Kvvi0wDhPwSgmm7xf04yUuajXICbhwHPWa
	 fxw/MOZ3gY1Senp/4CRtjYG8QUkX19I1Zk/pBj5/odbkRc0rIfaUYRk758YP1Y7uLdQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=E0uQpz9Z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.7
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011007.outbound.protection.outlook.com [52.101.57.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C46606A31C;
	Thu, 29 Oct 2026 15:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77C46606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=E0uQpz9Z
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dt0/9PONiJN+JNI/rsR8I7Qsog0iuqhl7sl4n3TpfD5KUVXVxNfxWXt0gFurnUf9ViFWMUFHOedNCpV6RMEASv8z4LlyhP2vFeZETxG2U7m3d40qT4T1iBccl5jgMqCe/5XS6lwc8cOz00AW4FhYSy16OhKbc6nauYEO6m8vOlMRGOvQbgOkAbDJkTpSARy/apt947opIcbx2yzurYOD/+oMOjCoXpczBX5WzwZkADn+eYEd/uDMM6V05mk9AzhnSmnxKfznXUsHWnPy4lTmYrPIR2ELy1Ml7OG+UE4um95HmonGqzK1XHWMzpA6pV8YE3L35LrNgoVbjzxAVUsOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjG+zp4lmBM2ynS4sA8trmdABzNwBT9TGM57029ZnpQ=;
 b=qdx735pOD1WD01odK62EYWE+UEuGCqnJDQsiMTRiUEIdmd6ymcmBMc8mwa5cpZudtXXj6awXfd3F/AWBq8jBCUVskAvldNxM8BxoZfVwbZHonjTEghxwc54JwMIYKdScG54n0b6wqyzkpqn80O0HaJ8fZj7h0HfKX4xf4HTuL2pzKfFjfecHOA3uI5NOdZikPZyusf1UjRQ5n4eUirXyxLDx8Pwz3WrQX//Z7lSBloe3KlMfRuhr055yIsL6kX5doOm5JqlJ1fhEEb7QbZHAGNjXtOXTlPQp8J//j8FrscrUkLJ038pFDBcrMe0Df1km6XJDyaLApCZjyB4hE4Mlbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjG+zp4lmBM2ynS4sA8trmdABzNwBT9TGM57029ZnpQ=;
 b=E0uQpz9ZYFGAtxjfqwtKi90y80kb4JYew8iCpOiK3ek3huqpFPjAqL9BXtL/iTfWK9Hk4w7T2zrr1cNBph7pRmIbYLPdzfWcSWjJGXYHxiBznNtPND4UUXn9DoCXQGa7IQnaXwuVziEbJ0ZxSHztcQEi65ImmqYoOn8JA1R6Ktk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by CH3PR12MB9249.namprd12.prod.outlook.com (2603:10b6:610:1bc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 29 Oct
 2026 15:33:24 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0546.021; Thu, 29 Oct 2026
 15:33:24 +0000
Message-ID: <04a438a0-6c21-4ec9-848d-7dacb59c7f18@amd.com>
Date: Thu, 29 Oct 2026 10:33:10 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] x86/sev: Set up RMPOPT only on an active SNP host
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <331aeb2f29710865ec064bacf9edacaadde2b094.1793216372.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <331aeb2f29710865ec064bacf9edacaadde2b094.1793216372.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DSSP220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:3d3::13) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|CH3PR12MB9249:EE_
X-MS-Office365-Filtering-Correlation-Id: c9df8dc7-1fdc-4a26-d8d2-08df35d1f84c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|921020|261028144727099003|4143699003|261026140227099003|11063799006|56012099006|261009223027099003|261022105027099003|261021123027099003|261021121427099003|10067099003|261026121527099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	u/FYQazXzYj/fwyMIrcG4kxFud4dRXKvzlJy69wKnsFk8C8EXa3wAP2sjO1DxluDLm5hvI4Yvomb2kHp5QatOokVcmjGXLCIxoJUoH3TRt3o42l2dK4CpXBnmmYbM9WBLycl6cOWP7WARieud4keKfMtzx5YOTOj0yeg5KVyK+R/n1Zayce4mpV1Q7tuZtauQdzV5Zsh8FNGZd7Mn54IBsLN0JP+vj26QzHouoxI255KrY8sJ3YhL0IUGdZA+ugydd4Kssbc1CK1jY+iWf7gNxuKZwbkZ5SFgG/DLKEcO72Br93xQ2Oy6BET1eVKrgIwh4VIkChu3cs9O5T/zB4xfy8Gg7iAU873cYdjpOKxDVNRn8eY5ffpJmgOpWuLOD3Tj4uUgEQJshow0cw9BX/TINtdkXcl00C6lsM1KX0as38yKiI7YNDqnYksrC0c7QQAgowkLEfyF3n4LrOlv49/uIF8e1yTT1CbaFSh7qqlcQ5984s7GhLr0/RF6ikAOVTdsitBonRFqcz+Ury0dEUjmGe7VnG3Q7Wf0ioQjlLD0RRweKgSU8b8/0N76c/RwZK84xinGoZ/Uq/U7cWpQDylU+RhiwAWiGvw5UL5gmPqAO0LSYD/CUL8FqaiBOrNv+7WP7Nq1++Mfd1pCuouzIzFHC9pYUNNJIPL4PcjVW/Eau+sebjEH1mTCEFlS1zmHUCda8fsp5sy0kRMgvkg7s8sLQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(921020)(261028144727099003)(4143699003)(261026140227099003)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261021123027099003)(261021121427099003)(10067099003)(261026121527099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmVIaVBpNG51YWdveUJrMmxZZGVaSUZtMS91SU1Sd0Q4YThmUU1JZStVd3Zr?=
 =?utf-8?B?Ym4wbDZOK01qYTNPMlpRM2drMDREQlBDZWtPSU1GZEEzbmVCc3F3L3VCanZr?=
 =?utf-8?B?bHpFc1lmZnVva3NMaUtWWjg4ekc0Z0pZblovRDhEZlU2REY2aCsvQ2src0dm?=
 =?utf-8?B?UkllcXpPdG1QUmRhWnlPQ2NUS2E5TG8vcWVCUGhpUGtxanUyWHFyellPMi81?=
 =?utf-8?B?SVRKOFdtUzhTZDM4eE56TGpCRGsvcnZ6SE9QK3ZyK0lqVVlBWEhBZURMdVpQ?=
 =?utf-8?B?aTU5aWVMdXJhaWs5QjZpeW9ydGhkWWlvMXdYcjBvaUVGei9iRlBlUVdxODh4?=
 =?utf-8?B?QlpjcEpKZEF4c3hzU1EwT0hiUDdWRk9VTys2T0Y0UVVkRHlvVmszenM3OFVK?=
 =?utf-8?B?aEtkdUQxdVI1L3hXMDVzZFg3QTF3Z3h3RlJMQ0Y2S3lRTGE2YU04Uk1NcHlP?=
 =?utf-8?B?aWlaQ0JLNHd3eFRQVFhYOVRZb0k0OUZBa0d2QmVGWC84a2ppSFpFSzlHVUho?=
 =?utf-8?B?U2Nkb2N0UXVOSVlRTEZkUk1tcU9lY3d5S2dWYml5RFRzRk1iV0J0VUlUckNM?=
 =?utf-8?B?VzJvcFZVbk5vV3VwZGtJaDRRZmFPNG0wOHB5Zkt6bHc3UVR0d2huRzNMMUhL?=
 =?utf-8?B?WjhCSG5jSktyd2FHRDBDdmlSOGVrTVJ6bEJzWUlrckxhZmc0TStEdm5DRDlZ?=
 =?utf-8?B?bTZQa25XNGh1aUxhSmJpNnc2WWlmakhMQzNCbVIwVW5vMENYaUxMQWQxMTR5?=
 =?utf-8?B?WUo1bDhDbzVtdjJZRldVcnJsVDlkT0wrd0twZnhvVE5LUzNta2x2UHl6bWhr?=
 =?utf-8?B?NkhGdEdTM2xyS21xd1RwbWRoKzJzcDhLcHhsN21rS2x0V1MxZW1FRFJBQUpY?=
 =?utf-8?B?ZHR2NFFDSVFId090ZjVnU2dWUjlwK3RMYm9Ed3BFTEtERGlQM1NUcEliYmZw?=
 =?utf-8?B?R0NDYUk0SHFVUy9vbHBYQnA4dllYMmY3RVlqb1JGcjNtM1pNV2JSdDM0Mkdq?=
 =?utf-8?B?bjF1N0N0NXRwWXlHaHRZQkkrNFpJR3dTSk1rd1RYV3VXQlpNS044RHRYZ1pD?=
 =?utf-8?B?U0tOS3NXYWhiV0hJc09zMEZ6anNRWFZtbnFOczJGdnplYUVhNXM4bDU2OEFG?=
 =?utf-8?B?ZldlaVM4MVBhcnhEL1cxbHA5Mm9zN1BudkZpUXBTRjdnTGNPUGJ2aFNyZUFS?=
 =?utf-8?B?S0t6N2IrU1pQSHF0dk1jb1lOd3pXbDlTTWFWblVwT2FKblM0MnpCVjMrOUVW?=
 =?utf-8?B?VkNNZVZBcitkOXF2ZHlpZXBWN0JCT1FoNituemh6SmV4UGt5bldHZGtvUExm?=
 =?utf-8?B?ajlOUzQ0ZGVxTm5ESlhneUF5aElpL1FYeGY2Sm9Jc3I2ZWR5UmVLTU4rc2d5?=
 =?utf-8?B?YkRxc0lJekxaaUxRdldadloveFd1Lzd3WkhUL2xLbDZGeE1JVjFONUU1Qmli?=
 =?utf-8?B?RTE0bjl4U0JnTUpXd1lnRW5saXoxNnAvTGpxc0NkKzhPYVNQeWVSNWRtNjI4?=
 =?utf-8?B?cFVDODlTd2dlbjNUN1RpYUZYbGM1MHlCWW82N0J4RDN1M2FTVHZuN2FRWjZB?=
 =?utf-8?B?ak54emRnUElPbDNRRHVVWUxXMnZCTTZVeFYwVlFBUGZkU0pyNlBWLzdCMVgx?=
 =?utf-8?B?blYyYk5IaytBQ2M4WVNqdWlaK2VqNkJBZm96b2htVzcxeUFML1lpSWRzVXVh?=
 =?utf-8?B?VW9GYjlRY2t0SHFiRnpmMWJSZ09LbTNBeHZvU0RaYmNQSW53Yk9GRTB0Mnpv?=
 =?utf-8?B?dms0TSszK05YdjlBSWNINExvbVpHNzFFd1d6MlZxSHRQcElieTZiYUd6L05R?=
 =?utf-8?B?anFuUUJHZlJ1eGp1eFNPY0N6Z3EwRVdqSmNoc0EyRkl3cEdXSnl3ZXVObzMr?=
 =?utf-8?B?T04wS0ZYc3Q3cURSMWRXTjBKMVFuWU1hdTcwYXF1VzBuMFVpNTgxYUp0MFdW?=
 =?utf-8?B?NXNlRVVhRmtWL2FDSjk4eTRmMzV2L1pQTGV3bmdPWlRvMTQ1K0RKc3lYbDlJ?=
 =?utf-8?B?RTNoSWNVN0QxZXVJOTkrdTU1Mk4xM0pRUy9hNEI3eFlmWTJNd3pVT0o0cUti?=
 =?utf-8?B?bmVDcXphQ2lvcTEwMklxMnc3ZTU3Ym1lR2tBeGN3VTMxWjgrbHdFWFRabzJp?=
 =?utf-8?B?bHZyS2IyS2NqWmV0VHJDUGV5WHBMdlBhN25uRFJlb2NBM2I5VmJ5Nzc4Lytx?=
 =?utf-8?B?bnVMQmEzTmpiVmRWa3JOZGNDM1hrTWdpSmh3N1QybThTL1hOa0VSeUlPZmZQ?=
 =?utf-8?B?ZC9rUUQ2OTl0bTcxS0lVbnkwZU5PZzg2M1o4c2hqZ0JmT3VKK0Rna1Z5enlG?=
 =?utf-8?Q?zzeQWoHGRLH8wirBnw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9df8dc7-1fdc-4a26-d8d2-08df35d1f84c
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 15:33:24.2132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WdMCJrM6e7q8ZYBOFAn65m0Nh6tRyI5PJUU5JmPAKLYmU4qP3ceX0acjeK43C9uGdC75iDvEhWYp5cYWzBh5kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9249

On 10/28/26 14:49, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> rmpopt_init() allocates the RMPOPT workqueue and prints "RMPOPT
> optimizations enabled", gated only on X86_FEATURE_RMPOPT - a CPUID bit
> advertised independently of whether SNP is active.  As a device_initcall
> it runs on every system with that bit, so on a host where SNP is not
> enabled (disabled in the BIOS, or AMD IOMMU initialization fails to bring
> it up) the workqueue is allocated and the message is printed at boot even
> though RMPOPT is never used: snp_enable_rmpopt() bails out on a non-SNP
> host.
> 
> Rather than add an explicit SNP-host gate to the initcall, set RMPOPT up
> where the host SNP state is established.  Call rmpopt_init() from the tail
> of snp_rmptable_init(), which runs only once the host RMP table has been
> set up and CC_ATTR_HOST_SEV_SNP is guaranteed (it WARN_ON_ONCE()s
> otherwise), and drop the device_initcall.  rmpopt_init() keeps its
> original X86_FEATURE_RMPOPT-only gate and no longer needs a separate
> SNP-host check.
> 
> This is soft initialization only - the workqueue and the announcement; the
> actual RMPOPT_BASE programming is still done later by snp_enable_rmpopt(),
> which re-checks X86_FEATURE_RMPOPT, CC_ATTR_HOST_SEV_SNP and
> rmpopt_soft_init.  An rmpopt_init() failure is non-fatal to SNP and is
> intentionally ignored by snp_rmptable_init().
> 
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Fixes: c6c6f156d192 ("x86/sev: Perform RMP optimizations asynchronously")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/virt/svm/sev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index cd0412b9d251..39d3943cdc49 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -662,7 +662,6 @@ static int __init rmpopt_init(void)
>  
>  	return 0;
>  }
> -device_initcall(rmpopt_init);
>  
>  void snp_enable_rmpopt(void)
>  {
> @@ -726,6 +725,8 @@ int __init snp_rmptable_init(void)
>  	 */
>  	crash_kexec_post_notifiers = true;
>  
> +	rmpopt_init();
> +
>  	return 0;
>  }
>  

