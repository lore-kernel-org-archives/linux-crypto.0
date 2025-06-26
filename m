Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66392E5438;
	Thu, 26 Jun 2025 14:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750949413; cv=fail; b=bRIdMGjjv0k28LF0s7HjDMNskm3Wrtpq4iGtR1hMu5fcPTjoYasLws1PD6BB89YxF4m/RNYP46l+jK4VZiahhGhdXvYz+Mq5k5czvI6rVkYMw03hzNUVxfDCPMNPSauXJbnz7cR1mVFUIqlJUdCzfYXyhgUzZkg+e/O23K95Z88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750949413; c=relaxed/simple;
	bh=b6YhQ1AjSvy9h1pnyFTcrrMfplGHbtF6UCGdeCg+G+g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hXMg+Q5uJJjGAlCkiBktmMhulXhR6AZYezIwAV7z00f+OT5TkrdZ7w8BrH74Z/YIb7n0MrEad0/jIDbv6kYc//Rro5yj4s032/n2Sfvj6r7gdh9QmmTCmnyG0G37185RLPXzQz2hWrVaOT1YhaeUT/Cn9gsnplqKj4VI7Ew3dPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GZ89sZvC; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GZ89sZvC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=stPqN/68IuoUIjfcRfImMabSNPqx1zrprNayTBQVw97gXRKoZxmO2MFMxZGUYvTucmJSIJEgAHQDijtSLi3dfqIvcaKhe0b23/VMh5L4x9Fz/l61QNaWp1/xuDwNBlATF5uCnd/sB3q2fCOOA7rtt1/KgiH8cFQluZlUfuMFThXzZT/q4GkLcflfseAkjRCIANibm/DtLdKeZ7arcje91iHY7Rf+Cb5Gu0+uQpCTE6XY7X/+USkJpTQX2uCIP644ntMo0oXAMOHztaSJr01U4R3AKV0hBid3LaCnE2tHJhH2bZcJK7uoCDsYB2CFghocImmWZxN6Xt/HEZKmFwpDrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcloSr5PMA5kVOhE1tAkfytc7OnVQyMAQMcSC+1MBPw=;
 b=Ck6POgX7d/ePykjSqo5C/k5exG93qIOIULaw3Gmi3UXQ5kWNLQ6xR27LvY1sbhsMhO3Rp3PE5oihhA2Qzg+GSMP2uGnDCQBaVPBMQb7JcbHJWWXAy9JJHJDGEajYv522BZR63faSi4Jp9G48d1OnzutW3d+ttklACYjoQHkPF6uV3RWfJme4v9yLaYbhhnAQrHl4PMIlKk5RwkUE3PJcPO3JrFZaSljviAIlvlkMmxrCbHQZsQit65mXG1QTadF0ZeLzbP/Ic3Qh6TMS0Vi/SH98ZmZuI6UBMGOuX9DmcU16uldWDkIT/aTLQzW+tmdF2Urgn0zWtXR7c2VWZLbFdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcloSr5PMA5kVOhE1tAkfytc7OnVQyMAQMcSC+1MBPw=;
 b=GZ89sZvCk5z7I4Rd3pLEMCiOLPvZ9RUWZhl5GCS+Hg6m+bkvha20YQx3Wsdhq7vxX6O7B4wAQqbs2qc5UvIEByMeAAMtbIYotCslUlamPdkBrTW+hIkNBg/LYb5ut3yOSoTpIY5L50hrcqHDoPXYnr+FDnwDiqUnkWNk2CJ5w3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by DS7PR12MB5719.namprd12.prod.outlook.com (2603:10b6:8:72::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Thu, 26 Jun
 2025 14:50:04 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%7]) with mapi id 15.20.8880.021; Thu, 26 Jun 2025
 14:50:04 +0000
Message-ID: <bce43912-699b-4738-87f2-6960f7eecdc6@amd.com>
Date: Thu, 26 Jun 2025 09:50:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto/ccp: Fix locking on alloc failure handling
To: Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
References: <20250617094354.1357771-1-aik@amd.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <20250617094354.1357771-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:806:a7::20) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|DS7PR12MB5719:EE_
X-MS-Office365-Filtering-Correlation-Id: a85d1e0f-2186-4456-64d7-08ddb4c0bc26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b3pLaysyR0JXVWRMRS9HL1Z6MXdGN1NBZmtSOWM3TnVOdDczMmtMOWRzZFJz?=
 =?utf-8?B?bUNPQW8xSTFsTzFvLzRWZUtkSkFPeVJvQ3JUQjBKcUdsUDZMaXpGWGptblVK?=
 =?utf-8?B?RExJTXA0MzVTL3FSNlMvZGRrZnNpa1dZZW8zVHpZZFk2aUxXZE9KV1V0cnJl?=
 =?utf-8?B?bzBHTzEzMkV4Nkc1d3JmWXJMVlZldmN5aG1nVE1zQkRremRwbFhDYitUMVJ2?=
 =?utf-8?B?eldmemxoL3VNRmp4eVc0NEQvYmJ5aXoraHdMckVIUHlMK3lKTUwwOTFZdjlW?=
 =?utf-8?B?eGJ0akZtZXhZUUJNdEplRlZaRlhZRU9NMjU0NDJZbjA2dUQyZ2pqNkJLWGRv?=
 =?utf-8?B?VWNzS2l3OGJKM0pMVFdGaHFCV0lrSFhaVzR1b2pqSTZBaTFNcHI0M3ZqcFhH?=
 =?utf-8?B?dWhWbFNPc2Rld1hFenFrcWd1MU9KNlBxS2tKUWdrYVZsNUJTaEtrSk5HQkZO?=
 =?utf-8?B?QnRtaGk4QmdtVVI1OTVyaXpxcS9sSlBoL083YUJKZ2RHZGc2NTFMMXN3bit3?=
 =?utf-8?B?N0VHSzFjR3ZlWW94YzllUmVnamNEa2JmWUhrNUdaeEVyWFJETEhLNWtySVdk?=
 =?utf-8?B?KzBiMGNNZFpuaTQ5NWE5eWgxUDNYNWhmaGhoM1dlZmhFV2Z3bGM4LzR5QmQ2?=
 =?utf-8?B?ZjZvL1BuWTJlQkd4NGlVRVZ2Z2NJUGJoWmpMUDAxLzZBSmJzQ0dJTDQzbExG?=
 =?utf-8?B?TWpVQithd1NvWjV4bmdrbGxYMEF3VndUVXZzTDd0eDRuTkI3VFJObFF6Y1pW?=
 =?utf-8?B?TGhDT1dWSXpWODh4VTJlQTBYSzl6bzM4ZDk3dW5odWQxMDJRaU1XVEF0Qndn?=
 =?utf-8?B?SllpR2V2T2xKaDU3VFVaWDNHbldBbjVwTU14U253V0lsN0dqUWIxT1lETFlU?=
 =?utf-8?B?N3p3QlZwQzB0Z3Z5QitsWTJKSDM2OHBXQ0hadGpNUENlN1BOZWdTN3BScUR1?=
 =?utf-8?B?NXNQZUZsNVJidzYyR3c3cWZKSWFQOUc1Y05YS1FKMnZ3RytHTkdJeVA3bHRQ?=
 =?utf-8?B?K1I3elV1aXZYZzBhUnYxNWNyUkNmYkYrWVp3VzFzSlNNTEpQRFV2ZVZqdWx4?=
 =?utf-8?B?K2hLSUtOSkI4bVNyQUhRaWl5bURnWVRxNTFlSXVaVlE5VHYwellJUFdwOUl5?=
 =?utf-8?B?SnJXcFFVSzBKekRwdGFmNXg1UVcwcFVyWXJoSWdGR1VqMTVaTlRWc1lnN3pH?=
 =?utf-8?B?bmUzeWVlOEJSWlIzdWcvVVl2Y055RkZvQU1FMG50d1I3NWVFQ2YybTh2VnBF?=
 =?utf-8?B?WEFGMDhJTHZnMlRLcGwzeThTdlBWSFVTd1dCTmxNbHZiNFFXcURlRXFCbjBM?=
 =?utf-8?B?eXZVY0RrSTdCTEJITWdibm5VMVFlek5hNmRpZTgzcUZQYmQwcE1OMXh2a3hS?=
 =?utf-8?B?c056SjFJU2NQQ01PR245MUpyT01YcExaMG1TNzYyQ1AxT1dpN0RLY2xCZDdt?=
 =?utf-8?B?Vy91WUtTUWhQT05PN3J4WHpweUdTN3BvMDJKZWpJYk1ESlFUbDFSNlNrQSto?=
 =?utf-8?B?UGRseXYwZVh3eDl0TXZrWEpNUUZ3ajF5ejdCVkNVZm11UVRHZTZqRGszNDNM?=
 =?utf-8?B?ZDFXcFpkVk85cVRrM0phSU05bVlzaFZ0NFdXNTdzUnNQK0NHMmU3dFRyN2NM?=
 =?utf-8?B?R2YrQ2M4dkdod1pnQkJGWmtZN3IwNW5kdnVYQlZLK1JlS01IYUg3NUF5c1hz?=
 =?utf-8?B?NVRicnNpVHVoMzQ3MllRRkxkMThaVzlMU2pjSlp2QTNDd3dtb3o5YXl4UVNj?=
 =?utf-8?B?Z1hDZDlHN1RKT2NiMFNWRk1zMkFpMTVLcEZ6ZW9qMnJNemo1QWNRVWFxVE5y?=
 =?utf-8?B?MU1HY09GTVVNbmxUT3JyMHFUZkNab3YrenhicHlPQ1J4UmNRUFRLUnZRbk1E?=
 =?utf-8?B?RXk2S1N3WTdvWDlWTXloK28yYUU4R2tabmdtSitYVUE0RXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0tWNk9zaDlRNDBYalJMOXJtcEFzTXphcHhsNXRjMnVkNm9pY0I3aHpTdUtw?=
 =?utf-8?B?eXh2a1ExWUI0bmxFQklHb01oMTdmUEp3THBqY3BuaGZiM2JiZEcrNE9lRFhn?=
 =?utf-8?B?VzRlM3ErSWs4RUpvMG5yU29pWm1UK1N3ZzJLRFV4N2NJWkkrbERydHVoY3BL?=
 =?utf-8?B?THA3RlltelFzbFd5enU3OTdRM3RJM1luZ0hTaDRramZWYmdaWEVEL1B1Mjll?=
 =?utf-8?B?SitjeGtCcDIvdm5oVWV5b0toVlNYTjVjVktBeUtja3F2UUN6VFRjeHVPNDF3?=
 =?utf-8?B?SlFOWlNPSjNxSzV2c1JETGtzVG9PMGFzdEI4UElIZEdhd1ppNk15eHR5WGRK?=
 =?utf-8?B?cEJkQncwMEZlY1ltZkN2aVlSU1lSVjNzeUV4K2FUWlNvUml5WFpMa2piZExk?=
 =?utf-8?B?QmM0UTdtS3UwY0lMcGZMTFlxZ3gySnVocTV6Rnh2SzRTWHk0MlN0UlJsc1Jl?=
 =?utf-8?B?YlNlcjBwcVVkdlRJRmRTbXI1b0w3UjNuNGE2cGhsNzVVQ3dON1ZOdWg5VmZp?=
 =?utf-8?B?OTgwb1RxWFIxQWlGVHNxaGpKSW03WHZJQnFyQWVCU3lCU2R4TkpKTFZaSUd4?=
 =?utf-8?B?OXE5cGF1ZEhETmdmQTh1SzJ4RHlNUEthYVJCTWlHeVI4Y3QyanFtZlZweUFL?=
 =?utf-8?B?N3dTQU9VMXd0TEc3RGRLNzNlc205bmVrQXZiQWFxU0dqc3NKWE1jRmlKbmd5?=
 =?utf-8?B?SDQ2UU1lcmkyM0xxSHpUUmtlL3JOclV6bUtSTWRNamphdU0xckJBOVh1emJU?=
 =?utf-8?B?M0NDR3ZJV3JIelBwWldwZ3FUbnYyTUFiejZudjFqMTBQN2ZVWnZ4QlAxWnBj?=
 =?utf-8?B?cG1veHU3MEJ1OFI4UWxMRzN6QTNyek5LNUpwMlVCSTJEQjJVOURscU0wSG9F?=
 =?utf-8?B?MUxaOFZhbnJJQUdhbHJJTnFESk9ETFE3MGxDbnhpSmovbVd0Y0lwL2Y1azRS?=
 =?utf-8?B?amtiZnA1N2hoT1VyRzY3TldZbGp2RUpQOGVaQ1B2N01VMXVDMXJQcXl2ZWFn?=
 =?utf-8?B?NzVKd1haS3BJMnpwc052dkdPd2g3K2tFYzh4YzZSdG1SZkQramVObzM4Yit2?=
 =?utf-8?B?V0lQNE4xMlNYeC9yZitkMGVpYXF1UGJrUkxCbDQ4ZHhTVzdyMHEyOWRjb0dy?=
 =?utf-8?B?RnBTWmlBejZlOE00bWl1cXdKdVFzNVd5ekRibHIzS01lMWN5eUVmVWhWZndp?=
 =?utf-8?B?SiswcVM1L0FYTHdNK1Vzb216eG5LUGp4ampnVTRHRXVMRVVFTXpzTDg3c0gv?=
 =?utf-8?B?b2VpK1VQR1lJWWpXd21IMk1PWGNCTHpObTc4Q1J2b294UFJZZFR5MllZOXdI?=
 =?utf-8?B?TkdTRkgrdTB3OUMyUVJKTmRYd1JtT2tmU2RZWkVOZnZvbUhXRFNDVE9aOHow?=
 =?utf-8?B?cE1NZXZEcGN0WUhRZkRJK0N2eTVzSEduNWhjcTJMSGd2cStoVHV3TWhldmVO?=
 =?utf-8?B?OWJQYXJ3OG1UUDh4UUlnU0xiRGFEeGhJd1AwdUNLR2lxbGNhY21sWFRncldR?=
 =?utf-8?B?cEt4UDN5UGIvU0xxOURrd0U2dHBlcWNoTytuTWxHL2xhN1BqWWVEM0toNXlR?=
 =?utf-8?B?cTNQaStxZS9adWFNUEQyaEQ3c0lUcTRCR2h2VklNU3JJR0xZZGZ2ci9Ka1pn?=
 =?utf-8?B?c0MwVG1Cb2UvVGZNVm1rbElSSi8reENJSkRPUnV2VUVKSllBZGZLUFRLYXc2?=
 =?utf-8?B?elNEMTdxQ1JZTWRTR1g3NSt4NmtRV1h1ckR3c1FRQWhpeTl0ek1pdU11dEVX?=
 =?utf-8?B?ajBhbHNWUk41a3kxNGFGdmZaTUlyZXRxRENickxHQUFhZkc0YVlVdGI5bm5G?=
 =?utf-8?B?V1laS09GYjFMemZFZ1duN3QxQmpjQ0liZHVLQWVtcVVwTks5WnVrZHI4V2RM?=
 =?utf-8?B?RFNrWE9DTnZaaWN0RnpnTWpDeTNYa09uUlJwT0oreDlDNm5qdFJidjYveEhO?=
 =?utf-8?B?ZzJXNzRiWDZzMjM5Vy8rSU1qNVZ6aHBYT3NzTHpPeE93NjdZdlY4anQ3aFdG?=
 =?utf-8?B?c3E0NFQzSi94V1JLUUZuVDF6MkNvWm82eHBBK3lVUTMwTWJNV3hDcFRLMFJF?=
 =?utf-8?B?THorK2Rrc0Fjd3BsOGlOanZnV3JIeStiVk9zcEg3SlFWR29nbGN3ZlA3NS82?=
 =?utf-8?Q?LAZnlxqzw7QggzvhBv66+xhew?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a85d1e0f-2186-4456-64d7-08ddb4c0bc26
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 14:50:04.2227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wuVanIOleTXpoO5M8XHFnMi8wSTic/eyll/cEsfd67tiGD5iafElap2bVc3A3b3UKoJH8K2WpEsNJCsVawHXAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5719

Hi Alexey,

On 6/17/25 4:43 AM, Alexey Kardashevskiy wrote:
> The __snp_alloc_firmware_pages() helper allocates pages in the firmware
> state (alloc + rmpupdate). In case of failed rmpupdate, it tries
> reclaiming pages with already changed state. This requires calling
> the PSP firmware and since there is sev_cmd_mutex to guard such calls,
> the helper takes a "locked" parameter so specify if the lock needs to
> be held.
> 
> Most calls happen from snp_alloc_firmware_page() which executes without
> the lock. However
> 
> commit 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")
> 
> switched sev_fw_alloc() from alloc_pages() (which does not call the PSP) to
> __snp_alloc_firmware_pages() (which does) but did not account for the fact
> that sev_fw_alloc() is called from __sev_platform_init_locked()
> (via __sev_platform_init_handle_tmr()) and executes with the lock held.
> 
> Add a "locked" parameter to __snp_alloc_firmware_pages().
> Make sev_fw_alloc() use the new parameter to prevent potential deadlock in
> rmp_mark_pages_firmware() if rmpupdate() failed.
> 
> Fixes: 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>

Thank you for fixing this.
I was facing a locking issue and was writing a similar patch when I
discovered this!

Reviewed-by: Pratik R. Sampat <prsampat@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 3451bada884e..16a11d5efe46 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -434,7 +434,7 @@ static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, boo
>  	return rc;
>  }
>  
> -static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
>  {
>  	unsigned long npages = 1ul << order, paddr;
>  	struct sev_device *sev;
> @@ -453,7 +453,7 @@ static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
>  		return page;
>  
>  	paddr = __pa((unsigned long)page_address(page));
> -	if (rmp_mark_pages_firmware(paddr, npages, false))
> +	if (rmp_mark_pages_firmware(paddr, npages, locked))
>  		return NULL;
>  
>  	return page;
> @@ -463,7 +463,7 @@ void *snp_alloc_firmware_page(gfp_t gfp_mask)
>  {
>  	struct page *page;
>  
> -	page = __snp_alloc_firmware_pages(gfp_mask, 0);
> +	page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
>  
>  	return page ? page_address(page) : NULL;
>  }
> @@ -498,7 +498,7 @@ static void *sev_fw_alloc(unsigned long len)
>  {
>  	struct page *page;
>  
> -	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len));
> +	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), true);
>  	if (!page)
>  		return NULL;
>  

