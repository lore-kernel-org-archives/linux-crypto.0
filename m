Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012025.outbound.protection.outlook.com [40.107.209.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A73925742F;
	Mon, 20 Jul 2026 20:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784579986; cv=fail; b=R01aTxjB7Mmwl2ML+dUMK2P4lVuXBBqQH0ZsNHllyvz9xs6JnH7kZJG4SLk1pG2uVQnad3dJRPzxNDvXH6v6fXN8/OyNSoeXRrkTdKTeNeInUgqIHLA5LkMN9PBfZlV8WaJKXAPOF0MVkMdaG1KaPna44dk79A6n/o2LSX/RIJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784579986; c=relaxed/simple;
	bh=CUO868IGLiBki/fDWgWpouZNlpMmWJqm1S0J+a9bsdY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OVTJIdOp5unvp8GicscGSXFz8mjTDgVvwxlm2/Ojiw5vPrV/iWVVbTIcRNK9W57oCEDkD/Ro/DSbfT2faCShzySX4QvN+DsD2aIRnSxdpMv+lVtU3JQiC8s+qrfJ/B/c7IeDZXb5qohi7xMJW7Wxy/Uvtur2zn+9GptLXIJwQ3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y7zfduHY; arc=fail smtp.client-ip=40.107.209.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y7zfduHY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i3PbBIPocVJfkIr8uKVKckIoewacei03YVZYZsR2WKdgmQFIzxzLOeCEmFjdEoFergYzHD1jAGBVw3G08rhdg4pI7P9agRBvfW61pJN0mPQrBpxv05P3Y4SZ9f3m3eCPIpF8WZ6LWqhdw5jhjVPUV+FQuN3bFyponYymFZBZw8U+47HBNS3qpFWGhOiyTw3cEfvpS/Yyfv+S9L3YEVh2XDj2TPYN1cJGSE/GDTB2RDMn0NqilNsQJtCTysz9ng63uyjOPqyziyKNCW+pMJfghXFT7nZpi7YvRddwtBUwbUaH0vehFRwKy2aGfC+vnxPVceWcofX9yF4AThrN22vX3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OgM1mTyj2hpcauqTu5Y/YJOIWq4vhVulxAzAkeU8LM=;
 b=og+rSzaNGwCLZDTJd3ImXqg4+EwHTiR4hKDjjksZKQXpvsxVnHHz3v9Z+oUDEcZ729o9NEHiDOHD/Pem5iUnIV2Sh2Fw6L0PngZbzIIlZDwoNgT/iwAzNb/Dw2ttMVhq3EIiTzfPItjFVMFNNS1i7UogAV8hzBCwrBQbuCxuAVgtyyGI3wf2rErk4zeC5C+LGafFz4ui/GcI6RdD51a+aWPhpS3O8zh6PTtZIliyurs80Ip60Wh53ibdTj6TPdDROQPrUwHzUMoUhxVCEfsqyELin+XjCuhDyo77E2S9VS382EMyFomJrCZACjzHUD2ot1KSJlU4u7V5UXC+BaumFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OgM1mTyj2hpcauqTu5Y/YJOIWq4vhVulxAzAkeU8LM=;
 b=y7zfduHYrW4V4JsbxG8/SSpRSdE7MdkW7IHwN3K25e7fBGRsNY2fN/WIx1PSZfxktFcIUFYIRtC3OphzEvMcr/xi7cIWrzWuu5r9WGlp9S3P2lgka9H38oGLxu9b4XlQ+KjW0FSN9WWHVCgLj0KuDJj50IZ1zx58HmWPPN3WK9E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB7140.namprd12.prod.outlook.com (2603:10b6:510:200::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 20:39:40 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 20:39:40 +0000
Message-ID: <e8d015c0-1aa4-4406-b668-23aa5813030a@amd.com>
Date: Mon, 20 Jul 2026 15:39:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/6] Add RMPOPT support.
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
 <aad54bd5-8a5e-418d-8cb2-2cec6527993b@amd.com>
 <20260720202845.GAal6E_dQjTa_vEO3y@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260720202845.GAal6E_dQjTa_vEO3y@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR04CA0118.namprd04.prod.outlook.com
 (2603:10b6:610:75::33) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB7140:EE_
X-MS-Office365-Filtering-Correlation-Id: 01bb96a9-6b87-467c-d446-08dee69f0547
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|18002099003|22082099003|4143699003|10067099003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	ta+DkwWQwDLj2hlnbSs29MvJXNz2URS/zdNTmzCNQj2Abs7PN513owtVzz4ILG6jpXQh6wRWGcgWJ2m0+CPI3tj9UuAr6rSdxYCUP3PVaqSC+/BMd01+PhtaoXArOqq3jkNm3Y4YFURlHtrgluR6SSnLAUccLyBNlRJ1HxAg4Xy2LN1IYMMmhkMkcYG9tkHH89bgayRGiUXEVE/5JFPBzGRSg677t1Lk1UTGG9VY3uzDIEp5JmdkNmRyJ7o6LmDaSunz8SIln760KOJOMf04VczA/539PfzDlwlMR21CXiW5aoaFpWzJKMOByeRw3G0ZkooWHT8JwU65zOT9eg6otKv0yClnWgdFQxQ1lVnsDuSYv0LZuaTruBy9/ppgP0KvDHgUlW/6inK3xn2YPyEkrWtGD3Z6fYtsbtZyZVl0pCLR6HLdpSktQOICp3f9MQLNzWC0XFoxvpoX0QMrVykJyzWf3P68tLTHplEGR/3L8l4J/6OIUD4BiwU3sjrg894CcgIKqxaDw66rpWlg5HueNF/bIQXA8AsQbwCQKHwn9iY7QrL3IqKCittdrkQsBsGnMMJZisfaHmGeeX2rxNEjcSHzjYRCb0avaaNylPmc5Yk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(18002099003)(22082099003)(4143699003)(10067099003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFJOS0RNS2NuTlFtNkFCbU5CV2hvREh1QnB5bVBxYUpsSExCL2xKUFFIenZm?=
 =?utf-8?B?NGdaZzNvNDViYjQvQzhKbUdlaUVuQy9IRG8wN3N5MTdiRFZaaXJnelFlcEpH?=
 =?utf-8?B?V3kyckxnZFF3OFlPRXpxVldtYmk3TllMN2cyNVVNVzdjdklxZ01RbGQveVkw?=
 =?utf-8?B?cE1yQTRXeGpDZmJ3d2l4N3RpbHoxVVNUR3F2MmJ4bE03c0xTVU1Hc21Felhm?=
 =?utf-8?B?WUV2UzBNNjdHdEJmL1IxZlhIQWVITW96VzVIUmVqbWh2cittenBRR2ZVY0hu?=
 =?utf-8?B?dmRjNFZEZjZSM2ppMWNndGt4MzY5M25VbWhjSWIvV0l3TGxwQ2wzaTJIbCs1?=
 =?utf-8?B?NE1RTVNFemlRcHQ4MmN2bERSWndoNEpJWU1kK1JSNDdUb3dJVHFMWFRHQUlw?=
 =?utf-8?B?YzZiZU1lcktwTDNKelA2WnFsNmo5SjFYWnJUdkdXUVlqa3RHL1NRS1I1bDR3?=
 =?utf-8?B?cU1UTGtXSmtBS1gvcS91ZFp5UnhGdDE2d1Fzb0xlcVEydm9KdStzeFVMeERR?=
 =?utf-8?B?VGZOQmVpTkRQRWhuZ2tla3J3YUF3ZGFQM2RMRVNrRU11aUQ4eTBHb2dyS282?=
 =?utf-8?B?cUNHM1JvSnZDdFJFQmpTWXBpTnhOM051Y2NWc1ExcnRSczlsb1Z4L2JKTlVQ?=
 =?utf-8?B?d3NtSEtQTU5laTVyQWlkbnpXRjYyaVlyb0FBM1luSnBtS2RxY0VBbmd2eTBJ?=
 =?utf-8?B?S2N4QnZORElkMkozZTFzUzc5V0RqL2lacGlYNUc1eGY3d0ZNcmZXVGM4R3J0?=
 =?utf-8?B?T2x2S0lKZHpyYUJLVWZsT1VMZEZoMG5MbW0rT0Z5QlBPR1ZtYUpQZTRvaWQ0?=
 =?utf-8?B?ZFZiTVJjZFJLMjZYTXlBVlBQSDhrVkFnUVVkM2lCZ0xHOVV4QThiOEU0WDZ5?=
 =?utf-8?B?bGk2ZTJheGpSand4allPM044NDBSbS9xRWE0ZTJKTjlXendMUWhqalVMNUMr?=
 =?utf-8?B?NU84RmlVbHdjdk45aUkzMk9sUFR2MTBsc1hXQWNxZi9WTWNUa05vdWJwSU1I?=
 =?utf-8?B?V3QxVTlBRUw3Nk5tSTJzTkhrZFNjNlh4OEVsRDJRd2FCY0VvQm4vZ1ZzQ0Z5?=
 =?utf-8?B?Z2pIdGtsOVh6ekE0bHRkdlE4NVFSdW02T2UxazdjR043Q3pEaEZDUEhocEZM?=
 =?utf-8?B?UHpBVlBZQ2tpSk9zTmdhZmZlTkpEeEFuWHpvblA0REhVdGRmUGRFZ0pRSGt5?=
 =?utf-8?B?V1NTSlJvYk9sSGxMandxTHZyeDJtdFVteWg5M09FUTBmTU9CbXdlSC85ZWVw?=
 =?utf-8?B?UUdERnZOc0tQKzlhWHZBRDlFRW5GZjdZRElZaGtXN2oyV0ZlTG5ZV294NVE0?=
 =?utf-8?B?UHUvUkcwQzFudjAxNFd0SGdKcnd3a3BkTzF1UXFWRFc4UnZzVW1vTE9RMmpq?=
 =?utf-8?B?dXN2S25odElKbW9ZNUpjM0p3dU1SNVFUdDdSdWhKRkw2RGhjT1A2UnZHRmtH?=
 =?utf-8?B?V2dEc3g5V1dCVE42d1VOT0dOVnY2Yzk2enV6Ny90VlowVjdtUGw4NDNOdHAy?=
 =?utf-8?B?UHZKenpXRFBzejlLalZLWXMxR2xRNk9Dclkxc3pmZWlyY21oTms2T1VYYkhk?=
 =?utf-8?B?ZEZQVDk4eVNLZlFtWDRYZWxJUDhKQmxlMTVuSHdwVTFJOEtieFZZQ09EWkJq?=
 =?utf-8?B?MWpuSXJRblpjL1FOMlIwSFFuOWlLYUIxZS95YVE1Mzd4cVhzVGpxUnJiMFVY?=
 =?utf-8?B?amc5ZUJwUURiT1BiSEVtRmxraXRXYzhnK3dxNnYreWh6c2hvQmRZaVYyRTlX?=
 =?utf-8?B?QnZXVC9SUTc3b2I0ajZXTmt2UWd5M3ZqbkYzYTJhRFhjT3VDeFcrWkY2eENk?=
 =?utf-8?B?WXBBME1RS0l0S1pJNXFtWnY4NCtpd2RzVVBxTFJZRTUwNHd5a2NFakVvWUFi?=
 =?utf-8?B?Nm1sM3ZORXhMLzdVbmVFQ2x2OUx2WkpMLzlrVDZMdnVqekRiTGkwekJBOWZH?=
 =?utf-8?B?akZuTFM0WVhTSTF0K2FSbFFkMU00OGg1bk90WUxsNlV6emdodmFIQkFHV2d4?=
 =?utf-8?B?N0MvOWJ2WnZjN3ZrblFBa1J3UWIyOWVDcjN4aFloRjRKdisxeTA3cEZLYUdR?=
 =?utf-8?B?cFY4N3QxeFJtdHY1clBmWXJUelNFYTI0eDhqallVa3d2QndTaEt5UkpHZkFk?=
 =?utf-8?B?SS9UWUtKc1M2VWg2VkxaRFlWV0VyUE4vTVVFSHp1Z1c0VnJCSHdNZlFKbWRX?=
 =?utf-8?B?UDZpYzFFVGZnWDllVUtLbTN4TGhZTjB6RlZ1anZLRDRIVUlXOVQzVUJhdExP?=
 =?utf-8?B?NW5hVk5mUkUxNGV2UStGSVYxZm1jbFZXVUFJNGo1cVphazFqMFUyemxDSVNh?=
 =?utf-8?Q?FBjs4EDjBCR06V5VK7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01bb96a9-6b87-467c-d446-08dee69f0547
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 20:39:39.8140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0x+MTSSCu0IrN81Xq2bT+D4n5qb6qcD+HICkjW1dxC7O1xkAKW5VcxfB9rzNUB0Vz4M0BaHOvkTR3P1LFdsRVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7140

Hello Boris,

On 7/20/2026 3:28 PM, Borislav Petkov wrote:
> On Mon, Jul 20, 2026 at 03:17:23PM -0500, Kalra, Ashish wrote:
>> Just a gentle ping on this series. I believe v10 addresses the feedback from the earlier rounds. 
>> Please let me know if it looks good to merge, or if there's anything else you'd like me to change.
> 
> What about those Sashiko comments to it:
> 
> https://sashiko.dev/#/patchset/cover.1782841284.git.ashish.kalra%40amd.com
> 
> ?
> 

The three Sashiko comments on v10 all resolved to no code change, with rationale posted inline:

  1. Suspend/resume vs. hotplug disable (patch 3): pre-existing base-SNP behavior — an SNP host doesn't support suspend/resume anyway (SnpEn is set once before
     SNP_INIT and can't be rebuilt on resume), so it can't arise.
  2. snp_setup_rmpopt() re-init pass (patch 4): performance-only and self-correcting, doesn't occur on RMPOPT-capable platforms (the x86_snp_shutdown path frees
     the workqueue, so re-init re-runs the pass) — the guarded case is legacy-firmware-only.
  3. mod_delayed_work() and VM churn (patch 6): deliberate — queue_delayed_work() would regress the common case (scanning a guest before its page conversion 
     completes), the deferral is best-effort and self-limiting.

Thanks,
Ashish
