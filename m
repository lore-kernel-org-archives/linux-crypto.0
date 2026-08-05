Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012052.outbound.protection.outlook.com [52.101.48.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4CA34FF78;
	Wed,  5 Aug 2026 21:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785963867; cv=fail; b=WBU/e6+yVqvApb6WDGPpCpYpXmbBXVE3buaUSMRNsGXKHGYFthwmxoUxIh4NwE9BKox8bmX5OQbsHAvl2yuSfhGCz1Jy9vd7uPgEKQcuRE6KnGJSLU8PZzK9usAf1BrhNle3sFJaLnCAZkfNHXqT5x5KECAdHo12z/wZbn3dzTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785963867; c=relaxed/simple;
	bh=39QpHtQrQ6uyFZmzpDvBkTYw+aaQt9KOKaFUaW5Y6Ek=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KwGAJVowk3eV67sJ3OU92TgFaR6iyd4q97DNSK4qUtaI3ya4sfOxViq5ThDaShoZ4bYRmrIBirIAwKduYO8JNJ5xOHa74pOMOM4IY3uj2qTVN5ls8EamnaEBwTjjzUziBiqz4OkmoGIDILKGIGUDqlLqCz5EDhTy7N+BsUK3lag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=phfSEWhk; arc=fail smtp.client-ip=52.101.48.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="phfSEWhk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpbcfo4HZaMC8q6PwwTyBmnYbDNN2KdOeJQUB09fqRiqg/yEIA94apdfkRke0XbpMovJP+JNCVzTQxtCvlJjmuGz2/Z7C+O9XnNxjRsMF5M/ojfHc5tnD7e2tY5KPBztc6K4ZvoljWOOp2HDtpVWGwLMAOXiX01YpMj798svlUnNh+Q3vY571nb2gmwcSBY0EHI5pgqs7ljo46Ds7Yp1B0QuBU9Fl2ePCnmGrg1yfoeYNwUGlbI/xDa//Gqhfko0wniqvLBUL0RYnJ57G0dqD6CEQf0dYpdz2o87KsaSyrDhsxvG0dNZgiWPKAxHwgwBRUhwyPXULdGkFCtaivHqag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/EuI1Jy6wx3AZ67YgALlklRTilNZyj4kHJrFJCzAhM=;
 b=m+ugvdXN+8b9ZdIUmv0IJC1kiPIl6gGApmnjtoyb9CeBQMoKA6MUxV4pJc96KPFYUUcjQDIoOIULDii6nK+wEXQP3AkmFLsrDSf3piZV6DNpJrOqbuHEQoDHsx2y0rnx9Bafq8KXAwt8Lijx/66gHnf+xN2QS0eCCZMHWzPAx0Zax/Pe1uiXzMf8+VkgDwKI1CpZ229AZ3bBCSxk7GuKJgUB7jYcbCkx4tNDleTMZy01rQfrMdOnxbXieHF7M56WeFbIEauI91zV3HVVVBc7pSLd+7zd+mqJ3b3tT2Fc81/B5kmn5DqGBxtUULqhEXjSgYi5TEao5mor5tBe6IUtpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/EuI1Jy6wx3AZ67YgALlklRTilNZyj4kHJrFJCzAhM=;
 b=phfSEWhk8g9ltJTmJLuCY1QWZFEjWvuEt1mxVY2QAt2VGMLNXyWbA2FdEl/PAGf94dRZqGILoWF+gx1Es8ke9L4xEwkBIeYGrJKeHCPCBwEoRYCfEYuY5MRYvXvQLfMEOvp01/g+k4zPmc4ENN5fDuUUivzrAnd66CGbSypOHbY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by DS1PR12MB999188.namprd12.prod.outlook.com (2603:10b6:8:495::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 21:04:23 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%6]) with mapi id 15.21.0270.016; Wed, 5 Aug 2026
 21:04:22 +0000
Message-ID: <9a54ea1c-73bd-469b-9f87-906fa269029c@amd.com>
Date: Wed, 5 Aug 2026 16:04:15 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com>
 <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base>
 <df5f5f6f-7278-42e7-bc7d-8e56187d1438@amd.com>
 <8DAAEA48-F2FA-4D52-8E56-4B7213155F12@alien8.de>
 <d7a17bde-4af0-45ad-96bc-4717a1fa1545@amd.com>
 <60B4B369-19E7-44DF-BCCF-FC8DD851B2E7@alien8.de>
 <59e8b0cf-0ab0-4b7a-9e05-4de6f83c9a10@amd.com>
 <20260805004913.GBanKIiW-O3pDjIqjH@fat_crate.local>
 <63867f3f-a7a3-4d6e-83b4-0683688512e9@amd.com>
 <20260805192837.GAanOO5SU78CzNgblB@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260805192837.GAanOO5SU78CzNgblB@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0306.namprd03.prod.outlook.com
 (2603:10b6:610:118::35) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|DS1PR12MB999188:EE_
X-MS-Office365-Filtering-Correlation-Id: 31d6bd02-030e-4600-58e8-08def3351ee0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|6133799003|10067099003|5023799004|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	94JfqJmJxhKacs4r3JYZgpZSHMW3PCgym1Ea82GoGWOrNd480L5Pxw7mYAYb1li3GWQjYaB5RpUSe1hGjNAvNDgWcyvpsVpMt7VWI+P+Zm1NRnOqVUgA8sjDSBXUXU3juPMtxgc035+eHSnxUn1cNLW7z75rxStssC2J7lT5JHGs0wVDNo4za8qYmCmEQ6I8WcoPyrfSK44o1gFmQR5eiwQuLxZnmA/S0QujAtGsK17gCv8AjkJXqNKGoofhGeocq7HASpO6/IBNFGlChrjDDjm2hOZvWN/7AZRM6JwV+mwjE+I8fzyYg+NCcfyUu7nV4foJfwHp8S9xZII9IezRbA1SpSNzptk9gndPeoQLUIrleNHs2p868iVCiVpuQPrhFaa6fzX+dKyLDiemYp7Tk6Z8sZTEw+3W8xVlYIjtPwmFJ1g8wRdky6YSJVNWdvt0PIIllyEqOJlHQzdj6xVL4deBJuRVhEayg5J6QjRsGRJOkywg0NOrQhXcJ+NyY3Gvrf8CsIq9Vi1KeFM61/6Wku6R+zE//LDtqAdryw/VMsPufx7HIewwGEragSQU6lPhlIWmPwu42VFAkpXE2C6YtwIpRHtkILyxBfJU8LmGgNxlyu7UHSv8ZVTZI08zCoUMDO55Uh1d/zLrfxgzj/aKW04q+sQPjAUPJnldiSZCgO4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(5023799004)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U255TG1EenRCcHl5R2lCZ2VxRFg2eEpBRStQQjZVR3U0NW1jQjA2QmtHL1FX?=
 =?utf-8?B?SGJFZ0RLdXZJekVSelJsK0Q1RXdvN0JOQ1VVRzArU3RlcUErYU13eVg5cXNN?=
 =?utf-8?B?RlA1YlR2dGlUUFIzSHFsa2NUaHhPTlE1Q2ZRZktBdlJCcEltMzlBRERMV2tt?=
 =?utf-8?B?Zzh6UXZyamNld2ZZZWVWK2hIeThEcWk4cUJudnlJd2JSd1h0TlNxS3A1WFBO?=
 =?utf-8?B?MzF5akpySy81TWhkam5DY3I5VUZ0eUJYenFNMVpOWUk4TzFpU1NHYXBKWmU5?=
 =?utf-8?B?L2g1emQ1UDlNQXBCRDVzS1RveHV4TFBjUTRuMjZ6dElDWGVNZTJJY0FXeHVE?=
 =?utf-8?B?UmVxSDZsUW81Yjdzdml3Z0M3Rm1zelkxR1JGdVpjRnltTzRIblMrUXZqQjR3?=
 =?utf-8?B?cFhCM1BRcVVDdFcrMFNCc1FqWVFVQnplSzROZFR1dG9QV0hiNGxJajZXcXNk?=
 =?utf-8?B?eHoydUltWG42bm9GVFpVeUJKSy9YbmxBZnhmRlVnd3J1d3V4ZDFxMUF0cHZU?=
 =?utf-8?B?dktNMkUzVzFVNkROYi9VaGxrcnBxYkZqbnV0L0pGeHVQV2FtcUFCcWZaNnZa?=
 =?utf-8?B?bnNrOWcraDBoYmE3UUM5a3pXK1ZCMU5hZFNYNnV5WVBDejdHUmM1ZmEvUUFN?=
 =?utf-8?B?ODY2UEJhd3BlU2JIcUJYZEtLZmJKZjArTXQ2aHVuVThzNmV2Y1cvZk1QNEVT?=
 =?utf-8?B?eVYvNHZBNEtEbEs1Z3huL3BzSlBpa3VRZC9NaHdHWnRwNTNrOTluanV2UjEw?=
 =?utf-8?B?c2dWOVhuTCtPT1p6N002eWVtUWFSWXllZzFzM2NENHJxVERvaVRtTG1vYTVU?=
 =?utf-8?B?M29uc2k3ZTd1LzZYOGRSL0RycTR6Q09NSkhSZjVDelorbGlBSW1RRWZNMnk5?=
 =?utf-8?B?MjJ4ZFovK2dLMW85bGZXYXZyWFZQU00xMEsvWkxTN0NnNDY2OWtGU3AxYTR4?=
 =?utf-8?B?L0YvdmFUcjM1K1hhZ1pCRXl2aldrWVhpaVNzSnpJZDZKZDB5d2ovS1lOL0FM?=
 =?utf-8?B?RWZsenczUUtMWDR4UEM2MGJTZVlMK1ozQjZWTGVYbkw2bExhVGVPSjErRTNN?=
 =?utf-8?B?cTlmamx2OWZQYyszTmNnek9OYTlXSVkvSnFoSEJZL2dGUmpUZTE2ODNCblNh?=
 =?utf-8?B?ZWF0MWs4OVVLemZrdnhyZHBlNlFzcldlcS9adkJCUlpJaTRnK2VTZlJsRktS?=
 =?utf-8?B?TjM5cHBaVFA2YTZkenJVU2s5TWE1SFlyejU2c1JSL0xPWTlhZ0t6T0E2c0tx?=
 =?utf-8?B?UmtEZmQ2cGFJVHhrOWEyQjE1czl5TiswczB3V0hKUk1aU1NLUjl3TDZKYkpZ?=
 =?utf-8?B?UXU0dnRtMkMyN1J0NldhM2pLSWFqdjNtSVd4NzdGOXRpdWl0eGlSQkZ2Y0hM?=
 =?utf-8?B?d0Y5Z0RuVjJLTHFQL0JuOFlwRHZBTmp3dWJtOE5NTDkwYUxKU3JhZ0s1YkhZ?=
 =?utf-8?B?V0VYSlVzUUJweDk5UlhLTTdWWk5QRDE2SDdRTlh4Vno4RnZOVFVpZzg4UHk0?=
 =?utf-8?B?VmRGV1J4LzB0dE1RTy9nNE0vT1ZjUG52RE9DeXZYdkQyRjZQQVc5MFVkTGpx?=
 =?utf-8?B?TzdpeFd2Q0RJTzU4c1hJRTdVRWswTHBMUXlBZjlkUmdSUnljbkxNSUpZT2Ny?=
 =?utf-8?B?OGF0eENXQlg5OHhjWHF6T0Yzb1JKSGVTUnoxcWxFTjRvUGx4K1kxUjdDN1VJ?=
 =?utf-8?B?eGlPVTljRnhsc2NtMnhESVFBK01HYmlQdW5DV2lIYlpVR29kYk9saFBsL0JD?=
 =?utf-8?B?VzY3eStuNVFaRmlIOFRzWGhyeGlQR0JEMHo4T3hmZHdnRHA5K2tvMUY4OHF3?=
 =?utf-8?B?VnRheG4ra2dEd3JuMGZoQzhacy94cWhEOGZDSGFnNzhQZXVvU0ZGRFZFcnBX?=
 =?utf-8?B?ZTh4dUZaa0VRNkRmSUYxalJWcDFqdGlHeGtyRnFoZzFPWVBCVE5zekRmcXRh?=
 =?utf-8?B?UFBLeVdiZDZoY2NaKzdqdEloVFhFVzlzbS83SEhiZmc4NFpBZFlJMGltQzBC?=
 =?utf-8?B?TXJQTWtVSWFxSGx4YTQwbGJOMjZ4MDNFVlJFdGFYQi9XSGl5OW5iUTcrOEc1?=
 =?utf-8?B?cFBBZVdoSGhOOUcrSC9NLzZjNzAwbzBBTWdCdkQ5L3hnMkpwZGVEWWJvY0lU?=
 =?utf-8?B?OXRyYkhkU0FjQXJweWIvK21ad3BxUVY3UG5FZ25rRGNnbk05NEszVjRMcGJx?=
 =?utf-8?B?K25wS1VQbmNhcnQ5enNxUGpUSkhVVkdoMGNwL011WHBBa3AyTExTRWlWY3hP?=
 =?utf-8?B?ZXc1WE1xUlhGdG91VUtsOFJTYlhsYWtTUFVRb0lHM1ZITkoyRzhnd3k0bHFv?=
 =?utf-8?Q?wwYlm0P+YEVQTeUAH6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d6bd02-030e-4600-58e8-08def3351ee0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 21:04:22.4310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rw1/8g2tgGiK9TmLZ+mKz+Gzx7lRKbAFPoFX/dso13FbPnQ5ixdWoVMjnXNOfBeJg44Tx5iRy/tXRStN0OpbjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR12MB999188


On 8/5/2026 2:28 PM, Borislav Petkov wrote:
> On Tue, Aug 04, 2026 at 09:38:05PM -0500, Kalra, Ashish wrote:
>> - Under churn (many SNP guests terminating and respawning), an hourly scan
>> is too coarse — freed regions would sit un-optimized for up to an hour. The
>> teardown trigger re-optimizes right after each burst of terminations
>> (batched by the timeout), so it's more responsive than a periodic scan
>> exactly when there's the most optimization work to do.
> 
> Yes.
> 
>> - When no SNP guests run, a periodic scan achieves nothing: the initial pass
>> already optimized all of memory and nothing has changed, so it just re-scans
>> physmem for zero benefit.
> 
> Well, no. You won't even run that when there are no SNP guests present.
> 
>> So the event-driven approach self-scales with real work — it runs as often
>> as memory is actually freed and not at all when the system is idle — whereas
>> a fixed timer is both too slow under load and pure overhead when idle. The
>> mid-life contiguous-1 GB case is then caught precisely by the 1 GB-hugetlb
>> page-cleanup hook when that lands, rather than by a coarse sweep.
> 
> I wanted to have this in case pages do get freed up from time to time and you
> get some sort of a fragmentation. But I'm being told that we don't support
> balooning yet, neither memory hotplug and when the pages get freed, they
> remain guest-owned. So yes, the points in time where those page become
> HV-owned and potentially freed, then we should optimize.
> 
> Please hold down that in the commit message so that it is clear for future
> readers why we did it this way.
> 

Will do — I have updated the patch 6 commit message to spell out why re-optimization is tied to guest teardown: SNP guests don't
support ballooning or memory hotplug yet, so pages freed during a guest's lifetime stay guest-owned, and teardown is the only
point where memory returns to hypervisor ownership and becomes eligible for re-optimization. That will be in the next revision.

Thanks,
Ashish
