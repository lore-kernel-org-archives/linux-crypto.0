Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AE9181B9D;
	Wed, 29 May 2024 16:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716999729; cv=fail; b=XxK6rySH2KGJNl+RLTxv+AD+pO+7h7R8RZTF4OYZjzXRsOhu9JpA3xELdUoMe86TRxdiYBIOXv06AHsDtiYoQrQkKzqCUQXyikUAAciNIW+f4yqDYM2nPHg26LkX5aql8SSJGB7b24qJKHrjfFokaEhZRY2vWHUWcELOB4pJyDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716999729; c=relaxed/simple;
	bh=NP6rczXxXFoog07AxwvkAzMrMZkHRp06+5G7Gg+1Iq8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lzkqDeB4cLf3I+6Fce6Ihy1LhOFmeF5Rakn8bkk0xgI/I1tM/t13ZYdJFB1/bOq0ZZa63S79R/5S9+zf621RFpUak2PtriFAuxvAsgIUmB46dA10tzR/9M/o1NF9h7mXK1meQjOccxCB+1MSQF6dnJ4ju+3CGSN5snK/PYnq59U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YopjG3ME; arc=fail smtp.client-ip=40.107.93.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YopjG3ME"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2fX0HuxD9zixEFGZyr0BjHCf80L/yA0SHGiMwhRRXi4n4+7S2xTixamJcTB1boD5RwvOkScGU/DtNvRqXuS7w42XP5e9MuNZiqfFOiYiBXTKPd0NFbYaPIiEk2a/F9ogLyE3bA4UxBPVEMICG547Ut4da8SNuRfKGadj3uafKm87AhlB+y4sqX9OX3GS5k8NJaVThqukSQi+FBkxV04oC5rH2mBT228zSa+sjujIecK76owAOrYq+Rt41wzQrGKIRous4Pk2GWPu4BbdWETj7GP/UOYRxW2zUfQTZdnDOZDjMRV3Htl6L4SYfvl9KBvvlm8cyK4v/Wu9sNsUawf/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMygOnQ4yYHLbQ9N0A4FOFJGXtIVWHSWGD95sRMhHJ0=;
 b=F0zhXZ3bfF/qk130/DGtDcPfPt7RskqlK0zXyeVx8MhmXs0GT/H98Ezy2bMnqh5r3b83faSKr0avcMPziJu7ZUz+MKfUZzjgzuaELGpzvJTHMh4uduQxVIWEU4pP7WvW4zrIDeXEbxhA3NP8Ggy9Fl8pTSKpxtd6TY7Aye9F3h6FwyJfEPk5sGfDo3kjloND28FtUl6KdkhAq7Ujde9MX1mw2U+IDHKenZijgVy1Y5s3pL4DzymAuFfQLuwKaRe6UITI4GWMGg9aJJvAy4jwgVQahSUYMxhPTPAq6a0MIWXwmY2m9pFQ5TGiWgZLDcy+wFcNRhj+GIWfNBAyCFc9IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMygOnQ4yYHLbQ9N0A4FOFJGXtIVWHSWGD95sRMhHJ0=;
 b=YopjG3MEPSFBIu2XGXbZ88qo8FDXtEW51o5yHLojIhGFIyLUV3L2CbV0crIeLEZ3hsBN3CmWHb+1fDQxAsa8mbxtucU0KWn+HZKhr7kpo3LvkiAPNbO5XmHAs7ntxdjv//U3M8d/Ucemd4DeflBZucjXj81CLwHTf9q9wm2Hn70=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN2PR12MB4341.namprd12.prod.outlook.com (2603:10b6:208:262::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Wed, 29 May
 2024 16:22:05 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%7]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 16:22:05 +0000
Message-ID: <e29a975a-cb63-43cb-a421-8d7dd5ca36a6@amd.com>
Date: Wed, 29 May 2024 11:22:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] crypto: ccp: Move security attributes to their own
 file
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
 <linux-crypto@vger.kernel.org>, Richard Hughes <hughsient@gmail.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20240528210712.1268-1-mario.limonciello@amd.com>
 <20240528210712.1268-3-mario.limonciello@amd.com>
 <7f9db4de-635f-6204-d261-3bcd0aac1c25@amd.com>
Content-Language: en-US
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <7f9db4de-635f-6204-d261-3bcd0aac1c25@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0147.namprd13.prod.outlook.com
 (2603:10b6:806:27::32) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|MN2PR12MB4341:EE_
X-MS-Office365-Filtering-Correlation-Id: 869f2014-d013-45fe-7392-08dc7ffb7ac2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WHMxYXdwanh6K2ZDbTZGd3ViUml2TUlEck5FcW04MXRzSUdQWmRJa3lDODlq?=
 =?utf-8?B?dHh6Y0VNQUMzRkJNUGhWVU1aV3lVOGJWTWZybmlXVUk2UVpBK3BOVDIxR0l6?=
 =?utf-8?B?b2dZTGUyZGx2MUtKVFVlOTVVSndwOTI5S2JibWZudXFOY3A5UzlPdnVwZW14?=
 =?utf-8?B?Y0tlSGpaOGovM2Y2YTFvcEUxTVoyTE5WenJoTzhzVWdMYlF2YnEzMXlGNzU1?=
 =?utf-8?B?MVJ5ekduR0dsMUpJK3hPSlkvVm55MForRDNOQmNhdllFV25qY2RmQ2J6R1Vi?=
 =?utf-8?B?eFo5YUtrTiswZUdDSC9uMnVIYnZaWkdjVGJPM2ZRZzVvM1l2Z1ZDWVBOMzRh?=
 =?utf-8?B?THNVUTQ0WHBncmYyc2hkVW0rdWxEMU83TUlDR25jYVlmYmdJdisrRnhMVWZH?=
 =?utf-8?B?QXBWN0NrMzhudFNkbjhpdkl1cWh2T2RnY3d5c1dKZGhaL002R3VpcytzSWwy?=
 =?utf-8?B?Tmh3SkZtdzVWQlFmaFYwY3hsWkNhQUxOUlhYamI1OGljSm43WjQyOExTb2lQ?=
 =?utf-8?B?KzBiR1FZT0JCS1czR3E5UEZsQ3VadjhIandQNi94b0ZwN05jbXJjY2FPQ0Y3?=
 =?utf-8?B?OVROR213SFZuU0drQjBsMmVJQ0JTYlBZc2k4KzFKampMejJYQ21YNjRLVWcx?=
 =?utf-8?B?dWRJUEJPR2Z0OGljRzJGSy85VWc3QUNtUkVyb2JueGxKSktod2Q4aWdBSHRZ?=
 =?utf-8?B?S3F2bG03NTdOcEZZT0xXazdJR2FROXpQamNVTzh0eFB0VXk1MGVRVlZrWGRw?=
 =?utf-8?B?KzBKZUpOaFZUQ0JoVnNIL0pDM2N2dUFKa0lRVjltRVFYQ2hlc0ZqSVJFeStz?=
 =?utf-8?B?TDFSdVI5QlJHcStMR2RjczN1N0hGbG1LZzJQWnpPWVVWVHpEb1lkV0ZvV0dQ?=
 =?utf-8?B?SlhPSE9Vc0VjYnJaeUZ3WkljMXk1MkNpd0JCOVNjZTEyT3R5c1pucVRvQ1Fq?=
 =?utf-8?B?SWRMWDJNM1ZsdnVBRmVGVmpsdDl1UHZzUVpObWdMMmxsWS9NS05ScVNUR3dl?=
 =?utf-8?B?dmRZZHAzanhZQmpQOFppSnkvU0NDeGx1NER5VitubXNBRzVlVmpHTmNwYjEy?=
 =?utf-8?B?MVVrRFRSaWo4N0xxOTlONmVpNXVvRDFGWForTStOU3hCRmIzdjNlMU9DNHR1?=
 =?utf-8?B?L0p6MThHMmxlRUV6cEN2OGxUbWxKcGQyb05kaklrUjZNQmVCMmZzRDNlTTRz?=
 =?utf-8?B?c0ptWXZpL1dBeGJnSE01a1hUcHRXSnl0bjVJdC9qWklhTHNKMGVVb3VZbnZO?=
 =?utf-8?B?QTlIUEs1N1hHSGlxQU1GaURNbElPc0loZDVBcWRldTJ0M2hHT0RkR0lCL0Rz?=
 =?utf-8?B?R2xISGZDeUlJWm5icjZyV1hYbmFUaVN4dEVWc2RsOS9WWWRwN096MU1udjVH?=
 =?utf-8?B?aTZ3ck9abWdKWEJHcFB2YlRQRG1iWXNSSTNXR3k0akRXajdpSUw0SmQ3V1d0?=
 =?utf-8?B?VmgrcXFkMTVSZjJiMEtWbzVCNSt3RW9UT2JVSktGZ0dyOGwweThCK2I0MWNp?=
 =?utf-8?B?dzhCMmczY0t1dU9hZzJlWU9OajVuT1BZWWo0NmFaL3ZCcURiajN1ek5XbSti?=
 =?utf-8?B?MlBNVkZUdmo2WEE0RXhiVTIyR2JmVW9GMWUzcUY3MzJoM2ZHUlpxL3BTNTlG?=
 =?utf-8?B?Q1d2aGdsUW5BQTdwR003R0VsWEc4L3hxeHByNWluY3daWmxVVktUUE5MeW5I?=
 =?utf-8?B?YXUxL3ZMb3Z2Q0pGbzZBQ1NPQXB3Y1JHT1ZFOGovTFZTbGswTTlpTkVRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjBBZ0IzS09mS01ncXFQREZ3QVlMTUxMdElzRXZ4WllsM2g3Yjhad2dkcXBK?=
 =?utf-8?B?ZXcxQWpLREVqT2NMeWxPSUJTTGJCTFhQalpTRE5Hb29mMStHRERTb0VWNDJU?=
 =?utf-8?B?cVAzd0RPT0dZdlF2d3FyQ0RYN29QT01pekpTRUdiK3N6aXhFS3dWYkZUdWw1?=
 =?utf-8?B?Rmhab2NvZlVoVmtjdGVpM0J5ZEkwTE9NRjJKQlRqSkN4dDhaVU50dHBiT0tl?=
 =?utf-8?B?cHowQlczYVczRGFLL2k4L0hWa2ovNERRZGNUWEwzb2tnVk9INVJ0MmY5cHhl?=
 =?utf-8?B?VEpsb2h1SUtzeSt6NGZMU3ZGTi9FTG5KZzdkSWhhK2lRWGhETzhFMDdLY0Nq?=
 =?utf-8?B?enlWS1pmVEIzSjZ6cW15eWhEN2w2RWZJbSsvZ3hOVmp0YUJLakNJdDE4WWE4?=
 =?utf-8?B?dC9oRHVxam9RNUdvZFZzbUw0MVpFUGthVkJjRlVOcldFRGhtNHh2dlE0eG94?=
 =?utf-8?B?QzdiQUVGckpubVJBQkEyK2UvQm1GTjk4NFhtclE2UHlIOXVDOFBXcEl0cHhC?=
 =?utf-8?B?bGpoNTJrdkhKT1VCWUVEaTdlWmUweW9RQ3NEcWozZnVadXdMejhRU3Jza1Bn?=
 =?utf-8?B?cmh2ME1VYXpsRmZGaExoN3h0L0ZnalcwM2pFU2h5ZUlpOERMZEQ4OGZqY0Yv?=
 =?utf-8?B?WGtDc3R3MTNiSW1wV2tPVUVkSFpPRHk4S1pZTTRWL0hDOTRiTERyaHlrVlMx?=
 =?utf-8?B?UzV1UXdua3BpMCtYMVhBMEhpYzkvd3Jxa1lmbklhVjlQdEtzWlgwbUpnanU5?=
 =?utf-8?B?UlhPc3lpMWk2UGduemFpTTJ2c015c1JUUWxuZ1lDRjQ4MGM1S1BZa01jczBK?=
 =?utf-8?B?K0hzVWw1QTZsdVg4eG1pNFFQdXhLSWg0dWNrUzN2MzI2dWRrSHg3UmhYMS9K?=
 =?utf-8?B?eDUva21kc3VJL2dqL3hJbkhxcUdUQXZYK05QUVlLSFZvSFNPVFdqV1JMWVBU?=
 =?utf-8?B?VWh4THpGWFY5aTh1RFRRWmlWZXA0VnVyRW5NYzFtelFCRFZ1WVZQbE42a3FM?=
 =?utf-8?B?STIvKytJalhRSy9Od2dkY2orVjhDSkZhTHVKbFJUSjFEaS9CRE1JV2toMlpI?=
 =?utf-8?B?V2Q1dG5XUnV1S081UzlOTHVNZHdUVU5DeERYc05IQnMzMDBlQkxxcHZjd2NO?=
 =?utf-8?B?eWVlWU16aXN4cmZLbkRvbHFCQ3pEdFdnKzdlOWx0emtDTVdILzIzNGdIZFov?=
 =?utf-8?B?eElwWG93VzJzQlRodDc4WE5YOXliYms2eHNRMCtEamJraWR1YUNwSmhhODFy?=
 =?utf-8?B?VGwzZ0htQVgvN0xOYmR5cDliWHY2QzRFSXlRY1c3bm5QRktONWhEcWRrenJG?=
 =?utf-8?B?T0t3aENHMkt6UTZmOEUzS0N1TmNucjdMdm9PZXZUcXlRcENQQVU1bFpNMlFn?=
 =?utf-8?B?YzFITWtLVHZNWTRJbW1va2NXdlVwVlZ0T2FhWjVOeVdtbmtZdU1BQlNUUTRB?=
 =?utf-8?B?OFNWb0ZPbWpsSytBdUUxOVFlVXROTDY2Z3hsNGhFdU82N0E2ZTYrQnFmY1N2?=
 =?utf-8?B?MjJwaFpveUl3NlhZeUJCNVRBRGVBelkzWjR4MHFWYzVZQ0pXQzRJZkJnY3hY?=
 =?utf-8?B?UjljMkNCKzBPeWtZMkZHbk5JeDN0bytEc042T056TXVlVVJQL0Fya3o5QnJP?=
 =?utf-8?B?c3ZEZDdORHorRjhqVElqTUNqYU16Y1B0Q1pZM0lZNlF5Mm1VNFNsQ1pidW0y?=
 =?utf-8?B?cFFFb0JHSGphOXVYN21zUHlLU01nUGU5V0lwTzUwakM5Z0xTOFBFVVVlNnEr?=
 =?utf-8?B?T2NQTzNRaFFRQ3JVRmRqSFJVS0Q4eFBSRTU5a2ZoVmNkazh4aFRQMm9QRGIx?=
 =?utf-8?B?SjZpVnhTQldlU2szbVMzWjNWRFIxQ1o2UHF3bWFOTWxrcTJZY09ybkwzRUNK?=
 =?utf-8?B?NGg3UldBdlJjZ0dFUjJkS09FSk81c01mQXg2ZTZJOWtxcGhtZGI3OHFSb2Jv?=
 =?utf-8?B?VTUzMEtnVlFjOXJ5UitodWdwWDVyaVpMVFNoMmpBY0dZd1BzREZlWW4rMXdT?=
 =?utf-8?B?cUg3MFNVa09BWHVtOEl0ZFJib2hGTG11ZXc2N0QxRUZQVmZGa2prZjluVTRm?=
 =?utf-8?B?L3c5ZVRtSXowblIwQ3BLNjJpWkFRYmZya0Zub0xmS0laNFl5Q2JXQkJLUFB2?=
 =?utf-8?Q?xPC5RZUuE9qbgElZe4YRG5pph?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 869f2014-d013-45fe-7392-08dc7ffb7ac2
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 16:22:05.4392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9+85DSJ0s5IaRtPnfJpqo6HGWTenZOpwItnWKQ7w1DIOFCcF3eg3o3CR5Q5UC+Zn+E4WvDH9m90pJdsWozUBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4341

On 5/29/2024 10:20, Tom Lendacky wrote:
> On 5/28/24 16:07, Mario Limonciello wrote:
>> To prepare for other code that will manipulate security attributes
>> move the handling code out of sp-pci.c. No intended functional changes.
>>
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> ---
>> v1->v2:
>>   * Only add psp_security_attr_group when PSP support enabled
>>     (Fixes lkp robot reported Kconfig issue)
> 
> Just verifying that there's no change in behavior in regards to whether 
> the attributes are shown. Previously the attributes were not shown if 
> CONFIG_CRYPTO_DEV_SP_PSP was "n" because the psp value would be NULL in 
> psp_security_is_visible(), right?

Yes; that's right.

