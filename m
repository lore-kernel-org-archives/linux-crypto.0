Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B194331352B;
	Thu, 23 Jul 2026 22:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845152; cv=fail; b=d+47IdSNj92X0Mtzj0yGWnDZfLEMOVG6g6t/Dwot3Snbw5CKK/WNLZguTavSgcCy+wY4ZQttOl4mwWw2YMDiYUXo9Joxv/1nPIqF6HhfnqpuPpMwceVc8AyAoQKsHgvNG7Oe4YIqSMU2DmnbivKvhcS8XCTQisaPA/hp+tlq2MI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845152; c=relaxed/simple;
	bh=XduGKQos0S5pALUoZTj5cDWUp62t2dhDf9OJs9G0BH8=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rd1GDM4zgyPjOdQ2RDcQzW3URqLdGh5ywEdXB/jlegOqiic135Q6MVVCpAviJFiV0VpzNt1OfhYhJeE2T99Hiisr+I0/JCp9DJgBj98jsis1GAFKqPLRDWL8dgKSvjqJgH7RL7w+n5SCdGXCAEMItBGQX3hEArxkLm2kp60Do1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gFzQAx90; arc=fail smtp.client-ip=40.93.196.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gFzQAx90"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g45ls8n6wzDuZdyl5E+Np7poSLo/b9/+ZDMuPOnhbjl3oXho6dN9Bxx3mc65nq8dxliGt4QAvJCUw1VBxNARts/iBET775/ftbnlU2ocoowXUcXwYFRhTuxMuub7koJaIIoKuUH9BRCoMCSWL+MJXjhTmA5ij+GhTXUo5jIoONtkyTyENKILcUTbF6V1n/fP+bogXY+bRd7AwoIIjuh66nTBilTpjc6xO9mb7tCuBi1ZhZgfjSNqlyQjS3yRzOBDnRzRp29qgiqYFpL/WPhVeZMrXfm2UjnJHZIXGaJJCNnGUrAGV8QmtK2rChzE05UX10Rcr5TXLEidR+9GLQjcbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJaY8v3RWf/yts0S+1yT6eniBOYjkMwQlC9lxWdO+Zw=;
 b=JqoTqOMG4cmkAhReNO7o3waW6ZzI5EqDsdqCRimfkNk3/MNc6YMPQMZ1JfIRqWxC8uBWX19voxKirOKBSzQFnK8kX4vCd6tdzcZ2VfDI9+srKxy61dT2+s3ugB6Y4TFkN4lXur5u7yiLPx9h6/ADjsDpu0R1+RhmWd+bU2TI7ny5xKviq6Yf5tUF8SIIuHVAxwcWdZJgmjg6/xd48UomDDd7tSIWTvFj2syutiMdQPtBKTlx0zD80AkMNkdFLcQGxBP3HwtoF5ZenHC4x10J5zNbVlQv38FaQr0KGF5FXYoZkQt8E+FgVEpu9L7N8a6NYk+aK3gR/RPs982colX5uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJaY8v3RWf/yts0S+1yT6eniBOYjkMwQlC9lxWdO+Zw=;
 b=gFzQAx90LsEYoL6qHRhWrK66Y+eiyMPdp/+4mMddCS8QgQrA+8WXrOUXcJAvy7BNymSEZEdSWEvDfEC1/wK+7Ga08uHqZQ074Tr/6zvTofrGvjURKD/vY8eJh1dPIxdFI73iFtCsAbt0ZaVpliZrGcBqILW9zgkT47Gxq0lmq3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MW6PR12MB8897.namprd12.prod.outlook.com (2603:10b6:303:24a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 22:19:04 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 22:19:04 +0000
Message-ID: <55a6bded-643e-4c36-9d5b-f2dae012b54b@amd.com>
Date: Thu, 23 Jul 2026 17:19:00 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/6] x86/sev: Disable CPU hotplug while SNP is active
From: "Kalra, Ashish" <ashish.kalra@amd.com>
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
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>
 <20260723185323.GAamJjI2HoM1gZmExw@fat_crate.local>
 <404433af-b908-4849-a8b6-1c1ee9d33d8e@amd.com>
 <20260723200003.GEamJyw2W1nMPAUdHc@fat_crate.local>
 <b1a5e1c9-481d-4c70-a058-de4718618891@amd.com>
Content-Language: en-US
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <b1a5e1c9-481d-4c70-a058-de4718618891@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:610:cd::21) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MW6PR12MB8897:EE_
X-MS-Office365-Filtering-Correlation-Id: ceae82eb-3079-4f08-9502-08dee90867d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|22082099003|18002099003|4143699003|11063799006|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	W8gaRoD1s6d7Yt2crVzolv6dz/4IP+rUlkn55v9rfzQU9KqCwt8eb6h6G1IDgJjn6SUOnps7vE3xQgTsIf/3XUKGBqaivCzOBkfGfccoQ+diKhiHCzIR2d3aOzZJdeee8JCIrPGwQtxho5lc2PijUoYBPvexNzGtIO1ZWpChL8MnW6aHgodK2KuvsAENW91vEPRInMNto8znJF7/44J81Zc6eh3GRK8nwZYJBXEndTT+t3xSCP1sYEjKhU8JOz3kDKCKoEn96ykj7BYlXu+LrCzXMgfjYYmtQ7f6bvxSxNgZ9++qnrL2NY5k8ZqdoE4gqebr67YUSpJQXAAymEUTTDCiwFMFTSRuT7hroe3d/P8W/zwTzCiulJAakzN2qPQg/V6cOP3B+sRq5MlVmIVFrnFUCMlZOERN19kMp/mo0N2zTy/D3+GxjyPXCNiaA1Bi70nQUq8mzh9lcpsfq+T5r+sRMGVAFrpGTz51qQJfZhHV7Eh0pwXrN9bQEjgx+7Yc+nxMF87M8aj/MWYFoMh56RgYAxMn4o7x+rmMMjI+2K3bU2rcl+gxNPZyBWu7YIQ1AIUnpMyIxGIVKLJpRtPcIhZinEd+YONn6DxVDApiEWBs5O5o7ruRwHuT2oCS3IxSCatmZJK7aU6jdCIi1sdQpiiQZMOu+OJQCOe5N8enCCg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(22082099003)(18002099003)(4143699003)(11063799006)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0pVSW5ZbHZNcVRKeHRHYnFRK3hjSWxRalNLbW9sVUNFNDltK2wwK2hEZzdz?=
 =?utf-8?B?RG9kNkhoVGRXcTBIRjEyTGNNandVUVl3RjhNMHdOYnFyYWpVcWFnY25LdWVM?=
 =?utf-8?B?Vkl2RzJRSitPb213Q1d6dkpYWHJ2VnA3alZpOW43bEk2QVhVSUpWUW1iV0tM?=
 =?utf-8?B?aW9aZEpTMUVTeitYTDRVdFdaSk9ISjQwYmxlNHZaYVkrNG9UWVQ0UmZURU9O?=
 =?utf-8?B?RlNuRHpFSXA4MmVDRFZ1Q3ZpMTRkN1RXTGk5bllFVURkLzBEeCtyUmZqb1ZO?=
 =?utf-8?B?UlAyNXVkOWc0dzErcnFYYzZpYVFJcGdZWnRwSmJ0YVUwY3RqRXNqd3U5STBu?=
 =?utf-8?B?OXBvcmhkaGxqcnNGdDB3bW5zVDlmVXozeTU2UUk1WW4vNWhNVTdKTW5QZTVJ?=
 =?utf-8?B?NlBNOG51UUlFR1NPblBRNkxLYnhodFJrd20xZ0NjRG8reHpNZ0xHeG5SbUtp?=
 =?utf-8?B?dWRRUjdzN2wzcVZXdytPcGllQkY2V3BHZlVaVXlqczJERmh5Ykd4dlBDRks0?=
 =?utf-8?B?MmxlbGdTOHNnTmFjWmcyMmN6QXN0OVdNUUlVNDNuQjNIVi9YaG45MWlsNWhK?=
 =?utf-8?B?U3M3UmRWMUt4ak0yeDE3N3VxZGpBdEZNU1BmVXZUdXEwNFhrYVp0Tng1R3Ni?=
 =?utf-8?B?S1N3TXBKYS93cWdBYlNxeHhzVkxsdzRWN2htdjlJMloyWlh3SnNyRFpxSTdN?=
 =?utf-8?B?Q0pKUnk3WkpoSCtJMW1UTVRwUEF2U1lOcGZrS2drdWNabExnY2lXME9yRHVE?=
 =?utf-8?B?K2xxWGVMUXg5UTc1VHV5VlJmaWhsRmRzSDhoOEs3M2NLN1dKNEJSYUphSkJG?=
 =?utf-8?B?T3haSFlHTzRweUxlc0F2RkNrYlBYdU9BR3VReDF5UThGREdHTW4zL29VM3gz?=
 =?utf-8?B?WVJpMGFuZ3lxTDdwOEo1WUZnOTNxa1FwV0lpMFc2R2RINGh3NFk4YmU5M3A3?=
 =?utf-8?B?YlNXcjE5cHFnUTJvWG9EMGJZZzZyQzU0cDFpdGdsYjdtK2kyK1JidFVoR3lI?=
 =?utf-8?B?SjFRMjZ3eUwxU2JDcTRrNUdnZlY5R1BtMWR5eFh1aHc2d3VPVVNzYTZPaFh4?=
 =?utf-8?B?c1lMem1tMmRoczA2RUtWd1orenhVS1FHLy9CL1VBeUNWclBRZFU4VUIwenZs?=
 =?utf-8?B?R1ZneVFCYkd5VGluQUZYeUxlZWtEbnpPZWVOaFBZSnUzek94NW1tSkVaUS9H?=
 =?utf-8?B?T3VQeTcxRi9Rc1lLYkE5anNUdXFiZXY3a25qa2U4bDJ5V0RRRkpTeTRYc2Vv?=
 =?utf-8?B?NmJ6OGs5UkN1bWNucWRKMlRORFRWSis2ekh4NzQ0Q0FGOWk4WXdDVU9EMWl2?=
 =?utf-8?B?cDZHNHFLdm5oWk16cUJzbnZVbUNKMUdYY3hwZGNFRG9uS0NObTBXbk8wTG9W?=
 =?utf-8?B?SHlaMHFqb1k0NTNpd3lSN0VQY3ZXOUdBcjlzTjFZR0ZBcDFveVV5U3dwQzM4?=
 =?utf-8?B?RCt5ZkVvT2JjRGEwaUd5K0N1WDdlTldJSHp1T0x6WnBaM1NWazJkK2dHaUdX?=
 =?utf-8?B?bHJMQVhPSTNUWnlDSUduOHFTWURMVUxObWk1azdYZndGTnluU2JBSkZvN0Nz?=
 =?utf-8?B?Qk5kTlJqdkZZK1pia3RYMmV2RGI0TUg0ekp2TUs3ZnhKa2hDLzFySmZwczlY?=
 =?utf-8?B?bWM5L0YvOGtTZ0c3US9KczluemV4WVcxSEN4bmhYNm0vUThxV29UV2gvM2ww?=
 =?utf-8?B?SjRoTjJzKzlwdlpjVldWN0tkajRtUWQzanVpQ1V2eVFZVTlmVnpHU3RDbzF1?=
 =?utf-8?B?K2pvMUo3Z0c0eWdGeHNiSmxsR2ttbjNxNis4Y0pYS2g4N00xYWIwOUtBLzFQ?=
 =?utf-8?B?aHNoY0FMOVhuRHVCeWVJTytqNjBmN0hoUE95M0ZEMkJDaVVwMUxUejAzUE5s?=
 =?utf-8?B?WG83Nm85a2k5WEJaTVd1Q2lSanFpSkYrY0VKdkQ3TGxIcGQyM2tGMGVKME1K?=
 =?utf-8?B?SlBiaGhFN0U1RDdSbXBQeGdTZklZNWFVNHhXWEgwTFVWSm91dDhjRlJxcW82?=
 =?utf-8?B?aGlNc1NmZWxGTzFiUmNaWC9vM0c0U01NaGVmK3Z4TFkvd1dmd2g0VDMzM1l1?=
 =?utf-8?B?OXBuMDA2NS92SWRXWi9KdkdHZkhsWEJLeldpT3A3ZUg1V0s0RW5LVGswZVpn?=
 =?utf-8?B?YjdKdzl6bUxSRGNETDB4WXNEWWxXU2JmcDFDWDV2YkR0WXc0ckpiWkFkTVgz?=
 =?utf-8?B?Qno5N2lFTUhDQ2N1ckx1R2ZaNlVYT0FxZDlPYUprWHFhUnpKeC8yWlJvK0F6?=
 =?utf-8?B?MVhKY2VZNzY4cUJVUlZ3N0tVek1HQ3ZtS2UxWmFTVWp4bkovdm45R1R4KzE2?=
 =?utf-8?Q?SCGmBQtQyG/CLktBN6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceae82eb-3079-4f08-9502-08dee90867d1
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 22:19:04.5906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0vkM/HbeWGZB/ZUJ4JqO039y6uyjseoelL43fMNKX/L06pjELsshjrushpNOnr7qNvh+wKJpnBwWH8G7Qcvcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8897


On 7/23/2026 3:39 PM, Kalra, Ashish wrote:
> 
> On 7/23/2026 3:00 PM, Borislav Petkov wrote:
>> On Thu, Jul 23, 2026 at 02:44:47PM -0500, Kalra, Ashish wrote:
>>> Actually, i will have to remove cpus_read_lock()/unlock() across the whole
>>> patch series and also in the original code.
>>
>> You need to do that in the same patch which adds the hotplug disable so that
>> there's no hole in hotplug handling when bisecting.
>>
>> Make sure to explain why you're doing that in the commit message.
>>
>> Thx.
>>
> 
> This is the list of the consolidated changes:
> 
> Patch 2:  "Initialize RMPOPT configuration MSRs":
>   - Renamed rmpopt_cleanup() to snp_cleanup_rmpopt() to match snp_setup_rmpopt().
>   - Simplified the 2 TB RMPOPT_BASE comment.
>   - Replaced the misleading primary-thread comment with "…only one thread per core needs to set up the RMPOPT_BASE MSR. All
>   primary threads are online, otherwise SNP would not have been enabled."
> 
>  
> Patch 3:  "Disable CPU hotplug while SNP is active":
>   - Used your commit message.
>   - Since CPU hotplug is disabled while SNP is active, the online mask is stable, so I dropped the redundant
>   cpus_read_lock()/cpus_read_unlock() in snp_prepare() and the cpus_read_lock() in snp_setup_rmpopt()/snp_cleanup_rmpopt() —
>   all in this same patch so there's no hole in hotplug handling when bisecting, and explained why in the commit message.
>   - Dropped the superfluous "SnpEn was never set" comment and rewrote the snp_shutdown() re-enable comment.
> 
> The RMPOPT scan in rmpopt_work_handler() (added in 4/6) is likewise lock-free — it runs only while SNP is active, i.e.
> after the hotplug-disable patch, so it never needed cpus_read_lock() in the first place.
> 

Actually for v11, I am reordering the patches so "Disable CPU hotplug" comes before "Initialize RMPOPT configuration MSRs." 

snp_prepare()'s cpus_read_lock() is then dropped in the hotplug-disable patch itself (bisect stays clean, explained in the commit
message), and snp_setup_rmpopt()/snp_cleanup_rmpopt() — introduced afterwards — never take it in the first place, same as
rmpopt_work_handler(). So the removal is implied by ordering rather than an add-then-remove.

Also folded in: renamed rmpopt_cleanup() to snp_cleanup_rmpopt(), simplified the RMPOPT_BASE comment and the primary-thread
comment and used your reworded hotplug commit message.

Thanks,  
Ashish
