Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491371C84B8;
	Sat,  6 Sep 2025 21:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757193322; cv=fail; b=sIZUC6o05Au5rIwt8FObFwuklulZPMK7N1vIZgfRLyhSVzuxVmJJwWg25tWuem5KMVsrShG8Jz6Y6L7jidDTIV0OJohOSPjLO/lfNKvZBzNd5eqsIX8lXwUZM8+Rs4hCqE9kKhh+FvAU/tpUKDEOOXwQlpKZ0VVdovhU5KzWfHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757193322; c=relaxed/simple;
	bh=/+hU1vQqMyNS7rzaaE70Lhg7amuDE8rEuevARfAZYCE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vm8b627ffdtUd/ZBO7U5bxR68SsScJbFYV+QwunxPt4LFjUZ/alLJVz2D1hxH3j1h2ME+kx3Q81Fe0eIZThKolqAsITyfwLGciJYV0LrvAxtXJZ+vk96+/tSV+ymn7niJD7F6c048rvBWXjr57pF903hLn2V/37gKbI927vuJSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cvIjP05w; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cvIjP05w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+TGAlMvjZLaVdX92c73Ekw8+BvI5cSgpuJ2vLltIifcmmHj2RKaqxC4lyM0ww3fCRLmsq1r7vxuySg8lAfmEy0TyQQkUtpnrwVwNuYu6A1KmDA+9yN1JtK9149Pz6IGuixg509pe2y5dh5+A2hvgjr8aC72OgEEVz2AfEUW6UWHmnupsn1MRkI95taluRiwf9VXe6yXFh+QQ9q7c4VvNEKQyA/7VjQ3u90hxvWMiZNh1oYs7qYPam3DlU7E6H/imX0e8AqJWi56UZ6b8WbeffM20inVje2Z4QMrHhck/aMZN+4X7PtvvbbXz2HlyRVFRexWvCvnaRaVyEt3Lo1xuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEp9hsivtb+0eBisK+/hxODwX4vdtMmy+VUjbaLMuHA=;
 b=HxhL3Qtj4985Z+sOBCygaMDsN5dQM8OmNNCXQ+0wagBv7l+sysir6IVkecSJpa0ZQ0569LHkwZewaus1fIS6SIJKrb1AAyWLBu2GcLmABFZXBjm1UCtfhGwLUcXH6tgO1A+xXMP/x3r66l51yp40bwIDCQHWg//VkkFeGMFo8qNG6lQWoNXwwb80hOSYpEiu+1PVEL+J9P3GdjjctiO9RXViE1feuTJaZ7Gn98gnlGXLqHbHT5Hy8kBUvMeNXRReE23+A4Ie951JuyG7BAX3z1Q13WTFphS/lB5FsYVMpy1RHrDWdiSWWgZWnetzpv7cWYTBz6ovl+3UFbQ3IwNEcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEp9hsivtb+0eBisK+/hxODwX4vdtMmy+VUjbaLMuHA=;
 b=cvIjP05wUHnjMM+v0AG0AqaZirRGnY/Io4++YesKZhCJ5r/DUVbeIY1UCjfjM9FauXLUJ97oXMLHdVtzbTv1wGIYSGjpU68GM2V5HCBPozjxzJK8Rd8ArPM/q0Qv5DoCAJaYPyMilyVSco0HIKsz0pfOu6dVaaV0UEcyjysg5xg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA3PR12MB9228.namprd12.prod.outlook.com (2603:10b6:806:39c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Sat, 6 Sep
 2025 21:15:17 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8989.018; Sat, 6 Sep 2025
 21:15:17 +0000
Message-ID: <8f7eec03-3d9d-49ff-9457-f966ed2fc424@amd.com>
Date: Sat, 6 Sep 2025 16:15:15 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp - Always pass in an error pointer to
 __sev_platform_shutdown_locked()
To: Borislav Petkov <bp@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 stable@kernel.org
References: <20250906122145.29784-1-bp@kernel.org>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20250906122145.29784-1-bp@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0083.namprd13.prod.outlook.com
 (2603:10b6:806:23::28) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA3PR12MB9228:EE_
X-MS-Office365-Filtering-Correlation-Id: aa25a768-cb73-4813-d477-08dded8a7a28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SE1vQkM1eitPcGdBbjdsbHRzRUMxZVRYb0c0dW9sVGwzMTNKWm1VSzlzWU5H?=
 =?utf-8?B?VUF1ZUUyNmlIWDRXRXRFNW1CSmZHek4wa3ZkcHFlWE83NjBYcnI3VVYwaVNS?=
 =?utf-8?B?ZkExK0p0L0tjV00xZkFSNU9kUTRYNHArY2k1ZUkyQ0xKYUU4SXA5YlNGVk9U?=
 =?utf-8?B?cW4zZ3VOckwxc2d4cUxVOEpLMVM3bmV1dkF1akNndkcvMXRKUGJpTm05aVlJ?=
 =?utf-8?B?YVg4dUkzTmZCUHN1SFhDSmZMSThrbnNMcTRCYVFHRXZrenBheE81Nm5mNEh1?=
 =?utf-8?B?VG1JNVAxZk5TTS92TVJFWGV1ZW9CTWRZRG9sQk9WUlh4aWRRZ1d6R3V6RnA4?=
 =?utf-8?B?ekxKdFRMSWFHcTZmVVRqOWlMdVJCNU5sZW16d2VPVFJaV08xZm13WFB6bzJB?=
 =?utf-8?B?Y0JiVE45cU9RVUZNOTFMZEZZdkJ5TElsZld3OERMUC8yVFpTUG5qdHJiL1JK?=
 =?utf-8?B?Mjg5eC85WmJnSk5xZWZTTkJpWlFMLzVQbkR0K3cycDV4bTQ0N3FUU1hiclFD?=
 =?utf-8?B?R2RjV2gzUXY4WFcwK0wwc1JzVmlxeVI0K2RmVTE1NkoralBubFNFZzd4am12?=
 =?utf-8?B?c3RDN1lIV2FDU054VnJVdzBWd2V5b25sVURxZENnTXE5TGYyNkZIYVZqb3Ev?=
 =?utf-8?B?TjlDY1hYK3dHdFN5clZmenZCSlR5QlNPaDFjVjZOYk5mS2lPM2NFcEtEdDhV?=
 =?utf-8?B?am9JYk0zS3BEbm9zQnYybTRhZU9laXpwVHZLNHFMS3kyU09XVTdGRGFHWHg4?=
 =?utf-8?B?UGphYU5yZG9aT1M0TWZ5S1lmTjlZeU4yNDBMVW9DSDVWOW1rVnlQdis1MFZz?=
 =?utf-8?B?M25IVUlVdHZ6dndmNkh1d280S20zd2F2NGlPUGd5bjMwd2JBWEZZTVY4MFo4?=
 =?utf-8?B?MERuWEowK1I1bzJsdFQ4NTVHZzl1V2tEc0s0NkNiR2ZrVXlsK1Vyb3FzYXo2?=
 =?utf-8?B?bzN5YitBUDlFUG5lTDF3ZURaK2FDUHQvcy9yOThLeDZhZTMvSFlEMHAvMmZu?=
 =?utf-8?B?R0hndDN3LzZzcFRPdmFMYVlrT1JYZE1mOHBMMmlXcFlkUkpNU0dicy8vWk9i?=
 =?utf-8?B?dlJ1YUt4SHZwbUlRNHhSVzJoRGtXMWNjZUFMd0JHbTVVTzFseXpQQUNUWXpn?=
 =?utf-8?B?QURGdWZKZUlCRGc5QlNOeXJHOXVnV1VyTGl0WXRUaG52ZVJBZllVQmh0Qkxq?=
 =?utf-8?B?N25EMkNlWUhPWFFxcC9YYkl6cytLWWNhOG5DbEdiU01veCtXVmxpVEkwRzlp?=
 =?utf-8?B?bnBaUUtodUNUYU1YbEdNSmVWNldiNWdJazZ0dVI3a295QythSk9DWUQ0K3ZX?=
 =?utf-8?B?YUtyYWdZNlpnWXhJMzc2eEQ4WExrQ0xubmRocVVDN25BWHBmWkt1ZUlxQ1JG?=
 =?utf-8?B?dHdOU1RjdUF6b0tBaUhzWkVKcy9ZVVlvZUxLWjFSNHZtQ0V1OTJ6QStDS2cz?=
 =?utf-8?B?bW5TMGJBa0lNanBLZGZDM1VmaDN5SGkya2syOVRBYnVnNWhNL05tVGxsZDZD?=
 =?utf-8?B?bGhTdGd0MWtyOUlUMjQ4QW5UcjFEUE9NbGVoZlJSU1FpTXd4UVREMHBFb0ly?=
 =?utf-8?B?QndvVEg4MzNxSHQvdFdyY3dMUWp4VDZTMmxka2hrQm5TbnZFTndHL0VGSFhM?=
 =?utf-8?B?M1dMbjViOUtxbFBFaXJSN1lScjNEQ0NISVQrbFNOaUY1dTFmTFBBaXk2aGY4?=
 =?utf-8?B?bWlkQlJrYUVvNS9iQ1B4MFhCY3h5QjNHNnJMU05pTC9Ib0dmOTRWY1F4cmRE?=
 =?utf-8?B?UkxvSWpmZnd5TDVLTUFpMC9sU25iQWJ3WksyNUZlR0ZHa2MzOEY3eHdhRmgy?=
 =?utf-8?B?djh4aGJLV2ZYZytJWHlvTDMvZ1NoRHhYZmZ1bkNvb0hYWFRGeUZmbE43L29O?=
 =?utf-8?B?TDJUNUhrb0FOY1hoL2k0c0w0ZnRVTnJEUlkySlBBM1dUYVpneThsQ2RqM1Jo?=
 =?utf-8?Q?Ar/QzbRcJSw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTVpbHViOWJENHVKWDNWQWRJZ2IwMnlHMXZLMDJ0WFlHekREZ2N6VWxsUlQw?=
 =?utf-8?B?NkJJLzB5VFY4SUlQYjhWZFRMaUZheUFzSFp4U09hM1JXcWgrZldXVFlETUhH?=
 =?utf-8?B?YlJwc3JoNi9kdWJ3THJodUJLeXBrR0M2dnZ4YzRMZWgvUDUvN1gyMk53SzBP?=
 =?utf-8?B?djdTb2VhL3RmSVBBeVpWMTBpdDVtVmZWWGtCSTFVb0NSUXJ4a1ZYRjlZaS9r?=
 =?utf-8?B?dzRseDVSM2RLcHJEV2FkeUUwblNhVzZOa2VWMTJkbUtFWk41QzdqUlVpeFlG?=
 =?utf-8?B?b0FoYTVVZDRnRzZkMGFKVGVNbjliS3FVY2pxelZvN2RUNmlieHl2M2YwNVJz?=
 =?utf-8?B?UFQ5aHdpMWtYaTYwOXhzS2dEdW9jd3JINUdCMmJ3YXhyTTdKU2FuUWQvOG9J?=
 =?utf-8?B?TkdwaWxScmpwL1RpaFBCSmE3Y0JpWTF3aVpvalgxb0FiL3l6cVJsYzhJcHVT?=
 =?utf-8?B?UWJGZ21GdUJ4bzVkK3lmNTg5a2p6OE0wVUkyTHl6bHNFb2lqT3RNcGl0Q2s4?=
 =?utf-8?B?cjl5T1Jjazh4Z0ZsdVN3di9YWXYxN3VDOTZDNzQvT1BJWHJlSCtqYXJPaklz?=
 =?utf-8?B?Y25ibndhOENMZ1RKdXlWQkdrT01BSHJEUVh1UmRPdS94UTBYYmtIUFlwbEEv?=
 =?utf-8?B?ZGtkVXZQWVozZjVxM2FkczVzQ2NuMzlLbTd4WnFRckd4VXpYRUtHUk5PNE9G?=
 =?utf-8?B?UjFkckhrdVoySTZ4KysvVTFlUklUN0toUmRXVEhtSkZaa1JsUU1CalRJQ20w?=
 =?utf-8?B?Rk83d2JTWW1jcWxXU0ZRWTJBRWlyakNkQm02T0hTUWtaSDNJNkFHR3NxYldG?=
 =?utf-8?B?NjBqaVhtOFNXY2FlcnNZaVpkTStEeG5odng1YkdhVWpRWUFoSHZ4TEhzbVQ2?=
 =?utf-8?B?SzZaUWxqUEJHZDJJZVZGRHMrYTlEeUxIUTBsSnhnbWppalhRZmc1QVhzTHBt?=
 =?utf-8?B?aTNKVVh4a3JCMGtKWm02QVh1UkIxU3N6UmM0ZklZZVQ1V3dESmNPUFBDWVRT?=
 =?utf-8?B?ODlyVTA1eVpzMU05dDVUR3pGL2FuNFA2ZnloSEpRZS90L0Y2L21LcEwzeEhK?=
 =?utf-8?B?SHpNQ2hXM0hUSTZVSzVkYkVJbGlFTXZEdzJISFRDa3R3SDA5YWl0YmVWblpl?=
 =?utf-8?B?UCt3cHljQWlUVmpWMER1YVpnMENFSVNGc2lWcHRjVEJQKzhtRWRvNGgwYXdW?=
 =?utf-8?B?SXVhLzJFVkdQOHlISE5tM2RHMmcxUjhpeFNSMkJ5b2N2THBJZGM0ekVZeXVw?=
 =?utf-8?B?dmQ0UlJKMFMvb0hsaVhFZVQ0TlNnVGV0L1grMVRNVGVIblNxeTRkdlFkVmNm?=
 =?utf-8?B?NG5sT055NzdrVWlmTlkvVTkrRXVnNFhuWkozZVlYdTkyNGVMOXVESXRCYVBo?=
 =?utf-8?B?eGE4ZTl3Y2NuYTFhcHMyMThrQ2JWYWxac2EzMTdUYjhybndOT1oveXZWVmlC?=
 =?utf-8?B?UlU3NlJOSHJYYTRXU1VYSzhIQU03R1R1eXIyNFN0V0VzWEN1TUk5a0NCUU1Y?=
 =?utf-8?B?VjhlbXFwcUNvODdqdjVPUGNJa0dwdU1wR0ZrSTFIOTRLUnNXRnhuc01DaWYr?=
 =?utf-8?B?Sm5OOXlENUlXbnkrYXNZeHVJY25pTXV5VlA3NEZodXEwL1JYUElmb0h2Mmc1?=
 =?utf-8?B?RHI3cU51NkVlVWZPVUFoUEwzSmk1dlZNME82eWxock5XMjVRREk0bExqK1lp?=
 =?utf-8?B?R3pzSmZnMWluNjFtVjA1dVpYSWRZdlZtTnlXN25MRVQ1aGhta2hiKzNFYlZj?=
 =?utf-8?B?NnhjYzlOTU1MUHFxQWJQZ05vN1dtejI1eW1wMmNBL3k4WEhPMFAwZjZJeGM4?=
 =?utf-8?B?TDFYbW4zZWJuTHMxZkpMR2NwUW1VS2RPNzc4TGxzcVdhRjNBMmU5ZUc0YnZQ?=
 =?utf-8?B?cy9XOFNrajZLQ1RaSmZVcFVNSTFtNllDd2FrcFlHUitYcEpzdEx6cm9jNDlt?=
 =?utf-8?B?dEFwSkhXamVMSjdoSHdHcEtvTDBFN0ZTNkY1SEtjVEtPRU96M2dXWXRUQkRy?=
 =?utf-8?B?c0F5MU1ka1NiaG1iVlVleGNmRFhBTENHYVJsT2M4OUxOUlZxNFhvUGtadWJj?=
 =?utf-8?B?dnBCeW5IR0RwNmJjRHV1bGpxM1Z0OXA0amtHV3djd1h1RDBDWFhzZXJhbG0x?=
 =?utf-8?Q?bHuQuDMsDWdFbvR65T4SR/K9I?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa25a768-cb73-4813-d477-08dded8a7a28
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 21:15:17.1599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xZf9vOrSa7xnEMC+r0Tzw9MCudss7ZEFG8S8dPYObMKDtoxeLWScn6bPjjzOgs4pa6H0n2Mq/8N2tJehsO+zkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9228


On 9/6/2025 7:21 AM, Borislav Petkov wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> When
> 
>   9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
> 
> moved the error messages dumping so that they don't need to be issued by
> the callers, it missed the case where __sev_firmware_shutdown() calls
> __sev_platform_shutdown_locked() with a NULL argument which leads to
> a NULL ptr deref on the shutdown path, during suspend to disk:
> 
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: Oops: 0000 [#1] SMP NOPTI
>   CPU: 0 UID: 0 PID: 983 Comm: hib.sh Not tainted 6.17.0-rc4+ #1 PREEMPT(voluntary)
>   Hardware name: Supermicro Super Server/H12SSL-i, BIOS 2.5 09/08/2022
>   RIP: 0010:__sev_platform_shutdown_locked.cold+0x0/0x21 [ccp]
> 
> That rIP is:
> 
>   00000000000006fd <__sev_platform_shutdown_locked.cold>:
>    6fd:   8b 13                   mov    (%rbx),%edx
>    6ff:   48 8b 7d 00             mov    0x0(%rbp),%rdi
>    703:   89 c1                   mov    %eax,%ecx
> 
>   Code: 74 05 31 ff 41 89 3f 49 8b 3e 89 ea 48 c7 c6 a0 8e 54 a0 41 bf 92 ff ff ff e8 e5 2e 09 e1 c6 05 2a d4 38 00 01 e9 26 af ff ff <8b> 13 48 8b 7d 00 89 c1 48 c7 c6 18 90 54 a0 89 44 24 04 e8 c1 2e
>   RSP: 0018:ffffc90005467d00 EFLAGS: 00010282
>   RAX: 00000000ffffff92 RBX: 0000000000000000 RCX: 0000000000000000
>   			     ^^^^^^^^^^^^^^^^
> and %rbx is nice and clean.
> 
>   Call Trace:
>    <TASK>
>    __sev_firmware_shutdown.isra.0
>    sev_dev_destroy
>    psp_dev_destroy
>    sp_destroy
>    pci_device_shutdown
>    device_shutdown
>    kernel_power_off
>    hibernate.cold
>    state_store
>    kernfs_fop_write_iter
>    vfs_write
>    ksys_write
>    do_syscall_64
>    entry_SYSCALL_64_after_hwframe
> 
> Pass in a pointer to the function-local error var in the caller.
> 
> With that addressed, suspending the ccp shows the error properly at
> least:
> 
>   ccp 0000:47:00.1: sev command 0x2 timed out, disabling PSP
>   ccp 0000:47:00.1: SEV: failed to SHUTDOWN error 0x0, rc -110
>   SEV-SNP: Leaking PFN range 0x146800-0x146a00
>   SEV-SNP: PFN 0x146800 unassigned, dumping non-zero entries in 2M PFN region: [0x146800 - 0x146a00]
>   ...
>   ccp 0000:47:00.1: SEV-SNP firmware shutdown failed, rc -16, error 0x0
>   ACPI: PM: Preparing to enter system sleep state S5
>   kvm: exiting hardware virtualization
>   reboot: Power down
> 
> Btw, this driver is crying to be cleaned up to pass in a proper I/O
> struct which can be used to store information between the different
> functions, otherwise stuff like that will happen in the future again.
> 
> Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Cc: <stable@kernel.org>
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e058ba027792..9f5ccc1720cb 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2430,7 +2430,7 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>  {
>  	int error;
>  
> -	__sev_platform_shutdown_locked(NULL);
> +	__sev_platform_shutdown_locked(&error);
>  
>  	if (sev_es_tmr) {
>  		/*

Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>

Thanks,
Ashish
