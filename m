Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DDE19DFAB;
	Wed, 16 Jul 2025 18:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752690321; cv=fail; b=NC30HDnGSheAJa+Nl24BnnkaNRJ4L+PuZDtNAqNEJf2GP9MzBU1hgtkIV7ndsTffU0t3yJABMokzCg9ZHigB6e4xqVKecmgVuwf+B7PMOaKtpUDdXXlLhPSFGbHuo/NFqeo3a2dfdxalyMUsVGMCp3S2nRM3A0+UAPM18YSCe8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752690321; c=relaxed/simple;
	bh=ABvinpvMZ978dVRoj5jovPJpMw/GeoLHmQFb7HkG9GA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l6OBZvsM9k7+JIxr7ND+vmnK8Z3Xi+X64HMou1jFkM0KQK4T28m8GoItLj4bhQtGaJV1IVZ0Gi4j2nyBelaW0LICv+t/R4UjB2822DfOqsRq+JbT5fwRCeGzOE/YNVqfkpNKSl2im30K/sTsCcgin252OMD3US59Cy0qUNNYc3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eNu3s6vM; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eNu3s6vM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYVh2FJbzGVKaDcZXI4EfIeNwiDjUOjz2goDJ4SlhgV8M+4oLpcr7HoGYHMPJa1/gWsDsZRdHEeub0u8d+KkJrMyMCX7VVaupaDhutUjZoIsMwV54MnX/cSIKU2xL0JLe+luwObPFxgiLpuMRX2MmyZq2S9sNsSKfHmZzxzlTfoEoI5S7fOODRdUkaEH2t7AubDSUMKiNLzqiKseDBeMvUGV9EEw+r18+or/SZfw/4e3JzGMhdfATYY7Zfq7BsWHiLPcGTnnr7P/UEKMy2C6EuCNr8OP0LCGuNVgcvOPBMgEapJtVt76JVKew1wkiG15Th1M+mLRIpGE5Ydo4jez2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+1CSj4qeBwg2NBBO2AVILN0whzEhn509+WbBYP4RN0=;
 b=B5FaJ4EWxXjFujld+YcdW5gN+qRzvPmI6snbvjigQz7+qF4dgPQjPifSl8IRKiayN7lYzgWEeayfvBR4/zM0N8xKYq++YdUQPxUcWjfW+n8ZqIO8na1tEBfbFfjg6/lILs14Km1GkBB/SD8MgEgZSUujouNwvaH+zjcr0e1sNTg+mOgIf0b2bbnjgnjXnRIvh2H0aqlsS7UT2NsPgZu9EOB4jF7WWFz4oVyKYuFe3GJ9WL1kL865kLMV6wDTUBMuG3H07At9uHZjT9WMQ3kFd8YwT/uSPv5tKhI0Wj+KhPZ4R/uOmRXXAkpvwoqEK2TSyCNUfw5VucuytmkPvUqT/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+1CSj4qeBwg2NBBO2AVILN0whzEhn509+WbBYP4RN0=;
 b=eNu3s6vMLvQ88jhtenB4gAd+UaWE8wNWFozBsCxJirPCs+sLbCpk2rW8iqvBYUeSxD/rKbkOT9ewYpI0IPdRbZRoLwPs43DTPPmc8rbYqyjj5WTbStUwJprqRdwLM4V9iXQpSCn+hCJNS22QnrwSpNUNlExkqddnQOgqT8QrBvs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by MW4PR12MB8610.namprd12.prod.outlook.com (2603:10b6:303:1ef::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Wed, 16 Jul
 2025 18:25:15 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%4]) with mapi id 15.20.8922.028; Wed, 16 Jul 2025
 18:25:15 +0000
Message-ID: <c502a550-3856-4c21-8546-b4b1abbd0abf@amd.com>
Date: Wed, 16 Jul 2025 13:25:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] crypto: ccp - Add the SNP_VERIFY_MITIGATION command
To: Sean Christopherson <seanjc@google.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, bp@alien8.de, michael.roth@amd.com,
 aik@amd.com, pbonzini@redhat.com
References: <20250630202319.56331-1-prsampat@amd.com>
 <20250630202319.56331-2-prsampat@amd.com> <aG0jxWk1eor1A_Gd@google.com>
 <a5dbf066-a999-42d4-8d0f-6dae66ef0b98@amd.com> <aHBCosztx8QWC4G0@google.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <aHBCosztx8QWC4G0@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0100.namprd13.prod.outlook.com
 (2603:10b6:806:24::15) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|MW4PR12MB8610:EE_
X-MS-Office365-Filtering-Correlation-Id: 835a500b-3ce0-4b1b-19cc-08ddc4961c21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWtHR3c3VHpxOEIzQmtaZkdXVTBqRkRnUjJJYXQwWUdsaWcwUFFEYkcrMm4y?=
 =?utf-8?B?MExKR3ovNWQ2MEJlTFZTcXlEUW9DL09hUDV3OGI4NWI1emxQQWFGbG5hM01V?=
 =?utf-8?B?RldUUGNtSXBZMEdUZE9mZmt5WkJDbWpGd1Yza1hLV3NkRXhUOHN6a2ZYZmZI?=
 =?utf-8?B?dVozT1FHM0U0S1VNL1hvNWZHQytjZDVmeWtLWHp2YzNpSGVJYWpEcHpidm8y?=
 =?utf-8?B?ZDFXaVViZkZmNXRyNmRadFJpaWlXcnkyYjdtNVYxS2I5OWUxUzJ0YkVTaGMx?=
 =?utf-8?B?YmJwZThwQWw4V1g1MHR4Z0NUc3BjWCtqTExNNEpzUnE5OWZQYk5CS0o3TUlH?=
 =?utf-8?B?YUdCUFovU1l3U0tEaDFjUlF1UkpuYzdqYzM1QWh0OFBWUnI3a2NRb0J0L2FE?=
 =?utf-8?B?VlJLRjRaUFBTNUF3WnUvbElheXNrSVhLTm1nT3hxRmdqay9YTU5nYTUyTHYx?=
 =?utf-8?B?Yjhhd1U3cmtqeDdzeTBCSUhKbzlVaGJCR0YrdUhiaVp6TzlIS3MxWHRMT25Y?=
 =?utf-8?B?SEhDV1R1RXhqL0N6OGt5VEp1TnlnU05IZm9kWWpSbXlpcW81VDNLU0tkbFM5?=
 =?utf-8?B?Y3BiRytDQUZ3djIrczI5QVU2dmZGVUZhVzdwbEpMdWVHQXovVmNlRnJJaE5P?=
 =?utf-8?B?NXAxVnFpMHF2WVZmZDMzWjNZb2c5N2JhejBDWVFjeXpESGp1dmJSRG5tMFhX?=
 =?utf-8?B?dFVPYk1tc0p6ZUJnazMvVFhidTdNcUQ5eTB0LzRyVXJ5enFQVW9vcE5uQ2g1?=
 =?utf-8?B?Ynl1a3dEU1pkL2dxVGRMcDZSRXNQTWZMY0ZuVVZRaGY0R2pUYmd0dDg1RDVu?=
 =?utf-8?B?bGhpa1RnQWplelZ3V0lMNkNHRXErT0dEeFpVR1ZzMkZVazQxVXZpdEhnZG5m?=
 =?utf-8?B?cXV1dlRSQ01vaGtiaHRnR3owYnIvYVZZWUJTREtlU2t3NFZ5eHVxRTV6ZUhm?=
 =?utf-8?B?cXZ5Y1I4Z2dDOWZNZ2NCMys3YWhjaHVSTEY2a2ZSU0pUNE5OOW5RZHYvejhm?=
 =?utf-8?B?czVEUTBVanRDMllMMVBmMjhCeTdiTThUb05pNXJ6OXpycmJWYlYvT1hrb20w?=
 =?utf-8?B?aWw2L3Z3VlpGb1BqMkM0VDAveHZjWitxRGZmSTN6ZStpQmZkNW5ITFp3aWZM?=
 =?utf-8?B?UXFmUldhNHJZYzFHS0NNZEVXSmwrMlIzVFFFU1JGd1lybVFOQVVQQ2pVMUN5?=
 =?utf-8?B?aGRUd2FBM0tacTFsUUI0Vy9VQ05zT0p0d2E4aGh6YTJNL0NzTHBvNW9GV3Zr?=
 =?utf-8?B?TDQzTGkrbjVmNHZnaVdLdCthN1NrQ3BaT1E0TE5sN0thOE5GTWJqeEJ2dmI0?=
 =?utf-8?B?Vk5qNFF0QlpkTmNFS2xGemJMMGhHU0RpYjlHWXNSQUI4MGFlT1RKTjh4STVj?=
 =?utf-8?B?K0VDWnZKcEE1Q3c0ZEZOOXJMUjA0N0lSbURDUjFKQUJDcGpDQUYyMnlFL2FM?=
 =?utf-8?B?ZFlUUmhaOW1IVzRpb2NjN2VhdmJIbnB0Tm85Y09rRnl1YitGU2VEdW9qTGJ2?=
 =?utf-8?B?dnNMVWExQnVPbWdpWEJ3Z1JRaWh4NE5oNktmWGFLc3g4TXhQRWIyVGRXemJR?=
 =?utf-8?B?RklVeDg2c2pLTDA5NC80Y2o5WkJFRllFT1ZsVHl5WC9mOWJVcWY2TkltWGlx?=
 =?utf-8?B?RVdxUjZraC9RbFlwMDVkQTZSaFZZYmVxVUtTZkRrVEhGU3IrM0I0ZjhwZlZO?=
 =?utf-8?B?b0xnNENxaGtkQ2tTRVloTGZjM0d3WDY3TkoyRFR3M08xMndSSWUwVEN4RUZM?=
 =?utf-8?B?NUpPWk9ORVg0aTcwQkRreEI5WFlnVTdFVnJRYWRPWEo2SG0zNmdxdXdYN0dL?=
 =?utf-8?B?UHFwSE56cUxaY2o0czQ5SUNNSkthRDFDcDhOdUtpOENJWmVoS0N5RFQxdEsr?=
 =?utf-8?B?eWJUQUFjR1RTTHk2MENlaVd2TzBnaEV6Zlp0bk8xVXZFaTJwZDZSdnhvZW55?=
 =?utf-8?Q?X1wEio4x0HA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjYxVm1DYzFJQjZ6bmt4Rm1EZWs5MFNqWVlrZ3RYZ0hxVlhQWWduWmYvSkpz?=
 =?utf-8?B?bFE2NkFXaFFjVDV6aWtYZWl0TUdIT0dlMDJReW45UXZrQkpiSktZdkR0U01p?=
 =?utf-8?B?b2RwR3ZPUUM1SHZvRUZCU2MxenowTWQ1eE1JVm9Ea1Jhc0dqN1RnMHUxM0tB?=
 =?utf-8?B?c0V6ZkNsdDVOR085UXFkV0xlOUQralI1OXBFV3FOVGRBcmRNRlBrd1drbXA4?=
 =?utf-8?B?ZUxkOVpkWmp1cGF3VzNQVUd3cW1oaDkwZFBWOEtyRnF0b3dkN1A5UlRxZGh1?=
 =?utf-8?B?NjNDd3JVU1p5RGw3cG5hTFA5S2dnVnEva2F4U2FJdmRXMUYzZ0FXQnc4L3VC?=
 =?utf-8?B?KzFYSm84WkxXcTNuR1hhZXluRFlINUhXeEZnZTFHYk4xdG9BYld1WFVKZEI2?=
 =?utf-8?B?L1VvKzFEVFYvVTNaLzJVYVJIUUVSTENiemdVYVl3dXZnSUU5NHhzWHhoYXBT?=
 =?utf-8?B?QmtKeUp6WDR6NklzbFZJVWZ6T2pRd00xbGdDWkpQU0VGbHh5eGRQemtadnIy?=
 =?utf-8?B?OHZBRmdGM3FvQmtHU3d2SmpBMUszN1VsNlF0Z3BSSnk4bjRRVklkSy9qanFo?=
 =?utf-8?B?QVVoNTFtNXlHQ1NGZzJOdzFqd3JrMHZFV2tYM1RNOHZPaEZuaWxPMm55OTQ0?=
 =?utf-8?B?dXJ0TkxJQ3o3TjZGemR0S0hnMVlDTUhwUnp4NjBKNnhFZWY4SW9yVU9wS1JY?=
 =?utf-8?B?eS8vSUFhcmViYzdXTHlKcnZpYVdXOFVQQlp3QU0veXJ1WWQwbzU4QjZ5UGpp?=
 =?utf-8?B?QzdldzlnWnlLT0lGaFR3ZUNreE9XVlhTMysyZ1J6UEdaY21XZkhVWFB6QlpN?=
 =?utf-8?B?WUxOSU5PcFQ4MjNyRVFSK01aQkMxSVRuYmpFMy9aRk1kMEQ0ejFTY3ptWVA0?=
 =?utf-8?B?UXFwd21HRWIxTHJueWlLTGRsYnE2TVl3YjNrU2pkMDJzdUlZUFE0MFBlYUpi?=
 =?utf-8?B?NEplOGZtVGZsVEF5Q1JIcVA1M0dWTE1wZnplRTFZYmw5ZW5DUVgwd2p5RDlN?=
 =?utf-8?B?cWJpb2dQbWtINlVwU3VKelQ5NEpmNU5yY0FZSTd2L1pvTU9OR3g2OTRiNVRS?=
 =?utf-8?B?MGhoRTBqRzUzWDEvdmFObllpODV4cGE4b1FkT21jS3l1QllEaDhwZEU2anlU?=
 =?utf-8?B?MythaTRCNG5CcmhBS09NK2xxWDRyNlNleDl6R25CS09iQXFyMzFGei9JeHQ3?=
 =?utf-8?B?TXlqNU1kdS9td0NBSU1XUWNRTnIrOFhNUk5UUjZYdkI1am8zbjdzNUZxWEo2?=
 =?utf-8?B?OEkzMGE0NEx3MlNtMEQ3MENHTHFVc1JhOEo4S3pBUVR2anhPWjB6S0U5bkZT?=
 =?utf-8?B?eGF2a21IdDRWaWQzYWNwT1RmWVV4dVNXRmFocTNXTW9lOWJQTGdBZ3VyZkE2?=
 =?utf-8?B?S3p5NElFclFMeENrR24yNm5IdzJCVytCMk4yTkJGZlkwaWVMaGxFMVBPaVNj?=
 =?utf-8?B?d0dzeEh6aVRxb2F2Z1RUNm9CM2hKRE40N0w2WVE5Zm5HMzZNd1BwL3lMWFZ0?=
 =?utf-8?B?R3A5MmFxbWJYS2c0WVcvU0hjQUM3OWEvamsxV21uaDNhUTJGMjBsWWFlbkFr?=
 =?utf-8?B?WGY1dUtRRU1aTzVYRXRsS0VIS2oyUFNzTU5ZRXFJRlkvbUc1bEN3dFNBVkxa?=
 =?utf-8?B?Q0RYcGdwQTZMM0pUbjRneTdudlhXRWF1QzZNb0MrZTVEK2RwM2d6amQ4ZGpv?=
 =?utf-8?B?QndLTHBobjVWcUFrUzc5SVRiMWdZaXRMZmlYV0hCcGJHTktXQjZTM2gvOUI1?=
 =?utf-8?B?Uy8xZ21sZklUdkVaQ2EySElQU25ieXlmeE1iSHN2cExQRDNJSE95S1hzbjU3?=
 =?utf-8?B?b2NhNFZGQkJsWHVEV08wRkZwMlBFaXlxTkFLcDZzMjRWNWF5NmwyOEFMVDNt?=
 =?utf-8?B?anlNT0J0R0E0dDQwVlNGaC9telY0dGhpR1FYSHVhTEhjNkIwT2o0WlNBLzdv?=
 =?utf-8?B?NnlhNmMxTWRydytUM0FOa2RJaHQyMENWTmN1YnlGWVU0bEdoc1NlYWZJS1hJ?=
 =?utf-8?B?NDQxWGp1QWk1Wi95RklTYlF4cjRVcExkNlVmTmNzeHkzRUd4V3VSUnpiYnQ5?=
 =?utf-8?B?UjNEMnFkNlQxT2pNK0x4ZDJoQXkyanNqTVdJNm9JdVg1OTFUZ21BUjRHQXN5?=
 =?utf-8?Q?zt39B9FQ/7Ilsk0Ixs/BfD6yi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 835a500b-3ce0-4b1b-19cc-08ddc4961c21
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 18:25:15.5662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cd1ZC3Y9lefmHf9U8Uz+Lx8aDDQVhZFJ5GezgtRZ65t8NnLwjfbNVugkOS6enYhCqIiiZIM5t7mSWeXf4aLl8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB8610



On 7/10/25 5:45 PM, Sean Christopherson wrote:
> On Wed, Jul 09, 2025, Pratik R. Sampat wrote:
>> Hi Sean,
>>
>> On 7/8/25 8:57 AM, Sean Christopherson wrote:
>>> On Mon, Jun 30, 2025, Pratik R. Sampat wrote:
>>>> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
>>>> can be used to query the status of currently supported vulnerability
>>>> mitigations and to initiate mitigations within the firmware.
>>>>
>>>> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
>>>> more details.
>>>
>>> Nothing here explains why this needs to be exposed directly to userspace.
>>
>> The general idea is that not all mitigations may/can be applied
>> immediately, for ex: some mitigations may require all the guest to be
>> shutdown before they can be applied. So a host userspace interface to
>> query+apply mitigations can be useful for that coordination before
>> attempting to apply the mitigation.
> 
> But why expose ioctls to effectively give userspace direct access to firmware?
> E.g. why not configure firmware mitigations via the kernel's upcoming
> Attack Vector Controls.
> 
> https://lore.kernel.org/all/20250707183316.1349127-1-david.kaplan@amd.com

Something like Attack Vector Controls may not work in our case, since
those are designed to protect the kernel from userspace and guests,
whereas SEV firmware mitigations are focused on protecting guests from
the hypervisor. Additionally, Attack Vector Controls are managed via
boot command-line parameters, but maybe we could potentially change
that by introducing RW interfaces for our case within
/sys/devices/system/cpu/vector_vulnerabilities (or what the final form
of this interface ends up being).

Another option could be to expose this functionality in a subdirectory
under /sys/firmware/?

However, with any of these approaches, we would still be giving
userspace the ability to access and alter the firmware, similar to
the interfaces that expose features such as Download Firmware EX
also allow, right?

Thanks!
Pratik

